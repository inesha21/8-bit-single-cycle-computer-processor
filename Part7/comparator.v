/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 6 part 2
              cpu.v
Last Updated: Wednesday, May 24, 2023 6:36:58 AM
*/

module comparator(IN1,IN2,OUT);
	input[0:2] IN1,IN2;
	output OUT;

	//xnor each bit and did and operation 
	assign #0.9 OUT = IN1[0]~^IN2[0] && IN1[1]~^IN2[1] && IN1[2]~^IN2[2];   
endmodule