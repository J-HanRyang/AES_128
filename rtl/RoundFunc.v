/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : RoundFunc.v
  - Description      : RoundFunction
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.11 : Initial release
                       2) 2025.01.13 : Finish
********************************************************************/

`timescale 1ns/10ps

module RoundFunc(
  input  iClk,
  input  iRsn,
  
  input  iInitRoundFlag,
  input  iFstRoundFlag,
  input  iMidRoundFlag,
  input  iLstRoundFlag,
  
  input  [127:0] iAesKey,
  input  [127:0] iPlainText,
  output [127:0] oCpText
  );
  
  wire [127:0] wAesText;
  wire [127:0] wSubText;
  wire [127:0] wShiftText;
  wire [127:0] wMixText;
  wire [127:0] wRoundText;
  wire [127:0] wSMRText;
  wire [127:0] wAddText;
  
  wire [127:0] wAesKey;
  wire [127:0] wAddKey;
  wire [127:0] wPreKey;
  
  wire [127:0] wCpText;
  
  wire         wEn;
  
  assign wEn      = (   iInitRoundFlag
                      | iFstRoundFlag
                      | iMidRoundFlag
                      | iLstRoundFlag   );
  
  assign wSMRText = (iLstRoundFlag == 1'b1)  ? wShiftText : wMixText;
  
  assign wAddText = (iInitRoundFlag == 1'b1) ? iPlainText : wSMRText;
  
  
  SubBytes U_Sub      (.iPlainText(wAesText),
                       .oSubText(wSubText)
                       );
                  
  ShiftRows U_Shift   (.iSubText(wSubText),
                       .oShiftText(wShiftText)
                       );
                    
  MixColumns U_Mix    (.iShiftText(wShiftText),
                       .oMixText(wMixText)
                       );
                    
  AddRoundKey U_Round (.iMixText(wAddText),
                       .iAesKey(wAddKey),
                       .oRoundText(wRoundText)
                       );
                       
  KeyExpansion U_Key  (.iAesKey(iAesKey),
                       .iPreKey(wPreKey),
                       .oAesKey(wAesKey),
                       .oAddKey(wAddKey),
                       .iInitRoundFlag(iInitRoundFlag)
                       );
   
  Flip_Flop U_Data_FF (.iClk(iClk),
                       .iRsn(iRsn),
                       .iEn(wEn),
                       .iInText(wRoundText),
                       .oOutText(wAesText)
                       );
                         
  Flip_Flop U_Key_FF  (.iClk(iClk),
                       .iRsn(iRsn),
                       .iEn(wEn),
                       .iInText(wAesKey),
                       .oOutText(wPreKey)
                       );

assign oCpText = wAesText;
  
  endmodule