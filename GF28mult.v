module GF28mult #(
    parameter N = 2
)
(
    input [7: 0] data_in,
    output reg[7: 0] data_out
);
reg [7:0] p;
reg [7:0] a;
reg [7:0] b;
reg ahi;
integer i;
always @(data_in) 
begin
    b = data_in;
    p = 8'b0;
    a = N;
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
    data_out = p;
end
endmodule