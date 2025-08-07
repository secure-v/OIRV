module CSA3_2 
    #(parameter WIDTH = 32)
(
    input                        cin  ,
    input [WIDTH - 1:0]          A    ,
    input [WIDTH - 1:0]          B    ,
    input [WIDTH - 1:0]          C    ,
    output wire [WIDTH - 1:0]    sum  ,
    output wire [WIDTH - 1:0]    carry
    // output wire                  co   // co = carry_temp[WIDTH - 1];
);

wire [WIDTH - 1:0] carry_temp;

assign sum = A ^ B ^ C;
assign carry_temp = (A & B | (A & C) | (B & C));
assign carry = {carry_temp[WIDTH - 2:0], cin};

endmodule