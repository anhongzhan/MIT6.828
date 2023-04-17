
obj/user/echo.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 b7 00 00 00       	call   8000e8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
  800040:	8b 7d 08             	mov    0x8(%ebp),%edi
  800043:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800046:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80004d:	83 ff 01             	cmp    $0x1,%edi
  800050:	7f 07                	jg     800059 <umain+0x26>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  800052:	bb 01 00 00 00       	mov    $0x1,%ebx
  800057:	eb 60                	jmp    8000b9 <umain+0x86>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	68 a0 1f 80 00       	push   $0x801fa0
  800061:	ff 76 04             	pushl  0x4(%esi)
  800064:	e8 e9 01 00 00       	call   800252 <strcmp>
  800069:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  80006c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800073:	85 c0                	test   %eax,%eax
  800075:	75 db                	jne    800052 <umain+0x1f>
		argc--;
  800077:	83 ef 01             	sub    $0x1,%edi
		argv++;
  80007a:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  80007d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800084:	eb cc                	jmp    800052 <umain+0x1f>
		if (i > 1)
			write(1, " ", 1);
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 01                	push   $0x1
  80008b:	68 a3 1f 80 00       	push   $0x801fa3
  800090:	6a 01                	push   $0x1
  800092:	e8 2d 0b 00 00       	call   800bc4 <write>
  800097:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a0:	e8 ab 00 00 00       	call   800150 <strlen>
  8000a5:	83 c4 0c             	add    $0xc,%esp
  8000a8:	50                   	push   %eax
  8000a9:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000ac:	6a 01                	push   $0x1
  8000ae:	e8 11 0b 00 00       	call   800bc4 <write>
	for (i = 1; i < argc; i++) {
  8000b3:	83 c3 01             	add    $0x1,%ebx
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	39 df                	cmp    %ebx,%edi
  8000bb:	7e 07                	jle    8000c4 <umain+0x91>
		if (i > 1)
  8000bd:	83 fb 01             	cmp    $0x1,%ebx
  8000c0:	7f c4                	jg     800086 <umain+0x53>
  8000c2:	eb d6                	jmp    80009a <umain+0x67>
	}
	if (!nflag)
  8000c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c8:	74 08                	je     8000d2 <umain+0x9f>
		write(1, "\n", 1);
}
  8000ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    
		write(1, "\n", 1);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	6a 01                	push   $0x1
  8000d7:	68 f8 23 80 00       	push   $0x8023f8
  8000dc:	6a 01                	push   $0x1
  8000de:	e8 e1 0a 00 00       	call   800bc4 <write>
  8000e3:	83 c4 10             	add    $0x10,%esp
}
  8000e6:	eb e2                	jmp    8000ca <umain+0x97>

008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	f3 0f 1e fb          	endbr32 
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f7:	e8 93 04 00 00       	call   80058f <sys_getenvid>
  8000fc:	25 ff 03 00 00       	and    $0x3ff,%eax
  800101:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800104:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800109:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010e:	85 db                	test   %ebx,%ebx
  800110:	7e 07                	jle    800119 <libmain+0x31>
		binaryname = argv[0];
  800112:	8b 06                	mov    (%esi),%eax
  800114:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800119:	83 ec 08             	sub    $0x8,%esp
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	e8 10 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800123:	e8 0a 00 00 00       	call   800132 <exit>
}
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800132:	f3 0f 1e fb          	endbr32 
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80013c:	e8 94 08 00 00       	call   8009d5 <close_all>
	sys_env_destroy(0);
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	6a 00                	push   $0x0
  800146:	e8 ff 03 00 00       	call   80054a <sys_env_destroy>
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800150:	f3 0f 1e fb          	endbr32 
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80015a:	b8 00 00 00 00       	mov    $0x0,%eax
  80015f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800163:	74 05                	je     80016a <strlen+0x1a>
		n++;
  800165:	83 c0 01             	add    $0x1,%eax
  800168:	eb f5                	jmp    80015f <strlen+0xf>
	return n;
}
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80016c:	f3 0f 1e fb          	endbr32 
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800176:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800179:	b8 00 00 00 00       	mov    $0x0,%eax
  80017e:	39 d0                	cmp    %edx,%eax
  800180:	74 0d                	je     80018f <strnlen+0x23>
  800182:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800186:	74 05                	je     80018d <strnlen+0x21>
		n++;
  800188:	83 c0 01             	add    $0x1,%eax
  80018b:	eb f1                	jmp    80017e <strnlen+0x12>
  80018d:	89 c2                	mov    %eax,%edx
	return n;
}
  80018f:	89 d0                	mov    %edx,%eax
  800191:	5d                   	pop    %ebp
  800192:	c3                   	ret    

00800193 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800193:	f3 0f 1e fb          	endbr32 
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8001aa:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8001ad:	83 c0 01             	add    $0x1,%eax
  8001b0:	84 d2                	test   %dl,%dl
  8001b2:	75 f2                	jne    8001a6 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8001b4:	89 c8                	mov    %ecx,%eax
  8001b6:	5b                   	pop    %ebx
  8001b7:	5d                   	pop    %ebp
  8001b8:	c3                   	ret    

008001b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8001b9:	f3 0f 1e fb          	endbr32 
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	53                   	push   %ebx
  8001c1:	83 ec 10             	sub    $0x10,%esp
  8001c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001c7:	53                   	push   %ebx
  8001c8:	e8 83 ff ff ff       	call   800150 <strlen>
  8001cd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8001d0:	ff 75 0c             	pushl  0xc(%ebp)
  8001d3:	01 d8                	add    %ebx,%eax
  8001d5:	50                   	push   %eax
  8001d6:	e8 b8 ff ff ff       	call   800193 <strcpy>
	return dst;
}
  8001db:	89 d8                	mov    %ebx,%eax
  8001dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    

008001e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001e2:	f3 0f 1e fb          	endbr32 
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	56                   	push   %esi
  8001ea:	53                   	push   %ebx
  8001eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f1:	89 f3                	mov    %esi,%ebx
  8001f3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001f6:	89 f0                	mov    %esi,%eax
  8001f8:	39 d8                	cmp    %ebx,%eax
  8001fa:	74 11                	je     80020d <strncpy+0x2b>
		*dst++ = *src;
  8001fc:	83 c0 01             	add    $0x1,%eax
  8001ff:	0f b6 0a             	movzbl (%edx),%ecx
  800202:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800205:	80 f9 01             	cmp    $0x1,%cl
  800208:	83 da ff             	sbb    $0xffffffff,%edx
  80020b:	eb eb                	jmp    8001f8 <strncpy+0x16>
	}
	return ret;
}
  80020d:	89 f0                	mov    %esi,%eax
  80020f:	5b                   	pop    %ebx
  800210:	5e                   	pop    %esi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    

00800213 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800213:	f3 0f 1e fb          	endbr32 
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	56                   	push   %esi
  80021b:	53                   	push   %ebx
  80021c:	8b 75 08             	mov    0x8(%ebp),%esi
  80021f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800222:	8b 55 10             	mov    0x10(%ebp),%edx
  800225:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800227:	85 d2                	test   %edx,%edx
  800229:	74 21                	je     80024c <strlcpy+0x39>
  80022b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80022f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800231:	39 c2                	cmp    %eax,%edx
  800233:	74 14                	je     800249 <strlcpy+0x36>
  800235:	0f b6 19             	movzbl (%ecx),%ebx
  800238:	84 db                	test   %bl,%bl
  80023a:	74 0b                	je     800247 <strlcpy+0x34>
			*dst++ = *src++;
  80023c:	83 c1 01             	add    $0x1,%ecx
  80023f:	83 c2 01             	add    $0x1,%edx
  800242:	88 5a ff             	mov    %bl,-0x1(%edx)
  800245:	eb ea                	jmp    800231 <strlcpy+0x1e>
  800247:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800249:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80024c:	29 f0                	sub    %esi,%eax
}
  80024e:	5b                   	pop    %ebx
  80024f:	5e                   	pop    %esi
  800250:	5d                   	pop    %ebp
  800251:	c3                   	ret    

00800252 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800252:	f3 0f 1e fb          	endbr32 
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80025c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80025f:	0f b6 01             	movzbl (%ecx),%eax
  800262:	84 c0                	test   %al,%al
  800264:	74 0c                	je     800272 <strcmp+0x20>
  800266:	3a 02                	cmp    (%edx),%al
  800268:	75 08                	jne    800272 <strcmp+0x20>
		p++, q++;
  80026a:	83 c1 01             	add    $0x1,%ecx
  80026d:	83 c2 01             	add    $0x1,%edx
  800270:	eb ed                	jmp    80025f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800272:	0f b6 c0             	movzbl %al,%eax
  800275:	0f b6 12             	movzbl (%edx),%edx
  800278:	29 d0                	sub    %edx,%eax
}
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    

0080027c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80027c:	f3 0f 1e fb          	endbr32 
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	53                   	push   %ebx
  800284:	8b 45 08             	mov    0x8(%ebp),%eax
  800287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028a:	89 c3                	mov    %eax,%ebx
  80028c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80028f:	eb 06                	jmp    800297 <strncmp+0x1b>
		n--, p++, q++;
  800291:	83 c0 01             	add    $0x1,%eax
  800294:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800297:	39 d8                	cmp    %ebx,%eax
  800299:	74 16                	je     8002b1 <strncmp+0x35>
  80029b:	0f b6 08             	movzbl (%eax),%ecx
  80029e:	84 c9                	test   %cl,%cl
  8002a0:	74 04                	je     8002a6 <strncmp+0x2a>
  8002a2:	3a 0a                	cmp    (%edx),%cl
  8002a4:	74 eb                	je     800291 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8002a6:	0f b6 00             	movzbl (%eax),%eax
  8002a9:	0f b6 12             	movzbl (%edx),%edx
  8002ac:	29 d0                	sub    %edx,%eax
}
  8002ae:	5b                   	pop    %ebx
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    
		return 0;
  8002b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b6:	eb f6                	jmp    8002ae <strncmp+0x32>

008002b8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002b8:	f3 0f 1e fb          	endbr32 
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002c6:	0f b6 10             	movzbl (%eax),%edx
  8002c9:	84 d2                	test   %dl,%dl
  8002cb:	74 09                	je     8002d6 <strchr+0x1e>
		if (*s == c)
  8002cd:	38 ca                	cmp    %cl,%dl
  8002cf:	74 0a                	je     8002db <strchr+0x23>
	for (; *s; s++)
  8002d1:	83 c0 01             	add    $0x1,%eax
  8002d4:	eb f0                	jmp    8002c6 <strchr+0xe>
			return (char *) s;
	return 0;
  8002d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002db:	5d                   	pop    %ebp
  8002dc:	c3                   	ret    

008002dd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002dd:	f3 0f 1e fb          	endbr32 
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002eb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002ee:	38 ca                	cmp    %cl,%dl
  8002f0:	74 09                	je     8002fb <strfind+0x1e>
  8002f2:	84 d2                	test   %dl,%dl
  8002f4:	74 05                	je     8002fb <strfind+0x1e>
	for (; *s; s++)
  8002f6:	83 c0 01             	add    $0x1,%eax
  8002f9:	eb f0                	jmp    8002eb <strfind+0xe>
			break;
	return (char *) s;
}
  8002fb:	5d                   	pop    %ebp
  8002fc:	c3                   	ret    

008002fd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002fd:	f3 0f 1e fb          	endbr32 
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	57                   	push   %edi
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	8b 7d 08             	mov    0x8(%ebp),%edi
  80030a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80030d:	85 c9                	test   %ecx,%ecx
  80030f:	74 31                	je     800342 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800311:	89 f8                	mov    %edi,%eax
  800313:	09 c8                	or     %ecx,%eax
  800315:	a8 03                	test   $0x3,%al
  800317:	75 23                	jne    80033c <memset+0x3f>
		c &= 0xFF;
  800319:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80031d:	89 d3                	mov    %edx,%ebx
  80031f:	c1 e3 08             	shl    $0x8,%ebx
  800322:	89 d0                	mov    %edx,%eax
  800324:	c1 e0 18             	shl    $0x18,%eax
  800327:	89 d6                	mov    %edx,%esi
  800329:	c1 e6 10             	shl    $0x10,%esi
  80032c:	09 f0                	or     %esi,%eax
  80032e:	09 c2                	or     %eax,%edx
  800330:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800332:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800335:	89 d0                	mov    %edx,%eax
  800337:	fc                   	cld    
  800338:	f3 ab                	rep stos %eax,%es:(%edi)
  80033a:	eb 06                	jmp    800342 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80033c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033f:	fc                   	cld    
  800340:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800342:	89 f8                	mov    %edi,%eax
  800344:	5b                   	pop    %ebx
  800345:	5e                   	pop    %esi
  800346:	5f                   	pop    %edi
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    

00800349 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800349:	f3 0f 1e fb          	endbr32 
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	57                   	push   %edi
  800351:	56                   	push   %esi
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	8b 75 0c             	mov    0xc(%ebp),%esi
  800358:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80035b:	39 c6                	cmp    %eax,%esi
  80035d:	73 32                	jae    800391 <memmove+0x48>
  80035f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800362:	39 c2                	cmp    %eax,%edx
  800364:	76 2b                	jbe    800391 <memmove+0x48>
		s += n;
		d += n;
  800366:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800369:	89 fe                	mov    %edi,%esi
  80036b:	09 ce                	or     %ecx,%esi
  80036d:	09 d6                	or     %edx,%esi
  80036f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800375:	75 0e                	jne    800385 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800377:	83 ef 04             	sub    $0x4,%edi
  80037a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80037d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800380:	fd                   	std    
  800381:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800383:	eb 09                	jmp    80038e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800385:	83 ef 01             	sub    $0x1,%edi
  800388:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80038b:	fd                   	std    
  80038c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80038e:	fc                   	cld    
  80038f:	eb 1a                	jmp    8003ab <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800391:	89 c2                	mov    %eax,%edx
  800393:	09 ca                	or     %ecx,%edx
  800395:	09 f2                	or     %esi,%edx
  800397:	f6 c2 03             	test   $0x3,%dl
  80039a:	75 0a                	jne    8003a6 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80039c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80039f:	89 c7                	mov    %eax,%edi
  8003a1:	fc                   	cld    
  8003a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8003a4:	eb 05                	jmp    8003ab <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8003a6:	89 c7                	mov    %eax,%edi
  8003a8:	fc                   	cld    
  8003a9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8003ab:	5e                   	pop    %esi
  8003ac:	5f                   	pop    %edi
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8003af:	f3 0f 1e fb          	endbr32 
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8003b9:	ff 75 10             	pushl  0x10(%ebp)
  8003bc:	ff 75 0c             	pushl  0xc(%ebp)
  8003bf:	ff 75 08             	pushl  0x8(%ebp)
  8003c2:	e8 82 ff ff ff       	call   800349 <memmove>
}
  8003c7:	c9                   	leave  
  8003c8:	c3                   	ret    

008003c9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8003c9:	f3 0f 1e fb          	endbr32 
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	56                   	push   %esi
  8003d1:	53                   	push   %ebx
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d8:	89 c6                	mov    %eax,%esi
  8003da:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003dd:	39 f0                	cmp    %esi,%eax
  8003df:	74 1c                	je     8003fd <memcmp+0x34>
		if (*s1 != *s2)
  8003e1:	0f b6 08             	movzbl (%eax),%ecx
  8003e4:	0f b6 1a             	movzbl (%edx),%ebx
  8003e7:	38 d9                	cmp    %bl,%cl
  8003e9:	75 08                	jne    8003f3 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8003eb:	83 c0 01             	add    $0x1,%eax
  8003ee:	83 c2 01             	add    $0x1,%edx
  8003f1:	eb ea                	jmp    8003dd <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8003f3:	0f b6 c1             	movzbl %cl,%eax
  8003f6:	0f b6 db             	movzbl %bl,%ebx
  8003f9:	29 d8                	sub    %ebx,%eax
  8003fb:	eb 05                	jmp    800402 <memcmp+0x39>
	}

	return 0;
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800402:	5b                   	pop    %ebx
  800403:	5e                   	pop    %esi
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800406:	f3 0f 1e fb          	endbr32 
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800413:	89 c2                	mov    %eax,%edx
  800415:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800418:	39 d0                	cmp    %edx,%eax
  80041a:	73 09                	jae    800425 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80041c:	38 08                	cmp    %cl,(%eax)
  80041e:	74 05                	je     800425 <memfind+0x1f>
	for (; s < ends; s++)
  800420:	83 c0 01             	add    $0x1,%eax
  800423:	eb f3                	jmp    800418 <memfind+0x12>
			break;
	return (void *) s;
}
  800425:	5d                   	pop    %ebp
  800426:	c3                   	ret    

00800427 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800427:	f3 0f 1e fb          	endbr32 
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	57                   	push   %edi
  80042f:	56                   	push   %esi
  800430:	53                   	push   %ebx
  800431:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800434:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800437:	eb 03                	jmp    80043c <strtol+0x15>
		s++;
  800439:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80043c:	0f b6 01             	movzbl (%ecx),%eax
  80043f:	3c 20                	cmp    $0x20,%al
  800441:	74 f6                	je     800439 <strtol+0x12>
  800443:	3c 09                	cmp    $0x9,%al
  800445:	74 f2                	je     800439 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800447:	3c 2b                	cmp    $0x2b,%al
  800449:	74 2a                	je     800475 <strtol+0x4e>
	int neg = 0;
  80044b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800450:	3c 2d                	cmp    $0x2d,%al
  800452:	74 2b                	je     80047f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800454:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80045a:	75 0f                	jne    80046b <strtol+0x44>
  80045c:	80 39 30             	cmpb   $0x30,(%ecx)
  80045f:	74 28                	je     800489 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800461:	85 db                	test   %ebx,%ebx
  800463:	b8 0a 00 00 00       	mov    $0xa,%eax
  800468:	0f 44 d8             	cmove  %eax,%ebx
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
  800470:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800473:	eb 46                	jmp    8004bb <strtol+0x94>
		s++;
  800475:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800478:	bf 00 00 00 00       	mov    $0x0,%edi
  80047d:	eb d5                	jmp    800454 <strtol+0x2d>
		s++, neg = 1;
  80047f:	83 c1 01             	add    $0x1,%ecx
  800482:	bf 01 00 00 00       	mov    $0x1,%edi
  800487:	eb cb                	jmp    800454 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800489:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80048d:	74 0e                	je     80049d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80048f:	85 db                	test   %ebx,%ebx
  800491:	75 d8                	jne    80046b <strtol+0x44>
		s++, base = 8;
  800493:	83 c1 01             	add    $0x1,%ecx
  800496:	bb 08 00 00 00       	mov    $0x8,%ebx
  80049b:	eb ce                	jmp    80046b <strtol+0x44>
		s += 2, base = 16;
  80049d:	83 c1 02             	add    $0x2,%ecx
  8004a0:	bb 10 00 00 00       	mov    $0x10,%ebx
  8004a5:	eb c4                	jmp    80046b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8004a7:	0f be d2             	movsbl %dl,%edx
  8004aa:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8004ad:	3b 55 10             	cmp    0x10(%ebp),%edx
  8004b0:	7d 3a                	jge    8004ec <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8004b2:	83 c1 01             	add    $0x1,%ecx
  8004b5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8004b9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8004bb:	0f b6 11             	movzbl (%ecx),%edx
  8004be:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004c1:	89 f3                	mov    %esi,%ebx
  8004c3:	80 fb 09             	cmp    $0x9,%bl
  8004c6:	76 df                	jbe    8004a7 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  8004c8:	8d 72 9f             	lea    -0x61(%edx),%esi
  8004cb:	89 f3                	mov    %esi,%ebx
  8004cd:	80 fb 19             	cmp    $0x19,%bl
  8004d0:	77 08                	ja     8004da <strtol+0xb3>
			dig = *s - 'a' + 10;
  8004d2:	0f be d2             	movsbl %dl,%edx
  8004d5:	83 ea 57             	sub    $0x57,%edx
  8004d8:	eb d3                	jmp    8004ad <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  8004da:	8d 72 bf             	lea    -0x41(%edx),%esi
  8004dd:	89 f3                	mov    %esi,%ebx
  8004df:	80 fb 19             	cmp    $0x19,%bl
  8004e2:	77 08                	ja     8004ec <strtol+0xc5>
			dig = *s - 'A' + 10;
  8004e4:	0f be d2             	movsbl %dl,%edx
  8004e7:	83 ea 37             	sub    $0x37,%edx
  8004ea:	eb c1                	jmp    8004ad <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  8004ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f0:	74 05                	je     8004f7 <strtol+0xd0>
		*endptr = (char *) s;
  8004f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004f5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004f7:	89 c2                	mov    %eax,%edx
  8004f9:	f7 da                	neg    %edx
  8004fb:	85 ff                	test   %edi,%edi
  8004fd:	0f 45 c2             	cmovne %edx,%eax
}
  800500:	5b                   	pop    %ebx
  800501:	5e                   	pop    %esi
  800502:	5f                   	pop    %edi
  800503:	5d                   	pop    %ebp
  800504:	c3                   	ret    

00800505 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800505:	f3 0f 1e fb          	endbr32 
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	57                   	push   %edi
  80050d:	56                   	push   %esi
  80050e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80050f:	b8 00 00 00 00       	mov    $0x0,%eax
  800514:	8b 55 08             	mov    0x8(%ebp),%edx
  800517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051a:	89 c3                	mov    %eax,%ebx
  80051c:	89 c7                	mov    %eax,%edi
  80051e:	89 c6                	mov    %eax,%esi
  800520:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800522:	5b                   	pop    %ebx
  800523:	5e                   	pop    %esi
  800524:	5f                   	pop    %edi
  800525:	5d                   	pop    %ebp
  800526:	c3                   	ret    

00800527 <sys_cgetc>:

int
sys_cgetc(void)
{
  800527:	f3 0f 1e fb          	endbr32 
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	57                   	push   %edi
  80052f:	56                   	push   %esi
  800530:	53                   	push   %ebx
	asm volatile("int %1\n"
  800531:	ba 00 00 00 00       	mov    $0x0,%edx
  800536:	b8 01 00 00 00       	mov    $0x1,%eax
  80053b:	89 d1                	mov    %edx,%ecx
  80053d:	89 d3                	mov    %edx,%ebx
  80053f:	89 d7                	mov    %edx,%edi
  800541:	89 d6                	mov    %edx,%esi
  800543:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800545:	5b                   	pop    %ebx
  800546:	5e                   	pop    %esi
  800547:	5f                   	pop    %edi
  800548:	5d                   	pop    %ebp
  800549:	c3                   	ret    

0080054a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80054a:	f3 0f 1e fb          	endbr32 
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	57                   	push   %edi
  800552:	56                   	push   %esi
  800553:	53                   	push   %ebx
  800554:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800557:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055c:	8b 55 08             	mov    0x8(%ebp),%edx
  80055f:	b8 03 00 00 00       	mov    $0x3,%eax
  800564:	89 cb                	mov    %ecx,%ebx
  800566:	89 cf                	mov    %ecx,%edi
  800568:	89 ce                	mov    %ecx,%esi
  80056a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80056c:	85 c0                	test   %eax,%eax
  80056e:	7f 08                	jg     800578 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800570:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800573:	5b                   	pop    %ebx
  800574:	5e                   	pop    %esi
  800575:	5f                   	pop    %edi
  800576:	5d                   	pop    %ebp
  800577:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800578:	83 ec 0c             	sub    $0xc,%esp
  80057b:	50                   	push   %eax
  80057c:	6a 03                	push   $0x3
  80057e:	68 af 1f 80 00       	push   $0x801faf
  800583:	6a 23                	push   $0x23
  800585:	68 cc 1f 80 00       	push   $0x801fcc
  80058a:	e8 9c 0f 00 00       	call   80152b <_panic>

0080058f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80058f:	f3 0f 1e fb          	endbr32 
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	57                   	push   %edi
  800597:	56                   	push   %esi
  800598:	53                   	push   %ebx
	asm volatile("int %1\n"
  800599:	ba 00 00 00 00       	mov    $0x0,%edx
  80059e:	b8 02 00 00 00       	mov    $0x2,%eax
  8005a3:	89 d1                	mov    %edx,%ecx
  8005a5:	89 d3                	mov    %edx,%ebx
  8005a7:	89 d7                	mov    %edx,%edi
  8005a9:	89 d6                	mov    %edx,%esi
  8005ab:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8005ad:	5b                   	pop    %ebx
  8005ae:	5e                   	pop    %esi
  8005af:	5f                   	pop    %edi
  8005b0:	5d                   	pop    %ebp
  8005b1:	c3                   	ret    

008005b2 <sys_yield>:

void
sys_yield(void)
{
  8005b2:	f3 0f 1e fb          	endbr32 
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	57                   	push   %edi
  8005ba:	56                   	push   %esi
  8005bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8005bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c1:	b8 0b 00 00 00       	mov    $0xb,%eax
  8005c6:	89 d1                	mov    %edx,%ecx
  8005c8:	89 d3                	mov    %edx,%ebx
  8005ca:	89 d7                	mov    %edx,%edi
  8005cc:	89 d6                	mov    %edx,%esi
  8005ce:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8005d0:	5b                   	pop    %ebx
  8005d1:	5e                   	pop    %esi
  8005d2:	5f                   	pop    %edi
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8005d5:	f3 0f 1e fb          	endbr32 
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	57                   	push   %edi
  8005dd:	56                   	push   %esi
  8005de:	53                   	push   %ebx
  8005df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005e2:	be 00 00 00 00       	mov    $0x0,%esi
  8005e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ed:	b8 04 00 00 00       	mov    $0x4,%eax
  8005f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005f5:	89 f7                	mov    %esi,%edi
  8005f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005f9:	85 c0                	test   %eax,%eax
  8005fb:	7f 08                	jg     800605 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8005fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800600:	5b                   	pop    %ebx
  800601:	5e                   	pop    %esi
  800602:	5f                   	pop    %edi
  800603:	5d                   	pop    %ebp
  800604:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800605:	83 ec 0c             	sub    $0xc,%esp
  800608:	50                   	push   %eax
  800609:	6a 04                	push   $0x4
  80060b:	68 af 1f 80 00       	push   $0x801faf
  800610:	6a 23                	push   $0x23
  800612:	68 cc 1f 80 00       	push   $0x801fcc
  800617:	e8 0f 0f 00 00       	call   80152b <_panic>

0080061c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80061c:	f3 0f 1e fb          	endbr32 
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	57                   	push   %edi
  800624:	56                   	push   %esi
  800625:	53                   	push   %ebx
  800626:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800629:	8b 55 08             	mov    0x8(%ebp),%edx
  80062c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80062f:	b8 05 00 00 00       	mov    $0x5,%eax
  800634:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800637:	8b 7d 14             	mov    0x14(%ebp),%edi
  80063a:	8b 75 18             	mov    0x18(%ebp),%esi
  80063d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80063f:	85 c0                	test   %eax,%eax
  800641:	7f 08                	jg     80064b <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800646:	5b                   	pop    %ebx
  800647:	5e                   	pop    %esi
  800648:	5f                   	pop    %edi
  800649:	5d                   	pop    %ebp
  80064a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	50                   	push   %eax
  80064f:	6a 05                	push   $0x5
  800651:	68 af 1f 80 00       	push   $0x801faf
  800656:	6a 23                	push   $0x23
  800658:	68 cc 1f 80 00       	push   $0x801fcc
  80065d:	e8 c9 0e 00 00       	call   80152b <_panic>

00800662 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800662:	f3 0f 1e fb          	endbr32 
  800666:	55                   	push   %ebp
  800667:	89 e5                	mov    %esp,%ebp
  800669:	57                   	push   %edi
  80066a:	56                   	push   %esi
  80066b:	53                   	push   %ebx
  80066c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80066f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800674:	8b 55 08             	mov    0x8(%ebp),%edx
  800677:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80067a:	b8 06 00 00 00       	mov    $0x6,%eax
  80067f:	89 df                	mov    %ebx,%edi
  800681:	89 de                	mov    %ebx,%esi
  800683:	cd 30                	int    $0x30
	if(check && ret > 0)
  800685:	85 c0                	test   %eax,%eax
  800687:	7f 08                	jg     800691 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800689:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80068c:	5b                   	pop    %ebx
  80068d:	5e                   	pop    %esi
  80068e:	5f                   	pop    %edi
  80068f:	5d                   	pop    %ebp
  800690:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	50                   	push   %eax
  800695:	6a 06                	push   $0x6
  800697:	68 af 1f 80 00       	push   $0x801faf
  80069c:	6a 23                	push   $0x23
  80069e:	68 cc 1f 80 00       	push   $0x801fcc
  8006a3:	e8 83 0e 00 00       	call   80152b <_panic>

008006a8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8006a8:	f3 0f 1e fb          	endbr32 
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
  8006af:	57                   	push   %edi
  8006b0:	56                   	push   %esi
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8006bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c5:	89 df                	mov    %ebx,%edi
  8006c7:	89 de                	mov    %ebx,%esi
  8006c9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006cb:	85 c0                	test   %eax,%eax
  8006cd:	7f 08                	jg     8006d7 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8006cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d2:	5b                   	pop    %ebx
  8006d3:	5e                   	pop    %esi
  8006d4:	5f                   	pop    %edi
  8006d5:	5d                   	pop    %ebp
  8006d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	50                   	push   %eax
  8006db:	6a 08                	push   $0x8
  8006dd:	68 af 1f 80 00       	push   $0x801faf
  8006e2:	6a 23                	push   $0x23
  8006e4:	68 cc 1f 80 00       	push   $0x801fcc
  8006e9:	e8 3d 0e 00 00       	call   80152b <_panic>

008006ee <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8006ee:	f3 0f 1e fb          	endbr32 
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	57                   	push   %edi
  8006f6:	56                   	push   %esi
  8006f7:	53                   	push   %ebx
  8006f8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800700:	8b 55 08             	mov    0x8(%ebp),%edx
  800703:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800706:	b8 09 00 00 00       	mov    $0x9,%eax
  80070b:	89 df                	mov    %ebx,%edi
  80070d:	89 de                	mov    %ebx,%esi
  80070f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800711:	85 c0                	test   %eax,%eax
  800713:	7f 08                	jg     80071d <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800715:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800718:	5b                   	pop    %ebx
  800719:	5e                   	pop    %esi
  80071a:	5f                   	pop    %edi
  80071b:	5d                   	pop    %ebp
  80071c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80071d:	83 ec 0c             	sub    $0xc,%esp
  800720:	50                   	push   %eax
  800721:	6a 09                	push   $0x9
  800723:	68 af 1f 80 00       	push   $0x801faf
  800728:	6a 23                	push   $0x23
  80072a:	68 cc 1f 80 00       	push   $0x801fcc
  80072f:	e8 f7 0d 00 00       	call   80152b <_panic>

00800734 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800734:	f3 0f 1e fb          	endbr32 
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	57                   	push   %edi
  80073c:	56                   	push   %esi
  80073d:	53                   	push   %ebx
  80073e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800741:	bb 00 00 00 00       	mov    $0x0,%ebx
  800746:	8b 55 08             	mov    0x8(%ebp),%edx
  800749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80074c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800751:	89 df                	mov    %ebx,%edi
  800753:	89 de                	mov    %ebx,%esi
  800755:	cd 30                	int    $0x30
	if(check && ret > 0)
  800757:	85 c0                	test   %eax,%eax
  800759:	7f 08                	jg     800763 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80075b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075e:	5b                   	pop    %ebx
  80075f:	5e                   	pop    %esi
  800760:	5f                   	pop    %edi
  800761:	5d                   	pop    %ebp
  800762:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	50                   	push   %eax
  800767:	6a 0a                	push   $0xa
  800769:	68 af 1f 80 00       	push   $0x801faf
  80076e:	6a 23                	push   $0x23
  800770:	68 cc 1f 80 00       	push   $0x801fcc
  800775:	e8 b1 0d 00 00       	call   80152b <_panic>

0080077a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80077a:	f3 0f 1e fb          	endbr32 
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	57                   	push   %edi
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
	asm volatile("int %1\n"
  800784:	8b 55 08             	mov    0x8(%ebp),%edx
  800787:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80078a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80078f:	be 00 00 00 00       	mov    $0x0,%esi
  800794:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800797:	8b 7d 14             	mov    0x14(%ebp),%edi
  80079a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80079c:	5b                   	pop    %ebx
  80079d:	5e                   	pop    %esi
  80079e:	5f                   	pop    %edi
  80079f:	5d                   	pop    %ebp
  8007a0:	c3                   	ret    

008007a1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8007a1:	f3 0f 1e fb          	endbr32 
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	57                   	push   %edi
  8007a9:	56                   	push   %esi
  8007aa:	53                   	push   %ebx
  8007ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8007ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007b6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8007bb:	89 cb                	mov    %ecx,%ebx
  8007bd:	89 cf                	mov    %ecx,%edi
  8007bf:	89 ce                	mov    %ecx,%esi
  8007c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	7f 08                	jg     8007cf <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8007c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ca:	5b                   	pop    %ebx
  8007cb:	5e                   	pop    %esi
  8007cc:	5f                   	pop    %edi
  8007cd:	5d                   	pop    %ebp
  8007ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8007cf:	83 ec 0c             	sub    $0xc,%esp
  8007d2:	50                   	push   %eax
  8007d3:	6a 0d                	push   $0xd
  8007d5:	68 af 1f 80 00       	push   $0x801faf
  8007da:	6a 23                	push   $0x23
  8007dc:	68 cc 1f 80 00       	push   $0x801fcc
  8007e1:	e8 45 0d 00 00       	call   80152b <_panic>

008007e6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8007e6:	f3 0f 1e fb          	endbr32 
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	05 00 00 00 30       	add    $0x30000000,%eax
  8007f5:	c1 e8 0c             	shr    $0xc,%eax
}
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8007fa:	f3 0f 1e fb          	endbr32 
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800809:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80080e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800815:	f3 0f 1e fb          	endbr32 
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800821:	89 c2                	mov    %eax,%edx
  800823:	c1 ea 16             	shr    $0x16,%edx
  800826:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80082d:	f6 c2 01             	test   $0x1,%dl
  800830:	74 2d                	je     80085f <fd_alloc+0x4a>
  800832:	89 c2                	mov    %eax,%edx
  800834:	c1 ea 0c             	shr    $0xc,%edx
  800837:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80083e:	f6 c2 01             	test   $0x1,%dl
  800841:	74 1c                	je     80085f <fd_alloc+0x4a>
  800843:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800848:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80084d:	75 d2                	jne    800821 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800858:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80085d:	eb 0a                	jmp    800869 <fd_alloc+0x54>
			*fd_store = fd;
  80085f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800862:	89 01                	mov    %eax,(%ecx)
			return 0;
  800864:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80086b:	f3 0f 1e fb          	endbr32 
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800875:	83 f8 1f             	cmp    $0x1f,%eax
  800878:	77 30                	ja     8008aa <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80087a:	c1 e0 0c             	shl    $0xc,%eax
  80087d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800882:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800888:	f6 c2 01             	test   $0x1,%dl
  80088b:	74 24                	je     8008b1 <fd_lookup+0x46>
  80088d:	89 c2                	mov    %eax,%edx
  80088f:	c1 ea 0c             	shr    $0xc,%edx
  800892:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800899:	f6 c2 01             	test   $0x1,%dl
  80089c:	74 1a                	je     8008b8 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a1:	89 02                	mov    %eax,(%edx)
	return 0;
  8008a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    
		return -E_INVAL;
  8008aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008af:	eb f7                	jmp    8008a8 <fd_lookup+0x3d>
		return -E_INVAL;
  8008b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b6:	eb f0                	jmp    8008a8 <fd_lookup+0x3d>
  8008b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008bd:	eb e9                	jmp    8008a8 <fd_lookup+0x3d>

008008bf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008bf:	f3 0f 1e fb          	endbr32 
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cc:	ba 58 20 80 00       	mov    $0x802058,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8008d1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8008d6:	39 08                	cmp    %ecx,(%eax)
  8008d8:	74 33                	je     80090d <dev_lookup+0x4e>
  8008da:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8008dd:	8b 02                	mov    (%edx),%eax
  8008df:	85 c0                	test   %eax,%eax
  8008e1:	75 f3                	jne    8008d6 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8008e8:	8b 40 48             	mov    0x48(%eax),%eax
  8008eb:	83 ec 04             	sub    $0x4,%esp
  8008ee:	51                   	push   %ecx
  8008ef:	50                   	push   %eax
  8008f0:	68 dc 1f 80 00       	push   $0x801fdc
  8008f5:	e8 18 0d 00 00       	call   801612 <cprintf>
	*dev = 0;
  8008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80090b:	c9                   	leave  
  80090c:	c3                   	ret    
			*dev = devtab[i];
  80090d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800910:	89 01                	mov    %eax,(%ecx)
			return 0;
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
  800917:	eb f2                	jmp    80090b <dev_lookup+0x4c>

00800919 <fd_close>:
{
  800919:	f3 0f 1e fb          	endbr32 
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	57                   	push   %edi
  800921:	56                   	push   %esi
  800922:	53                   	push   %ebx
  800923:	83 ec 24             	sub    $0x24,%esp
  800926:	8b 75 08             	mov    0x8(%ebp),%esi
  800929:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80092c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80092f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800930:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800936:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800939:	50                   	push   %eax
  80093a:	e8 2c ff ff ff       	call   80086b <fd_lookup>
  80093f:	89 c3                	mov    %eax,%ebx
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	78 05                	js     80094d <fd_close+0x34>
	    || fd != fd2)
  800948:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80094b:	74 16                	je     800963 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80094d:	89 f8                	mov    %edi,%eax
  80094f:	84 c0                	test   %al,%al
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
  800956:	0f 44 d8             	cmove  %eax,%ebx
}
  800959:	89 d8                	mov    %ebx,%eax
  80095b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80095e:	5b                   	pop    %ebx
  80095f:	5e                   	pop    %esi
  800960:	5f                   	pop    %edi
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800969:	50                   	push   %eax
  80096a:	ff 36                	pushl  (%esi)
  80096c:	e8 4e ff ff ff       	call   8008bf <dev_lookup>
  800971:	89 c3                	mov    %eax,%ebx
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	85 c0                	test   %eax,%eax
  800978:	78 1a                	js     800994 <fd_close+0x7b>
		if (dev->dev_close)
  80097a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80097d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800980:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800985:	85 c0                	test   %eax,%eax
  800987:	74 0b                	je     800994 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	56                   	push   %esi
  80098d:	ff d0                	call   *%eax
  80098f:	89 c3                	mov    %eax,%ebx
  800991:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	56                   	push   %esi
  800998:	6a 00                	push   $0x0
  80099a:	e8 c3 fc ff ff       	call   800662 <sys_page_unmap>
	return r;
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	eb b5                	jmp    800959 <fd_close+0x40>

008009a4 <close>:

int
close(int fdnum)
{
  8009a4:	f3 0f 1e fb          	endbr32 
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b1:	50                   	push   %eax
  8009b2:	ff 75 08             	pushl  0x8(%ebp)
  8009b5:	e8 b1 fe ff ff       	call   80086b <fd_lookup>
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	85 c0                	test   %eax,%eax
  8009bf:	79 02                	jns    8009c3 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8009c1:	c9                   	leave  
  8009c2:	c3                   	ret    
		return fd_close(fd, 1);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	6a 01                	push   $0x1
  8009c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009cb:	e8 49 ff ff ff       	call   800919 <fd_close>
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	eb ec                	jmp    8009c1 <close+0x1d>

008009d5 <close_all>:

void
close_all(void)
{
  8009d5:	f3 0f 1e fb          	endbr32 
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	53                   	push   %ebx
  8009dd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8009e0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8009e5:	83 ec 0c             	sub    $0xc,%esp
  8009e8:	53                   	push   %ebx
  8009e9:	e8 b6 ff ff ff       	call   8009a4 <close>
	for (i = 0; i < MAXFD; i++)
  8009ee:	83 c3 01             	add    $0x1,%ebx
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	83 fb 20             	cmp    $0x20,%ebx
  8009f7:	75 ec                	jne    8009e5 <close_all+0x10>
}
  8009f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009fe:	f3 0f 1e fb          	endbr32 
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	57                   	push   %edi
  800a06:	56                   	push   %esi
  800a07:	53                   	push   %ebx
  800a08:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800a0b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800a0e:	50                   	push   %eax
  800a0f:	ff 75 08             	pushl  0x8(%ebp)
  800a12:	e8 54 fe ff ff       	call   80086b <fd_lookup>
  800a17:	89 c3                	mov    %eax,%ebx
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	85 c0                	test   %eax,%eax
  800a1e:	0f 88 81 00 00 00    	js     800aa5 <dup+0xa7>
		return r;
	close(newfdnum);
  800a24:	83 ec 0c             	sub    $0xc,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	e8 75 ff ff ff       	call   8009a4 <close>

	newfd = INDEX2FD(newfdnum);
  800a2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a32:	c1 e6 0c             	shl    $0xc,%esi
  800a35:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800a3b:	83 c4 04             	add    $0x4,%esp
  800a3e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a41:	e8 b4 fd ff ff       	call   8007fa <fd2data>
  800a46:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800a48:	89 34 24             	mov    %esi,(%esp)
  800a4b:	e8 aa fd ff ff       	call   8007fa <fd2data>
  800a50:	83 c4 10             	add    $0x10,%esp
  800a53:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a55:	89 d8                	mov    %ebx,%eax
  800a57:	c1 e8 16             	shr    $0x16,%eax
  800a5a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800a61:	a8 01                	test   $0x1,%al
  800a63:	74 11                	je     800a76 <dup+0x78>
  800a65:	89 d8                	mov    %ebx,%eax
  800a67:	c1 e8 0c             	shr    $0xc,%eax
  800a6a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800a71:	f6 c2 01             	test   $0x1,%dl
  800a74:	75 39                	jne    800aaf <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a79:	89 d0                	mov    %edx,%eax
  800a7b:	c1 e8 0c             	shr    $0xc,%eax
  800a7e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a85:	83 ec 0c             	sub    $0xc,%esp
  800a88:	25 07 0e 00 00       	and    $0xe07,%eax
  800a8d:	50                   	push   %eax
  800a8e:	56                   	push   %esi
  800a8f:	6a 00                	push   $0x0
  800a91:	52                   	push   %edx
  800a92:	6a 00                	push   $0x0
  800a94:	e8 83 fb ff ff       	call   80061c <sys_page_map>
  800a99:	89 c3                	mov    %eax,%ebx
  800a9b:	83 c4 20             	add    $0x20,%esp
  800a9e:	85 c0                	test   %eax,%eax
  800aa0:	78 31                	js     800ad3 <dup+0xd5>
		goto err;

	return newfdnum;
  800aa2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800aa5:	89 d8                	mov    %ebx,%eax
  800aa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aaa:	5b                   	pop    %ebx
  800aab:	5e                   	pop    %esi
  800aac:	5f                   	pop    %edi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800aaf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ab6:	83 ec 0c             	sub    $0xc,%esp
  800ab9:	25 07 0e 00 00       	and    $0xe07,%eax
  800abe:	50                   	push   %eax
  800abf:	57                   	push   %edi
  800ac0:	6a 00                	push   $0x0
  800ac2:	53                   	push   %ebx
  800ac3:	6a 00                	push   $0x0
  800ac5:	e8 52 fb ff ff       	call   80061c <sys_page_map>
  800aca:	89 c3                	mov    %eax,%ebx
  800acc:	83 c4 20             	add    $0x20,%esp
  800acf:	85 c0                	test   %eax,%eax
  800ad1:	79 a3                	jns    800a76 <dup+0x78>
	sys_page_unmap(0, newfd);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	56                   	push   %esi
  800ad7:	6a 00                	push   $0x0
  800ad9:	e8 84 fb ff ff       	call   800662 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800ade:	83 c4 08             	add    $0x8,%esp
  800ae1:	57                   	push   %edi
  800ae2:	6a 00                	push   $0x0
  800ae4:	e8 79 fb ff ff       	call   800662 <sys_page_unmap>
	return r;
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	eb b7                	jmp    800aa5 <dup+0xa7>

00800aee <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800aee:	f3 0f 1e fb          	endbr32 
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	53                   	push   %ebx
  800af6:	83 ec 1c             	sub    $0x1c,%esp
  800af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800afc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800aff:	50                   	push   %eax
  800b00:	53                   	push   %ebx
  800b01:	e8 65 fd ff ff       	call   80086b <fd_lookup>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	85 c0                	test   %eax,%eax
  800b0b:	78 3f                	js     800b4c <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b0d:	83 ec 08             	sub    $0x8,%esp
  800b10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b13:	50                   	push   %eax
  800b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b17:	ff 30                	pushl  (%eax)
  800b19:	e8 a1 fd ff ff       	call   8008bf <dev_lookup>
  800b1e:	83 c4 10             	add    $0x10,%esp
  800b21:	85 c0                	test   %eax,%eax
  800b23:	78 27                	js     800b4c <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800b25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b28:	8b 42 08             	mov    0x8(%edx),%eax
  800b2b:	83 e0 03             	and    $0x3,%eax
  800b2e:	83 f8 01             	cmp    $0x1,%eax
  800b31:	74 1e                	je     800b51 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b36:	8b 40 08             	mov    0x8(%eax),%eax
  800b39:	85 c0                	test   %eax,%eax
  800b3b:	74 35                	je     800b72 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800b3d:	83 ec 04             	sub    $0x4,%esp
  800b40:	ff 75 10             	pushl  0x10(%ebp)
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	52                   	push   %edx
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
}
  800b4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b51:	a1 04 40 80 00       	mov    0x804004,%eax
  800b56:	8b 40 48             	mov    0x48(%eax),%eax
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	53                   	push   %ebx
  800b5d:	50                   	push   %eax
  800b5e:	68 1d 20 80 00       	push   $0x80201d
  800b63:	e8 aa 0a 00 00       	call   801612 <cprintf>
		return -E_INVAL;
  800b68:	83 c4 10             	add    $0x10,%esp
  800b6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b70:	eb da                	jmp    800b4c <read+0x5e>
		return -E_NOT_SUPP;
  800b72:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800b77:	eb d3                	jmp    800b4c <read+0x5e>

00800b79 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b79:	f3 0f 1e fb          	endbr32 
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	57                   	push   %edi
  800b81:	56                   	push   %esi
  800b82:	53                   	push   %ebx
  800b83:	83 ec 0c             	sub    $0xc,%esp
  800b86:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b89:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b91:	eb 02                	jmp    800b95 <readn+0x1c>
  800b93:	01 c3                	add    %eax,%ebx
  800b95:	39 f3                	cmp    %esi,%ebx
  800b97:	73 21                	jae    800bba <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b99:	83 ec 04             	sub    $0x4,%esp
  800b9c:	89 f0                	mov    %esi,%eax
  800b9e:	29 d8                	sub    %ebx,%eax
  800ba0:	50                   	push   %eax
  800ba1:	89 d8                	mov    %ebx,%eax
  800ba3:	03 45 0c             	add    0xc(%ebp),%eax
  800ba6:	50                   	push   %eax
  800ba7:	57                   	push   %edi
  800ba8:	e8 41 ff ff ff       	call   800aee <read>
		if (m < 0)
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	85 c0                	test   %eax,%eax
  800bb2:	78 04                	js     800bb8 <readn+0x3f>
			return m;
		if (m == 0)
  800bb4:	75 dd                	jne    800b93 <readn+0x1a>
  800bb6:	eb 02                	jmp    800bba <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800bb8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800bba:	89 d8                	mov    %ebx,%eax
  800bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	53                   	push   %ebx
  800bcc:	83 ec 1c             	sub    $0x1c,%esp
  800bcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bd2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bd5:	50                   	push   %eax
  800bd6:	53                   	push   %ebx
  800bd7:	e8 8f fc ff ff       	call   80086b <fd_lookup>
  800bdc:	83 c4 10             	add    $0x10,%esp
  800bdf:	85 c0                	test   %eax,%eax
  800be1:	78 3a                	js     800c1d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800be9:	50                   	push   %eax
  800bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bed:	ff 30                	pushl  (%eax)
  800bef:	e8 cb fc ff ff       	call   8008bf <dev_lookup>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	85 c0                	test   %eax,%eax
  800bf9:	78 22                	js     800c1d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfe:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c02:	74 1e                	je     800c22 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c07:	8b 52 0c             	mov    0xc(%edx),%edx
  800c0a:	85 d2                	test   %edx,%edx
  800c0c:	74 35                	je     800c43 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	ff 75 10             	pushl  0x10(%ebp)
  800c14:	ff 75 0c             	pushl  0xc(%ebp)
  800c17:	50                   	push   %eax
  800c18:	ff d2                	call   *%edx
  800c1a:	83 c4 10             	add    $0x10,%esp
}
  800c1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c22:	a1 04 40 80 00       	mov    0x804004,%eax
  800c27:	8b 40 48             	mov    0x48(%eax),%eax
  800c2a:	83 ec 04             	sub    $0x4,%esp
  800c2d:	53                   	push   %ebx
  800c2e:	50                   	push   %eax
  800c2f:	68 39 20 80 00       	push   $0x802039
  800c34:	e8 d9 09 00 00       	call   801612 <cprintf>
		return -E_INVAL;
  800c39:	83 c4 10             	add    $0x10,%esp
  800c3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c41:	eb da                	jmp    800c1d <write+0x59>
		return -E_NOT_SUPP;
  800c43:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c48:	eb d3                	jmp    800c1d <write+0x59>

00800c4a <seek>:

int
seek(int fdnum, off_t offset)
{
  800c4a:	f3 0f 1e fb          	endbr32 
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c57:	50                   	push   %eax
  800c58:	ff 75 08             	pushl  0x8(%ebp)
  800c5b:	e8 0b fc ff ff       	call   80086b <fd_lookup>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	85 c0                	test   %eax,%eax
  800c65:	78 0e                	js     800c75 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c6d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800c77:	f3 0f 1e fb          	endbr32 
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	53                   	push   %ebx
  800c7f:	83 ec 1c             	sub    $0x1c,%esp
  800c82:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c85:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	53                   	push   %ebx
  800c8a:	e8 dc fb ff ff       	call   80086b <fd_lookup>
  800c8f:	83 c4 10             	add    $0x10,%esp
  800c92:	85 c0                	test   %eax,%eax
  800c94:	78 37                	js     800ccd <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c96:	83 ec 08             	sub    $0x8,%esp
  800c99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca0:	ff 30                	pushl  (%eax)
  800ca2:	e8 18 fc ff ff       	call   8008bf <dev_lookup>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	85 c0                	test   %eax,%eax
  800cac:	78 1f                	js     800ccd <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800cb5:	74 1b                	je     800cd2 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cba:	8b 52 18             	mov    0x18(%edx),%edx
  800cbd:	85 d2                	test   %edx,%edx
  800cbf:	74 32                	je     800cf3 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800cc1:	83 ec 08             	sub    $0x8,%esp
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	50                   	push   %eax
  800cc8:	ff d2                	call   *%edx
  800cca:	83 c4 10             	add    $0x10,%esp
}
  800ccd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    
			thisenv->env_id, fdnum);
  800cd2:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cd7:	8b 40 48             	mov    0x48(%eax),%eax
  800cda:	83 ec 04             	sub    $0x4,%esp
  800cdd:	53                   	push   %ebx
  800cde:	50                   	push   %eax
  800cdf:	68 fc 1f 80 00       	push   $0x801ffc
  800ce4:	e8 29 09 00 00       	call   801612 <cprintf>
		return -E_INVAL;
  800ce9:	83 c4 10             	add    $0x10,%esp
  800cec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cf1:	eb da                	jmp    800ccd <ftruncate+0x56>
		return -E_NOT_SUPP;
  800cf3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cf8:	eb d3                	jmp    800ccd <ftruncate+0x56>

00800cfa <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800cfa:	f3 0f 1e fb          	endbr32 
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	53                   	push   %ebx
  800d02:	83 ec 1c             	sub    $0x1c,%esp
  800d05:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d0b:	50                   	push   %eax
  800d0c:	ff 75 08             	pushl  0x8(%ebp)
  800d0f:	e8 57 fb ff ff       	call   80086b <fd_lookup>
  800d14:	83 c4 10             	add    $0x10,%esp
  800d17:	85 c0                	test   %eax,%eax
  800d19:	78 4b                	js     800d66 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d1b:	83 ec 08             	sub    $0x8,%esp
  800d1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d21:	50                   	push   %eax
  800d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d25:	ff 30                	pushl  (%eax)
  800d27:	e8 93 fb ff ff       	call   8008bf <dev_lookup>
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	78 33                	js     800d66 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d36:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800d3a:	74 2f                	je     800d6b <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800d3c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800d3f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800d46:	00 00 00 
	stat->st_isdir = 0;
  800d49:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800d50:	00 00 00 
	stat->st_dev = dev;
  800d53:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800d59:	83 ec 08             	sub    $0x8,%esp
  800d5c:	53                   	push   %ebx
  800d5d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d60:	ff 50 14             	call   *0x14(%eax)
  800d63:	83 c4 10             	add    $0x10,%esp
}
  800d66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    
		return -E_NOT_SUPP;
  800d6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d70:	eb f4                	jmp    800d66 <fstat+0x6c>

00800d72 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800d72:	f3 0f 1e fb          	endbr32 
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800d7b:	83 ec 08             	sub    $0x8,%esp
  800d7e:	6a 00                	push   $0x0
  800d80:	ff 75 08             	pushl  0x8(%ebp)
  800d83:	e8 fb 01 00 00       	call   800f83 <open>
  800d88:	89 c3                	mov    %eax,%ebx
  800d8a:	83 c4 10             	add    $0x10,%esp
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	78 1b                	js     800dac <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800d91:	83 ec 08             	sub    $0x8,%esp
  800d94:	ff 75 0c             	pushl  0xc(%ebp)
  800d97:	50                   	push   %eax
  800d98:	e8 5d ff ff ff       	call   800cfa <fstat>
  800d9d:	89 c6                	mov    %eax,%esi
	close(fd);
  800d9f:	89 1c 24             	mov    %ebx,(%esp)
  800da2:	e8 fd fb ff ff       	call   8009a4 <close>
	return r;
  800da7:	83 c4 10             	add    $0x10,%esp
  800daa:	89 f3                	mov    %esi,%ebx
}
  800dac:	89 d8                	mov    %ebx,%eax
  800dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	89 c6                	mov    %eax,%esi
  800dbc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800dbe:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800dc5:	74 27                	je     800dee <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800dc7:	6a 07                	push   $0x7
  800dc9:	68 00 50 80 00       	push   $0x805000
  800dce:	56                   	push   %esi
  800dcf:	ff 35 00 40 80 00    	pushl  0x804000
  800dd5:	e8 84 0e 00 00       	call   801c5e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800dda:	83 c4 0c             	add    $0xc,%esp
  800ddd:	6a 00                	push   $0x0
  800ddf:	53                   	push   %ebx
  800de0:	6a 00                	push   $0x0
  800de2:	e8 f2 0d 00 00       	call   801bd9 <ipc_recv>
}
  800de7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800dee:	83 ec 0c             	sub    $0xc,%esp
  800df1:	6a 01                	push   $0x1
  800df3:	e8 be 0e 00 00       	call   801cb6 <ipc_find_env>
  800df8:	a3 00 40 80 00       	mov    %eax,0x804000
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	eb c5                	jmp    800dc7 <fsipc+0x12>

00800e02 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800e02:	f3 0f 1e fb          	endbr32 
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  800e12:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800e1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e24:	b8 02 00 00 00       	mov    $0x2,%eax
  800e29:	e8 87 ff ff ff       	call   800db5 <fsipc>
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <devfile_flush>:
{
  800e30:	f3 0f 1e fb          	endbr32 
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8b 40 0c             	mov    0xc(%eax),%eax
  800e40:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800e45:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4a:	b8 06 00 00 00       	mov    $0x6,%eax
  800e4f:	e8 61 ff ff ff       	call   800db5 <fsipc>
}
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <devfile_stat>:
{
  800e56:	f3 0f 1e fb          	endbr32 
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	53                   	push   %ebx
  800e5e:	83 ec 04             	sub    $0x4,%esp
  800e61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8b 40 0c             	mov    0xc(%eax),%eax
  800e6a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800e6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e74:	b8 05 00 00 00       	mov    $0x5,%eax
  800e79:	e8 37 ff ff ff       	call   800db5 <fsipc>
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	78 2c                	js     800eae <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	68 00 50 80 00       	push   $0x805000
  800e8a:	53                   	push   %ebx
  800e8b:	e8 03 f3 ff ff       	call   800193 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800e90:	a1 80 50 80 00       	mov    0x805080,%eax
  800e95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e9b:	a1 84 50 80 00       	mov    0x805084,%eax
  800ea0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800ea6:	83 c4 10             	add    $0x10,%esp
  800ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eb1:	c9                   	leave  
  800eb2:	c3                   	ret    

00800eb3 <devfile_write>:
{
  800eb3:	f3 0f 1e fb          	endbr32 
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec3:	8b 52 0c             	mov    0xc(%edx),%edx
  800ec6:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800ecc:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800ed1:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800ed6:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800ed9:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800ede:	50                   	push   %eax
  800edf:	ff 75 0c             	pushl  0xc(%ebp)
  800ee2:	68 08 50 80 00       	push   $0x805008
  800ee7:	e8 5d f4 ff ff       	call   800349 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800eec:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ef6:	e8 ba fe ff ff       	call   800db5 <fsipc>
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <devfile_read>:
{
  800efd:	f3 0f 1e fb          	endbr32 
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
  800f06:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8b 40 0c             	mov    0xc(%eax),%eax
  800f0f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800f14:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800f1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f1f:	b8 03 00 00 00       	mov    $0x3,%eax
  800f24:	e8 8c fe ff ff       	call   800db5 <fsipc>
  800f29:	89 c3                	mov    %eax,%ebx
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	78 1f                	js     800f4e <devfile_read+0x51>
	assert(r <= n);
  800f2f:	39 f0                	cmp    %esi,%eax
  800f31:	77 24                	ja     800f57 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800f33:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800f38:	7f 33                	jg     800f6d <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	50                   	push   %eax
  800f3e:	68 00 50 80 00       	push   $0x805000
  800f43:	ff 75 0c             	pushl  0xc(%ebp)
  800f46:	e8 fe f3 ff ff       	call   800349 <memmove>
	return r;
  800f4b:	83 c4 10             	add    $0x10,%esp
}
  800f4e:	89 d8                	mov    %ebx,%eax
  800f50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    
	assert(r <= n);
  800f57:	68 68 20 80 00       	push   $0x802068
  800f5c:	68 6f 20 80 00       	push   $0x80206f
  800f61:	6a 7c                	push   $0x7c
  800f63:	68 84 20 80 00       	push   $0x802084
  800f68:	e8 be 05 00 00       	call   80152b <_panic>
	assert(r <= PGSIZE);
  800f6d:	68 8f 20 80 00       	push   $0x80208f
  800f72:	68 6f 20 80 00       	push   $0x80206f
  800f77:	6a 7d                	push   $0x7d
  800f79:	68 84 20 80 00       	push   $0x802084
  800f7e:	e8 a8 05 00 00       	call   80152b <_panic>

00800f83 <open>:
{
  800f83:	f3 0f 1e fb          	endbr32 
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
  800f8c:	83 ec 1c             	sub    $0x1c,%esp
  800f8f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800f92:	56                   	push   %esi
  800f93:	e8 b8 f1 ff ff       	call   800150 <strlen>
  800f98:	83 c4 10             	add    $0x10,%esp
  800f9b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800fa0:	7f 6c                	jg     80100e <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800fa2:	83 ec 0c             	sub    $0xc,%esp
  800fa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fa8:	50                   	push   %eax
  800fa9:	e8 67 f8 ff ff       	call   800815 <fd_alloc>
  800fae:	89 c3                	mov    %eax,%ebx
  800fb0:	83 c4 10             	add    $0x10,%esp
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	78 3c                	js     800ff3 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800fb7:	83 ec 08             	sub    $0x8,%esp
  800fba:	56                   	push   %esi
  800fbb:	68 00 50 80 00       	push   $0x805000
  800fc0:	e8 ce f1 ff ff       	call   800193 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd0:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd5:	e8 db fd ff ff       	call   800db5 <fsipc>
  800fda:	89 c3                	mov    %eax,%ebx
  800fdc:	83 c4 10             	add    $0x10,%esp
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	78 19                	js     800ffc <open+0x79>
	return fd2num(fd);
  800fe3:	83 ec 0c             	sub    $0xc,%esp
  800fe6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe9:	e8 f8 f7 ff ff       	call   8007e6 <fd2num>
  800fee:	89 c3                	mov    %eax,%ebx
  800ff0:	83 c4 10             	add    $0x10,%esp
}
  800ff3:	89 d8                	mov    %ebx,%eax
  800ff5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    
		fd_close(fd, 0);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	6a 00                	push   $0x0
  801001:	ff 75 f4             	pushl  -0xc(%ebp)
  801004:	e8 10 f9 ff ff       	call   800919 <fd_close>
		return r;
  801009:	83 c4 10             	add    $0x10,%esp
  80100c:	eb e5                	jmp    800ff3 <open+0x70>
		return -E_BAD_PATH;
  80100e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801013:	eb de                	jmp    800ff3 <open+0x70>

00801015 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801015:	f3 0f 1e fb          	endbr32 
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80101f:	ba 00 00 00 00       	mov    $0x0,%edx
  801024:	b8 08 00 00 00       	mov    $0x8,%eax
  801029:	e8 87 fd ff ff       	call   800db5 <fsipc>
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801030:	f3 0f 1e fb          	endbr32 
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
  801039:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80103c:	83 ec 0c             	sub    $0xc,%esp
  80103f:	ff 75 08             	pushl  0x8(%ebp)
  801042:	e8 b3 f7 ff ff       	call   8007fa <fd2data>
  801047:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801049:	83 c4 08             	add    $0x8,%esp
  80104c:	68 9b 20 80 00       	push   $0x80209b
  801051:	53                   	push   %ebx
  801052:	e8 3c f1 ff ff       	call   800193 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801057:	8b 46 04             	mov    0x4(%esi),%eax
  80105a:	2b 06                	sub    (%esi),%eax
  80105c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801062:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801069:	00 00 00 
	stat->st_dev = &devpipe;
  80106c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801073:	30 80 00 
	return 0;
}
  801076:	b8 00 00 00 00       	mov    $0x0,%eax
  80107b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    

00801082 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801082:	f3 0f 1e fb          	endbr32 
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	53                   	push   %ebx
  80108a:	83 ec 0c             	sub    $0xc,%esp
  80108d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801090:	53                   	push   %ebx
  801091:	6a 00                	push   $0x0
  801093:	e8 ca f5 ff ff       	call   800662 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801098:	89 1c 24             	mov    %ebx,(%esp)
  80109b:	e8 5a f7 ff ff       	call   8007fa <fd2data>
  8010a0:	83 c4 08             	add    $0x8,%esp
  8010a3:	50                   	push   %eax
  8010a4:	6a 00                	push   $0x0
  8010a6:	e8 b7 f5 ff ff       	call   800662 <sys_page_unmap>
}
  8010ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <_pipeisclosed>:
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	57                   	push   %edi
  8010b4:	56                   	push   %esi
  8010b5:	53                   	push   %ebx
  8010b6:	83 ec 1c             	sub    $0x1c,%esp
  8010b9:	89 c7                	mov    %eax,%edi
  8010bb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8010bd:	a1 04 40 80 00       	mov    0x804004,%eax
  8010c2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	57                   	push   %edi
  8010c9:	e8 25 0c 00 00       	call   801cf3 <pageref>
  8010ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010d1:	89 34 24             	mov    %esi,(%esp)
  8010d4:	e8 1a 0c 00 00       	call   801cf3 <pageref>
		nn = thisenv->env_runs;
  8010d9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8010df:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	39 cb                	cmp    %ecx,%ebx
  8010e7:	74 1b                	je     801104 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8010e9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8010ec:	75 cf                	jne    8010bd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8010ee:	8b 42 58             	mov    0x58(%edx),%eax
  8010f1:	6a 01                	push   $0x1
  8010f3:	50                   	push   %eax
  8010f4:	53                   	push   %ebx
  8010f5:	68 a2 20 80 00       	push   $0x8020a2
  8010fa:	e8 13 05 00 00       	call   801612 <cprintf>
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	eb b9                	jmp    8010bd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801104:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801107:	0f 94 c0             	sete   %al
  80110a:	0f b6 c0             	movzbl %al,%eax
}
  80110d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801110:	5b                   	pop    %ebx
  801111:	5e                   	pop    %esi
  801112:	5f                   	pop    %edi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <devpipe_write>:
{
  801115:	f3 0f 1e fb          	endbr32 
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	57                   	push   %edi
  80111d:	56                   	push   %esi
  80111e:	53                   	push   %ebx
  80111f:	83 ec 28             	sub    $0x28,%esp
  801122:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801125:	56                   	push   %esi
  801126:	e8 cf f6 ff ff       	call   8007fa <fd2data>
  80112b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	bf 00 00 00 00       	mov    $0x0,%edi
  801135:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801138:	74 4f                	je     801189 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80113a:	8b 43 04             	mov    0x4(%ebx),%eax
  80113d:	8b 0b                	mov    (%ebx),%ecx
  80113f:	8d 51 20             	lea    0x20(%ecx),%edx
  801142:	39 d0                	cmp    %edx,%eax
  801144:	72 14                	jb     80115a <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801146:	89 da                	mov    %ebx,%edx
  801148:	89 f0                	mov    %esi,%eax
  80114a:	e8 61 ff ff ff       	call   8010b0 <_pipeisclosed>
  80114f:	85 c0                	test   %eax,%eax
  801151:	75 3b                	jne    80118e <devpipe_write+0x79>
			sys_yield();
  801153:	e8 5a f4 ff ff       	call   8005b2 <sys_yield>
  801158:	eb e0                	jmp    80113a <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80115a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801161:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801164:	89 c2                	mov    %eax,%edx
  801166:	c1 fa 1f             	sar    $0x1f,%edx
  801169:	89 d1                	mov    %edx,%ecx
  80116b:	c1 e9 1b             	shr    $0x1b,%ecx
  80116e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801171:	83 e2 1f             	and    $0x1f,%edx
  801174:	29 ca                	sub    %ecx,%edx
  801176:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80117a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80117e:	83 c0 01             	add    $0x1,%eax
  801181:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801184:	83 c7 01             	add    $0x1,%edi
  801187:	eb ac                	jmp    801135 <devpipe_write+0x20>
	return i;
  801189:	8b 45 10             	mov    0x10(%ebp),%eax
  80118c:	eb 05                	jmp    801193 <devpipe_write+0x7e>
				return 0;
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801193:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801196:	5b                   	pop    %ebx
  801197:	5e                   	pop    %esi
  801198:	5f                   	pop    %edi
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    

0080119b <devpipe_read>:
{
  80119b:	f3 0f 1e fb          	endbr32 
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	57                   	push   %edi
  8011a3:	56                   	push   %esi
  8011a4:	53                   	push   %ebx
  8011a5:	83 ec 18             	sub    $0x18,%esp
  8011a8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8011ab:	57                   	push   %edi
  8011ac:	e8 49 f6 ff ff       	call   8007fa <fd2data>
  8011b1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	be 00 00 00 00       	mov    $0x0,%esi
  8011bb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8011be:	75 14                	jne    8011d4 <devpipe_read+0x39>
	return i;
  8011c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c3:	eb 02                	jmp    8011c7 <devpipe_read+0x2c>
				return i;
  8011c5:	89 f0                	mov    %esi,%eax
}
  8011c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ca:	5b                   	pop    %ebx
  8011cb:	5e                   	pop    %esi
  8011cc:	5f                   	pop    %edi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    
			sys_yield();
  8011cf:	e8 de f3 ff ff       	call   8005b2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8011d4:	8b 03                	mov    (%ebx),%eax
  8011d6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8011d9:	75 18                	jne    8011f3 <devpipe_read+0x58>
			if (i > 0)
  8011db:	85 f6                	test   %esi,%esi
  8011dd:	75 e6                	jne    8011c5 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8011df:	89 da                	mov    %ebx,%edx
  8011e1:	89 f8                	mov    %edi,%eax
  8011e3:	e8 c8 fe ff ff       	call   8010b0 <_pipeisclosed>
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	74 e3                	je     8011cf <devpipe_read+0x34>
				return 0;
  8011ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f1:	eb d4                	jmp    8011c7 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8011f3:	99                   	cltd   
  8011f4:	c1 ea 1b             	shr    $0x1b,%edx
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	83 e0 1f             	and    $0x1f,%eax
  8011fc:	29 d0                	sub    %edx,%eax
  8011fe:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801203:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801206:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801209:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80120c:	83 c6 01             	add    $0x1,%esi
  80120f:	eb aa                	jmp    8011bb <devpipe_read+0x20>

00801211 <pipe>:
{
  801211:	f3 0f 1e fb          	endbr32 
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	56                   	push   %esi
  801219:	53                   	push   %ebx
  80121a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80121d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801220:	50                   	push   %eax
  801221:	e8 ef f5 ff ff       	call   800815 <fd_alloc>
  801226:	89 c3                	mov    %eax,%ebx
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	85 c0                	test   %eax,%eax
  80122d:	0f 88 23 01 00 00    	js     801356 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801233:	83 ec 04             	sub    $0x4,%esp
  801236:	68 07 04 00 00       	push   $0x407
  80123b:	ff 75 f4             	pushl  -0xc(%ebp)
  80123e:	6a 00                	push   $0x0
  801240:	e8 90 f3 ff ff       	call   8005d5 <sys_page_alloc>
  801245:	89 c3                	mov    %eax,%ebx
  801247:	83 c4 10             	add    $0x10,%esp
  80124a:	85 c0                	test   %eax,%eax
  80124c:	0f 88 04 01 00 00    	js     801356 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801252:	83 ec 0c             	sub    $0xc,%esp
  801255:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801258:	50                   	push   %eax
  801259:	e8 b7 f5 ff ff       	call   800815 <fd_alloc>
  80125e:	89 c3                	mov    %eax,%ebx
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	0f 88 db 00 00 00    	js     801346 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	68 07 04 00 00       	push   $0x407
  801273:	ff 75 f0             	pushl  -0x10(%ebp)
  801276:	6a 00                	push   $0x0
  801278:	e8 58 f3 ff ff       	call   8005d5 <sys_page_alloc>
  80127d:	89 c3                	mov    %eax,%ebx
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	0f 88 bc 00 00 00    	js     801346 <pipe+0x135>
	va = fd2data(fd0);
  80128a:	83 ec 0c             	sub    $0xc,%esp
  80128d:	ff 75 f4             	pushl  -0xc(%ebp)
  801290:	e8 65 f5 ff ff       	call   8007fa <fd2data>
  801295:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801297:	83 c4 0c             	add    $0xc,%esp
  80129a:	68 07 04 00 00       	push   $0x407
  80129f:	50                   	push   %eax
  8012a0:	6a 00                	push   $0x0
  8012a2:	e8 2e f3 ff ff       	call   8005d5 <sys_page_alloc>
  8012a7:	89 c3                	mov    %eax,%ebx
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	0f 88 82 00 00 00    	js     801336 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8012ba:	e8 3b f5 ff ff       	call   8007fa <fd2data>
  8012bf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8012c6:	50                   	push   %eax
  8012c7:	6a 00                	push   $0x0
  8012c9:	56                   	push   %esi
  8012ca:	6a 00                	push   $0x0
  8012cc:	e8 4b f3 ff ff       	call   80061c <sys_page_map>
  8012d1:	89 c3                	mov    %eax,%ebx
  8012d3:	83 c4 20             	add    $0x20,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 4e                	js     801328 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8012da:	a1 20 30 80 00       	mov    0x803020,%eax
  8012df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8012e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8012ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8012f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8012fd:	83 ec 0c             	sub    $0xc,%esp
  801300:	ff 75 f4             	pushl  -0xc(%ebp)
  801303:	e8 de f4 ff ff       	call   8007e6 <fd2num>
  801308:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80130d:	83 c4 04             	add    $0x4,%esp
  801310:	ff 75 f0             	pushl  -0x10(%ebp)
  801313:	e8 ce f4 ff ff       	call   8007e6 <fd2num>
  801318:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	bb 00 00 00 00       	mov    $0x0,%ebx
  801326:	eb 2e                	jmp    801356 <pipe+0x145>
	sys_page_unmap(0, va);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	56                   	push   %esi
  80132c:	6a 00                	push   $0x0
  80132e:	e8 2f f3 ff ff       	call   800662 <sys_page_unmap>
  801333:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801336:	83 ec 08             	sub    $0x8,%esp
  801339:	ff 75 f0             	pushl  -0x10(%ebp)
  80133c:	6a 00                	push   $0x0
  80133e:	e8 1f f3 ff ff       	call   800662 <sys_page_unmap>
  801343:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 f4             	pushl  -0xc(%ebp)
  80134c:	6a 00                	push   $0x0
  80134e:	e8 0f f3 ff ff       	call   800662 <sys_page_unmap>
  801353:	83 c4 10             	add    $0x10,%esp
}
  801356:	89 d8                	mov    %ebx,%eax
  801358:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80135b:	5b                   	pop    %ebx
  80135c:	5e                   	pop    %esi
  80135d:	5d                   	pop    %ebp
  80135e:	c3                   	ret    

0080135f <pipeisclosed>:
{
  80135f:	f3 0f 1e fb          	endbr32 
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	ff 75 08             	pushl  0x8(%ebp)
  801370:	e8 f6 f4 ff ff       	call   80086b <fd_lookup>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 18                	js     801394 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80137c:	83 ec 0c             	sub    $0xc,%esp
  80137f:	ff 75 f4             	pushl  -0xc(%ebp)
  801382:	e8 73 f4 ff ff       	call   8007fa <fd2data>
  801387:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138c:	e8 1f fd ff ff       	call   8010b0 <_pipeisclosed>
  801391:	83 c4 10             	add    $0x10,%esp
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801396:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80139a:	b8 00 00 00 00       	mov    $0x0,%eax
  80139f:	c3                   	ret    

008013a0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8013a0:	f3 0f 1e fb          	endbr32 
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8013aa:	68 ba 20 80 00       	push   $0x8020ba
  8013af:	ff 75 0c             	pushl  0xc(%ebp)
  8013b2:	e8 dc ed ff ff       	call   800193 <strcpy>
	return 0;
}
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <devcons_write>:
{
  8013be:	f3 0f 1e fb          	endbr32 
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	57                   	push   %edi
  8013c6:	56                   	push   %esi
  8013c7:	53                   	push   %ebx
  8013c8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8013ce:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8013d3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8013d9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013dc:	73 31                	jae    80140f <devcons_write+0x51>
		m = n - tot;
  8013de:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013e1:	29 f3                	sub    %esi,%ebx
  8013e3:	83 fb 7f             	cmp    $0x7f,%ebx
  8013e6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013eb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	53                   	push   %ebx
  8013f2:	89 f0                	mov    %esi,%eax
  8013f4:	03 45 0c             	add    0xc(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	57                   	push   %edi
  8013f9:	e8 4b ef ff ff       	call   800349 <memmove>
		sys_cputs(buf, m);
  8013fe:	83 c4 08             	add    $0x8,%esp
  801401:	53                   	push   %ebx
  801402:	57                   	push   %edi
  801403:	e8 fd f0 ff ff       	call   800505 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801408:	01 de                	add    %ebx,%esi
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	eb ca                	jmp    8013d9 <devcons_write+0x1b>
}
  80140f:	89 f0                	mov    %esi,%eax
  801411:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5f                   	pop    %edi
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <devcons_read>:
{
  801419:	f3 0f 1e fb          	endbr32 
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 08             	sub    $0x8,%esp
  801423:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801428:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142c:	74 21                	je     80144f <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80142e:	e8 f4 f0 ff ff       	call   800527 <sys_cgetc>
  801433:	85 c0                	test   %eax,%eax
  801435:	75 07                	jne    80143e <devcons_read+0x25>
		sys_yield();
  801437:	e8 76 f1 ff ff       	call   8005b2 <sys_yield>
  80143c:	eb f0                	jmp    80142e <devcons_read+0x15>
	if (c < 0)
  80143e:	78 0f                	js     80144f <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801440:	83 f8 04             	cmp    $0x4,%eax
  801443:	74 0c                	je     801451 <devcons_read+0x38>
	*(char*)vbuf = c;
  801445:	8b 55 0c             	mov    0xc(%ebp),%edx
  801448:	88 02                	mov    %al,(%edx)
	return 1;
  80144a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    
		return 0;
  801451:	b8 00 00 00 00       	mov    $0x0,%eax
  801456:	eb f7                	jmp    80144f <devcons_read+0x36>

00801458 <cputchar>:
{
  801458:	f3 0f 1e fb          	endbr32 
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801468:	6a 01                	push   $0x1
  80146a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80146d:	50                   	push   %eax
  80146e:	e8 92 f0 ff ff       	call   800505 <sys_cputs>
}
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <getchar>:
{
  801478:	f3 0f 1e fb          	endbr32 
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801482:	6a 01                	push   $0x1
  801484:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801487:	50                   	push   %eax
  801488:	6a 00                	push   $0x0
  80148a:	e8 5f f6 ff ff       	call   800aee <read>
	if (r < 0)
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	85 c0                	test   %eax,%eax
  801494:	78 06                	js     80149c <getchar+0x24>
	if (r < 1)
  801496:	74 06                	je     80149e <getchar+0x26>
	return c;
  801498:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    
		return -E_EOF;
  80149e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8014a3:	eb f7                	jmp    80149c <getchar+0x24>

008014a5 <iscons>:
{
  8014a5:	f3 0f 1e fb          	endbr32 
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b2:	50                   	push   %eax
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 b0 f3 ff ff       	call   80086b <fd_lookup>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 11                	js     8014d3 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8014c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8014cb:	39 10                	cmp    %edx,(%eax)
  8014cd:	0f 94 c0             	sete   %al
  8014d0:	0f b6 c0             	movzbl %al,%eax
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <opencons>:
{
  8014d5:	f3 0f 1e fb          	endbr32 
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8014df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e2:	50                   	push   %eax
  8014e3:	e8 2d f3 ff ff       	call   800815 <fd_alloc>
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 3a                	js     801529 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	68 07 04 00 00       	push   $0x407
  8014f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8014fa:	6a 00                	push   $0x0
  8014fc:	e8 d4 f0 ff ff       	call   8005d5 <sys_page_alloc>
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 21                	js     801529 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801511:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801516:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80151d:	83 ec 0c             	sub    $0xc,%esp
  801520:	50                   	push   %eax
  801521:	e8 c0 f2 ff ff       	call   8007e6 <fd2num>
  801526:	83 c4 10             	add    $0x10,%esp
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80152b:	f3 0f 1e fb          	endbr32 
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	56                   	push   %esi
  801533:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801534:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801537:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80153d:	e8 4d f0 ff ff       	call   80058f <sys_getenvid>
  801542:	83 ec 0c             	sub    $0xc,%esp
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	ff 75 08             	pushl  0x8(%ebp)
  80154b:	56                   	push   %esi
  80154c:	50                   	push   %eax
  80154d:	68 c8 20 80 00       	push   $0x8020c8
  801552:	e8 bb 00 00 00       	call   801612 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801557:	83 c4 18             	add    $0x18,%esp
  80155a:	53                   	push   %ebx
  80155b:	ff 75 10             	pushl  0x10(%ebp)
  80155e:	e8 5a 00 00 00       	call   8015bd <vcprintf>
	cprintf("\n");
  801563:	c7 04 24 f8 23 80 00 	movl   $0x8023f8,(%esp)
  80156a:	e8 a3 00 00 00       	call   801612 <cprintf>
  80156f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801572:	cc                   	int3   
  801573:	eb fd                	jmp    801572 <_panic+0x47>

00801575 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801575:	f3 0f 1e fb          	endbr32 
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	53                   	push   %ebx
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801583:	8b 13                	mov    (%ebx),%edx
  801585:	8d 42 01             	lea    0x1(%edx),%eax
  801588:	89 03                	mov    %eax,(%ebx)
  80158a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801591:	3d ff 00 00 00       	cmp    $0xff,%eax
  801596:	74 09                	je     8015a1 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801598:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80159c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	68 ff 00 00 00       	push   $0xff
  8015a9:	8d 43 08             	lea    0x8(%ebx),%eax
  8015ac:	50                   	push   %eax
  8015ad:	e8 53 ef ff ff       	call   800505 <sys_cputs>
		b->idx = 0;
  8015b2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	eb db                	jmp    801598 <putch+0x23>

008015bd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8015bd:	f3 0f 1e fb          	endbr32 
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8015ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8015d1:	00 00 00 
	b.cnt = 0;
  8015d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8015db:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	ff 75 08             	pushl  0x8(%ebp)
  8015e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	68 75 15 80 00       	push   $0x801575
  8015f0:	e8 20 01 00 00       	call   801715 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8015f5:	83 c4 08             	add    $0x8,%esp
  8015f8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015fe:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801604:	50                   	push   %eax
  801605:	e8 fb ee ff ff       	call   800505 <sys_cputs>

	return b.cnt;
}
  80160a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801612:	f3 0f 1e fb          	endbr32 
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80161c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80161f:	50                   	push   %eax
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	e8 95 ff ff ff       	call   8015bd <vcprintf>
	va_end(ap);

	return cnt;
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	57                   	push   %edi
  80162e:	56                   	push   %esi
  80162f:	53                   	push   %ebx
  801630:	83 ec 1c             	sub    $0x1c,%esp
  801633:	89 c7                	mov    %eax,%edi
  801635:	89 d6                	mov    %edx,%esi
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163d:	89 d1                	mov    %edx,%ecx
  80163f:	89 c2                	mov    %eax,%edx
  801641:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801644:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801647:	8b 45 10             	mov    0x10(%ebp),%eax
  80164a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80164d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801650:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801657:	39 c2                	cmp    %eax,%edx
  801659:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80165c:	72 3e                	jb     80169c <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	ff 75 18             	pushl  0x18(%ebp)
  801664:	83 eb 01             	sub    $0x1,%ebx
  801667:	53                   	push   %ebx
  801668:	50                   	push   %eax
  801669:	83 ec 08             	sub    $0x8,%esp
  80166c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80166f:	ff 75 e0             	pushl  -0x20(%ebp)
  801672:	ff 75 dc             	pushl  -0x24(%ebp)
  801675:	ff 75 d8             	pushl  -0x28(%ebp)
  801678:	e8 c3 06 00 00       	call   801d40 <__udivdi3>
  80167d:	83 c4 18             	add    $0x18,%esp
  801680:	52                   	push   %edx
  801681:	50                   	push   %eax
  801682:	89 f2                	mov    %esi,%edx
  801684:	89 f8                	mov    %edi,%eax
  801686:	e8 9f ff ff ff       	call   80162a <printnum>
  80168b:	83 c4 20             	add    $0x20,%esp
  80168e:	eb 13                	jmp    8016a3 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801690:	83 ec 08             	sub    $0x8,%esp
  801693:	56                   	push   %esi
  801694:	ff 75 18             	pushl  0x18(%ebp)
  801697:	ff d7                	call   *%edi
  801699:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80169c:	83 eb 01             	sub    $0x1,%ebx
  80169f:	85 db                	test   %ebx,%ebx
  8016a1:	7f ed                	jg     801690 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016a3:	83 ec 08             	sub    $0x8,%esp
  8016a6:	56                   	push   %esi
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8016b0:	ff 75 dc             	pushl  -0x24(%ebp)
  8016b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8016b6:	e8 95 07 00 00       	call   801e50 <__umoddi3>
  8016bb:	83 c4 14             	add    $0x14,%esp
  8016be:	0f be 80 eb 20 80 00 	movsbl 0x8020eb(%eax),%eax
  8016c5:	50                   	push   %eax
  8016c6:	ff d7                	call   *%edi
}
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ce:	5b                   	pop    %ebx
  8016cf:	5e                   	pop    %esi
  8016d0:	5f                   	pop    %edi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    

008016d3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016d3:	f3 0f 1e fb          	endbr32 
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8016dd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8016e1:	8b 10                	mov    (%eax),%edx
  8016e3:	3b 50 04             	cmp    0x4(%eax),%edx
  8016e6:	73 0a                	jae    8016f2 <sprintputch+0x1f>
		*b->buf++ = ch;
  8016e8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016eb:	89 08                	mov    %ecx,(%eax)
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	88 02                	mov    %al,(%edx)
}
  8016f2:	5d                   	pop    %ebp
  8016f3:	c3                   	ret    

008016f4 <printfmt>:
{
  8016f4:	f3 0f 1e fb          	endbr32 
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8016fe:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801701:	50                   	push   %eax
  801702:	ff 75 10             	pushl  0x10(%ebp)
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	ff 75 08             	pushl  0x8(%ebp)
  80170b:	e8 05 00 00 00       	call   801715 <vprintfmt>
}
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <vprintfmt>:
{
  801715:	f3 0f 1e fb          	endbr32 
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	57                   	push   %edi
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	83 ec 3c             	sub    $0x3c,%esp
  801722:	8b 75 08             	mov    0x8(%ebp),%esi
  801725:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801728:	8b 7d 10             	mov    0x10(%ebp),%edi
  80172b:	e9 8e 03 00 00       	jmp    801abe <vprintfmt+0x3a9>
		padc = ' ';
  801730:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801734:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80173b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801742:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801749:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80174e:	8d 47 01             	lea    0x1(%edi),%eax
  801751:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801754:	0f b6 17             	movzbl (%edi),%edx
  801757:	8d 42 dd             	lea    -0x23(%edx),%eax
  80175a:	3c 55                	cmp    $0x55,%al
  80175c:	0f 87 df 03 00 00    	ja     801b41 <vprintfmt+0x42c>
  801762:	0f b6 c0             	movzbl %al,%eax
  801765:	3e ff 24 85 20 22 80 	notrack jmp *0x802220(,%eax,4)
  80176c:	00 
  80176d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801770:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801774:	eb d8                	jmp    80174e <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801776:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801779:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80177d:	eb cf                	jmp    80174e <vprintfmt+0x39>
  80177f:	0f b6 d2             	movzbl %dl,%edx
  801782:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801785:	b8 00 00 00 00       	mov    $0x0,%eax
  80178a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80178d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801790:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801794:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801797:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80179a:	83 f9 09             	cmp    $0x9,%ecx
  80179d:	77 55                	ja     8017f4 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80179f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8017a2:	eb e9                	jmp    80178d <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8017a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a7:	8b 00                	mov    (%eax),%eax
  8017a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8017af:	8d 40 04             	lea    0x4(%eax),%eax
  8017b2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8017b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8017b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017bc:	79 90                	jns    80174e <vprintfmt+0x39>
				width = precision, precision = -1;
  8017be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017c4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8017cb:	eb 81                	jmp    80174e <vprintfmt+0x39>
  8017cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d7:	0f 49 d0             	cmovns %eax,%edx
  8017da:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8017dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017e0:	e9 69 ff ff ff       	jmp    80174e <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8017e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8017e8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8017ef:	e9 5a ff ff ff       	jmp    80174e <vprintfmt+0x39>
  8017f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017fa:	eb bc                	jmp    8017b8 <vprintfmt+0xa3>
			lflag++;
  8017fc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801802:	e9 47 ff ff ff       	jmp    80174e <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801807:	8b 45 14             	mov    0x14(%ebp),%eax
  80180a:	8d 78 04             	lea    0x4(%eax),%edi
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	53                   	push   %ebx
  801811:	ff 30                	pushl  (%eax)
  801813:	ff d6                	call   *%esi
			break;
  801815:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801818:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80181b:	e9 9b 02 00 00       	jmp    801abb <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801820:	8b 45 14             	mov    0x14(%ebp),%eax
  801823:	8d 78 04             	lea    0x4(%eax),%edi
  801826:	8b 00                	mov    (%eax),%eax
  801828:	99                   	cltd   
  801829:	31 d0                	xor    %edx,%eax
  80182b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80182d:	83 f8 0f             	cmp    $0xf,%eax
  801830:	7f 23                	jg     801855 <vprintfmt+0x140>
  801832:	8b 14 85 80 23 80 00 	mov    0x802380(,%eax,4),%edx
  801839:	85 d2                	test   %edx,%edx
  80183b:	74 18                	je     801855 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80183d:	52                   	push   %edx
  80183e:	68 81 20 80 00       	push   $0x802081
  801843:	53                   	push   %ebx
  801844:	56                   	push   %esi
  801845:	e8 aa fe ff ff       	call   8016f4 <printfmt>
  80184a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80184d:	89 7d 14             	mov    %edi,0x14(%ebp)
  801850:	e9 66 02 00 00       	jmp    801abb <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801855:	50                   	push   %eax
  801856:	68 03 21 80 00       	push   $0x802103
  80185b:	53                   	push   %ebx
  80185c:	56                   	push   %esi
  80185d:	e8 92 fe ff ff       	call   8016f4 <printfmt>
  801862:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801865:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801868:	e9 4e 02 00 00       	jmp    801abb <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80186d:	8b 45 14             	mov    0x14(%ebp),%eax
  801870:	83 c0 04             	add    $0x4,%eax
  801873:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801876:	8b 45 14             	mov    0x14(%ebp),%eax
  801879:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80187b:	85 d2                	test   %edx,%edx
  80187d:	b8 fc 20 80 00       	mov    $0x8020fc,%eax
  801882:	0f 45 c2             	cmovne %edx,%eax
  801885:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801888:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80188c:	7e 06                	jle    801894 <vprintfmt+0x17f>
  80188e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801892:	75 0d                	jne    8018a1 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801894:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801897:	89 c7                	mov    %eax,%edi
  801899:	03 45 e0             	add    -0x20(%ebp),%eax
  80189c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80189f:	eb 55                	jmp    8018f6 <vprintfmt+0x1e1>
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8018a7:	ff 75 cc             	pushl  -0x34(%ebp)
  8018aa:	e8 bd e8 ff ff       	call   80016c <strnlen>
  8018af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b2:	29 c2                	sub    %eax,%edx
  8018b4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8018bc:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8018c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8018c3:	85 ff                	test   %edi,%edi
  8018c5:	7e 11                	jle    8018d8 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8018c7:	83 ec 08             	sub    $0x8,%esp
  8018ca:	53                   	push   %ebx
  8018cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8018ce:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8018d0:	83 ef 01             	sub    $0x1,%edi
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	eb eb                	jmp    8018c3 <vprintfmt+0x1ae>
  8018d8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018db:	85 d2                	test   %edx,%edx
  8018dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e2:	0f 49 c2             	cmovns %edx,%eax
  8018e5:	29 c2                	sub    %eax,%edx
  8018e7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018ea:	eb a8                	jmp    801894 <vprintfmt+0x17f>
					putch(ch, putdat);
  8018ec:	83 ec 08             	sub    $0x8,%esp
  8018ef:	53                   	push   %ebx
  8018f0:	52                   	push   %edx
  8018f1:	ff d6                	call   *%esi
  8018f3:	83 c4 10             	add    $0x10,%esp
  8018f6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8018f9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018fb:	83 c7 01             	add    $0x1,%edi
  8018fe:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801902:	0f be d0             	movsbl %al,%edx
  801905:	85 d2                	test   %edx,%edx
  801907:	74 4b                	je     801954 <vprintfmt+0x23f>
  801909:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80190d:	78 06                	js     801915 <vprintfmt+0x200>
  80190f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801913:	78 1e                	js     801933 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801915:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801919:	74 d1                	je     8018ec <vprintfmt+0x1d7>
  80191b:	0f be c0             	movsbl %al,%eax
  80191e:	83 e8 20             	sub    $0x20,%eax
  801921:	83 f8 5e             	cmp    $0x5e,%eax
  801924:	76 c6                	jbe    8018ec <vprintfmt+0x1d7>
					putch('?', putdat);
  801926:	83 ec 08             	sub    $0x8,%esp
  801929:	53                   	push   %ebx
  80192a:	6a 3f                	push   $0x3f
  80192c:	ff d6                	call   *%esi
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	eb c3                	jmp    8018f6 <vprintfmt+0x1e1>
  801933:	89 cf                	mov    %ecx,%edi
  801935:	eb 0e                	jmp    801945 <vprintfmt+0x230>
				putch(' ', putdat);
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	53                   	push   %ebx
  80193b:	6a 20                	push   $0x20
  80193d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80193f:	83 ef 01             	sub    $0x1,%edi
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 ff                	test   %edi,%edi
  801947:	7f ee                	jg     801937 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801949:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80194c:	89 45 14             	mov    %eax,0x14(%ebp)
  80194f:	e9 67 01 00 00       	jmp    801abb <vprintfmt+0x3a6>
  801954:	89 cf                	mov    %ecx,%edi
  801956:	eb ed                	jmp    801945 <vprintfmt+0x230>
	if (lflag >= 2)
  801958:	83 f9 01             	cmp    $0x1,%ecx
  80195b:	7f 1b                	jg     801978 <vprintfmt+0x263>
	else if (lflag)
  80195d:	85 c9                	test   %ecx,%ecx
  80195f:	74 63                	je     8019c4 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801961:	8b 45 14             	mov    0x14(%ebp),%eax
  801964:	8b 00                	mov    (%eax),%eax
  801966:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801969:	99                   	cltd   
  80196a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8d 40 04             	lea    0x4(%eax),%eax
  801973:	89 45 14             	mov    %eax,0x14(%ebp)
  801976:	eb 17                	jmp    80198f <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801978:	8b 45 14             	mov    0x14(%ebp),%eax
  80197b:	8b 50 04             	mov    0x4(%eax),%edx
  80197e:	8b 00                	mov    (%eax),%eax
  801980:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801983:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801986:	8b 45 14             	mov    0x14(%ebp),%eax
  801989:	8d 40 08             	lea    0x8(%eax),%eax
  80198c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80198f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801992:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801995:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80199a:	85 c9                	test   %ecx,%ecx
  80199c:	0f 89 ff 00 00 00    	jns    801aa1 <vprintfmt+0x38c>
				putch('-', putdat);
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	53                   	push   %ebx
  8019a6:	6a 2d                	push   $0x2d
  8019a8:	ff d6                	call   *%esi
				num = -(long long) num;
  8019aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8019b0:	f7 da                	neg    %edx
  8019b2:	83 d1 00             	adc    $0x0,%ecx
  8019b5:	f7 d9                	neg    %ecx
  8019b7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8019ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019bf:	e9 dd 00 00 00       	jmp    801aa1 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8019c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c7:	8b 00                	mov    (%eax),%eax
  8019c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019cc:	99                   	cltd   
  8019cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d3:	8d 40 04             	lea    0x4(%eax),%eax
  8019d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8019d9:	eb b4                	jmp    80198f <vprintfmt+0x27a>
	if (lflag >= 2)
  8019db:	83 f9 01             	cmp    $0x1,%ecx
  8019de:	7f 1e                	jg     8019fe <vprintfmt+0x2e9>
	else if (lflag)
  8019e0:	85 c9                	test   %ecx,%ecx
  8019e2:	74 32                	je     801a16 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8019e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e7:	8b 10                	mov    (%eax),%edx
  8019e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ee:	8d 40 04             	lea    0x4(%eax),%eax
  8019f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019f4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8019f9:	e9 a3 00 00 00       	jmp    801aa1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8019fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801a01:	8b 10                	mov    (%eax),%edx
  801a03:	8b 48 04             	mov    0x4(%eax),%ecx
  801a06:	8d 40 08             	lea    0x8(%eax),%eax
  801a09:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a0c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801a11:	e9 8b 00 00 00       	jmp    801aa1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801a16:	8b 45 14             	mov    0x14(%ebp),%eax
  801a19:	8b 10                	mov    (%eax),%edx
  801a1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a20:	8d 40 04             	lea    0x4(%eax),%eax
  801a23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a26:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801a2b:	eb 74                	jmp    801aa1 <vprintfmt+0x38c>
	if (lflag >= 2)
  801a2d:	83 f9 01             	cmp    $0x1,%ecx
  801a30:	7f 1b                	jg     801a4d <vprintfmt+0x338>
	else if (lflag)
  801a32:	85 c9                	test   %ecx,%ecx
  801a34:	74 2c                	je     801a62 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801a36:	8b 45 14             	mov    0x14(%ebp),%eax
  801a39:	8b 10                	mov    (%eax),%edx
  801a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a40:	8d 40 04             	lea    0x4(%eax),%eax
  801a43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a46:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801a4b:	eb 54                	jmp    801aa1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a50:	8b 10                	mov    (%eax),%edx
  801a52:	8b 48 04             	mov    0x4(%eax),%ecx
  801a55:	8d 40 08             	lea    0x8(%eax),%eax
  801a58:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a5b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801a60:	eb 3f                	jmp    801aa1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801a62:	8b 45 14             	mov    0x14(%ebp),%eax
  801a65:	8b 10                	mov    (%eax),%edx
  801a67:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6c:	8d 40 04             	lea    0x4(%eax),%eax
  801a6f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a72:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801a77:	eb 28                	jmp    801aa1 <vprintfmt+0x38c>
			putch('0', putdat);
  801a79:	83 ec 08             	sub    $0x8,%esp
  801a7c:	53                   	push   %ebx
  801a7d:	6a 30                	push   $0x30
  801a7f:	ff d6                	call   *%esi
			putch('x', putdat);
  801a81:	83 c4 08             	add    $0x8,%esp
  801a84:	53                   	push   %ebx
  801a85:	6a 78                	push   $0x78
  801a87:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a89:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8c:	8b 10                	mov    (%eax),%edx
  801a8e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a93:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a96:	8d 40 04             	lea    0x4(%eax),%eax
  801a99:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a9c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801aa1:	83 ec 0c             	sub    $0xc,%esp
  801aa4:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801aa8:	57                   	push   %edi
  801aa9:	ff 75 e0             	pushl  -0x20(%ebp)
  801aac:	50                   	push   %eax
  801aad:	51                   	push   %ecx
  801aae:	52                   	push   %edx
  801aaf:	89 da                	mov    %ebx,%edx
  801ab1:	89 f0                	mov    %esi,%eax
  801ab3:	e8 72 fb ff ff       	call   80162a <printnum>
			break;
  801ab8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801abb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801abe:	83 c7 01             	add    $0x1,%edi
  801ac1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801ac5:	83 f8 25             	cmp    $0x25,%eax
  801ac8:	0f 84 62 fc ff ff    	je     801730 <vprintfmt+0x1b>
			if (ch == '\0')
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	0f 84 8b 00 00 00    	je     801b61 <vprintfmt+0x44c>
			putch(ch, putdat);
  801ad6:	83 ec 08             	sub    $0x8,%esp
  801ad9:	53                   	push   %ebx
  801ada:	50                   	push   %eax
  801adb:	ff d6                	call   *%esi
  801add:	83 c4 10             	add    $0x10,%esp
  801ae0:	eb dc                	jmp    801abe <vprintfmt+0x3a9>
	if (lflag >= 2)
  801ae2:	83 f9 01             	cmp    $0x1,%ecx
  801ae5:	7f 1b                	jg     801b02 <vprintfmt+0x3ed>
	else if (lflag)
  801ae7:	85 c9                	test   %ecx,%ecx
  801ae9:	74 2c                	je     801b17 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801aeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801aee:	8b 10                	mov    (%eax),%edx
  801af0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af5:	8d 40 04             	lea    0x4(%eax),%eax
  801af8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801afb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801b00:	eb 9f                	jmp    801aa1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b02:	8b 45 14             	mov    0x14(%ebp),%eax
  801b05:	8b 10                	mov    (%eax),%edx
  801b07:	8b 48 04             	mov    0x4(%eax),%ecx
  801b0a:	8d 40 08             	lea    0x8(%eax),%eax
  801b0d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b10:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801b15:	eb 8a                	jmp    801aa1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b17:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1a:	8b 10                	mov    (%eax),%edx
  801b1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b21:	8d 40 04             	lea    0x4(%eax),%eax
  801b24:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b27:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801b2c:	e9 70 ff ff ff       	jmp    801aa1 <vprintfmt+0x38c>
			putch(ch, putdat);
  801b31:	83 ec 08             	sub    $0x8,%esp
  801b34:	53                   	push   %ebx
  801b35:	6a 25                	push   $0x25
  801b37:	ff d6                	call   *%esi
			break;
  801b39:	83 c4 10             	add    $0x10,%esp
  801b3c:	e9 7a ff ff ff       	jmp    801abb <vprintfmt+0x3a6>
			putch('%', putdat);
  801b41:	83 ec 08             	sub    $0x8,%esp
  801b44:	53                   	push   %ebx
  801b45:	6a 25                	push   $0x25
  801b47:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	89 f8                	mov    %edi,%eax
  801b4e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b52:	74 05                	je     801b59 <vprintfmt+0x444>
  801b54:	83 e8 01             	sub    $0x1,%eax
  801b57:	eb f5                	jmp    801b4e <vprintfmt+0x439>
  801b59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b5c:	e9 5a ff ff ff       	jmp    801abb <vprintfmt+0x3a6>
}
  801b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5f                   	pop    %edi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    

00801b69 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b69:	f3 0f 1e fb          	endbr32 
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 18             	sub    $0x18,%esp
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b7c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b80:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b8a:	85 c0                	test   %eax,%eax
  801b8c:	74 26                	je     801bb4 <vsnprintf+0x4b>
  801b8e:	85 d2                	test   %edx,%edx
  801b90:	7e 22                	jle    801bb4 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	68 d3 16 80 00       	push   $0x8016d3
  801ba1:	e8 6f fb ff ff       	call   801715 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baf:	83 c4 10             	add    $0x10,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    
		return -E_INVAL;
  801bb4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bb9:	eb f7                	jmp    801bb2 <vsnprintf+0x49>

00801bbb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bbb:	f3 0f 1e fb          	endbr32 
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bc5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801bc8:	50                   	push   %eax
  801bc9:	ff 75 10             	pushl  0x10(%ebp)
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	e8 92 ff ff ff       	call   801b69 <vsnprintf>
	va_end(ap);

	return rc;
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801bd9:	f3 0f 1e fb          	endbr32 
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	56                   	push   %esi
  801be1:	53                   	push   %ebx
  801be2:	8b 75 08             	mov    0x8(%ebp),%esi
  801be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801beb:	85 c0                	test   %eax,%eax
  801bed:	74 3d                	je     801c2c <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801bef:	83 ec 0c             	sub    $0xc,%esp
  801bf2:	50                   	push   %eax
  801bf3:	e8 a9 eb ff ff       	call   8007a1 <sys_ipc_recv>
  801bf8:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801bfb:	85 f6                	test   %esi,%esi
  801bfd:	74 0b                	je     801c0a <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801bff:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c05:	8b 52 74             	mov    0x74(%edx),%edx
  801c08:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801c0a:	85 db                	test   %ebx,%ebx
  801c0c:	74 0b                	je     801c19 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801c0e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c14:	8b 52 78             	mov    0x78(%edx),%edx
  801c17:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	78 21                	js     801c3e <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801c1d:	a1 04 40 80 00       	mov    0x804004,%eax
  801c22:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c28:	5b                   	pop    %ebx
  801c29:	5e                   	pop    %esi
  801c2a:	5d                   	pop    %ebp
  801c2b:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801c2c:	83 ec 0c             	sub    $0xc,%esp
  801c2f:	68 00 00 c0 ee       	push   $0xeec00000
  801c34:	e8 68 eb ff ff       	call   8007a1 <sys_ipc_recv>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	eb bd                	jmp    801bfb <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801c3e:	85 f6                	test   %esi,%esi
  801c40:	74 10                	je     801c52 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801c42:	85 db                	test   %ebx,%ebx
  801c44:	75 df                	jne    801c25 <ipc_recv+0x4c>
  801c46:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c4d:	00 00 00 
  801c50:	eb d3                	jmp    801c25 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801c52:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c59:	00 00 00 
  801c5c:	eb e4                	jmp    801c42 <ipc_recv+0x69>

00801c5e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c5e:	f3 0f 1e fb          	endbr32 
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	57                   	push   %edi
  801c66:	56                   	push   %esi
  801c67:	53                   	push   %ebx
  801c68:	83 ec 0c             	sub    $0xc,%esp
  801c6b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801c74:	85 db                	test   %ebx,%ebx
  801c76:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c7b:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801c7e:	ff 75 14             	pushl  0x14(%ebp)
  801c81:	53                   	push   %ebx
  801c82:	56                   	push   %esi
  801c83:	57                   	push   %edi
  801c84:	e8 f1 ea ff ff       	call   80077a <sys_ipc_try_send>
  801c89:	83 c4 10             	add    $0x10,%esp
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	79 1e                	jns    801cae <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801c90:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c93:	75 07                	jne    801c9c <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801c95:	e8 18 e9 ff ff       	call   8005b2 <sys_yield>
  801c9a:	eb e2                	jmp    801c7e <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c9c:	50                   	push   %eax
  801c9d:	68 df 23 80 00       	push   $0x8023df
  801ca2:	6a 59                	push   $0x59
  801ca4:	68 fa 23 80 00       	push   $0x8023fa
  801ca9:	e8 7d f8 ff ff       	call   80152b <_panic>
	}
}
  801cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb1:	5b                   	pop    %ebx
  801cb2:	5e                   	pop    %esi
  801cb3:	5f                   	pop    %edi
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    

00801cb6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cb6:	f3 0f 1e fb          	endbr32 
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cc5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801cc8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801cce:	8b 52 50             	mov    0x50(%edx),%edx
  801cd1:	39 ca                	cmp    %ecx,%edx
  801cd3:	74 11                	je     801ce6 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801cd5:	83 c0 01             	add    $0x1,%eax
  801cd8:	3d 00 04 00 00       	cmp    $0x400,%eax
  801cdd:	75 e6                	jne    801cc5 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce4:	eb 0b                	jmp    801cf1 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801ce6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ce9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801cee:	8b 40 48             	mov    0x48(%eax),%eax
}
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cf3:	f3 0f 1e fb          	endbr32 
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cfd:	89 c2                	mov    %eax,%edx
  801cff:	c1 ea 16             	shr    $0x16,%edx
  801d02:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801d09:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801d0e:	f6 c1 01             	test   $0x1,%cl
  801d11:	74 1c                	je     801d2f <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801d13:	c1 e8 0c             	shr    $0xc,%eax
  801d16:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d1d:	a8 01                	test   $0x1,%al
  801d1f:	74 0e                	je     801d2f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d21:	c1 e8 0c             	shr    $0xc,%eax
  801d24:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801d2b:	ef 
  801d2c:	0f b7 d2             	movzwl %dx,%edx
}
  801d2f:	89 d0                	mov    %edx,%eax
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    
  801d33:	66 90                	xchg   %ax,%ax
  801d35:	66 90                	xchg   %ax,%ax
  801d37:	66 90                	xchg   %ax,%ax
  801d39:	66 90                	xchg   %ax,%ax
  801d3b:	66 90                	xchg   %ax,%ax
  801d3d:	66 90                	xchg   %ax,%ax
  801d3f:	90                   	nop

00801d40 <__udivdi3>:
  801d40:	f3 0f 1e fb          	endbr32 
  801d44:	55                   	push   %ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 1c             	sub    $0x1c,%esp
  801d4b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d4f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d53:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d57:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d5b:	85 d2                	test   %edx,%edx
  801d5d:	75 19                	jne    801d78 <__udivdi3+0x38>
  801d5f:	39 f3                	cmp    %esi,%ebx
  801d61:	76 4d                	jbe    801db0 <__udivdi3+0x70>
  801d63:	31 ff                	xor    %edi,%edi
  801d65:	89 e8                	mov    %ebp,%eax
  801d67:	89 f2                	mov    %esi,%edx
  801d69:	f7 f3                	div    %ebx
  801d6b:	89 fa                	mov    %edi,%edx
  801d6d:	83 c4 1c             	add    $0x1c,%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5f                   	pop    %edi
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    
  801d75:	8d 76 00             	lea    0x0(%esi),%esi
  801d78:	39 f2                	cmp    %esi,%edx
  801d7a:	76 14                	jbe    801d90 <__udivdi3+0x50>
  801d7c:	31 ff                	xor    %edi,%edi
  801d7e:	31 c0                	xor    %eax,%eax
  801d80:	89 fa                	mov    %edi,%edx
  801d82:	83 c4 1c             	add    $0x1c,%esp
  801d85:	5b                   	pop    %ebx
  801d86:	5e                   	pop    %esi
  801d87:	5f                   	pop    %edi
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    
  801d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d90:	0f bd fa             	bsr    %edx,%edi
  801d93:	83 f7 1f             	xor    $0x1f,%edi
  801d96:	75 48                	jne    801de0 <__udivdi3+0xa0>
  801d98:	39 f2                	cmp    %esi,%edx
  801d9a:	72 06                	jb     801da2 <__udivdi3+0x62>
  801d9c:	31 c0                	xor    %eax,%eax
  801d9e:	39 eb                	cmp    %ebp,%ebx
  801da0:	77 de                	ja     801d80 <__udivdi3+0x40>
  801da2:	b8 01 00 00 00       	mov    $0x1,%eax
  801da7:	eb d7                	jmp    801d80 <__udivdi3+0x40>
  801da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801db0:	89 d9                	mov    %ebx,%ecx
  801db2:	85 db                	test   %ebx,%ebx
  801db4:	75 0b                	jne    801dc1 <__udivdi3+0x81>
  801db6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbb:	31 d2                	xor    %edx,%edx
  801dbd:	f7 f3                	div    %ebx
  801dbf:	89 c1                	mov    %eax,%ecx
  801dc1:	31 d2                	xor    %edx,%edx
  801dc3:	89 f0                	mov    %esi,%eax
  801dc5:	f7 f1                	div    %ecx
  801dc7:	89 c6                	mov    %eax,%esi
  801dc9:	89 e8                	mov    %ebp,%eax
  801dcb:	89 f7                	mov    %esi,%edi
  801dcd:	f7 f1                	div    %ecx
  801dcf:	89 fa                	mov    %edi,%edx
  801dd1:	83 c4 1c             	add    $0x1c,%esp
  801dd4:	5b                   	pop    %ebx
  801dd5:	5e                   	pop    %esi
  801dd6:	5f                   	pop    %edi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    
  801dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801de0:	89 f9                	mov    %edi,%ecx
  801de2:	b8 20 00 00 00       	mov    $0x20,%eax
  801de7:	29 f8                	sub    %edi,%eax
  801de9:	d3 e2                	shl    %cl,%edx
  801deb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801def:	89 c1                	mov    %eax,%ecx
  801df1:	89 da                	mov    %ebx,%edx
  801df3:	d3 ea                	shr    %cl,%edx
  801df5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801df9:	09 d1                	or     %edx,%ecx
  801dfb:	89 f2                	mov    %esi,%edx
  801dfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e01:	89 f9                	mov    %edi,%ecx
  801e03:	d3 e3                	shl    %cl,%ebx
  801e05:	89 c1                	mov    %eax,%ecx
  801e07:	d3 ea                	shr    %cl,%edx
  801e09:	89 f9                	mov    %edi,%ecx
  801e0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e0f:	89 eb                	mov    %ebp,%ebx
  801e11:	d3 e6                	shl    %cl,%esi
  801e13:	89 c1                	mov    %eax,%ecx
  801e15:	d3 eb                	shr    %cl,%ebx
  801e17:	09 de                	or     %ebx,%esi
  801e19:	89 f0                	mov    %esi,%eax
  801e1b:	f7 74 24 08          	divl   0x8(%esp)
  801e1f:	89 d6                	mov    %edx,%esi
  801e21:	89 c3                	mov    %eax,%ebx
  801e23:	f7 64 24 0c          	mull   0xc(%esp)
  801e27:	39 d6                	cmp    %edx,%esi
  801e29:	72 15                	jb     801e40 <__udivdi3+0x100>
  801e2b:	89 f9                	mov    %edi,%ecx
  801e2d:	d3 e5                	shl    %cl,%ebp
  801e2f:	39 c5                	cmp    %eax,%ebp
  801e31:	73 04                	jae    801e37 <__udivdi3+0xf7>
  801e33:	39 d6                	cmp    %edx,%esi
  801e35:	74 09                	je     801e40 <__udivdi3+0x100>
  801e37:	89 d8                	mov    %ebx,%eax
  801e39:	31 ff                	xor    %edi,%edi
  801e3b:	e9 40 ff ff ff       	jmp    801d80 <__udivdi3+0x40>
  801e40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e43:	31 ff                	xor    %edi,%edi
  801e45:	e9 36 ff ff ff       	jmp    801d80 <__udivdi3+0x40>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	66 90                	xchg   %ax,%ax
  801e4e:	66 90                	xchg   %ax,%ax

00801e50 <__umoddi3>:
  801e50:	f3 0f 1e fb          	endbr32 
  801e54:	55                   	push   %ebp
  801e55:	57                   	push   %edi
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	83 ec 1c             	sub    $0x1c,%esp
  801e5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e5f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e63:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	75 19                	jne    801e88 <__umoddi3+0x38>
  801e6f:	39 df                	cmp    %ebx,%edi
  801e71:	76 5d                	jbe    801ed0 <__umoddi3+0x80>
  801e73:	89 f0                	mov    %esi,%eax
  801e75:	89 da                	mov    %ebx,%edx
  801e77:	f7 f7                	div    %edi
  801e79:	89 d0                	mov    %edx,%eax
  801e7b:	31 d2                	xor    %edx,%edx
  801e7d:	83 c4 1c             	add    $0x1c,%esp
  801e80:	5b                   	pop    %ebx
  801e81:	5e                   	pop    %esi
  801e82:	5f                   	pop    %edi
  801e83:	5d                   	pop    %ebp
  801e84:	c3                   	ret    
  801e85:	8d 76 00             	lea    0x0(%esi),%esi
  801e88:	89 f2                	mov    %esi,%edx
  801e8a:	39 d8                	cmp    %ebx,%eax
  801e8c:	76 12                	jbe    801ea0 <__umoddi3+0x50>
  801e8e:	89 f0                	mov    %esi,%eax
  801e90:	89 da                	mov    %ebx,%edx
  801e92:	83 c4 1c             	add    $0x1c,%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5f                   	pop    %edi
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    
  801e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ea0:	0f bd e8             	bsr    %eax,%ebp
  801ea3:	83 f5 1f             	xor    $0x1f,%ebp
  801ea6:	75 50                	jne    801ef8 <__umoddi3+0xa8>
  801ea8:	39 d8                	cmp    %ebx,%eax
  801eaa:	0f 82 e0 00 00 00    	jb     801f90 <__umoddi3+0x140>
  801eb0:	89 d9                	mov    %ebx,%ecx
  801eb2:	39 f7                	cmp    %esi,%edi
  801eb4:	0f 86 d6 00 00 00    	jbe    801f90 <__umoddi3+0x140>
  801eba:	89 d0                	mov    %edx,%eax
  801ebc:	89 ca                	mov    %ecx,%edx
  801ebe:	83 c4 1c             	add    $0x1c,%esp
  801ec1:	5b                   	pop    %ebx
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    
  801ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ecd:	8d 76 00             	lea    0x0(%esi),%esi
  801ed0:	89 fd                	mov    %edi,%ebp
  801ed2:	85 ff                	test   %edi,%edi
  801ed4:	75 0b                	jne    801ee1 <__umoddi3+0x91>
  801ed6:	b8 01 00 00 00       	mov    $0x1,%eax
  801edb:	31 d2                	xor    %edx,%edx
  801edd:	f7 f7                	div    %edi
  801edf:	89 c5                	mov    %eax,%ebp
  801ee1:	89 d8                	mov    %ebx,%eax
  801ee3:	31 d2                	xor    %edx,%edx
  801ee5:	f7 f5                	div    %ebp
  801ee7:	89 f0                	mov    %esi,%eax
  801ee9:	f7 f5                	div    %ebp
  801eeb:	89 d0                	mov    %edx,%eax
  801eed:	31 d2                	xor    %edx,%edx
  801eef:	eb 8c                	jmp    801e7d <__umoddi3+0x2d>
  801ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ef8:	89 e9                	mov    %ebp,%ecx
  801efa:	ba 20 00 00 00       	mov    $0x20,%edx
  801eff:	29 ea                	sub    %ebp,%edx
  801f01:	d3 e0                	shl    %cl,%eax
  801f03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f07:	89 d1                	mov    %edx,%ecx
  801f09:	89 f8                	mov    %edi,%eax
  801f0b:	d3 e8                	shr    %cl,%eax
  801f0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f11:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f15:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f19:	09 c1                	or     %eax,%ecx
  801f1b:	89 d8                	mov    %ebx,%eax
  801f1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f21:	89 e9                	mov    %ebp,%ecx
  801f23:	d3 e7                	shl    %cl,%edi
  801f25:	89 d1                	mov    %edx,%ecx
  801f27:	d3 e8                	shr    %cl,%eax
  801f29:	89 e9                	mov    %ebp,%ecx
  801f2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f2f:	d3 e3                	shl    %cl,%ebx
  801f31:	89 c7                	mov    %eax,%edi
  801f33:	89 d1                	mov    %edx,%ecx
  801f35:	89 f0                	mov    %esi,%eax
  801f37:	d3 e8                	shr    %cl,%eax
  801f39:	89 e9                	mov    %ebp,%ecx
  801f3b:	89 fa                	mov    %edi,%edx
  801f3d:	d3 e6                	shl    %cl,%esi
  801f3f:	09 d8                	or     %ebx,%eax
  801f41:	f7 74 24 08          	divl   0x8(%esp)
  801f45:	89 d1                	mov    %edx,%ecx
  801f47:	89 f3                	mov    %esi,%ebx
  801f49:	f7 64 24 0c          	mull   0xc(%esp)
  801f4d:	89 c6                	mov    %eax,%esi
  801f4f:	89 d7                	mov    %edx,%edi
  801f51:	39 d1                	cmp    %edx,%ecx
  801f53:	72 06                	jb     801f5b <__umoddi3+0x10b>
  801f55:	75 10                	jne    801f67 <__umoddi3+0x117>
  801f57:	39 c3                	cmp    %eax,%ebx
  801f59:	73 0c                	jae    801f67 <__umoddi3+0x117>
  801f5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f63:	89 d7                	mov    %edx,%edi
  801f65:	89 c6                	mov    %eax,%esi
  801f67:	89 ca                	mov    %ecx,%edx
  801f69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f6e:	29 f3                	sub    %esi,%ebx
  801f70:	19 fa                	sbb    %edi,%edx
  801f72:	89 d0                	mov    %edx,%eax
  801f74:	d3 e0                	shl    %cl,%eax
  801f76:	89 e9                	mov    %ebp,%ecx
  801f78:	d3 eb                	shr    %cl,%ebx
  801f7a:	d3 ea                	shr    %cl,%edx
  801f7c:	09 d8                	or     %ebx,%eax
  801f7e:	83 c4 1c             	add    $0x1c,%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5f                   	pop    %edi
  801f84:	5d                   	pop    %ebp
  801f85:	c3                   	ret    
  801f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f8d:	8d 76 00             	lea    0x0(%esi),%esi
  801f90:	29 fe                	sub    %edi,%esi
  801f92:	19 c3                	sbb    %eax,%ebx
  801f94:	89 f2                	mov    %esi,%edx
  801f96:	89 d9                	mov    %ebx,%ecx
  801f98:	e9 1d ff ff ff       	jmp    801eba <__umoddi3+0x6a>
