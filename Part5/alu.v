/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 5
              alu_.v
Last Updated: Tuesday, May 9, 2023 4:30:38 PM
*/

// function for FORWARD operation
module aluFORWARD(DATA2,RESULT); // start module
    // declaring ports
    input [7:0] DATA2;
    output [7:0] RESULT;
    // assigning the result and the delay
    assign #1 RESULT=DATA2;
endmodule                        // end module

// function for ADD operation
module aluADD(DATA1,DATA2,RESULT); // start module
    // declaring ports
    input [7:0] DATA1,DATA2;
    output [7:0] RESULT;
    // assigning the result and the delay
    assign #2 RESULT=DATA1+DATA2;
endmodule                        // end module

// function for AND operation
module aluAND(DATA1,DATA2,RESULT); // start module
    // declaring ports
    input [7:0] DATA1,DATA2;
    output [7:0] RESULT;
    // assigning the result and the delay
    assign #1 RESULT=DATA1&DATA2;
endmodule                        // end module

// function for OR operation
module aluOR(DATA1,DATA2,RESULT); // start module
    // declaring ports
    input [7:0] DATA1,DATA2;
    output [7:0] RESULT;
    // assigning the result and the delay
    assign #1 RESULT=DATA1|DATA2;
endmodule                        // end module

// Full Adder module for ALU multiplication
module FullAdder(A,B,Cin,S,Cout);

    //decalring ports
    input A,B,Cin;
    output S,Cout;
    // Full Adder logic
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));
endmodule

// Function for MULTIPLICATION
module aluMULT(MULTIPLICAND, MULTIPLIER, OUT);

	//Input and output port declaration
	input [7:0] MULTIPLICAND, MULTIPLIER;
	output [7:0] OUT;
	
	//Carry bits for intermediate carries
	wire C0 [5:0];
	wire C1 [4:0];
	wire C2 [3:0];
	wire C3 [2:0];
	wire C4 [1:0];
	wire C5;
	
	//Intermediate sums
	wire sum0 [5:0];
	wire sum1 [4:0];
	wire sum2 [3:0];
	wire sum3 [2:0];
	wire sum4 [1:0];
	wire sum5;
	
	//Bus to store result before output
	wire [7:0] RESULT;
	
	//First bit of RESULT can be directly set
	assign RESULT[0] = MULTIPLIER[0] & MULTIPLICAND[0];	
	
	
	//Full Adder array to calculate result by shifting and adding
	//level 0
	FullAdder FA0_0(MULTIPLIER[0] & MULTIPLICAND[1], MULTIPLIER[1] & MULTIPLICAND[0], 1'b0, RESULT[1], C0[0]);
	FullAdder FA0_1(MULTIPLIER[0] & MULTIPLICAND[2], MULTIPLIER[1] & MULTIPLICAND[1], C0[0], sum0[0], C0[1]);
	FullAdder FA0_2(MULTIPLIER[0] & MULTIPLICAND[3], MULTIPLIER[1] & MULTIPLICAND[2], C0[1], sum0[1], C0[2]);
	FullAdder FA0_3(MULTIPLIER[0] & MULTIPLICAND[4], MULTIPLIER[1] & MULTIPLICAND[3], C0[2], sum0[2], C0[3]);
	FullAdder FA0_4(MULTIPLIER[0] & MULTIPLICAND[5], MULTIPLIER[1] & MULTIPLICAND[4], C0[3], sum0[3], C0[4]);
	FullAdder FA0_5(MULTIPLIER[0] & MULTIPLICAND[6], MULTIPLIER[1] & MULTIPLICAND[5], C0[4], sum0[4], C0[5]);
	FullAdder FA0_6(MULTIPLIER[0] & MULTIPLICAND[7], MULTIPLIER[1] & MULTIPLICAND[6], C0[5], sum0[5], );
	
	//level 1
	FullAdder FA1_0(sum0[0], MULTIPLIER[2] & MULTIPLICAND[0], 1'b0, RESULT[2], C1[0]);
	FullAdder FA1_1(sum0[1], MULTIPLIER[2] & MULTIPLICAND[1], C1[0], sum1[0], C1[1]);
	FullAdder FA1_2(sum0[2], MULTIPLIER[2] & MULTIPLICAND[2], C1[1], sum1[1], C1[2]);
	FullAdder FA1_3(sum0[3], MULTIPLIER[2] & MULTIPLICAND[3], C1[2], sum1[2], C1[3]);
	FullAdder FA1_4(sum0[4], MULTIPLIER[2] & MULTIPLICAND[4], C1[3], sum1[3], C1[4]);
	FullAdder FA1_5(sum0[5], MULTIPLIER[2] & MULTIPLICAND[5], C1[4], sum1[4], );
	
	//level 2
	FullAdder FA2_0(sum1[0], MULTIPLIER[3] & MULTIPLICAND[0], 1'b0, RESULT[3], C2[0]);
	FullAdder FA2_1(sum1[1], MULTIPLIER[3] & MULTIPLICAND[1], C2[0], sum2[0], C2[1]);
	FullAdder FA2_2(sum1[2], MULTIPLIER[3] & MULTIPLICAND[2], C2[1], sum2[1], C2[2]);
	FullAdder FA2_3(sum1[3], MULTIPLIER[3] & MULTIPLICAND[3], C2[2], sum2[2], C2[3]);
	FullAdder FA2_4(sum1[4], MULTIPLIER[3] & MULTIPLICAND[4], C2[3], sum2[3], );
	
	//level 3
	FullAdder FA3_0(sum2[0], MULTIPLIER[4] & MULTIPLICAND[0], 1'b0, RESULT[4], C3[0]);
	FullAdder FA3_1(sum2[1], MULTIPLIER[4] & MULTIPLICAND[1], C3[0], sum3[0], C3[1]);
	FullAdder FA3_2(sum2[2], MULTIPLIER[4] & MULTIPLICAND[2], C3[1], sum3[1], C3[2]);
	FullAdder FA3_3(sum2[3], MULTIPLIER[4] & MULTIPLICAND[3], C3[2], sum3[2], );
	
	//level 4
	FullAdder FA4_0(sum3[0], MULTIPLIER[5] & MULTIPLICAND[0], 1'b0, RESULT[5], C4[0]);
	FullAdder FA4_1(sum3[1], MULTIPLIER[5] & MULTIPLICAND[1], C4[0], sum4[0], C4[1]);
	FullAdder FA4_2(sum3[2], MULTIPLIER[5] & MULTIPLICAND[2], C4[1], sum4[1], );
	
	//level 5
	FullAdder FA5_0(sum4[0], MULTIPLIER[6] & MULTIPLICAND[0], 1'b0, RESULT[6], C5);
	FullAdder FA5_1(sum4[1], MULTIPLIER[6] & MULTIPLICAND[1], C5, sum5, );
	
	//level 6
	FullAdder FA6_0(sum5, MULTIPLIER[7] & MULTIPLICAND[0], 1'b0, RESULT[7], );
	
	//assigning RESULT 
    // +3 seconds artificial delay
	assign #3 OUT = RESULT;

endmodule

//3x1 MUX Module
module mux3x1 (out , in2 , in1 , in0 , s);
	//declaring ports
    input in0,in1,in2;
    output out ; 
    input [1:0] s ;
    wire orIn [2:0] ;
    wire andOut[2:0];

	//mux circuit
    or (out , orIn[0], orIn[1] , orIn[2]);

    and(andOut[0] , !s[0],!s[1]);
    and (orIn[0] , in0 , andOut[0]);
    and(andOut[1] , s[0],!s[1]);
    and (orIn[1] , in1 , andOut[1]);
    and(andOut[2] , !s[0],s[1]);
    and (orIn[2] , in2 , andOut[2]);

endmodule

//2x1 MUX Module
module mux2x1(out, in0,in1,s);
	//declaring ports
    input in0, in1,s;
    output out ;
    wire orIn0 ,orIn1;

	//mux circuit
    and (orIn0,in0,!s);
    and (orIn1,in1,s);
    or (out , orIn0,orIn1);
	
endmodule


// function for LEFT SHIFT operation
module alu_lshift(data1 , data2 , OutPut);

	//Declaration of input and output ports
    input [7:0] data1 ,data2 ;
    output [7:0] OutPut;
    
	//Intermediate connections between MUX layers 
    wire [7:0] lOut [2:0];
    wire s[7:0];


	//MUX Level 1
    mux2x1 layer00(lOut[0][0],data1[0],1'b0,data2[0]);
    mux2x1 layer01(lOut[0][1],data1[1],data1[0],data2[0]);
    mux2x1 layer02(lOut[0][2],data1[2],data1[1],data2[0]);
    mux2x1 layer03(lOut[0][3],data1[3],data1[2],data2[0]);
    mux2x1 layer04(lOut[0][4],data1[4],data1[3],data2[0]);
    mux2x1 layer05(lOut[0][5],data1[5],data1[4],data2[0]);
    mux2x1 layer06(lOut[0][6],data1[6],data1[5],data2[0]);
    mux2x1 layer07(lOut[0][7],data1[7],data1[6],data2[0]);
  
	//MUX level 2
    mux2x1 layer10(lOut[1][0],lOut[0][0],1'b0,data2[1]);    
    mux2x1 layer11(lOut[1][1],lOut[0][1],1'b0,data2[1]);
    mux2x1 layer12(lOut[1][2],lOut[0][2],lOut[0][0],data2[1]);
    mux2x1 layer13(lOut[1][3],lOut[0][3],lOut[0][1],data2[1]);
    mux2x1 layer14(lOut[1][4],lOut[0][4],lOut[0][2],data2[1]);
    mux2x1 layer15(lOut[1][5],lOut[0][5],lOut[0][3],data2[1]);
    mux2x1 layer16(lOut[1][6],lOut[0][6],lOut[0][4],data2[1]);
    mux2x1 layer17(lOut[1][7],lOut[0][7],lOut[0][5],data2[1]);
  
	//MUX level 3
    mux2x1 layer20(lOut[2][0],lOut[1][0],1'b0,data2[2]);    
    mux2x1 layer21(lOut[2][1],lOut[1][1],1'b0,data2[2]);
    mux2x1 layer22(lOut[2][2],lOut[1][2],1'b0,data2[2]);
    mux2x1 layer23(lOut[2][3],lOut[1][3],1'b0,data2[2]);
    mux2x1 layer24(lOut[2][4],lOut[1][4],lOut[1][0],data2[2]);
    mux2x1 layer25(lOut[2][5],lOut[1][5],lOut[1][1],data2[2]);
    mux2x1 layer26(lOut[2][6],lOut[1][6],lOut[1][2],data2[2]);
    mux2x1 layer27(lOut[2][7],lOut[1][7],lOut[1][3],data2[2]);

	//Assigning final output after 2 time unit delay
	//If shift amount is 0x08 output is all zeros
    assign #2 OutPut= (data2==8'd8)? 8'b00000000:lOut[2];
	
endmodule

// function for RIGHT SHIFT ARIthmatic operation
module alu_rshift(data1 , data2 , OutPut);

	//Declaration of input and output ports
    input [7:0] data1 ,data2 ;
    output reg [7:0] OutPut ;


	//Connections between layers
    wire [7:0] lOut [2:0];
    //wire s[7:0] ;
	
	//Connections for selecting between logical shift, arithmetic shift and rotate operations
    wire m07;
    wire m17, m16;
    wire m27, m26, m25, m24;


	//MUX level 1
    /* 8* 2x1 muxes
       1* 3x1 muxes
    */
    mux2x1 layer00(lOut[0][0],data1[0],data1[1],data2[0]);
    mux2x1 layer01(lOut[0][1],data1[1],data1[2],data2[0]);
    mux2x1 layer02(lOut[0][2],data1[2],data1[3],data2[0]);
    mux2x1 layer03(lOut[0][3],data1[3],data1[4],data2[0]);
    mux2x1 layer04(lOut[0][4],data1[4],data1[5],data2[0]);
    mux2x1 layer05(lOut[0][5],data1[5],data1[6],data2[0]);
    mux2x1 layer06(lOut[0][6],data1[6],data1[7],data2[0]);
    mux2x1 layer07(lOut[0][7],data1[7],m07,data2[0]);
    mux3x1 M07(m07,data1[0],data1[7],1'b0,data2[7:6]);
  
	//MUX level 2
    /* 8* 2x1 muxes
       2* 3x1 muxes
    */
    mux2x1 layer10(lOut[1][0],lOut[0][0],lOut[0][2],data2[1]);    
    mux2x1 layer11(lOut[1][1],lOut[0][1],lOut[0][3],data2[1]);
    mux2x1 layer12(lOut[1][2],lOut[0][2],lOut[0][4],data2[1]);
    mux2x1 layer13(lOut[1][3],lOut[0][3],lOut[0][5],data2[1]);
    mux2x1 layer14(lOut[1][4],lOut[0][4],lOut[0][6],data2[1]);
    mux2x1 layer15(lOut[1][5],lOut[0][5],lOut[0][7],data2[1]);
    mux2x1 layer16(lOut[1][6],lOut[0][6],m16,data2[1]);
    mux3x1 M16(m16,lOut[0][0],lOut[0][7],1'b0,data2[7:6]);
    mux2x1 layer17(lOut[1][7],lOut[0][7],m17,data2[1]);
    mux3x1 M17(m17,lOut[0][1],lOut[0][7],1'b0,data2[7:6]);
 
   //MUX level 3  
   /*   8  *  2x1 muxes
        4  * 3x1 muxes
   */
  	mux2x1 layer20(lOut[2][0],lOut[1][0],lOut[1][4],data2[2]);    
    mux2x1 layer21(lOut[2][1],lOut[1][1],lOut[1][5],data2[2]);
    mux2x1 layer22(lOut[2][2],lOut[1][2],lOut[1][6],data2[2]);
    mux2x1 layer23(lOut[2][3],lOut[1][3],lOut[1][7],data2[2]);
    mux2x1 layer24(lOut[2][4],lOut[1][4],m24,data2[2]);
    mux3x1 M24(m24,lOut[1][0],lOut[1][7],1'b0,data2[7:6]);
    mux2x1 layer25(lOut[2][5],lOut[1][5],m25,data2[2]);
    mux3x1 M25(m25,lOut[1][1],lOut[1][7],1'b0,data2[7:6]);
    mux2x1 layer26(lOut[2][6],lOut[1][6],m26,data2[2]);
    mux3x1 M26(m26,lOut[1][2],lOut[1][7],1'b0,data2[7:6]);
    mux2x1 layer27(lOut[2][7],lOut[1][7],m27,data2[2]);
    mux3x1 M027(m27,lOut[1][3],lOut[1][7],1'b0,data2[7:6]);
    
	
	//always take inputs and give output with +2 artificial delay
	always @ (data1, data2, lOut[2])
	begin
		if (data2[7:6] == 2'b10) #2 OutPut = lOut[2];		//If rotate, send output
		
		else if (data2[7:6] == 2'b01)
		begin
			if (data2[3:0] == 4'd8) #2 OutPut = {8{data1[7]}};	//If arithmetic and shift amount is 0x08, set all bits to sign bit
			else #2 OutPut = lOut[2];		//Else, send output
		end
		
		else if (data2[7:6] == 2'b00)
		begin
			if (data2[3:0] == 4'd8) #2 OutPut = 8'b0;	//If logical and shift amount is 0x08, set all bits to zero
			else #5 OutPut = lOut[2];		//Else, send output
		end
    end

endmodule

// function for RIGHT SHIFT operation
module alu_rshift_arith(data1 , data2 , OutPut);

	//Declaration of input and output ports
    input [7:0] data1 ,data2 ;
    output reg [7:0] OutPut ;


	//Connections between layers
    wire [7:0] lOut [2:0];
    //wire s[7:0] ;
	
	//Connections for selecting between logical shift, arithmetic shift and rotate operations
    wire m07;
    wire m17, m16;
    wire m27, m26, m25, m24;


	//MUX level 1
    /* 8* 2x1 muxes
       1* 3x1 muxes
    */
    mux2x1 layer00(lOut[0][0],data1[0],data1[1],data2[0]);
    mux2x1 layer01(lOut[0][1],data1[1],data1[2],data2[0]);
    mux2x1 layer02(lOut[0][2],data1[2],data1[3],data2[0]);
    mux2x1 layer03(lOut[0][3],data1[3],data1[4],data2[0]);
    mux2x1 layer04(lOut[0][4],data1[4],data1[5],data2[0]);
    mux2x1 layer05(lOut[0][5],data1[5],data1[6],data2[0]);
    mux2x1 layer06(lOut[0][6],data1[6],data1[7],data2[0]);
    mux2x1 layer07(lOut[0][7],data1[7],m07,data2[0]);
    mux3x1 M07(m07,data1[0],data1[7],1'b0,data2[7:6]);
  
	//MUX level 2
    /* 8* 2x1 muxes
       2* 3x1 muxes
    */
    mux2x1 layer10(lOut[1][0],lOut[0][0],lOut[0][2],data2[1]);    
    mux2x1 layer11(lOut[1][1],lOut[0][1],lOut[0][3],data2[1]);
    mux2x1 layer12(lOut[1][2],lOut[0][2],lOut[0][4],data2[1]);
    mux2x1 layer13(lOut[1][3],lOut[0][3],lOut[0][5],data2[1]);
    mux2x1 layer14(lOut[1][4],lOut[0][4],lOut[0][6],data2[1]);
    mux2x1 layer15(lOut[1][5],lOut[0][5],lOut[0][7],data2[1]);
    mux2x1 layer16(lOut[1][6],lOut[0][6],m16,data2[1]);
    mux3x1 M16(m16,lOut[0][0],lOut[0][7],1'b0,data2[7:6]);
    mux2x1 layer17(lOut[1][7],lOut[0][7],m17,data2[1]);
    mux3x1 M17(m17,lOut[0][1],lOut[0][7],1'b0,data2[7:6]);
 
   //MUX level 3  
   /*   8  *  2x1 muxes
        4  * 3x1 muxes
   */
  	mux2x1 layer20(lOut[2][0],lOut[1][0],lOut[1][4],data2[2]);    
    mux2x1 layer21(lOut[2][1],lOut[1][1],lOut[1][5],data2[2]);
    mux2x1 layer22(lOut[2][2],lOut[1][2],lOut[1][6],data2[2]);
    mux2x1 layer23(lOut[2][3],lOut[1][3],lOut[1][7],data2[2]);
    mux2x1 layer24(lOut[2][4],lOut[1][4],m24,data2[2]);
    mux3x1 M24(m24,lOut[1][0],lOut[1][7],1'b0,data2[7:6]);
    mux2x1 layer25(lOut[2][5],lOut[1][5],m25,data2[2]);
    mux3x1 M25(m25,lOut[1][1],lOut[1][7],1'b0,data2[7:6]);
    mux2x1 layer26(lOut[2][6],lOut[1][6],m26,data2[2]);
    mux3x1 M26(m26,lOut[1][2],lOut[1][7],1'b0,data2[7:6]);
    mux2x1 layer27(lOut[2][7],lOut[1][7],m27,data2[2]);
    mux3x1 M027(m27,lOut[1][3],lOut[1][7],1'b0,data2[7:6]);
    
	
	//always take inputs and give output with +2 artificial delay
	always @ (data1, data2, lOut[2])
	begin
		if (data2[7:6] == 2'b10) #2 OutPut = lOut[2];		//If rotate, send output
		
		else if (data2[7:6] == 2'b01)
		begin
			if (data2[3:0] == 4'd8) #2 OutPut = {8{data1[7]}};	//If arithmetic and shift amount is 0x08, set all bits to sign bit
			else #2 OutPut = lOut[2];		//Else, send output
		end
		
		else if (data2[7:6] == 2'b00)
		begin
			if (data2[3:0] == 4'd8) #2 OutPut = 8'b0;	//If logical and shift amount is 0x08, set all bits to zero
			else #5 OutPut = lOut[2];		//Else, send output
		end
    end


endmodule

///////////////////////////////////////////////////////////////
// main module -- modified foe lab5.4 with zero
module alu(DATA1, DATA2, RESULT, SELECT,ZERO);
    //declaring ports
    input [7:0] DATA1,DATA2;
    input [2:0] SELECT; 
    //declaring output port register
    output reg [7:0] RESULT;
    output reg ZERO; // newly added ZERO
    //declaring wires
    wire [7:0]  ANS_FORWARD,ANS_ADD,ANS_AND,ANS_OR,ANS_MULT,ANS_LSHIFT,ANS_RSHIFT,ANS_RSHIFTAR;

    
    // instantiating modules
    aluFORWARD f1(DATA2,ANS_FORWARD);
    aluADD f2(DATA1,DATA2,ANS_ADD);
    aluAND f3(DATA1,DATA2,ANS_AND);
    aluOR f4(DATA1,DATA2,ANS_OR);
    aluMULT f5(DATA1,DATA2,ANS_MULT);
    alu_lshift f6(DATA1,DATA2,ANS_LSHIFT);
    alu_rshift f7(DATA1,DATA2,ANS_RSHIFT);
    alu_rshift_arith f8(DATA1,DATA2,ANS_RSHIFTAR);
    

    
    always @(DATA1,DATA2,RESULT)
    begin
        // switch case 
        case(SELECT)
            3'b000:
                // IF (SELECT == 000)    => FORWARD
                assign RESULT=ANS_FORWARD;
            3'b001:
                // IF (SELECT == 001)    => ADD
                assign RESULT=ANS_ADD;
            3'b010:
                // IF (SELECT == 010)    => AND
                assign RESULT=ANS_AND;
            3'b011:
                // IF (SELECT == 011)    => OR
                assign RESULT=ANS_OR;
            3'b100:
                // IF (SELECT == 100)    => MULT
                assign RESULT=ANS_MULT;
            3'b101:
                // IF (SELECT == 101)    => LEFT SHIFT
                assign RESULT=ANS_LSHIFT;
            3'b110:
                // IF (SELECT == 110)    => RIGHT SHIFT
                assign RESULT=ANS_RSHIFT;
            3'b111:
                // IF (SELECT == 111)    => RIGHT ROTATE
                assign RESULT=ANS_RSHIFT;
        // end of switch case
        endcase
            
    end
    

    always @(ANS_ADD) begin
        if(ANS_ADD==8'b00000000) begin
            ZERO =1'b1;
        end

        else begin
            ZERO=1'b0;
        end
    end

endmodule


/*
//Test values   - Tested and properly functioning
module stimulus;
    reg [7:0] DATA1, DATA2;
    reg [2:0] SELECT;
    wire [7:0] RESULT;

    //calling the alu module
    alu alu1(DATA1,DATA2,RESULT,SELECT);

    initial begin
        //testing FORWARD operation
        DATA1 = 8'b00001001;    
        DATA2 = 8'b01100011;    
        SELECT = 3'b000;
        #5
        $display("%b FORWARD %b = %b", DATA1, DATA2, RESULT);

        //testing ADD operation
        DATA1 = 8'b10001111;
        DATA2 = 8'b00001001;
        SELECT = 3'b001;
        #2
        $display("%b   ADD   %b = %b", DATA1, DATA2, RESULT);

        //testing AND opertion 
        DATA1 = 8'b00001111;
        DATA2 = 8'b01011001;
        SELECT = 3'b010;
        #2
        $display("%b   AND   %b = %b", DATA1, DATA2, RESULT);

        //testing OR operation
        DATA1 = 8'b00001111;
        DATA2 = 8'b01111001;
        SELECT = 3'b011;
        #2
        $display("%b    OR   %b = %b", DATA1, DATA2, RESULT);

        //testing MULT operation
        DATA1 = 8'b00000100;
        DATA2 = 8'b00001000;
        SELECT = 3'b100;
        #6
        $display("%d    MULT   %d = %d", DATA1, DATA2, RESULT);

        //testing LEFT SHIFT operation
        DATA1 = 8'b00010000;
        DATA2 = 8'b00000010;
        SELECT = 3'b101;
        #6
        $display("%d    LSL   %d = %d", DATA1, DATA2, RESULT);

        //testing RIGHT SHIFT operation
        DATA1 = 8'b00000100;
        DATA2 = 8'b00001000;
        SELECT = 3'b110;
        #6
        $display("%d    LSR   %d = %d", DATA1, DATA2, RESULT);

        // //testing RIGHT SHIFT operation
        // DATA1 = 8'b00000010;
        // DATA2 = 8'b00001000;
        // SELECT = 3'b111;
        // #10
        // $display("%d    ROR   %d = %d", DATA1, DATA2, RESULT);
    end

endmodule

*/
            