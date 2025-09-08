/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : ShiftRows.v
  - Description      : Shift Rows
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.10 : Initial release
********************************************************************/

`timescale 1ns/10ps

module ShiftRows(
  input  [127:0] iSubText,
  output [127:0] oShiftText
  );
  
  // First row is not shifted
  assign oShiftText[127 -:8] = iSubText[127 -:8];
  assign oShiftText[95  -:8] = iSubText[95  -:8];
  assign oShiftText[63  -:8] = iSubText[63  -:8];
  assign oShiftText[31  -:8] = iSubText[31  -:8];
	
  // Second row left shifed by 1
  assign oShiftText[119 -:8] = iSubText[87  -:8];
  assign oShiftText[87  -:8] = iSubText[55  -:8];
  assign oShiftText[55  -:8] = iSubText[23  -:8];
  assign oShiftText[23  -:8] = iSubText[119 -:8];
	
  // Third row left shifed by 2
  assign oShiftText[111 -:8] = iSubText[47  -:8];
  assign oShiftText[79  -:8] = iSubText[15  -:8];
  assign oShiftText[47  -:8] = iSubText[111 -:8];
  assign oShiftText[15  -:8] = iSubText[79  -:8];
	
  // Fourth row left shifted by 3 --> right shifted by 1
  assign oShiftText[103 -:8] = iSubText[7   -:8];
  assign oShiftText[71  -:8] = iSubText[103 -:8];
  assign oShiftText[39  -:8] = iSubText[71  -:8];
  assign oShiftText[7   -:8] = iSubText[39  -:8];
  
endmodule