#include <stdio.h>

int a = 1, b = 2, c = 3;

int main()
{
    a = a + 1;//a = 2
    a = (a * 2) + 3; //a = 7
    b = a + 5; //b = 12
    c = b ^ 123; //c = 119
    a = b >> 2; //a = 3
    b = c << 2; //b = 476
    // printf("%d %d %d\n",a,b,c);
    return 0;
}