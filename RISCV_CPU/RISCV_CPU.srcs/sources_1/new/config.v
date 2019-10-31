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

`define InstLen 32
`define AddrLen 32
`define RegAddrLen 5
`define RegLen 32
`define RegNum 32


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


`define RAM_SIZE 100
`define RAM_SIZELOG2 17

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

//AluOP
`define OpCodeLen 4
`define EXE_ADD 4'b0000
`define EXE_SUB 4'b1000
`define EXE_SLL 4'b0001
`define EXE_SLT 4'b0010
`define EXE_SLTU 4'b0011
`define EXE_XOR 4'b0100
`define EXE_SRL 4'b0101
`define EXE_SRA 4'b1101
`define EXE_OR 4'b0110
`define EXE_AND 4'b0111

//AluSelect
`define OpSelLen 3
`define LOGIC_OP 3'b001