module string_tb();
  
  string s1 = "An Apple A Day";
  string s2 = "Keeps doctor away";
  string s3 = "an apple a day";
  
  initial begin
    
     string temp;

    //len
    
    $display("length of s1 = %0d", s1.len());
    $display("length of s2 = %0d", s2.len());
	
    
    //putc and getc
    
    
    temp = s1;
    
    temp.putc(7,"y");
    $display("temp = %s", temp);
    $display("temp.getc(7) = %s", temp.getc(7));
    
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
  
  initial begin
    
    if (s1 == s2)
      $display("Pass");
    else
      $display("Fail");
      
    
  end
  
endmodule  
