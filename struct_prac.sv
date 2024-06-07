module tb_struct();
  
  typedef enum {CSE, IT, ECE, MECH, EE} stream;
  
  typedef struct {
    int house_no;
    string street;
    string state;
    string country;
    longint pincode;
  } address;
  
  typedef struct {
    string name;
    string roll_no;
    address add;
    int year;
    stream branch;
  } student;
  
  student s_arr[3];
  
  initial begin
    
    s_arr[0] = fill_student_details(s_arr[0], "alok", "EE12345", 98, "morris road", "MP", "India", 110029, 2021, EE);
    s_arr[1] = fill_student_details(s_arr[1], "ayush", "ECE12345", 99, "lorris broad", "Delhi", "India", 110030, 2020, ECE);
    s_arr[2] = fill_student_details(s_arr[2], "sahil", "MECH12345", 100, "torris road", "kolkata", "India", 110031, 2019, MECH);    
    
//     print_student_details(alok);
//     print_student_details(ayush);
//     print_student_details(sahil);

    for(int i = 0; i< 3; i = i + 1) 
      print_student_details(s_arr[i]);
    
  end
  
  function student fill_student_details  (
    student s, 
    string name, 
    string roll_no, 
    int house_no, 
    string street, 
    string state, 
    string country, 
    longint pincode, 
    int year, 
    stream branch
  );
    
    s.name = name;
    s.roll_no = roll_no;
    s.add.house_no = house_no;
    s.add.street = street;
    s.add.state = state;
    s.add.country = country;
    s.add.pincode = pincode;
    s.year = year;
    s.branch = branch;
    
    return s;
    
  endfunction
  
  task print_student_details(student s);
    
    $display("Name: %s", s.name);
    $display("Roll No: %s", s.roll_no);
    $display("Address: %0d, %s, %s, %s, %0ld", s.add.house_no, s.add.street, s.add.state, s.add.country, s.add.pincode);
    $display("Year: %0d", s.year);
    $display("Branch: %s", s.branch.name());
    
  endtask
  
endmodule
