module InvMixColumns (
    input [127:0] data_in,
    output reg[127:0] data_out
);
integer i;
always @(data_in) begin
    for (i = 0; i < 4; i = i + 1) begin
        data_out[127 - 32*i -: 8] = GF28mul('he,data_in[127 - 32*i -: 8]) ^ GF28mul('hb,data_in[119 - 32*i-: 8]) 
         ^ GF28mul('hd,data_in[111 - 32*i -: 8]) ^ GF28mul('h9,data_in[103 - 32*i -: 8]);

        data_out[119 - 32*i -: 8] = GF28mul('h9,data_in[127 - 32*i -: 8]) ^ GF28mul('he,data_in[119 - 32*i-: 8]) 
         ^ GF28mul('hb,data_in[111 - 32*i -: 8]) ^ GF28mul('hd,data_in[103 - 32*i -: 8]);

        data_out[111 - 32*i -: 8] = GF28mul('hd,data_in[127 - 32*i -: 8]) ^ GF28mul('h9,data_in[119 - 32*i-: 8]) 
         ^ GF28mul('he,data_in[111 - 32*i -: 8]) ^ GF28mul('hb,data_in[103 - 32*i -: 8]);

        data_out[103 - 32*i -: 8] = GF28mul('hb,data_in[127 - 32*i -: 8]) ^ GF28mul('hd,data_in[119 - 32*i-: 8]) 
         ^ GF28mul('h9,data_in[111 - 32*i -: 8]) ^ GF28mul('he,data_in[103 - 32*i -: 8]);
    end
end

function [7:0] GF28mul;
    input [7:0] a, b;
    reg [7:0] p;
    reg ahi;
    integer i;
    begin
        p = 8'b0;
        for (i = 0; i < 8; i = i + 1)
        begin
            if (b[0] == 1'b1)
            begin
                p = a ^ p;
            end
            ahi = a[7];
            a = a << 1;
            if (ahi == 1'b1) begin
                a = a ^ 8'h1b;
            end
            b = b >> 1;
        end
        GF28mul = p;
    end
endfunction 

endmodule