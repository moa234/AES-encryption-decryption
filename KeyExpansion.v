module KeyExpansion #(parameter Nk = 4, Nr = 10) (
    input [Nk * 32 - 1:0] key_in,
    output reg[(Nr + 1) * 128 - 1:0] key_out
);

reg [(Nr + 1) * 128 - 1:0] w;
reg [31:0] temp;
integer i;

always @(key_in) begin
    w[(Nr + 1) * 128 - 1 -: Nk * 32] = key_in;
    i = Nk;
    while (i < 4 * (Nr + 1)) begin
        temp = w[(Nr + 1) * 128 - i * 32 +: 32];
        if (i % Nk == 0) begin
            temp = SubWord(RotWord(temp)) ^ Rcon(i / Nk);
        end
        else if (Nk > 6 && i % Nk == 4) begin
            temp = SubWord(temp);
        end
        w[(Nr + 1) * 128 - i * 32 - 1 -: 32] = w[(Nr + 1) * 128 - i * 32 - 1 + Nk * 32 -: 32] ^ temp;
        i = i + 1;
    end
    key_out = w;
end

function [31:0] Rcon;
    input integer i;
    begin
        case (i)
            1: Rcon = 32'h01000000;
            2: Rcon = 32'h02000000;
            3: Rcon = 32'h04000000;
            4: Rcon = 32'h08000000;
            5: Rcon = 32'h10000000;
            6: Rcon = 32'h20000000;
            7: Rcon = 32'h40000000;
            8: Rcon = 32'h80000000;
            9: Rcon = 32'h1b000000;
            10: Rcon = 32'h36000000;
        endcase
    end
endfunction

function [31:0] RotWord;
    input [31:0] word_in;
    begin
        RotWord = {word_in[23:0], word_in[31:24]};
    end
endfunction

function [31:0] SubWord;
    input [31:0] word_in;
    integer i;
    begin
        for (i = 0; i < 4; i = i + 1) begin
            case (word_in[i * 8 +: 8])
                8'h00: SubWord[i * 8 +: 8] =8'h63;
                8'h01: SubWord[i * 8 +: 8] =8'h7c;
                8'h02: SubWord[i * 8 +: 8] =8'h77;
                8'h03: SubWord[i * 8 +: 8] =8'h7b;
                8'h04: SubWord[i * 8 +: 8] =8'hf2; 
                8'h05: SubWord[i * 8 +: 8] =8'h6b;
                8'h06: SubWord[i * 8 +: 8] =8'h6f;
                8'h07: SubWord[i * 8 +: 8] =8'hc5;
                8'h08: SubWord[i * 8 +: 8] =8'h30;
                8'h09: SubWord[i * 8 +: 8] =8'h01;
                8'h0a: SubWord[i * 8 +: 8] =8'h67;
                8'h0b: SubWord[i * 8 +: 8] =8'h2b;
                8'h0c: SubWord[i * 8 +: 8] =8'hfe;
                8'h0d: SubWord[i * 8 +: 8] =8'hd7;
                8'h0e: SubWord[i * 8 +: 8] =8'hab;
                8'h0f: SubWord[i * 8 +: 8] =8'h76;
                8'h10: SubWord[i * 8 +: 8] =8'hca;
                8'h11: SubWord[i * 8 +: 8] =8'h82;
                8'h12: SubWord[i * 8 +: 8] =8'hc9;
                8'h13: SubWord[i * 8 +: 8] =8'h7d;
                8'h14: SubWord[i * 8 +: 8] =8'hfa;
                8'h15: SubWord[i * 8 +: 8] =8'h59;
                8'h16: SubWord[i * 8 +: 8] =8'h47;
                8'h17: SubWord[i * 8 +: 8] =8'hf0;
                8'h18: SubWord[i * 8 +: 8] =8'had;
                8'h19: SubWord[i * 8 +: 8] =8'hd4;
                8'h1a: SubWord[i * 8 +: 8] =8'ha2;
                8'h1b: SubWord[i * 8 +: 8] =8'haf;
                8'h1c: SubWord[i * 8 +: 8] =8'h9c;
                8'h1d: SubWord[i * 8 +: 8] =8'ha4;
                8'h1e: SubWord[i * 8 +: 8] =8'h72;
                8'h1f: SubWord[i * 8 +: 8] =8'hc0;
                8'h20: SubWord[i * 8 +: 8] =8'hb7;
                8'h21: SubWord[i * 8 +: 8] =8'hfd;
                8'h22: SubWord[i * 8 +: 8] =8'h93;
                8'h23: SubWord[i * 8 +: 8] =8'h26;
                8'h24: SubWord[i * 8 +: 8] =8'h36;
                8'h25: SubWord[i * 8 +: 8] =8'h3f;
                8'h26: SubWord[i * 8 +: 8] =8'hf7;
                8'h27: SubWord[i * 8 +: 8] =8'hcc;
                8'h28: SubWord[i * 8 +: 8] =8'h34;
                8'h29: SubWord[i * 8 +: 8] =8'ha5;
                8'h2a: SubWord[i * 8 +: 8] =8'he5;
                8'h2b: SubWord[i * 8 +: 8] =8'hf1;
                8'h2c: SubWord[i * 8 +: 8] =8'h71;
                8'h2d: SubWord[i * 8 +: 8] =8'hd8;
                8'h2e: SubWord[i * 8 +: 8] =8'h31;
                8'h2f: SubWord[i * 8 +: 8] =8'h15;
                8'h30: SubWord[i * 8 +: 8] =8'h04;
                8'h31: SubWord[i * 8 +: 8] =8'hc7;
                8'h32: SubWord[i * 8 +: 8] =8'h23;
                8'h33: SubWord[i * 8 +: 8] =8'hc3;
                8'h34: SubWord[i * 8 +: 8] =8'h18;
                8'h35: SubWord[i * 8 +: 8] =8'h96;
                8'h36: SubWord[i * 8 +: 8] =8'h05;
                8'h37: SubWord[i * 8 +: 8] =8'h9a;
                8'h38: SubWord[i * 8 +: 8] =8'h07;
                8'h39: SubWord[i * 8 +: 8] =8'h12;
                8'h3a: SubWord[i * 8 +: 8] =8'h80;
                8'h3b: SubWord[i * 8 +: 8] =8'he2;
                8'h3c: SubWord[i * 8 +: 8] =8'heb;
                8'h3d: SubWord[i * 8 +: 8] =8'h27;
                8'h3e: SubWord[i * 8 +: 8] =8'hb2;
                8'h3f: SubWord[i * 8 +: 8] =8'h75;
                8'h40: SubWord[i * 8 +: 8] =8'h09;
                8'h41: SubWord[i * 8 +: 8] =8'h83;
                8'h42: SubWord[i * 8 +: 8] =8'h2c;
                8'h43: SubWord[i * 8 +: 8] =8'h1a;
                8'h44: SubWord[i * 8 +: 8] =8'h1b;
                8'h45: SubWord[i * 8 +: 8] =8'h6e;
                8'h46: SubWord[i * 8 +: 8] =8'h5a;
                8'h47: SubWord[i * 8 +: 8] =8'ha0;
                8'h48: SubWord[i * 8 +: 8] =8'h52;
                8'h49: SubWord[i * 8 +: 8] =8'h3b;
                8'h4a: SubWord[i * 8 +: 8] =8'hd6;
                8'h4b: SubWord[i * 8 +: 8] =8'hb3;
                8'h4c: SubWord[i * 8 +: 8] =8'h29;
                8'h4d: SubWord[i * 8 +: 8] =8'he3;
                8'h4e: SubWord[i * 8 +: 8] =8'h2f;
                8'h4f: SubWord[i * 8 +: 8] =8'h84;
                8'h50: SubWord[i * 8 +: 8] =8'h53;
                8'h51: SubWord[i * 8 +: 8] =8'hd1;
                8'h52: SubWord[i * 8 +: 8] =8'h00;
                8'h53: SubWord[i * 8 +: 8] =8'hed;
                8'h54: SubWord[i * 8 +: 8] =8'h20;
                8'h55: SubWord[i * 8 +: 8] =8'hfc;
                8'h56: SubWord[i * 8 +: 8] =8'hb1;
                8'h57: SubWord[i * 8 +: 8] =8'h5b;
                8'h58: SubWord[i * 8 +: 8] =8'h6a;
                8'h59: SubWord[i * 8 +: 8] =8'hcb;
                8'h5a: SubWord[i * 8 +: 8] =8'hbe;
                8'h5b: SubWord[i * 8 +: 8] =8'h39;
                8'h5c: SubWord[i * 8 +: 8] =8'h4a;
                8'h5d: SubWord[i * 8 +: 8] =8'h4c;
                8'h5e: SubWord[i * 8 +: 8] =8'h58;
                8'h5f: SubWord[i * 8 +: 8] =8'hcf;
                8'h60: SubWord[i * 8 +: 8] =8'hd0;
                8'h61: SubWord[i * 8 +: 8] =8'hef;
                8'h62: SubWord[i * 8 +: 8] =8'haa;
                8'h63: SubWord[i * 8 +: 8] =8'hfb;
                8'h64: SubWord[i * 8 +: 8] =8'h43;
                8'h65: SubWord[i * 8 +: 8] =8'h4d;
                8'h66: SubWord[i * 8 +: 8] =8'h33;
                8'h67: SubWord[i * 8 +: 8] =8'h85;
                8'h68: SubWord[i * 8 +: 8] =8'h45;
                8'h69: SubWord[i * 8 +: 8] =8'hf9;
                8'h6a: SubWord[i * 8 +: 8] =8'h02;
                8'h6b: SubWord[i * 8 +: 8] =8'h7f;
                8'h6c: SubWord[i * 8 +: 8] =8'h50;
                8'h6d: SubWord[i * 8 +: 8] =8'h3c;
                8'h6e: SubWord[i * 8 +: 8] =8'h9f;
                8'h6f: SubWord[i * 8 +: 8] =8'ha8;
                8'h70: SubWord[i * 8 +: 8] =8'h51;
                8'h71: SubWord[i * 8 +: 8] =8'ha3;
                8'h72: SubWord[i * 8 +: 8] =8'h40;
                8'h73: SubWord[i * 8 +: 8] =8'h8f;
                8'h74: SubWord[i * 8 +: 8] =8'h92;
                8'h75: SubWord[i * 8 +: 8] =8'h9d;
                8'h76: SubWord[i * 8 +: 8] =8'h38;
                8'h77: SubWord[i * 8 +: 8] =8'hf5;
                8'h78: SubWord[i * 8 +: 8] =8'hbc;
                8'h79: SubWord[i * 8 +: 8] =8'hb6;
                8'h7a: SubWord[i * 8 +: 8] =8'hda;
                8'h7b: SubWord[i * 8 +: 8] =8'h21;
                8'h7c: SubWord[i * 8 +: 8] =8'h10;
                8'h7d: SubWord[i * 8 +: 8] =8'hff;
                8'h7e: SubWord[i * 8 +: 8] =8'hf3;
                8'h7f: SubWord[i * 8 +: 8] =8'hd2;
                8'h80: SubWord[i * 8 +: 8] =8'hcd;
                8'h81: SubWord[i * 8 +: 8] =8'h0c;
                8'h82: SubWord[i * 8 +: 8] =8'h13;
                8'h83: SubWord[i * 8 +: 8] =8'hec;
                8'h84: SubWord[i * 8 +: 8] =8'h5f;
                8'h85: SubWord[i * 8 +: 8] =8'h97;
                8'h86: SubWord[i * 8 +: 8] =8'h44;
                8'h87: SubWord[i * 8 +: 8] =8'h17;
                8'h88: SubWord[i * 8 +: 8] =8'hc4;
                8'h89: SubWord[i * 8 +: 8] =8'ha7;
                8'h8a: SubWord[i * 8 +: 8] =8'h7e;
                8'h8b: SubWord[i * 8 +: 8] =8'h3d;
                8'h8c: SubWord[i * 8 +: 8] =8'h64;
                8'h8d: SubWord[i * 8 +: 8] =8'h5d;
                8'h8e: SubWord[i * 8 +: 8] =8'h19;
                8'h8f: SubWord[i * 8 +: 8] =8'h73;
                8'h90: SubWord[i * 8 +: 8] =8'h60;
                8'h91: SubWord[i * 8 +: 8] =8'h81;
                8'h92: SubWord[i * 8 +: 8] =8'h4f;
                8'h93: SubWord[i * 8 +: 8] =8'hdc;
                8'h94: SubWord[i * 8 +: 8] =8'h22;
                8'h95: SubWord[i * 8 +: 8] =8'h2a;
                8'h96: SubWord[i * 8 +: 8] =8'h90;
                8'h97: SubWord[i * 8 +: 8] =8'h88;
                8'h98: SubWord[i * 8 +: 8] =8'h46;
                8'h99: SubWord[i * 8 +: 8] =8'hee;
                8'h9a: SubWord[i * 8 +: 8] =8'hb8;
                8'h9b: SubWord[i * 8 +: 8] =8'h14;
                8'h9c: SubWord[i * 8 +: 8] =8'hde;
                8'h9d: SubWord[i * 8 +: 8] =8'h5e;
                8'h9e: SubWord[i * 8 +: 8] =8'h0b;
                8'h9f: SubWord[i * 8 +: 8] =8'hdb;
                8'ha0: SubWord[i * 8 +: 8] =8'he0;
                8'ha1: SubWord[i * 8 +: 8] =8'h32;
                8'ha2: SubWord[i * 8 +: 8] =8'h3a;
                8'ha3: SubWord[i * 8 +: 8] =8'h0a;
                8'ha4: SubWord[i * 8 +: 8] =8'h49;
                8'ha5: SubWord[i * 8 +: 8] =8'h06;
                8'ha6: SubWord[i * 8 +: 8] =8'h24;
                8'ha7: SubWord[i * 8 +: 8] =8'h5c;
                8'ha8: SubWord[i * 8 +: 8] =8'hc2;
                8'ha9: SubWord[i * 8 +: 8] =8'hd3;
                8'haa: SubWord[i * 8 +: 8] =8'hac;
                8'hab: SubWord[i * 8 +: 8] =8'h62;
                8'hac: SubWord[i * 8 +: 8] =8'h91;
                8'had: SubWord[i * 8 +: 8] =8'h95;
                8'hae: SubWord[i * 8 +: 8] =8'he4;
                8'haf: SubWord[i * 8 +: 8] =8'h79;
                8'hb0: SubWord[i * 8 +: 8] =8'he7;
                8'hb1: SubWord[i * 8 +: 8] =8'hc8;
                8'hb2: SubWord[i * 8 +: 8] =8'h37;
                8'hb3: SubWord[i * 8 +: 8] =8'h6d;
                8'hb4: SubWord[i * 8 +: 8] =8'h8d;
                8'hb5: SubWord[i * 8 +: 8] =8'hd5;
                8'hb6: SubWord[i * 8 +: 8] =8'h4e;
                8'hb7: SubWord[i * 8 +: 8] =8'ha9;
                8'hb8: SubWord[i * 8 +: 8] =8'h6c;
                8'hb9: SubWord[i * 8 +: 8] =8'h56;
                8'hba: SubWord[i * 8 +: 8] =8'hf4;
                8'hbb: SubWord[i * 8 +: 8] =8'hea;
                8'hbc: SubWord[i * 8 +: 8] =8'h65;
                8'hbd: SubWord[i * 8 +: 8] =8'h7a;
                8'hbe: SubWord[i * 8 +: 8] =8'hae;
                8'hbf: SubWord[i * 8 +: 8] =8'h08;
                8'hc0: SubWord[i * 8 +: 8] =8'hba;
                8'hc1: SubWord[i * 8 +: 8] =8'h78;
                8'hc2: SubWord[i * 8 +: 8] =8'h25;
                8'hc3: SubWord[i * 8 +: 8] =8'h2e;
                8'hc4: SubWord[i * 8 +: 8] =8'h1c;
                8'hc5: SubWord[i * 8 +: 8] =8'ha6;
                8'hc6: SubWord[i * 8 +: 8] =8'hb4;
                8'hc7: SubWord[i * 8 +: 8] =8'hc6;
                8'hc8: SubWord[i * 8 +: 8] =8'he8;
                8'hc9: SubWord[i * 8 +: 8] =8'hdd;
                8'hca: SubWord[i * 8 +: 8] =8'h74;
                8'hcb: SubWord[i * 8 +: 8] =8'h1f;
                8'hcc: SubWord[i * 8 +: 8] =8'h4b;
                8'hcd: SubWord[i * 8 +: 8] =8'hbd;
                8'hce: SubWord[i * 8 +: 8] =8'h8b;
                8'hcf: SubWord[i * 8 +: 8] =8'h8a;
                8'hd0: SubWord[i * 8 +: 8] =8'h70;
                8'hd1: SubWord[i * 8 +: 8] =8'h3e;
                8'hd2: SubWord[i * 8 +: 8] =8'hb5;
                8'hd3: SubWord[i * 8 +: 8] =8'h66;
                8'hd4: SubWord[i * 8 +: 8] =8'h48;
                8'hd5: SubWord[i * 8 +: 8] =8'h03;
                8'hd6: SubWord[i * 8 +: 8] =8'hf6;
                8'hd7: SubWord[i * 8 +: 8] =8'h0e;
                8'hd8: SubWord[i * 8 +: 8] =8'h61;
                8'hd9: SubWord[i * 8 +: 8] =8'h35;
                8'hda: SubWord[i * 8 +: 8] =8'h57;
                8'hdb: SubWord[i * 8 +: 8] =8'hb9;
                8'hdc: SubWord[i * 8 +: 8] =8'h86;
                8'hdd: SubWord[i * 8 +: 8] =8'hc1;
                8'hde: SubWord[i * 8 +: 8] =8'h1d;
                8'hdf: SubWord[i * 8 +: 8] =8'h9e;
                8'he0: SubWord[i * 8 +: 8] =8'he1;
                8'he1: SubWord[i * 8 +: 8] =8'hf8;
                8'he2: SubWord[i * 8 +: 8] =8'h98;
                8'he3: SubWord[i * 8 +: 8] =8'h11;
                8'he4: SubWord[i * 8 +: 8] =8'h69;
                8'he5: SubWord[i * 8 +: 8] =8'hd9;
                8'he6: SubWord[i * 8 +: 8] =8'h8e;
                8'he7: SubWord[i * 8 +: 8] =8'h94;
                8'he8: SubWord[i * 8 +: 8] =8'h9b;
                8'he9: SubWord[i * 8 +: 8] =8'h1e;
                8'hea: SubWord[i * 8 +: 8] =8'h87;
                8'heb: SubWord[i * 8 +: 8] =8'he9;
                8'hec: SubWord[i * 8 +: 8] =8'hce;
                8'hed: SubWord[i * 8 +: 8] =8'h55;
                8'hee: SubWord[i * 8 +: 8] =8'h28;
                8'hef: SubWord[i * 8 +: 8] =8'hdf;
                8'hf0: SubWord[i * 8 +: 8] =8'h8c;
                8'hf1: SubWord[i * 8 +: 8] =8'ha1;
                8'hf2: SubWord[i * 8 +: 8] =8'h89;
                8'hf3: SubWord[i * 8 +: 8] =8'h0d;
                8'hf4: SubWord[i * 8 +: 8] =8'hbf;
                8'hf5: SubWord[i * 8 +: 8] =8'he6;
                8'hf6: SubWord[i * 8 +: 8] =8'h42;
                8'hf7: SubWord[i * 8 +: 8] =8'h68;
                8'hf8: SubWord[i * 8 +: 8] =8'h41;
                8'hf9: SubWord[i * 8 +: 8] =8'h99;
                8'hfa: SubWord[i * 8 +: 8] =8'h2d;
                8'hfb: SubWord[i * 8 +: 8] =8'h0f;
                8'hfc: SubWord[i * 8 +: 8] =8'hb0;
                8'hfd: SubWord[i * 8 +: 8] =8'h54;
                8'hfe: SubWord[i * 8 +: 8] =8'hbb;
                8'hff: SubWord[i * 8 +: 8] =8'h16;
            endcase
        end
    end
endfunction
endmodule