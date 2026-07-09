module tb_top;
  //input
  reg clk_sys;
  reg rst_n;
  reg [127:0] cipher_text;
  reg [127:0] cipher_key;
  reg decipher_en;
  //output
  wire [127:0] plain_text;
  wire         decipher_ready;
  //
  aes aes (
  //input
  clk_sys,
  rst_n,
  decipher_en,
  1'b0,
  cipher_text,
  cipher_key,
  4'b0,
  128'b0,
  16'b0,
  //output
  plain_text,
  decipher_ready
  );
 
  initial begin    
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_top);
    clk_sys = 0;
    rst_n = 0;
    cipher_key = 0;
    cipher_text = 0;
    decipher_en = 0;
  end  initial begin    forever #5 clk_sys = ~clk_sys;
  end
  initial begin
    #16
    rst_n = 1;
    #10
    decipher_en = 1;
    cipher_text = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    cipher_key = 128'h000102030405060708090a0b0c0d0e0f;
    #10
    decipher_en = 0;
    #240
    $display ("---- plain_text: %32h - READY: %1b\n", plain_text[127:0], decipher_ready);
    #10
    decipher_en = 1;
    cipher_text = 128'hdaba0685a6b6ef1d096f7980accf3ac5;
    cipher_key = 128'h13111d7fe3944a17f307a78b4d2b30c5;
    #10
    decipher_en = 0;
    #240
    $display ("---- plain_text: %32h - READY: %1b\n", plain_text[127:0], decipher_ready);
    $stop;
  end
endmodule