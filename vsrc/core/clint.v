`include "params.v"

module clint (
    input                   clk                 ,
    input                   rstn                ,
    input [`DATA_ADDR_BUS]  data_addr           ,
    input                   wen                 ,
    input [`XLEN_BUS]       wdata               ,
    input [`WLEN_BUS]       wlen                ,
    input                   is_mret_instr       ,
    output reg              mtime_interrupt     
    );

    reg [`MTIME_BUS] mtime   /*verilator public*/;
    reg [`MTIME_BUS] mtimecmp/*verilator public*/;



    wire write_mtime   ;
    wire write_mtimecmp;
    reg [`MTIME_BUS] write_val ;
    reg [`MTIME_BUS] write_mask;

    assign write_mtime    = ((wen == `WDATA_EN) && ((data_addr & (~(`INSTR_ADDR_BUS_WIDTH'd7))) == `MTIME_ADDR))? `WDATA_EN : !`WDATA_EN;
    assign write_mtimecmp = ((wen == `WDATA_EN) && ((data_addr & (~(`INSTR_ADDR_BUS_WIDTH'd7))) == `MTIMECMP_ADDR))? `WDATA_EN : !`WDATA_EN;

`ifdef RV64
    always@(*) begin
        if ((write_mtime == `WDATA_EN) || (write_mtimecmp == `WDATA_EN)) begin
            case (data_addr[2:0])
                3'b000 : begin
                    case (wlen)
                        `WLEN_BYTE : begin write_val = wdata; write_mask = `MTIME_BUS_WIDTH'h0000_0000_0000_00ff; end
                        `WLEN_HALF : begin write_val = wdata; write_mask = `MTIME_BUS_WIDTH'h0000_0000_0000_ffff; end
                        `WLEN_WORD : begin write_val = wdata; write_mask = `MTIME_BUS_WIDTH'h0000_0000_ffff_ffff; end
                        `WLEN_DWORD: begin write_val = wdata; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                        default    : begin write_val = wdata; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
                3'b001 : begin
                    case (wlen)
                        `WLEN_BYTE : begin write_val = wdata << 8; write_mask = `MTIME_BUS_WIDTH'h0000_0000_0000_ff00; end
                        `WLEN_HALF : begin write_val = wdata << 8; write_mask = `MTIME_BUS_WIDTH'h0000_0000_00ff_ff00; end
                        `WLEN_WORD : begin write_val = wdata << 8; write_mask = `MTIME_BUS_WIDTH'h0000_00ff_ffff_ff00; end
                        default    : begin write_val = wdata << 8; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
                3'b010 : begin
                    case (wlen)
                        `WLEN_BYTE : begin write_val = wdata << 16; write_mask = `MTIME_BUS_WIDTH'h0000_0000_00ff_0000; end
                        `WLEN_HALF : begin write_val = wdata << 16; write_mask = `MTIME_BUS_WIDTH'h0000_0000_ffff_0000; end
                        `WLEN_WORD : begin write_val = wdata << 16; write_mask = `MTIME_BUS_WIDTH'h0000_ffff_ffff_0000; end
                        default    : begin write_val = wdata << 16; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
                3'b011 : begin
                    case (wlen)
                        `WLEN_BYTE : begin write_val = wdata << 24; write_mask = `MTIME_BUS_WIDTH'h0000_0000_ff00_0000; end
                        `WLEN_HALF : begin write_val = wdata << 24; write_mask = `MTIME_BUS_WIDTH'h0000_00ff_ff00_0000; end
                        `WLEN_WORD : begin write_val = wdata << 24; write_mask = `MTIME_BUS_WIDTH'h00ff_ffff_ff00_0000; end
                        default    : begin write_val = wdata << 24; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
                3'b100 : begin
                    case (wlen)
                        `WLEN_BYTE : begin write_val = wdata << 32; write_mask = `MTIME_BUS_WIDTH'h0000_00ff_0000_0000; end
                        `WLEN_HALF : begin write_val = wdata << 32; write_mask = `MTIME_BUS_WIDTH'h0000_ffff_0000_0000; end
                        `WLEN_WORD : begin write_val = wdata << 32; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_0000_0000; end
                        default    : begin write_val = wdata << 32; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
                3'b101 : begin
                    case (wlen)
                        `WLEN_BYTE : begin write_val = wdata << 40; write_mask = `MTIME_BUS_WIDTH'h0000_ff00_0000_0000; end
                        `WLEN_HALF : begin write_val = wdata << 40; write_mask = `MTIME_BUS_WIDTH'h00ff_ff00_0000_0000; end
                        default    : begin write_val = wdata << 40; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
                3'b110 : begin
                    case (wlen)
                        `WLEN_BYTE : begin write_val = wdata << 48; write_mask = `MTIME_BUS_WIDTH'h00ff_0000_0000_0000; end
                        `WLEN_HALF : begin write_val = wdata << 48; write_mask = `MTIME_BUS_WIDTH'hffff_0000_0000_ffff; end
                        default    : begin write_val = wdata << 48; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
                3'b111 : begin
                    case (wlen)
                        `WLEN_BYTE : begin write_val = wdata << 56; write_mask = `MTIME_BUS_WIDTH'hff00_0000_0000_0000; end
                        default    : begin write_val = wdata << 56; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
                default : begin write_val = wdata; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
            endcase
        end
        else begin write_val = wdata; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
    end
`else
    always@(*) begin
        if ((write_mtime == `WDATA_EN) || (write_mtimecmp == `WDATA_EN)) begin
            case (data_addr[2:0])
                3'b000 : begin
                    case (wlen)
                        `WLEN_WORD : begin write_val = {32'b`ZERO, wdata}; write_mask = `MTIME_BUS_WIDTH'h0000_0000_ffff_ffff; end
                        default    : begin write_val = {32'b`ZERO, wdata}; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end
                3'b100 : begin
                    case (wlen)
                        `WLEN_WORD : begin write_val = {wdata, 32'b`ZERO}; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_0000_0000; end
                        default    : begin write_val = {wdata, 32'b`ZERO}; write_mask = `MTIME_BUS_WIDTH'hffff_ffff_ffff_ffff; end
                    endcase
                end

                default : begin write_val = {32'b0, wdata}; write_mask = `MTIME_BUS_WIDTH'h0000_0000_0000_0000; end
            endcase
        end
        else begin write_val = {32'b0, wdata}; write_mask = `MTIME_BUS_WIDTH'h0000_0000_0000_0000; end
    end
`endif

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            mtime <= `MTIME_BUS_WIDTH'd`ZERO;
        else if (write_mtime == `WDATA_EN)
            mtime <= ((~write_mask) & mtime) | (write_mask & write_val);
        else
            mtime <= mtime + 1;
    end

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            mtimecmp <= ~(`MTIME_BUS_WIDTH'd`ZERO);
        else if (write_mtimecmp == `WDATA_EN)
            mtimecmp <= ((~write_mask) & mtimecmp) | (write_mask & write_val);
        else 
            mtimecmp <= mtimecmp;
    end

    always@(posedge clk) begin
        if (rstn == `RESET_EN)
            mtime_interrupt = !`TIME_INTERRUPT;
        else if (mtimecmp <= mtime)
            mtime_interrupt = `TIME_INTERRUPT ;
        else
            mtime_interrupt = !`TIME_INTERRUPT;
    end

endmodule


