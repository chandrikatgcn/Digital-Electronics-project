
/*PROJECT:AUTOMATED VEHICLE PARKING ENTRY AND EXIT

//DATAFLOW VERILOG CODE FOR AUTOMATED ENTRY AND EXIT OF VEHICLES 

//CHANDRIKA.T.G-16CO214


//ABSTRACT
		
		•	Unique password will be given to each vehicle owned by the residents which works for both entry and exit.
		•	Keep the count of two wheelers and four wheelers separately at any instant of time.
		•	Separate entry for two and four wheelers.
*/
//FUNCTIONALITY AND DESCRIPTION

//There is 1 module :
//						1.module VerilogBM_214 is the main module which actually does the work for automated entry and exit
//							*inputs are buzzer press and 5 bit(decimal) password entry
//							*outputs includes whether gate is closed or open ,chance to enter the password is over or not,num of vehicles in parking slot at any given time

module VerilogBM_214(input buzzer, 				//user can enter the password only if buzzer is pressed
						input entry,			//=1 if vehicle is entering else =0
						input exit,				//=1 if vehicle is exiting else =0
						input [20:1]password,	//password entered by the user			
						input clear,			//to clear the counter to count the number of chances
						input clear_new,		//to clear the counter to count the number of chances after correct password is entered
						output reg gate_open,	//will be equal to 1 if entered password is accepted else 0
						output reg gate_closed,	//will be equal to 0 if entered password is accepted else 1 if access is denied
						output reg [1:0]count_entry,		//To count the number of times buzzer pressed by each user while entering
						output reg [1:0]count_exit,			//To count the number of times buzzer pressed by each user while exiting
						output reg [12:1]num_in_park_slot,	//Total number of vehicles in the parking slot at given point of time
						output reg [2:1]count_next_entry,	//To give count_entry+1
						output reg [2:1]count_next_exit,	//To give count_exit+1
						output reg [12:1]num_entry_next ,	//To calculate num_in_park_slot+1 while entering
						output reg [12:1]num_exit_next,		//To calculate num_in_park_slot+1 while exiting
						output reg [2:1] count_prev_entry,	//To give count_entry-1
						output reg [2:1] count_prev_exit	//To give count_exit-1
						);
	
/* ACCEPTED PASSWORDS FOR 4 WHEELERS:
	1.74321
	2.12345
	3.64777
	4.56733
	5.37565
*/


always @(buzzer or password or entry or exit or clear or clear_new)
	
	begin

	
	//To clear the both the counters(one for counting the number of chances and the other for counting num of vehicles in parking slot) 
			if(clear==1'b1)			
			begin
			count_exit=2'd0;
			count_entry=2'd0;
			num_in_park_slot=12'd0;
			end
			
			else if(clear==1'b0)
			begin
				count_entry=count_next_entry;;
			end
			
			else if(clear==1'b0)
			begin
				count_exit=count_next_exit;
			end
			
	//To calculate count_prev,count_next,num_entry_next,num_exit_next		
			count_prev_entry=count_entry;
			num_entry_next=num_in_park_slot+1;
			count_prev_exit=count_exit;
			num_exit_next=num_in_park_slot-1;
//ENTRY OF VEHICLES 
			
	//Password checking for entered password and making chance_over=0 if buzzer is pressed <3 times  else =1	
		//Password is correct means gate_open=1 ,gate_closed=0	
		if(entry==1'b1)
		begin
			
			if(count_entry==2'd3 &&(password==20'd74321|| password==20'd12345|| password==20'd64777|| password==20'd56733|| password==20'd37565) )
				count_next_entry=2'd0;
			else if(count_entry==2'd3 && (password!=20'd74321|| password!=20'd12345|| password!=20'd64777|| password!=20'd56733|| password!=20'd37565))
				count_next_entry=2'd1;
			else
				count_next_entry=count_entry+1;
			
			
			
			if(count_entry<2'd3)
			begin
				if(buzzer==1'b1 && (password==20'd74321|| password==20'd12345|| password==20'd64777|| password==20'd56733|| password==20'd37565))
				begin
					gate_open<=1'b1;
					gate_closed<=1'b0;
					num_in_park_slot=num_entry_next;
					count_entry<=2'd0;
						
				end	
				
			end
			else if(count_entry==2'd3)
				begin
					$display("\nYour Chance is over::You cannot enter the parking slot....SORRY!!:(");
				
				end
	//Password is incorrect means gate will remain closed i.e gate+closed =1 and gate_open=0			
			if(buzzer==1'b0 ||(password!=20'd74321|| password!=20'd12345|| password!=20'd64777|| password!=20'd56733|| password!=20'd37565) )
			begin
				count_entry=count_next_entry;
				gate_open=1'b0;
				gate_closed=1'b1;
				num_in_park_slot=num_in_park_slot;
				count_entry<=1'd0;
			end
		end

//EXIT OF VEHICLES 
		
		if(exit==1'b1)
		begin
	//Password checking for entered password and making chance_over=0 if buzzer is pressed <3 times  else =1	
		//Password is correct means gate_open=1 ,gate_closed=0
		
			if(count_exit==2'd3 &&(password==20'd74321|| password==20'd12345|| password==20'd64777|| password==20'd56733|| password==20'd37565) )
			count_next_exit=2'd0;
			else if(count_exit==2'd3 && (password!=20'd74321|| password!=20'd12345|| password!=20'd64777|| password!=20'd56733|| password!=20'd37565))
			count_next_exit=2'd1;
			else
			count_next_exit=count_exit+1;
			
			
			
			if(count_exit<2'd3)
			begin
				if(buzzer==1'b1 && (password==20'd74321|| password==20'd12345|| password==20'd64777|| password==20'd56733|| password==20'd37565) )
				begin
					gate_open<=1'b1;
					gate_closed<=1'b0;
					num_in_park_slot=num_exit_next;
					count_exit<=2'd0;
						
				end	
				
			end
			else if(count_exit==2'd3)
				begin
					$display("\nYour Chance is over::You cannot enter the parking slot....SORRY!!:(");
				
				end
	//Password is incorrect means gate will remain closed i.e gate_closed =1 and gate_open=0	
	
		if(buzzer==1'b0 ||(password!=20'd74321|| password!=20'd12345|| password!=20'd64777|| password!=20'd56733|| password!=20'd37565) )
			begin
				count_exit=count_next_exit;
				gate_open=1'b0;
				gate_closed=1'b1;
				num_in_park_slot=num_in_park_slot;
				count_exit=1'd0;
			end
		end
	end
endmodule


		