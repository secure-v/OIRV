`include "params.v"

module reg_file (
	input                               clk       ,
	input                               rstn      ,
	input                               wen0      ,
	input                               wen1      ,
	input                               wcsr_en   ,
	input [`REG_INDEX_BUS]              reg_id0   ,
	input [`REG_INDEX_BUS]              reg_id1   ,
    input [`REG_INDEX_BUS]              reg_id2   ,
	input [`REG_INDEX_BUS]              reg_id3   ,
	input [`REG_INDEX_BUS]              wreg_id0  ,
    input [`REG_INDEX_BUS]              wreg_id1  ,
	input [`REG_INDEX_BUS]              reg_id_csr,
	input [`XLEN_BUS]                   wreg_data0,
    input [`XLEN_BUS]                   wreg_data1,
	output reg [`XLEN_BUS]              reg_data0 ,
	output reg [`XLEN_BUS]              reg_data1 ,
    output reg [`XLEN_BUS]              reg_data2 ,
	output reg [`XLEN_BUS]              reg_data3 ,
	output reg [`XLEN_BUS]              wcsr_data 
);
	
	reg[`XLEN_BUS] regs[`REG_BUS]/* verilator public */;

	`ifdef DISPLAY_REG_FILE_FROM_PORT
		wire [`XLEN_BUS]     x0 /*verilator public*/;
		wire [`XLEN_BUS]     x1 /*verilator public*/;
		wire [`XLEN_BUS]     x2 /*verilator public*/;
		wire [`XLEN_BUS]     x3 /*verilator public*/;
		wire [`XLEN_BUS]     x4 /*verilator public*/;
		wire [`XLEN_BUS]     x5 /*verilator public*/;
		wire [`XLEN_BUS]     x6 /*verilator public*/;
		wire [`XLEN_BUS]     x7 /*verilator public*/;
		wire [`XLEN_BUS]     x8 /*verilator public*/;
		wire [`XLEN_BUS]     x9 /*verilator public*/;
		wire [`XLEN_BUS]     x10/*verilator public*/;
		wire [`XLEN_BUS]     x11/*verilator public*/;
		wire [`XLEN_BUS]     x12/*verilator public*/;
		wire [`XLEN_BUS]     x13/*verilator public*/;
		wire [`XLEN_BUS]     x14/*verilator public*/;
		wire [`XLEN_BUS]     x15/*verilator public*/;
		wire [`XLEN_BUS]     x16/*verilator public*/;
		wire [`XLEN_BUS]     x17/*verilator public*/;
		wire [`XLEN_BUS]     x18/*verilator public*/;
		wire [`XLEN_BUS]     x19/*verilator public*/;
		wire [`XLEN_BUS]     x20/*verilator public*/;
		wire [`XLEN_BUS]     x21/*verilator public*/;
		wire [`XLEN_BUS]     x22/*verilator public*/;
		wire [`XLEN_BUS]     x23/*verilator public*/;
		wire [`XLEN_BUS]     x24/*verilator public*/;
		wire [`XLEN_BUS]     x25/*verilator public*/;
		wire [`XLEN_BUS]     x26/*verilator public*/;
		wire [`XLEN_BUS]     x27/*verilator public*/;
		wire [`XLEN_BUS]     x28/*verilator public*/;
		wire [`XLEN_BUS]     x29/*verilator public*/;
		wire [`XLEN_BUS]     x30/*verilator public*/;
		wire [`XLEN_BUS]     x31/*verilator public*/;

		assign x0  = regs[0] ;
		assign x1  = regs[1] ;
		assign x2  = regs[2] ;
		assign x3  = regs[3] ;
		assign x4  = regs[4] ;
		assign x5  = regs[5] ;
		assign x6  = regs[6] ;
		assign x7  = regs[7] ;
		assign x8  = regs[8] ;
		assign x9  = regs[9] ;
		assign x10 = regs[10];
		assign x11 = regs[11];
		assign x12 = regs[12];
		assign x13 = regs[13];
		assign x14 = regs[14];
		assign x15 = regs[15];
		assign x16 = regs[16];
		assign x17 = regs[17];
		assign x18 = regs[18];
		assign x19 = regs[19];
		assign x20 = regs[20];
		assign x21 = regs[21];
		assign x22 = regs[22];
		assign x23 = regs[23];
		assign x24 = regs[24];
		assign x25 = regs[25];
		assign x26 = regs[26];
		assign x27 = regs[27];
		assign x28 = regs[28];
		assign x29 = regs[29];
		assign x30 = regs[30];
		assign x31 = regs[31];
	`endif

	always@(*) begin
		if(rstn == `RESET_EN)
			reg_data0 = `ZERO;
		else	
			reg_data0 = regs[reg_id0];
	end

	always@(*) begin
		if(rstn == `RESET_EN)
			reg_data1 = `ZERO;
		else	
			reg_data1 = regs[reg_id1];
	end

	wire [`REG_INDEX_BUS] mux_reg_id2_reg_id_csr;
	assign mux_reg_id2_reg_id_csr = (wcsr_en == `W_CSR_EN)? reg_id_csr : reg_id2;

    always@(*) begin
		if(rstn == `RESET_EN)
			reg_data2 = `ZERO;
		else	
			reg_data2 = regs[mux_reg_id2_reg_id_csr];
	end

	always@(*) begin
		if(rstn == `RESET_EN)
			reg_data3 = `ZERO;
		else	
			reg_data3 = regs[reg_id3];
    end

	always@(*) begin
		wcsr_data = reg_data2;
	end

    wire is_wreg0;
    wire is_wreg1;

    assign is_wreg0 = (wen0 == `W_REG_EN) && (wreg_id0 != `ZERO);
    assign is_wreg1 = (wen1 == `W_REG_EN) && (wreg_id1 != `ZERO);

	always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			regs[0] <= `ZERO;
			regs[wreg_id0] <= `ZERO;
		end
			// other register hold original value
		else if (is_wreg0 && is_wreg1 && (wreg_id0 == wreg_id1)) begin
			regs[wreg_id1] <= wreg_data1;
		end
		else begin
			if (is_wreg0)
				regs[wreg_id0] <=  wreg_data0;

			if (is_wreg1)
				regs[wreg_id1] <=  wreg_data1;
        end
	end


endmodule
