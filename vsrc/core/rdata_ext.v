`include "params.v"

module rdata_ext (
	input     [`XLEN_BUS]      rdata     ,
	input     [`FUNC3_BUS]     func3     ,
	`ifdef C_EXTENSION
	input		               is_cinstr ,
	`endif
	output reg [`XLEN_BUS]     ext_rdata  
);

	wire [`XLEN_BUS] byte_zext_data;
	wire [`XLEN_BUS] half_zext_data;
	wire [`XLEN_BUS] word_zext_data;
	wire [`XLEN_BUS] byte_sext_data;
	wire [`XLEN_BUS] half_sext_data;
	wire [`XLEN_BUS] word_sext_data;


	assign byte_zext_data = {`RDATA_BYTE_ZEXT, rdata[`RDATA_BYTE_FIELD]};
	assign half_zext_data = {`RDATA_HALF_ZEXT, rdata[`RDATA_HALF_FIELD]};
`ifdef RV64
	assign word_zext_data = {`RDATA_WORD_ZEXT, rdata[`RDATA_WORD_FIELD]};
`else
	assign word_zext_data = rdata[`RDATA_WORD_FIELD];
`endif
	assign byte_sext_data = (rdata[`BYTE_SIGN_BIT] == `BOOL_TRUE)? {~`RDATA_BYTE_ZEXT, rdata[`RDATA_BYTE_FIELD]} : byte_zext_data;
	assign half_sext_data = (rdata[`HALF_SIGN_BIT] == `BOOL_TRUE)? {~`RDATA_HALF_ZEXT, rdata[`RDATA_HALF_FIELD]} : half_zext_data;
`ifdef RV64
	assign word_sext_data = (rdata[`WORD_SIGN_BIT] == `BOOL_TRUE)? {~`RDATA_WORD_ZEXT, rdata[`RDATA_WORD_FIELD]} : word_zext_data;
`else
	assign word_sext_data = word_zext_data;
`endif

	wire is_cinstr_load_word = func3[1]; // instr[13]

    wire [`XLEN_BUS] byte_sext_data_or_val = (func3 == `FUNC3_000)? byte_sext_data : `ZERO;
    wire [`XLEN_BUS] half_sext_data_or_val = (func3 == `FUNC3_001)? half_sext_data : `ZERO;
    wire [`XLEN_BUS] word_sext_data_or_val = ((func3 == `FUNC3_010) || ((is_cinstr == `IS_CINSTR) && (!is_cinstr_load_word)))? word_sext_data : `ZERO;

	wire [`XLEN_BUS] rdata_or_val = ((func3 == `FUNC3_011) || ((is_cinstr == `IS_CINSTR) && is_cinstr_load_word))? rdata : `ZERO;
    wire [`XLEN_BUS] byte_zext_data_or_val = (func3 == `FUNC3_100)? byte_zext_data : `ZERO;
    wire [`XLEN_BUS] half_zext_data_or_val = (func3 == `FUNC3_101)? half_zext_data : `ZERO;
    wire [`XLEN_BUS] word_zext_data_or_val = (func3 == `FUNC3_110)? word_zext_data : `ZERO;

    always@(*) begin
		ext_rdata = byte_sext_data_or_val | half_sext_data_or_val | word_sext_data_or_val | rdata_or_val | byte_zext_data_or_val | half_zext_data_or_val | word_zext_data_or_val;
    end

// `ifdef C_EXTENSION
// 	wire is_cinstr_load_word = func3[1]; // instr[13]

// 	always@(*) begin
// 		if (is_cinstr == `IS_CINSTR) begin
// 			case(is_cinstr_load_word)
// 				1'b0 : ext_rdata = word_sext_data; // c.lw
// 				1'b1 : ext_rdata = rdata         ; // c.ld RV64C
// 			    default    : ext_rdata = rdata   ; // x is better
// 			endcase
// 		end
// 		else begin
// 			case(func3)
// 				`FUNC3_000 : ext_rdata = byte_sext_data; // lb
// 				`FUNC3_001 : ext_rdata = half_sext_data; // lh
// 				`FUNC3_010 : ext_rdata = word_sext_data; // lw
// 				`FUNC3_011 : ext_rdata = rdata         ; // ld RV64I
// 				`FUNC3_100 : ext_rdata = byte_zext_data; // lbu	
// 				`FUNC3_101 : ext_rdata = half_zext_data; // lhu
// 				`FUNC3_110 : ext_rdata = word_zext_data; // lwu	RV64I		
// 			    default    : ext_rdata = rdata         ; // x is better
// 			endcase
// 		end
// 	end
// `else
// 	always@(*) begin
// 		case(func3)
// 			`FUNC3_000 : ext_rdata = byte_sext_data; // lb
// 			`FUNC3_001 : ext_rdata = half_sext_data; // lh
// 			`FUNC3_010 : ext_rdata = word_sext_data; // lw
// 			`FUNC3_011 : ext_rdata = rdata         ; // ld RV64I
// 			`FUNC3_100 : ext_rdata = byte_zext_data; // lbu	
// 			`FUNC3_101 : ext_rdata = half_zext_data; // lhu
// 			`FUNC3_110 : ext_rdata = word_zext_data; // lwu	RV64I		
// 		    default    : ext_rdata = rdata         ; // x is better
// 		endcase
// 	end
// `endif

endmodule
