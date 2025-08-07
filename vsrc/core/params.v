// `define                                RV64 // passing this by verilator
`define          DISPLAY_REG_FILE_FROM_PORT
`define                       VERILATOR_SIM
// `define                   PROC_BRANCH_IN_DC
// `define                BURST_BUFFER_TWO_WAY
`define                     ZICSR_EXTENSION
`define                         M_EXTENSION
`define                         C_EXTENSION
`define                         A_EXTENSION
//`define                        INSTR_BUFFER

`define                           WORD_ZEXT                            32'd0
`define                           MXLEN_BUS                      `XLEN - 1:0

`ifdef RV64
    `define                            XLEN                               64

    `define             BTYPE_IMM_HIGH_ZEXT                            51'd0 
    `define             ITYPE_IMM_HIGH_ZEXT                            52'd0
    `define             JTYPE_IMM_HIGH_ZEXT                            43'd0
    `define             STYPE_IMM_HIGH_ZEXT                            52'd0
    `define             UTYPE_IMM_HIGH_ZEXT                            32'd0

    `define                 RDATA_BYTE_ZEXT                            56'd0
    `define                 RDATA_HALF_ZEXT                            48'd0
    `define                 RDATA_WORD_ZEXT                       `WORD_ZEXT

    `define                        FUNC3_LD                           3'b011
    `define                       FUNC3_LWU                           3'b110

    `define                   OPCODE_ITYPE3                       7'b0011011
    `define                   OPCODE_RTYPE1                       7'b0111011

    `define                     FUNC3_ADDIW                           3'b000
    `define                     FUNC3_SLLIW                           3'b001
    `define                     FUNC7_SRLIW                       7'b0000000 // FUNC3_101 (shamt[5] == 0)
    `define                     FUNC7_SRAIW                       7'b0100000 // FUNC3_101

    `define                      FUNC3_SLLW                           3'b001
    `define                      FUNC7_ADDW                       7'b0000000
    `define                      FUNC7_SUBW                       7'b0100000
    `define                      FUNC7_SRLW                       7'b0000000 // FUNC3_101
    `define                      FUNC7_SRAW                       7'b0100000 // FUNC3_101
    `define                      IS_WORD_OP                             1'b1

    `define                   OPCODE_RTYPE1                       7'b0111011
    `define                      FUNC7_ADDW                       7'b0000000
    `define                      FUNC7_SUBW                       7'b0100000
    `define                      FUNC7_SRLW                       7'b0000000
    `define                      FUNC7_SRAW                       7'b0100000
`else // riscv32
    `define                            XLEN                               32

    `define             BTYPE_IMM_HIGH_ZEXT                            19'd0 
    `define             ITYPE_IMM_HIGH_ZEXT                            20'd0
    `define             JTYPE_IMM_HIGH_ZEXT                            11'd0
    `define             STYPE_IMM_HIGH_ZEXT                            20'd0
    `define             UTYPE_IMM_HIGH_ZEXT                             0'd0 

    `define                 RDATA_BYTE_ZEXT                            24'd0
    `define                 RDATA_HALF_ZEXT                            16'd0
    `define                 RDATA_WORD_ZEXT                             0'd0
`endif          

`define                            INST_BUS                             31:0
`ifdef RV64
    `define            INSTR_ADDR_BUS_WIDTH                               33
    `define          ADDR_TO_XLEN_BUS_WIDTH                               31 // `XLEN - `INSTR_ADDR_BUS_WIDTH ///////////////////////////////////////////////////////////////
    `define               ADDR_TO_XLEN_ZEXT       `ADDR_TO_XLEN_BUS_WIDTH'd0
`else
    `define            INSTR_ADDR_BUS_WIDTH                               32
    `define          ADDR_TO_XLEN_BUS_WIDTH                                0 // `XLEN - `INSTR_ADDR_BUS_WIDTH ///////////////////////////////////////////////////////////////
    `define               ADDR_TO_XLEN_ZEXT       `ADDR_TO_XLEN_BUS_WIDTH'd0
`endif


`define                      INSTR_ADDR_BUS      `INSTR_ADDR_BUS_WIDTH - 1:0
`define                       DATA_ADDR_BUS      `INSTR_ADDR_BUS_WIDTH - 1:0
`define                       PC_RESET_ADDR `INSTR_ADDR_BUS_WIDTH'h8000_0000

`define               INSTR_ADDR_ALIGN_MASK    (~(`INSTR_ADDR_BUS_WIDTH'd1))
`define                        INTER_ID_BUS                              7:0
`define                            RESET_EN                             1'b0
  
`define                                ZERO                                0
`define                             REG_NUM                               32
`define                             REG_BUS                   `REG_NUM - 1:0
`define                       REG_INDEX_BUS                              4:0
`define                            XLEN_BUS                      `XLEN - 1:0

`define                             CSR_BUS                             11:0

`define                         OP_TYPE_BUS                             20:0
`define                              OP_ADD        21'b000000000000000000001
`define                              OP_SUB        21'b000000000000000000010
`define                              OP_NOP        21'b000000000000000000100
`define                               OP_LE        21'b000000000000000001000
`define                                OP_L        21'b000000000000000010000 // Less
`define                               OP_LU        21'b000000000000000100000 // Less (Unsigned)
`define                              OP_XOR        21'b000000000000001000000
`define                              OP_AND        21'b000000000000010000000
`define                               OP_OR        21'b000000000000100000000
`define                              OP_SLL        21'b000000000001000000000
`define                              OP_SRA        21'b000000000010000000000
`define                              OP_SRL        21'b000000000100000000000
`define                            OP_AUIPC        21'b000000001000000000000
`define                              OP_LUI        21'b000000010000000000000
`define                               OP_EQ        21'b000000100000000000000
`define                               OP_NE        21'b000001000000000000000
`define                               OP_GE        21'b000010000000000000000
`define                              OP_GEU        21'b000100000000000000000

`define                        OP_ADD_INDEX                                0
`define                        OP_SUB_INDEX                                1
`define                        OP_NOP_INDEX                                2
`define                         OP_LE_INDEX                                3
`define                          OP_L_INDEX                                4
`define                         OP_LU_INDEX                                5
`define                        OP_XOR_INDEX                                6
`define                        OP_AND_INDEX                                7
`define                         OP_OR_INDEX                                8
`define                        OP_SLL_INDEX                                9
`define                        OP_SRA_INDEX                               10
`define                        OP_SRL_INDEX                               11
`define                      OP_AUIPC_INDEX                               12
`define                        OP_LUI_INDEX                               13
`define                         OP_EQ_INDEX                               14
`define                         OP_NE_INDEX                               15
`define                         OP_GE_INDEX                               16
`define                        OP_GEU_INDEX                               17


`ifdef M_EXTENSION
`define                              OP_MUL        21'b001000000000000000000
`define                              OP_DIV        21'b010000000000000000000

`define                        OP_MUL_INDEX                               18
`define                        OP_DIV_INDEX                               19

`ifdef A_EXTENSION
    `define                         OP_SWAP        21'b100000000000000000000
`endif

`ifdef A_EXTENSION
    `define                   OP_SWAP_INDEX                               20
`endif

`define                          FUNC7_MEXT                       7'b0000001


`define                        MUL_TYPE_BUS                              2:0
`define                        MUL_MUL_TYPE                           3'b000
`define                       MUL_MULH_TYPE                           3'b001
`define                     MUL_MULHSU_TYPE                           3'b010
`define                      MUL_MULHU_TYPE                           3'b011
`define                       MUL_MULW_TYPE                           3'b100
`define                        NOT_MUL_TYPE                           3'b101

`define                          WORD_FIELD                 `WORD_SIGN_BIT:0

`define                        DIV_TYPE_BUS                              2:0
`define                        DIV_DIV_TYPE                           3'b000
`define                       DIV_DIVU_TYPE                           3'b001
`define                        DIV_REM_TYPE                           3'b010
`define                       DIV_REMU_TYPE                           3'b011
`define                       DIV_DIVW_TYPE                           3'b100
`define                      DIV_DIVUW_TYPE                           3'b101
`define                       DIV_REMW_TYPE                           3'b110
`define                      DIV_REMUW_TYPE                           3'b111

`define                           DIV_START                             1'b1
`define                             DIV_FIN                             1'b1

`endif

`define                           BOOL_TRUE                             1'b1
`define                          BOOL_FALSE                    (!`BOOL_TRUE)

`define                    BTYPE_IMM_FIELD0                               31 // imm[12]
`define                    BTYPE_IMM_FIELD1                                7 // imm[11]
`define                    BTYPE_IMM_FIELD2                            30:25 // imm[10:5]
`define                    BTYPE_IMM_FIELD3                             11:8 // imm[4:1]
`define                     ITYPE_IMM_FIELD                            31:20 // imm[11:0]
`define                    JTYPE_IMM_FIELD0                               31 // imm[20]
`define                    JTYPE_IMM_FIELD1                            19:12 // imm[19:12]
`define                    JTYPE_IMM_FIELD2                               20 // imm[11]
`define                    JTYPE_IMM_FIELD3                            30:21 // imm[10:1]
`define                    STYPE_IMM_FIELD0                            31:25 // imm[11:5]
`define                    STYPE_IMM_FIELD1                             11:7 // imm[4:0]
`define                     UTYPE_IMM_FIELD                            31:12 // imm[31:12]

`define                  BTYPE_IMM_LOW_ZEXT                             1'b0 // btype imm[0] = 0
`define                  JTYPE_IMM_LOW_ZEXT                             1'b0 // jtype imm[0] = 0
`define                  UTYPE_IMM_LOW_ZEXT                          12'h000 // utype imm[11:0] = 0


`define                         FUNC7_FIELD                            31:25
`define                         FUNC6_FIELD                            31:26
`ifdef A_EXTENSION
    `define                     FUNC5_FIELD                            31:27    
`endif 
`define                           RS2_FIELD                            24:20
`define                           RS1_FIELD                            19:15
`define                         FUNC3_FIELD                            14:12
`define                            RD_FIELD                             11:7
`define                  INSTR_OPCODE_FIELD                              6:0

`define                           CSR_FIELD                            31:20 // csr
`define                          UIMM_FIELD                            19:15

`define                           FUNC3_BUS                              2:0
`define                           FUNC7_BUS                              6:0
`define                           FUNC6_BUS                              5:0
`ifdef A_EXTENSION
    `define                       FUNC5_BUS                              4:0    
`endif 

`define                        IMM_SIGN_BIT                               31

`define                      INSTR_BYTE_NUM                                4

`define                        OPCODE_BTYPE                       7'b1100011 // branch: beq/bge/bgeu/blt/bltu/bne
`define                       OPCODE_ITYPE0                       7'b0010011
`define                       OPCODE_ITYPE1                       7'b0000011 // load: lb/lw/lbu/lh/lhu
`define                       OPCODE_ITYPE2                       7'b1100111 // jalr

`define                       OPCODE_RTYPE0                       7'b0110011

`ifdef M_EXTENSION
`define                       OPCODE_RTYPE1                       7'b0111011
`define                           IS_OP_DIV                             1'b1
    `ifdef RV64
`define                      DWORD_SIGN_BIT                               63
`define                        DIV_LOW_ZEXT                        63'd`ZERO
    `else
`define                        DIV_LOW_ZEXT                        31'd`ZERO   
    `endif
`endif

`define                       OPCODE_UTYPE0                       7'b0010111 // auipc
`define                       OPCODE_UTYPE1                       7'b0110111 // lui
`define                        OPCODE_JTYPE                       7'b1101111 // jal
`define                       OPCODE_STYPE0                       7'b0100011 // branch
`define                       OPCODE_STYPE1                       7'b0100011 // store
`define                      OPCODE_SYSTYPE                       7'b1110011 // csr / ecall / ebreak

`define                               BTYPE            17'b00000000000000001
`define                               ITYPE            17'b00000000000000010
`define                               JTYPE            17'b00000000000000100
`define                               RTYPE            17'b00000000000001000
`define                               STYPE            17'b00000000000010000
`define                               UTYPE            17'b00000000000100000
`define                             SYSTYPE            17'b00000000001000000
`define                              UKTYPE            17'b00000000010000000 // unknown type

`define                         BTYPE_INDEX                                0
`define                         ITYPE_INDEX                                1
`define                         JTYPE_INDEX                                2
`define                         RTYPE_INDEX                                3
`define                         STYPE_INDEX                                4
`define                         UTYPE_INDEX                                5
`define                       SYSTYPE_INDEX                                6
`define                        UKTYPE_INDEX                                7 // unknown type

`define                           FUNC3_BEQ                           3'b000
`define                           FUNC3_BNE                           3'b001
`define                           FUNC3_BLT                           3'b100
`define                           FUNC3_BGE                           3'b101
`define                          FUNC3_BLTU                           3'b110
`define                          FUNC3_BGEU                           3'b111

`define                            FUNC3_LB                           3'b000
`define                            FUNC3_LH                           3'b001
`define                            FUNC3_LW                           3'b010
`define                           FUNC3_LBU                           3'b100
`define                           FUNC3_LHU                           3'b101


`define                            FUNC3_SB                           3'b000
`define                            FUNC3_SH                           3'b001
`define                            FUNC3_SW                           3'b010
`define                            FUNC3_SD                           3'b011

`define                          FUNC3_ADDI                           3'b000
`define                          FUNC3_SLLI                           3'b001
`define                          FUNC3_SLTI                           3'b010
`define                         FUNC3_SLTIU                           3'b011
`define                          FUNC3_XORI                           3'b100
`define                           FUNC3_ORI                           3'b110
`define                          FUNC3_ANDI                           3'b111


`define                           FUNC3_000                           3'b000 // add/sub
`define                           FUNC3_001                           3'b001 // 
`define                           FUNC3_010                           3'b010 // slt
`define                           FUNC3_011                           3'b011 // sltu
`define                           FUNC3_100                           3'b100 // xor
`define                           FUNC3_101                           3'b101 // srai/srli
`define                           FUNC3_110                           3'b110 // or
`define                           FUNC3_111                           3'b111 // and

`define                         FUNC3_CSRRW                       `FUNC3_001
`define                         FUNC3_CSRRS                       `FUNC3_010
`define                         FUNC3_CSRRC                       `FUNC3_011
`define                        FUNC3_CSRRWI                       `FUNC3_101
`define                        FUNC3_CSRRSI                       `FUNC3_110
`define                        FUNC3_CSRRCI                       `FUNC3_111

`define                           FUNC7_ADD                       7'b0000000
`define                           FUNC7_SUB                       7'b0100000
`define                          FUNC6_SRLI                        6'b000000
`define                          FUNC6_SRAI                        6'b010000
`define                           FUNC7_SRL                       7'b0000000
`define                           FUNC7_SRA                       7'b0100000

`define                            W_REG_EN                             1'b1
`define                            W_CSR_EN                             1'b1

`define                        CTRL_SIG_BUS                              5:0 ////////////////////////
`define                         W_REG_INDEX                                0
`define                     W_REG_SRC_INDEX                                1
`define                    OP_SEL_RS1_INDEX                                2
`define                    OP_SEL_RS2_INDEX                                3
`define        IS_LOAD_OR_STORE_INSTR_INDEX                                4
`define                       IS_JALR_INDEX                                5
  
`define                         IS_FROM_ALU                             1'b1
`define              IS_LOAD_OR_STORE_INSTR                             1'b1
  
`define                          OP_SEL_RS1                                0
`define                          OP_SEL_RS2                                0

`ifdef RV64
    `define                  SHIFT_BITS_BUS                              5:0
`else
    `define                  SHIFT_BITS_BUS                              4:0
`endif
`define                      MASK_FULL_ZERO                         `XLEN'd0
`define                       MASK_FULL_ONE                 ~`MASK_FULL_ZERO
`define                     SHAMT_WORD_MASK                        6'b011111

`define                       INST_TYPE_BUS                              16:0

`define                       BYTE_SIGN_BIT                                7
`define                       HALF_SIGN_BIT                               15
`define                       WORD_SIGN_BIT                               31

`define                    RDATA_BYTE_FIELD                 `BYTE_SIGN_BIT:0
`define                    RDATA_HALF_FIELD                 `HALF_SIGN_BIT:0
`define                    RDATA_WORD_FIELD                 `WORD_SIGN_BIT:0

`define                            WORD_BUS                 `WORD_SIGN_BIT:0

`define                            WLEN_BUS                              3:0
`define                           WLEN_BYTE                          4'b0001 // 1 byte
`define                           WLEN_HALF                          4'b0010 // 2 bytes
`define                           WLEN_WORD                          4'b0100 // 4 bytes
`define                          WLEN_DWORD                          4'b1000 // 8 bytes

`define                            RLEN_BUS                              3:0
`define                           RLEN_BYTE                          4'b0001 // 1 byte
`define                           RLEN_HALF                          4'b0010 // 2 bytes
`define                           RLEN_WORD                          4'b0100 // 4 bytes
`define                          RLEN_DWORD                          4'b1000 // 8 bytes

`define                         TAKE_BRANCH                         `XLEN'd1 // This is for sigle cycle RV
`define                         NTTK_BRANCH                         `XLEN'd0 // not taken branch

`define                               TAKEN                             1'd1 // This is for sigle cycle RV
`define                               NTTKN                             1'd0 // not taken branch

`define                             IS_JALR                             1'b1

`define                             IS_LOAD                             1'b1
`define                                HOLD                             1'b1

`define                        CANCEL_INSTR                             1'b1

`ifdef ZICSR_EXTENSION
    `define                    MVENDORID_ID                          12'hf11
    `define                      MARCHID_ID                          12'hf12
    `define                       MIMPID_ID                          12'hf13
    `define                      MHARTID_ID                          12'hf14

    `define                      MSTATUS_ID                          12'h300
    `define                         MISA_ID                          12'h301
    `define                          MIE_ID                          12'h304
    `define                        MTVEC_ID                          12'h305
    `define                     MSCRATCH_ID                          12'h340
    `define                         MEPC_ID                          12'h341
    `define                       MCAUSE_ID                          12'h342
    `define                        MTVAL_ID                          12'h343
    `define                          MIP_ID                          12'h344

    `define                     MINSTRET_ID                          12'hb02
    

    `define                         CSR_WOP                           3'b001
    `define                         CSR_SOP                           3'b010
    `define                         CSR_COP                           3'b011
    `define                        CSR_WIOP                           3'b101
    `define                        CSR_SIOP                           3'b110
    `define                        CSR_CIOP                           3'b111

    `define                    CSR_UIMM_BUS                              4:0
    `define                 CSR_OP_TYPE_BUS                              2:0
    `ifdef RV64
        `define               CSR_UIMM_ZEXT                        59'd`ZERO
    `else
        `define               CSR_UIMM_ZEXT                        27'd`ZERO
    `endif
    `define                  CSR_UIMM_FIELD                       `RS1_FIELD
    `define               CSR_OP_TYPE_FIELD                     `FUNC3_FIELD

    `ifdef RV64
        `define                   MCYCLE_ID                          12'hb00
        `define                    CYCLE_ID                          12'hc00
    `else
        `define                   MCYCLE_ID                          12'hb00
        `define                  MCYCLEH_ID                          12'hb80
        `define                    CYCLE_ID                          12'hc00
        `define                   CYCLEH_ID                          12'hc80
    `endif

    `define                 CSR_INSTR_IN_WB                             1'b1

    `ifdef RV64
        `define            MSTATUS_SD_FIELD                               63
        `define           MSTATUS_MBE_FIELD                               37
        `define           MSTATUS_SBE_FIELD                               36
        `define           MSTATUS_SXL_FIELD                            35:34
        `define           MSTATUS_UXL_FIELD                            33:32
    `else
        `define            MSTATUS_SD_FIELD                               31
    `endif
    
    `define               MSTATUS_TSR_FIELD                               22
    `define                MSTATUS_TW_FIELD                               21
    `define               MSTATUS_TVM_FIELD                               20
    `define               MSTATUS_MXR_FIELD                               19
    `define               MSTATUS_SUM_FIELD                               18
    `define              MSTATUS_MPRV_FIELD                               17
    `define                MSTATUS_XS_FIELD                            16:15
    `define                MSTATUS_FS_FIELD                            14:13
    `define               MSTATUS_MPP_FIELD                            12:11
    `define                MSTATUS_VS_FIELD                             10:9
    `define               MSTATUS_SPP_FIELD                                8
    `define              MSTATUS_MPIE_FIELD                                7
    `define               MSTATUS_UBE_FIELD                                6
    `define              MSTATUS_SPIE_FIELD                                5
    `define               MSTATUS_MIE_FIELD                                3
    `define               MSTATUS_SIE_FIELD                                1

    `define                      INT_ENABLE                             1'b1
    `define                     INT_DISABLE                     !`INT_ENABLE
    `define                  IS_ECALL_INSTR                             1'b1
    `define                   IS_MRET_INSTR                             1'b1
    `define                           ECALL                     32'h00000073
    `define                            MRET                     32'h30200073
`endif

`ifdef C_EXTENSION
        `define                   IS_CINSTR                             1'b1

        `define                      CRTYPE            17'b10000000000000000
        `define                      CITYPE            17'b01000000000000000 
        `define                     CSSTYPE            17'b00100000000000000
        `define                     CIWTYPE            17'b00010000000000000
        `define                      CLTYPE            17'b00001000000000000 
        `define                      CSTYPE            17'b00000100000000000 
        `define                      CATYPE            17'b00000010000000000 
        `define                      CBTYPE            17'b00000001000000000 
        `define                      CJTYPE            17'b00000000100000000 

        `define                CRTYPE_INDEX                               16
        `define                CITYPE_INDEX                               15 
        `define               CSSTYPE_INDEX                               14
        `define               CIWTYPE_INDEX                               13
        `define                CLTYPE_INDEX                               12 
        `define                CSTYPE_INDEX                               11 
        `define                CATYPE_INDEX                               10 
        `define                CBTYPE_INDEX                                9 
        `define                CJTYPE_INDEX                                8 

        `define             CINSTR_BYTE_NUM                                2   
`endif

`define                     IS_BRANCH_INSTR                             1'b1
`define                      FLUSH_PIPELINE                             1'b1
`define                          DATA_VALID                             1'b1


`define                       MACHINE_LEVEL                            2'b11
`define                    SUPERVISOR_LEVEL                            2'b01
`define                          USER_LEVEL                            2'b00

// uart
`define                           UART_ADDR  `INSTR_ADDR_BUS_WIDTH'h10000000

// clint
`define                     MTIME_BUS_WIDTH                               64
`define                          MTIME_ADDR   `INSTR_ADDR_BUS_WIDTH'h200bff8
`define                       MTIMECMP_ADDR   `INSTR_ADDR_BUS_WIDTH'h2004000
`define                           MTIME_BUS           `MTIME_BUS_WIDTH - 1:0
`define                      TIME_INTERRUPT                             1'b1
`define                    INT_UNDER_HANDLE                             1'b1

// plic
`define                  EXTERNAL_INTERRUPT                             1'b1
`define        EXTERNAL_DEVICE_PRIORITY_BUS                             31:0
`define                  PLIC_THRESHOLD_BUS                             31:0
`define                  CLAIM_COMPLETE_BUS                             31:0
`define                    PLIC_PENDING_BUS                             63:0
`define                     PLIC_ENABLE_BUS                             63:0
`define                   UART_PENDING_MASK                       (~(64'h2))
`define                      PLIC_BASE_ADDR  `INSTR_ADDR_BUS_WIDTH'h0c000000
`define                         UART_IRQ_ID                                1
`define                  UART_PRIORITY_ADDR  `INSTR_ADDR_BUS_WIDTH'h0c000004
`define                 PLIC_THRESHOLD_ADDR  `INSTR_ADDR_BUS_WIDTH'h0c200000
`define                 CLAIM_COMPLETE_ADDR  `INSTR_ADDR_BUS_WIDTH'h0c200000 // base addr: irq == 0 do not exist
`define                 UART_CLAIM_COMPLETE  `INSTR_ADDR_BUS_WIDTH'h0c200004
`define                   PLIC_PENDING_ADDR  `INSTR_ADDR_BUS_WIDTH'h0c001000
`define                    PLIC_ENABLE_ADDR  `INSTR_ADDR_BUS_WIDTH'h0c002000
`define                          PLIC_READY                             1'b1
`define                             PENDING                             1'b1

`define                     INTERRUPT_TAKEN                             1'b1


// parameter about cache
`define                               CACHE
`define                           CACHE_HIT                             1'b1
`define                 CACHE_TAG_BUS_WIDTH            `INSTR_ADDR_BUS_WIDTH - (`ENTRY_INDEX_BUS_WIDTH + 3)
`define               ENTRY_INDEX_BUS_WIDTH                                7 // parameter about cache size (only)
`define                           ENTRY_NUM      (1<<`ENTRY_INDEX_BUS_WIDTH)
`define                           ENTRY_BUS               (`ENTRY_NUM - 1):0 // `ENTRY_NUM - 1:0 // 128 entries
`define                     CACHE_TAG_FIELD      (`INSTR_ADDR_BUS_WIDTH - 1):(`ENTRY_INDEX_BUS_WIDTH + 3)
`define                   CACHE_ENTRY_FIELD   (`ENTRY_INDEX_BUS_WIDTH + 2):3
`define                     ENTRY_INDEX_BUS   (`ENTRY_INDEX_BUS_WIDTH - 1):0
`define                       CACHE_TAG_BUS     (`CACHE_TAG_BUS_WIDTH - 1):0 ////// data_bus width - 10
`define                    CACHE_LINE_WIDTH                               64
`define                      CACHE_LINE_BUS        (`CACHE_LINE_WIDTH - 1):0 // cache line width == 64, 8 Byte
`define                    CACHE_LINE_VALID                             1'b1
`define                      CACHE_PLRU_BUS                              2:0
`define                              WDIRTY                             1'b1
`define                    CACHE_LINE_DIRTY                             1'b1
`define                      CACHE_WAY_FULL                             1'b1
`define                            RW_TWICE                             1'b1
////////////////////////////////////////////////////////////////////////////

`define                    INSTR0_INDEX_BUS                             31:0
`define                    INSTR1_INDEX_BUS                            47:16
`define                    INSTR2_INDEX_BUS                            63:32
`define                   INSTRC0_INDEX_BUS                             15:0
`define                   INSTRC1_INDEX_BUS                            31:16
`define                   INSTRC2_INDEX_BUS                            47:32
`define                  INSTRC02_INDEX_BUS                             47:0
`define                  INSTRC13_INDEX_BUS                            63:16

`define                       AUX_CAN_ISSUE                             1'b1
`define                       SEL_INSTR_AUX                             1'b1


`define                        IS_CACHE_MEM                             1'b1

`define                        FENCEI_INSTR                     32'h0000100f

`ifdef A_EXTENSION
    `define                   AMO_STAGE_BUS                              1:0
    `define                  AMO_STAGE_IDLE                            2'b00
    `define                  AMO_STAGE_READ                            2'b01
    `define                  AMO_STAGE_WRTE                            2'b10
    `define                  AMO_STAGE_FNSH                            2'b11
    `define                    IS_AMO_INSTR                             1'b1
    `define                        LR_VALID                             1'b1
    `define                     SC_FAIL_VAL                                1
    `define                     SC_SUCC_VAL                            `ZERO
`endif 

// Interact with C testbench, should also define in CPP
`define                         RDATA_VALID                             1'b1
`define                         INSTR_VALID                     `RDATA_VALID
`define                        COMMIT_INSTR                             1'b1
`define                         WDATA_READY                             1'b1
`define                            WDATA_EN                             1'b1
`define                            RDATA_EN                             1'b1

