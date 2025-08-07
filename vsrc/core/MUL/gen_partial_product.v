module gen_partial_product 
    #(parameter WIDTH = 64)
(
    input [WIDTH - 1:0]      A   ,
    input                    b0  ,
    input                    b1  ,
    input                    b2  ,
    output reg               sign,
    output reg [WIDTH:0]     P     
);

    wire [2:0] booth_code;
    wire [WIDTH:0] zero_ext;
    wire [WIDTH:0] one_ext; 
    wire [WIDTH:0] two_ext;  
    wire [WIDTH:0] neg_ext;  
    wire [WIDTH:0] negtwo_ext;

    assign booth_code = {b2, b1, b0};
    assign zero_ext   = 1 << WIDTH;
    assign one_ext    = {~A[WIDTH - 1], A};
    assign two_ext    = {~A[WIDTH - 1], A[WIDTH - 2:0], 1'b0};
    assign neg_ext    = {A[WIDTH - 1], ~A};
    assign negtwo_ext = {A[WIDTH - 1], ~A[WIDTH - 2:0], 1'b1};

    always @(*) begin
        case (booth_code)
            3'b000 : begin 
                sign = 1'b0;
                P = zero_ext;
                end 
            3'b001 : begin 
                sign = 1'b0;
                P = one_ext;
                end 
            3'b010 : begin 
                sign = 1'b0;
                P = one_ext;
                end 
            3'b011 : begin 
                sign = 1'b0;
                P = two_ext;
                end 
            3'b100 : begin 
                sign = 1'b1;
                P = negtwo_ext;
                end 
            3'b101 : begin 
                sign = 1'b1;
                P = neg_ext;
                end 
            3'b110 : begin 
                sign = 1'b1;
                P = neg_ext;
                end 
            3'b111 : begin 
                sign = 1'b0;
                P = zero_ext;
                end
        endcase
    end

endmodule
