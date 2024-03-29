// ### Author : Foez Ahmed (foez.official@gmail.com)

module var_fifo #(
    parameter int ELEM_WIDTH = 8,
    parameter int NUM_ELEM   = 128,
    parameter int FIFO_DEPTH = 2 * NUM_ELEM
) (
    input logic clk_i,
    input logic arst_ni,

    input  logic [$clog2(NUM_ELEM+1)-1:0] data_in_num_lanes_i,
    input  logic [  $clog2(NUM_ELEM)-1:0] data_in_start_lane_i,
    output logic                          data_in_req_valid_o,

    input  logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_in_i,
    input  logic                                data_in_valid_i,
    output logic                                data_in_ready_o,

    input  logic [$clog2(NUM_ELEM+1)-1:0] data_out_num_lanes_i,
    input  logic [  $clog2(NUM_ELEM)-1:0] data_out_start_lane_i,
    output logic                          data_out_req_valid_o,

    output logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_out_o,
    output logic                                data_out_valid_o,
    input  logic                                data_out_ready_i,

    output logic [$clog2(FIFO_DEPTH+1)-1:0] space_available_o,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] elem_available_o
);

  logic [$clog2(NUM_ELEM+1)-1:0] wr_ptr;
  logic [$clog2(NUM_ELEM+1)-1:0] rd_ptr;
  logic [$clog2(NUM_ELEM+1)-1:0] wr_ptr_next;
  logic [$clog2(NUM_ELEM+1)-1:0] rd_ptr_next;
  logic [$clog2(FIFO_DEPTH+1)-1:0] elem_available_next;
  logic [$clog2(FIFO_DEPTH+1)-1:0] num_data_ins;
  logic [$clog2(FIFO_DEPTH+1)-1:0] num_data_outs;

  logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_in_x;
  logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_out_x;

  logic in_handshake;
  logic out_handshake;

  logic [FIFO_DEPTH-1:0][ELEM_WIDTH-1:0] mem;

  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] data_in_xbar_select;
  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] data_out_xbar_select;

  assign data_in_req_valid_o = ((data_in_start_lane_i + data_in_num_lanes_i) > NUM_ELEM) ? '0 : '1;

  assign data_in_ready_o =
    data_in_req_valid_o ? ((space_available_o < data_in_num_lanes_i) ? '0 : '1) : '0;

  assign data_out_req_valid_o =
    ((data_out_start_lane_i + data_out_num_lanes_i) > NUM_ELEM) ? '0 : '1;

  assign data_out_valid_o =
    data_out_req_valid_o ? ((elem_available_o<data_out_num_lanes_i) ? '0 : '1) : '0;

  assign space_available_o = FIFO_DEPTH - elem_available_o;

  assign in_handshake = data_in_valid_i & data_in_ready_o;
  assign out_handshake = data_out_valid_o & data_out_ready_i;

  assign num_data_ins = in_handshake ? data_in_num_lanes_i : '0;
  assign num_data_outs = out_handshake ? data_out_num_lanes_i : '0;

  assign elem_available_next = elem_available_o + num_data_ins - num_data_outs;

  assign wr_ptr_next =
    ((wr_ptr+data_in_num_lanes_i)<FIFO_DEPTH) ? (wr_ptr+data_in_num_lanes_i) :
      ((wr_ptr+data_in_num_lanes_i)-FIFO_DEPTH);

  assign rd_ptr_next =
    ((rd_ptr+data_out_num_lanes_i)<FIFO_DEPTH) ? (rd_ptr+data_out_num_lanes_i) :
      ((rd_ptr+data_out_num_lanes_i)-FIFO_DEPTH);

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_data_in_xbar_select
    assign data_in_xbar_select[i] = i + data_in_start_lane_i;
  end

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_data_out_xbar_select
    assign data_out_xbar_select [i] =
      (i < data_out_start_lane_i) ? ((i+NUM_ELEM) - data_out_start_lane_i) :
        (i - data_out_start_lane_i);
  end

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_data_out_x
    assign data_out_x[i] = mem[((rd_ptr+i)<FIFO_DEPTH)?(rd_ptr+i) : ((rd_ptr+i)-FIFO_DEPTH)];
  end

  xbar #(
      .ELEM_WIDTH(ELEM_WIDTH),
      .NUM_ELEM  (NUM_ELEM)
  ) xbar_data_in (
      .select_i (data_in_xbar_select),
      .inputs_i (data_in_i),
      .outputs_o(data_in_x)
  );

  xbar #(
      .ELEM_WIDTH(ELEM_WIDTH),
      .NUM_ELEM  (NUM_ELEM)
  ) xbar_data_out (
      .select_i (data_out_xbar_select),
      .inputs_i (data_out_x),
      .outputs_o(data_out_o)
  );

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      elem_available_o <= '0;
      wr_ptr <= '0;
      rd_ptr <= '0;
    end else begin
      elem_available_o <= elem_available_next;
      if (in_handshake) begin
        wr_ptr <= wr_ptr_next;
        for (int i = 0; i < NUM_ELEM; i++) begin
          if (i < data_in_num_lanes_i) begin
            mem[wr_ptr+i] <= data_in_x[i];
          end
        end
      end
      if (out_handshake) begin
        rd_ptr <= rd_ptr_next;
      end
    end
  end

endmodule

// TODO
