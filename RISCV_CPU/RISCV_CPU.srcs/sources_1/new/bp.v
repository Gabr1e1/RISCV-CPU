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
    input wire [`AddrLen - 1 : 0] addr,
    input wire wrong,
    output wire jmp_or_not
    );
    
    reg [1:0] bht[`BHTSize - 1 : 0];
    assign jmp_or_not = (bht[addr[`BHTLen - 1 + 2 : 2]] == 2'b10) || (bht[addr[`BHTLen - 1 + 2 : 2]] == 2'b11);
    
    always @ (*) begin
        if (wrong) begin
            case(bht[addr[`BHTLen - 1 + 2 : 2]])
                2'b00:
                    bht[addr[`BHTLen - 1 + 2 : 2]] = 2'b01;
                2'b01:
                    bht[addr[`BHTLen - 1 + 2 : 2]] = 2'b10;
                2'b10:
                    bht[addr[`BHTLen - 1 + 2 : 2]] = 2'b01;
                2'b11:
                    bht[addr[`BHTLen - 1 + 2 : 2]] = 2'b10;
            endcase
        end
    end

endmodule
