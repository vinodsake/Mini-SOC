
module tb (intf_fifo.tb_bi tb_if);

  	int temp;
	bit [DATA_WIDTH-1:0] queue [$:FIFO_DEPTH-1];	
  	bit [FIFO_DEPTH-1:0] data_sb;
  	bit full_sb, empty_sb;	

 	assign tb_if.data_bi = tb_if.push ? temp : 'z;
    
  	initial begin
    		forever #5 tb_if.clock = ~tb_if.clock;
  	end
  
  	initial begin
  	  	$dumpfile("dump.vcd");
  	  	$dumpvars();
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

	always @(posedge tb_if.clock) begin
		if(!tb_if.reset) begin
			full_sb = 0;
			empty_sb = 0;
			queue.delete();
		end
		else begin
			if(tb_if.push) begin
				queue.push_back(tb_if.data_bi);
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
				data_sb = queue.pop_front();
				if(queue.size() == 0) begin
					full_sb = 0;
					empty_sb = 1;
				end
				else begin
					full_sb = 0;
					empty_sb = 0;
				end
			end
		end
	end

	always @(posedge tb_if.clock) begin
		#1;
		if(tb_if.pop) begin
			if(!tb_if.empty)
				assert(tb_if.data_bi == data_sb);
				//else $error("pop reading wrong!");
		end
		assert(tb_if.full == full_sb);
		//else $error("full gone wrong!");
		assert(tb_if.empty == empty_sb);
		//else $error("empty gone wrong!");
	end
endmodule
