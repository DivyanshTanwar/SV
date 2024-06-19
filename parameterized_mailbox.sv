class transaction;
  
  rand bit [5:0] data1;
  rand bit [6:0] data2;
  
  constraint data {
    data1 inside {[11:20]};
    data2 inside {[0:10]};
  }
  
endclass

class generator;
  
  transaction t;
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    
  endfunction
  
  task gen;
    
    for(int i = 0; i<20; i++) begin
      
      t = new();
      assert(t.randomize()) else begin
        $display("Randomization Failed");
      end
      mbx.put(t);
      $display("Data Sent : Data1 = %0d, Data2 = %0d",t.data1, t.data2);
      #10;
      
    end
    
  endtask
  
  
endclass

class driver;
  
  transaction tc;
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    
  endfunction
  
  task drv;
    
    forever begin
      
      mbx.get(tc);
      $display("Data Recieved : Data1 = %0d, Data2 = %0d",tc.data1, tc.data2);
      
      #10;
      
    end
    
  endtask
  
endclass

module test;
  
  generator gen;
  driver drv;
  mailbox #(transaction) mbx;
  
  initial begin
    
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
    
    fork
      gen.gen();
      drv.drv();
    join
    
    #200;
    $finish;
    
  end
  
endmodule
