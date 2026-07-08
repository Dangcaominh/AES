module tb_cipher_top;
  //input
  reg clk_sys;
  reg rst_n;
  reg	[127:0]	cipher_key;
  reg	[127:0]	plain_text;
  reg cipher_en;
  //output
  wire [127:0] cipher_text;
  wire         cipher_ready;
  wire [127:0] round_key_10;

  aes_cipher_top aes_cipher_top(
  //input
  clk_sys,
  rst_n,
  cipher_key,
  plain_text,
  cipher_en,
  //output
  cipher_text,
  round_key_10,
  cipher_ready
  );
  
  initial begin
    $dumpfile("cipher_wave.vcd");
    $dumpvars(0, tb_cipher_top);

    clk_sys = 0;
    rst_n = 0;
    cipher_key = 0;
    plain_text = 0;
    cipher_en = 0;
  end
  initial begin
    forever #5 clk_sys = ~clk_sys;
  end
  initial begin
    #16
    rst_n = 1;
    #10
    cipher_en = 1;
    plain_text = 128'h00112233445566778899aabbccddeeff;
    cipher_key = 128'h000102030405060708090a0b0c0d0e0f;
    #10
    cipher_en = 0;
    #120
    $display ("---- cipher_text: %32h - READY: %1b", cipher_text[127:0], cipher_ready);
    $display ("---- round_key_10: %32h\n", round_key_10[127:0]);
    #10
    cipher_en = 1;
    plain_text = 128'h00112233445566778899aabbccddeeff;
    cipher_key = 128'ha5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5;
    #10
    cipher_en = 0;
    #120
    $display ("---- cipher_text: %32h - READY: %1b", cipher_text[127:0], cipher_ready);
    $display ("---- round_key_10: %32h\n", round_key_10[127:0]);
    $finish;
  end

endmodule