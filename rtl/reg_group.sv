module reg_group #(
  parameter int TAG_BITS   = 51,
  parameter int DATA_WIDTH = 1024
)(
  input logic clk_i,
  input logic arst_ni,
  input logic row_sel,

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

  input logic [DATA_WIDTH/8-1:0][7:0] data_i,
  input logic [DATA_WIDTH/8:0] data_en,
  output logic [DATA_WIDTH/8-1:0][7:0] data
);

  logic tag_en_i;
  logic val_en_i;
  logic dirty_en_i;
  logic evp_en_i;
  logic [DATA_WIDTH/8:0] data_en_i;

  assign tag_en_i   = tag_en & row_sel;
  assign val_en_i   = val_en & row_sel;
  assign dirty_en_i = dirty_en & row_sel;
  assign evp_en_i   = evp_en & row_sel;
  assign data_en_i  = data_en & row_sel;
  
  register #(
  .ELEM_WIDTH  (TAG_BITS ),
  .RESET_VALUE ('0)
  ) u_tag (
    .clk_i   ( clk_i    ),
    .arst_ni ( arst_ni  ),
    .en_i    ( tag_en_i ),
    .d_i     ( tag_i    ),
    .q_o     ( tag      )
  );

  register #(
    .ELEM_WIDTH  ( 1 ),
    .RESET_VALUE ('0)
  ) u_valid (
    .clk_i   ( clk_i    ),
    .arst_ni ( arst_ni  ),
    .en_i    ( val_en_i ),
    .d_i     ( val_i    ),
    .q_o     ( val      )
  );

  register #(
    .ELEM_WIDTH  ( 1 ),
    .RESET_VALUE ('0)
  ) u_dirty (
    .clk_i   ( clk_i      ),
    .arst_ni ( arst_ni    ),
    .en_i    ( dirty_en_i ),
    .d_i     ( dirty_i    ),
    .q_o     ( dirty      )
  );

  register #(
    .ELEM_WIDTH  ( 1 ),
    .RESET_VALUE ('0)
  ) u_evp (
    .clk_i   ( clk_i     ),
    .arst_ni ( arst_ni   ),
    .en_i    ( evp_en_i  ),
    .d_i     ( evp_i     ),
    .q_o     ( evp       )
  );

  for (genvar i = 0; i<(DATA_WIDTH/8); i++)
  begin : g_reg_data_array
    register #(
      .ELEM_WIDTH  ( DATA_WIDTH ),
      .RESET_VALUE ('0)
    ) u_data (
      .clk_i   ( clk_i        ),
      .arst_ni ( arst_ni      ),
      .en_i    ( data_en_i[i] ),
      .d_i     ( data_i       ),
      .q_o     ( data[i]      )
    );
  end

endmodule
