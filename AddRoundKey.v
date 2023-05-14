module AddRoundKey (
    input [127:0] data_in,
    input [127:0] key,
    output [127:0] data_out
);
  

	assign data_out = data_in ^ key;

endmodule