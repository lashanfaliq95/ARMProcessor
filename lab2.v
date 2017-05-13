module stimulus;
wire[15:0] Aout,Bout;
reg[3:0] Aadd,Badd,Cadd;
reg[15:0] Cin;
reg load,clear,clk;
reg[15:0] registerFile[15:0];

initial
 clk = 1'b1;
 
always
 #5 clk = ~clk;
 
initial
	#1000 $finish;
	
register_file my_register_file(Aout,Bout,Cin,Aadd,Badd,Cadd,clear,load,clk);	

initial
begin

Aadd = 4'd2; Badd = 4'd6; Cadd = 4'd9; load = 1'b0; clear = 1'b1; Cin = 16'd10000;

#10 $display("Should display Aout = x ,Bout = x");
	$display("Aout = %d ,Bout = %d\n",Aout,Bout);
	
Aadd = 4'd2; Badd = 4'd9; Cadd = 4'd9; load = 1'b1; clear = 1'b1; Cin = 16'd10000;
	
#10 $display("Should display Aout = x ,Bout = 1000");
	$display("Aout = %d ,Bout = %d\n",Aout,Bout);

Aadd = 4'd4; Badd = 4'd9; Cadd = 4'd4; load = 1'b1; clear = 1'b1; Cin = 16'd5555;

#10 $display("Should display Aout = 5555 ,Bout = 10000");
	$display("Aout = %d ,Bout = %d\n",Aout,Bout);	
	
Aadd = 4'd4; Badd = 4'd3; Cadd = 4'd3; load = 1'b1; clear = 1'b1; Cin = 16'd1024;

#10 $display("Should display Aout = 5555 ,Bout = 1024");
	$display("Aout = %d ,Bout = %d\n",Aout,Bout);	

	Aadd = 4'd4; Badd = 4'd3; Cadd = 4'd3; load = 1'b0; clear = 1'b0; Cin = 16'd1024;

#10 $display("Should display Aout = 0 ,Bout = 0");
	$display("Aout = %d ,Bout = %d\n",Aout,Bout);	

Aadd = 4'd4; Badd = 4'd3; Cadd = 4'd3; load = 1'b1; clear = 1'b1; Cin = 16'd520;

#10 $display("Should display Aout = 0 ,Bout = 520");
	$display("Aout = %d ,Bout = %d\n",Aout,Bout);	
	
	
end




endmodule



module register_file(Aout,Bout,Cin,Aadd,Badd,Cadd,clear,load,clk);

input[3:0] Aadd,Badd,Cadd;
input[15:0] Cin;
input load,clear,clk;
reg[15:0] registerFile[15:0];

output[15:0] Aout,Bout;


reg[15:0] temp1,temp2,temp3;

integer i;

always@(clear==1'b1)
begin

	for(i=0;i<16;i=i+1)
	  begin    //for clear ,set all to zero
	registerFile[i] = 1'b0;
	  end
	
end
	
	
	
always@(posedge clk)
	begin
	

	
	
	if(load==1'b1)
	begin
	    //for load
	temp3 = Cin;
	registerFile[Cadd] = temp3;
	
	end
	
	temp1 = registerFile[Aadd];  //get vlue in address a
	temp2 = registerFile[Badd];  //get vlue in address b
	

	end

	assign Aout = temp1;  //assign value of address A to Aout
	assign Bout = temp2;  //assign value of address B to Bout



endmodule
