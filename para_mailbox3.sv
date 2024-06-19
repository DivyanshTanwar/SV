class transaction;
  
	rand bit [7:0] a;
	rand bit [7:0] b;
	rand bit wr;
  
endclass

class generator;
  
  transaction t;
  mailbox #(transaction) mbx;
  
  function new( mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    
  endfunction
  
  task run();
    
    for( int i=0; i<10 ; i++) begin
      
      t = new();
      assert(t.randomize()) else begin
        
        $display("Randomization Failed");
        
      end
      
      mbx.put(t);
      $display("Data Send : a = %0d, b = %0d, wr = %0d" ,t.a, t.b, t.wr);
      
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
      $display("Data Rcvd : a = %0d, b = %0d, wr = %0d" ,tc.a, tc.b, tc.wr);
      
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
