function automatic logic[7:0] affine (
    input logic [7:0] x
);

    logic [7:0] y;
    localparam logic [7:0] C = 8'h63;
    
    for(int i = 0; i < 8; i++) begin
        y[i] = x[i] ^ x[(i + 4) % 8] ^ x[(i + 5) % 8] ^ x[(i + 6) % 8] ^ x[(i + 7) % 8] ^ C[i];
    end

    return y;

endfunction

function automatic logic[7:0] inv_affine (
    input logic [7:0] y
);

    logic [7:0] x;
    localparam logic [7:0] D = 8'h5;
    
    for(int i = 0; i < 8; i++) begin
        x[i] = y[(i + 2) % 8] ^ y[(i + 5) % 8] ^ x[(i + 7) % 8] ^ D[i];
    end

    return x;

endfunction

localparam logic [63:0] IMP_MATRIX = {
    8'b10100000,
    8'b11011110,
    8'b10101100,
    8'b10101110,
    8'b11000110,
    8'b10011110,
    8'b01010010,
    8'b01000011
};

function automatic logic [7:0] Imp (
    input logic [7:0] q
);
    logic [7:0] result;
    for (int i = 0; i < 8; i++) begin
        result[7-i] = ^(IMP_MATRIX[(7-i)*8 +: 8] & q);
    end
    return result;
endfunction

localparam logic [63:0] IMP_INV_MATRIX = {
    8'b11100010,
    8'b01000100,
    8'b01100010,
    8'b01110110,
    8'b00111110,
    8'b10011110,
    8'b00110000,
    8'b01110101
};

function automatic logic [7:0] ImpInv (
    input logic [7:0] q
);
    logic [7:0] result;
    for (int i = 0; i < 8; i++) begin
        result[7-i] = ^(IMP_INV_MATRIX[(7-i)*8 +: 8] & q);
    end
    return result;
endfunction


function automatic logic[3:0] S (
    input logic [3:0] q
);
    return {
        q[3], 
        q[3] ^ q[2],
        q[2] ^ q[1],
        q[3] ^ q[1] ^ q[0]
    };
endfunction

function automatic logic[3:0] C (
    input logic [3:0] q
);
    return {
        q[2] ^ q[0], 
        q[3] ^ q[2] ^ q[1] ^ q[0],
        q[3],
        q[2]
    };
endfunction

localparam logic [1:0] PHI = 2'b10;

function automatic logic[3:0] X (
    input logic [3:0] q,
    input logic [3:0] w
);
    logic [1:0] qH, qL;
    logic [1:0] wH, wL;
    logic [1:0] kH, kL;

    {qH, qL} = q;
    {wH, wL} = w;

    kH = mulGf22(qH ^ qL, wH ^ wL) ^ mulGf22(qL, wL);
    kL = mulGf22(mulGf22(qH, wH), PHI) ^ mulGf22(qL, wL);

    return {kH, kL};

endfunction

function automatic logic[1:0] mulGf22 (
    input logic [1:0] q,
    input logic [1:0] w
);

    return {
        (q[1] & w[1]) ^ (q[0] & w[1]) ^ (q[1] & w[0]), 
        (q[1] & w[1]) ^ (q[0] & w[0])
    };

endfunction

function automatic logic[3:0] inv4 (
    input logic [3:0] in
);
    case(in)
    4'h0 : return 4'h0;
    4'h1 : return 4'h1;
    4'h3 : return 4'h2;
    4'h2 : return 4'h3;
    4'hf : return 4'h4;
    4'hc : return 4'h5;
    4'h9 : return 4'h6;
    4'hb : return 4'h7;
    4'ha : return 4'h8;
    4'h6 : return 4'h9;
    4'h8 : return 4'ha;
    4'h7 : return 4'hb;
    4'h5 : return 4'hc;
    4'he : return 4'hd;
    4'hd : return 4'he;
    4'h4 : return 4'hf;
    endcase                                                                                 
endfunction

function automatic logic [7:0] inv8 (
    input logic [7:0] q
);

logic [7:0] a;
logic [3:0] aH, aL;
logic [3:0] b;
logic [7:0] result;

a = Imp(q);

{aH, aL} = a;

b = inv4(C(S(aH)) ^ (X(aL, aH ^ aL)));

result = ImpInv({X(b, aH), X(b, aH ^ aL)});

return result;

endfunction

function automatic logic [7:0] aes_sbox (
    input logic [7:0] sbox_in
);

return affine(inv8(sbox_in));

endfunction

function automatic logic [7:0] aes_inv_sbox (
    input logic [7:0] sbox_in
);

return inv8(inv_affine(sbox_in));

endfunction

