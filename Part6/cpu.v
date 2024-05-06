/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 6 part 1
              cpu.v
Last Updated: Wednesday, May 24, 2023 6:36:58 AM
*/

//including alu , register , mux , 2's compliment , Program counter
`include "alu.v"
`include "reg_file.v"
`include "mux.v"
`include "twos_compliment.v"
`include "pc_add.v"
`include "shift.v"
`include "sign_extend.v"
`include "pc_add_j_beq.v"
`include "mux32.v"



// Register File module to store output values from ALU
module cpu(PC,INSTRUCTION, CLK, RESET, BUSYWAIT, READDATA, WRITE, READ, WRITEDATA, ADDRESS);

    //////////////- Declaring ports -///////////////////
    //input Instruction
    input [31:0] INSTRUCTION;
    // clock signal and reset signal
    input CLK;
    input RESET;
    //Output port - program counter
    output reg [31:0] PC;
    //Current OPCODE for the CPU
    reg [7:0] OPCODE;
    /////////////////////////////////////////////////////

    //////////////- Declaring Connections to other modules -//////////////
    // register file
    wire[2:0] WRITEREG;    // input address to register file
    /*                        output ALURESULT from alu as input to register file */
    wire[2:0] READREG1;    // output-1  address from register file
    wire[2:0] READREG2;    // output-2 address from register file
    wire[7:0] REGOUT2;     // output-2 from reg file
    wire[7:0] REGOUT1;     // output-1 from reg file REGOUT1[7:0] 
    reg WRITEENABLE;       // Writeenable to reg file

    

    // negation mux
    wire [7:0] TWOSOUT;     // Output from the 2's compliment as input_1 to the negation_mux
    wire [7:0] NEGMUXIN;    // REGOUT2[7:0] Output from the reg file as input_2 to the negation_mux 
    wire [7:0] NEGMUXOUT;   // NEGMUXOUT[7:0] as the output from negation_mux 
    reg NEGSELECT;          // Select bit input to the negation mux

    // immediate mux
    wire [7:0] IMMEDIATE;   // immediate value as input_1 to the immediate_mux
    wire [7:0] REGVAL;    // negative value as input_2 to the immediate_mux
    wire [7:0] IMMUXOUT;    // output of the immediate mux 
    reg IMSELECT;           // Select bit input to the immediate_mux

    //  alu
    wire [7:0] DATA1,DATA2; // input operands to alu
    reg [2:0] ALUOP;        // select input to alu (for selecting operation)
    wire [7:0] ALURESULT;   // output from alu - Result
    
    // program counter
    wire [31:0] PCADDED;            // output from program_counter 
    wire [31:0] PCUPDATED;
    // jump/beq
    reg JUMPSELECT,BEQSELECT;
    wire [31:0] S_EXTENDED_OFFSET;
    wire [31:0] SE_OFFSET_SHIFTED;
    wire [31:0] PCADDED_J_BEQ;

    // data memory
    input BUSYWAIT;
    output reg READ,WRITE;
    output [7:0] ADDRESS,WRITEDATA;
    input [7:0] READDATA;
    reg DATA_MEM_SELECT;
    wire [7:0] DATAMEM_TO_REG;
    /////////////////////////////////////////////////////////////////////

    //assigning fields of instruction format
    /* |   Opcode   |   Rd/Imm(offset)    |    Rt    |  Rs/Imm  |   */

    assign WRITEREG=INSTRUCTION[23:16];  //Rd => destination register
    assign OFFSET = INSTRUCTION[23:16];  // offset value
    assign READREG1=INSTRUCTION[15:8];   //Rt => 1st operand register
    assign READREG2=INSTRUCTION[7:0];    //Rs => 2nd operand register
    assign IMMEDIATE=INSTRUCTION[7:0];   //immediate value register
    

    ////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////////////////////////////////


    //////////-Control Unit-Program Counter update-//////////////////////

    // program counter adder
    pc_add cpu_pc_add(PC,PCADDED);

    // sign exted
    sign_extend cpu_sign_extend((OFFSET+8'b00000000),S_EXTENDED_OFFSET);

    //shift
    shift cpu_shift(S_EXTENDED_OFFSET,SE_OFFSET_SHIFTED);

    // program counter adder for jump and beq
    pc_add_j_beq cpu_pc_add_j_beq(PCADDED,INSTRUCTION,SE_OFFSET_SHIFTED,PCADDED_J_BEQ);

    // always @(posedge CLK) begin //always at the +ve edge of the clock pulse
      
    //     // if reset is high program counter value=>0
    //     if (RESET==1'b1)   begin 
    //     #1 PC =0;    //+1 time unit delay
    //     end
    // end
    

    // always @(posedge CLK) begin
    // if (!BUSYWAIT) begin
    //     // PC Update
    //     #1 PC = PCUPDATED;
    //     end
    // end

    always @(posedge CLK) begin //always at the +ve edge of the clock pulse
      
        // if reset is high program counter value=>0
        if (RESET==1'b1)   begin 
        #1 PC =0;    //+1 time unit delay
        end
        else if (!BUSYWAIT) begin
        // PC Update
        #1 PC = PCUPDATED;
        end

    end
    
    // always check BUSYWAIT Signal
    always @(BUSYWAIT) begin
        // if BUSYWAIT is low disable READ and WRITE
        if (!BUSYWAIT) begin
            READ=0;
            WRITE=0;
        end
    end
    
    /////////////-Instruction Decoding-/////////////////////////////////

    always @(INSTRUCTION)   //decoding process occurs continuosly
    begin
        OPCODE=INSTRUCTION[31:24];       //Opcode field in the instruction format
        #1                              //adding 1 time unit delay
    
        case(OPCODE)
            //loadi 
            8'b00000000:	begin
                                ALUOP = 3'b000;			//Set alu to FORWARD
                                IMSELECT = 1'b1;		//Set immeiate_mux to select immediate value
                                NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
                                WRITEENABLE = 1'b1;		//Enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
                            end
            
            //mov
			8'b00000001:	begin
								ALUOP = 3'b000;			//Set alu to FORWARD
								IMSELECT = 1'b0;		//Set imm_mux to select register i/p
								NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
							end
            
            //add
			8'b00000010:	begin
								ALUOP = 3'b001;			//Set alu to ADD
								IMSELECT= 1'b0;		    //Set imm_mux to select register i/p
								NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
							end	
		
			//sub 
			8'b00000011:	begin
								ALUOP = 3'b001;			//Set alu to ADD
								IMSELECT = 1'b0;		//Set imm_mux to select register input
								NEGSELECT = 1'b1;		//Set neg_mux to select negative sign
								WRITEENABLE = 1'b1;		//Enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
							end

			//and 
			8'b00000100:	begin
								ALUOP = 3'b010;			//Set alu to AND
								IMSELECT = 1'b0;		//Set imm_mux to select register input
								NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
							end
							
			//or 
			8'b00000101:	begin
								ALUOP = 3'b011;			//Set ALU to OR
								IMSELECT = 1'b0;		//Set imm_mux to select register input
								NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
							end
            // jump
            8'b00000110:	begin
								IMSELECT = 1'b0;		//Set imm_mux to select register input
								NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
								WRITEENABLE = 1'b0;		//disable writing to register
                                JUMPSELECT=1'b1;        //enable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
							end
            // beq
            8'b00000111:	begin
								ALUOP = 3'b001;			//Set ALU to add
								IMSELECT = 1'b0;		//Set imm_mux to select register input
								NEGSELECT = 1'b1;		//Set neg_mux to select negative sign
								WRITEENABLE = 1'b0;		//disable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b1;         //enable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
							end
            // lwd
            8'b00001000:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								IMSELECT = 1'b0;		//Set imm_mux to select register input
								NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
								WRITEENABLE = 1'b1;		//enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b1;              //enable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b1;   //enable sending data to reg after reading from data memory
							end
             // lwi
            8'b00001001:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								IMSELECT = 1'b0;		//Set imm_mux to select register input
								NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
								WRITEENABLE = 1'b1;		//enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b1;              //enable READ from data memory
                                WRITE=1'b0;             //disable WRITE to data memory
                                DATA_MEM_SELECT=1'b1;   //enable sending data to reg after reading from data memory
							end
             // swd
            8'b00001010:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								IMSELECT = 1'b0;		//Set imm_mux to select register input
								NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
								WRITEENABLE = 1'b1;		//enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b1;             //enable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
							end
             // swi
            8'b00001011:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								IMSELECT = 1'b0;		//Set imm_mux to select register input
								NEGSELECT = 1'b0;		//Set neg_mux to select positive sign
								WRITEENABLE = 1'b1;		//enable writing to register
                                JUMPSELECT=1'b0;        //disable jump
                                BEQSELECT=1'b0;         //disable beq 
                                READ=1'b0;              //disable READ from data memory
                                WRITE=1'b1;             //enable WRITE to data memory
                                DATA_MEM_SELECT=1'b0;   //disable sending data to reg after reading from data memory
							end



			
        endcase
    end

    ////////- calling all the cpu modules-////////////////


    //register file
    wire WRITE_IN_REG =(WRITEENABLE & !BUSYWAIT);
    reg_file cpu_reg_file(DATAMEM_TO_REG,REGOUT1,REGOUT2,WRITEREG,READREG1,READREG2,WRITE_IN_REG,CLK,RESET);
    assign WRITEDATA=REGOUT1;
    assign ADDRESS=ALURESULT;
    
    // 2's compliment
    twos_compliment cpu_tc(REGOUT2,TWOSOUT);

    // Negation mux
    assign NEGMUXIN=REGOUT2;    //REGOUT2[7:0] Output from the reg file as input_2 to the negation_mux 
    mux cpu_neg_mux(NEGMUXIN,TWOSOUT,NEGSELECT,NEGMUXOUT);

    // Immediate mux
    assign REGVAL=NEGMUXOUT;   // negation_mux output as input_2 to the immediate_mux
    mux cpu_im_mux(REGVAL,IMMEDIATE,IMSELECT,IMMUXOUT);

    //jump or beq mux
    wire isBEQ,isJ_OR_BEQ;
    assign isBEQ = BEQSELECT & ZERO;
    assign isJ_OR_BEQ = JUMPSELECT | isBEQ;
    mux32 cpu_mux32(PCADDED,PCADDED_J_BEQ,PCUPDATED,isJ_OR_BEQ);

    //alu
    assign DATA1=REGOUT1;    // output-1 from reg file REGOUT1[7:0] is DATA1 input to alu
    assign DATA2=IMMUXOUT;   // output of the immediate mux is DATA2 input to the ALU 
    alu cpu_alu(DATA1,DATA2,ALURESULT,ALUOP,ZERO);

    //data memmory mux
    mux data_mem_mux(ALURESULT, READDATA,DATA_MEM_SELECT,DATAMEM_TO_REG);
    



endmodule