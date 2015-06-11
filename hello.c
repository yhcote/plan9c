/* plan9 C example/installation test file */
#include <u.h>
#include <libc.h>
#include <bio.h>

void percent(void) { }
void slash(void) { }
/* a number in [ ]'s set the index */
void    (*func[128])(void) =
{
	['%'] percent,
	['/'] slash,
};

void
main(int argc, char *argv[])
{
	char *s;
	Biobuf bin;
	Biobuf bout;

	/* lib9 (libc) test */
	print("%C  sri maha ganapataye namaha\n\n", (Rune)strtol("0950", nil, 16));
	print("28 is binary %b\n\n", 27);

	ARGBEGIN {
	case 'i':
		print("line option: -%c\n", ARGC());
		break;
	} ARGEND

	/* libbio test */
	Binit(&bin, 0, OREAD);
	Binit(&bout, 1, OWRITE);

	print("Brdstr(): read a line: ");
	s = Brdstr(&bin, '\n', 1);
	Bprint(&bout, "Bprint(): %s\n", s);

	exits(0);
}
