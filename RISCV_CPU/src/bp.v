`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/28 17:35:19
// Design Name: 
// Module Name: bp
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


module bp(
    input clk,
    input rst,
    input wire [`AddrLen - 1 : 0] addr,

//replacement related
    input wire [`AddrLen - 1 : 0] addr_r,
    input wire jmp_r,
    input wire [`AddrLen - 1 : 0] real_target,
    input wire change_enable,

    output wire jmp_enable,
    output wire [`AddrLen - 1 : 0] prediction
    );
    
    reg [`InstRealLen - `BHTLen - 2 : 0] tag[`BHTSize - 1 : 0];
    reg [`InstRealLen - 1 : 0] target[`BHTSize - 1 : 0];
    reg [`BHTSize - 1 : 0] cnt;

    assign hit = tag[addr[`BHTLen - 1 + 2 : 2]] == addr[`InstRealLen : `BHTLen + 2];
    assign valid = cnt[addr[`BHTLen - 1 + 2 : 2]] == 1'b1;
    
    assign jmp_enable = valid ? hit : 1'b0;
    assign prediction = target[addr[`BHTLen - 1 + 2 : 2]];

    always @ (posedge clk) begin
        if (rst == `ResetEnable) begin
            cnt <= 0;
        end
        else if (change_enable) begin
//            if (jmp_r == 1'b1) 
//                $display("%0t REPLACE: %h %d %h", $time, addr_r, jmp_r, real_target); 
            tag[addr_r[`BHTLen - 1 + 2 : 2]] <= addr_r[`InstRealLen : `BHTLen + 2];
            target[addr_r[`BHTLen - 1 + 2 : 2]] <= real_target[`InstRealLen - 1 : 0];
            cnt[addr_r[`BHTLen - 1 + 2 : 2]] <= jmp_r;
        end
    end

endmodule
