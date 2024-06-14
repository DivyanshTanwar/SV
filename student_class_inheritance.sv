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
  longint fees;
  static int lastroll = 0;
  
  function new(string name, string roll_no, int year, longint fees, address add, stream s);
    
    this.name = name;
    this.roll_no = roll_no;
    this.year = year;
    this.add = add;
    this.s = s;
    this.fees = fees;
    lastroll = lastroll + 1;
    
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
    $display("Academic Fees = %0d",this.fees);
    $display("LastRoll = %0d",lastroll);
    add.print();
    
  endfunction
  
endclass

class mech_student extends student;
  
  string industrial_training;
  longint fees;
  
  function new(string name, string roll_no, int year, longint fees, address add, string industrial_training);
    
    stream s = MECH;
    super.new(name, roll_no, year, fees, add, s);
    this.industrial_training = industrial_training;
    this.fees = super.fees *0.2;
    
  endfunction
  
  function void print();
    
    super.print();
    $display("Industrial_training in = %s",this.industrial_training);
    $display("Department Fees = %0d",this.fees);

    
  endfunction
  
endclass

class cse_student extends student;
  
  string programming_lang;
  longint fees;
  
  function new(string name, string roll_no, int year, longint fees, address add, string programming_lang);
    
    stream s = CSE;
    super.new(name, roll_no, year, fees, add, s);
    this.programming_lang = programming_lang;
    this.fees = super.fees *0.5;
    
  endfunction
  
  function void print();
    
    super.print();
    $display("Programming Languages Known = %s",this.programming_lang);
    $display("Department Fees = %0d",this.fees);

    
  endfunction
  
endclass


class ece_student extends student;
  
  string programming_lang;
  string tools;
  longint fees;
  
  function new(string name, string roll_no, int year, longint fees, address add, string programming_lang, string tools);
    
    stream s = ECE;
    super.new(name, roll_no, year, fees, add,s);
    this.programming_lang = programming_lang;
    this.tools = tools;
    this.fees = super.fees *0.3;
    
  endfunction
  
  function void print();
    
    super.print();
    $display("Programming Languages Known = %s",this.programming_lang);
    $display("Tools Known = %s",this.tools);
    $display("Department Fees = %0d",this.fees);

    
  endfunction
  
endclass

module top_tb();
  
  stream s = MECH;
  address a1 = new("12A", "Karol bagh", "Delhi", "India", 110029);
  address a2 = new("22B", "Rani bagh", "Delhi", "India", 110089);
  address a3 = new("32C", "baghpat", "UP", "India", 110099);

  cse_student s1;
  mech_student s2;
  ece_student s3;
  
  initial begin
    s1 = new("Ayush","2021CSE4321",2021,100000,a1,"C++/C");
    s1.print();
    $display("--------------------------------------------");
    s2 = new("Kamlesh","2020UME1234",2020,80000,a2,"Engines");
    s2.print();
    $display("--------------------------------------------");
    s3 = new("Tarun","2024UEC1234",2024,910000,a3,"Verilog", "Vivado");
    s3.print();
    $finish;
  end  

  
endmodule
