`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/09 10:03:40
// Design Name: 
// Module Name: adder_inst_3_9
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

module adder_inst_3_9(
    input clk,
    input rstn,
    input unsigned [2:0] index,
    input [7:0][31:0] data,
    input en,
    
    output reg [47:0] res
    );
    
    reg signed [21:0] temp1, temp2;
    wire signed [15:0] A1, A2;
    assign A1 = data[index][15:0];
    assign A2 = data[index][31:16];
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            res <= 48'b0;
            temp1 <= 22'b0;
            temp2 <= 22'b0;
        end
        else begin
            if (en) begin
                temp1 <= temp1 + A1;
                temp2 <= temp2 + A2;
            end
            else begin
                res <= {2'b0,temp2, 2'b0,temp1};
                temp1 <= 0;
                temp2 <= 0;
            end
        end
    end
endmodule
