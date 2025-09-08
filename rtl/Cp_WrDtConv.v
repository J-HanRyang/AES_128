/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : Cp_WrDtConvk.v
  - Description      : Write Data Conversion 32bit --> 128bit
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.12 : Initial release
********************************************************************/

`timescale 1ns/10ps

module Cp_WrDtConv (
  input          iWrEn_InBuf,
  input  [8:0]   iWrAddr_InBuf,
  input  [31:0]  iWrDt_InBuf,
  
  output         oWrEn_CpInBuf,
  output [3:0]   oWdSel_CpInBuf,
  output [6:0]   oWrAddr_CpInBuf,
  output [127:0] oWrDt_CpInBuf
  );
  
  
 // wire & reg declaration
  wire         wWrEn_CpInBuf;
  wire [3:0]   wWdSel_CpInBuf;
  wire [6:0]   wWrAddr_CpInBuf;
  wire [127:0] wWrDt_CpInBuf;
  
  
  // Enable
  assign wWrEn_CpInBuf         = iWrEn_InBuf;
  
  // Word Address Select
  assign wWdSel_CpInBuf        = (iWrAddr_InBuf[1:0] == 2'b00) ? 4'b0001 :
                                 (iWrAddr_InBuf[1:0] == 2'b01) ? 4'b0010 :
                                 (iWrAddr_InBuf[1:0] == 2'b10) ? 4'b0100 :
                                 (iWrAddr_InBuf[1:0] == 2'b11) ? 4'b1000 : 4'b0000;
  
  // Write Data Address 
  assign wWrAddr_CpInBuf       = iWrAddr_InBuf[8:2];
  
  // wire Data
  assign wWrDt_CpInBuf[ 31: 0] = (wWdSel_CpInBuf == 4'b0001) ? iWrDt_InBuf : 32'h0;
  assign wWrDt_CpInBuf[ 63:32] = (wWdSel_CpInBuf == 4'b0010) ? iWrDt_InBuf : 32'h0;
  assign wWrDt_CpInBuf[ 95:64] = (wWdSel_CpInBuf == 4'b0100) ? iWrDt_InBuf : 32'h0;
  assign wWrDt_CpInBuf[127:96] = (wWdSel_CpInBuf == 4'b1000) ? iWrDt_InBuf : 32'h0;
  
  // Output Mapping
  assign oWrEn_CpInBuf   = wWrEn_CpInBuf;
  assign oWdSel_CpInBuf  = (iWrEn_InBuf == 1'b1) ? wWdSel_CpInBuf  :   4'h0;
  assign oWrAddr_CpInBuf = (iWrEn_InBuf == 1'b1) ? wWrAddr_CpInBuf :   7'h0;
  assign oWrDt_CpInBuf   = (iWrEn_InBuf == 1'b1) ? wWrDt_CpInBuf   : 128'h0;
  
endmodule
