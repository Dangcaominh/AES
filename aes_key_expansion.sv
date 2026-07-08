`ifndef AES_KEY_EXPANSION
`define AES_KEY_EXPANSION

`include "aes_rcon.sv"

module aes_key_expansion(
    // input
    input logic clk,
    input logic rst_n,
    input logic [127:0] cipher_key,
    input logic cipher_en,
    input logic rkey_en,
    input logic [3:0] round_num,

    // output
    output logic [127:0] round_key_out
);

logic [127:0] current_key;
logic [127:0] next_key;

logic [31:0] w0, w1, w2, w3;
logic [31:0] w4, w5, w6, w7;

assign {w0, w1, w2, w3} = current_key;

logic [7:0] b0, b1, b2, b3;
assign {b0, b1, b2, b3} = w3;
logic [31:0] rot_sub_word;

assign rot_sub_word = {aes_sbox(b1), aes_sbox(b2), aes_sbox(b3), aes_sbox(b0)};

assign w4 = w0 ^ rot_sub_word ^ aes_rcon(round_num);

assign w5 = w4 ^ w1;
assign w6 = w5 ^ w2;
assign w7 = w6 ^ w3;

assign next_key = {w4, w5, w6, w7};

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        current_key <= 0;
    else begin
        if(cipher_en)
            current_key <= cipher_key;
        else if(rkey_en)
            current_key <= next_key;
    end
end

assign round_key_out = next_key;

endmodule

module aes_inv_key_expansion(
    // input
    input logic clk,
    input logic rst_n,
    input logic decipher_en,
    input logic [127:0] round_key_10,
    input logic rkey_en,
    input logic [3:0] round_num,

    // output
    output logic [127:0] round_key_inv_out
);

logic [127:0] current_key;
logic [127:0] next_key;

logic [31:0] w4, w5, w6, w7;
logic [31:0] w0, w1, w2, w3;

assign {w4, w5, w6, w7} = current_key;

assign w1 = w4 ^ w5;
assign w2 = w5 ^ w6;
assign w3 = w6 ^ w7;

logic [7:0] b0, b1, b2, b3;
assign {b0, b1, b2, b3} = w3;
logic [31:0] rot_sub_word;

assign rot_sub_word = {aes_sbox(b1), aes_sbox(b2), aes_sbox(b3), aes_sbox(b0)};

assign w0 = w4 ^ rot_sub_word ^ aes_inv_rcon(round_num);

assign next_key = {w0, w1, w2, w3};

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        current_key <= 0;
    else begin
        if(decipher_en)
            current_key <= round_key_10;
        else if(rkey_en)
            current_key <= next_key;
    end
end

assign round_key_inv_out = next_key;

endmodule   

`endif