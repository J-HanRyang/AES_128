/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : AesCtrl.v
  - Description      : AesCtrl FSM
  - Owner            : Jiyun_Han
  - Revision history : 1) 2025.01.11 : Initial release
********************************************************************/

`timescale 1ns/10ps

module AesCtrl(
  input  iClk,
  input  iRsn,
  
  input  iStAes,
  output oAesDone,
  
  output oInitRoundFlag,
  output oFstRoundFlag,
  output oMidRoundFlag,
  output oLstRoundFlag
  );
  
  parameter p_Idle      = 3'b000,
            p_InitRound = 3'b001,
            p_FstRound  = 3'b010,
            p_MidRound  = 3'b011,
            p_LstRound  = 3'b100,
            p_AesDone   = 3'b101;
  
  reg  [2:0] r_Pstate, r_Nstate;
            
  wire wEnInit;
  wire wEnFst;
  wire wEnMid;
  wire wEnLst;
  wire wEnDone;
  
  reg  [2:0] rNumOfRound;
  wire [2:0] wNumOfRound;
  
  
  always @(posedge iClk)
  begin
  
    if (!iRsn)
      r_Pstate <= p_Idle;
    else
      r_Pstate <= r_Nstate;
    
  end
  
  
  always @(*)
  begin
  
    case(r_Pstate)
      p_Idle      : if (iStAes == 1'b1)      r_Nstate <= p_InitRound; else r_Nstate <= p_Idle;
      p_InitRound :                          r_Nstate <= p_FstRound;
      p_FstRound  :                          r_Nstate <= p_MidRound;
      p_MidRound  : if (wNumOfRound == 3'h7) r_Nstate <= p_LstRound; else r_Nstate <= p_MidRound;
      p_LstRound  :                          r_Nstate <= p_AesDone;
      p_AesDone   :                          r_Nstate <= p_Idle;
      default     :                          r_Nstate <= p_Idle;
    endcase
    
  end
  
  
  assign wEnInit = (r_Pstate == p_InitRound) ? 1'b1 : 1'b0;
  assign wEnFst  = (r_Pstate == p_FstRound)  ? 1'b1 : 1'b0;
  assign wEnMid  = (r_Pstate == p_MidRound)  ? 1'b1 : 1'b0;
  assign wEnLst  = (r_Pstate == p_LstRound)  ? 1'b1 : 1'b0;
  assign wEnDone = (r_Pstate == p_AesDone)   ? 1'b1 : 1'b0;
  
  
  always @(posedge iClk)
  begin
  
    if (!iRsn)
      rNumOfRound <= 3'b0;
    else if (wEnMid == 1'b1)
    begin
    
      if(rNumOfRound == 3'h7)
        rNumOfRound <= rNumOfRound;
      else
        rNumOfRound <= rNumOfRound + 1;
      
    end    
      
  end
  
  assign wNumOfRound    = rNumOfRound;
  
  assign oInitRoundFlag = wEnInit;
  assign oFstRoundFlag  = wEnFst;
  assign oMidRoundFlag  = wEnMid;
  assign oLstRoundFlag  = wEnLst;
  assign oAesDone       = wEnDone;
  
 
endmodule