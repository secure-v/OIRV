`include "params.v"

module program_counter(
	input                        clk                ,
	input                        rstn               ,
	input                        hold               ,
	input [`INSTR_ADDR_BUS]      next_pc            , 
	output reg                   cancel_instr_if    ,
	output reg                   cancel_instr_if_aux,
	output reg [`INSTR_ADDR_BUS] pc                 
);
	
	always@(posedge clk) begin
		if(rstn == `RESET_EN)
			pc <= `PC_RESET_ADDR;
		else if (hold == `HOLD)
			pc <= pc;
		else	
			pc <= next_pc;
	end

	always@(posedge clk) begin
		if(rstn == `RESET_EN)
			cancel_instr_if <= !`CANCEL_INSTR ;
		else if (hold == `HOLD)
			cancel_instr_if <= cancel_instr_if;
		else	
			cancel_instr_if <= !`CANCEL_INSTR ;
	end

	always@(posedge clk) begin
		if(rstn == `RESET_EN)
			cancel_instr_if_aux <= !`CANCEL_INSTR     ;
		else if (hold == `HOLD)
			cancel_instr_if_aux <= cancel_instr_if_aux;
		else	
			cancel_instr_if_aux <= !`CANCEL_INSTR     ;
	end

endmodule
