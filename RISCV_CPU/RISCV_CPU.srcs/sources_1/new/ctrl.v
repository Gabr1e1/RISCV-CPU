`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2019 04:59:04 PM
// Design Name: 
// Module Name: ctrl
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


module ctrl(
    input wire rst,
    input wire clk,
//    input wire stallreq,
    input wire stallreq_if,
    input wire stallreq_mem,
    output reg [`PipelineDepth - 1 : 0] stall,

//Flush
    input wire jmp_enable,
    input wire if_flushed,
    input wire id_flushed,
    output reg flush_if,
    output reg flush_id
    );

    always @ (*) begin
        if (rst == `ResetEnable) begin
            stall = `PipelineDepth'b000000; //from msb to lsb!!!
        end 
        else if (stallreq_mem == `StallEnable) begin
            stall = `PipelineDepth'b011111;
        end
        else if (stallreq_if == `StallEnable) begin
            stall = `PipelineDepth'b000011;
        end
        else begin
            stall = `PipelineDepth'b000000;
        end 
    end

    reg _flush_if, _flush_id;
    
    always @ (posedge clk) begin
        _flush_if <= flush_if;
        _flush_id <= flush_id;
    end
    
    always @ (*) begin
        if (rst == `ResetEnable) begin
            flush_if = `FlushDisable;
            flush_id = `FlushDisable;
        end
        else begin
            if (jmp_enable) begin
                flush_if = `FlushEnable;
                flush_id = `FlushEnable;
            end
            else begin
                flush_if = _flush_if;
                flush_id = _flush_id; 
            end
                
            if (if_flushed)
                flush_if = `FlushDisable;
                
            if (id_flushed)
                flush_id = `FlushDisable;
       end
    end
    
endmodule
