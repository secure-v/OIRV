`include "params.v"

module lsu (
    input                         clk            ,
    input                         rstn           ,
    input                         hold           ,
    input [`DATA_ADDR_BUS]        data_addr_ex2  ,
    input                         rdata_en_ex2   ,
    input                         is_fencei           ,
    output                        fencei_stall        ,
    output                        fencei_flush        ,
    // ------------- signal group with core ---------------- //
    input [`DATA_ADDR_BUS]        data_addr_in   , // data address
    input                         rdata_en_in    , // read data enable
    input                         wdata_en_in    , // write data enable
    input [`CACHE_LINE_BUS]       wdata_in       , // write data
    input [`WLEN_BUS]             wlen_in        , // write length
    input [`RLEN_BUS]             rlen_in        , // read length
    output reg                    wdata_ready_out, // write data successfully
    output reg [`CACHE_LINE_BUS]  rdata_out      , // the required read data
    output reg                    rdata_valid_out, // read data valid

    // ------------- signal group with memeory ------------- //
    output reg [`DATA_ADDR_BUS]   data_addr_out  ,
    output                        rdata_en_out   ,
    output                        wdata_en_out   ,
    output reg [`CACHE_LINE_BUS]  wdata_out      ,
    output [`WLEN_BUS]            wlen_out       ,
    input                         wdata_ready_in ,
    input [`CACHE_LINE_BUS]       rdata_in       ,
    input                         rdata_valid_in 
);

    // ----------------------- cache ----------------------- //
    wire [`CACHE_TAG_BUS]             cache_tag            ;
    reg [`ENTRY_INDEX_BUS]            data_entry           ;
    wire [`ENTRY_INDEX_BUS]           cache_entry          ;
    reg [`CACHE_LINE_BUS]             wcache_mask          ;
    reg [`CACHE_LINE_BUS]             wcache_data          ;
    reg                               ren                  ;
    reg                               wen                  ;
    reg                               ren_cache            ;
    reg                               wdirty               ;
    wire                              hit                  ;
    wire                              wen_mem              ;
    wire [`CACHE_LINE_BUS]            cache_line_data      ;
    wire [`CACHE_LINE_BUS]            wmem_cache_line_data ;
    wire [`DATA_ADDR_BUS]             wmem_cache_line_addr ;
    // ===================================================== //

    assign cache_tag = data_addr_in_rw_twice[`CACHE_TAG_FIELD];
    assign cache_entry = data_addr_in_rw_twice[`CACHE_ENTRY_FIELD];
//////////////////////////////////////////////////////////////////////////////
    wire rw_twice;
    reg [1:0] rw_stage;
    reg [`DATA_ADDR_BUS] data_addr_in_rw_twice;
    reg [`CACHE_LINE_BUS] misalign_rdata_out;
    reg [`CACHE_LINE_BUS] wdata_in_rw_twice;
    reg [`CACHE_LINE_BUS] wmask_in_rw_twice;

    parameter RW_STAGE0 = 2'd0;
    parameter RW_STAGE1 = 2'd1;
    parameter RW_STAGE2 = 2'd2;

    assign rw_twice = (((rdata_en_in == `RDATA_EN) && (((rlen_in == `RLEN_HALF) && (data_addr_in[2:0] == 3'b111)) || ((rlen_in == `RLEN_WORD) && (data_addr_in[2:0] > 3'b100)) || ((rlen_in == `RLEN_DWORD) && (data_addr_in[2:0] != `ZERO)))) || ((wdata_en_in == `WDATA_EN) && (((wlen_in == `WLEN_HALF) && (data_addr_in[2:0] == 3'b111)) || ((wlen_in == `WLEN_WORD) && (data_addr_in[2:0] > 3'b100)) || ((wlen_in == `WLEN_DWORD) && (data_addr_in[2:0] != `ZERO)))))? `RW_TWICE : !`RW_TWICE;

    reg misalign_wdata_ready_out;
    reg misalign_rdata_valid_out;

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            rw_stage <= RW_STAGE0;
        else if ((misalign_rdata_valid_out == `RDATA_VALID) || (misalign_wdata_ready_out == `WDATA_READY))
            rw_stage <= RW_STAGE0;
        else if ((rw_twice == `RW_TWICE) && (rw_stage == RW_STAGE1)) begin
            if (((rdata_en_in == `RDATA_EN) && (rcache_valid == `RDATA_VALID)) || ((wdata_en_in == `WDATA_EN) && (hit == `CACHE_HIT)))
                rw_stage <= RW_STAGE2;
            else
                rw_stage <= RW_STAGE1;
        end
        else if ((rw_twice == `RW_TWICE) && (rw_stage == RW_STAGE2)) begin
            if (((rdata_en_in == `RDATA_EN) && (rcache_valid == `RDATA_VALID)) || ((wdata_en_in == `WDATA_EN) && (hit == `CACHE_HIT)))
                rw_stage <= RW_STAGE0;
            else
                rw_stage <= RW_STAGE2;
        end
        else if (((rdata_en_in == `RDATA_EN) || (wdata_en_in == `WDATA_EN)) && (rw_twice == `RW_TWICE))
            rw_stage <= RW_STAGE1;
        else
            rw_stage <= rw_stage;
    end

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            misalign_rdata_valid_out <= !`RDATA_VALID;
        else if ((rdata_en_in == `RDATA_EN) && (rcache_valid == `RDATA_VALID) && (rw_stage == RW_STAGE2))
            misalign_rdata_valid_out <=  `RDATA_VALID;
        else if (hold == `HOLD)
            misalign_rdata_valid_out <= misalign_rdata_valid_out;
        else
            misalign_rdata_valid_out <= !`RDATA_VALID;
    end

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            misalign_wdata_ready_out <= !`WDATA_READY;
        else if ((wdata_en_in == `WDATA_EN) && (hit == `CACHE_HIT) && (rw_stage == RW_STAGE2))
            misalign_wdata_ready_out <=  `WDATA_READY;
        else if (hold == `HOLD)
            misalign_wdata_ready_out <= misalign_wdata_ready_out;
        else
            misalign_wdata_ready_out <= !`WDATA_READY;
    end

    always @(*) begin
        if (rdata_en_in == `RDATA_EN) begin
            if ((hit == `CACHE_HIT) && (rw_twice == !`RW_TWICE) && (lsu_state == LSU_IDLE_STATE))
                rdata_valid_out = `RDATA_VALID;
            else if ((rw_twice == `RW_TWICE) && (misalign_rdata_valid_out == `RDATA_VALID) && (lsu_state == LSU_IDLE_STATE))
                rdata_valid_out = `RDATA_VALID;
            else
               rdata_valid_out = !`RDATA_VALID;
        end
        else
            rdata_valid_out = `RDATA_VALID;
    end

    always @(*) begin
        if (wdata_en_in == `WDATA_EN) begin
            if ((rw_twice == `RW_TWICE) && (misalign_wdata_ready_out ==  `WDATA_READY) && (lsu_state == LSU_IDLE_STATE))
                wdata_ready_out = `WDATA_READY;
            else if ((hit == `CACHE_HIT) && (rw_twice == !`RW_TWICE) && (lsu_state == LSU_IDLE_STATE))
                wdata_ready_out = `WDATA_READY;
            else
                wdata_ready_out = !`WDATA_READY;
        end
        else
            wdata_ready_out = `WDATA_READY;
    end

    always @(*) begin // need opt
        if (rdata_en_in == `RDATA_EN) begin
            if ((hit == `CACHE_HIT) && (rw_twice != `RW_TWICE))
                rdata_out = rdata_out_or_val0 | rdata_out_or_val1 | rdata_out_or_val2 | rdata_out_or_val3 | rdata_out_or_val4 | rdata_out_or_val5 | rdata_out_or_val6 | rdata_out_or_val7;
            else if (misalign_rdata_valid_out == `RDATA_VALID) begin // not align read
                rdata_out = misalign_rdata_out;
            end
            else
               rdata_out = `ZERO;
        end
        else
            rdata_out = `ZERO;
    end
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            wdata_out <= `ZERO;
        else if ((wen_mem == `WDATA_EN) || (fencei_stage == FENCEI_STAGE1))
            wdata_out <= wmem_cache_line_data ;
        else
            wdata_out <= wdata_out;
    end

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            wdata_en_out <= !`WDATA_EN;
        else if ((lsu_state == LSU_WTBK_STATE) && (wdata_en_out == `WDATA_EN) && (wdata_ready_in == `WDATA_READY))
            wdata_en_out <= !`WDATA_EN;
        else if (lsu_state == LSU_WTBK_STATE)
            wdata_en_out <= `WDATA_EN;
        else if (wdata_en_out == `WDATA_EN)
            wdata_en_out <= `WDATA_EN;
        else
            wdata_en_out <= !`WDATA_EN;
    end

    always @(posedge clk) begin
        if (wen_mem == `WDATA_EN)
            data_addr_out <= wmem_cache_line_addr   ;
        else if (lsu_state == LSU_WTBK_STATE)
            data_addr_out <= data_addr_out          ;
        else if (wdata_en_out == `WDATA_EN)
            data_addr_out <= data_addr_out          ;
        else
            data_addr_out <= data_addr_in_rw_twice  ;
    end

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            rdata_en_out <= !`RDATA_EN;
        else if (lsu_state == LSU_WTBK_STATE)
            rdata_en_out <= !`RDATA_EN;
        else if (hit == `CACHE_HIT)
            rdata_en_out <= !`RDATA_EN;
        else if ((wdata_en_in == `WDATA_EN) && (hit == !`CACHE_HIT)) // write miss
            rdata_en_out <= `RDATA_EN;
        else if ((rdata_en_in == `RDATA_EN) && (hit == !`CACHE_HIT)) // read miss
            rdata_en_out <= `RDATA_EN;
        else if ((lsu_state == LSU_MISS_STATE) && (rdata_en_out == `RDATA_EN) && (rdata_valid_in == `RDATA_VALID))
            rdata_en_out <= !`RDATA_EN;
        else if ((rdata_en_in == `RDATA_EN) && (hit == `CACHE_HIT) && (rw_twice != `RW_TWICE))
            rdata_en_out <= !`RDATA_EN;
        else if (rdata_en_in != `RDATA_EN)
            rdata_en_out <= !`RDATA_EN;
        else
            rdata_en_out <= rdata_en_out;
    end
//////////////////////////////////////////////////////////////////////////////

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            misalign_rdata_out <= `ZERO;
        else if (misalign_rdata_valid_out == `RDATA_VALID)
            misalign_rdata_out <= misalign_rdata_out;
        else if ((rw_stage == RW_STAGE1) && (rcache_valid == `RDATA_VALID))
            misalign_rdata_out <= cache_line_data;
        else if ((rw_stage == RW_STAGE2) && (rcache_valid == `RDATA_VALID))
            misalign_rdata_out <= rdata_out_rw_twice_or_val0 | rdata_out_rw_twice_or_val1 | rdata_out_rw_twice_or_val2 | rdata_out_rw_twice_or_val3 | rdata_out_rw_twice_or_val4 | rdata_out_rw_twice_or_val5 | rdata_out_rw_twice_or_val6 | rdata_out_rw_twice_or_val7;
        else
            misalign_rdata_out <= misalign_rdata_out;
    end

    always @(*) begin
        if (rw_stage == RW_STAGE2)
            data_addr_in_rw_twice = {data_addr_in[`INSTR_ADDR_BUS_WIDTH - 1:3], 3'b0} + 8; // cache line width
        else
            data_addr_in_rw_twice = {data_addr_in[`INSTR_ADDR_BUS_WIDTH - 1:3], 3'b0};
    end

    always @(*) begin
        if (rw_stage == RW_STAGE2) begin
            case (wlen_in)
                `WLEN_HALF : begin
                    case (data_addr_in[2:0])
                        3'b111 : begin wdata_in_rw_twice = {56'h`ZERO, wdata_in[15:8] }; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_00ff; end
                        default: begin wdata_in_rw_twice = cache_line_data             ; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_0000; end
                    endcase
                end
                `WLEN_WORD : begin
                    case (data_addr_in[2:0])
                        3'b101 : begin wdata_in_rw_twice = {56'h`ZERO, wdata_in[31:24]}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_00ff; end
                        3'b110 : begin wdata_in_rw_twice = {48'h`ZERO, wdata_in[31:16]}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_ffff; end
                        3'b111 : begin wdata_in_rw_twice = {40'h`ZERO, wdata_in[31:8] }; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_00ff_ffff; end
                        default: begin wdata_in_rw_twice = cache_line_data             ; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_0000; end
                    endcase
                end
            `ifdef RV64
                `WLEN_DWORD: begin
                    case (data_addr_in[2:0])
                        3'b001 : begin wdata_in_rw_twice = {56'h`ZERO, wdata_in[63:56]}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_00ff; end
                        3'b010 : begin wdata_in_rw_twice = {48'h`ZERO, wdata_in[63:48]}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_ffff; end
                        3'b011 : begin wdata_in_rw_twice = {40'h`ZERO, wdata_in[63:40]}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_00ff_ffff; end
                        3'b100 : begin wdata_in_rw_twice = {32'h`ZERO, wdata_in[63:32]}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_ffff_ffff; end
                        3'b101 : begin wdata_in_rw_twice = {24'h`ZERO, wdata_in[63:24]}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_00ff_ffff_ffff; end
                        3'b110 : begin wdata_in_rw_twice = {16'h`ZERO, wdata_in[63:16]}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_ffff_ffff_ffff; end
                        3'b111 : begin wdata_in_rw_twice = { 8'h`ZERO, wdata_in[63:8] }; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h00ff_ffff_ffff_ffff; end
                        default: begin wdata_in_rw_twice = cache_line_data             ; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_0000; end
                    endcase
                end
            `endif
                default: begin wdata_in_rw_twice = cache_line_data; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_0000; end
            endcase
        end
        else begin
            case (wlen_in)
                `WLEN_BYTE : begin
                    case (data_addr_in[2:0])
                        3'b000 : begin wdata_in_rw_twice = {56'h`ZERO, wdata_in[7:0]           }; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_00ff; end
                        3'b001 : begin wdata_in_rw_twice = {48'h`ZERO, wdata_in[7:0],  8'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_ff00; end
                        3'b010 : begin wdata_in_rw_twice = {40'h`ZERO, wdata_in[7:0], 16'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_00ff_0000; end
                        3'b011 : begin wdata_in_rw_twice = {32'h`ZERO, wdata_in[7:0], 24'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_ff00_0000; end
                        3'b100 : begin wdata_in_rw_twice = {24'h`ZERO, wdata_in[7:0], 32'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_00ff_0000_0000; end
                        3'b101 : begin wdata_in_rw_twice = {16'h`ZERO, wdata_in[7:0], 40'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_ff00_0000_0000; end
                        3'b110 : begin wdata_in_rw_twice = { 8'h`ZERO, wdata_in[7:0], 48'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h00ff_0000_0000_0000; end
                        3'b111 : begin wdata_in_rw_twice = {wdata_in[7:0], 56'h`ZERO           }; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hff00_0000_0000_0000; end
                        default: begin wdata_in_rw_twice = cache_line_data; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_0000; end
                    endcase
                end
                `WLEN_HALF : begin
                    case (data_addr_in[2:0])
                        3'b000 : begin wdata_in_rw_twice = {48'h`ZERO, wdata_in[15:0]           }; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_ffff; end
                        3'b001 : begin wdata_in_rw_twice = {40'h`ZERO, wdata_in[15:0],  8'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_00ff_ff00; end
                        3'b010 : begin wdata_in_rw_twice = {32'h`ZERO, wdata_in[15:0], 16'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_ffff_0000; end
                        3'b011 : begin wdata_in_rw_twice = {24'h`ZERO, wdata_in[15:0], 24'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_00ff_ff00_0000; end
                        3'b100 : begin wdata_in_rw_twice = {16'h`ZERO, wdata_in[15:0], 32'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_ffff_0000_0000; end
                        3'b101 : begin wdata_in_rw_twice = { 8'h`ZERO, wdata_in[15:0], 40'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h00ff_ff00_0000_0000; end
                        3'b110 : begin wdata_in_rw_twice = {wdata_in[15:0], 48'h`ZERO           }; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_0000_0000_0000; end
                        3'b111 : begin wdata_in_rw_twice = {wdata_in[7:0] , 56'h`ZERO           }; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hff00_0000_0000_0000; end
                        default: begin wdata_in_rw_twice = cache_line_data; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_0000; end
                    endcase
                end
                `WLEN_WORD : begin
                    case (data_addr_in[2:0])
                        3'b000 : begin wdata_in_rw_twice = {32'h`ZERO, wdata_in[31:0]           }; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_ffff_ffff; end
                        3'b001 : begin wdata_in_rw_twice = {24'h`ZERO, wdata_in[31:0],  8'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_00ff_ffff_ff00; end
                        3'b010 : begin wdata_in_rw_twice = {16'h`ZERO, wdata_in[31:0], 16'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_ffff_ffff_0000; end
                        3'b011 : begin wdata_in_rw_twice = { 8'h`ZERO, wdata_in[31:0], 24'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h00ff_ffff_ff00_0000; end
                        3'b100 : begin wdata_in_rw_twice = {wdata_in[31:0], 32'h`ZERO}           ; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_ffff_0000_0000; end
                        3'b101 : begin wdata_in_rw_twice = {wdata_in[23:0], 40'h`ZERO}           ; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_ff00_0000_0000; end
                        3'b110 : begin wdata_in_rw_twice = {wdata_in[15:0], 48'h`ZERO}           ; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_0000_0000_0000; end
                        3'b111 : begin wdata_in_rw_twice = {wdata_in[7:0] , 56'h`ZERO}           ; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hff00_0000_0000_0000; end
                        default: begin wdata_in_rw_twice = cache_line_data; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_0000; end
                    endcase
                end
            `ifdef RV64
                `WLEN_DWORD: begin
                    case (data_addr_in[2:0])
                        3'b001 : begin wdata_in_rw_twice = {wdata_in[55:0],  8'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_ffff_ffff_ff00; end 
                        3'b010 : begin wdata_in_rw_twice = {wdata_in[47:0], 16'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_ffff_ffff_0000; end 
                        3'b011 : begin wdata_in_rw_twice = {wdata_in[39:0], 24'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_ffff_ff00_0000; end 
                        3'b100 : begin wdata_in_rw_twice = {wdata_in[31:0], 32'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_ffff_0000_0000; end 
                        3'b101 : begin wdata_in_rw_twice = {wdata_in[23:0], 40'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_ff00_0000_0000; end 
                        3'b110 : begin wdata_in_rw_twice = {wdata_in[15:0], 48'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_0000_0000_0000; end 
                        3'b111 : begin wdata_in_rw_twice = {wdata_in[7:0] , 56'h`ZERO}; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hff00_0000_0000_0000; end 
                        default: begin wdata_in_rw_twice = wdata_in; wmask_in_rw_twice = `CACHE_LINE_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
            `endif
                default: begin wdata_in_rw_twice = cache_line_data; wmask_in_rw_twice = `CACHE_LINE_WIDTH'h0000_0000_0000_0000; end
            endcase
        end
    end

    always @(*) begin
        if ((wdata_en_in == `WDATA_EN) && (hit == `CACHE_HIT))  
        begin
            wcache_data = wdata_in_rw_twice;
            wcache_mask = wmask_in_rw_twice;
        end
        else if ((wdata_en_in == `WDATA_EN) && (hit == !`CACHE_HIT)) begin // write miss
            wcache_data = rdata_in;
            wcache_mask = ~(`CACHE_LINE_WIDTH'h`ZERO);
        end
        else if ((rdata_en_in == `RDATA_EN) && (hit == !`CACHE_HIT)) begin // read miss
            wcache_data = rdata_in;
            wcache_mask = ~(`CACHE_LINE_WIDTH'h`ZERO);
        end
        else begin
            wcache_data = `ZERO;
            wcache_mask = `ZERO;
        end
    end

    always @(*) begin
        if ((rdata_en_in == `RDATA_EN) && (hit == `CACHE_HIT))
            ren = `RDATA_EN;
        else
            ren = !`RDATA_EN;
    end

    always @(*) begin
        if (rdata_en_in == `RDATA_EN)
            ren_cache =  `RDATA_EN;
        else if ((lsu_state == LSU_MISS_STATE) || (lsu_state == LSU_WTBK_STATE) || (is_fencei))
            ren_cache =  `RDATA_EN;
        else if (wen_mem == `WDATA_EN)
            ren_cache =  `RDATA_EN;
        else if (rdata_en_ex2 == `RDATA_EN)
            ren_cache =  `RDATA_EN;
        else
            ren_cache = !`RDATA_EN;
    end

    reg rcache_valid;

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            rcache_valid <= !`RDATA_VALID;
        else if ((rw_stage == RW_STAGE0) && (rw_twice == `RW_TWICE))
            rcache_valid <= !`RDATA_VALID;
        else if ((rw_stage == RW_STAGE1) && (rcache_valid == `RDATA_VALID))
            rcache_valid <= !`RDATA_VALID;
        else if ((ren_cache == `RDATA_EN) && (hit == `CACHE_HIT))
            rcache_valid <=  `RDATA_VALID;
        else 
            rcache_valid <= !`RDATA_VALID;
    end

    always @(*) begin
        if (fencei_state)
            data_entry = fencei_index;
        else if (wdata_en_in == `WDATA_EN)
            data_entry = cache_entry ;
        else if ((lsu_state == LSU_MISS_STATE) || (lsu_state == LSU_WTBK_STATE) || (hold == `HOLD))
            data_entry = cache_entry ;
        else if (rw_stage != RW_STAGE0)
            data_entry = cache_entry ;
        else if (rdata_en_ex2 == `RDATA_EN)
            data_entry = data_addr_ex2[`CACHE_ENTRY_FIELD];
        else
            data_entry = cache_entry ;
    end

    always @(*) begin
        if (fencei_state)
            mux_cache_entry = fencei_index;
        else
            mux_cache_entry = cache_entry ;
    end

    always @(*) begin
        if ((wdata_en_in == `WDATA_EN) && (hit == `CACHE_HIT))
            wen = `WDATA_EN;
        else if ((rdata_en_in == `RDATA_EN) && (hit == `CACHE_HIT))
            wen = !`WDATA_EN;
        else if ((lsu_state == LSU_MISS_STATE) && (rdata_en_out == `RDATA_EN) && (rdata_valid_in == `RDATA_VALID))
            wen = `WDATA_EN;
        else
            wen = !`WDATA_EN;
    end

    wire [`CACHE_LINE_BUS] rdata_out_or_val0 = ((data_addr_in[2:0] == 3'b000) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice != `RW_TWICE)))? cache_line_data : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_or_val1 = ((data_addr_in[2:0] == 3'b001) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice != `RW_TWICE)))? { 8'd0, cache_line_data[63:8] } : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_or_val2 = ((data_addr_in[2:0] == 3'b010) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice != `RW_TWICE)))? {16'd0, cache_line_data[63:16]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_or_val3 = ((data_addr_in[2:0] == 3'b011) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice != `RW_TWICE)))? {24'd0, cache_line_data[63:24]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_or_val4 = ((data_addr_in[2:0] == 3'b100) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice != `RW_TWICE)))? {32'd0, cache_line_data[63:32]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_or_val5 = ((data_addr_in[2:0] == 3'b101) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice != `RW_TWICE)))? {40'd0, cache_line_data[63:40]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_or_val6 = ((data_addr_in[2:0] == 3'b110) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice != `RW_TWICE)))? {48'd0, cache_line_data[63:48]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_or_val7 = ((data_addr_in[2:0] == 3'b111) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice != `RW_TWICE)))? {56'd0, cache_line_data[63:56]} : `ZERO;

    wire [`CACHE_LINE_BUS] rdata_out_rw_twice_or_val0 = ((data_addr_in[2:0] == 3'b000) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice == `RW_TWICE)))? cache_line_data : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_rw_twice_or_val1 = ((data_addr_in[2:0] == 3'b001) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice == `RW_TWICE)))? {cache_line_data[7:0] , misalign_rdata_out[63:8] } : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_rw_twice_or_val2 = ((data_addr_in[2:0] == 3'b010) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice == `RW_TWICE)))? {cache_line_data[15:0], misalign_rdata_out[63:16]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_rw_twice_or_val3 = ((data_addr_in[2:0] == 3'b011) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice == `RW_TWICE)))? {cache_line_data[23:0], misalign_rdata_out[63:24]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_rw_twice_or_val4 = ((data_addr_in[2:0] == 3'b100) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice == `RW_TWICE)))? {cache_line_data[31:0], misalign_rdata_out[63:32]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_rw_twice_or_val5 = ((data_addr_in[2:0] == 3'b101) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice == `RW_TWICE)))? {cache_line_data[39:0], misalign_rdata_out[63:40]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_rw_twice_or_val6 = ((data_addr_in[2:0] == 3'b110) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice == `RW_TWICE)))? {cache_line_data[47:0], misalign_rdata_out[63:48]} : `ZERO;
    wire [`CACHE_LINE_BUS] rdata_out_rw_twice_or_val7 = ((data_addr_in[2:0] == 3'b111) && (rdata_en_in == `RDATA_EN) && ((hit == `CACHE_HIT) && (rw_twice == `RW_TWICE)))? {cache_line_data[55:0], misalign_rdata_out[63:56]} : `ZERO;


    parameter LSU_IDLE_STATE = 2'd0; // idle state: read / write cache
    parameter LSU_MISS_STATE = 2'd1; // cache miss state: cache miss
    parameter LSU_WTBK_STATE = 2'd2; // write back to memory state: a dirty line is replaced
    
    reg [1:0] lsu_state;

    always @(posedge clk) begin
        if (rstn == `RESET_EN)
            lsu_state <= LSU_IDLE_STATE;
        else if (wen_mem == `WDATA_EN)
            lsu_state <= LSU_WTBK_STATE;
        else if ((lsu_state == LSU_WTBK_STATE) && (wdata_en_out == `WDATA_EN) && (wdata_ready_in == `WDATA_READY))
            lsu_state <= LSU_IDLE_STATE;
        else if (lsu_state == LSU_WTBK_STATE)
            lsu_state <= LSU_WTBK_STATE;
        else if ((wdata_en_in == `WDATA_EN) && (hit == !`CACHE_HIT)) // write miss
            lsu_state <= LSU_MISS_STATE;
        else if ((rdata_en_in == `RDATA_EN) && (hit == !`CACHE_HIT)) // read miss
            lsu_state <= LSU_MISS_STATE;
        else if (((wdata_en_in == `WDATA_EN) && (hit == `CACHE_HIT)) || (wdata_en_in != `WDATA_EN))
            lsu_state <= LSU_IDLE_STATE;
        else if ((rdata_en_in == `RDATA_EN) && (hit == `CACHE_HIT) || (rdata_en_in != `RDATA_EN))
            lsu_state <= LSU_IDLE_STATE;
        else
            lsu_state <= lsu_state;
    end

    always @(*) begin
        if (wdata_en_in == `WDATA_EN)
            wdirty = `WDIRTY;
        else
            wdirty = !`WDIRTY;
    end

    assign wlen_out = `WLEN_DWORD;

//////////////////////////////////////////////////////////////////////////////////////////////////
    reg [(`ENTRY_INDEX_BUS_WIDTH + 1):0] fencei_count; // 128 * four way -> bus 8:0
    reg [1:0] fencei_stage;
    parameter FENCEI_STAGE0 = 2'd0; // not fencei instruction
    parameter FENCEI_STAGE1 = 2'd1; // write back to memeory stage
    parameter FENCEI_STAGE2 = 2'd2; // flash icache stage

    wire [1:0] fencei_way_index;
    wire [`ENTRY_INDEX_BUS] fencei_index;
    reg [`ENTRY_INDEX_BUS] mux_cache_entry;
    
	assign fencei_way_index = fencei_count[`ENTRY_INDEX_BUS_WIDTH + 1:`ENTRY_INDEX_BUS_WIDTH]; // TODO: Parameterization
	assign fencei_index     = fencei_count[`ENTRY_INDEX_BUS];

	parameter FENCEI_COUNT_MAX = {2'b11, ~(`ENTRY_INDEX_BUS_WIDTH'd`ZERO)};

    always@(posedge clk) begin
		if((rstn == `RESET_EN) || (!is_fencei))
			fencei_stage <= FENCEI_STAGE0;
        else if ((fencei_stage == FENCEI_STAGE1) && (fencei_count == FENCEI_COUNT_MAX) && (wdata_en_out == `WDATA_EN) && (wdata_ready_in == `WDATA_READY))
            fencei_stage <= FENCEI_STAGE2;
        else if ((fencei_stage == FENCEI_STAGE1) && (fencei_count == FENCEI_COUNT_MAX) && (wen_mem != `WDATA_EN))
            fencei_stage <= FENCEI_STAGE2;
        else if ((fencei_stage == FENCEI_STAGE0) && is_fencei)
            fencei_stage <= FENCEI_STAGE1;
		else
			fencei_stage <= fencei_stage;
	end

	always@(posedge clk) begin
		if(rstn == `RESET_EN)
			fencei_count <= `ZERO;
		else if (!fencei_state)
			fencei_count <= `ZERO;
        else if ((lsu_state == LSU_WTBK_STATE) && (wdata_en_out == `WDATA_EN) && (wdata_ready_in == `WDATA_READY))
            fencei_count <= fencei_count + 1;
        else if (lsu_state == LSU_WTBK_STATE)
            fencei_count <= fencei_count;
        else if (wen_mem != `WDATA_EN)
            fencei_count <= fencei_count + 1;
		else
			fencei_count <= fencei_count;
	end

    assign fencei_stall = is_fencei && (fencei_stage != FENCEI_STAGE2);
    assign fencei_flush = (fencei_stage == FENCEI_STAGE2);
    wire fencei_state = (fencei_stage == FENCEI_STAGE1);

    parameter FENCEI_FINH = 2'd0;
    parameter FENCEI_IDLE = 2'd1;




//////////////////////////////////////////////////////////////////////////////////////////////////

cache dcache_inst0 (
        .clk                 (clk                 ),
        .rstn                (rstn                ),
        .fencei_way_index    (fencei_way_index    ),
        .fencei_state        (fencei_state        ),
        .cache_tag           (cache_tag           ),
        .cache_entry         (mux_cache_entry     ),
        .data_entry          (data_entry          ),
        .wcache_mask         (wcache_mask         ),
        .wcache_data         (wcache_data         ),
        .ren                 (ren                 ),     
        .wen                 (wen                 ),
        .ren_cache           (ren_cache           ),
        .wdirty              (wdirty              ),
        .hit                 (hit                 ),
        .wen_mem             (wen_mem             ),
        .cache_line_data     (cache_line_data     ),
        .wmem_cache_line_data(wmem_cache_line_data),
        .wmem_cache_line_addr(wmem_cache_line_addr)
);

endmodule
