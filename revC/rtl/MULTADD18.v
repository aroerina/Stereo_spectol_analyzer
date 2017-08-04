/* Verilog netlist generated by SCUBA Diamond_1.2_Production (92) */
/* Module Version: 4.0 */
/* D:\lscc\diamond\1.2\ispfpga\bin\nt\scuba.exe -w -n MULTADD18 -lang verilog -synth synplify -bus_exp 7 -bb -arch mg5a00 -type dspmadd -widtha 18 -widthb 18 -widthsum 37 -gsr ENABLED -area -madd -signed -regsa1 -regsa1clk CLK0 -regsa1rst RST0 -regsb1 -regsb1clk CLK0 -regsb1rst RST0 -regp0 -regp0clk CLK0 -regp0rst RST0 -regp1 -regp1clk CLK0 -regp1rst RST0 -rego -regoclk CLK0 -regorst RST0 -clk0 -rst0 -e  */
/* Sun Jun 19 03:05:23 2011 */


`timescale 1 ns / 1 ps
module MULTADD18 (CLK0, RST0, A0, A1, B0, B1, SUM);
    input wire CLK0;
    input wire RST0;
    input wire [17:0] A0;
    input wire [17:0] A1;
    input wire [17:0] B0;
    input wire [17:0] B1;
    output wire [36:0] SUM;

    wire scuba_vhi;
    wire scuba_vlo;

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    // synopsys translate_off
    defparam dsp_0.GSR = "ENABLED" ;
    defparam dsp_0.REG_ADDNSUB_1_RST = "RST0" ;
    defparam dsp_0.REG_ADDNSUB_1_CE = "CE0" ;
    defparam dsp_0.REG_ADDNSUB_1_CLK = "NONE" ;
    defparam dsp_0.REG_ADDNSUB_0_RST = "RST0" ;
    defparam dsp_0.REG_ADDNSUB_0_CE = "CE0" ;
    defparam dsp_0.REG_ADDNSUB_0_CLK = "NONE" ;
    defparam dsp_0.REG_SIGNEDB_1_RST = "RST0" ;
    defparam dsp_0.REG_SIGNEDB_1_CE = "CE0" ;
    defparam dsp_0.REG_SIGNEDB_1_CLK = "CLK0" ;
    defparam dsp_0.REG_SIGNEDA_1_RST = "RST0" ;
    defparam dsp_0.REG_SIGNEDA_1_CE = "CE0" ;
    defparam dsp_0.REG_SIGNEDA_1_CLK = "CLK0" ;
    defparam dsp_0.REG_SIGNEDB_0_RST = "RST0" ;
    defparam dsp_0.REG_SIGNEDB_0_CE = "CE0" ;
    defparam dsp_0.REG_SIGNEDB_0_CLK = "NONE" ;
    defparam dsp_0.REG_SIGNEDA_0_RST = "RST0" ;
    defparam dsp_0.REG_SIGNEDA_0_CE = "CE0" ;
    defparam dsp_0.REG_SIGNEDA_0_CLK = "NONE" ;
    defparam dsp_0.REG_OUTPUT_RST = "RST0" ;
    defparam dsp_0.REG_OUTPUT_CE = "CE0" ;
    defparam dsp_0.REG_OUTPUT_CLK = "CLK0" ;
    defparam dsp_0.REG_PIPELINE1_RST = "RST0" ;
    defparam dsp_0.REG_PIPELINE1_CE = "CE0" ;
    defparam dsp_0.REG_PIPELINE1_CLK = "CLK0" ;
    defparam dsp_0.REG_PIPELINE0_RST = "RST0" ;
    defparam dsp_0.REG_PIPELINE0_CE = "CE0" ;
    defparam dsp_0.REG_PIPELINE0_CLK = "CLK0" ;
    defparam dsp_0.REG_INPUTB1_RST = "RST0" ;
    defparam dsp_0.REG_INPUTB1_CE = "CE0" ;
    defparam dsp_0.REG_INPUTB1_CLK = "NONE" ;
    defparam dsp_0.REG_INPUTA1_RST = "RST0" ;
    defparam dsp_0.REG_INPUTA1_CE = "CE0" ;
    defparam dsp_0.REG_INPUTA1_CLK = "NONE" ;
    defparam dsp_0.REG_INPUTB0_RST = "RST0" ;
    defparam dsp_0.REG_INPUTB0_CE = "CE0" ;
    defparam dsp_0.REG_INPUTB0_CLK = "NONE" ;
    defparam dsp_0.REG_INPUTA0_RST = "RST0" ;
    defparam dsp_0.REG_INPUTA0_CE = "CE0" ;
    defparam dsp_0.REG_INPUTA0_CLK = "NONE" ;
    // synopsys translate_on
    MULT18X18ADDSUBB dsp_0 (.A017(A0[17]), .A016(A0[16]), .A015(A0[15]), 
        .A014(A0[14]), .A013(A0[13]), .A012(A0[12]), .A011(A0[11]), .A010(A0[10]), 
        .A09(A0[9]), .A08(A0[8]), .A07(A0[7]), .A06(A0[6]), .A05(A0[5]), 
        .A04(A0[4]), .A03(A0[3]), .A02(A0[2]), .A01(A0[1]), .A00(A0[0]), 
        .A117(A1[17]), .A116(A1[16]), .A115(A1[15]), .A114(A1[14]), .A113(A1[13]), 
        .A112(A1[12]), .A111(A1[11]), .A110(A1[10]), .A19(A1[9]), .A18(A1[8]), 
        .A17(A1[7]), .A16(A1[6]), .A15(A1[5]), .A14(A1[4]), .A13(A1[3]), 
        .A12(A1[2]), .A11(A1[1]), .A10(A1[0]), .B017(B0[17]), .B016(B0[16]), 
        .B015(B0[15]), .B014(B0[14]), .B013(B0[13]), .B012(B0[12]), .B011(B0[11]), 
        .B010(B0[10]), .B09(B0[9]), .B08(B0[8]), .B07(B0[7]), .B06(B0[6]), 
        .B05(B0[5]), .B04(B0[4]), .B03(B0[3]), .B02(B0[2]), .B01(B0[1]), 
        .B00(B0[0]), .B117(B1[17]), .B116(B1[16]), .B115(B1[15]), .B114(B1[14]), 
        .B113(B1[13]), .B112(B1[12]), .B111(B1[11]), .B110(B1[10]), .B19(B1[9]), 
        .B18(B1[8]), .B17(B1[7]), .B16(B1[6]), .B15(B1[5]), .B14(B1[4]), 
        .B13(B1[3]), .B12(B1[2]), .B11(B1[1]), .B10(B1[0]), .SIGNEDA(scuba_vhi), 
        .SIGNEDB(scuba_vhi), .ADDNSUB(scuba_vhi), .SOURCEA0(scuba_vlo), 
        .SOURCEA1(scuba_vlo), .SOURCEB0(scuba_vlo), .SOURCEB1(scuba_vlo), 
        .CE0(scuba_vhi), .CE1(scuba_vhi), .CE2(scuba_vhi), .CE3(scuba_vhi), 
        .CLK0(CLK0), .CLK1(scuba_vlo), .CLK2(scuba_vlo), .CLK3(scuba_vlo), 
        .RST0(RST0), .RST1(scuba_vlo), .RST2(scuba_vlo), .RST3(scuba_vlo), 
        .SRIA17(scuba_vlo), .SRIA16(scuba_vlo), .SRIA15(scuba_vlo), .SRIA14(scuba_vlo), 
        .SRIA13(scuba_vlo), .SRIA12(scuba_vlo), .SRIA11(scuba_vlo), .SRIA10(scuba_vlo), 
        .SRIA9(scuba_vlo), .SRIA8(scuba_vlo), .SRIA7(scuba_vlo), .SRIA6(scuba_vlo), 
        .SRIA5(scuba_vlo), .SRIA4(scuba_vlo), .SRIA3(scuba_vlo), .SRIA2(scuba_vlo), 
        .SRIA1(scuba_vlo), .SRIA0(scuba_vlo), .SRIB17(scuba_vlo), .SRIB16(scuba_vlo), 
        .SRIB15(scuba_vlo), .SRIB14(scuba_vlo), .SRIB13(scuba_vlo), .SRIB12(scuba_vlo), 
        .SRIB11(scuba_vlo), .SRIB10(scuba_vlo), .SRIB9(scuba_vlo), .SRIB8(scuba_vlo), 
        .SRIB7(scuba_vlo), .SRIB6(scuba_vlo), .SRIB5(scuba_vlo), .SRIB4(scuba_vlo), 
        .SRIB3(scuba_vlo), .SRIB2(scuba_vlo), .SRIB1(scuba_vlo), .SRIB0(scuba_vlo), 
        .SROA17(), .SROA16(), .SROA15(), .SROA14(), .SROA13(), .SROA12(), 
        .SROA11(), .SROA10(), .SROA9(), .SROA8(), .SROA7(), .SROA6(), .SROA5(), 
        .SROA4(), .SROA3(), .SROA2(), .SROA1(), .SROA0(), .SROB17(), .SROB16(), 
        .SROB15(), .SROB14(), .SROB13(), .SROB12(), .SROB11(), .SROB10(), 
        .SROB9(), .SROB8(), .SROB7(), .SROB6(), .SROB5(), .SROB4(), .SROB3(), 
        .SROB2(), .SROB1(), .SROB0(), .SUM36(SUM[36]), .SUM35(SUM[35]), 
        .SUM34(SUM[34]), .SUM33(SUM[33]), .SUM32(SUM[32]), .SUM31(SUM[31]), 
        .SUM30(SUM[30]), .SUM29(SUM[29]), .SUM28(SUM[28]), .SUM27(SUM[27]), 
        .SUM26(SUM[26]), .SUM25(SUM[25]), .SUM24(SUM[24]), .SUM23(SUM[23]), 
        .SUM22(SUM[22]), .SUM21(SUM[21]), .SUM20(SUM[20]), .SUM19(SUM[19]), 
        .SUM18(SUM[18]), .SUM17(SUM[17]), .SUM16(SUM[16]), .SUM15(SUM[15]), 
        .SUM14(SUM[14]), .SUM13(SUM[13]), .SUM12(SUM[12]), .SUM11(SUM[11]), 
        .SUM10(SUM[10]), .SUM9(SUM[9]), .SUM8(SUM[8]), .SUM7(SUM[7]), .SUM6(SUM[6]), 
        .SUM5(SUM[5]), .SUM4(SUM[4]), .SUM3(SUM[3]), .SUM2(SUM[2]), .SUM1(SUM[1]), 
        .SUM0(SUM[0]))
             /* synthesis GSR="ENABLED" */
             /* synthesis REG_ADDNSUB_1_RST="RST0" */
             /* synthesis REG_ADDNSUB_1_CE="CE0" */
             /* synthesis REG_ADDNSUB_1_CLK="NONE" */
             /* synthesis REG_ADDNSUB_0_RST="RST0" */
             /* synthesis REG_ADDNSUB_0_CE="CE0" */
             /* synthesis REG_ADDNSUB_0_CLK="NONE" */
             /* synthesis REG_SIGNEDB_1_RST="RST0" */
             /* synthesis REG_SIGNEDB_1_CE="CE0" */
             /* synthesis REG_SIGNEDB_1_CLK="CLK0" */
             /* synthesis REG_SIGNEDA_1_RST="RST0" */
             /* synthesis REG_SIGNEDA_1_CE="CE0" */
             /* synthesis REG_SIGNEDA_1_CLK="CLK0" */
             /* synthesis REG_SIGNEDB_0_RST="RST0" */
             /* synthesis REG_SIGNEDB_0_CE="CE0" */
             /* synthesis REG_SIGNEDB_0_CLK="NONE" */
             /* synthesis REG_SIGNEDA_0_RST="RST0" */
             /* synthesis REG_SIGNEDA_0_CE="CE0" */
             /* synthesis REG_SIGNEDA_0_CLK="NONE" */
             /* synthesis REG_OUTPUT_RST="RST0" */
             /* synthesis REG_OUTPUT_CE="CE0" */
             /* synthesis REG_OUTPUT_CLK="CLK0" */
             /* synthesis REG_PIPELINE1_RST="RST0" */
             /* synthesis REG_PIPELINE1_CE="CE0" */
             /* synthesis REG_PIPELINE1_CLK="CLK0" */
             /* synthesis REG_PIPELINE0_RST="RST0" */
             /* synthesis REG_PIPELINE0_CE="CE0" */
             /* synthesis REG_PIPELINE0_CLK="CLK0" */
             /* synthesis REG_INPUTB1_RST="RST0" */
             /* synthesis REG_INPUTB1_CE="CE0" */
             /* synthesis REG_INPUTB1_CLK="NONE" */
             /* synthesis REG_INPUTA1_RST="RST0" */
             /* synthesis REG_INPUTA1_CE="CE0" */
             /* synthesis REG_INPUTA1_CLK="NONE" */
             /* synthesis REG_INPUTB0_RST="RST0" */
             /* synthesis REG_INPUTB0_CE="CE0" */
             /* synthesis REG_INPUTB0_CLK="NONE" */
             /* synthesis REG_INPUTA0_RST="RST0" */
             /* synthesis REG_INPUTA0_CE="CE0" */
             /* synthesis REG_INPUTA0_CLK="NONE" */;



    // exemplar begin
    // exemplar attribute dsp_0 GSR ENABLED
    // exemplar attribute dsp_0 REG_ADDNSUB_1_RST RST0
    // exemplar attribute dsp_0 REG_ADDNSUB_1_CE CE0
    // exemplar attribute dsp_0 REG_ADDNSUB_1_CLK NONE
    // exemplar attribute dsp_0 REG_ADDNSUB_0_RST RST0
    // exemplar attribute dsp_0 REG_ADDNSUB_0_CE CE0
    // exemplar attribute dsp_0 REG_ADDNSUB_0_CLK NONE
    // exemplar attribute dsp_0 REG_SIGNEDB_1_RST RST0
    // exemplar attribute dsp_0 REG_SIGNEDB_1_CE CE0
    // exemplar attribute dsp_0 REG_SIGNEDB_1_CLK CLK0
    // exemplar attribute dsp_0 REG_SIGNEDA_1_RST RST0
    // exemplar attribute dsp_0 REG_SIGNEDA_1_CE CE0
    // exemplar attribute dsp_0 REG_SIGNEDA_1_CLK CLK0
    // exemplar attribute dsp_0 REG_SIGNEDB_0_RST RST0
    // exemplar attribute dsp_0 REG_SIGNEDB_0_CE CE0
    // exemplar attribute dsp_0 REG_SIGNEDB_0_CLK NONE
    // exemplar attribute dsp_0 REG_SIGNEDA_0_RST RST0
    // exemplar attribute dsp_0 REG_SIGNEDA_0_CE CE0
    // exemplar attribute dsp_0 REG_SIGNEDA_0_CLK NONE
    // exemplar attribute dsp_0 REG_OUTPUT_RST RST0
    // exemplar attribute dsp_0 REG_OUTPUT_CE CE0
    // exemplar attribute dsp_0 REG_OUTPUT_CLK CLK0
    // exemplar attribute dsp_0 REG_PIPELINE1_RST RST0
    // exemplar attribute dsp_0 REG_PIPELINE1_CE CE0
    // exemplar attribute dsp_0 REG_PIPELINE1_CLK CLK0
    // exemplar attribute dsp_0 REG_PIPELINE0_RST RST0
    // exemplar attribute dsp_0 REG_PIPELINE0_CE CE0
    // exemplar attribute dsp_0 REG_PIPELINE0_CLK CLK0
    // exemplar attribute dsp_0 REG_INPUTB1_RST RST0
    // exemplar attribute dsp_0 REG_INPUTB1_CE CE0
    // exemplar attribute dsp_0 REG_INPUTB1_CLK NONE
    // exemplar attribute dsp_0 REG_INPUTA1_RST RST0
    // exemplar attribute dsp_0 REG_INPUTA1_CE CE0
    // exemplar attribute dsp_0 REG_INPUTA1_CLK NONE
    // exemplar attribute dsp_0 REG_INPUTB0_RST RST0
    // exemplar attribute dsp_0 REG_INPUTB0_CE CE0
    // exemplar attribute dsp_0 REG_INPUTB0_CLK NONE
    // exemplar attribute dsp_0 REG_INPUTA0_RST RST0
    // exemplar attribute dsp_0 REG_INPUTA0_CE CE0
    // exemplar attribute dsp_0 REG_INPUTA0_CLK NONE
    // exemplar end

endmodule
