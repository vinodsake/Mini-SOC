import my_pkg::*;

module fifo #(parameter WRITE = 1, parameter READ = 4) (
	intf_fifo.dut fifo_if
);

	bit [DATA_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
	bit [$clog2(FIFO_DEPTH)-1:0] wr_ptr;
	bit [$clog2(FIFO_DEPTH)-1:0] rd_ptr;
	bit [$clog2(FIFO_DEPTH):0] counter;
  	bit [DATA_WIDTH-1:0] data_temp;


	wire [DATA_WIDTH-1:0] buff_temp[READ:0];
	assign buff_temp[0] = data_temp;
	assign fifo_if.data_out = buff_temp[READ-1];

	wire [READ:0] buff_signal;
	assign buff_signal[0] = fifo_if.pop && !fifo_if.empty;
	assign fifo_if.read_en = (buff_signal[READ]);

	always @(posedge fifo_if.clock or negedge fifo_if.reset) begin
		if(!fifo_if.reset) begin
			wr_ptr <= 0;
			rd_ptr <= 0;
			counter <= 0;
			fifo_if.full <= 0;
			fifo_if.empty <= 1;
		end
		else begin
			if(fifo_if.push && !fifo_if.full) begin
				mem[wr_ptr] <= fifo_if.data_in;
				wr_ptr <= wr_ptr + 1;
				counter <= counter + 1;
			end
			else if(fifo_if.pop && !fifo_if.empty) begin
				data_temp <= mem[rd_ptr];
				rd_ptr <= rd_ptr + 1;
				counter <= counter - 1;
			end
			else begin
				wr_ptr <= wr_ptr;
                        	rd_ptr <= rd_ptr;
                        	counter <= counter;
			end
		end
	end

	always @(wr_ptr,rd_ptr) begin
		if(wr_ptr > FIFO_DEPTH-1)
			wr_ptr = 0;
		if(rd_ptr > FIFO_DEPTH-1)
			rd_ptr = 0;
		fifo_if.empty = (counter == 0);
		fifo_if.full = (counter == FIFO_DEPTH);
	end

	// Addition delay is caused because data_temp is assigned at posedge clock
	genvar i;
	generate
		for(i=0; i < READ-1; i++) begin
			data_buffer db(.clock(fifo_if.clock), .in(buff_temp[i]), .out(buff_temp[i+1]));	
		end
	endgenerate

	genvar j;
	generate
		for(j=0; j < READ; j++) begin
			signal_buffer sb(.clock(fifo_if.clock), .in(buff_signal[j]), .out(buff_signal[j+1]));
		end
	endgenerate
endmodule

module data_buffer(
	input clock,
	input [DATA_WIDTH-1:0] in,
       	output logic [DATA_WIDTH-1:0] out	
);

	always @(posedge clock) begin
		out <= in;
	end
endmodule

module signal_buffer(
	input clock,
	input in,
	output logic out
);
	always @(posedge clock) begin
		out <= in;
	end
endmodule
