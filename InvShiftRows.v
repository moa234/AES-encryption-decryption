module InvShiftRows (
    input [127:0] data_in,
    output reg [127:0] data_out
);
    
always @(*) begin
    data_out[127 -: 8] = data_in[127 -: 8];
    data_out[95  -: 8] = data_in[95  -: 8];
    data_out[63  -: 8] = data_in[63  -: 8];
    data_out[31  -: 8] = data_in[31  -: 8];
    
    data_out[119 -: 8] = data_in[23 -: 8];
    data_out[87  -: 8] = data_in[119 -: 8];
    data_out[55  -: 8] = data_in[87  -: 8];
    data_out[23  -: 8] = data_in[55  -: 8];
    
    data_out[111 -: 8] = data_in[47 -: 8];
    data_out[79  -: 8] = data_in[15 -: 8];
    data_out[47  -: 8] = data_in[111 -: 8];
    data_out[15  -: 8] = data_in[79  -: 8];
    
    data_out[103 -: 8] = data_in[71 -: 8];
    data_out[71  -: 8] = data_in[39 -: 8];
    data_out[39  -: 8] = data_in[7  -: 8];
    data_out[7   -: 8] = data_in[103 -: 8];
end

endmodule
