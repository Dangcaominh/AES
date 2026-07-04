function automatic logic [7:0] mul2 (
    input logic [7:0] in
);

if(in[7])
    return (in << 1) ^ 8'h1b;
else
    return (in << 1);

endfunction

function automatic logic [7:0] mul3 (
    input logic [7:0] in
);

return (mul2(in) ^ in);

endfunction

function automatic logic [7:0] mul9 (
    input logic [7:0] in
);
    return (mul2(mul2(mul2(in))) ^ in);
endfunction

function automatic logic [7:0] mulB (
    input logic [7:0] in
);
    return (mul2(mul2(mul2(in))) ^ mul2(in) ^ in);
endfunction

function automatic logic [7:0] mulD (
    input logic [7:0] in
);
    return (mul2(mul2(mul2(in))) ^ mul2(mul2(in)) ^ in);
endfunction

function automatic logic [7:0] mulE (
    input logic [7:0] in
);
    return (mul2(mul2(mul2(in))) ^ mul2(mul2(in)) ^ mul2(in));
endfunction

module aes_mix_columns (
    input logic [127:0] state_in,
    output logic [127:0] state_out
);

genvar i;

generate
    for(i = 0; i < 4; i++) begin: GEN_COL
        logic [7:0] a0, a1, a2, a3;
        logic [7:0] b0, b1, b2, b3;

        assign {a0, a1, a2, a3} = state_in[31 + 32 * i : 0 + 32 * i];
        assign state_out[31 + 32 * i : 0 + 32 * i] = {b0, b1, b2, b3};


        assign b0 = mul2(a0) ^ mul3(a1) ^ a2 ^ a3;
        assign b1 = a0 ^ mul2(a1) ^ mul3(a2) ^ a3;
        assign b2 = a0 ^ a1 ^ mul2(a2) ^ mul3(a3);
        assign b3 = mul3(a0) ^ a1 ^ a2 ^ mul2(a3);
    end
endgenerate

endmodule

module aes_inv_mix_columns (
    input logic [127:0] state_in,
    output logic [127:0] state_out
);

genvar i;

generate
    for(i = 0; i < 4; i++) begin: GEN_COL
        logic [7:0] a0, a1, a2, a3;
        logic [7:0] b0, b1, b2, b3;

        assign {a0, a1, a2, a3} = state_in[31 + 32 * i : 0 + 32 * i];
        assign state_out[31 + 32 * i : 0 + 32 * i] = {b0, b1, b2, b3};


        assign b0 = mulE(a0) ^ mulB(a1) ^ mulD(a2) ^ mul9(a3);
        assign b1 = mul9(a0) ^ mulE(a1) ^ mulB(a2) ^ mulD(a3);
        assign b2 = mulD(a0) ^ mul9(a1) ^ mulE(a2) ^ mulB(a3);
        assign b3 = mulB(a0) ^ mulD(a1) ^ mul9(a2) ^ mulE(a3);
    end
endgenerate

endmodule