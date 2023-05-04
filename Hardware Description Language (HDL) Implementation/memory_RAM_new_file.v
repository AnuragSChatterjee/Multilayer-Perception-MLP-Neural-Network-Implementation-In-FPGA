`timescale 1ns / 1ps

/* 
----------------------------------------------------------------------------------
--	(c) Rajesh C Panicker, NUS
--  Description : Module implementing a single port fully synchronous RAM to act as local memory for the AXI Stream Coprocessor
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post a modified version of this on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of any entity.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course EE4218 at the National University of Singapore);
--		(vi) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------
*/

// width is the number of bits per location; depth_bits is the number of address bits. 2^depth_bits is the number of locations

module memory_RAM
	#(
		parameter width = 8, 					// width is the number of bits per location
		parameter depth_bits = 2				// depth is the number of locations (2^number of address bits)
	) 
	(
		input clk,
		input write_en,
		input [depth_bits-1:0] write_address,
		input [width-1:0] write_data_in,
		input read_en,    
		input [depth_bits-1:0] read_address,
		output reg [width-1:0] read_data_out
	);
    
    reg [width-1:0] RAM [0:2**depth_bits-1];
    wire [depth_bits-1:0] address;
    wire enable;
    
    // to convert external signals to a form followed in the template given in Vivado synthesis manual. 
    // Not really necessary, but to follow the spirit of using templates
    assign enable = read_en | write_en;
    assign address = write_en? write_address:read_address;
    
  	// the following is from a template given in Vivado synthesis manual.
  	// Read up more about write first, read first, no change modes.

	always @(posedge clk)
	begin
		 if (enable)
		 begin
			if (write_en)
				RAM[address] <= write_data_in;
		 else
			read_data_out <= RAM[address];
		 end
	end

endmodule
