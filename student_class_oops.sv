typedef enum {CSE, ECE, MECH, EE} stream;


//address class
class address;
  
  string house_no;
  string street;
  string state;
  string country;
  longint pincode;
  
  function new(string house_no, string street, string state, string country, longint pincode);
    
    this.house_no = house_no;
    this.street = street;
    this.state = state;
    this.country = country;
    this.pincode = pincode;
    
  endfunction
  
  //getter and setter functions of address class
  
  function string gethouseno();
    
    return this.house_no;
    
  endfunction
  
  function void sethouseno(string house_no);
    
    this.house_no = house_no;
    
  endfunction
 
  function string getstreet();
    
    return this.street;
    
  endfunction
  
  function void setstreet(string street);
    
    this.street = street;
    
  endfunction

  function string getstate();
    
    return this.state;
    
  endfunction
  
  function void setstate(string state);
    
    this.state = state;
    
  endfunction
  
  function string getcountry();
    
    return this.country;
    
  endfunction
  
  function void setcountry(string country);
    
    this.country = country;
    
  endfunction
  
  
  function longint getpincode();
    
    return this.pincode;
    
  endfunction
  
  function void setpincode(longint pincode);
    
    this.pincode = pincode;
    
  endfunction
  
  //print address function
  
  function void print();
    
    $display("House No = %s",this.house_no);
    $display("Street = %s",this.street);
    $display("State = %s",this.state);
    $display("Country = %s",this.country);
    $display("Pincode = %0d",this.pincode);

    
    
  endfunction
  
  
endclass


// student class

class student;

  string name;
  string roll_no;
  int year;
  address add;
  stream s;
  
  function new(string name, string roll_no, int year, address add, stream s);
    
    this.name = name;
    this.roll_no = roll_no;
    this.year = year;
    this.add = add;
    this.s = s;
    
  endfunction
  
  
  //getter and setter functions of student class
  
  function string getname();
    
    return this.name;
    
  endfunction
  
  function void setname(string name);
    
    this.name = name;
    
  endfunction
  
  
  function string getrollno();
    
    return this.roll_no;
    
  endfunction
 
  function void setrollno(string roll_no);
    
    this.roll_no = roll_no;
    
  endfunction
  
  function int getyear();
    
    return this.year;
    
  endfunction
  
  function void setyear(int year);
    
    this.year = year;
    
  endfunction
  
  function address getaddress();
    
    return this.add;
    
  endfunction
  
  function void setaddress(address add);
    
    this.add = add;
    
  endfunction
  
  
  function stream getstream();
    
    return this.s;
    
  endfunction
  
  function void setstream(stream s);
    
    this.s = s;
    
  endfunction
  
  //print student function
  
  function void print();
    
    $display("Name = %s",this.name);
    $display("Roll Number = %s",this.roll_no);
    $display("year = %0d",this.year);
    $display("Stream = %s",this.s.name());
    add.print();
    
  endfunction
  
endclass

module top_tb();
  
  stream s = MECH;
  address a1 = new("12A", "Karol bagh", "Delhi", "India", 110029);
  student s1 = new("Ayush","2020UME1234",2020,a1,s);
  
  initial begin
	
	//a1.print();
	s1.print();
    $display("Using getters and setter functions of Student");
        
    $display("Name = %s",s1.getname());
    s1.setname("Alok");
    
    
    $display("Roll no = %s",s1.getrollno());
    s1.setrollno("1234UECMECH");
    
    $display("Year = %0d",s1.getyear());
    s1.setyear(2025);
    
    $display("Stream = %s",s1.getstream().name());
    s1.setstream(ECE);
    
    $display("House No  = %s",a1.gethouseno());    
    a1.sethouseno("CK91");
    
    $display("Street  = %s",a1.getstreet());    
    a1.setstreet("Naraina");
    
    $display("State  = %s",a1.getstate());    
    a1.setstate("Bhopal");
    
    $display("Country  = %s",a1.getcountry());    
    a1.setcountry("Russia");
    
    $display("Pincode  = %0d",a1.getpincode());    
    a1.setpincode(273321);
    
    $display("Address  = %p",s1.getaddress());    
    s1.setaddress(a1);
    
    $display("Printing after making changes using getter and setter functions.");
    s1.print();
  end
  

  
endmodule
