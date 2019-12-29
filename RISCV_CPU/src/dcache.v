module dcache(
    input wire clk,
    input wire rst,

    input wire [`AddrLen - 1 : 0] addr,
    input wire [`AddrLen - 1 : 0] data_r, //data to replace
    input wire replace,

    output wire [`RegLen - 1 : 0] data,
    output wire isCorrect
    );

    reg [`AddrLen - 1 : 0] entry[`CacheSize - 1 : 0];
    reg [`TagLen - 1 : 0] tag[`CacheSize - 1 : 0];
    reg [`CacheSize - 1 : 0] valid;

    assign data = entry[addr[`CacheLen - 1 + 2 : 2]];
    assign isCorrect = (valid[addr[`CacheLen - 1 + 2 : 2]] == `Valid) ? (tag[addr[`CacheLen - 1 + 2 : 2]] == addr[`CacheLen + `TagLen + 1: `CacheLen + 2]) : 1'b0;

    always @ (posedge clk) begin
        if (rst == `ResetEnable) begin
            valid <= 0;
        end
        else if (replace) begin
            entry[addr[`CacheLen - 1 + 2 : 2]] <= data_r;
            tag[addr[`CacheLen - 1 + 2 : 2]] <= addr[`CacheLen + `TagLen + 1: `CacheLen + 2];
            valid[addr[`CacheLen - 1 + 2 : 2]] <= `Valid;
        end
    end
endmodule