#include <cstdint>
#include <verilated.h>
#include "verilated_vpi.h"
#include <iostream>
#include "Voirv.h"
#include "vpi_user.h"

#include "Voirv_oirv.h"
#include "Voirv_stall.h"
#include "Voirv_instr_fetch_buffer.h"
#include "Voirv_clint.h"
#include "Voirv_plic.h"
#include "Voirv_reg_file.h"
#include <fstream>

#include <queue>
#include <thread>
#include <mutex>
#include <termios.h>
#include <stdio.h>
#include <unistd.h>
#include "axi4_mem.hpp"
#include <chrono>
#include <pthread.h>
#include <signal.h>

#ifdef DUMP_WAVE
	#include "verilated_vcd_c.h"
#endif

#ifdef RV64
	typedef uint64_t reg_t;
	typedef uint64_t addr_t;
#else
	typedef uint32_t reg_t;
	typedef uint32_t addr_t;
#endif

using namespace std;
using namespace chrono;

#define RESET_ENABLE 0
#define RESET_DISABLE 1
#define RESET_TICKS 10

#define MEM_SIZE 4096
#define RESET_VECTOR 0x80000000


#define INVALID_INST 0x00000000
#define CINVALID_INST 0x0000
#define EXT_MEM_SIZE 16 * 1024 * 1024
#define WDATA_EN 1
#define WDATA_READY 1
#define RDATA_VALID 1
#define INSTR_VALID 1
#define COMMIT_INSTR 1
#define PLIC_READY 1

#define UART_PORT 0x10000000
#define MTIME_ADDR 0x200bff8
#define MTIMECMP_ADDR 0x2004000

#define CFG_CELL_OUTPUT_REG_ADDR 0x200
#define UART_PRIORITY_ADDR 0x0c000004
#define PLIC_ENABLE_ADDR 0x0c002000
#define PLIC_THRESHOLD_ADDR 0x0c200000


#define UART_CLAIM_COMPLETE 0x0c200004
#define PLIC_PENDING_ADDR 0x0c001000

#define CACHE

char hex_char_set[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
static size_t ext_mem_base;
static size_t tot_mem_size;
std::queue<char> input_char_queue;
std::mutex mtx;
char uart_char;
Voirv *top;
uint64_t main_time = 0;

typedef struct {
	uint8_t* clk;
	uint8_t* rstn;
	uint64_t* instr_addr;
#ifdef RV64
	uint64_t* instr_addr_wb;
#else
	uint32_t* instr_addr_wb;
#endif
	uint8_t* instr_valid;
	uint32_t* instr;
	uint32_t* instr_wb;
	uint8_t* irq1;
	uint8_t* plic_ready;
	uint64_t* rdata;
	uint8_t* rdata_valid;
	uint8_t* wdata_en;
	uint8_t* rdata_en;
	uint8_t* wdata_ready;
	uint8_t* wlen;
	uint64_t* data_addr;
	uint64_t* wdata;
	reg_t* x0;
	reg_t* x1;
	reg_t* x2;
	reg_t* x3;
	reg_t* x4;
	reg_t* x5;
	reg_t* x6;
	reg_t* x7;
	reg_t* x8;
	reg_t* x9;
	reg_t* x10;
	reg_t* x11;
	reg_t* x12;
	reg_t* x13;
	reg_t* x14;
	reg_t* x15;
	reg_t* x16;
	reg_t* x17;
	reg_t* x18;
	reg_t* x19;
	reg_t* x20;
	reg_t* x21;
	reg_t* x22;
	reg_t* x23;
	reg_t* x24;
	reg_t* x25;
	reg_t* x26;
	reg_t* x27;
	reg_t* x28;
	reg_t* x29;
	reg_t* x30;
	reg_t* x31;
	uint8_t* commit;
	uint8_t* commit_aux;
	uint32_t* claim_complete_irq1;
	uint64_t* plic_pending;
	uint32_t* priority_irq1;
	uint64_t* plic_enable;
	uint32_t* plic_threshold;
	uint64_t* mtime;
	uint64_t* mtimecmp;
} core_signal;

core_signal rv_signals;

void connect_signals(core_signal* s) {
	s->clk =                 &top->clk;
	s->rstn =                &top->rstn;
	s->instr_addr_wb =       &top->oirv->instr_addr_wb;
#ifndef CACHE
	s->instr_addr =          &top->instr_addr;
	s->instr_valid =         &top->instr_valid;
	s->instr =               &top->instr;
#endif
	
	s->irq1 =                &top->irq1;
	s->plic_ready =          &top->plic_ready;

	s->commit =              &top->oirv->commit;
	s->commit_aux =          &top->oirv->commit_aux;
	s->claim_complete_irq1 = &top->oirv->plic_inst0->claim_complete_irq1;
	s->plic_pending =        &top->oirv->plic_inst0->plic_pending;
	s->priority_irq1 =       &top->oirv->plic_inst0->priority_irq1;
	s->plic_enable =         &top->oirv->plic_inst0->plic_enable;
	s->plic_threshold =      &top->oirv->plic_inst0->plic_threshold;
	s->mtime =               &top->oirv->clint_inst0->mtime;
	s->mtimecmp =            &top->oirv->clint_inst0->mtimecmp;

	s->x0 =                  &top->oirv->reg_file_inst0->x0;
	s->x1 =                  &top->oirv->reg_file_inst0->x1;
	s->x2 =                  &top->oirv->reg_file_inst0->x2;
	s->x3 =                  &top->oirv->reg_file_inst0->x3;
	s->x4 =                  &top->oirv->reg_file_inst0->x4;
	s->x5 =                  &top->oirv->reg_file_inst0->x5;
	s->x6 =                  &top->oirv->reg_file_inst0->x6;
	s->x7 =                  &top->oirv->reg_file_inst0->x7;
	s->x8 =                  &top->oirv->reg_file_inst0->x8;
	s->x9 =                  &top->oirv->reg_file_inst0->x9;
	s->x10 =                 &top->oirv->reg_file_inst0->x10;
	s->x11 =                 &top->oirv->reg_file_inst0->x11;
	s->x12 =                 &top->oirv->reg_file_inst0->x12;
	s->x13 =                 &top->oirv->reg_file_inst0->x13;
	s->x14 =                 &top->oirv->reg_file_inst0->x14;
	s->x15 =                 &top->oirv->reg_file_inst0->x15;
	s->x16 =                 &top->oirv->reg_file_inst0->x16;
	s->x17 =                 &top->oirv->reg_file_inst0->x17;
	s->x18 =                 &top->oirv->reg_file_inst0->x18;
	s->x19 =                 &top->oirv->reg_file_inst0->x19;
	s->x20 =                 &top->oirv->reg_file_inst0->x20;
	s->x21 =                 &top->oirv->reg_file_inst0->x21;
	s->x22 =                 &top->oirv->reg_file_inst0->x22;
	s->x23 =                 &top->oirv->reg_file_inst0->x23;
	s->x24 =                 &top->oirv->reg_file_inst0->x24;
	s->x25 =                 &top->oirv->reg_file_inst0->x25;
	s->x26 =                 &top->oirv->reg_file_inst0->x26;
	s->x27 =                 &top->oirv->reg_file_inst0->x27;
	s->x28 =                 &top->oirv->reg_file_inst0->x28;
	s->x29 =                 &top->oirv->reg_file_inst0->x29;
	s->x30 =                 &top->oirv->reg_file_inst0->x30;
	s->x31 =                 &top->oirv->reg_file_inst0->x31;
	s->instr_wb =            &top->oirv->instr_wb;
}

struct termios oldt, newt;

char getche(void)
{
    char ch;
    tcgetattr(STDIN_FILENO, &oldt);
    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    ch = getchar();
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt);

    return ch;
}

void* get_input_char_task(void* args) {
    char ch;

    while(1) {
		ch = getche();
        mtx.lock();
        input_char_queue.push(ch);
        mtx.unlock();
    }

    return NULL;
}

void display_reg_value(Voirv *top) {
	reg_t regs[32] = {
							*rv_signals. x0, *rv_signals. x1, *rv_signals. x2, *rv_signals. x3,
							*rv_signals. x4, *rv_signals. x5, *rv_signals. x6, *rv_signals. x7,
							*rv_signals. x8, *rv_signals. x9, *rv_signals.x10, *rv_signals.x11,
							*rv_signals.x12, *rv_signals.x13, *rv_signals.x14, *rv_signals.x15,
							*rv_signals.x16, *rv_signals.x17, *rv_signals.x18, *rv_signals.x19,
							*rv_signals.x20, *rv_signals.x21, *rv_signals.x22, *rv_signals.x23,
							*rv_signals.x24, *rv_signals.x25, *rv_signals.x26, *rv_signals.x27,
							*rv_signals.x28, *rv_signals.x29, *rv_signals.x30, *rv_signals.x31,
				};

	for (size_t i = 0; i < 32;i++) 
	#ifdef RV64
		printf("%ld: /z $x%ld = 0x%016lx\n", i + 1, i, regs[i]);
	#else
		printf("%ld: /z $x%ld = 0x%08x\n", i + 1, i, regs[i]);
	#endif

	return ;
}

void dump_reg_value(Voirv *top, FILE* fd) {
	if ((((*rv_signals.commit) & 1) != COMMIT_INSTR) && (((*rv_signals.commit_aux) & 1) != COMMIT_INSTR))
		return ;

	reg_t regs[34] = {
							*rv_signals. x0, *rv_signals. x1, *rv_signals. x2, *rv_signals. x3,
							*rv_signals. x4, *rv_signals. x5, *rv_signals. x6, *rv_signals. x7,
							*rv_signals. x8, *rv_signals. x9, *rv_signals.x10, *rv_signals.x11,
							*rv_signals.x12, *rv_signals.x13, *rv_signals.x14, *rv_signals.x15,
							*rv_signals.x16, *rv_signals.x17, *rv_signals.x18, *rv_signals.x19,
							*rv_signals.x20, *rv_signals.x21, *rv_signals.x22, *rv_signals.x23,
							*rv_signals.x24, *rv_signals.x25, *rv_signals.x26, *rv_signals.x27,
							*rv_signals.x28, *rv_signals.x29, *rv_signals.x30, *rv_signals.x31,
							*rv_signals.instr_addr_wb, // The pc of next instruction
							(reg_t)(*rv_signals.commit) + (reg_t)(*rv_signals.commit_aux), // commit instruction number
				};

	fwrite((char*)regs, sizeof(reg_t), 34, fd);

	return ;
}

uint32_t* init_mem(char const *fn, size_t *len) {
	FILE* fp = fopen(fn, "r");
 
	if (fp == NULL)
	{
	    printf("Fail to open the binary initialization file!\n");
		return NULL;
	}
	
	fseek(fp, 0, SEEK_END);
	size_t file_size = ftell(fp);
	fseek(fp, 0, SEEK_SET);

	tot_mem_size = file_size + EXT_MEM_SIZE;
	char* buf = (char*)malloc(tot_mem_size);
	ext_mem_base = file_size; // for load and store data
	
	size_t read_len = fread(buf, file_size, 1, fp);

	if (read_len == 0)
		return nullptr;
	
	size_t i = 0;

	uint32_t* mem_base = (uint32_t*)buf;
	*len = file_size;

	// for(size_t i = 0;i < file_size;i++)
	// 	printf("%lx: %08x\n", i * 4 + RESET_VECTOR, mem_base[i]);

	for (size_t i = ext_mem_base; i < tot_mem_size; i++) {
		// buf[i] = (char)(i % 256); // !!!!!!!!!!!!!!!!!!!!! need clear this area for var in global / bss 
		buf[i] = 0;
	}
	
	fclose(fp);

	return mem_base;
}

bool uncached_write(addr_t waddr, uint64_t wdata, uint8_t wlen) {
	if (waddr == UART_PORT) {
		cerr << (char)(0xff & wdata);

		return true;
	}
	else if ((waddr == CFG_CELL_OUTPUT_REG_ADDR) || (waddr == UART_PRIORITY_ADDR) || (waddr == PLIC_PENDING_ADDR) || (waddr == UART_CLAIM_COMPLETE) || (waddr == PLIC_ENABLE_ADDR) || (waddr == PLIC_THRESHOLD_ADDR) || (waddr == MTIME_ADDR) || (waddr == MTIMECMP_ADDR)) // plic register
		return true;
	
	if (waddr < RESET_VECTOR) {
	#ifdef RV64
		printf("wrong waddr: %016lx [mtime = %016lx] @(pc)0x%16lx\n", waddr, *rv_signals.mtime, *rv_signals.instr_addr_wb);
	#else
		printf("wrong waddr: %08x [mtime = %016lx] @(pc)0x%08x\n", waddr, *rv_signals.mtime, *rv_signals.instr_addr_wb);
	#endif
		return true;
	}

	return false;
}

bool uncached_read(addr_t raddr, uint64_t& rdata) {
	if (raddr == UART_PORT) {
		rdata = (uint64_t)((uint8_t)uart_char);

		return true;
	}

	if (raddr == UART_CLAIM_COMPLETE) {
		rdata = (uint64_t)(*(rv_signals.claim_complete_irq1));

		return true;
	}

	if (raddr == PLIC_PENDING_ADDR) {
		rdata = (uint64_t)(*(rv_signals.plic_pending));

		return true;
	}

	if (raddr == UART_PRIORITY_ADDR) {
		rdata = (uint64_t)(*(rv_signals.priority_irq1));

		return true;
	}

	if (raddr == PLIC_ENABLE_ADDR) {
		rdata = (uint64_t)(*(rv_signals.plic_enable));

		return true;
	}

	if (raddr == PLIC_THRESHOLD_ADDR) {
		rdata = (uint64_t)(*(rv_signals.plic_threshold));

		return true;
	}

	if (raddr == MTIME_ADDR) {
		rdata = (uint64_t)(*(rv_signals.mtime));

		return true;
	}
	
	if (raddr == MTIMECMP_ADDR) {
		rdata = (uint64_t)(*(rv_signals.mtimecmp));

		return true;
	}

	if (raddr < RESET_VECTOR) {
		rdata = 0;
	#ifdef RV64
		printf("wrong raddr: %016lx [mtime = %016lx] @(pc)0x%016lx\n", raddr, *rv_signals.mtime, *rv_signals.instr_addr_wb);
	#else
		printf("wrong raddr: %08x [mtime = %016lx] @(pc)0x%08x\n", raddr, *rv_signals.mtime, *rv_signals.instr_addr_wb);
	#endif

		return true;
	}

	return false;
}

int main(int argc, char** argv) {
	if (argc < 2) {
		printf("No input binary file!\n");

		return 0;
	}

	Verilated::commandArgs(argc, argv);
	top = new Voirv; 
	size_t instr_num;
 	uint32_t* mem = init_mem(argv[1], &instr_num);
 	size_t mem_addr = 0;	
	char instruction_bin_str[33] = {0};
	connect_signals(&rv_signals);

	#ifdef DUMP_WAVE
		Verilated::traceEverOn(true);             // dump vcd
    	VerilatedVcdC* tfp = new VerilatedVcdC(); // dump vcd
    	top->trace(tfp, 0);                       // dump vcd
    	tfp->open("oirv_wave.vcd");         // dump vcd

	#endif

	#ifdef DUMP
		FILE* dump_reg_fd = fopen("dump.rv", "w");

		if(!dump_reg_fd) {
			printf("Can not open dump.rv!\n");

			return 0;
		}
	#endif

	pthread_t tid;
	int ret;

	ret = pthread_create(&tid, NULL, get_input_char_task, NULL);

	if (ret) {
		fprintf(stderr, "Thread create error: %s\n", strerror(ret));
		exit(-1);
	}
	
	uint64_t tot_instr_num = 0;
	uint64_t aux_instr_num = 0;
	bool stoped_by_max_time_limit = false;
	uint64_t dcache_miss_num = 0;
	uint64_t dcache_tot_num = 0;
	uint64_t icache_miss_num = 0;

#ifdef RV64
	axi_mem<uint64_t, uint64_t> axi_ports;
#else
	axi_mem<uint32_t, uint64_t> axi_ports;
#endif
    axi_ports.aclk = &top->clk;
    axi_ports.aresetn = &top->rstn;
    axi_ports.awvalid = &top->axi_awvalid;
    axi_ports.awready = &top->axi_awready;
    axi_ports.awaddr = &top->axi_awaddr;
    axi_ports.wvalid = &top->axi_wvalid;
    axi_ports.wready = &top->axi_wready;
    axi_ports.awburst = &top->axi_awburst;
    axi_ports.awsize = &top->axi_awsize;
    axi_ports.wdata = &top->axi_wdata;
    axi_ports.wlast = &top->axi_wlast;
    axi_ports.bvalid = &top->axi_bvalid;
    axi_ports.bready = &top->axi_bready;
    axi_ports.arvalid = &top->axi_arvalid;
    axi_ports.arready = &top->axi_arready;
    axi_ports.araddr = &top->axi_araddr;
    axi_ports.rvalid = &top->axi_rvalid;
    axi_ports.rready = &top->axi_rready;
    axi_ports.rdata = &top->axi_rdata;
    axi_ports.arburst = &top->axi_arburst;
    axi_ports.arsize = &top->axi_arsize;
    axi_ports.arlen = &top->axi_arlen;
    axi_ports.rlast = &top->axi_rlast;
    axi_ports.init(3, 3, 3, 3, 3, RESET_VECTOR, (uint8_t*)mem, &uncached_write, &uncached_read);
	auto start_time = system_clock::now();

	while (!Verilated::gotFinish()) {
 		if (main_time > RESET_TICKS)
 			*rv_signals.rstn = RESET_DISABLE;
		else
			*rv_signals.rstn = RESET_ENABLE;

		if (main_time & 1)
 			*rv_signals.clk = 1;
		else
			*rv_signals.clk = 0;

		bool hold = top->oirv->stall_inst0->hold_pipeline;
		
  		top->eval();
		
		uint32_t next_instr = 0;
		uint64_t next_instr_addr = 0;

		if (*rv_signals.clk == 1) { // reach the posedge of clk
			*rv_signals.irq1 = 0;

			if (*rv_signals.plic_ready == PLIC_READY) {
				mtx.lock();

        		if (!input_char_queue.empty()) {
					*rv_signals.irq1 = 1; // uart input irq
        		    uart_char = input_char_queue.front();
        		    input_char_queue.pop();
        		}

        		mtx.unlock();
			}

			axi_ports.axi_signal_update();
			// write_mem(top, (uint8_t*)mem);
			next_instr_addr = (uint64_t)*rv_signals.instr_addr_wb;
			next_instr = *rv_signals.instr_wb;

			#ifdef DUMP
				dump_reg_value(top, dump_reg_fd);
			#else
			#endif

			tot_instr_num += (uint64_t)((*rv_signals.commit) & 1) + (uint64_t)((*rv_signals.commit_aux) & 1);
			aux_instr_num += (uint64_t)((*rv_signals.commit_aux) & 1);

			if ((!hold) && (top->oirv->stall_inst0->dcache_miss))
				dcache_miss_num++;
			
			if ((!hold) && (top->oirv->stall_inst0->dcache_visit))
				dcache_tot_num++;

			// if (top->oirv->stall_inst0->icache_miss)
			if (top->oirv->instr_fetch_buffer_inst0->icache_miss)
				icache_miss_num++;
		}

		#ifdef DUMP_WAVE
			tfp->dump(main_time);                 //dump vcd
		#endif

		if ((*rv_signals.clk == 1) && (next_instr == INVALID_INST || (next_instr & 0xffff) == CINVALID_INST) && (((*rv_signals.commit) & 1) == COMMIT_INSTR)) {
			#ifdef RV64
			printf("\033[0m\033[1;32mMeet invalid instruction, stop simulation at 0x%lx.\033[0m\n", *rv_signals.instr_addr_wb);
			#else
			printf("\033[0m\033[1;32mMeet invalid instruction, stop simulation at 0x%x.\033[0m\n", *rv_signals.instr_addr_wb);
			#endif
			printf("\033[0m\033[1;32mcase                        @@ %30s.\033[0m\n", argv[1]);
			printf("\033[0m\033[1;32mCommited instruction number @@ %30lu (%lu/%lu=%f%%).\nCycle                       @@ %30lu.\nIPC                         @@ %30f.\033[0m\n", tot_instr_num, aux_instr_num, tot_instr_num - aux_instr_num, 100 * (0.0 + aux_instr_num) / (tot_instr_num - aux_instr_num), (main_time - RESET_TICKS) >> 1, ((double)tot_instr_num) / ((main_time - RESET_TICKS) >> 1));
			printf("\033[0m\033[1;32mDcache miss rate            @@ %29f%% (%lu/%lu).\n",  (100.0 * dcache_miss_num) / dcache_tot_num, dcache_miss_num, dcache_tot_num);
			printf("\033[0m\033[1;32mIcache miss rate            @@ %29f%% (%lu/%lu).\n", (100.0 * icache_miss_num) / ((main_time - RESET_TICKS) >> 1), icache_miss_num, (main_time - RESET_TICKS) >> 1);

			break;
		}

		main_time++;

		if ((main_time > STOPTIME) && (STOPTIME != 0)) {
			stoped_by_max_time_limit = true;
			break;
		}
  	}

	auto end_time   = system_clock::now();
    top->final();
    delete top;

	#ifdef DUMP_WAVE
			tfp->close();
	#endif
	
	#ifdef DUMP
		fclose(dump_reg_fd);
	#endif

	auto duration = duration_cast<microseconds>(end_time - start_time);
	double total_time = double(duration.count()) * microseconds::period::num / microseconds::period::den * 1000;
	printf("\033[0m\033[1;32mTotal simulation time: %f ms, frequency: %f KHz.\033[0m\n", total_time, (main_time >> 1) / total_time);

	if (stoped_by_max_time_limit) {
		#ifdef RV64
		printf("\033[0m\033[1;31mExceed maximum simulation time, stop simulation at 0x%lx. \033[0m\n", *rv_signals.instr_addr_wb);
		#else
		printf("\033[0m\033[1;31mExceed maximum simulation time, stop simulation at 0x%x. \033[0m\n", *rv_signals.instr_addr_wb);
		#endif
		
		printf("\033[0m\033[1;31mcase                        @@ %30s.\033[0m\n", argv[1]);
		printf("\033[0m\033[1;31mCommited instruction number @@ %30lu (%lu/%lu=%f%%).\nCycle                       @@ %30lu.\nIPC                         @@ %30f.\033[0m\n", tot_instr_num, aux_instr_num, tot_instr_num - aux_instr_num, 100 * (0.0 + aux_instr_num) / (tot_instr_num - aux_instr_num), (main_time - RESET_TICKS) >> 1, ((double)tot_instr_num) / ((main_time - RESET_TICKS) >> 1));
		printf("\033[0m\033[1;31mDcache miss rate            @@ %29f%% (%lu/%lu).\n",  (100.0 * dcache_miss_num) / dcache_tot_num, dcache_miss_num, dcache_tot_num);
		printf("\033[0m\033[1;31mIcache miss rate            @@ %29f%% (%lu/%lu).\n", (100.0 * icache_miss_num) / ((main_time - RESET_TICKS) >> 1), icache_miss_num, (main_time - RESET_TICKS) >> 1);
	}
	else {
		#ifdef RV64
		// printf("\033[0m\033[1;32mStop simulation at %lx.\033[0m\n", *rv_signals.instr_addr_wb);
		#else
		printf("\033[0m\033[1;32mStop simulation at %x.\033[0m\n", *rv_signals.instr_addr_wb);
		#endif
		
		// printf("\033[0m\033[1;32mCommited instruction number: %lu.\nCycle                      : %lu.\nIPC                        : %f.\033[0m\n", tot_instr_num, (main_time - RESET_TICKS) >> 1, ((double)tot_instr_num) / ((main_time - RESET_TICKS) >> 1));
	}	

	ret = pthread_kill(tid, 0); // NDK

	if (ret) {
		fprintf(stderr, "pthread_cancel error: %s\n", strerror(ret));
		exit(-1);
	}

	tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
	free((char*)mem);

	return 0;
}

