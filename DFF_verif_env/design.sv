interface dff_if ;
  
  logic clk;
  logic rst;
  logic d_in;
  logic d_out;
  
endinterface

module dff (dff_if dif);
  
  always @(posedge dif.clk) begin
    
    if(dif.rst == 1'b1)
      dif.d_out <= 1'b0;
    
    else 
      dif.d_out <= dif.d_in;
    
  end
  
endmodule
