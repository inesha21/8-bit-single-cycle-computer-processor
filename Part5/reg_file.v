/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 2
              reg_file.v
Last Updated: Wednesday, May 10, 2023 10:27:08 AM
*/

// Register File module to store output values from ALU
module reg_file(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS, WRITE, CLK, RESET) ;
   
    //declaring ports

    //data input ports
    input[7:0] IN;
    //data output ports
    output[7:0] OUT1;
    output[7:0] OUT2;
    // address ports
    input[2:0] INADDRESS;
    input[2:0] OUT1ADDRESS;
    input[2:0] OUT2ADDRESS;
    //control input ports
    input WRITE;
    // clock signal and reset signal
    input CLK;
    input RESET;
   

    //declaring a register array(8*8)
    reg[7:0] REGISTER[0:7];

    /* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
         REGISTER READING OPERATION 
         --------------------------

         1. Reading the values in REGISTER specified by the provided addresses asynchronously
         2. The values are loaded onto OUT1 and OUT2
         3. Artificial delays of two time  units (#2) included

       $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
    assign #2 OUT1 = REGISTER[OUT1ADDRESS];
    assign #2 OUT2 = REGISTER[OUT2ADDRESS];

    
    /* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
         REGISTER WRITING OPERATION 
         --------------------------

         1. Positive edge triggerd with the clock pulse synchronously
         2. If RESET is enabled reset all the values of the REGISTER
         3. Else if WRITEENABLE wirte the data values into the REGISTER

       $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
    
    integer i; //parameter to iterate through the REGISTER

    // begin the continous loop at the positive edge of a clock pulse
    always @(posedge CLK)
          begin
          // if RESET is enabled Reset all the values in REGISTER
          // (Replace all values in REGISTER by 0)
          if (RESET)
               begin
               #1 // Artificial delay of one time unit
               
               for (i=0;i<8;i=i+1)
                    begin
                    REGISTER[i]<=0;
                    end
               end

          //else if check WRITEENABLE
          // if it is enabled write data values
          else
               begin
               if (WRITE)
                    begin
                    #1 // Artificial delay of one time unit
                    REGISTER[INADDRESS] <= IN;
                    end
               end
          end
     // logging reg file and dumping wave data
	initial
	begin
		#5
		$display("\t\t TIME \t R0 \t R1 \t R2 \t R3 \t R4 \t R5 \t R6 \t R7");
		$monitor($time, "\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", REGISTER[0], REGISTER[1], REGISTER[2], REGISTER[3], REGISTER[4], REGISTER[5], REGISTER[6], REGISTER[7]);
	end  

//end the module
endmodule


   