module tb();
  
  
  int a = 64;
  
  function bit isonehot(input int a);
    
    return ((a!= 0) && ((a&(a-1)) == 0));
    
  endfunction


  initial begin
    
    $display("%0b",isonehot(a));


    
  end
  
endmodule
