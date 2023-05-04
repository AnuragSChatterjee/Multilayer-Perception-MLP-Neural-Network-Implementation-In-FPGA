`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2023 12:40:57 AM
// Design Name: 
// Module Name: Sigmoid
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//COMPARE WITH PURE CALCULATION LATER
module Sigmoid	#(
		parameter width = 8, 					// width is the number of bits per location
		parameter Interm1_depth_bits = 7,			// depth is the number of locations (2^number of Location bits)
		parameter RES_depth_bits = 7	
	) 
(
    input clk, 
    input Start_Sigmoid,
    output reg End_Sigmoid, 
    
    
	output wire Interm1_read_en,  								// matrix_multiply_0 -> A_RAM. Possibly reg.
	output reg [Interm1_depth_bits-1:0] Interm1_read_address, 		// matrix_multiply_0 -> A_RAM. Possibly reg.
	input [width-1:0] Interm1_read_data_out,				// A_RAM -> matrix_multiply_0.
	 
    output wire RES_write_en, 							// matrix_multiply_0 -> RES_RAM. Possibly reg.
    output reg [RES_depth_bits-1:0] RES_write_address, 	// matrix_multiply_0 -> RES_RAM. Possibly reg.
    output reg [width-1:0] RES_write_data_in			// matrix_multiply_0 -> RES_RAM. Possibly reg.
		
);

 	
reg [Interm1_depth_bits:0] Location = 0;

assign Interm1_read_en = Start_Sigmoid; //the function will allow reading for A_RAM and B_RAM
assign RES_write_en = Start_Sigmoid;

	always @(posedge clk) 
    begin
        if (Start_Sigmoid == 1) //once signal from the main state machine is given
        begin
            Interm1_read_address <= Location;
            RES_write_address <= Location-2; 
            if (Interm1_read_data_out < 4) begin
             RES_write_data_in <= 12;
             end
            else if (Interm1_read_data_out < 7) begin
             RES_write_data_in <= 13;
             end
            else if (Interm1_read_data_out < 10) begin
             RES_write_data_in <= 14;
             end
            else if (Interm1_read_data_out < 13) begin
             RES_write_data_in <= 15;
             end
            else if (Interm1_read_data_out < 16) begin
             RES_write_data_in <= 16;
             end
            else if (Interm1_read_data_out < 18) begin
             RES_write_data_in <= 17;
             end
            else if (Interm1_read_data_out < 21) begin
             RES_write_data_in <= 18;
             end
            else if (Interm1_read_data_out < 23) begin
             RES_write_data_in <= 19;
             end
            else if (Interm1_read_data_out < 25) begin
             RES_write_data_in <= 20;
             end
            else if (Interm1_read_data_out < 28) begin
             RES_write_data_in <= 21;
             end
            else if (Interm1_read_data_out < 30) begin
             RES_write_data_in <= 22;
             end
            else if (Interm1_read_data_out < 32) begin
             RES_write_data_in <= 23;
             end
            else if (Interm1_read_data_out < 34) begin
             RES_write_data_in <= 24;
             end
            else if (Interm1_read_data_out < 35) begin
             RES_write_data_in <= 25;
             end
            else if (Interm1_read_data_out < 37) begin
             RES_write_data_in <= 26;
             end
            else if (Interm1_read_data_out < 39) begin
             RES_write_data_in <= 27;
             end
            else if (Interm1_read_data_out < 41) begin
             RES_write_data_in <= 28;
             end
            else if (Interm1_read_data_out < 42) begin
             RES_write_data_in <= 29;
             end
            else if (Interm1_read_data_out < 44) begin
             RES_write_data_in <= 30;
             end
            else if (Interm1_read_data_out < 45) begin
             RES_write_data_in <= 31;
             end
            else if (Interm1_read_data_out < 47) begin
             RES_write_data_in <= 32;
             end
            else if (Interm1_read_data_out < 48) begin
             RES_write_data_in <= 33;
             end
            else if (Interm1_read_data_out < 50) begin
             RES_write_data_in <= 34;
             end
            else if (Interm1_read_data_out < 51) begin
             RES_write_data_in <= 35;
             end
            else if (Interm1_read_data_out < 53) begin
             RES_write_data_in <= 36;
             end
            else if (Interm1_read_data_out < 54) begin
             RES_write_data_in <= 37;
             end
            else if (Interm1_read_data_out < 55) begin
             RES_write_data_in <= 38;
             end
            else if (Interm1_read_data_out < 57) begin
             RES_write_data_in <= 39;
             end
            else if (Interm1_read_data_out < 58) begin
             RES_write_data_in <= 40;
             end
            else if (Interm1_read_data_out < 59) begin
             RES_write_data_in <= 41;
             end
            else if (Interm1_read_data_out < 60) begin
             RES_write_data_in <= 42;
             end
            else if (Interm1_read_data_out < 61) begin
             RES_write_data_in <= 43;
             end
            else if (Interm1_read_data_out < 63) begin
             RES_write_data_in <= 44;
             end
            else if (Interm1_read_data_out < 64) begin
             RES_write_data_in <= 45;
             end
            else if (Interm1_read_data_out < 65) begin
             RES_write_data_in <= 46;
             end
            else if (Interm1_read_data_out < 66) begin
             RES_write_data_in <= 47;
             end
            else if (Interm1_read_data_out < 67) begin
             RES_write_data_in <= 48;
             end
            else if (Interm1_read_data_out < 68) begin
             RES_write_data_in <= 49;
             end
            else if (Interm1_read_data_out < 69) begin
             RES_write_data_in <= 50;
             end
            else if (Interm1_read_data_out < 70) begin
             RES_write_data_in <= 51;
             end
            else if (Interm1_read_data_out < 71) begin
             RES_write_data_in <= 52;
             end
            else if (Interm1_read_data_out < 72) begin
             RES_write_data_in <= 53;
             end
            else if (Interm1_read_data_out < 73) begin
             RES_write_data_in <= 54;
             end
            else if (Interm1_read_data_out < 74) begin
             RES_write_data_in <= 55;
             end
            else if (Interm1_read_data_out < 75) begin
             RES_write_data_in <= 56;
             end
            else if (Interm1_read_data_out < 76) begin
             RES_write_data_in <= 57;
             end
            else if (Interm1_read_data_out < 77) begin
             RES_write_data_in <= 58;
             end
            else if (Interm1_read_data_out < 78) begin
             RES_write_data_in <= 59;
             end
            else if (Interm1_read_data_out < 79) begin
             RES_write_data_in <= 60;
             end
            else if (Interm1_read_data_out < 80) begin
             RES_write_data_in <= 61;
             end
            else if (Interm1_read_data_out < 81) begin
             RES_write_data_in <= 62;
             end
            else if (Interm1_read_data_out < 82) begin
             RES_write_data_in <= 63;
             end
            else if (Interm1_read_data_out < 83) begin
             RES_write_data_in <= 64;
             end
            else if (Interm1_read_data_out < 84) begin
             RES_write_data_in <= 66;
             end
            else if (Interm1_read_data_out < 85) begin
             RES_write_data_in <= 67;
             end
            else if (Interm1_read_data_out < 86) begin
             RES_write_data_in <= 68;
             end
            else if (Interm1_read_data_out < 87) begin
             RES_write_data_in <= 69;
             end
            else if (Interm1_read_data_out < 88) begin
             RES_write_data_in <= 70;
             end
            else if (Interm1_read_data_out < 89) begin
             RES_write_data_in <= 72;
             end
            else if (Interm1_read_data_out < 90) begin
             RES_write_data_in <= 73;
             end
            else if (Interm1_read_data_out < 91) begin
             RES_write_data_in <= 74;
             end
            else if (Interm1_read_data_out < 92) begin
             RES_write_data_in <= 75;
             end
            else if (Interm1_read_data_out < 93) begin
             RES_write_data_in <= 76;
             end
            else if (Interm1_read_data_out < 94) begin
             RES_write_data_in <= 78;
             end
            else if (Interm1_read_data_out < 95) begin
             RES_write_data_in <= 79;
             end
            else if (Interm1_read_data_out < 96) begin
             RES_write_data_in <= 80;
             end
            else if (Interm1_read_data_out < 97) begin
             RES_write_data_in <= 82;
             end
            else if (Interm1_read_data_out < 98) begin
             RES_write_data_in <= 83;
             end
            else if (Interm1_read_data_out < 99) begin
             RES_write_data_in <= 84;
             end
            else if (Interm1_read_data_out < 100) begin
             RES_write_data_in <= 86;
             end
            else if (Interm1_read_data_out < 101) begin
             RES_write_data_in <= 87;
             end
            else if (Interm1_read_data_out < 102) begin
             RES_write_data_in <= 88;
             end
            else if (Interm1_read_data_out < 103) begin
             RES_write_data_in <= 90;
             end
            else if (Interm1_read_data_out < 104) begin
             RES_write_data_in <= 91;
             end
            else if (Interm1_read_data_out < 105) begin
             RES_write_data_in <= 92;
             end
            else if (Interm1_read_data_out < 106) begin
             RES_write_data_in <= 94;
             end
            else if (Interm1_read_data_out < 107) begin
             RES_write_data_in <= 95;
             end
            else if (Interm1_read_data_out < 108) begin
             RES_write_data_in <= 97;
             end
            else if (Interm1_read_data_out < 109) begin
             RES_write_data_in <= 98;
             end
            else if (Interm1_read_data_out < 110) begin
             RES_write_data_in <= 99;
             end
            else if (Interm1_read_data_out < 111) begin
             RES_write_data_in <= 101;
             end
            else if (Interm1_read_data_out < 112) begin
             RES_write_data_in <= 102;
             end
            else if (Interm1_read_data_out < 113) begin
             RES_write_data_in <= 104;
             end
            else if (Interm1_read_data_out < 114) begin
             RES_write_data_in <= 105;
             end
            else if (Interm1_read_data_out < 115) begin
             RES_write_data_in <= 107;
             end
            else if (Interm1_read_data_out < 116) begin
             RES_write_data_in <= 108;
             end
            else if (Interm1_read_data_out < 117) begin
             RES_write_data_in <= 110;
             end
            else if (Interm1_read_data_out < 118) begin
             RES_write_data_in <= 111;
             end
            else if (Interm1_read_data_out < 119) begin
             RES_write_data_in <= 113;
             end
            else if (Interm1_read_data_out < 120) begin
             RES_write_data_in <= 114;
             end
            else if (Interm1_read_data_out < 121) begin
             RES_write_data_in <= 116;
             end
            else if (Interm1_read_data_out < 122) begin
             RES_write_data_in <= 117;
             end
            else if (Interm1_read_data_out < 123) begin
             RES_write_data_in <= 119;
             end
            else if (Interm1_read_data_out < 124) begin
             RES_write_data_in <= 120;
             end
            else if (Interm1_read_data_out < 125) begin
             RES_write_data_in <= 122;
             end
            else if (Interm1_read_data_out < 126) begin
             RES_write_data_in <= 123;
             end
            else if (Interm1_read_data_out < 127) begin
             RES_write_data_in <= 125;
             end
            else if (Interm1_read_data_out < 128) begin
             RES_write_data_in <= 126;
             end
            else if (Interm1_read_data_out < 129) begin
             RES_write_data_in <= 128;
             end
            else if (Interm1_read_data_out < 130) begin
             RES_write_data_in <= 129;
             end
            else if (Interm1_read_data_out < 131) begin
             RES_write_data_in <= 130;
             end
            else if (Interm1_read_data_out < 132) begin
             RES_write_data_in <= 132;
             end
            else if (Interm1_read_data_out < 133) begin
             RES_write_data_in <= 133;
             end
            else if (Interm1_read_data_out < 134) begin
             RES_write_data_in <= 135;
             end
            else if (Interm1_read_data_out < 135) begin
             RES_write_data_in <= 136;
             end
            else if (Interm1_read_data_out < 136) begin
             RES_write_data_in <= 138;
             end
            else if (Interm1_read_data_out < 137) begin
             RES_write_data_in <= 139;
             end
            else if (Interm1_read_data_out < 138) begin
             RES_write_data_in <= 141;
             end
            else if (Interm1_read_data_out < 139) begin
             RES_write_data_in <= 142;
             end
            else if (Interm1_read_data_out < 140) begin
             RES_write_data_in <= 144;
             end
            else if (Interm1_read_data_out < 141) begin
             RES_write_data_in <= 145;
             end
            else if (Interm1_read_data_out < 142) begin
             RES_write_data_in <= 147;
             end
            else if (Interm1_read_data_out < 143) begin
             RES_write_data_in <= 148;
             end
            else if (Interm1_read_data_out < 144) begin
             RES_write_data_in <= 150;
             end
            else if (Interm1_read_data_out < 145) begin
             RES_write_data_in <= 151;
             end
            else if (Interm1_read_data_out < 146) begin
             RES_write_data_in <= 153;
             end
            else if (Interm1_read_data_out < 147) begin
             RES_write_data_in <= 154;
             end
            else if (Interm1_read_data_out < 148) begin
             RES_write_data_in <= 156;
             end
            else if (Interm1_read_data_out < 149) begin
             RES_write_data_in <= 157;
             end
            else if (Interm1_read_data_out < 150) begin
             RES_write_data_in <= 158;
             end
            else if (Interm1_read_data_out < 151) begin
             RES_write_data_in <= 160;
             end
            else if (Interm1_read_data_out < 152) begin
             RES_write_data_in <= 161;
             end
            else if (Interm1_read_data_out < 153) begin
             RES_write_data_in <= 163;
             end
            else if (Interm1_read_data_out < 154) begin
             RES_write_data_in <= 164;
             end
            else if (Interm1_read_data_out < 155) begin
             RES_write_data_in <= 165;
             end
            else if (Interm1_read_data_out < 156) begin
             RES_write_data_in <= 167;
             end
            else if (Interm1_read_data_out < 157) begin
             RES_write_data_in <= 168;
             end
            else if (Interm1_read_data_out < 158) begin
             RES_write_data_in <= 169;
             end
            else if (Interm1_read_data_out < 159) begin
             RES_write_data_in <= 171;
             end
            else if (Interm1_read_data_out < 160) begin
             RES_write_data_in <= 172;
             end
            else if (Interm1_read_data_out < 161) begin
             RES_write_data_in <= 173;
             end
            else if (Interm1_read_data_out < 162) begin
             RES_write_data_in <= 175;
             end
            else if (Interm1_read_data_out < 163) begin
             RES_write_data_in <= 176;
             end
            else if (Interm1_read_data_out < 164) begin
             RES_write_data_in <= 177;
             end
            else if (Interm1_read_data_out < 165) begin
             RES_write_data_in <= 179;
             end
            else if (Interm1_read_data_out < 166) begin
             RES_write_data_in <= 180;
             end
            else if (Interm1_read_data_out < 167) begin
             RES_write_data_in <= 181;
             end
            else if (Interm1_read_data_out < 168) begin
             RES_write_data_in <= 182;
             end
            else if (Interm1_read_data_out < 169) begin
             RES_write_data_in <= 183;
             end
            else if (Interm1_read_data_out < 170) begin
             RES_write_data_in <= 185;
             end
            else if (Interm1_read_data_out < 171) begin
             RES_write_data_in <= 186;
             end
            else if (Interm1_read_data_out < 172) begin
             RES_write_data_in <= 187;
             end
            else if (Interm1_read_data_out < 173) begin
             RES_write_data_in <= 188;
             end
            else if (Interm1_read_data_out < 174) begin
             RES_write_data_in <= 189;
             end
            else if (Interm1_read_data_out < 175) begin
             RES_write_data_in <= 191;
             end
            else if (Interm1_read_data_out < 176) begin
             RES_write_data_in <= 192;
             end
            else if (Interm1_read_data_out < 177) begin
             RES_write_data_in <= 193;
             end
            else if (Interm1_read_data_out < 178) begin
             RES_write_data_in <= 194;
             end
            else if (Interm1_read_data_out < 179) begin
             RES_write_data_in <= 195;
             end
            else if (Interm1_read_data_out < 180) begin
             RES_write_data_in <= 196;
             end
            else if (Interm1_read_data_out < 181) begin
             RES_write_data_in <= 197;
             end
            else if (Interm1_read_data_out < 182) begin
             RES_write_data_in <= 198;
             end
            else if (Interm1_read_data_out < 183) begin
             RES_write_data_in <= 199;
             end
            else if (Interm1_read_data_out < 184) begin
             RES_write_data_in <= 200;
             end
            else if (Interm1_read_data_out < 185) begin
             RES_write_data_in <= 201;
             end
            else if (Interm1_read_data_out < 186) begin
             RES_write_data_in <= 202;
             end
            else if (Interm1_read_data_out < 187) begin
             RES_write_data_in <= 203;
             end
            else if (Interm1_read_data_out < 188) begin
             RES_write_data_in <= 204;
             end
            else if (Interm1_read_data_out < 189) begin
             RES_write_data_in <= 205;
             end
            else if (Interm1_read_data_out < 190) begin
             RES_write_data_in <= 206;
             end
            else if (Interm1_read_data_out < 191) begin
             RES_write_data_in <= 207;
             end
            else if (Interm1_read_data_out < 192) begin
             RES_write_data_in <= 208;
             end
            else if (Interm1_read_data_out < 193) begin
             RES_write_data_in <= 209;
             end
            else if (Interm1_read_data_out < 194) begin
             RES_write_data_in <= 210;
             end
            else if (Interm1_read_data_out < 196) begin
             RES_write_data_in <= 211;
             end
            else if (Interm1_read_data_out < 197) begin
             RES_write_data_in <= 212;
             end
            else if (Interm1_read_data_out < 198) begin
             RES_write_data_in <= 213;
             end
            else if (Interm1_read_data_out < 199) begin
             RES_write_data_in <= 214;
             end
            else if (Interm1_read_data_out < 200) begin
             RES_write_data_in <= 215;
             end
            else if (Interm1_read_data_out < 202) begin
             RES_write_data_in <= 216;
             end
            else if (Interm1_read_data_out < 203) begin
             RES_write_data_in <= 217;
             end
            else if (Interm1_read_data_out < 204) begin
             RES_write_data_in <= 218;
             end
            else if (Interm1_read_data_out < 206) begin
             RES_write_data_in <= 219;
             end
            else if (Interm1_read_data_out < 207) begin
             RES_write_data_in <= 220;
             end
            else if (Interm1_read_data_out < 209) begin
             RES_write_data_in <= 221;
             end
            else if (Interm1_read_data_out < 210) begin
             RES_write_data_in <= 222;
             end
            else if (Interm1_read_data_out < 212) begin
             RES_write_data_in <= 223;
             end
            else if (Interm1_read_data_out < 213) begin
             RES_write_data_in <= 224;
             end
            else if (Interm1_read_data_out < 215) begin
             RES_write_data_in <= 225;
             end
            else if (Interm1_read_data_out < 216) begin
             RES_write_data_in <= 226;
             end
            else if (Interm1_read_data_out < 218) begin
             RES_write_data_in <= 227;
             end
            else if (Interm1_read_data_out < 220) begin
             RES_write_data_in <= 228;
             end
            else if (Interm1_read_data_out < 222) begin
             RES_write_data_in <= 229;
             end
            else if (Interm1_read_data_out < 223) begin
             RES_write_data_in <= 230;
             end
            else if (Interm1_read_data_out < 225) begin
             RES_write_data_in <= 231;
             end
            else if (Interm1_read_data_out < 227) begin
             RES_write_data_in <= 232;
             end
            else if (Interm1_read_data_out < 229) begin
             RES_write_data_in <= 233;
             end
            else if (Interm1_read_data_out < 232) begin
             RES_write_data_in <= 234;
             end
            else if (Interm1_read_data_out < 234) begin
             RES_write_data_in <= 235;
             end
            else if (Interm1_read_data_out < 236) begin
             RES_write_data_in <= 236;
             end
            else if (Interm1_read_data_out < 239) begin
             RES_write_data_in <= 237;
             end
            else if (Interm1_read_data_out < 241) begin
             RES_write_data_in <= 238;
             end
            else if (Interm1_read_data_out < 244) begin
             RES_write_data_in <= 239;
             end
            else if (Interm1_read_data_out < 247) begin
             RES_write_data_in <= 240;
             end
            else if (Interm1_read_data_out < 250) begin
             RES_write_data_in <= 241;
             end
            else if (Interm1_read_data_out < 253) begin
             RES_write_data_in <= 242;
             end  
            else begin
             RES_write_data_in <= 243;
             end            
            
            
            Location <= Location + 1;
            
            if (Location == 129) 
            begin
                End_Sigmoid <= 1;
            end
        end
        
        else 
        begin
            End_Sigmoid <= 0;
            Location <= 0;
        end     
    
    end
endmodule
