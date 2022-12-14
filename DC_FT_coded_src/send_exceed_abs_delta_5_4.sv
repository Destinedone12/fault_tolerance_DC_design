`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/09 12:13:30
// Design Name: 
// Module Name: send_exceed_delta_3_9
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

// Need 13CLK ?

module send_exceed_abs_delta_5_4#(parameter INWIDTH_DELTA = 17)
(
    input clk,
    input rstn,
    input unsigned [INWIDTH_DELTA-1:0] delta1_thres_i,
    input unsigned [INWIDTH_DELTA-1:0] delta2_thres_i,
    input delta1_delta2_en,
    input signed [INWIDTH_DELTA-1:0] delta1_real_imag_i[15:0],
    input signed [INWIDTH_DELTA-1:0] delta2_real_imag_i[15:0],
    output reg unsigned [INWIDTH_DELTA-1:0] delta1_real_imag_exceed_o[15:0],
    output reg unsigned [INWIDTH_DELTA-1:0] delta2_real_imag_exceed_o[15:0],
    output reg [15:0] exceed_map_en_o
    );
    
    reg [3:0] index;
    reg en;
    reg signed [INWIDTH_DELTA-1:0] delta1_real_imag_i_temp[15:0];
    reg signed [INWIDTH_DELTA-1:0] delta2_real_imag_i_temp[15:0];
    
    
    reg [15:0] exceed_map_en_o_temp;
    
    wire signed [INWIDTH_DELTA-1:0] delta1_real_imag_signed;
    wire signed [INWIDTH_DELTA-1:0] delta2_real_imag_signed;
    
    assign delta1_real_imag_signed = delta1_real_imag_i_temp[index];
    assign delta2_real_imag_signed = delta2_real_imag_i_temp[index];
    
    wire unsigned [INWIDTH_DELTA-1:0] delta1_real_imag_abs;
    wire unsigned [INWIDTH_DELTA-1:0] delta2_real_imag_abs;
    
    abs_calc_lut #(INWIDTH_DELTA) trans_to_abs_delta1(
        .signed_data_i(delta1_real_imag_signed),
        .unsigned_data_o(delta1_real_imag_abs)
    );
    
    abs_calc_lut #(INWIDTH_DELTA) trans_to_abs_delta2(
        .signed_data_i(delta2_real_imag_signed),
        .unsigned_data_o(delta2_real_imag_abs)
    );
    
    wire unsigned [INWIDTH_DELTA-1:0] comp_1, comp_2;
    assign comp_1 = delta1_real_imag_abs;
    assign comp_2 = delta2_real_imag_abs;
    
    localparam IDLE = 2'd0, WRITE=2'd1, CALC = 2'd2, OUT = 2'd3;
    
    reg [1:0] cur_state, next_state;
    
    always@(posedge clk or negedge rstn) begin
        if (!rstn)
            cur_state <= IDLE;
        else
            cur_state <= next_state;
    end
    
    always @(*) begin
        next_state = IDLE;
        case (cur_state)
            IDLE: begin
                if (delta1_delta2_en)
                    next_state = WRITE;
                else
                    next_state = IDLE;
            end
            WRITE:next_state = CALC;
            CALC: begin
                if (index == 15)
                    next_state = OUT;
                else
                    next_state = CALC;
                end
            OUT: next_state = IDLE;
            default:next_state = IDLE;
        endcase
    end
    
    //idx ctrl
    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            index <= 4'b0;
        end
        else begin
            case (cur_state)
                CALC: index <= index + 1;
                default: index <= 4'b0;
            endcase
        end
    end
    
    //data ctrl 
    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            delta1_real_imag_i_temp <= {0,0,0,0,0,0,0,0,
                                        0,0,0,0,0,0,0,0};
            delta2_real_imag_i_temp <= {0,0,0,0,0,0,0,0,
                                        0,0,0,0,0,0,0,0};
        end
        else begin
            case (cur_state)
                WRITE: begin
                    delta1_real_imag_i_temp <= delta1_real_imag_i;
                    delta2_real_imag_i_temp <= delta2_real_imag_i;
                end
                default: begin
                    delta1_real_imag_i_temp <= delta1_real_imag_i_temp;
                    delta2_real_imag_i_temp <= delta2_real_imag_i_temp;
                end
            endcase
        end
    end
    
    
    
    //exceed_map_en_o_temp ctrl 
    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            exceed_map_en_o_temp <= 16'b0;
        end
        else begin
            case (cur_state)
                CALC:begin
                    if ((comp_1 > delta1_thres_i) & (comp_2 > delta2_thres_i))
                        exceed_map_en_o_temp[index] <= 1'b1;
                end
                //OUT: exceed_map_en_o_temp <= 16'b0;
                default: exceed_map_en_o_temp <= 16'b0;
            endcase
        end
    end    
    //en ctrl
    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            exceed_map_en_o <= 16'b0;
        end
        else begin
            case (cur_state)
                OUT: begin
                    exceed_map_en_o <= exceed_map_en_o_temp;
                end
                default: exceed_map_en_o <= 16'b0;
            endcase
        end
    end
    
    //delta1_real_imag_exceed_o ctrl
    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            delta1_real_imag_exceed_o <= {0,0,0,0,0,0,0,0,
                                          0,0,0,0,0,0,0,0};
            delta2_real_imag_exceed_o <= {0,0,0,0,0,0,0,0,
                                          0,0,0,0,0,0,0,0};
        end
        else begin
            case (cur_state)
                CALC: begin
                    delta1_real_imag_exceed_o[index] <= comp_1;
                    delta2_real_imag_exceed_o[index] <= comp_2;
                end
                default: begin delta1_real_imag_exceed_o <= delta1_real_imag_exceed_o;
                                delta2_real_imag_exceed_o <= delta2_real_imag_exceed_o;
                        end
            endcase
        end
    end
endmodule

