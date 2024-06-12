//design

interface my_fifo #(parameter WIDTH = 8, DEPTH = 8) (input clk);
  
  logic rst_n, wr_en, rd_en, empty, full;
  logic [WIDTH - 1 : 0] data_in, data_out;
  
  modport dut (output data_out, empty, full, input rst_n, data_in, wr_en, rd_en, clk);
  
  modport tb (input data_out, empty, full, clk, output rst_n, data_in, wr_en, rd_en);
  
  task push(input logic [WIDTH - 1 : 0] wr_data);
        
    @(posedge clk);
    
    if(!full) begin
     
      data_in = wr_data;
      wr_en = 1;
      #1 $display("Data = %0h Pushed into the fifo",data_in);
      //wr_en = 0;
      
    end
    
    else
      $display("ERROR : Fifo full data cannot be inserted, Data = %0h",wr_data);
    
  endtask
  
  task pop(output logic [WIDTH - 1 : 0] rd_data);
    
    @(posedge clk);

    
    if(!empty) begin
            
      rd_en = 1;
            
      rd_data = data_out;
      
      #1 $display("Data out  = %0h",data_out);
      
      //rd_en = 0;
      
    end
    
    else begin
      
      $display("ERROR : Fifo Empty");
      rd_data = data_out;
      
	end
      
    
  endtask
  
endinterface

module fifo #(parameter WIDTH = 8, DEPTH = 8) (my_fifo fifo_if );
  
  logic [WIDTH - 1 : 0 ] memory [DEPTH - 1 : 0];
  
  parameter PTR_WIDTH = $clog2(DEPTH);
  logic [PTR_WIDTH : 0] rd_ptr, wr_ptr;
  
  logic wrap_around;
  
  always_ff @(posedge fifo_if.clk) begin
    
     if (!fifo_if.rst_n) begin
       	rd_ptr <= 0;
       	wr_ptr <= 0;
       //fifo_if.data_out <= 0;
        	
      end 
    
      else begin
          // write
        if (fifo_if.wr_en & !fifo_if.full) begin
              memory[wr_ptr[PTR_WIDTH - 1 : 0]] <= fifo_if.data_in;
              wr_ptr <= wr_ptr + 1;
          end

          // read
        if (fifo_if.rd_en & !fifo_if.empty) begin
          
          	  //fifo_if.data_out = memory[rd_ptr[PTR_WIDTH - 1 : 0]];
              rd_ptr <= rd_ptr + 1;
          end
        
		end
	end
  

  
  
  //logic for wraparound condition
  assign fifo_if.data_out = memory[rd_ptr[PTR_WIDTH - 1 : 0]];

  assign wrap_around = rd_ptr[PTR_WIDTH] ^ wr_ptr[PTR_WIDTH];
  
  assign fifo_if.empty = (rd_ptr == wr_ptr);
  
  assign fifo_if.full = (wrap_around) && (rd_ptr[PTR_WIDTH-1 : 0] == wr_ptr[PTR_WIDTH - 1 : 0]);
  
  
  
endmodule






//tb

module tb_toplevel #(parameter WIDTH = 8, DEPTH = 8)();

  logic clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  my_fifo #(WIDTH, DEPTH) intf(clk);
  
  fifo #(WIDTH, DEPTH) dut (intf);
 
  test1 t1(intf);
  

  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars();
    
    #1000 $finish;
  end
  
  

endmodule


program test1 #(parameter WIDTH = 8, DEPTH = 8)(my_fifo fifo_if);
  
  logic [WIDTH - 1 : 0] data_in, data_out;
 
  //program block terminates the entire simulation after it gets executed
  
  initial begin
    fifo_if.rst_n = 0;
    
    #10 fifo_if.rst_n = 1;
    
    fifo_if.wr_en = 0;
    fifo_if.rd_en = 0;
   	
    repeat(10) begin
      
      data_in = $urandom;
      fifo_if.push(data_in);
    end
    
    fifo_if.wr_en = 0;

      
    repeat(10) begin
      
      fifo_if.pop(data_out);
      
    end
     
    fifo_if.rd_en = 0;

  end
  
  //test2 simultaneous push and pop from fifo
  
  initial begin
    
    #200;
  
  fork 
    
    begin
      
      repeat(10) begin
      
      data_in = $urandom;
      fifo_if.push(data_in);
        
    	end
    
    fifo_if.wr_en = 0;
      
    end
    
    begin
      #10;
      repeat(10) begin
      
      fifo_if.pop(data_out);
      
    end
     
    fifo_if.rd_en = 0;
      
      
    end
    
    
  join
    
  end
  
  
  
endprogram
