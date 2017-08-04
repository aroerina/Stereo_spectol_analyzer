//-----------------------------------------------------------------------------
// Copyright(c) 2007 Lattice Semiconductor Corporation. All rights reserved.   
// WARNING - Changes to this file should be performed by re-running IPexpress
// or modifying the .LPC file and regenerating the core.  Other changes may lead
// to inconsistent simulation and/or implemenation results
//-----------------------------------------------------------------------------


module FFTC2048_18_top (
               clk,                       // system clock
               rstn,                      // system reset
               ibstart,                   // input block start indicator
               dire,                      // real part of input data
               diim,                      // imaginary part of input data

               except,                    // exception signal
               rfib,                      // ready for input block
               ibend,                     // input block end
               obstart,                   // output block start
               outvalid,                  // output outvalid
               dore,                      // real part of output data
               doim                       // imaginary part of output data
);
         // input ports
      input                                 clk;
      input                                 rstn;
      input                                 ibstart;
      input [18-1:0]                 dire;
      input [18-1:0]                 diim;
      // output ports
         output                             except;
      output                                rfib;
      output                                ibend;
      output                                obstart;
      output                                outvalid;
      output[18-1:0]                dore;
      output[18-1:0]                doim;
FFTC2048_18 u1_FFTC2048_18 (
               .clk(clk),                 // system clock
               .rstn(rstn),               // system reset
               .ibstart(ibstart),         // input block start indicator
               .dire(dire),               // real part of input data
               .diim(diim),               // imaginary part of input data

               .except(except),           // exception signal
               .rfib(rfib),               // ready for input block
               .ibend(ibend),             // input block end
               .obstart(obstart),         // output block start
               .outvalid(outvalid),       // output outvalid
               .dore(dore),               // real part of output data
               .doim(doim)                // imaginary part of output data
);
endmodule
