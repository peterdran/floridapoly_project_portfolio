#include <stm32f2xx.h> 

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
