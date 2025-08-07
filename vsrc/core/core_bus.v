`include "params.v"

module core_bus (
	input wire                        clk    ,
	input wire                        rstn   ,
	output reg [`INSTR_ADDR_BUS]      araddr ,
    output wire [1:0]                 arburst,
    output wire [3:0]                 arcache,
    output wire [1:0]                 arid   ,
	output reg [7:0]                  arlen  ,
    output wire                       arlock ,
    output wire [2:0]                 arprot ,
    output wire [3:0]                 arqos  ,
    input wire                        arready,
	output wire [2:0]                 arsize ,
	output wire [1:0]                 aruser ,
	output wire                       arvalid,
	output reg [`INSTR_ADDR_BUS]      awaddr ,
	output wire [1:0]                 awburst,
    output wire [3:0]                 awcache,
    output wire [1:0]                 awid   ,
	output wire                       awlock ,
    output wire [7:0]                 awlen  ,
    output wire [2:0]                 awprot ,
    output wire [3:0]                 awqos  ,
    input wire                        awready,
	output wire [2:0]                 awsize ,
	output wire [1:0]                 awuser ,
	output wire                       awvalid,
	input wire [1:0]                  bid    ,
    output wire                       bready ,
	input wire [1:0]                  bresp  ,
	input wire [1:0]                  buser  ,
	input wire                        bvalid ,
	input wire [1:0]                  rid    ,
	input wire [63:0]                 rdata  ,
    input wire                        rlast  ,
	input wire [1:0]                  rresp  ,
	output wire                       rready ,
	input wire [1:0]                  ruser  ,
	input wire                        rvalid ,
    output reg [63:0]                 wdata  ,
    output wire [1:0]                 wid    ,
    output wire                       wlast  ,
    input wire                        wready ,
	output wire [7:0]                 wstrb  ,
	output wire [1:0]                 wuser  ,
	output wire                       wvalid ,

    // -------------- signal group from core -------------- //
	input                         hold_if         ,
	input                         hold_mem        ,
    input                         fencei_flush    ,
	// ----------------- signal group 0 ------------------- // ifu
    input [`DATA_ADDR_BUS]        data_addr_in0   ,
    input                         rdata_en_in0    ,
    input                         wdata_en_in0    ,
    input [`CACHE_LINE_BUS]       wdata_in0       ,
    input [`WLEN_BUS]             wlen_in0        ,
    output reg                    wdata_ready_out0,
    output [`CACHE_LINE_BUS]      rdata_out0      ,
    output reg                    rdata_valid_out0,

    // ----------------- signal group 1 ------------------- // lsu
    input [`DATA_ADDR_BUS]        data_addr_in1   ,
    input                         rdata_en_in1    ,
    input                         wdata_en_in1    ,
    input [`CACHE_LINE_BUS]       wdata_in1       ,
    input [`WLEN_BUS]             wlen_in1        ,
    output reg                    wdata_ready_out1,
    output reg [`CACHE_LINE_BUS]  rdata_out1      ,
    output reg                    rdata_valid_out1
);

    parameter IDLE = 2'b00;
    parameter AW   = 2'b01; // write the address
    parameter WD   = 2'b10; // write the data
    parameter RESP = 2'b11; // response

    reg [1:0] write_state;

    always @ (posedge clk) begin
        if (rstn == `RESET_EN)
            write_state <= IDLE;
        else if ((write_state == IDLE) && (wdata_en_in1 == `WDATA_EN) && (wdata_ready_out1 != `WDATA_READY)) 
            write_state <= AW;
        else if ((write_state == AW) && awready && awvalid)
            write_state <= WD;
        else if ((write_state == WD) && wready && wvalid)
            write_state <= RESP;
        else if ((write_state == RESP) && bready && bvalid)
            write_state <= IDLE;
        else 
            write_state <= write_state;
    end

    always @ (posedge clk) begin
        if (rstn == `RESET_EN)
            awaddr <= `PC_RESET_ADDR;
        else if ((write_state == IDLE) && (wdata_en_in1 == `WDATA_EN) && (wdata_ready_out1 != `WDATA_READY))
            awaddr <= data_addr_in1;
        else 
            awaddr <= awaddr;
    end

    always @ (posedge clk) begin
        if (wdata_en_in1 == `WDATA_EN)
            wdata <= wdata_in1;
        else 
            wdata <= wdata;
    end

    reg is_occupy_bus_wchannel0;
    reg is_occupy_bus_wchannel1;

    always @ (*) begin
        is_occupy_bus_wchannel0 = 0;
    end

    always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || (((write_state == RESP) && bready && bvalid) && is_occupy_bus_wchannel1))
            is_occupy_bus_wchannel1 <= 0;
        else if ((write_state == IDLE) && (wdata_en_in1 == `WDATA_EN) && (wdata_ready_out1 == !`WDATA_READY))
            is_occupy_bus_wchannel1 <= 1;
        else 
            is_occupy_bus_wchannel1 <= is_occupy_bus_wchannel1;
    end

	always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || (wdata_en_in1 != `WDATA_EN))
            wdata_ready_out1 <= !`WDATA_READY;
		else if ((write_state == RESP) && bready && bvalid && is_occupy_bus_wchannel1)
			wdata_ready_out1 <=  `WDATA_READY;
        else if (hold_mem == `HOLD)
            wdata_ready_out1 <= wdata_ready_out1;
        else 
            wdata_ready_out1 <= !`WDATA_READY;
    end
	
	// do not need handle
	always @ (*) begin
        wdata_ready_out0 = `WDATA_READY;
    end

////////////////////////////////////////////////////////////////////////////////////////////////////

    parameter AR   = 2'b01; // write the address
    parameter RD   = 2'b10; // write the data
    
    reg [1:0] read_state;

    always @ (posedge clk) begin
        if (rstn == `RESET_EN)
            read_state <= IDLE;
        else if ((read_state == IDLE) && (rdata_en_in0 == `RDATA_EN) && (rdata_valid_out0 == !`RDATA_VALID)) 
            read_state <= AR;
        else if ((read_state == IDLE) && (rdata_en_in1 == `RDATA_EN) && (rdata_valid_out1 == !`RDATA_VALID)) 
            read_state <= AR;
        else if ((read_state == AR) && arready && arvalid)
            read_state <= RD;
        else if ((read_state == RD) && rlast)
            read_state <= IDLE;
        else 
            read_state <= read_state;
    end

    reg is_occupy_bus_rchannel0;
    reg is_occupy_bus_rchannel1;

    always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || ((read_state == RD) && rlast && is_occupy_bus_rchannel0))
            is_occupy_bus_rchannel0 <= 0;
        else if ((read_state == IDLE) && (rdata_en_in0 == `RDATA_EN) && (rdata_valid_out0 == !`RDATA_VALID)) 
            is_occupy_bus_rchannel0 <= 1;
        else 
            is_occupy_bus_rchannel0 <= is_occupy_bus_rchannel0;
    end

    always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || ((((read_state == RD) && rlast)) && is_occupy_bus_rchannel1))
            is_occupy_bus_rchannel1 <= 0;
        else if ((read_state == IDLE) && (rdata_en_in0 == `RDATA_EN) && (rdata_valid_out0 == !`RDATA_VALID)) 
            is_occupy_bus_rchannel1 <= 0;
        else if ((read_state == IDLE) && (rdata_en_in1 == `RDATA_EN) && (rdata_valid_out1 == !`RDATA_VALID))
            is_occupy_bus_rchannel1 <= 1;
        else 
            is_occupy_bus_rchannel1 <= is_occupy_bus_rchannel1;
    end

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////

    always @ (posedge clk) begin
        if ((read_state == IDLE) && (rdata_en_in0 == `RDATA_EN) && (rdata_valid_out0 == !`RDATA_VALID)) 
            araddr <= {data_addr_in0[`INSTR_ADDR_BUS_WIDTH - 1:7], 7'b0};
        else if ((read_state == IDLE) && (rdata_en_in1 == `RDATA_EN) && (rdata_valid_out1 == !`RDATA_VALID)) 
            araddr <= data_addr_in1;
        else 
            araddr <= araddr;
    end

	always @ (posedge clk) begin
        if (rstn == `RESET_EN)
            arlen <= `ZERO;
        else if (is_occupy_bus_rchannel0) // burst 16
            arlen <= 15;
        else if (is_occupy_bus_rchannel1) // burst 1
            arlen <= `ZERO;
        else 
            arlen <= arlen;
    end

	reg [3:0] read_burst_index;
	
	always @ (posedge clk) begin
        if (is_occupy_bus_rchannel0 && (read_state == AR))
            read_burst_index <= `ZERO;
        else if (((read_state == RD) && (rready) && (rvalid)) && is_occupy_bus_rchannel0)
            read_burst_index <= read_burst_index + 1;
        else 
            read_burst_index <= read_burst_index;
    end


`ifdef BURST_BUFFER_TWO_WAY
    reg [`INSTR_ADDR_BUS] ifu_busrt_buffer_base_addr0;
	reg [`INSTR_ADDR_BUS] ifu_busrt_buffer_base_addr1;
	reg [`CACHE_LINE_BUS] ifu_busrt_buffer0 [15:0];
	reg [`CACHE_LINE_BUS] ifu_busrt_buffer1 [15:0];
	reg [`CACHE_LINE_BUS] ifu_busrt_buffer_data0;
	reg [`CACHE_LINE_BUS] ifu_busrt_buffer_data1;
	wire [3:0] buffer_index;
    assign buffer_index = data_addr_in0[6:3];
    reg buffer_lru_state;
    parameter LAST_READ_BUFFER0 = 1'b0;
    parameter LAST_READ_BUFFER1 = 1'b1;

    always @ (posedge clk) begin
        if (rstn == `RESET_EN)
            buffer_lru_state <= ~`ZERO;
        else if ((ifu_busrt_buffer_base_addr0[`INSTR_ADDR_BUS_WIDTH - 1:7] == data_addr_in0[`INSTR_ADDR_BUS_WIDTH - 1:7]) && (!is_occupy_bus_rchannel0))
            buffer_lru_state <= LAST_READ_BUFFER0;
        else if ((ifu_busrt_buffer_base_addr1[`INSTR_ADDR_BUS_WIDTH - 1:7] == data_addr_in0[`INSTR_ADDR_BUS_WIDTH - 1:7]) && (!is_occupy_bus_rchannel0))
            buffer_lru_state <= LAST_READ_BUFFER1;
        else 
            buffer_lru_state <= buffer_lru_state;
    end

	always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || fencei_flush) begin
            ifu_busrt_buffer_base_addr0 <= ~`ZERO;
            ifu_busrt_buffer_base_addr1 <= ~`ZERO;
        end
        else if ((((read_state == RD) && rlast)) && is_occupy_bus_rchannel0) begin
            case (buffer_lru_state)
                LAST_READ_BUFFER0: begin  ifu_busrt_buffer_base_addr0 <= ifu_busrt_buffer_base_addr0; ifu_busrt_buffer_base_addr1 <= araddr                     ; end /////
                LAST_READ_BUFFER1: begin  ifu_busrt_buffer_base_addr0 <= araddr                     ; ifu_busrt_buffer_base_addr1 <= ifu_busrt_buffer_base_addr1; end /////
                default          : begin  ifu_busrt_buffer_base_addr0 <= ifu_busrt_buffer_base_addr0; ifu_busrt_buffer_base_addr1 <= ifu_busrt_buffer_base_addr1; end
            endcase
        end
        // else if (fencei)
        //     ifu_busrt_buffer_base_addr0 <= ~`ZERO;
        //     ifu_busrt_buffer_base_addr1 <= ~`ZERO;
        else begin
            ifu_busrt_buffer_base_addr0 <= ifu_busrt_buffer_base_addr0;
            ifu_busrt_buffer_base_addr1 <= ifu_busrt_buffer_base_addr1;
        end
    end

	always@(posedge clk) begin
		if (((read_state == RD) && (rready) && (rvalid)) && is_occupy_bus_rchannel0 && (buffer_lru_state == LAST_READ_BUFFER1)) /////
			ifu_busrt_buffer0[read_burst_index] <= rdata                              ;
		else
			ifu_busrt_buffer0[read_burst_index] <= ifu_busrt_buffer0[read_burst_index];
	end

    always@(posedge clk) begin
		if (((read_state == RD) && (rready) && (rvalid)) && is_occupy_bus_rchannel0 && (buffer_lru_state == LAST_READ_BUFFER0)) /////
			ifu_busrt_buffer1[read_burst_index] <= rdata                              ;
		else
			ifu_busrt_buffer1[read_burst_index] <= ifu_busrt_buffer1[read_burst_index];
	end

	always @ (*) begin
        if (((ifu_busrt_buffer_base_addr0[`INSTR_ADDR_BUS_WIDTH - 1:7] == data_addr_in0[`INSTR_ADDR_BUS_WIDTH - 1:7]) || (ifu_busrt_buffer_base_addr1[`INSTR_ADDR_BUS_WIDTH - 1:7] == data_addr_in0[`INSTR_ADDR_BUS_WIDTH - 1:7])) && (!is_occupy_bus_rchannel0)) begin // finishing buffer update
			rdata_valid_out0 =  `RDATA_VALID;
			rdata_out0 = (ifu_busrt_buffer_base_addr0[`INSTR_ADDR_BUS_WIDTH - 1:7] == data_addr_in0[`INSTR_ADDR_BUS_WIDTH - 1:7])? ifu_busrt_buffer_data0 : ifu_busrt_buffer_data1;
		end
        else begin
            rdata_valid_out0 = !`RDATA_VALID;
			rdata_out0 = ifu_busrt_buffer_data0;
		end
    end

    always @ (*) begin
        ifu_busrt_buffer_data0 = ifu_busrt_buffer0[buffer_index];
    end

    always @ (*) begin
        ifu_busrt_buffer_data1 = ifu_busrt_buffer1[buffer_index];
    end
`else // four way
    always @ (*) begin
        if (hit && (!is_occupy_bus_rchannel0)) begin // finishing buffer update
			rdata_valid_out0 =  `RDATA_VALID;
			rdata_out0 = rdata_out;
		end
        else begin
            rdata_valid_out0 = !`RDATA_VALID;
			rdata_out0 = rdata_out;
		end
    end

    wire                   wen           ;
    wire                   wbase_addr_en ;
    wire                   flush_cache   ;
    wire                   hit           ;
    wire [`CACHE_LINE_BUS] rdata_out     ;    

    assign wen = ((read_state == RD) && (rready) && (rvalid)) && is_occupy_bus_rchannel0;
    assign wbase_addr_en = ((read_state == RD) && rlast) && is_occupy_bus_rchannel0;
    assign flush_cache = fencei_flush;

    read_burst_cache read_burst_cache_inst0 (
        .clk                   (clk                    ),
        .rstn                  (rstn                   ),
        .is_occupy_bus_rchannel(is_occupy_bus_rchannel0),
        .data_addr_in          (data_addr_in0          ),
        .base_addr             (araddr                 ),
        .burst_data            (rdata                  ),
        .burst_index           (read_burst_index       ),
        .ren                   (rdata_en_in0           ),     
        .wen                   (wen                    ),
        .wbase_addr_en         (wbase_addr_en          ),
        .flush_cache           (flush_cache            ),
        .hit                   (hit                    ),
        .rdata_out             (rdata_out              )
    );
`endif

    always @ (posedge clk) begin
        if ((rstn == `RESET_EN) || (rdata_en_in1 != `RDATA_EN)) begin
            rdata_valid_out1 <= !`RDATA_VALID;
            rdata_out1 <= rdata_out1;
        end
		else if ((read_state == RD) && rlast && is_occupy_bus_rchannel1) begin
			rdata_valid_out1 <=  `RDATA_VALID;
            rdata_out1 <= rdata;
        end
        else if (hold_mem == `HOLD) begin
            rdata_valid_out1 <= rdata_valid_out1;
            rdata_out1 <= rdata_out1;
        end
        else begin
            rdata_valid_out1 <= !`RDATA_VALID;
            rdata_out1 <= rdata_out1;
        end
    end

////////////////////////////////////////////////////////////////////////////////////////////////////

    // address read channel
    assign arburst = 1;
    assign arcache = 2;
    assign arid = 0;
    // assign arlen = 0;
    assign arlock = 0;
    assign arprot = 0;
    assign arqos = 0;
    // arready
    assign arsize = 3;
    assign aruser = 0;
    assign arvalid = (read_state == AR) && (is_occupy_bus_rchannel0 || is_occupy_bus_rchannel1);

    assign awburst = 1;
    assign awcache = 2;
    assign awid = 0;
    assign awlock = 0;
    assign awlen = 0;
    assign awprot = 0;
    assign awqos = 0;
    // awready
    assign awsize = 3;
    assign awuser = 0;
    assign awvalid = (write_state == AW);

    // bid
    // assign bready = bvalid;
    assign bready = 1;
    // bresp
    // buser
    // bvalid

    // rid
    // rdata
    // rlast
    // rresp
    assign rready = (read_state == RD);
    // ruser
    // rvalid

    assign wid = 0;
    assign wlast = (write_state == WD);
    // wready
    assign wstrb = 8'b11111111;
    assign wuser = 0;
    assign wvalid = (write_state == WD);
    assign awid = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////
endmodule
