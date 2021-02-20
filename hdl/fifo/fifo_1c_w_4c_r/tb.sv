
module tb (intf_fifo.tb tb_if);

	parameter READ = 4;

  	int temp;
	bit [DATA_WIDTH-1:0] queue [$:FIFO_DEPTH-1];	
	bit [DATA_WIDTH-1:0] queue_buff [$:READ-1];	
  	bit [FIFO_DEPTH-1:0] data_sb;
  	bit full_sb, empty_sb;	
	int counter;
	int debug = 0;

	assign tb_if.data_in = temp; 
    
  	initial begin
    		forever #5 tb_if.clock = ~tb_if.clock;
  	end
  
  	initial begin
  	  	$dumpfile("dump.vcd");
  	  	$dumpvars();
		if($test$plusargs("DEBUG")) debug = 1;
  	  	tb_if.clock = 0;
  	  	tb_if.reset = 0;
  	  	temp = 0;
  	  	reset();	
  	  	repeat(10) begin
  	  		push();
		end
  	  	
  	  	#10;
		repeat(10) begin
  	     		pop();
		end	
  	      	#10;

		#100;
  	  	repeat(10) begin
  	  		push();
		end
  	  	
  	  	#10;
		repeat(10) begin
  	     		pop();
		end	
  	      	#10;

  	      	repeat(10) begin
  	  		push();
			pop();
		end
		#10;
		
  	  	repeat(4) begin
  	  		push();
		end
  	  	repeat(3) begin
  	  		pop();
		end
  	  	repeat(7) begin
  	  		push();
		end
  	  	repeat(3) begin
  	  		pop();
		end
			
  	        
  	  	#100;
  	  	$finish;
  	end

	task push;
  	    	@(negedge tb_if.clock);
  	    	tb_if.push <= 1;
  	    	tb_if.pop <= 0;
  	    	temp <= temp + 1;
	endtask
	
	task pop;
  	    	@(negedge tb_if.clock);
  	    	tb_if.pop <= 1;
  	    	tb_if.push <= 0;
	endtask

	task reset;
  	  	tb_if.push = 0;
  	  	tb_if.pop = 0;
		repeat(3) begin
  	    		@(negedge tb_if.clock);
			tb_if.reset = 0;
		end
  	    	@(negedge tb_if.clock);
		tb_if.reset = 1;	
	endtask

	always @(negedge tb_if.clock) begin
		if(!tb_if.reset) begin
			full_sb = 0;
			empty_sb = 1;
			queue.delete();
		end
		else begin
			if(tb_if.push) begin
				queue.push_back(tb_if.data_in);
				if(queue.size() == FIFO_DEPTH) begin
					full_sb = 1;
					empty_sb = 0;
				end
				else begin
					full_sb = 0;
					empty_sb = 0;
				end
					
			end
			else if(tb_if.pop) begin
				if(!empty_sb)
					queue_buff.push_back(queue.pop_front());
				//data_sb = queue.pop_front();
				if(queue.size() == 0) begin
					full_sb = 0;
					empty_sb = 1;
				end
				else begin
					full_sb = 0;
					empty_sb = 0;
				end
			end

			if(tb_if.read_en) begin
				data_sb <= queue_buff.pop_front();
			end
		end
	end

	always @(negedge tb_if.clock) begin
		#1;
		if(tb_if.read_en) begin
			assert(tb_if.data_out == data_sb);
			//else $error("pop reading wrong!");
		end
	end

	always @(posedge tb_if.clock) begin
		assert(tb_if.full == full_sb);
		//else $error("full gone wrong!");
		assert(tb_if.empty == empty_sb);
		//else $error("empty gone wrong!");
	end


	always @(posedge tb_if.clock) begin
		if(debug) begin
		if(tb_if.push && !tb_if.full) begin
			$display("PUSH : data - %0d counter - %0d", tb_if.data_in, counter);
			counter++;
			if(counter > 7)
				counter = 7;
		end

		if(tb_if.read_en) begin
			$display("POP : data - %0d counter - %0d", tb_if.data_out, counter);
			counter--;
			if(counter < 0)
				counter = 0;
		end
		end
	end
endmodule

