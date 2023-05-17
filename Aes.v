module Aes #(parameter Nk = 4, Nr = 10) (
    input clk,
    input rst,
    input cs1,
    input cs2,
    input mosi,
    output misod,
    output donedec,
    output doneenc,
	output misok,
    output [127:0] encrypted,
    output [127:0] decrypted
);

wire [127:0] data_in;
wire [Nk * 32 - 1:0] key;
wire [(Nr + 1) * 128 - 1:0] w;
wire ddone;
wire kdone;
wire cdone;
wire expdone;
wire [127:0] encrypteddata;

Spi #(.Nr(Nr), .Nk(Nk), .datasize(128))d (
    .clk(clk),
    .rst(rst),
    .cs(cs1),
    .miso(misod),
    .mosi(mosi),
    .done(ddone),
    .data(data_in)
);

KeyExpansion #(.Nr(Nr), .Nk(Nk)) kex(
    .key_in(key),
    .key_out(w),
    .rst(rst),
    .en(kdone),
    .clk(clk),
    .done(expdone)
);

Spi #(.Nr(Nr), .Nk(Nk), .datasize(Nk * 32)) k  (
    .clk(clk),
    .rst(rst),
    .cs(cs2),
    .miso(misok),
    .mosi(mosi),
    .done(kdone),
    .data(key)
);

Cipher #(.Nr(Nr), .Nk(Nk)) enc(
    .clk(clk),
    .data_in(data_in),
    .w(w),
    .rst(rst),
    .done(cdone),
    .en(expdone & ddone),
    .data_out(encrypteddata)
);

assign encrypted = encrypteddata;
assign doneenc = cdone;

InvCipher #(.Nr(Nr), .Nk(Nk)) dec(
    .clk(clk),
    .data_in(encrypteddata),
    .w(w),
    .rst(rst),
    .en(cdone),
    .done(donedec),
    .data_out(decrypted)
);
    
endmodule