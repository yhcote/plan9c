/* plan9 C example file */
#include <u.h>
#include <libc.h>
#include <bio.h>

void
main(void)
{
	char *s;
	Biobuf bin;
	Biobuf bout;

	/* lib9 (libc) test */
	print("%C  sri maha ganapataye namaha\n\n", (Rune)strtol("0950", nil, 16));
	print("27 is binary %b\n\n", 27);

	/* libbio test */
	Binit(&bin, 0, OREAD);
	Binit(&bout, 1, OWRITE);

	print("Brdstr(): read a line: ");
	s = Brdstr(&bin, '\n', '\0');
	Bprint(&bout, "Bprint(): %s", s);

	exits(0);
}
