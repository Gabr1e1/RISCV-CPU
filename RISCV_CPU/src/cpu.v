// RISCV32I CPU top module
// port modification allowed for debugging purposes

module cpu(
      input  wire                 clk_in,			// system clock signal
      input  wire                 rst_in,			// reset signal
      input wire stall_test,
      input  wire                 rdy_in,			// ready signal, pause cpu when low
      
      input  wire [ 7:0]          mem_din,		// data input bus
      output wire [ 7:0]          mem_dout,		// data output bus
      output wire [31:0]          mem_a,			// address bus (only 17:0 is used)
      output wire                 mem_wr			// write/read signal (1 for write)
//	output wire [31:0]			dbgreg_dout		  // cpu register output (debugging demo)
);

// implementation goes here

// Specifications:
// - Pause cpu(freeze pc, registers, etc.) when rdy_in is low
// - Memory read takes 2 cycles(wait till next cycle), write takes 1 cycle(no need to wait)
// - Memory is of size 128KB, with valid address ranging from 0x0 to 0x20000
// - I/O port is mapped to address higher than 0x30000 (mem_a[17:16]==2'b11)
// - 0x30000 read: read a byte from input
// - 0x30000 write: write a byte to output (write 0x00 is ignored)
// - 0x30004 read: read clocks passed since cpu starts (in dword, 4 bytes)
// - 0x30004 write: indicates program stop (will output '\0' through uart tx)

//PC
wire [`AddrLen - 1 : 0] pc;

//IF -> IF/ID
wire [`InstLen - 1 : 0] if_inst;

//IF/ID -> ID
wire [`AddrLen - 1 : 0] id_pc_i;
wire [`InstLen - 1 : 0] id_inst_i;

//Register -> ID
wire [`RegLen - 1 : 0] reg1_data;
wire [`RegLen - 1 : 0] reg2_data;

//ID -> Register
wire [`RegAddrLen - 1 : 0] reg1_addr;
wire [`RegLen - 1 : 0] reg1_read_enable;
wire [`RegAddrLen - 1 : 0] reg2_addr;
wire [`RegLen - 1 : 0] reg2_read_enable;

//ID -> ID/EX
wire [`OpCodeLen - 1 : 0] id_aluop;
wire [`OpSelLen - 1 : 0] id_alusel;
wire [`RegLen - 1 : 0] id_reg1, id_reg2, id_Imm, id_rd;
wire [3:0] id_width;
wire id_rd_enable;

//ID/EX -> EX
wire [`OpCodeLen - 1 : 0] ex_aluop;
wire [`OpSelLen - 1 : 0] ex_alusel;
wire [`RegLen - 1 : 0] ex_reg1, ex_reg2, ex_Imm, ex_rd;
wire [3:0] ex_width;
wire ex_rd_enable_i;

//EX -> EX/MEM
wire [`RegLen - 1 : 0] ex_rd_data;
wire [`RegAddrLen - 1 : 0] ex_rd_addr;
wire ex_rd_enable_o;
wire [3:0] ex_width_o;

//EX/MEM -> MEM
wire [`RegLen - 1 : 0] mem_rd_data_i;
wire [`RegAddrLen - 1 : 0] mem_rd_addr_i;
wire mem_rd_enable_i;
wire [3:0] mem_width;

//MEM -> MEM/WB
wire [`RegLen - 1 : 0] mem_rd_data_o;
wire [`RegAddrLen - 1 : 0] mem_rd_addr_o;
wire mem_rd_enable_o;

//MEM/WB -> Register
wire write_enable;
wire [`RegAddrLen - 1 : 0] write_addr;
wire [`RegLen - 1 : 0] write_data;

//Stall request
wire [`PipelineDepth - 1 : 0] stall;
wire stallreq;
wire stallreq_if, stallreq_mem;

//Mem Ctrl
wire [`AddrLen - 1 : 0] addr_from_if;
wire [`AddrLen - 1 : 0] addr_from_mem;
wire rw_if;
wire [2:0] rw_mem;
wire [`RegLen - 1: 0] data_in;
wire [`RegLen - 1 : 0] data_out;
wire [1:0] MemCtrlStatus;
wire [3:0] quantity;

//Instantiation
pc_reg pc_reg0(.clk(clk_in), .rst(rst_in), .pc(pc), .chip_enable(rdy_in),
              .stall(stall[0]));

if_stage if0(.rst(rst_in),.clk(clk_in),
      .pc(pc), .inst(if_inst),
      .addr_to_mem(addr_from_if), .rw(rw_if), .data_from_mem(data_out), .mem_status(MemCtrlStatus),
      .stall(stall), .stallreq(stallreq_if));

if_id if_id0(.clk(clk_in), .rst(rst_in), .if_pc(pc), .if_inst(if_inst), .id_pc(id_pc_i), .id_inst(id_inst_i),
            .stall(stall));

id id0(.rst(rst_in), .pc(id_pc_i), .inst(id_inst_i), .reg1_data_i(reg1_data), .reg2_data_i(reg2_data), 
      .reg1_addr_o(reg1_addr), .reg1_read_enable(reg1_read_enable), .reg2_addr_o(reg2_addr), .reg2_read_enable(reg2_read_enable),
      .reg1(id_reg1), .reg2(id_reg2), .Imm(id_Imm), .rd(id_rd), .rd_enable(id_rd_enable), .aluop(id_aluop), .alusel(id_alusel), .width(id_width),
      .ex_reg_i(ex_rd_enable_o), .ex_reg_addr(ex_rd_addr), .ex_reg_data(ex_rd_data),
      .mem_reg_i(mem_rd_enable_o), .mem_reg_addr(mem_rd_addr_o), .mem_reg_data(mem_rd_data_o));
      
register register0(.clk(clk_in), .rst(rst_in), 
                  .write_enable(write_enable), .write_addr(write_addr), .write_data(write_data),
                  .read_enable1(reg1_read_enable), .read_addr1(reg1_addr), .read_data1(reg1_data),
                  .read_enable2(reg2_read_enable), .read_addr2(reg2_addr), .read_data2(reg2_data));
id_ex id_ex0(.clk(clk_in), .rst(rst_in),
            .id_reg1(id_reg1), .id_reg2(id_reg2), .id_Imm(id_Imm), .id_rd(id_rd), .id_rd_enable(id_rd_enable), .id_aluop(id_aluop), .id_alusel(id_alusel), .id_width(id_width), 
            .ex_reg1(ex_reg1), .ex_reg2(ex_reg2), .ex_Imm(ex_Imm), .ex_rd(ex_rd), .ex_rd_enable(ex_rd_enable_i), .ex_aluop(ex_aluop), .ex_alusel(ex_alusel), .ex_width(ex_width), 
            .stall(stall));

ex ex0(.rst(rst_in), .pc(pc), 
      .reg1(ex_reg1), .reg2(ex_reg2), .Imm(ex_Imm), .rd(ex_rd), .rd_enable(ex_rd_enable_i), .aluop(ex_aluop), .alusel(ex_alusel), .width_i(ex_width),
      .rd_data_o(ex_rd_data), .rd_addr(ex_rd_addr), .rd_enable_o(ex_rd_enable_o), .width_o(ex_width_o));
      
ex_mem ex_mem0(.clk(clk_in), .rst(rst_in),
              .ex_rd_data(ex_rd_data), .ex_rd_addr(ex_rd_addr), .ex_rd_enable(ex_rd_enable_o), .ex_width(ex_width_o), 
              .mem_rd_data(mem_rd_data_i), .mem_rd_addr(mem_rd_addr_i), .mem_rd_enable(mem_rd_enable_i), .mem_width(mem_width), 
              .stall(stall));
              
mem mem0(.rst(rst_in),
        .rd_data_i(mem_rd_data_i), .rd_addr_i(mem_rd_addr_i), .rd_enable_i(mem_rd_enable_i), .width(mem_width), 
        .rd_data_o(mem_rd_data_o), .rd_addr_o(mem_rd_addr_o), .rd_enable_o(mem_rd_enable_o),
        .addr_to_mem(addr_from_mem), .rw_mem(rw_mem), .quantity(quantity), .stallreq(stallreq_mem),
        .data_from_mem(data_out), .mem_status(MemCtrlStatus));
        
mem_wb mem_wb0(.clk(clk_in), .rst(rst_in),
              .mem_rd_data(mem_rd_data_o), .mem_rd_addr(mem_rd_addr_o), .mem_rd_enable(mem_rd_enable_o),
              .wb_rd_data(write_data), .wb_rd_addr(write_addr), .wb_rd_enable(write_enable),
              .stall(stall));


ctrl ctrl0(.rst(rst_in),
          .stallreq(stall_test),
          .stallreq_if(stallreq_if), .stallreq_mem(stallreq_mem),
          .stall(stall));

mem_ctrl mem_ctrl0(.clk(clk_in), .rst(rst_in),
                  .addr_from_if(addr_from_if), .addr_from_mem(addr_from_mem), .data_in(data_in), .rw_if(rw_if), .rw_mem(rw_mem),
                  .data_out(data_out), .status(MemCtrlStatus),
                  .addr_to_mem(mem_a), .r_nw_to_mem(mem_wr), .data_to_mem(mem_dout), .data_from_mem(mem_din),
                  .quantity(quantity));
endmodule