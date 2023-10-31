// Testbench for reg_group
// ### Author : Walid Akash (walidakash070@gmail.com)

module reg_group_tb;

  `define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int TagBits = 51;
  localparam int DataWidth = 1024;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i, 2ns, 2ns)

  logic arst_ni;
  logic row_sel;

  logic [TagBits-1:0] tag_i;
  logic tag_en;
  logic [TagBits-1:0] tag;

  logic val_i;
  logic val_en;
  logic val;

  logic dirty_i;
  logic dirty_en;
  logic dirty;

  logic evp_i;
  logic evp_en;
  logic evp;

  logic [(DataWidth/8)-1:0][7:0] data_i;
  logic [(DataWidth/8)-1:0] data_en;
  logic [(DataWidth/8)-1:0][7:0] data;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [TagBits-1:0] tag_m;
  logic val_m;
  logic dirty_m;
  logic evp_m;
  logic [(DataWidth/8)-1:0][7:0] data_m;

  // Test value
  int error = 0;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INTERFACES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-CLASSES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  reg_group # (
    .TAG_BITS  (TagBits  ),
    .DATA_WIDTH(DataWidth)
    ) u_reg_group (
    .clk_i   (clk_i   ),
    .arst_ni (arst_ni ),
    .row_sel (row_sel ),
    .tag_i   (tag_i   ),
    .tag_en  (tag_en  ),
    .tag     (tag     ),
    .val_i   (val_i   ),
    .val_en  (val_en  ),
    .val     (val     ),
    .dirty_i (dirty_i ),
    .dirty_en(dirty_en),
    .dirty   (dirty   ),
    .evp_i   (evp_i   ),
    .evp_en  (evp_en  ),
    .evp     (evp     ),
    .data_i  (data_i  ),
    .data_en (data_en ),
    .data    (data    )
    );

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static apply_reset();  //{{{
    row_sel <= 0;
    tag_i <= 0;
    tag_en <= 0;
    tag <= 0;
    val_i <= 0;
    val_en <= 0;
    val <= 0;
    dirty_i <= 0;
    dirty_en <= 0;
    dirty <= 0;
    evp_i <= 0;
    evp_en <= 0;
    evp <= 0;
    data_i <= 0;
    data_en <= 0;
    data <= 0;
    #10ns;
    arst_ni = 0;
    #10ns;
    arst_ni = 1;
    #10ns;
  endtask  //}}}

  // Reference Model of reg_group
  task static model_reg_group();   //{{{
    @(posedge clk_i);
    if (tag_en && row_sel) begin
      tag_m <= tag_i;
    end

    @(posedge clk_i);
    if (val_en && row_sel) begin
      val_m <= val_i;
    end

    @(posedge clk_i);
    if (dirty_en && row_sel) begin
      dirty_m <= dirty_i;
    end

    @(posedge clk_i);
    if (evp_en && row_sel) begin
      evp_m <= evp_i;
    end

    for (int i = 0; i < DataWidth; i++) begin
      @(posedge clk_i);
      if (data_en && row_sel) begin
        data_m[i] <= data_i[i];
      end
    end

    #1000ns;
  endtask   //}}}

  // Monitoring and Scoreboarding the Reference Model and DUT's ouputs
  task static mon_score();    //{{{
    if ((tag != tag_m) || (val != val_m) || (dirty != dirty_m) || (evp != evp_m)) begin
      error++;
    end

    /*for (int i = 0; i < 8; i++) begin
      if (data[i] != data_m[i]) begin
        error++;
      end
    end*/
  endtask   //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin  // main initial{{{

    apply_reset();
    start_clk_i();

    @(posedge clk_i);
    row_sel <= 1;
    tag_i <= $urandom();
    tag_en <= 1'b1;
    val_i <= $urandom();
    val_en <= 1'b1;
    dirty_i <= $urandom();
    dirty_en <= 1'b1;
    evp_i <= $urandom();
    evp_en <= 1'b1;

    for (int i = 0; i < DataWidth; i++) begin
      data_i <= $urandom;
    end
    data_en <= 1;
    @(posedge clk_i);

    model_reg_group();
    @(posedge clk_i);
    $display("Driven inputs to DUT  ----------- ");
    $display("tag_i = %0h", tag_i);
    $display("val_i = %0h", val_i);
    $display("dirty_i = %0h", dirty_i);
    $display("evp_i = %0h", evp_i);
    for (int i = 0; i < 8; i++) begin
      $display("data_i = %0h", data_i[i]);
    end

    @(posedge clk_i);
    $display("Outputs from REF. MODEL  ----------- ");
    $display("tag_m = %0h", tag_m);
    $display("val_m = %0h", val_m);
    $display("dirty_m = %0h", dirty_m);
    $display("evp_m = %0h", evp_m);
    for (int i = 0; i < 8; i++) begin
      $display("data_m = %0h", data_m[i]);
    end

    @(posedge clk_i);
    $display("Outputs from DUT  ----------- ");
    $display("tag = %0h", tag);
    $display("val = %0h", val);
    $display("dirty = %0h", dirty);
    $display("evp = %0h", evp);
    for (int i = 0; i < 8; i++) begin
      $display("data = %0h", data[i]);
    end
    @(posedge clk_i);
    mon_score();
    #2000;

    result_print(error == 0, "reg_group is passed");
    $finish;

  end  //}}}

  //}}}

endmodule

