`include "aes_subbytes.sv"
`include "aes_shift_rows.sv"
`include "aes_mix_columns.sv"

module aes_decipher_core(
    // input
    input logic clk,
    input logic rst_n,
    input logic [127 : 0] round_key_10,
    input logic [127 : 0] cipher_text,
    input logic decipher_en,
    input logic [127 : 0] round_key_inv,
    // output
    output logic [127 : 0] plain_text,
    output logic decipher_ready,
    output logic [3 : 0] round_num,
    output logic round_key_en
);

logic [127:0] decipher_text_reg;

assign plain_text = decipher_text_reg;

logic [3:0] decipher_counter;

assign round_num = decipher_counter;

logic [127:0] afterInvShiftRows;

aes_inv_shift_rows u_inv_shift_rows (decipher_text_reg, afterInvShiftRows);

logic [127:0] afterInvSubBytes;

aes_inv_subbytes u_inv_subbytes(afterInvShiftRows, afterInvSubBytes);

logic [127:0] afterAddRoundKey;

assign afterAddRoundKey = afterInvSubBytes ^ round_key_inv;

logic [127:0] afterInvMixColumns;

aes_inv_mix_columns u_inv_mix_columns(afterAddRoundKey, afterInvMixColumns);


always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        decipher_counter <= 0;
        decipher_ready <= 0;
    end
    else if(decipher_counter == 0) begin
        if(decipher_en) begin
            decipher_ready <= 0;
            decipher_counter <= 1;
            round_key_en <= 1;
            decipher_text_reg <= cipher_text ^ round_key_10;
        end
    end
    else begin
        if (decipher_counter == 10) begin
            decipher_text_reg <= afterAddRoundKey;
            decipher_ready   <= 1;
            round_key_en   <= 0;
            decipher_counter <= 0;
        end
        else begin
            decipher_text_reg <= afterInvMixColumns;
            decipher_counter <= decipher_counter + 1;
        end
    end
end

endmodule