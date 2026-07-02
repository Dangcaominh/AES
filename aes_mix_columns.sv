function automatic logic [7:0] mul2 (
    input logic [7:0] in
);
begin
    if(in[7])
        return (in << 1) ^ 8'h1b;
    else
        return (in << 1);
end
endfunction

function automatic logic [7:0] mul3 (
    input logic [7:0] in
);
begin
    if(in[7])
        return (in << 1) ^ 8'h1b ^ in;
    else
        return (in << 1) ^ in;
end
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