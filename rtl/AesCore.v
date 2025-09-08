/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : AesCore.v
  - Description      : AesCore + RoundFunc
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.11 : Initial release
********************************************************************/

`timescale 1ns/10ps

module AesCore(
  input  iClk,
  input  iRsn,
  
  input  iStAes,
  output oAesDone,
  
  input  [127:0] iAesKey,
  input  [127:0] iPlainText,
  output [127:0] oCpText
  );
  
  wire wInit;
  wire wFst;
  wire wMid;
  wire wLst;
  
  AesCtrl U_AesCtrl (.iClk(iClk),
                     .iRsn(iRsn),
                     .iStAes(iStAes),
                     .oAesDone(oAesDone),
                     .oInitRoundFlag(wInit),
                     .oFstRoundFlag(wFst),
                     .oMidRoundFlag(wMid),
                     .oLstRoundFlag(wLst)
                     );
                     
  
  RoundFunc U_Round (.iClk(iClk),
                     .iRsn(iRsn),
                     .iInitRoundFlag(wInit),
                     .iFstRoundFlag(wFst),
                     .iMidRoundFlag(wMid),
                     .iLstRoundFlag(wLst),
                     .iAesKey(iAesKey),
                     .iPlainText(iPlainText),
                     .oCpText(oCpText)
                     );
                     
endmodule
