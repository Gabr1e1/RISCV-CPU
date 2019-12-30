module dcache(
    input wire clk,
    input wire rst,

    input wire [`AddrLen - 1 : 0] addr,
    input wire [`AddrLen - 1 : 0] data_r, //data to replace
    input wire replace,

    output wire [`RegLen - 1 : 0] data,
    output wire isCorrect
    );

    reg [`RegLen - 1 : 0] entry[`DCacheSize - 1 : 0];
    reg [`DTagLen - 1 : 0] tag[`DCacheSize - 1 : 0];
    reg [`DCacheSize - 1 : 0] valid;

    assign data = entry[addr[`DCacheLen - 1 + 2 : 2]];
    assign isCorrect = (valid[addr[`DCacheLen - 1 + 2 : 2]] == `Valid) ? (tag[addr[`DCacheLen - 1 + 2 : 2]] == addr[`DCacheLen + `DTagLen + 1: `DCacheLen + 2]) : 1'b0;

    always @ (posedge clk) begin
        if (rst == `ResetEnable) begin
            valid <= 0;
        end
        else if (replace) begin
//            $display("DCache Replace %h %h %h", addr[`DCacheLen + `DTagLen + 1: `DCacheLen + 2], addr, data_r);
            entry[addr[`DCacheLen - 1 + 2 : 2]] <= data_r;
            tag[addr[`DCacheLen - 1 + 2 : 2]] <= addr[`DCacheLen + `DTagLen + 1: `DCacheLen + 2];
            valid[addr[`DCacheLen - 1 + 2 : 2]] <= `Valid;
        end
    end
endmodule