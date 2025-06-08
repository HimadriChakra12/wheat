#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void run_ps_script_from_url(const char *script_name) {
    char command[1024];
    const char *base_url = "https://github.com/HimadriChakra12/hyphw/raw/refs/heads/master/mashrooms/";

    snprintf(command, sizeof(command),
             "powershell -NoProfile -ExecutionPolicy Bypass -Command \"iwr -useb '%s%s' | iex\"",
             base_url, script_name);

    system(command);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("\033[1;33mUsage: hyphw install <script>\nor:    hyphw list\033[0m\n");
        return 1;
    }

    if (strcmp(argv[1], "list") == 0) {
        run_ps_script_from_url("mashrooms.ps1");
    } else if (strcmp(argv[1], "install") == 0 && argc >= 3) {
        char script_file[256];
        snprintf(script_file, sizeof(script_file), "%s.ps1", argv[2]);
        run_ps_script_from_url(script_file);
    } else {
        printf("Unknown command or missing argument: %s\n", argv[1]);
        return 1;
    }

    return 0;
}
