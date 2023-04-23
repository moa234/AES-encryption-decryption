module MixColumns (
    input [127:0] data_in,
    output reg[127:0] data_out
);

reg [7:0] mule;
reg [7:0] muleout;
reg [7:0] mulb;
reg [7:0] mulbout;
reg [7:0] muld;
reg [7:0] muldout;
reg [7:0] mul9;
reg [7:0] mul9out;

GF28mult #(.N(14)) multe (
    .data_in(mule),
    .data_out(muleout)
);
GF28mult #(.N(11)) multb (
    .data_in(mulb),
    .data_out(mulbout)
);
GF28mult #(.N(13)) multd (
    .data_in(muld),
    .data_out(muldout)
);
GF28mult #(.N(9)) mult9 (
    .data_in(mul9),
    .data_out(mul9out)
);

always @(data_in) begin
    mule = data_in[127 -: 8];
    mulb = data_in[119 -: 8];
    muld = data_in[111 -: 8];
    mul9 = data_in[103 -: 8];
    data_out[127 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mul9 = data_in[127 -: 8];
    mule = data_in[119 -: 8];
    mulb = data_in[111 -: 8];
    muld = data_in[103 -: 8];
    data_out[119 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    muld = data_in[127 -: 8];
    mul9 = data_in[119 -: 8];
    mule = data_in[111 -: 8];
    mulb = data_in[103 -: 8];
    data_out[111 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mulb = data_in[127 -: 8];
    muld = data_in[119 -: 8];
    mul9 = data_in[111 -: 8];
    mule = data_in[103 -: 8];
    data_out[103 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mule = data_in[95 -: 8];
    mulb = data_in[87 -: 8];
    muld = data_in[79 -: 8];
    mul9 = data_in[71 -: 8];
    data_out[95 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mul9 = data_in[95 -: 8];
    mule = data_in[87 -: 8];
    mulb = data_in[79 -: 8];
    muld = data_in[71 -: 8];
    data_out[87 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    muld = data_in[95 -: 8];
    mul9 = data_in[87 -: 8];
    mule = data_in[79 -: 8];
    mulb = data_in[71 -: 8];
    data_out[79 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mulb = data_in[95 -: 8];
    muld = data_in[87 -: 8];
    mul9 = data_in[79 -: 8];
    mule = data_in[71 -: 8];
    data_out[71 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mule = data_in[63 -: 8];
    mulb = data_in[55 -: 8];
    muld = data_in[47 -: 8];
    mul9 = data_in[39 -: 8];
    data_out[63 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mul9 = data_in[63 -: 8];
    mule = data_in[55 -: 8];
    mulb = data_in[47 -: 8];
    muld = data_in[39 -: 8];
    data_out[55 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    muld = data_in[63 -: 8];
    mul9 = data_in[55 -: 8];
    mule = data_in[47 -: 8];
    mulb = data_in[39 -: 8];
    data_out[47 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mulb = data_in[63 -: 8];
    muld = data_in[55 -: 8];
    mul9 = data_in[47 -: 8];
    mule = data_in[39 -: 8];
    data_out[39 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mule = data_in[31 -: 8];
    mulb = data_in[23 -: 8];
    muld = data_in[15 -: 8];
    mul9 = data_in[7 -: 8];
    data_out[31 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mul9 = data_in[31 -: 8];
    mule = data_in[23 -: 8];
    mulb = data_in[15 -: 8];
    muld = data_in[7 -: 8];
    data_out[23 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    muld = data_in[31 -: 8];
    mul9 = data_in[23 -: 8];
    mule = data_in[15 -: 8];
    mulb = data_in[7 -: 8];
    data_out[15 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;

    mulb = data_in[31 -: 8];
    muld = data_in[23 -: 8];
    mul9 = data_in[15 -: 8];
    mule = data_in[7 -: 8];
    data_out[7 -: 8] = muleout ^ mulbout ^ muldout ^ mul9out;
end

endmodule