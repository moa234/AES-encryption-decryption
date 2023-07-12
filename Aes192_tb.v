module Aes192_tb(
    input clk,
    input rst,
    output reg passenc = 0,
    output reg passdec = 0
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
reg [191:0] key = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
reg [127:0] expectedenc = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
reg [127:0] expecteddec = 128'h00112233445566778899aabbccddeeff;
reg mosi;
wire doneend;
wire donedec;

Aes #(.Nk(6),.Nr(12)) main(
    .clk(clk),
    .rst(rst),
    .cs1(cs1),
    .cs2(cs2),
    .mosi(mosi),
    .misod(misod),
    .doneenc(doneenc),
    .donedec(donedec),
    .misok(misok),
    .encrypted(encrypted),
    .decrypted(decrypted)
);

integer i = 0;
always @(posedge clk) begin
    if (rst) begin
        
    end
    else begin
        if (i < 129) begin
            if (!cs1) begin
                recieved = misod;
            end
        end
        else if (i < 129 + 193) begin
            if (!cs2) begin
                recieved = misok;
            end
        end
        if(donedec)
            passdec = (decrypted == expecteddec);
        if(doneenc)
            passenc = (encrypted == expectedenc);
    end
end

always @(negedge clk, posedge rst) begin
    if (rst) begin
		mosi = data[127];
        i = 0;
    end
    else begin
        if (i < 129) begin
            if (!cs1) begin
                mosi = data[127];
                data = {data[126:0], recieved};
                i = i + 1;
                if (i == 129) begin
                    cs1 = 1;
                    mosi = key[191];
                end
            end
        end
        else if (i < 129 + 193) begin
            if (i == 129) begin
                cs2 = 0;
            end
            if (!cs2) begin
                mosi = key[191];
                key = {key[190:0], recieved};
                i = i + 1;
                if (i == 129 + 193) begin
                    cs1 = 1;
                    cs2 = 1;
                end
            end
        end
    end
end

endmodule


