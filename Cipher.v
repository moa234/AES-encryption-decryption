module Cipher #(parameter Nk = 4, Nr = 10)(
    input [127:0] data_in,
    input clk,
    input [Nk * 32 - 1:0] key,
    output reg[127:0] data_out
);
wire [127:0] state[Nr * 4 - 1:0];
wire [(Nr + 1) * 128 - 1:0] w;

reg [127:0] last;
integer k = 0;

KeyExpansion keyexp (
    .key_in(key),
    .key_out(w)
);

AddRoundKey addr (
    .data_in(data_in),
    .key(w[(Nr + 1) * 128 - 1 -: 128]),
    .data_out(state[0])
);
always @(posedge clk) begin
    if (k == 0) begin
        last = state[0];
    end
    else if(k < Nr - 1) begin
        last = state[4];
    end
    else if(k == Nr - 1) begin
        data_out = state[7];
    end
    
    k = k + 1;
end
SubBytes subb (
    .data_in(last),
    .data_out(state[1])
);
ShiftRows shiftr (
    .data_in(state[1]),
    .data_out(state[2])
);
MixColumns mixc (
    .data_in(state[2]),
    .data_out(state[3])
);
AddRoundKey addr1 (
    .data_in(state[3]),
    .key(w[(Nr + 1) * 128 - 1 - k * 128 -: 128]),
    .data_out(state[4])
);

SubBytes subb2 (
    .data_in(state[4]),
    .data_out(state[5])
);
ShiftRows shiftr2 (
    .data_in(state[5]),
    .data_out(state[6])
);
AddRoundKey addr2 (
    .data_in(state[6]),
    .key(w[127 : 0]),
    .data_out(state[7])
);

endmodule