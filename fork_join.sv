module tb();
  
  int tno1 = 0, tno2 = 0;

  
  task t1;
    
    forever begin
      $display("Task 1 Trigger at %0t", $time);
      	tno1 = tno1 + 1;
      	#20;
    end
    
  endtask
  
  task t2;
    
    forever begin
      	$display("Task 2 Trigger at %0t",$time);
      	tno2 = tno2 + 1;
      	#40;
    end
    
  endtask
  
  task run;
    
    #200;
    $display("t1 = %0d, t2 = %0d", tno1, tno2);
    $finish;
  endtask
  
  
  initial begin
    
    fork
      t1;
      t2;
      run;
    join
    
  end
  
endmodule
