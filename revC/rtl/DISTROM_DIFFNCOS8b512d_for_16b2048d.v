/* Verilog netlist generated by SCUBA Diamond_1.2_Production (92) */
/* Module Version: 2.4 */
/* D:\lscc\diamond\1.2\ispfpga\bin\nt\scuba.exe -w -lang verilog -synth synplify -bus_exp 7 -bb -arch mg5a00 -type rom -addr_width 9 -num_rows 512 -data_width 8 -outdata REGISTERED -memfile c:/dev/source/hdl/fpgaproject/ipex/diff_quaternegativecosine17b512d.mem -memformat hex -e  */
/* Mon Aug 22 19:49:03 2011 */


`timescale 1 ns / 1 ps
module DISTROM_DIFFNCOS8b512d_for_16b2048d (Address, OutClock, 
    OutClockEn, Reset, Q);
    input wire [8:0] Address;
    input wire OutClock;
    input wire OutClockEn;
    input wire Reset;
    output wire [7:0] Q;

    wire qdataout7_ffin;
    wire mdL0_0_1;
    wire mdL0_0_0;
    wire qdataout6_ffin;
    wire mdL0_1_1;
    wire mdL0_1_0;
    wire qdataout5_ffin;
    wire mdL0_2_1;
    wire mdL0_2_0;
    wire qdataout4_ffin;
    wire mdL0_3_1;
    wire mdL0_3_0;
    wire qdataout3_ffin;
    wire mdL0_4_1;
    wire mdL0_4_0;
    wire qdataout2_ffin;
    wire mdL0_5_1;
    wire mdL0_5_0;
    wire qdataout1_ffin;
    wire mdL0_6_1;
    wire mdL0_6_0;
    wire qdataout0_ffin;
    wire mdL0_7_1;
    wire mdL0_7_0;

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
    defparam mem_0_7.initval = 256'hFFFFFFFF00000000000000000000000000000000000000000000000000000000 ;
    // synopsys translate_on
    ROM256X1 mem_0_7 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_0_0))
             /* synthesis initval="0xFFFFFFFF00000000000000000000000000000000000000000000000000000000" */;

    // synopsys translate_off
    defparam mem_0_6.initval = 256'h00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFE00000000000000000000000000 ;
    // synopsys translate_on
    ROM256X1 mem_0_6 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_1_0))
             /* synthesis initval="0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFE00000000000000000000000000" */;

    // synopsys translate_off
    defparam mem_0_5.initval = 256'h00000000FFFFFFFFFFFFFFFE00000000000001FFFFFFFFFFFFF0000000000000 ;
    // synopsys translate_on
    ROM256X1 mem_0_5 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_2_0))
             /* synthesis initval="0x00000000FFFFFFFFFFFFFFFE00000000000001FFFFFFFFFFFFF0000000000000" */;

    // synopsys translate_off
    defparam mem_0_4.initval = 256'h00000000FFFFFFFF80000001FFFFFFE0000001FFFFFFA000000FFFFFFC000000 ;
    // synopsys translate_on
    ROM256X1 mem_0_4 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_3_0))
             /* synthesis initval="0x00000000FFFFFFFF80000001FFFFFFE0000001FFFFFFA000000FFFFFFC000000" */;

    // synopsys translate_off
    defparam mem_0_3.initval = 256'hFFFE0000FFFF80007FFF0001FFF4001FFF8001FFF4005FFF000FFFC003FFF000 ;
    // synopsys translate_on
    ROM256X1 mem_0_3 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_4_0))
             /* synthesis initval="0xFFFE0000FFFF80007FFF0001FFF4001FFF8001FFF4005FFF000FFFC003FFF000" */;

    // synopsys translate_off
    defparam mem_0_2.initval = 256'hFC01FE80FF807F807F80FE01FA0BF81FE07F01FC0BF05F40FC0FF03F83F80FC0 ;
    // synopsys translate_on
    ROM256X1 mem_0_2 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_5_0))
             /* synthesis initval="0xFC01FE80FF807F807F80FE01FA0BF81FE07F01FC0BF05F40FC0FF03F83F80FC0" */;

    // synopsys translate_off
    defparam mem_0_1.initval = 256'h83C1E170E87078787068E1E1C5CB871E1C78E1E3CB0E58B0E3CF0C3863C78E3C ;
    // synopsys translate_on
    ROM256X1 mem_0_1 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_6_0))
             /* synthesis initval="0x83C1E170E87078787068E1E1C5CB871E1C78E1E3CB0E58B0E3CF0C3863C78E3C" */;

    // synopsys translate_off
    defparam mem_0_0.initval = 256'h73B99D0CF42E44444C30DD993C3A44B99366FD9318C9D78C932E8B345FB649B2 ;
    // synopsys translate_on
    ROM256X1 mem_0_0 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_7_0))
             /* synthesis initval="0x73B99D0CF42E44444C30DD993C3A44B99366FD9318C9D78C932E8B345FB649B2" */;

    // synopsys translate_off
    defparam mem_1_7.initval = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ;
    // synopsys translate_on
    ROM256X1 mem_1_7 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_0_1))
             /* synthesis initval="0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" */;

    // synopsys translate_off
    defparam mem_1_6.initval = 256'hFFFFFFFFFFFFFFFFFFFFFFFFD800000000000000000000000000000000000000 ;
    // synopsys translate_on
    ROM256X1 mem_1_6 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_1_1))
             /* synthesis initval="0xFFFFFFFFFFFFFFFFFFFFFFFFD800000000000000000000000000000000000000" */;

    // synopsys translate_off
    defparam mem_1_5.initval = 256'h00000000000000000000000027FFFFFFFFFFFFFFFFFFFFFFFFFFF80000000000 ;
    // synopsys translate_on
    ROM256X1 mem_1_5 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_2_1))
             /* synthesis initval="0x00000000000000000000000027FFFFFFFFFFFFFFFFFFFFFFFFFFF80000000000" */;

    // synopsys translate_off
    defparam mem_1_4.initval = 256'h00000000000000000000000027FFFFFFFFFFFFFFFD000000000007FFFFFFFFF4 ;
    // synopsys translate_on
    ROM256X1 mem_1_4 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_3_1))
             /* synthesis initval="0x00000000000000000000000027FFFFFFFFFFFFFFFD000000000007FFFFFFFFF4" */;

    // synopsys translate_off
    defparam mem_1_3.initval = 256'hFFFFFFFFF6A000000000000027FFFFFFFF80000002FFFFFE000007FFFFC0000B ;
    // synopsys translate_on
    ROM256X1 mem_1_3 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_4_1))
             /* synthesis initval="0xFFFFFFFFF6A000000000000027FFFFFFFF80000002FFFFFE000007FFFFC0000B" */;

    // synopsys translate_off
    defparam mem_1_2.initval = 256'h00000000095FFFFFFFF4000027FFFF80007FFF0002FFD001FFE007FF003FF00B ;
    // synopsys translate_on
    ROM256X1 mem_1_2 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_5_1))
             /* synthesis initval="0x00000000095FFFFFFFF4000027FFFF80007FFF0002FFD001FFE007FF003FF00B" */;

    // synopsys translate_off
    defparam mem_1_1.initval = 256'h00000000095FFFF4800BFFC027FA807F407F80FE82F42F41F41F07E0F83C0F0B ;
    // synopsys translate_on
    ROM256X1 mem_1_1 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_6_1))
             /* synthesis initval="0x00000000095FFFF4800BFFC027FA807F407F80FE82F42F41F41F07E0F83C0F0B" */;

    // synopsys translate_off
    defparam mem_1_0.initval = 256'hFFFFB692095FD40B5A0BD03E67D55074B47878F1424AAAA9CA18E718C6378CEA ;
    // synopsys translate_on
    ROM256X1 mem_1_0 (.AD7(Address[7]), .AD6(Address[6]), .AD5(Address[5]), 
        .AD4(Address[4]), .AD3(Address[3]), .AD2(Address[2]), .AD1(Address[1]), 
        .AD0(Address[0]), .DO0(mdL0_7_1))
             /* synthesis initval="0xFFFFB692095FD40B5A0BD03E67D55074B47878F1424AAAA9CA18E718C6378CEA" */;

    MUX21 mux_7 (.D0(mdL0_0_0), .D1(mdL0_0_1), .SD(Address[8]), .Z(qdataout7_ffin));

    MUX21 mux_6 (.D0(mdL0_1_0), .D1(mdL0_1_1), .SD(Address[8]), .Z(qdataout6_ffin));

    MUX21 mux_5 (.D0(mdL0_2_0), .D1(mdL0_2_1), .SD(Address[8]), .Z(qdataout5_ffin));

    MUX21 mux_4 (.D0(mdL0_3_0), .D1(mdL0_3_1), .SD(Address[8]), .Z(qdataout4_ffin));

    MUX21 mux_3 (.D0(mdL0_4_0), .D1(mdL0_4_1), .SD(Address[8]), .Z(qdataout3_ffin));

    MUX21 mux_2 (.D0(mdL0_5_0), .D1(mdL0_5_1), .SD(Address[8]), .Z(qdataout2_ffin));

    MUX21 mux_1 (.D0(mdL0_6_0), .D1(mdL0_6_1), .SD(Address[8]), .Z(qdataout1_ffin));

    MUX21 mux_0 (.D0(mdL0_7_0), .D1(mdL0_7_1), .SD(Address[8]), .Z(qdataout0_ffin));



    // exemplar begin
    // exemplar attribute FF_7 GSR ENABLED
    // exemplar attribute FF_6 GSR ENABLED
    // exemplar attribute FF_5 GSR ENABLED
    // exemplar attribute FF_4 GSR ENABLED
    // exemplar attribute FF_3 GSR ENABLED
    // exemplar attribute FF_2 GSR ENABLED
    // exemplar attribute FF_1 GSR ENABLED
    // exemplar attribute FF_0 GSR ENABLED
    // exemplar attribute mem_0_7 initval 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
    // exemplar attribute mem_0_6 initval 0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFE00000000000000000000000000
    // exemplar attribute mem_0_5 initval 0x00000000FFFFFFFFFFFFFFFE00000000000001FFFFFFFFFFFFF0000000000000
    // exemplar attribute mem_0_4 initval 0x00000000FFFFFFFF80000001FFFFFFE0000001FFFFFFA000000FFFFFFC000000
    // exemplar attribute mem_0_3 initval 0xFFFE0000FFFF80007FFF0001FFF4001FFF8001FFF4005FFF000FFFC003FFF000
    // exemplar attribute mem_0_2 initval 0xFC01FE80FF807F807F80FE01FA0BF81FE07F01FC0BF05F40FC0FF03F83F80FC0
    // exemplar attribute mem_0_1 initval 0x83C1E170E87078787068E1E1C5CB871E1C78E1E3CB0E58B0E3CF0C3863C78E3C
    // exemplar attribute mem_0_0 initval 0x73B99D0CF42E44444C30DD993C3A44B99366FD9318C9D78C932E8B345FB649B2
    // exemplar attribute mem_1_7 initval 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    // exemplar attribute mem_1_6 initval 0xFFFFFFFFFFFFFFFFFFFFFFFFD800000000000000000000000000000000000000
    // exemplar attribute mem_1_5 initval 0x00000000000000000000000027FFFFFFFFFFFFFFFFFFFFFFFFFFF80000000000
    // exemplar attribute mem_1_4 initval 0x00000000000000000000000027FFFFFFFFFFFFFFFD000000000007FFFFFFFFF4
    // exemplar attribute mem_1_3 initval 0xFFFFFFFFF6A000000000000027FFFFFFFF80000002FFFFFE000007FFFFC0000B
    // exemplar attribute mem_1_2 initval 0x00000000095FFFFFFFF4000027FFFF80007FFF0002FFD001FFE007FF003FF00B
    // exemplar attribute mem_1_1 initval 0x00000000095FFFF4800BFFC027FA807F407F80FE82F42F41F41F07E0F83C0F0B
    // exemplar attribute mem_1_0 initval 0xFFFFB692095FD40B5A0BD03E67D55074B47878F1424AAAA9CA18E718C6378CEA
    // exemplar end

endmodule
