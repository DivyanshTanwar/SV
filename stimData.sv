//tb
class stimData;
  
  rand int arr[];
  
  constraint c1{
    arr.size() inside {[1:1000]};
  }
  
  function void display();
    
    $display("Size of the Array : %0d",arr.size());
    
  endfunction
  
endclass

module tb();
  
  stimData s1;
  
  initial begin
    
    s1 = new();
    
    repeat(20) begin
    
    	assert(s1.randomize()) else $display("Randomization Failed");
    	s1.display();
    
    end
  
  end
  
endmodule
