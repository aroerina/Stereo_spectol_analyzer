/* Verilog netlist generated by SCUBA Diamond_1.2_Production (92) */
/* Module Version: 2.4 */
/* C:\lscc\diamond\1.2\ispfpga\bin\nt\scuba.exe -w -lang verilog -synth synplify -bus_exp 7 -bb -arch mg5a00 -type rom -addr_width 2 -num_rows 4 -data_width 14 -outdata REGISTERED -memfile c:/dev/source/rb/rom_make/hannig_window/diff_quaternegativecosine16.mem -memformat hex -e  */
/* Sat Aug 06 15:13:18 2011 */


`timescale 1 ns / 1 ps
module DISTROM_DIFFNCOS16 (Address, OutClock, OutClockEn, Reset, Q);
    input wire [1:0] Address;
    input wire OutClock;
    input wire OutClockEn;
    input wire Reset;
    output wire [13:0] Q;

    wire qdataout13_ffin;
    wire qdataout12_ffin;
    wire qdataout11_ffin;
    wire qdataout10_ffin;
    wire qdataout9_ffin;
    wire qdataout8_ffin;
    wire qdataout7_ffin;
    wire qdataout6_ffin;
    wire qdataout5_ffin;
    wire qdataout4_ffin;
    wire qdataout3_ffin;
    wire qdataout2_ffin;
    wire qdataout1_ffin;
    wire qdataout0_ffin;
    wire scuba_vlo;

    // synopsys translate_off
    defparam FF_13.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_13 (.D(qdataout13_ffin), .SP(OutClockEn), .CK(OutClock), 
        .CD(Reset), .Q(Q[13]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_12.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_12 (.D(qdataout12_ffin), .SP(OutClockEn), .CK(OutClock), 
        .CD(Reset), .Q(Q[12]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_11.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_11 (.D(qdataout11_ffin), .SP(OutClockEn), .CK(OutClock), 
        .CD(Reset), .Q(Q[11]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_10.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_10 (.D(qdataout10_ffin), .SP(OutClockEn), .CK(OutClock), 
        .CD(Reset), .Q(Q[10]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_9.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_9 (.D(qdataout9_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[9]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_8.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_8 (.D(qdataout8_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[8]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_7.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_7 (.D(qdataout7_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[7]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_6.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_6 (.D(qdataout6_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[6]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_5.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_5 (.D(qdataout5_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[5]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_4.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_4 (.D(qdataout4_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[4]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_3.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_3 (.D(qdataout3_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[3]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_2.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_2 (.D(qdataout2_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[2]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_1.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_1 (.D(qdataout1_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[1]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam FF_0.GSR = "ENABLED" ;
    // synopsys translate_on
    FD1P3DX FF_0 (.D(qdataout0_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[0]))
             /* synthesis GSR="ENABLED" */;

    // synopsys translate_off
    defparam mem_0_13.initval =  16'h000C ;
    // synopsys translate_on
    ROM16X1 mem_0_13 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout13_ffin))
             /* synthesis initval="0x000C" */;

    // synopsys translate_off
    defparam mem_0_12.initval =  16'h000A ;
    // synopsys translate_on
    ROM16X1 mem_0_12 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout12_ffin))
             /* synthesis initval="0x000A" */;

    // synopsys translate_off
    defparam mem_0_11.initval =  16'h0007 ;
    // synopsys translate_on
    ROM16X1 mem_0_11 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout11_ffin))
             /* synthesis initval="0x0007" */;

    // synopsys translate_off
    defparam mem_0_10.initval =  16'h0000 ;
    // synopsys translate_on
    ROM16X1 mem_0_10 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout10_ffin))
             /* synthesis initval="0x0000" */;

    // synopsys translate_off
    defparam mem_0_9.initval =  16'h0002 ;
    // synopsys translate_on
    ROM16X1 mem_0_9 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout9_ffin))
             /* synthesis initval="0x0002" */;

    // synopsys translate_off
    defparam mem_0_8.initval =  16'h0007 ;
    // synopsys translate_on
    ROM16X1 mem_0_8 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout8_ffin))
             /* synthesis initval="0x0007" */;

    // synopsys translate_off
    defparam mem_0_7.initval =  16'h000F ;
    // synopsys translate_on
    ROM16X1 mem_0_7 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout7_ffin))
             /* synthesis initval="0x000F" */;

    // synopsys translate_off
    defparam mem_0_6.initval =  16'h000A ;
    // synopsys translate_on
    ROM16X1 mem_0_6 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout6_ffin))
             /* synthesis initval="0x000A" */;

    // synopsys translate_off
    defparam mem_0_5.initval =  16'h0009 ;
    // synopsys translate_on
    ROM16X1 mem_0_5 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout5_ffin))
             /* synthesis initval="0x0009" */;

    // synopsys translate_off
    defparam mem_0_4.initval =  16'h0009 ;
    // synopsys translate_on
    ROM16X1 mem_0_4 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout4_ffin))
             /* synthesis initval="0x0009" */;

    // synopsys translate_off
    defparam mem_0_3.initval =  16'h0009 ;
    // synopsys translate_on
    ROM16X1 mem_0_3 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout3_ffin))
             /* synthesis initval="0x0009" */;

    // synopsys translate_off
    defparam mem_0_2.initval =  16'h000D ;
    // synopsys translate_on
    ROM16X1 mem_0_2 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout2_ffin))
             /* synthesis initval="0x000D" */;

    // synopsys translate_off
    defparam mem_0_1.initval =  16'h0005 ;
    // synopsys translate_on
    ROM16X1 mem_0_1 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout1_ffin))
             /* synthesis initval="0x0005" */;

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    // synopsys translate_off
    defparam mem_0_0.initval =  16'h0000 ;
    // synopsys translate_on
    ROM16X1 mem_0_0 (.AD3(scuba_vlo), .AD2(scuba_vlo), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(qdataout0_ffin))
             /* synthesis initval="0x0000" */;



    // exemplar begin
    // exemplar attribute FF_13 GSR ENABLED
    // exemplar attribute FF_12 GSR ENABLED
    // exemplar attribute FF_11 GSR ENABLED
    // exemplar attribute FF_10 GSR ENABLED
    // exemplar attribute FF_9 GSR ENABLED
    // exemplar attribute FF_8 GSR ENABLED
    // exemplar attribute FF_7 GSR ENABLED
    // exemplar attribute FF_6 GSR ENABLED
    // exemplar attribute FF_5 GSR ENABLED
    // exemplar attribute FF_4 GSR ENABLED
    // exemplar attribute FF_3 GSR ENABLED
    // exemplar attribute FF_2 GSR ENABLED
    // exemplar attribute FF_1 GSR ENABLED
    // exemplar attribute FF_0 GSR ENABLED
    // exemplar attribute mem_0_13 initval 0x000C
    // exemplar attribute mem_0_12 initval 0x000A
    // exemplar attribute mem_0_11 initval 0x0007
    // exemplar attribute mem_0_10 initval 0x0000
    // exemplar attribute mem_0_9 initval 0x0002
    // exemplar attribute mem_0_8 initval 0x0007
    // exemplar attribute mem_0_7 initval 0x000F
    // exemplar attribute mem_0_6 initval 0x000A
    // exemplar attribute mem_0_5 initval 0x0009
    // exemplar attribute mem_0_4 initval 0x0009
    // exemplar attribute mem_0_3 initval 0x0009
    // exemplar attribute mem_0_2 initval 0x000D
    // exemplar attribute mem_0_1 initval 0x0005
    // exemplar attribute mem_0_0 initval 0x0000
    // exemplar end

endmodule
