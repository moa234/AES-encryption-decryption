module encrpytiondecryptionbench #(parameter Nk = 4, Nr = 10) ();

reg [127:0] data_in;
reg [127:0] key;
reg rst;
reg clk;
wire [127:0] encrypteddata;
wire [127:0] decrypted;
wire [(Nr + 1) * 128 - 1:0] w;
wire expdone;
wire cdone;
wire donedec;

KeyExpansion #(.Nr(Nr), .Nk(Nk)) kex(
    .key_in(key),
    .key_out(w),
    .rst(rst),
    .en(1),
    .clk(clk),
    .done(expdone)
);

Cipher #(.Nr(Nr), .Nk(Nk)) enc(
    .clk(clk),
    .data_in(data_in),
    .w(w),
    .rst(rst),
    .done(cdone),
    .en(expdone),
    .data_out(encrypteddata)
);

InvCipher #(.Nr(Nr), .Nk(Nk)) dec(
    .clk(clk),
    .data_in(encrypteddata),
    .w(w),
    .rst(rst),
    .en(cdone),
    .done(donedec),
    .data_out(decrypted)
);
    
initial begin
    forever begin
        #5 clk = ~clk;
    end
end

initial begin
    clk = 0;
    data_in = 128'h00112233445566778899aabbccddeeff;
    key = 128'h000102030405060708090a0b0c0d0e0f;
    rst = 1;
    #10 rst = 0;
    while (!donedec) begin
        #10 ;
    end
    #10
    $display("encrypted: %h", encrypteddata);
    $display("decrypted: %h", decrypted);
    $finish;
end

endmodule