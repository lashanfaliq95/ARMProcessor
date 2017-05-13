module stimulus;
wire[3:0] out;
reg[3:0] i0,i1;
reg s0;

mux2_to_1_4bit mux(out,i0,i1,s0);

initial
begin

i0=4'b0110; i1=4'b0000; s0=1;
#1 $display("i0= %b, i1= %b, s0=%b \nout= %b\n",i0,i1,s0,out);

s0=0;
#1 $display("i0= %b, i1= %b, s0=%b \nout= %b\n",i0,i1,s0,out);

end
endmodule



module mux2_to_1_4bit (out, i0, i1, s0);//mux
	
	
	output[3:0] out;
	input[3:0] i0, i1;
	input s0;

	reg[3:0] tempout;
	
	always @(s0,i0,i1)
	begin	
	
		case ({s0})
			1'b0 : tempout = i0;
			1'b1 : tempout = i1;
				
		endcase
	

	end	
	
	assign out=tempout;
	
endmodule
