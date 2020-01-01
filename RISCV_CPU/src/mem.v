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
    input clk,
    input wire [`RegLen - 1 : 0] rd_data_i,
    input wire [`RegAddrLen - 1 : 0] rd_addr_i,
    input wire [`AddrLen - 1 : 0] mem_addr,
    
    input wire rd_enable_i,
    input wire [3:0] width,

    output reg [`RegLen - 1 : 0] rd_data_o,
    output reg [`RegAddrLen - 1 : 0] rd_addr_o,
    output reg rd_enable_o,

//TO MEMCTRL
    output reg [`AddrLen - 1 : 0] addr_to_mem,
    output reg [`AddrLen - 1 : 0] data_to_mem,
    output reg [2:0] rw_mem,
    output reg [3:0] quantity,

    input wire [`RegLen - 1 : 0] data_from_mem,
    input wire [1:0] mem_status,
    
//DCache 
    input wire cacheHit,
    input wire [`RegLen - 1 : 0] cacheVal,

    input wire [`PipelineDepth - 1 : 0] stall,
    output reg stallreq
    );
    
    reg _stallreq;
        
always @ (posedge clk) begin
    _stallreq <= stallreq;
end

always @ (*) begin
    if (rst == `ResetEnable) begin
        rd_data_o = `ZERO_WORD;
        rd_addr_o = 0;
        rd_enable_o = `WriteDisable;
        stallreq = `StallDisable;
        rw_mem = 2'b00;
        addr_to_mem = `ZERO_WORD;
        quantity = `ZERO_WORD;
        data_to_mem = `ZERO_WORD;
    end
    else if (width == 4'b0000) begin
        rd_data_o = rd_data_i;
        rd_addr_o = rd_addr_i;
        rd_enable_o = rd_enable_i;
        stallreq = `StallDisable;
        rw_mem = 2'b00;
        addr_to_mem = `ZERO_WORD;
        quantity = `ZERO_WORD;
        data_to_mem = `ZERO_WORD;
    end
    else if (width[3] == 1'b0) begin //LOAD
        // $display("%0t %d %d",$time, rd_addr_i, rd_data_i);
        data_to_mem = `ZERO_WORD;
        
        rd_addr_o = rd_addr_i;
        rd_data_o = `ZERO_WORD;
        rd_enable_o = `WriteEnable;
        if (width[2] ^ width[1] ^ width[0] == 1) 
            quantity = width;
        else  
            quantity = width & 4'b0011;
            
        rw_mem = 2'b01;
        addr_to_mem = rd_data_i;
        if (mem_status == `DONE) begin
//            if (width[2] ^ width[1] ^ width[0] == 0) begin //Unsigned extension
//               if (width[0] == 1'b1) //LBU
//                    rd_data_o = { {24{1'b0}} , data_from_mem[7 : 0] };
//               else
//                    rd_data_o = { {16{1'b0}} , data_from_mem[15 : 0] };
//            end
//            else begin //Signed extension
//                if (width[0] == 1'b1) //LB
//                    rd_data_o = $signed(data_from_mem[7 : 0]);
//                else if (width[1] == 1'b1)
//                    rd_data_o = $signed(data_from_mem[15 : 0]);
//                else 
//                    rd_data_o = $signed(data_from_mem[31 : 0]);
//            end
            case (width)
                4'b0001: //LB
                    rd_data_o = $signed(data_from_mem[7 : 0]);
                4'b0010: //LH
                    rd_data_o = $signed(data_from_mem[15 : 0]);
                4'b0100: //LW
                    rd_data_o = $signed(data_from_mem[31 : 0]);
                4'b0101: //LBU
                    rd_data_o = { {24{1'b0}} , data_from_mem[7 : 0] };
                4'b0110: //LHU
                    rd_data_o = { {16{1'b0}} , data_from_mem[15 : 0] };
                default:
                    rd_data_o = 0;
            endcase
            
            stallreq = `StallDisable;
            rw_mem = 2'b00;
        end
        else if (mem_status == `IDLE) begin
            if (cacheHit && width == 4'b0100) begin
                rd_data_o = cacheVal;
                rw_mem = 2'b00;
                stallreq = `StallDisable;
            end
            else begin
                stallreq = `StallEnable;
            end
        end
        else begin
            stallreq = _stallreq;
        end
    end
    else begin //SAVE
        rd_data_o = `ZERO_WORD;
        rd_enable_o = `WriteDisable;
        rd_addr_o = rd_addr_i;
        quantity = width & 4'b0111;
        data_to_mem = rd_data_i;
        addr_to_mem = mem_addr;

        rw_mem = 2'b10;
        if (mem_status == `DONE) begin
            stallreq = `StallDisable;
            rw_mem = 2'b00;    
        end
        else if (mem_status == `IDLE) begin
            stallreq = `StallEnable;
        end
        else begin
            stallreq = _stallreq;
        end
    end
end

endmodule
