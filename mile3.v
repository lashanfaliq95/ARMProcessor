module processor;


wire[3:0] writeReg;
wire[15:0] temp,Aout,Bout,z,read_data,instruction,cin,temp1,input_address,current_address,address,temp2,temp3,new_address,temp4,branch_address,jump_address,final_address;
wire out0,out1,out2,out3,out4,out5A,out5B,out5C,out5Active,out6,out7,out8,c_in,c_out,lt, eq, gt,overflow,clock,clear,b;
wire [2:0] c; 

pc myPc(input_address,current_address,clock);//getting address from pc

add add1(address,current_address,16'd2,clock);//adding 2 to the address

ins_memory my_InsMem(current_address,temp,clock);//loading the instruction from memory

   assign instruction=temp;

KURM mykurm(instruction[15],instruction[14],instruction[13],instruction[12],clock,out0,out1,out2,out3,out4,out5A,out5B,out5C,out5Active,out6,out7,out8);

mux2_to_1_4bit regdest(writeReg,instruction[11:8],instruction[7:4],out0);//getting write register depending on the control   

register_file  regFile(Aout,Bout,temp3,instruction[11:8],instruction[7:4],writeReg,1'b1,out8,clock);//clear one since we dont have a clear in out data path
    assign    c[2]=out5A;
    assign    c[1]=out5B;
    assign    c[0]=out5C;
ALU myAluOne(Aout,temp2,z,c,c_in,c_out,lt, eq, gt,overflow,clock);//the alu that get the result  or offset

data_memory my_datamem(z,read_data,Bout,out3,out6,clock);//accessing data memory

mux2_to_1_16bit memtoreg(temp3,z,read_data,out4);//which to write back to reg file

signExtend offsetExtend(instruction[3:0],temp1,clock);//sign extending the load store branch offset

mux2_to_1_16bit alusrc(temp2,Bout,temp1,out7);//chosing the input for the alu

leftshift branchoffset(temp1,temp4,clock);//shifting the branch offset

add add2(branch_address,temp4,address+16'd2,clock);//getting the branch address

assign b=out2 && !eq; //checking if the operation is branch and also not equal

mux2_to_1_16bit branch(new_address,address,branch_address,b);//getting the

jumpoffset jump(instruction[11:0],current_address,jump_address,clock);//getting the jump address

mux2_to_1_16bit final(final_address,new_address,jump_address,out1);//chosing the output address if jump

assign input_address=final_address;//updating the programme counter


endmodule


module pc(input_address,current_address,clock);//programme counter
input[15:0] input_address;
output reg[15:0] current_address;
input clock;
always@(posedge clock) begin
if(input_address>0)
 current_address=input_address;
else
  current_address=0;
end
endmodule


module ins_memory(read_address,instruction,clock);//instruction memory
input[15:0] read_address;
reg[15:0] registerFile[255:0];
output reg[15:0] instruction;
input clock;
initial begin
registerFile[8'd2]=0010000100100011;//add reg 1 reg 2 to reg 3 ;
registerFile[8'd5]=0110000100100011;//sub reg 1 reg 2 to reg 3;
registerFile[8'd7]=0100000100100011;//slt reg 1 reg 2 to reg 3;
registerFile[8'd10]=0101000100100101;//lw reg 1 reg 2 offset 0101
registerFile[8'd12]=1110000100100101;//bne reg 1 reg 2 offset 0101
registerFile[8'd14]=1111000000000011;//jump
end
always@(posedge clock) begin
instruction=registerFile[read_address];
end
endmodule

module data_memory(address,read_data,write_data,mem_read,mem_write,clock);
input[15:0] address,write_data;
input mem_read,mem_write,clock;
reg[15:0] registerFile[255:0];//this is not the max possible number
output reg[15:0] read_data;
always@(posedge clock) begin
if(mem_read==1)
read_data=registerFile[address];
if(mem_write==1)
registerFile[address]=write_data;
end
endmodule

module  KURM(s0,s1,s2,s3,clock,out0,out1,out2,out3,out4,out5A,out5B,out5C,out5Active,out6,out7,out8);
//control
input s0,s1,s2,s3;
input clock;
output out0,out1,out2,out3,out4,out5A,out5B,out5C,out5Active,out6,out7,out8;

//out0 -Register Destination.
//out1 -Register Jump.
//out2 -Register Branch.
//out3 -Register Memory Read.
//out4 - Register Memory write to Register.
//out5Active - activation for ALU.

//out5A,out5B,out5C  - control Register ALUOp.

//out6 -Register Memory write.
//out7 - Register ALU source.
//out8 - Register Register Write.


reg  temp0,temp1,temp2,temp3,temp4,temp5A,temp5B,temp5C,temp5Active,temp6,temp7,temp8; //get temporary registers for save outputs. 


always @(posedge clock)
begin

	case ({s0,s1,s2,s3})
	
			//opcode for ADD.
			4'b0010 :  
			begin 
			temp0 = 1; temp1 = 0; temp2 = 0;temp3 = 0;temp4 = 0;temp5Active = 1; temp5A = s1; temp5B = s2; temp5C = s3; temp6 = 0; temp7 = 0; temp8 = 1; 
			end   
			
			//opcode for SUB.
			4'b0110 :  
			begin 
			temp0 = 1;  temp1 = 0;  temp2 = 0; temp3 = 0;temp4 = 0; temp5Active = 1; temp5A = s1; temp5B = s2; temp5C = s3; temp6 = 0;  temp7 = 0; temp8 = 1;
			end 
			
			//opcode for AND.
			4'b0000 :  
			begin 
			temp0 = 1;  temp1 = 0; temp2 = 0; temp3 = 0; temp4 = 0; temp5Active = 1; temp5A = s1; temp5B = s2; temp5C = s3; temp6 = 0;  temp7 = 0; temp8 = 1;
			end 
			
			//opcode for OR.
			4'b0001 :  
			begin 
			temp0 = 1;  temp1 = 0; temp2 = 0; temp3 = 0; temp4 = 0; temp5Active = 1; temp5A = s1; temp5B = s2; temp5C = s3; temp6 = 0;  temp7 = 0; temp8 = 1;
			end 
			
			//opcode for SLT.
			4'b0100 :  
			begin 
			temp0 = 1;  temp1 = 0;  temp2 = 0;  temp3 = 0; temp4 = 0; temp5Active = 1; temp5A = s1; temp5B = s2; temp5C = s3; temp6 = 0;  temp7 = 0; temp8 = 1; 
			end 
			
			
			//opcode for LW.
			4 'b0101 :  
			begin  
			temp0 = 0; temp1 = 0; temp2 = 0; temp3 = 1; temp4 = 1; temp5Active = 1; temp5A = 0; temp5B = 0; temp5C = 0;  temp6 = 0;  temp7 = 1; temp8 = 1;
			end
			
			//opcode for SW.
			4 'b1010 :  
			begin 
 			temp0 = 0; temp1 = 0; temp2 = 0;  temp3 = 0; temp4 = 0; temp5Active = 1; temp5A = 0; temp5B = 0; temp5C = 0;  temp6 = 1;  temp7 = 1; temp8 = 0; 
			end
			
			//opcode for BNE.
			4 'b1110 :  
			begin  
			temp0 = 1;  temp1 = 0; temp2 = 1; temp3 = 0; temp4 = 0; temp5Active = 1; temp5A = 0; temp5B = 0; temp5C = 1;  temp6 = 0;  temp7 = 0; temp8 = 0; 
			end
			
			//opcode for JMP.
			4 'b1111 :  
			begin 
			temp0 = 0; temp1 = 1; temp2 = 0; temp3 = 0; temp4 = 0; temp5Active = 0; temp5A = 0; temp5B = 0; temp5C = 0;  temp6 = 0;  temp7 = 0; temp8 = 0; 
			end
		
			
		endcase
end

	assign out0= temp0;
	assign out1= temp1;
	assign out3= temp2;
	assign out3= temp3;
	assign out4= temp4;
	assign out5Active= temp5Active;
	assign out5A= temp5A;
	assign out5B= temp5B;
	assign out5C= temp5C;
	assign out6= temp6;
	assign out7= temp7;
	assign out8= temp8;
	
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
module register_file(Aout,Bout,Cin,Aadd,Badd,Cadd,clear,load,clk);//register file

input[3:0] Aadd,Badd,Cadd;
input[15:0] Cin;
input load,clear,clk;
reg[15:0] registerFile[15:0];

output[15:0] Aout,Bout;


reg[15:0] temp1,temp2,temp3;

integer i;
initial begin
registerFile[4'd1]=16'd4;
registerFile[4'd2]=16'd3;
end
always@(!clear)
	begin
	
	
	
	for(i=0;i<16;i=i+1)
	begin      //for clear ,set all to zero
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


module ALU( x,y,z,c,c_in,c_out,lt,eq,gt,overflow,clock);

input[15:0] x,y;
input[2:0] c;
output reg[15:0] z;
output reg c_in,c_out,lt,eq,gt,overflow;
reg[15:0] temp1,temp2,tempx,tempy,cin;
reg[16:0] temp3;
input clock;
always@(posedge clock)
begin

if(x<y)
begin lt=1'b1; gt=1'b0; eq=1'b0; end
  
else if(x>y)
begin lt=1'b0; gt=1'b1; eq=1'b0; end

else if(x==y)
begin lt=1'b0; gt=1'b0; eq=1'b1; end

tempx = x;
tempy = y;
tempx[15]=0;               //find c_in
tempy[15]=0;
cin = tempx + tempy;
if(cin[15]==0) c_in = 0;
else if(cin[15]==1) c_in=1;

temp3 = x+y;
if(temp3[16]==1) c_out = 1;
else if(temp3[16] == 0) c_out = 0;

overflow=c_in^c_out;


//alu operations
if(c==3'b000)//and
z=x&y;


else if(c==3'b001)//or
z=x|y;

else if(c==3'b010)//add
z=x+y;

else if(c==3'b011)//substract
begin
temp1=x;

temp2=(~y+ 16'b1);

z=temp1 + temp2;
end

else if(c==3'b111)//set less than
if(x<y) z=1;
else if(x>=y) z=0;



end
endmodule


module add(z,x,y,clock);//for addition of addresses
input [15:0] x,y;
output reg[15:0] z;
input clock;
always@(posedge clock) begin
z=x+y;
end

endmodule

module signExtend(x,y,clock); //sign extend the offset
input[3:0] x;
output reg[15:0] y;
input clock;
integer i;

always@(posedge clock) begin
for(i=0;i<16;i=i+1)
begin 
if(i<4)
y[i]=x[i];
else
y[i]=x[3];
end
end

endmodule



module leftshift(x,y,clock);//left shifting
input[15:0] x;
output reg[15:0] y;
input clock;
always@(posedge clock) begin
y=x<<1'b1;
end

endmodule

module jumpoffset(offset,current_address,output_address,clock);//getting the jump offset
input [11:0] offset;
input [15:0] current_address;
output reg [15:0] output_address;
reg [12:0] temp;
input clock;
integer i;
always@(posedge clock) begin
temp=offset<<1; //multiplying by 2
for(i=0;i<16;i=i+1)
begin
if(i<13)
output_address[i]=temp[i];
else
output_address[i]=current_address[i];//appending the first 3 didgits of current address of program counter to output address
end
end
endmodule
