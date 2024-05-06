/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 1
              alu_part1_group13.v
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

///////////////////////////////////////////////////////////////
// main module
module alu(DATA1, DATA2, RESULT, SELECT);
    //declaring ports
    input [7:0] DATA1,DATA2;
    input [2:0] SELECT; 
    //declaring output port register
    output reg [7:0] RESULT;
    //declaring wires
    wire [7:0]  ANS_FORWARD,ANS_ADD,ANS_AND,ANS_OR;

    // instantiating modules
    aluFORWARD f1(DATA2,ANS_FORWARD);
    aluADD f2(DATA1,DATA2,ANS_ADD);
    aluAND f3(DATA1,DATA2,ANS_AND);
    aluOR f4(DATA1,DATA2,ANS_OR);

    //
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
            default:
                // IF (SELECT == 1XX)    => no operations executed for now
                RESULT=8'b00000000;
        // end of switch case
        endcase
            
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
    end

endmodule

*/
            