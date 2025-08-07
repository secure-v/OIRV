module compressor4_2 (
    input            x0   ,
    input            x1   ,
    input            x2   ,
    input            x3   ,
    input            cin  ,
    output wire      sum  ,
    output wire      cout ,
    output wire      carry

);

    wire xor_val;

    assign cout = (x1 && x2) || (x2 && x3) || (x1 && x3);
    assign xor_val = x0 ^ x1 ^ x2 ^ x3;
    assign sum  = xor_val ^ cin;
    assign carry = (x0 && (!xor_val)) || (cin && xor_val);

endmodule
