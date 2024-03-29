module Cipher #(parameter Nk = 4, Nr = 10)(
    input [127:0] data_in,
    input [(Nr + 1) * 128 - 1:0] w,
    input rst,
    input en,
    output reg done = 0,
    input clk,
    output reg[127:0] data_out
);
reg [127:0] data;
reg [2:0] state = 'b000;

integer i = 0;
always @(posedge clk && en, posedge rst) begin
    if (rst) begin
        state = 'b000;
        i = 0;
    end
    else begin
        case (state)
            'b000:begin
                if (i == 0) begin
                    data = data_in;
                end
                data = AddRoundKey(data, w[(Nr + 1) * 128 - 1 - i * 128 -: 128]);
                if (i == Nr) begin
                    data_out = data;
                    done = 1;
                    state = 'b111;
                end
                else begin
                    state = 'b001;
                end
            end 
            'b001:begin
                data = SubBytes(data); 
                state = 'b010;
            end
            'b010:begin
                data = ShiftRows(data);
                if (i == Nr - 1) begin
                    i = i + 1;
                    state = 'b000;
                end 
                else begin
                    state = 'b011;
                end
            end
            'b011:begin
                data = MixColumns(data);
                state = 'b000;
                i = i + 1;
            end
            default:begin
                
            end
        endcase
    end
    
end

function [127:0] SubBytes;
	input [127:0] data_in;
	integer i;
	begin
		for (i = 0;i < 16; i = i + 1) begin
			SubBytes[i * 8 +: 8] = SubByte(data_in[i * 8 +: 8]);
		end
	end
endfunction

function [7:0] SubByte;
    input [7:0] data_in;
    case (data_in)
        8'h00: SubByte =8'h63;
        8'h01: SubByte =8'h7c;
        8'h02: SubByte =8'h77;
        8'h03: SubByte =8'h7b;
        8'h04: SubByte =8'hf2; 
        8'h05: SubByte =8'h6b;
        8'h06: SubByte =8'h6f;
        8'h07: SubByte =8'hc5;
        8'h08: SubByte =8'h30;
        8'h09: SubByte =8'h01;
        8'h0a: SubByte =8'h67;
        8'h0b: SubByte =8'h2b;
        8'h0c: SubByte =8'hfe;
        8'h0d: SubByte =8'hd7;
        8'h0e: SubByte =8'hab;
        8'h0f: SubByte =8'h76;
        8'h10: SubByte =8'hca;
        8'h11: SubByte =8'h82;
        8'h12: SubByte =8'hc9;
        8'h13: SubByte =8'h7d;
        8'h14: SubByte =8'hfa;
        8'h15: SubByte =8'h59;
        8'h16: SubByte =8'h47;
        8'h17: SubByte =8'hf0;
        8'h18: SubByte =8'had;
        8'h19: SubByte =8'hd4;
        8'h1a: SubByte =8'ha2;
        8'h1b: SubByte =8'haf;
        8'h1c: SubByte =8'h9c;
        8'h1d: SubByte =8'ha4;
        8'h1e: SubByte =8'h72;
        8'h1f: SubByte =8'hc0;
        8'h20: SubByte =8'hb7;
        8'h21: SubByte =8'hfd;
        8'h22: SubByte =8'h93;
        8'h23: SubByte =8'h26;
        8'h24: SubByte =8'h36;
        8'h25: SubByte =8'h3f;
        8'h26: SubByte =8'hf7;
        8'h27: SubByte =8'hcc;
        8'h28: SubByte =8'h34;
        8'h29: SubByte =8'ha5;
        8'h2a: SubByte =8'he5;
        8'h2b: SubByte =8'hf1;
        8'h2c: SubByte =8'h71;
        8'h2d: SubByte =8'hd8;
        8'h2e: SubByte =8'h31;
        8'h2f: SubByte =8'h15;
        8'h30: SubByte =8'h04;
        8'h31: SubByte =8'hc7;
        8'h32: SubByte =8'h23;
        8'h33: SubByte =8'hc3;
        8'h34: SubByte =8'h18;
        8'h35: SubByte =8'h96;
        8'h36: SubByte =8'h05;
        8'h37: SubByte =8'h9a;
        8'h38: SubByte =8'h07;
        8'h39: SubByte =8'h12;
        8'h3a: SubByte =8'h80;
        8'h3b: SubByte =8'he2;
        8'h3c: SubByte =8'heb;
        8'h3d: SubByte =8'h27;
        8'h3e: SubByte =8'hb2;
        8'h3f: SubByte =8'h75;
        8'h40: SubByte =8'h09;
        8'h41: SubByte =8'h83;
        8'h42: SubByte =8'h2c;
        8'h43: SubByte =8'h1a;
        8'h44: SubByte =8'h1b;
        8'h45: SubByte =8'h6e;
        8'h46: SubByte =8'h5a;
        8'h47: SubByte =8'ha0;
        8'h48: SubByte =8'h52;
        8'h49: SubByte =8'h3b;
        8'h4a: SubByte =8'hd6;
        8'h4b: SubByte =8'hb3;
        8'h4c: SubByte =8'h29;
        8'h4d: SubByte =8'he3;
        8'h4e: SubByte =8'h2f;
        8'h4f: SubByte =8'h84;
        8'h50: SubByte =8'h53;
        8'h51: SubByte =8'hd1;
        8'h52: SubByte =8'h00;
        8'h53: SubByte =8'hed;
        8'h54: SubByte =8'h20;
        8'h55: SubByte =8'hfc;
        8'h56: SubByte =8'hb1;
        8'h57: SubByte =8'h5b;
        8'h58: SubByte =8'h6a;
        8'h59: SubByte =8'hcb;
        8'h5a: SubByte =8'hbe;
        8'h5b: SubByte =8'h39;
        8'h5c: SubByte =8'h4a;
        8'h5d: SubByte =8'h4c;
        8'h5e: SubByte =8'h58;
        8'h5f: SubByte =8'hcf;
        8'h60: SubByte =8'hd0;
        8'h61: SubByte =8'hef;
        8'h62: SubByte =8'haa;
        8'h63: SubByte =8'hfb;
        8'h64: SubByte =8'h43;
        8'h65: SubByte =8'h4d;
        8'h66: SubByte =8'h33;
        8'h67: SubByte =8'h85;
        8'h68: SubByte =8'h45;
        8'h69: SubByte =8'hf9;
        8'h6a: SubByte =8'h02;
        8'h6b: SubByte =8'h7f;
        8'h6c: SubByte =8'h50;
        8'h6d: SubByte =8'h3c;
        8'h6e: SubByte =8'h9f;
        8'h6f: SubByte =8'ha8;
        8'h70: SubByte =8'h51;
        8'h71: SubByte =8'ha3;
        8'h72: SubByte =8'h40;
        8'h73: SubByte =8'h8f;
        8'h74: SubByte =8'h92;
        8'h75: SubByte =8'h9d;
        8'h76: SubByte =8'h38;
        8'h77: SubByte =8'hf5;
        8'h78: SubByte =8'hbc;
        8'h79: SubByte =8'hb6;
        8'h7a: SubByte =8'hda;
        8'h7b: SubByte =8'h21;
        8'h7c: SubByte =8'h10;
        8'h7d: SubByte =8'hff;
        8'h7e: SubByte =8'hf3;
        8'h7f: SubByte =8'hd2;
        8'h80: SubByte =8'hcd;
        8'h81: SubByte =8'h0c;
        8'h82: SubByte =8'h13;
        8'h83: SubByte =8'hec;
        8'h84: SubByte =8'h5f;
        8'h85: SubByte =8'h97;
        8'h86: SubByte =8'h44;
        8'h87: SubByte =8'h17;
        8'h88: SubByte =8'hc4;
        8'h89: SubByte =8'ha7;
        8'h8a: SubByte =8'h7e;
        8'h8b: SubByte =8'h3d;
        8'h8c: SubByte =8'h64;
        8'h8d: SubByte =8'h5d;
        8'h8e: SubByte =8'h19;
        8'h8f: SubByte =8'h73;
        8'h90: SubByte =8'h60;
        8'h91: SubByte =8'h81;
        8'h92: SubByte =8'h4f;
        8'h93: SubByte =8'hdc;
        8'h94: SubByte =8'h22;
        8'h95: SubByte =8'h2a;
        8'h96: SubByte =8'h90;
        8'h97: SubByte =8'h88;
        8'h98: SubByte =8'h46;
        8'h99: SubByte =8'hee;
        8'h9a: SubByte =8'hb8;
        8'h9b: SubByte =8'h14;
        8'h9c: SubByte =8'hde;
        8'h9d: SubByte =8'h5e;
        8'h9e: SubByte =8'h0b;
        8'h9f: SubByte =8'hdb;
        8'ha0: SubByte =8'he0;
        8'ha1: SubByte =8'h32;
        8'ha2: SubByte =8'h3a;
        8'ha3: SubByte =8'h0a;
        8'ha4: SubByte =8'h49;
        8'ha5: SubByte =8'h06;
        8'ha6: SubByte =8'h24;
        8'ha7: SubByte =8'h5c;
        8'ha8: SubByte =8'hc2;
        8'ha9: SubByte =8'hd3;
        8'haa: SubByte =8'hac;
        8'hab: SubByte =8'h62;
        8'hac: SubByte =8'h91;
        8'had: SubByte =8'h95;
        8'hae: SubByte =8'he4;
        8'haf: SubByte =8'h79;
        8'hb0: SubByte =8'he7;
        8'hb1: SubByte =8'hc8;
        8'hb2: SubByte =8'h37;
        8'hb3: SubByte =8'h6d;
        8'hb4: SubByte =8'h8d;
        8'hb5: SubByte =8'hd5;
        8'hb6: SubByte =8'h4e;
        8'hb7: SubByte =8'ha9;
        8'hb8: SubByte =8'h6c;
        8'hb9: SubByte =8'h56;
        8'hba: SubByte =8'hf4;
        8'hbb: SubByte =8'hea;
        8'hbc: SubByte =8'h65;
        8'hbd: SubByte =8'h7a;
        8'hbe: SubByte =8'hae;
        8'hbf: SubByte =8'h08;
        8'hc0: SubByte =8'hba;
        8'hc1: SubByte =8'h78;
        8'hc2: SubByte =8'h25;
        8'hc3: SubByte =8'h2e;
        8'hc4: SubByte =8'h1c;
        8'hc5: SubByte =8'ha6;
        8'hc6: SubByte =8'hb4;
        8'hc7: SubByte =8'hc6;
        8'hc8: SubByte =8'he8;
        8'hc9: SubByte =8'hdd;
        8'hca: SubByte =8'h74;
        8'hcb: SubByte =8'h1f;
        8'hcc: SubByte =8'h4b;
        8'hcd: SubByte =8'hbd;
        8'hce: SubByte =8'h8b;
        8'hcf: SubByte =8'h8a;
        8'hd0: SubByte =8'h70;
        8'hd1: SubByte =8'h3e;
        8'hd2: SubByte =8'hb5;
        8'hd3: SubByte =8'h66;
        8'hd4: SubByte =8'h48;
        8'hd5: SubByte =8'h03;
        8'hd6: SubByte =8'hf6;
        8'hd7: SubByte =8'h0e;
        8'hd8: SubByte =8'h61;
        8'hd9: SubByte =8'h35;
        8'hda: SubByte =8'h57;
        8'hdb: SubByte =8'hb9;
        8'hdc: SubByte =8'h86;
        8'hdd: SubByte =8'hc1;
        8'hde: SubByte =8'h1d;
        8'hdf: SubByte =8'h9e;
        8'he0: SubByte =8'he1;
        8'he1: SubByte =8'hf8;
        8'he2: SubByte =8'h98;
        8'he3: SubByte =8'h11;
        8'he4: SubByte =8'h69;
        8'he5: SubByte =8'hd9;
        8'he6: SubByte =8'h8e;
        8'he7: SubByte =8'h94;
        8'he8: SubByte =8'h9b;
        8'he9: SubByte =8'h1e;
        8'hea: SubByte =8'h87;
        8'heb: SubByte =8'he9;
        8'hec: SubByte =8'hce;
        8'hed: SubByte =8'h55;
        8'hee: SubByte =8'h28;
        8'hef: SubByte =8'hdf;
        8'hf0: SubByte =8'h8c;
        8'hf1: SubByte =8'ha1;
        8'hf2: SubByte =8'h89;
        8'hf3: SubByte =8'h0d;
        8'hf4: SubByte =8'hbf;
        8'hf5: SubByte =8'he6;
        8'hf6: SubByte =8'h42;
        8'hf7: SubByte =8'h68;
        8'hf8: SubByte =8'h41;
        8'hf9: SubByte =8'h99;
        8'hfa: SubByte =8'h2d;
        8'hfb: SubByte =8'h0f;
        8'hfc: SubByte =8'hb0;
        8'hfd: SubByte =8'h54;
        8'hfe: SubByte =8'hbb;
        8'hff: SubByte =8'h16;
        default: SubByte =8'h00;
    endcase
    
    
endfunction

function [127:0] AddRoundKey;
	input [127:0] data_in, key;
	AddRoundKey = data_in ^ key;
endfunction

function [127:0] ShiftRows;
	input [127:0] data_in;
	begin
		ShiftRows[127 -: 8] = data_in[127 -: 8];
		ShiftRows[95 -: 8] = data_in[95 -: 8];
		ShiftRows[63 -: 8] = data_in[63 -: 8];
		ShiftRows[31 -: 8] = data_in[31 -: 8];

		ShiftRows[119 -: 8] = data_in[87 -: 8];
		ShiftRows[87 -: 8] = data_in[55 -: 8];
		ShiftRows[55 -: 8] = data_in[23 -: 8];
		ShiftRows[23 -: 8] = data_in[119 -: 8];

		ShiftRows[111 -: 8] = data_in[47 -: 8];
		ShiftRows[79 -: 8] = data_in[15 -: 8];
		ShiftRows[47 -: 8] = data_in[111 -: 8];
		ShiftRows[15 -: 8] = data_in[79 -: 8];

		ShiftRows[103 -: 8] = data_in[7 -: 8];
		ShiftRows[71 -: 8] = data_in[103 -: 8];
		ShiftRows[39 -: 8] = data_in[71 -: 8];
		ShiftRows[7 -: 8] = data_in[39 -: 8];
	end
endfunction

function [127:0] MixColumns;
	input [127:0] data_in;
	integer i;
	begin
		for (i = 0; i < 4; i = i + 1) begin
			MixColumns[127 - 32*i -: 8] = GF28mul(2,data_in[127 - 32*i -: 8]) ^ GF28mul(3,data_in[119 - 32*i-: 8]) 
			^ data_in[111 - 32*i -: 8] ^ data_in[103  - 32*i-: 8];

			MixColumns[119 - 32*i -: 8] = GF28mul(2,data_in[119 - 32*i -: 8]) ^ GF28mul(3,data_in[111 - 32*i -: 8]) 
			^ data_in[103 - 32*i -: 8] ^ data_in[127 - 32*i -: 8];

			MixColumns[111 - 32*i -: 8] = GF28mul(2,data_in[111 - 32*i -: 8]) ^ GF28mul(3,data_in[103 - 32*i -: 8])
			^ data_in[127 - 32*i -: 8] ^ data_in[119 - 32*i -: 8];

			MixColumns[103 - 32*i -: 8] = GF28mul(2,data_in[103 - 32*i -: 8]) ^ GF28mul(3,data_in[127 - 32*i -: 8])
			^ data_in[119 - 32*i -: 8] ^ data_in[111 - 32*i -: 8];
		end
	end
endfunction

function [7:0] GF28mul;
    input [7:0] a, b;
    reg [7:0] p;
    reg ahi;
    integer i;
    begin
        p = 8'b0;
        for (i = 0; i < 8; i = i + 1) begin
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