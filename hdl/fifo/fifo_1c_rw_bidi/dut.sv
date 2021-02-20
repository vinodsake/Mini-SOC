// fifo_1c_rw_bidi
import my_pkg::*;

module fifo #(parameter WRITE=1, parameter READ=1) (
  	intf_fifo.dut_bi fifo_if
	);
  
  bit [$clog2(FIFO_DEPTH)-1:0] wr_ptr;
  bit [$clog2(FIFO_DEPTH)-1:0] rd_ptr;
  bit [FIFO_DEPTH-1:0] counter;
  bit [DATA_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
  bit [FIFO_DEPTH-1:0] data_t;
  
  	assign fifo_if.data_bi = fifo_if.pop ? data_t : 'z;
  
	always @ (posedge fifo_if.clock or negedge fifo_if.reset) begin
		if(!fifo_if.reset) begin
      			wr_ptr <= 0;
          		rd_ptr <= 0;
          		counter <= 0;
        		fifo_if.full <= 0;
        		fifo_if.empty <= 0;
    		end
  	end
      
	always @ (posedge fifo_if.clock) begin
      		if(fifo_if.push && !fifo_if.full) begin
        		mem[wr_ptr] <= fifo_if.data_bi;
        		wr_ptr <= wr_ptr + 1;
        		counter <= counter + 1;
      		end
      		else if(fifo_if.pop && !fifo_if.empty) begin
        		data_t <= mem[rd_ptr];
        		rd_ptr <= rd_ptr + 1;
        		counter <= counter - 1;
      		end
      		else begin
        		wr_ptr <= wr_ptr;
        		rd_ptr <= rd_ptr;
        		counter <= counter;
      		end
	end
      
      always @ (wr_ptr,rd_ptr) begin
	      	if(wr_ptr > FIFO_DEPTH-1)
			wr_ptr = 0;
	      	if(rd_ptr > FIFO_DEPTH-1)
			rd_ptr = 0;
        	fifo_if.empty = (counter == 0);
        	fifo_if.full = (counter == FIFO_DEPTH);
      end

endmodule
