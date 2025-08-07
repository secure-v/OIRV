`include "params.v"

module sel_data_to_gpr (
	input [`XLEN_BUS]       csr_data    ,
	input                   wcsr_en_wb  ,
	input [`XLEN_BUS]       wreg_data_wb,
	output reg [`XLEN_BUS]  wreg_data       
);

    always@(*) begin
		if (wcsr_en_wb == `W_CSR_EN)
			wreg_data = csr_data    ;
        else
            wreg_data = wreg_data_wb;
	end
    
endmodule
