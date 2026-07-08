`ifndef AES_SUBBYTES
`define AES_SUBBYTES

`include "aes_sbox.sv"

module aes_subbytes (
    input logic [127:0] state_in,
    output logic [127:0] state_out
);

genvar i;

generate
    for(i = 0; i < 16; i++) begin: BYTE_TRAVERSAL
        assign state_out[7 + 8*i : 8*i] = aes_sbox(state_in[7 + 8*i : 8*i]);
    end
endgenerate

endmodule

module aes_inv_subbytes (
    input logic [127:0] state_in,
    output logic [127:0] state_out
);

genvar i;

generate
    for(i = 0; i < 16; i++) begin: BYTE_TRAVERSAL
        assign state_out[7 + 8*i : 8*i] = aes_inv_sbox(state_in[7 + 8*i : 8*i]);
    end
endgenerate

endmodule

`endif