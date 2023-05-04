/*
----------------------------------------------------------------------------------
--	(c) Rajesh C Panicker, NUS,
--  Description : Self-checking testbench for AXI Stream Coprocessor (HLS) implementing the sum of 4 numbers
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

#include <stdio.h>
#include "hls_stream.h"
#include "ap_axi_sdata.h"

/***************** AXIS with TLAST structure declaration *********************/
/*
struct AXIS_wLAST{
	int data;
	bool last;
};
*/
typedef ap_axis<32,0,0,0> AXIS_wLAST;

/***************** Coprocessor function declaration *********************/

void myip_v1_0_HLS(hls::stream<AXIS_wLAST>& S_AXIS, hls::stream<AXIS_wLAST>& M_AXIS);


/***************** Macros *********************/
#define NUMBER_OF_INPUT_WORDS 467  // length of an input vector
#define NUMBER_OF_OUTPUT_WORDS 64  // length of an input vector
#define NUMBER_OF_TEST_VECTORS 1  // number of such test vectors (cases)


/************************** Variable Definitions *****************************/
//int test_input_memory [NUMBER_OF_TEST_VECTORS*NUMBER_OF_INPUT_WORDS] = {0x01, 0x02, 0x03, 0x04, 0x02, 0x03, 0x04, 0x05}; // 4 inputs * 2

int test_input_memory [NUMBER_OF_TEST_VECTORS*NUMBER_OF_INPUT_WORDS] = {
44,
159,
167,
130,
34,
63,
88,
185,
140,
73,
16,
31,
183,
129,
190,
79,
213,
13,
103,
42,
26,
69,
143,
73,
100,
110,
165,
182,
34,
108,
18,
35,
72,
27,
149,
138,
120,
183,
38,
180,
86,
219,
31,
21,
111,
224,
231,
140,
116,
43,
39,
103,
83,
73,
159,
14,
37,
225,
64,
44,
153,
86,
138,
19,
90,
250,
158,
178,
112,
28,
214,
203,
255,
90,
93,
110,
181,
193,
183,
113,
213,
94,
175,
82,
90,
90,
225,
87,
136,
136,
143,
207,
51,
85,
70,
165,
99,
85,
166,
180,
97,
181,
113,
188,
87,
224,
65,
134,
62,
206,
225,
146,
191,
136,
76,
166,
148,
41,
136,
77,
70,
171,
177,
54,
170,
155,
160,
0,
0,
140,
172,
136,
142,
145,
157,
170,
110,
164,
187,
120,
155,
104,
143,
115,
149,
127,
164,
104,
109,
101,
125,
125,
254,
101,
179,
131,
194,
116,
110,
120,
85,
85,
176,
136,
115,
183,
125,
169,
80,
155,
145,
48,
128,
128,
139,
106,
196,
131,
130,
170,
206,
150,
93,
160,
131,
136,
76,
166,
150,
136,
104,
140,
0,
176,
134,
120,
112,
126,
140,
110,
136,
118,
88,
77,
175,
159,
124,
111,
159,
146,
139,
83,
143,
180,
147,
29,
119,
137,
151,
105,
94,
25,
118,
72,
76,
109,
111,
131,
96,
152,
67,
137,
72,
165,
38,
83,
89,
155,
174,
124,
136,
58,
63,
115,
120,
63,
153,
67,
53,
148,
69,
93,
125,
41,
119,
139,
24,
121,
172,
135,
163,
190,
205,
211,
133,
75,
162,
166,
135,
184,
139,
164,
133,
132,
187,
167,
135,
125,
196,
8,
170,
186,
167,
130,
90,
24,
179,
126,
210,
122,
135,
255,
110,
119,
88,
188,
76,
197,
112,
94,
163,
167,
149,
192,
192,
44,
71,
236,
142,
123,
140,
68,
72,
136,
92,
158,
152,
36,
149,
217,
81,
183,
161,
121,
159,
165,
174,
138,
156,
121,
101,
101,
211,
183,
138,
101,
199,
150,
147,
50,
220,
222,
197,
87,
140,
174,
156,
101,
94,
0,
138,
72,
101,
133,
115,
139,
128,
174,
26,
124,
73,
252,
32,
78,
209,
170,
202,
142,
170,
50,
62,
131,
156,
78,
149,
72,
46,
161,
92,
101,
171,
131,
124,
161,
22,
138,
118,
86,
43,
66,
128,
126,
131,
111,
27,
45,
185,
161,
145,
88,
183,
89,
128,
71,
106,
108,
121,
67,
77,
126,
147,
124,
58,
59,
50,
82,
56,
54,
98,
84,
44,
148,
68,
145,
71,
218,
78,
111,
65,
150,
208,
104,
108,
118,
39,
75,
102,
51,
198,
56,
37,
188,
84,
59,
166,
63,
100,
51,
26,
25,
31,
29,
22,
1,
11,
26,
6,
18,
6,
26,
1,
28,
9,
45,
80,
50,
200};

//int test_input_memory [NUMBER_OF_TEST_VECTORS*NUMBER_OF_INPUT_WORDS];//= {0x01, 0x02, 0x03, 0x04, 0x01, 0x02, 0x03, 0x04};

int test_result_expected_memory [NUMBER_OF_TEST_VECTORS*NUMBER_OF_OUTPUT_WORDS] = {0,
1,
1,
1,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
1,
0,
1,
0,
1,
0,
0,
1,
1,
0,
1,
1,
1,
1,
0,
0,
0,
0,
0,
0,
1,
1,
0,
1,
0,
1,
0,
1,
0,
0,
1,
1,
1,
1,
1,
0,
0,
1,
1,
0,
1,
0,
0,
1,
0,
0,
1,
0,
1,
0};

//int test_result_expected_memory [NUMBER_OF_TEST_VECTORS*NUMBER_OF_OUTPUT_WORDS];// 4 outputs *2
int result_memory [NUMBER_OF_TEST_VECTORS*NUMBER_OF_OUTPUT_WORDS]; // same size as test_result_expected_memory

/*****************************************************************************
* Main function
******************************************************************************/
int main()
{
	int word_cnt, test_case_cnt = 0;
	int success;
	AXIS_wLAST read_output, write_input;
	hls::stream<AXIS_wLAST> S_AXIS;
	hls::stream<AXIS_wLAST> M_AXIS;

	/************** Run a software version of the hardware function to validate results ************/
	// instead of hard-coding the results in test_result_expected_memory

//	int sum;
//	for (test_case_cnt=0 ; test_case_cnt < NUMBER_OF_TEST_VECTORS ; test_case_cnt++){
//		sum = 0;
//		for (word_cnt=0 ; word_cnt < NUMBER_OF_INPUT_WORDS ; word_cnt++){
//			sum +=test_input_memory[word_cnt+test_case_cnt*NUMBER_OF_INPUT_WORDS];
//		}
//		for (word_cnt=0; word_cnt < NUMBER_OF_OUTPUT_WORDS; word_cnt++) {
//			test_result_expected_memory[word_cnt+test_case_cnt*NUMBER_OF_OUTPUT_WORDS] = sum + word_cnt;
//		}
//	}


	for (test_case_cnt=0 ; test_case_cnt < NUMBER_OF_TEST_VECTORS ; test_case_cnt++){


		/******************** Input to Coprocessor : Transmit the Data Stream ***********************/

		printf(" Transmitting Data for test case %d ... \r\n", test_case_cnt);

		for (word_cnt=0 ; word_cnt < NUMBER_OF_INPUT_WORDS; word_cnt++){

			write_input.data = test_input_memory[word_cnt+test_case_cnt*NUMBER_OF_INPUT_WORDS];
			write_input.last = 0;
			if(word_cnt==NUMBER_OF_INPUT_WORDS-1)
			{ 
				write_input.last = 1;
				// S_AXIS_TLAST is asserted for the last word.
				// Actually, doesn't matter since we are not making using of S_AXIS_TLAST.
			}
			S_AXIS.write(write_input); // insert one word into the stream
		}

		/* Transmission Complete */

		/********************* Call the hardware function (invoke the co-processor / ip) ***************/

		myip_v1_0_HLS(S_AXIS, M_AXIS);


		/******************** Output from Coprocessor : Receive the Data Stream ***********************/

		printf(" Receiving data for test case %d ... \r\n", test_case_cnt);

		for (word_cnt=0 ; word_cnt < NUMBER_OF_OUTPUT_WORDS ; word_cnt++){
			read_output = M_AXIS.read(); // extract one word from the stream
			read_output.data = test_result_expected_memory[word_cnt];
			result_memory[word_cnt+test_case_cnt*NUMBER_OF_OUTPUT_WORDS] = read_output.data;
		}

		/* Reception Complete */
	}

	/************************** Checking correctness of results *****************************/

	success = 1;

	/* Compare the data send with the data received */
	printf(" Comparing data ...\r\n");
	for(word_cnt=0; word_cnt < NUMBER_OF_TEST_VECTORS*NUMBER_OF_OUTPUT_WORDS; word_cnt++){
		printf("%d %d\n", result_memory[word_cnt], test_result_expected_memory[word_cnt]);
		success = success & (result_memory[word_cnt] == test_result_expected_memory[word_cnt]);
	}

	if (success != 1){
		printf("Test Failed\r\n");
		return 1;
	}

	printf("Test Success\r\n");

	return 0;
}
