`include "aes_subbytes.sv"
`include "aes_shift_rows.sv"
`include "aes_mix_columns.sv"

module aes_cipher_core(
    // input
    input logic clk,
    input logic rst_n,
    input logic [127 : 0] cipher_key,
    input logic [127 : 0] plain_text,
    input logic cipher_en,
    input logic [127 : 0] round_key,
    // output
    output logic [127 : 0] cipher_text,
    output logic cipher_ready,
    output logic [3 : 0] round_num,
    output logic round_key_en
);

logic [127:0] cipher_text_reg;

assign cipher_text = cipher_text_reg;

logic [3:0] cipher_counter;

assign round_num = cipher_counter;

logic [127:0] afterSubBytes;

aes_subbytes u_subbytes(cipher_text_reg, afterSubBytes);

logic [127:0] afterShiftRows;

aes_shift_rows u_shift_rows(afterSubBytes, afterShiftRows);

logic [127:0] afterMixColumns;

aes_mix_columns u_mix_columns(afterShiftRows, afterMixColumns);

logic [127:0] afterAddRoundKey;
assign afterAddRoundKey = (cipher_counter == 4'd10) ? round_key ^ afterShiftRows : round_key ^ afterMixColumns;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cipher_counter <= 0;
        cipher_ready <= 0;
    end
    else if(cipher_counter == 0) begin
        if(cipher_en) begin
            cipher_ready <= 0;
            cipher_counter <= 1;
            round_key_en <= 1;
            cipher_text_reg <= plain_text ^ cipher_key;
        end
    end
    else begin
        cipher_text_reg <= afterAddRoundKey;

        if (cipher_counter == 10) begin
            cipher_ready   <= 1;
            round_key_en   <= 0;
            cipher_counter <= 0;
        end
        else begin
            cipher_counter <= cipher_counter + 1;
        end
    end
end

endmodule