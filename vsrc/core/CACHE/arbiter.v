`include "params.v"

module arbiter (
    input                         clk             ,
    input                         rstn            ,

    // ----------------- signal group 0 ------------------- //
    input [`DATA_ADDR_BUS]        data_addr_in0   ,
    input                         rdata_en_in0    ,
    input                         wdata_en_in0    ,
    input [`XLEN_BUS]             wdata_in0       ,
    input [`WLEN_BUS]             wlen_in0        ,
    output reg                    wdata_ready_out0,
    output [`XLEN_BUS]            rdata_out0      ,
    output reg                    rdata_valid_out0,

    // ----------------- signal group 1 ------------------- //
    input [`DATA_ADDR_BUS]        data_addr_in1   ,
    input                         rdata_en_in1    ,
    input                         wdata_en_in1    ,
    input [`XLEN_BUS]             wdata_in1       ,
    input [`WLEN_BUS]             wlen_in1        ,
    output reg                    wdata_ready_out1,
    output [`XLEN_BUS]            rdata_out1      ,
    output reg                    rdata_valid_out1,

    // ------------- signal group with memeory ------------- //
    output reg [`DATA_ADDR_BUS]   data_addr_out   ,
    output reg                    rdata_en_out    ,
    output reg                    wdata_en_out    ,
    output reg [`XLEN_BUS]        wdata_out       ,
    output reg [`WLEN_BUS]        wlen_out        ,
    input                         wdata_ready_in  ,
    input [`XLEN_BUS]             rdata_in        ,
    input                         rdata_valid_in  
);
    
    assign rdata_out0 = rdata_in;
    assign rdata_out1 = rdata_in;

    always @(*) begin
        if ((rdata_en_in0 == `RDATA_EN) || (wdata_en_in0 == `WDATA_EN)) begin
            data_addr_out  = data_addr_in0   ;
            rdata_en_out   = rdata_en_in0    ;
            wdata_en_out   = wdata_en_in0    ;
            wdata_out      = wdata_in0       ;
            wlen_out       = wlen_in0        ;
        end
        else begin
            data_addr_out  = data_addr_in1   ;
            rdata_en_out   = rdata_en_in1    ;
            wdata_en_out   = wdata_en_in1    ;
            wdata_out      = wdata_in1       ;
            wlen_out       = wlen_in1        ;
        end
    end


    always @(*) begin
        if ((rdata_en_in0 == `RDATA_EN) || (wdata_en_in0 == `WDATA_EN)) begin
            wdata_ready_out0 = wdata_ready_in ;
            wdata_ready_out1 = !`WDATA_READY  ;
        end
        else begin
            wdata_ready_out0 = !`WDATA_READY  ;
            wdata_ready_out1 = wdata_ready_in ;
        end
    end

        always @(*) begin
        if ((rdata_en_in0 == `RDATA_EN) || (wdata_en_in0 == `WDATA_EN)) begin
            rdata_valid_out0 = rdata_valid_in ;
            rdata_valid_out1 = !`RDATA_VALID  ;
        end
        else begin
            rdata_valid_out0 = !`RDATA_VALID  ;
            rdata_valid_out1 = rdata_valid_in ;
        end
    end

endmodule