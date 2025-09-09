/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : MixColumns.v
  - Description      : matrix operations
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.10 : Initial release
********************************************************************/

`timescale 1ns/10ps

module MixColumns(
  input  [127:0] iShiftText,
  output [127:0] oMixText
  );
  
  // generate 
  genvar i;
  
  generate
    for (i=0; i<4; i=i+1)
    begin : Mix_Columns
  
      assign oMixText[(i*32)+31 -:8] =   Mb2(iShiftText[(i*32)+31 -:8]) 
                                       ^ Mb3(iShiftText[(i*32)+23 -:8])
                                       ^     iShiftText[(i*32)+15 -:8] 
                                       ^     iShiftText[(i*32)+7  -:8];
                                
      assign oMixText[(i*32)+23 -:8] =       iShiftText[(i*32)+31 -:8]
                                       ^ Mb2(iShiftText[(i*32)+23 -:8])
                                       ^ Mb3(iShiftText[(i*32)+15 -:8]) 
                                       ^     iShiftText[(i*32)+7  -:8];
                                
      assign oMixText[(i*32)+15 -:8] =       iShiftText[(i*32)+31 -:8]
                                       ^     iShiftText[(i*32)+23 -:8]
                                       ^ Mb2(iShiftText[(i*32)+15 -:8]) 
                                       ^ Mb3(iShiftText[(i*32)+7  -:8]);
                                
      assign oMixText[(i*32)+7  -:8] =   Mb3(iShiftText[(i*32)+31 -:8]) 
                                       ^     iShiftText[(i*32)+23 -:8]
                                       ^     iShiftText[(i*32)+15 -:8] 
                                       ^ Mb2(iShiftText[(i*32)+7  -:8]);
  
    end
  endgenerate
  
    
  // Funtion - Multiply by 2
  function [7:0] Mb2;
    input [7:0] x;
    begin
    
      if(x[7] == 1'b1)
        Mb2 = ((x << 1'b1) ^ 8'h1b); // Xor 0001_1011
      else
        Mb2 = x << 1;
      
    end
  endfunction
  
  // Funtion - Multiply by 2
  function [7:0] Mb3;               // Multiply by 3
    input [7:0] x;
    
      Mb3 = Mb2(x) ^ x;             // Add = Xor
      
  endfunction
  
  
endmodule
