#include <dirent.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <libgen.h>

/*
 * Roughly equivalent to `sudo smem -H -c 'pss name'`, but *much* faster.
 */

bool is_pid(const char* s) {
	while(*s != 0) {
		if(*s < '0' || '9' < *s) {
			return false;
		}
		s++;
	}
	return true;
}

long find_value(const char* s) {
	while(*s != 0 && (*s < '0' || '9' < *s)) {
		// While not a digit
		s++;
	}
	char buf[32] = "0";
	char *p = buf;
	while(*s != 0 && ('0' <= *s && *s <= '9')) {
		*p++ = *s++;
	}

	return strtol(buf, NULL, 10);
}

void find_executable(const char* s, char* executable) {
	while(*s != 0 && (*s != ' ' || *(s+1) != ' ')) {
		s++;
	}

	while(*s == ' ') {
		s++;
	}

	char* c = executable;
	while(*s != '\n') {
		if(*s == '/') {
			c = executable;
			s++;
		} else {
			*c++ = *s++;
		}
	}
	*c++ = 0;
}

int main() {
	if(setuid(0)) {
		perror("Failed to setuid(0)");
		return 1;
	}

	DIR *dp;
	struct dirent *ep;

	dp = opendir("/proc");
	if(dp == NULL) {
		perror("Failed to open /proc");
		return 2;
	}

	while((ep = readdir(dp))) {
		if(is_pid(ep->d_name)) {
			// Find name of executable
			char exename[266];
			snprintf(exename, 266, "/proc/%s/exe", ep->d_name);

			char executable[256] = "";
			if(readlink(exename, executable, 256) < 0) {
				continue;
			}
			char* basepath = basename(executable);

			// Find PSS
			char mapsname[268];
			snprintf(mapsname, 268, "/proc/%s/smaps", ep->d_name);

			FILE *fp;
			fp = fopen(mapsname, "rbe");
			if(fp == NULL) {
				continue;
			}

			char buf[512];
			long pss = 0;
			while(fgets(buf, 512, fp) != NULL) {
				if(strncmp(buf, "Pss:", 4) == 0) {
					pss += find_value(buf);
				}
			}
			fclose(fp);

			if(pss != 0) {
				printf("%li %s\n", pss, basepath);
			}

		}
	}

	closedir(dp);
	return 0;
}
