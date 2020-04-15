#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdbool.h>

#include "./main.h"

char *builtin_str[] = {
        "cd",
        "exit",
        "help"
};

int (*builtin_func[])(char **) = {
        &jsh_cd,
        &jsh_exit,
        &jsh_help
};

int jsh_num_builtins(void) {
    return sizeof(builtin_str) / sizeof(char *);
}

int EXIT_STATUS = 0;

// char *prompt = "> ";

int main(int argc, char **argv) {
    // config files (?)

    // execute commands from stdin
    jsh_loop();

    // cleanup
    return EXIT_STATUS;
}

void jsh_loop(void) {
    char *line;
    char **args;
    int status;

    do {
        printf("%s", jsh_parse_prompt(getenv("PS1")));

        line = jsh_read_line();
        args = jsh_split_line(line);
        status = jsh_execute(args);

        free(line);
        free(args);

    } while (status);
}

#define JSH_RL_BUFSIZE 1024

char *jsh_read_line(void) {
    int bufsize = JSH_RL_BUFSIZE;
    int position = 0;
    char *buffer = malloc(sizeof(char) * bufsize);
    int c;

    if (!buffer) {
        fprintf(stderr, "jsh: allocation error\n");
        exit(EXIT_FAILURE);
    }
    while (1) {
        c = getchar();

        if (c == EOF) {
            printf("\n");
            exit(EXIT_SUCCESS);
        } else if (c == '\n') {
            buffer[position] = '\0';
            return buffer;
        } else {
            buffer[position] = (char) c;
        }
        position++;

        if (position >= bufsize) {
            bufsize += JSH_RL_BUFSIZE;
            buffer = realloc(buffer, bufsize);
            if (!buffer) {
                fprintf(stderr, "jsh: allocation failure");
                exit(EXIT_FAILURE);
            }
        }
    }
}

#define JSH_TOK_BUFSIZE 64
#define JSH_TOK_DELIM " \t\r\n\a"

char **jsh_split_line(char *line) {
    int bufsize = JSH_TOK_BUFSIZE, token_num = 0;//, position = 0;
    char **tokens = malloc(bufsize * sizeof(char *));
    char *token;
    char chr;
    bool quotes = false;
    bool word = false;
    char quote_type = '\'';
    // for (len = 0; line[len] != '\0'; len++);

    if (!tokens) {
        fprintf(stderr, "jsh: allocation error\n");
        exit(EXIT_FAILURE);
    }

    tokens[token_num++] = line;
    // printf("%s\n", tokens[token_num - 1]);

    for (int i = 0; i < strlen(line); i++) {
    // for (int i = 0; line[i] != '\0'; i++) {
        chr = line[i];
        // printf("%c\n", chr);
        if (!quotes) {
            if (chr == '"' || chr == '\'') {
                // there's a quote here, so we should start a block
                tokens[token_num++] = line + i;
                quotes = true;
                quote_type = chr;
            } else {
                for (int c = 0; JSH_TOK_DELIM[c] != '\0'; c++) {
                    if (line[i] == JSH_TOK_DELIM[c]) {
                        tokens[token_num++] = line + i + 1;

                        printf("%s\n", tokens[token_num - 1]);

                        line[i] = '\0';
                    }
                }
            }
        } else {
            // we are currently inside quotes
            if (chr == quote_type) {
                line[i] = '\0';
                quotes = false;
                printf("%s\n", tokens[token_num - 1]);
            }
        }
    }

    tokens[token_num] = NULL;
    return tokens;
}

int jsh_execute(char **args) {
    if (args[0] == NULL) {
        return 1;
    }

//    for (int i = 0; args[i] != NULL; i++) {
//	printf("%s\n", args[i]);
//    }

    for (int i = 0; i < jsh_num_builtins(); i++) {
        if (strcmp(args[0], builtin_str[i]) == 0) {
            return builtin_func[i](args);
        }
    }

    return jsh_launch(args);
}

int jsh_launch(char **args) {
    pid_t pid, wpid;
    int status;

    pid = fork();
    if (pid == 0) {
        // this is the child process
        if (execvp(args[0], args) == -1) {
            perror("jsh");
        }
    } else if (pid == -1) {
        // something went wrong with the fork
        perror("jsh");
    } else {
        // this is the parent process, and everything went well
        do {
            wpid = waitpid(pid, &status, WUNTRACED);
        } while (!WIFEXITED(status) && !WIFSIGNALED(status));
        jsh_set_return(WEXITSTATUS(status));
    }
    return 1;
}

// builtins
int jsh_cd(char **args) {
    if (args[1] == NULL) {
        // cd $HOME
        args[1] = getenv("HOME");
    }
    if (chdir(args[1]) != 0) {
        perror("jsh");
        jsh_set_return(1);
    } else {
        jsh_set_return(0);
    }
    return 1;
}

int jsh_exit(char **args) {
    if (args[1] != NULL) {
        EXIT_STATUS = atoi(args[1]);
    } else {
        EXIT_STATUS = atoi(getenv("?"));
    }
    return 0;
}

int jsh_help(char **args) {
    printf("JSH - Jemand's SHell\n");
    printf("--------------------\n\n");
    printf("Builtin commands are:\n");
    for (int i = 0; i < jsh_num_builtins(); i++) {
        printf("%s\n", builtin_str[i]);
    }
    printf("\n");
    printf("For specific info on (almost) any command, type `man <name>`.\n");
    return 1;
}

// util
char *jsh_parse_prompt(char *prompt_in) {
    return "> ";
}

void jsh_set_return(int status) {
    setenv("?", itoa(status), 1);
}

char *itoa(int i) {
    int length = snprintf(NULL, 0, "%d", i);
    char *str = malloc(length + 1);
    snprintf(str, length + 1, "%d", i);
    return str;
}
