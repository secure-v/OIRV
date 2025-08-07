`include "params.v"

module gen_wdata (
	input [`XLEN_BUS]            reg_data1, // rs2
	output [`XLEN_BUS]           wdata        
);
	
	assign wdata = reg_data1;
endmodule
