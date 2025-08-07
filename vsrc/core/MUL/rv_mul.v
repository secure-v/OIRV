`include "params.v"

module rv_mul (
    input                        clk          ,
    input [`MUL_TYPE_BUS]        mul_type     ,
    input [`XLEN_BUS]            rs1_data     ,
    input [`XLEN_BUS]            rs2_data     ,
    output [`XLEN * 2 - 1:0]     part_mul_res0,
    output [`XLEN * 2 - 1:0]     part_mul_res1     
);


    wire [`XLEN:0] mul_op0;
    wire [`XLEN:0] mul_op1;
    wire [`XLEN * 2 - 1:0] mul_res_tmp = part_mul_res0 + part_mul_res1;
    
`ifdef RV64
    assign mul_op0 = (mul_type == `MUL_MULHU_TYPE)? {1'b0, rs1_data} : (((mul_type == `MUL_MUL_TYPE) || (mul_type == `MUL_MULH_TYPE) || (mul_type == `MUL_MULHSU_TYPE) || (mul_type == `MUL_MULW_TYPE))? {rs1_data[`XLEN - 1], rs1_data} : `ZERO);
    assign mul_op1 = ((mul_type == `MUL_MULHU_TYPE) || (mul_type == `MUL_MULHSU_TYPE))? {1'b0, rs2_data} : (((mul_type == `MUL_MUL_TYPE) || (mul_type == `MUL_MULH_TYPE) || (mul_type == `MUL_MULW_TYPE))? {rs2_data[`XLEN - 1], rs2_data} : `ZERO);
`else
    assign mul_op0 = (mul_type == `MUL_MULHU_TYPE)? {1'b0, rs1_data} : (((mul_type == `MUL_MUL_TYPE) || (mul_type == `MUL_MULH_TYPE) || (mul_type == `MUL_MULHSU_TYPE))? {rs1_data[`XLEN - 1], rs1_data} : `ZERO);
    assign mul_op1 = ((mul_type == `MUL_MULHU_TYPE) || (mul_type == `MUL_MULHSU_TYPE))? {1'b0, rs2_data} : (((mul_type == `MUL_MUL_TYPE) || (mul_type == `MUL_MULH_TYPE))? {rs2_data[`XLEN - 1], rs2_data} : `ZERO);
`endif 
    
`ifdef VERILATOR_SIM
    wire signed [`XLEN:0] mul_op0_signed;
    wire signed [`XLEN:0] mul_op1_signed;
    wire signed [`XLEN * 2 + 1:0] mul_res_tmp_signed;

    assign mul_op0_signed = mul_op0;
    assign mul_op1_signed = mul_op1;
    assign mul_res_tmp_signed = mul_op0_signed * mul_op1_signed;
    assign part_mul_res0 = {`XLEN'd`ZERO, mul_res_tmp_signed[`XLEN - 1:0]};
    assign part_mul_res1 = {mul_res_tmp_signed[2 * `XLEN - 1:`XLEN], `XLEN'd`ZERO}; // seperate into two part for debug
`else
    `ifdef RV64
        MUL65 MUL65_inst0 (
            .A             (mul_op0      ),
            .B             (mul_op1      ),
            // .mul           (mul_res_tmp  ),
            .part_mul_res0 (part_mul_res0), 
            .part_mul_res1 (part_mul_res1)
        );
    `else
        MUL33 MUL33_inst0 (
            .A             (mul_op0      ),
            .B             (mul_op1      ),
            // .mul           (mul_res_tmp  ),
            .part_mul_res0 (part_mul_res0), 
            .part_mul_res1 (part_mul_res1)
        );
    `endif
`endif
    
endmodule
