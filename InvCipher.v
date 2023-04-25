module InvCipher #(parameter Nk = 4, Nr = 10)(
    input [127:0] data_in,
    input [Nk * 32 - 1:0] key,
    output reg[127:0] data_out
);
wire [127:0] state[39:0];
wire [(Nr + 1) * 128 - 1:0] w;

KeyExpansion keyexp (
    .key_in(key),
    .key_out(w)
);

AddRoundKey invaddr (
    .data_in(data_in),
    .key(w[127 : 0]),
    .data_out(state[0])
);

genvar i;
for (i = 8;i >= 0; i = i - 1) begin
    InvShiftRows invsh (
        .data_in(state[32 - i * 4]),
        .data_out(state[32 - i * 4 + 1])
    );
    InvSubByte invsubb (
        .data_in(state[32 - i * 4 + 1]),
        .data_out(state[32 - i * 4 + 2])
    );
    AddRoundKey invaddr1 (
        .data_in(state[32 - i * 4 + 2]),
        .key(w[(Nr + 1) * 128 - 1 - (i + 1) * 128 -: 128]),
        .data_out(state[32 - i * 4 + 3])
    );
    InvMixColumns invmixc (
        .data_in(state[32 - i * 4 + 3]),
        .data_out(state[32 - i * 4 + 4])
    );
end
InvShiftRows invsh2 (
    .data_in(state[36]),
    .data_out(state[37])
);
InvSubByte invsubb2 (
    .data_in(state[37]),
    .data_out(state[38])
);
AddRoundKey invaddr2 (
    .data_in(state[38]),
    .key(w[(Nr + 1) * 128 - 1 -: 128]),
    .data_out(state[39])
);

assign data_out = state[39];
    
endmodule