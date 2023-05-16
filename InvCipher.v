module InvCipher #(parameter Nk = 4, Nr = 10)(
      input [127:0] data_in,
    input [(Nr + 1) * 128 - 1:0] w,
    input rst,
    input en,
    input clk,
    input [Nk * 32 - 1:0] key,
    output reg[127:0] data_out
);
reg [127:0] data;
reg [2:0] state = 'b000;


integer i = Nr;
always @(posedge clk && en, posedge rst) begin
    if (rst) begin
        state = 'b000;
        i = Nr;
    end
    else begin
        case (state)
            'b000:begin
                if (i == Nr) begin
                    data = data_in;
                    state='b001;
                end
                data = AddRoundKey(data, w[(Nr + 1) * 128 - 1 - i * 128 -: 128]);
                if(i == 0) begin 
                    state='b111;
                    data_out = data;
                end
                else if(i < Nr) begin 
                     state='b011; 
                end
            end 
            'b001:begin
                data = InvShiftRows(data);
                state = 'b010;
            end
            'b010:begin
                data = invSubBytes(data);
                state = 'b000; 
                if (i == Nr)
                    i = i - 1;
            end
            'b011:begin
                data = InvMixColumns(data);
                state = 'b001;
                i = i - 1;
            end
            default:begin
                
            end
        endcase
    end
    
end
function [127:0] invSubBytes;
	input [127:0] data_in;
	integer i;
	begin
		for (i = 0;i < 16; i = i + 1) begin
			invSubBytes[i * 8 +: 8] = invSubByte(data_in[i * 8 +: 8]);
		end
	end
endfunction


function [7:0] invSubByte;
    input [7:0] data_in;
        case (data_in)
            8'h00: invSubByte =8'h52;
            8'h01: invSubByte =8'h09;
            8'h02: invSubByte =8'h6a;
            8'h03: invSubByte =8'hd5;
            8'h04: invSubByte =8'h30;
            8'h05: invSubByte =8'h36;
            8'h06: invSubByte =8'ha5;
            8'h07: invSubByte =8'h38;
            8'h08: invSubByte =8'hbf;
            8'h09: invSubByte =8'h40;
            8'h0a: invSubByte =8'ha3;
            8'h0b: invSubByte =8'h9e;
            8'h0c: invSubByte =8'h81;
            8'h0d: invSubByte =8'hf3;
            8'h0e: invSubByte =8'hd7;
            8'h0f: invSubByte =8'hfb;
            8'h10: invSubByte =8'h7c;
            8'h11: invSubByte =8'he3;
            8'h12: invSubByte =8'h39;
            8'h13: invSubByte =8'h82;
            8'h14: invSubByte =8'h9b;
            8'h15: invSubByte =8'h2f;
            8'h16: invSubByte =8'hff;
            8'h17: invSubByte =8'h87;
            8'h18: invSubByte =8'h34;
            8'h19: invSubByte =8'h8e;
            8'h1a: invSubByte =8'h43;
            8'h1b: invSubByte =8'h44;
            8'h1c: invSubByte =8'hc4;
            8'h1d: invSubByte =8'hde;
            8'h1e: invSubByte =8'he9;
            8'h1f: invSubByte =8'hcb;
            8'h20: invSubByte =8'h54;
            8'h21: invSubByte =8'h7b;
            8'h22: invSubByte =8'h94;
            8'h23: invSubByte =8'h32;
            8'h24: invSubByte =8'ha6;
            8'h25: invSubByte =8'hc2;
            8'h26: invSubByte =8'h23;
            8'h27: invSubByte =8'h3d;
            8'h28: invSubByte =8'hee;
            8'h29: invSubByte =8'h4c;
            8'h2a: invSubByte =8'h95;
            8'h2b: invSubByte =8'h0b;
            8'h2c: invSubByte =8'h42;
            8'h2d: invSubByte =8'hfa;
            8'h2e: invSubByte =8'hc3;
            8'h2f: invSubByte =8'h4e;
            8'h30: invSubByte =8'h08;
            8'h31: invSubByte =8'h2e;
            8'h32: invSubByte =8'ha1;
            8'h33: invSubByte =8'h66;
            8'h34: invSubByte =8'h28;
            8'h35: invSubByte =8'hd9;
            8'h36: invSubByte =8'h24;
            8'h37: invSubByte =8'hb2;
            8'h38: invSubByte =8'h76;
            8'h39: invSubByte =8'h5b;
            8'h3a: invSubByte =8'ha2;
            8'h3b: invSubByte =8'h49;
            8'h3c: invSubByte =8'h6d;
            8'h3d: invSubByte =8'h8b;
            8'h3e: invSubByte =8'hd1;
            8'h3f: invSubByte =8'h25;
            8'h40: invSubByte =8'h72;
            8'h41: invSubByte =8'hf8;
            8'h42: invSubByte =8'hf6;
            8'h43: invSubByte =8'h64;
            8'h44: invSubByte =8'h86;
            8'h45: invSubByte =8'h68;
            8'h46: invSubByte =8'h98;
            8'h47: invSubByte =8'h16;
            8'h48: invSubByte =8'hd4;
            8'h49: invSubByte =8'ha4;
            8'h4a: invSubByte =8'h5c;
            8'h4b: invSubByte =8'hcc;
            8'h4c: invSubByte =8'h5d;
            8'h4d: invSubByte =8'h65;
            8'h4e: invSubByte =8'hb6;
            8'h4f: invSubByte =8'h92;
            8'h50: invSubByte =8'h6c;
            8'h51: invSubByte =8'h70;
            8'h52: invSubByte =8'h48;
            8'h53: invSubByte =8'h50;
            8'h54: invSubByte =8'hfd;
            8'h55: invSubByte =8'hed;
            8'h56: invSubByte =8'hb9;
            8'h57: invSubByte =8'hda;
            8'h58: invSubByte =8'h5e;
            8'h59: invSubByte =8'h15;
            8'h5a: invSubByte =8'h46;
            8'h5b: invSubByte =8'h57;
            8'h5c: invSubByte =8'ha7;
            8'h5d: invSubByte =8'h8d;
            8'h5e: invSubByte =8'h9d;
            8'h5f: invSubByte =8'h84;
            8'h60: invSubByte =8'h90;
            8'h61: invSubByte =8'hd8;
            8'h62: invSubByte =8'hab;
            8'h63: invSubByte =8'h00;
            8'h64: invSubByte =8'h8c;
            8'h65: invSubByte =8'hbc;
            8'h66: invSubByte =8'hd3;
            8'h67: invSubByte =8'h0a;
            8'h68: invSubByte =8'hf7;
            8'h69: invSubByte =8'he4;
            8'h6a: invSubByte =8'h58;
            8'h6b: invSubByte =8'h05;
            8'h6c: invSubByte =8'hb8;
            8'h6d: invSubByte =8'hb3;
            8'h6e: invSubByte =8'h45;
            8'h6f: invSubByte =8'h06;
            8'h70: invSubByte =8'hd0;
            8'h71: invSubByte =8'h2c;
            8'h72: invSubByte =8'h1e;
            8'h73: invSubByte =8'h8f;
            8'h74: invSubByte =8'hca;
            8'h75: invSubByte =8'h3f;
            8'h76: invSubByte =8'h0f;
            8'h77: invSubByte =8'h02;
            8'h78: invSubByte =8'hc1;
            8'h79: invSubByte =8'haf;
            8'h7a: invSubByte =8'hbd;
            8'h7b: invSubByte =8'h03;
            8'h7c: invSubByte =8'h01;
            8'h7d: invSubByte =8'h13;
            8'h7e: invSubByte =8'h8a;
            8'h7f: invSubByte =8'h6b;
            8'h80: invSubByte =8'h3a;
            8'h81: invSubByte =8'h91;
            8'h82: invSubByte =8'h11;
            8'h83: invSubByte =8'h41;
            8'h84: invSubByte =8'h4f;
            8'h85: invSubByte =8'h67;
            8'h86: invSubByte =8'hdc;
            8'h87: invSubByte =8'hea;
            8'h88: invSubByte =8'h97;
            8'h89: invSubByte =8'hf2;
            8'h8a: invSubByte =8'hcf;
            8'h8b: invSubByte =8'hce;
            8'h8c: invSubByte =8'hf0;
            8'h8d: invSubByte =8'hb4;
            8'h8e: invSubByte =8'he6;
            8'h8f: invSubByte =8'h73;
            8'h90: invSubByte =8'h96;
            8'h91: invSubByte =8'hac;
            8'h92: invSubByte =8'h74;
            8'h93: invSubByte =8'h22;
            8'h94: invSubByte =8'he7;
            8'h95: invSubByte =8'had;
            8'h96: invSubByte =8'h35;
            8'h97: invSubByte =8'h85;
            8'h98: invSubByte =8'he2;
            8'h99: invSubByte =8'hf9;
            8'h9a: invSubByte =8'h37;
            8'h9b: invSubByte =8'he8;
            8'h9c: invSubByte =8'h1c;
            8'h9d: invSubByte =8'h75;
            8'h9e: invSubByte =8'hdf;
            8'h9f: invSubByte =8'h6e;
            8'ha0: invSubByte =8'h47;
            8'ha1: invSubByte =8'hf1;
            8'ha2: invSubByte =8'h1a;
            8'ha3: invSubByte =8'h71;
            8'ha4: invSubByte =8'h1d;
            8'ha5: invSubByte =8'h29;
            8'ha6: invSubByte =8'hc5;
            8'ha7: invSubByte =8'h89;
            8'ha8: invSubByte =8'h6f;
            8'ha9: invSubByte =8'hb7;
            8'haa: invSubByte =8'h62;
            8'hab: invSubByte =8'h0e;
            8'hac: invSubByte =8'haa;
            8'had: invSubByte =8'h18;
            8'hae: invSubByte =8'hbe;
            8'haf: invSubByte =8'h1b;
            8'hb0: invSubByte =8'hfc;
            8'hb1: invSubByte =8'h56;
            8'hb2: invSubByte =8'h3e;
            8'hb3: invSubByte =8'h4b;
            8'hb4: invSubByte =8'hc6;
            8'hb5: invSubByte =8'hd2;
            8'hb6: invSubByte =8'h79;
            8'hb7: invSubByte =8'h20;
            8'hb8: invSubByte =8'h9a;
            8'hb9: invSubByte =8'hdb;
            8'hba: invSubByte =8'hc0;
            8'hbb: invSubByte =8'hfe;
            8'hbc: invSubByte =8'h78;
            8'hbd: invSubByte =8'hcd;
            8'hbe: invSubByte =8'h5a;
            8'hbf: invSubByte =8'hf4;
            8'hc0: invSubByte =8'h1f;
            8'hc1: invSubByte =8'hdd;
            8'hc2: invSubByte =8'ha8;
            8'hc3: invSubByte =8'h33;
            8'hc4: invSubByte =8'h88;
            8'hc5: invSubByte =8'h07;
            8'hc6: invSubByte =8'hc7;
            8'hc7: invSubByte =8'h31;
            8'hc8: invSubByte =8'hb1;
            8'hc9: invSubByte =8'h12;
            8'hca: invSubByte =8'h10;
            8'hcb: invSubByte =8'h59;
            8'hcc: invSubByte =8'h27;
            8'hcd: invSubByte =8'h80;
            8'hce: invSubByte =8'hec;
            8'hcf: invSubByte =8'h5f;
            8'hd0: invSubByte =8'h60;
            8'hd1: invSubByte =8'h51;
            8'hd2: invSubByte =8'h7f;
            8'hd3: invSubByte =8'ha9;
            8'hd4: invSubByte =8'h19;
            8'hd5: invSubByte =8'hb5;
            8'hd6: invSubByte =8'h4a;
            8'hd7: invSubByte =8'h0d;
            8'hd8: invSubByte =8'h2d;
            8'hd9: invSubByte =8'he5;
            8'hda: invSubByte =8'h7a;
            8'hdb: invSubByte =8'h9f;
            8'hdc: invSubByte =8'h93;
            8'hdd: invSubByte =8'hc9;
            8'hde: invSubByte =8'h9c;
            8'hdf: invSubByte =8'hef;
            8'he0: invSubByte =8'ha0;
            8'he1: invSubByte =8'he0;
            8'he2: invSubByte =8'h3b;
            8'he3: invSubByte =8'h4d;
            8'he4: invSubByte =8'hae;
            8'he5: invSubByte =8'h2a;
            8'he6: invSubByte =8'hf5;
            8'he7: invSubByte =8'hb0;
            8'he8: invSubByte =8'hc8;
            8'he9: invSubByte =8'heb;
            8'hea: invSubByte =8'hbb;
            8'heb: invSubByte =8'h3c;
            8'hec: invSubByte =8'h83;
            8'hed: invSubByte =8'h53;
            8'hee: invSubByte =8'h99;
            8'hef: invSubByte =8'h61;
            8'hf0: invSubByte =8'h17;
            8'hf1: invSubByte =8'h2b;
            8'hf2: invSubByte =8'h04;
            8'hf3: invSubByte =8'h7e;
            8'hf4: invSubByte =8'hba;
            8'hf5: invSubByte =8'h77;
            8'hf6: invSubByte =8'hd6;
            8'hf7: invSubByte =8'h26;
            8'hf8: invSubByte =8'he1;
            8'hf9: invSubByte =8'h69;
            8'hfa: invSubByte =8'h14;
            8'hfb: invSubByte =8'h63;
            8'hfc: invSubByte =8'h55;
            8'hfd: invSubByte =8'h21;
            8'hfe: invSubByte =8'h0c;
            8'hff: invSubByte =8'h7d;
        endcase
endfunction

function [127:0] AddRoundKey;
	input [127:0] data_in, key;
	AddRoundKey = data_in ^ key;
endfunction

function [127:0] InvShiftRows;
	input [127:0] data_in;
	begin
    InvShiftRows[127 -: 8] = data_in[127 -: 8];
    InvShiftRows[95  -: 8] = data_in[95  -: 8];
    InvShiftRows[63  -: 8] = data_in[63  -: 8];
    InvShiftRows[31  -: 8] = data_in[31  -: 8];
    
    InvShiftRows[119 -: 8] = data_in[23 -: 8];
    InvShiftRows[87  -: 8] = data_in[119 -: 8];
    InvShiftRows[55  -: 8] = data_in[87  -: 8];
    InvShiftRows[23  -: 8] = data_in[55  -: 8];
    
    InvShiftRows[111 -: 8] = data_in[47 -: 8];
    InvShiftRows[79  -: 8] = data_in[15 -: 8];
    InvShiftRows[47  -: 8] = data_in[111 -: 8];
    InvShiftRows[15  -: 8] = data_in[79  -: 8];
    
    InvShiftRows[103 -: 8] = data_in[71 -: 8];
    InvShiftRows[71  -: 8] = data_in[39 -: 8];
    InvShiftRows[39  -: 8] = data_in[7  -: 8];
    InvShiftRows[7   -: 8] = data_in[103 -: 8];
	end
endfunction

function [127:0] InvMixColumns;
	input [127:0] data_in;
	integer i;
	begin
		for (i = 0; i < 4; i = i + 1) begin
			        InvMixColumns[127 - 32*i -: 8] = GF28mul('he,data_in[127 - 32*i -: 8]) ^ GF28mul('hb,data_in[119 - 32*i-: 8]) 
         ^ GF28mul('hd,data_in[111 - 32*i -: 8]) ^ GF28mul('h9,data_in[103 - 32*i -: 8]);

        InvMixColumns[119 - 32*i -: 8] = GF28mul('h9,data_in[127 - 32*i -: 8]) ^ GF28mul('he,data_in[119 - 32*i-: 8]) 
         ^ GF28mul('hb,data_in[111 - 32*i -: 8]) ^ GF28mul('hd,data_in[103 - 32*i -: 8]);

        InvMixColumns[111 - 32*i -: 8] = GF28mul('hd,data_in[127 - 32*i -: 8]) ^ GF28mul('h9,data_in[119 - 32*i-: 8]) 
         ^ GF28mul('he,data_in[111 - 32*i -: 8]) ^ GF28mul('hb,data_in[103 - 32*i -: 8]);

        InvMixColumns[103 - 32*i -: 8] = GF28mul('hb,data_in[127 - 32*i -: 8]) ^ GF28mul('hd,data_in[119 - 32*i-: 8]) 
         ^ GF28mul('h9,data_in[111 - 32*i -: 8]) ^ GF28mul('he,data_in[103 - 32*i -: 8]);		end
	end
endfunction
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