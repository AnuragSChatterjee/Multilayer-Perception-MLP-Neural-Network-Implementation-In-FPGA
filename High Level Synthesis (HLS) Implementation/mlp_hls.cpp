/*
----------------------------------------------------------------------------------
--  (c) Rajesh C Panicker, NUS,
--  Description : AXI Stream Coprocessor (HLS), implementing the sum of 4 numbers
--  License terms :
--  You are free to use this code as long as you
--    (i) DO NOT post a modified version of this on any public repository;
--    (ii) use it only for educational purposes;
--    (iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of any entity.
--    (iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--    (v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course EE4218 at the National University of Singapore);
--    (vi) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------
*/

#include "hls_stream.h"
#include "ap_int.h"
#include "ap_axi_sdata.h"
#include <math.h>
#include <stdio.h>

#define NUMBER_OF_INPUT_WORDS 467  // length of an input vector => 64x7 +8x2 +3x1
#define NUMBER_OF_OUTPUT_WORDS 64  // length of an input vector

// Creating a custom structure which includes the data word and TLAST signal.
// ACLK, ARESETN, TREADY, TDATA, TVALID are essential signals for AXIS.
// TLAST is a sideband signal which is optional in AXIS.
// However, it is necessary for us since we connecting M_AXIS to AXI Stream FIFO / AXI DMA.
// So, we create a struct with data (TDATA) and last (TLAST). The rest of the essential AXIS signals are automatically dealt with by the HLS tool.


/* // doesn't work with HLS version 2022.2
struct AXIS_wLAST{
  int data;
  //ap_uint<32> data;
  bool last;
};
*/
int sig_arr[256] = {
12,
12,
12,
12,
13,
13,
13,
14,
14,
14,
15,
15,
15,
16,
16,
16,
17,
17,
18,
18,
18,
19,
19,
20,
20,
21,
21,
21,
22,
22,
23,
23,
24,
24,
25,
26,
26,
27,
27,
28,
28,
29,
30,
30,
31,
32,
32,
33,
34,
34,
35,
36,
36,
37,
38,
39,
39,
40,
41,
42,
43,
44,
44,
45,
46,
47,
48,
49,
50,
51,
52,
53,
54,
55,
56,
57,
58,
59,
60,
61,
62,
63,
64,
66,
67,
68,
69,
70,
72,
73,
74,
75,
76,
78,
79,
80,
82,
83,
84,
86,
87,
88,
90,
91,
92,
94,
95,
97,
98,
99,
101,
102,
104,
105,
107,
108,
110,
111,
113,
114,
116,
117,
119,
120,
122,
123,
125,
126,
128,
129,
130,
132,
133,
135,
136,
138,
139,
141,
142,
144,
145,
147,
148,
150,
151,
153,
154,
156,
157,
158,
160,
161,
163,
164,
165,
167,
168,
169,
171,
172,
173,
175,
176,
177,
179,
180,
181,
182,
183,
185,
186,
187,
188,
189,
191,
192,
193,
194,
195,
196,
197,
198,
199,
200,
201,
202,
203,
204,
205,
206,
207,
208,
209,
210,
211,
211,
212,
213,
214,
215,
216,
216,
217,
218,
219,
219,
220,
221,
221,
222,
223,
223,
224,
225,
225,
226,
227,
227,
228,
228,
229,
229,
230,
231,
231,
232,
232,
233,
233,
234,
234,
234,
235,
235,
236,
236,
237,
237,
237,
238,
238,
239,
239,
239,
240,
240,
240,
241,
241,
241,
242,
242,
242,
243,
243,
243
};
typedef ap_axis<32,0,0,0> AXIS_wLAST;

int sigmoid(int sum, int sig_arr[256]){
  for (int i=0; i<256; i++) {
	  if (i==sum) {
		  return sig_arr[i];
	  }
  }
}

void matrix_multiply(int input_arr[], int sig_arr[256], int x_rows, int x_cols, int whid_rows, int whid_cols, int wout_rows, int wout_cols, int result[]) {
    // Separate the input array into the three matrices
    int X[x_rows][x_cols];
    int W_hid[whid_rows][whid_cols];
    int W_out[wout_rows][wout_cols];
    int res_hidden[x_rows][whid_cols]; //computes hidden layer x input layer

  //printf("input layer\n");
    for (int i = 0; i < x_rows; i++) {
        for (int j = 0; j < x_cols; j++) {
            X[i][j] = input_arr[i*x_cols + j];
            //printf("%d\n", X[i][j]);
        }
    }
    //printf("Hidden layer\n");
    for (int i = 0; i < whid_rows; i++) {
        for (int j = 0; j < whid_cols; j++) {
            W_hid[i][j] = input_arr[x_rows*x_cols + i*whid_cols + j ];
            //printf("%d\n", W_hid[i][j]);
        }
    }
    //printf("out layer\n");
    for (int i = 0; i < wout_rows; i++) {
        for (int j = 0; j < wout_cols; j++) {
            W_out[i][j] = input_arr[x_rows*x_cols + whid_rows*whid_cols + i*wout_cols + j ];
            //printf("%d\n", W_out[i][j]);
        }
    }

    //printf("Multiplication layer 1 \n");

    // Perform matrix multiplication on the three matrices
    // Multiply X and W_hid and store the result in result
    for (int i = 0; i < x_rows; i++) {
        for (int j = 0; j < whid_cols; j++) {
            int sum = 0;
            for (int k = 0; k < x_cols; k++) {
                sum += X[i][k] * W_hid[k+1][j];
            }
      sum /= 256;
      //printf("%d\n", sum);
      if(j == 0){
        sum += W_hid[0][0]; //add bias
      }
      else{
        sum += W_hid[0][1];
      }
      	  	//printf("%d\n", sum);
            res_hidden[i][j] = sigmoid(sum, sig_arr); //activation function
            //printf("%d\n", res_hidden[i][j]);
        }
    }

    printf("Multiplication layer 2\n");
    // Multiply only the 2nd and 3rd rows of the result with the W_out matrix
    for (int i = 1; i < x_rows; i++) {
        for (int j = 0; j < wout_cols; j++) {
            int sum = 0;
            for (int k = 0; k < whid_cols; k++) {
                sum += res_hidden[i][k] * W_out[k+1][j];
            }
      sum /= 256;
      sum += W_out[0][0];
      //printf("%d\n", sum);

            result[i] = sigmoid(sum, sig_arr);
            printf("%d\n", result[i]);

            if (result[i] >= 198 && result[i] <= 240) {
            	printf("Class 1\n");
            }
            else if (result[i] >= 150 && result[i] < 198) {
            	printf("Class 0\n");
            }
            else {
            	printf("Class 0\n");
            	}
            }
        }
 }
void myip_v1_0_HLS(hls::stream<AXIS_wLAST>& S_AXIS, hls::stream<AXIS_wLAST>& M_AXIS){
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis port=S_AXIS
#pragma HLS INTERFACE axis port=M_AXIS

  int word_cnt;
  ap_uint<8> sum = 0; // using arbitrary precision
  //int sum = 0;     // using 32 bit precision
  AXIS_wLAST read_input, write_output;
  int arr[NUMBER_OF_INPUT_WORDS];
  //int sig_arr[256];

    myip_v1_0_HLS_for1:for(word_cnt = 0; word_cnt < NUMBER_OF_INPUT_WORDS; word_cnt++){
	#pragma HLS pipeline II=4

    read_input = S_AXIS.read();
      // read_input is the element (data + other signals) received by our ip through S_AXIS in one clock cycle (which contains one word).
      // read() extracts it from the stream. Overloaded operator >> can also be used.
       //extracting that word

    arr[word_cnt] = read_input.data;
    	  //printf("%d\n", arr[word_cnt]);

    	  //printf("%d\n", sig_arr[word_cnt]);

    	  //printf("%d\n", arr[word_cnt]);

      // We are not making using of S_AXIS_TLAST in this example.
      // S_AXIS_TLAST is required only when we are receiving an unknown number of words.
    }

      // Initialize the result matrix as a 1D array of size 64
    int result[NUMBER_OF_OUTPUT_WORDS];
    int x_rows = 64;
    int x_cols = 7;
    int whid_rows = 8;
    int whid_cols = 2;
    int wout_rows = 3;
    int wout_cols = 1;


      // Compute the matrix multiplication using the function
    matrix_multiply(arr, sig_arr, x_rows, x_cols, whid_rows, whid_cols, wout_rows, wout_cols, result);

    myip_v1_0_HLS_for2:for(word_cnt = 0; word_cnt < NUMBER_OF_OUTPUT_WORDS; word_cnt++){

    //rite_output.data = sum.to_int() + word_cnt;  // using arbitrary precision internally but int for interfacing
      //write_output.data = sum + word_cnt;  // using 32 bit precision or arbitrary precision all the way
      // write_output is the element sent by our ip through M_AXIS in one clock cycle.
      write_output.data = result[word_cnt];
      write_output.last = 0;
      if(word_cnt==NUMBER_OF_OUTPUT_WORDS-1)
      {
        write_output.last = 1;
        // M_AXIS_TLAST is required to be asserted for the last word.
        // Else, the AXI Stream FIFO / AXI DMA will not know if all the words have been received from the co-processor.
      }
      M_AXIS.write(write_output);
      // write() inserts it into the stream. Overloaded operator << can also be used.
    }
}

