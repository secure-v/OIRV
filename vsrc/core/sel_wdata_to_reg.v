`include "params.v"

module sel_wdata_to_reg (
	input                    wreg_src    ,
	input [`XLEN_BUS]        mem_data    ,
    input [`XLEN_BUS]        alu_res     ,
	output reg [`XLEN_BUS]   wreg_data             
);

    always@(*) begin
		if (wreg_src == `IS_FROM_ALU)
            wreg_data = alu_res;
        else
            wreg_data = mem_data;
	end

    
endmodule
