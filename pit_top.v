////////////////////////////////////////////////////////////////////////////////
//
//  WISHBONE revB.2 compliant Programable Interrupt Timer - Top-level
//
//  Author: Ahmed Abdelazeem
//          ahmed-abdelazeem@outlook.com
//
//  
//
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, Ahmed Abdelazeem
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the <organization> nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY Ahmed Abdelazeem ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL Ahmed Abdelazeem BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
////////////////////////////////////////////////////////////////////////////////
// 45678901234567890123456789012345678901234567890123456789012345678901234567890
`include "pit_count.v"
`include "pit_prescale.v"
`include "pit_regs.v"
`include "pit_wb_bus.v"

module pit_top #(parameter ARST_LVL = 1'b0,      // asynchronous reset level
                 parameter PRE_COUNT_SIZE = 15,  // Prescale Counter size
                 parameter COUNT_SIZE = 16,      // Main counter size
                 parameter DECADE_CNTR = 1'b1,   // Prescale rollover decode
                 parameter NO_PRESCALE = 1'b0,   // Remove prescale function
                 parameter SINGLE_CYCLE = 1'b0,  // No bus wait state added
		 parameter DWIDTH = 16)          // Data bus width
  (
  // Wishbone Signals
  output [DWIDTH-1:0] wb_dat_o,     // databus output
  output              wb_ack_o,     // bus cycle acknowledge output
  input               wb_clk_i,     // master clock input
  input               wb_rst_i,     // synchronous active high reset
  input               arst_i,       // asynchronous reset
  input         [2:0] wb_adr_i,     // lower address bits
  input  [DWIDTH-1:0] wb_dat_i,     // databus input
  input               wb_we_i,      // write enable input
  input               wb_stb_i,     // stobe/core select signal
  input               wb_cyc_i,     // valid bus cycle input
  input         [1:0] wb_sel_i,     // Select byte in word bus transaction
  // PIT IO Signals
  output              pit_o,        // PIT output pulse
  output              pit_irq_o,    // PIT interrupt request signal output
  output              cnt_flag_o,   // PIT Flag Out
  output              cnt_sync_o,   // PIT Master Enable for Slave PIT's
  input               ext_sync_i    // Counter enable from Master PIT
  );
  
  wire [COUNT_SIZE-1:0] mod_value;     // Main Counter Modulo
  wire [COUNT_SIZE-1:0] cnt_n;         // PIT Counter Value
  wire                  async_rst_b;   // Asyncronous reset
  wire                  sync_reset;    // Syncronous reset
  wire           [ 3:0] write_regs;    // Control register write strobes
  wire                  prescale_out;  //
  wire                  pit_flg_clr;   // Clear PIT Rollover Status Bit
  wire                  pit_slave;     // PIT in Slave Mode, ext_sync_i selected
  wire           [ 3:0] pit_pre_scl;   // Prescaler modulo
  wire                  counter_sync;  // 
  
  // Wishbone Bus interface
  pit_wb_bus #(.ARST_LVL(ARST_LVL),
               .SINGLE_CYCLE(SINGLE_CYCLE),
               .DWIDTH(DWIDTH))
    wishbone(
    .wb_dat_o     ( wb_dat_o ),
    .wb_ack_o     ( wb_ack_o ),
    .wb_clk_i     ( wb_clk_i ),
    .wb_rst_i     ( wb_rst_i ),
    .arst_i       ( arst_i ),
    .wb_adr_i     ( wb_adr_i ),
    .wb_dat_i     ( wb_dat_i ),
    .wb_we_i      ( wb_we_i ),
    .wb_stb_i     ( wb_stb_i ),
    .wb_cyc_i     ( wb_cyc_i ),
    .wb_sel_i     ( wb_sel_i ),
    
    // outputs
    .write_regs   ( write_regs ),
    .sync_reset   ( sync_reset ),
    // inputs    
    .async_rst_b  ( async_rst_b ),
    .irq_source   ( cnt_flag_o ),
    .read_regs    (               // in  -- status register bits
		   { cnt_n,
		     mod_value,
		     {pit_slave, DECADE_CNTR, NO_PRESCALE, 1'b0, pit_pre_scl,
		      5'b0, cnt_flag_o, pit_ien, cnt_sync_o}
		   }
		  )
  );

// -----------------------------------------------------------------------------
  pit_regs #(.ARST_LVL(ARST_LVL),
             .COUNT_SIZE(COUNT_SIZE),
	     .NO_PRESCALE(NO_PRESCALE),
             .DWIDTH(DWIDTH))
    regs(
    // outputs
    .mod_value    ( mod_value ),
    .pit_pre_scl  ( pit_pre_scl ),
    .pit_slave    ( pit_slave ),
    .pit_flg_clr  ( pit_flg_clr ),
    .pit_ien      ( pit_ien ),
    .cnt_sync_o   ( cnt_sync_o ),
    .pit_irq_o    ( pit_irq_o ),
    // inputs
    .async_rst_b  ( async_rst_b ),
    .sync_reset   ( sync_reset ),
    .bus_clk      ( wb_clk_i ),
    .write_bus    ( wb_dat_i ),
    .write_regs   ( write_regs ),
    .cnt_flag_o   ( cnt_flag_o )
  );

// -----------------------------------------------------------------------------
  pit_prescale #(.COUNT_SIZE(PRE_COUNT_SIZE),
                 .DECADE_CNTR(DECADE_CNTR),
		 .NO_PRESCALE(NO_PRESCALE))
    prescale(
    // outputs
    .prescale_out      ( prescale_out ),
    .counter_sync      ( counter_sync ),
    // inputs
    .async_rst_b       ( async_rst_b ),
    .sync_reset        ( sync_reset ),
    .bus_clk           ( wb_clk_i ),
    .cnt_sync_o        ( cnt_sync_o ),
    .ext_sync_i        ( ext_sync_i ),
    .pit_slave         ( pit_slave ),
    .divisor           ( pit_pre_scl )
  );

// -----------------------------------------------------------------------------
  pit_count #(.COUNT_SIZE(COUNT_SIZE))
    counter(
    // outputs
    .cnt_n             ( cnt_n ),
    .cnt_flag_o        ( cnt_flag_o ),
    .pit_o             ( pit_o ),
    // inputs
    .async_rst_b       ( async_rst_b ),
    .sync_reset        ( sync_reset ),
    .bus_clk           ( wb_clk_i ),
    .counter_sync      ( counter_sync ),
    .prescale_out      ( prescale_out ),
    .pit_flg_clr       ( pit_flg_clr ),
    .mod_value         ( mod_value )
  );

endmodule // pit_top
