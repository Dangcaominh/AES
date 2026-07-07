`include "aes_cipher_top.v"
`include "aes_decipher_top.v"

module aes (
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire encrypt,     // 1 = encypt, 0 = decrypt
    input wire [127:0] data_in,
    input wire [127:0] key,
    input wire [3:0] mode,
    input wire [127:0] init_vector,
    input wire [15:0] segment_len,

    output reg [127:0] data_out,
    output reg ready
);

reg cipher_en;
reg decipher_en;
wire [127:0] cipher_text;
wire [127:0] plain_text;
wire cipher_ready;
wire decipher_ready;
wire [127:0] round_key_10;

always_ff @(posedge clk) begin
    if(enable) begin
        cipher_en <= 1;
    end
    else begin
        cipher_en <= 0;
        decipher_en <= 0;
    end

    
    if(cipher_ready) begin
        if(!encrypt) begin
            decipher_en <= 1;
        end
        else begin
            data_out <= cipher_text;
        end
    end
    
    if(decipher_ready) begin
        data_out <= plain_text;
    end
end



aes_cipher_top u_cipher_top (
    .clk(clk),
    .rst_n(rst_n),
    .cipher_key(key),
    .plain_text(data_in),
    .cipher_en(cipher_en),
    .cipher_text(cipher_text),
    .round_key_10(round_key_10),
    .cipher_ready(cipher_ready)
);

aes_decipher_top u_decipher_top (
    .clk(clk),
    .rst_n(rst_n),
    .round_key_10(round_key_10),
    .cipher_text(data_in),
    .decipher_en(decipher_en),
    .plain_text(plain_text),
    .decipher_ready(decipher_ready)
);



endmodule