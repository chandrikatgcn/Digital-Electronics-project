

/*-------------------------------------TEST BENCH------------------------------------------------*/
/*PROJECT:AUTOMATED VEHICLE PARKING ENTRY AND EXIT

//DATAFLOW VERILOG CODE FOR AUTOMATED ENTRY AND EXIT OF VEHICLES 

//CHANDRIKA.T.G-16CO214


//ABSTRACT
		
		•	Unique password will be given to each vehicle owned by the residents which works for both entry and exit.
		•	Keep the count of two wheelers and four wheelers separately at any instant of time.
		•	Separate entry for two and four wheelers.
*/
//FUNCTIONALITY
 //Following is the test bench for 2 wheelers

module Verilog_214_test;
reg buzzer; //user can enter the password only if buzzer is pressed
reg [12:1]password;//password entered by the user			
reg clear;//to clear the counter to count the number of chances
reg clear_new;//to clear the counter to count the number of chances after correct password is entered
reg entry;
reg exit;
wire [2:1]count_entry;//To count the number of times buzzer pressed by each user while entering
wire [2:1]count_exit;//To count the number of times buzzer pressed by each user while exiting
wire gate_open;//will be equal to 1 if entered password is accepted else 0
wire gate_closed;//will be equal to 0 if entered password is accepted else 1 if access is denied
wire [12:1]num_in_park_slot;//Total number of vehicles in the parking slot at given point of time
wire [2:1]count_next_entry;//To give count_entry+1
wire [2:1]count_next_exit;//To give count_exit+1
wire [12:1]num_entry_next;//To calculate num_in_park_slot+1 while entering
wire [12:1]num_exit_next;//To calculate num_in_park_slot+1 while exiting
wire [2:1] count_prev_entry;//To give count_entry-1
wire [2:1] count_prev_exit;//To give count_exit-1
VerilogBM_214 test(buzzer,entry,exit,password,clear,clear_new,gate_open,gate_closed,count_entry,count_exit,num_in_park_slot,count_next_entry,count_next_exit,num_entry_next,num_exit_next,count_prev_entry,count_prev_exit);
initial
begin
	$dumpfile("VerilogBM_214_2w.vcd");
	$dumpvars;
end

initial begin
	buzzer=1'b0;
	clear=1'b1;
	entry=1'b1;
	exit=1'b0;
	#10
		entry=1'b1;
		exit=0;
		clear=1'b0;
		buzzer=1'b1;
		password=12'd722;
	#10
		entry=1'b1;
		exit=0;
		clear=1'b0;
		buzzer=1'b1;
		password=12'd420;
	#10
		entry=1'b1;
		exit=0;
		clear=1'b0;
		buzzer=1'b1;
		password=12'd434;
	#10
		entry=1'b1;
		exit=0;
		clear=1'b0;
		buzzer=1'b1;
		password=12'd436;
	#10
		exit=1'b0;
		entry=1;
		clear=1'b0;
		buzzer=1'b1;
		password=12'd460;
	#10
		entry=1'b1;
		exit=0;
		clear=1'b0;
		buzzer=1'b1;
		password=12'd567;
	#10
		exit=0;
		entry=1;
		clear=1'b0;
		buzzer=1'b1;
		password=12'd791;
	#10
		exit=0;
		entry=1;
		clear=1'b0;
		buzzer=1'b1;
		password=12'd460;
	
	#10
		entry=1;
		exit=0;
		buzzer=1'b1;
		clear=1'b0;
		password=12'd500;
	#10
		exit=0;
		entry=1;
		buzzer=1'b1;
		password=12'd207;
		clear=1'b0;
	#10
		exit=1;
		entry=0;
		buzzer=1'b1;
		password=12'd217;
		clear=1'b0;
	#10
		exit=1;
		entry=0;
		buzzer=1'b1;
		password=12'd701;
		clear=1'b0;
		
end 
initial

$monitor("\nentry=%b\texit=%b\tBuzzer=%b\tPassword=%3d\tgate open=%b\tgate closed=%b\tnumber of vehicles in parking slot=%2d",entry,exit,buzzer,password,gate_open,gate_closed,num_in_park_slot);

endmodule