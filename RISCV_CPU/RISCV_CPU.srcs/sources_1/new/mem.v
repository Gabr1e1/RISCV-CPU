`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2019 08:31:41 PM
// Design Name: 
// Module Name: mem
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


module mem(
    input rst,
    input wire [`RegLen - 1 : 0] rd_data_i,
    input wire [`RegAddrLen - 1 : 0] rd_addr_i,
    input wire rd_enable_i,
    input wire [3:0] width,

    output reg [`RegLen - 1 : 0] rd_data_o,
    output reg [`RegAddrLen - 1 : 0] rd_addr_o,
    output reg rd_enable_o,

//TO MEMCTRL
    output reg [`AddrLen - 1 : 0] addr_to_mem,
    output reg [2:0] rw_mem,
    output reg [3:0] quantity,

    input wire [`RegLen - 1 : 0] data_from_mem,
    input wire [1:0] mem_status,

    output reg stallreq
    );

    reg start;
    reg [5:0] digit_cnt;

always @ (*) begin
    if (rst == `ResetEnable) begin
        rd_data_o = `ZERO_WORD;
        rd_addr_o = `RegAddrLen'h0;
        rd_enable_o = `WriteDisable;
        stallreq = `StallDisable;
        start = 1'b0;
    end
    else if (width == 4'b0000) begin
        rd_data_o = rd_data_i;
        rd_addr_o = rd_addr_i;
        rd_enable_o = rd_enable_i;
        stallreq = `StallDisable;
        start = 1'b0;
    end
    else if (width[3] == 1'b0) begin //LOAD
        if (mem_status != `IDLE && start == 1'b0) begin
            stallreq = `StallEnable;
        end
        else if (mem_status == `DONE) begin
            if (width[2] ^ width[1] ^ width[0] == 0) begin //Unsigned extension
               if (width[0] == 1'b1) //LBU
                    rd_data_o = { {24{1'b0}} , data_from_mem[7 : 0] };
               else
                    rd_data_o = { {16{1'b0}} , data_from_mem[15 : 0] };
            end
            else begin //Signed extension
                if (width[0] == 1'b1) //LB
                    rd_data_o = $signed(data_from_mem[7 : 0]);
                else if (width[1] == 1'b1)
                    rd_data_o = $signed(data_from_mem[15 : 0]);
                else 
                    rd_data_o = $signed(data_from_mem[31 : 0]);
            end
            stallreq = `StallDisable;
            start = 1'b0;
        end
        else begin
            addr_to_mem = rd_data_i;
            rw_mem = 2'b01;
            stallreq = `StallEnable;
            start = 1'b1;
            if (width[2] != 1'b1) 
                quantity = width;
            else  
                quantity = width & 4'b0011;
        end
    end
    else if (width[3] == 1'b1) begin //SAVE
        if (mem_status != `IDLE && start == 1'b0) begin
            stallreq = `StallEnable;
        end
        else if (mem_status == `DONE) begin
            rd_enable_o = `WriteDisable;
            stallreq = `StallDisable;
            start = 1'b0;
            rw_mem = 2'b00;
        end
        else begin
            addr_to_mem = rd_data_i;
            rw_mem = 2'b10;
            stallreq = `StallEnable;
            start = 1'b1;
            quantity = width & 4'b0111;
        end
    end
end

endmodule
