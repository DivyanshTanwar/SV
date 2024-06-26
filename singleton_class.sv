class singleton_class;
  
  protected static singleton_class sc;
  static int instances = 0;
  
  protected function new();
    
    $display("Singleton Class Created");
    instances ++;
    
  endfunction
  
  static function singleton_class create();
    
    if(sc == null)
      sc = new();
    
    return sc;
    
  endfunction
  
 
endclass

module tb();
  
  singleton_class sc1,sc2,sc3;
  
  initial begin
        
    sc1 = singleton_class :: create();
    $display("Intances after sc1 = %0d",sc1.instances);
    sc2 = singleton_class :: create();
    $display("Intances after sc2 = %0d",sc2.instances);    
    sc3 = singleton_class :: create();
    $display("Intances after sc3 = %0d",sc3.instances);


  end
  
endmodule
