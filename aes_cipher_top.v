`include "aes_cipher_core.sv" 
`include "aes_key_expansion.sv"

module aes_cipher_top(
    // input
    input wire clk,
    input wire rst_n,
    input wire [127 : 0] cipher_key,
    input wire [127 : 0] plain_text,
    input wire cipher_en,
    // output
    output reg [127 : 0] cipher_text,
    output reg cipher_ready
);

wire [127 : 0] round_key;
wire [3 : 0] round_num;
wire rkey_en;


aes_cipher_core u_cipher(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .cipher_key(cipher_key),
    .plain_text(plain_text),
    .cipher_en(cipher_en),
    .round_key(round_key),
    // output
    .cipher_text(cipher_text),
    .cipher_ready(cipher_ready),
    .round_num(round_num),
    .round_key_en(rkey_en)
);

aes_key_expansion u_expansion(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .cipher_key(cipher_key),
    .cipher_en(cipher_en),
    .round_num(round_num),
    .rkey_en(rkey_en),
    // output
    .round_key_out(round_key)
);

endmodule