module top;
	intf_fifo fifo_if();
  	fifo f1(fifo_if.dut);
  	tb tb1(fifo_if.tb);
endmodule
