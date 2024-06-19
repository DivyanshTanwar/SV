class generator;
  
  rand bit [3:0] addr;
  rand bit wr;
  
  constraint c1 {
   
    if(wr)
    {
      addr inside {[0:7]};
    }
    else
    {
      addr inside {[8:15]};
    }
    
  }
  function void display();
    
    $display("addr = %0d, wr = %0d", addr, wr);
    
  endfunction
  
  
endclass

    
module tb();
  
  generator g;
  
  initial begin
    
    g = new();
    
    for(int i = 0; i < 20; i++) begin
      
      g.randomize();
      g.display();
      
    end
    
  end
      
endmodule
