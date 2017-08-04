/* Verilog netlist generated by SCUBA Diamond_1.2_Production (92) */
/* Module Version: 7.1 */
/* C:\lscc\diamond\1.2\ispfpga\bin\nt\scuba.exe -w -lang verilog -synth synplify -bus_exp 7 -bb -arch mg5a00 -type bram -wp 11 -rp 1010 -data_width 17 -rdata_width 17 -num_rows 1024 -outdataA REGISTERED -outdataB REGISTERED -writemodeA NORMAL -writemodeB NORMAL -resetmode SYNC -memfile c:/dev/source/rb/quoternegsine_17b1024d.mem_1024d17b.mem -memformat hex -cascade -1 -e  */
/* Wed Nov 30 18:02:17 2011 */


`timescale 1 ns / 1 ps
module TDPRAM_NSINE17b1024d (DataInA, DataInB, AddressA, AddressB, 
    ClockA, ClockB, ClockEnA, ClockEnB, WrA, WrB, ResetA, ResetB, QA, QB);
    input wire [16:0] DataInA;
    input wire [16:0] DataInB;
    input wire [9:0] AddressA;
    input wire [9:0] AddressB;
    input wire ClockA;
    input wire ClockB;
    input wire ClockEnA;
    input wire ClockEnB;
    input wire WrA;
    input wire WrB;
    input wire ResetA;
    input wire ResetB;
    output wire [16:0] QA;
    output wire [16:0] QB;

    wire scuba_vhi;
    wire scuba_vlo;

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    // synopsys translate_off
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_3F = 320'h10000100001000110001100021000310004100051000610008100091000B1000D1000F1001110014 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_3E = 320'h10016100191001C1001F1002210025100291002C1003010034100381003C10041100451004A1004F ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_3D = 320'h10054100591005E100641006A1006F100751007B10082100881008F100951009C100A3100AA100B2 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_3C = 320'h100B9100C1100C8100D0100D8100E1100E9100F2100FA101031010C101151011F10128101321013C ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_3B = 320'h10146101501015A101641016F10179101841018F1019A101A6101B1101BD101C9101D5101E1101ED ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_3A = 320'h101F910206102121021F1022C10239102471025410262102701027D1028C1029A102A8102B7102C5 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_39 = 320'h102D4102E3102F210302103111032110330103401035010360103711038110392103A3103B4103C5 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_38 = 320'h103D6103E8103F91040B1041D1042F104411045310466104781048B1049E104B1104C4104D8104EB ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_37 = 320'h104FF10513105271053B1054F10564105781058D105A2105B7105CC105E1105F71060D1062210638 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_36 = 320'h1064E106651067B10692106A8106BF106D6106ED107051071C107341074C107631077B10794107AC ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_35 = 320'h107C5107DD107F61080F10828108411085B108741088E108A8108C2108DC108F6109111092B10946 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_34 = 320'h109611097C10997109B2109CE109EA10A0510A2110A3D10A5A10A7610A9210AAF10ACC10AE910B06 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_33 = 320'h10B2310B4110B5E10B7C10B9A10BB810BD610BF410C1310C3110C5010C6F10C8E10CAD10CCC10CEC ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_32 = 320'h10D0B10D2B10D4B10D6B10D8B10DAC10DCC10DED10E0D10E2E10E4F10E7110E9210EB410ED510EF7 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_31 = 320'h10F1910F3B10F5D10F8010FA210FC510FE81100B1102E110511107411098110BB110DF1110311127 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_30 = 320'h1114C1117011195111B9111DE11203112281124D1127311298112BE112E41130A11330113561137D ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_2F = 320'h113A3113CA113F1114181143F114661148D114B5114DD115041152C115551157D115A5115CE115F6 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_2E = 320'h1161F11648116711169A116C4116ED11717117411176B11795117BF117E9118141183E1186911894 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_2D = 320'h118BF118EA11916119411196D11999119C4119F011A1D11A4911A7511AA211ACF11AFC11B2911B56 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_2C = 320'h11B8311BB011BDE11C0C11C3911C6711C9511CC411CF211D2111D4F11D7E11DAD11DDC11E0B11E3A ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_2B = 320'h11E6A11E9911EC911EF911F2911F5911F8911FBA11FEA1201B1204C1207D120AE120DF1211012142 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_2A = 320'h12174121A5121D7122091223B1226E122A0122D312305123381236B1239E123D112405124381246C ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_29 = 320'h124A0124D4125081253C12570125A4125D91260E1264212677126AC126E2127171274C12782127B8 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_28 = 320'h127EE128241285A12890128C6128FD129331296A129A1129D812A0F12A4612A7E12AB512AED12B25 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_27 = 320'h12B5D12B9512BCD12C0512C3E12C7612CAF12CE812D2112D5A12D9312DCC12E0612E3F12E7912EB3 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_26 = 320'h12EED12F2712F6112F9B12FD6130101304B13086130C1130FC1313713172131AE131E91322513261 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_25 = 320'h1329D132D913315133521338E133CB134071344413481134BE134FB1353913576135B3135F11362F ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_24 = 320'h1366D136AB136E91372713766137A4137E313822138601389F138DF1391E1395D1399D139DC13A1C ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_23 = 320'h13A5C13A9C13ADC13B1C13B5C13B9D13BDD13C1E13C5F13CA013CE113D2213D6313DA413DE613E28 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_22 = 320'h13E6913EAB13EED13F2F13F7113FB413FF6140391407B140BE141011414414187141CA1420E14251 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_21 = 320'h14295142D81431C14360143A4143E81442C14471144B5144FA1453F14583145C81460D1465214698 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_20 = 320'h146DD1472314768147AE147F41483A14880148C61490C1495314999149E014A2614A6D14AB414AFB ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_1F = 320'h14B4214B8914BD114C1814C6014CA814CEF14D3714D7F14DC714E1014E5814EA014EE914F3214F7A ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_1E = 320'h14FC31500C150551509E150E8151311517B151C41520E15258152A2152EC1533615380153CA15415 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_1D = 320'h1545F154AA154F51553F1558A155D6156211566C156B7157031574E1579A157E6158321587E158CA ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_1C = 320'h1591615962159AE159FB15A4815A9415AE115B2E15B7B15BC815C1515C6215CB015CFD15D4B15D98 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_1B = 320'h15DE615E3415E8215ED015F1E15F6C15FBB1600916058160A6160F51614416193161E21623116280 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_1A = 320'h162CF1631F1636E163BE1640E1645D164AD164FD1654D1659D165EE1663E1668E166DF1673016780 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_19 = 320'h167D11682216873168C41691516966169B816A0916A5B16AAC16AFE16B5016BA216BF416C4616C98 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_18 = 320'h16CEA16D3C16D8F16DE116E3416E8716ED916F2C16F7F16FD21702517078170CC1711F17173171C6 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_17 = 320'h1721A1726D172C11731517369173BD1741117466174BA1750E17563175B71760C17661176B61770A ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_16 = 320'h1775F177B41780A1785F178B4179091795F179B417A0A17A6017AB617B0B17B6117BB717C0E17C64 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_15 = 320'h17CBA17D1017D6717DBD17E1417E6B17EC117F1817F6F17FC61801D18074180CB181231817A181D1 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_14 = 320'h1822918281182D81833018388183E01843818490184E81854018598185F018649186A1186FA18753 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_13 = 320'h187AB188041885D188B61890F18968189C118A1A18A7318ACD18B2618B8018BD918C3318C8D18CE6 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_12 = 320'h18D4018D9A18DF418E4E18EA818F0218F5D18FB7190111906C190C6191211917B191D6192311928C ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_11 = 320'h192E7193421939D193F819453194AE1950A19565195C01961C19677196D31972F1978A197E619842 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_10 = 320'h1989E198FA19956199B219A0E19A6B19AC719B2319B8019BDC19C3919C9519CF219D4F19DAC19E08 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_0F = 320'h19E6519EC219F1F19F7C19FDA1A0371A0941A0F11A14F1A1AC1A20A1A2671A2C51A3221A3801A3DE ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_0E = 320'h1A43C1A49A1A4F81A5561A5B41A6121A6701A6CE1A72C1A78B1A7E91A8471A8A61A9041A9631A9C2 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_0D = 320'h1AA201AA7F1AADE1AB3D1AB9C1ABFA1AC591ACB81AD181AD771ADD61AE351AE941AEF41AF531AFB3 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_0C = 320'h1B0121B0721B0D11B1311B1901B1F01B2501B2B01B3101B3701B3CF1B42F1B48F1B4F01B5501B5B0 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_0B = 320'h1B6101B6701B6D11B7311B7911B7F21B8521B8B31B9141B9741B9D51BA351BA961BAF71BB581BBB9 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_0A = 320'h1BC1A1BC7B1BCDC1BD3D1BD9E1BDFF1BE601BEC11BF221BF841BFE51C0461C0A81C1091C16B1C1CC ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_09 = 320'h1C22E1C28F1C2F11C3521C3B41C4161C4781C4D91C53B1C59D1C5FF1C6611C6C31C7251C7871C7E9 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_08 = 320'h1C84B1C8AD1C90F1C9721C9D41CA361CA981CAFB1CB5D1CBC01CC221CC841CCE71CD491CDAC1CE0F ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_07 = 320'h1CE711CED41CF361CF991CFFC1D05F1D0C11D1241D1871D1EA1D24D1D2B01D3131D3761D3D91D43C ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_06 = 320'h1D49F1D5021D5651D5C81D62B1D68F1D6F21D7551D7B81D81C1D87F1D8E21D9461D9A91DA0C1DA70 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_05 = 320'h1DAD31DB371DB9A1DBFE1DC611DCC51DD291DD8C1DDF01DE531DEB71DF1B1DF7E1DFE21E0461E0AA ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_04 = 320'h1E10D1E1711E1D51E2391E29D1E3011E3651E3C81E42C1E4901E4F41E5581E5BC1E6201E6841E6E8 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_03 = 320'h1E74C1E7B01E8151E8791E8DD1E9411E9A51EA091EA6D1EAD21EB361EB9A1EBFE1EC621ECC71ED2B ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_02 = 320'h1ED8F1EDF31EE581EEBC1EF201EF851EFE91F04D1F0B21F1161F17A1F1DF1F2431F2A71F30C1F370 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_01 = 320'h1F3D51F4391F49E1F5021F5661F5CB1F62F1F6941F6F81F75D1F7C11F8261F88A1F8EF1F9531F9B8 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.INITVAL_00 = 320'h1FA1C1FA811FAE51FB4A1FBAE1FC131FC771FCDC1FD401FDA51FE091FE6E1FED21FF371FF9B10000 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.CSDECODE_B =  3'b000 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.CSDECODE_A =  3'b000 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.WRITEMODE_B = "NORMAL" ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.WRITEMODE_A = "NORMAL" ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.GSR = "DISABLED" ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.RESETMODE = "SYNC" ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.REGMODE_B = "OUTREG" ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.REGMODE_A = "OUTREG" ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.DATA_WIDTH_B = 18 ;
    defparam TDPRAM_NSINE17b1024d_0_0_0.DATA_WIDTH_A = 18 ;
    // synopsys translate_on
    DP16KB TDPRAM_NSINE17b1024d_0_0_0 (.DIA0(DataInA[0]), .DIA1(DataInA[1]), 
        .DIA2(DataInA[2]), .DIA3(DataInA[3]), .DIA4(DataInA[4]), .DIA5(DataInA[5]), 
        .DIA6(DataInA[6]), .DIA7(DataInA[7]), .DIA8(DataInA[8]), .DIA9(DataInA[9]), 
        .DIA10(DataInA[10]), .DIA11(DataInA[11]), .DIA12(DataInA[12]), .DIA13(DataInA[13]), 
        .DIA14(DataInA[14]), .DIA15(DataInA[15]), .DIA16(DataInA[16]), .DIA17(scuba_vlo), 
        .ADA0(scuba_vhi), .ADA1(scuba_vhi), .ADA2(scuba_vlo), .ADA3(scuba_vlo), 
        .ADA4(AddressA[0]), .ADA5(AddressA[1]), .ADA6(AddressA[2]), .ADA7(AddressA[3]), 
        .ADA8(AddressA[4]), .ADA9(AddressA[5]), .ADA10(AddressA[6]), .ADA11(AddressA[7]), 
        .ADA12(AddressA[8]), .ADA13(AddressA[9]), .CEA(ClockEnA), .CLKA(ClockA), 
        .WEA(WrA), .CSA0(scuba_vlo), .CSA1(scuba_vlo), .CSA2(scuba_vlo), 
        .RSTA(ResetA), .DIB0(DataInB[0]), .DIB1(DataInB[1]), .DIB2(DataInB[2]), 
        .DIB3(DataInB[3]), .DIB4(DataInB[4]), .DIB5(DataInB[5]), .DIB6(DataInB[6]), 
        .DIB7(DataInB[7]), .DIB8(DataInB[8]), .DIB9(DataInB[9]), .DIB10(DataInB[10]), 
        .DIB11(DataInB[11]), .DIB12(DataInB[12]), .DIB13(DataInB[13]), .DIB14(DataInB[14]), 
        .DIB15(DataInB[15]), .DIB16(DataInB[16]), .DIB17(scuba_vlo), .ADB0(scuba_vhi), 
        .ADB1(scuba_vhi), .ADB2(scuba_vlo), .ADB3(scuba_vlo), .ADB4(AddressB[0]), 
        .ADB5(AddressB[1]), .ADB6(AddressB[2]), .ADB7(AddressB[3]), .ADB8(AddressB[4]), 
        .ADB9(AddressB[5]), .ADB10(AddressB[6]), .ADB11(AddressB[7]), .ADB12(AddressB[8]), 
        .ADB13(AddressB[9]), .CEB(ClockEnB), .CLKB(ClockB), .WEB(WrB), .CSB0(scuba_vlo), 
        .CSB1(scuba_vlo), .CSB2(scuba_vlo), .RSTB(ResetB), .DOA0(QA[0]), 
        .DOA1(QA[1]), .DOA2(QA[2]), .DOA3(QA[3]), .DOA4(QA[4]), .DOA5(QA[5]), 
        .DOA6(QA[6]), .DOA7(QA[7]), .DOA8(QA[8]), .DOA9(QA[9]), .DOA10(QA[10]), 
        .DOA11(QA[11]), .DOA12(QA[12]), .DOA13(QA[13]), .DOA14(QA[14]), 
        .DOA15(QA[15]), .DOA16(QA[16]), .DOA17(), .DOB0(QB[0]), .DOB1(QB[1]), 
        .DOB2(QB[2]), .DOB3(QB[3]), .DOB4(QB[4]), .DOB5(QB[5]), .DOB6(QB[6]), 
        .DOB7(QB[7]), .DOB8(QB[8]), .DOB9(QB[9]), .DOB10(QB[10]), .DOB11(QB[11]), 
        .DOB12(QB[12]), .DOB13(QB[13]), .DOB14(QB[14]), .DOB15(QB[15]), 
        .DOB16(QB[16]), .DOB17())
             /* synthesis MEM_LPC_FILE="TDPRAM_NSINE17b1024d.lpc" */
             /* synthesis MEM_INIT_FILE="quoternegsine_17b1024d.mem_1024d17b.mem" */
             /* synthesis INITVAL_3F="0x10000100001000110001100021000310004100051000610008100091000B1000D1000F1001110014" */
             /* synthesis INITVAL_3E="0x10016100191001C1001F1002210025100291002C1003010034100381003C10041100451004A1004F" */
             /* synthesis INITVAL_3D="0x10054100591005E100641006A1006F100751007B10082100881008F100951009C100A3100AA100B2" */
             /* synthesis INITVAL_3C="0x100B9100C1100C8100D0100D8100E1100E9100F2100FA101031010C101151011F10128101321013C" */
             /* synthesis INITVAL_3B="0x10146101501015A101641016F10179101841018F1019A101A6101B1101BD101C9101D5101E1101ED" */
             /* synthesis INITVAL_3A="0x101F910206102121021F1022C10239102471025410262102701027D1028C1029A102A8102B7102C5" */
             /* synthesis INITVAL_39="0x102D4102E3102F210302103111032110330103401035010360103711038110392103A3103B4103C5" */
             /* synthesis INITVAL_38="0x103D6103E8103F91040B1041D1042F104411045310466104781048B1049E104B1104C4104D8104EB" */
             /* synthesis INITVAL_37="0x104FF10513105271053B1054F10564105781058D105A2105B7105CC105E1105F71060D1062210638" */
             /* synthesis INITVAL_36="0x1064E106651067B10692106A8106BF106D6106ED107051071C107341074C107631077B10794107AC" */
             /* synthesis INITVAL_35="0x107C5107DD107F61080F10828108411085B108741088E108A8108C2108DC108F6109111092B10946" */
             /* synthesis INITVAL_34="0x109611097C10997109B2109CE109EA10A0510A2110A3D10A5A10A7610A9210AAF10ACC10AE910B06" */
             /* synthesis INITVAL_33="0x10B2310B4110B5E10B7C10B9A10BB810BD610BF410C1310C3110C5010C6F10C8E10CAD10CCC10CEC" */
             /* synthesis INITVAL_32="0x10D0B10D2B10D4B10D6B10D8B10DAC10DCC10DED10E0D10E2E10E4F10E7110E9210EB410ED510EF7" */
             /* synthesis INITVAL_31="0x10F1910F3B10F5D10F8010FA210FC510FE81100B1102E110511107411098110BB110DF1110311127" */
             /* synthesis INITVAL_30="0x1114C1117011195111B9111DE11203112281124D1127311298112BE112E41130A11330113561137D" */
             /* synthesis INITVAL_2F="0x113A3113CA113F1114181143F114661148D114B5114DD115041152C115551157D115A5115CE115F6" */
             /* synthesis INITVAL_2E="0x1161F11648116711169A116C4116ED11717117411176B11795117BF117E9118141183E1186911894" */
             /* synthesis INITVAL_2D="0x118BF118EA11916119411196D11999119C4119F011A1D11A4911A7511AA211ACF11AFC11B2911B56" */
             /* synthesis INITVAL_2C="0x11B8311BB011BDE11C0C11C3911C6711C9511CC411CF211D2111D4F11D7E11DAD11DDC11E0B11E3A" */
             /* synthesis INITVAL_2B="0x11E6A11E9911EC911EF911F2911F5911F8911FBA11FEA1201B1204C1207D120AE120DF1211012142" */
             /* synthesis INITVAL_2A="0x12174121A5121D7122091223B1226E122A0122D312305123381236B1239E123D112405124381246C" */
             /* synthesis INITVAL_29="0x124A0124D4125081253C12570125A4125D91260E1264212677126AC126E2127171274C12782127B8" */
             /* synthesis INITVAL_28="0x127EE128241285A12890128C6128FD129331296A129A1129D812A0F12A4612A7E12AB512AED12B25" */
             /* synthesis INITVAL_27="0x12B5D12B9512BCD12C0512C3E12C7612CAF12CE812D2112D5A12D9312DCC12E0612E3F12E7912EB3" */
             /* synthesis INITVAL_26="0x12EED12F2712F6112F9B12FD6130101304B13086130C1130FC1313713172131AE131E91322513261" */
             /* synthesis INITVAL_25="0x1329D132D913315133521338E133CB134071344413481134BE134FB1353913576135B3135F11362F" */
             /* synthesis INITVAL_24="0x1366D136AB136E91372713766137A4137E313822138601389F138DF1391E1395D1399D139DC13A1C" */
             /* synthesis INITVAL_23="0x13A5C13A9C13ADC13B1C13B5C13B9D13BDD13C1E13C5F13CA013CE113D2213D6313DA413DE613E28" */
             /* synthesis INITVAL_22="0x13E6913EAB13EED13F2F13F7113FB413FF6140391407B140BE141011414414187141CA1420E14251" */
             /* synthesis INITVAL_21="0x14295142D81431C14360143A4143E81442C14471144B5144FA1453F14583145C81460D1465214698" */
             /* synthesis INITVAL_20="0x146DD1472314768147AE147F41483A14880148C61490C1495314999149E014A2614A6D14AB414AFB" */
             /* synthesis INITVAL_1F="0x14B4214B8914BD114C1814C6014CA814CEF14D3714D7F14DC714E1014E5814EA014EE914F3214F7A" */
             /* synthesis INITVAL_1E="0x14FC31500C150551509E150E8151311517B151C41520E15258152A2152EC1533615380153CA15415" */
             /* synthesis INITVAL_1D="0x1545F154AA154F51553F1558A155D6156211566C156B7157031574E1579A157E6158321587E158CA" */
             /* synthesis INITVAL_1C="0x1591615962159AE159FB15A4815A9415AE115B2E15B7B15BC815C1515C6215CB015CFD15D4B15D98" */
             /* synthesis INITVAL_1B="0x15DE615E3415E8215ED015F1E15F6C15FBB1600916058160A6160F51614416193161E21623116280" */
             /* synthesis INITVAL_1A="0x162CF1631F1636E163BE1640E1645D164AD164FD1654D1659D165EE1663E1668E166DF1673016780" */
             /* synthesis INITVAL_19="0x167D11682216873168C41691516966169B816A0916A5B16AAC16AFE16B5016BA216BF416C4616C98" */
             /* synthesis INITVAL_18="0x16CEA16D3C16D8F16DE116E3416E8716ED916F2C16F7F16FD21702517078170CC1711F17173171C6" */
             /* synthesis INITVAL_17="0x1721A1726D172C11731517369173BD1741117466174BA1750E17563175B71760C17661176B61770A" */
             /* synthesis INITVAL_16="0x1775F177B41780A1785F178B4179091795F179B417A0A17A6017AB617B0B17B6117BB717C0E17C64" */
             /* synthesis INITVAL_15="0x17CBA17D1017D6717DBD17E1417E6B17EC117F1817F6F17FC61801D18074180CB181231817A181D1" */
             /* synthesis INITVAL_14="0x1822918281182D81833018388183E01843818490184E81854018598185F018649186A1186FA18753" */
             /* synthesis INITVAL_13="0x187AB188041885D188B61890F18968189C118A1A18A7318ACD18B2618B8018BD918C3318C8D18CE6" */
             /* synthesis INITVAL_12="0x18D4018D9A18DF418E4E18EA818F0218F5D18FB7190111906C190C6191211917B191D6192311928C" */
             /* synthesis INITVAL_11="0x192E7193421939D193F819453194AE1950A19565195C01961C19677196D31972F1978A197E619842" */
             /* synthesis INITVAL_10="0x1989E198FA19956199B219A0E19A6B19AC719B2319B8019BDC19C3919C9519CF219D4F19DAC19E08" */
             /* synthesis INITVAL_0F="0x19E6519EC219F1F19F7C19FDA1A0371A0941A0F11A14F1A1AC1A20A1A2671A2C51A3221A3801A3DE" */
             /* synthesis INITVAL_0E="0x1A43C1A49A1A4F81A5561A5B41A6121A6701A6CE1A72C1A78B1A7E91A8471A8A61A9041A9631A9C2" */
             /* synthesis INITVAL_0D="0x1AA201AA7F1AADE1AB3D1AB9C1ABFA1AC591ACB81AD181AD771ADD61AE351AE941AEF41AF531AFB3" */
             /* synthesis INITVAL_0C="0x1B0121B0721B0D11B1311B1901B1F01B2501B2B01B3101B3701B3CF1B42F1B48F1B4F01B5501B5B0" */
             /* synthesis INITVAL_0B="0x1B6101B6701B6D11B7311B7911B7F21B8521B8B31B9141B9741B9D51BA351BA961BAF71BB581BBB9" */
             /* synthesis INITVAL_0A="0x1BC1A1BC7B1BCDC1BD3D1BD9E1BDFF1BE601BEC11BF221BF841BFE51C0461C0A81C1091C16B1C1CC" */
             /* synthesis INITVAL_09="0x1C22E1C28F1C2F11C3521C3B41C4161C4781C4D91C53B1C59D1C5FF1C6611C6C31C7251C7871C7E9" */
             /* synthesis INITVAL_08="0x1C84B1C8AD1C90F1C9721C9D41CA361CA981CAFB1CB5D1CBC01CC221CC841CCE71CD491CDAC1CE0F" */
             /* synthesis INITVAL_07="0x1CE711CED41CF361CF991CFFC1D05F1D0C11D1241D1871D1EA1D24D1D2B01D3131D3761D3D91D43C" */
             /* synthesis INITVAL_06="0x1D49F1D5021D5651D5C81D62B1D68F1D6F21D7551D7B81D81C1D87F1D8E21D9461D9A91DA0C1DA70" */
             /* synthesis INITVAL_05="0x1DAD31DB371DB9A1DBFE1DC611DCC51DD291DD8C1DDF01DE531DEB71DF1B1DF7E1DFE21E0461E0AA" */
             /* synthesis INITVAL_04="0x1E10D1E1711E1D51E2391E29D1E3011E3651E3C81E42C1E4901E4F41E5581E5BC1E6201E6841E6E8" */
             /* synthesis INITVAL_03="0x1E74C1E7B01E8151E8791E8DD1E9411E9A51EA091EA6D1EAD21EB361EB9A1EBFE1EC621ECC71ED2B" */
             /* synthesis INITVAL_02="0x1ED8F1EDF31EE581EEBC1EF201EF851EFE91F04D1F0B21F1161F17A1F1DF1F2431F2A71F30C1F370" */
             /* synthesis INITVAL_01="0x1F3D51F4391F49E1F5021F5661F5CB1F62F1F6941F6F81F75D1F7C11F8261F88A1F8EF1F9531F9B8" */
             /* synthesis INITVAL_00="0x1FA1C1FA811FAE51FB4A1FBAE1FC131FC771FCDC1FD401FDA51FE091FE6E1FED21FF371FF9B10000" */
             /* synthesis CSDECODE_B="0b000" */
             /* synthesis CSDECODE_A="0b000" */
             /* synthesis WRITEMODE_B="NORMAL" */
             /* synthesis WRITEMODE_A="NORMAL" */
             /* synthesis GSR="DISABLED" */
             /* synthesis RESETMODE="SYNC" */
             /* synthesis REGMODE_B="OUTREG" */
             /* synthesis REGMODE_A="OUTREG" */
             /* synthesis DATA_WIDTH_B="18" */
             /* synthesis DATA_WIDTH_A="18" */;



    // exemplar begin
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 MEM_LPC_FILE TDPRAM_NSINE17b1024d.lpc
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 MEM_INIT_FILE quoternegsine_17b1024d.mem_1024d17b.mem
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_3F 0x10000100001000110001100021000310004100051000610008100091000B1000D1000F1001110014
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_3E 0x10016100191001C1001F1002210025100291002C1003010034100381003C10041100451004A1004F
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_3D 0x10054100591005E100641006A1006F100751007B10082100881008F100951009C100A3100AA100B2
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_3C 0x100B9100C1100C8100D0100D8100E1100E9100F2100FA101031010C101151011F10128101321013C
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_3B 0x10146101501015A101641016F10179101841018F1019A101A6101B1101BD101C9101D5101E1101ED
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_3A 0x101F910206102121021F1022C10239102471025410262102701027D1028C1029A102A8102B7102C5
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_39 0x102D4102E3102F210302103111032110330103401035010360103711038110392103A3103B4103C5
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_38 0x103D6103E8103F91040B1041D1042F104411045310466104781048B1049E104B1104C4104D8104EB
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_37 0x104FF10513105271053B1054F10564105781058D105A2105B7105CC105E1105F71060D1062210638
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_36 0x1064E106651067B10692106A8106BF106D6106ED107051071C107341074C107631077B10794107AC
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_35 0x107C5107DD107F61080F10828108411085B108741088E108A8108C2108DC108F6109111092B10946
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_34 0x109611097C10997109B2109CE109EA10A0510A2110A3D10A5A10A7610A9210AAF10ACC10AE910B06
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_33 0x10B2310B4110B5E10B7C10B9A10BB810BD610BF410C1310C3110C5010C6F10C8E10CAD10CCC10CEC
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_32 0x10D0B10D2B10D4B10D6B10D8B10DAC10DCC10DED10E0D10E2E10E4F10E7110E9210EB410ED510EF7
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_31 0x10F1910F3B10F5D10F8010FA210FC510FE81100B1102E110511107411098110BB110DF1110311127
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_30 0x1114C1117011195111B9111DE11203112281124D1127311298112BE112E41130A11330113561137D
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_2F 0x113A3113CA113F1114181143F114661148D114B5114DD115041152C115551157D115A5115CE115F6
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_2E 0x1161F11648116711169A116C4116ED11717117411176B11795117BF117E9118141183E1186911894
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_2D 0x118BF118EA11916119411196D11999119C4119F011A1D11A4911A7511AA211ACF11AFC11B2911B56
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_2C 0x11B8311BB011BDE11C0C11C3911C6711C9511CC411CF211D2111D4F11D7E11DAD11DDC11E0B11E3A
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_2B 0x11E6A11E9911EC911EF911F2911F5911F8911FBA11FEA1201B1204C1207D120AE120DF1211012142
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_2A 0x12174121A5121D7122091223B1226E122A0122D312305123381236B1239E123D112405124381246C
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_29 0x124A0124D4125081253C12570125A4125D91260E1264212677126AC126E2127171274C12782127B8
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_28 0x127EE128241285A12890128C6128FD129331296A129A1129D812A0F12A4612A7E12AB512AED12B25
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_27 0x12B5D12B9512BCD12C0512C3E12C7612CAF12CE812D2112D5A12D9312DCC12E0612E3F12E7912EB3
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_26 0x12EED12F2712F6112F9B12FD6130101304B13086130C1130FC1313713172131AE131E91322513261
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_25 0x1329D132D913315133521338E133CB134071344413481134BE134FB1353913576135B3135F11362F
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_24 0x1366D136AB136E91372713766137A4137E313822138601389F138DF1391E1395D1399D139DC13A1C
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_23 0x13A5C13A9C13ADC13B1C13B5C13B9D13BDD13C1E13C5F13CA013CE113D2213D6313DA413DE613E28
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_22 0x13E6913EAB13EED13F2F13F7113FB413FF6140391407B140BE141011414414187141CA1420E14251
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_21 0x14295142D81431C14360143A4143E81442C14471144B5144FA1453F14583145C81460D1465214698
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_20 0x146DD1472314768147AE147F41483A14880148C61490C1495314999149E014A2614A6D14AB414AFB
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_1F 0x14B4214B8914BD114C1814C6014CA814CEF14D3714D7F14DC714E1014E5814EA014EE914F3214F7A
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_1E 0x14FC31500C150551509E150E8151311517B151C41520E15258152A2152EC1533615380153CA15415
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_1D 0x1545F154AA154F51553F1558A155D6156211566C156B7157031574E1579A157E6158321587E158CA
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_1C 0x1591615962159AE159FB15A4815A9415AE115B2E15B7B15BC815C1515C6215CB015CFD15D4B15D98
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_1B 0x15DE615E3415E8215ED015F1E15F6C15FBB1600916058160A6160F51614416193161E21623116280
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_1A 0x162CF1631F1636E163BE1640E1645D164AD164FD1654D1659D165EE1663E1668E166DF1673016780
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_19 0x167D11682216873168C41691516966169B816A0916A5B16AAC16AFE16B5016BA216BF416C4616C98
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_18 0x16CEA16D3C16D8F16DE116E3416E8716ED916F2C16F7F16FD21702517078170CC1711F17173171C6
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_17 0x1721A1726D172C11731517369173BD1741117466174BA1750E17563175B71760C17661176B61770A
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_16 0x1775F177B41780A1785F178B4179091795F179B417A0A17A6017AB617B0B17B6117BB717C0E17C64
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_15 0x17CBA17D1017D6717DBD17E1417E6B17EC117F1817F6F17FC61801D18074180CB181231817A181D1
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_14 0x1822918281182D81833018388183E01843818490184E81854018598185F018649186A1186FA18753
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_13 0x187AB188041885D188B61890F18968189C118A1A18A7318ACD18B2618B8018BD918C3318C8D18CE6
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_12 0x18D4018D9A18DF418E4E18EA818F0218F5D18FB7190111906C190C6191211917B191D6192311928C
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_11 0x192E7193421939D193F819453194AE1950A19565195C01961C19677196D31972F1978A197E619842
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_10 0x1989E198FA19956199B219A0E19A6B19AC719B2319B8019BDC19C3919C9519CF219D4F19DAC19E08
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_0F 0x19E6519EC219F1F19F7C19FDA1A0371A0941A0F11A14F1A1AC1A20A1A2671A2C51A3221A3801A3DE
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_0E 0x1A43C1A49A1A4F81A5561A5B41A6121A6701A6CE1A72C1A78B1A7E91A8471A8A61A9041A9631A9C2
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_0D 0x1AA201AA7F1AADE1AB3D1AB9C1ABFA1AC591ACB81AD181AD771ADD61AE351AE941AEF41AF531AFB3
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_0C 0x1B0121B0721B0D11B1311B1901B1F01B2501B2B01B3101B3701B3CF1B42F1B48F1B4F01B5501B5B0
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_0B 0x1B6101B6701B6D11B7311B7911B7F21B8521B8B31B9141B9741B9D51BA351BA961BAF71BB581BBB9
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_0A 0x1BC1A1BC7B1BCDC1BD3D1BD9E1BDFF1BE601BEC11BF221BF841BFE51C0461C0A81C1091C16B1C1CC
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_09 0x1C22E1C28F1C2F11C3521C3B41C4161C4781C4D91C53B1C59D1C5FF1C6611C6C31C7251C7871C7E9
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_08 0x1C84B1C8AD1C90F1C9721C9D41CA361CA981CAFB1CB5D1CBC01CC221CC841CCE71CD491CDAC1CE0F
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_07 0x1CE711CED41CF361CF991CFFC1D05F1D0C11D1241D1871D1EA1D24D1D2B01D3131D3761D3D91D43C
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_06 0x1D49F1D5021D5651D5C81D62B1D68F1D6F21D7551D7B81D81C1D87F1D8E21D9461D9A91DA0C1DA70
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_05 0x1DAD31DB371DB9A1DBFE1DC611DCC51DD291DD8C1DDF01DE531DEB71DF1B1DF7E1DFE21E0461E0AA
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_04 0x1E10D1E1711E1D51E2391E29D1E3011E3651E3C81E42C1E4901E4F41E5581E5BC1E6201E6841E6E8
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_03 0x1E74C1E7B01E8151E8791E8DD1E9411E9A51EA091EA6D1EAD21EB361EB9A1EBFE1EC621ECC71ED2B
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_02 0x1ED8F1EDF31EE581EEBC1EF201EF851EFE91F04D1F0B21F1161F17A1F1DF1F2431F2A71F30C1F370
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_01 0x1F3D51F4391F49E1F5021F5661F5CB1F62F1F6941F6F81F75D1F7C11F8261F88A1F8EF1F9531F9B8
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 INITVAL_00 0x1FA1C1FA811FAE51FB4A1FBAE1FC131FC771FCDC1FD401FDA51FE091FE6E1FED21FF371FF9B10000
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 CSDECODE_B 0b000
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 CSDECODE_A 0b000
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 WRITEMODE_B NORMAL
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 WRITEMODE_A NORMAL
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 GSR DISABLED
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 RESETMODE SYNC
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 REGMODE_B OUTREG
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 REGMODE_A OUTREG
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 DATA_WIDTH_B 18
    // exemplar attribute TDPRAM_NSINE17b1024d_0_0_0 DATA_WIDTH_A 18
    // exemplar end

endmodule