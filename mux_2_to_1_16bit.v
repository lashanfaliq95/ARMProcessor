module stimulus;
wire[15:0] out;
reg[15:0] i0,i1;
reg s0;

mux2_to_1_16bit mux1(out,i0,i1,s0);

initial
begin

i0=16'd5; i1=16'd6; s0=1;
#1 $display("i0= %b, i1= %b, s0=%b \nout= %b\n",i0,i1,s0,out);

s0=0;
#1 $display("i0= %b, i1= %b, s0=%b \nout= %b\n",i0,i1,s0,out);

end
endmodule




module mux2_to_1_16bit (out, i0, i1, s0);//mux
	
	
	output[15:0] out;
	input[15:0] i0, i1;
	input s0;

	reg[15:0] tempout;
	
	always @(s0,i0,i1)
	begin	
	
		case ({s0})
			1'b0 : tempout = i0;
			1'b1 : tempout = i1;
				
		endcase
	

	end	
	
	assign out=tempout;
	
endmodule
