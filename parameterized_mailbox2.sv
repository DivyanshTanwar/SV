class transaction;
  
	rand bit [7:0] addr = 7'h12;
	rand bit [3:0] data = 4'h4;
	rand bit we = 1'b1;	
	rand bit rst = 1'b0;
  
endclass

class generator;
  
  transaction t;
  mailbox #(transaction) mbx;
  
  function new( mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    
  endfunction
  
  task run();
    
    for( int i=0; i<5 ; i++) begin
      
      t = new();
      assert(t.randomize()) else begin
        
        $display("Randomization Failed");
        
      end
      
      mbx.put(t);
      $display("Data Send : addr = %0d, data = %0d, we = %0d, rst = %0d",t.addr, t.data, t.we, t.rst);
      
      #20;
      
    end
    
  endtask
  
endclass


class driver;
  
  transaction tc;
  mailbox #(transaction) mbx;
  
  function new (mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    
  endfunction
  
  task run();
    
    forever begin
      
      mbx.get(tc);
      $display("Data Rcvd : addr = %0d, data = %0d, we = %0d, rst = %0d",tc.addr, tc.data, tc.we, tc.rst);
      
      #20;
    end
    
  endtask;
  
endclass

module tb;
  
  generator gen;
  driver drv;
  mailbox #(transaction) mbx;
  
  initial begin
    
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
    
    fork 
      
      gen.run();
      drv.run();
      
    join
    
    #200 $finish;
    
  end
  
endmodule
