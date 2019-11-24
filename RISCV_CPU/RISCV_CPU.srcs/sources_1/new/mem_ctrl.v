`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2019 11:13:48 PM
// Design Name: 
// Module Name: mem_ctrl
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


module mem_ctrl(
    input wire rst,
    input wire clk,

    input wire [`AddrLen - 1 : 0] addr_from_if,
    input wire [`AddrLen - 1 : 0] addr_from_mem,
    input wire [`RegLen - 1: 0] data_in,
    input wire rw_if, // 0 : disable, 1 : read
    input wire [2:0] rw_mem, // 0 : disable, 1 : read 2 : write
    input wire [3:0] quantity,

    output reg [`RegLen - 1 : 0] data_out,
    output reg [1:0] status_if,
    output reg [1:0] status_mem,

    output reg [`AddrLen - 1 : 0] addr_to_mem,
    output reg r_nw_to_mem,
    output reg [`RamWord - 1 : 0] data_to_mem,
    input wire [`RamWord - 1 : 0] data_from_mem
    );

    integer q, count;
    reg [1:0] status;

always @ (posedge clk) begin
    if (rst == `ResetEnable) begin
        status <= `IDLE;
        status_if <= 2'b00;
        status_mem <= 2'b00;
        r_nw_to_mem <= 1'b1; //Read
    end
    else begin
        case (status)
            `IDLE: begin
                data_out <= `ZERO_WORD;
                count <= 2'b00;
                status_mem <= `IDLE;
                status_if <= `IDLE;
                r_nw_to_mem <= 1'b1;

                if (rw_mem != 2'b00) begin
                    r_nw_to_mem <= (rw_mem != 2'b10);
                    addr_to_mem <= addr_from_mem;
                    data_to_mem <= data_in[7:0];
                    q <= quantity;
                    status_mem <= `WORKING;
                    if (rw_mem == 2'b01)
                        status <= `BUSYR;
                    else begin
                        data_to_mem <= data_in[7:0];
                        status <= `BUSYW;
                    end
                end
                else if (rw_if != 1'b0) begin
                    r_nw_to_mem <= 1'b1;
                    addr_to_mem <= addr_from_if;
                    q <= 3'b100;
                    status_if <= `WORKING;
                    status <= `BUSYR;
                end
            end
            `BUSYR: begin
                count <= count + 1;
                if (count >= 1) begin
                    data_out[count * `RamWord - 1 -: `RamWord] <= data_from_mem;
                    q <= q - 1;
                end
                if (count <= 3) begin
                    addr_to_mem <= addr_to_mem + 1;
                end
                if (count == 4 || q == 3'b000)  begin //have read all
                    status <= `IDLE;
                    if (status_if == `WORKING)
                        status_if <= `DONE;
                    else
                        status_mem <= `DONE;
                end
            end
            `BUSYW: begin
                count <= count + 1;
                data_to_mem <= data_in[(count + 2) * `RamWord - 1 -: `RamWord];
                q <= q - 1;
                if (count <= 2)
                    addr_to_mem <= addr_to_mem + 1;
                if (count == 2 || q == 3'b010) begin
                    status <= `IDLE;
                    status_mem <= `DONE;
                end
            end
            default: ;
        endcase
    end
end

endmodule
