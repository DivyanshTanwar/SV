class graphics_image;
  
  parameter width = 10;
  parameter height = 10;
  parameter white_pixels = (width*height)/5;  // total pixels/ 5 = 20%
  
  rand bit [width -1 : 0] image [height - 1 : 0] ;
  
  
  function int count_white();
    
    count_white = 0;
    
    for(int i = 0; i<height ; i++) begin
      
      for(int j = 0; j < width; j++) begin
        
        if(image[i][j] == 1)
          count_white ++;
        
      end
      
      
    end
    
    return count_white;
    
  endfunction
  
    function void print_image();
      
      for (int i = 0; i < height; i++) begin
        
        for (int j = 0; j < width; j++) begin
          
          if (image[i][j] == 1)
          
          $write("1 ");
        else
          $write("0 ");
      end
      $write("\n");
        
    end
      
  endfunction
  
  function void report_pixel_counts();
    
    int white_pixels = count_white();
    int black_pixels = width*height - white_pixels;
    
    $display("White pixels: %0d", white_pixels);
    $display("Black pixels: %0d", black_pixels);
    
  endfunction
  
  constraint c1 {
   
    foreach(image[i])
      $countones(image[i]) == 2; //system task to count number of ones in an array
  }
  
endclass


module tb();
  
  graphics_image i1;
  
  
  initial begin
    i1 = new();
    
    assert(i1.randomize()) else $error("Randomization Failed");
	
    i1.print_image();
    i1.report_pixel_counts();
    
  end
  
  
endmodule
