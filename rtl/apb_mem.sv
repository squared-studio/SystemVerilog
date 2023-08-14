// ### Author : Foez Ahmed (foez.official@gmail.com)

module apb_mem #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (
    input  wire                  clk_i,
    input  wire                  arst_ni,
    input  wire                  psel_i,
    input  wire                  penable_i,
    input  wire [ADDR_WIDTH-1:0] paddr_i,
    input  wire                  pwrite_i,
    input  wire [DATA_WIDTH-1:0] pwdata_i,
    output wire [DATA_WIDTH-1:0] prdata_o,
    output wire                  pready_o
);

  typedef enum int {
    IDLE,
    SETUP,
    ACCESS
  } state_t;

  state_t                  state;

  logic   [DATA_WIDTH-1:0] mem   [2**ADDR_WIDTH];
  logic   [DATA_WIDTH-1:0] rdata;
  logic                    ready;

  assign prdata_o = (state == ACCESS) ? rdata : 'z;
  assign pready_o = (state == ACCESS) ? ready : 'z;

  assign rdata = mem[paddr_i];

  always_ff @(posedge clk_i or negedge arst_ni) begin

    if (~arst_ni) begin  // RESET
      state <= IDLE;
      ready <= '0;
    end else begin
      if (psel_i) begin
        case (state)
          default: begin
            state <= IDLE;
            ready <= '0;
          end

          IDLE: begin
            if (psel_i & ~penable_i) begin
              state <= SETUP;
              ready <= '0;
            end
          end

          SETUP: begin
            if (penable_i) begin
              state <= ACCESS;
              if (pwrite_i) begin
                mem[paddr_i] <= pwdata_i;
              end
              ready <= '1;
            end
          end

          ACCESS: begin
            if (~psel_i) begin
              state <= IDLE;
              ready <= '0;
            end else if (~penable_i) begin
              state <= SETUP;
              ready <= '0;
            end
          end

        endcase
      end else begin
        state <= IDLE;
        ready <= '0;
      end
    end

  end

endmodule

// TODO