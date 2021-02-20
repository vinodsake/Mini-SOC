module top;
  intf_fifo fifo_if();
  fifo f1(fifo_if.dut_bi);
  tb tb1(fifo_if.tb_bi);
endmodule