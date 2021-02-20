import my_pkg::*;

interface intf_fifo;
  wire [DATA_WIDTH-1:0] data_bi;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic read_en;
  logic push;
  logic pop;
  logic full;
  logic empty;
  logic clock;
  logic reset;
  
  modport dut_bi(inout data_bi, input push, pop, clock, reset, output full, empty);
  modport dut(input data_in, push, pop, clock, reset, output full, empty, data_out,read_en);
  modport tb_bi(inout data_bi, output push, pop, clock, reset, input full, empty);
  modport tb(output data_in, push, pop, clock, reset, input full, empty, data_out, read_en);
  
endinterface
