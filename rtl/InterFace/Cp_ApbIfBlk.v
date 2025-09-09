/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : Cp_ApbIfBlk.v
  - Description      : APB Interface
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.12 : Initial release
********************************************************************/

`timescale 1ns/10ps

module Cp_ApbIfBlk(

  // Clock & Reset
  input          iClk,
  input          iRsn,
  
  // APB Interface
  input          iPsel,
  input          iPenable,
  input          iPwrite,
  input  [15:0]  iPaddr,
  
  input  [31:0]  iPwdata,
  output [31:0]  oPrdata,
  
  output         oInt,
  
  // InBuf_Conversion
  output         oWrEn_InBuf,
  output [8:0]   oWrAddr_InBuf,
  output [31:0]  oWrDt_InBuf,
  
  // OutBuf_Conversion
  output         oRdEn_OutBuf,
  output [8:0]   oRdAddr_OutBuf,
  input  [31:0]  iRdDt_OutBuf,
  
  // Control
  output         oStCp,
  output [11:0]  oCpByteSize,
  input          iCpDone,
  
  // AesCore
  output [127:0] oAesKey
  );
  
  
  // wire & red declaration
  wire wWrEn;
  wire wRdEn;
  
  wire         wWrEn_InBuf;
  wire [8:0]   wWrAddr_InBuf;
  wire [31:0]  wWrDt_InBuf;
  
  wire         wRdEn_OutBuf;
  wire [8:0]   wRdAddr_OutBuf;
  wire [31:0]  wRdDt_OutBuf;
  
  reg  [11:0]  rCpByteSize;
  wire         wStCp;
  wire         wCpDone;
  
  reg  [127:0] rAesKey;
    
  reg          rIntEnable;
  reg          rIntPending;
  reg          rIntMask;
  
  wire         wInt;
  
  
  /************************************************************************
  // Wr/Rd Enable Signal
  ************************************************************************/
  assign wWrEn = (   (iPsel         == 1'b1)
                   & (iPenable      == 1'b0)
                   & (iPwrite       == 1'b1)   ) ? 1'b1 : 1'b0;
                   
  assign wRdEn = (   (iPsel         == 1'b1)
                   & (iPenable      == 1'b0)
                   & (iPwrite       == 1'b0)   ) ? 1'b1 : 1'b0;
                   
                   
 /***********************************************************************
 // InBuf_Conversion
 ***********************************************************************/ 
  assign wWrEn_InBuf   = (    (wWrEn         == 1'b1)
                           && (iPaddr[15:12] == 4'h4)    ) ? 1'b1 : 1'b0;
                   
  // 4000 --> 0, 47FC --> 1FF
  assign wWrAddr_InBuf = iPaddr[10:2];

  // Write Data
  assign wWrDt_InBuf = iPwdata;

  // Output Assign
  assign oWrEn_InBuf   = wWrEn_InBuf;
  assign oWrAddr_InBuf = wWrAddr_InBuf;
  assign oWrDt_InBuf   = wWrDt_InBuf;
  

  /************************************************************************
  // OutBuf_Conversion
  ************************************************************************/
  assign wRdEn_OutBuf   = (    (wRdEn         == 1'b1)
                            && (iPaddr[15:12] == 4'h6)    ) ? 1'b1 : 1'b0;

  // 6000 --> 0, 67FC --> 1FF
  assign wRdAddr_OutBuf = iPaddr[10:2];

  // Read Data
  assign wRdDt_OutBuf   = iRdDt_OutBuf;

  // Output Assign
  assign oRdEn_OutBuf   = wRdEn_OutBuf;
  assign oRdAddr_OutBuf = wRdAddr_OutBuf;
  assign oPrdata        = wRdDt_OutBuf;
  
  
  /************************************************************************
  // Control Interface
  ************************************************************************/
  assign wStCp = (    (wWrEn      == 1'b1)
                   && (iPaddr     == 16'h0)
                   && (iPwdata[0] == 1'b1)    ) ? 1'b1 : 1'b0;
                   
  always @(posedge iClk)
  begin
  
    if (!iRsn)
      rCpByteSize <= 12'b0;
    else if ((wWrEn == 1'b1) && (iPaddr[15:0] == 16'h4))
      rCpByteSize <= iPwdata;
  
  end 
  
  assign oStCp = wStCp;
  assign oCpByteSize = rCpByteSize;
  
  
  /************************************************************************
  // AesCore - Key
  ************************************************************************/
  always @(posedge iClk)
  begin
  
    if (!iRsn)
      rAesKey <= 128'h0;
    else if ((wWrEn == 1'b1) && (iPaddr[15:12] == 4'h2))
    begin
      case (iPaddr[3:0])
        4'h0 : rAesKey[ 31: 0] <= iPwdata;
        4'h4 : rAesKey[ 63:32] <= iPwdata;
        4'h8 : rAesKey[ 96:64] <= iPwdata;
        4'hC : rAesKey[127:96] <= iPwdata;
      endcase 
    end
    
  end
  
  assign oAesKey = rAesKey;
  
   
  /************************************************************************
  // Interrupt
  ************************************************************************/
  
  // rIntMask
  always @(posedge iClk)
  begin

    if (!iRsn)
      rIntMask <= 1'b0;
    else if((wWrEn == 1'b1) && (iPaddr == 16'hA008))
      rIntMask <= iPwdata[0];
  
  end

  // rIntEnable
  always @(posedge iClk)
  begin

    if (!iRsn)
      rIntEnable <= 1'b0;
    else if((wWrEn == 1'b1) && (iPaddr == 16'hA000))
      rIntEnable <= iPwdata[0];
      
  end

  // rIntPending
  always @(posedge iClk)
  begin

    if (!iRsn)
      rIntPending <= 1'b0;
    else if ((rIntEnable == 1'b1) && (wCpDone == 1'b1))
      rIntPending <= 1'b1;
    else if ((wWrEn == 1'b1) && (iPaddr == 16'hA004) && iPwdata[0] == 1'b1)
      rIntPending <= 1'b0;

  end
  
  assign wCpDone = iCpDone;
  assign wInt    = (rIntMask & rIntPending);
  
  assign oInt    = wInt;
  
endmodule
