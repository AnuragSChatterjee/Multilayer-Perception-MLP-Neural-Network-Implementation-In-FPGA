/* 
----------------------------------------------------------------------------------
--	(c) Rajesh C Panicker, NUS
--  Description : Matrix Multiplication AXI Stream Coprocessor. Based on the orginal AXIS Coprocessor template (c) Xilinx Inc
-- 	Based on the orginal AXIS coprocessor template (c) Xilinx Inc
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
/*
-------------------------------------------------------------------------------
--
-- Definition of Ports
-- ACLK              : Synchronous clock
-- ARESETN           : System reset, active low
-- S_AXIS_TREADY  : Ready to accept data in
-- S_AXIS_TDATA   :  Data in 
-- S_AXIS_TLAST   : Optional data in qualifier
-- S_AXIS_TVALID  : Data in is valid
-- M_AXIS_TVALID  :  Data out is valid
-- M_AXIS_TDATA   : Data Out
-- M_AXIS_TLAST   : Optional data out qualifier
-- M_AXIS_TREADY  : Connected slave device is ready to accept data out
--
-------------------------------------------------------------------------------
*/

module myip_v1_0 
	(
		// DO NOT EDIT BELOW THIS LINE ////////////////////
		ACLK,
		ARESETN,
		S_AXIS_TREADY,
		S_AXIS_TDATA,
		S_AXIS_TLAST,
		S_AXIS_TVALID,
		M_AXIS_TVALID,
		M_AXIS_TDATA,
		M_AXIS_TLAST,
		M_AXIS_TREADY
		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);

	input					ACLK;    // Synchronous clock
	input					ARESETN; // System reset, active low
	// slave in interface
	output	reg				S_AXIS_TREADY;  // Ready to accept data in
	input	[31 : 0]		S_AXIS_TDATA;   // Data in
	input					S_AXIS_TLAST;   // Optional data in qualifier
	input					S_AXIS_TVALID;  // Data in is valid
	// master out interface
	output	reg				M_AXIS_TVALID;  // Data out is valid
	output  wire [31 : 0]   M_AXIS_TDATA;   // Data Out
	output					M_AXIS_TLAST;   // Optional data out qualifier
	input					M_AXIS_TREADY;  // Connected slave device is ready to accept data out

//----------------------------------------
// Implementation Section
//----------------------------------------
// In this section, we povide an example implementation of MODULE myip_v1_0
// that does the following:
//
// 1. Read all inputs
// 2. Add each input to the contents of register 'sum' which acts as an accumulator
// 3. After all the inputs have been read, write out the content of 'sum', 'sum+1', 'sum+2', 'sum+3'
//
// You will need to modify this example for
// MODULE myip_v1_0 to implement your coprocessor

 
// RAM parameters for assignment 1
	localparam A_depth_bits = 9;  	// X matrix (A is a 64x7 matrix so just keeping it at 2**9 which is 512
	localparam B_depth_bits = 4; 	// w_hid (B is a 8x2 matrix)
	localparam C_depth_bits = 2;  	// w_out matrix (C is a 3x1 matrix so keeping it as 2**2 which is 4)
	localparam RES_depth_bits = 7;	// to store A * B first which is a 64 x 2 matrix
	
	localparam Interm1_depth_bits = 7;	// 2 elements (RES is a 2x1 matrix), 128 elements (RES = 64 x 2 matrix)
    localparam Interm2_depth_bits = 7;	// 2 elements (RES is a 2x1 matrix), 128 elements (RES = 64 x 2 matrix) which feeds in from Interm1
	localparam width = 8;			// all 8-bit data
	
// wires (or regs) to connect to RAMs and matrix_multiply_0 for assignment 1
// those which are assigned in an always block of myip_v1_0 shoud be changes to reg.
	reg    	A_write_en;								// myip_v1_0 -> A_RAM. To be assigned within myip_v1_0. Possibly reg.
	reg    	[A_depth_bits-1:0] A_write_address;		// myip_v1_0 -> A_RAM. To be assigned within myip_v1_0. Possibly reg. 
	reg	   [width-1:0] A_write_data_in;			// myip_v1_0 -> A_RAM. To be assigned within myip_v1_0. Possibly reg.
	wire	A_read_en;								// matrix_multiply_0 -> A_RAM.
	wire	[A_depth_bits-1:0] A_read_address;		// matrix_multiply_0 -> A_RAM.
	wire	[width-1:0] A_read_data_out;			// A_RAM -> matrix_multiply_0.
	
	reg    	B_write_en;								// myip_v1_0 -> B_RAM. To be assigned within myip_v1_0. Possibly reg.
	reg	   [B_depth_bits-1:0] B_write_address;		// myip_v1_0 -> B_RAM. To be assigned within myip_v1_0. Possibly reg.
    reg	    [width-1:0] B_write_data_in;			// myip_v1_0 -> B_RAM. To be assigned within myip_v1_0. Possibly reg.
	wire	B_read_en;								// matrix_multiply_0 -> B_RAM.
	wire	[B_depth_bits-1:0] B_read_address;		// matrix_multiply_0 -> B_RAM.
	wire	[width-1:0] B_read_data_out;			// B_RAM -> matrix_multiply_0.
	
	reg    	C_write_en;								// myip_v1_0 -> B_RAM. To be assigned within myip_v1_0. Possibly reg.
	reg	   [C_depth_bits-1:0] C_write_address;		// myip_v1_0 -> B_RAM. To be assigned within myip_v1_0. Possibly reg.
    reg	    [width-1:0] C_write_data_in;			// myip_v1_0 -> B_RAM. To be assigned within myip_v1_0. Possibly reg.
	wire	C_read_en;								// matrix_multiply_0 -> B_RAM.
	wire	[C_depth_bits-1:0] C_read_address;		// matrix_multiply_0 -> B_RAM.
	wire	[width-1:0] C_read_data_out;			// B_RAM -> matrix_multiply_0.

	wire	RES_write_en;							// matrix_multiply_0 -> RES_RAM.
	wire	[RES_depth_bits-1:0] RES_write_address;	// matrix_multiply_0 -> RES_RAM.
	wire	[width-1:0] RES_write_data_in;			// matrix_multiply_0 -> RES_RAM.
	reg    	RES_read_en = 0;  							// myip_v1_0 -> RES_RAM. To be assigned within myip_v1_0. Possibly reg.
	wire	[RES_depth_bits-1:0] RES_read_address;	// myip_v1_0 -> RES_RAM. To be assigned within myip_v1_0. Possibly reg.
	wire	[width-1:0] RES_read_data_out;			// RES_RAM -> myip_v1_0
	
	wire	Interm1_write_en;							// matrix_multiply_0 -> RES_RAM.
	wire	[Interm1_depth_bits-1:0] Interm1_write_address;	// matrix_multiply_0 -> RES_RAM.
	wire	[width-1:0] Interm1_write_data_in;			// matrix_multiply_0 -> RES_RAM.
	wire    Interm1_read_en;  							// myip_v1_0 -> RES_RAM. To be assigned within myip_v1_0. Possibly reg.
	wire	[Interm1_depth_bits-1:0] Interm1_read_address;	// myip_v1_0 -> RES_RAM. To be assigned within myip_v1_0. Possibly reg.
	wire	[width-1:0] Interm1_read_data_out;			// RES_RAM -> myip_v1_0
	
	wire	Interm2_write_en;							// matrix_multiply_0 -> RES_RAM.
	wire	[Interm2_depth_bits-1:0] Interm2_write_address;	// matrix_multiply_0 -> RES_RAM.
	wire	[width-1:0] Interm2_write_data_in;			// matrix_multiply_0 -> RES_RAM.
	reg    	Interm2_read_en = 0;  							// myip_v1_0 -> RES_RAM. To be assigned within myip_v1_0. Possibly reg.
	wire	[Interm2_depth_bits-1:0] Interm2_read_address;	// myip_v1_0 -> RES_RAM. To be assigned within myip_v1_0. Possibly reg.
	wire	[width-1:0] Interm2_read_data_out;			// RES_RAM -> myip_v1_0
	
	// wires (or regs) to connect to matrix_multiply for assignment 1
	reg	Start; 								// myip_v1_0 -> matrix_multiply_0. To be assigned within myip_v1_0. Possibly reg.
	wire Done;								// matrix_multiply_0 -> myip_v1_0. 
	
	reg Start_Sigmoid; //Starts sigmoid function call
	wire End_Sigmoid; //Ends sigmoid function call		
				
	// Total number of input data.
	localparam NUMBER_OF_A_WORDS = (2**A_depth_bits - 64); //448 data points for 64 x 7 matrix
	localparam NUMBER_OF_B_WORDS = 2**B_depth_bits; //4 data points for 8 x 2 matrix
	localparam NUMBER_OF_C_WORDS = (2**C_depth_bits - 1); //3 data points for 3 x 1 matrix
	//localparam NUMBER_OF_SIG_WORDS = 2**Sig_depth_bits;
	
    localparam NUMBER_OF_INPUT_WORDS = NUMBER_OF_A_WORDS + NUMBER_OF_B_WORDS + NUMBER_OF_C_WORDS; //467 in total
	// Total number of output data
	localparam NUMBER_OF_OUTPUT_WORDS = 2**RES_depth_bits;  

	// Total number of output data
	//localparam NUMBER_OF_OUTPUT_WORDS = 128; // 2**RES_depth_bits = 2 for assignment 1

	// Define the states of state machine (one hot encoding)
	localparam Idle  = 5'b10000;
	localparam Read_Inputs = 5'b01000;
	localparam Compute = 5'b00100;
	localparam Compute_Last_Layer = 5'b0010;
	localparam Write_Outputs  = 5'b0001;

	reg [4:0] state;

	// Accumulator to hold sum of inputs read at any point in time
	// reg [31:0] sum;

	// Counters to store the number inputs read & outputs written.
	// Could be done using the same counter if reads and writes are not overlapped (i.e., no dataflow optimization)
	// Left as separate for ease of debugging
	reg [$clog2(NUMBER_OF_INPUT_WORDS) - 1:0] read_input_counter; //counter to read all matrix values 
	reg [RES_depth_bits:0] write_RES_counter; //counter to compute the final result value 
    
    reg disabled = 0;
   
	reg [$clog2(7) :0] bias_A; //first bias of w_hid
	reg [$clog2(7) :0] bias_B; //second bias of w_hid
	reg [$clog2(7) :0] bias_C; //first bias of w_out
	 
    reg [15:0] Last_Layer_Value; 
    
    /***************************
    THIS SECTION IS ADDED
    */
    assign RES_read_address = write_RES_counter;
    assign M_AXIS_TDATA = RES_read_data_out;
    assign M_AXIS_TLAST = (state == Write_Outputs) & (write_RES_counter == NUMBER_OF_OUTPUT_WORDS); //if goes into last state and wrote result already
    /*
    */////////////////////////////
    

	always @(posedge ACLK) 
	begin
	// implemented as a single-always Moore machine
	// a Mealy machine that asserts S_AXIS_TREADY and captures S_AXIS_TDATA etc can save a clock cycle

		/****** Synchronous reset (active low) ******/
		if (!ARESETN)
		begin
			// CAUTION: make sure your reset polarity is consistent with the system reset polarity
			state        <= Idle;
        end
		else
		begin
			case (state)

				Idle:
				begin
					read_input_counter 	<= 0;
					write_RES_counter 	<= 0;
					S_AXIS_TREADY 	<= 0;
					M_AXIS_TVALID 	<= 0;
					if (S_AXIS_TVALID == 1)
					begin
						state       	<= Read_Inputs;
						S_AXIS_TREADY 	<= 1; 
						// start receiving data once you go into Read_Inputs
					end
				end

				Read_Inputs:
				begin
					S_AXIS_TREADY 	<= 1;
					if (S_AXIS_TVALID == 1) 
					begin
						// Coprocessor function (adding the numbers together) happens here (partly)
                        if (read_input_counter < NUMBER_OF_A_WORDS) //read X csv matrix
                        begin
                            A_write_en <= 1;
                            A_write_address <= read_input_counter;
                            A_write_data_in <= S_AXIS_TDATA;
                        end
                        else if (read_input_counter < NUMBER_OF_A_WORDS + 14) //starts reading w_hid matrix
                        begin //last data will be sent to B_RAM
                            A_write_en <= 0;
                            B_write_en <= 1;
                            B_write_address <= read_input_counter - NUMBER_OF_A_WORDS; 
                            B_write_data_in <= S_AXIS_TDATA;
                        end
                        else if (read_input_counter < NUMBER_OF_A_WORDS + 15) 
                        begin //last data will be sent to B_RAM
                            Last_Layer_Value[7:0] <=   S_AXIS_TDATA;  //reads first 8 bit data for last layer for w_hid                     
                        end
                        else if (read_input_counter < NUMBER_OF_A_WORDS + 16) 
                        begin //last data will be sent to B_RAM
                            Last_Layer_Value[15:8] <=   S_AXIS_TDATA;   //reads last 8 bit data for last layer for w_hid
                        end
                        else if (read_input_counter < NUMBER_OF_A_WORDS + 17) 
                        begin //last data will be sent to B_RAM
                            bias_A <= S_AXIS_TDATA; //read first bias of w_hid at the end of the matrix 
                        end
                        else if (read_input_counter < NUMBER_OF_A_WORDS + 18) 
                        begin //last data will be sent to B_RAM
                            bias_B <= S_AXIS_TDATA; //read second bias of w_hid at the end of the matrix
                        end
                        else if (read_input_counter < NUMBER_OF_A_WORDS + 19) 
                        begin //last data will be sent to B_RAM
                               bias_C <= S_AXIS_TDATA; //read first bias of w_out                           
                        end
						// If we are expecting a variable number of words, we should make use of S_AXIS_TLAST.
						// Since the number of words we are expecting is fixed, we simply count and receive 
						// the expected number (NUMBER_OF_INPUT_WORDS) instead.
						if (read_input_counter == NUMBER_OF_INPUT_WORDS -1)
						begin
							state      		<= Compute;
							read_input_counter <= 0;
							Start           <= 1; //added this new
							S_AXIS_TREADY 	<= 0;
						end
						else
						begin
							read_input_counter 	<= read_input_counter + 1;
							
						end
					end
				end
            
				Compute:
				begin
				    B_write_en <= 0;
				    Start <= 1; //to activate matrax_multiply
					// Coprocessor function to be implemented (matrix multiply) should be here. Right now, nothing happens here.
					// Possible to save a cycle by asserting M_AXIS_TVALID and presenting M_AXIS_TDATA just before going into 
					// Write_Outputs state. However, need to adjust write_counter limits accordingly
					// Alternatively, M_AXIS_TVALID and M_AXIS_TDATA can be asserted combinationally to save a cycle.
					if (Done == 1) 
					begin //once done =1, change state in next clock cycle
						state <= Last_Layer_Value;
						Start <= 0;
						//RES_read_en <= 1;	
					end
				end
			
			    Compute_Last_Layer:
				begin
				    Start_Sigmoid <= 1; //to activate matrax_multiply
					// Coprocessor function to be implemented (matrix multiply) should be here. Right now, nothing happens here.
					// Possible to save a cycle by asserting M_AXIS_TVALID and presenting M_AXIS_TDATA just before going into 
					// Write_Outputs state. However, need to adjust write_counter limits accordingly
					// Alternatively, M_AXIS_TVALID and M_AXIS_TDATA can be asserted combinationally to save a cycle.
					if (End_Sigmoid == 1) 
					begin //once done =1, change state in next clock cycle
						state <= Write_Outputs;
						Start_Sigmoid <= 0;
						RES_read_en <= 1;	
					end
				end
				
				Write_Outputs:
				begin
                M_AXIS_TVALID	<= 1;
                
                    // Coprocessor function (adding 1 to sum in each iteration = adding iteration count to sum) happens here (partly)
                    if (M_AXIS_TREADY == 1) 
                    begin
                        if (disabled == 1)
                        begin
                        write_RES_counter <= write_RES_counter +1;
                        M_AXIS_TVALID <= 0; 
                        disabled = 0;
                        end
                        
                        
                        if (write_RES_counter == NUMBER_OF_OUTPUT_WORDS - 1)
                        begin
                            state	<= Idle;
                            RES_read_en <= 0;
                            write_RES_counter <= 0;
                            M_AXIS_TVALID <= 0;
                            // M_AXIS_TLAST, though optional in AXIS, is necessary in practice as AXI Stream FIFO and AXI DMA expects it.
                        end
                         
                        else 
                        begin					     
                            write_RES_counter	<= write_RES_counter + 1;
                        end

                    end
                    
                    else if (disabled == 0)
                    begin
                    write_RES_counter <= write_RES_counter -1;
                    disabled <= 1;
                    end
              end
                    
			endcase
		end
	end 
	   
	// Connection to sub-modules / components for assignment 1
	
	memory_RAM 
	#(
		.width(width), 
		.depth_bits(A_depth_bits)
	) A_RAM 
	(
		.clk(ACLK), 
		.write_en(A_write_en),
		.write_address(A_write_address),
		.write_data_in(A_write_data_in),
		.read_en(A_read_en),    
		.read_address(A_read_address),
		.read_data_out(A_read_data_out)
	);
										
										
	memory_RAM 
	#(
		.width(width), 
		.depth_bits(B_depth_bits)
	) B_RAM 
	(
		.clk(ACLK),
		.write_en(B_write_en),
		.write_address(B_write_address),
		.write_data_in(B_write_data_in),
		.read_en(B_read_en),    
		.read_address(B_read_address),
		.read_data_out(B_read_data_out)
	);
	
//	memory_RAM 
//	#(
//		.width(width), 
//		.depth_bits(C_depth_bits)
//	) C_RAM 
//	(
//		.clk(ACLK),
//		.write_en(C_write_en),
//		.write_address(C_write_address),
//		.write_data_in(C_write_data_in),
//		.read_en(C_read_en),    
//		.read_address(C_read_address),
//		.read_data_out(C_read_data_out)
//	);
																					
	memory_RAM 
	#(
		.width(width), 
		.depth_bits(RES_depth_bits)
	) RES_RAM 
	(
		.clk(ACLK),
		.write_en(RES_write_en),
		.write_address(RES_write_address),
		.write_data_in(RES_write_data_in),
		.read_en(RES_read_en),    
		.read_address(RES_read_address),
		.read_data_out(RES_read_data_out)
	);
				
	memory_RAM 
	#(
		.width(width), 
		.depth_bits(Interm1_depth_bits)
	) Interm1_RAM 
	(
		.clk(ACLK),
		.write_en(Interm1_write_en),
		.write_address(Interm1_write_address),
		.write_data_in(Interm1_write_data_in),
		.read_en(Interm1_read_en),    
		.read_address(Interm1_read_address),
		.read_data_out(Interm1_read_data_out)
	);
			
	memory_RAM 
	#(
		.width(width), 
		.depth_bits(Interm2_depth_bits)
	) Interm2_RAM 
	(
		.clk(ACLK),
		.write_en(Interm2_write_en),
		.write_address(Interm2_write_address),
		.write_data_in(Interm2_write_data_in),
		.read_en(Interm2_read_en),    
		.read_address(Interm2_read_address),
		.read_data_out(Interm2_read_data_out)
	);
				
										
	matrix_multiply 
	#(
		.width(width), 
		.A_depth_bits(A_depth_bits), 
		.B_depth_bits(B_depth_bits), 
		.Interm1_depth_bits(Interm1_depth_bits) 
	) matrix_multiply_0
	(									
		.clk(ACLK),
		.Start(Start),
		.Done(Done),
		
		.A_read_en(A_read_en),
		.A_read_address(A_read_address),
		.A_read_data_out(A_read_data_out),
		
		.B_read_en(B_read_en),
		.B_read_address(B_read_address),
		.B_read_data_out(B_read_data_out),
		
		.Interm1_write_en(Interm1_write_en),
		.Interm1_write_address(Interm1_write_address),
		.Interm1_write_data_in(Interm1_write_data_in),
		
		.bias_A(bias_A),
		.bias_B(bias_B)
	);
	
    Sigmoid	
    #(
		.width(width), 					// width is the number of bits per location
		.Interm1_depth_bits(Interm1_depth_bits)	,			// depth is the number of locations (2^number of address bits)
		.RES_depth_bits(RES_depth_bits)	
	) Sigmoid_0
( 
    .clk(ACLK),
    .Start_Sigmoid(Start_Sigmoid),
    .End_Sigmoid(End_Sigmoid),
     
    
	.Interm1_read_en(Interm1_read_en),  								// matrix_multiply_0 -> A_RAM. Possibly reg.
	.Interm1_read_address(Interm1_read_address), 		// matrix_multiply_0 -> A_RAM. Possibly reg.
	.Interm1_read_data_out(Interm1_read_data_out),				// A_RAM -> matrix_multiply_0.
	
    .RES_write_en(RES_write_en), 							// matrix_multiply_0 -> RES_RAM. Possibly reg.
    .RES_write_address(RES_write_address), 	// matrix_multiply_0 -> RES_RAM. Possibly reg.
    .RES_write_data_in(RES_write_data_in)			// matrix_multiply_0 -> RES_RAM. Possibly reg.
		
);

endmodule

