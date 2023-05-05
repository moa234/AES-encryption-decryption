module AddRoundKey (
    input [127:0] data_in,
    input [127:0] key,
    output reg[127:0] data_out
);
  
always @(*) begin
  
	data_out = data_in ^ key;
end

endmodule