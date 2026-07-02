function automatic logic [31:0] aes_rcon (
    input logic [3:0] round
);
    case(round)
        4'd01 : return 32'h0100_0000;
        4'd02 : return 32'h0200_0000;
        4'd03 : return 32'h0400_0000;
        4'd04 : return 32'h0800_0000;
        4'd05 : return 32'h1000_0000;
        4'd06 : return 32'h2000_0000;
        4'd07 : return 32'h4000_0000;
        4'd08 : return 32'h8000_0000;
        4'd09 : return 32'h1b00_0000;
        4'd10 : return 32'h3600_0000;
        default : return 32'h3600_0000;
    endcase

endfunction