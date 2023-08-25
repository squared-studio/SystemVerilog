// Clock gate
// ### Author : Razu Ahamed(en.razu.ahamed@gmail.com)

module clk_gate (
    input  logic cp_i,
    input  logic e_i,
    input  logic te_i,
    output logic q_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic temp;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign q_o = te_i ? cp_i : temp;

  and (temp, cp_i, e_i);

endmodule
