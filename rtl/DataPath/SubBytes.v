/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : SubBytes.v
  - Description      : Data replacement with S-Box
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.10 : Initial release
********************************************************************/

`timescale 1ns/10ps

module SubBytes(
  input  [127:0] iPlainText,
  output [127:0] oSubText
  );
  
  genvar i;
  
  generate
    for (i=0; i<128; i=i+8)
    begin : Sub_Bytes
    
      S_Box U_S_Box(.iIn(iPlainText[i +:8]),
                    .oOut(oSubText[i +:8])
                    );
                    
    end
  endgenerate
 
endmodule
