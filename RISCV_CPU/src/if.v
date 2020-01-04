`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2019 01:20:44 PM
// Design Name: 
// Module Name: if_stage
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


module if_stage(
    input wire rst,
    input wire clk,
    input wire [`AddrLen - 1 : 0] pc,
    input wire [`AddrLen - 1 : 0] npc,

    output wire [`AddrLen - 1 : 0] pc_o,
    
    output reg [`InstLen - 1 : 0] inst,
    
//    output reg [`InstLen - 1 : 0] addr_to_mem,
    output reg rw,  
    input wire [`RegLen - 1 : 0] data_from_mem,
    input wire [1:0] mem_status,
//Cache 
    input wire cacheHit,
    input wire [`RegLen - 1 : 0] cacheVal,
    
    input wire [`PipelineDepth - 1 : 0] stall,
    input wire enable_pc,
    output reg stallreq,

    input wire btb_hit,
    input wire [`AddrLen - 1 : 0] btb_pred,
    output reg [`AddrLen - 1 : 0] prediction,
    output reg pred_enable
    );
        
    reg [`InstLen - 1 : 0] _inst;
    reg _stallreq, _rw;
    
    assign isLoad = (_inst[`OpLen - 1 : 0] == `LOAD);
    assign pc_o = pc;

always @ (posedge clk) begin
    _inst <= inst;
    _stallreq <= stallreq;
    _rw <= rw;
end

always @ (*) begin
    if (rst == `ResetEnable) begin
        rw = 1'b0;
        stallreq = `StallDisable;
        inst = `ZERO_WORD;
        pred_enable = 1'b0;
        prediction = 0;
    end
    else begin
        pred_enable = 1'b0;
        prediction = npc; //pc + 4;
        if (mem_status == `DONE) begin
            rw = 1'b0;
            inst = data_from_mem;
            stallreq = `StallDisable;
            
            if (btb_hit) begin
                pred_enable = 1'b1;
                prediction = btb_pred;
            end
        end
        else if (mem_status == `IDLE && enable_pc) begin
            if (1'b1) begin //(!cacheHit) || isLoad) begin
                rw = 1'b1;
                stallreq = `StallEnable;
                inst = _inst;
            end
            else begin
                inst = cacheVal;
                stallreq = `StallDisable;
                rw = 1'b0;
                if (btb_hit) begin
                    pred_enable = 1'b1;
                    prediction = btb_pred;
                end
            end
        end
        else begin
            inst = _inst;
            stallreq = _stallreq;
            rw = _rw;
        end
    end
end

endmodule
