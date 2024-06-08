module associative_array_tb();
  
  int student_marks [string];
  
  initial begin
    
    student_marks = {
      "Aksh" : 25,
      "Aryan" : 66
    };
    
    student_marks["Alok"] = 100;
    student_marks["Ayush"] = 98;
    student_marks["Sahil"] = 56;
    student_marks["Yogesh"] = 96;
    student_marks["Divyansh"] = 62;
    
    $display("student_marks.size() = %0d",student_marks.size());
    $display("student_marks.num() = %0d",student_marks.num());
    $display("student_marks.exists(Alok) = %0d",student_marks.exists("Alok"));
    
    $display("student_marks = %p",student_marks);

    student_marks.delete("Alok");
    $display("student_marks = %p",student_marks);
    
    
    $display("student_marks.exists(Alok) = %0d",student_marks.exists("Alok"));
    
    
    begin
      
      string f;
      if(student_marks.first(f)) 
        $display("student_marks.first() [%s] %0d",f,student_marks[f]);
      
    end
   
        
    begin
      
      string f;
      if(student_marks.last(f)) 
        $display("student_marks.last() [%s] %0d",f,student_marks[f]);
      
    end
    
    begin
      
      string f = "Ayush";
      if(student_marks.next(f)) 
        $display("student_marks.next(Ayush) [%s] %0d",f,student_marks[f]);
      
    end
    
    begin
      
      string f = "Divyansh";
      if(student_marks.prev(f)) 
        $display("student_marks.prev() [%s] %0d",f,student_marks[f]);
      
    end
    
    begin
      string f;
      
      while(student_marks.next(f)) begin
        $display("[%s] : %0d", f,student_marks[f]);
      end
      
    end
    
     
  end
  
  
endmodule
  
