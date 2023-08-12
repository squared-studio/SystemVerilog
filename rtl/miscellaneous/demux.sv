// General purpose DEMUX
// ### Author : Foez Ahmed (foez.official@gmail.com)

module demux #(
    parameter int NUM_ELEM = 7  // Number of elements in the demux
) (
    input  logic [$clog2(NUM_ELEM)-1:0] s_i,  // Output select
    input  logic                        i_i,  // input
    output logic [        NUM_ELEM-1:0] o_o   // Array of Output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [$clog2(NUM_ELEM)-1:0] s_n;  // Invited select

  logic [$clog2(NUM_ELEM):0] output_and_red[NUM_ELEM];  // Output and reduction

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign s_n = ~s_i;

  always_comb begin
    for (bit [$clog2(NUM_ELEM):0] i = 0; i < NUM_ELEM; i++) begin
      for (int j = 0; j < $clog2(NUM_ELEM); j++) begin
        output_and_red[i][j] = i[j] ? s_i[j] : s_n[j];
      end
      output_and_red[i][$clog2(NUM_ELEM)] = i_i;
    end
  end

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_output_and_red
    assign o_o[i] = &output_and_red[i];
  end

endmodule
