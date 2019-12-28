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

//TODO: No or less stall when writting?

module mem_ctrl(
    input wire rdy,
    input wire rst,
    input wire clk,
    input wire [`AddrLen - 1 : 0] pc,
    
    input wire [`AddrLen - 1 : 0] addr_from_if,
    input wire [`AddrLen - 1 : 0] addr_from_mem,
    input wire [`RegLen - 1: 0] data_in,
    input wire rw_if, // 0 : disable, 1 : read
    input wire [2:0] rw_mem, // 0 : disable, 1 : read 2 : write
    input wire [3:0] quantity,

    output reg [`RegLen - 1 : 0] data_out,
    output reg [1:0] status_if,
    output wire cacheHit,
    output wire [`RegLen - 1 : 0] cacheVal,
    
    output reg [1:0] status_mem,

    output reg [`AddrLen - 1 : 0] addr_to_mem,
    output reg r_nw_to_mem,
    output reg [`RamWord - 1 : 0] data_to_mem,
    input wire [`RamWord - 1 : 0] data_from_mem
);

    reg [3:0] q, count;
    reg [1:0] status;
    
    reg replace[0:1];
    wire isValid[0:1], isCorrect[0:1];
    wire [`RegLen - 1 : 0] data[0:1];
    
    cache cache0(.clk(clk), .rst(rst), .addr(pc), .replace(replace[0]), .data_r(data_out), .data(data[0]), .isValid(isValid[0]), .isCorrect(isCorrect[0]));
    cache cache1(.clk(clk), .rst(rst), .addr(pc), .replace(replace[1]), .data_r(data_out), .data(data[1]), .isValid(isValid[1]), .isCorrect(isCorrect[1]));

    assign cacheVal = isCorrect[0] ? data[0] : data[1];
    assign cacheHit = isCorrect[0] || isCorrect[1];

always @ (posedge clk) begin
    if (rst == `ResetEnable) begin
        status <= `IDLE;
        status_if <= 2'b00;
        status_mem <= 2'b00;
        r_nw_to_mem <= 1'b0; //Read
        { replace[0], replace[1] } <= { 2'b00 };
        q <= 0;
        count <= 0;
    end
    else if (!rdy) begin
    end
    else begin
        case (status)
            `IDLE: begin
                data_out <= `ZERO_WORD;
                count <= 0;
                status_mem <= `IDLE;
                status_if <= `IDLE;
                r_nw_to_mem <= 1'b0;
                addr_to_mem <= `ZERO_WORD;

                { replace[0], replace[1] }  <= 2'b00;

                if (rw_mem != 2'b00) begin
                    r_nw_to_mem <= (rw_mem == 2'b10);
                    addr_to_mem <= addr_from_mem;
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
                    r_nw_to_mem <= 1'b0;
                    addr_to_mem <= addr_from_if;
                    q <= 3'b100;
                    status_if <= `WORKING;
                    status <= `BUSYR;
                end
            end
            `BUSYR: begin
                count <= count + 1;
                if (count <= 2 && q >= 2) begin
                    addr_to_mem <= addr_to_mem + 1;
                end
                
                if (count == 1) begin
                    data_out[7:0] <= data_from_mem;
                end
                else if (count == 2) begin
                    data_out[15:8] <= data_from_mem;
                end
                else if (count == 3) begin
                    data_out[23:16] <= data_from_mem;
                end
                else if (count == 4) begin
                    data_out[31:24] <= data_from_mem;
                end
                q <= q - 1;

                if (count == 4 || q == 0)  begin //have read all
                    status <= `IDLE;
                    addr_to_mem <= `ZERO_WORD;

                    if (status_if == `WORKING) begin
                        status_if <= `DONE;
                        //Replace entry in cache

                        if (!isValid[0])
                            replace[0] <= 1'b1;
                        else
                            replace[1] <= 1'b1;
                    end
                    else
                        status_mem <= `DONE;
                end
            end
            `BUSYW: begin
                count <= count + 1;
//                data_to_mem <= data_in[(count + 2) * `RamWord - 1 -: `RamWord];                
                if (count == 0) begin
                    data_to_mem <= data_in[15:8];
                end
                else if (count == 1) begin
                    data_to_mem <= data_in[23:16];
                end
                else if (count == 2) begin
                    data_to_mem <= data_in[31:24];
                end
                
                q <= q - 1;
                if (count <= 2 && q >= 2)
                    addr_to_mem <= addr_to_mem + 1;
                else
                    addr_to_mem <= `ZERO_WORD;
                    
                if (count == 2 || q <= 2) begin
                    status <= `IDLE;
                    status_mem <= `DONE;
                end
            end
            default: ;
        endcase
    end
end

endmodule