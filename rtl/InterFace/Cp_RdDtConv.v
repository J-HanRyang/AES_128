/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : Cp_RdDtConv.v
  - Description      : Read Data Conversion 128bit --> 32bit
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.12 : Initial release
********************************************************************/

`timescale 1ns/10ps

module Cp_RdDtConv (
  input          iRdEn_OutBuf,
  input  [8:0]   iRdAddr_OutBuf,
  output [31:0]  oRdDt_OutBuf,
  
  output         oRdEn_CpOutBuf,
  output [6:0]   oRdAddr_CpOutBuf,
  input  [127:0] iRdDt_CpOutBuf
  );


  // Write Data Address 
  wire         wRdEn_CpOutBuf;
  wire [6:0]   wRdAddr_CpOutBuf;
  reg  [31:0]  rRdDt_OutBuf;


  // Enable
  assign wRdEn_CpOutBuf   = iRdEn_OutBuf;
  
  // Read Data Address
  assign wRdAddr_CpOutBuf = iRdAddr_OutBuf[8:2];
  
  // Read Data
  always @(*)
  begin
  
    if (iRdEn_OutBuf == 1'b1)
    begin
      case (iRdAddr_OutBuf[1:0])
        2'b00   : rRdDt_OutBuf <= iRdDt_CpOutBuf[ 31: 0];
        2'b01   : rRdDt_OutBuf <= iRdDt_CpOutBuf[ 63:32];
        2'b10   : rRdDt_OutBuf <= iRdDt_CpOutBuf[ 95:64];
        2'b11   : rRdDt_OutBuf <= iRdDt_CpOutBuf[127:96];
        default : rRdDt_OutBuf <= 32'h0;
      endcase
    end
    else
      rRdDt_OutBuf <= rRdDt_OutBuf;
    
  end
  
  // Output Mapping
  assign oRdEn_CpOutBuf   = wRdEn_CpOutBuf;
  assign oRdAddr_CpOutBuf = (iRdEn_OutBuf == 1'b1) ? wRdAddr_CpOutBuf : 7'b0;
  assign oRdDt_OutBuf     = rRdDt_OutBuf;
  
endmodule
