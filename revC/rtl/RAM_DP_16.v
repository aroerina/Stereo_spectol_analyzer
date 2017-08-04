/* Verilog netlist generated by SCUBA Diamond_1.0_Production (529) */
/* Module Version: 6.1 */
/* C:\lscc\diamond\1.0\ispfpga\bin\nt\scuba.exe -w -lang verilog -synth synplify -bus_exp 7 -bb -arch mg5a00 -type bram -wp 10 -rp 0011 -rdata_width 18 -data_width 18 -num_rows 16 -resetmode SYNC -cascade -1 -e  */
/* Sat Dec 11 18:31:57 2010 */


`timescale 1 ns / 1 ps
module RAM_DP_16 (WrAddress, RdAddress, Data, WE, RdClock, RdClockEn, 
    Reset, WrClock, WrClockEn, Q);
    input wire [3:0] WrAddress;
    input wire [3:0] RdAddress;
    input wire [17:0] Data;
    input wire WE;
    input wire RdClock;
    input wire RdClockEn;
    input wire Reset;
    input wire WrClock;
    input wire WrClockEn;
    output wire [17:0] Q;

    wire scuba_vhi;
    wire scuba_vlo;

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    // synopsys translate_off
    defparam RAM_DP_16_0_0_0.CSDECODE_B =  3'b000 ;
    defparam RAM_DP_16_0_0_0.CSDECODE_A =  3'b000 ;
    defparam RAM_DP_16_0_0_0.WRITEMODE_B = "NORMAL" ;
    defparam RAM_DP_16_0_0_0.WRITEMODE_A = "NORMAL" ;
    defparam RAM_DP_16_0_0_0.GSR = "DISABLED" ;
    defparam RAM_DP_16_0_0_0.RESETMODE = "SYNC" ;
    defparam RAM_DP_16_0_0_0.REGMODE_B = "NOREG" ;
    defparam RAM_DP_16_0_0_0.REGMODE_A = "NOREG" ;
    defparam RAM_DP_16_0_0_0.DATA_WIDTH_B = 18 ;
    defparam RAM_DP_16_0_0_0.DATA_WIDTH_A = 18 ;
    // synopsys translate_on
    DP16KB RAM_DP_16_0_0_0 (.DIA0(Data[0]), .DIA1(Data[1]), .DIA2(Data[2]), 
        .DIA3(Data[3]), .DIA4(Data[4]), .DIA5(Data[5]), .DIA6(Data[6]), 
        .DIA7(Data[7]), .DIA8(Data[8]), .DIA9(Data[9]), .DIA10(Data[10]), 
        .DIA11(Data[11]), .DIA12(Data[12]), .DIA13(Data[13]), .DIA14(Data[14]), 
        .DIA15(Data[15]), .DIA16(Data[16]), .DIA17(Data[17]), .ADA0(scuba_vhi), 
        .ADA1(scuba_vhi), .ADA2(scuba_vlo), .ADA3(scuba_vlo), .ADA4(WrAddress[0]), 
        .ADA5(WrAddress[1]), .ADA6(WrAddress[2]), .ADA7(WrAddress[3]), .ADA8(scuba_vlo), 
        .ADA9(scuba_vlo), .ADA10(scuba_vlo), .ADA11(scuba_vlo), .ADA12(scuba_vlo), 
        .ADA13(scuba_vlo), .CEA(WrClockEn), .CLKA(WrClock), .WEA(WE), .CSA0(scuba_vlo), 
        .CSA1(scuba_vlo), .CSA2(scuba_vlo), .RSTA(Reset), .DIB0(scuba_vlo), 
        .DIB1(scuba_vlo), .DIB2(scuba_vlo), .DIB3(scuba_vlo), .DIB4(scuba_vlo), 
        .DIB5(scuba_vlo), .DIB6(scuba_vlo), .DIB7(scuba_vlo), .DIB8(scuba_vlo), 
        .DIB9(scuba_vlo), .DIB10(scuba_vlo), .DIB11(scuba_vlo), .DIB12(scuba_vlo), 
        .DIB13(scuba_vlo), .DIB14(scuba_vlo), .DIB15(scuba_vlo), .DIB16(scuba_vlo), 
        .DIB17(scuba_vlo), .ADB0(scuba_vlo), .ADB1(scuba_vlo), .ADB2(scuba_vlo), 
        .ADB3(scuba_vlo), .ADB4(RdAddress[0]), .ADB5(RdAddress[1]), .ADB6(RdAddress[2]), 
        .ADB7(RdAddress[3]), .ADB8(scuba_vlo), .ADB9(scuba_vlo), .ADB10(scuba_vlo), 
        .ADB11(scuba_vlo), .ADB12(scuba_vlo), .ADB13(scuba_vlo), .CEB(RdClockEn), 
        .CLKB(RdClock), .WEB(scuba_vlo), .CSB0(scuba_vlo), .CSB1(scuba_vlo), 
        .CSB2(scuba_vlo), .RSTB(Reset), .DOA0(), .DOA1(), .DOA2(), .DOA3(), 
        .DOA4(), .DOA5(), .DOA6(), .DOA7(), .DOA8(), .DOA9(), .DOA10(), 
        .DOA11(), .DOA12(), .DOA13(), .DOA14(), .DOA15(), .DOA16(), .DOA17(), 
        .DOB0(Q[0]), .DOB1(Q[1]), .DOB2(Q[2]), .DOB3(Q[3]), .DOB4(Q[4]), 
        .DOB5(Q[5]), .DOB6(Q[6]), .DOB7(Q[7]), .DOB8(Q[8]), .DOB9(Q[9]), 
        .DOB10(Q[10]), .DOB11(Q[11]), .DOB12(Q[12]), .DOB13(Q[13]), .DOB14(Q[14]), 
        .DOB15(Q[15]), .DOB16(Q[16]), .DOB17(Q[17]))
             /* synthesis MEM_LPC_FILE="RAM_DP_16.lpc" */
             /* synthesis MEM_INIT_FILE="" */
             /* synthesis CSDECODE_B="0b000" */
             /* synthesis CSDECODE_A="0b000" */
             /* synthesis WRITEMODE_B="NORMAL" */
             /* synthesis WRITEMODE_A="NORMAL" */
             /* synthesis GSR="DISABLED" */
             /* synthesis RESETMODE="SYNC" */
             /* synthesis REGMODE_B="NOREG" */
             /* synthesis REGMODE_A="NOREG" */
             /* synthesis DATA_WIDTH_B="18" */
             /* synthesis DATA_WIDTH_A="18" */;



    // exemplar begin
    // exemplar attribute RAM_DP_16_0_0_0 MEM_LPC_FILE RAM_DP_16.lpc
    // exemplar attribute RAM_DP_16_0_0_0 MEM_INIT_FILE 
    // exemplar attribute RAM_DP_16_0_0_0 CSDECODE_B 0b000
    // exemplar attribute RAM_DP_16_0_0_0 CSDECODE_A 0b000
    // exemplar attribute RAM_DP_16_0_0_0 WRITEMODE_B NORMAL
    // exemplar attribute RAM_DP_16_0_0_0 WRITEMODE_A NORMAL
    // exemplar attribute RAM_DP_16_0_0_0 GSR DISABLED
    // exemplar attribute RAM_DP_16_0_0_0 RESETMODE SYNC
    // exemplar attribute RAM_DP_16_0_0_0 REGMODE_B NOREG
    // exemplar attribute RAM_DP_16_0_0_0 REGMODE_A NOREG
    // exemplar attribute RAM_DP_16_0_0_0 DATA_WIDTH_B 18
    // exemplar attribute RAM_DP_16_0_0_0 DATA_WIDTH_A 18
    // exemplar end

endmodule