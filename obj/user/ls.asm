
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 a9 02 00 00       	call   8002da <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  800042:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800049:	74 20                	je     80006b <ls1+0x38>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  80004b:	89 f0                	mov    %esi,%eax
  80004d:	3c 01                	cmp    $0x1,%al
  80004f:	19 c0                	sbb    %eax,%eax
  800051:	83 e0 c9             	and    $0xffffffc9,%eax
  800054:	83 c0 64             	add    $0x64,%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	50                   	push   %eax
  80005b:	ff 75 10             	pushl  0x10(%ebp)
  80005e:	68 22 24 80 00       	push   $0x802422
  800063:	e8 d1 1a 00 00       	call   801b39 <printf>
  800068:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  80006b:	85 db                	test   %ebx,%ebx
  80006d:	74 1c                	je     80008b <ls1+0x58>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006f:	b8 88 24 80 00       	mov    $0x802488,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800074:	80 3b 00             	cmpb   $0x0,(%ebx)
  800077:	75 4b                	jne    8000c4 <ls1+0x91>
		printf("%s%s", prefix, sep);
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 2b 24 80 00       	push   $0x80242b
  800083:	e8 b1 1a 00 00       	call   801b39 <printf>
  800088:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	ff 75 14             	pushl  0x14(%ebp)
  800091:	68 b1 28 80 00       	push   $0x8028b1
  800096:	e8 9e 1a 00 00       	call   801b39 <printf>
	if(flag['F'] && isdir)
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a5:	74 06                	je     8000ad <ls1+0x7a>
  8000a7:	89 f0                	mov    %esi,%eax
  8000a9:	84 c0                	test   %al,%al
  8000ab:	75 37                	jne    8000e4 <ls1+0xb1>
		printf("/");
	printf("\n");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 87 24 80 00       	push   $0x802487
  8000b5:	e8 7f 1a 00 00       	call   801b39 <printf>
}
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	53                   	push   %ebx
  8000c8:	e8 23 09 00 00       	call   8009f0 <strlen>
  8000cd:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000d0:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d5:	b8 20 24 80 00       	mov    $0x802420,%eax
  8000da:	ba 88 24 80 00       	mov    $0x802488,%edx
  8000df:	0f 44 c2             	cmove  %edx,%eax
  8000e2:	eb 95                	jmp    800079 <ls1+0x46>
		printf("/");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 20 24 80 00       	push   $0x802420
  8000ec:	e8 48 1a 00 00       	call   801b39 <printf>
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	eb b7                	jmp    8000ad <ls1+0x7a>

008000f6 <lsdir>:
{
  8000f6:	f3 0f 1e fb          	endbr32 
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	57                   	push   %edi
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800106:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800109:	6a 00                	push   $0x0
  80010b:	57                   	push   %edi
  80010c:	e8 71 18 00 00       	call   801982 <open>
  800111:	89 c3                	mov    %eax,%ebx
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	85 c0                	test   %eax,%eax
  800118:	78 4a                	js     800164 <lsdir+0x6e>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80011a:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	68 00 01 00 00       	push   $0x100
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	e8 49 14 00 00       	call   801578 <readn>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	3d 00 01 00 00       	cmp    $0x100,%eax
  800137:	75 41                	jne    80017a <lsdir+0x84>
		if (f.f_name[0])
  800139:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800140:	74 de                	je     800120 <lsdir+0x2a>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800142:	56                   	push   %esi
  800143:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800149:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800150:	0f 94 c0             	sete   %al
  800153:	0f b6 c0             	movzbl %al,%eax
  800156:	50                   	push   %eax
  800157:	ff 75 0c             	pushl  0xc(%ebp)
  80015a:	e8 d4 fe ff ff       	call   800033 <ls1>
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	eb bc                	jmp    800120 <lsdir+0x2a>
		panic("open %s: %e", path, fd);
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	50                   	push   %eax
  800168:	57                   	push   %edi
  800169:	68 30 24 80 00       	push   $0x802430
  80016e:	6a 1d                	push   $0x1d
  800170:	68 3c 24 80 00       	push   $0x80243c
  800175:	e8 c8 01 00 00       	call   800342 <_panic>
	if (n > 0)
  80017a:	85 c0                	test   %eax,%eax
  80017c:	7f 0a                	jg     800188 <lsdir+0x92>
	if (n < 0)
  80017e:	78 1a                	js     80019a <lsdir+0xa4>
}
  800180:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800183:	5b                   	pop    %ebx
  800184:	5e                   	pop    %esi
  800185:	5f                   	pop    %edi
  800186:	5d                   	pop    %ebp
  800187:	c3                   	ret    
		panic("short read in directory %s", path);
  800188:	57                   	push   %edi
  800189:	68 46 24 80 00       	push   $0x802446
  80018e:	6a 22                	push   $0x22
  800190:	68 3c 24 80 00       	push   $0x80243c
  800195:	e8 a8 01 00 00       	call   800342 <_panic>
		panic("error reading directory %s: %e", path, n);
  80019a:	83 ec 0c             	sub    $0xc,%esp
  80019d:	50                   	push   %eax
  80019e:	57                   	push   %edi
  80019f:	68 8c 24 80 00       	push   $0x80248c
  8001a4:	6a 24                	push   $0x24
  8001a6:	68 3c 24 80 00       	push   $0x80243c
  8001ab:	e8 92 01 00 00       	call   800342 <_panic>

008001b0 <ls>:
{
  8001b0:	f3 0f 1e fb          	endbr32 
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	53                   	push   %ebx
  8001b8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001c1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001c7:	50                   	push   %eax
  8001c8:	53                   	push   %ebx
  8001c9:	e8 a3 15 00 00       	call   801771 <stat>
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	85 c0                	test   %eax,%eax
  8001d3:	78 2c                	js     800201 <ls+0x51>
	if (st.st_isdir && !flag['d'])
  8001d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001d8:	85 c0                	test   %eax,%eax
  8001da:	74 09                	je     8001e5 <ls+0x35>
  8001dc:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001e3:	74 32                	je     800217 <ls+0x67>
		ls1(0, st.st_isdir, st.st_size, path);
  8001e5:	53                   	push   %ebx
  8001e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e9:	85 c0                	test   %eax,%eax
  8001eb:	0f 95 c0             	setne  %al
  8001ee:	0f b6 c0             	movzbl %al,%eax
  8001f1:	50                   	push   %eax
  8001f2:	6a 00                	push   $0x0
  8001f4:	e8 3a fe ff ff       	call   800033 <ls1>
  8001f9:	83 c4 10             	add    $0x10,%esp
}
  8001fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    
		panic("stat %s: %e", path, r);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	50                   	push   %eax
  800205:	53                   	push   %ebx
  800206:	68 61 24 80 00       	push   $0x802461
  80020b:	6a 0f                	push   $0xf
  80020d:	68 3c 24 80 00       	push   $0x80243c
  800212:	e8 2b 01 00 00       	call   800342 <_panic>
		lsdir(path, prefix);
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	ff 75 0c             	pushl  0xc(%ebp)
  80021d:	53                   	push   %ebx
  80021e:	e8 d3 fe ff ff       	call   8000f6 <lsdir>
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	eb d4                	jmp    8001fc <ls+0x4c>

00800228 <usage>:

void
usage(void)
{
  800228:	f3 0f 1e fb          	endbr32 
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800232:	68 6d 24 80 00       	push   $0x80246d
  800237:	e8 fd 18 00 00       	call   801b39 <printf>
	exit();
  80023c:	e8 e3 00 00 00       	call   800324 <exit>
}
  800241:	83 c4 10             	add    $0x10,%esp
  800244:	c9                   	leave  
  800245:	c3                   	ret    

00800246 <umain>:

void
umain(int argc, char **argv)
{
  800246:	f3 0f 1e fb          	endbr32 
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
  80024f:	83 ec 14             	sub    $0x14,%esp
  800252:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800255:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800258:	50                   	push   %eax
  800259:	56                   	push   %esi
  80025a:	8d 45 08             	lea    0x8(%ebp),%eax
  80025d:	50                   	push   %eax
  80025e:	e8 23 0e 00 00       	call   801086 <argstart>
	while ((i = argnext(&args)) >= 0)
  800263:	83 c4 10             	add    $0x10,%esp
  800266:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800269:	eb 08                	jmp    800273 <umain+0x2d>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  80026b:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  800272:	01 
	while ((i = argnext(&args)) >= 0)
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	53                   	push   %ebx
  800277:	e8 3e 0e 00 00       	call   8010ba <argnext>
  80027c:	83 c4 10             	add    $0x10,%esp
  80027f:	85 c0                	test   %eax,%eax
  800281:	78 16                	js     800299 <umain+0x53>
		switch (i) {
  800283:	89 c2                	mov    %eax,%edx
  800285:	83 e2 f7             	and    $0xfffffff7,%edx
  800288:	83 fa 64             	cmp    $0x64,%edx
  80028b:	74 de                	je     80026b <umain+0x25>
  80028d:	83 f8 46             	cmp    $0x46,%eax
  800290:	74 d9                	je     80026b <umain+0x25>
			break;
		default:
			usage();
  800292:	e8 91 ff ff ff       	call   800228 <usage>
  800297:	eb da                	jmp    800273 <umain+0x2d>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800299:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80029e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8002a2:	75 2a                	jne    8002ce <umain+0x88>
		ls("/", "");
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	68 88 24 80 00       	push   $0x802488
  8002ac:	68 20 24 80 00       	push   $0x802420
  8002b1:	e8 fa fe ff ff       	call   8001b0 <ls>
  8002b6:	83 c4 10             	add    $0x10,%esp
  8002b9:	eb 18                	jmp    8002d3 <umain+0x8d>
			ls(argv[i], argv[i]);
  8002bb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	50                   	push   %eax
  8002c2:	50                   	push   %eax
  8002c3:	e8 e8 fe ff ff       	call   8001b0 <ls>
		for (i = 1; i < argc; i++)
  8002c8:	83 c3 01             	add    $0x1,%ebx
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002d1:	7f e8                	jg     8002bb <umain+0x75>
	}
}
  8002d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002d6:	5b                   	pop    %ebx
  8002d7:	5e                   	pop    %esi
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    

008002da <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002da:	f3 0f 1e fb          	endbr32 
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e9:	e8 41 0b 00 00       	call   800e2f <sys_getenvid>
  8002ee:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002f3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002fb:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800300:	85 db                	test   %ebx,%ebx
  800302:	7e 07                	jle    80030b <libmain+0x31>
		binaryname = argv[0];
  800304:	8b 06                	mov    (%esi),%eax
  800306:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	56                   	push   %esi
  80030f:	53                   	push   %ebx
  800310:	e8 31 ff ff ff       	call   800246 <umain>

	// exit gracefully
	exit();
  800315:	e8 0a 00 00 00       	call   800324 <exit>
}
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800320:	5b                   	pop    %ebx
  800321:	5e                   	pop    %esi
  800322:	5d                   	pop    %ebp
  800323:	c3                   	ret    

00800324 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800324:	f3 0f 1e fb          	endbr32 
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80032e:	e8 a1 10 00 00       	call   8013d4 <close_all>
	sys_env_destroy(0);
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	6a 00                	push   $0x0
  800338:	e8 ad 0a 00 00       	call   800dea <sys_env_destroy>
}
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	c9                   	leave  
  800341:	c3                   	ret    

00800342 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800342:	f3 0f 1e fb          	endbr32 
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80034b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800354:	e8 d6 0a 00 00       	call   800e2f <sys_getenvid>
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 08             	pushl  0x8(%ebp)
  800362:	56                   	push   %esi
  800363:	50                   	push   %eax
  800364:	68 b8 24 80 00       	push   $0x8024b8
  800369:	e8 bb 00 00 00       	call   800429 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036e:	83 c4 18             	add    $0x18,%esp
  800371:	53                   	push   %ebx
  800372:	ff 75 10             	pushl  0x10(%ebp)
  800375:	e8 5a 00 00 00       	call   8003d4 <vcprintf>
	cprintf("\n");
  80037a:	c7 04 24 87 24 80 00 	movl   $0x802487,(%esp)
  800381:	e8 a3 00 00 00       	call   800429 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800389:	cc                   	int3   
  80038a:	eb fd                	jmp    800389 <_panic+0x47>

0080038c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80038c:	f3 0f 1e fb          	endbr32 
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	53                   	push   %ebx
  800394:	83 ec 04             	sub    $0x4,%esp
  800397:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039a:	8b 13                	mov    (%ebx),%edx
  80039c:	8d 42 01             	lea    0x1(%edx),%eax
  80039f:	89 03                	mov    %eax,(%ebx)
  8003a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ad:	74 09                	je     8003b8 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003af:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b6:	c9                   	leave  
  8003b7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 ff 00 00 00       	push   $0xff
  8003c0:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c3:	50                   	push   %eax
  8003c4:	e8 dc 09 00 00       	call   800da5 <sys_cputs>
		b->idx = 0;
  8003c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	eb db                	jmp    8003af <putch+0x23>

008003d4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d4:	f3 0f 1e fb          	endbr32 
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e8:	00 00 00 
	b.cnt = 0;
  8003eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800401:	50                   	push   %eax
  800402:	68 8c 03 80 00       	push   $0x80038c
  800407:	e8 20 01 00 00       	call   80052c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80040c:	83 c4 08             	add    $0x8,%esp
  80040f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800415:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80041b:	50                   	push   %eax
  80041c:	e8 84 09 00 00       	call   800da5 <sys_cputs>

	return b.cnt;
}
  800421:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800427:	c9                   	leave  
  800428:	c3                   	ret    

00800429 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800429:	f3 0f 1e fb          	endbr32 
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800433:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800436:	50                   	push   %eax
  800437:	ff 75 08             	pushl  0x8(%ebp)
  80043a:	e8 95 ff ff ff       	call   8003d4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80043f:	c9                   	leave  
  800440:	c3                   	ret    

00800441 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	57                   	push   %edi
  800445:	56                   	push   %esi
  800446:	53                   	push   %ebx
  800447:	83 ec 1c             	sub    $0x1c,%esp
  80044a:	89 c7                	mov    %eax,%edi
  80044c:	89 d6                	mov    %edx,%esi
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	8b 55 0c             	mov    0xc(%ebp),%edx
  800454:	89 d1                	mov    %edx,%ecx
  800456:	89 c2                	mov    %eax,%edx
  800458:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80045e:	8b 45 10             	mov    0x10(%ebp),%eax
  800461:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800464:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800467:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800473:	72 3e                	jb     8004b3 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	ff 75 18             	pushl  0x18(%ebp)
  80047b:	83 eb 01             	sub    $0x1,%ebx
  80047e:	53                   	push   %ebx
  80047f:	50                   	push   %eax
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	ff 75 e4             	pushl  -0x1c(%ebp)
  800486:	ff 75 e0             	pushl  -0x20(%ebp)
  800489:	ff 75 dc             	pushl  -0x24(%ebp)
  80048c:	ff 75 d8             	pushl  -0x28(%ebp)
  80048f:	e8 1c 1d 00 00       	call   8021b0 <__udivdi3>
  800494:	83 c4 18             	add    $0x18,%esp
  800497:	52                   	push   %edx
  800498:	50                   	push   %eax
  800499:	89 f2                	mov    %esi,%edx
  80049b:	89 f8                	mov    %edi,%eax
  80049d:	e8 9f ff ff ff       	call   800441 <printnum>
  8004a2:	83 c4 20             	add    $0x20,%esp
  8004a5:	eb 13                	jmp    8004ba <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	56                   	push   %esi
  8004ab:	ff 75 18             	pushl  0x18(%ebp)
  8004ae:	ff d7                	call   *%edi
  8004b0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004b3:	83 eb 01             	sub    $0x1,%ebx
  8004b6:	85 db                	test   %ebx,%ebx
  8004b8:	7f ed                	jg     8004a7 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	56                   	push   %esi
  8004be:	83 ec 04             	sub    $0x4,%esp
  8004c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8004ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cd:	e8 ee 1d 00 00       	call   8022c0 <__umoddi3>
  8004d2:	83 c4 14             	add    $0x14,%esp
  8004d5:	0f be 80 db 24 80 00 	movsbl 0x8024db(%eax),%eax
  8004dc:	50                   	push   %eax
  8004dd:	ff d7                	call   *%edi
}
  8004df:	83 c4 10             	add    $0x10,%esp
  8004e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e5:	5b                   	pop    %ebx
  8004e6:	5e                   	pop    %esi
  8004e7:	5f                   	pop    %edi
  8004e8:	5d                   	pop    %ebp
  8004e9:	c3                   	ret    

008004ea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ea:	f3 0f 1e fb          	endbr32 
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f8:	8b 10                	mov    (%eax),%edx
  8004fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8004fd:	73 0a                	jae    800509 <sprintputch+0x1f>
		*b->buf++ = ch;
  8004ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800502:	89 08                	mov    %ecx,(%eax)
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	88 02                	mov    %al,(%edx)
}
  800509:	5d                   	pop    %ebp
  80050a:	c3                   	ret    

0080050b <printfmt>:
{
  80050b:	f3 0f 1e fb          	endbr32 
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800515:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800518:	50                   	push   %eax
  800519:	ff 75 10             	pushl  0x10(%ebp)
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	e8 05 00 00 00       	call   80052c <vprintfmt>
}
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <vprintfmt>:
{
  80052c:	f3 0f 1e fb          	endbr32 
  800530:	55                   	push   %ebp
  800531:	89 e5                	mov    %esp,%ebp
  800533:	57                   	push   %edi
  800534:	56                   	push   %esi
  800535:	53                   	push   %ebx
  800536:	83 ec 3c             	sub    $0x3c,%esp
  800539:	8b 75 08             	mov    0x8(%ebp),%esi
  80053c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800542:	e9 8e 03 00 00       	jmp    8008d5 <vprintfmt+0x3a9>
		padc = ' ';
  800547:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80054b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800552:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800559:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800560:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800565:	8d 47 01             	lea    0x1(%edi),%eax
  800568:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80056b:	0f b6 17             	movzbl (%edi),%edx
  80056e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800571:	3c 55                	cmp    $0x55,%al
  800573:	0f 87 df 03 00 00    	ja     800958 <vprintfmt+0x42c>
  800579:	0f b6 c0             	movzbl %al,%eax
  80057c:	3e ff 24 85 20 26 80 	notrack jmp *0x802620(,%eax,4)
  800583:	00 
  800584:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800587:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80058b:	eb d8                	jmp    800565 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80058d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800590:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800594:	eb cf                	jmp    800565 <vprintfmt+0x39>
  800596:	0f b6 d2             	movzbl %dl,%edx
  800599:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80059c:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005a4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005ab:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005ae:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005b1:	83 f9 09             	cmp    $0x9,%ecx
  8005b4:	77 55                	ja     80060b <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005b6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b9:	eb e9                	jmp    8005a4 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8d 40 04             	lea    0x4(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d3:	79 90                	jns    800565 <vprintfmt+0x39>
				width = precision, precision = -1;
  8005d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005db:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005e2:	eb 81                	jmp    800565 <vprintfmt+0x39>
  8005e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e7:	85 c0                	test   %eax,%eax
  8005e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ee:	0f 49 d0             	cmovns %eax,%edx
  8005f1:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f7:	e9 69 ff ff ff       	jmp    800565 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ff:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800606:	e9 5a ff ff ff       	jmp    800565 <vprintfmt+0x39>
  80060b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80060e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800611:	eb bc                	jmp    8005cf <vprintfmt+0xa3>
			lflag++;
  800613:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800616:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800619:	e9 47 ff ff ff       	jmp    800565 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 78 04             	lea    0x4(%eax),%edi
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	53                   	push   %ebx
  800628:	ff 30                	pushl  (%eax)
  80062a:	ff d6                	call   *%esi
			break;
  80062c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80062f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800632:	e9 9b 02 00 00       	jmp    8008d2 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8d 78 04             	lea    0x4(%eax),%edi
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	31 d0                	xor    %edx,%eax
  800642:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800644:	83 f8 0f             	cmp    $0xf,%eax
  800647:	7f 23                	jg     80066c <vprintfmt+0x140>
  800649:	8b 14 85 80 27 80 00 	mov    0x802780(,%eax,4),%edx
  800650:	85 d2                	test   %edx,%edx
  800652:	74 18                	je     80066c <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800654:	52                   	push   %edx
  800655:	68 b1 28 80 00       	push   $0x8028b1
  80065a:	53                   	push   %ebx
  80065b:	56                   	push   %esi
  80065c:	e8 aa fe ff ff       	call   80050b <printfmt>
  800661:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800664:	89 7d 14             	mov    %edi,0x14(%ebp)
  800667:	e9 66 02 00 00       	jmp    8008d2 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80066c:	50                   	push   %eax
  80066d:	68 f3 24 80 00       	push   $0x8024f3
  800672:	53                   	push   %ebx
  800673:	56                   	push   %esi
  800674:	e8 92 fe ff ff       	call   80050b <printfmt>
  800679:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80067c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80067f:	e9 4e 02 00 00       	jmp    8008d2 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	83 c0 04             	add    $0x4,%eax
  80068a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800692:	85 d2                	test   %edx,%edx
  800694:	b8 ec 24 80 00       	mov    $0x8024ec,%eax
  800699:	0f 45 c2             	cmovne %edx,%eax
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80069f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a3:	7e 06                	jle    8006ab <vprintfmt+0x17f>
  8006a5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a9:	75 0d                	jne    8006b8 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006ae:	89 c7                	mov    %eax,%edi
  8006b0:	03 45 e0             	add    -0x20(%ebp),%eax
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b6:	eb 55                	jmp    80070d <vprintfmt+0x1e1>
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006be:	ff 75 cc             	pushl  -0x34(%ebp)
  8006c1:	e8 46 03 00 00       	call   800a0c <strnlen>
  8006c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c9:	29 c2                	sub    %eax,%edx
  8006cb:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006d3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006da:	85 ff                	test   %edi,%edi
  8006dc:	7e 11                	jle    8006ef <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	53                   	push   %ebx
  8006e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e7:	83 ef 01             	sub    $0x1,%edi
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	eb eb                	jmp    8006da <vprintfmt+0x1ae>
  8006ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006f2:	85 d2                	test   %edx,%edx
  8006f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f9:	0f 49 c2             	cmovns %edx,%eax
  8006fc:	29 c2                	sub    %eax,%edx
  8006fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800701:	eb a8                	jmp    8006ab <vprintfmt+0x17f>
					putch(ch, putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	52                   	push   %edx
  800708:	ff d6                	call   *%esi
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800710:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800712:	83 c7 01             	add    $0x1,%edi
  800715:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800719:	0f be d0             	movsbl %al,%edx
  80071c:	85 d2                	test   %edx,%edx
  80071e:	74 4b                	je     80076b <vprintfmt+0x23f>
  800720:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800724:	78 06                	js     80072c <vprintfmt+0x200>
  800726:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80072a:	78 1e                	js     80074a <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80072c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800730:	74 d1                	je     800703 <vprintfmt+0x1d7>
  800732:	0f be c0             	movsbl %al,%eax
  800735:	83 e8 20             	sub    $0x20,%eax
  800738:	83 f8 5e             	cmp    $0x5e,%eax
  80073b:	76 c6                	jbe    800703 <vprintfmt+0x1d7>
					putch('?', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	53                   	push   %ebx
  800741:	6a 3f                	push   $0x3f
  800743:	ff d6                	call   *%esi
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	eb c3                	jmp    80070d <vprintfmt+0x1e1>
  80074a:	89 cf                	mov    %ecx,%edi
  80074c:	eb 0e                	jmp    80075c <vprintfmt+0x230>
				putch(' ', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 20                	push   $0x20
  800754:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800756:	83 ef 01             	sub    $0x1,%edi
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	85 ff                	test   %edi,%edi
  80075e:	7f ee                	jg     80074e <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800760:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
  800766:	e9 67 01 00 00       	jmp    8008d2 <vprintfmt+0x3a6>
  80076b:	89 cf                	mov    %ecx,%edi
  80076d:	eb ed                	jmp    80075c <vprintfmt+0x230>
	if (lflag >= 2)
  80076f:	83 f9 01             	cmp    $0x1,%ecx
  800772:	7f 1b                	jg     80078f <vprintfmt+0x263>
	else if (lflag)
  800774:	85 c9                	test   %ecx,%ecx
  800776:	74 63                	je     8007db <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800780:	99                   	cltd   
  800781:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
  80078d:	eb 17                	jmp    8007a6 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 50 04             	mov    0x4(%eax),%edx
  800795:	8b 00                	mov    (%eax),%eax
  800797:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8d 40 08             	lea    0x8(%eax),%eax
  8007a3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007ac:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007b1:	85 c9                	test   %ecx,%ecx
  8007b3:	0f 89 ff 00 00 00    	jns    8008b8 <vprintfmt+0x38c>
				putch('-', putdat);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	53                   	push   %ebx
  8007bd:	6a 2d                	push   $0x2d
  8007bf:	ff d6                	call   *%esi
				num = -(long long) num;
  8007c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007c7:	f7 da                	neg    %edx
  8007c9:	83 d1 00             	adc    $0x0,%ecx
  8007cc:	f7 d9                	neg    %ecx
  8007ce:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d6:	e9 dd 00 00 00       	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e3:	99                   	cltd   
  8007e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 40 04             	lea    0x4(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f0:	eb b4                	jmp    8007a6 <vprintfmt+0x27a>
	if (lflag >= 2)
  8007f2:	83 f9 01             	cmp    $0x1,%ecx
  8007f5:	7f 1e                	jg     800815 <vprintfmt+0x2e9>
	else if (lflag)
  8007f7:	85 c9                	test   %ecx,%ecx
  8007f9:	74 32                	je     80082d <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8b 10                	mov    (%eax),%edx
  800800:	b9 00 00 00 00       	mov    $0x0,%ecx
  800805:	8d 40 04             	lea    0x4(%eax),%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800810:	e9 a3 00 00 00       	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 10                	mov    (%eax),%edx
  80081a:	8b 48 04             	mov    0x4(%eax),%ecx
  80081d:	8d 40 08             	lea    0x8(%eax),%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800823:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800828:	e9 8b 00 00 00       	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 10                	mov    (%eax),%edx
  800832:	b9 00 00 00 00       	mov    $0x0,%ecx
  800837:	8d 40 04             	lea    0x4(%eax),%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800842:	eb 74                	jmp    8008b8 <vprintfmt+0x38c>
	if (lflag >= 2)
  800844:	83 f9 01             	cmp    $0x1,%ecx
  800847:	7f 1b                	jg     800864 <vprintfmt+0x338>
	else if (lflag)
  800849:	85 c9                	test   %ecx,%ecx
  80084b:	74 2c                	je     800879 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8b 10                	mov    (%eax),%edx
  800852:	b9 00 00 00 00       	mov    $0x0,%ecx
  800857:	8d 40 04             	lea    0x4(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800862:	eb 54                	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 10                	mov    (%eax),%edx
  800869:	8b 48 04             	mov    0x4(%eax),%ecx
  80086c:	8d 40 08             	lea    0x8(%eax),%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800872:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800877:	eb 3f                	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8b 10                	mov    (%eax),%edx
  80087e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800883:	8d 40 04             	lea    0x4(%eax),%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800889:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80088e:	eb 28                	jmp    8008b8 <vprintfmt+0x38c>
			putch('0', putdat);
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	53                   	push   %ebx
  800894:	6a 30                	push   $0x30
  800896:	ff d6                	call   *%esi
			putch('x', putdat);
  800898:	83 c4 08             	add    $0x8,%esp
  80089b:	53                   	push   %ebx
  80089c:	6a 78                	push   $0x78
  80089e:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	8b 10                	mov    (%eax),%edx
  8008a5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008aa:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	83 ec 0c             	sub    $0xc,%esp
  8008bb:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008bf:	57                   	push   %edi
  8008c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8008c3:	50                   	push   %eax
  8008c4:	51                   	push   %ecx
  8008c5:	52                   	push   %edx
  8008c6:	89 da                	mov    %ebx,%edx
  8008c8:	89 f0                	mov    %esi,%eax
  8008ca:	e8 72 fb ff ff       	call   800441 <printnum>
			break;
  8008cf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d5:	83 c7 01             	add    $0x1,%edi
  8008d8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008dc:	83 f8 25             	cmp    $0x25,%eax
  8008df:	0f 84 62 fc ff ff    	je     800547 <vprintfmt+0x1b>
			if (ch == '\0')
  8008e5:	85 c0                	test   %eax,%eax
  8008e7:	0f 84 8b 00 00 00    	je     800978 <vprintfmt+0x44c>
			putch(ch, putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	50                   	push   %eax
  8008f2:	ff d6                	call   *%esi
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	eb dc                	jmp    8008d5 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008f9:	83 f9 01             	cmp    $0x1,%ecx
  8008fc:	7f 1b                	jg     800919 <vprintfmt+0x3ed>
	else if (lflag)
  8008fe:	85 c9                	test   %ecx,%ecx
  800900:	74 2c                	je     80092e <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8b 10                	mov    (%eax),%edx
  800907:	b9 00 00 00 00       	mov    $0x0,%ecx
  80090c:	8d 40 04             	lea    0x4(%eax),%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800912:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800917:	eb 9f                	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	8b 10                	mov    (%eax),%edx
  80091e:	8b 48 04             	mov    0x4(%eax),%ecx
  800921:	8d 40 08             	lea    0x8(%eax),%eax
  800924:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800927:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80092c:	eb 8a                	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	8b 10                	mov    (%eax),%edx
  800933:	b9 00 00 00 00       	mov    $0x0,%ecx
  800938:	8d 40 04             	lea    0x4(%eax),%eax
  80093b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800943:	e9 70 ff ff ff       	jmp    8008b8 <vprintfmt+0x38c>
			putch(ch, putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	53                   	push   %ebx
  80094c:	6a 25                	push   $0x25
  80094e:	ff d6                	call   *%esi
			break;
  800950:	83 c4 10             	add    $0x10,%esp
  800953:	e9 7a ff ff ff       	jmp    8008d2 <vprintfmt+0x3a6>
			putch('%', putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	53                   	push   %ebx
  80095c:	6a 25                	push   $0x25
  80095e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800960:	83 c4 10             	add    $0x10,%esp
  800963:	89 f8                	mov    %edi,%eax
  800965:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800969:	74 05                	je     800970 <vprintfmt+0x444>
  80096b:	83 e8 01             	sub    $0x1,%eax
  80096e:	eb f5                	jmp    800965 <vprintfmt+0x439>
  800970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800973:	e9 5a ff ff ff       	jmp    8008d2 <vprintfmt+0x3a6>
}
  800978:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80097b:	5b                   	pop    %ebx
  80097c:	5e                   	pop    %esi
  80097d:	5f                   	pop    %edi
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800980:	f3 0f 1e fb          	endbr32 
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 18             	sub    $0x18,%esp
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800990:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800993:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800997:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a1:	85 c0                	test   %eax,%eax
  8009a3:	74 26                	je     8009cb <vsnprintf+0x4b>
  8009a5:	85 d2                	test   %edx,%edx
  8009a7:	7e 22                	jle    8009cb <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a9:	ff 75 14             	pushl  0x14(%ebp)
  8009ac:	ff 75 10             	pushl  0x10(%ebp)
  8009af:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b2:	50                   	push   %eax
  8009b3:	68 ea 04 80 00       	push   $0x8004ea
  8009b8:	e8 6f fb ff ff       	call   80052c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c6:	83 c4 10             	add    $0x10,%esp
}
  8009c9:	c9                   	leave  
  8009ca:	c3                   	ret    
		return -E_INVAL;
  8009cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d0:	eb f7                	jmp    8009c9 <vsnprintf+0x49>

008009d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d2:	f3 0f 1e fb          	endbr32 
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009df:	50                   	push   %eax
  8009e0:	ff 75 10             	pushl  0x10(%ebp)
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	ff 75 08             	pushl  0x8(%ebp)
  8009e9:	e8 92 ff ff ff       	call   800980 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ee:	c9                   	leave  
  8009ef:	c3                   	ret    

008009f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f0:	f3 0f 1e fb          	endbr32 
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ff:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a03:	74 05                	je     800a0a <strlen+0x1a>
		n++;
  800a05:	83 c0 01             	add    $0x1,%eax
  800a08:	eb f5                	jmp    8009ff <strlen+0xf>
	return n;
}
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a0c:	f3 0f 1e fb          	endbr32 
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a19:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1e:	39 d0                	cmp    %edx,%eax
  800a20:	74 0d                	je     800a2f <strnlen+0x23>
  800a22:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a26:	74 05                	je     800a2d <strnlen+0x21>
		n++;
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	eb f1                	jmp    800a1e <strnlen+0x12>
  800a2d:	89 c2                	mov    %eax,%edx
	return n;
}
  800a2f:	89 d0                	mov    %edx,%eax
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a33:	f3 0f 1e fb          	endbr32 
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a41:	b8 00 00 00 00       	mov    $0x0,%eax
  800a46:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a4a:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a4d:	83 c0 01             	add    $0x1,%eax
  800a50:	84 d2                	test   %dl,%dl
  800a52:	75 f2                	jne    800a46 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a54:	89 c8                	mov    %ecx,%eax
  800a56:	5b                   	pop    %ebx
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a59:	f3 0f 1e fb          	endbr32 
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	53                   	push   %ebx
  800a61:	83 ec 10             	sub    $0x10,%esp
  800a64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a67:	53                   	push   %ebx
  800a68:	e8 83 ff ff ff       	call   8009f0 <strlen>
  800a6d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	01 d8                	add    %ebx,%eax
  800a75:	50                   	push   %eax
  800a76:	e8 b8 ff ff ff       	call   800a33 <strcpy>
	return dst;
}
  800a7b:	89 d8                	mov    %ebx,%eax
  800a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a82:	f3 0f 1e fb          	endbr32 
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	56                   	push   %esi
  800a8a:	53                   	push   %ebx
  800a8b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a91:	89 f3                	mov    %esi,%ebx
  800a93:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a96:	89 f0                	mov    %esi,%eax
  800a98:	39 d8                	cmp    %ebx,%eax
  800a9a:	74 11                	je     800aad <strncpy+0x2b>
		*dst++ = *src;
  800a9c:	83 c0 01             	add    $0x1,%eax
  800a9f:	0f b6 0a             	movzbl (%edx),%ecx
  800aa2:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa5:	80 f9 01             	cmp    $0x1,%cl
  800aa8:	83 da ff             	sbb    $0xffffffff,%edx
  800aab:	eb eb                	jmp    800a98 <strncpy+0x16>
	}
	return ret;
}
  800aad:	89 f0                	mov    %esi,%eax
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab3:	f3 0f 1e fb          	endbr32 
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	56                   	push   %esi
  800abb:	53                   	push   %ebx
  800abc:	8b 75 08             	mov    0x8(%ebp),%esi
  800abf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac2:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac7:	85 d2                	test   %edx,%edx
  800ac9:	74 21                	je     800aec <strlcpy+0x39>
  800acb:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800acf:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ad1:	39 c2                	cmp    %eax,%edx
  800ad3:	74 14                	je     800ae9 <strlcpy+0x36>
  800ad5:	0f b6 19             	movzbl (%ecx),%ebx
  800ad8:	84 db                	test   %bl,%bl
  800ada:	74 0b                	je     800ae7 <strlcpy+0x34>
			*dst++ = *src++;
  800adc:	83 c1 01             	add    $0x1,%ecx
  800adf:	83 c2 01             	add    $0x1,%edx
  800ae2:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae5:	eb ea                	jmp    800ad1 <strlcpy+0x1e>
  800ae7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aec:	29 f0                	sub    %esi,%eax
}
  800aee:	5b                   	pop    %ebx
  800aef:	5e                   	pop    %esi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af2:	f3 0f 1e fb          	endbr32 
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aff:	0f b6 01             	movzbl (%ecx),%eax
  800b02:	84 c0                	test   %al,%al
  800b04:	74 0c                	je     800b12 <strcmp+0x20>
  800b06:	3a 02                	cmp    (%edx),%al
  800b08:	75 08                	jne    800b12 <strcmp+0x20>
		p++, q++;
  800b0a:	83 c1 01             	add    $0x1,%ecx
  800b0d:	83 c2 01             	add    $0x1,%edx
  800b10:	eb ed                	jmp    800aff <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b12:	0f b6 c0             	movzbl %al,%eax
  800b15:	0f b6 12             	movzbl (%edx),%edx
  800b18:	29 d0                	sub    %edx,%eax
}
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b1c:	f3 0f 1e fb          	endbr32 
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	53                   	push   %ebx
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	89 c3                	mov    %eax,%ebx
  800b2c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b2f:	eb 06                	jmp    800b37 <strncmp+0x1b>
		n--, p++, q++;
  800b31:	83 c0 01             	add    $0x1,%eax
  800b34:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b37:	39 d8                	cmp    %ebx,%eax
  800b39:	74 16                	je     800b51 <strncmp+0x35>
  800b3b:	0f b6 08             	movzbl (%eax),%ecx
  800b3e:	84 c9                	test   %cl,%cl
  800b40:	74 04                	je     800b46 <strncmp+0x2a>
  800b42:	3a 0a                	cmp    (%edx),%cl
  800b44:	74 eb                	je     800b31 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b46:	0f b6 00             	movzbl (%eax),%eax
  800b49:	0f b6 12             	movzbl (%edx),%edx
  800b4c:	29 d0                	sub    %edx,%eax
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    
		return 0;
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
  800b56:	eb f6                	jmp    800b4e <strncmp+0x32>

00800b58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b58:	f3 0f 1e fb          	endbr32 
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b66:	0f b6 10             	movzbl (%eax),%edx
  800b69:	84 d2                	test   %dl,%dl
  800b6b:	74 09                	je     800b76 <strchr+0x1e>
		if (*s == c)
  800b6d:	38 ca                	cmp    %cl,%dl
  800b6f:	74 0a                	je     800b7b <strchr+0x23>
	for (; *s; s++)
  800b71:	83 c0 01             	add    $0x1,%eax
  800b74:	eb f0                	jmp    800b66 <strchr+0xe>
			return (char *) s;
	return 0;
  800b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7d:	f3 0f 1e fb          	endbr32 
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b8b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b8e:	38 ca                	cmp    %cl,%dl
  800b90:	74 09                	je     800b9b <strfind+0x1e>
  800b92:	84 d2                	test   %dl,%dl
  800b94:	74 05                	je     800b9b <strfind+0x1e>
	for (; *s; s++)
  800b96:	83 c0 01             	add    $0x1,%eax
  800b99:	eb f0                	jmp    800b8b <strfind+0xe>
			break;
	return (char *) s;
}
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b9d:	f3 0f 1e fb          	endbr32 
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	57                   	push   %edi
  800ba5:	56                   	push   %esi
  800ba6:	53                   	push   %ebx
  800ba7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800baa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bad:	85 c9                	test   %ecx,%ecx
  800baf:	74 31                	je     800be2 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb1:	89 f8                	mov    %edi,%eax
  800bb3:	09 c8                	or     %ecx,%eax
  800bb5:	a8 03                	test   $0x3,%al
  800bb7:	75 23                	jne    800bdc <memset+0x3f>
		c &= 0xFF;
  800bb9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bbd:	89 d3                	mov    %edx,%ebx
  800bbf:	c1 e3 08             	shl    $0x8,%ebx
  800bc2:	89 d0                	mov    %edx,%eax
  800bc4:	c1 e0 18             	shl    $0x18,%eax
  800bc7:	89 d6                	mov    %edx,%esi
  800bc9:	c1 e6 10             	shl    $0x10,%esi
  800bcc:	09 f0                	or     %esi,%eax
  800bce:	09 c2                	or     %eax,%edx
  800bd0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bd2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd5:	89 d0                	mov    %edx,%eax
  800bd7:	fc                   	cld    
  800bd8:	f3 ab                	rep stos %eax,%es:(%edi)
  800bda:	eb 06                	jmp    800be2 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdf:	fc                   	cld    
  800be0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800be2:	89 f8                	mov    %edi,%eax
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be9:	f3 0f 1e fb          	endbr32 
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bfb:	39 c6                	cmp    %eax,%esi
  800bfd:	73 32                	jae    800c31 <memmove+0x48>
  800bff:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c02:	39 c2                	cmp    %eax,%edx
  800c04:	76 2b                	jbe    800c31 <memmove+0x48>
		s += n;
		d += n;
  800c06:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c09:	89 fe                	mov    %edi,%esi
  800c0b:	09 ce                	or     %ecx,%esi
  800c0d:	09 d6                	or     %edx,%esi
  800c0f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c15:	75 0e                	jne    800c25 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c17:	83 ef 04             	sub    $0x4,%edi
  800c1a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c1d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c20:	fd                   	std    
  800c21:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c23:	eb 09                	jmp    800c2e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c25:	83 ef 01             	sub    $0x1,%edi
  800c28:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c2b:	fd                   	std    
  800c2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c2e:	fc                   	cld    
  800c2f:	eb 1a                	jmp    800c4b <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c31:	89 c2                	mov    %eax,%edx
  800c33:	09 ca                	or     %ecx,%edx
  800c35:	09 f2                	or     %esi,%edx
  800c37:	f6 c2 03             	test   $0x3,%dl
  800c3a:	75 0a                	jne    800c46 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c3c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c3f:	89 c7                	mov    %eax,%edi
  800c41:	fc                   	cld    
  800c42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c44:	eb 05                	jmp    800c4b <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c46:	89 c7                	mov    %eax,%edi
  800c48:	fc                   	cld    
  800c49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4f:	f3 0f 1e fb          	endbr32 
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	ff 75 08             	pushl  0x8(%ebp)
  800c62:	e8 82 ff ff ff       	call   800be9 <memmove>
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c69:	f3 0f 1e fb          	endbr32 
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c78:	89 c6                	mov    %eax,%esi
  800c7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7d:	39 f0                	cmp    %esi,%eax
  800c7f:	74 1c                	je     800c9d <memcmp+0x34>
		if (*s1 != *s2)
  800c81:	0f b6 08             	movzbl (%eax),%ecx
  800c84:	0f b6 1a             	movzbl (%edx),%ebx
  800c87:	38 d9                	cmp    %bl,%cl
  800c89:	75 08                	jne    800c93 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c8b:	83 c0 01             	add    $0x1,%eax
  800c8e:	83 c2 01             	add    $0x1,%edx
  800c91:	eb ea                	jmp    800c7d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c93:	0f b6 c1             	movzbl %cl,%eax
  800c96:	0f b6 db             	movzbl %bl,%ebx
  800c99:	29 d8                	sub    %ebx,%eax
  800c9b:	eb 05                	jmp    800ca2 <memcmp+0x39>
	}

	return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca6:	f3 0f 1e fb          	endbr32 
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cb3:	89 c2                	mov    %eax,%edx
  800cb5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb8:	39 d0                	cmp    %edx,%eax
  800cba:	73 09                	jae    800cc5 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cbc:	38 08                	cmp    %cl,(%eax)
  800cbe:	74 05                	je     800cc5 <memfind+0x1f>
	for (; s < ends; s++)
  800cc0:	83 c0 01             	add    $0x1,%eax
  800cc3:	eb f3                	jmp    800cb8 <memfind+0x12>
			break;
	return (void *) s;
}
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc7:	f3 0f 1e fb          	endbr32 
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd7:	eb 03                	jmp    800cdc <strtol+0x15>
		s++;
  800cd9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cdc:	0f b6 01             	movzbl (%ecx),%eax
  800cdf:	3c 20                	cmp    $0x20,%al
  800ce1:	74 f6                	je     800cd9 <strtol+0x12>
  800ce3:	3c 09                	cmp    $0x9,%al
  800ce5:	74 f2                	je     800cd9 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ce7:	3c 2b                	cmp    $0x2b,%al
  800ce9:	74 2a                	je     800d15 <strtol+0x4e>
	int neg = 0;
  800ceb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cf0:	3c 2d                	cmp    $0x2d,%al
  800cf2:	74 2b                	je     800d1f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cfa:	75 0f                	jne    800d0b <strtol+0x44>
  800cfc:	80 39 30             	cmpb   $0x30,(%ecx)
  800cff:	74 28                	je     800d29 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d01:	85 db                	test   %ebx,%ebx
  800d03:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d08:	0f 44 d8             	cmove  %eax,%ebx
  800d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d10:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d13:	eb 46                	jmp    800d5b <strtol+0x94>
		s++;
  800d15:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d18:	bf 00 00 00 00       	mov    $0x0,%edi
  800d1d:	eb d5                	jmp    800cf4 <strtol+0x2d>
		s++, neg = 1;
  800d1f:	83 c1 01             	add    $0x1,%ecx
  800d22:	bf 01 00 00 00       	mov    $0x1,%edi
  800d27:	eb cb                	jmp    800cf4 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d29:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d2d:	74 0e                	je     800d3d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d2f:	85 db                	test   %ebx,%ebx
  800d31:	75 d8                	jne    800d0b <strtol+0x44>
		s++, base = 8;
  800d33:	83 c1 01             	add    $0x1,%ecx
  800d36:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d3b:	eb ce                	jmp    800d0b <strtol+0x44>
		s += 2, base = 16;
  800d3d:	83 c1 02             	add    $0x2,%ecx
  800d40:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d45:	eb c4                	jmp    800d0b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d47:	0f be d2             	movsbl %dl,%edx
  800d4a:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d4d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d50:	7d 3a                	jge    800d8c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d52:	83 c1 01             	add    $0x1,%ecx
  800d55:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d59:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d5b:	0f b6 11             	movzbl (%ecx),%edx
  800d5e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d61:	89 f3                	mov    %esi,%ebx
  800d63:	80 fb 09             	cmp    $0x9,%bl
  800d66:	76 df                	jbe    800d47 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d68:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d6b:	89 f3                	mov    %esi,%ebx
  800d6d:	80 fb 19             	cmp    $0x19,%bl
  800d70:	77 08                	ja     800d7a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d72:	0f be d2             	movsbl %dl,%edx
  800d75:	83 ea 57             	sub    $0x57,%edx
  800d78:	eb d3                	jmp    800d4d <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d7a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d7d:	89 f3                	mov    %esi,%ebx
  800d7f:	80 fb 19             	cmp    $0x19,%bl
  800d82:	77 08                	ja     800d8c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d84:	0f be d2             	movsbl %dl,%edx
  800d87:	83 ea 37             	sub    $0x37,%edx
  800d8a:	eb c1                	jmp    800d4d <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d90:	74 05                	je     800d97 <strtol+0xd0>
		*endptr = (char *) s;
  800d92:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d95:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d97:	89 c2                	mov    %eax,%edx
  800d99:	f7 da                	neg    %edx
  800d9b:	85 ff                	test   %edi,%edi
  800d9d:	0f 45 c2             	cmovne %edx,%eax
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800da5:	f3 0f 1e fb          	endbr32 
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800daf:	b8 00 00 00 00       	mov    $0x0,%eax
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	89 c3                	mov    %eax,%ebx
  800dbc:	89 c7                	mov    %eax,%edi
  800dbe:	89 c6                	mov    %eax,%esi
  800dc0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc7:	f3 0f 1e fb          	endbr32 
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ddb:	89 d1                	mov    %edx,%ecx
  800ddd:	89 d3                	mov    %edx,%ebx
  800ddf:	89 d7                	mov    %edx,%edi
  800de1:	89 d6                	mov    %edx,%esi
  800de3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dea:	f3 0f 1e fb          	endbr32 
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	57                   	push   %edi
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
  800df4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	b8 03 00 00 00       	mov    $0x3,%eax
  800e04:	89 cb                	mov    %ecx,%ebx
  800e06:	89 cf                	mov    %ecx,%edi
  800e08:	89 ce                	mov    %ecx,%esi
  800e0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7f 08                	jg     800e18 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e18:	83 ec 0c             	sub    $0xc,%esp
  800e1b:	50                   	push   %eax
  800e1c:	6a 03                	push   $0x3
  800e1e:	68 df 27 80 00       	push   $0x8027df
  800e23:	6a 23                	push   $0x23
  800e25:	68 fc 27 80 00       	push   $0x8027fc
  800e2a:	e8 13 f5 ff ff       	call   800342 <_panic>

00800e2f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e2f:	f3 0f 1e fb          	endbr32 
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e39:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3e:	b8 02 00 00 00       	mov    $0x2,%eax
  800e43:	89 d1                	mov    %edx,%ecx
  800e45:	89 d3                	mov    %edx,%ebx
  800e47:	89 d7                	mov    %edx,%edi
  800e49:	89 d6                	mov    %edx,%esi
  800e4b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <sys_yield>:

void
sys_yield(void)
{
  800e52:	f3 0f 1e fb          	endbr32 
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e61:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e66:	89 d1                	mov    %edx,%ecx
  800e68:	89 d3                	mov    %edx,%ebx
  800e6a:	89 d7                	mov    %edx,%edi
  800e6c:	89 d6                	mov    %edx,%esi
  800e6e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e75:	f3 0f 1e fb          	endbr32 
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
  800e7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e82:	be 00 00 00 00       	mov    $0x0,%esi
  800e87:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8d:	b8 04 00 00 00       	mov    $0x4,%eax
  800e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e95:	89 f7                	mov    %esi,%edi
  800e97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7f 08                	jg     800ea5 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	50                   	push   %eax
  800ea9:	6a 04                	push   $0x4
  800eab:	68 df 27 80 00       	push   $0x8027df
  800eb0:	6a 23                	push   $0x23
  800eb2:	68 fc 27 80 00       	push   $0x8027fc
  800eb7:	e8 86 f4 ff ff       	call   800342 <_panic>

00800ebc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ebc:	f3 0f 1e fb          	endbr32 
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
  800ec6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecf:	b8 05 00 00 00       	mov    $0x5,%eax
  800ed4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eda:	8b 75 18             	mov    0x18(%ebp),%esi
  800edd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	7f 08                	jg     800eeb <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eeb:	83 ec 0c             	sub    $0xc,%esp
  800eee:	50                   	push   %eax
  800eef:	6a 05                	push   $0x5
  800ef1:	68 df 27 80 00       	push   $0x8027df
  800ef6:	6a 23                	push   $0x23
  800ef8:	68 fc 27 80 00       	push   $0x8027fc
  800efd:	e8 40 f4 ff ff       	call   800342 <_panic>

00800f02 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f02:	f3 0f 1e fb          	endbr32 
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
  800f0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1a:	b8 06 00 00 00       	mov    $0x6,%eax
  800f1f:	89 df                	mov    %ebx,%edi
  800f21:	89 de                	mov    %ebx,%esi
  800f23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7f 08                	jg     800f31 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	50                   	push   %eax
  800f35:	6a 06                	push   $0x6
  800f37:	68 df 27 80 00       	push   $0x8027df
  800f3c:	6a 23                	push   $0x23
  800f3e:	68 fc 27 80 00       	push   $0x8027fc
  800f43:	e8 fa f3 ff ff       	call   800342 <_panic>

00800f48 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f48:	f3 0f 1e fb          	endbr32 
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
  800f52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f60:	b8 08 00 00 00       	mov    $0x8,%eax
  800f65:	89 df                	mov    %ebx,%edi
  800f67:	89 de                	mov    %ebx,%esi
  800f69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	7f 08                	jg     800f77 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f77:	83 ec 0c             	sub    $0xc,%esp
  800f7a:	50                   	push   %eax
  800f7b:	6a 08                	push   $0x8
  800f7d:	68 df 27 80 00       	push   $0x8027df
  800f82:	6a 23                	push   $0x23
  800f84:	68 fc 27 80 00       	push   $0x8027fc
  800f89:	e8 b4 f3 ff ff       	call   800342 <_panic>

00800f8e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8e:	f3 0f 1e fb          	endbr32 
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
  800f98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa6:	b8 09 00 00 00       	mov    $0x9,%eax
  800fab:	89 df                	mov    %ebx,%edi
  800fad:	89 de                	mov    %ebx,%esi
  800faf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	7f 08                	jg     800fbd <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbd:	83 ec 0c             	sub    $0xc,%esp
  800fc0:	50                   	push   %eax
  800fc1:	6a 09                	push   $0x9
  800fc3:	68 df 27 80 00       	push   $0x8027df
  800fc8:	6a 23                	push   $0x23
  800fca:	68 fc 27 80 00       	push   $0x8027fc
  800fcf:	e8 6e f3 ff ff       	call   800342 <_panic>

00800fd4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fd4:	f3 0f 1e fb          	endbr32 
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	57                   	push   %edi
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
  800fde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff1:	89 df                	mov    %ebx,%edi
  800ff3:	89 de                	mov    %ebx,%esi
  800ff5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	7f 08                	jg     801003 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801003:	83 ec 0c             	sub    $0xc,%esp
  801006:	50                   	push   %eax
  801007:	6a 0a                	push   $0xa
  801009:	68 df 27 80 00       	push   $0x8027df
  80100e:	6a 23                	push   $0x23
  801010:	68 fc 27 80 00       	push   $0x8027fc
  801015:	e8 28 f3 ff ff       	call   800342 <_panic>

0080101a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80101a:	f3 0f 1e fb          	endbr32 
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
	asm volatile("int %1\n"
  801024:	8b 55 08             	mov    0x8(%ebp),%edx
  801027:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80102f:	be 00 00 00 00       	mov    $0x0,%esi
  801034:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801037:	8b 7d 14             	mov    0x14(%ebp),%edi
  80103a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801041:	f3 0f 1e fb          	endbr32 
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	57                   	push   %edi
  801049:	56                   	push   %esi
  80104a:	53                   	push   %ebx
  80104b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	b8 0d 00 00 00       	mov    $0xd,%eax
  80105b:	89 cb                	mov    %ecx,%ebx
  80105d:	89 cf                	mov    %ecx,%edi
  80105f:	89 ce                	mov    %ecx,%esi
  801061:	cd 30                	int    $0x30
	if(check && ret > 0)
  801063:	85 c0                	test   %eax,%eax
  801065:	7f 08                	jg     80106f <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801067:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106a:	5b                   	pop    %ebx
  80106b:	5e                   	pop    %esi
  80106c:	5f                   	pop    %edi
  80106d:	5d                   	pop    %ebp
  80106e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106f:	83 ec 0c             	sub    $0xc,%esp
  801072:	50                   	push   %eax
  801073:	6a 0d                	push   $0xd
  801075:	68 df 27 80 00       	push   $0x8027df
  80107a:	6a 23                	push   $0x23
  80107c:	68 fc 27 80 00       	push   $0x8027fc
  801081:	e8 bc f2 ff ff       	call   800342 <_panic>

00801086 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801086:	f3 0f 1e fb          	endbr32 
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	8b 55 08             	mov    0x8(%ebp),%edx
  801090:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801096:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801098:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80109b:	83 3a 01             	cmpl   $0x1,(%edx)
  80109e:	7e 09                	jle    8010a9 <argstart+0x23>
  8010a0:	ba 88 24 80 00       	mov    $0x802488,%edx
  8010a5:	85 c9                	test   %ecx,%ecx
  8010a7:	75 05                	jne    8010ae <argstart+0x28>
  8010a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ae:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8010b1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    

008010ba <argnext>:

int
argnext(struct Argstate *args)
{
  8010ba:	f3 0f 1e fb          	endbr32 
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	53                   	push   %ebx
  8010c2:	83 ec 04             	sub    $0x4,%esp
  8010c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8010c8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8010cf:	8b 43 08             	mov    0x8(%ebx),%eax
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	74 74                	je     80114a <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  8010d6:	80 38 00             	cmpb   $0x0,(%eax)
  8010d9:	75 48                	jne    801123 <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8010db:	8b 0b                	mov    (%ebx),%ecx
  8010dd:	83 39 01             	cmpl   $0x1,(%ecx)
  8010e0:	74 5a                	je     80113c <argnext+0x82>
		    || args->argv[1][0] != '-'
  8010e2:	8b 53 04             	mov    0x4(%ebx),%edx
  8010e5:	8b 42 04             	mov    0x4(%edx),%eax
  8010e8:	80 38 2d             	cmpb   $0x2d,(%eax)
  8010eb:	75 4f                	jne    80113c <argnext+0x82>
		    || args->argv[1][1] == '\0')
  8010ed:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8010f1:	74 49                	je     80113c <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8010f3:	83 c0 01             	add    $0x1,%eax
  8010f6:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	8b 01                	mov    (%ecx),%eax
  8010fe:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801105:	50                   	push   %eax
  801106:	8d 42 08             	lea    0x8(%edx),%eax
  801109:	50                   	push   %eax
  80110a:	83 c2 04             	add    $0x4,%edx
  80110d:	52                   	push   %edx
  80110e:	e8 d6 fa ff ff       	call   800be9 <memmove>
		(*args->argc)--;
  801113:	8b 03                	mov    (%ebx),%eax
  801115:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801118:	8b 43 08             	mov    0x8(%ebx),%eax
  80111b:	83 c4 10             	add    $0x10,%esp
  80111e:	80 38 2d             	cmpb   $0x2d,(%eax)
  801121:	74 13                	je     801136 <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801123:	8b 43 08             	mov    0x8(%ebx),%eax
  801126:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  801129:	83 c0 01             	add    $0x1,%eax
  80112c:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80112f:	89 d0                	mov    %edx,%eax
  801131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801134:	c9                   	leave  
  801135:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801136:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80113a:	75 e7                	jne    801123 <argnext+0x69>
	args->curarg = 0;
  80113c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801143:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801148:	eb e5                	jmp    80112f <argnext+0x75>
		return -1;
  80114a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80114f:	eb de                	jmp    80112f <argnext+0x75>

00801151 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801151:	f3 0f 1e fb          	endbr32 
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	53                   	push   %ebx
  801159:	83 ec 04             	sub    $0x4,%esp
  80115c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80115f:	8b 43 08             	mov    0x8(%ebx),%eax
  801162:	85 c0                	test   %eax,%eax
  801164:	74 12                	je     801178 <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  801166:	80 38 00             	cmpb   $0x0,(%eax)
  801169:	74 12                	je     80117d <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  80116b:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  80116e:	c7 43 08 88 24 80 00 	movl   $0x802488,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801175:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    
	} else if (*args->argc > 1) {
  80117d:	8b 13                	mov    (%ebx),%edx
  80117f:	83 3a 01             	cmpl   $0x1,(%edx)
  801182:	7f 10                	jg     801194 <argnextvalue+0x43>
		args->argvalue = 0;
  801184:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80118b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801192:	eb e1                	jmp    801175 <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  801194:	8b 43 04             	mov    0x4(%ebx),%eax
  801197:	8b 48 04             	mov    0x4(%eax),%ecx
  80119a:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80119d:	83 ec 04             	sub    $0x4,%esp
  8011a0:	8b 12                	mov    (%edx),%edx
  8011a2:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8011a9:	52                   	push   %edx
  8011aa:	8d 50 08             	lea    0x8(%eax),%edx
  8011ad:	52                   	push   %edx
  8011ae:	83 c0 04             	add    $0x4,%eax
  8011b1:	50                   	push   %eax
  8011b2:	e8 32 fa ff ff       	call   800be9 <memmove>
		(*args->argc)--;
  8011b7:	8b 03                	mov    (%ebx),%eax
  8011b9:	83 28 01             	subl   $0x1,(%eax)
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	eb b4                	jmp    801175 <argnextvalue+0x24>

008011c1 <argvalue>:
{
  8011c1:	f3 0f 1e fb          	endbr32 
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011ce:	8b 42 0c             	mov    0xc(%edx),%eax
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	74 02                	je     8011d7 <argvalue+0x16>
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	52                   	push   %edx
  8011db:	e8 71 ff ff ff       	call   801151 <argnextvalue>
  8011e0:	83 c4 10             	add    $0x10,%esp
  8011e3:	eb f0                	jmp    8011d5 <argvalue+0x14>

008011e5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011e5:	f3 0f 1e fb          	endbr32 
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	05 00 00 00 30       	add    $0x30000000,%eax
  8011f4:	c1 e8 0c             	shr    $0xc,%eax
}
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011f9:	f3 0f 1e fb          	endbr32 
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801208:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80120d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801212:	5d                   	pop    %ebp
  801213:	c3                   	ret    

00801214 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801214:	f3 0f 1e fb          	endbr32 
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801220:	89 c2                	mov    %eax,%edx
  801222:	c1 ea 16             	shr    $0x16,%edx
  801225:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80122c:	f6 c2 01             	test   $0x1,%dl
  80122f:	74 2d                	je     80125e <fd_alloc+0x4a>
  801231:	89 c2                	mov    %eax,%edx
  801233:	c1 ea 0c             	shr    $0xc,%edx
  801236:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80123d:	f6 c2 01             	test   $0x1,%dl
  801240:	74 1c                	je     80125e <fd_alloc+0x4a>
  801242:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801247:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80124c:	75 d2                	jne    801220 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801257:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80125c:	eb 0a                	jmp    801268 <fd_alloc+0x54>
			*fd_store = fd;
  80125e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801261:	89 01                	mov    %eax,(%ecx)
			return 0;
  801263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    

0080126a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80126a:	f3 0f 1e fb          	endbr32 
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801274:	83 f8 1f             	cmp    $0x1f,%eax
  801277:	77 30                	ja     8012a9 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801279:	c1 e0 0c             	shl    $0xc,%eax
  80127c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801281:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801287:	f6 c2 01             	test   $0x1,%dl
  80128a:	74 24                	je     8012b0 <fd_lookup+0x46>
  80128c:	89 c2                	mov    %eax,%edx
  80128e:	c1 ea 0c             	shr    $0xc,%edx
  801291:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801298:	f6 c2 01             	test   $0x1,%dl
  80129b:	74 1a                	je     8012b7 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80129d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a0:	89 02                	mov    %eax,(%edx)
	return 0;
  8012a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a7:	5d                   	pop    %ebp
  8012a8:	c3                   	ret    
		return -E_INVAL;
  8012a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ae:	eb f7                	jmp    8012a7 <fd_lookup+0x3d>
		return -E_INVAL;
  8012b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b5:	eb f0                	jmp    8012a7 <fd_lookup+0x3d>
  8012b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bc:	eb e9                	jmp    8012a7 <fd_lookup+0x3d>

008012be <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012be:	f3 0f 1e fb          	endbr32 
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	83 ec 08             	sub    $0x8,%esp
  8012c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cb:	ba 88 28 80 00       	mov    $0x802888,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012d0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012d5:	39 08                	cmp    %ecx,(%eax)
  8012d7:	74 33                	je     80130c <dev_lookup+0x4e>
  8012d9:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012dc:	8b 02                	mov    (%edx),%eax
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 f3                	jne    8012d5 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012e2:	a1 20 44 80 00       	mov    0x804420,%eax
  8012e7:	8b 40 48             	mov    0x48(%eax),%eax
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	51                   	push   %ecx
  8012ee:	50                   	push   %eax
  8012ef:	68 0c 28 80 00       	push   $0x80280c
  8012f4:	e8 30 f1 ff ff       	call   800429 <cprintf>
	*dev = 0;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    
			*dev = devtab[i];
  80130c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801311:	b8 00 00 00 00       	mov    $0x0,%eax
  801316:	eb f2                	jmp    80130a <dev_lookup+0x4c>

00801318 <fd_close>:
{
  801318:	f3 0f 1e fb          	endbr32 
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	57                   	push   %edi
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
  801322:	83 ec 24             	sub    $0x24,%esp
  801325:	8b 75 08             	mov    0x8(%ebp),%esi
  801328:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80132b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80132e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80132f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801335:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801338:	50                   	push   %eax
  801339:	e8 2c ff ff ff       	call   80126a <fd_lookup>
  80133e:	89 c3                	mov    %eax,%ebx
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	78 05                	js     80134c <fd_close+0x34>
	    || fd != fd2)
  801347:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80134a:	74 16                	je     801362 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80134c:	89 f8                	mov    %edi,%eax
  80134e:	84 c0                	test   %al,%al
  801350:	b8 00 00 00 00       	mov    $0x0,%eax
  801355:	0f 44 d8             	cmove  %eax,%ebx
}
  801358:	89 d8                	mov    %ebx,%eax
  80135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135d:	5b                   	pop    %ebx
  80135e:	5e                   	pop    %esi
  80135f:	5f                   	pop    %edi
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801368:	50                   	push   %eax
  801369:	ff 36                	pushl  (%esi)
  80136b:	e8 4e ff ff ff       	call   8012be <dev_lookup>
  801370:	89 c3                	mov    %eax,%ebx
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	85 c0                	test   %eax,%eax
  801377:	78 1a                	js     801393 <fd_close+0x7b>
		if (dev->dev_close)
  801379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80137c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80137f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801384:	85 c0                	test   %eax,%eax
  801386:	74 0b                	je     801393 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801388:	83 ec 0c             	sub    $0xc,%esp
  80138b:	56                   	push   %esi
  80138c:	ff d0                	call   *%eax
  80138e:	89 c3                	mov    %eax,%ebx
  801390:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801393:	83 ec 08             	sub    $0x8,%esp
  801396:	56                   	push   %esi
  801397:	6a 00                	push   $0x0
  801399:	e8 64 fb ff ff       	call   800f02 <sys_page_unmap>
	return r;
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	eb b5                	jmp    801358 <fd_close+0x40>

008013a3 <close>:

int
close(int fdnum)
{
  8013a3:	f3 0f 1e fb          	endbr32 
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b0:	50                   	push   %eax
  8013b1:	ff 75 08             	pushl  0x8(%ebp)
  8013b4:	e8 b1 fe ff ff       	call   80126a <fd_lookup>
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	79 02                	jns    8013c2 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    
		return fd_close(fd, 1);
  8013c2:	83 ec 08             	sub    $0x8,%esp
  8013c5:	6a 01                	push   $0x1
  8013c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ca:	e8 49 ff ff ff       	call   801318 <fd_close>
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	eb ec                	jmp    8013c0 <close+0x1d>

008013d4 <close_all>:

void
close_all(void)
{
  8013d4:	f3 0f 1e fb          	endbr32 
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	53                   	push   %ebx
  8013dc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013df:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	53                   	push   %ebx
  8013e8:	e8 b6 ff ff ff       	call   8013a3 <close>
	for (i = 0; i < MAXFD; i++)
  8013ed:	83 c3 01             	add    $0x1,%ebx
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	83 fb 20             	cmp    $0x20,%ebx
  8013f6:	75 ec                	jne    8013e4 <close_all+0x10>
}
  8013f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013fd:	f3 0f 1e fb          	endbr32 
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	57                   	push   %edi
  801405:	56                   	push   %esi
  801406:	53                   	push   %ebx
  801407:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80140a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80140d:	50                   	push   %eax
  80140e:	ff 75 08             	pushl  0x8(%ebp)
  801411:	e8 54 fe ff ff       	call   80126a <fd_lookup>
  801416:	89 c3                	mov    %eax,%ebx
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	85 c0                	test   %eax,%eax
  80141d:	0f 88 81 00 00 00    	js     8014a4 <dup+0xa7>
		return r;
	close(newfdnum);
  801423:	83 ec 0c             	sub    $0xc,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	e8 75 ff ff ff       	call   8013a3 <close>

	newfd = INDEX2FD(newfdnum);
  80142e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801431:	c1 e6 0c             	shl    $0xc,%esi
  801434:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80143a:	83 c4 04             	add    $0x4,%esp
  80143d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801440:	e8 b4 fd ff ff       	call   8011f9 <fd2data>
  801445:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801447:	89 34 24             	mov    %esi,(%esp)
  80144a:	e8 aa fd ff ff       	call   8011f9 <fd2data>
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801454:	89 d8                	mov    %ebx,%eax
  801456:	c1 e8 16             	shr    $0x16,%eax
  801459:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801460:	a8 01                	test   $0x1,%al
  801462:	74 11                	je     801475 <dup+0x78>
  801464:	89 d8                	mov    %ebx,%eax
  801466:	c1 e8 0c             	shr    $0xc,%eax
  801469:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801470:	f6 c2 01             	test   $0x1,%dl
  801473:	75 39                	jne    8014ae <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801475:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801478:	89 d0                	mov    %edx,%eax
  80147a:	c1 e8 0c             	shr    $0xc,%eax
  80147d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801484:	83 ec 0c             	sub    $0xc,%esp
  801487:	25 07 0e 00 00       	and    $0xe07,%eax
  80148c:	50                   	push   %eax
  80148d:	56                   	push   %esi
  80148e:	6a 00                	push   $0x0
  801490:	52                   	push   %edx
  801491:	6a 00                	push   $0x0
  801493:	e8 24 fa ff ff       	call   800ebc <sys_page_map>
  801498:	89 c3                	mov    %eax,%ebx
  80149a:	83 c4 20             	add    $0x20,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 31                	js     8014d2 <dup+0xd5>
		goto err;

	return newfdnum;
  8014a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014a4:	89 d8                	mov    %ebx,%eax
  8014a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a9:	5b                   	pop    %ebx
  8014aa:	5e                   	pop    %esi
  8014ab:	5f                   	pop    %edi
  8014ac:	5d                   	pop    %ebp
  8014ad:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014ae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014b5:	83 ec 0c             	sub    $0xc,%esp
  8014b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8014bd:	50                   	push   %eax
  8014be:	57                   	push   %edi
  8014bf:	6a 00                	push   $0x0
  8014c1:	53                   	push   %ebx
  8014c2:	6a 00                	push   $0x0
  8014c4:	e8 f3 f9 ff ff       	call   800ebc <sys_page_map>
  8014c9:	89 c3                	mov    %eax,%ebx
  8014cb:	83 c4 20             	add    $0x20,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	79 a3                	jns    801475 <dup+0x78>
	sys_page_unmap(0, newfd);
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	56                   	push   %esi
  8014d6:	6a 00                	push   $0x0
  8014d8:	e8 25 fa ff ff       	call   800f02 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014dd:	83 c4 08             	add    $0x8,%esp
  8014e0:	57                   	push   %edi
  8014e1:	6a 00                	push   $0x0
  8014e3:	e8 1a fa ff ff       	call   800f02 <sys_page_unmap>
	return r;
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	eb b7                	jmp    8014a4 <dup+0xa7>

008014ed <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014ed:	f3 0f 1e fb          	endbr32 
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	53                   	push   %ebx
  8014f5:	83 ec 1c             	sub    $0x1c,%esp
  8014f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fe:	50                   	push   %eax
  8014ff:	53                   	push   %ebx
  801500:	e8 65 fd ff ff       	call   80126a <fd_lookup>
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	78 3f                	js     80154b <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150c:	83 ec 08             	sub    $0x8,%esp
  80150f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801512:	50                   	push   %eax
  801513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801516:	ff 30                	pushl  (%eax)
  801518:	e8 a1 fd ff ff       	call   8012be <dev_lookup>
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 27                	js     80154b <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801524:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801527:	8b 42 08             	mov    0x8(%edx),%eax
  80152a:	83 e0 03             	and    $0x3,%eax
  80152d:	83 f8 01             	cmp    $0x1,%eax
  801530:	74 1e                	je     801550 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801535:	8b 40 08             	mov    0x8(%eax),%eax
  801538:	85 c0                	test   %eax,%eax
  80153a:	74 35                	je     801571 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	ff 75 10             	pushl  0x10(%ebp)
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	52                   	push   %edx
  801546:	ff d0                	call   *%eax
  801548:	83 c4 10             	add    $0x10,%esp
}
  80154b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801550:	a1 20 44 80 00       	mov    0x804420,%eax
  801555:	8b 40 48             	mov    0x48(%eax),%eax
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	53                   	push   %ebx
  80155c:	50                   	push   %eax
  80155d:	68 4d 28 80 00       	push   $0x80284d
  801562:	e8 c2 ee ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156f:	eb da                	jmp    80154b <read+0x5e>
		return -E_NOT_SUPP;
  801571:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801576:	eb d3                	jmp    80154b <read+0x5e>

00801578 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801578:	f3 0f 1e fb          	endbr32 
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	57                   	push   %edi
  801580:	56                   	push   %esi
  801581:	53                   	push   %ebx
  801582:	83 ec 0c             	sub    $0xc,%esp
  801585:	8b 7d 08             	mov    0x8(%ebp),%edi
  801588:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80158b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801590:	eb 02                	jmp    801594 <readn+0x1c>
  801592:	01 c3                	add    %eax,%ebx
  801594:	39 f3                	cmp    %esi,%ebx
  801596:	73 21                	jae    8015b9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	89 f0                	mov    %esi,%eax
  80159d:	29 d8                	sub    %ebx,%eax
  80159f:	50                   	push   %eax
  8015a0:	89 d8                	mov    %ebx,%eax
  8015a2:	03 45 0c             	add    0xc(%ebp),%eax
  8015a5:	50                   	push   %eax
  8015a6:	57                   	push   %edi
  8015a7:	e8 41 ff ff ff       	call   8014ed <read>
		if (m < 0)
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	78 04                	js     8015b7 <readn+0x3f>
			return m;
		if (m == 0)
  8015b3:	75 dd                	jne    801592 <readn+0x1a>
  8015b5:	eb 02                	jmp    8015b9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015b7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015b9:	89 d8                	mov    %ebx,%eax
  8015bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015be:	5b                   	pop    %ebx
  8015bf:	5e                   	pop    %esi
  8015c0:	5f                   	pop    %edi
  8015c1:	5d                   	pop    %ebp
  8015c2:	c3                   	ret    

008015c3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015c3:	f3 0f 1e fb          	endbr32 
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	53                   	push   %ebx
  8015cb:	83 ec 1c             	sub    $0x1c,%esp
  8015ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d4:	50                   	push   %eax
  8015d5:	53                   	push   %ebx
  8015d6:	e8 8f fc ff ff       	call   80126a <fd_lookup>
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 3a                	js     80161c <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e8:	50                   	push   %eax
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	ff 30                	pushl  (%eax)
  8015ee:	e8 cb fc ff ff       	call   8012be <dev_lookup>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 22                	js     80161c <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801601:	74 1e                	je     801621 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801606:	8b 52 0c             	mov    0xc(%edx),%edx
  801609:	85 d2                	test   %edx,%edx
  80160b:	74 35                	je     801642 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	ff 75 10             	pushl  0x10(%ebp)
  801613:	ff 75 0c             	pushl  0xc(%ebp)
  801616:	50                   	push   %eax
  801617:	ff d2                	call   *%edx
  801619:	83 c4 10             	add    $0x10,%esp
}
  80161c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161f:	c9                   	leave  
  801620:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801621:	a1 20 44 80 00       	mov    0x804420,%eax
  801626:	8b 40 48             	mov    0x48(%eax),%eax
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	53                   	push   %ebx
  80162d:	50                   	push   %eax
  80162e:	68 69 28 80 00       	push   $0x802869
  801633:	e8 f1 ed ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801640:	eb da                	jmp    80161c <write+0x59>
		return -E_NOT_SUPP;
  801642:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801647:	eb d3                	jmp    80161c <write+0x59>

00801649 <seek>:

int
seek(int fdnum, off_t offset)
{
  801649:	f3 0f 1e fb          	endbr32 
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801653:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801656:	50                   	push   %eax
  801657:	ff 75 08             	pushl  0x8(%ebp)
  80165a:	e8 0b fc ff ff       	call   80126a <fd_lookup>
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	85 c0                	test   %eax,%eax
  801664:	78 0e                	js     801674 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80166f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801676:	f3 0f 1e fb          	endbr32 
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	53                   	push   %ebx
  80167e:	83 ec 1c             	sub    $0x1c,%esp
  801681:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801684:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801687:	50                   	push   %eax
  801688:	53                   	push   %ebx
  801689:	e8 dc fb ff ff       	call   80126a <fd_lookup>
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 37                	js     8016cc <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169f:	ff 30                	pushl  (%eax)
  8016a1:	e8 18 fc ff ff       	call   8012be <dev_lookup>
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	78 1f                	js     8016cc <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b4:	74 1b                	je     8016d1 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b9:	8b 52 18             	mov    0x18(%edx),%edx
  8016bc:	85 d2                	test   %edx,%edx
  8016be:	74 32                	je     8016f2 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	50                   	push   %eax
  8016c7:	ff d2                	call   *%edx
  8016c9:	83 c4 10             	add    $0x10,%esp
}
  8016cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016d1:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016d6:	8b 40 48             	mov    0x48(%eax),%eax
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	53                   	push   %ebx
  8016dd:	50                   	push   %eax
  8016de:	68 2c 28 80 00       	push   $0x80282c
  8016e3:	e8 41 ed ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f0:	eb da                	jmp    8016cc <ftruncate+0x56>
		return -E_NOT_SUPP;
  8016f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f7:	eb d3                	jmp    8016cc <ftruncate+0x56>

008016f9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016f9:	f3 0f 1e fb          	endbr32 
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	53                   	push   %ebx
  801701:	83 ec 1c             	sub    $0x1c,%esp
  801704:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801707:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	e8 57 fb ff ff       	call   80126a <fd_lookup>
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	85 c0                	test   %eax,%eax
  801718:	78 4b                	js     801765 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171a:	83 ec 08             	sub    $0x8,%esp
  80171d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801720:	50                   	push   %eax
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	ff 30                	pushl  (%eax)
  801726:	e8 93 fb ff ff       	call   8012be <dev_lookup>
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 33                	js     801765 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801735:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801739:	74 2f                	je     80176a <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80173b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80173e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801745:	00 00 00 
	stat->st_isdir = 0;
  801748:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80174f:	00 00 00 
	stat->st_dev = dev;
  801752:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801758:	83 ec 08             	sub    $0x8,%esp
  80175b:	53                   	push   %ebx
  80175c:	ff 75 f0             	pushl  -0x10(%ebp)
  80175f:	ff 50 14             	call   *0x14(%eax)
  801762:	83 c4 10             	add    $0x10,%esp
}
  801765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801768:	c9                   	leave  
  801769:	c3                   	ret    
		return -E_NOT_SUPP;
  80176a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80176f:	eb f4                	jmp    801765 <fstat+0x6c>

00801771 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801771:	f3 0f 1e fb          	endbr32 
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	56                   	push   %esi
  801779:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80177a:	83 ec 08             	sub    $0x8,%esp
  80177d:	6a 00                	push   $0x0
  80177f:	ff 75 08             	pushl  0x8(%ebp)
  801782:	e8 fb 01 00 00       	call   801982 <open>
  801787:	89 c3                	mov    %eax,%ebx
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 1b                	js     8017ab <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	ff 75 0c             	pushl  0xc(%ebp)
  801796:	50                   	push   %eax
  801797:	e8 5d ff ff ff       	call   8016f9 <fstat>
  80179c:	89 c6                	mov    %eax,%esi
	close(fd);
  80179e:	89 1c 24             	mov    %ebx,(%esp)
  8017a1:	e8 fd fb ff ff       	call   8013a3 <close>
	return r;
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	89 f3                	mov    %esi,%ebx
}
  8017ab:	89 d8                	mov    %ebx,%eax
  8017ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b0:	5b                   	pop    %ebx
  8017b1:	5e                   	pop    %esi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    

008017b4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	56                   	push   %esi
  8017b8:	53                   	push   %ebx
  8017b9:	89 c6                	mov    %eax,%esi
  8017bb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017bd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017c4:	74 27                	je     8017ed <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017c6:	6a 07                	push   $0x7
  8017c8:	68 00 50 80 00       	push   $0x805000
  8017cd:	56                   	push   %esi
  8017ce:	ff 35 00 40 80 00    	pushl  0x804000
  8017d4:	e8 fa 08 00 00       	call   8020d3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017d9:	83 c4 0c             	add    $0xc,%esp
  8017dc:	6a 00                	push   $0x0
  8017de:	53                   	push   %ebx
  8017df:	6a 00                	push   $0x0
  8017e1:	e8 68 08 00 00       	call   80204e <ipc_recv>
}
  8017e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5e                   	pop    %esi
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	6a 01                	push   $0x1
  8017f2:	e8 34 09 00 00       	call   80212b <ipc_find_env>
  8017f7:	a3 00 40 80 00       	mov    %eax,0x804000
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	eb c5                	jmp    8017c6 <fsipc+0x12>

00801801 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801801:	f3 0f 1e fb          	endbr32 
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	8b 40 0c             	mov    0xc(%eax),%eax
  801811:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801816:	8b 45 0c             	mov    0xc(%ebp),%eax
  801819:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80181e:	ba 00 00 00 00       	mov    $0x0,%edx
  801823:	b8 02 00 00 00       	mov    $0x2,%eax
  801828:	e8 87 ff ff ff       	call   8017b4 <fsipc>
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <devfile_flush>:
{
  80182f:	f3 0f 1e fb          	endbr32 
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8b 40 0c             	mov    0xc(%eax),%eax
  80183f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801844:	ba 00 00 00 00       	mov    $0x0,%edx
  801849:	b8 06 00 00 00       	mov    $0x6,%eax
  80184e:	e8 61 ff ff ff       	call   8017b4 <fsipc>
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <devfile_stat>:
{
  801855:	f3 0f 1e fb          	endbr32 
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	53                   	push   %ebx
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	8b 40 0c             	mov    0xc(%eax),%eax
  801869:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	b8 05 00 00 00       	mov    $0x5,%eax
  801878:	e8 37 ff ff ff       	call   8017b4 <fsipc>
  80187d:	85 c0                	test   %eax,%eax
  80187f:	78 2c                	js     8018ad <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801881:	83 ec 08             	sub    $0x8,%esp
  801884:	68 00 50 80 00       	push   $0x805000
  801889:	53                   	push   %ebx
  80188a:	e8 a4 f1 ff ff       	call   800a33 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80188f:	a1 80 50 80 00       	mov    0x805080,%eax
  801894:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80189a:	a1 84 50 80 00       	mov    0x805084,%eax
  80189f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <devfile_write>:
{
  8018b2:	f3 0f 1e fb          	endbr32 
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 0c             	sub    $0xc,%esp
  8018bc:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8018c5:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8018cb:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8018d0:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8018d5:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8018d8:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018dd:	50                   	push   %eax
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	68 08 50 80 00       	push   $0x805008
  8018e6:	e8 fe f2 ff ff       	call   800be9 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8018eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f0:	b8 04 00 00 00       	mov    $0x4,%eax
  8018f5:	e8 ba fe ff ff       	call   8017b4 <fsipc>
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <devfile_read>:
{
  8018fc:	f3 0f 1e fb          	endbr32 
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	8b 40 0c             	mov    0xc(%eax),%eax
  80190e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801913:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801919:	ba 00 00 00 00       	mov    $0x0,%edx
  80191e:	b8 03 00 00 00       	mov    $0x3,%eax
  801923:	e8 8c fe ff ff       	call   8017b4 <fsipc>
  801928:	89 c3                	mov    %eax,%ebx
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 1f                	js     80194d <devfile_read+0x51>
	assert(r <= n);
  80192e:	39 f0                	cmp    %esi,%eax
  801930:	77 24                	ja     801956 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801932:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801937:	7f 33                	jg     80196c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	50                   	push   %eax
  80193d:	68 00 50 80 00       	push   $0x805000
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	e8 9f f2 ff ff       	call   800be9 <memmove>
	return r;
  80194a:	83 c4 10             	add    $0x10,%esp
}
  80194d:	89 d8                	mov    %ebx,%eax
  80194f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801952:	5b                   	pop    %ebx
  801953:	5e                   	pop    %esi
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    
	assert(r <= n);
  801956:	68 98 28 80 00       	push   $0x802898
  80195b:	68 9f 28 80 00       	push   $0x80289f
  801960:	6a 7c                	push   $0x7c
  801962:	68 b4 28 80 00       	push   $0x8028b4
  801967:	e8 d6 e9 ff ff       	call   800342 <_panic>
	assert(r <= PGSIZE);
  80196c:	68 bf 28 80 00       	push   $0x8028bf
  801971:	68 9f 28 80 00       	push   $0x80289f
  801976:	6a 7d                	push   $0x7d
  801978:	68 b4 28 80 00       	push   $0x8028b4
  80197d:	e8 c0 e9 ff ff       	call   800342 <_panic>

00801982 <open>:
{
  801982:	f3 0f 1e fb          	endbr32 
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	56                   	push   %esi
  80198a:	53                   	push   %ebx
  80198b:	83 ec 1c             	sub    $0x1c,%esp
  80198e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801991:	56                   	push   %esi
  801992:	e8 59 f0 ff ff       	call   8009f0 <strlen>
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80199f:	7f 6c                	jg     801a0d <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a7:	50                   	push   %eax
  8019a8:	e8 67 f8 ff ff       	call   801214 <fd_alloc>
  8019ad:	89 c3                	mov    %eax,%ebx
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 3c                	js     8019f2 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8019b6:	83 ec 08             	sub    $0x8,%esp
  8019b9:	56                   	push   %esi
  8019ba:	68 00 50 80 00       	push   $0x805000
  8019bf:	e8 6f f0 ff ff       	call   800a33 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d4:	e8 db fd ff ff       	call   8017b4 <fsipc>
  8019d9:	89 c3                	mov    %eax,%ebx
  8019db:	83 c4 10             	add    $0x10,%esp
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 19                	js     8019fb <open+0x79>
	return fd2num(fd);
  8019e2:	83 ec 0c             	sub    $0xc,%esp
  8019e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e8:	e8 f8 f7 ff ff       	call   8011e5 <fd2num>
  8019ed:	89 c3                	mov    %eax,%ebx
  8019ef:	83 c4 10             	add    $0x10,%esp
}
  8019f2:	89 d8                	mov    %ebx,%eax
  8019f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    
		fd_close(fd, 0);
  8019fb:	83 ec 08             	sub    $0x8,%esp
  8019fe:	6a 00                	push   $0x0
  801a00:	ff 75 f4             	pushl  -0xc(%ebp)
  801a03:	e8 10 f9 ff ff       	call   801318 <fd_close>
		return r;
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	eb e5                	jmp    8019f2 <open+0x70>
		return -E_BAD_PATH;
  801a0d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a12:	eb de                	jmp    8019f2 <open+0x70>

00801a14 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a14:	f3 0f 1e fb          	endbr32 
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a23:	b8 08 00 00 00       	mov    $0x8,%eax
  801a28:	e8 87 fd ff ff       	call   8017b4 <fsipc>
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a2f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a33:	7f 01                	jg     801a36 <writebuf+0x7>
  801a35:	c3                   	ret    
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	53                   	push   %ebx
  801a3a:	83 ec 08             	sub    $0x8,%esp
  801a3d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a3f:	ff 70 04             	pushl  0x4(%eax)
  801a42:	8d 40 10             	lea    0x10(%eax),%eax
  801a45:	50                   	push   %eax
  801a46:	ff 33                	pushl  (%ebx)
  801a48:	e8 76 fb ff ff       	call   8015c3 <write>
		if (result > 0)
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	7e 03                	jle    801a57 <writebuf+0x28>
			b->result += result;
  801a54:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a57:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a5a:	74 0d                	je     801a69 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a63:	0f 4f c2             	cmovg  %edx,%eax
  801a66:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <putch>:

static void
putch(int ch, void *thunk)
{
  801a6e:	f3 0f 1e fb          	endbr32 
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	53                   	push   %ebx
  801a76:	83 ec 04             	sub    $0x4,%esp
  801a79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a7c:	8b 53 04             	mov    0x4(%ebx),%edx
  801a7f:	8d 42 01             	lea    0x1(%edx),%eax
  801a82:	89 43 04             	mov    %eax,0x4(%ebx)
  801a85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a88:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a8c:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a91:	74 06                	je     801a99 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  801a93:	83 c4 04             	add    $0x4,%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    
		writebuf(b);
  801a99:	89 d8                	mov    %ebx,%eax
  801a9b:	e8 8f ff ff ff       	call   801a2f <writebuf>
		b->idx = 0;
  801aa0:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801aa7:	eb ea                	jmp    801a93 <putch+0x25>

00801aa9 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801aa9:	f3 0f 1e fb          	endbr32 
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801abf:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801ac6:	00 00 00 
	b.result = 0;
  801ac9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ad0:	00 00 00 
	b.error = 1;
  801ad3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801ada:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801add:	ff 75 10             	pushl  0x10(%ebp)
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ae9:	50                   	push   %eax
  801aea:	68 6e 1a 80 00       	push   $0x801a6e
  801aef:	e8 38 ea ff ff       	call   80052c <vprintfmt>
	if (b.idx > 0)
  801af4:	83 c4 10             	add    $0x10,%esp
  801af7:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801afe:	7f 11                	jg     801b11 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801b00:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b06:	85 c0                	test   %eax,%eax
  801b08:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    
		writebuf(&b);
  801b11:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b17:	e8 13 ff ff ff       	call   801a2f <writebuf>
  801b1c:	eb e2                	jmp    801b00 <vfprintf+0x57>

00801b1e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b1e:	f3 0f 1e fb          	endbr32 
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b28:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b2b:	50                   	push   %eax
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	ff 75 08             	pushl  0x8(%ebp)
  801b32:	e8 72 ff ff ff       	call   801aa9 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <printf>:

int
printf(const char *fmt, ...)
{
  801b39:	f3 0f 1e fb          	endbr32 
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b43:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b46:	50                   	push   %eax
  801b47:	ff 75 08             	pushl  0x8(%ebp)
  801b4a:	6a 01                	push   $0x1
  801b4c:	e8 58 ff ff ff       	call   801aa9 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b53:	f3 0f 1e fb          	endbr32 
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	56                   	push   %esi
  801b5b:	53                   	push   %ebx
  801b5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b5f:	83 ec 0c             	sub    $0xc,%esp
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	e8 8f f6 ff ff       	call   8011f9 <fd2data>
  801b6a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b6c:	83 c4 08             	add    $0x8,%esp
  801b6f:	68 cb 28 80 00       	push   $0x8028cb
  801b74:	53                   	push   %ebx
  801b75:	e8 b9 ee ff ff       	call   800a33 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b7a:	8b 46 04             	mov    0x4(%esi),%eax
  801b7d:	2b 06                	sub    (%esi),%eax
  801b7f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b85:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b8c:	00 00 00 
	stat->st_dev = &devpipe;
  801b8f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b96:	30 80 00 
	return 0;
}
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba1:	5b                   	pop    %ebx
  801ba2:	5e                   	pop    %esi
  801ba3:	5d                   	pop    %ebp
  801ba4:	c3                   	ret    

00801ba5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ba5:	f3 0f 1e fb          	endbr32 
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	53                   	push   %ebx
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bb3:	53                   	push   %ebx
  801bb4:	6a 00                	push   $0x0
  801bb6:	e8 47 f3 ff ff       	call   800f02 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bbb:	89 1c 24             	mov    %ebx,(%esp)
  801bbe:	e8 36 f6 ff ff       	call   8011f9 <fd2data>
  801bc3:	83 c4 08             	add    $0x8,%esp
  801bc6:	50                   	push   %eax
  801bc7:	6a 00                	push   $0x0
  801bc9:	e8 34 f3 ff ff       	call   800f02 <sys_page_unmap>
}
  801bce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <_pipeisclosed>:
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	57                   	push   %edi
  801bd7:	56                   	push   %esi
  801bd8:	53                   	push   %ebx
  801bd9:	83 ec 1c             	sub    $0x1c,%esp
  801bdc:	89 c7                	mov    %eax,%edi
  801bde:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801be0:	a1 20 44 80 00       	mov    0x804420,%eax
  801be5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801be8:	83 ec 0c             	sub    $0xc,%esp
  801beb:	57                   	push   %edi
  801bec:	e8 77 05 00 00       	call   802168 <pageref>
  801bf1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bf4:	89 34 24             	mov    %esi,(%esp)
  801bf7:	e8 6c 05 00 00       	call   802168 <pageref>
		nn = thisenv->env_runs;
  801bfc:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801c02:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	39 cb                	cmp    %ecx,%ebx
  801c0a:	74 1b                	je     801c27 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c0c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c0f:	75 cf                	jne    801be0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c11:	8b 42 58             	mov    0x58(%edx),%eax
  801c14:	6a 01                	push   $0x1
  801c16:	50                   	push   %eax
  801c17:	53                   	push   %ebx
  801c18:	68 d2 28 80 00       	push   $0x8028d2
  801c1d:	e8 07 e8 ff ff       	call   800429 <cprintf>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	eb b9                	jmp    801be0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c27:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c2a:	0f 94 c0             	sete   %al
  801c2d:	0f b6 c0             	movzbl %al,%eax
}
  801c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    

00801c38 <devpipe_write>:
{
  801c38:	f3 0f 1e fb          	endbr32 
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	57                   	push   %edi
  801c40:	56                   	push   %esi
  801c41:	53                   	push   %ebx
  801c42:	83 ec 28             	sub    $0x28,%esp
  801c45:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c48:	56                   	push   %esi
  801c49:	e8 ab f5 ff ff       	call   8011f9 <fd2data>
  801c4e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c50:	83 c4 10             	add    $0x10,%esp
  801c53:	bf 00 00 00 00       	mov    $0x0,%edi
  801c58:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c5b:	74 4f                	je     801cac <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c5d:	8b 43 04             	mov    0x4(%ebx),%eax
  801c60:	8b 0b                	mov    (%ebx),%ecx
  801c62:	8d 51 20             	lea    0x20(%ecx),%edx
  801c65:	39 d0                	cmp    %edx,%eax
  801c67:	72 14                	jb     801c7d <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c69:	89 da                	mov    %ebx,%edx
  801c6b:	89 f0                	mov    %esi,%eax
  801c6d:	e8 61 ff ff ff       	call   801bd3 <_pipeisclosed>
  801c72:	85 c0                	test   %eax,%eax
  801c74:	75 3b                	jne    801cb1 <devpipe_write+0x79>
			sys_yield();
  801c76:	e8 d7 f1 ff ff       	call   800e52 <sys_yield>
  801c7b:	eb e0                	jmp    801c5d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c80:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c84:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c87:	89 c2                	mov    %eax,%edx
  801c89:	c1 fa 1f             	sar    $0x1f,%edx
  801c8c:	89 d1                	mov    %edx,%ecx
  801c8e:	c1 e9 1b             	shr    $0x1b,%ecx
  801c91:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c94:	83 e2 1f             	and    $0x1f,%edx
  801c97:	29 ca                	sub    %ecx,%edx
  801c99:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c9d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ca1:	83 c0 01             	add    $0x1,%eax
  801ca4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ca7:	83 c7 01             	add    $0x1,%edi
  801caa:	eb ac                	jmp    801c58 <devpipe_write+0x20>
	return i;
  801cac:	8b 45 10             	mov    0x10(%ebp),%eax
  801caf:	eb 05                	jmp    801cb6 <devpipe_write+0x7e>
				return 0;
  801cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb9:	5b                   	pop    %ebx
  801cba:	5e                   	pop    %esi
  801cbb:	5f                   	pop    %edi
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    

00801cbe <devpipe_read>:
{
  801cbe:	f3 0f 1e fb          	endbr32 
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 18             	sub    $0x18,%esp
  801ccb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cce:	57                   	push   %edi
  801ccf:	e8 25 f5 ff ff       	call   8011f9 <fd2data>
  801cd4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	be 00 00 00 00       	mov    $0x0,%esi
  801cde:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ce1:	75 14                	jne    801cf7 <devpipe_read+0x39>
	return i;
  801ce3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce6:	eb 02                	jmp    801cea <devpipe_read+0x2c>
				return i;
  801ce8:	89 f0                	mov    %esi,%eax
}
  801cea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5e                   	pop    %esi
  801cef:	5f                   	pop    %edi
  801cf0:	5d                   	pop    %ebp
  801cf1:	c3                   	ret    
			sys_yield();
  801cf2:	e8 5b f1 ff ff       	call   800e52 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cf7:	8b 03                	mov    (%ebx),%eax
  801cf9:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cfc:	75 18                	jne    801d16 <devpipe_read+0x58>
			if (i > 0)
  801cfe:	85 f6                	test   %esi,%esi
  801d00:	75 e6                	jne    801ce8 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d02:	89 da                	mov    %ebx,%edx
  801d04:	89 f8                	mov    %edi,%eax
  801d06:	e8 c8 fe ff ff       	call   801bd3 <_pipeisclosed>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	74 e3                	je     801cf2 <devpipe_read+0x34>
				return 0;
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	eb d4                	jmp    801cea <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d16:	99                   	cltd   
  801d17:	c1 ea 1b             	shr    $0x1b,%edx
  801d1a:	01 d0                	add    %edx,%eax
  801d1c:	83 e0 1f             	and    $0x1f,%eax
  801d1f:	29 d0                	sub    %edx,%eax
  801d21:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d29:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d2c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d2f:	83 c6 01             	add    $0x1,%esi
  801d32:	eb aa                	jmp    801cde <devpipe_read+0x20>

00801d34 <pipe>:
{
  801d34:	f3 0f 1e fb          	endbr32 
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	56                   	push   %esi
  801d3c:	53                   	push   %ebx
  801d3d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d43:	50                   	push   %eax
  801d44:	e8 cb f4 ff ff       	call   801214 <fd_alloc>
  801d49:	89 c3                	mov    %eax,%ebx
  801d4b:	83 c4 10             	add    $0x10,%esp
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	0f 88 23 01 00 00    	js     801e79 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d56:	83 ec 04             	sub    $0x4,%esp
  801d59:	68 07 04 00 00       	push   $0x407
  801d5e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d61:	6a 00                	push   $0x0
  801d63:	e8 0d f1 ff ff       	call   800e75 <sys_page_alloc>
  801d68:	89 c3                	mov    %eax,%ebx
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	0f 88 04 01 00 00    	js     801e79 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d75:	83 ec 0c             	sub    $0xc,%esp
  801d78:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d7b:	50                   	push   %eax
  801d7c:	e8 93 f4 ff ff       	call   801214 <fd_alloc>
  801d81:	89 c3                	mov    %eax,%ebx
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	85 c0                	test   %eax,%eax
  801d88:	0f 88 db 00 00 00    	js     801e69 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	68 07 04 00 00       	push   $0x407
  801d96:	ff 75 f0             	pushl  -0x10(%ebp)
  801d99:	6a 00                	push   $0x0
  801d9b:	e8 d5 f0 ff ff       	call   800e75 <sys_page_alloc>
  801da0:	89 c3                	mov    %eax,%ebx
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	85 c0                	test   %eax,%eax
  801da7:	0f 88 bc 00 00 00    	js     801e69 <pipe+0x135>
	va = fd2data(fd0);
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	ff 75 f4             	pushl  -0xc(%ebp)
  801db3:	e8 41 f4 ff ff       	call   8011f9 <fd2data>
  801db8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dba:	83 c4 0c             	add    $0xc,%esp
  801dbd:	68 07 04 00 00       	push   $0x407
  801dc2:	50                   	push   %eax
  801dc3:	6a 00                	push   $0x0
  801dc5:	e8 ab f0 ff ff       	call   800e75 <sys_page_alloc>
  801dca:	89 c3                	mov    %eax,%ebx
  801dcc:	83 c4 10             	add    $0x10,%esp
  801dcf:	85 c0                	test   %eax,%eax
  801dd1:	0f 88 82 00 00 00    	js     801e59 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd7:	83 ec 0c             	sub    $0xc,%esp
  801dda:	ff 75 f0             	pushl  -0x10(%ebp)
  801ddd:	e8 17 f4 ff ff       	call   8011f9 <fd2data>
  801de2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801de9:	50                   	push   %eax
  801dea:	6a 00                	push   $0x0
  801dec:	56                   	push   %esi
  801ded:	6a 00                	push   $0x0
  801def:	e8 c8 f0 ff ff       	call   800ebc <sys_page_map>
  801df4:	89 c3                	mov    %eax,%ebx
  801df6:	83 c4 20             	add    $0x20,%esp
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	78 4e                	js     801e4b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801dfd:	a1 20 30 80 00       	mov    0x803020,%eax
  801e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e05:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e14:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e19:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e20:	83 ec 0c             	sub    $0xc,%esp
  801e23:	ff 75 f4             	pushl  -0xc(%ebp)
  801e26:	e8 ba f3 ff ff       	call   8011e5 <fd2num>
  801e2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e2e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e30:	83 c4 04             	add    $0x4,%esp
  801e33:	ff 75 f0             	pushl  -0x10(%ebp)
  801e36:	e8 aa f3 ff ff       	call   8011e5 <fd2num>
  801e3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e49:	eb 2e                	jmp    801e79 <pipe+0x145>
	sys_page_unmap(0, va);
  801e4b:	83 ec 08             	sub    $0x8,%esp
  801e4e:	56                   	push   %esi
  801e4f:	6a 00                	push   $0x0
  801e51:	e8 ac f0 ff ff       	call   800f02 <sys_page_unmap>
  801e56:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e59:	83 ec 08             	sub    $0x8,%esp
  801e5c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5f:	6a 00                	push   $0x0
  801e61:	e8 9c f0 ff ff       	call   800f02 <sys_page_unmap>
  801e66:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e69:	83 ec 08             	sub    $0x8,%esp
  801e6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6f:	6a 00                	push   $0x0
  801e71:	e8 8c f0 ff ff       	call   800f02 <sys_page_unmap>
  801e76:	83 c4 10             	add    $0x10,%esp
}
  801e79:	89 d8                	mov    %ebx,%eax
  801e7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e7e:	5b                   	pop    %ebx
  801e7f:	5e                   	pop    %esi
  801e80:	5d                   	pop    %ebp
  801e81:	c3                   	ret    

00801e82 <pipeisclosed>:
{
  801e82:	f3 0f 1e fb          	endbr32 
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8f:	50                   	push   %eax
  801e90:	ff 75 08             	pushl  0x8(%ebp)
  801e93:	e8 d2 f3 ff ff       	call   80126a <fd_lookup>
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	78 18                	js     801eb7 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea5:	e8 4f f3 ff ff       	call   8011f9 <fd2data>
  801eaa:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	e8 1f fd ff ff       	call   801bd3 <_pipeisclosed>
  801eb4:	83 c4 10             	add    $0x10,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801eb9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec2:	c3                   	ret    

00801ec3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ec3:	f3 0f 1e fb          	endbr32 
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ecd:	68 ea 28 80 00       	push   $0x8028ea
  801ed2:	ff 75 0c             	pushl  0xc(%ebp)
  801ed5:	e8 59 eb ff ff       	call   800a33 <strcpy>
	return 0;
}
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <devcons_write>:
{
  801ee1:	f3 0f 1e fb          	endbr32 
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	57                   	push   %edi
  801ee9:	56                   	push   %esi
  801eea:	53                   	push   %ebx
  801eeb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ef1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ef6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801efc:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eff:	73 31                	jae    801f32 <devcons_write+0x51>
		m = n - tot;
  801f01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f04:	29 f3                	sub    %esi,%ebx
  801f06:	83 fb 7f             	cmp    $0x7f,%ebx
  801f09:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f0e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f11:	83 ec 04             	sub    $0x4,%esp
  801f14:	53                   	push   %ebx
  801f15:	89 f0                	mov    %esi,%eax
  801f17:	03 45 0c             	add    0xc(%ebp),%eax
  801f1a:	50                   	push   %eax
  801f1b:	57                   	push   %edi
  801f1c:	e8 c8 ec ff ff       	call   800be9 <memmove>
		sys_cputs(buf, m);
  801f21:	83 c4 08             	add    $0x8,%esp
  801f24:	53                   	push   %ebx
  801f25:	57                   	push   %edi
  801f26:	e8 7a ee ff ff       	call   800da5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f2b:	01 de                	add    %ebx,%esi
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	eb ca                	jmp    801efc <devcons_write+0x1b>
}
  801f32:	89 f0                	mov    %esi,%eax
  801f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5f                   	pop    %edi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    

00801f3c <devcons_read>:
{
  801f3c:	f3 0f 1e fb          	endbr32 
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 08             	sub    $0x8,%esp
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f4f:	74 21                	je     801f72 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f51:	e8 71 ee ff ff       	call   800dc7 <sys_cgetc>
  801f56:	85 c0                	test   %eax,%eax
  801f58:	75 07                	jne    801f61 <devcons_read+0x25>
		sys_yield();
  801f5a:	e8 f3 ee ff ff       	call   800e52 <sys_yield>
  801f5f:	eb f0                	jmp    801f51 <devcons_read+0x15>
	if (c < 0)
  801f61:	78 0f                	js     801f72 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f63:	83 f8 04             	cmp    $0x4,%eax
  801f66:	74 0c                	je     801f74 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6b:	88 02                	mov    %al,(%edx)
	return 1;
  801f6d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    
		return 0;
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
  801f79:	eb f7                	jmp    801f72 <devcons_read+0x36>

00801f7b <cputchar>:
{
  801f7b:	f3 0f 1e fb          	endbr32 
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f8b:	6a 01                	push   $0x1
  801f8d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f90:	50                   	push   %eax
  801f91:	e8 0f ee ff ff       	call   800da5 <sys_cputs>
}
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <getchar>:
{
  801f9b:	f3 0f 1e fb          	endbr32 
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fa5:	6a 01                	push   $0x1
  801fa7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801faa:	50                   	push   %eax
  801fab:	6a 00                	push   $0x0
  801fad:	e8 3b f5 ff ff       	call   8014ed <read>
	if (r < 0)
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	78 06                	js     801fbf <getchar+0x24>
	if (r < 1)
  801fb9:	74 06                	je     801fc1 <getchar+0x26>
	return c;
  801fbb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    
		return -E_EOF;
  801fc1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fc6:	eb f7                	jmp    801fbf <getchar+0x24>

00801fc8 <iscons>:
{
  801fc8:	f3 0f 1e fb          	endbr32 
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd5:	50                   	push   %eax
  801fd6:	ff 75 08             	pushl  0x8(%ebp)
  801fd9:	e8 8c f2 ff ff       	call   80126a <fd_lookup>
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	78 11                	js     801ff6 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fee:	39 10                	cmp    %edx,(%eax)
  801ff0:	0f 94 c0             	sete   %al
  801ff3:	0f b6 c0             	movzbl %al,%eax
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <opencons>:
{
  801ff8:	f3 0f 1e fb          	endbr32 
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802002:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802005:	50                   	push   %eax
  802006:	e8 09 f2 ff ff       	call   801214 <fd_alloc>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 3a                	js     80204c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	68 07 04 00 00       	push   $0x407
  80201a:	ff 75 f4             	pushl  -0xc(%ebp)
  80201d:	6a 00                	push   $0x0
  80201f:	e8 51 ee ff ff       	call   800e75 <sys_page_alloc>
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	85 c0                	test   %eax,%eax
  802029:	78 21                	js     80204c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802034:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802040:	83 ec 0c             	sub    $0xc,%esp
  802043:	50                   	push   %eax
  802044:	e8 9c f1 ff ff       	call   8011e5 <fd2num>
  802049:	83 c4 10             	add    $0x10,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80204e:	f3 0f 1e fb          	endbr32 
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	56                   	push   %esi
  802056:	53                   	push   %ebx
  802057:	8b 75 08             	mov    0x8(%ebp),%esi
  80205a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802060:	85 c0                	test   %eax,%eax
  802062:	74 3d                	je     8020a1 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802064:	83 ec 0c             	sub    $0xc,%esp
  802067:	50                   	push   %eax
  802068:	e8 d4 ef ff ff       	call   801041 <sys_ipc_recv>
  80206d:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802070:	85 f6                	test   %esi,%esi
  802072:	74 0b                	je     80207f <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802074:	8b 15 20 44 80 00    	mov    0x804420,%edx
  80207a:	8b 52 74             	mov    0x74(%edx),%edx
  80207d:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80207f:	85 db                	test   %ebx,%ebx
  802081:	74 0b                	je     80208e <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802083:	8b 15 20 44 80 00    	mov    0x804420,%edx
  802089:	8b 52 78             	mov    0x78(%edx),%edx
  80208c:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80208e:	85 c0                	test   %eax,%eax
  802090:	78 21                	js     8020b3 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802092:	a1 20 44 80 00       	mov    0x804420,%eax
  802097:	8b 40 70             	mov    0x70(%eax),%eax
}
  80209a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209d:	5b                   	pop    %ebx
  80209e:	5e                   	pop    %esi
  80209f:	5d                   	pop    %ebp
  8020a0:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	68 00 00 c0 ee       	push   $0xeec00000
  8020a9:	e8 93 ef ff ff       	call   801041 <sys_ipc_recv>
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	eb bd                	jmp    802070 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8020b3:	85 f6                	test   %esi,%esi
  8020b5:	74 10                	je     8020c7 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8020b7:	85 db                	test   %ebx,%ebx
  8020b9:	75 df                	jne    80209a <ipc_recv+0x4c>
  8020bb:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8020c2:	00 00 00 
  8020c5:	eb d3                	jmp    80209a <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8020c7:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8020ce:	00 00 00 
  8020d1:	eb e4                	jmp    8020b7 <ipc_recv+0x69>

008020d3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020d3:	f3 0f 1e fb          	endbr32 
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	57                   	push   %edi
  8020db:	56                   	push   %esi
  8020dc:	53                   	push   %ebx
  8020dd:	83 ec 0c             	sub    $0xc,%esp
  8020e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8020e9:	85 db                	test   %ebx,%ebx
  8020eb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020f0:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8020f3:	ff 75 14             	pushl  0x14(%ebp)
  8020f6:	53                   	push   %ebx
  8020f7:	56                   	push   %esi
  8020f8:	57                   	push   %edi
  8020f9:	e8 1c ef ff ff       	call   80101a <sys_ipc_try_send>
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	85 c0                	test   %eax,%eax
  802103:	79 1e                	jns    802123 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802105:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802108:	75 07                	jne    802111 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80210a:	e8 43 ed ff ff       	call   800e52 <sys_yield>
  80210f:	eb e2                	jmp    8020f3 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802111:	50                   	push   %eax
  802112:	68 f6 28 80 00       	push   $0x8028f6
  802117:	6a 59                	push   $0x59
  802119:	68 11 29 80 00       	push   $0x802911
  80211e:	e8 1f e2 ff ff       	call   800342 <_panic>
	}
}
  802123:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802126:	5b                   	pop    %ebx
  802127:	5e                   	pop    %esi
  802128:	5f                   	pop    %edi
  802129:	5d                   	pop    %ebp
  80212a:	c3                   	ret    

0080212b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80212b:	f3 0f 1e fb          	endbr32 
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802135:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80213a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80213d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802143:	8b 52 50             	mov    0x50(%edx),%edx
  802146:	39 ca                	cmp    %ecx,%edx
  802148:	74 11                	je     80215b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80214a:	83 c0 01             	add    $0x1,%eax
  80214d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802152:	75 e6                	jne    80213a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802154:	b8 00 00 00 00       	mov    $0x0,%eax
  802159:	eb 0b                	jmp    802166 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80215b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80215e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802163:	8b 40 48             	mov    0x48(%eax),%eax
}
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    

00802168 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802168:	f3 0f 1e fb          	endbr32 
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802172:	89 c2                	mov    %eax,%edx
  802174:	c1 ea 16             	shr    $0x16,%edx
  802177:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80217e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802183:	f6 c1 01             	test   $0x1,%cl
  802186:	74 1c                	je     8021a4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802188:	c1 e8 0c             	shr    $0xc,%eax
  80218b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802192:	a8 01                	test   $0x1,%al
  802194:	74 0e                	je     8021a4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802196:	c1 e8 0c             	shr    $0xc,%eax
  802199:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021a0:	ef 
  8021a1:	0f b7 d2             	movzwl %dx,%edx
}
  8021a4:	89 d0                	mov    %edx,%eax
  8021a6:	5d                   	pop    %ebp
  8021a7:	c3                   	ret    
  8021a8:	66 90                	xchg   %ax,%ax
  8021aa:	66 90                	xchg   %ax,%ax
  8021ac:	66 90                	xchg   %ax,%ax
  8021ae:	66 90                	xchg   %ax,%ax

008021b0 <__udivdi3>:
  8021b0:	f3 0f 1e fb          	endbr32 
  8021b4:	55                   	push   %ebp
  8021b5:	57                   	push   %edi
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 1c             	sub    $0x1c,%esp
  8021bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021cb:	85 d2                	test   %edx,%edx
  8021cd:	75 19                	jne    8021e8 <__udivdi3+0x38>
  8021cf:	39 f3                	cmp    %esi,%ebx
  8021d1:	76 4d                	jbe    802220 <__udivdi3+0x70>
  8021d3:	31 ff                	xor    %edi,%edi
  8021d5:	89 e8                	mov    %ebp,%eax
  8021d7:	89 f2                	mov    %esi,%edx
  8021d9:	f7 f3                	div    %ebx
  8021db:	89 fa                	mov    %edi,%edx
  8021dd:	83 c4 1c             	add    $0x1c,%esp
  8021e0:	5b                   	pop    %ebx
  8021e1:	5e                   	pop    %esi
  8021e2:	5f                   	pop    %edi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    
  8021e5:	8d 76 00             	lea    0x0(%esi),%esi
  8021e8:	39 f2                	cmp    %esi,%edx
  8021ea:	76 14                	jbe    802200 <__udivdi3+0x50>
  8021ec:	31 ff                	xor    %edi,%edi
  8021ee:	31 c0                	xor    %eax,%eax
  8021f0:	89 fa                	mov    %edi,%edx
  8021f2:	83 c4 1c             	add    $0x1c,%esp
  8021f5:	5b                   	pop    %ebx
  8021f6:	5e                   	pop    %esi
  8021f7:	5f                   	pop    %edi
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    
  8021fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802200:	0f bd fa             	bsr    %edx,%edi
  802203:	83 f7 1f             	xor    $0x1f,%edi
  802206:	75 48                	jne    802250 <__udivdi3+0xa0>
  802208:	39 f2                	cmp    %esi,%edx
  80220a:	72 06                	jb     802212 <__udivdi3+0x62>
  80220c:	31 c0                	xor    %eax,%eax
  80220e:	39 eb                	cmp    %ebp,%ebx
  802210:	77 de                	ja     8021f0 <__udivdi3+0x40>
  802212:	b8 01 00 00 00       	mov    $0x1,%eax
  802217:	eb d7                	jmp    8021f0 <__udivdi3+0x40>
  802219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802220:	89 d9                	mov    %ebx,%ecx
  802222:	85 db                	test   %ebx,%ebx
  802224:	75 0b                	jne    802231 <__udivdi3+0x81>
  802226:	b8 01 00 00 00       	mov    $0x1,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	f7 f3                	div    %ebx
  80222f:	89 c1                	mov    %eax,%ecx
  802231:	31 d2                	xor    %edx,%edx
  802233:	89 f0                	mov    %esi,%eax
  802235:	f7 f1                	div    %ecx
  802237:	89 c6                	mov    %eax,%esi
  802239:	89 e8                	mov    %ebp,%eax
  80223b:	89 f7                	mov    %esi,%edi
  80223d:	f7 f1                	div    %ecx
  80223f:	89 fa                	mov    %edi,%edx
  802241:	83 c4 1c             	add    $0x1c,%esp
  802244:	5b                   	pop    %ebx
  802245:	5e                   	pop    %esi
  802246:	5f                   	pop    %edi
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    
  802249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802250:	89 f9                	mov    %edi,%ecx
  802252:	b8 20 00 00 00       	mov    $0x20,%eax
  802257:	29 f8                	sub    %edi,%eax
  802259:	d3 e2                	shl    %cl,%edx
  80225b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80225f:	89 c1                	mov    %eax,%ecx
  802261:	89 da                	mov    %ebx,%edx
  802263:	d3 ea                	shr    %cl,%edx
  802265:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802269:	09 d1                	or     %edx,%ecx
  80226b:	89 f2                	mov    %esi,%edx
  80226d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802271:	89 f9                	mov    %edi,%ecx
  802273:	d3 e3                	shl    %cl,%ebx
  802275:	89 c1                	mov    %eax,%ecx
  802277:	d3 ea                	shr    %cl,%edx
  802279:	89 f9                	mov    %edi,%ecx
  80227b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80227f:	89 eb                	mov    %ebp,%ebx
  802281:	d3 e6                	shl    %cl,%esi
  802283:	89 c1                	mov    %eax,%ecx
  802285:	d3 eb                	shr    %cl,%ebx
  802287:	09 de                	or     %ebx,%esi
  802289:	89 f0                	mov    %esi,%eax
  80228b:	f7 74 24 08          	divl   0x8(%esp)
  80228f:	89 d6                	mov    %edx,%esi
  802291:	89 c3                	mov    %eax,%ebx
  802293:	f7 64 24 0c          	mull   0xc(%esp)
  802297:	39 d6                	cmp    %edx,%esi
  802299:	72 15                	jb     8022b0 <__udivdi3+0x100>
  80229b:	89 f9                	mov    %edi,%ecx
  80229d:	d3 e5                	shl    %cl,%ebp
  80229f:	39 c5                	cmp    %eax,%ebp
  8022a1:	73 04                	jae    8022a7 <__udivdi3+0xf7>
  8022a3:	39 d6                	cmp    %edx,%esi
  8022a5:	74 09                	je     8022b0 <__udivdi3+0x100>
  8022a7:	89 d8                	mov    %ebx,%eax
  8022a9:	31 ff                	xor    %edi,%edi
  8022ab:	e9 40 ff ff ff       	jmp    8021f0 <__udivdi3+0x40>
  8022b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022b3:	31 ff                	xor    %edi,%edi
  8022b5:	e9 36 ff ff ff       	jmp    8021f0 <__udivdi3+0x40>
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__umoddi3>:
  8022c0:	f3 0f 1e fb          	endbr32 
  8022c4:	55                   	push   %ebp
  8022c5:	57                   	push   %edi
  8022c6:	56                   	push   %esi
  8022c7:	53                   	push   %ebx
  8022c8:	83 ec 1c             	sub    $0x1c,%esp
  8022cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	75 19                	jne    8022f8 <__umoddi3+0x38>
  8022df:	39 df                	cmp    %ebx,%edi
  8022e1:	76 5d                	jbe    802340 <__umoddi3+0x80>
  8022e3:	89 f0                	mov    %esi,%eax
  8022e5:	89 da                	mov    %ebx,%edx
  8022e7:	f7 f7                	div    %edi
  8022e9:	89 d0                	mov    %edx,%eax
  8022eb:	31 d2                	xor    %edx,%edx
  8022ed:	83 c4 1c             	add    $0x1c,%esp
  8022f0:	5b                   	pop    %ebx
  8022f1:	5e                   	pop    %esi
  8022f2:	5f                   	pop    %edi
  8022f3:	5d                   	pop    %ebp
  8022f4:	c3                   	ret    
  8022f5:	8d 76 00             	lea    0x0(%esi),%esi
  8022f8:	89 f2                	mov    %esi,%edx
  8022fa:	39 d8                	cmp    %ebx,%eax
  8022fc:	76 12                	jbe    802310 <__umoddi3+0x50>
  8022fe:	89 f0                	mov    %esi,%eax
  802300:	89 da                	mov    %ebx,%edx
  802302:	83 c4 1c             	add    $0x1c,%esp
  802305:	5b                   	pop    %ebx
  802306:	5e                   	pop    %esi
  802307:	5f                   	pop    %edi
  802308:	5d                   	pop    %ebp
  802309:	c3                   	ret    
  80230a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802310:	0f bd e8             	bsr    %eax,%ebp
  802313:	83 f5 1f             	xor    $0x1f,%ebp
  802316:	75 50                	jne    802368 <__umoddi3+0xa8>
  802318:	39 d8                	cmp    %ebx,%eax
  80231a:	0f 82 e0 00 00 00    	jb     802400 <__umoddi3+0x140>
  802320:	89 d9                	mov    %ebx,%ecx
  802322:	39 f7                	cmp    %esi,%edi
  802324:	0f 86 d6 00 00 00    	jbe    802400 <__umoddi3+0x140>
  80232a:	89 d0                	mov    %edx,%eax
  80232c:	89 ca                	mov    %ecx,%edx
  80232e:	83 c4 1c             	add    $0x1c,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    
  802336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80233d:	8d 76 00             	lea    0x0(%esi),%esi
  802340:	89 fd                	mov    %edi,%ebp
  802342:	85 ff                	test   %edi,%edi
  802344:	75 0b                	jne    802351 <__umoddi3+0x91>
  802346:	b8 01 00 00 00       	mov    $0x1,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	f7 f7                	div    %edi
  80234f:	89 c5                	mov    %eax,%ebp
  802351:	89 d8                	mov    %ebx,%eax
  802353:	31 d2                	xor    %edx,%edx
  802355:	f7 f5                	div    %ebp
  802357:	89 f0                	mov    %esi,%eax
  802359:	f7 f5                	div    %ebp
  80235b:	89 d0                	mov    %edx,%eax
  80235d:	31 d2                	xor    %edx,%edx
  80235f:	eb 8c                	jmp    8022ed <__umoddi3+0x2d>
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	89 e9                	mov    %ebp,%ecx
  80236a:	ba 20 00 00 00       	mov    $0x20,%edx
  80236f:	29 ea                	sub    %ebp,%edx
  802371:	d3 e0                	shl    %cl,%eax
  802373:	89 44 24 08          	mov    %eax,0x8(%esp)
  802377:	89 d1                	mov    %edx,%ecx
  802379:	89 f8                	mov    %edi,%eax
  80237b:	d3 e8                	shr    %cl,%eax
  80237d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802381:	89 54 24 04          	mov    %edx,0x4(%esp)
  802385:	8b 54 24 04          	mov    0x4(%esp),%edx
  802389:	09 c1                	or     %eax,%ecx
  80238b:	89 d8                	mov    %ebx,%eax
  80238d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802391:	89 e9                	mov    %ebp,%ecx
  802393:	d3 e7                	shl    %cl,%edi
  802395:	89 d1                	mov    %edx,%ecx
  802397:	d3 e8                	shr    %cl,%eax
  802399:	89 e9                	mov    %ebp,%ecx
  80239b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80239f:	d3 e3                	shl    %cl,%ebx
  8023a1:	89 c7                	mov    %eax,%edi
  8023a3:	89 d1                	mov    %edx,%ecx
  8023a5:	89 f0                	mov    %esi,%eax
  8023a7:	d3 e8                	shr    %cl,%eax
  8023a9:	89 e9                	mov    %ebp,%ecx
  8023ab:	89 fa                	mov    %edi,%edx
  8023ad:	d3 e6                	shl    %cl,%esi
  8023af:	09 d8                	or     %ebx,%eax
  8023b1:	f7 74 24 08          	divl   0x8(%esp)
  8023b5:	89 d1                	mov    %edx,%ecx
  8023b7:	89 f3                	mov    %esi,%ebx
  8023b9:	f7 64 24 0c          	mull   0xc(%esp)
  8023bd:	89 c6                	mov    %eax,%esi
  8023bf:	89 d7                	mov    %edx,%edi
  8023c1:	39 d1                	cmp    %edx,%ecx
  8023c3:	72 06                	jb     8023cb <__umoddi3+0x10b>
  8023c5:	75 10                	jne    8023d7 <__umoddi3+0x117>
  8023c7:	39 c3                	cmp    %eax,%ebx
  8023c9:	73 0c                	jae    8023d7 <__umoddi3+0x117>
  8023cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023d3:	89 d7                	mov    %edx,%edi
  8023d5:	89 c6                	mov    %eax,%esi
  8023d7:	89 ca                	mov    %ecx,%edx
  8023d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023de:	29 f3                	sub    %esi,%ebx
  8023e0:	19 fa                	sbb    %edi,%edx
  8023e2:	89 d0                	mov    %edx,%eax
  8023e4:	d3 e0                	shl    %cl,%eax
  8023e6:	89 e9                	mov    %ebp,%ecx
  8023e8:	d3 eb                	shr    %cl,%ebx
  8023ea:	d3 ea                	shr    %cl,%edx
  8023ec:	09 d8                	or     %ebx,%eax
  8023ee:	83 c4 1c             	add    $0x1c,%esp
  8023f1:	5b                   	pop    %ebx
  8023f2:	5e                   	pop    %esi
  8023f3:	5f                   	pop    %edi
  8023f4:	5d                   	pop    %ebp
  8023f5:	c3                   	ret    
  8023f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023fd:	8d 76 00             	lea    0x0(%esi),%esi
  802400:	29 fe                	sub    %edi,%esi
  802402:	19 c3                	sbb    %eax,%ebx
  802404:	89 f2                	mov    %esi,%edx
  802406:	89 d9                	mov    %ebx,%ecx
  802408:	e9 1d ff ff ff       	jmp    80232a <__umoddi3+0x6a>
