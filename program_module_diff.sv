//design
module example( output reg [3:0] out);
  
  initial begin
    
    out <= 15;
    
  end
  
endmodule;

//tb

program prog_example(wire [3:0] out);
  
  initial begin
    
    $display("Value of output using program : %0d",out);
    
  end
  
endprogram



module tb_example();
  
  wire [3:0] out;
  
  example e0 (.out(out));
  
  prog_example p0( .out(out));
  
  initial begin
    
    $display("Value of output using module : %0d",out);
    
  end
  
endmodule
