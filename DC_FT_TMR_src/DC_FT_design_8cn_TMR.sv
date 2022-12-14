`timescale 1ns / 1ps

//modify DC_CNT to change the number of digital channelizers under protection
module DC_FT_design_8cn_TMR
#(parameter DC_CNT = 8)
(
    input clk,
    input rstn,
    input signed [8*DC_CNT-1:0][31:0] tx_sig ,
    input        [8*DC_CNT-1:0]  tx_sig_tvalid,
    output wire [8*DC_CNT-1:0][19:0] rx_sig_real ,
    output wire [8*DC_CNT-1:0][19:0] rx_sig_imag ,
    output wire        [8*DC_CNT-1:0]  rx_sig_tvalid
    );
    
genvar i, j;
generate
    for (i = 0; i < DC_CNT; i = i+1) begin
        reg signed [7:0][19:0] rx_sig_real_0;
        reg signed [7:0][19:0] rx_sig_imag_0;
        reg        [7:0]  rx_sig_tvalid_0;
        reg signed [7:0][19:0] rx_sig_real_1;
        reg signed [7:0][19:0] rx_sig_imag_1;
        reg        [7:0]  rx_sig_tvalid_1;
        reg signed [7:0][19:0] rx_sig_real_2;
        reg signed [7:0][19:0] rx_sig_imag_2;
        reg        [7:0]  rx_sig_tvalid_2;
        
        wire [8*20-1:0] tmr_data_real;
        wire [8*20-1:0] tmr_data_imag;
        wire [7:0] tmr_tvalid;
    
        DC_rx DC_rx_rev0
        (
            .clk(clk),
            .rstn(rstn),
            .tx_sig(tx_sig[(i*8+7):(i*8)]),
            .tx_sig_tvalid(tx_sig_tvalid[i*8+7:i*8]),
            .rx_sig_real(rx_sig_real_0),
            .rx_sig_imag(rx_sig_imag_0),
            .rx_sig_tvalid(rx_sig_tvalid_0)
        );
        
        DC_rx DC_rx_rev1
        (
            .clk(clk),
            .rstn(rstn),
            .tx_sig(tx_sig[(i*8+7):(i*8)]),
            .tx_sig_tvalid(tx_sig_tvalid[i*8+7:i*8]),
            .rx_sig_real(rx_sig_real_1),
            .rx_sig_imag(rx_sig_imag_1),
            .rx_sig_tvalid(rx_sig_tvalid_1)
        );
        
        DC_rx DC_rx_rev2
        (
            .clk(clk),
            .rstn(rstn),
            .tx_sig(tx_sig[(i*8+7):(i*8)]),
            .tx_sig_tvalid(tx_sig_tvalid[i*8+7:i*8]),
            .rx_sig_real(rx_sig_real_2),
            .rx_sig_imag(rx_sig_imag_2),
            .rx_sig_tvalid(rx_sig_tvalid_2)
        );
        
        tmr_voter_data tmr_voter_data_real_inst
        (
            .Discrete1(rx_sig_real_0),
            .Discrete2(rx_sig_real_1),
            .Discrete3(rx_sig_real_2),
            .Discrete(tmr_data_real)
        );
        
        tmr_voter_data tmr_voter_data_imag_inst
        (
            .Discrete1(rx_sig_imag_0),
            .Discrete2(rx_sig_imag_1),
            .Discrete3(rx_sig_imag_2),
            .Discrete(tmr_data_imag)
        );
        
        tmr_voter_tvalid tmr_voter_tvalid_inst
        (
            .Discrete1(rx_sig_tvalid_0),
            .Discrete2(rx_sig_tvalid_1),
            .Discrete3(rx_sig_tvalid_2),
            .Discrete(tmr_tvalid)
        );
        
        for (j = 0; j < 8; j++) begin
            assign rx_sig_real[i*8+j] = tmr_data_real[20*(j+1)-1:20*j];
            assign rx_sig_imag[i*8+j] = tmr_data_imag[20*(j+1)-1:20*j];
        end
        assign rx_sig_tvalid[i*8+7:i*8] = tmr_tvalid;
    end
endgenerate
endmodule
