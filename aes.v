module aes (
    input wire clk,
    input wire rst_n,
    input wire cipher_en,
    input wire decipher_en,
    input wire [127:0] data_in,
    input wire [127:0] key,
    input wire [3:0] mode,
    input wire [127:0] init_vector,
    input wire [15:0] segment_len,

    output reg [127:0] data_out,
    output reg ready
);

endmodule