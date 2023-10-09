# Using DSPLib AI Engine SSR FIR block to achieve 4 Gsps throughput

This example demonstrates using the AI Engine 'FIR Asymmetric Filter' block with a Super Sample Rate (SSR) of 4 in Vitis Model Composer to achieve a high throughput. We also compare the results to the Simulink FIR block for functional correctness.

Each stream input to the AI Engine FIR block has a thoughput of close to 1 GSPS for a total of 4 GSPS. To achieve this throughput the following factors are in play:

* 64 bit wide PLIO blocks on all the inputs and outputs, with a PL frequency of 500 MHz. This means two 16-bit complex inputs (64 bits total) can be transferred between AIE and PL through each PLIO during each clock cycle, for a total throughput of 1 GSPS per stream.
* A high value for the parameter "Input frame size" on the filter block, in this case 8192. Note this parameter is the sum of the signal sizes of all the four inputs. A larger value means at each invocation of the filter more samples will be processed, which reduces the total overhead we incur when we invoke the kernel, and hence a higher throughput. However, a higher value here will also translate to a higher latency. 

<img height="200" src="./Images/fir.png">

<img height="300" src="./Images/throughput.png">


## Knowledge nuggets
:bulb: To see the estimated throughput, we are setting the Vitis Model Composer Hub block as below before pushing the _Generate_ button:

<img height="300" src="./Images/hub.png">

:bulb: The input data is split over four ports, where each successive sample is sent to a different input port in a round-robin fashion.

:bulb: The number of AI Engines used is equal to SSR^2 * CASC_LEN (in this case 4^2*1=16)


![](Images/screen_shot.png)


## Related Examples

* [This](../../SingleStreamSSR_FIR/README.md) is another example of a high throughput filter built from scratch instead of using the block from the AMD AI Engine DSP library.

* [This](../../../AIENGINE_plus_PL/AIE_HDL/SingleStreamSSR_FIR_withPL/README.md) is an example of an AI Engine/Programmable Logic heterogeneous design where the AI Engine is also built from scratch instead of using the block from the AMD AI Engine DSP library along with HDL blocks feeding the AI Engine array and receiving the filtered data back from the array.

------------
Copyright 2022 Xilinx

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
