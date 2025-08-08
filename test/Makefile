## RTL SIMULATION SETTING
T ?= 0 # maximum simulation time 0 (running forever)
SRC ?= addi
ABI ?= lp64
ARCH ?= rv64imac
VERILATOR ?= verilator
VDEFINE_ARGS ?= RV64


## COMPILE SETTING
CROSS_COMPILE = riscv64-unknown-elf-
CC = ${CROSS_COMPILE}gcc
OBJDUMP = ${CROSS_COMPILE}objdump
OBJCOPY = ${CROSS_COMPILE}objcopy
FLAG ?= -O0
CFLAGS = -nostdlib -fno-builtin -march=${ARCH} -mabi=${ABI} -g -Wall -mcmodel=medany -lgcc ${FLAG}


ifeq (, $(shell which verilator))
	VERILATOR = ~/eda/verilator/bin/verilator
endif


ifeq ($(findstring rv64, $(ARCH)), )
	VDEFINE_ARGS = RV32
	ABI = ilp32
else
	VDEFINE_ARGS = RV64
endif


ifneq ($(wildcard c/$(SRC).c),)
  SRC_FILE = c/start.S $(wildcard c/$(SRC).c)
  LINK_OPT = -T bare.lds
else
	ifeq ($(findstring rv64, $(ARCH)), )
		SRC_FILE = $(wildcard asm_rv32/$(SRC).s)
  		LINK_OPT = -Ttext=0x80000000
	else
		SRC_FILE = $(wildcard asm_rv64/$(SRC).s)
  		LINK_OPT = -Ttext=0x80000000
	endif
endif


all: start
	

rtl-model:
	${VERILATOR} --cc --exe --build --vpi --trace  test_main.cpp +define+${VDEFINE_ARGS} -CFLAGS -DSTOPTIME=${T} +incdir+. ../vsrc/core/*.v ../vsrc/core/MUL/*.v ../vsrc/core/DIV/*.v ../vsrc/core/CACHE/*.v -CFLAGS -DSTOPTIME=0  -CFLAGS -D${VDEFINE_ARGS} +incdir+../vsrc/core/ --top-module oirv
# 	mv obj_dir/Voirv ../../oirv_model
# 	chmod +x ../../oirv_model


wave-model:
	${VERILATOR} --cc --exe --build --vpi --trace  test_main.cpp +define+${VDEFINE_ARGS} -CFLAGS -DDUMP_WAVE -CFLAGS -DSTOPTIME=${T} +incdir+. ../vsrc/core/*.v ../vsrc/core/MUL/*.v ../vsrc/core/DIV/*.v ../vsrc/core/CACHE/*.v -CFLAGS -DSTOPTIME=0  -CFLAGS -D${VDEFINE_ARGS} +incdir+../vsrc/core/ --top-module oirv


dump:
	${VERILATOR}  --cc --exe --build --vpi --trace  +define+${VDEFINE_ARGS} -CFLAGS -DSTOPTIME=${T} -CFLAGS -DDUMP -CFLAGS -CFLAGS -D${VDEFINE_ARGS} test_main.cpp +incdir+. ../vsrc/core/*.v ../vsrc/core/MUL/*.v ../vsrc/core/DIV/*.v ../vsrc/core/CACHE/*.v  +incdir+../vsrc/core/ --top-module oirv
# 	mv obj_dir/Voirv ../../oirv_model
# 	chmod +x ../../oirv_model


./build/${SRC}.elf: ${SRC_FILE}
	mkdir -p build
	${CC} ${LINK_OPT} $^ -o $@ ${CFLAGS}


./build/${SRC}.bin: ./build/${SRC}.elf
	${OBJCOPY} -O binary $^ $@


start: ./build/${SRC}.bin rtl-model
	./obj_dir/Voirv $<


wave: ./build/${SRC}.bin wave-model
	./obj_dir/Voirv $<


clean:
	rm -rf obj_dir dump.* ./build *.vcd *.log
	
.PHONY: clean
