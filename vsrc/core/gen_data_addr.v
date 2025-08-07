`include "params.v"

module gen_data_addr (
	input                        is_load_or_store_instr ,
	input                        wdata_en               ,
	input                        flush_mem              ,
	input                        cancel_instr_mem       ,
	input [`XLEN_BUS]            alu_res                ,
	output reg [`DATA_ADDR_BUS]  data_addr              ,
	output reg                   rdata_en               
);
	
	always@(*) begin
		if ((wdata_en == `WDATA_EN) || (rdata_en == `RDATA_EN))
			data_addr = alu_res[`DATA_ADDR_BUS];
		else
			data_addr = `PC_RESET_ADDR;
	end

	always@(*) begin
		if ((is_load_or_store_instr == `IS_LOAD_OR_STORE_INSTR) && (wdata_en != `WDATA_EN) && (flush_mem != `FLUSH_PIPELINE) && (cancel_instr_mem != `CANCEL_INSTR))
			rdata_en = `RDATA_EN;
		else
			rdata_en = !`RDATA_EN;
	end

endmodule
