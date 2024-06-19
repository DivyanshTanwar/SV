module tb();
  
  event a1, a2;
  
  initial begin
    
    #10;
    -> a1;
    //#10;
    -> a2;
    
  end
  
  initial begin
    
    
    @(a1);
    $display("a1 Triggered at %0t",$time);
    @(a2);
    $display("a2 Triggered at %0t", $time);
	
    
//     wait(a1.triggered);
//     $display("a1 Triggered at %0t",$time);
//     wait(a2.triggered);
//     $display("a2 Triggered at %0t",$time);
    
    
  end
  
endmodule
