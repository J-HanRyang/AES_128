/*******************************************************************
  - Project          : 2024 winter internship
  - File name        : Cp_BufWrap.v
  - Description      : 128x128 SPSRAM wrapper
  - Owner            : Inchul.song
  - Revision history : 1) 2025.01.07 : Initial release
*******************************************************************/

`timescale 1ns/10ps

module Cp_BufWrap (

  // Clock & reset
  input            iClk,               // Rising edge
  input            iRsn,               // Sync. & low reset


  // Write port
  input            iWrEn,              // Write enable, active high
  input  [3:0]     iWdSel,             // Write word select, active high
  input  [6:0]     iWrAddr,            // Write address
  input  [127:0]   iWrDt,              // 32bit write data


  // Read port
  input            iRdEn,              // Read enable, active high
  input  [6:0]     iRdAddr,            // Read address
  output [127:0]   oRdDt               // 32bit read data

  );



  // Wire & reg declaration
  wire             wCsn;
  wire             wWrn;
  wire [3:0]       wWdSel;
  wire [6:0]       wAddr;



  /*******************************************************/
  // SpSram interface signals
  /*******************************************************/
  // Chip select (0: Selected, 1: Not selected)
  assign wCsn    = (iWrEn == 1'b1 || iRdEn == 1'b1) ? 1'b0 : 1'b1;

  // Write enable (0: write, 1: read)
  assign wWrn    = (iWrEn == 1'b1 && iRdEn == 1'b0) ? 1'b0 : 1'b1;

  // Write word select (0: selected, 1: not selected)
  assign wWdSel  = (iWrEn == 1'b1) ? ~iWdSel[3:0] : 4'hF;

  // 32bit address
  assign wAddr   = (iWrEn == 1'b1) ? iWrAddr[6:0] :
                   (iRdEn == 1'b1) ? iRdAddr[6:0] : 7'h0;



  /*******************************************************/
  // SpSram instantiation
  /*******************************************************/
  SpSram_128x128 A_SpSram_128x128 (
  // Clock & reset
    .iClk               (iClk),
    .iRsn               (iRsn),


  // SP-SRAM Input & Output
    .iCsn               (wCsn),
    .iWrn               (wWrn),
    .iWdSel             (wWdSel[3:0]),
    .iAddr              (wAddr[6:0]),

    .iWrDt              (iWrDt[127:0]),
    .oRdDt              (oRdDt[127:0])
  );


endmodule
