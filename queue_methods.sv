module tb_queue_methods();
  
  string q1[$] = {"apple", "oranges", "melon", "mango", "pineapple" };
  string q2[$] = {"kiwi", "oranges", "grapes", "mango", "blueberry"};
  string q3[$] = {"tomato", "brinjal", "capsicum"};


  
  initial begin
    
    $display("q1 : %p", q1);
    
    //size
    
    $display("q1.size() : %0d", q1.size());
    
    //insert
    
    q1.insert(2,"grapes");
    $display("q1 after q1.insert(2,grapes) : %p", q1);

    
    //delete
    
    q1.delete(3);
    $display("q1 after q1.delete(3) : %p", q1);
    
    //pop_back
    
    $display("q1.pop_back() : %s", q1.pop_back());
    
    //pop_front
    
    $display("q1.pop_front() : %s", q1.pop_front());
    
    $display("q1 : %p", q1);

    
    //push_back
    q1.push_back("blueberry");

    
    
    //push_front
    q1.push_front("kiwi");

    
    $display("q1 : %p", q1);
    $display("q2 : %p", q2);
    
    if(q1 == q2) begin
      
      $display("q1 is equal to q2.");

    end
    
    else
      $display("q1 is not equal to q2.");
    
    if(q1 == q3) begin
      
      $display("q1 is equal to q3.");

    end
    
    else
      $display("q1 is not equal to q3.");
  
  
  	$display("q3 : %p", q3);

  
  	q3 = {q1,q3};	
  
  	$display("{q1,q3} : %p", q3);
  end
  
endmodule
