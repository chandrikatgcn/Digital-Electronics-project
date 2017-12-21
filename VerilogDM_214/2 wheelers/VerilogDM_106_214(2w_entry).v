/*PROJECT:AUTOMATED VEHICLE PARKING ENTRY AND EXIT

//DATAFLOW VERILOG CODE FOR AUTOMATED ENTRY AND EXIT OF VEHICLES 

//CHANDRIKA.T.G-16CO214


//ABSTRACT
		
		•	Unique password will be given to each vehicle owned by the residents which works for both entry and exit.
		•	Keep the count of two wheelers and four wheelers separately at any instant of time.
		•	Separate entry for two and four wheelers.
*/
//FUNCTIONALITY AND DESCRIPTION

//There are 2 modules :
//						1.module VerilogDM_214 is the main module which actually does the work for automated entry and exit
//							*inputs are buzzer press and 3 bit(decimal) password entry
//							*outputs includes whether gate is closed or open ,chance to enter the password is over or not,num of vehicles entered
//						2.Module for T-flipflop
module VerilogDM_214(input buzzer,				//User can enter password after pressing the buzzer only
						input [12:1]password,	//Password to be entered by the user
						input entry,			//is equal to 1 if the user is entering the parking slot
						input exit,				//is equal to 1 if user is leaving the parking slot
						input reset1,			//to reset the counter
						output  gate_open,		//=1 if gate opens else =0
						output  gate_closed,	//=1 if gate is closed ,else =0
						output  chance_over,	//if buzzer is pressed for >3 times without entrering the correct password
						output  [3:0] num_entry,//gives the number of vehicles entered
						output  [1:0]q			//for counting the number of chances
						
						);
/* ACCEPTED PASSWORDS FOR 2 WHEELERS:
	1.722
	
	2.701
	3.217
	4.645
	5.420
*/
wire pass_out;					//ALL THESE ARE USED AS INTERNAL WIRES
wire c1_or;
wire pass_out_not;
wire and_of_pass_out_c1_or;
wire [1:0]q;

assign  pass_out=(entry==1 && buzzer==1 && (password==12'd722 || password==12'd701|| password==12'd217|| password==12'd645|| password==12'd420))?1'b1:1'b0;
assign  pass_out_not=~(pass_out);

//Instantiating t flip flop to increament the counter to count the number of chances taken by the user
t_ff c1_bit1(q[0],1'b1,buzzer,reset1);
t_ff c1_bit0(q[1],1'b1,~q[0],1'b0);

assign   c1_or=(q[1]|q[0]);
assign chance_over=~c1_or,						//Chance is over if count becomes 00 after becoimg 3=(11)
		and_of_pass_out_c1_or=(pass_out&c1_or),	//calculates the "and" of correct password entered ,c1_or
		gate_closed=(pass_out_not|~c1_or),		//gate_closed=1 if "or" of password is incorrect or counter counts 00 after giving 3 chances
		gate_open=(and_of_pass_out_c1_or);		//gate_open=1 if entered password is correct and buzzer is pressed


//Instatiating the t flipflop to increament the counter to count the number of vehicles entered
t_ff c2_bit0(num_entry[0],1'b1,pass_out,reset1);
t_ff c2_bit1(num_entry[1],1'b1,~num_entry[0],reset1);
t_ff c2_bit2(num_entry[2],1'b1,~num_entry[1],reset1);
t_ff c2_bit3(num_entry[3],1'b1,~num_entry[2],reset1);
endmodule


//T FLIP FLOP MODULE
module t_ff(q,t,clk,rst);
	input t,clk,rst;
	 output reg q=1'b1;
	always @(posedge clk or posedge rst)
	begin
	if(rst==1)
	q=1;
	
	q<=~q;
	end
endmodule

//TEST BENCH
module VerilogDM_214_test;
reg buzzer;			//User can enter password after pressing the buzzer only
reg[12:1]password;	 //Password to be entered by the user
reg entry;			//is equal to 1 if the user is entering the parking slot
reg exit;			//is equal to 1 if user is leaving the parking slot
reg reset1;			//to reset the counter
wire  gate_open;	//=1 if gate opens else =0
wire  gate_closed;	//=1 if gate is closed ,else =0
wire  chance_over;	//if buzzer is pressed for >3 times without entrering the correct password
wire [3:0] num_entry;//gives the number of vehicles entered
wire [1:0] q; 		//for counting the number of chances


 VerilogDM_214 test(buzzer,password,entry,exit,reset1,gate_open,gate_closed,chance_over,num_entry,q);
 initial begin
 $dumpfile("VerilogDM_214_2w_entry.vcd");
 $dumpvars;
 
$monitor("\nBuzzer=%b\tPassword=%3d\tGate open=%b\tGate closed=%b\tChance_over=%b\tnum_entry=%2d\tq=%2b",buzzer,password,gate_open,gate_closed,chance_over,num_entry,q);
 end
 initial begin
 
	
 reset1=1'b1;
 password=12'd000;
 buzzer=1;
 #5
		buzzer=0;
	#10
		entry=1'b1;
		exit=0;
		buzzer=1'b1;
		password=12'd722;
		reset1=1'b0;
	#5
	buzzer=0;
	#10
		entry=1'b1;
		exit=0;
		buzzer=1'b1;
		password=12'd420;
	#5
	buzzer=0;
	#10
		entry=1'b1;
		exit=0;
		buzzer=1'b1;
		password=12'd434;
	
	#5
	buzzer=0;
	#5
	buzzer=0;
	#10
		entry=1'b1;
		exit=0;
		buzzer=1'b1;
		password=12'd436;
	#5
	buzzer=0;
	#10
		exit=1'b0;
		entry=1;
		buzzer=1'b1;
		password=12'd460;
	#5
	buzzer=0;	
	#10
		entry=1'b1;
		exit=0;
		buzzer=1'b1;
		password=12'd217;
			
		
end
endmodule
 
 

						
						