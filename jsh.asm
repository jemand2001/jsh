	.file	"main.c"
	.text
	.globl	builtin_str
	.section	.rodata
.LC0:
	.string	"cd"
.LC1:
	.string	"exit"
	.section	.data.rel.local,"aw"
	.align 16
	.type	builtin_str, @object
	.size	builtin_str, 16
builtin_str:
	.quad	.LC0
	.quad	.LC1
	.globl	builtin_func
	.align 16
	.type	builtin_func, @object
	.size	builtin_func, 16
builtin_func:
	.quad	jsh_cd
	.quad	jsh_exit
	.text
	.globl	jsh_num_builtins
	.type	jsh_num_builtins, @function
jsh_num_builtins:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$2, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	jsh_num_builtins, .-jsh_num_builtins
	.globl	EXIT_STATUS
	.bss
	.align 4
	.type	EXIT_STATUS, @object
	.size	EXIT_STATUS, 4
EXIT_STATUS:
	.zero	4
	.globl	prompt
	.section	.rodata
.LC2:
	.string	"> "
	.section	.data.rel.local
	.align 8
	.type	prompt, @object
	.size	prompt, 8
prompt:
	.quad	.LC2
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	call	jsh_loop
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.globl	jsh_loop
	.type	jsh_loop, @function
jsh_loop:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
.L6:
	movq	prompt(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	call	jsh_read_line
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	jsh_split_line
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	jsh_execute
	movl	%eax, -20(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	cmpl	$0, -20(%rbp)
	jne	.L6
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	jsh_loop, .-jsh_loop
	.section	.rodata
.LC3:
	.string	"jsh: allocation error\n"
.LC4:
	.string	"jsh: allocation failure"
	.text
	.globl	jsh_read_line
	.type	jsh_read_line, @function
jsh_read_line:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	$1024, -4(%rbp)
	movl	$0, -8(%rbp)
	movl	-4(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L8
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$22, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L8:
	call	getchar@PLT
	movl	%eax, -20(%rbp)
	cmpl	$-1, -20(%rbp)
	jne	.L9
	movl	$10, %edi
	call	putchar@PLT
	movl	$0, %edi
	call	exit@PLT
.L9:
	cmpl	$10, -20(%rbp)
	jne	.L10
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-16(%rbp), %rax
	jmp	.L13
.L10:
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movl	-20(%rbp), %edx
	movb	%dl, (%rax)
	addl	$1, -8(%rbp)
	movl	-8(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jl	.L8
	addl	$1024, -4(%rbp)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L8
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$23, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L13:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	jsh_read_line, .-jsh_read_line
	.section	.rodata
.LC5:
	.string	" \t\r\n\007"
	.text
	.globl	jsh_split_line
	.type	jsh_split_line, @function
jsh_split_line:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	$64, -4(%rbp)
	movl	$0, -8(%rbp)
	movl	-4(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L15
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$22, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L15:
	movq	-40(%rbp), %rax
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	call	strtok@PLT
	movq	%rax, -24(%rbp)
	jmp	.L16
.L18:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-16(%rbp), %rax
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rax, (%rdx)
	addl	$1, -8(%rbp)
	movl	-8(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jl	.L17
	addl	$64, -4(%rbp)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L17
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$22, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L17:
	leaq	.LC5(%rip), %rsi
	movl	$0, %edi
	call	strtok@PLT
	movq	%rax, -24(%rbp)
.L16:
	cmpq	$0, -24(%rbp)
	jne	.L18
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	$0, (%rax)
	movq	-16(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	jsh_split_line, .-jsh_split_line
	.globl	jsh_execute
	.type	jsh_execute, @function
jsh_execute:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L21
	movl	$1, %eax
	jmp	.L22
.L21:
	movl	$0, -4(%rbp)
	jmp	.L23
.L25:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	builtin_str(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L24
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	builtin_func(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	*%rdx
	jmp	.L22
.L24:
	addl	$1, -4(%rbp)
.L23:
	call	jsh_num_builtins
	cmpl	%eax, -4(%rbp)
	jl	.L25
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	jsh_launch
.L22:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	jsh_execute, .-jsh_execute
	.section	.rodata
.LC6:
	.string	"jsh"
	.text
	.globl	jsh_launch
	.type	jsh_launch, @function
jsh_launch:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	call	fork@PLT
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jne	.L27
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	execvp@PLT
	cmpl	$-1, %eax
	jne	.L28
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	jmp	.L28
.L27:
	cmpl	$-1, -4(%rbp)
	jne	.L29
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	jmp	.L28
.L29:
	leaq	-12(%rbp), %rcx
	movl	-4(%rbp), %eax
	movl	$2, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	waitpid@PLT
	movl	%eax, -8(%rbp)
	movl	-12(%rbp), %eax
	andl	$127, %eax
	testl	%eax, %eax
	je	.L28
	movl	-12(%rbp), %eax
	andl	$127, %eax
	addl	$1, %eax
	sarb	%al
	testb	%al, %al
	jle	.L29
.L28:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	jsh_launch, .-jsh_launch
	.section	.rodata
.LC7:
	.string	"HOME"
	.text
	.globl	jsh_cd
	.type	jsh_cd, @function
jsh_cd:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L31
	movq	-24(%rbp), %rax
	leaq	8(%rax), %rbx
	leaq	.LC7(%rip), %rdi
	call	getenv@PLT
	movq	%rax, (%rbx)
.L31:
	movq	-24(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	chdir@PLT
	testl	%eax, %eax
	je	.L32
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
.L32:
	movl	$1, %eax
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	jsh_cd, .-jsh_cd
	.globl	jsh_exit
	.type	jsh_exit, @function
jsh_exit:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	jsh_exit, .-jsh_exit
	.ident	"GCC: (Debian 9.2.1-25) 9.2.1 20200123"
	.section	.note.GNU-stack,"",@progbits
