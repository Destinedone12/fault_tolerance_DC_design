`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/06 11:45:32
// Design Name: 
// Module Name: abs_calc_lut
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


module abs_calc_lut#(parameter LENGTH = 10)
(
    input signed [LENGTH-1:0] signed_data_i,
    output wire [LENGTH-1:0] unsigned_data_o
    );
    
    assign unsigned_data_o = (signed_data_i[LENGTH-1] == 0) ? signed_data_i : (~signed_data_i + 1);
endmodule
