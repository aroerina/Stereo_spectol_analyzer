/* Verilog netlist generated by SCUBA Diamond_1.2_Production (92) */
/* Module Version: 6.1 */
/* C:\lscc\diamond\1.2\ispfpga\bin\nt\scuba.exe -w -lang verilog -synth synplify -bus_exp 7 -bb -arch mg5a00 -type bram -wp 10 -rp 0011 -rdata_width 9 -data_width 9 -num_rows 16 -outdata REGISTERED -resetmode SYNC -memfile c:/dev/source/hdl/fpgaproject/ipex/sqwave9b16d.mem -memformat hex -cascade -1 -e  */
/* Fri Aug 19 15:58:31 2011 */


`timescale 1 ns / 1 ps
module DPRAM9b16d_SQW (WrAddress, RdAddress, Data, WE, RdClock, 
    RdClockEn, Reset, WrClock, WrClockEn, Q);
    input wire [3:0] WrAddress;
    input wire [3:0] RdAddress;
    input wire [8:0] Data;
    input wire WE;
    input wire RdClock;
    input wire RdClockEn;
    input wire Reset;
    input wire WrClock;
    input wire WrClockEn;
    output wire [8:0] Q;

    wire scuba_vhi;
    wire scuba_vlo;

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    // synopsys translate_off
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_3F = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_3E = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_3D = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_3C = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_3B = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_3A = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_39 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_38 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_37 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_36 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_35 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_34 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_33 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_32 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_31 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_30 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_2F = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_2E = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_2D = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_2C = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_2B = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_2A = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_29 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_28 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_27 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_26 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_25 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_24 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_23 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_22 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_21 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_20 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_1F = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_1E = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_1D = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_1C = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_1B = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_1A = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_19 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_18 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_17 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_16 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_15 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_14 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_13 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_12 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_11 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_10 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_0F = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_0E = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_0D = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_0C = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_0B = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_0A = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_09 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_08 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_07 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_06 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_05 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_04 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_03 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_02 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_01 = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000 ;
    defparam DPRAM9b16d_SQW_0_0_0.INITVAL_00 = 320'h0000000000000000000000000000000000000000203012030120301203011FEFF1FEFF1FEFF1FEFF ;
    defparam DPRAM9b16d_SQW_0_0_0.CSDECODE_B =  3'b000 ;
    defparam DPRAM9b16d_SQW_0_0_0.CSDECODE_A =  3'b000 ;
    defparam DPRAM9b16d_SQW_0_0_0.WRITEMODE_B = "NORMAL" ;
    defparam DPRAM9b16d_SQW_0_0_0.WRITEMODE_A = "NORMAL" ;
    defparam DPRAM9b16d_SQW_0_0_0.GSR = "DISABLED" ;
    defparam DPRAM9b16d_SQW_0_0_0.RESETMODE = "SYNC" ;
    defparam DPRAM9b16d_SQW_0_0_0.REGMODE_B = "OUTREG" ;
    defparam DPRAM9b16d_SQW_0_0_0.REGMODE_A = "OUTREG" ;
    defparam DPRAM9b16d_SQW_0_0_0.DATA_WIDTH_B = 9 ;
    defparam DPRAM9b16d_SQW_0_0_0.DATA_WIDTH_A = 9 ;
    // synopsys translate_on
    DP16KB DPRAM9b16d_SQW_0_0_0 (.DIA0(Data[0]), .DIA1(Data[1]), .DIA2(Data[2]), 
        .DIA3(Data[3]), .DIA4(Data[4]), .DIA5(Data[5]), .DIA6(Data[6]), 
        .DIA7(Data[7]), .DIA8(Data[8]), .DIA9(scuba_vlo), .DIA10(scuba_vlo), 
        .DIA11(scuba_vlo), .DIA12(scuba_vlo), .DIA13(scuba_vlo), .DIA14(scuba_vlo), 
        .DIA15(scuba_vlo), .DIA16(scuba_vlo), .DIA17(scuba_vlo), .ADA0(scuba_vlo), 
        .ADA1(scuba_vlo), .ADA2(scuba_vlo), .ADA3(WrAddress[0]), .ADA4(WrAddress[1]), 
        .ADA5(WrAddress[2]), .ADA6(WrAddress[3]), .ADA7(scuba_vlo), .ADA8(scuba_vlo), 
        .ADA9(scuba_vlo), .ADA10(scuba_vlo), .ADA11(scuba_vlo), .ADA12(scuba_vlo), 
        .ADA13(scuba_vlo), .CEA(WrClockEn), .CLKA(WrClock), .WEA(WE), .CSA0(scuba_vlo), 
        .CSA1(scuba_vlo), .CSA2(scuba_vlo), .RSTA(Reset), .DIB0(scuba_vlo), 
        .DIB1(scuba_vlo), .DIB2(scuba_vlo), .DIB3(scuba_vlo), .DIB4(scuba_vlo), 
        .DIB5(scuba_vlo), .DIB6(scuba_vlo), .DIB7(scuba_vlo), .DIB8(scuba_vlo), 
        .DIB9(scuba_vlo), .DIB10(scuba_vlo), .DIB11(scuba_vlo), .DIB12(scuba_vlo), 
        .DIB13(scuba_vlo), .DIB14(scuba_vlo), .DIB15(scuba_vlo), .DIB16(scuba_vlo), 
        .DIB17(scuba_vlo), .ADB0(scuba_vlo), .ADB1(scuba_vlo), .ADB2(scuba_vlo), 
        .ADB3(RdAddress[0]), .ADB4(RdAddress[1]), .ADB5(RdAddress[2]), .ADB6(RdAddress[3]), 
        .ADB7(scuba_vlo), .ADB8(scuba_vlo), .ADB9(scuba_vlo), .ADB10(scuba_vlo), 
        .ADB11(scuba_vlo), .ADB12(scuba_vlo), .ADB13(scuba_vlo), .CEB(RdClockEn), 
        .CLKB(RdClock), .WEB(scuba_vlo), .CSB0(scuba_vlo), .CSB1(scuba_vlo), 
        .CSB2(scuba_vlo), .RSTB(Reset), .DOA0(), .DOA1(), .DOA2(), .DOA3(), 
        .DOA4(), .DOA5(), .DOA6(), .DOA7(), .DOA8(), .DOA9(), .DOA10(), 
        .DOA11(), .DOA12(), .DOA13(), .DOA14(), .DOA15(), .DOA16(), .DOA17(), 
        .DOB0(Q[0]), .DOB1(Q[1]), .DOB2(Q[2]), .DOB3(Q[3]), .DOB4(Q[4]), 
        .DOB5(Q[5]), .DOB6(Q[6]), .DOB7(Q[7]), .DOB8(Q[8]), .DOB9(), .DOB10(), 
        .DOB11(), .DOB12(), .DOB13(), .DOB14(), .DOB15(), .DOB16(), .DOB17())
             /* synthesis MEM_LPC_FILE="DPRAM9b16d_SQW.lpc" */
             /* synthesis MEM_INIT_FILE="sqwave9b16d.mem" */
             /* synthesis INITVAL_3F="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_3E="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_3D="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_3C="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_3B="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_3A="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_39="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_38="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_37="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_36="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_35="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_34="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_33="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_32="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_31="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_30="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_2F="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_2E="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_2D="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_2C="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_2B="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_2A="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_29="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_28="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_27="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_26="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_25="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_24="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_23="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_22="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_21="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_20="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_1F="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_1E="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_1D="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_1C="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_1B="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_1A="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_19="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_18="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_17="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_16="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_15="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_14="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_13="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_12="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_11="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_10="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_0F="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_0E="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_0D="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_0C="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_0B="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_0A="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_09="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_08="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_07="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_06="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_05="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_04="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_03="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_02="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_01="0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" */
             /* synthesis INITVAL_00="0x0000000000000000000000000000000000000000203012030120301203011FEFF1FEFF1FEFF1FEFF" */
             /* synthesis CSDECODE_B="0b000" */
             /* synthesis CSDECODE_A="0b000" */
             /* synthesis WRITEMODE_B="NORMAL" */
             /* synthesis WRITEMODE_A="NORMAL" */
             /* synthesis GSR="DISABLED" */
             /* synthesis RESETMODE="SYNC" */
             /* synthesis REGMODE_B="OUTREG" */
             /* synthesis REGMODE_A="OUTREG" */
             /* synthesis DATA_WIDTH_B="9" */
             /* synthesis DATA_WIDTH_A="9" */;



    // exemplar begin
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 MEM_LPC_FILE DPRAM9b16d_SQW.lpc
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 MEM_INIT_FILE sqwave9b16d.mem
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_3F 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_3E 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_3D 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_3C 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_3B 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_3A 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_39 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_38 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_37 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_36 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_35 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_34 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_33 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_32 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_31 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_30 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_2F 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_2E 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_2D 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_2C 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_2B 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_2A 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_29 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_28 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_27 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_26 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_25 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_24 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_23 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_22 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_21 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_20 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_1F 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_1E 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_1D 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_1C 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_1B 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_1A 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_19 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_18 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_17 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_16 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_15 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_14 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_13 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_12 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_11 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_10 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_0F 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_0E 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_0D 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_0C 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_0B 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_0A 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_09 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_08 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_07 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_06 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_05 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_04 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_03 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_02 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_01 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 INITVAL_00 0x0000000000000000000000000000000000000000203012030120301203011FEFF1FEFF1FEFF1FEFF
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 CSDECODE_B 0b000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 CSDECODE_A 0b000
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 WRITEMODE_B NORMAL
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 WRITEMODE_A NORMAL
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 GSR DISABLED
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 RESETMODE SYNC
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 REGMODE_B OUTREG
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 REGMODE_A OUTREG
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 DATA_WIDTH_B 9
    // exemplar attribute DPRAM9b16d_SQW_0_0_0 DATA_WIDTH_A 9
    // exemplar end

endmodule
