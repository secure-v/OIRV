`include "params.v"

module read_burst_cache (
    input                              clk                   ,
    input                              rstn                  ,
    input                              is_occupy_bus_rchannel,
    input [`INSTR_ADDR_BUS]            data_addr_in          ,
    input [`INSTR_ADDR_BUS]            base_addr             ,
    input [`CACHE_LINE_BUS]            burst_data            ,
    input [3:0]                        burst_index           ,
    input                              ren                   ,     
    input                              wen                   ,
    input                              wbase_addr_en         ,
    input                              flush_cache           ,
    output                             hit                   ,
    output [`CACHE_LINE_BUS]           rdata_out             
);

    wire hit0;
    wire hit1;
    wire hit2;
    wire hit3;
    reg [`INSTR_ADDR_BUS] ifu_busrt_buffer_base_addr0;
    reg [`INSTR_ADDR_BUS] ifu_busrt_buffer_base_addr1;
    reg [`INSTR_ADDR_BUS] ifu_busrt_buffer_base_addr2;
    reg [`INSTR_ADDR_BUS] ifu_busrt_buffer_base_addr3;

    assign hit0 = (ifu_busrt_buffer_base_addr0[`INSTR_ADDR_BUS_WIDTH - 1:7] == data_addr_in[`INSTR_ADDR_BUS_WIDTH - 1:7]);
    assign hit1 = (ifu_busrt_buffer_base_addr1[`INSTR_ADDR_BUS_WIDTH - 1:7] == data_addr_in[`INSTR_ADDR_BUS_WIDTH - 1:7]);
    assign hit2 = (ifu_busrt_buffer_base_addr2[`INSTR_ADDR_BUS_WIDTH - 1:7] == data_addr_in[`INSTR_ADDR_BUS_WIDTH - 1:7]);
    assign hit3 = (ifu_busrt_buffer_base_addr3[`INSTR_ADDR_BUS_WIDTH - 1:7] == data_addr_in[`INSTR_ADDR_BUS_WIDTH - 1:7]);
    assign hit = (hit0 || hit1 || hit2 || hit3);
    assign rdata_out = rdata0 | rdata1 | rdata2 | rdata3;

    parameter PLRU_STATE000 = 3'b000;
    parameter PLRU_STATE001 = 3'b001;
    parameter PLRU_STATE010 = 3'b010;
    parameter PLRU_STATE011 = 3'b011;
    parameter PLRU_STATE100 = 3'b100;
    parameter PLRU_STATE101 = 3'b101;
    parameter PLRU_STATE110 = 3'b110;
    parameter PLRU_STATE111 = 3'b111;

    reg [2:0] buffer_plru_state;

    always@(posedge clk) begin
        if ((ren == `RDATA_EN) && (!is_occupy_bus_rchannel)) begin
            if (hit0 == `CACHE_HIT)
                buffer_plru_state <= {2'b11, buffer_plru_state[0]};
            else if (hit1 == `CACHE_HIT)
                buffer_plru_state <= {2'b10, buffer_plru_state[0]};
            else if (hit2 == `CACHE_HIT)
                buffer_plru_state <= {1'b0, buffer_plru_state[1], 1'b1};
            else if (hit3 == `CACHE_HIT)
                buffer_plru_state <= {1'b0, buffer_plru_state[1], 1'b0};
            else 
                buffer_plru_state <= buffer_plru_state;
        end
        else
            buffer_plru_state <= buffer_plru_state;
    end

    // always@(*) begin
    //     if (wen) begin
    //         case (buffer_plru_state)
    //             PLRU_STATE000: begin wen_way0 = 1; wen_way1 = 0; wen_way2 = 0; wen_way3 = 0; end
    //             PLRU_STATE001: begin wen_way0 = 1; wen_way1 = 0; wen_way2 = 0; wen_way3 = 0; end
    //             PLRU_STATE010: begin wen_way0 = 0; wen_way1 = 1; wen_way2 = 0; wen_way3 = 0; end
    //             PLRU_STATE011: begin wen_way0 = 0; wen_way1 = 1; wen_way2 = 0; wen_way3 = 0; end
    //             PLRU_STATE100: begin wen_way0 = 0; wen_way1 = 0; wen_way2 = 1; wen_way3 = 0; end
    //             PLRU_STATE101: begin wen_way0 = 0; wen_way1 = 0; wen_way2 = 0; wen_way3 = 1; end
    //             PLRU_STATE110: begin wen_way0 = 0; wen_way1 = 0; wen_way2 = 1; wen_way3 = 0; end
    //             PLRU_STATE111: begin wen_way0 = 0; wen_way1 = 0; wen_way2 = 0; wen_way3 = 1; end
    //             default      : begin wen_way0 = 0; wen_way1 = 0; wen_way2 = 0; wen_way3 = 0; end 
    //         endcase
    //     end
    //     else                   begin wen_way0 = 0; wen_way1 = 0; wen_way2 = 0; wen_way3 = 0; end
    // end

    assign wen_way0 = wen && ((buffer_plru_state == PLRU_STATE000) || (buffer_plru_state == PLRU_STATE001));
    assign wen_way1 = wen && ((buffer_plru_state == PLRU_STATE010) || (buffer_plru_state == PLRU_STATE011));
    assign wen_way2 = wen && ((buffer_plru_state == PLRU_STATE100) || (buffer_plru_state == PLRU_STATE110));
    assign wen_way3 = wen && ((buffer_plru_state == PLRU_STATE101) || (buffer_plru_state == PLRU_STATE111));

    always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || flush_cache)
            ifu_busrt_buffer_base_addr0 <= ~`ZERO;
        else if (wbase_addr_en && ((buffer_plru_state == PLRU_STATE000) || (buffer_plru_state == PLRU_STATE001)))
            ifu_busrt_buffer_base_addr0 <= base_addr;
        else
            ifu_busrt_buffer_base_addr0 <= ifu_busrt_buffer_base_addr0;
    end

    always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || flush_cache)
            ifu_busrt_buffer_base_addr1 <= ~`ZERO;
        else if (wbase_addr_en && ((buffer_plru_state == PLRU_STATE010) || (buffer_plru_state == PLRU_STATE011)))
            ifu_busrt_buffer_base_addr1 <= base_addr;
        else
            ifu_busrt_buffer_base_addr1 <= ifu_busrt_buffer_base_addr1;
    end

    always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || flush_cache)
            ifu_busrt_buffer_base_addr2 <= ~`ZERO;
        else if (wbase_addr_en && ((buffer_plru_state == PLRU_STATE100) || (buffer_plru_state == PLRU_STATE110)))
            ifu_busrt_buffer_base_addr2 <= base_addr;
        else
            ifu_busrt_buffer_base_addr2 <= ifu_busrt_buffer_base_addr2;
    end

    always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || flush_cache)
            ifu_busrt_buffer_base_addr3 <= ~`ZERO;
        else if (wbase_addr_en && ((buffer_plru_state == PLRU_STATE101) || (buffer_plru_state == PLRU_STATE111)))
            ifu_busrt_buffer_base_addr3 <= base_addr;
        else
            ifu_busrt_buffer_base_addr3 <= ifu_busrt_buffer_base_addr3;
    end

    wire [3:0]              index_way0           ;
    // reg                     wen_way0             ;
    wire                    wen_way0             ;
    wire [`CACHE_LINE_BUS]  wdata_way0           ;
    wire [`CACHE_LINE_BUS]  rdata_way0           ;

    wire [3:0]              index_way1           ;
    // reg                     wen_way1             ;
    wire                    wen_way1             ;
    wire [`CACHE_LINE_BUS]  wdata_way1           ;
    wire [`CACHE_LINE_BUS]  rdata_way1           ;

    wire [3:0]              index_way2           ;
    // reg                     wen_way2             ;
    wire                    wen_way2             ;
    wire [`CACHE_LINE_BUS]  wdata_way2           ;
    wire [`CACHE_LINE_BUS]  rdata_way2           ;

    wire [3:0]              index_way3           ;
    // reg                     wen_way3             ;
    wire                    wen_way3             ;
    wire [`CACHE_LINE_BUS]  wdata_way3           ;
    wire [`CACHE_LINE_BUS]  rdata_way3           ;

    assign index_way0 = (wen_way0)? burst_index : `ZERO;
    assign index_way1 = (wen_way1)? burst_index : `ZERO;
    assign index_way2 = (wen_way2)? burst_index : `ZERO;
    assign index_way3 = (wen_way3)? burst_index : `ZERO;
    
    assign wdata_way0 = burst_data;
    assign wdata_way1 = burst_data;
    assign wdata_way2 = burst_data;
    assign wdata_way3 = burst_data;

    wire [`CACHE_LINE_BUS] rdata0;
    wire [`CACHE_LINE_BUS] rdata1;
    wire [`CACHE_LINE_BUS] rdata2;
    wire [`CACHE_LINE_BUS] rdata3;

    assign rdata0 = (hit0)? rdata_way0 : `ZERO;
    assign rdata1 = (hit1)? rdata_way1 : `ZERO;
    assign rdata2 = (hit2)? rdata_way2 : `ZERO;
    assign rdata3 = (hit3)? rdata_way3 : `ZERO;

    wire [3:0] rindex0;
    wire [3:0] rindex1;
    wire [3:0] rindex2;
    wire [3:0] rindex3;

    assign rindex0 = (hit0)? data_addr_in[6:3] : `ZERO;
    assign rindex1 = (hit1)? data_addr_in[6:3] : `ZERO;
    assign rindex2 = (hit2)? data_addr_in[6:3] : `ZERO;
    assign rindex3 = (hit3)? data_addr_in[6:3] : `ZERO;

    ram_16_64 way0 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .rindex     (rindex0         ),
        .windex     (index_way0      ),
        .wen        (wen_way0        ),
        .wdata      (wdata_way0      ),
        .rdata      (rdata_way0      )
    );

    ram_16_64 way1 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .rindex     (rindex1         ),
        .windex     (index_way1      ),
        .wen        (wen_way1        ),
        .wdata      (wdata_way1      ),
        .rdata      (rdata_way1      )
    );

    ram_16_64 way2 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .rindex     (rindex2         ),
        .windex     (index_way2      ),
        .wen        (wen_way2        ),
        .wdata      (wdata_way2      ),
        .rdata      (rdata_way2      )
    );

    ram_16_64 way3 (
        .clk        (clk             ),
        .rstn       (rstn            ),
        .rindex     (rindex3         ),
        .windex     (index_way3      ),
        .wen        (wen_way3        ),
        .wdata      (wdata_way3      ),
        .rdata      (rdata_way3      )
    );

endmodule
