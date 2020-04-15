// mainloop functions
void jsh_loop(void);
char *jsh_read_line(void);
char **jsh_split_line (char* line);
int jsh_execute(char** args);
int jsh_launch(char** args);


// builtins
int jsh_cd(char** args);
int jsh_exit(char** args);
int jsh_help(char** args);
// int jsh_test(char** args);

int jsh_num_builtins(void);


// util
char *jsh_parse_prompt(char* prompt_in);
void jsh_set_return(int status);
char *itoa(int i);
//char **tokenize(char* line);
