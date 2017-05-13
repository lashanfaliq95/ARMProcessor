module stimulus;

wire[3:0] out;
reg [3:0] in;
reg en,ctrl1,ctrl2,sli,sri,clk;

initial
	clk = 1'b1;

always
	#2 clk = ~clk;  //give #2 clock period

initial
	#100 $finish;
	// Instantiate the shiftregister
four_bit_shift_register shiftregister(in,out,clk,ctrl1,ctrl2,sli,sri,en);

// Stimulate the inputs

initial
begin
// set input lines
  en=1'b1 ; in[3]=1'b1; in[2]=1'b0; in[1]=1'b1; in[0]=1'b1; sli=1'b1; sri=1'b0;
#4  $display("Enable=%b ,Input[3]=%b ,Input[2]=%b ,Input[1]=%b ,Input[0]=%b ,shift_rightIn=%b ,shift_leftIn=%b \n",en,in[3],in[2],in[1],in[0],sli,sri);

  en=1'b1 ; ctrl1=1'b0; ctrl2=1'b0; in[3]=1'b1; in[2]=1'b0; in[1]=1'b1; in[0]=1'b1; sli=1'b1; sri=1'b0;
#4 $display("Enable=%b ,Control1=%b ,Control2=%b ,Output[3]=%b ,Output[2]=%b ,Output[1]=%b ,Output[0]=%b ,shift_rightIn=%b ,shift_leftIn=%b \n",en,ctrl1,ctrl2,out[3],out[2],out[1],out[0],sli,sri);

 en=1'b1 ; ctrl1=1'b0; ctrl2=1'b1;in[3]=1'b1; in[2]=1'b0; in[1]=1'b1; in[0]=1'b1; sli=1'b1; sri=1'b0;
 #4  $display("Enable=%b ,Control1=%b ,Control2=%b ,Output[3]=%b ,Output[2]=%b ,Output[1]=%b ,Output[0]=%b ,shift_rightIn=%b ,shift_leftIn=%b \n",en,ctrl1,ctrl2,out[3],out[2],out[1],out[0],sli,sri);

 en=1'b1 ; ctrl1=1'b1; ctrl2=1'b0; in[3]=1'b1; in[2]=1'b0; in[1]=1'b1; in[0]=1'b1; sli=1'b1; sri=1'b0;
 #4  $display("Enable=%b , Control1=%b , Control2=%b ,Output[3]=%b ,Output[2]=%b ,Output[1]=%b ,Output[0]=%b ,shift_rightIn=%b ,shift_leftIn=%b \n",en,ctrl1,ctrl2,out[3],out[2],out[1],out[0],sli,sri);

 en=1'b1 ; ctrl1=1'b1; ctrl2=1'b1; in[3]=1'b1; in[2]=1'b0; in[1]=1'b1; in[0]=1'b1; sli=1'b1; sri=1'b0;
#4  $display("Enable=%b ,Control1=%b ,Control2=%b ,Output[3]=%b ,Output[2]=%b ,Output[1]=%b ,Output[0]=%b ,shift_rightIn=%b ,shift_leftIn=%b \n",en,ctrl1,ctrl2,out[3],out[2],out[1],out[0],sli,sri);

 en=1'b0 ; ctrl1=1'b1; ctrl2=1'b0; in[3]=1'b1; in[2]=1'b0; in[1]=1'b1; in[0]=1'b1; sli=1'b1; sri=1'b0;
#4 $display("Enable=%b , Control1=%b , Control2=%b ,Output[3]=%b ,Output[2]=%b ,Output[1]=%b ,Output[0]=%b ,shift_rightIn=%b ,shift_leftIn=%b \n",en,ctrl1,ctrl2,out[3],out[2],out[1],out[0],sli,sri);



end

endmodule
module four_bit_shift_register(reg_in,reg_out,clk,s0,s1,sli,sri,en);

input[3:0] reg_in;
input s0,s1,clk,en,sli,sri;
output[3:0] reg_out;

reg[3:0] temp;

always @(posedge clk)
begin
  if(en==1'b1)
  begin
  if (s1==1'b0 && s0==1'b0) //load
		temp=reg_in;
	else if (s1==1'b0 && s0==1'b1)//hold
		temp=reg_out;
	else if (s1==1'b1 && s0==1'b0)//shift left
		 begin
		 temp=reg_out<<1'b1;
		 temp[0]=sri;
		 end
		 
	else if(s1==1'b1 && s0==1'b1)
	begin//shift right
		temp=reg_out>>1'b1;
		temp[3]=sli;
	end	
  end
  else if(en==1'b0)
  begin
  
  end

end
        assign reg_out=temp;
endmodule
