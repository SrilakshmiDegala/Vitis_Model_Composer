# PL + AI Engine design Examples <a name="heterogeneous"></a>


Versal AI Core devices are highly integrated, multicore compute platform that can adapt with evolving and diverse algorithms. These devices include both Programmable Logic (PL) and an AI Engine array. Vitis Model Composer provides a design environment, based on industry standard MATLAB and Simulink tools, to model and simulate designs with both PL and AI Engine components.


 <p align="center">
  <img src="images/aie_plus_pl.png" align ="center" width = 70%>
</p>
 

 

# Examples
<table style="width:100%">
<tr>
  <td align="center" colspan="2" style="bold" ><b><a href="./AIE_HLS/README.md">Design with both AI Engines and HLS kernels</a></b>
</tr>

<tr>
<td>
<a href="./AIE_HLS/Channelizer/README.md">Polyphase Channelizer</a> <img src="../../Images/new.PNG" width="50">
</td>
<td>
This example implements a high-speed channelizer design using a combination of AI Engine and Programmable Logic (PL) resources in Versal devices. 
</td>
</tr> 

 
<tr>
<td>
<a href="./AIE_HLS/AIE_HLS_with_interface/README.md">AI Engines and HLS Kernel with interface blocks</a>
</td>
<td>
A design with both AI Engine and HLS Kernel blocks connected through interface blocks.
</td>
</tr> 
 
<tr>
<td>
<a href="./AIE_HLS/AIE_HLS_without_interface/README.md">AI Engines and HLS Kernel connected directly</a>
</td>
<td>
A design with both AI Engine and HLS Kernel blocks connected directly.
</td>
</tr>

<tr> 
<td>
<a href="./AIE_HLS/FFT2D_HLS/README.md">2D FFT</a>
</td>
<td>
A 2D FFT design with both AI Engine and HLS Kernel.
</td>
 </tr>
</table>

<br/>
<table style="width:100%">
<tr>
  <td align="center" colspan="2" style="bold" ><b><a href="./AIE_HDL/README.md">Designs with both AI Engine and HDL blocks</a></b>
</tr>

<tr>
<td>
<a href="./AIE_HDL/AIE_HDL_cosim/README.md">Design with HDL and AI Engine blocks</a>
</td>
<td>
Design with HDL and AI Engine blocks
</td>
</tr> 
 
<tr>
<td>
<a href="./AIE_HDL/AIE_HDL_cosim_rtl_blackbox/README.md">Design with imported RTL and AI Engine blocks</a>
</td>
<td>
Design with imported RTL and AI Engine blocks.
</td>
</tr>
 
<td>
<a href="./AIE_HDL/FFT2D/README.md">2D FFT</a>
</td>
<td>
A 2D FFT design with both AI Engine and HDL Kernel.
</td>
</tr>

<tr> 
<td>
<a href="./AIE_HDL/SingleStreamSSR_FIR_withPL/README.md">Super Sample Rate FIR filter with PL</a>
</td>
<td>
This design showcases a Super Sample Rate FIR filter to process a 4GSPS input stream. In this design we consider latencies within the kernels, which are implemented into the FIFO's included in AXI-Stream Interconnect(PL).
</td>
</tr>

<tr> 
<td>
<a href="./AIE_HDL/AIE_HDL_multirate/README.md">AIE-PL Multirate Design</a>
</td>
<td>
This design highlights best practices for working with multirate designs.  The example utilizes multirate AIE FIR filters to generate outputs in multiple clock domains which are then fed thru the PL.  The DSP aspects are discussed separately, so for designers not interested in filtering the discussion still provides useful information.
</td>
</tr>
 
</table>

