//design

interface my_fifo #(parameter WIDTH = 8, DEPTH = 8, PTR_WIDTH = $clog2(DEPTH)) (input clk);
  
  logic rst_n, wr_en, rd_en, empty, full;
  logic [WIDTH - 1 : 0] data_in, data_out;
  logic [PTR_WIDTH : 0 ] rd_ptr, wr_ptr;
  
  modport dut (output data_out, empty, full, rd_ptr, wr_ptr, input rst_n, data_in, wr_en, rd_en, clk);
  
  modport t1 (input data_out, empty, full, clk, rd_ptr, wr_ptr, output rst_n, data_in, wr_en, rd_en);
  
  clocking cl1 @(posedge clk);
    
    default input #2ns output #2ns;
    input data_out, empty, full, rd_ptr, wr_ptr;
    output rst_n, data_in, wr_en, rd_en;
    
  endclocking
  
  
  task automatic push(input logic [WIDTH - 1 : 0] wr_data, ref logic [WIDTH - 1 : 0] memory[logic[PTR_WIDTH : 0 ]]);
        
    @(posedge clk);
    
    if(!cl1.full) begin
      cl1.data_in <= wr_data;
      memory[cl1.wr_ptr] = wr_data;
      cl1.wr_en <= 1;
      #1 $display("Data = %0h Pushed into the fifo",cl1.data_in);
      //wr_en = 0;
      
    end
    
    else
      $display("ERROR : Fifo full data cannot be inserted, Data = %0h",wr_data);
    
  endtask
  
  task automatic pop(output logic [WIDTH - 1 : 0] rd_data, ref logic [WIDTH - 1 : 0] memory[logic[PTR_WIDTH : 0 ]]);
    
    @(posedge clk);

    
    if(!cl1.empty) begin
            
      cl1.rd_en <= 1;
      
            
      rd_data = cl1.data_out;
      if(rd_data == memory[cl1.rd_ptr]) 
        #1 $display("Matched, Data out  = %0h Expected output = %0h",cl1.data_out,memory[cl1.rd_ptr]);
      
      else 
        #1 $display("ERROR : Not matched : Data out  = %0h Expected output = %0h",cl1.data_out,memory[cl1.rd_ptr]);
        
      
      memory.delete(cl1.rd_ptr);
      //rd_en = 0;
      
    end
    
    else begin
      
      $display("ERROR : Fifo Empty");
      rd_data = cl1.data_out;
      
	end
      
    
  endtask
  
endinterface

module fifo #(parameter WIDTH = 8, DEPTH = 8, PTR_WIDTH = $clog2(DEPTH) ) (my_fifo fifo_if );
  
  logic [WIDTH - 1 : 0 ] memory [DEPTH - 1 : 0];
  
  //parameter PTR_WIDTH = $clog2(DEPTH);
  //logic [PTR_WIDTH : 0] rd_ptr, wr_ptr;
  
  logic wrap_around;
  
  always_ff @(posedge fifo_if.clk) begin
    
     if (!fifo_if.rst_n) begin
       	fifo_if.rd_ptr <= 0;
       	fifo_if.wr_ptr <= 0;
       //fifo_if.data_out <= 0;
        	
      end 
    
      else begin
          // write
        if (fifo_if.wr_en & !fifo_if.full) begin
          	memory[fifo_if.wr_ptr[PTR_WIDTH - 1 : 0]] <= fifo_if.data_in;
              fifo_if.wr_ptr <= fifo_if.wr_ptr + 1;
          end

          // read
        if (fifo_if.rd_en & !fifo_if.empty) begin
          
          	  //fifo_if.data_out = memory[rd_ptr[PTR_WIDTH - 1 : 0]];
              fifo_if.rd_ptr <= fifo_if.rd_ptr + 1;
          end
        
		end
	end
  

  
  
  //logic for wraparound condition
  assign fifo_if.data_out = memory[fifo_if.rd_ptr[PTR_WIDTH - 1 : 0]];

  assign wrap_around = fifo_if.rd_ptr[PTR_WIDTH] ^ fifo_if.wr_ptr[PTR_WIDTH];
  
  assign fifo_if.empty = (fifo_if.rd_ptr == fifo_if.wr_ptr);
  
  assign fifo_if.full = (wrap_around) && (fifo_if.rd_ptr[PTR_WIDTH-1 : 0] == fifo_if.wr_ptr[PTR_WIDTH - 1 : 0]);
  
  
  
endmodule


//tb

module tb_toplevel #(parameter WIDTH = 8, DEPTH = 8, PTR_WIDTH = $clog2(DEPTH))();

  logic clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  my_fifo #(WIDTH, DEPTH, PTR_WIDTH) intf(clk);
  
  fifo #(WIDTH, DEPTH, PTR_WIDTH) dut (intf);
 
  test1 t1(intf);
  

  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars();
    
    #1000 $finish;
  end
  
  

endmodule


program test1 #(parameter WIDTH = 8, DEPTH = 8,PTR_WIDTH = $clog2(DEPTH))(my_fifo fifo_if);
  
  logic [WIDTH - 1 : 0] data_in, data_out;
  
  logic [WIDTH - 1 : 0] memory [logic[PTR_WIDTH : 0 ]];
 
  //program block terminates the entire simulation after it gets executed
  
  initial begin
    
    fifo_if.rst_n = 0;
    
    #10 fifo_if.rst_n = 1;
    
    fifo_if.wr_en = 0;
    fifo_if.rd_en = 0;
   	
    repeat(10) begin
      
      data_in = $urandom;
      fifo_if.push(data_in,memory);
    end
    
    fifo_if.wr_en = 0;

      
    repeat(10) begin
      
      fifo_if.pop(data_out,memory);
      
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
        fifo_if.push(data_in,memory);
        
    	end
    
    fifo_if.wr_en = 0;
      
    end
    
    begin
      #10;
      repeat(10) begin
      
        fifo_if.pop(data_out,memory);
      
    end
     
    fifo_if.rd_en = 0;
      
      
    end
    
    
  join
    
  end
  
  initial #1000;
  
  
  
endprogram







//tb
