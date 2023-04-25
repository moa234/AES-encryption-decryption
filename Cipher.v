module Cipher (
    input [127:0] data_in,
    input [127:0] key,
    output reg[127:0] data_out
);
reg [127:0] state[39:0];
// AddRoundKey addr (
//     .data_in(data_in),
//     //.key(key),
//     .data_out(state[0])
// );

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
        .key(key),
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
// AddRoundKey addr2 (
//     .data_in(state[38]),
//     .key(key),
//     .data_out(data_out)
// );

    
endmodule