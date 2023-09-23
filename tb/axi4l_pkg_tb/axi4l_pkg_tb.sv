// Description here
// ### Author : name (email)

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"
`include "vip/axi4l_pkg.sv"
//`include "vip/axi4_pkg.sv"
//`include "vip/bus_dvr_mon.svh"
//`include "vip/string_ops_pkg.sv"

module axi4l_pkg_tb;

  `define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  import axi4l_pkg::axi4l_seq_item;
  import axi4l_pkg::axi4l_resp_item;
  import axi4l_pkg::axi4l_driver;
  import axi4l_pkg::axi4l_monitor;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  `AXI4L_T(main, 32, 64)

  typedef axi4l_seq_item#(
      .ADDR_WIDTH(32),
      .DATA_WIDTH(64)
  ) main_seq_item_t;

  typedef axi4l_resp_item#(
      .ADDR_WIDTH(32),
      .DATA_WIDTH(64)
  ) main_resp_item_t;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i, 5ns, 5ns)

  logic arst_ni = 1;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INTERFACES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  axi4l_if #(
      .ADDR_WIDTH(32),
      .DATA_WIDTH(64)
  ) u_axi4l_if (
      .clk_i  (clk_i),
      .arst_ni(arst_ni)
  );

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-CLASSES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  axi4l_driver #(.ADDR_WIDTH(32), .DATA_WIDTH(64), .ROLE(1)) manager = new(u_axi4l_if);
  axi4l_driver #(.ADDR_WIDTH(32), .DATA_WIDTH(64), .ROLE(0)) subordinate = new(u_axi4l_if);
  axi4l_monitor #(.ADDR_WIDTH(32), .DATA_WIDTH(64))          monitor = new(u_axi4l_if);

  mailbox #(main_seq_item_t)                                 dvr_mbx = new();
  mailbox #(main_resp_item_t)                                mon_mbx = new();

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

  task static apply_reset();  //{{{
    #100;
    arst_ni = 0;
    #100;
    arst_ni = 1;
    #100;
  endtask  //}}}

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin  // main initial{{{

    apply_reset();
    start_clk_i();

    manager.mbx = dvr_mbx;
    monitor.mbx = mon_mbx;

    subordinate.failure_odds = 10;

    manager.start();
    subordinate.start();
    monitor.start();

    repeat (25) begin
      main_seq_item_t item;
      item = new();
      item.randomize();
      item._type = 1;
      $display("%s", item.to_string());
      dvr_mbx.put(item);
      item = new item;
      item._type = 0;
      $display("%s", item.to_string());
      dvr_mbx.put(item);
    end

    monitor.wait_cooldown();

    while (mon_mbx.num()) begin
      main_resp_item_t item;
      mon_mbx.get(item);
      $display("%s", item.to_string());
    end

    $finish;

  end  //}}}

  //}}}

endmodule
