`include "aes_decipher_core.sv" 
`include "aes_key_expansion.sv"

module aes_decipher_top(
    // input
    input wire clk,
    input wire rst_n,
    input wire [127 : 0] round_key_10,
    input wire [127 : 0] cipher_text,
    input wire decipher_en,
    // output
    output wire [127 : 0] plain_text,
    output wire decipher_ready
);

wire [127 : 0] round_key_inv;
wire [3 : 0] round_num;
wire rkey_en;


aes_decipher_core u_decipher(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .round_key_10(round_key_10),
    .cipher_text(cipher_text),
    .decipher_en(decipher_en),
    .round_key_inv(round_key_inv),
    // output
    .plain_text(plain_text),
    .decipher_ready(decipher_ready),
    .round_num(round_num),
    .round_key_en(rkey_en)
);

aes_inv_key_expansion u_inv_expansion(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .round_key_10(round_key_10),
    .decipher_en(decipher_en),
    .round_num(round_num),
    .rkey_en(rkey_en),
    // output
    .round_key_inv_out(round_key_inv)
);

endmodule