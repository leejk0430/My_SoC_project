// Created with Corsair v1.0.4

module regs_uart #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System
    input clk,
    input rst,
    // U_TX_DATA.DATA
    output [7:0] csr_u_tx_data_data_out,

    // U_TX_STAT.READY
    input  csr_u_tx_stat_ready_in,
    // U_TX_STAT.TX_DONE
    input  csr_u_tx_stat_tx_done_in,

    // U_TX_CTRL.TX_START
    output  csr_u_tx_ctrl_tx_start_out,

    // U_RX_DATA.DATA
    input [7:0] csr_u_rx_data_data_in,

    // U_RX_STAT.RX_OVERRUN
    input  csr_u_rx_stat_rx_overrun_in,
    // U_RX_STAT.RX_VALID
    input  csr_u_rx_stat_rx_valid_in,

    // U_RX_CTRL.RX_START
    input  csr_u_rx_ctrl_rx_start_in,
    // U_RX_CTRL.RX_CLEAR
    input  csr_u_rx_ctrl_rx_clear_in,

    // Local Bus
    input  [ADDR_W-1:0] waddr,
    input  [DATA_W-1:0] wdata,
    input               wen,
    input  [STRB_W-1:0] wstrb,
    output              wready,
    input  [ADDR_W-1:0] raddr,
    input               ren,
    output [DATA_W-1:0] rdata,
    output              rvalid
);
//------------------------------------------------------------------------------
// CSR:
// [0x0] - U_TX_DATA - UART_TX Data register
//------------------------------------------------------------------------------
wire [31:0] csr_u_tx_data_rdata;
assign csr_u_tx_data_rdata[31:8] = 24'h0;

wire csr_u_tx_data_wen;
assign csr_u_tx_data_wen = wen && (waddr == 32'h0);

wire csr_u_tx_data_ren;
assign csr_u_tx_data_ren = ren && (raddr == 32'h0);
reg csr_u_tx_data_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_u_tx_data_ren_ff <= 1'b0;
    end else begin
        csr_u_tx_data_ren_ff <= csr_u_tx_data_ren;
    end
end
//---------------------
// Bit field:
// U_TX_DATA[7:0] - DATA - Data To Send Via UART TX
// access: rw, hardware: o
//---------------------
reg [7:0] csr_u_tx_data_data_ff;

assign csr_u_tx_data_rdata[7:0] = csr_u_tx_data_data_ff;

assign csr_u_tx_data_data_out = csr_u_tx_data_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_u_tx_data_data_ff <= 8'h0;
    end else  begin
     if (csr_u_tx_data_wen) begin
            if (wstrb[0]) begin
                csr_u_tx_data_data_ff[7:0] <= wdata[7:0];
            end
        end else begin
            csr_u_tx_data_data_ff <= csr_u_tx_data_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x4] - U_TX_STAT - UART_TX Status register
//------------------------------------------------------------------------------
wire [31:0] csr_u_tx_stat_rdata;
assign csr_u_tx_stat_rdata[4:0] = 5'h0;
assign csr_u_tx_stat_rdata[12:6] = 7'h0;
assign csr_u_tx_stat_rdata[31:14] = 18'h0;

wire csr_u_tx_stat_wen;
assign csr_u_tx_stat_wen = wen && (waddr == 32'h4);

wire csr_u_tx_stat_ren;
assign csr_u_tx_stat_ren = ren && (raddr == 32'h4);
reg csr_u_tx_stat_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_u_tx_stat_ren_ff <= 1'b0;
    end else begin
        csr_u_tx_stat_ren_ff <= csr_u_tx_stat_ren;
    end
end
//---------------------
// Bit field:
// U_TX_STAT[5] - READY - UART is Ready
// access: ro, hardware: i
//---------------------
reg  csr_u_tx_stat_ready_ff;

assign csr_u_tx_stat_rdata[5] = csr_u_tx_stat_ready_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_u_tx_stat_ready_ff <= 1'b1;
    end else  begin
              begin            csr_u_tx_stat_ready_ff <= csr_u_tx_stat_ready_in;
        end
    end
end


//---------------------
// Bit field:
// U_TX_STAT[13] - TX_DONE - Done Transmitting The Last Char (TX) (8-bit)
// access: roc, hardware: i
//---------------------
reg  csr_u_tx_stat_tx_done_ff;

assign csr_u_tx_stat_rdata[13] = csr_u_tx_stat_tx_done_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_u_tx_stat_tx_done_ff <= 1'b0;
    end else  begin
          if (csr_u_tx_stat_ren && !csr_u_tx_stat_ren_ff) begin
            csr_u_tx_stat_tx_done_ff <= 1'b0;
        end else            begin            csr_u_tx_stat_tx_done_ff <= csr_u_tx_stat_tx_done_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x8] - U_TX_CTRL - UART_TX Control register
//------------------------------------------------------------------------------
wire [31:0] csr_u_tx_ctrl_rdata;
assign csr_u_tx_ctrl_rdata[8:0] = 9'h0;
assign csr_u_tx_ctrl_rdata[31:10] = 22'h0;

wire csr_u_tx_ctrl_wen;
assign csr_u_tx_ctrl_wen = wen && (waddr == 32'h8);

//---------------------
// Bit field:
// U_TX_CTRL[9] - TX_START - TX Begin Signal, Valid For Only One Cycle
// access: wosc, hardware: o
//---------------------
reg  csr_u_tx_ctrl_tx_start_ff;

assign csr_u_tx_ctrl_rdata[9] = 1'b0;

assign csr_u_tx_ctrl_tx_start_out = csr_u_tx_ctrl_tx_start_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_u_tx_ctrl_tx_start_ff <= 1'b0;
    end else  begin
     if (csr_u_tx_ctrl_wen) begin
            if (wstrb[1]) begin
                csr_u_tx_ctrl_tx_start_ff <= wdata[9];
            end
        end else begin
            csr_u_tx_ctrl_tx_start_ff <= 1'b0;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x10] - U_RX_DATA - UART_RX Data register
//------------------------------------------------------------------------------
wire [31:0] csr_u_rx_data_rdata;
assign csr_u_rx_data_rdata[31:8] = 24'h0;


wire csr_u_rx_data_ren;
assign csr_u_rx_data_ren = ren && (raddr == 32'h10);
reg csr_u_rx_data_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_u_rx_data_ren_ff <= 1'b0;
    end else begin
        csr_u_rx_data_ren_ff <= csr_u_rx_data_ren;
    end
end
//---------------------
// Bit field:
// U_RX_DATA[7:0] - DATA - Data To recieve Via UART RX
// access: ro, hardware: i
//---------------------
reg [7:0] csr_u_rx_data_data_ff;

assign csr_u_rx_data_rdata[7:0] = csr_u_rx_data_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_u_rx_data_data_ff <= 8'h0;
    end else  begin
              begin            csr_u_rx_data_data_ff <= csr_u_rx_data_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x14] - U_RX_STAT - UART_RX Status register
//------------------------------------------------------------------------------
wire [31:0] csr_u_rx_stat_rdata;
assign csr_u_rx_stat_rdata[5:0] = 6'h0;
assign csr_u_rx_stat_rdata[13:7] = 7'h0;
assign csr_u_rx_stat_rdata[31:15] = 17'h0;

wire csr_u_rx_stat_wen;
assign csr_u_rx_stat_wen = wen && (waddr == 32'h14);

wire csr_u_rx_stat_ren;
assign csr_u_rx_stat_ren = ren && (raddr == 32'h14);
reg csr_u_rx_stat_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_u_rx_stat_ren_ff <= 1'b0;
    end else begin
        csr_u_rx_stat_ren_ff <= csr_u_rx_stat_ren;
    end
end
//---------------------
// Bit field:
// U_RX_STAT[6] - RX_OVERRUN - another data has arrived before finishing reading
// access: ro, hardware: i
//---------------------
reg  csr_u_rx_stat_rx_overrun_ff;

assign csr_u_rx_stat_rdata[6] = csr_u_rx_stat_rx_overrun_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_u_rx_stat_rx_overrun_ff <= 1'b0;
    end else  begin
              begin            csr_u_rx_stat_rx_overrun_ff <= csr_u_rx_stat_rx_overrun_in;
        end
    end
end


//---------------------
// Bit field:
// U_RX_STAT[14] - RX_VALID - new data has arrived
// access: roc, hardware: i
//---------------------
reg  csr_u_rx_stat_rx_valid_ff;

assign csr_u_rx_stat_rdata[14] = csr_u_rx_stat_rx_valid_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_u_rx_stat_rx_valid_ff <= 1'b0;
    end else  begin
          if (csr_u_rx_stat_ren && !csr_u_rx_stat_ren_ff) begin
            csr_u_rx_stat_rx_valid_ff <= 1'b0;
        end else            begin            csr_u_rx_stat_rx_valid_ff <= csr_u_rx_stat_rx_valid_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x18] - U_RX_CTRL - UART_RX Control register
//------------------------------------------------------------------------------
wire [31:0] csr_u_rx_ctrl_rdata;
assign csr_u_rx_ctrl_rdata[9:0] = 10'h0;
assign csr_u_rx_ctrl_rdata[31:12] = 20'h0;

wire csr_u_rx_ctrl_wen;
assign csr_u_rx_ctrl_wen = wen && (waddr == 32'h18);

wire csr_u_rx_ctrl_ren;
assign csr_u_rx_ctrl_ren = ren && (raddr == 32'h18);
reg csr_u_rx_ctrl_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_u_rx_ctrl_ren_ff <= 1'b0;
    end else begin
        csr_u_rx_ctrl_ren_ff <= csr_u_rx_ctrl_ren;
    end
end
//---------------------
// Bit field:
// U_RX_CTRL[10] - RX_START - RX Begin Signal, Valid For Only One Cycle
// access: rw, hardware: i
//---------------------
reg  csr_u_rx_ctrl_rx_start_ff;

assign csr_u_rx_ctrl_rdata[10] = csr_u_rx_ctrl_rx_start_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_u_rx_ctrl_rx_start_ff <= 1'b0;
    end else  begin
     if (csr_u_rx_ctrl_wen) begin
            if (wstrb[1]) begin
                csr_u_rx_ctrl_rx_start_ff <= wdata[10];
            end
        end else         begin            csr_u_rx_ctrl_rx_start_ff <= csr_u_rx_ctrl_rx_start_in;
        end
    end
end


//---------------------
// Bit field:
// U_RX_CTRL[11] - RX_CLEAR - reset recive buffer (pulse)
// access: wo, hardware: i
//---------------------
reg  csr_u_rx_ctrl_rx_clear_ff;

assign csr_u_rx_ctrl_rdata[11] = 1'b0;


always @(posedge clk) begin
    if (rst) begin
        csr_u_rx_ctrl_rx_clear_ff <= 1'b0;
    end else  begin
     if (csr_u_rx_ctrl_wen) begin
            if (wstrb[1]) begin
                csr_u_rx_ctrl_rx_clear_ff <= wdata[11];
            end
        end else         begin            csr_u_rx_ctrl_rx_clear_ff <= csr_u_rx_ctrl_rx_clear_in;
        end
    end
end


//------------------------------------------------------------------------------
// Write ready
//------------------------------------------------------------------------------
assign wready = 1'b1;

//------------------------------------------------------------------------------
// Read address decoder
//------------------------------------------------------------------------------
reg [31:0] rdata_ff;
always @(posedge clk) begin
    if (rst) begin
        rdata_ff <= 32'h0;
    end else if (ren) begin
        case (raddr)
            32'h0: rdata_ff <= csr_u_tx_data_rdata;
            32'h4: rdata_ff <= csr_u_tx_stat_rdata;
            32'h8: rdata_ff <= csr_u_tx_ctrl_rdata;
            32'h10: rdata_ff <= csr_u_rx_data_rdata;
            32'h14: rdata_ff <= csr_u_rx_stat_rdata;
            32'h18: rdata_ff <= csr_u_rx_ctrl_rdata;
            default: rdata_ff <= 32'h0;
        endcase
    end else begin
        rdata_ff <= 32'h0;
    end
end
assign rdata = rdata_ff;

//------------------------------------------------------------------------------
// Read data valid
//------------------------------------------------------------------------------
reg rvalid_ff;
always @(posedge clk) begin
    if (rst) begin
        rvalid_ff <= 1'b0;
    end else if (ren && rvalid) begin
        rvalid_ff <= 1'b0;
    end else if (ren) begin
        rvalid_ff <= 1'b1;
    end
end

assign rvalid = rvalid_ff;

endmodule