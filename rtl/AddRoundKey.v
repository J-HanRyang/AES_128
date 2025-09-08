/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : AddRoundKey.v
  - Description      : Data Xor Key
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.10 : Initial release
********************************************************************/

`timescale 1ns/10ps

module AddRoundKey(
  input  [127:0] iMixText,
  input  [127:0] iAesKey,
  output [127:0] oRoundText
  );
  
  assign oRoundText = iAesKey ^ iMixText;

endmodule