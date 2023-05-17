module Aes_tb(
    input clk,
    input rst,
    output reg pass = 0
);

reg cs1 = 0;
reg sclk;
reg cs2 = 1;
reg recieved;
wire misod;
wire misok;
wire [127:0] encrypted;
wire [127:0] decrypted;
reg [127:0] data = 128'h00112233445566778899aabbccddeeff;
reg [127:0] key = 128'h000102030405060708090a0b0c0d0e0f;
reg [127:0] expected = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
reg mosi;

Aes #(.Nk(4),.Nr(10)) main(
    .clk(clk),
    .rst(rst),
    .cs1(cs1),
    .cs2(cs2),
    .mosi(mosi),
    .misod(misod),
    .misok(misok),
    .encrypted(encrypted),
    .decrypted(decrypted)
);

integer i = 0;
always @(posedge (clk && (~cs1 || ~cs2)), posedge rst) begin
    if (rst) begin
        mosi = data[127];
        i = 0;
    end
    else begin
        if (i < 129) begin
            recieved = misod;
        end
        else if (i < 129 + 129) begin
            recieved = misok;
        end
    end
end

always @(negedge (clk && (~cs1 || ~cs2))) begin
    if (rst) begin
    end
    else begin
        if (i < 129) begin
            mosi = data[127];
            data = {data[126:0], recieved};
            i = i + 1;
            if (i == 129) begin
                cs1 = 1;
                cs2 = 0;
                mosi = key[127];
            end
        end
        else if (i < 129 + 129) begin
            mosi = key[127];
            key = {key[126:0], recieved};
            i = i + 1;
            if (i == 128 + 129) begin
                cs1 = 1;
                cs2 = 1;
            end
        end
    end
end

endmodule


