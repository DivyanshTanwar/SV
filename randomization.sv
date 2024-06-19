class generator;
  
  
  randc bit[7:0] x,y,z;
  
  constraint data {
    x inside {[0:50]};
    y inside {[0:50]};
    z inside {[0:50]};
  }
  
  extern function void display();
  
  
endclass

    function void generator:: display();
      
      $display("x = %0d, y = %0d, z = %0d",x,y,z);
      
    endfunction


module tb();
  
  generator g;
  int i = 0;
  
  initial begin
    
    for ( i=0 ; i<20; i++) begin
      
      g = new();
      assert(g.randomize()) else begin
        $display("Randomization Failed");
        $finish;
      end
      
      g.display();
      #20;
      
      
    end
    
  end
  
  
endmodule
