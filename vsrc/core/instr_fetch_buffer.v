`include "params.v"

module instr_fetch_buffer (
	input                        clk                  ,
	input                        rstn                 ,
	input                        hold                 , // hold_if
    input                        interrupt_taken      ,
    input                        is_ecall_instr_wb    ,
    input                        is_mret_instr_wb     ,
    input                        is_csr_instr_in_wb   ,
    input                        is_fencei_wb         ,
    input                        branch_taken_ex2     ,
    input [`INSTR_ADDR_BUS]      exception_entry      ,
    input [`INSTR_ADDR_BUS]      instr_addr_wb        ,
    input [`INSTR_ADDR_BUS]      branch_jalr_target_pc,
    input                        can_not_issue        ,
    output [`INSTR_ADDR_BUS]     instr_addr_ifu       , // to ifu
	input [`CACHE_LINE_BUS]      ifu_data             ,
	input                        ifu_rdata_valid      ,

    input [`INST_TYPE_BUS]       instr_type           , // from ctrl
    input [`XLEN_BUS]            sext_imm_dc          ,
    input [`XLEN_BUS]            cimm_dc              ,

    input                        aux_can_issue        , // from ctrl_aux
	input                        ifu_miss             ,
    output                       instr_valid          ,
	output reg [`INSTR_ADDR_BUS] next_instr_addr      ,
	output reg [`INSTR_ADDR_BUS] instr_addr_dc        ,
    output reg [`INSTR_ADDR_BUS] instr_addr_dc_aux    ,
	output reg [`INST_BUS]       instr_dc             , // to ctrl
    output reg [`INST_BUS]       instr_aux            , // to ctrl_aux
    output                       is_cinstr            ,
    output                       is_cinstr_aux        ,
	output                       cancel_instr_dc      ,
	output                       cancel_instr_dc_aux  
);
    
`define DATA_BUFFER_SIZE 240

    wire icache_miss/*verilator public*/;

    assign icache_miss = (ifu_rdata_valid != `RDATA_VALID);
    assign instr_valid = (ifu_miss && ((interrupt_taken == `INTERRUPT_TAKEN) || ((is_ecall_instr_wb == `IS_ECALL_INSTR) || (is_mret_instr_wb == `IS_MRET_INSTR)) || (is_csr_instr_in_wb == `CSR_INSTR_IN_WB) || is_fencei_wb || (branch_taken_ex2 == `BOOL_TRUE) || ((instr_type[`CJTYPE_INDEX] || instr_type[`JTYPE_INDEX]))))? !`INSTR_VALID : `INSTR_VALID;
    assign instr_addr_ifu = {instr_addr[`INSTR_ADDR_BUS_WIDTH - 1:3], 3'b0};

	wire [`INSTR_ADDR_BUS] flush_entry = instr_addr_wb + `INSTR_BYTE_NUM;
	wire [`INSTR_ADDR_BUS] jal_target_pc = instr_addr_dc + ((is_cinstr != `IS_CINSTR)? sext_imm_dc[`INSTR_ADDR_BUS] : cimm_dc[`INSTR_ADDR_BUS]);
	reg [`INSTR_ADDR_BUS] instr_addr;
    reg [`CACHE_LINE_BUS] ifu_data_buffer;
	reg [1:0] ifu_data_buffer_offset; // wlen: 0 -> 8 B || 1 -> 6 B || 2 -> 4 B || 3 -> 2 B
	reg ifu_data_buffer_valid;

	always@(*) begin
		if ((interrupt_taken == `INTERRUPT_TAKEN) || ((is_ecall_instr_wb == `IS_ECALL_INSTR) || (is_mret_instr_wb == `IS_MRET_INSTR))) // time interrupt / ecall / mret
			next_instr_addr = exception_entry                                                      ;
		else if ((is_csr_instr_in_wb == `CSR_INSTR_IN_WB) || is_fencei_wb) // csr / fencei
			next_instr_addr = flush_entry                                                          ;
		else if (branch_taken_ex2 == `BOOL_TRUE)
			next_instr_addr = branch_jalr_target_pc                                                ;
        // else if ((instr_type[`CJTYPE_INDEX] || instr_type[`JTYPE_INDEX]) && (cancel_instr_dc != `CANCEL_INSTR)) // jal in dc
        else if ((instr_type[`CJTYPE_INDEX] || instr_type[`JTYPE_INDEX]) && (!((wr_ptr == 4'd0) || ((wr_ptr == 4'd1) && (is_cinstr != `IS_CINSTR))))) // jal in dc
			next_instr_addr = jal_target_pc                                                        ;
		else if ((!icache_miss) && ((!ifu_data_buffer_valid) || wen_buffer))
			next_instr_addr = instr_addr_ifu + `INSTR_ADDR_BUS_WIDTH'd8                            ;
		else
			next_instr_addr = instr_addr                                                           ;
    end

    always@(posedge clk) begin
		if (rstn == `RESET_EN)
			instr_addr <= `PC_RESET_ADDR ;
		else
			instr_addr <= next_instr_addr;
    end

    always@(posedge clk) begin
		if (rstn == `RESET_EN) begin
            ifu_data_buffer        <= `ZERO;
            ifu_data_buffer_offset <= `ZERO;
            ifu_data_buffer_valid  <= `ZERO;
        end
		if ((interrupt_taken == `INTERRUPT_TAKEN) || ((is_ecall_instr_wb == `IS_ECALL_INSTR) || (is_mret_instr_wb == `IS_MRET_INSTR))) begin // time interrupt / ecall / mret
            ifu_data_buffer        <= ifu_data_buffer           ;
            ifu_data_buffer_offset <= ifu_data_buffer_offset    ;
            ifu_data_buffer_valid  <= `ZERO                     ;
        end
		else if ((is_csr_instr_in_wb == `CSR_INSTR_IN_WB) || is_fencei_wb) begin // csr / fencei
			ifu_data_buffer        <= ifu_data_buffer           ;
            ifu_data_buffer_offset <= ifu_data_buffer_offset    ;
            ifu_data_buffer_valid  <= `ZERO                     ;
        end
		else if (branch_taken_ex2 == `BOOL_TRUE) begin
            ifu_data_buffer        <= ifu_data_buffer           ;
            ifu_data_buffer_offset <= ifu_data_buffer_offset    ;
            ifu_data_buffer_valid  <= `ZERO                     ;
        end
        else if ((instr_type[`CJTYPE_INDEX] || instr_type[`JTYPE_INDEX]) && (cancel_instr_dc != `CANCEL_INSTR)) begin // jal in dc
            ifu_data_buffer        <= ifu_data_buffer           ;
            ifu_data_buffer_offset <= ifu_data_buffer_offset    ;
            ifu_data_buffer_valid  <= `ZERO                     ;
        end
		else if (((ifu_rdata_valid == `RDATA_VALID) && ((!ifu_data_buffer_valid) || wen_buffer))) begin
            ifu_data_buffer        <= ifu_data                  ;
            ifu_data_buffer_offset <= instr_addr[2:1]           ;
            ifu_data_buffer_valid  <= 1                         ;
        end
        else if (wen_buffer && ifu_data_buffer_valid) begin
            ifu_data_buffer        <= ifu_data                  ;
            ifu_data_buffer_offset <= instr_addr[2:1]           ;
            ifu_data_buffer_valid  <= `ZERO                     ;
        end
		else begin
            ifu_data_buffer        <= ifu_data_buffer           ;
            ifu_data_buffer_offset <= ifu_data_buffer_offset    ;
            ifu_data_buffer_valid  <= ifu_data_buffer_valid     ;
        end
    end

	reg [`CACHE_LINE_BUS] ifu_data_buffer_shifted;
	reg [`CACHE_LINE_WIDTH + `DATA_BUFFER_SIZE - 1:0] ifu_data_buffer_shifted_ext;
	reg [`DATA_BUFFER_SIZE - 1:0] buffer_mask;

	always @(*) begin
		case (ifu_data_buffer_offset)
			2'd0   : ifu_data_buffer_shifted = ifu_data_buffer      ;
			2'd1   : ifu_data_buffer_shifted = ifu_data_buffer >> 16;
			2'd2   : ifu_data_buffer_shifted = ifu_data_buffer >> 32;
			2'd3   : ifu_data_buffer_shifted = ifu_data_buffer >> 48;
			default: ifu_data_buffer_shifted = ifu_data_buffer      ;
		endcase
	end

	always @(*) begin
		case (wr_ptr)
			4'd0   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (0  * 16)        ;
			4'd1   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (1  * 16)        ;
			4'd2   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (2  * 16)        ;
			4'd3   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (3  * 16)        ;
			4'd4   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (4  * 16)        ;
			4'd5   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (5  * 16)        ;
			4'd6   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (6  * 16)        ;
			4'd7   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (7  * 16)        ;
			4'd8   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (8  * 16)        ;
			4'd9   : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (9  * 16)        ;
			4'd10  : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (10 * 16)        ;
			4'd11  : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (11 * 16)        ;
			4'd12  : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (12 * 16)        ;
			4'd13  : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (13 * 16)        ;
			4'd14  : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (14 * 16)        ;
			4'd15  : ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << (15 * 16)        ;
			default: ifu_data_buffer_shifted_ext = {`DATA_BUFFER_SIZE'd0, ifu_data_buffer_shifted} << `DATA_BUFFER_SIZE; 
		endcase
	end

	always @(*) begin
		case (wr_ptr)
			4'd0   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 0 ) * 16);
			4'd1   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 1 ) * 16);
			4'd2   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 2 ) * 16);
			4'd3   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 3 ) * 16);
			4'd4   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 4 ) * 16);
			4'd5   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 5 ) * 16);
			4'd6   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 6 ) * 16);
			4'd7   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 7 ) * 16);
			4'd8   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 8 ) * 16);
			4'd9   : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 9 ) * 16);
			4'd10  : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 10) * 16);
			4'd11  : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 11) * 16);
			4'd12  : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 12) * 16);
			4'd13  : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 13) * 16);
			4'd14  : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 14) * 16);
			4'd15  : buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO)) >> ((15 - 15) * 16);
			default: buffer_mask = (~(`DATA_BUFFER_SIZE'h`ZERO))                   ; 
		endcase
	end

	wire [`CACHE_LINE_WIDTH + `DATA_BUFFER_SIZE - 1:0] ifu_data_buffer_shifted_ext_shift_byte0 = (consume_byte0)? ifu_data_buffer_shifted_ext : `ZERO;
	wire [`CACHE_LINE_WIDTH + `DATA_BUFFER_SIZE - 1:0] ifu_data_buffer_shifted_ext_shift_byte2 = (consume_byte2)? (ifu_data_buffer_shifted_ext >> 16) : `ZERO;
	wire [`CACHE_LINE_WIDTH + `DATA_BUFFER_SIZE - 1:0] ifu_data_buffer_shifted_ext_shift_byte4 = (consume_byte4)? (ifu_data_buffer_shifted_ext >> 32) : `ZERO;
	wire [`CACHE_LINE_WIDTH + `DATA_BUFFER_SIZE - 1:0] ifu_data_buffer_shifted_ext_shift_byte6 = (consume_byte6)? (ifu_data_buffer_shifted_ext >> 48) : `ZERO;
	wire [`CACHE_LINE_WIDTH + `DATA_BUFFER_SIZE - 1:0] ifu_data_buffer_shifted_ext_shift_byte8 = (consume_byte8)? (ifu_data_buffer_shifted_ext >> 64) : `ZERO;
	wire [`CACHE_LINE_WIDTH + `DATA_BUFFER_SIZE - 1:0] ifu_data_buffer_shifted_ext_shift = ifu_data_buffer_shifted_ext_shift_byte0 | ifu_data_buffer_shifted_ext_shift_byte2 | ifu_data_buffer_shifted_ext_shift_byte4 | ifu_data_buffer_shifted_ext_shift_byte6 | ifu_data_buffer_shifted_ext_shift_byte8;
	wire [`DATA_BUFFER_SIZE - 1:0] adjusted_ifu_buffer_data = ifu_data_buffer_shifted_ext_shift[`DATA_BUFFER_SIZE - 1:0];

////////////////////////////////////////////////////// buffer for decouple //////////////////////////////////////////////////////////
	reg [3:0] wr_ptr; // full: wr_ptr >= 8
    reg [`DATA_BUFFER_SIZE - 1:0] buffer;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			wr_ptr <= `ZERO              ;
		else if ((interrupt_taken == `INTERRUPT_TAKEN) || ((is_ecall_instr_wb == `IS_ECALL_INSTR) || (is_mret_instr_wb == `IS_MRET_INSTR))) // time interrupt / ecall / mret
			wr_ptr <= `ZERO              ;
		else if ((is_csr_instr_in_wb == `CSR_INSTR_IN_WB) || is_fencei_wb) // csr / fencei
			wr_ptr <= `ZERO              ;
		else if (branch_taken_ex2 == `BOOL_TRUE)
			wr_ptr <= `ZERO              ;
        else if ((instr_type[`CJTYPE_INDEX] || instr_type[`JTYPE_INDEX]) && (cancel_instr_dc != `CANCEL_INSTR)) // jal in dc
			wr_ptr <= `ZERO              ;
		else
			wr_ptr <= wr_ptr - wr_ptr_dec;
	end 

    always@(posedge clk) begin
		if (rstn == `RESET_EN)
			buffer <= `ZERO        ;
		else if ((ifu_data_buffer_valid && wen_buffer) || (!consume_byte0))
			buffer <= (buffer_shift_val & buffer_mask_shift) | (adjusted_ifu_buffer_data & (~buffer_mask_shift));
		else
			buffer <= buffer;
	end 

	assign is_cinstr = (buffer[1:0] != 2'b11)? `IS_CINSTR : !`IS_CINSTR;
    assign is_cinstr_aux = (((buffer[1:0] == 2'b11) && (buffer[33:32] != 2'b11)) || ((buffer[1:0] != 2'b11) && (buffer[17:16] != 2'b11)))? `IS_CINSTR : !`IS_CINSTR;
    
    wire consume_byte0 =  can_not_issue || (hold == `HOLD) || (wr_ptr == 4'd0) || ((wr_ptr == 4'd1) && (is_cinstr != `IS_CINSTR));
	wire consume_byte2 = (!can_not_issue) && (hold != `HOLD) && (((wr_ptr == 4'd1) && (is_cinstr == `IS_CINSTR)) || ((wr_ptr == 4'd2) && (is_cinstr == `IS_CINSTR) && ((is_cinstr_aux != `IS_CINSTR) || (aux_can_issue != `AUX_CAN_ISSUE))) || ((wr_ptr >= 4'd3) && (is_cinstr == `IS_CINSTR) && (aux_can_issue != `AUX_CAN_ISSUE)));
	wire consume_byte4 = (!can_not_issue) && (hold != `HOLD) && (((wr_ptr >= 4'd2) && (is_cinstr == `IS_CINSTR) && (is_cinstr_aux == `IS_CINSTR) && (aux_can_issue == `AUX_CAN_ISSUE)) || ((wr_ptr == 4'd2) && (is_cinstr != `IS_CINSTR)) || ((wr_ptr == 4'd3) && (is_cinstr != `IS_CINSTR) && ((is_cinstr_aux != `IS_CINSTR) || (aux_can_issue != `AUX_CAN_ISSUE))) || ((wr_ptr >= 4'd4) && (is_cinstr != `IS_CINSTR) && (aux_can_issue != `AUX_CAN_ISSUE)));
	wire consume_byte6 = (!can_not_issue) && (hold != `HOLD) && (wr_ptr >= 4'd3) && (is_cinstr ^ is_cinstr_aux) && (aux_can_issue == `AUX_CAN_ISSUE);
	wire consume_byte8 = (!can_not_issue) && (hold != `HOLD) && (wr_ptr >= 4'd4) && (is_cinstr != `IS_CINSTR) && (is_cinstr_aux != `IS_CINSTR) && (aux_can_issue == `AUX_CAN_ISSUE);

	wire [`DATA_BUFFER_SIZE - 1:0] buffer_shift_byte0 = (consume_byte0)? buffer : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_shift_byte2 = (consume_byte2)? (buffer >> 16) : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_shift_byte4 = (consume_byte4)? (buffer >> 32) : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_shift_byte6 = (consume_byte6)? (buffer >> 48) : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_shift_byte8 = (consume_byte8)? (buffer >> 64) : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_shift_val = buffer_shift_byte0 | buffer_shift_byte2 | buffer_shift_byte4 | buffer_shift_byte6 | buffer_shift_byte8;

	wire [`DATA_BUFFER_SIZE - 1:0] buffer_mask_shift_byte0 = (consume_byte0)? buffer_mask : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_mask_shift_byte2 = (consume_byte2)? (buffer_mask >> 16) : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_mask_shift_byte4 = (consume_byte4)? (buffer_mask >> 32) : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_mask_shift_byte6 = (consume_byte6)? (buffer_mask >> 48) : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_mask_shift_byte8 = (consume_byte8)? (buffer_mask >> 64) : `ZERO;
	wire [`DATA_BUFFER_SIZE - 1:0] buffer_mask_shift = buffer_mask_shift_byte0 | buffer_mask_shift_byte2 | buffer_mask_shift_byte4 | buffer_mask_shift_byte6 | buffer_mask_shift_byte8;

	reg wen_buffer;
    reg[3:0] wr_ptr_dec;

	always @(*) begin
		// case (wr_ptr)
		// 	4'd5   : begin
		// 		if (consume_byte0 && (ifu_data_buffer_offset == 2'd0)) // wlen == 8 B
		// 			wen_buffer = `ZERO;
		// 		else
		// 			wen_buffer = 1    ;
		// 	end
		// 	4'd6   : begin
		// 		if (consume_byte0 && ((ifu_data_buffer_offset == 2'd0) || (ifu_data_buffer_offset == 2'd1))) // wlen > 4 B
		// 			wen_buffer = `ZERO;
		// 		else if (consume_byte2 && (ifu_data_buffer_offset == 2'd0)) // wlen == 8 B
		// 			wen_buffer = `ZERO;
		// 		else
		// 			wen_buffer = 1    ;
		// 	end
		// 	4'd7   : begin
		// 		if (consume_byte0 && ((ifu_data_buffer_offset == 2'd0) || (ifu_data_buffer_offset == 2'd1) || (ifu_data_buffer_offset == 2'd2))) // wlen > 2 B
		// 			wen_buffer = `ZERO;
		// 		else if (consume_byte2 && ((ifu_data_buffer_offset == 2'd0) || (ifu_data_buffer_offset == 2'd1))) // wlen > 4 B
		// 			wen_buffer = `ZERO;
		// 		else if (consume_byte4 && (ifu_data_buffer_offset == 2'd0)) // wlen == 8 B
		// 			wen_buffer = `ZERO;
		// 		else
		// 			wen_buffer = 1    ;
		// 	end
		// 	4'd8   : begin
		// 		if (consume_byte0)
		// 			wen_buffer = `ZERO;
		// 		else if (consume_byte2 && ((ifu_data_buffer_offset == 2'd0) || (ifu_data_buffer_offset == 2'd1) || (ifu_data_buffer_offset == 2'd2))) // wlen > 2 B
		// 			wen_buffer = `ZERO;
		// 		else if (consume_byte4 && ((ifu_data_buffer_offset == 2'd0) || (ifu_data_buffer_offset == 2'd1))) // wlen > 4 B
		// 			wen_buffer = `ZERO;
		// 		else if (consume_byte6 && (ifu_data_buffer_offset == 2'd0)) // wlen == 8 B
		// 			wen_buffer = `ZERO;
		// 		else
		// 			wen_buffer = 1    ;
		// 	end
		// 	default: wen_buffer = 1   ; 
		// endcase

		if (wr_ptr <= 11)
			wen_buffer = 1   ; 
		else
			wen_buffer = 0   ; 
	end

    always @(*) begin
		if (wen_buffer && ifu_data_buffer_valid)
            wr_ptr_dec = {1'b0, pc_inc[3:1]} + {2'b11, ifu_data_buffer_offset}; // consuming byte num / 2 - write buffer len
        else
            wr_ptr_dec = {1'b0, pc_inc[3:1]};
	end

////////////////////////////////////////////////////////////////////////////////////

	always@(*) begin
        instr_dc = buffer[`INSTR0_INDEX_BUS];
    end

    always@(*) begin
    `ifdef C_EXTENSION
        if (is_cinstr == `IS_CINSTR)
            instr_aux = buffer[`INSTR1_INDEX_BUS];
        else
            instr_aux = buffer[`INSTR2_INDEX_BUS];
    `else
        instr_aux = buffer[`INSTR2_INDEX_BUS];
    `endif
    end

	wire [`INSTR_ADDR_BUS] pc_inc_byte0 = (consume_byte0)? `ZERO : `ZERO;
	wire [`INSTR_ADDR_BUS] pc_inc_byte2 = (consume_byte2)? 2 : `ZERO;
	wire [`INSTR_ADDR_BUS] pc_inc_byte4 = (consume_byte4)? 4 : `ZERO;
	wire [`INSTR_ADDR_BUS] pc_inc_byte6 = (consume_byte6)? 6 : `ZERO;
	wire [`INSTR_ADDR_BUS] pc_inc_byte8 = (consume_byte8)? 8 : `ZERO;
	wire [`INSTR_ADDR_BUS] pc_inc = pc_inc_byte0 | pc_inc_byte2 | pc_inc_byte4 | pc_inc_byte6 | pc_inc_byte8;

	always@(posedge clk) begin
		if (rstn == `RESET_EN)
			instr_addr_dc <= `PC_RESET_ADDR                 ;
		else if ((interrupt_taken == `INTERRUPT_TAKEN) || ((is_ecall_instr_wb == `IS_ECALL_INSTR) || (is_mret_instr_wb == `IS_MRET_INSTR))) // time interrupt / ecall / mret
			instr_addr_dc <= exception_entry                ;
		else if ((is_csr_instr_in_wb == `CSR_INSTR_IN_WB) || is_fencei_wb) // csr / fencei
			instr_addr_dc <= flush_entry                    ;
		else if (branch_taken_ex2)
			instr_addr_dc <= branch_jalr_target_pc          ;
        else if ((instr_type[`CJTYPE_INDEX] || instr_type[`JTYPE_INDEX]) && (cancel_instr_dc != `CANCEL_INSTR)) // jal in dc
			instr_addr_dc <= jal_target_pc                  ;
		else
			instr_addr_dc <= instr_addr_dc + pc_inc         ;
    end

	always@(*) begin
		if (is_cinstr == `IS_CINSTR)
			instr_addr_dc_aux = instr_addr_dc + `CINSTR_BYTE_NUM;
		else
			instr_addr_dc_aux = instr_addr_dc + `INSTR_BYTE_NUM ;
    end

	assign cancel_instr_dc = (consume_byte0)? `CANCEL_INSTR : !`CANCEL_INSTR;
	assign cancel_instr_dc_aux = (consume_byte0 || consume_byte2 || (consume_byte4 && (is_cinstr != `IS_CINSTR)))? `CANCEL_INSTR : !`CANCEL_INSTR;

endmodule
