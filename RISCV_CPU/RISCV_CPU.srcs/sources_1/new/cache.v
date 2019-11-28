`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/26 22:30:02
// Design Name: 
// Module Name: cache
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


module cache(
    input wire rst,
    input wire [`AddrLen - 1 : 0] addr,
    input wire [`AddrLen - 1 : 0] data_r,
    input wire replace,

    output wire [`RegLen - 1 : 0] data,
    output wire isCorrect,
    output wire isValid
    );

    reg [`AddrLen - 1 : 0] entry[`CacheSize - 1 : 0];
    reg [`TagLen - 1 : 0] tag[`CacheSize - 1 : 0];
    reg [`CacheSize - 1 : 0] valid; //not initialized 

    assign data = entry[addr[`CacheLen - 1 + 2 : 2]];
    assign isCorrect = (valid[addr[`CacheLen - 1 + 2 : 2]] == `Valid)
                    && (tag[addr[`CacheLen - 1 + 2 : 2]] == addr[16 : `CacheLen + 2]);
    assign isValid = valid[addr[`CacheLen - 1 + 2 : 2]] == `Valid;
    
    integer i;
    
    always @ (*) begin
        if (rst == `ResetEnable) begin
            for (i = 0; i < `CacheSize; i = i + 1) begin
                entry[i] = `ZERO_WORD;
                tag[i] = `ZERO_WORD;
                valid[i] = 1'b0;
            end
        end 
        else if (replace) begin
            entry[addr[`CacheLen - 1 + 2 : 2]] = data_r;
            tag[addr[`CacheLen - 1 + 2 : 2]] = addr[16 : `CacheLen + 2];
            valid[addr[`CacheLen - 1 + 2 : 2]] = `Valid;
        end
    end
endmodule
