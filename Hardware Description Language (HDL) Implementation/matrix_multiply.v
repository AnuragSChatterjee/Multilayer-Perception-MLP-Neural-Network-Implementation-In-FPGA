`timescale 1ns / 1ps

/* 
----------------------------------------------------------------------------------
--	(c) Rajesh C Panicker, NUS
--  Description : Template for the Matrix Multiply unit for the AXI Stream Coprocessor
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

// those outputs which are assigned in an always block of matrix_multiply shoud be changes to reg (such as output reg Done).

module matrix_multiply
	#(	parameter width = 8, 			// width is the number of bits per location
		parameter A_depth_bits = 9, 	// for 64 x 7 matrix
		parameter B_depth_bits = 4,     // for 8 x 2 matrix
		//parameter D_depth_bits = 2, 
		parameter Interm1_depth_bits = 7 //for 64 x 2 matrix for A * B
	) 
	(
		input clk,										
		input Start,									// myip_v1_0 -> matrix_multiply_0.
		output reg Done,									// matrix_multiply_0 -> myip_v1_0. Possibly reg.
		
		output A_read_en,  								// matrix_multiply_0 -> A_RAM. Possibly reg.
		output [A_depth_bits-1:0] A_read_address, 		// matrix_multiply_0 -> A_RAM. Possibly reg.
		input [width-1:0] A_read_data_out,				// A_RAM -> matrix_multiply_0.
		
		output B_read_en, 								// matrix_multiply_0 -> B_RAM. Possibly reg.
		output [B_depth_bits-1:0] B_read_address, 		// matrix_multiply_0 -> B_RAM. Possibly reg.
		input [width-1:0] B_read_data_out,				// B_RAM -> matrix_multiply_0.
		
		output reg Interm1_write_en, 							// matrix_multiply_0 -> RES_RAM. Possibly reg.
		output reg [Interm1_depth_bits-1:0] Interm1_write_address, 	// matrix_multiply_0 -> RES_RAM. Possibly reg.
		output reg [width-1:0] Interm1_write_data_in, 			// matrix_multiply_0 -> RES_RAM. Possibly reg.
		
		input [7:0] bias_A,
		input [7:0] bias_B
	);
	
	// implement the logic to read A_RAM, read B_RAM, do the multiplication and write the results to RES_RAM
	// Note: A_RAM and B_RAM are to be read synchronously. Read the wiki for more details.
    
    reg [15:0] sum = 0;
    reg [$clog2(2**A_depth_bits):0] read_A_counter = 0; //read X matrix i.e. 64 x 7 matrix
    reg [$clog2(8):0] read_B_counter = 0; //read w_hid matrix rows i.e 8
    reg [$clog2(2**A_depth_bits - 64):0] write_counter = 0; //write result which is A*B i.e a 64 x 7 matrix

    wire [15:0] AB_PRODUCT;
    
    reg sum_delay = 0;
    assign AB_PRODUCT = A_read_data_out * B_read_data_out; 
    assign A_read_address = read_A_counter; 
    assign B_read_address = read_B_counter; 
    assign A_read_en = Start; 
    assign B_read_en = Start;
  

	always @(posedge clk) 
    begin
        if (Start) //once signal from the main state machine is given
        begin
            if (read_A_counter == 0 && write_counter == 0) 
            begin
        		sum <= bias_A << 8;
                read_A_counter <= read_A_counter + 1;
                read_B_counter <= read_B_counter + 1;
			end
            else if (write_counter == 2**Interm1_depth_bits) 
            begin
					Interm1_write_en <= 0;
					sum <= 0;
					Done <= 1;
			end
            else if ( read_A_counter == 7  && write_counter < 63) 
            begin
                 read_B_counter <= 0;
                 sum <= sum + AB_PRODUCT;
            end
            else if ( read_B_counter == 6  && write_counter < 63) 
            begin
                 read_B_counter <= 7;
                 read_A_counter <= 0;
                 sum <= sum + AB_PRODUCT;
                 sum_delay = 1;
            end
            else if(sum_delay == 1)
            begin
                sum <= sum + AB_PRODUCT;
                sum_delay <= 0;
            end
            else if ( read_B_counter == 14) 
            begin
                 read_B_counter <= 7;
                 sum <= sum + AB_PRODUCT;
            end
            else if ( (read_B_counter == 0 && write_counter < 63) | read_B_counter== 7) 
            begin
                Interm1_write_en <= 1;
                Interm1_write_address <= write_counter;
                Interm1_write_data_in <= sum[15:8];
                write_counter <= write_counter + 1;
                read_B_counter <= (write_counter < 63) ? 1:8;
                sum <= (write_counter < 63) ? bias_A << 8 : bias_B << 8;
                read_A_counter <= read_B_counter + 1;
            end

        	else begin
        		sum <= sum + AB_PRODUCT;
        		read_A_counter <= read_A_counter + 1;
        		read_B_counter <= read_B_counter + 1;
        	end   
        end
        
		else begin
			Done <= 0; 
			read_A_counter <= 0;  
			read_B_counter <= 0;   
			write_counter <= 0;
        end
    end
endmodule


