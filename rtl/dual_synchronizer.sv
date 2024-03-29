/*
Author : Foez Ahmed (foez.official@gmail.com)
*/

module dual_synchronizer #(
    // A bit that determines whether the first flip-flop detects positive edges
    parameter bit FIRST_FF_EDGE_POSEDGED = 0,
    // A bit that determines whether the last flip-flop detects positive edges
    parameter bit LAST_FF_EDGE_POSEDGED  = 0
) (
    input logic arst_ni,  // The asynchronous reset signal
    input logic clk_i,    // The global clock signal

    input logic en_i,  // The enable signal

    input logic d_i,  // The data input signal

    output logic q_o  // The output signal
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic dff0_clk_in;  // The clock input for the first flip-flop
  logic dff1_clk_in;  // The clock input for the second flip-flop
  logic en_intermediate;  // The intermediate enable signal
  logic q_intermediate;  // The intermediate output signal
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign dff0_clk_in = FIRST_FF_EDGE_POSEDGED ? clk_i : ~clk_i;
  assign dff1_clk_in = LAST_FF_EDGE_POSEDGED ? clk_i : ~clk_i;
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always @(posedge dff0_clk_in or negedge arst_ni) begin
    if (~arst_ni) begin
      en_intermediate <= '0;
      q_intermediate  <= '0;
    end else begin
      en_intermediate <= en_i;
      q_intermediate  <= d_i;
    end
  end

  always @(posedge dff1_clk_in or negedge arst_ni) begin
    if (~arst_ni) begin
      q_o <= '0;
    end else begin
      if (en_intermediate) q_o <= q_intermediate;
    end
  end
endmodule
