#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

char* smem_argv[] = {
	"smem", "-H", "-c", "pss name", NULL
};

int main() {
	setuid(0);
	execvp(smem_argv[0], smem_argv);
	return 0;
}
