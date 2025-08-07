`include "params.v"

module icache (
    input                              clk                            ,
    input                              rstn                           ,
    input                              fencei_flush                   ,
    input [`CACHE_TAG_BUS]             cache_tag                      ,
    input [`ENTRY_INDEX_BUS]           cache_entry                    , // 128 entry
    input [`ENTRY_INDEX_BUS]           next_cache_entry               , // 128 entry
    input [`CACHE_LINE_BUS]            wcache_data                    ,
    input                              ren                            ,     
    input                              wen                            ,
    output                             hit                            ,
    output reg [`CACHE_LINE_BUS]       cache_line_data                          
);

    reg [`CACHE_PLRU_BUS] plru_table[`ENTRY_BUS]; // tree-PLRU

    parameter PLRU_STATE000 = 3'b000;
    parameter PLRU_STATE001 = 3'b001;
    parameter PLRU_STATE010 = 3'b010;
    parameter PLRU_STATE011 = 3'b011;
    parameter PLRU_STATE100 = 3'b100;
    parameter PLRU_STATE101 = 3'b101;
    parameter PLRU_STATE110 = 3'b110;
    parameter PLRU_STATE111 = 3'b111;

    wire hit0;
    wire hit1;
    wire hit2;
    wire hit3;

    assign hit0 = ((cache_tag == tag_way0) && (vflag0[cache_entry] == `CACHE_LINE_VALID))? `CACHE_HIT : !`CACHE_HIT;
    assign hit1 = ((cache_tag == tag_way1) && (vflag1[cache_entry] == `CACHE_LINE_VALID))? `CACHE_HIT : !`CACHE_HIT;
    assign hit2 = ((cache_tag == tag_way2) && (vflag2[cache_entry] == `CACHE_LINE_VALID))? `CACHE_HIT : !`CACHE_HIT;
    assign hit3 = ((cache_tag == tag_way3) && (vflag3[cache_entry] == `CACHE_LINE_VALID))? `CACHE_HIT : !`CACHE_HIT;
    assign hit = ((hit0 == `CACHE_HIT) || (hit1 == `CACHE_HIT) || (hit2 == `CACHE_HIT) || (hit3 == `CACHE_HIT))? `CACHE_HIT : !`CACHE_HIT;
    
    wire [`CACHE_LINE_BUS] cache_line_data_or_val0 = (((ren == `RDATA_EN) || (wen == `WDATA_EN)) && (hit0 == `CACHE_LINE_VALID))? rdata_way0 : `ZERO;
    wire [`CACHE_LINE_BUS] cache_line_data_or_val1 = (((ren == `RDATA_EN) || (wen == `WDATA_EN)) && (hit1 == `CACHE_LINE_VALID))? rdata_way1 : `ZERO;
    wire [`CACHE_LINE_BUS] cache_line_data_or_val2 = (((ren == `RDATA_EN) || (wen == `WDATA_EN)) && (hit2 == `CACHE_LINE_VALID))? rdata_way2 : `ZERO;
    wire [`CACHE_LINE_BUS] cache_line_data_or_val3 = (((ren == `RDATA_EN) || (wen == `WDATA_EN)) && (hit3 == `CACHE_LINE_VALID))? rdata_way3 : `ZERO;

    always@(*) begin
        cache_line_data = cache_line_data_or_val0 | cache_line_data_or_val1 | cache_line_data_or_val2 | cache_line_data_or_val3;
    end

    always@(*) begin
        if (wen == `WDATA_EN) begin
            case (plru_table[cache_entry])
                PLRU_STATE000: begin wen_way0 =  `WDATA_EN; end
                PLRU_STATE001: begin wen_way0 =  `WDATA_EN; end
                PLRU_STATE010: begin wen_way0 = !`WDATA_EN; end
                PLRU_STATE011: begin wen_way0 = !`WDATA_EN; end
                PLRU_STATE100: begin wen_way0 = !`WDATA_EN; end
                PLRU_STATE101: begin wen_way0 = !`WDATA_EN; end
                PLRU_STATE110: begin wen_way0 = !`WDATA_EN; end
                PLRU_STATE111: begin wen_way0 = !`WDATA_EN; end
                default      : begin wen_way0 = !`WDATA_EN; end 
            endcase
        end
        else
            wen_way0 = !`WDATA_EN       ;
    end

    always@(*) begin
        if (wen == `WDATA_EN) begin
            case (plru_table[cache_entry])
                PLRU_STATE000: begin wen_way1 = !`WDATA_EN; end
                PLRU_STATE001: begin wen_way1 = !`WDATA_EN; end
                PLRU_STATE010: begin wen_way1 =  `WDATA_EN; end
                PLRU_STATE011: begin wen_way1 =  `WDATA_EN; end
                PLRU_STATE100: begin wen_way1 = !`WDATA_EN; end
                PLRU_STATE101: begin wen_way1 = !`WDATA_EN; end
                PLRU_STATE110: begin wen_way1 = !`WDATA_EN; end
                PLRU_STATE111: begin wen_way1 = !`WDATA_EN; end
                default      : begin wen_way1 = !`WDATA_EN; end 
            endcase
        end
        else
            wen_way1 = !`WDATA_EN       ;
    end

    always@(*) begin
        if (wen == `WDATA_EN) begin
            case (plru_table[cache_entry])
                PLRU_STATE000: begin wen_way2 = !`WDATA_EN; end
                PLRU_STATE001: begin wen_way2 = !`WDATA_EN; end
                PLRU_STATE010: begin wen_way2 = !`WDATA_EN; end
                PLRU_STATE011: begin wen_way2 = !`WDATA_EN; end
                PLRU_STATE100: begin wen_way2 =  `WDATA_EN; end
                PLRU_STATE101: begin wen_way2 = !`WDATA_EN; end
                PLRU_STATE110: begin wen_way2 =  `WDATA_EN; end
                PLRU_STATE111: begin wen_way2 = !`WDATA_EN; end
                default      : begin wen_way2 = !`WDATA_EN; end 
            endcase
        end
        else
            wen_way2 = !`WDATA_EN       ;
    end

    always@(*) begin
        if (wen == `WDATA_EN) begin
            case (plru_table[cache_entry])
                PLRU_STATE000: begin wen_way3 = !`WDATA_EN; end
                PLRU_STATE001: begin wen_way3 = !`WDATA_EN; end
                PLRU_STATE010: begin wen_way3 = !`WDATA_EN; end
                PLRU_STATE011: begin wen_way3 = !`WDATA_EN; end
                PLRU_STATE100: begin wen_way3 = !`WDATA_EN; end
                PLRU_STATE101: begin wen_way3 =  `WDATA_EN; end
                PLRU_STATE110: begin wen_way3 = !`WDATA_EN; end
                PLRU_STATE111: begin wen_way3 =  `WDATA_EN; end
                default      : begin wen_way3 = !`WDATA_EN; end 
            endcase
        end
        else
            wen_way3 = !`WDATA_EN       ;
    end

    wire [`CACHE_PLRU_BUS] next_plru_state0 = (hit0 == `CACHE_HIT)? {2'b11, plru_table[cache_entry][0]}      : `ZERO;
    wire [`CACHE_PLRU_BUS] next_plru_state1 = (hit1 == `CACHE_HIT)? {2'b10, plru_table[cache_entry][0]}      : `ZERO;
    wire [`CACHE_PLRU_BUS] next_plru_state2 = (hit2 == `CACHE_HIT)? {1'b0, plru_table[cache_entry][1], 1'b1} : `ZERO;
    wire [`CACHE_PLRU_BUS] next_plru_state3 = (hit3 == `CACHE_HIT)? {1'b0, plru_table[cache_entry][1], 1'b0} : `ZERO;

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
			plru_table[cache_entry] <= plru_table[cache_entry];
        else if ((wen == `WDATA_EN) || (ren == `RDATA_EN)) begin
            if (hit == `CACHE_HIT)
                plru_table[cache_entry] <= next_plru_state0 | next_plru_state1 | next_plru_state2 | next_plru_state3;
            else 
                plru_table[cache_entry] <= plru_table[cache_entry];
        end
        else
            plru_table[cache_entry] <= plru_table[cache_entry];
    end

    integer i;
    
    always@(posedge clk) begin
        if ((rstn == `RESET_EN) || fencei_flush) begin
            for (i = 0; i < `ENTRY_NUM; i++) begin
				vflag0[i] <= !`CACHE_LINE_VALID;
			end
        end
        else if (wen_way0)
            vflag0[cache_entry] <=   `CACHE_LINE_VALID;
        else
            vflag0[cache_entry] <= vflag0[cache_entry];     
    end

    always@(posedge clk) begin
        if ((rstn == `RESET_EN) || fencei_flush) begin
            for (i = 0; i < `ENTRY_NUM; i++) begin
				vflag1[i] <= !`CACHE_LINE_VALID;
			end
        end
        else if (wen_way1)
            vflag1[cache_entry] <=   `CACHE_LINE_VALID;
        else
            vflag1[cache_entry] <= vflag1[cache_entry];     
    end

    always@(posedge clk) begin
        if ((rstn == `RESET_EN) || fencei_flush) begin
            for (i = 0; i < `ENTRY_NUM; i++) begin
				vflag2[i] <= !`CACHE_LINE_VALID;
			end
        end
        else if (wen_way2)
            vflag2[cache_entry] <=   `CACHE_LINE_VALID;
        else
            vflag2[cache_entry] <= vflag2[cache_entry];     
    end

    always@(posedge clk) begin
        if ((rstn == `RESET_EN) || fencei_flush) begin
            for (i = 0; i < `ENTRY_NUM; i++) begin
				vflag3[i] <= !`CACHE_LINE_VALID;
			end
        end
        else if (wen_way3)
            vflag3[cache_entry] <=   `CACHE_LINE_VALID;
        else
            vflag3[cache_entry] <= vflag3[cache_entry];     
    end

    wire [`ENTRY_INDEX_BUS] entry_index_way0     ;
    wire                    ren_way0             ;
    reg                     wen_way0             ;
    wire [`CACHE_LINE_BUS]  wmask0               ;
    wire [`CACHE_LINE_BUS]  wdata_way0           ;
    wire [`CACHE_LINE_BUS]  rdata_way0           ;
    reg [`ENTRY_BUS]        vflag0               ;
    // reg [`CACHE_TAG_BUS]    tag_way0 [`ENTRY_BUS];

    wire [`ENTRY_INDEX_BUS] entry_index_way1     ;
    wire                    ren_way1             ;
    reg                     wen_way1             ;
    wire [`CACHE_LINE_BUS]  wmask1               ;
    wire [`CACHE_LINE_BUS]  wdata_way1           ;
    wire [`CACHE_LINE_BUS]  rdata_way1           ;
    reg [`ENTRY_BUS]        vflag1               ;
    // reg [`CACHE_TAG_BUS]    tag_way1 [`ENTRY_BUS];

    wire [`ENTRY_INDEX_BUS] entry_index_way2     ;
    wire                    ren_way2             ;
    reg                     wen_way2             ;
    wire [`CACHE_LINE_BUS]  wmask2               ;
    wire [`CACHE_LINE_BUS]  wdata_way2           ;
    wire [`CACHE_LINE_BUS]  rdata_way2           ;
    reg [`ENTRY_BUS]        vflag2               ;
    // reg [`CACHE_TAG_BUS]    tag_way2 [`ENTRY_BUS];

    wire [`ENTRY_INDEX_BUS] entry_index_way3     ;
    wire                    ren_way3             ;
    reg                     wen_way3             ;
    wire [`CACHE_LINE_BUS]  wmask3               ;
    wire [`CACHE_LINE_BUS]  wdata_way3           ;
    wire [`CACHE_LINE_BUS]  rdata_way3           ;
    reg [`ENTRY_BUS]        vflag3               ;
    // reg [`CACHE_TAG_BUS]    tag_way3 [`ENTRY_BUS];

    assign ren_way0 = `RDATA_EN;
    assign ren_way1 = `RDATA_EN;
    assign ren_way2 = `RDATA_EN;
    assign ren_way3 = `RDATA_EN;

    assign entry_index_way0 = next_cache_entry;
    assign entry_index_way1 = next_cache_entry;
    assign entry_index_way2 = next_cache_entry;
    assign entry_index_way3 = next_cache_entry;
    
    assign wdata_way0 = wcache_data;
    assign wdata_way1 = wcache_data;
    assign wdata_way2 = wcache_data;
    assign wdata_way3 = wcache_data;

    assign wmask0 = ~(`CACHE_LINE_WIDTH'h`ZERO);
    assign wmask1 = ~(`CACHE_LINE_WIDTH'h`ZERO);
    assign wmask2 = ~(`CACHE_LINE_WIDTH'h`ZERO);
    assign wmask3 = ~(`CACHE_LINE_WIDTH'h`ZERO);

    wire [`CACHE_TAG_BUS] tag_way0;
    wire [`CACHE_TAG_BUS] tag_way1;
    wire [`CACHE_TAG_BUS] tag_way2;
    wire [`CACHE_TAG_BUS] tag_way3;

    tag_ram tag_ram_way0 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .entry_index(cache_entry     ),
        .wen        (wen_way0        ),
        .wdata      (cache_tag       ),
        .rdata      (tag_way0        )
    );

    tag_ram tag_ram_way1 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .entry_index(cache_entry     ),
        .wen        (wen_way1        ),
        .wdata      (cache_tag       ),
        .rdata      (tag_way1        )
    );

    tag_ram tag_ram_way2 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .entry_index(cache_entry     ),
        .wen        (wen_way2        ),
        .wdata      (cache_tag       ),
        .rdata      (tag_way2        )
    );

    tag_ram tag_ram_way3 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .entry_index(cache_entry     ),
        .wen        (wen_way3        ),
        .wdata      (cache_tag       ),
        .rdata      (tag_way3        )
    );

    sram_128_64 way0 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .entry_index(entry_index_way0),
        .ren        (ren_way0        ),
        .wen        (wen_way0        ),
        .wmask      (wmask0          ),
        .wdata      (wdata_way0      ),
        .rdata      (rdata_way0      )
    );

    sram_128_64 way1 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .entry_index(entry_index_way1),
        .ren        (ren_way1        ),
        .wen        (wen_way1        ),
        .wmask      (wmask1          ),
        .wdata      (wdata_way1      ),
        .rdata      (rdata_way1      )
    );

    sram_128_64 way2 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .entry_index(entry_index_way2),
        .ren        (ren_way2        ),
        .wen        (wen_way2        ),
        .wmask      (wmask2          ),
        .wdata      (wdata_way2      ),
        .rdata      (rdata_way2      )
    );

    sram_128_64 way3 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .entry_index(entry_index_way3),
        .ren        (ren_way3        ),
        .wen        (wen_way3        ),
        .wmask      (wmask3          ),
        .wdata      (wdata_way3      ),
        .rdata      (rdata_way3      )
    );

endmodule
