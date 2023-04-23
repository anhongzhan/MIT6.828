
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
  80005e:	68 82 29 80 00       	push   $0x802982
  800063:	e8 85 1b 00 00       	call   801bed <printf>
  800068:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  80006b:	85 db                	test   %ebx,%ebx
  80006d:	74 1c                	je     80008b <ls1+0x58>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006f:	b8 e8 29 80 00       	mov    $0x8029e8,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800074:	80 3b 00             	cmpb   $0x0,(%ebx)
  800077:	75 4b                	jne    8000c4 <ls1+0x91>
		printf("%s%s", prefix, sep);
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 8b 29 80 00       	push   $0x80298b
  800083:	e8 65 1b 00 00       	call   801bed <printf>
  800088:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	ff 75 14             	pushl  0x14(%ebp)
  800091:	68 15 2e 80 00       	push   $0x802e15
  800096:	e8 52 1b 00 00       	call   801bed <printf>
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
  8000b0:	68 e7 29 80 00       	push   $0x8029e7
  8000b5:	e8 33 1b 00 00       	call   801bed <printf>
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
  8000d5:	b8 80 29 80 00       	mov    $0x802980,%eax
  8000da:	ba e8 29 80 00       	mov    $0x8029e8,%edx
  8000df:	0f 44 c2             	cmove  %edx,%eax
  8000e2:	eb 95                	jmp    800079 <ls1+0x46>
		printf("/");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 80 29 80 00       	push   $0x802980
  8000ec:	e8 fc 1a 00 00       	call   801bed <printf>
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
  80010c:	e8 25 19 00 00       	call   801a36 <open>
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
  80012a:	e8 fd 14 00 00       	call   80162c <readn>
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
  800169:	68 90 29 80 00       	push   $0x802990
  80016e:	6a 1d                	push   $0x1d
  800170:	68 9c 29 80 00       	push   $0x80299c
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
  800189:	68 a6 29 80 00       	push   $0x8029a6
  80018e:	6a 22                	push   $0x22
  800190:	68 9c 29 80 00       	push   $0x80299c
  800195:	e8 a8 01 00 00       	call   800342 <_panic>
		panic("error reading directory %s: %e", path, n);
  80019a:	83 ec 0c             	sub    $0xc,%esp
  80019d:	50                   	push   %eax
  80019e:	57                   	push   %edi
  80019f:	68 ec 29 80 00       	push   $0x8029ec
  8001a4:	6a 24                	push   $0x24
  8001a6:	68 9c 29 80 00       	push   $0x80299c
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
  8001c9:	e8 57 16 00 00       	call   801825 <stat>
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
  800206:	68 c1 29 80 00       	push   $0x8029c1
  80020b:	6a 0f                	push   $0xf
  80020d:	68 9c 29 80 00       	push   $0x80299c
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
  800232:	68 cd 29 80 00       	push   $0x8029cd
  800237:	e8 b1 19 00 00       	call   801bed <printf>
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
  80025e:	e8 d2 0e 00 00       	call   801135 <argstart>
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
  800277:	e8 ed 0e 00 00       	call   801169 <argnext>
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
  8002a7:	68 e8 29 80 00       	push   $0x8029e8
  8002ac:	68 80 29 80 00       	push   $0x802980
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
  80032e:	e8 55 11 00 00       	call   801488 <close_all>
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
  800364:	68 18 2a 80 00       	push   $0x802a18
  800369:	e8 bb 00 00 00       	call   800429 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036e:	83 c4 18             	add    $0x18,%esp
  800371:	53                   	push   %ebx
  800372:	ff 75 10             	pushl  0x10(%ebp)
  800375:	e8 5a 00 00 00       	call   8003d4 <vcprintf>
	cprintf("\n");
  80037a:	c7 04 24 e7 29 80 00 	movl   $0x8029e7,(%esp)
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
  80048f:	e8 8c 22 00 00       	call   802720 <__udivdi3>
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
  8004cd:	e8 5e 23 00 00       	call   802830 <__umoddi3>
  8004d2:	83 c4 14             	add    $0x14,%esp
  8004d5:	0f be 80 3b 2a 80 00 	movsbl 0x802a3b(%eax),%eax
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
  80057c:	3e ff 24 85 80 2b 80 	notrack jmp *0x802b80(,%eax,4)
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
  800649:	8b 14 85 e0 2c 80 00 	mov    0x802ce0(,%eax,4),%edx
  800650:	85 d2                	test   %edx,%edx
  800652:	74 18                	je     80066c <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800654:	52                   	push   %edx
  800655:	68 15 2e 80 00       	push   $0x802e15
  80065a:	53                   	push   %ebx
  80065b:	56                   	push   %esi
  80065c:	e8 aa fe ff ff       	call   80050b <printfmt>
  800661:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800664:	89 7d 14             	mov    %edi,0x14(%ebp)
  800667:	e9 66 02 00 00       	jmp    8008d2 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80066c:	50                   	push   %eax
  80066d:	68 53 2a 80 00       	push   $0x802a53
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
  800694:	b8 4c 2a 80 00       	mov    $0x802a4c,%eax
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
  800e1e:	68 3f 2d 80 00       	push   $0x802d3f
  800e23:	6a 23                	push   $0x23
  800e25:	68 5c 2d 80 00       	push   $0x802d5c
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
  800eab:	68 3f 2d 80 00       	push   $0x802d3f
  800eb0:	6a 23                	push   $0x23
  800eb2:	68 5c 2d 80 00       	push   $0x802d5c
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
  800ef1:	68 3f 2d 80 00       	push   $0x802d3f
  800ef6:	6a 23                	push   $0x23
  800ef8:	68 5c 2d 80 00       	push   $0x802d5c
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
  800f37:	68 3f 2d 80 00       	push   $0x802d3f
  800f3c:	6a 23                	push   $0x23
  800f3e:	68 5c 2d 80 00       	push   $0x802d5c
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
  800f7d:	68 3f 2d 80 00       	push   $0x802d3f
  800f82:	6a 23                	push   $0x23
  800f84:	68 5c 2d 80 00       	push   $0x802d5c
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
  800fc3:	68 3f 2d 80 00       	push   $0x802d3f
  800fc8:	6a 23                	push   $0x23
  800fca:	68 5c 2d 80 00       	push   $0x802d5c
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
  801009:	68 3f 2d 80 00       	push   $0x802d3f
  80100e:	6a 23                	push   $0x23
  801010:	68 5c 2d 80 00       	push   $0x802d5c
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
  801075:	68 3f 2d 80 00       	push   $0x802d3f
  80107a:	6a 23                	push   $0x23
  80107c:	68 5c 2d 80 00       	push   $0x802d5c
  801081:	e8 bc f2 ff ff       	call   800342 <_panic>

00801086 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801086:	f3 0f 1e fb          	endbr32 
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801090:	ba 00 00 00 00       	mov    $0x0,%edx
  801095:	b8 0e 00 00 00       	mov    $0xe,%eax
  80109a:	89 d1                	mov    %edx,%ecx
  80109c:	89 d3                	mov    %edx,%ebx
  80109e:	89 d7                	mov    %edx,%edi
  8010a0:	89 d6                	mov    %edx,%esi
  8010a2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8010a9:	f3 0f 1e fb          	endbr32 
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010c6:	89 df                	mov    %ebx,%edi
  8010c8:	89 de                	mov    %ebx,%esi
  8010ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	7f 08                	jg     8010d8 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8010d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d3:	5b                   	pop    %ebx
  8010d4:	5e                   	pop    %esi
  8010d5:	5f                   	pop    %edi
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d8:	83 ec 0c             	sub    $0xc,%esp
  8010db:	50                   	push   %eax
  8010dc:	6a 0f                	push   $0xf
  8010de:	68 3f 2d 80 00       	push   $0x802d3f
  8010e3:	6a 23                	push   $0x23
  8010e5:	68 5c 2d 80 00       	push   $0x802d5c
  8010ea:	e8 53 f2 ff ff       	call   800342 <_panic>

008010ef <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8010ef:	f3 0f 1e fb          	endbr32 
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	57                   	push   %edi
  8010f7:	56                   	push   %esi
  8010f8:	53                   	push   %ebx
  8010f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801101:	8b 55 08             	mov    0x8(%ebp),%edx
  801104:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801107:	b8 10 00 00 00       	mov    $0x10,%eax
  80110c:	89 df                	mov    %ebx,%edi
  80110e:	89 de                	mov    %ebx,%esi
  801110:	cd 30                	int    $0x30
	if(check && ret > 0)
  801112:	85 c0                	test   %eax,%eax
  801114:	7f 08                	jg     80111e <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  801116:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801119:	5b                   	pop    %ebx
  80111a:	5e                   	pop    %esi
  80111b:	5f                   	pop    %edi
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80111e:	83 ec 0c             	sub    $0xc,%esp
  801121:	50                   	push   %eax
  801122:	6a 10                	push   $0x10
  801124:	68 3f 2d 80 00       	push   $0x802d3f
  801129:	6a 23                	push   $0x23
  80112b:	68 5c 2d 80 00       	push   $0x802d5c
  801130:	e8 0d f2 ff ff       	call   800342 <_panic>

00801135 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801135:	f3 0f 1e fb          	endbr32 
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	8b 55 08             	mov    0x8(%ebp),%edx
  80113f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801142:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801145:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801147:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80114a:	83 3a 01             	cmpl   $0x1,(%edx)
  80114d:	7e 09                	jle    801158 <argstart+0x23>
  80114f:	ba e8 29 80 00       	mov    $0x8029e8,%edx
  801154:	85 c9                	test   %ecx,%ecx
  801156:	75 05                	jne    80115d <argstart+0x28>
  801158:	ba 00 00 00 00       	mov    $0x0,%edx
  80115d:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801160:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <argnext>:

int
argnext(struct Argstate *args)
{
  801169:	f3 0f 1e fb          	endbr32 
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	53                   	push   %ebx
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801177:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80117e:	8b 43 08             	mov    0x8(%ebx),%eax
  801181:	85 c0                	test   %eax,%eax
  801183:	74 74                	je     8011f9 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  801185:	80 38 00             	cmpb   $0x0,(%eax)
  801188:	75 48                	jne    8011d2 <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80118a:	8b 0b                	mov    (%ebx),%ecx
  80118c:	83 39 01             	cmpl   $0x1,(%ecx)
  80118f:	74 5a                	je     8011eb <argnext+0x82>
		    || args->argv[1][0] != '-'
  801191:	8b 53 04             	mov    0x4(%ebx),%edx
  801194:	8b 42 04             	mov    0x4(%edx),%eax
  801197:	80 38 2d             	cmpb   $0x2d,(%eax)
  80119a:	75 4f                	jne    8011eb <argnext+0x82>
		    || args->argv[1][1] == '\0')
  80119c:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8011a0:	74 49                	je     8011eb <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8011a2:	83 c0 01             	add    $0x1,%eax
  8011a5:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8011a8:	83 ec 04             	sub    $0x4,%esp
  8011ab:	8b 01                	mov    (%ecx),%eax
  8011ad:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8011b4:	50                   	push   %eax
  8011b5:	8d 42 08             	lea    0x8(%edx),%eax
  8011b8:	50                   	push   %eax
  8011b9:	83 c2 04             	add    $0x4,%edx
  8011bc:	52                   	push   %edx
  8011bd:	e8 27 fa ff ff       	call   800be9 <memmove>
		(*args->argc)--;
  8011c2:	8b 03                	mov    (%ebx),%eax
  8011c4:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8011c7:	8b 43 08             	mov    0x8(%ebx),%eax
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	80 38 2d             	cmpb   $0x2d,(%eax)
  8011d0:	74 13                	je     8011e5 <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8011d2:	8b 43 08             	mov    0x8(%ebx),%eax
  8011d5:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  8011d8:	83 c0 01             	add    $0x1,%eax
  8011db:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8011de:	89 d0                	mov    %edx,%eax
  8011e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8011e5:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8011e9:	75 e7                	jne    8011d2 <argnext+0x69>
	args->curarg = 0;
  8011eb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8011f2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8011f7:	eb e5                	jmp    8011de <argnext+0x75>
		return -1;
  8011f9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8011fe:	eb de                	jmp    8011de <argnext+0x75>

00801200 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801200:	f3 0f 1e fb          	endbr32 
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	53                   	push   %ebx
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80120e:	8b 43 08             	mov    0x8(%ebx),%eax
  801211:	85 c0                	test   %eax,%eax
  801213:	74 12                	je     801227 <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  801215:	80 38 00             	cmpb   $0x0,(%eax)
  801218:	74 12                	je     80122c <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  80121a:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  80121d:	c7 43 08 e8 29 80 00 	movl   $0x8029e8,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801224:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801227:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    
	} else if (*args->argc > 1) {
  80122c:	8b 13                	mov    (%ebx),%edx
  80122e:	83 3a 01             	cmpl   $0x1,(%edx)
  801231:	7f 10                	jg     801243 <argnextvalue+0x43>
		args->argvalue = 0;
  801233:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80123a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801241:	eb e1                	jmp    801224 <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  801243:	8b 43 04             	mov    0x4(%ebx),%eax
  801246:	8b 48 04             	mov    0x4(%eax),%ecx
  801249:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80124c:	83 ec 04             	sub    $0x4,%esp
  80124f:	8b 12                	mov    (%edx),%edx
  801251:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801258:	52                   	push   %edx
  801259:	8d 50 08             	lea    0x8(%eax),%edx
  80125c:	52                   	push   %edx
  80125d:	83 c0 04             	add    $0x4,%eax
  801260:	50                   	push   %eax
  801261:	e8 83 f9 ff ff       	call   800be9 <memmove>
		(*args->argc)--;
  801266:	8b 03                	mov    (%ebx),%eax
  801268:	83 28 01             	subl   $0x1,(%eax)
  80126b:	83 c4 10             	add    $0x10,%esp
  80126e:	eb b4                	jmp    801224 <argnextvalue+0x24>

00801270 <argvalue>:
{
  801270:	f3 0f 1e fb          	endbr32 
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80127d:	8b 42 0c             	mov    0xc(%edx),%eax
  801280:	85 c0                	test   %eax,%eax
  801282:	74 02                	je     801286 <argvalue+0x16>
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801286:	83 ec 0c             	sub    $0xc,%esp
  801289:	52                   	push   %edx
  80128a:	e8 71 ff ff ff       	call   801200 <argnextvalue>
  80128f:	83 c4 10             	add    $0x10,%esp
  801292:	eb f0                	jmp    801284 <argvalue+0x14>

00801294 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801294:	f3 0f 1e fb          	endbr32 
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	05 00 00 00 30       	add    $0x30000000,%eax
  8012a3:	c1 e8 0c             	shr    $0xc,%eax
}
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012a8:	f3 0f 1e fb          	endbr32 
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012bc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    

008012c3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012c3:	f3 0f 1e fb          	endbr32 
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012cf:	89 c2                	mov    %eax,%edx
  8012d1:	c1 ea 16             	shr    $0x16,%edx
  8012d4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012db:	f6 c2 01             	test   $0x1,%dl
  8012de:	74 2d                	je     80130d <fd_alloc+0x4a>
  8012e0:	89 c2                	mov    %eax,%edx
  8012e2:	c1 ea 0c             	shr    $0xc,%edx
  8012e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ec:	f6 c2 01             	test   $0x1,%dl
  8012ef:	74 1c                	je     80130d <fd_alloc+0x4a>
  8012f1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012f6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012fb:	75 d2                	jne    8012cf <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801306:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80130b:	eb 0a                	jmp    801317 <fd_alloc+0x54>
			*fd_store = fd;
  80130d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801310:	89 01                	mov    %eax,(%ecx)
			return 0;
  801312:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    

00801319 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801319:	f3 0f 1e fb          	endbr32 
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801323:	83 f8 1f             	cmp    $0x1f,%eax
  801326:	77 30                	ja     801358 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801328:	c1 e0 0c             	shl    $0xc,%eax
  80132b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801330:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801336:	f6 c2 01             	test   $0x1,%dl
  801339:	74 24                	je     80135f <fd_lookup+0x46>
  80133b:	89 c2                	mov    %eax,%edx
  80133d:	c1 ea 0c             	shr    $0xc,%edx
  801340:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801347:	f6 c2 01             	test   $0x1,%dl
  80134a:	74 1a                	je     801366 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80134c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134f:	89 02                	mov    %eax,(%edx)
	return 0;
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801356:	5d                   	pop    %ebp
  801357:	c3                   	ret    
		return -E_INVAL;
  801358:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135d:	eb f7                	jmp    801356 <fd_lookup+0x3d>
		return -E_INVAL;
  80135f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801364:	eb f0                	jmp    801356 <fd_lookup+0x3d>
  801366:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80136b:	eb e9                	jmp    801356 <fd_lookup+0x3d>

0080136d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80136d:	f3 0f 1e fb          	endbr32 
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 08             	sub    $0x8,%esp
  801377:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80137a:	ba 00 00 00 00       	mov    $0x0,%edx
  80137f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801384:	39 08                	cmp    %ecx,(%eax)
  801386:	74 38                	je     8013c0 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801388:	83 c2 01             	add    $0x1,%edx
  80138b:	8b 04 95 e8 2d 80 00 	mov    0x802de8(,%edx,4),%eax
  801392:	85 c0                	test   %eax,%eax
  801394:	75 ee                	jne    801384 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801396:	a1 20 44 80 00       	mov    0x804420,%eax
  80139b:	8b 40 48             	mov    0x48(%eax),%eax
  80139e:	83 ec 04             	sub    $0x4,%esp
  8013a1:	51                   	push   %ecx
  8013a2:	50                   	push   %eax
  8013a3:	68 6c 2d 80 00       	push   $0x802d6c
  8013a8:	e8 7c f0 ff ff       	call   800429 <cprintf>
	*dev = 0;
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    
			*dev = devtab[i];
  8013c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ca:	eb f2                	jmp    8013be <dev_lookup+0x51>

008013cc <fd_close>:
{
  8013cc:	f3 0f 1e fb          	endbr32 
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	57                   	push   %edi
  8013d4:	56                   	push   %esi
  8013d5:	53                   	push   %ebx
  8013d6:	83 ec 24             	sub    $0x24,%esp
  8013d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8013dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013e2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013e9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013ec:	50                   	push   %eax
  8013ed:	e8 27 ff ff ff       	call   801319 <fd_lookup>
  8013f2:	89 c3                	mov    %eax,%ebx
  8013f4:	83 c4 10             	add    $0x10,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	78 05                	js     801400 <fd_close+0x34>
	    || fd != fd2)
  8013fb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013fe:	74 16                	je     801416 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801400:	89 f8                	mov    %edi,%eax
  801402:	84 c0                	test   %al,%al
  801404:	b8 00 00 00 00       	mov    $0x0,%eax
  801409:	0f 44 d8             	cmove  %eax,%ebx
}
  80140c:	89 d8                	mov    %ebx,%eax
  80140e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801411:	5b                   	pop    %ebx
  801412:	5e                   	pop    %esi
  801413:	5f                   	pop    %edi
  801414:	5d                   	pop    %ebp
  801415:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80141c:	50                   	push   %eax
  80141d:	ff 36                	pushl  (%esi)
  80141f:	e8 49 ff ff ff       	call   80136d <dev_lookup>
  801424:	89 c3                	mov    %eax,%ebx
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	78 1a                	js     801447 <fd_close+0x7b>
		if (dev->dev_close)
  80142d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801430:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801433:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801438:	85 c0                	test   %eax,%eax
  80143a:	74 0b                	je     801447 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80143c:	83 ec 0c             	sub    $0xc,%esp
  80143f:	56                   	push   %esi
  801440:	ff d0                	call   *%eax
  801442:	89 c3                	mov    %eax,%ebx
  801444:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801447:	83 ec 08             	sub    $0x8,%esp
  80144a:	56                   	push   %esi
  80144b:	6a 00                	push   $0x0
  80144d:	e8 b0 fa ff ff       	call   800f02 <sys_page_unmap>
	return r;
  801452:	83 c4 10             	add    $0x10,%esp
  801455:	eb b5                	jmp    80140c <fd_close+0x40>

00801457 <close>:

int
close(int fdnum)
{
  801457:	f3 0f 1e fb          	endbr32 
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801461:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801464:	50                   	push   %eax
  801465:	ff 75 08             	pushl  0x8(%ebp)
  801468:	e8 ac fe ff ff       	call   801319 <fd_lookup>
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	79 02                	jns    801476 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    
		return fd_close(fd, 1);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	6a 01                	push   $0x1
  80147b:	ff 75 f4             	pushl  -0xc(%ebp)
  80147e:	e8 49 ff ff ff       	call   8013cc <fd_close>
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	eb ec                	jmp    801474 <close+0x1d>

00801488 <close_all>:

void
close_all(void)
{
  801488:	f3 0f 1e fb          	endbr32 
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	53                   	push   %ebx
  801490:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801493:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	53                   	push   %ebx
  80149c:	e8 b6 ff ff ff       	call   801457 <close>
	for (i = 0; i < MAXFD; i++)
  8014a1:	83 c3 01             	add    $0x1,%ebx
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	83 fb 20             	cmp    $0x20,%ebx
  8014aa:	75 ec                	jne    801498 <close_all+0x10>
}
  8014ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014b1:	f3 0f 1e fb          	endbr32 
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	57                   	push   %edi
  8014b9:	56                   	push   %esi
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014c1:	50                   	push   %eax
  8014c2:	ff 75 08             	pushl  0x8(%ebp)
  8014c5:	e8 4f fe ff ff       	call   801319 <fd_lookup>
  8014ca:	89 c3                	mov    %eax,%ebx
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	0f 88 81 00 00 00    	js     801558 <dup+0xa7>
		return r;
	close(newfdnum);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	e8 75 ff ff ff       	call   801457 <close>

	newfd = INDEX2FD(newfdnum);
  8014e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014e5:	c1 e6 0c             	shl    $0xc,%esi
  8014e8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014ee:	83 c4 04             	add    $0x4,%esp
  8014f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014f4:	e8 af fd ff ff       	call   8012a8 <fd2data>
  8014f9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014fb:	89 34 24             	mov    %esi,(%esp)
  8014fe:	e8 a5 fd ff ff       	call   8012a8 <fd2data>
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801508:	89 d8                	mov    %ebx,%eax
  80150a:	c1 e8 16             	shr    $0x16,%eax
  80150d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801514:	a8 01                	test   $0x1,%al
  801516:	74 11                	je     801529 <dup+0x78>
  801518:	89 d8                	mov    %ebx,%eax
  80151a:	c1 e8 0c             	shr    $0xc,%eax
  80151d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801524:	f6 c2 01             	test   $0x1,%dl
  801527:	75 39                	jne    801562 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801529:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80152c:	89 d0                	mov    %edx,%eax
  80152e:	c1 e8 0c             	shr    $0xc,%eax
  801531:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	25 07 0e 00 00       	and    $0xe07,%eax
  801540:	50                   	push   %eax
  801541:	56                   	push   %esi
  801542:	6a 00                	push   $0x0
  801544:	52                   	push   %edx
  801545:	6a 00                	push   $0x0
  801547:	e8 70 f9 ff ff       	call   800ebc <sys_page_map>
  80154c:	89 c3                	mov    %eax,%ebx
  80154e:	83 c4 20             	add    $0x20,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 31                	js     801586 <dup+0xd5>
		goto err;

	return newfdnum;
  801555:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801558:	89 d8                	mov    %ebx,%eax
  80155a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155d:	5b                   	pop    %ebx
  80155e:	5e                   	pop    %esi
  80155f:	5f                   	pop    %edi
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801562:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801569:	83 ec 0c             	sub    $0xc,%esp
  80156c:	25 07 0e 00 00       	and    $0xe07,%eax
  801571:	50                   	push   %eax
  801572:	57                   	push   %edi
  801573:	6a 00                	push   $0x0
  801575:	53                   	push   %ebx
  801576:	6a 00                	push   $0x0
  801578:	e8 3f f9 ff ff       	call   800ebc <sys_page_map>
  80157d:	89 c3                	mov    %eax,%ebx
  80157f:	83 c4 20             	add    $0x20,%esp
  801582:	85 c0                	test   %eax,%eax
  801584:	79 a3                	jns    801529 <dup+0x78>
	sys_page_unmap(0, newfd);
  801586:	83 ec 08             	sub    $0x8,%esp
  801589:	56                   	push   %esi
  80158a:	6a 00                	push   $0x0
  80158c:	e8 71 f9 ff ff       	call   800f02 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801591:	83 c4 08             	add    $0x8,%esp
  801594:	57                   	push   %edi
  801595:	6a 00                	push   $0x0
  801597:	e8 66 f9 ff ff       	call   800f02 <sys_page_unmap>
	return r;
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	eb b7                	jmp    801558 <dup+0xa7>

008015a1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015a1:	f3 0f 1e fb          	endbr32 
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	53                   	push   %ebx
  8015a9:	83 ec 1c             	sub    $0x1c,%esp
  8015ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b2:	50                   	push   %eax
  8015b3:	53                   	push   %ebx
  8015b4:	e8 60 fd ff ff       	call   801319 <fd_lookup>
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 3f                	js     8015ff <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c0:	83 ec 08             	sub    $0x8,%esp
  8015c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c6:	50                   	push   %eax
  8015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ca:	ff 30                	pushl  (%eax)
  8015cc:	e8 9c fd ff ff       	call   80136d <dev_lookup>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	78 27                	js     8015ff <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015db:	8b 42 08             	mov    0x8(%edx),%eax
  8015de:	83 e0 03             	and    $0x3,%eax
  8015e1:	83 f8 01             	cmp    $0x1,%eax
  8015e4:	74 1e                	je     801604 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e9:	8b 40 08             	mov    0x8(%eax),%eax
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	74 35                	je     801625 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	ff 75 10             	pushl  0x10(%ebp)
  8015f6:	ff 75 0c             	pushl  0xc(%ebp)
  8015f9:	52                   	push   %edx
  8015fa:	ff d0                	call   *%eax
  8015fc:	83 c4 10             	add    $0x10,%esp
}
  8015ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801602:	c9                   	leave  
  801603:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801604:	a1 20 44 80 00       	mov    0x804420,%eax
  801609:	8b 40 48             	mov    0x48(%eax),%eax
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	53                   	push   %ebx
  801610:	50                   	push   %eax
  801611:	68 ad 2d 80 00       	push   $0x802dad
  801616:	e8 0e ee ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801623:	eb da                	jmp    8015ff <read+0x5e>
		return -E_NOT_SUPP;
  801625:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80162a:	eb d3                	jmp    8015ff <read+0x5e>

0080162c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80162c:	f3 0f 1e fb          	endbr32 
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	57                   	push   %edi
  801634:	56                   	push   %esi
  801635:	53                   	push   %ebx
  801636:	83 ec 0c             	sub    $0xc,%esp
  801639:	8b 7d 08             	mov    0x8(%ebp),%edi
  80163c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80163f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801644:	eb 02                	jmp    801648 <readn+0x1c>
  801646:	01 c3                	add    %eax,%ebx
  801648:	39 f3                	cmp    %esi,%ebx
  80164a:	73 21                	jae    80166d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	89 f0                	mov    %esi,%eax
  801651:	29 d8                	sub    %ebx,%eax
  801653:	50                   	push   %eax
  801654:	89 d8                	mov    %ebx,%eax
  801656:	03 45 0c             	add    0xc(%ebp),%eax
  801659:	50                   	push   %eax
  80165a:	57                   	push   %edi
  80165b:	e8 41 ff ff ff       	call   8015a1 <read>
		if (m < 0)
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	85 c0                	test   %eax,%eax
  801665:	78 04                	js     80166b <readn+0x3f>
			return m;
		if (m == 0)
  801667:	75 dd                	jne    801646 <readn+0x1a>
  801669:	eb 02                	jmp    80166d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80166b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80166d:	89 d8                	mov    %ebx,%eax
  80166f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801672:	5b                   	pop    %ebx
  801673:	5e                   	pop    %esi
  801674:	5f                   	pop    %edi
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801677:	f3 0f 1e fb          	endbr32 
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	53                   	push   %ebx
  80167f:	83 ec 1c             	sub    $0x1c,%esp
  801682:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801685:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801688:	50                   	push   %eax
  801689:	53                   	push   %ebx
  80168a:	e8 8a fc ff ff       	call   801319 <fd_lookup>
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	85 c0                	test   %eax,%eax
  801694:	78 3a                	js     8016d0 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801696:	83 ec 08             	sub    $0x8,%esp
  801699:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169c:	50                   	push   %eax
  80169d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a0:	ff 30                	pushl  (%eax)
  8016a2:	e8 c6 fc ff ff       	call   80136d <dev_lookup>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 22                	js     8016d0 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b5:	74 1e                	je     8016d5 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ba:	8b 52 0c             	mov    0xc(%edx),%edx
  8016bd:	85 d2                	test   %edx,%edx
  8016bf:	74 35                	je     8016f6 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016c1:	83 ec 04             	sub    $0x4,%esp
  8016c4:	ff 75 10             	pushl  0x10(%ebp)
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	50                   	push   %eax
  8016cb:	ff d2                	call   *%edx
  8016cd:	83 c4 10             	add    $0x10,%esp
}
  8016d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016d5:	a1 20 44 80 00       	mov    0x804420,%eax
  8016da:	8b 40 48             	mov    0x48(%eax),%eax
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	53                   	push   %ebx
  8016e1:	50                   	push   %eax
  8016e2:	68 c9 2d 80 00       	push   $0x802dc9
  8016e7:	e8 3d ed ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f4:	eb da                	jmp    8016d0 <write+0x59>
		return -E_NOT_SUPP;
  8016f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fb:	eb d3                	jmp    8016d0 <write+0x59>

008016fd <seek>:

int
seek(int fdnum, off_t offset)
{
  8016fd:	f3 0f 1e fb          	endbr32 
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801707:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	e8 06 fc ff ff       	call   801319 <fd_lookup>
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	85 c0                	test   %eax,%eax
  801718:	78 0e                	js     801728 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80172a:	f3 0f 1e fb          	endbr32 
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	53                   	push   %ebx
  801732:	83 ec 1c             	sub    $0x1c,%esp
  801735:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801738:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173b:	50                   	push   %eax
  80173c:	53                   	push   %ebx
  80173d:	e8 d7 fb ff ff       	call   801319 <fd_lookup>
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	85 c0                	test   %eax,%eax
  801747:	78 37                	js     801780 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174f:	50                   	push   %eax
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801753:	ff 30                	pushl  (%eax)
  801755:	e8 13 fc ff ff       	call   80136d <dev_lookup>
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 1f                	js     801780 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801764:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801768:	74 1b                	je     801785 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80176a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176d:	8b 52 18             	mov    0x18(%edx),%edx
  801770:	85 d2                	test   %edx,%edx
  801772:	74 32                	je     8017a6 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	ff 75 0c             	pushl  0xc(%ebp)
  80177a:	50                   	push   %eax
  80177b:	ff d2                	call   *%edx
  80177d:	83 c4 10             	add    $0x10,%esp
}
  801780:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801783:	c9                   	leave  
  801784:	c3                   	ret    
			thisenv->env_id, fdnum);
  801785:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80178a:	8b 40 48             	mov    0x48(%eax),%eax
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	53                   	push   %ebx
  801791:	50                   	push   %eax
  801792:	68 8c 2d 80 00       	push   $0x802d8c
  801797:	e8 8d ec ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a4:	eb da                	jmp    801780 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ab:	eb d3                	jmp    801780 <ftruncate+0x56>

008017ad <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017ad:	f3 0f 1e fb          	endbr32 
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	53                   	push   %ebx
  8017b5:	83 ec 1c             	sub    $0x1c,%esp
  8017b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017be:	50                   	push   %eax
  8017bf:	ff 75 08             	pushl  0x8(%ebp)
  8017c2:	e8 52 fb ff ff       	call   801319 <fd_lookup>
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	78 4b                	js     801819 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d4:	50                   	push   %eax
  8017d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d8:	ff 30                	pushl  (%eax)
  8017da:	e8 8e fb ff ff       	call   80136d <dev_lookup>
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	78 33                	js     801819 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017ed:	74 2f                	je     80181e <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017ef:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017f2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017f9:	00 00 00 
	stat->st_isdir = 0;
  8017fc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801803:	00 00 00 
	stat->st_dev = dev;
  801806:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80180c:	83 ec 08             	sub    $0x8,%esp
  80180f:	53                   	push   %ebx
  801810:	ff 75 f0             	pushl  -0x10(%ebp)
  801813:	ff 50 14             	call   *0x14(%eax)
  801816:	83 c4 10             	add    $0x10,%esp
}
  801819:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    
		return -E_NOT_SUPP;
  80181e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801823:	eb f4                	jmp    801819 <fstat+0x6c>

00801825 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801825:	f3 0f 1e fb          	endbr32 
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	56                   	push   %esi
  80182d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80182e:	83 ec 08             	sub    $0x8,%esp
  801831:	6a 00                	push   $0x0
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	e8 fb 01 00 00       	call   801a36 <open>
  80183b:	89 c3                	mov    %eax,%ebx
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	85 c0                	test   %eax,%eax
  801842:	78 1b                	js     80185f <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	50                   	push   %eax
  80184b:	e8 5d ff ff ff       	call   8017ad <fstat>
  801850:	89 c6                	mov    %eax,%esi
	close(fd);
  801852:	89 1c 24             	mov    %ebx,(%esp)
  801855:	e8 fd fb ff ff       	call   801457 <close>
	return r;
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	89 f3                	mov    %esi,%ebx
}
  80185f:	89 d8                	mov    %ebx,%eax
  801861:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801864:	5b                   	pop    %ebx
  801865:	5e                   	pop    %esi
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    

00801868 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	56                   	push   %esi
  80186c:	53                   	push   %ebx
  80186d:	89 c6                	mov    %eax,%esi
  80186f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801871:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801878:	74 27                	je     8018a1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80187a:	6a 07                	push   $0x7
  80187c:	68 00 50 80 00       	push   $0x805000
  801881:	56                   	push   %esi
  801882:	ff 35 00 40 80 00    	pushl  0x804000
  801888:	e8 b2 0d 00 00       	call   80263f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80188d:	83 c4 0c             	add    $0xc,%esp
  801890:	6a 00                	push   $0x0
  801892:	53                   	push   %ebx
  801893:	6a 00                	push   $0x0
  801895:	e8 20 0d 00 00       	call   8025ba <ipc_recv>
}
  80189a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5e                   	pop    %esi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018a1:	83 ec 0c             	sub    $0xc,%esp
  8018a4:	6a 01                	push   $0x1
  8018a6:	e8 ec 0d 00 00       	call   802697 <ipc_find_env>
  8018ab:	a3 00 40 80 00       	mov    %eax,0x804000
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	eb c5                	jmp    80187a <fsipc+0x12>

008018b5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018b5:	f3 0f 1e fb          	endbr32 
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8018dc:	e8 87 ff ff ff       	call   801868 <fsipc>
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <devfile_flush>:
{
  8018e3:	f3 0f 1e fb          	endbr32 
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fd:	b8 06 00 00 00       	mov    $0x6,%eax
  801902:	e8 61 ff ff ff       	call   801868 <fsipc>
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <devfile_stat>:
{
  801909:	f3 0f 1e fb          	endbr32 
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	53                   	push   %ebx
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	8b 40 0c             	mov    0xc(%eax),%eax
  80191d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801922:	ba 00 00 00 00       	mov    $0x0,%edx
  801927:	b8 05 00 00 00       	mov    $0x5,%eax
  80192c:	e8 37 ff ff ff       	call   801868 <fsipc>
  801931:	85 c0                	test   %eax,%eax
  801933:	78 2c                	js     801961 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	68 00 50 80 00       	push   $0x805000
  80193d:	53                   	push   %ebx
  80193e:	e8 f0 f0 ff ff       	call   800a33 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801943:	a1 80 50 80 00       	mov    0x805080,%eax
  801948:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80194e:	a1 84 50 80 00       	mov    0x805084,%eax
  801953:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801961:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <devfile_write>:
{
  801966:	f3 0f 1e fb          	endbr32 
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 0c             	sub    $0xc,%esp
  801970:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801973:	8b 55 08             	mov    0x8(%ebp),%edx
  801976:	8b 52 0c             	mov    0xc(%edx),%edx
  801979:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80197f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801984:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801989:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80198c:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801991:	50                   	push   %eax
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	68 08 50 80 00       	push   $0x805008
  80199a:	e8 4a f2 ff ff       	call   800be9 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80199f:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a4:	b8 04 00 00 00       	mov    $0x4,%eax
  8019a9:	e8 ba fe ff ff       	call   801868 <fsipc>
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <devfile_read>:
{
  8019b0:	f3 0f 1e fb          	endbr32 
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	56                   	push   %esi
  8019b8:	53                   	push   %ebx
  8019b9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019c7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d2:	b8 03 00 00 00       	mov    $0x3,%eax
  8019d7:	e8 8c fe ff ff       	call   801868 <fsipc>
  8019dc:	89 c3                	mov    %eax,%ebx
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 1f                	js     801a01 <devfile_read+0x51>
	assert(r <= n);
  8019e2:	39 f0                	cmp    %esi,%eax
  8019e4:	77 24                	ja     801a0a <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019e6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019eb:	7f 33                	jg     801a20 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	50                   	push   %eax
  8019f1:	68 00 50 80 00       	push   $0x805000
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	e8 eb f1 ff ff       	call   800be9 <memmove>
	return r;
  8019fe:	83 c4 10             	add    $0x10,%esp
}
  801a01:	89 d8                	mov    %ebx,%eax
  801a03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a06:	5b                   	pop    %ebx
  801a07:	5e                   	pop    %esi
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    
	assert(r <= n);
  801a0a:	68 fc 2d 80 00       	push   $0x802dfc
  801a0f:	68 03 2e 80 00       	push   $0x802e03
  801a14:	6a 7c                	push   $0x7c
  801a16:	68 18 2e 80 00       	push   $0x802e18
  801a1b:	e8 22 e9 ff ff       	call   800342 <_panic>
	assert(r <= PGSIZE);
  801a20:	68 23 2e 80 00       	push   $0x802e23
  801a25:	68 03 2e 80 00       	push   $0x802e03
  801a2a:	6a 7d                	push   $0x7d
  801a2c:	68 18 2e 80 00       	push   $0x802e18
  801a31:	e8 0c e9 ff ff       	call   800342 <_panic>

00801a36 <open>:
{
  801a36:	f3 0f 1e fb          	endbr32 
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	56                   	push   %esi
  801a3e:	53                   	push   %ebx
  801a3f:	83 ec 1c             	sub    $0x1c,%esp
  801a42:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a45:	56                   	push   %esi
  801a46:	e8 a5 ef ff ff       	call   8009f0 <strlen>
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a53:	7f 6c                	jg     801ac1 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a55:	83 ec 0c             	sub    $0xc,%esp
  801a58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5b:	50                   	push   %eax
  801a5c:	e8 62 f8 ff ff       	call   8012c3 <fd_alloc>
  801a61:	89 c3                	mov    %eax,%ebx
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	85 c0                	test   %eax,%eax
  801a68:	78 3c                	js     801aa6 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a6a:	83 ec 08             	sub    $0x8,%esp
  801a6d:	56                   	push   %esi
  801a6e:	68 00 50 80 00       	push   $0x805000
  801a73:	e8 bb ef ff ff       	call   800a33 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a83:	b8 01 00 00 00       	mov    $0x1,%eax
  801a88:	e8 db fd ff ff       	call   801868 <fsipc>
  801a8d:	89 c3                	mov    %eax,%ebx
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	85 c0                	test   %eax,%eax
  801a94:	78 19                	js     801aaf <open+0x79>
	return fd2num(fd);
  801a96:	83 ec 0c             	sub    $0xc,%esp
  801a99:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9c:	e8 f3 f7 ff ff       	call   801294 <fd2num>
  801aa1:	89 c3                	mov    %eax,%ebx
  801aa3:	83 c4 10             	add    $0x10,%esp
}
  801aa6:	89 d8                	mov    %ebx,%eax
  801aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
		fd_close(fd, 0);
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	6a 00                	push   $0x0
  801ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab7:	e8 10 f9 ff ff       	call   8013cc <fd_close>
		return r;
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	eb e5                	jmp    801aa6 <open+0x70>
		return -E_BAD_PATH;
  801ac1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ac6:	eb de                	jmp    801aa6 <open+0x70>

00801ac8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ac8:	f3 0f 1e fb          	endbr32 
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ad2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad7:	b8 08 00 00 00       	mov    $0x8,%eax
  801adc:	e8 87 fd ff ff       	call   801868 <fsipc>
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801ae3:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801ae7:	7f 01                	jg     801aea <writebuf+0x7>
  801ae9:	c3                   	ret    
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	53                   	push   %ebx
  801aee:	83 ec 08             	sub    $0x8,%esp
  801af1:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801af3:	ff 70 04             	pushl  0x4(%eax)
  801af6:	8d 40 10             	lea    0x10(%eax),%eax
  801af9:	50                   	push   %eax
  801afa:	ff 33                	pushl  (%ebx)
  801afc:	e8 76 fb ff ff       	call   801677 <write>
		if (result > 0)
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	85 c0                	test   %eax,%eax
  801b06:	7e 03                	jle    801b0b <writebuf+0x28>
			b->result += result;
  801b08:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b0b:	39 43 04             	cmp    %eax,0x4(%ebx)
  801b0e:	74 0d                	je     801b1d <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801b10:	85 c0                	test   %eax,%eax
  801b12:	ba 00 00 00 00       	mov    $0x0,%edx
  801b17:	0f 4f c2             	cmovg  %edx,%eax
  801b1a:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <putch>:

static void
putch(int ch, void *thunk)
{
  801b22:	f3 0f 1e fb          	endbr32 
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	53                   	push   %ebx
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801b30:	8b 53 04             	mov    0x4(%ebx),%edx
  801b33:	8d 42 01             	lea    0x1(%edx),%eax
  801b36:	89 43 04             	mov    %eax,0x4(%ebx)
  801b39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b3c:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801b40:	3d 00 01 00 00       	cmp    $0x100,%eax
  801b45:	74 06                	je     801b4d <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  801b47:	83 c4 04             	add    $0x4,%esp
  801b4a:	5b                   	pop    %ebx
  801b4b:	5d                   	pop    %ebp
  801b4c:	c3                   	ret    
		writebuf(b);
  801b4d:	89 d8                	mov    %ebx,%eax
  801b4f:	e8 8f ff ff ff       	call   801ae3 <writebuf>
		b->idx = 0;
  801b54:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801b5b:	eb ea                	jmp    801b47 <putch+0x25>

00801b5d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b5d:	f3 0f 1e fb          	endbr32 
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b73:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b7a:	00 00 00 
	b.result = 0;
  801b7d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b84:	00 00 00 
	b.error = 1;
  801b87:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b8e:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b91:	ff 75 10             	pushl  0x10(%ebp)
  801b94:	ff 75 0c             	pushl  0xc(%ebp)
  801b97:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b9d:	50                   	push   %eax
  801b9e:	68 22 1b 80 00       	push   $0x801b22
  801ba3:	e8 84 e9 ff ff       	call   80052c <vprintfmt>
	if (b.idx > 0)
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801bb2:	7f 11                	jg     801bc5 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801bb4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    
		writebuf(&b);
  801bc5:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bcb:	e8 13 ff ff ff       	call   801ae3 <writebuf>
  801bd0:	eb e2                	jmp    801bb4 <vfprintf+0x57>

00801bd2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801bd2:	f3 0f 1e fb          	endbr32 
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bdc:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801bdf:	50                   	push   %eax
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	ff 75 08             	pushl  0x8(%ebp)
  801be6:	e8 72 ff ff ff       	call   801b5d <vfprintf>
	va_end(ap);

	return cnt;
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <printf>:

int
printf(const char *fmt, ...)
{
  801bed:	f3 0f 1e fb          	endbr32 
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bf7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801bfa:	50                   	push   %eax
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	6a 01                	push   $0x1
  801c00:	e8 58 ff ff ff       	call   801b5d <vfprintf>
	va_end(ap);

	return cnt;
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c07:	f3 0f 1e fb          	endbr32 
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c11:	68 2f 2e 80 00       	push   $0x802e2f
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	e8 15 ee ff ff       	call   800a33 <strcpy>
	return 0;
}
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <devsock_close>:
{
  801c25:	f3 0f 1e fb          	endbr32 
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	53                   	push   %ebx
  801c2d:	83 ec 10             	sub    $0x10,%esp
  801c30:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c33:	53                   	push   %ebx
  801c34:	e8 9b 0a 00 00       	call   8026d4 <pageref>
  801c39:	89 c2                	mov    %eax,%edx
  801c3b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c3e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801c43:	83 fa 01             	cmp    $0x1,%edx
  801c46:	74 05                	je     801c4d <devsock_close+0x28>
}
  801c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c4d:	83 ec 0c             	sub    $0xc,%esp
  801c50:	ff 73 0c             	pushl  0xc(%ebx)
  801c53:	e8 e3 02 00 00       	call   801f3b <nsipc_close>
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	eb eb                	jmp    801c48 <devsock_close+0x23>

00801c5d <devsock_write>:
{
  801c5d:	f3 0f 1e fb          	endbr32 
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	ff 75 10             	pushl  0x10(%ebp)
  801c6c:	ff 75 0c             	pushl  0xc(%ebp)
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	ff 70 0c             	pushl  0xc(%eax)
  801c75:	e8 b5 03 00 00       	call   80202f <nsipc_send>
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <devsock_read>:
{
  801c7c:	f3 0f 1e fb          	endbr32 
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	ff 75 10             	pushl  0x10(%ebp)
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	ff 70 0c             	pushl  0xc(%eax)
  801c94:	e8 1f 03 00 00       	call   801fb8 <nsipc_recv>
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <fd2sockid>:
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ca1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ca4:	52                   	push   %edx
  801ca5:	50                   	push   %eax
  801ca6:	e8 6e f6 ff ff       	call   801319 <fd_lookup>
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	78 10                	js     801cc2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801cbb:	39 08                	cmp    %ecx,(%eax)
  801cbd:	75 05                	jne    801cc4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801cbf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    
		return -E_NOT_SUPP;
  801cc4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cc9:	eb f7                	jmp    801cc2 <fd2sockid+0x27>

00801ccb <alloc_sockfd>:
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	83 ec 1c             	sub    $0x1c,%esp
  801cd3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801cd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd8:	50                   	push   %eax
  801cd9:	e8 e5 f5 ff ff       	call   8012c3 <fd_alloc>
  801cde:	89 c3                	mov    %eax,%ebx
  801ce0:	83 c4 10             	add    $0x10,%esp
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	78 43                	js     801d2a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ce7:	83 ec 04             	sub    $0x4,%esp
  801cea:	68 07 04 00 00       	push   $0x407
  801cef:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf2:	6a 00                	push   $0x0
  801cf4:	e8 7c f1 ff ff       	call   800e75 <sys_page_alloc>
  801cf9:	89 c3                	mov    %eax,%ebx
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	78 28                	js     801d2a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d0b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d10:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d17:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d1a:	83 ec 0c             	sub    $0xc,%esp
  801d1d:	50                   	push   %eax
  801d1e:	e8 71 f5 ff ff       	call   801294 <fd2num>
  801d23:	89 c3                	mov    %eax,%ebx
  801d25:	83 c4 10             	add    $0x10,%esp
  801d28:	eb 0c                	jmp    801d36 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d2a:	83 ec 0c             	sub    $0xc,%esp
  801d2d:	56                   	push   %esi
  801d2e:	e8 08 02 00 00       	call   801f3b <nsipc_close>
		return r;
  801d33:	83 c4 10             	add    $0x10,%esp
}
  801d36:	89 d8                	mov    %ebx,%eax
  801d38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    

00801d3f <accept>:
{
  801d3f:	f3 0f 1e fb          	endbr32 
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	e8 4a ff ff ff       	call   801c9b <fd2sockid>
  801d51:	85 c0                	test   %eax,%eax
  801d53:	78 1b                	js     801d70 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d55:	83 ec 04             	sub    $0x4,%esp
  801d58:	ff 75 10             	pushl  0x10(%ebp)
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	50                   	push   %eax
  801d5f:	e8 22 01 00 00       	call   801e86 <nsipc_accept>
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	85 c0                	test   %eax,%eax
  801d69:	78 05                	js     801d70 <accept+0x31>
	return alloc_sockfd(r);
  801d6b:	e8 5b ff ff ff       	call   801ccb <alloc_sockfd>
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <bind>:
{
  801d72:	f3 0f 1e fb          	endbr32 
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	e8 17 ff ff ff       	call   801c9b <fd2sockid>
  801d84:	85 c0                	test   %eax,%eax
  801d86:	78 12                	js     801d9a <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	ff 75 10             	pushl  0x10(%ebp)
  801d8e:	ff 75 0c             	pushl  0xc(%ebp)
  801d91:	50                   	push   %eax
  801d92:	e8 45 01 00 00       	call   801edc <nsipc_bind>
  801d97:	83 c4 10             	add    $0x10,%esp
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <shutdown>:
{
  801d9c:	f3 0f 1e fb          	endbr32 
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	e8 ed fe ff ff       	call   801c9b <fd2sockid>
  801dae:	85 c0                	test   %eax,%eax
  801db0:	78 0f                	js     801dc1 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801db2:	83 ec 08             	sub    $0x8,%esp
  801db5:	ff 75 0c             	pushl  0xc(%ebp)
  801db8:	50                   	push   %eax
  801db9:	e8 57 01 00 00       	call   801f15 <nsipc_shutdown>
  801dbe:	83 c4 10             	add    $0x10,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <connect>:
{
  801dc3:	f3 0f 1e fb          	endbr32 
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	e8 c6 fe ff ff       	call   801c9b <fd2sockid>
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	78 12                	js     801deb <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801dd9:	83 ec 04             	sub    $0x4,%esp
  801ddc:	ff 75 10             	pushl  0x10(%ebp)
  801ddf:	ff 75 0c             	pushl  0xc(%ebp)
  801de2:	50                   	push   %eax
  801de3:	e8 71 01 00 00       	call   801f59 <nsipc_connect>
  801de8:	83 c4 10             	add    $0x10,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <listen>:
{
  801ded:	f3 0f 1e fb          	endbr32 
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	e8 9c fe ff ff       	call   801c9b <fd2sockid>
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 0f                	js     801e12 <listen+0x25>
	return nsipc_listen(r, backlog);
  801e03:	83 ec 08             	sub    $0x8,%esp
  801e06:	ff 75 0c             	pushl  0xc(%ebp)
  801e09:	50                   	push   %eax
  801e0a:	e8 83 01 00 00       	call   801f92 <nsipc_listen>
  801e0f:	83 c4 10             	add    $0x10,%esp
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <socket>:

int
socket(int domain, int type, int protocol)
{
  801e14:	f3 0f 1e fb          	endbr32 
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e1e:	ff 75 10             	pushl  0x10(%ebp)
  801e21:	ff 75 0c             	pushl  0xc(%ebp)
  801e24:	ff 75 08             	pushl  0x8(%ebp)
  801e27:	e8 65 02 00 00       	call   802091 <nsipc_socket>
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 05                	js     801e38 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801e33:	e8 93 fe ff ff       	call   801ccb <alloc_sockfd>
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	53                   	push   %ebx
  801e3e:	83 ec 04             	sub    $0x4,%esp
  801e41:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e43:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801e4a:	74 26                	je     801e72 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e4c:	6a 07                	push   $0x7
  801e4e:	68 00 60 80 00       	push   $0x806000
  801e53:	53                   	push   %ebx
  801e54:	ff 35 04 40 80 00    	pushl  0x804004
  801e5a:	e8 e0 07 00 00       	call   80263f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e5f:	83 c4 0c             	add    $0xc,%esp
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	e8 4d 07 00 00       	call   8025ba <ipc_recv>
}
  801e6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	6a 02                	push   $0x2
  801e77:	e8 1b 08 00 00       	call   802697 <ipc_find_env>
  801e7c:	a3 04 40 80 00       	mov    %eax,0x804004
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	eb c6                	jmp    801e4c <nsipc+0x12>

00801e86 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e86:	f3 0f 1e fb          	endbr32 
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	56                   	push   %esi
  801e8e:	53                   	push   %ebx
  801e8f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e9a:	8b 06                	mov    (%esi),%eax
  801e9c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ea1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea6:	e8 8f ff ff ff       	call   801e3a <nsipc>
  801eab:	89 c3                	mov    %eax,%ebx
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	79 09                	jns    801eba <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801eb1:	89 d8                	mov    %ebx,%eax
  801eb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb6:	5b                   	pop    %ebx
  801eb7:	5e                   	pop    %esi
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	ff 35 10 60 80 00    	pushl  0x806010
  801ec3:	68 00 60 80 00       	push   $0x806000
  801ec8:	ff 75 0c             	pushl  0xc(%ebp)
  801ecb:	e8 19 ed ff ff       	call   800be9 <memmove>
		*addrlen = ret->ret_addrlen;
  801ed0:	a1 10 60 80 00       	mov    0x806010,%eax
  801ed5:	89 06                	mov    %eax,(%esi)
  801ed7:	83 c4 10             	add    $0x10,%esp
	return r;
  801eda:	eb d5                	jmp    801eb1 <nsipc_accept+0x2b>

00801edc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801edc:	f3 0f 1e fb          	endbr32 
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 08             	sub    $0x8,%esp
  801ee7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ef2:	53                   	push   %ebx
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	68 04 60 80 00       	push   $0x806004
  801efb:	e8 e9 ec ff ff       	call   800be9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f00:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f06:	b8 02 00 00 00       	mov    $0x2,%eax
  801f0b:	e8 2a ff ff ff       	call   801e3a <nsipc>
}
  801f10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f15:	f3 0f 1e fb          	endbr32 
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f2f:	b8 03 00 00 00       	mov    $0x3,%eax
  801f34:	e8 01 ff ff ff       	call   801e3a <nsipc>
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <nsipc_close>:

int
nsipc_close(int s)
{
  801f3b:	f3 0f 1e fb          	endbr32 
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f4d:	b8 04 00 00 00       	mov    $0x4,%eax
  801f52:	e8 e3 fe ff ff       	call   801e3a <nsipc>
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f59:	f3 0f 1e fb          	endbr32 
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	53                   	push   %ebx
  801f61:	83 ec 08             	sub    $0x8,%esp
  801f64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f6f:	53                   	push   %ebx
  801f70:	ff 75 0c             	pushl  0xc(%ebp)
  801f73:	68 04 60 80 00       	push   $0x806004
  801f78:	e8 6c ec ff ff       	call   800be9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f7d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f83:	b8 05 00 00 00       	mov    $0x5,%eax
  801f88:	e8 ad fe ff ff       	call   801e3a <nsipc>
}
  801f8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f92:	f3 0f 1e fb          	endbr32 
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801fac:	b8 06 00 00 00       	mov    $0x6,%eax
  801fb1:	e8 84 fe ff ff       	call   801e3a <nsipc>
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fb8:	f3 0f 1e fb          	endbr32 
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	56                   	push   %esi
  801fc0:	53                   	push   %ebx
  801fc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801fcc:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801fd2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd5:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801fda:	b8 07 00 00 00       	mov    $0x7,%eax
  801fdf:	e8 56 fe ff ff       	call   801e3a <nsipc>
  801fe4:	89 c3                	mov    %eax,%ebx
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 26                	js     802010 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801fea:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801ff0:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801ff5:	0f 4e c6             	cmovle %esi,%eax
  801ff8:	39 c3                	cmp    %eax,%ebx
  801ffa:	7f 1d                	jg     802019 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ffc:	83 ec 04             	sub    $0x4,%esp
  801fff:	53                   	push   %ebx
  802000:	68 00 60 80 00       	push   $0x806000
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	e8 dc eb ff ff       	call   800be9 <memmove>
  80200d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802010:	89 d8                	mov    %ebx,%eax
  802012:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802015:	5b                   	pop    %ebx
  802016:	5e                   	pop    %esi
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802019:	68 3b 2e 80 00       	push   $0x802e3b
  80201e:	68 03 2e 80 00       	push   $0x802e03
  802023:	6a 62                	push   $0x62
  802025:	68 50 2e 80 00       	push   $0x802e50
  80202a:	e8 13 e3 ff ff       	call   800342 <_panic>

0080202f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80202f:	f3 0f 1e fb          	endbr32 
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	53                   	push   %ebx
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802045:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80204b:	7f 2e                	jg     80207b <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	53                   	push   %ebx
  802051:	ff 75 0c             	pushl  0xc(%ebp)
  802054:	68 0c 60 80 00       	push   $0x80600c
  802059:	e8 8b eb ff ff       	call   800be9 <memmove>
	nsipcbuf.send.req_size = size;
  80205e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802064:	8b 45 14             	mov    0x14(%ebp),%eax
  802067:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80206c:	b8 08 00 00 00       	mov    $0x8,%eax
  802071:	e8 c4 fd ff ff       	call   801e3a <nsipc>
}
  802076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802079:	c9                   	leave  
  80207a:	c3                   	ret    
	assert(size < 1600);
  80207b:	68 5c 2e 80 00       	push   $0x802e5c
  802080:	68 03 2e 80 00       	push   $0x802e03
  802085:	6a 6d                	push   $0x6d
  802087:	68 50 2e 80 00       	push   $0x802e50
  80208c:	e8 b1 e2 ff ff       	call   800342 <_panic>

00802091 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802091:	f3 0f 1e fb          	endbr32 
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a6:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8020ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ae:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8020b3:	b8 09 00 00 00       	mov    $0x9,%eax
  8020b8:	e8 7d fd ff ff       	call   801e3a <nsipc>
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020bf:	f3 0f 1e fb          	endbr32 
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	56                   	push   %esi
  8020c7:	53                   	push   %ebx
  8020c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020cb:	83 ec 0c             	sub    $0xc,%esp
  8020ce:	ff 75 08             	pushl  0x8(%ebp)
  8020d1:	e8 d2 f1 ff ff       	call   8012a8 <fd2data>
  8020d6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020d8:	83 c4 08             	add    $0x8,%esp
  8020db:	68 68 2e 80 00       	push   $0x802e68
  8020e0:	53                   	push   %ebx
  8020e1:	e8 4d e9 ff ff       	call   800a33 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020e6:	8b 46 04             	mov    0x4(%esi),%eax
  8020e9:	2b 06                	sub    (%esi),%eax
  8020eb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020f1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020f8:	00 00 00 
	stat->st_dev = &devpipe;
  8020fb:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  802102:	30 80 00 
	return 0;
}
  802105:	b8 00 00 00 00       	mov    $0x0,%eax
  80210a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    

00802111 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802111:	f3 0f 1e fb          	endbr32 
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	53                   	push   %ebx
  802119:	83 ec 0c             	sub    $0xc,%esp
  80211c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80211f:	53                   	push   %ebx
  802120:	6a 00                	push   $0x0
  802122:	e8 db ed ff ff       	call   800f02 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802127:	89 1c 24             	mov    %ebx,(%esp)
  80212a:	e8 79 f1 ff ff       	call   8012a8 <fd2data>
  80212f:	83 c4 08             	add    $0x8,%esp
  802132:	50                   	push   %eax
  802133:	6a 00                	push   $0x0
  802135:	e8 c8 ed ff ff       	call   800f02 <sys_page_unmap>
}
  80213a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <_pipeisclosed>:
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	57                   	push   %edi
  802143:	56                   	push   %esi
  802144:	53                   	push   %ebx
  802145:	83 ec 1c             	sub    $0x1c,%esp
  802148:	89 c7                	mov    %eax,%edi
  80214a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80214c:	a1 20 44 80 00       	mov    0x804420,%eax
  802151:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802154:	83 ec 0c             	sub    $0xc,%esp
  802157:	57                   	push   %edi
  802158:	e8 77 05 00 00       	call   8026d4 <pageref>
  80215d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802160:	89 34 24             	mov    %esi,(%esp)
  802163:	e8 6c 05 00 00       	call   8026d4 <pageref>
		nn = thisenv->env_runs;
  802168:	8b 15 20 44 80 00    	mov    0x804420,%edx
  80216e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	39 cb                	cmp    %ecx,%ebx
  802176:	74 1b                	je     802193 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802178:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80217b:	75 cf                	jne    80214c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80217d:	8b 42 58             	mov    0x58(%edx),%eax
  802180:	6a 01                	push   $0x1
  802182:	50                   	push   %eax
  802183:	53                   	push   %ebx
  802184:	68 6f 2e 80 00       	push   $0x802e6f
  802189:	e8 9b e2 ff ff       	call   800429 <cprintf>
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	eb b9                	jmp    80214c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802193:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802196:	0f 94 c0             	sete   %al
  802199:	0f b6 c0             	movzbl %al,%eax
}
  80219c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5f                   	pop    %edi
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    

008021a4 <devpipe_write>:
{
  8021a4:	f3 0f 1e fb          	endbr32 
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	57                   	push   %edi
  8021ac:	56                   	push   %esi
  8021ad:	53                   	push   %ebx
  8021ae:	83 ec 28             	sub    $0x28,%esp
  8021b1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021b4:	56                   	push   %esi
  8021b5:	e8 ee f0 ff ff       	call   8012a8 <fd2data>
  8021ba:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021bc:	83 c4 10             	add    $0x10,%esp
  8021bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021c7:	74 4f                	je     802218 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021c9:	8b 43 04             	mov    0x4(%ebx),%eax
  8021cc:	8b 0b                	mov    (%ebx),%ecx
  8021ce:	8d 51 20             	lea    0x20(%ecx),%edx
  8021d1:	39 d0                	cmp    %edx,%eax
  8021d3:	72 14                	jb     8021e9 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8021d5:	89 da                	mov    %ebx,%edx
  8021d7:	89 f0                	mov    %esi,%eax
  8021d9:	e8 61 ff ff ff       	call   80213f <_pipeisclosed>
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	75 3b                	jne    80221d <devpipe_write+0x79>
			sys_yield();
  8021e2:	e8 6b ec ff ff       	call   800e52 <sys_yield>
  8021e7:	eb e0                	jmp    8021c9 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021ec:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021f0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021f3:	89 c2                	mov    %eax,%edx
  8021f5:	c1 fa 1f             	sar    $0x1f,%edx
  8021f8:	89 d1                	mov    %edx,%ecx
  8021fa:	c1 e9 1b             	shr    $0x1b,%ecx
  8021fd:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802200:	83 e2 1f             	and    $0x1f,%edx
  802203:	29 ca                	sub    %ecx,%edx
  802205:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802209:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80220d:	83 c0 01             	add    $0x1,%eax
  802210:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802213:	83 c7 01             	add    $0x1,%edi
  802216:	eb ac                	jmp    8021c4 <devpipe_write+0x20>
	return i;
  802218:	8b 45 10             	mov    0x10(%ebp),%eax
  80221b:	eb 05                	jmp    802222 <devpipe_write+0x7e>
				return 0;
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802225:	5b                   	pop    %ebx
  802226:	5e                   	pop    %esi
  802227:	5f                   	pop    %edi
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    

0080222a <devpipe_read>:
{
  80222a:	f3 0f 1e fb          	endbr32 
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	57                   	push   %edi
  802232:	56                   	push   %esi
  802233:	53                   	push   %ebx
  802234:	83 ec 18             	sub    $0x18,%esp
  802237:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80223a:	57                   	push   %edi
  80223b:	e8 68 f0 ff ff       	call   8012a8 <fd2data>
  802240:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	be 00 00 00 00       	mov    $0x0,%esi
  80224a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80224d:	75 14                	jne    802263 <devpipe_read+0x39>
	return i;
  80224f:	8b 45 10             	mov    0x10(%ebp),%eax
  802252:	eb 02                	jmp    802256 <devpipe_read+0x2c>
				return i;
  802254:	89 f0                	mov    %esi,%eax
}
  802256:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802259:	5b                   	pop    %ebx
  80225a:	5e                   	pop    %esi
  80225b:	5f                   	pop    %edi
  80225c:	5d                   	pop    %ebp
  80225d:	c3                   	ret    
			sys_yield();
  80225e:	e8 ef eb ff ff       	call   800e52 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802263:	8b 03                	mov    (%ebx),%eax
  802265:	3b 43 04             	cmp    0x4(%ebx),%eax
  802268:	75 18                	jne    802282 <devpipe_read+0x58>
			if (i > 0)
  80226a:	85 f6                	test   %esi,%esi
  80226c:	75 e6                	jne    802254 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80226e:	89 da                	mov    %ebx,%edx
  802270:	89 f8                	mov    %edi,%eax
  802272:	e8 c8 fe ff ff       	call   80213f <_pipeisclosed>
  802277:	85 c0                	test   %eax,%eax
  802279:	74 e3                	je     80225e <devpipe_read+0x34>
				return 0;
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
  802280:	eb d4                	jmp    802256 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802282:	99                   	cltd   
  802283:	c1 ea 1b             	shr    $0x1b,%edx
  802286:	01 d0                	add    %edx,%eax
  802288:	83 e0 1f             	and    $0x1f,%eax
  80228b:	29 d0                	sub    %edx,%eax
  80228d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802295:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802298:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80229b:	83 c6 01             	add    $0x1,%esi
  80229e:	eb aa                	jmp    80224a <devpipe_read+0x20>

008022a0 <pipe>:
{
  8022a0:	f3 0f 1e fb          	endbr32 
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	56                   	push   %esi
  8022a8:	53                   	push   %ebx
  8022a9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022af:	50                   	push   %eax
  8022b0:	e8 0e f0 ff ff       	call   8012c3 <fd_alloc>
  8022b5:	89 c3                	mov    %eax,%ebx
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	0f 88 23 01 00 00    	js     8023e5 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022c2:	83 ec 04             	sub    $0x4,%esp
  8022c5:	68 07 04 00 00       	push   $0x407
  8022ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8022cd:	6a 00                	push   $0x0
  8022cf:	e8 a1 eb ff ff       	call   800e75 <sys_page_alloc>
  8022d4:	89 c3                	mov    %eax,%ebx
  8022d6:	83 c4 10             	add    $0x10,%esp
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	0f 88 04 01 00 00    	js     8023e5 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8022e1:	83 ec 0c             	sub    $0xc,%esp
  8022e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022e7:	50                   	push   %eax
  8022e8:	e8 d6 ef ff ff       	call   8012c3 <fd_alloc>
  8022ed:	89 c3                	mov    %eax,%ebx
  8022ef:	83 c4 10             	add    $0x10,%esp
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	0f 88 db 00 00 00    	js     8023d5 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022fa:	83 ec 04             	sub    $0x4,%esp
  8022fd:	68 07 04 00 00       	push   $0x407
  802302:	ff 75 f0             	pushl  -0x10(%ebp)
  802305:	6a 00                	push   $0x0
  802307:	e8 69 eb ff ff       	call   800e75 <sys_page_alloc>
  80230c:	89 c3                	mov    %eax,%ebx
  80230e:	83 c4 10             	add    $0x10,%esp
  802311:	85 c0                	test   %eax,%eax
  802313:	0f 88 bc 00 00 00    	js     8023d5 <pipe+0x135>
	va = fd2data(fd0);
  802319:	83 ec 0c             	sub    $0xc,%esp
  80231c:	ff 75 f4             	pushl  -0xc(%ebp)
  80231f:	e8 84 ef ff ff       	call   8012a8 <fd2data>
  802324:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802326:	83 c4 0c             	add    $0xc,%esp
  802329:	68 07 04 00 00       	push   $0x407
  80232e:	50                   	push   %eax
  80232f:	6a 00                	push   $0x0
  802331:	e8 3f eb ff ff       	call   800e75 <sys_page_alloc>
  802336:	89 c3                	mov    %eax,%ebx
  802338:	83 c4 10             	add    $0x10,%esp
  80233b:	85 c0                	test   %eax,%eax
  80233d:	0f 88 82 00 00 00    	js     8023c5 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802343:	83 ec 0c             	sub    $0xc,%esp
  802346:	ff 75 f0             	pushl  -0x10(%ebp)
  802349:	e8 5a ef ff ff       	call   8012a8 <fd2data>
  80234e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802355:	50                   	push   %eax
  802356:	6a 00                	push   $0x0
  802358:	56                   	push   %esi
  802359:	6a 00                	push   $0x0
  80235b:	e8 5c eb ff ff       	call   800ebc <sys_page_map>
  802360:	89 c3                	mov    %eax,%ebx
  802362:	83 c4 20             	add    $0x20,%esp
  802365:	85 c0                	test   %eax,%eax
  802367:	78 4e                	js     8023b7 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802369:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80236e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802371:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802376:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80237d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802380:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802385:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80238c:	83 ec 0c             	sub    $0xc,%esp
  80238f:	ff 75 f4             	pushl  -0xc(%ebp)
  802392:	e8 fd ee ff ff       	call   801294 <fd2num>
  802397:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80239a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80239c:	83 c4 04             	add    $0x4,%esp
  80239f:	ff 75 f0             	pushl  -0x10(%ebp)
  8023a2:	e8 ed ee ff ff       	call   801294 <fd2num>
  8023a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023aa:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023ad:	83 c4 10             	add    $0x10,%esp
  8023b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023b5:	eb 2e                	jmp    8023e5 <pipe+0x145>
	sys_page_unmap(0, va);
  8023b7:	83 ec 08             	sub    $0x8,%esp
  8023ba:	56                   	push   %esi
  8023bb:	6a 00                	push   $0x0
  8023bd:	e8 40 eb ff ff       	call   800f02 <sys_page_unmap>
  8023c2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023c5:	83 ec 08             	sub    $0x8,%esp
  8023c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8023cb:	6a 00                	push   $0x0
  8023cd:	e8 30 eb ff ff       	call   800f02 <sys_page_unmap>
  8023d2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023d5:	83 ec 08             	sub    $0x8,%esp
  8023d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8023db:	6a 00                	push   $0x0
  8023dd:	e8 20 eb ff ff       	call   800f02 <sys_page_unmap>
  8023e2:	83 c4 10             	add    $0x10,%esp
}
  8023e5:	89 d8                	mov    %ebx,%eax
  8023e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023ea:	5b                   	pop    %ebx
  8023eb:	5e                   	pop    %esi
  8023ec:	5d                   	pop    %ebp
  8023ed:	c3                   	ret    

008023ee <pipeisclosed>:
{
  8023ee:	f3 0f 1e fb          	endbr32 
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023fb:	50                   	push   %eax
  8023fc:	ff 75 08             	pushl  0x8(%ebp)
  8023ff:	e8 15 ef ff ff       	call   801319 <fd_lookup>
  802404:	83 c4 10             	add    $0x10,%esp
  802407:	85 c0                	test   %eax,%eax
  802409:	78 18                	js     802423 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80240b:	83 ec 0c             	sub    $0xc,%esp
  80240e:	ff 75 f4             	pushl  -0xc(%ebp)
  802411:	e8 92 ee ff ff       	call   8012a8 <fd2data>
  802416:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	e8 1f fd ff ff       	call   80213f <_pipeisclosed>
  802420:	83 c4 10             	add    $0x10,%esp
}
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802425:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
  80242e:	c3                   	ret    

0080242f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80242f:	f3 0f 1e fb          	endbr32 
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802439:	68 87 2e 80 00       	push   $0x802e87
  80243e:	ff 75 0c             	pushl  0xc(%ebp)
  802441:	e8 ed e5 ff ff       	call   800a33 <strcpy>
	return 0;
}
  802446:	b8 00 00 00 00       	mov    $0x0,%eax
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <devcons_write>:
{
  80244d:	f3 0f 1e fb          	endbr32 
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
  802454:	57                   	push   %edi
  802455:	56                   	push   %esi
  802456:	53                   	push   %ebx
  802457:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80245d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802462:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802468:	3b 75 10             	cmp    0x10(%ebp),%esi
  80246b:	73 31                	jae    80249e <devcons_write+0x51>
		m = n - tot;
  80246d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802470:	29 f3                	sub    %esi,%ebx
  802472:	83 fb 7f             	cmp    $0x7f,%ebx
  802475:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80247a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80247d:	83 ec 04             	sub    $0x4,%esp
  802480:	53                   	push   %ebx
  802481:	89 f0                	mov    %esi,%eax
  802483:	03 45 0c             	add    0xc(%ebp),%eax
  802486:	50                   	push   %eax
  802487:	57                   	push   %edi
  802488:	e8 5c e7 ff ff       	call   800be9 <memmove>
		sys_cputs(buf, m);
  80248d:	83 c4 08             	add    $0x8,%esp
  802490:	53                   	push   %ebx
  802491:	57                   	push   %edi
  802492:	e8 0e e9 ff ff       	call   800da5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802497:	01 de                	add    %ebx,%esi
  802499:	83 c4 10             	add    $0x10,%esp
  80249c:	eb ca                	jmp    802468 <devcons_write+0x1b>
}
  80249e:	89 f0                	mov    %esi,%eax
  8024a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024a3:	5b                   	pop    %ebx
  8024a4:	5e                   	pop    %esi
  8024a5:	5f                   	pop    %edi
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    

008024a8 <devcons_read>:
{
  8024a8:	f3 0f 1e fb          	endbr32 
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 08             	sub    $0x8,%esp
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024bb:	74 21                	je     8024de <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8024bd:	e8 05 e9 ff ff       	call   800dc7 <sys_cgetc>
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	75 07                	jne    8024cd <devcons_read+0x25>
		sys_yield();
  8024c6:	e8 87 e9 ff ff       	call   800e52 <sys_yield>
  8024cb:	eb f0                	jmp    8024bd <devcons_read+0x15>
	if (c < 0)
  8024cd:	78 0f                	js     8024de <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8024cf:	83 f8 04             	cmp    $0x4,%eax
  8024d2:	74 0c                	je     8024e0 <devcons_read+0x38>
	*(char*)vbuf = c;
  8024d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d7:	88 02                	mov    %al,(%edx)
	return 1;
  8024d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    
		return 0;
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e5:	eb f7                	jmp    8024de <devcons_read+0x36>

008024e7 <cputchar>:
{
  8024e7:	f3 0f 1e fb          	endbr32 
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024f7:	6a 01                	push   $0x1
  8024f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024fc:	50                   	push   %eax
  8024fd:	e8 a3 e8 ff ff       	call   800da5 <sys_cputs>
}
  802502:	83 c4 10             	add    $0x10,%esp
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <getchar>:
{
  802507:	f3 0f 1e fb          	endbr32 
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802511:	6a 01                	push   $0x1
  802513:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802516:	50                   	push   %eax
  802517:	6a 00                	push   $0x0
  802519:	e8 83 f0 ff ff       	call   8015a1 <read>
	if (r < 0)
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	85 c0                	test   %eax,%eax
  802523:	78 06                	js     80252b <getchar+0x24>
	if (r < 1)
  802525:	74 06                	je     80252d <getchar+0x26>
	return c;
  802527:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    
		return -E_EOF;
  80252d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802532:	eb f7                	jmp    80252b <getchar+0x24>

00802534 <iscons>:
{
  802534:	f3 0f 1e fb          	endbr32 
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80253e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802541:	50                   	push   %eax
  802542:	ff 75 08             	pushl  0x8(%ebp)
  802545:	e8 cf ed ff ff       	call   801319 <fd_lookup>
  80254a:	83 c4 10             	add    $0x10,%esp
  80254d:	85 c0                	test   %eax,%eax
  80254f:	78 11                	js     802562 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80255a:	39 10                	cmp    %edx,(%eax)
  80255c:	0f 94 c0             	sete   %al
  80255f:	0f b6 c0             	movzbl %al,%eax
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <opencons>:
{
  802564:	f3 0f 1e fb          	endbr32 
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80256e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802571:	50                   	push   %eax
  802572:	e8 4c ed ff ff       	call   8012c3 <fd_alloc>
  802577:	83 c4 10             	add    $0x10,%esp
  80257a:	85 c0                	test   %eax,%eax
  80257c:	78 3a                	js     8025b8 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80257e:	83 ec 04             	sub    $0x4,%esp
  802581:	68 07 04 00 00       	push   $0x407
  802586:	ff 75 f4             	pushl  -0xc(%ebp)
  802589:	6a 00                	push   $0x0
  80258b:	e8 e5 e8 ff ff       	call   800e75 <sys_page_alloc>
  802590:	83 c4 10             	add    $0x10,%esp
  802593:	85 c0                	test   %eax,%eax
  802595:	78 21                	js     8025b8 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8025a0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025ac:	83 ec 0c             	sub    $0xc,%esp
  8025af:	50                   	push   %eax
  8025b0:	e8 df ec ff ff       	call   801294 <fd2num>
  8025b5:	83 c4 10             	add    $0x10,%esp
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025ba:	f3 0f 1e fb          	endbr32 
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
  8025c1:	56                   	push   %esi
  8025c2:	53                   	push   %ebx
  8025c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8025c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	74 3d                	je     80260d <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8025d0:	83 ec 0c             	sub    $0xc,%esp
  8025d3:	50                   	push   %eax
  8025d4:	e8 68 ea ff ff       	call   801041 <sys_ipc_recv>
  8025d9:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8025dc:	85 f6                	test   %esi,%esi
  8025de:	74 0b                	je     8025eb <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8025e0:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8025e6:	8b 52 74             	mov    0x74(%edx),%edx
  8025e9:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8025eb:	85 db                	test   %ebx,%ebx
  8025ed:	74 0b                	je     8025fa <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8025ef:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8025f5:	8b 52 78             	mov    0x78(%edx),%edx
  8025f8:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8025fa:	85 c0                	test   %eax,%eax
  8025fc:	78 21                	js     80261f <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8025fe:	a1 20 44 80 00       	mov    0x804420,%eax
  802603:	8b 40 70             	mov    0x70(%eax),%eax
}
  802606:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802609:	5b                   	pop    %ebx
  80260a:	5e                   	pop    %esi
  80260b:	5d                   	pop    %ebp
  80260c:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80260d:	83 ec 0c             	sub    $0xc,%esp
  802610:	68 00 00 c0 ee       	push   $0xeec00000
  802615:	e8 27 ea ff ff       	call   801041 <sys_ipc_recv>
  80261a:	83 c4 10             	add    $0x10,%esp
  80261d:	eb bd                	jmp    8025dc <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80261f:	85 f6                	test   %esi,%esi
  802621:	74 10                	je     802633 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802623:	85 db                	test   %ebx,%ebx
  802625:	75 df                	jne    802606 <ipc_recv+0x4c>
  802627:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80262e:	00 00 00 
  802631:	eb d3                	jmp    802606 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802633:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80263a:	00 00 00 
  80263d:	eb e4                	jmp    802623 <ipc_recv+0x69>

0080263f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80263f:	f3 0f 1e fb          	endbr32 
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	57                   	push   %edi
  802647:	56                   	push   %esi
  802648:	53                   	push   %ebx
  802649:	83 ec 0c             	sub    $0xc,%esp
  80264c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80264f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802652:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802655:	85 db                	test   %ebx,%ebx
  802657:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80265c:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80265f:	ff 75 14             	pushl  0x14(%ebp)
  802662:	53                   	push   %ebx
  802663:	56                   	push   %esi
  802664:	57                   	push   %edi
  802665:	e8 b0 e9 ff ff       	call   80101a <sys_ipc_try_send>
  80266a:	83 c4 10             	add    $0x10,%esp
  80266d:	85 c0                	test   %eax,%eax
  80266f:	79 1e                	jns    80268f <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802671:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802674:	75 07                	jne    80267d <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802676:	e8 d7 e7 ff ff       	call   800e52 <sys_yield>
  80267b:	eb e2                	jmp    80265f <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80267d:	50                   	push   %eax
  80267e:	68 93 2e 80 00       	push   $0x802e93
  802683:	6a 59                	push   $0x59
  802685:	68 ae 2e 80 00       	push   $0x802eae
  80268a:	e8 b3 dc ff ff       	call   800342 <_panic>
	}
}
  80268f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802692:	5b                   	pop    %ebx
  802693:	5e                   	pop    %esi
  802694:	5f                   	pop    %edi
  802695:	5d                   	pop    %ebp
  802696:	c3                   	ret    

00802697 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802697:	f3 0f 1e fb          	endbr32 
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026a6:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026a9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026af:	8b 52 50             	mov    0x50(%edx),%edx
  8026b2:	39 ca                	cmp    %ecx,%edx
  8026b4:	74 11                	je     8026c7 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8026b6:	83 c0 01             	add    $0x1,%eax
  8026b9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026be:	75 e6                	jne    8026a6 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8026c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c5:	eb 0b                	jmp    8026d2 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8026c7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026cf:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026d2:	5d                   	pop    %ebp
  8026d3:	c3                   	ret    

008026d4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026d4:	f3 0f 1e fb          	endbr32 
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026de:	89 c2                	mov    %eax,%edx
  8026e0:	c1 ea 16             	shr    $0x16,%edx
  8026e3:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8026ea:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8026ef:	f6 c1 01             	test   $0x1,%cl
  8026f2:	74 1c                	je     802710 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8026f4:	c1 e8 0c             	shr    $0xc,%eax
  8026f7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8026fe:	a8 01                	test   $0x1,%al
  802700:	74 0e                	je     802710 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802702:	c1 e8 0c             	shr    $0xc,%eax
  802705:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80270c:	ef 
  80270d:	0f b7 d2             	movzwl %dx,%edx
}
  802710:	89 d0                	mov    %edx,%eax
  802712:	5d                   	pop    %ebp
  802713:	c3                   	ret    
  802714:	66 90                	xchg   %ax,%ax
  802716:	66 90                	xchg   %ax,%ax
  802718:	66 90                	xchg   %ax,%ax
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <__udivdi3>:
  802720:	f3 0f 1e fb          	endbr32 
  802724:	55                   	push   %ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	83 ec 1c             	sub    $0x1c,%esp
  80272b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80272f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802733:	8b 74 24 34          	mov    0x34(%esp),%esi
  802737:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80273b:	85 d2                	test   %edx,%edx
  80273d:	75 19                	jne    802758 <__udivdi3+0x38>
  80273f:	39 f3                	cmp    %esi,%ebx
  802741:	76 4d                	jbe    802790 <__udivdi3+0x70>
  802743:	31 ff                	xor    %edi,%edi
  802745:	89 e8                	mov    %ebp,%eax
  802747:	89 f2                	mov    %esi,%edx
  802749:	f7 f3                	div    %ebx
  80274b:	89 fa                	mov    %edi,%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	39 f2                	cmp    %esi,%edx
  80275a:	76 14                	jbe    802770 <__udivdi3+0x50>
  80275c:	31 ff                	xor    %edi,%edi
  80275e:	31 c0                	xor    %eax,%eax
  802760:	89 fa                	mov    %edi,%edx
  802762:	83 c4 1c             	add    $0x1c,%esp
  802765:	5b                   	pop    %ebx
  802766:	5e                   	pop    %esi
  802767:	5f                   	pop    %edi
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    
  80276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802770:	0f bd fa             	bsr    %edx,%edi
  802773:	83 f7 1f             	xor    $0x1f,%edi
  802776:	75 48                	jne    8027c0 <__udivdi3+0xa0>
  802778:	39 f2                	cmp    %esi,%edx
  80277a:	72 06                	jb     802782 <__udivdi3+0x62>
  80277c:	31 c0                	xor    %eax,%eax
  80277e:	39 eb                	cmp    %ebp,%ebx
  802780:	77 de                	ja     802760 <__udivdi3+0x40>
  802782:	b8 01 00 00 00       	mov    $0x1,%eax
  802787:	eb d7                	jmp    802760 <__udivdi3+0x40>
  802789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802790:	89 d9                	mov    %ebx,%ecx
  802792:	85 db                	test   %ebx,%ebx
  802794:	75 0b                	jne    8027a1 <__udivdi3+0x81>
  802796:	b8 01 00 00 00       	mov    $0x1,%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	f7 f3                	div    %ebx
  80279f:	89 c1                	mov    %eax,%ecx
  8027a1:	31 d2                	xor    %edx,%edx
  8027a3:	89 f0                	mov    %esi,%eax
  8027a5:	f7 f1                	div    %ecx
  8027a7:	89 c6                	mov    %eax,%esi
  8027a9:	89 e8                	mov    %ebp,%eax
  8027ab:	89 f7                	mov    %esi,%edi
  8027ad:	f7 f1                	div    %ecx
  8027af:	89 fa                	mov    %edi,%edx
  8027b1:	83 c4 1c             	add    $0x1c,%esp
  8027b4:	5b                   	pop    %ebx
  8027b5:	5e                   	pop    %esi
  8027b6:	5f                   	pop    %edi
  8027b7:	5d                   	pop    %ebp
  8027b8:	c3                   	ret    
  8027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027c0:	89 f9                	mov    %edi,%ecx
  8027c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027c7:	29 f8                	sub    %edi,%eax
  8027c9:	d3 e2                	shl    %cl,%edx
  8027cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027cf:	89 c1                	mov    %eax,%ecx
  8027d1:	89 da                	mov    %ebx,%edx
  8027d3:	d3 ea                	shr    %cl,%edx
  8027d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027d9:	09 d1                	or     %edx,%ecx
  8027db:	89 f2                	mov    %esi,%edx
  8027dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027e1:	89 f9                	mov    %edi,%ecx
  8027e3:	d3 e3                	shl    %cl,%ebx
  8027e5:	89 c1                	mov    %eax,%ecx
  8027e7:	d3 ea                	shr    %cl,%edx
  8027e9:	89 f9                	mov    %edi,%ecx
  8027eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027ef:	89 eb                	mov    %ebp,%ebx
  8027f1:	d3 e6                	shl    %cl,%esi
  8027f3:	89 c1                	mov    %eax,%ecx
  8027f5:	d3 eb                	shr    %cl,%ebx
  8027f7:	09 de                	or     %ebx,%esi
  8027f9:	89 f0                	mov    %esi,%eax
  8027fb:	f7 74 24 08          	divl   0x8(%esp)
  8027ff:	89 d6                	mov    %edx,%esi
  802801:	89 c3                	mov    %eax,%ebx
  802803:	f7 64 24 0c          	mull   0xc(%esp)
  802807:	39 d6                	cmp    %edx,%esi
  802809:	72 15                	jb     802820 <__udivdi3+0x100>
  80280b:	89 f9                	mov    %edi,%ecx
  80280d:	d3 e5                	shl    %cl,%ebp
  80280f:	39 c5                	cmp    %eax,%ebp
  802811:	73 04                	jae    802817 <__udivdi3+0xf7>
  802813:	39 d6                	cmp    %edx,%esi
  802815:	74 09                	je     802820 <__udivdi3+0x100>
  802817:	89 d8                	mov    %ebx,%eax
  802819:	31 ff                	xor    %edi,%edi
  80281b:	e9 40 ff ff ff       	jmp    802760 <__udivdi3+0x40>
  802820:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802823:	31 ff                	xor    %edi,%edi
  802825:	e9 36 ff ff ff       	jmp    802760 <__udivdi3+0x40>
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	66 90                	xchg   %ax,%ax
  80282e:	66 90                	xchg   %ax,%ax

00802830 <__umoddi3>:
  802830:	f3 0f 1e fb          	endbr32 
  802834:	55                   	push   %ebp
  802835:	57                   	push   %edi
  802836:	56                   	push   %esi
  802837:	53                   	push   %ebx
  802838:	83 ec 1c             	sub    $0x1c,%esp
  80283b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80283f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802843:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802847:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80284b:	85 c0                	test   %eax,%eax
  80284d:	75 19                	jne    802868 <__umoddi3+0x38>
  80284f:	39 df                	cmp    %ebx,%edi
  802851:	76 5d                	jbe    8028b0 <__umoddi3+0x80>
  802853:	89 f0                	mov    %esi,%eax
  802855:	89 da                	mov    %ebx,%edx
  802857:	f7 f7                	div    %edi
  802859:	89 d0                	mov    %edx,%eax
  80285b:	31 d2                	xor    %edx,%edx
  80285d:	83 c4 1c             	add    $0x1c,%esp
  802860:	5b                   	pop    %ebx
  802861:	5e                   	pop    %esi
  802862:	5f                   	pop    %edi
  802863:	5d                   	pop    %ebp
  802864:	c3                   	ret    
  802865:	8d 76 00             	lea    0x0(%esi),%esi
  802868:	89 f2                	mov    %esi,%edx
  80286a:	39 d8                	cmp    %ebx,%eax
  80286c:	76 12                	jbe    802880 <__umoddi3+0x50>
  80286e:	89 f0                	mov    %esi,%eax
  802870:	89 da                	mov    %ebx,%edx
  802872:	83 c4 1c             	add    $0x1c,%esp
  802875:	5b                   	pop    %ebx
  802876:	5e                   	pop    %esi
  802877:	5f                   	pop    %edi
  802878:	5d                   	pop    %ebp
  802879:	c3                   	ret    
  80287a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802880:	0f bd e8             	bsr    %eax,%ebp
  802883:	83 f5 1f             	xor    $0x1f,%ebp
  802886:	75 50                	jne    8028d8 <__umoddi3+0xa8>
  802888:	39 d8                	cmp    %ebx,%eax
  80288a:	0f 82 e0 00 00 00    	jb     802970 <__umoddi3+0x140>
  802890:	89 d9                	mov    %ebx,%ecx
  802892:	39 f7                	cmp    %esi,%edi
  802894:	0f 86 d6 00 00 00    	jbe    802970 <__umoddi3+0x140>
  80289a:	89 d0                	mov    %edx,%eax
  80289c:	89 ca                	mov    %ecx,%edx
  80289e:	83 c4 1c             	add    $0x1c,%esp
  8028a1:	5b                   	pop    %ebx
  8028a2:	5e                   	pop    %esi
  8028a3:	5f                   	pop    %edi
  8028a4:	5d                   	pop    %ebp
  8028a5:	c3                   	ret    
  8028a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028ad:	8d 76 00             	lea    0x0(%esi),%esi
  8028b0:	89 fd                	mov    %edi,%ebp
  8028b2:	85 ff                	test   %edi,%edi
  8028b4:	75 0b                	jne    8028c1 <__umoddi3+0x91>
  8028b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bb:	31 d2                	xor    %edx,%edx
  8028bd:	f7 f7                	div    %edi
  8028bf:	89 c5                	mov    %eax,%ebp
  8028c1:	89 d8                	mov    %ebx,%eax
  8028c3:	31 d2                	xor    %edx,%edx
  8028c5:	f7 f5                	div    %ebp
  8028c7:	89 f0                	mov    %esi,%eax
  8028c9:	f7 f5                	div    %ebp
  8028cb:	89 d0                	mov    %edx,%eax
  8028cd:	31 d2                	xor    %edx,%edx
  8028cf:	eb 8c                	jmp    80285d <__umoddi3+0x2d>
  8028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	89 e9                	mov    %ebp,%ecx
  8028da:	ba 20 00 00 00       	mov    $0x20,%edx
  8028df:	29 ea                	sub    %ebp,%edx
  8028e1:	d3 e0                	shl    %cl,%eax
  8028e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028e7:	89 d1                	mov    %edx,%ecx
  8028e9:	89 f8                	mov    %edi,%eax
  8028eb:	d3 e8                	shr    %cl,%eax
  8028ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028f9:	09 c1                	or     %eax,%ecx
  8028fb:	89 d8                	mov    %ebx,%eax
  8028fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802901:	89 e9                	mov    %ebp,%ecx
  802903:	d3 e7                	shl    %cl,%edi
  802905:	89 d1                	mov    %edx,%ecx
  802907:	d3 e8                	shr    %cl,%eax
  802909:	89 e9                	mov    %ebp,%ecx
  80290b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80290f:	d3 e3                	shl    %cl,%ebx
  802911:	89 c7                	mov    %eax,%edi
  802913:	89 d1                	mov    %edx,%ecx
  802915:	89 f0                	mov    %esi,%eax
  802917:	d3 e8                	shr    %cl,%eax
  802919:	89 e9                	mov    %ebp,%ecx
  80291b:	89 fa                	mov    %edi,%edx
  80291d:	d3 e6                	shl    %cl,%esi
  80291f:	09 d8                	or     %ebx,%eax
  802921:	f7 74 24 08          	divl   0x8(%esp)
  802925:	89 d1                	mov    %edx,%ecx
  802927:	89 f3                	mov    %esi,%ebx
  802929:	f7 64 24 0c          	mull   0xc(%esp)
  80292d:	89 c6                	mov    %eax,%esi
  80292f:	89 d7                	mov    %edx,%edi
  802931:	39 d1                	cmp    %edx,%ecx
  802933:	72 06                	jb     80293b <__umoddi3+0x10b>
  802935:	75 10                	jne    802947 <__umoddi3+0x117>
  802937:	39 c3                	cmp    %eax,%ebx
  802939:	73 0c                	jae    802947 <__umoddi3+0x117>
  80293b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80293f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802943:	89 d7                	mov    %edx,%edi
  802945:	89 c6                	mov    %eax,%esi
  802947:	89 ca                	mov    %ecx,%edx
  802949:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80294e:	29 f3                	sub    %esi,%ebx
  802950:	19 fa                	sbb    %edi,%edx
  802952:	89 d0                	mov    %edx,%eax
  802954:	d3 e0                	shl    %cl,%eax
  802956:	89 e9                	mov    %ebp,%ecx
  802958:	d3 eb                	shr    %cl,%ebx
  80295a:	d3 ea                	shr    %cl,%edx
  80295c:	09 d8                	or     %ebx,%eax
  80295e:	83 c4 1c             	add    $0x1c,%esp
  802961:	5b                   	pop    %ebx
  802962:	5e                   	pop    %esi
  802963:	5f                   	pop    %edi
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    
  802966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	29 fe                	sub    %edi,%esi
  802972:	19 c3                	sbb    %eax,%ebx
  802974:	89 f2                	mov    %esi,%edx
  802976:	89 d9                	mov    %ebx,%ecx
  802978:	e9 1d ff ff ff       	jmp    80289a <__umoddi3+0x6a>
