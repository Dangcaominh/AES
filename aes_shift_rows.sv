module aes_shift_rows(
    input logic [127:0] state_in,
    output logic [127:0] state_out
);

logic [7:0] a0, a1, a2, a3;
logic [7:0] b0, b1, b2, b3;
logic [7:0] c0, c1, c2, c3;
logic [7:0] d0, d1, d2, d3;

assign {a0, a1, a2, a3, 
        b0, b1, b2, b3, 
        c0, c1, c2, c3, 
        d0, d1, d2, d3} = state_in;

assign state_out = {
    a0, b1, c2, d3,
    b0, c1, d2, a3,
    c0, d1, a2, b3,
    d0, a1, b2, c3
};

endmodule