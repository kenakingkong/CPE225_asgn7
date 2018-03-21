/* makena Kong
 * mkong02
 * assignment 7
 * part 1: C recusrions
 */

#include <stdio.h>

void countBackwardFrom(int x);
void countForwardTo(int x);

/*what if they enter 0 ?)*/
int main() 
{
   int input;
   printf("Enter number: ");
   scanf("%d", &input);
   countBackwardFrom(input);
   printf("\n");
   countForwardTo(input);
   printf("\n");
   return(0);
}

/*count backwards from x to 1*/
void countBackwardFrom(int x)
{
   int i = x;
   if (i==1){
      printf("%d", i);
      return;
   }
   else{
      printf("%d, ", i);
      i--;
      countBackwardFrom(i);
   }
   return;
}

/*count from 1 to x*/
void countForwardTo(int x)
{  
   int i = x;
   if (i == 1)
      printf("1");  
   else if (i > 1)
   {
      countForwardTo(i-1);
      printf(", %d", i);
   }
   return;
}
