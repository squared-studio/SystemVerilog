// Description
// ### Author : name (email)

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
//`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"

module rtl_model #(
    //-PARAMETERS
    //-LOCALPARAMS
) (
    //-PORTS
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIAL{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (DATA_WIDTH > 2) begin
      $display("\033[7;31m%m DATA_WIDTH\033[0m");
    end
  end
`endif  // SIMULATION

  //}}}

endmodule
