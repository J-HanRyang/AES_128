/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : Cp_Ctrl.v
  - Description      : Controller wirh Endian conversion
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.12 : Initial release
********************************************************************/

`timescale 1ns/10ps

module Cp_Ctrl (
  // Clock & Reset
  input iClk,
  input iRsn,
  
  // Apb Interface
  input          iStCp,
  input  [ 11:0] iCpByteSize,
  output         oCpDone,
  
  // InBuf Interface
  output         oRdEn_CpInBuf,
  output [  6:0] oRdAddr_CpInBuf,
  input  [127:0] iRdDt_CpInBuf,
  
  // OutBuf Interface
  output         oWrEn_CpOutBuf,
  output [  3:0] oWdSel_CpOutBuf,
  output [  6:0] oWrAddr_CpOutBuf,
  output [127:0] oWrDt_CpOutBuf,
  
  // AesCore Interface
  output         oStAes,
  output [127:0] oPlainText,
  input          iAesDone,
  input  [127:0] iCpText
  );
  
  
  // Parameter
  parameter p_Idle       = 3'b000,
            p_StCp       = 3'b001,
            p_RdCpInBuf  = 3'b010,
            p_StAes      = 3'b011,
            p_WtAes      = 3'b100,
            p_AesDone    = 3'b101,
            p_WrCpOutBuf = 3'b110,
            p_CpDone     = 3'b111;
            
            
  // wire & reg
  // FSM
  reg  [  2:0] rPstate;
  reg  [  2:0] rNstate;
  
  wire         wEnStCp;
  wire         wEnRdCpInBuf;
  wire         wEnStAes;
  wire         wEnWtAes;
  wire         wEnAesDone;
  wire         wEnWrCpOutBuf;
  wire         wEnCpDone;
  
  // Apb
  wire         wCpDone;
  
  reg  [ 11:0] rCpByteSize;
  wire         wLastDtFlag;
  // InBuf
  wire         wRdEn_CpInBuf;
  reg  [  6:0] rRdAddr_CpInBuf;
  
  // Little --> Big Endian
  reg  [127:0] rRdDt_EndianConv;
  wire [  7:0] wValidBytes;
  
  // OutBuf
  wire         wWrEn_CpOutBuf;
  reg  [  3:0] rWdSel_CpOutBuf;
  reg  [  6:0] rWrAddr_CpOutBuf;
  wire [127:0] wWrDt_CpOutBuf;
  
  // Big --> Little Endian
  wire [127:0] wWrDt_EndianConv;
  
  // AesCore
  wire         wStAes;
  wire [127:0] wPlainText;
  
  
  /**************************************************/
  // FSM
  /**************************************************/
  always @(posedge iClk)
  begin
  
    if (!iRsn)
      rPstate <= p_Idle;
    else
      rPstate <= rNstate;
  
  end
  
  always @(*)
  begin
  
    case (rPstate)
      p_Idle       : if (iStCp == 1'b1)       rNstate <= p_StCp;       else rNstate <= p_Idle;
      p_StCp       :                          rNstate <= p_RdCpInBuf;
      p_RdCpInBuf  :                          rNstate <= p_StAes;
      p_StAes      :                          rNstate <= p_WtAes;
      p_WtAes      : if (iAesDone == 1'b1)    rNstate <= p_AesDone;    else rNstate <= p_WtAes;
      p_AesDone    :                          rNstate <= p_WrCpOutBuf;
      p_WrCpOutBuf : if (wLastDtFlag == 1'b1) rNstate <= p_CpDone;     else rNstate <= p_RdCpInBuf;
      p_CpDone     :                          rNstate <= p_Idle;
      default      :                          rNstate <= p_Idle;
    endcase
    
  end
  
  
  /**************************************************/
  // Contol Signal
  /**************************************************/
  
  assign wEnStCp       = (rPstate == p_StCp)       ? 1'b1 : 1'b0;
  assign wEnRdCpInBuf  = (rPstate == p_RdCpInBuf)  ? 1'b1 : 1'b0;
  assign wEnStAes      = (rPstate == p_StAes)      ? 1'b1 : 1'b0;
  assign wEnWtAes      = (rPstate == p_WtAes)      ? 1'b1 : 1'b0;
  assign wEnAesDone    = (rPstate == p_AesDone)    ? 1'b1 : 1'b0;
  assign wEnWrCpOutBuf = (rPstate == p_WrCpOutBuf) ? 1'b1 : 1'b0;
  assign wEnCpDone     = (rPstate == p_CpDone)     ? 1'b1 : 1'b0;
  
  
  /**************************************************/
  // InBuf Read
  /**************************************************/
  assign wRdEn_CpInBuf = wEnRdCpInBuf;
  
  always @(posedge iClk)
  begin
  
    if(!iRsn)
      rRdAddr_CpInBuf <= 7'b0;
    else if (wEnStCp == 1'b1 || wEnCpDone == 1'b1)
      rRdAddr_CpInBuf <= 7'b0;
    else if (wRdEn_CpInBuf == 1'b1)
    begin
      if (rRdAddr_CpInBuf == (iCpByteSize / 16))
        rRdAddr_CpInBuf <= rRdAddr_CpInBuf;
      else
        rRdAddr_CpInBuf <= rRdAddr_CpInBuf + 1;
    end
  
  end
  
  // Mapping
  assign oRdEn_CpInBuf    = wRdEn_CpInBuf;
  assign oRdAddr_CpInBuf  = rRdAddr_CpInBuf;
  
  // Little --> Big Endian
  assign wValidBytes = (iCpByteSize > (rRdAddr_CpInBuf * 16)) ? (iCpByteSize - (rRdAddr_CpInBuf * 16)) : 0;
  
  always @(*)
  begin
    
    rRdDt_EndianConv = {iRdDt_CpInBuf[  7: 0],
                         iRdDt_CpInBuf[ 15: 8],
                         iRdDt_CpInBuf[ 23:16],
                         iRdDt_CpInBuf[ 31:24],  // First 32-bit
                         iRdDt_CpInBuf[ 39:32],
                         iRdDt_CpInBuf[ 47:40],
                         iRdDt_CpInBuf[ 55:48],
                         iRdDt_CpInBuf[ 63:56],  // Second 32-bit
                         iRdDt_CpInBuf[ 71:64],
                         iRdDt_CpInBuf[ 79:72],
                         iRdDt_CpInBuf[ 87:80],
                         iRdDt_CpInBuf[ 95:88],  // Third 32-bit
                         iRdDt_CpInBuf[103:96],
                         iRdDt_CpInBuf[111:104],
                         iRdDt_CpInBuf[119:112],
                         iRdDt_CpInBuf[127:120]}; // Fourth 32-bit      
                                       
    case (wValidBytes)
      8'h0    : rRdDt_EndianConv[127:0] = 0;
      8'h1    : rRdDt_EndianConv[119:0] = 0;
      8'h2    : rRdDt_EndianConv[111:0] = 0;
      8'h3    : rRdDt_EndianConv[103:0] = 0;
      8'h4    : rRdDt_EndianConv[ 95:0] = 0;
      8'h5    : rRdDt_EndianConv[ 87:0] = 0;
      8'h6    : rRdDt_EndianConv[ 79:0] = 0;
      8'h7    : rRdDt_EndianConv[ 71:0] = 0;
      8'h8    : rRdDt_EndianConv[ 63:0] = 0;
      8'h9    : rRdDt_EndianConv[ 55:0] = 0;
      8'ha    : rRdDt_EndianConv[ 47:0] = 0;
      8'hb    : rRdDt_EndianConv[ 39:0] = 0;
      8'hc    : rRdDt_EndianConv[ 31:0] = 0;
      8'hd    : rRdDt_EndianConv[ 23:0] = 0;
      8'he    : rRdDt_EndianConv[ 15:0] = 0;
      8'hf    : rRdDt_EndianConv[  7:0] = 0;
      default : rRdDt_EndianConv        = rRdDt_EndianConv;
    endcase
    
  end
  
  
  /**************************************************/
  // Aes Core
  /**************************************************/
  assign wPlainText = rRdDt_EndianConv;
  assign wStAes     = wEnStAes;
  
  assign oStAes     = wStAes;
  assign oPlainText = wPlainText;
  
  
  /**************************************************/
  // OutBuf Write
  /**************************************************/
  assign wWrEn_CpOutBuf = wEnWrCpOutBuf;
  
  always @(posedge iClk)
  begin
  
    if(!iRsn)
      rWrAddr_CpOutBuf <= 7'b0;
    else if (wEnStCp == 1'b1 || wEnCpDone == 1'b1)
      rWrAddr_CpOutBuf <= 7'b0;
    else if (wWrEn_CpOutBuf == 1'b1)
    begin
      if (rWrAddr_CpOutBuf == (iCpByteSize / 16))
        rWrAddr_CpOutBuf <= rWrAddr_CpOutBuf;
      else
        rWrAddr_CpOutBuf <= rWrAddr_CpOutBuf + 1;
    end
    
  end
  
  //Mapping
  assign oWrEn_CpOutBuf   = wWrEn_CpOutBuf;
  assign oWrAddr_CpOutBuf = rWrAddr_CpOutBuf;
  
  // Big --> Little Endian
  
  assign wWrDt_EndianConv = {iCpText[  7: 0],
                             iCpText[ 15: 8],
                             iCpText[ 23:16],
                             iCpText[ 31:24],  // First 32-bit
                             iCpText[ 39:32],
                             iCpText[ 47:40],
                             iCpText[ 55:48],
                             iCpText[ 63:56],  // Second 32-bit
                             iCpText[ 71:64],
                             iCpText[ 79:72],
                             iCpText[ 87:80],
                             iCpText[ 95:88],  // Third 32-bit
                             iCpText[103:96],
                             iCpText[111:104],
                             iCpText[119:112],
                             iCpText[127:120]}; // Fourth 32-bit
                             
  assign oWrDt_CpOutBuf   = wWrDt_EndianConv;
  
  assign wWdSel_CpOutBuf  = 4'b1111;
  
  assign oWdSel_CpOutBuf  = wWdSel_CpOutBuf;   


  
    /**************************************************/
  // Last Read / Output Mapping
  /**************************************************/
  
  assign wLastDtFlag = (rRdAddr_CpInBuf == (iCpByteSize / 16)) ? 1'b1 : 1'b0;
  
  assign oCpDone     = wEnCpDone;
  
  
endmodule 
