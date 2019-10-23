/* ACM Class System (I) 2018 Fall Assignment 1 
 *
 * Part I: Write an adder in Verilog
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */
 
	// TODO: Write the ports of this module here
	//
	// Hint: 
	//   The module needs 4 ports, 
	//     the first 2 ports input two 16-bit unsigned numbers as the addends
	//     the third port outputs a 16-bit unsigned number as the sum
	//	   the forth port outputs a 1-bit carry flag as the overflow
	// 
	// TODO: Implement this module here
	// Hint: You can use generate statement in Verilog to create multiple instantiations of modules and code.
	
module adder(in1, in2, out, overflow);
    input in1, in2;
    output out, overflow;
    
    wire[15:0] in1, in2;
    reg[15:0] out;
    reg overflow;
    
    integer i;
    
    initial begin
        overflow = 0;
    end
    
    always @ (in1, in2) begin
            overflow = 0;
            for (i = 0; i < 16; i = i + 1) begin
                out[i] = in1[i] ^ in2[i] ^ overflow;
                overflow = (in1[i] & in2[i]) | ((in1[i] ^ in2[i]) & overflow);
            end
        end
endmodule