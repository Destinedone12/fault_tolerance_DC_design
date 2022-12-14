`timescale 1ns / 1ps

module se2pa(
    input clk,
    input rstn,
    input signed [47:0] fft_m_data_tdata,
    input        [2:0]  fft_m_data_tuser,
    input               fft_m_data_tvalid,
    output reg signed [7:0][19:0] receive_sig_real ,
    output reg signed [7:0][19:0] receive_sig_imag ,
    output reg        [7:0]       Rx_tvalid
    );
    
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin //Çå¿ÕÊä³ö
        receive_sig_real <= 160'b0;
        receive_sig_imag <= 160'b0;
        Rx_tvalid <= 8'b00000000;
    end
    else if (fft_m_data_tvalid) begin
        case (fft_m_data_tuser)
        3'd0:begin
            //receive_sig_real[0] <= {fft_m_data_tdata[19],fft_m_data_tdata[14:0]};
            //receive_sig_imag[0] <= {fft_m_data_tdata[43],fft_m_data_tdata[38:24]};
            receive_sig_real[0] <= fft_m_data_tdata[19:0];
            receive_sig_imag[0] <= fft_m_data_tdata[43:24];
            Rx_tvalid <= 8'b00000001;
        end
        3'd1:begin
            //receive_sig_real[1] <= {fft_m_data_tdata[19],fft_m_data_tdata[14:0]};
            //receive_sig_imag[1] <= {fft_m_data_tdata[43],fft_m_data_tdata[38:24]};
            receive_sig_real[1] <= fft_m_data_tdata[19:0];;
            receive_sig_imag[1] <= fft_m_data_tdata[43:24];
            Rx_tvalid <= 8'b00000010;
        end
        3'd2:begin
            //receive_sig_real[2] <= {fft_m_data_tdata[19],fft_m_data_tdata[14:0]};
            //receive_sig_imag[2] <= {fft_m_data_tdata[43],fft_m_data_tdata[38:24]};
            receive_sig_real[2] <= fft_m_data_tdata[19:0];;
            receive_sig_imag[2] <= fft_m_data_tdata[43:24];
            Rx_tvalid <= 8'b00000100;
        end
        3'd3:begin
            //receive_sig_real[3] <= {fft_m_data_tdata[19],fft_m_data_tdata[14:0]};
            //receive_sig_imag[3] <= {fft_m_data_tdata[43],fft_m_data_tdata[38:24]};
            receive_sig_real[3] <= fft_m_data_tdata[19:0];;
            receive_sig_imag[3] <= fft_m_data_tdata[43:24];
            Rx_tvalid <= 8'b00001000;
        end
        3'd4:begin
            //receive_sig_real[4] <= {fft_m_data_tdata[19],fft_m_data_tdata[14:0]};
            //receive_sig_imag[4] <= {fft_m_data_tdata[43],fft_m_data_tdata[38:24]};
            receive_sig_real[4] <= fft_m_data_tdata[19:0];;
            receive_sig_imag[4] <= fft_m_data_tdata[43:24];
            Rx_tvalid <= 8'b00010000;
        end
        3'd5:begin
            //receive_sig_real[5] <= {fft_m_data_tdata[19],fft_m_data_tdata[14:0]};
            //receive_sig_imag[5] <= {fft_m_data_tdata[43],fft_m_data_tdata[38:24]};
            receive_sig_real[5] <= fft_m_data_tdata[19:0];;
            receive_sig_imag[5] <= fft_m_data_tdata[43:24];
            Rx_tvalid <= 8'b00100000;
        end
        3'd6:begin
            //receive_sig_real[6] <= {fft_m_data_tdata[19],fft_m_data_tdata[14:0]};
            //receive_sig_imag[6] <= {fft_m_data_tdata[43],fft_m_data_tdata[38:24]};
            receive_sig_real[6] <= fft_m_data_tdata[19:0];;
            receive_sig_imag[6] <= fft_m_data_tdata[43:24];
            Rx_tvalid <= 8'b01000000;
        end
        3'd7:begin
            //receive_sig_real[7] <= {fft_m_data_tdata[19],fft_m_data_tdata[14:0]};
            //receive_sig_imag[7] <= {fft_m_data_tdata[43],fft_m_data_tdata[38:24]};
            receive_sig_real[7] <= fft_m_data_tdata[19:0];;
            receive_sig_imag[7] <= fft_m_data_tdata[43:24];
            Rx_tvalid <= 8'b10000000;
        end
        default:begin
            Rx_tvalid <= 8'b00000000;
        end
        endcase
    end
    else begin
        Rx_tvalid <= 8'b00000000;
    end
end
endmodule

