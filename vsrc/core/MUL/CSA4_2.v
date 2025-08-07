module CSA4_2 
    #(parameter WIDTH = 32)
(
    input                        cin  ,
    input [WIDTH - 1:0]          A    ,
    input [WIDTH - 1:0]          B    ,
    input [WIDTH - 1:0]          C    ,
    input [WIDTH - 1:0]          D    ,
    output wire [WIDTH - 1:0]    sum  ,
    output wire [WIDTH - 1:0]    carry
    // output wire                  co   
);

    wire [WIDTH - 1:0] cout;
    // assign co = cout[WIDTH - 1];
    
    compressor4_2 compressor4_2_insts0 (
                .x0   (A[0]    ),
                .x1   (B[0]    ),
                .x2   (C[0]    ),
                .x3   (D[0]    ),
                .cin  (cin     ),
                .sum  (sum[0]  ),
                .cout (cout[0] ),
                .carry(carry[0])
    );

    genvar i;
    generate
        for (i = 1; i < WIDTH; i++) begin: inst_csr4_2
            compressor4_2 compressor4_2_inst (
                .x0   (A[i]       ),
                .x1   (B[i]       ),
                .x2   (C[i]       ),
                .x3   (D[i]       ),
                .cin  (cout[i - 1]),
                .sum  (sum[i]     ),
                .cout (cout[i]    ),
                .carry(carry[i]   )
            );
        end
    endgenerate
endmodule