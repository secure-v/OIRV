`include "params.v"

module ifu (
    input                         clk            ,
    input                         rstn           ,

    // ------------- signal group with core ---------------- //
    input [`INSTR_ADDR_BUS]          next_instr_addr,
    // input [`DATA_ADDR_BUS]        data_addr_in   ,
    // input                         rdata_en_in    ,
    // input                         wdata_en_in    ,
    // input [`XLEN_BUS]             wdata_in       ,
    // input [`WLEN_BUS]             wlen_in        ,
    // output reg                    wdata_ready_out,
    // output reg [`XLEN_BUS]        rdata_out      ,
    // output reg                    rdata_valid_out,
    input [`INSTR_ADDR_BUS]            instr_addr   ,
	output reg [`CACHE_LINE_BUS]       ifu_data     ,
    output                             ifu_miss     ,
	output                             instr_valid  ,
    input                              fencei_flush ,
    // ------------- signal group with memeory ------------- //
    output reg [`DATA_ADDR_BUS]   data_addr_out  ,
    output reg                    rdata_en_out   ,
    output                        wdata_en_out   ,
    output [`CACHE_LINE_BUS]      wdata_out      ,
    output [`WLEN_BUS]            wlen_out       ,
    input                         wdata_ready_in ,
    input [`CACHE_LINE_BUS]       rdata_in       ,
    input                         rdata_valid_in 
);

    wire [`DATA_ADDR_BUS]        data_addr_in   ;
    wire                         rdata_en_in    ;
    // wire                         wdata_en_in    ;
    // wire [`XLEN_BUS]             wdata_in       ;
    // wire [`WLEN_BUS]             wlen_in        ;
    // wire                         wdata_ready_out;
    reg                          rdata_valid_out;

    assign data_addr_in = instr_addr;
    assign rdata_en_in = `RDATA_EN;
    assign ifu_miss = (lsu_state == LSU_MISS_STATE);     
    assign instr_valid = rdata_valid_out;

    always @(*) begin
        if (lsu_state == LSU_WRTE_STATE)
            ifu_data = wcache_data    ;
        else
            ifu_data = cache_line_data;
    end

    // ----------------------- cache ----------------------- //
    wire [`CACHE_TAG_BUS]             cache_tag            ;
    wire [`ENTRY_INDEX_BUS]           cache_entry          ;
    wire [`ENTRY_INDEX_BUS]           next_cache_entry     ;
    wire [`CACHE_LINE_BUS]            wcache_data          ;
    reg                               ren                  ;
    reg                               wen                  ;
    wire                              hit                  ;
    wire [`CACHE_LINE_BUS]            cache_line_data      ;
    // ===================================================== //

    wire [`DATA_ADDR_BUS] data_addr_in_rw_align = {data_addr_in[`INSTR_ADDR_BUS_WIDTH - 1:3], 3'b000};

    assign cache_tag = data_addr_in_rw_align[`CACHE_TAG_FIELD];
    assign cache_entry = data_addr_in_rw_align[`CACHE_ENTRY_FIELD];
    assign next_cache_entry = (lsu_state == LSU_MISS_STATE)? cache_entry : next_instr_addr[`CACHE_ENTRY_FIELD]; // lsu_state == LSU_MISS_STATE: write to the current cacheline
    assign wcache_data = rdata_in;

    always @(*) begin
        ren = `RDATA_EN;
    end

    always @(*) begin
        if ((rdata_en_in == `RDATA_EN) && (hit == `CACHE_HIT))
            wen = !`WDATA_EN;
        else if ((lsu_state == LSU_MISS_STATE) && (rdata_en_out == `RDATA_EN) && (rdata_valid_in == `RDATA_VALID))
            wen = `WDATA_EN;
        else
            wen = !`WDATA_EN;
    end

    always @(*) begin
        if (rdata_en_in == `RDATA_EN) begin
            if ((hit == `CACHE_HIT) && (lsu_state != LSU_MISS_STATE))
                rdata_valid_out = `RDATA_VALID;
            else
               rdata_valid_out = !`RDATA_VALID;
        end
        else
            rdata_valid_out = `RDATA_VALID;
    end

    parameter LSU_IDLE_STATE = 2'd0; // idle state: read / write cache
    parameter LSU_MISS_STATE = 2'd1; // cache miss state: cache miss
    parameter LSU_WRTE_STATE = 2'd2;

    reg[1:0] lsu_state;

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            lsu_state <= LSU_IDLE_STATE;
        else if ((lsu_state == LSU_MISS_STATE) && (rdata_en_out == `RDATA_EN) && (rdata_valid_in == `RDATA_VALID))
            lsu_state <= LSU_WRTE_STATE;
        else if ((rdata_en_in == `RDATA_EN) && (hit == !`CACHE_HIT)) // read miss
            lsu_state <= LSU_MISS_STATE;
        else if (lsu_state == LSU_WRTE_STATE)
            lsu_state <= LSU_IDLE_STATE;
        else if ((rdata_en_in == `RDATA_EN) && (hit == `CACHE_HIT) || (rdata_en_in != `RDATA_EN))
            lsu_state <= LSU_IDLE_STATE;
        else
            lsu_state <= lsu_state;
    end

    assign wdata_out = `ZERO;
    assign wdata_en_out = !`WDATA_EN;

    always @(*) begin
        data_addr_out = data_addr_in_rw_align  ;
    end

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            rdata_en_out <= !`RDATA_EN;
        else if ((rdata_en_in == `RDATA_EN) && (hit == !`CACHE_HIT)) // read miss
            rdata_en_out <= `RDATA_EN;
        else if ((lsu_state == LSU_MISS_STATE) && (rdata_en_out == `RDATA_EN) && (rdata_valid_in == `RDATA_VALID))
            rdata_en_out <= !`RDATA_EN;
        else if ((rdata_en_in == `RDATA_EN) && (hit == `CACHE_HIT))
            rdata_en_out <= !`RDATA_EN;
        else if (rdata_en_in != `RDATA_EN)
            rdata_en_out <= !`RDATA_EN;
        else
            rdata_en_out <= rdata_en_out;
    end

    assign wlen_out = `WLEN_DWORD;


icache icache_inst0 (
        .clk                 (clk                 ),
        .rstn                (rstn                ),
        .fencei_flush        (fencei_flush        ),
        .cache_tag           (cache_tag           ),
        .cache_entry         (cache_entry         ),
        .next_cache_entry    (next_cache_entry    ),
        .wcache_data         (wcache_data         ),
        .ren                 (ren                 ),     
        .wen                 (wen                 ),
        .hit                 (hit                 ),
        .cache_line_data     (cache_line_data     )
);

endmodule
