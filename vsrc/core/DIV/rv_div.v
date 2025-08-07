`include "params.v"

module rv_div (
    input                  clk       ,
    input                  rstn      ,
    input                  hold      ,
    input                  is_op_div ,
    input [`DIV_TYPE_BUS]  div_type  ,
    input [`XLEN_BUS]      rs1_data  ,
    input [`XLEN_BUS]      rs2_data  ,
    output reg             valid     ,
    output reg [`XLEN_BUS] div_res   
);


    reg              start                ;
    reg              valid_tmp            ;
    reg [`XLEN_BUS]  rs1_data_sext        ;
    reg [`XLEN_BUS]  rs2_data_sext        ;
    reg [`XLEN_BUS]  div_op0              ;
    reg [`XLEN_BUS]  div_op1              ;
    wire [`XLEN_BUS] div_res_tmp          ;
    wire [`XLEN_BUS] rem_res_tmp          ;
    wire [`XLEN_BUS] rs1_data_word_sext   ;
    reg [`XLEN_BUS]  div_res_tmp_sext     ;
    reg [`XLEN_BUS]  rem_res_tmp_sext     ;
    wire [`XLEN_BUS] div_res_tmp_word_sext;
    wire [`XLEN_BUS] rem_res_tmp_word_sext;
    
`ifdef RV64
    assign rs1_data_word_sext    = (rs1_data[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, rs1_data[`WORD_FIELD]} : {`WORD_ZEXT, rs1_data[`WORD_FIELD]}                        ;
    assign div_res_tmp_word_sext = (div_res_tmp_sext[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, div_res_tmp_sext[`WORD_FIELD]} : {`WORD_ZEXT, div_res_tmp_sext[`WORD_FIELD]};
    assign rem_res_tmp_word_sext = (rem_res_tmp_sext[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`WORD_ZEXT, rem_res_tmp_sext[`WORD_FIELD]} : {`WORD_ZEXT, rem_res_tmp_sext[`WORD_FIELD]};
`else
    assign rs1_data_word_sext    = rs1_data[`WORD_FIELD];
    assign div_res_tmp_word_sext = div_res_tmp_sext[`WORD_FIELD];
    assign rem_res_tmp_word_sext = rem_res_tmp_sext[`WORD_FIELD];
`endif 
  
    always@(*) begin
        if (is_op_div == `IS_OP_DIV) begin
        `ifdef RV64
            if ((rs1_data[`DWORD_SIGN_BIT] ^ rs2_data[`DWORD_SIGN_BIT]) == `BOOL_TRUE)
        `else
            if ((rs1_data[`WORD_SIGN_BIT] ^ rs2_data[`WORD_SIGN_BIT]) == `BOOL_TRUE)
        `endif
                div_res_tmp_sext = (~div_res_tmp) + 1;
            else
                div_res_tmp_sext = div_res_tmp;
        end
        else
            div_res_tmp_sext = `ZERO;
    end

    always@(*) begin
        if (is_op_div == `IS_OP_DIV) begin
        `ifdef RV64
            if ((rs1_data[`DWORD_SIGN_BIT] == `BOOL_TRUE) && ((div_type == `DIV_REM_TYPE) || (div_type == `DIV_REMW_TYPE)))
        `else
            if ((rs1_data[`WORD_SIGN_BIT] == `BOOL_TRUE) && ((div_type == `DIV_REM_TYPE) || (div_type == `DIV_REMW_TYPE)))
        `endif
                rem_res_tmp_sext = (~rem_res_tmp) + 1;
            else
                rem_res_tmp_sext = rem_res_tmp;
        end
        else
            rem_res_tmp_sext = `ZERO;
    end

    always@(*) begin
        if (is_op_div == `IS_OP_DIV) begin
        `ifdef RV64
            if (rs1_data[`DWORD_SIGN_BIT] == `BOOL_TRUE)
        `else
            if (rs1_data[`WORD_SIGN_BIT] == `BOOL_TRUE)
        `endif
                rs1_data_sext = (~rs1_data) + 1;
            else
                rs1_data_sext = rs1_data;
        end
        else
            rs1_data_sext = `ZERO;
    end

    always@(*) begin
        if (is_op_div == `IS_OP_DIV) begin
        `ifdef RV64
            if (rs2_data[`DWORD_SIGN_BIT] == `BOOL_TRUE)
        `else
            if (rs2_data[`WORD_SIGN_BIT] == `BOOL_TRUE)
        `endif
                rs2_data_sext = (~rs2_data) + 1;
            else
                rs2_data_sext = rs2_data;
        end
        else
            rs2_data_sext = `ZERO;
    end

    always@(*) begin
        if (is_op_div == `IS_OP_DIV) begin
            if (rs2_data == `ZERO) // div 0
                start = !`DIV_START;
        `ifdef RV64
            else if ((rs1_data[`DWORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) // overflow
        `else
            else if ((rs1_data[`WORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) // overflow
        `endif
                start = !`DIV_START;
            else if (valid == `DATA_VALID) // !!!!!
                start = !`DIV_START;
            else
                start = `DIV_START;
        end
        else
            start = !`DIV_START;
    end

    always@(*) begin
        if (is_op_div == `IS_OP_DIV) begin
            if (rs2_data == `ZERO) // div 0
                valid = `DATA_VALID;
        `ifdef RV64
            else if ((rs1_data[`DWORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) // overflow
        `else
            else if ((rs1_data[`WORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) // overflow
        `endif
                valid = `DATA_VALID;
            else
                valid = valid_tmp;
        end
        else
            valid = !`DATA_VALID;
    end

    always@(*) begin
        if (is_op_div == `IS_OP_DIV) begin
            if (rs2_data == `ZERO) // div 0
                div_op0 = `ZERO;
        `ifdef RV64
            else if ((rs1_data[`DWORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) // overflow
        `else
            else if ((rs1_data[`WORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) // overflow
        `endif
                div_op0 = `ZERO;
            else begin
                case (div_type)
                    `DIV_DIV_TYPE  : div_op0 = rs1_data_sext;
                    `DIV_DIVU_TYPE : div_op0 = rs1_data     ;
                    `DIV_REM_TYPE  : div_op0 = rs1_data_sext;
                    `DIV_REMU_TYPE : div_op0 = rs1_data     ;
                `ifdef RV64
                    `DIV_DIVW_TYPE : div_op0 = rs1_data_sext;
                    `DIV_DIVUW_TYPE: div_op0 = rs1_data     ;
                    `DIV_REMW_TYPE : div_op0 = rs1_data_sext;
                    `DIV_REMUW_TYPE: div_op0 = rs1_data     ;
                `endif
                    default        : div_op0 = `ZERO        ;
                endcase
            end
        end
        else
            div_op0 = `ZERO;
    end

    always@(*) begin
        if (is_op_div == `IS_OP_DIV) begin
            if (rs2_data == `ZERO) // div 0
                div_op1 = `ZERO;
        `ifdef RV64
            else if ((rs1_data[`DWORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) // overflow
        `else
            else if ((rs1_data[`WORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) // overflow
        `endif
                div_op1 = `ZERO;
            else begin
                case (div_type)
                    `DIV_DIV_TYPE  : div_op1 = rs2_data_sext;
                    `DIV_DIVU_TYPE : div_op1 = rs2_data     ;
                    `DIV_REM_TYPE  : div_op1 = rs2_data_sext;
                    `DIV_REMU_TYPE : div_op1 = rs2_data     ;
                `ifdef RV64
                    `DIV_DIVW_TYPE : div_op1 = rs2_data_sext;
                    `DIV_DIVUW_TYPE: div_op1 = rs2_data     ;
                    `DIV_REMW_TYPE : div_op1 = rs2_data_sext;
                    `DIV_REMUW_TYPE: div_op1 = rs2_data     ;
                `endif
                    default        : div_op1 = `ZERO        ;
                endcase
            end
        end
        else
            div_op1 = `ZERO;
    end

    always@(*) begin
        if (is_op_div == `IS_OP_DIV) begin
            if (rs2_data == `ZERO) begin // div 0
                case (div_type)
                    `DIV_DIV_TYPE  : div_res = ~(`XLEN'd`ZERO)   ;
                    `DIV_DIVU_TYPE : div_res = ~(`XLEN'd`ZERO)   ;
                    `DIV_REM_TYPE  : div_res = rs1_data          ;
                    `DIV_REMU_TYPE : div_res = rs1_data          ;
                `ifdef RV64
                    `DIV_DIVW_TYPE : div_res = ~(`XLEN'd`ZERO)   ;
                    `DIV_DIVUW_TYPE: div_res = ~(`XLEN'd`ZERO)   ;
                    `DIV_REMW_TYPE : div_res = rs1_data_word_sext;
                    `DIV_REMUW_TYPE: div_res = rs1_data_word_sext;
                `endif
                    default        : div_res = `ZERO             ;
                endcase
            end
        `ifdef RV64
            else if ((rs1_data[`DWORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) begin // overflow
        `else
            else if ((rs1_data[`WORD_SIGN_BIT] == `BOOL_TRUE) && (rs1_data[`XLEN - 2:0] == `ZERO) && (rs2_data == (~(`XLEN'd`ZERO)))) begin // overflow
        `endif
                case (div_type)
                    `DIV_DIV_TYPE  : div_res = {1'b1, `DIV_LOW_ZEXT}     ;
                    `DIV_DIVU_TYPE : div_res = `ZERO                     ;
                    `DIV_REM_TYPE  : div_res = `ZERO                     ;
                    `DIV_REMU_TYPE : div_res = {1'b1, `DIV_LOW_ZEXT}     ;
                `ifdef RV64
                    `DIV_DIVW_TYPE : div_res = `ZERO                     ;
                    `DIV_DIVUW_TYPE: div_res = `ZERO                     ;
                    `DIV_REMW_TYPE : div_res = `ZERO                     ;
                    `DIV_REMUW_TYPE: div_res = `ZERO                     ;
                `endif
                    default        : div_res = `ZERO                     ;
                endcase
            end
            else begin
                case (div_type)
                    `DIV_DIV_TYPE  : div_res = div_res_tmp_sext     ;
                    `DIV_DIVU_TYPE : div_res = div_res_tmp          ;
                    `DIV_REM_TYPE  : div_res = rem_res_tmp_sext     ;
                    `DIV_REMU_TYPE : div_res = rem_res_tmp          ;
                `ifdef RV64
                    `DIV_DIVW_TYPE : div_res = div_res_tmp_word_sext;
                    `DIV_DIVUW_TYPE: div_res = div_res_tmp_word_sext;
                    `DIV_REMW_TYPE : div_res = rem_res_tmp_word_sext;
                    `DIV_REMUW_TYPE: div_res = rem_res_tmp_word_sext;
                `endif
                    default        : div_res = `ZERO                ;
                endcase
            end
        end
        else
            div_res = `ZERO;
    end

`ifdef VERILATOR_SIM
    assign valid_tmp = `DATA_VALID;
    assign div_res_tmp = div_op0 / div_op1;
    assign rem_res_tmp = div_op0 % div_op1;
`else
    `ifdef RV64
    srt4_64 srt4_64_inst0 (
        .clk     (clk        ),
        .rstn    (rstn       ),
        .hold    (hold       ),
        .dividend(div_op0    ),
        .divisor (div_op1    ),
        .start   (start      ),
        .valid   (valid_tmp  ),
        .q       (div_res_tmp),
        .rem     (rem_res_tmp)
);
    `else
    srt4_32 srt4_32_inst0 (
        .clk     (clk        ),
        .rstn    (rstn       ),
        .hold    (hold       ),
        .dividend(div_op0    ),
        .divisor (div_op1    ),
        .start   (start      ),
        .valid   (valid_tmp  ),
        .q       (div_res_tmp),
        .rem     (rem_res_tmp)
);
    `endif
`endif
    
endmodule
