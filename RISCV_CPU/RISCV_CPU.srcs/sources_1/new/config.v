`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Gabriel
// 
// Create Date: 10/24/2019 11:41:47 PM
// Design Name: 
// Module Name: config
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define ZERO_WORD 32'h00000000
`define FlushInst 32'h00000001

`define InstLen 32
`define AddrLen 32
`define RegAddrLen 5
`define RegLen 32
`define RegNum 32
`define PipelineDepth 6 //including pc
`define RamWord 8

`define IDLE 2'b00
`define BUSYR 2'b01
`define BUSYW 2'b10
`define WORKING 2'b01
`define DONE 2'b10

`define ResetEnable 1'b1
`define ResetDisable 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define ForwardEnable 1'b1
`define ForwardDisable 1'b0
`define StallEnable 1'b1
`define StallDisable 1'b0
`define FlushEnable 1'b1
`define FlushDisable 1'b0
`define JumpEnable 1'b1
`define JumpDisable 1'b0

//OPCODE
`define OpLen 7
`define Funct3 14:12
`define Funct3Len 3
`define Funct7 31:25
`define Funct7Len 7

`define INTCOM_LUI    7'b0110111
`define INTCOM_AUIPC  7'b0010111
`define INTCOM_REG    7'b0010011
    `define ADDI 3'b000
    `define SLLI 3'b001
    `define SLTI 3'b010
    `define SLTIU 3'b011
    `define XORI 3'b100
    `define SRXI 3'b101
        `define SRLI 7'b0000000
        `define SRAI 7'b0100000 
    `define ORI 3'b110
    `define ANDI 3'b111

`define INTCOM_REGREG 7'b0110011
    `define ADDSUB 3'b000
        `define ADD 7'b0000000
        `define SUB 7'b0100000
    `define SLL 3'b001
    `define SLT 3'b010
    `define SLTIU 3'b011
    `define XOR 3'b100
    `define SRX 3'b101
        `define SRL 7'b0000000
        `define SRA 7'b0100000
    `define OR 3'b110
    `define AND 3'b111
`define LOAD 7'b0000011
    `define LB 3'b000
    `define LH 3'b001
    `define LW 3'b010
    `define LBU 3'b100
    `define LHU 3'b101
`define SAVE 7'b0100011
    `define SB 3'b000
    `define SH 3'b001
    `define SW 3'b010
`define Flushed 7'b0000001
`define JAL 7'b1101111
`define JALR 7'b1100111 
`define BRANCH 7'b1100011
    `define BEQ 3'b000
    `define BNE 3'b001
    `define BLT 3'b100
    `define BGE 3'b101
    `define BLTU 3'b110
    `define BGEU 3'b111

//AluOP
`define OpCodeLen 4
`define OP_LUI 4'b1110
`define OP_AUIPC 4'b1010

`define OP_ADD 4'b0000
`define OP_ADD2 4'b1001
`define OP_SUB 4'b1000
`define OP_SLL 4'b0001
`define OP_SLT 4'b0010
`define OP_SLTU 4'b0011
`define OP_XOR 4'b0100
`define OP_SRL 4'b0101
`define OP_SRA 4'b1101
`define OP_OR 4'b0110
`define OP_AND 4'b0111
`define NOP 4'b1000
`define FlushOp 4'b1111

//AluSelect
`define OpSelLen 3
`define NO_OP 3'b000
`define Arith_OP 3'b001
`define LUI_OP 3'b010
`define AUIPC_OP 3'b011
`define LOAD_OP 3'b100
`define STORE_OP 3'b101
`define JAL_OP 3'b110

//Ctrl
`define CtrlLen 4
`define Ctrl_JAL 4'b0010
`define Ctrl_NOP 4'b1111
`define Ctrl_BEQ 4'b0000
`define Ctrl_BNE 4'b0001
`define Ctrl_BLT 4'b0100
`define Ctrl_BGE 4'b0101
`define Ctrl_BLTU 4'b0110
`define Ctrl_BGEU 4'b0111
`define Ctrl_Flush 4'b1010
//see branch define above

//ICache
`define CacheLen 7
`define CacheSize 128
`define TagLen 8
`define Valid 1'b1
`define Correct 1'b1

//Branch Prediction
`define BHTLen 7
`define BHTSize 128