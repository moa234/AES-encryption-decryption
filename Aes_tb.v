module Aes_tb;

reg clk;
wire sclk;

reg rst;

reg cs1;
reg cs2;

wire scs1;
wire scs2;

wire done;

reg miso;
reg [128+Nk*32-1:0] data;

wire mosi;

wire misod;
wire misok;

wire [127:0] encrypted;
wire [127:0] decrypted;


Spi_master inst(
  .clk(clk),
  .rst(rst),
  .cs1 (cs1),
  .cs2 (cs2),
  .data(data),
  .miso(miso),

  .sclk(sclk),
  .scs1 (scs1),
  .scs2 (scs2),
  .mosi(mosi),
  .done(done)

);

Aes inst1(
 .clk(sclk),
 .rst(rst),
 .cs1(scs1),
 .cs2(scs2),
 .mosi(mosi),
 .misod(misod),
 .misok(misok),
 .encrypted(encrypted),
 .decrypted(decrypted)

);

initial begin
clk=0;
rst=1;
cs1=0;
cs2=1;
cs=0;
data<=128'h00112233445566778899aabbccddeeff;

end   

always #5 clk=~clk;


initial begin
#640 
data<=128'h000102030405060708090a0b0c0d0e0f;
cs2=0;
cs1=1;
#Nk*32*5 /* Nk*32*5 */
#400
end

endmodule


