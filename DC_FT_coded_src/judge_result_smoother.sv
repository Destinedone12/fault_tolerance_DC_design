`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/25 16:28:31
// Design Name: 
// Module Name: judge_result_smoother
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


module judge_result_smoother(
    input clk,
    input rstn,
    input [8:0] judge_result_i,
    input       judge_result_en_i,
    output reg  [3:0] judge_result_smoother_o,
    output reg        judge_result_smoother_en_o
    );
    
    reg [8:0] judge_result_i_temp[14:0];
    reg [3:0] judge_result_cnt;
    
    reg       syn_rst;
    reg       overflow_rst;
    //judge_result_i_temp ctrl
    always@(posedge clk or negedge rstn) begin 
        if(!rstn) begin
            judge_result_i_temp <= {9'd0,9'd0,9'd0,9'd0,9'd0,9'd0,9'd0,
                                    9'd0,9'd0,9'd0,9'd0,9'd0,9'd0,9'd0,9'd0};
        end
        else begin
            if (syn_rst || overflow_rst) begin
                judge_result_i_temp[14:1] <= {9'd0,9'd0,9'd0,9'd0,9'd0,9'd0,9'd0,
                                              9'd0,9'd0,9'd0,9'd0,9'd0,9'd0,9'd0};
                if (judge_result_en_i)
                    judge_result_i_temp[0] <= judge_result_i;
                else
                    judge_result_i_temp[0] <= 9'd0;
            end
            else if (judge_result_en_i) begin
                judge_result_i_temp[14] <= judge_result_i_temp[13];
                judge_result_i_temp[13] <= judge_result_i_temp[12];
                judge_result_i_temp[12] <= judge_result_i_temp[11];
                judge_result_i_temp[11] <= judge_result_i_temp[10];
                judge_result_i_temp[10] <= judge_result_i_temp[9];
                judge_result_i_temp[9] <= judge_result_i_temp[8];
                judge_result_i_temp[8] <= judge_result_i_temp[7];
                judge_result_i_temp[7] <= judge_result_i_temp[6];
                judge_result_i_temp[6] <= judge_result_i_temp[5];
                judge_result_i_temp[5] <= judge_result_i_temp[4];
                judge_result_i_temp[4] <= judge_result_i_temp[3];
                judge_result_i_temp[3] <= judge_result_i_temp[2];
                judge_result_i_temp[2] <= judge_result_i_temp[1];
                judge_result_i_temp[1] <= judge_result_i_temp[0];
                judge_result_i_temp[0] <= judge_result_i;
            end
        end
    end
    
    //some wires that immediately show sums
    wire [4:0] cn0_cnt;
    wire [4:0] cn1_cnt; 
    wire [4:0] cn2_cnt;
    wire [4:0] cn3_cnt; 
    wire [4:0] cn4_cnt;
    wire [4:0] cn5_cnt;
    wire [4:0] cn6_cnt;
    wire [4:0] cn7_cnt;
    assign cn0_cnt = judge_result_i_temp[0][0] + judge_result_i_temp[1][0]+judge_result_i_temp[2][0]+judge_result_i_temp[3][0]
                    +judge_result_i_temp[4][0]+judge_result_i_temp[5][0]+judge_result_i_temp[6][0]+judge_result_i_temp[7][0]
                    +judge_result_i_temp[8][0]+judge_result_i_temp[9][0]+judge_result_i_temp[10][0]+judge_result_i_temp[11][0]
                    +judge_result_i_temp[12][0]+judge_result_i_temp[13][0]+judge_result_i_temp[14][0];
    assign cn1_cnt = judge_result_i_temp[0][1] + judge_result_i_temp[1][1]+judge_result_i_temp[2][1]+judge_result_i_temp[3][1]
                    +judge_result_i_temp[4][1]+judge_result_i_temp[5][1]+judge_result_i_temp[6][1]+judge_result_i_temp[7][1]
                    +judge_result_i_temp[8][1]+judge_result_i_temp[9][1]+judge_result_i_temp[10][1]+judge_result_i_temp[11][1]
                    +judge_result_i_temp[12][1]+judge_result_i_temp[13][1]+judge_result_i_temp[14][1];
    assign cn2_cnt = judge_result_i_temp[0][2] + judge_result_i_temp[1][2]+judge_result_i_temp[2][2]+judge_result_i_temp[3][2]
                    +judge_result_i_temp[4][2]+judge_result_i_temp[5][2]+judge_result_i_temp[6][2]+judge_result_i_temp[7][2]
                    +judge_result_i_temp[8][2]+judge_result_i_temp[9][2]+judge_result_i_temp[10][2]+judge_result_i_temp[11][2]
                    +judge_result_i_temp[12][2]+judge_result_i_temp[13][2]+judge_result_i_temp[14][2];
    assign cn3_cnt = judge_result_i_temp[0][3] + judge_result_i_temp[1][3]+judge_result_i_temp[2][3]+judge_result_i_temp[3][3]
                    +judge_result_i_temp[4][3]+judge_result_i_temp[5][3]+judge_result_i_temp[6][3]+judge_result_i_temp[7][3]
                    +judge_result_i_temp[8][3]+judge_result_i_temp[9][3]+judge_result_i_temp[10][3]+judge_result_i_temp[11][3]
                    +judge_result_i_temp[12][3]+judge_result_i_temp[13][3]+judge_result_i_temp[14][3];
    assign cn4_cnt = judge_result_i_temp[0][4] + judge_result_i_temp[1][4]+judge_result_i_temp[2][4]+judge_result_i_temp[3][4]
                    +judge_result_i_temp[4][4]+judge_result_i_temp[5][4]+judge_result_i_temp[6][4]+judge_result_i_temp[7][4]
                    +judge_result_i_temp[8][4]+judge_result_i_temp[9][4]+judge_result_i_temp[10][4]+judge_result_i_temp[11][4]
                    +judge_result_i_temp[12][4]+judge_result_i_temp[13][4]+judge_result_i_temp[14][4];
    assign cn5_cnt = judge_result_i_temp[0][5] + judge_result_i_temp[1][5]+judge_result_i_temp[2][5]+judge_result_i_temp[3][5]
                    +judge_result_i_temp[4][5]+judge_result_i_temp[5][5]+judge_result_i_temp[6][5]+judge_result_i_temp[7][5]
                    +judge_result_i_temp[8][5]+judge_result_i_temp[9][5]+judge_result_i_temp[10][5]+judge_result_i_temp[11][5]
                    +judge_result_i_temp[12][5]+judge_result_i_temp[13][5]+judge_result_i_temp[14][5];
    assign cn6_cnt = judge_result_i_temp[0][6] + judge_result_i_temp[1][6]+judge_result_i_temp[2][6]+judge_result_i_temp[3][6]
                    +judge_result_i_temp[4][6]+judge_result_i_temp[5][6]+judge_result_i_temp[6][6]+judge_result_i_temp[7][6]
                    +judge_result_i_temp[8][6]+judge_result_i_temp[9][6]+judge_result_i_temp[10][6]+judge_result_i_temp[11][6]
                    +judge_result_i_temp[12][6]+judge_result_i_temp[13][6]+judge_result_i_temp[14][6];
    assign cn7_cnt = judge_result_i_temp[0][7] + judge_result_i_temp[1][7]+judge_result_i_temp[2][7]+judge_result_i_temp[3][7]
                    +judge_result_i_temp[4][7]+judge_result_i_temp[5][7]+judge_result_i_temp[6][7]+judge_result_i_temp[7][7]
                    +judge_result_i_temp[8][7]+judge_result_i_temp[9][7]+judge_result_i_temp[10][7]+judge_result_i_temp[11][7]
                    +judge_result_i_temp[12][7]+judge_result_i_temp[13][7]+judge_result_i_temp[14][7];
    //set timer, if no response in 256 clk pulse, force module to output result & reset all counters
    //syn_rst ctrl
    reg [7:0] timer;
    always@(posedge clk or negedge rstn) begin 
        if(!rstn) begin
            timer <= 8'b0;
            syn_rst <= 1'b0;
        end
        else begin
            if (timer == 8'b11111111) begin
                timer <= 8'b0;
                syn_rst <= 1'b1;
            end
            else if (judge_result_en_i) begin
                timer <= 8'b0;
                syn_rst <= 1'b0;
            end
            else begin
                timer <= timer + 1;
                syn_rst <= 1'b0;
            end
        end
    end
    
    //overflow ctrl
    always@(posedge clk or negedge rstn) begin 
        if(!rstn) begin
            overflow_rst <= 0;
            judge_result_cnt <= 0;
        end
        else begin
            if (judge_result_cnt == 15) begin
                overflow_rst <= 1;
                judge_result_cnt <= 0;
            end
            else begin
                if (judge_result_en_i) begin
                    judge_result_cnt <= judge_result_cnt + 1;
                end
                overflow_rst <= 0;
            end
        end
    end
    
    //result control
    always@(posedge clk or negedge rstn) begin
        if(!rstn) begin
            judge_result_smoother_en_o <= 0;
            judge_result_smoother_o <= 4'b0;
        end
        else begin
            if(timer == 6'b111111 || judge_result_cnt == 15) begin
                if (cn0_cnt > judge_result_cnt/2)
                    judge_result_smoother_o <= 4'd0;
                else if (cn1_cnt > judge_result_cnt/2)
                    judge_result_smoother_o <= 4'd1;
                else if (cn2_cnt > judge_result_cnt/2)
                    judge_result_smoother_o <= 4'd2;
                else if (cn3_cnt > judge_result_cnt/2)
                    judge_result_smoother_o <= 4'd3;
                else if (cn4_cnt > judge_result_cnt/2)
                    judge_result_smoother_o <= 4'd4;
                else if (cn5_cnt > judge_result_cnt/2)
                    judge_result_smoother_o <= 4'd5;
                else if (cn6_cnt > judge_result_cnt/2)
                    judge_result_smoother_o <= 4'd6;
                else if (cn7_cnt > judge_result_cnt/2)
                    judge_result_smoother_o <= 4'd7;
                else //invalid result
                    judge_result_smoother_o <= 4'b1111;
                judge_result_smoother_en_o <= 1;
            end
            else
                judge_result_smoother_en_o <= 0;
        end
    end
endmodule
