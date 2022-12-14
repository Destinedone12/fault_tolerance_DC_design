`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/23 17:04:09
// Design Name: 
// Module Name: Rx_channelization_fault_tolerance
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Rx_channelization_fault_tolerance(
    input prj_clk,
    input prj_rst_n,
    input signed [47:0] extra_output_channel_1 [7:0],
    input signed [47:0] extra_output_channel_2 [7:0],
    input        [7:0]  extra_output_tvalid,
    output reg signed [21:0] Rx_output_real_channel_1 [7:0],
    output reg signed [21:0] Rx_output_imag_channel_1 [7:0],
    output reg       [7:0]  Rx_tvalid_channel_1,
    
    output reg signed [21:0] Rx_output_real_channel_2 [7:0],
    output reg signed [21:0] Rx_output_imag_channel_2 [7:0],
    output reg       [7:0]  Rx_tvalid_channel_2      
    
    );
    wire signed [47:0] polyphase_Rx_extra_output_channel_1 [7:0];
    wire        [7:0] polyphase_Rx_extra_output_tvalid_channel_1;
    wire signed [47:0] polyphase_Rx_extra_output_channel_2 [7:0];
    wire        [7:0] polyphase_Rx_extra_output_tvalid_channel_2;
    
    Polyphase_Rx_extra polyphase_Rx_extra_inst0(
        .prj_clk(prj_clk),
        .prj_rst_n(prj_rst_n),
        .decimator_input(extra_output_channel_1),
        .decimator_input_tvalid(extra_output_tvalid),
        .polyphase_output(polyphase_Rx_extra_output_channel_1),
        .polyphase_output_tvalid(polyphase_Rx_extra_output_tvalid_channel_1)
    );
    
    Polyphase_Rx_extra polyphase_Rx_extra_inst1(
        .prj_clk(prj_clk),
        .prj_rst_n(prj_rst_n),
        .decimator_input(extra_output_channel_2),
        .decimator_input_tvalid(extra_output_tvalid),
        .polyphase_output(polyphase_Rx_extra_output_channel_2),
        .polyphase_output_tvalid(polyphase_Rx_extra_output_tvalid_channel_2)
    );
    
wire signed [63:0] fft_m_data_tdata_Rx_channel_1; //change needed
wire  [2:0]        fft_m_data_tuser_Rx_channel_1;
wire               fft_m_data_tvalid_Rx_channel_1;

wire signed [63:0] fft_m_data_tdata_Rx_channel_2; //change needed
wire  [2:0]        fft_m_data_tuser_Rx_channel_2;
wire               fft_m_data_tvalid_Rx_channel_2;
    
    Rx_inst0_extra Rx_inst_0(
        .prj_clk(prj_clk),
        .prj_rst_n(prj_rst_n),
        .polyphase_input(polyphase_Rx_extra_output_channel_1),
        .polyphase_input_tvalid(polyphase_Rx_extra_output_tvalid_channel_1),
        .fft_m_data_tdata(fft_m_data_tdata_Rx_channel_1),
        .fft_m_data_tuser(fft_m_data_tuser_Rx_channel_1),
        .fft_m_data_tvalid(fft_m_data_tvalid_Rx_channel_1)
    );
    
    Rx_inst0_extra Rx_inst_1(
        .prj_clk(prj_clk),
        .prj_rst_n(prj_rst_n),
        .polyphase_input(polyphase_Rx_extra_output_channel_2),
        .polyphase_input_tvalid(polyphase_Rx_extra_output_tvalid_channel_2),
        .fft_m_data_tdata(fft_m_data_tdata_Rx_channel_2),
        .fft_m_data_tuser(fft_m_data_tuser_Rx_channel_2),
        .fft_m_data_tvalid(fft_m_data_tvalid_Rx_channel_2)
    );
    

       
    divider_Rx_extra divider_Rx_extra_inst0(
        .prj_clk(prj_clk),
        .prj_rst_n(prj_rst_n),
        .fft_m_data_tdata(fft_m_data_tdata_Rx_channel_1),
        .fft_m_data_tuser(fft_m_data_tuser_Rx_channel_1),
        .fft_m_data_tvalid(fft_m_data_tvalid_Rx_channel_1),
        .receive_sig_real(Rx_output_real_channel_1),
        .receive_sig_imag(Rx_output_imag_channel_1),
        .Rx_tvalid(Rx_tvalid_channel_1)
    );
    
    divider_Rx_extra divider_Rx_extra_inst1(
        .prj_clk(prj_clk),
        .prj_rst_n(prj_rst_n),
        .fft_m_data_tdata(fft_m_data_tdata_Rx_channel_2),
        .fft_m_data_tuser(fft_m_data_tuser_Rx_channel_2),
        .fft_m_data_tvalid(fft_m_data_tvalid_Rx_channel_2),
        .receive_sig_real(Rx_output_real_channel_2),
        .receive_sig_imag(Rx_output_imag_channel_2),
        .Rx_tvalid(Rx_tvalid_channel_2)
    );    
endmodule
