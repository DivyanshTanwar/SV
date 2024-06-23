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

module tb1();
  
    exercise2 e2;
  	real count[bit[3:0]];
  	real countmid = 0;
    initial begin
      
      $display("Calling Randomization for Exercise 2 1000 times");

      e2 = new();

      e2.c1.constraint_mode(0);

      repeat(1000) begin

        assert(e2.randomize()) else $error("Randomization Failed");
        count[e2.address]++;
        e2.display();

      end
      

  	end
  
  	initial begin
      #100;
      
      $display("Count of Each Value of Address :");
      for(int i=0; i< 16; i++) begin
        
        $display("Value : %0d  Count : %0d", i, count[i]);
        
      end
      for(int i=1; i< 15; i++) begin
        
        countmid = countmid + count[i];
        
      end
      
      
      $display("Distribution for 0 : %0f", (count[0]/1000)*100);
      $display("Distribution for 1 to 14 : %0f", (countmid/1000)*100);
      $display("Dsirtibution for 15 : %0f", (count[15]/ 1000)*100);
      
    end

endmodule
