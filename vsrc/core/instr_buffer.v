`include "params.v"

module instr_buffer (
    input                              clk              ,
    input                              rstn             ,
    input [`INSTR_ADDR_BUS]            next_pc          ,
    input                              hold             ,
    input                              fencei_flush     ,
    input [`INSTR_ADDR_BUS]            instr_addr       , // from core
	output reg [`XLEN_BUS]             instr_buffer_data,
	output reg                         instr_valid      ,

    output reg [`INSTR_ADDR_BUS]       instr_addr_ifu   , // to ifu
	input [`XLEN_BUS]                  ifu_data         ,
	input                              ifu_rdata_valid  
    );

////////////////////////////////////////////////////////////////////////////////////

`ifdef INSTR_BUFFER
    wire [`INSTR_ADDR_BUS] cur_line_addr;
    reg [`INSTR_ADDR_BUS] next_line_addr;

    assign cur_line_addr = {instr_addr[`INSTR_ADDR_BUS_WIDTH - 1:3], 3'b0};

	always@(posedge clk) begin
		if(rstn == `RESET_EN)
			next_line_addr <= `PC_RESET_ADDR + 8;
		else if (hold == `HOLD)
			next_line_addr <= next_line_addr;
		else	
			next_line_addr <= {next_pc[`INSTR_ADDR_BUS_WIDTH - 1:3], 3'b0} + 8;
	end

    wire [`INSTR_ADDR_BUS] aligned_next_pc;
    assign aligned_next_pc = {next_pc[`INSTR_ADDR_BUS_WIDTH - 1:3], 3'b0};

//----------------------------------------------------------------------------------
    reg [`XLEN_BUS] ifu_data0;
    reg [`XLEN_BUS] ifu_data1;
    reg [`INSTR_ADDR_BUS] ifu_data0_addr; // addr
    reg [`INSTR_ADDR_BUS] ifu_data1_addr; // addr + 8

    always@(posedge clk) begin
        if ((rstn == `RESET_EN) || fencei_flush) begin
            ifu_data0 <= `ZERO;
            ifu_data1 <= `ZERO;
            ifu_data0_addr <= ~`ZERO;
            ifu_data1_addr <= ~`ZERO;
        end
        else if (((instr_valid != `INSTR_VALID) || (ifu_data1_addr == instr_addr)) && (ifu_rdata_valid == `RDATA_VALID)) begin
            ifu_data0 <= ifu_data1;
            ifu_data1 <= ifu_data ;
            ifu_data0_addr <= ifu_data1_addr;
            ifu_data1_addr <= instr_addr_ifu;
        end
        else begin
            ifu_data0 <= ifu_data0;
            ifu_data1 <= ifu_data1;
            ifu_data0_addr <= ifu_data0_addr;
            ifu_data1_addr <= ifu_data1_addr;
        end
    end
//----------------------------------------------------------------------------------

    always@(posedge clk) begin
		if(rstn == `RESET_EN)
			instr_addr_ifu <= `PC_RESET_ADDR;
        else if ((ifu_data1_addr == instr_addr) && (ifu_rdata_valid == `RDATA_VALID))
            instr_addr_ifu <= instr_addr_ifu + 8;
        else if ((cur_line_addr == ifu_data1_addr) || ((ifu_data0_addr == cur_line_addr) && (ifu_data1_addr == next_line_addr)))
            instr_addr_ifu <= ifu_data1_addr + 8;
        else if (ifu_rdata_valid == `RDATA_VALID)
			instr_addr_ifu <= instr_addr_ifu + 8;
        else if (instr_valid != `INSTR_VALID)
			instr_addr_ifu <= cur_line_addr;
		else
			instr_addr_ifu <= aligned_next_pc;
	end

    always@(*) begin
        if (((ifu_data0_addr == cur_line_addr) && (ifu_data1_addr == next_line_addr)) || (ifu_data1_addr == instr_addr))
        // if ((ifu_data0_addr == cur_line_addr) && (ifu_data1_addr == next_line_addr))
            instr_valid = `INSTR_VALID;
        else
            instr_valid = !`INSTR_VALID;
    end

    always@(*) begin
        if ((ifu_data0_addr == cur_line_addr) && (ifu_data1_addr == next_line_addr))
            case (instr_addr[2:0])
                3'b001 : instr_buffer_data = {ifu_data1[7:0] , ifu_data0[63:8] };
                3'b010 : instr_buffer_data = {ifu_data1[15:0], ifu_data0[63:16]};
                3'b011 : instr_buffer_data = {ifu_data1[23:0], ifu_data0[63:24]};
                3'b100 : instr_buffer_data = {ifu_data1[31:0], ifu_data0[63:32]};
                3'b101 : instr_buffer_data = {ifu_data1[39:0], ifu_data0[63:40]};
                3'b110 : instr_buffer_data = {ifu_data1[47:0], ifu_data0[63:48]};
                3'b111 : instr_buffer_data = {ifu_data1[55:0], ifu_data0[63:56]};
                default: instr_buffer_data = ifu_data0;
            endcase
        else
            instr_buffer_data = ifu_data1;
    end
`else
    always@(*) begin
        instr_buffer_data = ifu_data;
        instr_addr_ifu = instr_addr;
        instr_valid = ifu_rdata_valid;
    end
`endif

endmodule


