`include "params.v"

module cached_mem (
    input                         clk            ,
    input                         rstn           ,
    input                         hold           ,
    input [`DATA_ADDR_BUS]        data_addr_ex2  ,
    input                         rdata_en_ex2   ,
    input                         is_cache_mem   ,
    input                         is_device_write,
    
    input                         is_fencei           ,
    output                        fencei_stall        ,
    output                        fencei_flush        ,
    // ------------- signal group with core ---------------- //
    input [`DATA_ADDR_BUS]        data_addr_in   ,
    input                         rdata_en_in    ,
    input                         wdata_en_in    ,
    input [`CACHE_LINE_BUS]       wdata_in       ,
    input [`WLEN_BUS]             wlen_in        ,
    input [`RLEN_BUS]             rlen_in        ,
    output reg                    wdata_ready_out,
    output reg [`CACHE_LINE_BUS]  rdata_out      ,
    output reg                    rdata_valid_out,

    // --------------- signal group with mem --------------- //
    output reg [`DATA_ADDR_BUS]   data_addr_out  ,
    output reg                    rdata_en_out   ,
    output reg                    wdata_en_out   ,
    output reg [`CACHE_LINE_BUS]  wdata_out      ,
    output reg [`WLEN_BUS]        wlen_out       ,
    input                         wdata_ready_in ,
    input [`CACHE_LINE_BUS]       rdata_in       ,
    input                         rdata_valid_in 
);
 
    always @(*) begin
        if (is_cache_mem == `IS_CACHE_MEM) begin
            lsu_rdata_en_in  = rdata_en_in         ;
            lsu_wdata_en_in  = wdata_en_in         ;
            wdata_ready_out  = lsu_wdata_ready_out ;
            rdata_out        = lsu_rdata_out       ;
            rdata_valid_out  = lsu_rdata_valid_out ;
            data_addr_out    = lsu_data_addr_out   ;
            rdata_en_out     = lsu_rdata_en_out    ;
            wdata_en_out     = lsu_wdata_en_out    ;
            wdata_out        = lsu_wdata_out       ;
            wlen_out         = lsu_wlen_out        ;
        end
        else begin
            lsu_rdata_en_in  = !`RDATA_EN          ;
            lsu_wdata_en_in  = !`WDATA_EN          ;

            if (is_device_write)
                wdata_ready_out  = `WDATA_READY        ;
            else 
                wdata_ready_out  = wdata_ready_in      ;

            rdata_out        = rdata_in            ; 
            rdata_valid_out  = rdata_valid_in      ; 
            data_addr_out    = data_addr_in        ; 
            rdata_en_out     = rdata_en_in         ; 
            wdata_en_out     = wdata_en_in         ; 
            wdata_out        = wdata_in            ; 
            wlen_out         = wlen_in             ;
        end
    end

    wire [`DATA_ADDR_BUS]   lsu_data_addr_in   ;
    reg                     lsu_rdata_en_in    ;
    reg                     lsu_wdata_en_in    ;
    wire [`CACHE_LINE_BUS]  lsu_wdata_in       ;
    wire [`WLEN_BUS]        lsu_wlen_in        ;
    wire [`RLEN_BUS]        lsu_rlen_in        ;
    wire                    lsu_wdata_ready_out;
    wire [`CACHE_LINE_BUS]  lsu_rdata_out      ;
    wire                    lsu_rdata_valid_out;
    wire [`DATA_ADDR_BUS]   lsu_data_addr_out  ;
    wire                    lsu_rdata_en_out   ;
    wire                    lsu_wdata_en_out   ;
    wire [`CACHE_LINE_BUS]  lsu_wdata_out      ;
    wire [`WLEN_BUS]        lsu_wlen_out       ;
    wire                    lsu_wdata_ready_in ;
    wire [`CACHE_LINE_BUS]  lsu_rdata_in       ;
    wire                    lsu_rdata_valid_in ;

    assign lsu_data_addr_in = data_addr_in;
    assign lsu_wdata_in = wdata_in;
    assign lsu_wlen_in = wlen_in;
    assign lsu_rlen_in = rlen_in;

    assign lsu_wdata_ready_in = wdata_ready_in;
    assign lsu_rdata_in = rdata_in;
    assign lsu_rdata_valid_in = rdata_valid_in;

lsu lsu_inst0 (
    .clk            (clk                ),
    .rstn           (rstn               ),
    .hold           (hold               ),
    .data_addr_ex2  (data_addr_ex2      ),
	.rdata_en_ex2   (rdata_en_ex2       ),
    .is_fencei           (is_fencei           ),
    .fencei_stall        (fencei_stall        ),
    .fencei_flush        (fencei_flush        ),
    
    .data_addr_in   (lsu_data_addr_in   ),
    .rdata_en_in    (lsu_rdata_en_in    ),
    .wdata_en_in    (lsu_wdata_en_in    ),
    .wdata_in       (lsu_wdata_in       ),
    .wlen_in        (lsu_wlen_in        ),
    .rlen_in        (lsu_rlen_in        ),
    .wdata_ready_out(lsu_wdata_ready_out),
    .rdata_out      (lsu_rdata_out      ),
    .rdata_valid_out(lsu_rdata_valid_out),
    .data_addr_out  (lsu_data_addr_out  ),
    .rdata_en_out   (lsu_rdata_en_out   ),
    .wdata_en_out   (lsu_wdata_en_out   ),
    .wdata_out      (lsu_wdata_out      ),
    .wlen_out       (lsu_wlen_out       ),
    .wdata_ready_in (lsu_wdata_ready_in ),
    .rdata_in       (lsu_rdata_in       ),
    .rdata_valid_in (lsu_rdata_valid_in )
);

endmodule


