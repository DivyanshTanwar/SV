class generator;
  
  rand bit rst, wr;
  
  constraint control_sig {
    rst dist {0 :/ 30 , 1 :/ 70};
    wr dist {0 :/ 50, 1 :/ 50};
  }
  
  function void display();
    
    $display("rst = %0d, wr =%0d", rst, wr);
    
  endfunction
  
  
  
endclass

module tb();
  
  generator g;
  
  initial begin
    
    g = new();
    
    for(int i = 0; i< 20; i++) begin
      
      g.randomize();
      g.display();
      
    end
    
  end
  
endmodule
