#include <u.h>
#include <libc.h>

/* prints ॐ  */

void
main(void)
{
	print("hello world: 27 is binary %b\n", 27);
	print("%C\n", (Rune)strtol("0950", nil, 16));
	exits(0);
}
