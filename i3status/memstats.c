#include <dirent.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

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
	setuid(0);

	DIR *dp;
	struct dirent *ep;

	dp = opendir("/proc");
	if(dp == NULL) {
		perror("Failed to open /proc");
		return 1;
	}

	while((ep = readdir(dp))) {
		if(is_pid(ep->d_name)) {
			char fname[32] = "/proc/";
			FILE *fp;

			strncat(fname, ep->d_name, 10);
			strncat(fname, "/smaps", 7);

			fp = fopen(fname, "rbe");
			if(fp == NULL) {
				continue;
			}

			long pss = 0;
			char executable[256] = "";
			char buf[512];

			while(fgets(buf, 512, fp) != NULL) {
				if(*executable == 0 && strncmp(buf+24, " kB\n", 5) != 0) {
					find_executable(buf, executable);
				}
				if(strncmp(buf, "Pss:", 4) == 0) {
					pss += find_value(buf);
				}
			}
			if(pss != 0) {
				printf("%li %s\n", pss, executable);
			}
			fclose(fp);

		}
	}

	closedir(dp);
	return 0;
}
