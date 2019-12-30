#include "io.h"
int tak(int x, int y, int z) {
	if ( y < x ) return 1 + tak( tak(x-1, y, z), tak(y-1, z, x), tak(z-1, x, y) );
	else return z;
}

int main(){
    int a = 100, b = 100;
    outlln(a * b);
	return 0;
}
