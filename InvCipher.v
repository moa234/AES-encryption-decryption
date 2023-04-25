module InvCipher (
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
    InvShiftrows invsh (
        .data_in(state[i * 4]),
        .data_out(state[i * 4 + 1])
    );
    InvSubByte invsubb (
        .data_in(state[i * 4 + 1]),
        .data_out(state[i * 4 + 2])
    );
    // AddRoundKey addr (
    //     .data_in(state[i * 4 + 2]),
    //     .key(key),
    //     .data_out(state[i * 4 + 3])
    // );
    InvMixColumns invmixc (
        .data_in(state[i * 4 + 3]),
        .data_out(state[i * 4 + 4])
    );
end
InvShiftrows invsh2 (
    .data_in(state[36]),
    .data_out(state[37])
);
InvSubByte invsubb2 (
    .data_in(state[37]),
    .data_out(state[38])
);
// AddRoundKey addr2 (
//     .data_in(state[38]),
//     .key(key),
//     .data_out(data_out)
// );

    
endmodule