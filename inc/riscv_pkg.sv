
`ifndef RISCV_PKG_SV
`define RISCV_PKG_SV

package riscv_pkg;

  localparam int NumReg = 32;
  localparam int ImmLen = 64;

  typedef enum logic [7:0] {
    INVALID,
    ADD,
    ADDI,
    ADDIW,
    ADDW,
    AMOADD_D,
    AMOADD_W,
    AMOAND_D,
    AMOAND_W,
    AMOMAX_D,
    AMOMAX_W,
    AMOMAXU_D,
    AMOMAXU_W,
    AMOMIN_D,
    AMOMIN_W,
    AMOMINU_D,
    AMOMINU_W,
    AMOOR_D,
    AMOOR_W,
    AMOSWAP_D,
    AMOSWAP_W,
    AMOXOR_D,
    AMOXOR_W,
    AND,
    ANDI,
    AUIPC,
    BEQ,
    BGE,
    BGEU,
    BLT,
    BLTU,
    BNE,
    CSRRC,
    CSRRCI,
    CSRRS,
    CSRRSI,
    CSRRW,
    CSRRWI,
    DIV,
    DIVU,
    DIVUW,
    DIVW,
    EBREAK,
    ECALL,
    FADD_D,
    FADD_Q,
    FADD_S,
    FCLASS_D,
    FCLASS_Q,
    FCLASS_S,
    FCVT_D_L,
    FCVT_D_LU,
    FCVT_D_Q,
    FCVT_D_S,
    FCVT_D_W,
    FCVT_D_WU,
    FCVT_L_D,
    FCVT_L_Q,
    FCVT_L_S,
    FCVT_LU_D,
    FCVT_LU_Q,
    FCVT_LU_S,
    FCVT_Q_D,
    FCVT_Q_L,
    FCVT_Q_LU,
    FCVT_Q_S,
    FCVT_Q_W,
    FCVT_Q_WU,
    FCVT_S_D,
    FCVT_S_L,
    FCVT_S_LU,
    FCVT_S_Q,
    FCVT_S_W,
    FCVT_S_WU,
    FCVT_W_D,
    FCVT_W_Q,
    FCVT_W_S,
    FCVT_WU_D,
    FCVT_WU_Q,
    FCVT_WU_S,
    FDIV_D,
    FDIV_Q,
    FDIV_S,
    FENCE_I,
    FENCE,
    FEQ_D,
    FEQ_Q,
    FEQ_S,
    FLD,
    FLE_D,
    FLE_Q,
    FLE_S,
    FLQ,
    FLT_D,
    FLT_Q,
    FLT_S,
    FLW,
    FMADD_D,
    FMADD_Q,
    FMADD_S,
    FMAX_D,
    FMAX_Q,
    FMAX_S,
    FMIN_D,
    FMIN_Q,
    FMIN_S,
    FMSUB_D,
    FMSUB_Q,
    FMSUB_S,
    FMUL_D,
    FMUL_Q,
    FMUL_S,
    FMV_D_X,
    FMV_W_X,
    FMV_X_D,
    FMV_X_W,
    FNMADD_D,
    FNMADD_Q,
    FNMADD_S,
    FNMSUB_D,
    FNMSUB_Q,
    FNMSUB_S,
    FSD,
    FSGNJ_D,
    FSGNJ_Q,
    FSGNJ_S,
    FSGNJN_D,
    FSGNJN_Q,
    FSGNJN_S,
    FSGNJX_D,
    FSGNJX_Q,
    FSGNJX_S,
    FSQ,
    FSQRT_D,
    FSQRT_Q,
    FSQRT_S,
    FSUB_D,
    FSUB_Q,
    FSUB_S,
    FSW,
    JAL,
    JALR,
    LB,
    LBU,
    LD,
    LH,
    LHU,
    LR_D,
    LR_W,
    LUI,
    LW,
    LWU,
    MUL,
    MULH,
    MULHSU,
    MULHU,
    MULW,
    OR,
    ORI,
    REM,
    REMU,
    REMUW,
    REMW,
    SB,
    SC_D,
    SC_W,
    SD,
    SH,
    SLL,
    SLLI,
    SLLIW,
    SLLW,
    SLT,
    SLTI,
    SLTIU,
    SLTU,
    SRA,
    SRAI,
    SRAIW,
    SRAW,
    SRL,
    SRLI,
    SRLIW,
    SRLW,
    SUB,
    SUBW,
    SW,
    XOR,
    XORI
  } func_t;

  typedef logic [$clog2(NumReg)-1:0] reg_index_t;

  typedef logic [ImmLen-1:0] imm_t;

  typedef enum logic [2:0] {
    RNE = 0,
    RTZ = 1,
    RDN = 2,
    RUP = 3,
    RMM = 4,
    RM_RES_5 = 5,
    RM_RES_6 = 6,
    DYN = 7
  } rm_t;

  typedef struct packed {
    func_t       func;
    reg_index_t  rs1;
    reg_index_t  rs2;
    reg_index_t  rs3;
    reg_index_t  rd;
    imm_t        imm;
    logic [5:0]  shamt;
    logic [3:0]  fm;
    logic [3:0]  pred;
    logic [3:0]  succ;
    logic        aq;
    logic        rl;
    rm_t         rm;
    imm_t        uimm;
    logic [11:0] csr;
  } decoded_inst_t;

  typedef struct packed {
    logic sign;
    logic [4:0] exponent;
    logic [9:0] mantissa;
  } float16_t;

  typedef struct packed {
    logic sign;
    logic [7:0] exponent;
    logic [22:0] mantissa;
  } float32_t;

  typedef struct packed {
    logic sign;
    logic [10:0] exponent;
    logic [51:0] mantissa;
  } float64_t;

  typedef struct packed {
    logic sign;
    logic [14:0] exponent;
    logic [111:0] mantissa;
  } float128_t;

endpackage

`endif
