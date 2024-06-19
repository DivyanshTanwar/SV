class generator;
  
  rand bit [4:0] a;
  rand bit [5:0] b;
  
  constraint data {
    a inside {[0:8]};
    b inside {[0:5]};
  }
  
  function void display();
    
    $display("a = %0d, b = %0d", a, b);
    
  endfunction 
  
endclass

module tb();
  
  generator g;
  int failed_count = 0;
  int i = 0;
  
  initial begin
    
    g = new();
    
    for (i = 0; i<20 ; i++) begin
      
      assert(g.randomize()) else begin
        
        failed_count = failed_count + 1;
        $display("Randomization Failed");
        
      end
      
      g.display();
      
    end
    
    $display("Count of Failed Randomizations = %0d", failed_count);
    
    
    
  end
  
endmodule

