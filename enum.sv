module enum_tb();
  
  typedef enum {pass, fail, operation} status;
  status str;
  string s1 = "An Apple A Day";
  string s2 = "Keeps doctor away";
  string s3 = "An Apple A Day";
  
  task strings();
    if ( str == pass) 
    	$display("compare s1 and s3 = %0d", s1.compare(s3));
    
    else if( str == fail) 
      	$display("compare s1 and s3 = %0d", s1.compare(s2));
    
    else begin
    
      	$display("length of s1 = %0d", s1.len());
    	$display("length of s2 = %0d", s2.len());
	
    
    	//putc and getc
    
    	s1.putc(7,"y");
      $display("temp = %s", s1);
      $display("temp.getc(7) = %s", s1.getc(7));
    
    	//tolower and toupper
    	$display("s1.toupper() = %s", s1.toupper());
   	 	$display("s1 = %s", s1);
    	$display("s1.tolower() = %s", s1.tolower());
    
    	//compare and icompare
    	$display("compare s1 and s3 = %0d", s1.compare(s3));
    	$display("compare s1 and s3 = %0d", s1.icompare(s3));
    
    	//substring
    	$display("s1.substr(0,2) = %s", s1.substr(0,2));

    
    end
    
    
  endtask
  
  initial begin
    str = operation;
    strings();
    str = pass;
    strings();
    str = fail;
    strings();
   
  end
  
endmodule
