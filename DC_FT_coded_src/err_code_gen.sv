`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/04 14:12:52
// Design Name: 
// Module Name: err_code_gen
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


module err_code_gen(
    input clk,
    input rstn,
    input [31:0] division_o,
    input        division_o_tvalid,
    output reg [8:0] judge_result,
    output reg judge_result_en
    );
    
    wire unsigned [23:0] quotient_1bit_frac;
    assign quotient_1bit_frac = division_o[30:7];
    
    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            judge_result <= 9'b0;
        end
        else begin
            if (division_o_tvalid) begin
                case(quotient_1bit_frac)
                    'd0: judge_result <= 9'b100000000; //invalid
                    'd1: judge_result <= 9'b000000001; //CN1
                    'd2: judge_result <= 9'b000000001; 
                    'd3: judge_result <= 9'b000000010; 
                    'd4: judge_result <= 9'b000000010; 
                    'd5: judge_result <= 9'b000000100; 
                    'd6: judge_result <= 9'b000000100; 
                    'd7: judge_result <= 9'b000001000; 
                    'd8: judge_result <= 9'b000001000; 
                    'd9: judge_result <= 9'b000010000; 
                    'd10: judge_result <= 9'b000010000; 
                    'd11: judge_result <= 9'b000100000; 
                    'd12: judge_result <= 9'b000100000; 
                    'd13: judge_result <= 9'b001000000; 
                    'd14: judge_result <= 9'b001000000; 
                    'd15: judge_result <= 9'b010000000; 
                    'd16: judge_result <= 9'b010000000; 
                    default: judge_result <= 9'b100000000; //invalid
                endcase
            end
            else begin
                judge_result <= judge_result;
            end
        end
    end
    
    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            judge_result_en <= 0;
        end
        else begin
            if (division_o_tvalid)
                judge_result_en <= 1;
            else
                judge_result_en <= 0;
        end
    end
endmodule
