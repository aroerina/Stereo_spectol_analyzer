//--------------------------- BASE PARAMETERS --------------------------

`define     DEVICE_XP2

`define     DEVICE_FAMILY        "XP2"

`define     USE_HARDMAC
`define     NUM_POINTS           2048
`define     MODE_FORWARD
`define     SFACT_RS111
`define     DIN_WIDTH            16
`define     DATA_WIDTH           16
`define     DOUT_WIDTH           16
`define     DATA_WIDTH2          32
`define     TWID_WIDTH           16
`define     TWID_WIDTH2          32
`define     ADDER_PIPELINE       0
`define     TRUNCATE


//-------------------------- DERIVED PARAMETERS ------------------------

`define     NUM_POINTS_2048
`define     NBY4                 512
`define     SFACT_WIDTH          22
`define     LOG2_N               11
`define     LOG2_NBY2            10
`define     LOG2_NBY4            9
`define     NUM_STAGES           11
`define     STAGE_WIDTH          4
`define     NFFT_WIDTH           4
`define     WR_LATENCY           9
`define     HMAC_NON36
`define     BE_PL_DEPTH           3
`define     OUTVALID_SEL
