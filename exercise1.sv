//tb
class exercise1;
  
  rand bit [7:0] data;
  rand bit [3:0] address;
  
  constraint c1 {
    address inside {3,4};
  }
  
  function void display();
    
    $display("Data = %0d  address = %0d",data,address);
    
  endfunction
  
endclass

class exercise2 extends exercise1;
  
  constraint c2{
   	
    data == 5; 
    address dist {0 :/ 10, [1:14] :/ 80, 15:/ 10};
    
  }
  
  
endclass

module tb();
  
  exercise1 e;
  exercise2 e2;
  
  initial begin
    
    e = new();
    e2 = new();
    assert(e.randomize()) else $error("Randomization Failed");
    e.display();
    
    e2.c1.constraint_mode(0);
    
    repeat(20) begin
      assert(e2.randomize()) else $error("Randomization Failed");
      e2.display();

    end
    
  end
  
endmodule


