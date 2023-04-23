
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
  80005c:	68 00 25 80 00       	push   $0x802500
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
  80008b:	68 03 25 80 00       	push   $0x802503
  800090:	6a 01                	push   $0x1
  800092:	e8 e1 0b 00 00       	call   800c78 <write>
  800097:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a0:	e8 ab 00 00 00       	call   800150 <strlen>
  8000a5:	83 c4 0c             	add    $0xc,%esp
  8000a8:	50                   	push   %eax
  8000a9:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000ac:	6a 01                	push   $0x1
  8000ae:	e8 c5 0b 00 00       	call   800c78 <write>
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
  8000d7:	68 98 29 80 00       	push   $0x802998
  8000dc:	6a 01                	push   $0x1
  8000de:	e8 95 0b 00 00       	call   800c78 <write>
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
  800109:	a3 08 40 80 00       	mov    %eax,0x804008

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
  80013c:	e8 48 09 00 00       	call   800a89 <close_all>
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
  80057e:	68 0f 25 80 00       	push   $0x80250f
  800583:	6a 23                	push   $0x23
  800585:	68 2c 25 80 00       	push   $0x80252c
  80058a:	e8 08 15 00 00       	call   801a97 <_panic>

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
  80060b:	68 0f 25 80 00       	push   $0x80250f
  800610:	6a 23                	push   $0x23
  800612:	68 2c 25 80 00       	push   $0x80252c
  800617:	e8 7b 14 00 00       	call   801a97 <_panic>

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
  800651:	68 0f 25 80 00       	push   $0x80250f
  800656:	6a 23                	push   $0x23
  800658:	68 2c 25 80 00       	push   $0x80252c
  80065d:	e8 35 14 00 00       	call   801a97 <_panic>

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
  800697:	68 0f 25 80 00       	push   $0x80250f
  80069c:	6a 23                	push   $0x23
  80069e:	68 2c 25 80 00       	push   $0x80252c
  8006a3:	e8 ef 13 00 00       	call   801a97 <_panic>

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
  8006dd:	68 0f 25 80 00       	push   $0x80250f
  8006e2:	6a 23                	push   $0x23
  8006e4:	68 2c 25 80 00       	push   $0x80252c
  8006e9:	e8 a9 13 00 00       	call   801a97 <_panic>

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
  800723:	68 0f 25 80 00       	push   $0x80250f
  800728:	6a 23                	push   $0x23
  80072a:	68 2c 25 80 00       	push   $0x80252c
  80072f:	e8 63 13 00 00       	call   801a97 <_panic>

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
  800769:	68 0f 25 80 00       	push   $0x80250f
  80076e:	6a 23                	push   $0x23
  800770:	68 2c 25 80 00       	push   $0x80252c
  800775:	e8 1d 13 00 00       	call   801a97 <_panic>

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
  8007d5:	68 0f 25 80 00       	push   $0x80250f
  8007da:	6a 23                	push   $0x23
  8007dc:	68 2c 25 80 00       	push   $0x80252c
  8007e1:	e8 b1 12 00 00       	call   801a97 <_panic>

008007e6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8007e6:	f3 0f 1e fb          	endbr32 
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	57                   	push   %edi
  8007ee:	56                   	push   %esi
  8007ef:	53                   	push   %ebx
	asm volatile("int %1\n"
  8007f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f5:	b8 0e 00 00 00       	mov    $0xe,%eax
  8007fa:	89 d1                	mov    %edx,%ecx
  8007fc:	89 d3                	mov    %edx,%ebx
  8007fe:	89 d7                	mov    %edx,%edi
  800800:	89 d6                	mov    %edx,%esi
  800802:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800804:	5b                   	pop    %ebx
  800805:	5e                   	pop    %esi
  800806:	5f                   	pop    %edi
  800807:	5d                   	pop    %ebp
  800808:	c3                   	ret    

00800809 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800809:	f3 0f 1e fb          	endbr32 
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	57                   	push   %edi
  800811:	56                   	push   %esi
  800812:	53                   	push   %ebx
  800813:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800816:	bb 00 00 00 00       	mov    $0x0,%ebx
  80081b:	8b 55 08             	mov    0x8(%ebp),%edx
  80081e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800821:	b8 0f 00 00 00       	mov    $0xf,%eax
  800826:	89 df                	mov    %ebx,%edi
  800828:	89 de                	mov    %ebx,%esi
  80082a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80082c:	85 c0                	test   %eax,%eax
  80082e:	7f 08                	jg     800838 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800830:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800833:	5b                   	pop    %ebx
  800834:	5e                   	pop    %esi
  800835:	5f                   	pop    %edi
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800838:	83 ec 0c             	sub    $0xc,%esp
  80083b:	50                   	push   %eax
  80083c:	6a 0f                	push   $0xf
  80083e:	68 0f 25 80 00       	push   $0x80250f
  800843:	6a 23                	push   $0x23
  800845:	68 2c 25 80 00       	push   $0x80252c
  80084a:	e8 48 12 00 00       	call   801a97 <_panic>

0080084f <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  80084f:	f3 0f 1e fb          	endbr32 
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	57                   	push   %edi
  800857:	56                   	push   %esi
  800858:	53                   	push   %ebx
  800859:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80085c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800861:	8b 55 08             	mov    0x8(%ebp),%edx
  800864:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800867:	b8 10 00 00 00       	mov    $0x10,%eax
  80086c:	89 df                	mov    %ebx,%edi
  80086e:	89 de                	mov    %ebx,%esi
  800870:	cd 30                	int    $0x30
	if(check && ret > 0)
  800872:	85 c0                	test   %eax,%eax
  800874:	7f 08                	jg     80087e <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800876:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800879:	5b                   	pop    %ebx
  80087a:	5e                   	pop    %esi
  80087b:	5f                   	pop    %edi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80087e:	83 ec 0c             	sub    $0xc,%esp
  800881:	50                   	push   %eax
  800882:	6a 10                	push   $0x10
  800884:	68 0f 25 80 00       	push   $0x80250f
  800889:	6a 23                	push   $0x23
  80088b:	68 2c 25 80 00       	push   $0x80252c
  800890:	e8 02 12 00 00       	call   801a97 <_panic>

00800895 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800895:	f3 0f 1e fb          	endbr32 
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	05 00 00 00 30       	add    $0x30000000,%eax
  8008a4:	c1 e8 0c             	shr    $0xc,%eax
}
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8008a9:	f3 0f 1e fb          	endbr32 
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8008b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008bd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8008c4:	f3 0f 1e fb          	endbr32 
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8008d0:	89 c2                	mov    %eax,%edx
  8008d2:	c1 ea 16             	shr    $0x16,%edx
  8008d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8008dc:	f6 c2 01             	test   $0x1,%dl
  8008df:	74 2d                	je     80090e <fd_alloc+0x4a>
  8008e1:	89 c2                	mov    %eax,%edx
  8008e3:	c1 ea 0c             	shr    $0xc,%edx
  8008e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8008ed:	f6 c2 01             	test   $0x1,%dl
  8008f0:	74 1c                	je     80090e <fd_alloc+0x4a>
  8008f2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8008f7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8008fc:	75 d2                	jne    8008d0 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800907:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80090c:	eb 0a                	jmp    800918 <fd_alloc+0x54>
			*fd_store = fd;
  80090e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800911:	89 01                	mov    %eax,(%ecx)
			return 0;
  800913:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80091a:	f3 0f 1e fb          	endbr32 
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800924:	83 f8 1f             	cmp    $0x1f,%eax
  800927:	77 30                	ja     800959 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800929:	c1 e0 0c             	shl    $0xc,%eax
  80092c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800931:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800937:	f6 c2 01             	test   $0x1,%dl
  80093a:	74 24                	je     800960 <fd_lookup+0x46>
  80093c:	89 c2                	mov    %eax,%edx
  80093e:	c1 ea 0c             	shr    $0xc,%edx
  800941:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800948:	f6 c2 01             	test   $0x1,%dl
  80094b:	74 1a                	je     800967 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80094d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800950:	89 02                	mov    %eax,(%edx)
	return 0;
  800952:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    
		return -E_INVAL;
  800959:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80095e:	eb f7                	jmp    800957 <fd_lookup+0x3d>
		return -E_INVAL;
  800960:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800965:	eb f0                	jmp    800957 <fd_lookup+0x3d>
  800967:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096c:	eb e9                	jmp    800957 <fd_lookup+0x3d>

0080096e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80096e:	f3 0f 1e fb          	endbr32 
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80097b:	ba 00 00 00 00       	mov    $0x0,%edx
  800980:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800985:	39 08                	cmp    %ecx,(%eax)
  800987:	74 38                	je     8009c1 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800989:	83 c2 01             	add    $0x1,%edx
  80098c:	8b 04 95 b8 25 80 00 	mov    0x8025b8(,%edx,4),%eax
  800993:	85 c0                	test   %eax,%eax
  800995:	75 ee                	jne    800985 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800997:	a1 08 40 80 00       	mov    0x804008,%eax
  80099c:	8b 40 48             	mov    0x48(%eax),%eax
  80099f:	83 ec 04             	sub    $0x4,%esp
  8009a2:	51                   	push   %ecx
  8009a3:	50                   	push   %eax
  8009a4:	68 3c 25 80 00       	push   $0x80253c
  8009a9:	e8 d0 11 00 00       	call   801b7e <cprintf>
	*dev = 0;
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8009bf:	c9                   	leave  
  8009c0:	c3                   	ret    
			*dev = devtab[i];
  8009c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cb:	eb f2                	jmp    8009bf <dev_lookup+0x51>

008009cd <fd_close>:
{
  8009cd:	f3 0f 1e fb          	endbr32 
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	57                   	push   %edi
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	83 ec 24             	sub    $0x24,%esp
  8009da:	8b 75 08             	mov    0x8(%ebp),%esi
  8009dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8009e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8009e3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8009e4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8009ea:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8009ed:	50                   	push   %eax
  8009ee:	e8 27 ff ff ff       	call   80091a <fd_lookup>
  8009f3:	89 c3                	mov    %eax,%ebx
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	85 c0                	test   %eax,%eax
  8009fa:	78 05                	js     800a01 <fd_close+0x34>
	    || fd != fd2)
  8009fc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8009ff:	74 16                	je     800a17 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800a01:	89 f8                	mov    %edi,%eax
  800a03:	84 c0                	test   %al,%al
  800a05:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0a:	0f 44 d8             	cmove  %eax,%ebx
}
  800a0d:	89 d8                	mov    %ebx,%eax
  800a0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a12:	5b                   	pop    %ebx
  800a13:	5e                   	pop    %esi
  800a14:	5f                   	pop    %edi
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800a1d:	50                   	push   %eax
  800a1e:	ff 36                	pushl  (%esi)
  800a20:	e8 49 ff ff ff       	call   80096e <dev_lookup>
  800a25:	89 c3                	mov    %eax,%ebx
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	85 c0                	test   %eax,%eax
  800a2c:	78 1a                	js     800a48 <fd_close+0x7b>
		if (dev->dev_close)
  800a2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a31:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800a34:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800a39:	85 c0                	test   %eax,%eax
  800a3b:	74 0b                	je     800a48 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800a3d:	83 ec 0c             	sub    $0xc,%esp
  800a40:	56                   	push   %esi
  800a41:	ff d0                	call   *%eax
  800a43:	89 c3                	mov    %eax,%ebx
  800a45:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	56                   	push   %esi
  800a4c:	6a 00                	push   $0x0
  800a4e:	e8 0f fc ff ff       	call   800662 <sys_page_unmap>
	return r;
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	eb b5                	jmp    800a0d <fd_close+0x40>

00800a58 <close>:

int
close(int fdnum)
{
  800a58:	f3 0f 1e fb          	endbr32 
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a65:	50                   	push   %eax
  800a66:	ff 75 08             	pushl  0x8(%ebp)
  800a69:	e8 ac fe ff ff       	call   80091a <fd_lookup>
  800a6e:	83 c4 10             	add    $0x10,%esp
  800a71:	85 c0                	test   %eax,%eax
  800a73:	79 02                	jns    800a77 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800a75:	c9                   	leave  
  800a76:	c3                   	ret    
		return fd_close(fd, 1);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	6a 01                	push   $0x1
  800a7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7f:	e8 49 ff ff ff       	call   8009cd <fd_close>
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	eb ec                	jmp    800a75 <close+0x1d>

00800a89 <close_all>:

void
close_all(void)
{
  800a89:	f3 0f 1e fb          	endbr32 
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	53                   	push   %ebx
  800a91:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800a94:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800a99:	83 ec 0c             	sub    $0xc,%esp
  800a9c:	53                   	push   %ebx
  800a9d:	e8 b6 ff ff ff       	call   800a58 <close>
	for (i = 0; i < MAXFD; i++)
  800aa2:	83 c3 01             	add    $0x1,%ebx
  800aa5:	83 c4 10             	add    $0x10,%esp
  800aa8:	83 fb 20             	cmp    $0x20,%ebx
  800aab:	75 ec                	jne    800a99 <close_all+0x10>
}
  800aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ab2:	f3 0f 1e fb          	endbr32 
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	57                   	push   %edi
  800aba:	56                   	push   %esi
  800abb:	53                   	push   %ebx
  800abc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800abf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ac2:	50                   	push   %eax
  800ac3:	ff 75 08             	pushl  0x8(%ebp)
  800ac6:	e8 4f fe ff ff       	call   80091a <fd_lookup>
  800acb:	89 c3                	mov    %eax,%ebx
  800acd:	83 c4 10             	add    $0x10,%esp
  800ad0:	85 c0                	test   %eax,%eax
  800ad2:	0f 88 81 00 00 00    	js     800b59 <dup+0xa7>
		return r;
	close(newfdnum);
  800ad8:	83 ec 0c             	sub    $0xc,%esp
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	e8 75 ff ff ff       	call   800a58 <close>

	newfd = INDEX2FD(newfdnum);
  800ae3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae6:	c1 e6 0c             	shl    $0xc,%esi
  800ae9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800aef:	83 c4 04             	add    $0x4,%esp
  800af2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800af5:	e8 af fd ff ff       	call   8008a9 <fd2data>
  800afa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800afc:	89 34 24             	mov    %esi,(%esp)
  800aff:	e8 a5 fd ff ff       	call   8008a9 <fd2data>
  800b04:	83 c4 10             	add    $0x10,%esp
  800b07:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800b09:	89 d8                	mov    %ebx,%eax
  800b0b:	c1 e8 16             	shr    $0x16,%eax
  800b0e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800b15:	a8 01                	test   $0x1,%al
  800b17:	74 11                	je     800b2a <dup+0x78>
  800b19:	89 d8                	mov    %ebx,%eax
  800b1b:	c1 e8 0c             	shr    $0xc,%eax
  800b1e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800b25:	f6 c2 01             	test   $0x1,%dl
  800b28:	75 39                	jne    800b63 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800b2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b2d:	89 d0                	mov    %edx,%eax
  800b2f:	c1 e8 0c             	shr    $0xc,%eax
  800b32:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800b39:	83 ec 0c             	sub    $0xc,%esp
  800b3c:	25 07 0e 00 00       	and    $0xe07,%eax
  800b41:	50                   	push   %eax
  800b42:	56                   	push   %esi
  800b43:	6a 00                	push   $0x0
  800b45:	52                   	push   %edx
  800b46:	6a 00                	push   $0x0
  800b48:	e8 cf fa ff ff       	call   80061c <sys_page_map>
  800b4d:	89 c3                	mov    %eax,%ebx
  800b4f:	83 c4 20             	add    $0x20,%esp
  800b52:	85 c0                	test   %eax,%eax
  800b54:	78 31                	js     800b87 <dup+0xd5>
		goto err;

	return newfdnum;
  800b56:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800b59:	89 d8                	mov    %ebx,%eax
  800b5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b5e:	5b                   	pop    %ebx
  800b5f:	5e                   	pop    %esi
  800b60:	5f                   	pop    %edi
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800b63:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800b6a:	83 ec 0c             	sub    $0xc,%esp
  800b6d:	25 07 0e 00 00       	and    $0xe07,%eax
  800b72:	50                   	push   %eax
  800b73:	57                   	push   %edi
  800b74:	6a 00                	push   $0x0
  800b76:	53                   	push   %ebx
  800b77:	6a 00                	push   $0x0
  800b79:	e8 9e fa ff ff       	call   80061c <sys_page_map>
  800b7e:	89 c3                	mov    %eax,%ebx
  800b80:	83 c4 20             	add    $0x20,%esp
  800b83:	85 c0                	test   %eax,%eax
  800b85:	79 a3                	jns    800b2a <dup+0x78>
	sys_page_unmap(0, newfd);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	56                   	push   %esi
  800b8b:	6a 00                	push   $0x0
  800b8d:	e8 d0 fa ff ff       	call   800662 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800b92:	83 c4 08             	add    $0x8,%esp
  800b95:	57                   	push   %edi
  800b96:	6a 00                	push   $0x0
  800b98:	e8 c5 fa ff ff       	call   800662 <sys_page_unmap>
	return r;
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	eb b7                	jmp    800b59 <dup+0xa7>

00800ba2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800ba2:	f3 0f 1e fb          	endbr32 
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	53                   	push   %ebx
  800baa:	83 ec 1c             	sub    $0x1c,%esp
  800bad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bb3:	50                   	push   %eax
  800bb4:	53                   	push   %ebx
  800bb5:	e8 60 fd ff ff       	call   80091a <fd_lookup>
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	78 3f                	js     800c00 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcb:	ff 30                	pushl  (%eax)
  800bcd:	e8 9c fd ff ff       	call   80096e <dev_lookup>
  800bd2:	83 c4 10             	add    $0x10,%esp
  800bd5:	85 c0                	test   %eax,%eax
  800bd7:	78 27                	js     800c00 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800bd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800bdc:	8b 42 08             	mov    0x8(%edx),%eax
  800bdf:	83 e0 03             	and    $0x3,%eax
  800be2:	83 f8 01             	cmp    $0x1,%eax
  800be5:	74 1e                	je     800c05 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bea:	8b 40 08             	mov    0x8(%eax),%eax
  800bed:	85 c0                	test   %eax,%eax
  800bef:	74 35                	je     800c26 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800bf1:	83 ec 04             	sub    $0x4,%esp
  800bf4:	ff 75 10             	pushl  0x10(%ebp)
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	52                   	push   %edx
  800bfb:	ff d0                	call   *%eax
  800bfd:	83 c4 10             	add    $0x10,%esp
}
  800c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800c05:	a1 08 40 80 00       	mov    0x804008,%eax
  800c0a:	8b 40 48             	mov    0x48(%eax),%eax
  800c0d:	83 ec 04             	sub    $0x4,%esp
  800c10:	53                   	push   %ebx
  800c11:	50                   	push   %eax
  800c12:	68 7d 25 80 00       	push   $0x80257d
  800c17:	e8 62 0f 00 00       	call   801b7e <cprintf>
		return -E_INVAL;
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c24:	eb da                	jmp    800c00 <read+0x5e>
		return -E_NOT_SUPP;
  800c26:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c2b:	eb d3                	jmp    800c00 <read+0x5e>

00800c2d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c2d:	f3 0f 1e fb          	endbr32 
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
  800c37:	83 ec 0c             	sub    $0xc,%esp
  800c3a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c3d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c45:	eb 02                	jmp    800c49 <readn+0x1c>
  800c47:	01 c3                	add    %eax,%ebx
  800c49:	39 f3                	cmp    %esi,%ebx
  800c4b:	73 21                	jae    800c6e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	89 f0                	mov    %esi,%eax
  800c52:	29 d8                	sub    %ebx,%eax
  800c54:	50                   	push   %eax
  800c55:	89 d8                	mov    %ebx,%eax
  800c57:	03 45 0c             	add    0xc(%ebp),%eax
  800c5a:	50                   	push   %eax
  800c5b:	57                   	push   %edi
  800c5c:	e8 41 ff ff ff       	call   800ba2 <read>
		if (m < 0)
  800c61:	83 c4 10             	add    $0x10,%esp
  800c64:	85 c0                	test   %eax,%eax
  800c66:	78 04                	js     800c6c <readn+0x3f>
			return m;
		if (m == 0)
  800c68:	75 dd                	jne    800c47 <readn+0x1a>
  800c6a:	eb 02                	jmp    800c6e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c6c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800c6e:	89 d8                	mov    %ebx,%eax
  800c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c73:	5b                   	pop    %ebx
  800c74:	5e                   	pop    %esi
  800c75:	5f                   	pop    %edi
  800c76:	5d                   	pop    %ebp
  800c77:	c3                   	ret    

00800c78 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800c78:	f3 0f 1e fb          	endbr32 
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	53                   	push   %ebx
  800c80:	83 ec 1c             	sub    $0x1c,%esp
  800c83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c89:	50                   	push   %eax
  800c8a:	53                   	push   %ebx
  800c8b:	e8 8a fc ff ff       	call   80091a <fd_lookup>
  800c90:	83 c4 10             	add    $0x10,%esp
  800c93:	85 c0                	test   %eax,%eax
  800c95:	78 3a                	js     800cd1 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c9d:	50                   	push   %eax
  800c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca1:	ff 30                	pushl  (%eax)
  800ca3:	e8 c6 fc ff ff       	call   80096e <dev_lookup>
  800ca8:	83 c4 10             	add    $0x10,%esp
  800cab:	85 c0                	test   %eax,%eax
  800cad:	78 22                	js     800cd1 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800cb6:	74 1e                	je     800cd6 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cbb:	8b 52 0c             	mov    0xc(%edx),%edx
  800cbe:	85 d2                	test   %edx,%edx
  800cc0:	74 35                	je     800cf7 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800cc2:	83 ec 04             	sub    $0x4,%esp
  800cc5:	ff 75 10             	pushl  0x10(%ebp)
  800cc8:	ff 75 0c             	pushl  0xc(%ebp)
  800ccb:	50                   	push   %eax
  800ccc:	ff d2                	call   *%edx
  800cce:	83 c4 10             	add    $0x10,%esp
}
  800cd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd4:	c9                   	leave  
  800cd5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800cd6:	a1 08 40 80 00       	mov    0x804008,%eax
  800cdb:	8b 40 48             	mov    0x48(%eax),%eax
  800cde:	83 ec 04             	sub    $0x4,%esp
  800ce1:	53                   	push   %ebx
  800ce2:	50                   	push   %eax
  800ce3:	68 99 25 80 00       	push   $0x802599
  800ce8:	e8 91 0e 00 00       	call   801b7e <cprintf>
		return -E_INVAL;
  800ced:	83 c4 10             	add    $0x10,%esp
  800cf0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cf5:	eb da                	jmp    800cd1 <write+0x59>
		return -E_NOT_SUPP;
  800cf7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cfc:	eb d3                	jmp    800cd1 <write+0x59>

00800cfe <seek>:

int
seek(int fdnum, off_t offset)
{
  800cfe:	f3 0f 1e fb          	endbr32 
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d0b:	50                   	push   %eax
  800d0c:	ff 75 08             	pushl  0x8(%ebp)
  800d0f:	e8 06 fc ff ff       	call   80091a <fd_lookup>
  800d14:	83 c4 10             	add    $0x10,%esp
  800d17:	85 c0                	test   %eax,%eax
  800d19:	78 0e                	js     800d29 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d21:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800d2b:	f3 0f 1e fb          	endbr32 
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	53                   	push   %ebx
  800d33:	83 ec 1c             	sub    $0x1c,%esp
  800d36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d39:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d3c:	50                   	push   %eax
  800d3d:	53                   	push   %ebx
  800d3e:	e8 d7 fb ff ff       	call   80091a <fd_lookup>
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	85 c0                	test   %eax,%eax
  800d48:	78 37                	js     800d81 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d4a:	83 ec 08             	sub    $0x8,%esp
  800d4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d50:	50                   	push   %eax
  800d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d54:	ff 30                	pushl  (%eax)
  800d56:	e8 13 fc ff ff       	call   80096e <dev_lookup>
  800d5b:	83 c4 10             	add    $0x10,%esp
  800d5e:	85 c0                	test   %eax,%eax
  800d60:	78 1f                	js     800d81 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d65:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800d69:	74 1b                	je     800d86 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800d6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d6e:	8b 52 18             	mov    0x18(%edx),%edx
  800d71:	85 d2                	test   %edx,%edx
  800d73:	74 32                	je     800da7 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	ff 75 0c             	pushl  0xc(%ebp)
  800d7b:	50                   	push   %eax
  800d7c:	ff d2                	call   *%edx
  800d7e:	83 c4 10             	add    $0x10,%esp
}
  800d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d84:	c9                   	leave  
  800d85:	c3                   	ret    
			thisenv->env_id, fdnum);
  800d86:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d8b:	8b 40 48             	mov    0x48(%eax),%eax
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	53                   	push   %ebx
  800d92:	50                   	push   %eax
  800d93:	68 5c 25 80 00       	push   $0x80255c
  800d98:	e8 e1 0d 00 00       	call   801b7e <cprintf>
		return -E_INVAL;
  800d9d:	83 c4 10             	add    $0x10,%esp
  800da0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800da5:	eb da                	jmp    800d81 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800da7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800dac:	eb d3                	jmp    800d81 <ftruncate+0x56>

00800dae <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800dae:	f3 0f 1e fb          	endbr32 
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	53                   	push   %ebx
  800db6:	83 ec 1c             	sub    $0x1c,%esp
  800db9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dbc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dbf:	50                   	push   %eax
  800dc0:	ff 75 08             	pushl  0x8(%ebp)
  800dc3:	e8 52 fb ff ff       	call   80091a <fd_lookup>
  800dc8:	83 c4 10             	add    $0x10,%esp
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	78 4b                	js     800e1a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dcf:	83 ec 08             	sub    $0x8,%esp
  800dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dd5:	50                   	push   %eax
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	ff 30                	pushl  (%eax)
  800ddb:	e8 8e fb ff ff       	call   80096e <dev_lookup>
  800de0:	83 c4 10             	add    $0x10,%esp
  800de3:	85 c0                	test   %eax,%eax
  800de5:	78 33                	js     800e1a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dea:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800dee:	74 2f                	je     800e1f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800df0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800df3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800dfa:	00 00 00 
	stat->st_isdir = 0;
  800dfd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800e04:	00 00 00 
	stat->st_dev = dev;
  800e07:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800e0d:	83 ec 08             	sub    $0x8,%esp
  800e10:	53                   	push   %ebx
  800e11:	ff 75 f0             	pushl  -0x10(%ebp)
  800e14:	ff 50 14             	call   *0x14(%eax)
  800e17:	83 c4 10             	add    $0x10,%esp
}
  800e1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    
		return -E_NOT_SUPP;
  800e1f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800e24:	eb f4                	jmp    800e1a <fstat+0x6c>

00800e26 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e26:	f3 0f 1e fb          	endbr32 
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e2f:	83 ec 08             	sub    $0x8,%esp
  800e32:	6a 00                	push   $0x0
  800e34:	ff 75 08             	pushl  0x8(%ebp)
  800e37:	e8 fb 01 00 00       	call   801037 <open>
  800e3c:	89 c3                	mov    %eax,%ebx
  800e3e:	83 c4 10             	add    $0x10,%esp
  800e41:	85 c0                	test   %eax,%eax
  800e43:	78 1b                	js     800e60 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	ff 75 0c             	pushl  0xc(%ebp)
  800e4b:	50                   	push   %eax
  800e4c:	e8 5d ff ff ff       	call   800dae <fstat>
  800e51:	89 c6                	mov    %eax,%esi
	close(fd);
  800e53:	89 1c 24             	mov    %ebx,(%esp)
  800e56:	e8 fd fb ff ff       	call   800a58 <close>
	return r;
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	89 f3                	mov    %esi,%ebx
}
  800e60:	89 d8                	mov    %ebx,%eax
  800e62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	56                   	push   %esi
  800e6d:	53                   	push   %ebx
  800e6e:	89 c6                	mov    %eax,%esi
  800e70:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800e72:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800e79:	74 27                	je     800ea2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800e7b:	6a 07                	push   $0x7
  800e7d:	68 00 50 80 00       	push   $0x805000
  800e82:	56                   	push   %esi
  800e83:	ff 35 00 40 80 00    	pushl  0x804000
  800e89:	e8 3c 13 00 00       	call   8021ca <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800e8e:	83 c4 0c             	add    $0xc,%esp
  800e91:	6a 00                	push   $0x0
  800e93:	53                   	push   %ebx
  800e94:	6a 00                	push   $0x0
  800e96:	e8 aa 12 00 00       	call   802145 <ipc_recv>
}
  800e9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	6a 01                	push   $0x1
  800ea7:	e8 76 13 00 00       	call   802222 <ipc_find_env>
  800eac:	a3 00 40 80 00       	mov    %eax,0x804000
  800eb1:	83 c4 10             	add    $0x10,%esp
  800eb4:	eb c5                	jmp    800e7b <fsipc+0x12>

00800eb6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800eb6:	f3 0f 1e fb          	endbr32 
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8b 40 0c             	mov    0xc(%eax),%eax
  800ec6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800ed3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed8:	b8 02 00 00 00       	mov    $0x2,%eax
  800edd:	e8 87 ff ff ff       	call   800e69 <fsipc>
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <devfile_flush>:
{
  800ee4:	f3 0f 1e fb          	endbr32 
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  800ef4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800ef9:	ba 00 00 00 00       	mov    $0x0,%edx
  800efe:	b8 06 00 00 00       	mov    $0x6,%eax
  800f03:	e8 61 ff ff ff       	call   800e69 <fsipc>
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <devfile_stat>:
{
  800f0a:	f3 0f 1e fb          	endbr32 
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	53                   	push   %ebx
  800f12:	83 ec 04             	sub    $0x4,%esp
  800f15:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8b 40 0c             	mov    0xc(%eax),%eax
  800f1e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800f23:	ba 00 00 00 00       	mov    $0x0,%edx
  800f28:	b8 05 00 00 00       	mov    $0x5,%eax
  800f2d:	e8 37 ff ff ff       	call   800e69 <fsipc>
  800f32:	85 c0                	test   %eax,%eax
  800f34:	78 2c                	js     800f62 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	68 00 50 80 00       	push   $0x805000
  800f3e:	53                   	push   %ebx
  800f3f:	e8 4f f2 ff ff       	call   800193 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800f44:	a1 80 50 80 00       	mov    0x805080,%eax
  800f49:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f4f:	a1 84 50 80 00       	mov    0x805084,%eax
  800f54:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800f5a:	83 c4 10             	add    $0x10,%esp
  800f5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <devfile_write>:
{
  800f67:	f3 0f 1e fb          	endbr32 
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	83 ec 0c             	sub    $0xc,%esp
  800f71:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	8b 52 0c             	mov    0xc(%edx),%edx
  800f7a:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800f80:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800f85:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800f8a:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800f8d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800f92:	50                   	push   %eax
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	68 08 50 80 00       	push   $0x805008
  800f9b:	e8 a9 f3 ff ff       	call   800349 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800fa0:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa5:	b8 04 00 00 00       	mov    $0x4,%eax
  800faa:	e8 ba fe ff ff       	call   800e69 <fsipc>
}
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    

00800fb1 <devfile_read>:
{
  800fb1:	f3 0f 1e fb          	endbr32 
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
  800fba:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8b 40 0c             	mov    0xc(%eax),%eax
  800fc3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800fc8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800fce:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800fd8:	e8 8c fe ff ff       	call   800e69 <fsipc>
  800fdd:	89 c3                	mov    %eax,%ebx
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	78 1f                	js     801002 <devfile_read+0x51>
	assert(r <= n);
  800fe3:	39 f0                	cmp    %esi,%eax
  800fe5:	77 24                	ja     80100b <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800fe7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800fec:	7f 33                	jg     801021 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800fee:	83 ec 04             	sub    $0x4,%esp
  800ff1:	50                   	push   %eax
  800ff2:	68 00 50 80 00       	push   $0x805000
  800ff7:	ff 75 0c             	pushl  0xc(%ebp)
  800ffa:	e8 4a f3 ff ff       	call   800349 <memmove>
	return r;
  800fff:	83 c4 10             	add    $0x10,%esp
}
  801002:	89 d8                	mov    %ebx,%eax
  801004:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    
	assert(r <= n);
  80100b:	68 cc 25 80 00       	push   $0x8025cc
  801010:	68 d3 25 80 00       	push   $0x8025d3
  801015:	6a 7c                	push   $0x7c
  801017:	68 e8 25 80 00       	push   $0x8025e8
  80101c:	e8 76 0a 00 00       	call   801a97 <_panic>
	assert(r <= PGSIZE);
  801021:	68 f3 25 80 00       	push   $0x8025f3
  801026:	68 d3 25 80 00       	push   $0x8025d3
  80102b:	6a 7d                	push   $0x7d
  80102d:	68 e8 25 80 00       	push   $0x8025e8
  801032:	e8 60 0a 00 00       	call   801a97 <_panic>

00801037 <open>:
{
  801037:	f3 0f 1e fb          	endbr32 
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	56                   	push   %esi
  80103f:	53                   	push   %ebx
  801040:	83 ec 1c             	sub    $0x1c,%esp
  801043:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801046:	56                   	push   %esi
  801047:	e8 04 f1 ff ff       	call   800150 <strlen>
  80104c:	83 c4 10             	add    $0x10,%esp
  80104f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801054:	7f 6c                	jg     8010c2 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80105c:	50                   	push   %eax
  80105d:	e8 62 f8 ff ff       	call   8008c4 <fd_alloc>
  801062:	89 c3                	mov    %eax,%ebx
  801064:	83 c4 10             	add    $0x10,%esp
  801067:	85 c0                	test   %eax,%eax
  801069:	78 3c                	js     8010a7 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80106b:	83 ec 08             	sub    $0x8,%esp
  80106e:	56                   	push   %esi
  80106f:	68 00 50 80 00       	push   $0x805000
  801074:	e8 1a f1 ff ff       	call   800193 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801084:	b8 01 00 00 00       	mov    $0x1,%eax
  801089:	e8 db fd ff ff       	call   800e69 <fsipc>
  80108e:	89 c3                	mov    %eax,%ebx
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	78 19                	js     8010b0 <open+0x79>
	return fd2num(fd);
  801097:	83 ec 0c             	sub    $0xc,%esp
  80109a:	ff 75 f4             	pushl  -0xc(%ebp)
  80109d:	e8 f3 f7 ff ff       	call   800895 <fd2num>
  8010a2:	89 c3                	mov    %eax,%ebx
  8010a4:	83 c4 10             	add    $0x10,%esp
}
  8010a7:	89 d8                	mov    %ebx,%eax
  8010a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    
		fd_close(fd, 0);
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	6a 00                	push   $0x0
  8010b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b8:	e8 10 f9 ff ff       	call   8009cd <fd_close>
		return r;
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	eb e5                	jmp    8010a7 <open+0x70>
		return -E_BAD_PATH;
  8010c2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8010c7:	eb de                	jmp    8010a7 <open+0x70>

008010c9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8010c9:	f3 0f 1e fb          	endbr32 
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8010d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d8:	b8 08 00 00 00       	mov    $0x8,%eax
  8010dd:	e8 87 fd ff ff       	call   800e69 <fsipc>
}
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

008010e4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8010e4:	f3 0f 1e fb          	endbr32 
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8010ee:	68 ff 25 80 00       	push   $0x8025ff
  8010f3:	ff 75 0c             	pushl  0xc(%ebp)
  8010f6:	e8 98 f0 ff ff       	call   800193 <strcpy>
	return 0;
}
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <devsock_close>:
{
  801102:	f3 0f 1e fb          	endbr32 
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	53                   	push   %ebx
  80110a:	83 ec 10             	sub    $0x10,%esp
  80110d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801110:	53                   	push   %ebx
  801111:	e8 49 11 00 00       	call   80225f <pageref>
  801116:	89 c2                	mov    %eax,%edx
  801118:	83 c4 10             	add    $0x10,%esp
		return 0;
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801120:	83 fa 01             	cmp    $0x1,%edx
  801123:	74 05                	je     80112a <devsock_close+0x28>
}
  801125:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801128:	c9                   	leave  
  801129:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80112a:	83 ec 0c             	sub    $0xc,%esp
  80112d:	ff 73 0c             	pushl  0xc(%ebx)
  801130:	e8 e3 02 00 00       	call   801418 <nsipc_close>
  801135:	83 c4 10             	add    $0x10,%esp
  801138:	eb eb                	jmp    801125 <devsock_close+0x23>

0080113a <devsock_write>:
{
  80113a:	f3 0f 1e fb          	endbr32 
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801144:	6a 00                	push   $0x0
  801146:	ff 75 10             	pushl  0x10(%ebp)
  801149:	ff 75 0c             	pushl  0xc(%ebp)
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	ff 70 0c             	pushl  0xc(%eax)
  801152:	e8 b5 03 00 00       	call   80150c <nsipc_send>
}
  801157:	c9                   	leave  
  801158:	c3                   	ret    

00801159 <devsock_read>:
{
  801159:	f3 0f 1e fb          	endbr32 
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801163:	6a 00                	push   $0x0
  801165:	ff 75 10             	pushl  0x10(%ebp)
  801168:	ff 75 0c             	pushl  0xc(%ebp)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	ff 70 0c             	pushl  0xc(%eax)
  801171:	e8 1f 03 00 00       	call   801495 <nsipc_recv>
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <fd2sockid>:
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80117e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801181:	52                   	push   %edx
  801182:	50                   	push   %eax
  801183:	e8 92 f7 ff ff       	call   80091a <fd_lookup>
  801188:	83 c4 10             	add    $0x10,%esp
  80118b:	85 c0                	test   %eax,%eax
  80118d:	78 10                	js     80119f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801198:	39 08                	cmp    %ecx,(%eax)
  80119a:	75 05                	jne    8011a1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80119c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    
		return -E_NOT_SUPP;
  8011a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011a6:	eb f7                	jmp    80119f <fd2sockid+0x27>

008011a8 <alloc_sockfd>:
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	56                   	push   %esi
  8011ac:	53                   	push   %ebx
  8011ad:	83 ec 1c             	sub    $0x1c,%esp
  8011b0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8011b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b5:	50                   	push   %eax
  8011b6:	e8 09 f7 ff ff       	call   8008c4 <fd_alloc>
  8011bb:	89 c3                	mov    %eax,%ebx
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	78 43                	js     801207 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8011c4:	83 ec 04             	sub    $0x4,%esp
  8011c7:	68 07 04 00 00       	push   $0x407
  8011cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8011cf:	6a 00                	push   $0x0
  8011d1:	e8 ff f3 ff ff       	call   8005d5 <sys_page_alloc>
  8011d6:	89 c3                	mov    %eax,%ebx
  8011d8:	83 c4 10             	add    $0x10,%esp
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	78 28                	js     801207 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8011df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8011e8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8011ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ed:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8011f4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8011f7:	83 ec 0c             	sub    $0xc,%esp
  8011fa:	50                   	push   %eax
  8011fb:	e8 95 f6 ff ff       	call   800895 <fd2num>
  801200:	89 c3                	mov    %eax,%ebx
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	eb 0c                	jmp    801213 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801207:	83 ec 0c             	sub    $0xc,%esp
  80120a:	56                   	push   %esi
  80120b:	e8 08 02 00 00       	call   801418 <nsipc_close>
		return r;
  801210:	83 c4 10             	add    $0x10,%esp
}
  801213:	89 d8                	mov    %ebx,%eax
  801215:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801218:	5b                   	pop    %ebx
  801219:	5e                   	pop    %esi
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    

0080121c <accept>:
{
  80121c:	f3 0f 1e fb          	endbr32 
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	e8 4a ff ff ff       	call   801178 <fd2sockid>
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 1b                	js     80124d <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801232:	83 ec 04             	sub    $0x4,%esp
  801235:	ff 75 10             	pushl  0x10(%ebp)
  801238:	ff 75 0c             	pushl  0xc(%ebp)
  80123b:	50                   	push   %eax
  80123c:	e8 22 01 00 00       	call   801363 <nsipc_accept>
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	85 c0                	test   %eax,%eax
  801246:	78 05                	js     80124d <accept+0x31>
	return alloc_sockfd(r);
  801248:	e8 5b ff ff ff       	call   8011a8 <alloc_sockfd>
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <bind>:
{
  80124f:	f3 0f 1e fb          	endbr32 
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	e8 17 ff ff ff       	call   801178 <fd2sockid>
  801261:	85 c0                	test   %eax,%eax
  801263:	78 12                	js     801277 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801265:	83 ec 04             	sub    $0x4,%esp
  801268:	ff 75 10             	pushl  0x10(%ebp)
  80126b:	ff 75 0c             	pushl  0xc(%ebp)
  80126e:	50                   	push   %eax
  80126f:	e8 45 01 00 00       	call   8013b9 <nsipc_bind>
  801274:	83 c4 10             	add    $0x10,%esp
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <shutdown>:
{
  801279:	f3 0f 1e fb          	endbr32 
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	e8 ed fe ff ff       	call   801178 <fd2sockid>
  80128b:	85 c0                	test   %eax,%eax
  80128d:	78 0f                	js     80129e <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	ff 75 0c             	pushl  0xc(%ebp)
  801295:	50                   	push   %eax
  801296:	e8 57 01 00 00       	call   8013f2 <nsipc_shutdown>
  80129b:	83 c4 10             	add    $0x10,%esp
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <connect>:
{
  8012a0:	f3 0f 1e fb          	endbr32 
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	e8 c6 fe ff ff       	call   801178 <fd2sockid>
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 12                	js     8012c8 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8012b6:	83 ec 04             	sub    $0x4,%esp
  8012b9:	ff 75 10             	pushl  0x10(%ebp)
  8012bc:	ff 75 0c             	pushl  0xc(%ebp)
  8012bf:	50                   	push   %eax
  8012c0:	e8 71 01 00 00       	call   801436 <nsipc_connect>
  8012c5:	83 c4 10             	add    $0x10,%esp
}
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <listen>:
{
  8012ca:	f3 0f 1e fb          	endbr32 
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	e8 9c fe ff ff       	call   801178 <fd2sockid>
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	78 0f                	js     8012ef <listen+0x25>
	return nsipc_listen(r, backlog);
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	e8 83 01 00 00       	call   80146f <nsipc_listen>
  8012ec:	83 c4 10             	add    $0x10,%esp
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8012f1:	f3 0f 1e fb          	endbr32 
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8012fb:	ff 75 10             	pushl  0x10(%ebp)
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	ff 75 08             	pushl  0x8(%ebp)
  801304:	e8 65 02 00 00       	call   80156e <nsipc_socket>
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	85 c0                	test   %eax,%eax
  80130e:	78 05                	js     801315 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801310:	e8 93 fe ff ff       	call   8011a8 <alloc_sockfd>
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	53                   	push   %ebx
  80131b:	83 ec 04             	sub    $0x4,%esp
  80131e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801320:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801327:	74 26                	je     80134f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801329:	6a 07                	push   $0x7
  80132b:	68 00 60 80 00       	push   $0x806000
  801330:	53                   	push   %ebx
  801331:	ff 35 04 40 80 00    	pushl  0x804004
  801337:	e8 8e 0e 00 00       	call   8021ca <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80133c:	83 c4 0c             	add    $0xc,%esp
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	e8 fb 0d 00 00       	call   802145 <ipc_recv>
}
  80134a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80134f:	83 ec 0c             	sub    $0xc,%esp
  801352:	6a 02                	push   $0x2
  801354:	e8 c9 0e 00 00       	call   802222 <ipc_find_env>
  801359:	a3 04 40 80 00       	mov    %eax,0x804004
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	eb c6                	jmp    801329 <nsipc+0x12>

00801363 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801363:	f3 0f 1e fb          	endbr32 
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	56                   	push   %esi
  80136b:	53                   	push   %ebx
  80136c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801377:	8b 06                	mov    (%esi),%eax
  801379:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80137e:	b8 01 00 00 00       	mov    $0x1,%eax
  801383:	e8 8f ff ff ff       	call   801317 <nsipc>
  801388:	89 c3                	mov    %eax,%ebx
  80138a:	85 c0                	test   %eax,%eax
  80138c:	79 09                	jns    801397 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80138e:	89 d8                	mov    %ebx,%eax
  801390:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801393:	5b                   	pop    %ebx
  801394:	5e                   	pop    %esi
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	ff 35 10 60 80 00    	pushl  0x806010
  8013a0:	68 00 60 80 00       	push   $0x806000
  8013a5:	ff 75 0c             	pushl  0xc(%ebp)
  8013a8:	e8 9c ef ff ff       	call   800349 <memmove>
		*addrlen = ret->ret_addrlen;
  8013ad:	a1 10 60 80 00       	mov    0x806010,%eax
  8013b2:	89 06                	mov    %eax,(%esi)
  8013b4:	83 c4 10             	add    $0x10,%esp
	return r;
  8013b7:	eb d5                	jmp    80138e <nsipc_accept+0x2b>

008013b9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8013b9:	f3 0f 1e fb          	endbr32 
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	53                   	push   %ebx
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8013cf:	53                   	push   %ebx
  8013d0:	ff 75 0c             	pushl  0xc(%ebp)
  8013d3:	68 04 60 80 00       	push   $0x806004
  8013d8:	e8 6c ef ff ff       	call   800349 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8013dd:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8013e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8013e8:	e8 2a ff ff ff       	call   801317 <nsipc>
}
  8013ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8013f2:	f3 0f 1e fb          	endbr32 
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801404:	8b 45 0c             	mov    0xc(%ebp),%eax
  801407:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80140c:	b8 03 00 00 00       	mov    $0x3,%eax
  801411:	e8 01 ff ff ff       	call   801317 <nsipc>
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <nsipc_close>:

int
nsipc_close(int s)
{
  801418:	f3 0f 1e fb          	endbr32 
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80142a:	b8 04 00 00 00       	mov    $0x4,%eax
  80142f:	e8 e3 fe ff ff       	call   801317 <nsipc>
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801436:	f3 0f 1e fb          	endbr32 
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80144c:	53                   	push   %ebx
  80144d:	ff 75 0c             	pushl  0xc(%ebp)
  801450:	68 04 60 80 00       	push   $0x806004
  801455:	e8 ef ee ff ff       	call   800349 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80145a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801460:	b8 05 00 00 00       	mov    $0x5,%eax
  801465:	e8 ad fe ff ff       	call   801317 <nsipc>
}
  80146a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80146f:	f3 0f 1e fb          	endbr32 
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801481:	8b 45 0c             	mov    0xc(%ebp),%eax
  801484:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801489:	b8 06 00 00 00       	mov    $0x6,%eax
  80148e:	e8 84 fe ff ff       	call   801317 <nsipc>
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801495:	f3 0f 1e fb          	endbr32 
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	56                   	push   %esi
  80149d:	53                   	push   %ebx
  80149e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8014a9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8014af:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b2:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8014b7:	b8 07 00 00 00       	mov    $0x7,%eax
  8014bc:	e8 56 fe ff ff       	call   801317 <nsipc>
  8014c1:	89 c3                	mov    %eax,%ebx
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 26                	js     8014ed <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  8014c7:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  8014cd:	b8 3f 06 00 00       	mov    $0x63f,%eax
  8014d2:	0f 4e c6             	cmovle %esi,%eax
  8014d5:	39 c3                	cmp    %eax,%ebx
  8014d7:	7f 1d                	jg     8014f6 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8014d9:	83 ec 04             	sub    $0x4,%esp
  8014dc:	53                   	push   %ebx
  8014dd:	68 00 60 80 00       	push   $0x806000
  8014e2:	ff 75 0c             	pushl  0xc(%ebp)
  8014e5:	e8 5f ee ff ff       	call   800349 <memmove>
  8014ea:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8014ed:	89 d8                	mov    %ebx,%eax
  8014ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f2:	5b                   	pop    %ebx
  8014f3:	5e                   	pop    %esi
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8014f6:	68 0b 26 80 00       	push   $0x80260b
  8014fb:	68 d3 25 80 00       	push   $0x8025d3
  801500:	6a 62                	push   $0x62
  801502:	68 20 26 80 00       	push   $0x802620
  801507:	e8 8b 05 00 00       	call   801a97 <_panic>

0080150c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80150c:	f3 0f 1e fb          	endbr32 
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	53                   	push   %ebx
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801522:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801528:	7f 2e                	jg     801558 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80152a:	83 ec 04             	sub    $0x4,%esp
  80152d:	53                   	push   %ebx
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	68 0c 60 80 00       	push   $0x80600c
  801536:	e8 0e ee ff ff       	call   800349 <memmove>
	nsipcbuf.send.req_size = size;
  80153b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801541:	8b 45 14             	mov    0x14(%ebp),%eax
  801544:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801549:	b8 08 00 00 00       	mov    $0x8,%eax
  80154e:	e8 c4 fd ff ff       	call   801317 <nsipc>
}
  801553:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801556:	c9                   	leave  
  801557:	c3                   	ret    
	assert(size < 1600);
  801558:	68 2c 26 80 00       	push   $0x80262c
  80155d:	68 d3 25 80 00       	push   $0x8025d3
  801562:	6a 6d                	push   $0x6d
  801564:	68 20 26 80 00       	push   $0x802620
  801569:	e8 29 05 00 00       	call   801a97 <_panic>

0080156e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80156e:	f3 0f 1e fb          	endbr32 
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801588:	8b 45 10             	mov    0x10(%ebp),%eax
  80158b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801590:	b8 09 00 00 00       	mov    $0x9,%eax
  801595:	e8 7d fd ff ff       	call   801317 <nsipc>
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80159c:	f3 0f 1e fb          	endbr32 
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	56                   	push   %esi
  8015a4:	53                   	push   %ebx
  8015a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8015a8:	83 ec 0c             	sub    $0xc,%esp
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	e8 f6 f2 ff ff       	call   8008a9 <fd2data>
  8015b3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8015b5:	83 c4 08             	add    $0x8,%esp
  8015b8:	68 38 26 80 00       	push   $0x802638
  8015bd:	53                   	push   %ebx
  8015be:	e8 d0 eb ff ff       	call   800193 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8015c3:	8b 46 04             	mov    0x4(%esi),%eax
  8015c6:	2b 06                	sub    (%esi),%eax
  8015c8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8015ce:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015d5:	00 00 00 
	stat->st_dev = &devpipe;
  8015d8:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8015df:	30 80 00 
	return 0;
}
  8015e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ea:	5b                   	pop    %ebx
  8015eb:	5e                   	pop    %esi
  8015ec:	5d                   	pop    %ebp
  8015ed:	c3                   	ret    

008015ee <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015ee:	f3 0f 1e fb          	endbr32 
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	53                   	push   %ebx
  8015f6:	83 ec 0c             	sub    $0xc,%esp
  8015f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015fc:	53                   	push   %ebx
  8015fd:	6a 00                	push   $0x0
  8015ff:	e8 5e f0 ff ff       	call   800662 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801604:	89 1c 24             	mov    %ebx,(%esp)
  801607:	e8 9d f2 ff ff       	call   8008a9 <fd2data>
  80160c:	83 c4 08             	add    $0x8,%esp
  80160f:	50                   	push   %eax
  801610:	6a 00                	push   $0x0
  801612:	e8 4b f0 ff ff       	call   800662 <sys_page_unmap>
}
  801617:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <_pipeisclosed>:
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	57                   	push   %edi
  801620:	56                   	push   %esi
  801621:	53                   	push   %ebx
  801622:	83 ec 1c             	sub    $0x1c,%esp
  801625:	89 c7                	mov    %eax,%edi
  801627:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801629:	a1 08 40 80 00       	mov    0x804008,%eax
  80162e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	57                   	push   %edi
  801635:	e8 25 0c 00 00       	call   80225f <pageref>
  80163a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80163d:	89 34 24             	mov    %esi,(%esp)
  801640:	e8 1a 0c 00 00       	call   80225f <pageref>
		nn = thisenv->env_runs;
  801645:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80164b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	39 cb                	cmp    %ecx,%ebx
  801653:	74 1b                	je     801670 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801655:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801658:	75 cf                	jne    801629 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80165a:	8b 42 58             	mov    0x58(%edx),%eax
  80165d:	6a 01                	push   $0x1
  80165f:	50                   	push   %eax
  801660:	53                   	push   %ebx
  801661:	68 3f 26 80 00       	push   $0x80263f
  801666:	e8 13 05 00 00       	call   801b7e <cprintf>
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	eb b9                	jmp    801629 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801670:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801673:	0f 94 c0             	sete   %al
  801676:	0f b6 c0             	movzbl %al,%eax
}
  801679:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167c:	5b                   	pop    %ebx
  80167d:	5e                   	pop    %esi
  80167e:	5f                   	pop    %edi
  80167f:	5d                   	pop    %ebp
  801680:	c3                   	ret    

00801681 <devpipe_write>:
{
  801681:	f3 0f 1e fb          	endbr32 
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	57                   	push   %edi
  801689:	56                   	push   %esi
  80168a:	53                   	push   %ebx
  80168b:	83 ec 28             	sub    $0x28,%esp
  80168e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801691:	56                   	push   %esi
  801692:	e8 12 f2 ff ff       	call   8008a9 <fd2data>
  801697:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	bf 00 00 00 00       	mov    $0x0,%edi
  8016a1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016a4:	74 4f                	je     8016f5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016a6:	8b 43 04             	mov    0x4(%ebx),%eax
  8016a9:	8b 0b                	mov    (%ebx),%ecx
  8016ab:	8d 51 20             	lea    0x20(%ecx),%edx
  8016ae:	39 d0                	cmp    %edx,%eax
  8016b0:	72 14                	jb     8016c6 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8016b2:	89 da                	mov    %ebx,%edx
  8016b4:	89 f0                	mov    %esi,%eax
  8016b6:	e8 61 ff ff ff       	call   80161c <_pipeisclosed>
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 3b                	jne    8016fa <devpipe_write+0x79>
			sys_yield();
  8016bf:	e8 ee ee ff ff       	call   8005b2 <sys_yield>
  8016c4:	eb e0                	jmp    8016a6 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8016c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016c9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8016cd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8016d0:	89 c2                	mov    %eax,%edx
  8016d2:	c1 fa 1f             	sar    $0x1f,%edx
  8016d5:	89 d1                	mov    %edx,%ecx
  8016d7:	c1 e9 1b             	shr    $0x1b,%ecx
  8016da:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016dd:	83 e2 1f             	and    $0x1f,%edx
  8016e0:	29 ca                	sub    %ecx,%edx
  8016e2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016ea:	83 c0 01             	add    $0x1,%eax
  8016ed:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8016f0:	83 c7 01             	add    $0x1,%edi
  8016f3:	eb ac                	jmp    8016a1 <devpipe_write+0x20>
	return i;
  8016f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f8:	eb 05                	jmp    8016ff <devpipe_write+0x7e>
				return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801702:	5b                   	pop    %ebx
  801703:	5e                   	pop    %esi
  801704:	5f                   	pop    %edi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    

00801707 <devpipe_read>:
{
  801707:	f3 0f 1e fb          	endbr32 
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	57                   	push   %edi
  80170f:	56                   	push   %esi
  801710:	53                   	push   %ebx
  801711:	83 ec 18             	sub    $0x18,%esp
  801714:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801717:	57                   	push   %edi
  801718:	e8 8c f1 ff ff       	call   8008a9 <fd2data>
  80171d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	be 00 00 00 00       	mov    $0x0,%esi
  801727:	3b 75 10             	cmp    0x10(%ebp),%esi
  80172a:	75 14                	jne    801740 <devpipe_read+0x39>
	return i;
  80172c:	8b 45 10             	mov    0x10(%ebp),%eax
  80172f:	eb 02                	jmp    801733 <devpipe_read+0x2c>
				return i;
  801731:	89 f0                	mov    %esi,%eax
}
  801733:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801736:	5b                   	pop    %ebx
  801737:	5e                   	pop    %esi
  801738:	5f                   	pop    %edi
  801739:	5d                   	pop    %ebp
  80173a:	c3                   	ret    
			sys_yield();
  80173b:	e8 72 ee ff ff       	call   8005b2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801740:	8b 03                	mov    (%ebx),%eax
  801742:	3b 43 04             	cmp    0x4(%ebx),%eax
  801745:	75 18                	jne    80175f <devpipe_read+0x58>
			if (i > 0)
  801747:	85 f6                	test   %esi,%esi
  801749:	75 e6                	jne    801731 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80174b:	89 da                	mov    %ebx,%edx
  80174d:	89 f8                	mov    %edi,%eax
  80174f:	e8 c8 fe ff ff       	call   80161c <_pipeisclosed>
  801754:	85 c0                	test   %eax,%eax
  801756:	74 e3                	je     80173b <devpipe_read+0x34>
				return 0;
  801758:	b8 00 00 00 00       	mov    $0x0,%eax
  80175d:	eb d4                	jmp    801733 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80175f:	99                   	cltd   
  801760:	c1 ea 1b             	shr    $0x1b,%edx
  801763:	01 d0                	add    %edx,%eax
  801765:	83 e0 1f             	and    $0x1f,%eax
  801768:	29 d0                	sub    %edx,%eax
  80176a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80176f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801772:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801775:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801778:	83 c6 01             	add    $0x1,%esi
  80177b:	eb aa                	jmp    801727 <devpipe_read+0x20>

0080177d <pipe>:
{
  80177d:	f3 0f 1e fb          	endbr32 
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	56                   	push   %esi
  801785:	53                   	push   %ebx
  801786:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801789:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178c:	50                   	push   %eax
  80178d:	e8 32 f1 ff ff       	call   8008c4 <fd_alloc>
  801792:	89 c3                	mov    %eax,%ebx
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	85 c0                	test   %eax,%eax
  801799:	0f 88 23 01 00 00    	js     8018c2 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	68 07 04 00 00       	push   $0x407
  8017a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017aa:	6a 00                	push   $0x0
  8017ac:	e8 24 ee ff ff       	call   8005d5 <sys_page_alloc>
  8017b1:	89 c3                	mov    %eax,%ebx
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	0f 88 04 01 00 00    	js     8018c2 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8017be:	83 ec 0c             	sub    $0xc,%esp
  8017c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c4:	50                   	push   %eax
  8017c5:	e8 fa f0 ff ff       	call   8008c4 <fd_alloc>
  8017ca:	89 c3                	mov    %eax,%ebx
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	0f 88 db 00 00 00    	js     8018b2 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	68 07 04 00 00       	push   $0x407
  8017df:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e2:	6a 00                	push   $0x0
  8017e4:	e8 ec ed ff ff       	call   8005d5 <sys_page_alloc>
  8017e9:	89 c3                	mov    %eax,%ebx
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	0f 88 bc 00 00 00    	js     8018b2 <pipe+0x135>
	va = fd2data(fd0);
  8017f6:	83 ec 0c             	sub    $0xc,%esp
  8017f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fc:	e8 a8 f0 ff ff       	call   8008a9 <fd2data>
  801801:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801803:	83 c4 0c             	add    $0xc,%esp
  801806:	68 07 04 00 00       	push   $0x407
  80180b:	50                   	push   %eax
  80180c:	6a 00                	push   $0x0
  80180e:	e8 c2 ed ff ff       	call   8005d5 <sys_page_alloc>
  801813:	89 c3                	mov    %eax,%ebx
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	85 c0                	test   %eax,%eax
  80181a:	0f 88 82 00 00 00    	js     8018a2 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801820:	83 ec 0c             	sub    $0xc,%esp
  801823:	ff 75 f0             	pushl  -0x10(%ebp)
  801826:	e8 7e f0 ff ff       	call   8008a9 <fd2data>
  80182b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801832:	50                   	push   %eax
  801833:	6a 00                	push   $0x0
  801835:	56                   	push   %esi
  801836:	6a 00                	push   $0x0
  801838:	e8 df ed ff ff       	call   80061c <sys_page_map>
  80183d:	89 c3                	mov    %eax,%ebx
  80183f:	83 c4 20             	add    $0x20,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	78 4e                	js     801894 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801846:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80184b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801850:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801853:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80185a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80185d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80185f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801862:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801869:	83 ec 0c             	sub    $0xc,%esp
  80186c:	ff 75 f4             	pushl  -0xc(%ebp)
  80186f:	e8 21 f0 ff ff       	call   800895 <fd2num>
  801874:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801877:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801879:	83 c4 04             	add    $0x4,%esp
  80187c:	ff 75 f0             	pushl  -0x10(%ebp)
  80187f:	e8 11 f0 ff ff       	call   800895 <fd2num>
  801884:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801887:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801892:	eb 2e                	jmp    8018c2 <pipe+0x145>
	sys_page_unmap(0, va);
  801894:	83 ec 08             	sub    $0x8,%esp
  801897:	56                   	push   %esi
  801898:	6a 00                	push   $0x0
  80189a:	e8 c3 ed ff ff       	call   800662 <sys_page_unmap>
  80189f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8018a2:	83 ec 08             	sub    $0x8,%esp
  8018a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a8:	6a 00                	push   $0x0
  8018aa:	e8 b3 ed ff ff       	call   800662 <sys_page_unmap>
  8018af:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8018b2:	83 ec 08             	sub    $0x8,%esp
  8018b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b8:	6a 00                	push   $0x0
  8018ba:	e8 a3 ed ff ff       	call   800662 <sys_page_unmap>
  8018bf:	83 c4 10             	add    $0x10,%esp
}
  8018c2:	89 d8                	mov    %ebx,%eax
  8018c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5d                   	pop    %ebp
  8018ca:	c3                   	ret    

008018cb <pipeisclosed>:
{
  8018cb:	f3 0f 1e fb          	endbr32 
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d8:	50                   	push   %eax
  8018d9:	ff 75 08             	pushl  0x8(%ebp)
  8018dc:	e8 39 f0 ff ff       	call   80091a <fd_lookup>
  8018e1:	83 c4 10             	add    $0x10,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	78 18                	js     801900 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8018e8:	83 ec 0c             	sub    $0xc,%esp
  8018eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ee:	e8 b6 ef ff ff       	call   8008a9 <fd2data>
  8018f3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8018f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f8:	e8 1f fd ff ff       	call   80161c <_pipeisclosed>
  8018fd:	83 c4 10             	add    $0x10,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801902:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
  80190b:	c3                   	ret    

0080190c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80190c:	f3 0f 1e fb          	endbr32 
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801916:	68 57 26 80 00       	push   $0x802657
  80191b:	ff 75 0c             	pushl  0xc(%ebp)
  80191e:	e8 70 e8 ff ff       	call   800193 <strcpy>
	return 0;
}
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <devcons_write>:
{
  80192a:	f3 0f 1e fb          	endbr32 
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	57                   	push   %edi
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
  801934:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80193a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80193f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801945:	3b 75 10             	cmp    0x10(%ebp),%esi
  801948:	73 31                	jae    80197b <devcons_write+0x51>
		m = n - tot;
  80194a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80194d:	29 f3                	sub    %esi,%ebx
  80194f:	83 fb 7f             	cmp    $0x7f,%ebx
  801952:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801957:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	53                   	push   %ebx
  80195e:	89 f0                	mov    %esi,%eax
  801960:	03 45 0c             	add    0xc(%ebp),%eax
  801963:	50                   	push   %eax
  801964:	57                   	push   %edi
  801965:	e8 df e9 ff ff       	call   800349 <memmove>
		sys_cputs(buf, m);
  80196a:	83 c4 08             	add    $0x8,%esp
  80196d:	53                   	push   %ebx
  80196e:	57                   	push   %edi
  80196f:	e8 91 eb ff ff       	call   800505 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801974:	01 de                	add    %ebx,%esi
  801976:	83 c4 10             	add    $0x10,%esp
  801979:	eb ca                	jmp    801945 <devcons_write+0x1b>
}
  80197b:	89 f0                	mov    %esi,%eax
  80197d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801980:	5b                   	pop    %ebx
  801981:	5e                   	pop    %esi
  801982:	5f                   	pop    %edi
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    

00801985 <devcons_read>:
{
  801985:	f3 0f 1e fb          	endbr32 
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 08             	sub    $0x8,%esp
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801994:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801998:	74 21                	je     8019bb <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80199a:	e8 88 eb ff ff       	call   800527 <sys_cgetc>
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	75 07                	jne    8019aa <devcons_read+0x25>
		sys_yield();
  8019a3:	e8 0a ec ff ff       	call   8005b2 <sys_yield>
  8019a8:	eb f0                	jmp    80199a <devcons_read+0x15>
	if (c < 0)
  8019aa:	78 0f                	js     8019bb <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8019ac:	83 f8 04             	cmp    $0x4,%eax
  8019af:	74 0c                	je     8019bd <devcons_read+0x38>
	*(char*)vbuf = c;
  8019b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b4:	88 02                	mov    %al,(%edx)
	return 1;
  8019b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    
		return 0;
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c2:	eb f7                	jmp    8019bb <devcons_read+0x36>

008019c4 <cputchar>:
{
  8019c4:	f3 0f 1e fb          	endbr32 
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8019d4:	6a 01                	push   $0x1
  8019d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019d9:	50                   	push   %eax
  8019da:	e8 26 eb ff ff       	call   800505 <sys_cputs>
}
  8019df:	83 c4 10             	add    $0x10,%esp
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <getchar>:
{
  8019e4:	f3 0f 1e fb          	endbr32 
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8019ee:	6a 01                	push   $0x1
  8019f0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019f3:	50                   	push   %eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	e8 a7 f1 ff ff       	call   800ba2 <read>
	if (r < 0)
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 06                	js     801a08 <getchar+0x24>
	if (r < 1)
  801a02:	74 06                	je     801a0a <getchar+0x26>
	return c;
  801a04:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    
		return -E_EOF;
  801a0a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a0f:	eb f7                	jmp    801a08 <getchar+0x24>

00801a11 <iscons>:
{
  801a11:	f3 0f 1e fb          	endbr32 
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1e:	50                   	push   %eax
  801a1f:	ff 75 08             	pushl  0x8(%ebp)
  801a22:	e8 f3 ee ff ff       	call   80091a <fd_lookup>
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 11                	js     801a3f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a31:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801a37:	39 10                	cmp    %edx,(%eax)
  801a39:	0f 94 c0             	sete   %al
  801a3c:	0f b6 c0             	movzbl %al,%eax
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <opencons>:
{
  801a41:	f3 0f 1e fb          	endbr32 
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4e:	50                   	push   %eax
  801a4f:	e8 70 ee ff ff       	call   8008c4 <fd_alloc>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	85 c0                	test   %eax,%eax
  801a59:	78 3a                	js     801a95 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	68 07 04 00 00       	push   $0x407
  801a63:	ff 75 f4             	pushl  -0xc(%ebp)
  801a66:	6a 00                	push   $0x0
  801a68:	e8 68 eb ff ff       	call   8005d5 <sys_page_alloc>
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	85 c0                	test   %eax,%eax
  801a72:	78 21                	js     801a95 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801a7d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a89:	83 ec 0c             	sub    $0xc,%esp
  801a8c:	50                   	push   %eax
  801a8d:	e8 03 ee ff ff       	call   800895 <fd2num>
  801a92:	83 c4 10             	add    $0x10,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a97:	f3 0f 1e fb          	endbr32 
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	56                   	push   %esi
  801a9f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801aa0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801aa3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801aa9:	e8 e1 ea ff ff       	call   80058f <sys_getenvid>
  801aae:	83 ec 0c             	sub    $0xc,%esp
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	ff 75 08             	pushl  0x8(%ebp)
  801ab7:	56                   	push   %esi
  801ab8:	50                   	push   %eax
  801ab9:	68 64 26 80 00       	push   $0x802664
  801abe:	e8 bb 00 00 00       	call   801b7e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ac3:	83 c4 18             	add    $0x18,%esp
  801ac6:	53                   	push   %ebx
  801ac7:	ff 75 10             	pushl  0x10(%ebp)
  801aca:	e8 5a 00 00 00       	call   801b29 <vcprintf>
	cprintf("\n");
  801acf:	c7 04 24 98 29 80 00 	movl   $0x802998,(%esp)
  801ad6:	e8 a3 00 00 00       	call   801b7e <cprintf>
  801adb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ade:	cc                   	int3   
  801adf:	eb fd                	jmp    801ade <_panic+0x47>

00801ae1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801ae1:	f3 0f 1e fb          	endbr32 
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	53                   	push   %ebx
  801ae9:	83 ec 04             	sub    $0x4,%esp
  801aec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801aef:	8b 13                	mov    (%ebx),%edx
  801af1:	8d 42 01             	lea    0x1(%edx),%eax
  801af4:	89 03                	mov    %eax,(%ebx)
  801af6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801afd:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b02:	74 09                	je     801b0d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801b04:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801b08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	68 ff 00 00 00       	push   $0xff
  801b15:	8d 43 08             	lea    0x8(%ebx),%eax
  801b18:	50                   	push   %eax
  801b19:	e8 e7 e9 ff ff       	call   800505 <sys_cputs>
		b->idx = 0;
  801b1e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	eb db                	jmp    801b04 <putch+0x23>

00801b29 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801b29:	f3 0f 1e fb          	endbr32 
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801b36:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b3d:	00 00 00 
	b.cnt = 0;
  801b40:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801b47:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	ff 75 08             	pushl  0x8(%ebp)
  801b50:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801b56:	50                   	push   %eax
  801b57:	68 e1 1a 80 00       	push   $0x801ae1
  801b5c:	e8 20 01 00 00       	call   801c81 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801b61:	83 c4 08             	add    $0x8,%esp
  801b64:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801b6a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801b70:	50                   	push   %eax
  801b71:	e8 8f e9 ff ff       	call   800505 <sys_cputs>

	return b.cnt;
}
  801b76:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801b7e:	f3 0f 1e fb          	endbr32 
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b88:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801b8b:	50                   	push   %eax
  801b8c:	ff 75 08             	pushl  0x8(%ebp)
  801b8f:	e8 95 ff ff ff       	call   801b29 <vcprintf>
	va_end(ap);

	return cnt;
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	57                   	push   %edi
  801b9a:	56                   	push   %esi
  801b9b:	53                   	push   %ebx
  801b9c:	83 ec 1c             	sub    $0x1c,%esp
  801b9f:	89 c7                	mov    %eax,%edi
  801ba1:	89 d6                	mov    %edx,%esi
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba9:	89 d1                	mov    %edx,%ecx
  801bab:	89 c2                	mov    %eax,%edx
  801bad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801bb0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801bb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bbc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801bc3:	39 c2                	cmp    %eax,%edx
  801bc5:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801bc8:	72 3e                	jb     801c08 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801bca:	83 ec 0c             	sub    $0xc,%esp
  801bcd:	ff 75 18             	pushl  0x18(%ebp)
  801bd0:	83 eb 01             	sub    $0x1,%ebx
  801bd3:	53                   	push   %ebx
  801bd4:	50                   	push   %eax
  801bd5:	83 ec 08             	sub    $0x8,%esp
  801bd8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bdb:	ff 75 e0             	pushl  -0x20(%ebp)
  801bde:	ff 75 dc             	pushl  -0x24(%ebp)
  801be1:	ff 75 d8             	pushl  -0x28(%ebp)
  801be4:	e8 b7 06 00 00       	call   8022a0 <__udivdi3>
  801be9:	83 c4 18             	add    $0x18,%esp
  801bec:	52                   	push   %edx
  801bed:	50                   	push   %eax
  801bee:	89 f2                	mov    %esi,%edx
  801bf0:	89 f8                	mov    %edi,%eax
  801bf2:	e8 9f ff ff ff       	call   801b96 <printnum>
  801bf7:	83 c4 20             	add    $0x20,%esp
  801bfa:	eb 13                	jmp    801c0f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801bfc:	83 ec 08             	sub    $0x8,%esp
  801bff:	56                   	push   %esi
  801c00:	ff 75 18             	pushl  0x18(%ebp)
  801c03:	ff d7                	call   *%edi
  801c05:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801c08:	83 eb 01             	sub    $0x1,%ebx
  801c0b:	85 db                	test   %ebx,%ebx
  801c0d:	7f ed                	jg     801bfc <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801c0f:	83 ec 08             	sub    $0x8,%esp
  801c12:	56                   	push   %esi
  801c13:	83 ec 04             	sub    $0x4,%esp
  801c16:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c19:	ff 75 e0             	pushl  -0x20(%ebp)
  801c1c:	ff 75 dc             	pushl  -0x24(%ebp)
  801c1f:	ff 75 d8             	pushl  -0x28(%ebp)
  801c22:	e8 89 07 00 00       	call   8023b0 <__umoddi3>
  801c27:	83 c4 14             	add    $0x14,%esp
  801c2a:	0f be 80 87 26 80 00 	movsbl 0x802687(%eax),%eax
  801c31:	50                   	push   %eax
  801c32:	ff d7                	call   *%edi
}
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3a:	5b                   	pop    %ebx
  801c3b:	5e                   	pop    %esi
  801c3c:	5f                   	pop    %edi
  801c3d:	5d                   	pop    %ebp
  801c3e:	c3                   	ret    

00801c3f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801c3f:	f3 0f 1e fb          	endbr32 
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801c49:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801c4d:	8b 10                	mov    (%eax),%edx
  801c4f:	3b 50 04             	cmp    0x4(%eax),%edx
  801c52:	73 0a                	jae    801c5e <sprintputch+0x1f>
		*b->buf++ = ch;
  801c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c57:	89 08                	mov    %ecx,(%eax)
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	88 02                	mov    %al,(%edx)
}
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    

00801c60 <printfmt>:
{
  801c60:	f3 0f 1e fb          	endbr32 
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801c6a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801c6d:	50                   	push   %eax
  801c6e:	ff 75 10             	pushl  0x10(%ebp)
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	e8 05 00 00 00       	call   801c81 <vprintfmt>
}
  801c7c:	83 c4 10             	add    $0x10,%esp
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <vprintfmt>:
{
  801c81:	f3 0f 1e fb          	endbr32 
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	57                   	push   %edi
  801c89:	56                   	push   %esi
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 3c             	sub    $0x3c,%esp
  801c8e:	8b 75 08             	mov    0x8(%ebp),%esi
  801c91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801c94:	8b 7d 10             	mov    0x10(%ebp),%edi
  801c97:	e9 8e 03 00 00       	jmp    80202a <vprintfmt+0x3a9>
		padc = ' ';
  801c9c:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801ca0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801ca7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801cae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801cb5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801cba:	8d 47 01             	lea    0x1(%edi),%eax
  801cbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cc0:	0f b6 17             	movzbl (%edi),%edx
  801cc3:	8d 42 dd             	lea    -0x23(%edx),%eax
  801cc6:	3c 55                	cmp    $0x55,%al
  801cc8:	0f 87 df 03 00 00    	ja     8020ad <vprintfmt+0x42c>
  801cce:	0f b6 c0             	movzbl %al,%eax
  801cd1:	3e ff 24 85 c0 27 80 	notrack jmp *0x8027c0(,%eax,4)
  801cd8:	00 
  801cd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801cdc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801ce0:	eb d8                	jmp    801cba <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801ce2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801ce5:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801ce9:	eb cf                	jmp    801cba <vprintfmt+0x39>
  801ceb:	0f b6 d2             	movzbl %dl,%edx
  801cee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801cf9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801cfc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801d00:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801d03:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801d06:	83 f9 09             	cmp    $0x9,%ecx
  801d09:	77 55                	ja     801d60 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801d0b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801d0e:	eb e9                	jmp    801cf9 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801d10:	8b 45 14             	mov    0x14(%ebp),%eax
  801d13:	8b 00                	mov    (%eax),%eax
  801d15:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d18:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1b:	8d 40 04             	lea    0x4(%eax),%eax
  801d1e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801d21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801d24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d28:	79 90                	jns    801cba <vprintfmt+0x39>
				width = precision, precision = -1;
  801d2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d30:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801d37:	eb 81                	jmp    801cba <vprintfmt+0x39>
  801d39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d43:	0f 49 d0             	cmovns %eax,%edx
  801d46:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801d49:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801d4c:	e9 69 ff ff ff       	jmp    801cba <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801d51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801d54:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801d5b:	e9 5a ff ff ff       	jmp    801cba <vprintfmt+0x39>
  801d60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801d63:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d66:	eb bc                	jmp    801d24 <vprintfmt+0xa3>
			lflag++;
  801d68:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801d6b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801d6e:	e9 47 ff ff ff       	jmp    801cba <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801d73:	8b 45 14             	mov    0x14(%ebp),%eax
  801d76:	8d 78 04             	lea    0x4(%eax),%edi
  801d79:	83 ec 08             	sub    $0x8,%esp
  801d7c:	53                   	push   %ebx
  801d7d:	ff 30                	pushl  (%eax)
  801d7f:	ff d6                	call   *%esi
			break;
  801d81:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801d84:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801d87:	e9 9b 02 00 00       	jmp    802027 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8f:	8d 78 04             	lea    0x4(%eax),%edi
  801d92:	8b 00                	mov    (%eax),%eax
  801d94:	99                   	cltd   
  801d95:	31 d0                	xor    %edx,%eax
  801d97:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801d99:	83 f8 0f             	cmp    $0xf,%eax
  801d9c:	7f 23                	jg     801dc1 <vprintfmt+0x140>
  801d9e:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  801da5:	85 d2                	test   %edx,%edx
  801da7:	74 18                	je     801dc1 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801da9:	52                   	push   %edx
  801daa:	68 e5 25 80 00       	push   $0x8025e5
  801daf:	53                   	push   %ebx
  801db0:	56                   	push   %esi
  801db1:	e8 aa fe ff ff       	call   801c60 <printfmt>
  801db6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801db9:	89 7d 14             	mov    %edi,0x14(%ebp)
  801dbc:	e9 66 02 00 00       	jmp    802027 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801dc1:	50                   	push   %eax
  801dc2:	68 9f 26 80 00       	push   $0x80269f
  801dc7:	53                   	push   %ebx
  801dc8:	56                   	push   %esi
  801dc9:	e8 92 fe ff ff       	call   801c60 <printfmt>
  801dce:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801dd1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801dd4:	e9 4e 02 00 00       	jmp    802027 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801dd9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ddc:	83 c0 04             	add    $0x4,%eax
  801ddf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801de2:	8b 45 14             	mov    0x14(%ebp),%eax
  801de5:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801de7:	85 d2                	test   %edx,%edx
  801de9:	b8 98 26 80 00       	mov    $0x802698,%eax
  801dee:	0f 45 c2             	cmovne %edx,%eax
  801df1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801df4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801df8:	7e 06                	jle    801e00 <vprintfmt+0x17f>
  801dfa:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801dfe:	75 0d                	jne    801e0d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e03:	89 c7                	mov    %eax,%edi
  801e05:	03 45 e0             	add    -0x20(%ebp),%eax
  801e08:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e0b:	eb 55                	jmp    801e62 <vprintfmt+0x1e1>
  801e0d:	83 ec 08             	sub    $0x8,%esp
  801e10:	ff 75 d8             	pushl  -0x28(%ebp)
  801e13:	ff 75 cc             	pushl  -0x34(%ebp)
  801e16:	e8 51 e3 ff ff       	call   80016c <strnlen>
  801e1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e1e:	29 c2                	sub    %eax,%edx
  801e20:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801e28:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801e2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801e2f:	85 ff                	test   %edi,%edi
  801e31:	7e 11                	jle    801e44 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801e33:	83 ec 08             	sub    $0x8,%esp
  801e36:	53                   	push   %ebx
  801e37:	ff 75 e0             	pushl  -0x20(%ebp)
  801e3a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801e3c:	83 ef 01             	sub    $0x1,%edi
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	eb eb                	jmp    801e2f <vprintfmt+0x1ae>
  801e44:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801e47:	85 d2                	test   %edx,%edx
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4e:	0f 49 c2             	cmovns %edx,%eax
  801e51:	29 c2                	sub    %eax,%edx
  801e53:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801e56:	eb a8                	jmp    801e00 <vprintfmt+0x17f>
					putch(ch, putdat);
  801e58:	83 ec 08             	sub    $0x8,%esp
  801e5b:	53                   	push   %ebx
  801e5c:	52                   	push   %edx
  801e5d:	ff d6                	call   *%esi
  801e5f:	83 c4 10             	add    $0x10,%esp
  801e62:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801e65:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e67:	83 c7 01             	add    $0x1,%edi
  801e6a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801e6e:	0f be d0             	movsbl %al,%edx
  801e71:	85 d2                	test   %edx,%edx
  801e73:	74 4b                	je     801ec0 <vprintfmt+0x23f>
  801e75:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801e79:	78 06                	js     801e81 <vprintfmt+0x200>
  801e7b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801e7f:	78 1e                	js     801e9f <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801e81:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e85:	74 d1                	je     801e58 <vprintfmt+0x1d7>
  801e87:	0f be c0             	movsbl %al,%eax
  801e8a:	83 e8 20             	sub    $0x20,%eax
  801e8d:	83 f8 5e             	cmp    $0x5e,%eax
  801e90:	76 c6                	jbe    801e58 <vprintfmt+0x1d7>
					putch('?', putdat);
  801e92:	83 ec 08             	sub    $0x8,%esp
  801e95:	53                   	push   %ebx
  801e96:	6a 3f                	push   $0x3f
  801e98:	ff d6                	call   *%esi
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	eb c3                	jmp    801e62 <vprintfmt+0x1e1>
  801e9f:	89 cf                	mov    %ecx,%edi
  801ea1:	eb 0e                	jmp    801eb1 <vprintfmt+0x230>
				putch(' ', putdat);
  801ea3:	83 ec 08             	sub    $0x8,%esp
  801ea6:	53                   	push   %ebx
  801ea7:	6a 20                	push   $0x20
  801ea9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801eab:	83 ef 01             	sub    $0x1,%edi
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	85 ff                	test   %edi,%edi
  801eb3:	7f ee                	jg     801ea3 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801eb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801eb8:	89 45 14             	mov    %eax,0x14(%ebp)
  801ebb:	e9 67 01 00 00       	jmp    802027 <vprintfmt+0x3a6>
  801ec0:	89 cf                	mov    %ecx,%edi
  801ec2:	eb ed                	jmp    801eb1 <vprintfmt+0x230>
	if (lflag >= 2)
  801ec4:	83 f9 01             	cmp    $0x1,%ecx
  801ec7:	7f 1b                	jg     801ee4 <vprintfmt+0x263>
	else if (lflag)
  801ec9:	85 c9                	test   %ecx,%ecx
  801ecb:	74 63                	je     801f30 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed0:	8b 00                	mov    (%eax),%eax
  801ed2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ed5:	99                   	cltd   
  801ed6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801ed9:	8b 45 14             	mov    0x14(%ebp),%eax
  801edc:	8d 40 04             	lea    0x4(%eax),%eax
  801edf:	89 45 14             	mov    %eax,0x14(%ebp)
  801ee2:	eb 17                	jmp    801efb <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801ee4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee7:	8b 50 04             	mov    0x4(%eax),%edx
  801eea:	8b 00                	mov    (%eax),%eax
  801eec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801eef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801ef2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef5:	8d 40 08             	lea    0x8(%eax),%eax
  801ef8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801efb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801efe:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801f01:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801f06:	85 c9                	test   %ecx,%ecx
  801f08:	0f 89 ff 00 00 00    	jns    80200d <vprintfmt+0x38c>
				putch('-', putdat);
  801f0e:	83 ec 08             	sub    $0x8,%esp
  801f11:	53                   	push   %ebx
  801f12:	6a 2d                	push   $0x2d
  801f14:	ff d6                	call   *%esi
				num = -(long long) num;
  801f16:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f19:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801f1c:	f7 da                	neg    %edx
  801f1e:	83 d1 00             	adc    $0x0,%ecx
  801f21:	f7 d9                	neg    %ecx
  801f23:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801f26:	b8 0a 00 00 00       	mov    $0xa,%eax
  801f2b:	e9 dd 00 00 00       	jmp    80200d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801f30:	8b 45 14             	mov    0x14(%ebp),%eax
  801f33:	8b 00                	mov    (%eax),%eax
  801f35:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f38:	99                   	cltd   
  801f39:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3f:	8d 40 04             	lea    0x4(%eax),%eax
  801f42:	89 45 14             	mov    %eax,0x14(%ebp)
  801f45:	eb b4                	jmp    801efb <vprintfmt+0x27a>
	if (lflag >= 2)
  801f47:	83 f9 01             	cmp    $0x1,%ecx
  801f4a:	7f 1e                	jg     801f6a <vprintfmt+0x2e9>
	else if (lflag)
  801f4c:	85 c9                	test   %ecx,%ecx
  801f4e:	74 32                	je     801f82 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801f50:	8b 45 14             	mov    0x14(%ebp),%eax
  801f53:	8b 10                	mov    (%eax),%edx
  801f55:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f5a:	8d 40 04             	lea    0x4(%eax),%eax
  801f5d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801f60:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801f65:	e9 a3 00 00 00       	jmp    80200d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f6d:	8b 10                	mov    (%eax),%edx
  801f6f:	8b 48 04             	mov    0x4(%eax),%ecx
  801f72:	8d 40 08             	lea    0x8(%eax),%eax
  801f75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801f78:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801f7d:	e9 8b 00 00 00       	jmp    80200d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801f82:	8b 45 14             	mov    0x14(%ebp),%eax
  801f85:	8b 10                	mov    (%eax),%edx
  801f87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f8c:	8d 40 04             	lea    0x4(%eax),%eax
  801f8f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801f92:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801f97:	eb 74                	jmp    80200d <vprintfmt+0x38c>
	if (lflag >= 2)
  801f99:	83 f9 01             	cmp    $0x1,%ecx
  801f9c:	7f 1b                	jg     801fb9 <vprintfmt+0x338>
	else if (lflag)
  801f9e:	85 c9                	test   %ecx,%ecx
  801fa0:	74 2c                	je     801fce <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801fa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa5:	8b 10                	mov    (%eax),%edx
  801fa7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fac:	8d 40 04             	lea    0x4(%eax),%eax
  801faf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801fb2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801fb7:	eb 54                	jmp    80200d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fbc:	8b 10                	mov    (%eax),%edx
  801fbe:	8b 48 04             	mov    0x4(%eax),%ecx
  801fc1:	8d 40 08             	lea    0x8(%eax),%eax
  801fc4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801fc7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801fcc:	eb 3f                	jmp    80200d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801fce:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd1:	8b 10                	mov    (%eax),%edx
  801fd3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fd8:	8d 40 04             	lea    0x4(%eax),%eax
  801fdb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801fde:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801fe3:	eb 28                	jmp    80200d <vprintfmt+0x38c>
			putch('0', putdat);
  801fe5:	83 ec 08             	sub    $0x8,%esp
  801fe8:	53                   	push   %ebx
  801fe9:	6a 30                	push   $0x30
  801feb:	ff d6                	call   *%esi
			putch('x', putdat);
  801fed:	83 c4 08             	add    $0x8,%esp
  801ff0:	53                   	push   %ebx
  801ff1:	6a 78                	push   $0x78
  801ff3:	ff d6                	call   *%esi
			num = (unsigned long long)
  801ff5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff8:	8b 10                	mov    (%eax),%edx
  801ffa:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801fff:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  802002:	8d 40 04             	lea    0x4(%eax),%eax
  802005:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802008:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  802014:	57                   	push   %edi
  802015:	ff 75 e0             	pushl  -0x20(%ebp)
  802018:	50                   	push   %eax
  802019:	51                   	push   %ecx
  80201a:	52                   	push   %edx
  80201b:	89 da                	mov    %ebx,%edx
  80201d:	89 f0                	mov    %esi,%eax
  80201f:	e8 72 fb ff ff       	call   801b96 <printnum>
			break;
  802024:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  802027:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80202a:	83 c7 01             	add    $0x1,%edi
  80202d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802031:	83 f8 25             	cmp    $0x25,%eax
  802034:	0f 84 62 fc ff ff    	je     801c9c <vprintfmt+0x1b>
			if (ch == '\0')
  80203a:	85 c0                	test   %eax,%eax
  80203c:	0f 84 8b 00 00 00    	je     8020cd <vprintfmt+0x44c>
			putch(ch, putdat);
  802042:	83 ec 08             	sub    $0x8,%esp
  802045:	53                   	push   %ebx
  802046:	50                   	push   %eax
  802047:	ff d6                	call   *%esi
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	eb dc                	jmp    80202a <vprintfmt+0x3a9>
	if (lflag >= 2)
  80204e:	83 f9 01             	cmp    $0x1,%ecx
  802051:	7f 1b                	jg     80206e <vprintfmt+0x3ed>
	else if (lflag)
  802053:	85 c9                	test   %ecx,%ecx
  802055:	74 2c                	je     802083 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  802057:	8b 45 14             	mov    0x14(%ebp),%eax
  80205a:	8b 10                	mov    (%eax),%edx
  80205c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802061:	8d 40 04             	lea    0x4(%eax),%eax
  802064:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802067:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80206c:	eb 9f                	jmp    80200d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80206e:	8b 45 14             	mov    0x14(%ebp),%eax
  802071:	8b 10                	mov    (%eax),%edx
  802073:	8b 48 04             	mov    0x4(%eax),%ecx
  802076:	8d 40 08             	lea    0x8(%eax),%eax
  802079:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80207c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  802081:	eb 8a                	jmp    80200d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  802083:	8b 45 14             	mov    0x14(%ebp),%eax
  802086:	8b 10                	mov    (%eax),%edx
  802088:	b9 00 00 00 00       	mov    $0x0,%ecx
  80208d:	8d 40 04             	lea    0x4(%eax),%eax
  802090:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802093:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  802098:	e9 70 ff ff ff       	jmp    80200d <vprintfmt+0x38c>
			putch(ch, putdat);
  80209d:	83 ec 08             	sub    $0x8,%esp
  8020a0:	53                   	push   %ebx
  8020a1:	6a 25                	push   $0x25
  8020a3:	ff d6                	call   *%esi
			break;
  8020a5:	83 c4 10             	add    $0x10,%esp
  8020a8:	e9 7a ff ff ff       	jmp    802027 <vprintfmt+0x3a6>
			putch('%', putdat);
  8020ad:	83 ec 08             	sub    $0x8,%esp
  8020b0:	53                   	push   %ebx
  8020b1:	6a 25                	push   $0x25
  8020b3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	89 f8                	mov    %edi,%eax
  8020ba:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8020be:	74 05                	je     8020c5 <vprintfmt+0x444>
  8020c0:	83 e8 01             	sub    $0x1,%eax
  8020c3:	eb f5                	jmp    8020ba <vprintfmt+0x439>
  8020c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020c8:	e9 5a ff ff ff       	jmp    802027 <vprintfmt+0x3a6>
}
  8020cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d0:	5b                   	pop    %ebx
  8020d1:	5e                   	pop    %esi
  8020d2:	5f                   	pop    %edi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    

008020d5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8020d5:	f3 0f 1e fb          	endbr32 
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 18             	sub    $0x18,%esp
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8020e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020e8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8020ec:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8020ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 26                	je     802120 <vsnprintf+0x4b>
  8020fa:	85 d2                	test   %edx,%edx
  8020fc:	7e 22                	jle    802120 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8020fe:	ff 75 14             	pushl  0x14(%ebp)
  802101:	ff 75 10             	pushl  0x10(%ebp)
  802104:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802107:	50                   	push   %eax
  802108:	68 3f 1c 80 00       	push   $0x801c3f
  80210d:	e8 6f fb ff ff       	call   801c81 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802112:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802115:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	83 c4 10             	add    $0x10,%esp
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    
		return -E_INVAL;
  802120:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802125:	eb f7                	jmp    80211e <vsnprintf+0x49>

00802127 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802127:	f3 0f 1e fb          	endbr32 
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802131:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802134:	50                   	push   %eax
  802135:	ff 75 10             	pushl  0x10(%ebp)
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	ff 75 08             	pushl  0x8(%ebp)
  80213e:	e8 92 ff ff ff       	call   8020d5 <vsnprintf>
	va_end(ap);

	return rc;
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802145:	f3 0f 1e fb          	endbr32 
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
  80214e:	8b 75 08             	mov    0x8(%ebp),%esi
  802151:	8b 45 0c             	mov    0xc(%ebp),%eax
  802154:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802157:	85 c0                	test   %eax,%eax
  802159:	74 3d                	je     802198 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	50                   	push   %eax
  80215f:	e8 3d e6 ff ff       	call   8007a1 <sys_ipc_recv>
  802164:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802167:	85 f6                	test   %esi,%esi
  802169:	74 0b                	je     802176 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80216b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802171:	8b 52 74             	mov    0x74(%edx),%edx
  802174:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802176:	85 db                	test   %ebx,%ebx
  802178:	74 0b                	je     802185 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80217a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802180:	8b 52 78             	mov    0x78(%edx),%edx
  802183:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802185:	85 c0                	test   %eax,%eax
  802187:	78 21                	js     8021aa <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802189:	a1 08 40 80 00       	mov    0x804008,%eax
  80218e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802191:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802198:	83 ec 0c             	sub    $0xc,%esp
  80219b:	68 00 00 c0 ee       	push   $0xeec00000
  8021a0:	e8 fc e5 ff ff       	call   8007a1 <sys_ipc_recv>
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	eb bd                	jmp    802167 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8021aa:	85 f6                	test   %esi,%esi
  8021ac:	74 10                	je     8021be <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8021ae:	85 db                	test   %ebx,%ebx
  8021b0:	75 df                	jne    802191 <ipc_recv+0x4c>
  8021b2:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021b9:	00 00 00 
  8021bc:	eb d3                	jmp    802191 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8021be:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021c5:	00 00 00 
  8021c8:	eb e4                	jmp    8021ae <ipc_recv+0x69>

008021ca <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021ca:	f3 0f 1e fb          	endbr32 
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 0c             	sub    $0xc,%esp
  8021d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021da:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8021e0:	85 db                	test   %ebx,%ebx
  8021e2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021e7:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8021ea:	ff 75 14             	pushl  0x14(%ebp)
  8021ed:	53                   	push   %ebx
  8021ee:	56                   	push   %esi
  8021ef:	57                   	push   %edi
  8021f0:	e8 85 e5 ff ff       	call   80077a <sys_ipc_try_send>
  8021f5:	83 c4 10             	add    $0x10,%esp
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	79 1e                	jns    80221a <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8021fc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021ff:	75 07                	jne    802208 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802201:	e8 ac e3 ff ff       	call   8005b2 <sys_yield>
  802206:	eb e2                	jmp    8021ea <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802208:	50                   	push   %eax
  802209:	68 7f 29 80 00       	push   $0x80297f
  80220e:	6a 59                	push   $0x59
  802210:	68 9a 29 80 00       	push   $0x80299a
  802215:	e8 7d f8 ff ff       	call   801a97 <_panic>
	}
}
  80221a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80221d:	5b                   	pop    %ebx
  80221e:	5e                   	pop    %esi
  80221f:	5f                   	pop    %edi
  802220:	5d                   	pop    %ebp
  802221:	c3                   	ret    

00802222 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802222:	f3 0f 1e fb          	endbr32 
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802231:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802234:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80223a:	8b 52 50             	mov    0x50(%edx),%edx
  80223d:	39 ca                	cmp    %ecx,%edx
  80223f:	74 11                	je     802252 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802241:	83 c0 01             	add    $0x1,%eax
  802244:	3d 00 04 00 00       	cmp    $0x400,%eax
  802249:	75 e6                	jne    802231 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80224b:	b8 00 00 00 00       	mov    $0x0,%eax
  802250:	eb 0b                	jmp    80225d <ipc_find_env+0x3b>
			return envs[i].env_id;
  802252:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802255:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80225a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80225d:	5d                   	pop    %ebp
  80225e:	c3                   	ret    

0080225f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80225f:	f3 0f 1e fb          	endbr32 
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802269:	89 c2                	mov    %eax,%edx
  80226b:	c1 ea 16             	shr    $0x16,%edx
  80226e:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802275:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80227a:	f6 c1 01             	test   $0x1,%cl
  80227d:	74 1c                	je     80229b <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80227f:	c1 e8 0c             	shr    $0xc,%eax
  802282:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802289:	a8 01                	test   $0x1,%al
  80228b:	74 0e                	je     80229b <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80228d:	c1 e8 0c             	shr    $0xc,%eax
  802290:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802297:	ef 
  802298:	0f b7 d2             	movzwl %dx,%edx
}
  80229b:	89 d0                	mov    %edx,%eax
  80229d:	5d                   	pop    %ebp
  80229e:	c3                   	ret    
  80229f:	90                   	nop

008022a0 <__udivdi3>:
  8022a0:	f3 0f 1e fb          	endbr32 
  8022a4:	55                   	push   %ebp
  8022a5:	57                   	push   %edi
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 1c             	sub    $0x1c,%esp
  8022ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022bb:	85 d2                	test   %edx,%edx
  8022bd:	75 19                	jne    8022d8 <__udivdi3+0x38>
  8022bf:	39 f3                	cmp    %esi,%ebx
  8022c1:	76 4d                	jbe    802310 <__udivdi3+0x70>
  8022c3:	31 ff                	xor    %edi,%edi
  8022c5:	89 e8                	mov    %ebp,%eax
  8022c7:	89 f2                	mov    %esi,%edx
  8022c9:	f7 f3                	div    %ebx
  8022cb:	89 fa                	mov    %edi,%edx
  8022cd:	83 c4 1c             	add    $0x1c,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
  8022d5:	8d 76 00             	lea    0x0(%esi),%esi
  8022d8:	39 f2                	cmp    %esi,%edx
  8022da:	76 14                	jbe    8022f0 <__udivdi3+0x50>
  8022dc:	31 ff                	xor    %edi,%edi
  8022de:	31 c0                	xor    %eax,%eax
  8022e0:	89 fa                	mov    %edi,%edx
  8022e2:	83 c4 1c             	add    $0x1c,%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
  8022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f0:	0f bd fa             	bsr    %edx,%edi
  8022f3:	83 f7 1f             	xor    $0x1f,%edi
  8022f6:	75 48                	jne    802340 <__udivdi3+0xa0>
  8022f8:	39 f2                	cmp    %esi,%edx
  8022fa:	72 06                	jb     802302 <__udivdi3+0x62>
  8022fc:	31 c0                	xor    %eax,%eax
  8022fe:	39 eb                	cmp    %ebp,%ebx
  802300:	77 de                	ja     8022e0 <__udivdi3+0x40>
  802302:	b8 01 00 00 00       	mov    $0x1,%eax
  802307:	eb d7                	jmp    8022e0 <__udivdi3+0x40>
  802309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802310:	89 d9                	mov    %ebx,%ecx
  802312:	85 db                	test   %ebx,%ebx
  802314:	75 0b                	jne    802321 <__udivdi3+0x81>
  802316:	b8 01 00 00 00       	mov    $0x1,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	f7 f3                	div    %ebx
  80231f:	89 c1                	mov    %eax,%ecx
  802321:	31 d2                	xor    %edx,%edx
  802323:	89 f0                	mov    %esi,%eax
  802325:	f7 f1                	div    %ecx
  802327:	89 c6                	mov    %eax,%esi
  802329:	89 e8                	mov    %ebp,%eax
  80232b:	89 f7                	mov    %esi,%edi
  80232d:	f7 f1                	div    %ecx
  80232f:	89 fa                	mov    %edi,%edx
  802331:	83 c4 1c             	add    $0x1c,%esp
  802334:	5b                   	pop    %ebx
  802335:	5e                   	pop    %esi
  802336:	5f                   	pop    %edi
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    
  802339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802340:	89 f9                	mov    %edi,%ecx
  802342:	b8 20 00 00 00       	mov    $0x20,%eax
  802347:	29 f8                	sub    %edi,%eax
  802349:	d3 e2                	shl    %cl,%edx
  80234b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80234f:	89 c1                	mov    %eax,%ecx
  802351:	89 da                	mov    %ebx,%edx
  802353:	d3 ea                	shr    %cl,%edx
  802355:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802359:	09 d1                	or     %edx,%ecx
  80235b:	89 f2                	mov    %esi,%edx
  80235d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802361:	89 f9                	mov    %edi,%ecx
  802363:	d3 e3                	shl    %cl,%ebx
  802365:	89 c1                	mov    %eax,%ecx
  802367:	d3 ea                	shr    %cl,%edx
  802369:	89 f9                	mov    %edi,%ecx
  80236b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80236f:	89 eb                	mov    %ebp,%ebx
  802371:	d3 e6                	shl    %cl,%esi
  802373:	89 c1                	mov    %eax,%ecx
  802375:	d3 eb                	shr    %cl,%ebx
  802377:	09 de                	or     %ebx,%esi
  802379:	89 f0                	mov    %esi,%eax
  80237b:	f7 74 24 08          	divl   0x8(%esp)
  80237f:	89 d6                	mov    %edx,%esi
  802381:	89 c3                	mov    %eax,%ebx
  802383:	f7 64 24 0c          	mull   0xc(%esp)
  802387:	39 d6                	cmp    %edx,%esi
  802389:	72 15                	jb     8023a0 <__udivdi3+0x100>
  80238b:	89 f9                	mov    %edi,%ecx
  80238d:	d3 e5                	shl    %cl,%ebp
  80238f:	39 c5                	cmp    %eax,%ebp
  802391:	73 04                	jae    802397 <__udivdi3+0xf7>
  802393:	39 d6                	cmp    %edx,%esi
  802395:	74 09                	je     8023a0 <__udivdi3+0x100>
  802397:	89 d8                	mov    %ebx,%eax
  802399:	31 ff                	xor    %edi,%edi
  80239b:	e9 40 ff ff ff       	jmp    8022e0 <__udivdi3+0x40>
  8023a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023a3:	31 ff                	xor    %edi,%edi
  8023a5:	e9 36 ff ff ff       	jmp    8022e0 <__udivdi3+0x40>
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <__umoddi3>:
  8023b0:	f3 0f 1e fb          	endbr32 
  8023b4:	55                   	push   %ebp
  8023b5:	57                   	push   %edi
  8023b6:	56                   	push   %esi
  8023b7:	53                   	push   %ebx
  8023b8:	83 ec 1c             	sub    $0x1c,%esp
  8023bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	75 19                	jne    8023e8 <__umoddi3+0x38>
  8023cf:	39 df                	cmp    %ebx,%edi
  8023d1:	76 5d                	jbe    802430 <__umoddi3+0x80>
  8023d3:	89 f0                	mov    %esi,%eax
  8023d5:	89 da                	mov    %ebx,%edx
  8023d7:	f7 f7                	div    %edi
  8023d9:	89 d0                	mov    %edx,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	83 c4 1c             	add    $0x1c,%esp
  8023e0:	5b                   	pop    %ebx
  8023e1:	5e                   	pop    %esi
  8023e2:	5f                   	pop    %edi
  8023e3:	5d                   	pop    %ebp
  8023e4:	c3                   	ret    
  8023e5:	8d 76 00             	lea    0x0(%esi),%esi
  8023e8:	89 f2                	mov    %esi,%edx
  8023ea:	39 d8                	cmp    %ebx,%eax
  8023ec:	76 12                	jbe    802400 <__umoddi3+0x50>
  8023ee:	89 f0                	mov    %esi,%eax
  8023f0:	89 da                	mov    %ebx,%edx
  8023f2:	83 c4 1c             	add    $0x1c,%esp
  8023f5:	5b                   	pop    %ebx
  8023f6:	5e                   	pop    %esi
  8023f7:	5f                   	pop    %edi
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    
  8023fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802400:	0f bd e8             	bsr    %eax,%ebp
  802403:	83 f5 1f             	xor    $0x1f,%ebp
  802406:	75 50                	jne    802458 <__umoddi3+0xa8>
  802408:	39 d8                	cmp    %ebx,%eax
  80240a:	0f 82 e0 00 00 00    	jb     8024f0 <__umoddi3+0x140>
  802410:	89 d9                	mov    %ebx,%ecx
  802412:	39 f7                	cmp    %esi,%edi
  802414:	0f 86 d6 00 00 00    	jbe    8024f0 <__umoddi3+0x140>
  80241a:	89 d0                	mov    %edx,%eax
  80241c:	89 ca                	mov    %ecx,%edx
  80241e:	83 c4 1c             	add    $0x1c,%esp
  802421:	5b                   	pop    %ebx
  802422:	5e                   	pop    %esi
  802423:	5f                   	pop    %edi
  802424:	5d                   	pop    %ebp
  802425:	c3                   	ret    
  802426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80242d:	8d 76 00             	lea    0x0(%esi),%esi
  802430:	89 fd                	mov    %edi,%ebp
  802432:	85 ff                	test   %edi,%edi
  802434:	75 0b                	jne    802441 <__umoddi3+0x91>
  802436:	b8 01 00 00 00       	mov    $0x1,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	f7 f7                	div    %edi
  80243f:	89 c5                	mov    %eax,%ebp
  802441:	89 d8                	mov    %ebx,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f5                	div    %ebp
  802447:	89 f0                	mov    %esi,%eax
  802449:	f7 f5                	div    %ebp
  80244b:	89 d0                	mov    %edx,%eax
  80244d:	31 d2                	xor    %edx,%edx
  80244f:	eb 8c                	jmp    8023dd <__umoddi3+0x2d>
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 e9                	mov    %ebp,%ecx
  80245a:	ba 20 00 00 00       	mov    $0x20,%edx
  80245f:	29 ea                	sub    %ebp,%edx
  802461:	d3 e0                	shl    %cl,%eax
  802463:	89 44 24 08          	mov    %eax,0x8(%esp)
  802467:	89 d1                	mov    %edx,%ecx
  802469:	89 f8                	mov    %edi,%eax
  80246b:	d3 e8                	shr    %cl,%eax
  80246d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802471:	89 54 24 04          	mov    %edx,0x4(%esp)
  802475:	8b 54 24 04          	mov    0x4(%esp),%edx
  802479:	09 c1                	or     %eax,%ecx
  80247b:	89 d8                	mov    %ebx,%eax
  80247d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802481:	89 e9                	mov    %ebp,%ecx
  802483:	d3 e7                	shl    %cl,%edi
  802485:	89 d1                	mov    %edx,%ecx
  802487:	d3 e8                	shr    %cl,%eax
  802489:	89 e9                	mov    %ebp,%ecx
  80248b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248f:	d3 e3                	shl    %cl,%ebx
  802491:	89 c7                	mov    %eax,%edi
  802493:	89 d1                	mov    %edx,%ecx
  802495:	89 f0                	mov    %esi,%eax
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 fa                	mov    %edi,%edx
  80249d:	d3 e6                	shl    %cl,%esi
  80249f:	09 d8                	or     %ebx,%eax
  8024a1:	f7 74 24 08          	divl   0x8(%esp)
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	89 f3                	mov    %esi,%ebx
  8024a9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ad:	89 c6                	mov    %eax,%esi
  8024af:	89 d7                	mov    %edx,%edi
  8024b1:	39 d1                	cmp    %edx,%ecx
  8024b3:	72 06                	jb     8024bb <__umoddi3+0x10b>
  8024b5:	75 10                	jne    8024c7 <__umoddi3+0x117>
  8024b7:	39 c3                	cmp    %eax,%ebx
  8024b9:	73 0c                	jae    8024c7 <__umoddi3+0x117>
  8024bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024c3:	89 d7                	mov    %edx,%edi
  8024c5:	89 c6                	mov    %eax,%esi
  8024c7:	89 ca                	mov    %ecx,%edx
  8024c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ce:	29 f3                	sub    %esi,%ebx
  8024d0:	19 fa                	sbb    %edi,%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	d3 e0                	shl    %cl,%eax
  8024d6:	89 e9                	mov    %ebp,%ecx
  8024d8:	d3 eb                	shr    %cl,%ebx
  8024da:	d3 ea                	shr    %cl,%edx
  8024dc:	09 d8                	or     %ebx,%eax
  8024de:	83 c4 1c             	add    $0x1c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
  8024e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ed:	8d 76 00             	lea    0x0(%esi),%esi
  8024f0:	29 fe                	sub    %edi,%esi
  8024f2:	19 c3                	sbb    %eax,%ebx
  8024f4:	89 f2                	mov    %esi,%edx
  8024f6:	89 d9                	mov    %ebx,%ecx
  8024f8:	e9 1d ff ff ff       	jmp    80241a <__umoddi3+0x6a>
