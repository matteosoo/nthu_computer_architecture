# assignment2

## PART I. (Load, Store, Add, Sub)
Please load the data 12($gp) as A, 0($gp) as B, and 8($gp) as C, and do the following
calculations.

```asm
D = C - B + A, store D to 4($gp).
E = A + A + C, store E to 12($gp)
```

## PART II. (Branch Loop, System call, Arithmetic Operations)
Please convert the following C-like code to MIPS assembly code. Write a new assembly
file for this part.

* Description: Please design a “Toy MIPS Bomb” that will generate a random number
(from zero to nine), and you can enter your lucky number into this Bomb (for only three
times). If your lucky number equals the random number, you can save the world.

```C
#include<stdio.h>

int main()
{
	int t0;
	int bingo,test1,test2;
	int counter = 3;
	
	printf("The Bomb has been activated!!!\n");
	srand(time(NULL));
	bingo = (rand()%9);
	
	while(counter > 0)
	{
		printf("You have only %d times to inactivate it!!!\n", counter);
		printf("Please enter your lucky number[0-9]:\n");
		scanf("%d", &t0);
		
		if(t0 < bingo)
		{
			if(counter>1)
			{
				printf("HA!HA!HA! Wrong Guess!\n");
				printf("You should choose a bigger number!\n");
			}
			else
			{
				printf("HA!HA!HA! Wrong Guess!\n");
				printf("Bye Bye!!!Boom!!!\n");
			}
		}
		else if(t0 > bingo)
		{
			if(counter>1)
			{
				printf("HA!HA!HA! Wrong Guess!\n");
				printf("You should choose a smaller number!\n");
			}
			else
			{
				printf("HA!HA!HA! Wrong Guess!\n");
				printf("Bye Bye!!!Boom!!!\n");
			}	
		}
		else
		{
			printf("Wow! You are very lucky! The boom has been inactive!\n");
			return 0;
		}
    	counter = counter - 1;
	}	
	return 0;
}
```
