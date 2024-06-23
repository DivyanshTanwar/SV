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
  
  constraint c_add{
    address inside {[0:7]};
  }
  
  
  
endclass


module tb2();
  
  exercise2 e3,memTrans;
  
  initial begin
    
    e3 = new();
    memTrans = new();
    e3.c1.constraint_mode(0);
    e3.c2.constraint_mode(0);
    
    repeat(10) begin
      
      assert(e3.randomize() with {address inside {[0:8]};}) else $error("Randomization Failed");
      e3.display();

      
    end
    
    memTrans.c1.constraint_mode(0);
    memTrans.c2.constraint_mode(0);
    memTrans.c_add.constraint_mode(0);

    $display("MemTrans Object");
    
    repeat(10) begin
      
      assert(memTrans.randomize() with {address inside {[0:8]};}) else $error("Randomization Failed");
      memTrans.display();

      
    end

    
  end
  
  
endmodule
