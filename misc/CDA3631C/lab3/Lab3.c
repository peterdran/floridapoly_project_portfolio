//
//  Author: David Foster


#include <stm32f2xx.h> 
//#include <assert.h>
																			// Notice answers are in base 10!
																			// Assuming that the system is little-endian
uint32_t array0[] = {0x00000001,0x00000020,0x00000400,0x00008000,0x00440000,0x02200000,0x12000000,0x80000000}; // answer = 0d0/ 0x0  
uint32_t array1[] = {0x00000000,0x00000020,0x00000400,0x00008000,0x00440000,0x02200000,0x12000000,0x80000000}; // answer = 37/ 0x25 (in hex 0x25 =0d37)
uint32_t array2[] = {0x00000000,0x00000000,0x00000400,0x00008000,0x00440000,0x02200000,0x12000000,0x80000000}; // answer = 74/ 0x4A
uint32_t array3[] = {0x00000000,0x00000000,0x00000000,0x00008000,0x00440000,0x02200000,0x12000000,0x80000000}; // answer = 111/ 0x6F
uint32_t array4[] = {0x00000000,0x00000000,0x00000000,0x00000000,0x00440000,0x02200000,0x12000000,0x80000000}; // answer = 146/ 0x92
uint32_t array5[] = {0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x02200000,0x12000000,0x80000000}; // answer = 181/ 0xB5
uint32_t array6[] = {0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x12000000,0x80000000}; // answer = 217/ 0xD9
uint32_t array7[] = {0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x80000000}; // answer = 255/ 0xFF

uint32_t* arrays[] = {array0, array1, array2, array3, array4, array5, array6, array7}; 
uint32_t narrays = sizeof(arrays)/sizeof(uint32_t*);

uint32_t findLowBitASM(uint32_t*);
uint32_t findLowBitC(uint32_t*);

int main(void){
	int i;
	//volatile int position1;
	int position2;
	for (i = 0; i<narrays; i++)
	{
		//position1 = findLowBitASM(arrays[i]);
		position2 = findLowBitC(arrays[i]);
		//assert(position1 == position2);
	}
	
	while(1){/*position1++;*/} // endless loop to keep micro from crashing
						 // position++ keeps position in scope for easier debugging
}

// stub for your implementation of the function
uint32_t findLowBitC(uint32_t* array)
{
	uint16_t trigger = 0;
	uint16_t pos = 0;
	uint16_t inpos = 0;
	uint16_t inposcounter = 0;
	while (trigger==0)
	{
		
		//loop for each array entry
		if (inpos!= 32) 
		{            
			//loop for each bit in an entry
			if((1 & array[pos]>>inpos) != 1) 
			{
				inpos++; //1 not found
			}
			if (1& array[pos]>>inpos)
			{
				trigger=1; //1 found
			}
		}
		else
			{
				inposcounter++;
				pos++;
				inpos=0;
			}
	}
	return (inposcounter*32 +inpos);
}
