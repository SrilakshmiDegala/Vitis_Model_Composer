// In this example, all the function arguments are scalar. 
// Feeding matrices or vectors of the same dimensions to 
// the block will result in element wise operation.

#include <stdint.h>

#pragma XMC INPORT in1,in2
#pragma XMC OUTPORT out

void func6_a(int16_t in1, int16_t in2, int16_t &out)
{
   out = in1 + in2;
}
