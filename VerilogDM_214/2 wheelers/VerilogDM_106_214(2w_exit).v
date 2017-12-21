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
//							*outputs includes whether gate is closed or open ,chance to enter the password is over or not,num of vehicles exited
//						2.Module for T-flipflop
module VerilogDM_214_exit(input buzzer1,		//User can enter password after pressing the buzzer only
						input [12:1]password1,		//Password to be entered by the user
						input entry1,				//is equal to 1 if the user is entering the parking slot
						input exit1,				//is equal to 1 if user is leaving the parking slot
						input reset11,				//to reset the counter
						output  gate_open1,			//=1 if gate opens else =0
						output  gate_closed1,		//=1 if gate is closed ,else =0
						output  chance_over1,		//if buzzer is pressed for >3 times without entrering the correct password
						output  [3:0] num_exit1,	//gives the number of vehicles exited
						output  [1:0]q1				//for counting the number of chances
						
						);
/* ACCEPTED PASSWORDS FOR 2 WHEELERS:
	1.722
	
	2.701
	3.217
	4.645
	5.420
*/
wire pass_out1;
wire c1_or1;				//ALL THESE ARE USED AS INTERNAL WIRES
wire pass_out_not1;
wire and_of_pass_out_c1_or1;
//wire [1:0]q;
//wire clk;
assign  pass_out1=(exit1==1 && buzzer1==1 && (password1==12'd722 || password1==12'd701|| password1==12'd217|| password1==12'd645|| password1==12'd420))?1'b1:1'b0;
assign  pass_out_not1=~(pass_out1);


//Instantiating t flip flop to increament the counter to count the number of chances taken by the user
t_ff1 c1_bit1_(q1[0],1'b1,buzzer1,reset11);
t_ff1 c1_bit0_(q1[1],1'b1,~q1[0],1'b0);

assign c1_or1=(q1[1]|q1[0]);
assign chance_over1=~c1_or1,					//Chance is over if count becomes 00 after becoimg 3=(11)
		and_of_pass_out_c1_or1=(pass_out1&c1_or1),	//calculates the "and" of correct password entered ,c1_or
		gate_closed1=(pass_out_not1|~c1_or1),		//gate_closed=1 if "or" of password is incorrect or counter counts 00 after giving 3 chances
		gate_open1=(and_of_pass_out_c1_or1);		//gate_open=1 if entered password is correct and buzzer is pressed



//Instatiating the t flipflop to increament the counter to count the number of vehicles exited
t_ff1 c2_bit0_(num_exit1[0],1'b1,pass_out1,reset11);
t_ff1 c2_bit1_(num_exit1[1],1'b1,~num_exit1[0],reset11);
t_ff1 c2_bit2_(num_exit1[2],1'b1,~num_exit1[1],reset11);
t_ff1 c2_bit3_(num_exit1[3],1'b1,~num_exit1[2],reset11);
endmodule


//T FLIP FLOP MODULE
module t_ff1(q,t,clk,rst);
	input t,clk,rst;
	 output reg q=1'b1;
	always @(posedge clk or posedge rst)
	begin
	if(rst==1)
	q=1;
	
	q<=~q;
	end
endmodule

//TEST BENCH FOR EXIT
module VerilogDM_214_test1;
reg buzzer1;		//User can enter password after pressing the buzzer only
reg[12:1]password1;	 //Password to be entered by the user
reg entry1;			//is equal to 1 if the user is entering the parking slot
reg exit1;			//is equal to 1 if user is leaving the parking slot
reg reset11;		//to reset the counter
wire  gate_open1;	//=1 if gate opens else =0
wire  gate_closed1;	//=1 if gate is closed ,else =0
wire  chance_over1;	//if buzzer is pressed for >3 times without entrering the correct password
wire [3:0] num_exit1;//gives the number of vehicles exited
wire [1:0]q1; 		//for counting the number of chances


 VerilogDM_214_exit test1(buzzer1,password1,entry1,exit1,reset11,gate_open1,gate_closed1,chance_over1,num_exit1,q1);
 
 initial begin
 $dumpfile("VerilogDM_214_2w_exit.vcd");
 $dumpvars;
$monitor("\nBuzzer=%b\tPassword=%3d\tentry=%b\texit=%b\tGate open=%b\tGate closed=%b\tChance_over=%b\tnum_exit=%2d\tq=%2b",buzzer1,password1,entry1,exit1,gate_open1,gate_closed1,chance_over1,num_exit1,q1);
 end
 initial begin
 
	
 reset11=1'b1;
 password1=12'b000;
 buzzer1=1;
 #5
		buzzer1=0;
	#10
		entry1=1'b0;
		exit1=1;
		buzzer1=1'b1;
		password1=12'd722;
		reset11=1'b0;
	#5
	buzzer1=0;
	#10
		entry1=1'b0;
		exit1=1;
		buzzer1=1'b1;
		password1=12'd420;
	#5
	buzzer1=0;
	#10
		entry1=1'b0;
		exit1=1;
		buzzer1=1'b1;
		password1=12'd400;
	#5
	buzzer1=0;
	#10
		buzzer1=1;
		password1=0;
		entry1=0;
		exit1=1;
	#5
	buzzer1=0;
	#10
		entry1=1'b0;
		exit1=1;
		buzzer1=1'b1;
		password1=12'd428;
	#5
	buzzer1=0;
		
end
endmodule