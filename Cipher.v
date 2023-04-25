module Cipher #(parameter Nk = 4, Nr = 10)(
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

AddRoundKey addr (
    .data_in(data_in),
    .key(w[(Nr + 1) * 128 - 1 -: 128]),
    .data_out(state[0])
);

genvar i;
for (i = 0;i < 9; i = i + 1) begin
    SubByte subb (
        .data_in(state[i * 4]),
        .data_out(state[i * 4 + 1])
    );
    ShiftRows shiftr (
        .data_in(state[i * 4 + 1]),
        .data_out(state[i * 4 + 2])
    );
    MixColumns mixc (
        .data_in(state[i * 4 + 2]),
        .data_out(state[i * 4 + 3])
    );
    AddRoundKey addr (
        .data_in(state[i * 4 + 3]),
        .key(w[(Nr + 1) * 128 - 1 - (i + 1) * 128 -: 128]),
        .data_out(state[i * 4 + 4])
    );
end
SubByte subb2 (
    .data_in(state[36]),
    .data_out(state[37])
);
ShiftRows shiftr2 (
    .data_in(state[37]),
    .data_out(state[38])
);
AddRoundKey addr2 (
    .data_in(state[38]),
    .key(w[127 : 0]),
    .data_out(state[39])
);

assign data_out = state[39];

endmodule