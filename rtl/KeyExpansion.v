/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : KeyExpansion.v
  - Description      : RotWord / SubWord / RCon ---> Key Change
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.10 : Initial release
                       2) 2025.01.13 : finish
********************************************************************/

`timescale 1ns/10ps

module KeyExpansion (
  input  [127:0] iAesKey,
  input  [127:0] iPreKey,
  output [127:0] oAddKey,
  output [127:0] oAesKey,
  
  
  input  iInitRoundFlag
  );
  
  reg  [127:0] rAesKey;
  
  reg  [ 31:0] rRotKey;
  reg  [ 31:0] rSubKey;
  reg  [ 31:0] rRound;
  reg  [ 31:0] rRCon;
  
  reg  [127:0] rNewKey;
              
                     
  always @(*)
  begin
  
    if (iInitRoundFlag)
    begin
      rAesKey <= iAesKey;
      rRound  <= 1;
    end
   
    else
    begin
      rAesKey = iPreKey;
      rRound  = rRound + 1;
    end
     
    rRotKey = RotWord(rAesKey[31:0]);
    rSubKey = SubWord(rRotKey);
    rRCon   = rSubKey ^ RCon(rRound);
    
    rNewKey[127:96] = rAesKey[127:96] ^ rRCon;
    rNewKey[ 95:64] = rAesKey[95:64]  ^ rNewKey[127:96];
    rNewKey[ 63:32] = rAesKey[63:32]  ^ rNewKey[95:64];
    rNewKey[ 31: 0] = rAesKey[31: 0]  ^ rNewKey[63:32];
    
  end
  
  assign oAddKey = rAesKey;
  assign oAesKey = rNewKey;
  
  
  // Function1 : RowWord
  function [31:0] RotWord;
  input    [31:0] rAesKey;
  begin
  
    RotWord[31:0] = {rAesKey[23:0], rAesKey[31:24]};
    
  end
  endfunction

  // Function2 : SubWord      
  function [31:0] SubWord;
  input    [31:0] iIn;
  integer  i;
  begin

    for (i=0; i<32; i=i+8)
      SubWord[i +:8] = oOut(iIn[i +:8]);

  end
  endfunction
  
  // Function3 : S_Box
  function [7:0] oOut
  (input   [7:0] iIn);
  begin
  
    case (iIn)
      8'h00: oOut=8'h63;
      8'h01: oOut=8'h7c;
      8'h02: oOut=8'h77;
      8'h03: oOut=8'h7b;
      8'h04: oOut=8'hf2;
      8'h05: oOut=8'h6b;
      8'h06: oOut=8'h6f;
      8'h07: oOut=8'hc5;
      8'h08: oOut=8'h30;
      8'h09: oOut=8'h01;
      8'h0a: oOut=8'h67;
      8'h0b: oOut=8'h2b;
      8'h0c: oOut=8'hfe;
      8'h0d: oOut=8'hd7;
      8'h0e: oOut=8'hab;
      8'h0f: oOut=8'h76;
      8'h10: oOut=8'hca;
      8'h11: oOut=8'h82;
      8'h12: oOut=8'hc9;
      8'h13: oOut=8'h7d;
      8'h14: oOut=8'hfa;
      8'h15: oOut=8'h59;
      8'h16: oOut=8'h47;
      8'h17: oOut=8'hf0;
      8'h18: oOut=8'had;
      8'h19: oOut=8'hd4;
      8'h1a: oOut=8'ha2;
      8'h1b: oOut=8'haf;
      8'h1c: oOut=8'h9c;
      8'h1d: oOut=8'ha4;
      8'h1e: oOut=8'h72;
      8'h1f: oOut=8'hc0;
      8'h20: oOut=8'hb7;
      8'h21: oOut=8'hfd;
      8'h22: oOut=8'h93;
      8'h23: oOut=8'h26;
      8'h24: oOut=8'h36;
      8'h25: oOut=8'h3f;
      8'h26: oOut=8'hf7;
      8'h27: oOut=8'hcc;
      8'h28: oOut=8'h34;
      8'h29: oOut=8'ha5;
      8'h2a: oOut=8'he5;
      8'h2b: oOut=8'hf1;
      8'h2c: oOut=8'h71;
      8'h2d: oOut=8'hd8;
      8'h2e: oOut=8'h31;
      8'h2f: oOut=8'h15;
      8'h30: oOut=8'h04;
      8'h31: oOut=8'hc7;
      8'h32: oOut=8'h23;
      8'h33: oOut=8'hc3;
      8'h34: oOut=8'h18;
      8'h35: oOut=8'h96;
      8'h36: oOut=8'h05;
      8'h37: oOut=8'h9a;
      8'h38: oOut=8'h07;
      8'h39: oOut=8'h12;
      8'h3a: oOut=8'h80;
      8'h3b: oOut=8'he2;
      8'h3c: oOut=8'heb;
      8'h3d: oOut=8'h27;
      8'h3e: oOut=8'hb2;
      8'h3f: oOut=8'h75;
      8'h40: oOut=8'h09;
      8'h41: oOut=8'h83;
      8'h42: oOut=8'h2c;
      8'h43: oOut=8'h1a;
      8'h44: oOut=8'h1b;
      8'h45: oOut=8'h6e;
      8'h46: oOut=8'h5a;
      8'h47: oOut=8'ha0;
      8'h48: oOut=8'h52;
      8'h49: oOut=8'h3b;
      8'h4a: oOut=8'hd6;
      8'h4b: oOut=8'hb3;
      8'h4c: oOut=8'h29;
      8'h4d: oOut=8'he3;
      8'h4e: oOut=8'h2f;
      8'h4f: oOut=8'h84;
      8'h50: oOut=8'h53;
      8'h51: oOut=8'hd1;
      8'h52: oOut=8'h00;
      8'h53: oOut=8'hed;
      8'h54: oOut=8'h20;
      8'h55: oOut=8'hfc;
      8'h56: oOut=8'hb1;
      8'h57: oOut=8'h5b;
      8'h58: oOut=8'h6a;
      8'h59: oOut=8'hcb;
      8'h5a: oOut=8'hbe;
      8'h5b: oOut=8'h39;
      8'h5c: oOut=8'h4a;
      8'h5d: oOut=8'h4c;
      8'h5e: oOut=8'h58;
      8'h5f: oOut=8'hcf;
      8'h60: oOut=8'hd0;
      8'h61: oOut=8'hef;
      8'h62: oOut=8'haa;
      8'h63: oOut=8'hfb;
      8'h64: oOut=8'h43;
      8'h65: oOut=8'h4d;
      8'h66: oOut=8'h33;
      8'h67: oOut=8'h85;
      8'h68: oOut=8'h45;
      8'h69: oOut=8'hf9;
      8'h6a: oOut=8'h02;
      8'h6b: oOut=8'h7f;
      8'h6c: oOut=8'h50;
      8'h6d: oOut=8'h3c;
      8'h6e: oOut=8'h9f;
      8'h6f: oOut=8'ha8;
      8'h70: oOut=8'h51;
      8'h71: oOut=8'ha3;
      8'h72: oOut=8'h40;
      8'h73: oOut=8'h8f;
      8'h74: oOut=8'h92;
      8'h75: oOut=8'h9d;
      8'h76: oOut=8'h38;
      8'h77: oOut=8'hf5;
      8'h78: oOut=8'hbc;
      8'h79: oOut=8'hb6;
      8'h7a: oOut=8'hda;
      8'h7b: oOut=8'h21;
      8'h7c: oOut=8'h10;
      8'h7d: oOut=8'hff;
      8'h7e: oOut=8'hf3;
      8'h7f: oOut=8'hd2;
      8'h80: oOut=8'hcd;
      8'h81: oOut=8'h0c;
      8'h82: oOut=8'h13;
      8'h83: oOut=8'hec;
      8'h84: oOut=8'h5f;
      8'h85: oOut=8'h97;
      8'h86: oOut=8'h44;
      8'h87: oOut=8'h17;
      8'h88: oOut=8'hc4;
      8'h89: oOut=8'ha7;
      8'h8a: oOut=8'h7e;
      8'h8b: oOut=8'h3d;
      8'h8c: oOut=8'h64;
      8'h8d: oOut=8'h5d;
      8'h8e: oOut=8'h19;
      8'h8f: oOut=8'h73;
      8'h90: oOut=8'h60;
      8'h91: oOut=8'h81;
      8'h92: oOut=8'h4f;
      8'h93: oOut=8'hdc;
      8'h94: oOut=8'h22;
      8'h95: oOut=8'h2a;
      8'h96: oOut=8'h90;
      8'h97: oOut=8'h88;
      8'h98: oOut=8'h46;
      8'h99: oOut=8'hee;
      8'h9a: oOut=8'hb8;
      8'h9b: oOut=8'h14;
      8'h9c: oOut=8'hde;
      8'h9d: oOut=8'h5e;
      8'h9e: oOut=8'h0b;
      8'h9f: oOut=8'hdb;
      8'ha0: oOut=8'he0;
      8'ha1: oOut=8'h32;
      8'ha2: oOut=8'h3a;
      8'ha3: oOut=8'h0a;
      8'ha4: oOut=8'h49;
      8'ha5: oOut=8'h06;
      8'ha6: oOut=8'h24;
      8'ha7: oOut=8'h5c;
      8'ha8: oOut=8'hc2;
      8'ha9: oOut=8'hd3;
      8'haa: oOut=8'hac;
      8'hab: oOut=8'h62;
      8'hac: oOut=8'h91;
      8'had: oOut=8'h95;
      8'hae: oOut=8'he4;
      8'haf: oOut=8'h79;
      8'hb0: oOut=8'he7;
      8'hb1: oOut=8'hc8;
      8'hb2: oOut=8'h37;
      8'hb3: oOut=8'h6d;
      8'hb4: oOut=8'h8d;
      8'hb5: oOut=8'hd5;
      8'hb6: oOut=8'h4e;
      8'hb7: oOut=8'ha9;
      8'hb8: oOut=8'h6c;
      8'hb9: oOut=8'h56;
      8'hba: oOut=8'hf4;
      8'hbb: oOut=8'hea;
      8'hbc: oOut=8'h65;
      8'hbd: oOut=8'h7a;
      8'hbe: oOut=8'hae;
      8'hbf: oOut=8'h08;
      8'hc0: oOut=8'hba;
      8'hc1: oOut=8'h78;
      8'hc2: oOut=8'h25;
      8'hc3: oOut=8'h2e;
      8'hc4: oOut=8'h1c;
      8'hc5: oOut=8'ha6;
      8'hc6: oOut=8'hb4;
      8'hc7: oOut=8'hc6;
      8'hc8: oOut=8'he8;
      8'hc9: oOut=8'hdd;
      8'hca: oOut=8'h74;
      8'hcb: oOut=8'h1f;
      8'hcc: oOut=8'h4b;
      8'hcd: oOut=8'hbd;
      8'hce: oOut=8'h8b;
      8'hcf: oOut=8'h8a;
      8'hd0: oOut=8'h70;
      8'hd1: oOut=8'h3e;
      8'hd2: oOut=8'hb5;
      8'hd3: oOut=8'h66;
      8'hd4: oOut=8'h48;
      8'hd5: oOut=8'h03;
      8'hd6: oOut=8'hf6;
      8'hd7: oOut=8'h0e;
      8'hd8: oOut=8'h61;
      8'hd9: oOut=8'h35;
      8'hda: oOut=8'h57;
      8'hdb: oOut=8'hb9;
      8'hdc: oOut=8'h86;
      8'hdd: oOut=8'hc1;
      8'hde: oOut=8'h1d;
      8'hdf: oOut=8'h9e;
      8'he0: oOut=8'he1;
      8'he1: oOut=8'hf8;
      8'he2: oOut=8'h98;
      8'he3: oOut=8'h11;
      8'he4: oOut=8'h69;
      8'he5: oOut=8'hd9;
      8'he6: oOut=8'h8e;
      8'he7: oOut=8'h94;
      8'he8: oOut=8'h9b;
      8'he9: oOut=8'h1e;
      8'hea: oOut=8'h87;
      8'heb: oOut=8'he9;
      8'hec: oOut=8'hce;
      8'hed: oOut=8'h55;
      8'hee: oOut=8'h28;
      8'hef: oOut=8'hdf;
      8'hf0: oOut=8'h8c;
      8'hf1: oOut=8'ha1;
      8'hf2: oOut=8'h89;
      8'hf3: oOut=8'h0d;
      8'hf4: oOut=8'hbf;
      8'hf5: oOut=8'he6;
      8'hf6: oOut=8'h42;
      8'hf7: oOut=8'h68;
      8'hf8: oOut=8'h41;
      8'hf9: oOut=8'h99;
      8'hfa: oOut=8'h2d;
      8'hfb: oOut=8'h0f;
      8'hfc: oOut=8'hb0;
      8'hfd: oOut=8'h54;
      8'hfe: oOut=8'hbb;
      8'hff: oOut=8'h16;
    endcase
    
  end
  endfunction
  
  // Function4 : RCon
  function [31:0] RCon;
  input    [31:0] rRound;
  begin
  
    case (rRound)
      4'h1    : RCon = 32'h0100_0000;
      4'h2    : RCon = 32'h0200_0000;
      4'h3    : RCon = 32'h0400_0000;
      4'h4    : RCon = 32'h0800_0000;
      4'h5    : RCon = 32'h1000_0000;
      4'h6    : RCon = 32'h2000_0000;
      4'h7    : RCon = 32'h4000_0000;
      4'h8    : RCon = 32'h8000_0000;
      4'h9    : RCon = 32'h1b00_0000;
      4'ha    : RCon = 32'h3600_0000;
      default : RCon = 32'h0000_0000;
    endcase
    
  end
  endfunction
  
endmodule