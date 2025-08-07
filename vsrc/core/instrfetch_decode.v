`include "params.v"

module instrfetch_decode (
	input                               clk                ,
	input                               rstn               ,
	input                               bpu_taken          ,
	input                               hold               ,
	input [`INSTR_ADDR_BUS]             instr_addr_if      ,
	input [`XLEN_BUS]                   ifu_data_if        ,
	`ifdef C_EXTENSION
	input                               is_cinstr_if       ,
	input                               is_cinstr_if_aux   ,
	`endif
	input                               cancel_instr       ,
	input                               cancel_instr_if    ,
	input                               cancel_instr_if_aux,
	input                               flush_if           ,
    output reg [`INSTR_ADDR_BUS]        instr_addr_dc      ,
	output reg [`XLEN_BUS]              ifu_data_dc        ,
	`ifdef C_EXTENSION
	output reg                          is_cinstr_dc       ,
	output reg                          is_cinstr_dc_aux   ,
	`endif
	output reg                          cancel_instr_dc    ,
	output reg                          cancel_instr_dc_aux    
);

	always@(posedge clk) begin
		if(rstn == `RESET_EN) begin
			instr_addr_dc   <= `PC_RESET_ADDR;
            ifu_data_dc        <= `ZERO;
			`ifdef C_EXTENSION
			is_cinstr_dc    <= !`IS_CINSTR;
			is_cinstr_dc_aux<= !`IS_CINSTR;
			`endif
			cancel_instr_dc <= `CANCEL_INSTR;
			cancel_instr_dc_aux <= `CANCEL_INSTR;
		end
		else if(hold == `HOLD) begin
			instr_addr_dc   <= instr_addr_dc;
            ifu_data_dc        <= ifu_data_dc;
			`ifdef C_EXTENSION
			is_cinstr_dc    <= is_cinstr_dc;
			is_cinstr_dc_aux<= is_cinstr_dc_aux;
			`endif
			cancel_instr_dc <= cancel_instr_dc;
			cancel_instr_dc_aux <= cancel_instr_dc_aux;
		end
		else begin
			instr_addr_dc   <= instr_addr_if;
			ifu_data_dc        <= ifu_data_if;
			`ifdef C_EXTENSION
			is_cinstr_dc    <= is_cinstr_if;
			is_cinstr_dc_aux<= is_cinstr_if_aux;
			`endif
			if ((flush_if == `FLUSH_PIPELINE) || (cancel_instr == `CANCEL_INSTR)) begin
            	cancel_instr_dc     <= `CANCEL_INSTR      ;
				cancel_instr_dc_aux <= `CANCEL_INSTR      ;
			end
			else if (bpu_taken == `TAKEN) begin
				cancel_instr_dc     <= !`CANCEL_INSTR     ;
				cancel_instr_dc_aux <= `CANCEL_INSTR      ;
			end
			else begin
				cancel_instr_dc <= cancel_instr_if;
				cancel_instr_dc_aux <= cancel_instr_if_aux;
			end
		end
	end
endmodule
