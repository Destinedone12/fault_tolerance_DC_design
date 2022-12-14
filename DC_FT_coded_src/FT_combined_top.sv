`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/07 11:39:43
// Design Name: 
// Module Name: FT_combined_top
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


module FT_combined_top(
    input clk,
    input rstn,
    input signed [7:0][31:0] decimator_output_channel_0 ,
    input        [7:0]  decimator_output_tvalid_channel_0,
    input signed [7:0][31:0] decimator_output_channel_1,
    input signed [7:0][31:0] decimator_output_channel_2,
    input signed [7:0][31:0] decimator_output_channel_3,
    input signed [7:0][31:0] decimator_output_channel_4,
    input signed [7:0][31:0] decimator_output_channel_5,
    input signed [7:0][31:0] decimator_output_channel_6,
    input signed [7:0][31:0] decimator_output_channel_7,
    
    input signed [7:0][31:0] divider_output_channel_0,
    input signed [7:0][31:0] divider_output_channel_1,
    input signed [7:0][31:0] divider_output_channel_2,
    input signed [7:0][31:0] divider_output_channel_3,
    input signed [7:0][31:0] divider_output_channel_4,
    input signed [7:0][31:0] divider_output_channel_5,
    input signed [7:0][31:0] divider_output_channel_6,
    input signed [7:0][31:0] divider_output_channel_7,
    
    input        [7:0]  divider_output_tvalid_channel_0,
    
    output reg [3:0] judge_result_smoother,
    output reg       judge_result_smoother_en,
    output reg  [7:0] error_fix_en,
    output reg  [7:0][31:0] error_fix_channel
    );
    
    wire signed [47:0] extra_output_channel_1 [7:0];
    wire signed [47:0] extra_output_channel_2 [7:0];
    wire        [7:0]       extra_output_tvalid    ;
    
    multi_adder_dsp add_mult_beforeRx
    (
        .prj_clk(clk),
        .prj_rst_n(rstn),
        .input_16bit_channel_0(decimator_output_channel_0),
        .input_16bit_channel_1(decimator_output_channel_1),
        .input_16bit_channel_2(decimator_output_channel_2),
        .input_16bit_channel_3(decimator_output_channel_3),
        .input_16bit_channel_4(decimator_output_channel_4),
        .input_16bit_channel_5(decimator_output_channel_5),
        .input_16bit_channel_6(decimator_output_channel_6),
        .input_16bit_channel_7(decimator_output_channel_7),
        .input_16bit_tvalid(decimator_output_tvalid_channel_0[0]),
        .output_22bit_channel_1(extra_output_channel_1),
        .output_22bit_channel_2(extra_output_channel_2),
        .output_22bit_tvalid(extra_output_tvalid)
    );
wire signed [47:0] afterRx_output_channel_1 [7:0];
    wire signed [47:0] afterRx_output_channel_2 [7:0];
    wire        [7:0]  afterRx_output_tvalid    ;
    
    multi_adder_dsp add_mult_afterRx
    (
        .prj_clk(clk),
        .prj_rst_n(rstn),
        .input_16bit_channel_0(divider_output_channel_0),
        .input_16bit_channel_1(divider_output_channel_1),
        .input_16bit_channel_2(divider_output_channel_2),
        .input_16bit_channel_3(divider_output_channel_3),
        .input_16bit_channel_4(divider_output_channel_4),
        .input_16bit_channel_5(divider_output_channel_5),
        .input_16bit_channel_6(divider_output_channel_6),
        .input_16bit_channel_7(divider_output_channel_7),
        .input_16bit_tvalid(divider_output_tvalid_channel_0[0]),
        .output_22bit_channel_1(afterRx_output_channel_1),
        .output_22bit_channel_2(afterRx_output_channel_2),
        .output_22bit_tvalid(afterRx_output_tvalid)
    );
    
    wire signed [21:0] extra_real_channel_1 [7:0];
    wire signed [21:0] extra_imag_channel_1 [7:0];
    wire [7:0]  extra_tvalid_channel_1;
    
    wire signed [21:0] extra_real_channel_2 [7:0];
    wire signed [21:0] extra_imag_channel_2 [7:0];
    wire [7:0]  extra_tvalid_channel_2;
    
Rx_channelization_fault_tolerance rx_redundant_2channel(
        .prj_clk(clk),
        .prj_rst_n(rstn),
        .extra_output_channel_1(extra_output_channel_1),
        .extra_output_channel_2(extra_output_channel_2),
        .extra_output_tvalid({extra_output_tvalid,extra_output_tvalid,extra_output_tvalid,extra_output_tvalid,
                                      extra_output_tvalid,extra_output_tvalid,extra_output_tvalid,extra_output_tvalid}),
        .Rx_output_real_channel_1(extra_real_channel_1),
        .Rx_output_imag_channel_1(extra_imag_channel_1),
        .Rx_tvalid_channel_1(extra_tvalid_channel_1),
        .Rx_output_real_channel_2(extra_real_channel_2),
        .Rx_output_imag_channel_2(extra_imag_channel_2),
        .Rx_tvalid_channel_2(extra_tvalid_channel_2)
    );
    wire signed [16:0] delta1_real_imag[15:0];
    wire signed [16:0] delta2_real_imag[15:0];
    
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign delta1_real_imag[i] = $signed(afterRx_output_channel_1[i][21:0]) - $signed(extra_real_channel_1[i]);
        assign delta1_real_imag[i+8] = $signed(afterRx_output_channel_1[i][45:24]) - $signed(extra_imag_channel_1[i]);
        assign delta2_real_imag[i] = $signed(afterRx_output_channel_2[i][21:0]) - $signed(extra_real_channel_2[i]);
        assign delta2_real_imag[i+8] = $signed(afterRx_output_channel_2[i][45:24]) - $signed(extra_imag_channel_2[i]);
    end
endgenerate

error_check_division error_checker_inst
(
    .clk(clk),
    .rstn(rstn),
    .delta1_real_imag(delta1_real_imag),
    .delta2_real_imag(delta2_real_imag),
    .delta1_delta2_en(extra_tvalid_channel_1),
    .judge_result_smoother(judge_result_smoother),
    .judge_result_smoother_en(judge_result_smoother_en)
);

    error_fixer_3_12 error_fixer_inst(
        .clk(clk),
        .rstn(rstn),
        .error_code(judge_result_smoother),
        .bit16_cn0(divider_output_channel_0),
        .bit16_cn1(divider_output_channel_1),
        .bit16_cn2(divider_output_channel_2),
        .bit16_cn3(divider_output_channel_3),
        .bit16_cn4(divider_output_channel_4),
        .bit16_cn5(divider_output_channel_5),
        .bit16_cn6(divider_output_channel_6),
        .bit16_cn7(divider_output_channel_7),
        .en_i(divider_output_tvalid_channel_0[0]),
        .delta1_real(delta1_real_imag[7:0]),
        .delta1_imag(delta1_real_imag[15:8]),
        .error_fix_en(error_fix_en),
        .error_fix_channel(error_fix_channel)
        );
       
endmodule
