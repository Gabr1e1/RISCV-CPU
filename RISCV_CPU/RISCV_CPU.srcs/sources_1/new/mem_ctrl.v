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

    output reg [`RegLen - 1 : 0] data_out,
    output reg [1:0] status,

    output reg [`AddrLen - 1 : 0] addr_to_mem,
    output reg r_nw_to_mem,
    output reg [`RamWord - 1 : 0] data_to_mem,
    input wire [`RamWord - 1 : 0] data_from_mem
    );

    integer count;
    
always @ (posedge clk) begin
    if (rst == `ResetEnable) begin
        //TODO: set to zero
        status <= `IDLE;
    end
    else begin
        case (status)
            `DONE: begin
                status <= `IDLE;
            end
            `IDLE: begin
                if (rw_if != 1'b0 || rw_mem != 2'b00) begin
                    count <= 2'b00;
                    r_nw_to_mem <= (rw_mem == 2'b10);
                    if (rw_if != 1'b0)
                        addr_to_mem <= addr_from_if;
                    else
                        addr_to_mem <= addr_from_mem;

                    if (rw_if == 1'b1 || rw_mem == 2'b01) begin
                        status <= `BUSYR;
                    end
                    else if (rw_mem == 2'b10) begin
                        data_to_mem <= data_in[7 : 0];
                        status <= `BUSYW;
                    end
                end
            end
            `BUSYR: begin
                count <= count + 1;
                if (count >= 1)
                    data_out[(5 - count) * `RamWord - 1 -: `RamWord] <= data_from_mem;
                if (count <= 3) begin
                    addr_to_mem <= addr_to_mem + 1;
                end
                if (count == 4) begin //have read all
                    status <= `DONE;
                end
            end
            `BUSYW: begin
            //TODO: READ FROM MEM
                // if (count == 2'b11) begin //have read all
                //     status <= IDLE;
                // end
                // else begin
                //     count <= count + 1;
                //     data_to_mem <= [(count + 2) * `RamWord - 1 : ((count + 1) * `RamWord)];
                // end
            end
            default: ;
        endcase
    end
end

endmodule
