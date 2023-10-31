module reg_group #(
  parameter int TAG_BITS   = 51,
  parameter int DATA_WIDTH = 1024
)(
  input logic clk_i,
  input logic arst_ni,

  input logic [TAG_BITS-1:0] tag_i,
  input logic tag_en,
  output logic [TAG_BITS-1:0] tag,

  input logic val_i,
  input logic val_en,
  output logic val,

  input logic dirty_i,
  input logic dirty_en,
  output logic dirty,

  input logic evp_i,
  input logic evp_en,
  output logic evp,

  input logic [DEPTH-1:0][DATA_WIDTH-1:0] data_i,
  input logic [127:0] data_en,
  output logic [DEPTH-1:0][DATA_WIDTH-1:0] data
);

  register #(
  .ELEM_WIDTH  (TAG_BITS ),
  .RESET_VALUE ('0)
  ) u_tag (
    .clk_i   ( clk_i   ),
    .arst_ni ( arst_ni ),
    .en_i    ( tag_en  ),
    .d_i     ( tag_i   ),
    .q_o     ( tag     )
  );

  register #(
    .ELEM_WIDTH  ( 1 ),
    .RESET_VALUE ('0)
  ) u_valid (
    .clk_i   ( clk_i   ),
    .arst_ni ( arst_ni ),
    .en_i    ( val_en  ),
    .d_i     ( val_i   ),
    .q_o     ( val     )
  );

  register #(
    .ELEM_WIDTH  ( 1 ),
    .RESET_VALUE ('0)
  ) u_dirty (
    .clk_i   ( clk_i     ),
    .arst_ni ( arst_ni   ),
    .en_i    ( dirty_en  ),
    .d_i     ( dirty_i   ),
    .q_o     ( dirty     )
  );

  register #(
    .ELEM_WIDTH  ( 1 ),
    .RESET_VALUE ('0)
  ) u_evp (
    .clk_i   ( clk_i     ),
    .arst_ni ( arst_ni   ),
    .en_i    ( evp_en  ),
    .d_i     ( evp_i   ),
    .q_o     ( evp     )
  );

  for (genvar i = 0; i<DEPTH; i++)
  begin : g_reg_data_array
    register #(
      .ELEM_WIDTH  ( DATA_WIDTH ),
      .RESET_VALUE ('0)
    ) u_data (
      .clk_i   ( clk_i       ),
      .arst_ni ( arst_ni     ),
      .en_i    ( data_en[i]  ),
      .d_i     ( data_i      ),
      .q_o     ( data[i]     )
    );
  end

endmodule
