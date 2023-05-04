///******************************************************************************
//*
//* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
//*
//* Permission is hereby granted, free of charge, to any person obtaining a copy
//* of this software and associated documentation files (the "Software"), to deal
//* in the Software without restriction, including without limitation the rights
//* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//* copies of the Software, and to permit persons to whom the Software is
//* furnished to do so, subject to the following conditions:
//*
//* The above copyright notice and this permission notice shall be included in
//* all copies or substantial portions of the Software.
//*
//* Use of the Software is limited solely to applications:
//* (a) running on a Xilinx device, or
//* (b) that interact with a Xilinx device through a bus or interconnect.
//*
//* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
//* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//* SOFTWARE.
//*
//* Except as contained in this notice, the name of the Xilinx shall not be used
//* in advertising or otherwise to promote the sale, use or other dealings in
//* this Software without prior written authorization from Xilinx.
//*
//******************************************************************************/
//
///*
// * helloworld.c: simple test application
// *
// * This application configures UART 16550 to baud rate 9600.
// * PS7 UART (Zynq) is not initialized by this application, since
// * bootrom/bsp configures it to baud rate 115200
// *
// * ------------------------------------------------
// * | UART TYPE   BAUD RATE                        |
// * ------------------------------------------------
// *   uartns550   9600
// *   uartlite    Configurable only in HW design
// *   ps7_uart    115200 (configured by bootrom/bsp)
// */
//
//#include <stdio.h>
//#include "platform.h"
//#include "xil_printf.h"
//#include <math.h>
//
//#define NUMBER_OF_INPUT_WORDS 467  // length of an input vector => 64x7 +8x2 +3x1
//#define NUMBER_OF_OUTPUT_WORDS 64  // length of an input vector
//
//int sigmoid(int sum, int sig_arr[]){
//	for(i = 0; i < 256; i++){
//		if(i == sum){
//			return sig_arr[i];
//		}
//	}
//}
//
//void matrix_multiply(int input_arr[], int sig_arr[], int x_rows, int x_cols, int whid_rows, int whid_cols, int wout_rows, int wout_cols, int result[]) {
//    // Separate the input array into the three matrices
//    int X[x_rows][x_cols];
//    int W_hid[whid_rows][whid_cols];
//    int W_out[wout_rows][wout_cols];
//    int res_hidden[x_rows][whid_cols]; //computes hidden layer x input layer
//
//    //printf("input layer\n");
//    for (int i = 0; i < x_rows; i++) {
//        for (int j = 0; j < x_cols; j++) {
//            X[i][j] = input_arr[i*x_cols + j];
//            //printf("%d\n", X[i][j]);
//        }
//    }
//    //printf("Hidden layer\n");
//    for (int i = 0; i < whid_rows; i++) {
//        for (int j = 0; j < whid_cols; j++) {
//            W_hid[i][j] = input_arr[x_rows*x_cols + i*whid_cols + j ];
//            //printf("%d\n", W_hid[i][j]);
//        }
//    }
//    //printf("out layer\n");
//    for (int i = 0; i < wout_rows; i++) {
//        for (int j = 0; j < wout_cols; j++) {
//            W_out[i][j] = input_arr[x_rows*x_cols + whid_rows*whid_cols + i*wout_cols + j ];
//            //printf("%d\n", W_out[i][j]);
//        }
//    }
//
//    //printf("Multiplication layer 1 \n");
//
//    // Perform matrix multiplication on the three matrices
//    // Multiply X and W_hid and store the result in result
//    for (int i = 0; i < x_rows; i++) {
//        for (int j = 0; j < whid_cols; j++) {
//            int sum = 0;
//            for (int k = 0; k < x_cols; k++) {
//                sum += X[i][k] * W_hid[k+1][j];
//            }
//			  sum /= 256;
//			  if(j == 0){
//				sum += W_hid[0][0]; //add bias
//			  }
//			  else{
//				sum += W_hid[0][1];
//			  }
//
//
//            res_hidden[i][j] = sigmoid(sum, sig_arr); //activation function
//
//            //printf("%0.1f\n", res_hidden[i][j]);
//        }
//    }
//    //printf("Multiplication layer 2\n");
//    // Multiply only the 2nd and 3rd rows of the result with the W_out matrix
//    for (int i = 1; i < x_rows; i++) {
//        for (int j = 0; j < wout_cols; j++) {
//            int sum = 0;
//            for (int k = 0; k < whid_cols; k++) {
//                sum += res_hidden[i][k] * W_out[k+1][j];
//            }
//		  sum /= 256;
//		  sum += W_out[0][0];
//
//            result[i] = sigmoid(sum, sig_arr);
//            //if(result[i] >)
//            printf("%d\n", result[i]);
//        }
//    }
//}
//
//
//int main()
//{
//    init_platform();
//
//    int arr[NUMBER_OF_INPUT_WORDS];
//    int result[NUMBER_OF_OUTPUT_WORDS];
//
//	int x_rows = 64;
//	int x_cols = 7;
//	int whid_rows = 8;
//	int whid_cols = 2;
//	int wout_rows = 3;
//	int wout_cols = 1;
//	int sig_arr[256];
//
//     // Scan in Matrix X + W_hid + W_out
//     for(int i=0; i < NUMBER_OF_INPUT_WORDS; i++) {
//       scanf("%d", &arr[i]);
//       //printf("%d\n", arr[i]);
//     }
//     for(int i = 0; i < 256; i ++){
//    	 scanf("%d", &sig_arr[i])
//     }
//
//     matrix_multiply(arr, sig_arr, x_rows, x_cols, whid_rows, whid_cols, wout_rows, wout_cols, result);
//
//    cleanup_platform();
//    return 0;
//}
