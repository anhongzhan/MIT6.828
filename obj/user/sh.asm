
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 07 0a 00 00       	call   800a38 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 0c             	sub    $0xc,%esp
  800040:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800043:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800046:	85 db                	test   %ebx,%ebx
  800048:	74 1a                	je     800064 <_gettoken+0x31>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  80004a:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800051:	7f 31                	jg     800084 <_gettoken+0x51>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  800053:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  800059:	8b 45 10             	mov    0x10(%ebp),%eax
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  800062:	eb 3a                	jmp    80009e <_gettoken+0x6b>
		return 0;
  800064:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800069:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800070:	7e 59                	jle    8000cb <_gettoken+0x98>
			cprintf("GETTOKEN NULL\n");
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	68 c0 34 80 00       	push   $0x8034c0
  80007a:	e8 08 0b 00 00       	call   800b87 <cprintf>
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	eb 47                	jmp    8000cb <_gettoken+0x98>
		cprintf("GETTOKEN: %s\n", s);
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	53                   	push   %ebx
  800088:	68 cf 34 80 00       	push   $0x8034cf
  80008d:	e8 f5 0a 00 00       	call   800b87 <cprintf>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	eb bc                	jmp    800053 <_gettoken+0x20>
		*s++ = 0;
  800097:	83 c3 01             	add    $0x1,%ebx
  80009a:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	0f be 03             	movsbl (%ebx),%eax
  8000a4:	50                   	push   %eax
  8000a5:	68 dd 34 80 00       	push   $0x8034dd
  8000aa:	e8 fb 12 00 00       	call   8013aa <strchr>
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	85 c0                	test   %eax,%eax
  8000b4:	75 e1                	jne    800097 <_gettoken+0x64>
	if (*s == 0) {
  8000b6:	0f b6 03             	movzbl (%ebx),%eax
  8000b9:	84 c0                	test   %al,%al
  8000bb:	75 2a                	jne    8000e7 <_gettoken+0xb4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000bd:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000c2:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000c9:	7f 0a                	jg     8000d5 <_gettoken+0xa2>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000cb:	89 f0                	mov    %esi,%eax
  8000cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d0:	5b                   	pop    %ebx
  8000d1:	5e                   	pop    %esi
  8000d2:	5f                   	pop    %edi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    
			cprintf("EOL\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 e2 34 80 00       	push   $0x8034e2
  8000dd:	e8 a5 0a 00 00       	call   800b87 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb e4                	jmp    8000cb <_gettoken+0x98>
	if (strchr(SYMBOLS, *s)) {
  8000e7:	83 ec 08             	sub    $0x8,%esp
  8000ea:	0f be c0             	movsbl %al,%eax
  8000ed:	50                   	push   %eax
  8000ee:	68 f3 34 80 00       	push   $0x8034f3
  8000f3:	e8 b2 12 00 00       	call   8013aa <strchr>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	85 c0                	test   %eax,%eax
  8000fd:	74 2c                	je     80012b <_gettoken+0xf8>
		t = *s;
  8000ff:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  800102:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800104:	c6 03 00             	movb   $0x0,(%ebx)
  800107:	83 c3 01             	add    $0x1,%ebx
  80010a:	8b 45 10             	mov    0x10(%ebp),%eax
  80010d:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010f:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800116:	7e b3                	jle    8000cb <_gettoken+0x98>
			cprintf("TOK %c\n", t);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	56                   	push   %esi
  80011c:	68 e7 34 80 00       	push   $0x8034e7
  800121:	e8 61 0a 00 00       	call   800b87 <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	eb a0                	jmp    8000cb <_gettoken+0x98>
	*p1 = s;
  80012b:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012d:	eb 03                	jmp    800132 <_gettoken+0xff>
		s++;
  80012f:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800132:	0f b6 03             	movzbl (%ebx),%eax
  800135:	84 c0                	test   %al,%al
  800137:	74 18                	je     800151 <_gettoken+0x11e>
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	0f be c0             	movsbl %al,%eax
  80013f:	50                   	push   %eax
  800140:	68 ef 34 80 00       	push   $0x8034ef
  800145:	e8 60 12 00 00       	call   8013aa <strchr>
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	85 c0                	test   %eax,%eax
  80014f:	74 de                	je     80012f <_gettoken+0xfc>
	*p2 = s;
  800151:	8b 45 10             	mov    0x10(%ebp),%eax
  800154:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800156:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  80015b:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800162:	0f 8e 63 ff ff ff    	jle    8000cb <_gettoken+0x98>
		t = **p2;
  800168:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  80016b:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 37                	pushl  (%edi)
  800173:	68 fb 34 80 00       	push   $0x8034fb
  800178:	e8 0a 0a 00 00       	call   800b87 <cprintf>
		**p2 = t;
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 00                	mov    (%eax),%eax
  800182:	89 f2                	mov    %esi,%edx
  800184:	88 10                	mov    %dl,(%eax)
  800186:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800189:	be 77 00 00 00       	mov    $0x77,%esi
  80018e:	e9 38 ff ff ff       	jmp    8000cb <_gettoken+0x98>

00800193 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800193:	f3 0f 1e fb          	endbr32 
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 08             	sub    $0x8,%esp
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001a0:	85 c0                	test   %eax,%eax
  8001a2:	74 22                	je     8001c6 <gettoken+0x33>
		nc = _gettoken(s, &np1, &np2);
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 0c 50 80 00       	push   $0x80500c
  8001ac:	68 10 50 80 00       	push   $0x805010
  8001b1:	50                   	push   %eax
  8001b2:	e8 7c fe ff ff       	call   800033 <_gettoken>
  8001b7:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    
	c = nc;
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001d0:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 0c 50 80 00       	push   $0x80500c
  8001e3:	68 10 50 80 00       	push   $0x805010
  8001e8:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001ee:	e8 40 fe ff ff       	call   800033 <_gettoken>
  8001f3:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f8:	a1 04 50 80 00       	mov    0x805004,%eax
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	eb c2                	jmp    8001c4 <gettoken+0x31>

00800202 <runcmd>:
{
  800202:	f3 0f 1e fb          	endbr32 
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800212:	6a 00                	push   $0x0
  800214:	ff 75 08             	pushl  0x8(%ebp)
  800217:	e8 77 ff ff ff       	call   800193 <gettoken>
  80021c:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  80021f:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  800222:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	56                   	push   %esi
  80022b:	6a 00                	push   $0x0
  80022d:	e8 61 ff ff ff       	call   800193 <gettoken>
  800232:	89 c3                	mov    %eax,%ebx
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	83 f8 3e             	cmp    $0x3e,%eax
  80023a:	0f 84 2c 01 00 00    	je     80036c <runcmd+0x16a>
  800240:	7f 5c                	jg     80029e <runcmd+0x9c>
  800242:	85 c0                	test   %eax,%eax
  800244:	0f 84 16 02 00 00    	je     800460 <runcmd+0x25e>
  80024a:	83 f8 3c             	cmp    $0x3c,%eax
  80024d:	0f 85 e9 02 00 00    	jne    80053c <runcmd+0x33a>
			if (gettoken(0, &t) != 'w') {
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	56                   	push   %esi
  800257:	6a 00                	push   $0x0
  800259:	e8 35 ff ff ff       	call   800193 <gettoken>
  80025e:	83 c4 10             	add    $0x10,%esp
  800261:	83 f8 77             	cmp    $0x77,%eax
  800264:	0f 85 cd 00 00 00    	jne    800337 <runcmd+0x135>
			int fd = open(t, O_RDONLY);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	6a 00                	push   $0x0
  80026f:	ff 75 a4             	pushl  -0x5c(%ebp)
  800272:	e8 56 22 00 00       	call   8024cd <open>
  800277:	89 c3                	mov    %eax,%ebx
			if(fd < 0){
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	85 c0                	test   %eax,%eax
  80027e:	0f 88 cd 00 00 00    	js     800351 <runcmd+0x14f>
			}else if(fd){// then check whether 'fd' is 0.
  800284:	74 a1                	je     800227 <runcmd+0x25>
				dup(fd, 0);
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	6a 00                	push   $0x0
  80028b:	50                   	push   %eax
  80028c:	e8 b7 1c 00 00       	call   801f48 <dup>
				close(fd);
  800291:	89 1c 24             	mov    %ebx,(%esp)
  800294:	e8 55 1c 00 00       	call   801eee <close>
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	eb 89                	jmp    800227 <runcmd+0x25>
		switch ((c = gettoken(0, &t))) {
  80029e:	83 f8 77             	cmp    $0x77,%eax
  8002a1:	74 69                	je     80030c <runcmd+0x10a>
  8002a3:	83 f8 7c             	cmp    $0x7c,%eax
  8002a6:	0f 85 90 02 00 00    	jne    80053c <runcmd+0x33a>
			if ((r = pipe(p)) < 0) {
  8002ac:	83 ec 0c             	sub    $0xc,%esp
  8002af:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8002b5:	50                   	push   %eax
  8002b6:	e8 d2 2b 00 00       	call   802e8d <pipe>
  8002bb:	83 c4 10             	add    $0x10,%esp
  8002be:	85 c0                	test   %eax,%eax
  8002c0:	0f 88 28 01 00 00    	js     8003ee <runcmd+0x1ec>
			if (debug)
  8002c6:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002cd:	0f 85 36 01 00 00    	jne    800409 <runcmd+0x207>
			if ((r = fork()) < 0) {
  8002d3:	e8 e0 16 00 00       	call   8019b8 <fork>
  8002d8:	89 c3                	mov    %eax,%ebx
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	0f 88 48 01 00 00    	js     80042a <runcmd+0x228>
			if (r == 0) {
  8002e2:	0f 85 58 01 00 00    	jne    800440 <runcmd+0x23e>
				if (p[0] != 0) {
  8002e8:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002ee:	85 c0                	test   %eax,%eax
  8002f0:	0f 85 04 02 00 00    	jne    8004fa <runcmd+0x2f8>
				close(p[1]);
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002ff:	e8 ea 1b 00 00       	call   801eee <close>
				goto again;
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	e9 16 ff ff ff       	jmp    800222 <runcmd+0x20>
			if (argc == MAXARGS) {
  80030c:	83 ff 10             	cmp    $0x10,%edi
  80030f:	74 0f                	je     800320 <runcmd+0x11e>
			argv[argc++] = t;
  800311:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800314:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  800318:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  80031b:	e9 07 ff ff ff       	jmp    800227 <runcmd+0x25>
				cprintf("too many arguments\n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 05 35 80 00       	push   $0x803505
  800328:	e8 5a 08 00 00       	call   800b87 <cprintf>
				exit();
  80032d:	e8 50 07 00 00       	call   800a82 <exit>
  800332:	83 c4 10             	add    $0x10,%esp
  800335:	eb da                	jmp    800311 <runcmd+0x10f>
				cprintf("syntax error: < not followed by word\n");
  800337:	83 ec 0c             	sub    $0xc,%esp
  80033a:	68 50 36 80 00       	push   $0x803650
  80033f:	e8 43 08 00 00       	call   800b87 <cprintf>
				exit();
  800344:	e8 39 07 00 00       	call   800a82 <exit>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	e9 19 ff ff ff       	jmp    80026a <runcmd+0x68>
				cprintf("case <:open err - %e\n", fd);
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	50                   	push   %eax
  800355:	68 19 35 80 00       	push   $0x803519
  80035a:	e8 28 08 00 00       	call   800b87 <cprintf>
				exit();
  80035f:	e8 1e 07 00 00       	call   800a82 <exit>
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	e9 bb fe ff ff       	jmp    800227 <runcmd+0x25>
			if (gettoken(0, &t) != 'w') {
  80036c:	83 ec 08             	sub    $0x8,%esp
  80036f:	56                   	push   %esi
  800370:	6a 00                	push   $0x0
  800372:	e8 1c fe ff ff       	call   800193 <gettoken>
  800377:	83 c4 10             	add    $0x10,%esp
  80037a:	83 f8 77             	cmp    $0x77,%eax
  80037d:	75 24                	jne    8003a3 <runcmd+0x1a1>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	68 01 03 00 00       	push   $0x301
  800387:	ff 75 a4             	pushl  -0x5c(%ebp)
  80038a:	e8 3e 21 00 00       	call   8024cd <open>
  80038f:	89 c3                	mov    %eax,%ebx
  800391:	83 c4 10             	add    $0x10,%esp
  800394:	85 c0                	test   %eax,%eax
  800396:	78 22                	js     8003ba <runcmd+0x1b8>
			if (fd != 1) {
  800398:	83 f8 01             	cmp    $0x1,%eax
  80039b:	0f 84 86 fe ff ff    	je     800227 <runcmd+0x25>
  8003a1:	eb 30                	jmp    8003d3 <runcmd+0x1d1>
				cprintf("syntax error: > not followed by word\n");
  8003a3:	83 ec 0c             	sub    $0xc,%esp
  8003a6:	68 78 36 80 00       	push   $0x803678
  8003ab:	e8 d7 07 00 00       	call   800b87 <cprintf>
				exit();
  8003b0:	e8 cd 06 00 00       	call   800a82 <exit>
  8003b5:	83 c4 10             	add    $0x10,%esp
  8003b8:	eb c5                	jmp    80037f <runcmd+0x17d>
				cprintf("open %s for write: %e", t, fd);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	50                   	push   %eax
  8003be:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003c1:	68 2f 35 80 00       	push   $0x80352f
  8003c6:	e8 bc 07 00 00       	call   800b87 <cprintf>
				exit();
  8003cb:	e8 b2 06 00 00       	call   800a82 <exit>
  8003d0:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	6a 01                	push   $0x1
  8003d8:	53                   	push   %ebx
  8003d9:	e8 6a 1b 00 00       	call   801f48 <dup>
				close(fd);
  8003de:	89 1c 24             	mov    %ebx,(%esp)
  8003e1:	e8 08 1b 00 00       	call   801eee <close>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	e9 39 fe ff ff       	jmp    800227 <runcmd+0x25>
				cprintf("pipe: %e", r);
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	50                   	push   %eax
  8003f2:	68 45 35 80 00       	push   $0x803545
  8003f7:	e8 8b 07 00 00       	call   800b87 <cprintf>
				exit();
  8003fc:	e8 81 06 00 00       	call   800a82 <exit>
  800401:	83 c4 10             	add    $0x10,%esp
  800404:	e9 bd fe ff ff       	jmp    8002c6 <runcmd+0xc4>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800412:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800418:	68 4e 35 80 00       	push   $0x80354e
  80041d:	e8 65 07 00 00       	call   800b87 <cprintf>
  800422:	83 c4 10             	add    $0x10,%esp
  800425:	e9 a9 fe ff ff       	jmp    8002d3 <runcmd+0xd1>
				cprintf("fork: %e", r);
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	50                   	push   %eax
  80042e:	68 75 3a 80 00       	push   $0x803a75
  800433:	e8 4f 07 00 00       	call   800b87 <cprintf>
				exit();
  800438:	e8 45 06 00 00       	call   800a82 <exit>
  80043d:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  800440:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800446:	83 f8 01             	cmp    $0x1,%eax
  800449:	0f 85 cc 00 00 00    	jne    80051b <runcmd+0x319>
				close(p[0]);
  80044f:	83 ec 0c             	sub    $0xc,%esp
  800452:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800458:	e8 91 1a 00 00       	call   801eee <close>
				goto runit;
  80045d:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  800460:	85 ff                	test   %edi,%edi
  800462:	0f 84 e6 00 00 00    	je     80054e <runcmd+0x34c>
	if (argv[0][0] != '/') {
  800468:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80046b:	80 38 2f             	cmpb   $0x2f,(%eax)
  80046e:	0f 85 f5 00 00 00    	jne    800569 <runcmd+0x367>
	argv[argc] = 0;
  800474:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  80047b:	00 
	if (debug) {
  80047c:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800483:	0f 85 08 01 00 00    	jne    800591 <runcmd+0x38f>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	8d 45 a8             	lea    -0x58(%ebp),%eax
  80048f:	50                   	push   %eax
  800490:	ff 75 a8             	pushl  -0x58(%ebp)
  800493:	e8 06 22 00 00       	call   80269e <spawn>
  800498:	89 c6                	mov    %eax,%esi
  80049a:	83 c4 10             	add    $0x10,%esp
  80049d:	85 c0                	test   %eax,%eax
  80049f:	0f 88 3a 01 00 00    	js     8005df <runcmd+0x3dd>
	close_all();
  8004a5:	e8 75 1a 00 00       	call   801f1f <close_all>
		if (debug)
  8004aa:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004b1:	0f 85 75 01 00 00    	jne    80062c <runcmd+0x42a>
		wait(r);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	56                   	push   %esi
  8004bb:	e8 52 2b 00 00       	call   803012 <wait>
		if (debug)
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004ca:	0f 85 7b 01 00 00    	jne    80064b <runcmd+0x449>
	if (pipe_child) {
  8004d0:	85 db                	test   %ebx,%ebx
  8004d2:	74 19                	je     8004ed <runcmd+0x2eb>
		wait(pipe_child);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	53                   	push   %ebx
  8004d8:	e8 35 2b 00 00       	call   803012 <wait>
		if (debug)
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004e7:	0f 85 79 01 00 00    	jne    800666 <runcmd+0x464>
	exit();
  8004ed:	e8 90 05 00 00       	call   800a82 <exit>
}
  8004f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f5:	5b                   	pop    %ebx
  8004f6:	5e                   	pop    %esi
  8004f7:	5f                   	pop    %edi
  8004f8:	5d                   	pop    %ebp
  8004f9:	c3                   	ret    
					dup(p[0], 0);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	6a 00                	push   $0x0
  8004ff:	50                   	push   %eax
  800500:	e8 43 1a 00 00       	call   801f48 <dup>
					close(p[0]);
  800505:	83 c4 04             	add    $0x4,%esp
  800508:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80050e:	e8 db 19 00 00       	call   801eee <close>
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	e9 db fd ff ff       	jmp    8002f6 <runcmd+0xf4>
					dup(p[1], 1);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	6a 01                	push   $0x1
  800520:	50                   	push   %eax
  800521:	e8 22 1a 00 00       	call   801f48 <dup>
					close(p[1]);
  800526:	83 c4 04             	add    $0x4,%esp
  800529:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80052f:	e8 ba 19 00 00       	call   801eee <close>
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	e9 13 ff ff ff       	jmp    80044f <runcmd+0x24d>
			panic("bad return %d from gettoken", c);
  80053c:	53                   	push   %ebx
  80053d:	68 5b 35 80 00       	push   $0x80355b
  800542:	6a 7c                	push   $0x7c
  800544:	68 77 35 80 00       	push   $0x803577
  800549:	e8 52 05 00 00       	call   800aa0 <_panic>
		if (debug)
  80054e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800555:	74 9b                	je     8004f2 <runcmd+0x2f0>
			cprintf("EMPTY COMMAND\n");
  800557:	83 ec 0c             	sub    $0xc,%esp
  80055a:	68 81 35 80 00       	push   $0x803581
  80055f:	e8 23 06 00 00       	call   800b87 <cprintf>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	eb 89                	jmp    8004f2 <runcmd+0x2f0>
		argv0buf[0] = '/';
  800569:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	50                   	push   %eax
  800574:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  80057a:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800580:	50                   	push   %eax
  800581:	e8 ff 0c 00 00       	call   801285 <strcpy>
		argv[0] = argv0buf;
  800586:	89 75 a8             	mov    %esi,-0x58(%ebp)
  800589:	83 c4 10             	add    $0x10,%esp
  80058c:	e9 e3 fe ff ff       	jmp    800474 <runcmd+0x272>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800591:	a1 24 54 80 00       	mov    0x805424,%eax
  800596:	8b 40 48             	mov    0x48(%eax),%eax
  800599:	83 ec 08             	sub    $0x8,%esp
  80059c:	50                   	push   %eax
  80059d:	68 90 35 80 00       	push   $0x803590
  8005a2:	e8 e0 05 00 00       	call   800b87 <cprintf>
  8005a7:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	eb 11                	jmp    8005c0 <runcmd+0x3be>
			cprintf(" %s", argv[i]);
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	50                   	push   %eax
  8005b3:	68 18 36 80 00       	push   $0x803618
  8005b8:	e8 ca 05 00 00       	call   800b87 <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
  8005c0:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005c3:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	75 e5                	jne    8005af <runcmd+0x3ad>
		cprintf("\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 e0 34 80 00       	push   $0x8034e0
  8005d2:	e8 b0 05 00 00       	call   800b87 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	e9 aa fe ff ff       	jmp    800489 <runcmd+0x287>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	50                   	push   %eax
  8005e3:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e6:	68 9e 35 80 00       	push   $0x80359e
  8005eb:	e8 97 05 00 00       	call   800b87 <cprintf>
	close_all();
  8005f0:	e8 2a 19 00 00       	call   801f1f <close_all>
  8005f5:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005f8:	85 db                	test   %ebx,%ebx
  8005fa:	0f 84 ed fe ff ff    	je     8004ed <runcmd+0x2eb>
		if (debug)
  800600:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800607:	0f 84 c7 fe ff ff    	je     8004d4 <runcmd+0x2d2>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  80060d:	a1 24 54 80 00       	mov    0x805424,%eax
  800612:	8b 40 48             	mov    0x48(%eax),%eax
  800615:	83 ec 04             	sub    $0x4,%esp
  800618:	53                   	push   %ebx
  800619:	50                   	push   %eax
  80061a:	68 d7 35 80 00       	push   $0x8035d7
  80061f:	e8 63 05 00 00       	call   800b87 <cprintf>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	e9 a8 fe ff ff       	jmp    8004d4 <runcmd+0x2d2>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  80062c:	a1 24 54 80 00       	mov    0x805424,%eax
  800631:	8b 40 48             	mov    0x48(%eax),%eax
  800634:	56                   	push   %esi
  800635:	ff 75 a8             	pushl  -0x58(%ebp)
  800638:	50                   	push   %eax
  800639:	68 ac 35 80 00       	push   $0x8035ac
  80063e:	e8 44 05 00 00       	call   800b87 <cprintf>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	e9 6c fe ff ff       	jmp    8004b7 <runcmd+0x2b5>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80064b:	a1 24 54 80 00       	mov    0x805424,%eax
  800650:	8b 40 48             	mov    0x48(%eax),%eax
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	50                   	push   %eax
  800657:	68 c1 35 80 00       	push   $0x8035c1
  80065c:	e8 26 05 00 00       	call   800b87 <cprintf>
  800661:	83 c4 10             	add    $0x10,%esp
  800664:	eb 92                	jmp    8005f8 <runcmd+0x3f6>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800666:	a1 24 54 80 00       	mov    0x805424,%eax
  80066b:	8b 40 48             	mov    0x48(%eax),%eax
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	50                   	push   %eax
  800672:	68 c1 35 80 00       	push   $0x8035c1
  800677:	e8 0b 05 00 00       	call   800b87 <cprintf>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	e9 69 fe ff ff       	jmp    8004ed <runcmd+0x2eb>

00800684 <usage>:


void
usage(void)
{
  800684:	f3 0f 1e fb          	endbr32 
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  80068e:	68 a0 36 80 00       	push   $0x8036a0
  800693:	e8 ef 04 00 00       	call   800b87 <cprintf>
	exit();
  800698:	e8 e5 03 00 00       	call   800a82 <exit>
}
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	c9                   	leave  
  8006a1:	c3                   	ret    

008006a2 <umain>:

void
umain(int argc, char **argv)
{
  8006a2:	f3 0f 1e fb          	endbr32 
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	57                   	push   %edi
  8006aa:	56                   	push   %esi
  8006ab:	53                   	push   %ebx
  8006ac:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006af:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	ff 75 0c             	pushl  0xc(%ebp)
  8006b6:	8d 45 08             	lea    0x8(%ebp),%eax
  8006b9:	50                   	push   %eax
  8006ba:	e8 12 15 00 00       	call   801bd1 <argstart>
	while ((r = argnext(&args)) >= 0)
  8006bf:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006c2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006c9:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006ce:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006d1:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006d6:	eb 10                	jmp    8006e8 <umain+0x46>
			debug++;
  8006d8:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  8006df:	eb 07                	jmp    8006e8 <umain+0x46>
			interactive = 1;
  8006e1:	89 f7                	mov    %esi,%edi
  8006e3:	eb 03                	jmp    8006e8 <umain+0x46>
		switch (r) {
  8006e5:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006e8:	83 ec 0c             	sub    $0xc,%esp
  8006eb:	53                   	push   %ebx
  8006ec:	e8 14 15 00 00       	call   801c05 <argnext>
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	85 c0                	test   %eax,%eax
  8006f6:	78 16                	js     80070e <umain+0x6c>
		switch (r) {
  8006f8:	83 f8 69             	cmp    $0x69,%eax
  8006fb:	74 e4                	je     8006e1 <umain+0x3f>
  8006fd:	83 f8 78             	cmp    $0x78,%eax
  800700:	74 e3                	je     8006e5 <umain+0x43>
  800702:	83 f8 64             	cmp    $0x64,%eax
  800705:	74 d1                	je     8006d8 <umain+0x36>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  800707:	e8 78 ff ff ff       	call   800684 <usage>
  80070c:	eb da                	jmp    8006e8 <umain+0x46>
		}

	if (argc > 2)
  80070e:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800712:	7f 1f                	jg     800733 <umain+0x91>
		usage();
	if (argc == 2) {
  800714:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800718:	74 20                	je     80073a <umain+0x98>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  80071a:	83 ff 3f             	cmp    $0x3f,%edi
  80071d:	74 75                	je     800794 <umain+0xf2>
  80071f:	85 ff                	test   %edi,%edi
  800721:	bf 1c 36 80 00       	mov    $0x80361c,%edi
  800726:	b8 00 00 00 00       	mov    $0x0,%eax
  80072b:	0f 44 f8             	cmove  %eax,%edi
  80072e:	e9 06 01 00 00       	jmp    800839 <umain+0x197>
		usage();
  800733:	e8 4c ff ff ff       	call   800684 <usage>
  800738:	eb da                	jmp    800714 <umain+0x72>
		close(0);
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	e8 aa 17 00 00       	call   801eee <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800744:	83 c4 08             	add    $0x8,%esp
  800747:	6a 00                	push   $0x0
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	ff 70 04             	pushl  0x4(%eax)
  80074f:	e8 79 1d 00 00       	call   8024cd <open>
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	85 c0                	test   %eax,%eax
  800759:	78 1b                	js     800776 <umain+0xd4>
		assert(r == 0);
  80075b:	74 bd                	je     80071a <umain+0x78>
  80075d:	68 00 36 80 00       	push   $0x803600
  800762:	68 07 36 80 00       	push   $0x803607
  800767:	68 2d 01 00 00       	push   $0x12d
  80076c:	68 77 35 80 00       	push   $0x803577
  800771:	e8 2a 03 00 00       	call   800aa0 <_panic>
			panic("open %s: %e", argv[1], r);
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	50                   	push   %eax
  80077a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077d:	ff 70 04             	pushl  0x4(%eax)
  800780:	68 f4 35 80 00       	push   $0x8035f4
  800785:	68 2c 01 00 00       	push   $0x12c
  80078a:	68 77 35 80 00       	push   $0x803577
  80078f:	e8 0c 03 00 00       	call   800aa0 <_panic>
		interactive = iscons(0);
  800794:	83 ec 0c             	sub    $0xc,%esp
  800797:	6a 00                	push   $0x0
  800799:	e8 14 02 00 00       	call   8009b2 <iscons>
  80079e:	89 c7                	mov    %eax,%edi
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	e9 77 ff ff ff       	jmp    80071f <umain+0x7d>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  8007a8:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8007af:	75 0a                	jne    8007bb <umain+0x119>
				cprintf("EXITING\n");
			exit();	// end of file
  8007b1:	e8 cc 02 00 00       	call   800a82 <exit>
  8007b6:	e9 94 00 00 00       	jmp    80084f <umain+0x1ad>
				cprintf("EXITING\n");
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	68 1f 36 80 00       	push   $0x80361f
  8007c3:	e8 bf 03 00 00       	call   800b87 <cprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	eb e4                	jmp    8007b1 <umain+0x10f>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	68 28 36 80 00       	push   $0x803628
  8007d6:	e8 ac 03 00 00       	call   800b87 <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	eb 7c                	jmp    80085c <umain+0x1ba>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	53                   	push   %ebx
  8007e4:	68 32 36 80 00       	push   $0x803632
  8007e9:	e8 96 1e 00 00       	call   802684 <printf>
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	eb 78                	jmp    80086b <umain+0x1c9>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007f3:	83 ec 0c             	sub    $0xc,%esp
  8007f6:	68 38 36 80 00       	push   $0x803638
  8007fb:	e8 87 03 00 00       	call   800b87 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
  800803:	eb 73                	jmp    800878 <umain+0x1d6>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  800805:	50                   	push   %eax
  800806:	68 75 3a 80 00       	push   $0x803a75
  80080b:	68 44 01 00 00       	push   $0x144
  800810:	68 77 35 80 00       	push   $0x803577
  800815:	e8 86 02 00 00       	call   800aa0 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	50                   	push   %eax
  80081e:	68 45 36 80 00       	push   $0x803645
  800823:	e8 5f 03 00 00       	call   800b87 <cprintf>
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	eb 5f                	jmp    80088c <umain+0x1ea>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	56                   	push   %esi
  800831:	e8 dc 27 00 00       	call   803012 <wait>
  800836:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  800839:	83 ec 0c             	sub    $0xc,%esp
  80083c:	57                   	push   %edi
  80083d:	e8 0c 09 00 00       	call   80114e <readline>
  800842:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	85 c0                	test   %eax,%eax
  800849:	0f 84 59 ff ff ff    	je     8007a8 <umain+0x106>
		if (debug)
  80084f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800856:	0f 85 71 ff ff ff    	jne    8007cd <umain+0x12b>
		if (buf[0] == '#')
  80085c:	80 3b 23             	cmpb   $0x23,(%ebx)
  80085f:	74 d8                	je     800839 <umain+0x197>
		if (echocmds)
  800861:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800865:	0f 85 75 ff ff ff    	jne    8007e0 <umain+0x13e>
		if (debug)
  80086b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800872:	0f 85 7b ff ff ff    	jne    8007f3 <umain+0x151>
		if ((r = fork()) < 0)
  800878:	e8 3b 11 00 00       	call   8019b8 <fork>
  80087d:	89 c6                	mov    %eax,%esi
  80087f:	85 c0                	test   %eax,%eax
  800881:	78 82                	js     800805 <umain+0x163>
		if (debug)
  800883:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80088a:	75 8e                	jne    80081a <umain+0x178>
		if (r == 0) {
  80088c:	85 f6                	test   %esi,%esi
  80088e:	75 9d                	jne    80082d <umain+0x18b>
			runcmd(buf);
  800890:	83 ec 0c             	sub    $0xc,%esp
  800893:	53                   	push   %ebx
  800894:	e8 69 f9 ff ff       	call   800202 <runcmd>
			exit();
  800899:	e8 e4 01 00 00       	call   800a82 <exit>
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	eb 96                	jmp    800839 <umain+0x197>

008008a3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8008a3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8008a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ac:	c3                   	ret    

008008ad <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8008ad:	f3 0f 1e fb          	endbr32 
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008b7:	68 c1 36 80 00       	push   $0x8036c1
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	e8 c1 09 00 00       	call   801285 <strcpy>
	return 0;
}
  8008c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c9:	c9                   	leave  
  8008ca:	c3                   	ret    

008008cb <devcons_write>:
{
  8008cb:	f3 0f 1e fb          	endbr32 
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	57                   	push   %edi
  8008d3:	56                   	push   %esi
  8008d4:	53                   	push   %ebx
  8008d5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008db:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008e0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008e6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008e9:	73 31                	jae    80091c <devcons_write+0x51>
		m = n - tot;
  8008eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008ee:	29 f3                	sub    %esi,%ebx
  8008f0:	83 fb 7f             	cmp    $0x7f,%ebx
  8008f3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008f8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008fb:	83 ec 04             	sub    $0x4,%esp
  8008fe:	53                   	push   %ebx
  8008ff:	89 f0                	mov    %esi,%eax
  800901:	03 45 0c             	add    0xc(%ebp),%eax
  800904:	50                   	push   %eax
  800905:	57                   	push   %edi
  800906:	e8 30 0b 00 00       	call   80143b <memmove>
		sys_cputs(buf, m);
  80090b:	83 c4 08             	add    $0x8,%esp
  80090e:	53                   	push   %ebx
  80090f:	57                   	push   %edi
  800910:	e8 e2 0c 00 00       	call   8015f7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800915:	01 de                	add    %ebx,%esi
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	eb ca                	jmp    8008e6 <devcons_write+0x1b>
}
  80091c:	89 f0                	mov    %esi,%eax
  80091e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800921:	5b                   	pop    %ebx
  800922:	5e                   	pop    %esi
  800923:	5f                   	pop    %edi
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <devcons_read>:
{
  800926:	f3 0f 1e fb          	endbr32 
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800935:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800939:	74 21                	je     80095c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80093b:	e8 d9 0c 00 00       	call   801619 <sys_cgetc>
  800940:	85 c0                	test   %eax,%eax
  800942:	75 07                	jne    80094b <devcons_read+0x25>
		sys_yield();
  800944:	e8 5b 0d 00 00       	call   8016a4 <sys_yield>
  800949:	eb f0                	jmp    80093b <devcons_read+0x15>
	if (c < 0)
  80094b:	78 0f                	js     80095c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80094d:	83 f8 04             	cmp    $0x4,%eax
  800950:	74 0c                	je     80095e <devcons_read+0x38>
	*(char*)vbuf = c;
  800952:	8b 55 0c             	mov    0xc(%ebp),%edx
  800955:	88 02                	mov    %al,(%edx)
	return 1;
  800957:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    
		return 0;
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	eb f7                	jmp    80095c <devcons_read+0x36>

00800965 <cputchar>:
{
  800965:	f3 0f 1e fb          	endbr32 
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800975:	6a 01                	push   $0x1
  800977:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80097a:	50                   	push   %eax
  80097b:	e8 77 0c 00 00       	call   8015f7 <sys_cputs>
}
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	c9                   	leave  
  800984:	c3                   	ret    

00800985 <getchar>:
{
  800985:	f3 0f 1e fb          	endbr32 
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80098f:	6a 01                	push   $0x1
  800991:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800994:	50                   	push   %eax
  800995:	6a 00                	push   $0x0
  800997:	e8 9c 16 00 00       	call   802038 <read>
	if (r < 0)
  80099c:	83 c4 10             	add    $0x10,%esp
  80099f:	85 c0                	test   %eax,%eax
  8009a1:	78 06                	js     8009a9 <getchar+0x24>
	if (r < 1)
  8009a3:	74 06                	je     8009ab <getchar+0x26>
	return c;
  8009a5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    
		return -E_EOF;
  8009ab:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8009b0:	eb f7                	jmp    8009a9 <getchar+0x24>

008009b2 <iscons>:
{
  8009b2:	f3 0f 1e fb          	endbr32 
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009bf:	50                   	push   %eax
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 ed 13 00 00       	call   801db5 <fd_lookup>
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	78 11                	js     8009e0 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8009cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d2:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009d8:	39 10                	cmp    %edx,(%eax)
  8009da:	0f 94 c0             	sete   %al
  8009dd:	0f b6 c0             	movzbl %al,%eax
}
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    

008009e2 <opencons>:
{
  8009e2:	f3 0f 1e fb          	endbr32 
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009ef:	50                   	push   %eax
  8009f0:	e8 6a 13 00 00       	call   801d5f <fd_alloc>
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	85 c0                	test   %eax,%eax
  8009fa:	78 3a                	js     800a36 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009fc:	83 ec 04             	sub    $0x4,%esp
  8009ff:	68 07 04 00 00       	push   $0x407
  800a04:	ff 75 f4             	pushl  -0xc(%ebp)
  800a07:	6a 00                	push   $0x0
  800a09:	e8 b9 0c 00 00       	call   8016c7 <sys_page_alloc>
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	85 c0                	test   %eax,%eax
  800a13:	78 21                	js     800a36 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  800a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a18:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800a1e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a23:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a2a:	83 ec 0c             	sub    $0xc,%esp
  800a2d:	50                   	push   %eax
  800a2e:	e8 fd 12 00 00       	call   801d30 <fd2num>
  800a33:	83 c4 10             	add    $0x10,%esp
}
  800a36:	c9                   	leave  
  800a37:	c3                   	ret    

00800a38 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a38:	f3 0f 1e fb          	endbr32 
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	56                   	push   %esi
  800a40:	53                   	push   %ebx
  800a41:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a44:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a47:	e8 35 0c 00 00       	call   801681 <sys_getenvid>
  800a4c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a51:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a54:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a59:	a3 24 54 80 00       	mov    %eax,0x805424

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	7e 07                	jle    800a69 <libmain+0x31>
		binaryname = argv[0];
  800a62:	8b 06                	mov    (%esi),%eax
  800a64:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	56                   	push   %esi
  800a6d:	53                   	push   %ebx
  800a6e:	e8 2f fc ff ff       	call   8006a2 <umain>

	// exit gracefully
	exit();
  800a73:	e8 0a 00 00 00       	call   800a82 <exit>
}
  800a78:	83 c4 10             	add    $0x10,%esp
  800a7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a7e:	5b                   	pop    %ebx
  800a7f:	5e                   	pop    %esi
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a82:	f3 0f 1e fb          	endbr32 
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a8c:	e8 8e 14 00 00       	call   801f1f <close_all>
	sys_env_destroy(0);
  800a91:	83 ec 0c             	sub    $0xc,%esp
  800a94:	6a 00                	push   $0x0
  800a96:	e8 a1 0b 00 00       	call   80163c <sys_env_destroy>
}
  800a9b:	83 c4 10             	add    $0x10,%esp
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800aa0:	f3 0f 1e fb          	endbr32 
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	56                   	push   %esi
  800aa8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800aa9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800aac:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800ab2:	e8 ca 0b 00 00       	call   801681 <sys_getenvid>
  800ab7:	83 ec 0c             	sub    $0xc,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	56                   	push   %esi
  800ac1:	50                   	push   %eax
  800ac2:	68 d8 36 80 00       	push   $0x8036d8
  800ac7:	e8 bb 00 00 00       	call   800b87 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800acc:	83 c4 18             	add    $0x18,%esp
  800acf:	53                   	push   %ebx
  800ad0:	ff 75 10             	pushl  0x10(%ebp)
  800ad3:	e8 5a 00 00 00       	call   800b32 <vcprintf>
	cprintf("\n");
  800ad8:	c7 04 24 e0 34 80 00 	movl   $0x8034e0,(%esp)
  800adf:	e8 a3 00 00 00       	call   800b87 <cprintf>
  800ae4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ae7:	cc                   	int3   
  800ae8:	eb fd                	jmp    800ae7 <_panic+0x47>

00800aea <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800aea:	f3 0f 1e fb          	endbr32 
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	53                   	push   %ebx
  800af2:	83 ec 04             	sub    $0x4,%esp
  800af5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800af8:	8b 13                	mov    (%ebx),%edx
  800afa:	8d 42 01             	lea    0x1(%edx),%eax
  800afd:	89 03                	mov    %eax,(%ebx)
  800aff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b02:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800b06:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0b:	74 09                	je     800b16 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800b0d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b14:	c9                   	leave  
  800b15:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	68 ff 00 00 00       	push   $0xff
  800b1e:	8d 43 08             	lea    0x8(%ebx),%eax
  800b21:	50                   	push   %eax
  800b22:	e8 d0 0a 00 00       	call   8015f7 <sys_cputs>
		b->idx = 0;
  800b27:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	eb db                	jmp    800b0d <putch+0x23>

00800b32 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b32:	f3 0f 1e fb          	endbr32 
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b3f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b46:	00 00 00 
	b.cnt = 0;
  800b49:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b50:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	ff 75 08             	pushl  0x8(%ebp)
  800b59:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b5f:	50                   	push   %eax
  800b60:	68 ea 0a 80 00       	push   $0x800aea
  800b65:	e8 20 01 00 00       	call   800c8a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b6a:	83 c4 08             	add    $0x8,%esp
  800b6d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b73:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b79:	50                   	push   %eax
  800b7a:	e8 78 0a 00 00       	call   8015f7 <sys_cputs>

	return b.cnt;
}
  800b7f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b87:	f3 0f 1e fb          	endbr32 
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b91:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b94:	50                   	push   %eax
  800b95:	ff 75 08             	pushl  0x8(%ebp)
  800b98:	e8 95 ff ff ff       	call   800b32 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	57                   	push   %edi
  800ba3:	56                   	push   %esi
  800ba4:	53                   	push   %ebx
  800ba5:	83 ec 1c             	sub    $0x1c,%esp
  800ba8:	89 c7                	mov    %eax,%edi
  800baa:	89 d6                	mov    %edx,%esi
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb2:	89 d1                	mov    %edx,%ecx
  800bb4:	89 c2                	mov    %eax,%edx
  800bb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bb9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbf:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bc5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800bcc:	39 c2                	cmp    %eax,%edx
  800bce:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800bd1:	72 3e                	jb     800c11 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	ff 75 18             	pushl  0x18(%ebp)
  800bd9:	83 eb 01             	sub    $0x1,%ebx
  800bdc:	53                   	push   %ebx
  800bdd:	50                   	push   %eax
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800be4:	ff 75 e0             	pushl  -0x20(%ebp)
  800be7:	ff 75 dc             	pushl  -0x24(%ebp)
  800bea:	ff 75 d8             	pushl  -0x28(%ebp)
  800bed:	e8 6e 26 00 00       	call   803260 <__udivdi3>
  800bf2:	83 c4 18             	add    $0x18,%esp
  800bf5:	52                   	push   %edx
  800bf6:	50                   	push   %eax
  800bf7:	89 f2                	mov    %esi,%edx
  800bf9:	89 f8                	mov    %edi,%eax
  800bfb:	e8 9f ff ff ff       	call   800b9f <printnum>
  800c00:	83 c4 20             	add    $0x20,%esp
  800c03:	eb 13                	jmp    800c18 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	56                   	push   %esi
  800c09:	ff 75 18             	pushl  0x18(%ebp)
  800c0c:	ff d7                	call   *%edi
  800c0e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800c11:	83 eb 01             	sub    $0x1,%ebx
  800c14:	85 db                	test   %ebx,%ebx
  800c16:	7f ed                	jg     800c05 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c18:	83 ec 08             	sub    $0x8,%esp
  800c1b:	56                   	push   %esi
  800c1c:	83 ec 04             	sub    $0x4,%esp
  800c1f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c22:	ff 75 e0             	pushl  -0x20(%ebp)
  800c25:	ff 75 dc             	pushl  -0x24(%ebp)
  800c28:	ff 75 d8             	pushl  -0x28(%ebp)
  800c2b:	e8 40 27 00 00       	call   803370 <__umoddi3>
  800c30:	83 c4 14             	add    $0x14,%esp
  800c33:	0f be 80 fb 36 80 00 	movsbl 0x8036fb(%eax),%eax
  800c3a:	50                   	push   %eax
  800c3b:	ff d7                	call   *%edi
}
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c48:	f3 0f 1e fb          	endbr32 
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c52:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c56:	8b 10                	mov    (%eax),%edx
  800c58:	3b 50 04             	cmp    0x4(%eax),%edx
  800c5b:	73 0a                	jae    800c67 <sprintputch+0x1f>
		*b->buf++ = ch;
  800c5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c60:	89 08                	mov    %ecx,(%eax)
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	88 02                	mov    %al,(%edx)
}
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <printfmt>:
{
  800c69:	f3 0f 1e fb          	endbr32 
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c73:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c76:	50                   	push   %eax
  800c77:	ff 75 10             	pushl  0x10(%ebp)
  800c7a:	ff 75 0c             	pushl  0xc(%ebp)
  800c7d:	ff 75 08             	pushl  0x8(%ebp)
  800c80:	e8 05 00 00 00       	call   800c8a <vprintfmt>
}
  800c85:	83 c4 10             	add    $0x10,%esp
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <vprintfmt>:
{
  800c8a:	f3 0f 1e fb          	endbr32 
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
  800c94:	83 ec 3c             	sub    $0x3c,%esp
  800c97:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c9d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ca0:	e9 8e 03 00 00       	jmp    801033 <vprintfmt+0x3a9>
		padc = ' ';
  800ca5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800ca9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800cb0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800cb7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cbe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800cc3:	8d 47 01             	lea    0x1(%edi),%eax
  800cc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cc9:	0f b6 17             	movzbl (%edi),%edx
  800ccc:	8d 42 dd             	lea    -0x23(%edx),%eax
  800ccf:	3c 55                	cmp    $0x55,%al
  800cd1:	0f 87 df 03 00 00    	ja     8010b6 <vprintfmt+0x42c>
  800cd7:	0f b6 c0             	movzbl %al,%eax
  800cda:	3e ff 24 85 40 38 80 	notrack jmp *0x803840(,%eax,4)
  800ce1:	00 
  800ce2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800ce5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800ce9:	eb d8                	jmp    800cc3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800ceb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800cee:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800cf2:	eb cf                	jmp    800cc3 <vprintfmt+0x39>
  800cf4:	0f b6 d2             	movzbl %dl,%edx
  800cf7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800cff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800d02:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800d05:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800d09:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800d0c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800d0f:	83 f9 09             	cmp    $0x9,%ecx
  800d12:	77 55                	ja     800d69 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800d14:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800d17:	eb e9                	jmp    800d02 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800d19:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d21:	8b 45 14             	mov    0x14(%ebp),%eax
  800d24:	8d 40 04             	lea    0x4(%eax),%eax
  800d27:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d2a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800d2d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d31:	79 90                	jns    800cc3 <vprintfmt+0x39>
				width = precision, precision = -1;
  800d33:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d36:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d39:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d40:	eb 81                	jmp    800cc3 <vprintfmt+0x39>
  800d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d45:	85 c0                	test   %eax,%eax
  800d47:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4c:	0f 49 d0             	cmovns %eax,%edx
  800d4f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d52:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d55:	e9 69 ff ff ff       	jmp    800cc3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800d5a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d5d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800d64:	e9 5a ff ff ff       	jmp    800cc3 <vprintfmt+0x39>
  800d69:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d6c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d6f:	eb bc                	jmp    800d2d <vprintfmt+0xa3>
			lflag++;
  800d71:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d74:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d77:	e9 47 ff ff ff       	jmp    800cc3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	8d 78 04             	lea    0x4(%eax),%edi
  800d82:	83 ec 08             	sub    $0x8,%esp
  800d85:	53                   	push   %ebx
  800d86:	ff 30                	pushl  (%eax)
  800d88:	ff d6                	call   *%esi
			break;
  800d8a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d8d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d90:	e9 9b 02 00 00       	jmp    801030 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800d95:	8b 45 14             	mov    0x14(%ebp),%eax
  800d98:	8d 78 04             	lea    0x4(%eax),%edi
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	99                   	cltd   
  800d9e:	31 d0                	xor    %edx,%eax
  800da0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800da2:	83 f8 0f             	cmp    $0xf,%eax
  800da5:	7f 23                	jg     800dca <vprintfmt+0x140>
  800da7:	8b 14 85 a0 39 80 00 	mov    0x8039a0(,%eax,4),%edx
  800dae:	85 d2                	test   %edx,%edx
  800db0:	74 18                	je     800dca <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800db2:	52                   	push   %edx
  800db3:	68 19 36 80 00       	push   $0x803619
  800db8:	53                   	push   %ebx
  800db9:	56                   	push   %esi
  800dba:	e8 aa fe ff ff       	call   800c69 <printfmt>
  800dbf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dc2:	89 7d 14             	mov    %edi,0x14(%ebp)
  800dc5:	e9 66 02 00 00       	jmp    801030 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800dca:	50                   	push   %eax
  800dcb:	68 13 37 80 00       	push   $0x803713
  800dd0:	53                   	push   %ebx
  800dd1:	56                   	push   %esi
  800dd2:	e8 92 fe ff ff       	call   800c69 <printfmt>
  800dd7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dda:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800ddd:	e9 4e 02 00 00       	jmp    801030 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800de2:	8b 45 14             	mov    0x14(%ebp),%eax
  800de5:	83 c0 04             	add    $0x4,%eax
  800de8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800deb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dee:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800df0:	85 d2                	test   %edx,%edx
  800df2:	b8 0c 37 80 00       	mov    $0x80370c,%eax
  800df7:	0f 45 c2             	cmovne %edx,%eax
  800dfa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800dfd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e01:	7e 06                	jle    800e09 <vprintfmt+0x17f>
  800e03:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800e07:	75 0d                	jne    800e16 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e0c:	89 c7                	mov    %eax,%edi
  800e0e:	03 45 e0             	add    -0x20(%ebp),%eax
  800e11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e14:	eb 55                	jmp    800e6b <vprintfmt+0x1e1>
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 d8             	pushl  -0x28(%ebp)
  800e1c:	ff 75 cc             	pushl  -0x34(%ebp)
  800e1f:	e8 3a 04 00 00       	call   80125e <strnlen>
  800e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e27:	29 c2                	sub    %eax,%edx
  800e29:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800e31:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800e38:	85 ff                	test   %edi,%edi
  800e3a:	7e 11                	jle    800e4d <vprintfmt+0x1c3>
					putch(padc, putdat);
  800e3c:	83 ec 08             	sub    $0x8,%esp
  800e3f:	53                   	push   %ebx
  800e40:	ff 75 e0             	pushl  -0x20(%ebp)
  800e43:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e45:	83 ef 01             	sub    $0x1,%edi
  800e48:	83 c4 10             	add    $0x10,%esp
  800e4b:	eb eb                	jmp    800e38 <vprintfmt+0x1ae>
  800e4d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800e50:	85 d2                	test   %edx,%edx
  800e52:	b8 00 00 00 00       	mov    $0x0,%eax
  800e57:	0f 49 c2             	cmovns %edx,%eax
  800e5a:	29 c2                	sub    %eax,%edx
  800e5c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800e5f:	eb a8                	jmp    800e09 <vprintfmt+0x17f>
					putch(ch, putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	53                   	push   %ebx
  800e65:	52                   	push   %edx
  800e66:	ff d6                	call   *%esi
  800e68:	83 c4 10             	add    $0x10,%esp
  800e6b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e6e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e70:	83 c7 01             	add    $0x1,%edi
  800e73:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e77:	0f be d0             	movsbl %al,%edx
  800e7a:	85 d2                	test   %edx,%edx
  800e7c:	74 4b                	je     800ec9 <vprintfmt+0x23f>
  800e7e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e82:	78 06                	js     800e8a <vprintfmt+0x200>
  800e84:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800e88:	78 1e                	js     800ea8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800e8a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e8e:	74 d1                	je     800e61 <vprintfmt+0x1d7>
  800e90:	0f be c0             	movsbl %al,%eax
  800e93:	83 e8 20             	sub    $0x20,%eax
  800e96:	83 f8 5e             	cmp    $0x5e,%eax
  800e99:	76 c6                	jbe    800e61 <vprintfmt+0x1d7>
					putch('?', putdat);
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	53                   	push   %ebx
  800e9f:	6a 3f                	push   $0x3f
  800ea1:	ff d6                	call   *%esi
  800ea3:	83 c4 10             	add    $0x10,%esp
  800ea6:	eb c3                	jmp    800e6b <vprintfmt+0x1e1>
  800ea8:	89 cf                	mov    %ecx,%edi
  800eaa:	eb 0e                	jmp    800eba <vprintfmt+0x230>
				putch(' ', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	53                   	push   %ebx
  800eb0:	6a 20                	push   $0x20
  800eb2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800eb4:	83 ef 01             	sub    $0x1,%edi
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	85 ff                	test   %edi,%edi
  800ebc:	7f ee                	jg     800eac <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800ebe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ec1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec4:	e9 67 01 00 00       	jmp    801030 <vprintfmt+0x3a6>
  800ec9:	89 cf                	mov    %ecx,%edi
  800ecb:	eb ed                	jmp    800eba <vprintfmt+0x230>
	if (lflag >= 2)
  800ecd:	83 f9 01             	cmp    $0x1,%ecx
  800ed0:	7f 1b                	jg     800eed <vprintfmt+0x263>
	else if (lflag)
  800ed2:	85 c9                	test   %ecx,%ecx
  800ed4:	74 63                	je     800f39 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	8b 00                	mov    (%eax),%eax
  800edb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ede:	99                   	cltd   
  800edf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee5:	8d 40 04             	lea    0x4(%eax),%eax
  800ee8:	89 45 14             	mov    %eax,0x14(%ebp)
  800eeb:	eb 17                	jmp    800f04 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800eed:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef0:	8b 50 04             	mov    0x4(%eax),%edx
  800ef3:	8b 00                	mov    (%eax),%eax
  800ef5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ef8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800efb:	8b 45 14             	mov    0x14(%ebp),%eax
  800efe:	8d 40 08             	lea    0x8(%eax),%eax
  800f01:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800f04:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f07:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800f0a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800f0f:	85 c9                	test   %ecx,%ecx
  800f11:	0f 89 ff 00 00 00    	jns    801016 <vprintfmt+0x38c>
				putch('-', putdat);
  800f17:	83 ec 08             	sub    $0x8,%esp
  800f1a:	53                   	push   %ebx
  800f1b:	6a 2d                	push   $0x2d
  800f1d:	ff d6                	call   *%esi
				num = -(long long) num;
  800f1f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f22:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800f25:	f7 da                	neg    %edx
  800f27:	83 d1 00             	adc    $0x0,%ecx
  800f2a:	f7 d9                	neg    %ecx
  800f2c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f2f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f34:	e9 dd 00 00 00       	jmp    801016 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800f39:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3c:	8b 00                	mov    (%eax),%eax
  800f3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f41:	99                   	cltd   
  800f42:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	8d 40 04             	lea    0x4(%eax),%eax
  800f4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f4e:	eb b4                	jmp    800f04 <vprintfmt+0x27a>
	if (lflag >= 2)
  800f50:	83 f9 01             	cmp    $0x1,%ecx
  800f53:	7f 1e                	jg     800f73 <vprintfmt+0x2e9>
	else if (lflag)
  800f55:	85 c9                	test   %ecx,%ecx
  800f57:	74 32                	je     800f8b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800f59:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5c:	8b 10                	mov    (%eax),%edx
  800f5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f63:	8d 40 04             	lea    0x4(%eax),%eax
  800f66:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f69:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800f6e:	e9 a3 00 00 00       	jmp    801016 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	8b 10                	mov    (%eax),%edx
  800f78:	8b 48 04             	mov    0x4(%eax),%ecx
  800f7b:	8d 40 08             	lea    0x8(%eax),%eax
  800f7e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f81:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800f86:	e9 8b 00 00 00       	jmp    801016 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800f8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8e:	8b 10                	mov    (%eax),%edx
  800f90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f95:	8d 40 04             	lea    0x4(%eax),%eax
  800f98:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f9b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800fa0:	eb 74                	jmp    801016 <vprintfmt+0x38c>
	if (lflag >= 2)
  800fa2:	83 f9 01             	cmp    $0x1,%ecx
  800fa5:	7f 1b                	jg     800fc2 <vprintfmt+0x338>
	else if (lflag)
  800fa7:	85 c9                	test   %ecx,%ecx
  800fa9:	74 2c                	je     800fd7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800fab:	8b 45 14             	mov    0x14(%ebp),%eax
  800fae:	8b 10                	mov    (%eax),%edx
  800fb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb5:	8d 40 04             	lea    0x4(%eax),%eax
  800fb8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fbb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800fc0:	eb 54                	jmp    801016 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800fc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc5:	8b 10                	mov    (%eax),%edx
  800fc7:	8b 48 04             	mov    0x4(%eax),%ecx
  800fca:	8d 40 08             	lea    0x8(%eax),%eax
  800fcd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fd0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800fd5:	eb 3f                	jmp    801016 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800fd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fda:	8b 10                	mov    (%eax),%edx
  800fdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe1:	8d 40 04             	lea    0x4(%eax),%eax
  800fe4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fe7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800fec:	eb 28                	jmp    801016 <vprintfmt+0x38c>
			putch('0', putdat);
  800fee:	83 ec 08             	sub    $0x8,%esp
  800ff1:	53                   	push   %ebx
  800ff2:	6a 30                	push   $0x30
  800ff4:	ff d6                	call   *%esi
			putch('x', putdat);
  800ff6:	83 c4 08             	add    $0x8,%esp
  800ff9:	53                   	push   %ebx
  800ffa:	6a 78                	push   $0x78
  800ffc:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ffe:	8b 45 14             	mov    0x14(%ebp),%eax
  801001:	8b 10                	mov    (%eax),%edx
  801003:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801008:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80100b:	8d 40 04             	lea    0x4(%eax),%eax
  80100e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801011:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80101d:	57                   	push   %edi
  80101e:	ff 75 e0             	pushl  -0x20(%ebp)
  801021:	50                   	push   %eax
  801022:	51                   	push   %ecx
  801023:	52                   	push   %edx
  801024:	89 da                	mov    %ebx,%edx
  801026:	89 f0                	mov    %esi,%eax
  801028:	e8 72 fb ff ff       	call   800b9f <printnum>
			break;
  80102d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801030:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801033:	83 c7 01             	add    $0x1,%edi
  801036:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80103a:	83 f8 25             	cmp    $0x25,%eax
  80103d:	0f 84 62 fc ff ff    	je     800ca5 <vprintfmt+0x1b>
			if (ch == '\0')
  801043:	85 c0                	test   %eax,%eax
  801045:	0f 84 8b 00 00 00    	je     8010d6 <vprintfmt+0x44c>
			putch(ch, putdat);
  80104b:	83 ec 08             	sub    $0x8,%esp
  80104e:	53                   	push   %ebx
  80104f:	50                   	push   %eax
  801050:	ff d6                	call   *%esi
  801052:	83 c4 10             	add    $0x10,%esp
  801055:	eb dc                	jmp    801033 <vprintfmt+0x3a9>
	if (lflag >= 2)
  801057:	83 f9 01             	cmp    $0x1,%ecx
  80105a:	7f 1b                	jg     801077 <vprintfmt+0x3ed>
	else if (lflag)
  80105c:	85 c9                	test   %ecx,%ecx
  80105e:	74 2c                	je     80108c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801060:	8b 45 14             	mov    0x14(%ebp),%eax
  801063:	8b 10                	mov    (%eax),%edx
  801065:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106a:	8d 40 04             	lea    0x4(%eax),%eax
  80106d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801070:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801075:	eb 9f                	jmp    801016 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801077:	8b 45 14             	mov    0x14(%ebp),%eax
  80107a:	8b 10                	mov    (%eax),%edx
  80107c:	8b 48 04             	mov    0x4(%eax),%ecx
  80107f:	8d 40 08             	lea    0x8(%eax),%eax
  801082:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801085:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80108a:	eb 8a                	jmp    801016 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 10                	mov    (%eax),%edx
  801091:	b9 00 00 00 00       	mov    $0x0,%ecx
  801096:	8d 40 04             	lea    0x4(%eax),%eax
  801099:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80109c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8010a1:	e9 70 ff ff ff       	jmp    801016 <vprintfmt+0x38c>
			putch(ch, putdat);
  8010a6:	83 ec 08             	sub    $0x8,%esp
  8010a9:	53                   	push   %ebx
  8010aa:	6a 25                	push   $0x25
  8010ac:	ff d6                	call   *%esi
			break;
  8010ae:	83 c4 10             	add    $0x10,%esp
  8010b1:	e9 7a ff ff ff       	jmp    801030 <vprintfmt+0x3a6>
			putch('%', putdat);
  8010b6:	83 ec 08             	sub    $0x8,%esp
  8010b9:	53                   	push   %ebx
  8010ba:	6a 25                	push   $0x25
  8010bc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010be:	83 c4 10             	add    $0x10,%esp
  8010c1:	89 f8                	mov    %edi,%eax
  8010c3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010c7:	74 05                	je     8010ce <vprintfmt+0x444>
  8010c9:	83 e8 01             	sub    $0x1,%eax
  8010cc:	eb f5                	jmp    8010c3 <vprintfmt+0x439>
  8010ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010d1:	e9 5a ff ff ff       	jmp    801030 <vprintfmt+0x3a6>
}
  8010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d9:	5b                   	pop    %ebx
  8010da:	5e                   	pop    %esi
  8010db:	5f                   	pop    %edi
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010de:	f3 0f 1e fb          	endbr32 
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 18             	sub    $0x18,%esp
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010ff:	85 c0                	test   %eax,%eax
  801101:	74 26                	je     801129 <vsnprintf+0x4b>
  801103:	85 d2                	test   %edx,%edx
  801105:	7e 22                	jle    801129 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801107:	ff 75 14             	pushl  0x14(%ebp)
  80110a:	ff 75 10             	pushl  0x10(%ebp)
  80110d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801110:	50                   	push   %eax
  801111:	68 48 0c 80 00       	push   $0x800c48
  801116:	e8 6f fb ff ff       	call   800c8a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80111b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80111e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801124:	83 c4 10             	add    $0x10,%esp
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    
		return -E_INVAL;
  801129:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112e:	eb f7                	jmp    801127 <vsnprintf+0x49>

00801130 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801130:	f3 0f 1e fb          	endbr32 
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80113a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80113d:	50                   	push   %eax
  80113e:	ff 75 10             	pushl  0x10(%ebp)
  801141:	ff 75 0c             	pushl  0xc(%ebp)
  801144:	ff 75 08             	pushl  0x8(%ebp)
  801147:	e8 92 ff ff ff       	call   8010de <vsnprintf>
	va_end(ap);

	return rc;
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  80114e:	f3 0f 1e fb          	endbr32 
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	57                   	push   %edi
  801156:	56                   	push   %esi
  801157:	53                   	push   %ebx
  801158:	83 ec 0c             	sub    $0xc,%esp
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80115e:	85 c0                	test   %eax,%eax
  801160:	74 13                	je     801175 <readline+0x27>
		fprintf(1, "%s", prompt);
  801162:	83 ec 04             	sub    $0x4,%esp
  801165:	50                   	push   %eax
  801166:	68 19 36 80 00       	push   $0x803619
  80116b:	6a 01                	push   $0x1
  80116d:	e8 f7 14 00 00       	call   802669 <fprintf>
  801172:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	6a 00                	push   $0x0
  80117a:	e8 33 f8 ff ff       	call   8009b2 <iscons>
  80117f:	89 c7                	mov    %eax,%edi
  801181:	83 c4 10             	add    $0x10,%esp
	i = 0;
  801184:	be 00 00 00 00       	mov    $0x0,%esi
  801189:	eb 57                	jmp    8011e2 <readline+0x94>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  80118b:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801190:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801193:	75 08                	jne    80119d <readline+0x4f>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  801195:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801198:	5b                   	pop    %ebx
  801199:	5e                   	pop    %esi
  80119a:	5f                   	pop    %edi
  80119b:	5d                   	pop    %ebp
  80119c:	c3                   	ret    
				cprintf("read error: %e\n", c);
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	53                   	push   %ebx
  8011a1:	68 ff 39 80 00       	push   $0x8039ff
  8011a6:	e8 dc f9 ff ff       	call   800b87 <cprintf>
  8011ab:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8011ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b3:	eb e0                	jmp    801195 <readline+0x47>
			if (echoing)
  8011b5:	85 ff                	test   %edi,%edi
  8011b7:	75 05                	jne    8011be <readline+0x70>
			i--;
  8011b9:	83 ee 01             	sub    $0x1,%esi
  8011bc:	eb 24                	jmp    8011e2 <readline+0x94>
				cputchar('\b');
  8011be:	83 ec 0c             	sub    $0xc,%esp
  8011c1:	6a 08                	push   $0x8
  8011c3:	e8 9d f7 ff ff       	call   800965 <cputchar>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	eb ec                	jmp    8011b9 <readline+0x6b>
				cputchar(c);
  8011cd:	83 ec 0c             	sub    $0xc,%esp
  8011d0:	53                   	push   %ebx
  8011d1:	e8 8f f7 ff ff       	call   800965 <cputchar>
  8011d6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011d9:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  8011df:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  8011e2:	e8 9e f7 ff ff       	call   800985 <getchar>
  8011e7:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	78 9e                	js     80118b <readline+0x3d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8011ed:	83 f8 08             	cmp    $0x8,%eax
  8011f0:	0f 94 c2             	sete   %dl
  8011f3:	83 f8 7f             	cmp    $0x7f,%eax
  8011f6:	0f 94 c0             	sete   %al
  8011f9:	08 c2                	or     %al,%dl
  8011fb:	74 04                	je     801201 <readline+0xb3>
  8011fd:	85 f6                	test   %esi,%esi
  8011ff:	7f b4                	jg     8011b5 <readline+0x67>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801201:	83 fb 1f             	cmp    $0x1f,%ebx
  801204:	7e 0e                	jle    801214 <readline+0xc6>
  801206:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  80120c:	7f 06                	jg     801214 <readline+0xc6>
			if (echoing)
  80120e:	85 ff                	test   %edi,%edi
  801210:	74 c7                	je     8011d9 <readline+0x8b>
  801212:	eb b9                	jmp    8011cd <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
  801214:	83 fb 0a             	cmp    $0xa,%ebx
  801217:	74 05                	je     80121e <readline+0xd0>
  801219:	83 fb 0d             	cmp    $0xd,%ebx
  80121c:	75 c4                	jne    8011e2 <readline+0x94>
			if (echoing)
  80121e:	85 ff                	test   %edi,%edi
  801220:	75 11                	jne    801233 <readline+0xe5>
			buf[i] = 0;
  801222:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  801229:	b8 20 50 80 00       	mov    $0x805020,%eax
  80122e:	e9 62 ff ff ff       	jmp    801195 <readline+0x47>
				cputchar('\n');
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	6a 0a                	push   $0xa
  801238:	e8 28 f7 ff ff       	call   800965 <cputchar>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	eb e0                	jmp    801222 <readline+0xd4>

00801242 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801242:	f3 0f 1e fb          	endbr32 
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80124c:	b8 00 00 00 00       	mov    $0x0,%eax
  801251:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801255:	74 05                	je     80125c <strlen+0x1a>
		n++;
  801257:	83 c0 01             	add    $0x1,%eax
  80125a:	eb f5                	jmp    801251 <strlen+0xf>
	return n;
}
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80125e:	f3 0f 1e fb          	endbr32 
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801268:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	b8 00 00 00 00       	mov    $0x0,%eax
  801270:	39 d0                	cmp    %edx,%eax
  801272:	74 0d                	je     801281 <strnlen+0x23>
  801274:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801278:	74 05                	je     80127f <strnlen+0x21>
		n++;
  80127a:	83 c0 01             	add    $0x1,%eax
  80127d:	eb f1                	jmp    801270 <strnlen+0x12>
  80127f:	89 c2                	mov    %eax,%edx
	return n;
}
  801281:	89 d0                	mov    %edx,%eax
  801283:	5d                   	pop    %ebp
  801284:	c3                   	ret    

00801285 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801285:	f3 0f 1e fb          	endbr32 
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	53                   	push   %ebx
  80128d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801290:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801293:	b8 00 00 00 00       	mov    $0x0,%eax
  801298:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80129c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80129f:	83 c0 01             	add    $0x1,%eax
  8012a2:	84 d2                	test   %dl,%dl
  8012a4:	75 f2                	jne    801298 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8012a6:	89 c8                	mov    %ecx,%eax
  8012a8:	5b                   	pop    %ebx
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    

008012ab <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012ab:	f3 0f 1e fb          	endbr32 
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	53                   	push   %ebx
  8012b3:	83 ec 10             	sub    $0x10,%esp
  8012b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8012b9:	53                   	push   %ebx
  8012ba:	e8 83 ff ff ff       	call   801242 <strlen>
  8012bf:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	01 d8                	add    %ebx,%eax
  8012c7:	50                   	push   %eax
  8012c8:	e8 b8 ff ff ff       	call   801285 <strcpy>
	return dst;
}
  8012cd:	89 d8                	mov    %ebx,%eax
  8012cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012d4:	f3 0f 1e fb          	endbr32 
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
  8012dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8012e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e3:	89 f3                	mov    %esi,%ebx
  8012e5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012e8:	89 f0                	mov    %esi,%eax
  8012ea:	39 d8                	cmp    %ebx,%eax
  8012ec:	74 11                	je     8012ff <strncpy+0x2b>
		*dst++ = *src;
  8012ee:	83 c0 01             	add    $0x1,%eax
  8012f1:	0f b6 0a             	movzbl (%edx),%ecx
  8012f4:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012f7:	80 f9 01             	cmp    $0x1,%cl
  8012fa:	83 da ff             	sbb    $0xffffffff,%edx
  8012fd:	eb eb                	jmp    8012ea <strncpy+0x16>
	}
	return ret;
}
  8012ff:	89 f0                	mov    %esi,%eax
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    

00801305 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801305:	f3 0f 1e fb          	endbr32 
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	56                   	push   %esi
  80130d:	53                   	push   %ebx
  80130e:	8b 75 08             	mov    0x8(%ebp),%esi
  801311:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801314:	8b 55 10             	mov    0x10(%ebp),%edx
  801317:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801319:	85 d2                	test   %edx,%edx
  80131b:	74 21                	je     80133e <strlcpy+0x39>
  80131d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801321:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801323:	39 c2                	cmp    %eax,%edx
  801325:	74 14                	je     80133b <strlcpy+0x36>
  801327:	0f b6 19             	movzbl (%ecx),%ebx
  80132a:	84 db                	test   %bl,%bl
  80132c:	74 0b                	je     801339 <strlcpy+0x34>
			*dst++ = *src++;
  80132e:	83 c1 01             	add    $0x1,%ecx
  801331:	83 c2 01             	add    $0x1,%edx
  801334:	88 5a ff             	mov    %bl,-0x1(%edx)
  801337:	eb ea                	jmp    801323 <strlcpy+0x1e>
  801339:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80133b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80133e:	29 f0                	sub    %esi,%eax
}
  801340:	5b                   	pop    %ebx
  801341:	5e                   	pop    %esi
  801342:	5d                   	pop    %ebp
  801343:	c3                   	ret    

00801344 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801344:	f3 0f 1e fb          	endbr32 
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801351:	0f b6 01             	movzbl (%ecx),%eax
  801354:	84 c0                	test   %al,%al
  801356:	74 0c                	je     801364 <strcmp+0x20>
  801358:	3a 02                	cmp    (%edx),%al
  80135a:	75 08                	jne    801364 <strcmp+0x20>
		p++, q++;
  80135c:	83 c1 01             	add    $0x1,%ecx
  80135f:	83 c2 01             	add    $0x1,%edx
  801362:	eb ed                	jmp    801351 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	0f b6 12             	movzbl (%edx),%edx
  80136a:	29 d0                	sub    %edx,%eax
}
  80136c:	5d                   	pop    %ebp
  80136d:	c3                   	ret    

0080136e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80136e:	f3 0f 1e fb          	endbr32 
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	53                   	push   %ebx
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137c:	89 c3                	mov    %eax,%ebx
  80137e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801381:	eb 06                	jmp    801389 <strncmp+0x1b>
		n--, p++, q++;
  801383:	83 c0 01             	add    $0x1,%eax
  801386:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801389:	39 d8                	cmp    %ebx,%eax
  80138b:	74 16                	je     8013a3 <strncmp+0x35>
  80138d:	0f b6 08             	movzbl (%eax),%ecx
  801390:	84 c9                	test   %cl,%cl
  801392:	74 04                	je     801398 <strncmp+0x2a>
  801394:	3a 0a                	cmp    (%edx),%cl
  801396:	74 eb                	je     801383 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801398:	0f b6 00             	movzbl (%eax),%eax
  80139b:	0f b6 12             	movzbl (%edx),%edx
  80139e:	29 d0                	sub    %edx,%eax
}
  8013a0:	5b                   	pop    %ebx
  8013a1:	5d                   	pop    %ebp
  8013a2:	c3                   	ret    
		return 0;
  8013a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a8:	eb f6                	jmp    8013a0 <strncmp+0x32>

008013aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013aa:	f3 0f 1e fb          	endbr32 
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013b8:	0f b6 10             	movzbl (%eax),%edx
  8013bb:	84 d2                	test   %dl,%dl
  8013bd:	74 09                	je     8013c8 <strchr+0x1e>
		if (*s == c)
  8013bf:	38 ca                	cmp    %cl,%dl
  8013c1:	74 0a                	je     8013cd <strchr+0x23>
	for (; *s; s++)
  8013c3:	83 c0 01             	add    $0x1,%eax
  8013c6:	eb f0                	jmp    8013b8 <strchr+0xe>
			return (char *) s;
	return 0;
  8013c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    

008013cf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013cf:	f3 0f 1e fb          	endbr32 
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013dd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8013e0:	38 ca                	cmp    %cl,%dl
  8013e2:	74 09                	je     8013ed <strfind+0x1e>
  8013e4:	84 d2                	test   %dl,%dl
  8013e6:	74 05                	je     8013ed <strfind+0x1e>
	for (; *s; s++)
  8013e8:	83 c0 01             	add    $0x1,%eax
  8013eb:	eb f0                	jmp    8013dd <strfind+0xe>
			break;
	return (char *) s;
}
  8013ed:	5d                   	pop    %ebp
  8013ee:	c3                   	ret    

008013ef <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013ef:	f3 0f 1e fb          	endbr32 
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	57                   	push   %edi
  8013f7:	56                   	push   %esi
  8013f8:	53                   	push   %ebx
  8013f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8013ff:	85 c9                	test   %ecx,%ecx
  801401:	74 31                	je     801434 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801403:	89 f8                	mov    %edi,%eax
  801405:	09 c8                	or     %ecx,%eax
  801407:	a8 03                	test   $0x3,%al
  801409:	75 23                	jne    80142e <memset+0x3f>
		c &= 0xFF;
  80140b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80140f:	89 d3                	mov    %edx,%ebx
  801411:	c1 e3 08             	shl    $0x8,%ebx
  801414:	89 d0                	mov    %edx,%eax
  801416:	c1 e0 18             	shl    $0x18,%eax
  801419:	89 d6                	mov    %edx,%esi
  80141b:	c1 e6 10             	shl    $0x10,%esi
  80141e:	09 f0                	or     %esi,%eax
  801420:	09 c2                	or     %eax,%edx
  801422:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801424:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801427:	89 d0                	mov    %edx,%eax
  801429:	fc                   	cld    
  80142a:	f3 ab                	rep stos %eax,%es:(%edi)
  80142c:	eb 06                	jmp    801434 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	fc                   	cld    
  801432:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801434:	89 f8                	mov    %edi,%eax
  801436:	5b                   	pop    %ebx
  801437:	5e                   	pop    %esi
  801438:	5f                   	pop    %edi
  801439:	5d                   	pop    %ebp
  80143a:	c3                   	ret    

0080143b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80143b:	f3 0f 1e fb          	endbr32 
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	57                   	push   %edi
  801443:	56                   	push   %esi
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8b 75 0c             	mov    0xc(%ebp),%esi
  80144a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80144d:	39 c6                	cmp    %eax,%esi
  80144f:	73 32                	jae    801483 <memmove+0x48>
  801451:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801454:	39 c2                	cmp    %eax,%edx
  801456:	76 2b                	jbe    801483 <memmove+0x48>
		s += n;
		d += n;
  801458:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80145b:	89 fe                	mov    %edi,%esi
  80145d:	09 ce                	or     %ecx,%esi
  80145f:	09 d6                	or     %edx,%esi
  801461:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801467:	75 0e                	jne    801477 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801469:	83 ef 04             	sub    $0x4,%edi
  80146c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80146f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801472:	fd                   	std    
  801473:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801475:	eb 09                	jmp    801480 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801477:	83 ef 01             	sub    $0x1,%edi
  80147a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80147d:	fd                   	std    
  80147e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801480:	fc                   	cld    
  801481:	eb 1a                	jmp    80149d <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801483:	89 c2                	mov    %eax,%edx
  801485:	09 ca                	or     %ecx,%edx
  801487:	09 f2                	or     %esi,%edx
  801489:	f6 c2 03             	test   $0x3,%dl
  80148c:	75 0a                	jne    801498 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80148e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801491:	89 c7                	mov    %eax,%edi
  801493:	fc                   	cld    
  801494:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801496:	eb 05                	jmp    80149d <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801498:	89 c7                	mov    %eax,%edi
  80149a:	fc                   	cld    
  80149b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80149d:	5e                   	pop    %esi
  80149e:	5f                   	pop    %edi
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014a1:	f3 0f 1e fb          	endbr32 
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8014ab:	ff 75 10             	pushl  0x10(%ebp)
  8014ae:	ff 75 0c             	pushl  0xc(%ebp)
  8014b1:	ff 75 08             	pushl  0x8(%ebp)
  8014b4:	e8 82 ff ff ff       	call   80143b <memmove>
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014bb:	f3 0f 1e fb          	endbr32 
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	56                   	push   %esi
  8014c3:	53                   	push   %ebx
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	89 c6                	mov    %eax,%esi
  8014cc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014cf:	39 f0                	cmp    %esi,%eax
  8014d1:	74 1c                	je     8014ef <memcmp+0x34>
		if (*s1 != *s2)
  8014d3:	0f b6 08             	movzbl (%eax),%ecx
  8014d6:	0f b6 1a             	movzbl (%edx),%ebx
  8014d9:	38 d9                	cmp    %bl,%cl
  8014db:	75 08                	jne    8014e5 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8014dd:	83 c0 01             	add    $0x1,%eax
  8014e0:	83 c2 01             	add    $0x1,%edx
  8014e3:	eb ea                	jmp    8014cf <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8014e5:	0f b6 c1             	movzbl %cl,%eax
  8014e8:	0f b6 db             	movzbl %bl,%ebx
  8014eb:	29 d8                	sub    %ebx,%eax
  8014ed:	eb 05                	jmp    8014f4 <memcmp+0x39>
	}

	return 0;
  8014ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f4:	5b                   	pop    %ebx
  8014f5:	5e                   	pop    %esi
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014f8:	f3 0f 1e fb          	endbr32 
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801505:	89 c2                	mov    %eax,%edx
  801507:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80150a:	39 d0                	cmp    %edx,%eax
  80150c:	73 09                	jae    801517 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80150e:	38 08                	cmp    %cl,(%eax)
  801510:	74 05                	je     801517 <memfind+0x1f>
	for (; s < ends; s++)
  801512:	83 c0 01             	add    $0x1,%eax
  801515:	eb f3                	jmp    80150a <memfind+0x12>
			break;
	return (void *) s;
}
  801517:	5d                   	pop    %ebp
  801518:	c3                   	ret    

00801519 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801519:	f3 0f 1e fb          	endbr32 
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	57                   	push   %edi
  801521:	56                   	push   %esi
  801522:	53                   	push   %ebx
  801523:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801526:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801529:	eb 03                	jmp    80152e <strtol+0x15>
		s++;
  80152b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80152e:	0f b6 01             	movzbl (%ecx),%eax
  801531:	3c 20                	cmp    $0x20,%al
  801533:	74 f6                	je     80152b <strtol+0x12>
  801535:	3c 09                	cmp    $0x9,%al
  801537:	74 f2                	je     80152b <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801539:	3c 2b                	cmp    $0x2b,%al
  80153b:	74 2a                	je     801567 <strtol+0x4e>
	int neg = 0;
  80153d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801542:	3c 2d                	cmp    $0x2d,%al
  801544:	74 2b                	je     801571 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801546:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80154c:	75 0f                	jne    80155d <strtol+0x44>
  80154e:	80 39 30             	cmpb   $0x30,(%ecx)
  801551:	74 28                	je     80157b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801553:	85 db                	test   %ebx,%ebx
  801555:	b8 0a 00 00 00       	mov    $0xa,%eax
  80155a:	0f 44 d8             	cmove  %eax,%ebx
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
  801562:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801565:	eb 46                	jmp    8015ad <strtol+0x94>
		s++;
  801567:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80156a:	bf 00 00 00 00       	mov    $0x0,%edi
  80156f:	eb d5                	jmp    801546 <strtol+0x2d>
		s++, neg = 1;
  801571:	83 c1 01             	add    $0x1,%ecx
  801574:	bf 01 00 00 00       	mov    $0x1,%edi
  801579:	eb cb                	jmp    801546 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80157b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80157f:	74 0e                	je     80158f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801581:	85 db                	test   %ebx,%ebx
  801583:	75 d8                	jne    80155d <strtol+0x44>
		s++, base = 8;
  801585:	83 c1 01             	add    $0x1,%ecx
  801588:	bb 08 00 00 00       	mov    $0x8,%ebx
  80158d:	eb ce                	jmp    80155d <strtol+0x44>
		s += 2, base = 16;
  80158f:	83 c1 02             	add    $0x2,%ecx
  801592:	bb 10 00 00 00       	mov    $0x10,%ebx
  801597:	eb c4                	jmp    80155d <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801599:	0f be d2             	movsbl %dl,%edx
  80159c:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80159f:	3b 55 10             	cmp    0x10(%ebp),%edx
  8015a2:	7d 3a                	jge    8015de <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8015a4:	83 c1 01             	add    $0x1,%ecx
  8015a7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015ab:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8015ad:	0f b6 11             	movzbl (%ecx),%edx
  8015b0:	8d 72 d0             	lea    -0x30(%edx),%esi
  8015b3:	89 f3                	mov    %esi,%ebx
  8015b5:	80 fb 09             	cmp    $0x9,%bl
  8015b8:	76 df                	jbe    801599 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  8015ba:	8d 72 9f             	lea    -0x61(%edx),%esi
  8015bd:	89 f3                	mov    %esi,%ebx
  8015bf:	80 fb 19             	cmp    $0x19,%bl
  8015c2:	77 08                	ja     8015cc <strtol+0xb3>
			dig = *s - 'a' + 10;
  8015c4:	0f be d2             	movsbl %dl,%edx
  8015c7:	83 ea 57             	sub    $0x57,%edx
  8015ca:	eb d3                	jmp    80159f <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  8015cc:	8d 72 bf             	lea    -0x41(%edx),%esi
  8015cf:	89 f3                	mov    %esi,%ebx
  8015d1:	80 fb 19             	cmp    $0x19,%bl
  8015d4:	77 08                	ja     8015de <strtol+0xc5>
			dig = *s - 'A' + 10;
  8015d6:	0f be d2             	movsbl %dl,%edx
  8015d9:	83 ea 37             	sub    $0x37,%edx
  8015dc:	eb c1                	jmp    80159f <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  8015de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e2:	74 05                	je     8015e9 <strtol+0xd0>
		*endptr = (char *) s;
  8015e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015e7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	f7 da                	neg    %edx
  8015ed:	85 ff                	test   %edi,%edi
  8015ef:	0f 45 c2             	cmovne %edx,%eax
}
  8015f2:	5b                   	pop    %ebx
  8015f3:	5e                   	pop    %esi
  8015f4:	5f                   	pop    %edi
  8015f5:	5d                   	pop    %ebp
  8015f6:	c3                   	ret    

008015f7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8015f7:	f3 0f 1e fb          	endbr32 
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	57                   	push   %edi
  8015ff:	56                   	push   %esi
  801600:	53                   	push   %ebx
	asm volatile("int %1\n"
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
  801606:	8b 55 08             	mov    0x8(%ebp),%edx
  801609:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80160c:	89 c3                	mov    %eax,%ebx
  80160e:	89 c7                	mov    %eax,%edi
  801610:	89 c6                	mov    %eax,%esi
  801612:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801614:	5b                   	pop    %ebx
  801615:	5e                   	pop    %esi
  801616:	5f                   	pop    %edi
  801617:	5d                   	pop    %ebp
  801618:	c3                   	ret    

00801619 <sys_cgetc>:

int
sys_cgetc(void)
{
  801619:	f3 0f 1e fb          	endbr32 
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	57                   	push   %edi
  801621:	56                   	push   %esi
  801622:	53                   	push   %ebx
	asm volatile("int %1\n"
  801623:	ba 00 00 00 00       	mov    $0x0,%edx
  801628:	b8 01 00 00 00       	mov    $0x1,%eax
  80162d:	89 d1                	mov    %edx,%ecx
  80162f:	89 d3                	mov    %edx,%ebx
  801631:	89 d7                	mov    %edx,%edi
  801633:	89 d6                	mov    %edx,%esi
  801635:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801637:	5b                   	pop    %ebx
  801638:	5e                   	pop    %esi
  801639:	5f                   	pop    %edi
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80163c:	f3 0f 1e fb          	endbr32 
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	57                   	push   %edi
  801644:	56                   	push   %esi
  801645:	53                   	push   %ebx
  801646:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801649:	b9 00 00 00 00       	mov    $0x0,%ecx
  80164e:	8b 55 08             	mov    0x8(%ebp),%edx
  801651:	b8 03 00 00 00       	mov    $0x3,%eax
  801656:	89 cb                	mov    %ecx,%ebx
  801658:	89 cf                	mov    %ecx,%edi
  80165a:	89 ce                	mov    %ecx,%esi
  80165c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80165e:	85 c0                	test   %eax,%eax
  801660:	7f 08                	jg     80166a <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801662:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801665:	5b                   	pop    %ebx
  801666:	5e                   	pop    %esi
  801667:	5f                   	pop    %edi
  801668:	5d                   	pop    %ebp
  801669:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80166a:	83 ec 0c             	sub    $0xc,%esp
  80166d:	50                   	push   %eax
  80166e:	6a 03                	push   $0x3
  801670:	68 0f 3a 80 00       	push   $0x803a0f
  801675:	6a 23                	push   $0x23
  801677:	68 2c 3a 80 00       	push   $0x803a2c
  80167c:	e8 1f f4 ff ff       	call   800aa0 <_panic>

00801681 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801681:	f3 0f 1e fb          	endbr32 
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	57                   	push   %edi
  801689:	56                   	push   %esi
  80168a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80168b:	ba 00 00 00 00       	mov    $0x0,%edx
  801690:	b8 02 00 00 00       	mov    $0x2,%eax
  801695:	89 d1                	mov    %edx,%ecx
  801697:	89 d3                	mov    %edx,%ebx
  801699:	89 d7                	mov    %edx,%edi
  80169b:	89 d6                	mov    %edx,%esi
  80169d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80169f:	5b                   	pop    %ebx
  8016a0:	5e                   	pop    %esi
  8016a1:	5f                   	pop    %edi
  8016a2:	5d                   	pop    %ebp
  8016a3:	c3                   	ret    

008016a4 <sys_yield>:

void
sys_yield(void)
{
  8016a4:	f3 0f 1e fb          	endbr32 
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	57                   	push   %edi
  8016ac:	56                   	push   %esi
  8016ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8016b8:	89 d1                	mov    %edx,%ecx
  8016ba:	89 d3                	mov    %edx,%ebx
  8016bc:	89 d7                	mov    %edx,%edi
  8016be:	89 d6                	mov    %edx,%esi
  8016c0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8016c2:	5b                   	pop    %ebx
  8016c3:	5e                   	pop    %esi
  8016c4:	5f                   	pop    %edi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8016c7:	f3 0f 1e fb          	endbr32 
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	57                   	push   %edi
  8016cf:	56                   	push   %esi
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016d4:	be 00 00 00 00       	mov    $0x0,%esi
  8016d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016df:	b8 04 00 00 00       	mov    $0x4,%eax
  8016e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016e7:	89 f7                	mov    %esi,%edi
  8016e9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	7f 08                	jg     8016f7 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8016ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016f7:	83 ec 0c             	sub    $0xc,%esp
  8016fa:	50                   	push   %eax
  8016fb:	6a 04                	push   $0x4
  8016fd:	68 0f 3a 80 00       	push   $0x803a0f
  801702:	6a 23                	push   $0x23
  801704:	68 2c 3a 80 00       	push   $0x803a2c
  801709:	e8 92 f3 ff ff       	call   800aa0 <_panic>

0080170e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80170e:	f3 0f 1e fb          	endbr32 
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	57                   	push   %edi
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
  801718:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80171b:	8b 55 08             	mov    0x8(%ebp),%edx
  80171e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801721:	b8 05 00 00 00       	mov    $0x5,%eax
  801726:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801729:	8b 7d 14             	mov    0x14(%ebp),%edi
  80172c:	8b 75 18             	mov    0x18(%ebp),%esi
  80172f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801731:	85 c0                	test   %eax,%eax
  801733:	7f 08                	jg     80173d <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801735:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5f                   	pop    %edi
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80173d:	83 ec 0c             	sub    $0xc,%esp
  801740:	50                   	push   %eax
  801741:	6a 05                	push   $0x5
  801743:	68 0f 3a 80 00       	push   $0x803a0f
  801748:	6a 23                	push   $0x23
  80174a:	68 2c 3a 80 00       	push   $0x803a2c
  80174f:	e8 4c f3 ff ff       	call   800aa0 <_panic>

00801754 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801754:	f3 0f 1e fb          	endbr32 
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	57                   	push   %edi
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801761:	bb 00 00 00 00       	mov    $0x0,%ebx
  801766:	8b 55 08             	mov    0x8(%ebp),%edx
  801769:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80176c:	b8 06 00 00 00       	mov    $0x6,%eax
  801771:	89 df                	mov    %ebx,%edi
  801773:	89 de                	mov    %ebx,%esi
  801775:	cd 30                	int    $0x30
	if(check && ret > 0)
  801777:	85 c0                	test   %eax,%eax
  801779:	7f 08                	jg     801783 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80177b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177e:	5b                   	pop    %ebx
  80177f:	5e                   	pop    %esi
  801780:	5f                   	pop    %edi
  801781:	5d                   	pop    %ebp
  801782:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801783:	83 ec 0c             	sub    $0xc,%esp
  801786:	50                   	push   %eax
  801787:	6a 06                	push   $0x6
  801789:	68 0f 3a 80 00       	push   $0x803a0f
  80178e:	6a 23                	push   $0x23
  801790:	68 2c 3a 80 00       	push   $0x803a2c
  801795:	e8 06 f3 ff ff       	call   800aa0 <_panic>

0080179a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80179a:	f3 0f 1e fb          	endbr32 
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	57                   	push   %edi
  8017a2:	56                   	push   %esi
  8017a3:	53                   	push   %ebx
  8017a4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8017af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8017b7:	89 df                	mov    %ebx,%edi
  8017b9:	89 de                	mov    %ebx,%esi
  8017bb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	7f 08                	jg     8017c9 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8017c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c4:	5b                   	pop    %ebx
  8017c5:	5e                   	pop    %esi
  8017c6:	5f                   	pop    %edi
  8017c7:	5d                   	pop    %ebp
  8017c8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017c9:	83 ec 0c             	sub    $0xc,%esp
  8017cc:	50                   	push   %eax
  8017cd:	6a 08                	push   $0x8
  8017cf:	68 0f 3a 80 00       	push   $0x803a0f
  8017d4:	6a 23                	push   $0x23
  8017d6:	68 2c 3a 80 00       	push   $0x803a2c
  8017db:	e8 c0 f2 ff ff       	call   800aa0 <_panic>

008017e0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8017e0:	f3 0f 1e fb          	endbr32 
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	57                   	push   %edi
  8017e8:	56                   	push   %esi
  8017e9:	53                   	push   %ebx
  8017ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f8:	b8 09 00 00 00       	mov    $0x9,%eax
  8017fd:	89 df                	mov    %ebx,%edi
  8017ff:	89 de                	mov    %ebx,%esi
  801801:	cd 30                	int    $0x30
	if(check && ret > 0)
  801803:	85 c0                	test   %eax,%eax
  801805:	7f 08                	jg     80180f <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801807:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5f                   	pop    %edi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	50                   	push   %eax
  801813:	6a 09                	push   $0x9
  801815:	68 0f 3a 80 00       	push   $0x803a0f
  80181a:	6a 23                	push   $0x23
  80181c:	68 2c 3a 80 00       	push   $0x803a2c
  801821:	e8 7a f2 ff ff       	call   800aa0 <_panic>

00801826 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801826:	f3 0f 1e fb          	endbr32 
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	57                   	push   %edi
  80182e:	56                   	push   %esi
  80182f:	53                   	push   %ebx
  801830:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801833:	bb 00 00 00 00       	mov    $0x0,%ebx
  801838:	8b 55 08             	mov    0x8(%ebp),%edx
  80183b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80183e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801843:	89 df                	mov    %ebx,%edi
  801845:	89 de                	mov    %ebx,%esi
  801847:	cd 30                	int    $0x30
	if(check && ret > 0)
  801849:	85 c0                	test   %eax,%eax
  80184b:	7f 08                	jg     801855 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80184d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801850:	5b                   	pop    %ebx
  801851:	5e                   	pop    %esi
  801852:	5f                   	pop    %edi
  801853:	5d                   	pop    %ebp
  801854:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801855:	83 ec 0c             	sub    $0xc,%esp
  801858:	50                   	push   %eax
  801859:	6a 0a                	push   $0xa
  80185b:	68 0f 3a 80 00       	push   $0x803a0f
  801860:	6a 23                	push   $0x23
  801862:	68 2c 3a 80 00       	push   $0x803a2c
  801867:	e8 34 f2 ff ff       	call   800aa0 <_panic>

0080186c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80186c:	f3 0f 1e fb          	endbr32 
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	57                   	push   %edi
  801874:	56                   	push   %esi
  801875:	53                   	push   %ebx
	asm volatile("int %1\n"
  801876:	8b 55 08             	mov    0x8(%ebp),%edx
  801879:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80187c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801881:	be 00 00 00 00       	mov    $0x0,%esi
  801886:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801889:	8b 7d 14             	mov    0x14(%ebp),%edi
  80188c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80188e:	5b                   	pop    %ebx
  80188f:	5e                   	pop    %esi
  801890:	5f                   	pop    %edi
  801891:	5d                   	pop    %ebp
  801892:	c3                   	ret    

00801893 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801893:	f3 0f 1e fb          	endbr32 
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	57                   	push   %edi
  80189b:	56                   	push   %esi
  80189c:	53                   	push   %ebx
  80189d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a8:	b8 0d 00 00 00       	mov    $0xd,%eax
  8018ad:	89 cb                	mov    %ecx,%ebx
  8018af:	89 cf                	mov    %ecx,%edi
  8018b1:	89 ce                	mov    %ecx,%esi
  8018b3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	7f 08                	jg     8018c1 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bc:	5b                   	pop    %ebx
  8018bd:	5e                   	pop    %esi
  8018be:	5f                   	pop    %edi
  8018bf:	5d                   	pop    %ebp
  8018c0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018c1:	83 ec 0c             	sub    $0xc,%esp
  8018c4:	50                   	push   %eax
  8018c5:	6a 0d                	push   $0xd
  8018c7:	68 0f 3a 80 00       	push   $0x803a0f
  8018cc:	6a 23                	push   $0x23
  8018ce:	68 2c 3a 80 00       	push   $0x803a2c
  8018d3:	e8 c8 f1 ff ff       	call   800aa0 <_panic>

008018d8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8018d8:	f3 0f 1e fb          	endbr32 
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	53                   	push   %ebx
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8018e6:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  8018e8:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8018ec:	74 74                	je     801962 <pgfault+0x8a>
  8018ee:	89 d8                	mov    %ebx,%eax
  8018f0:	c1 e8 0c             	shr    $0xc,%eax
  8018f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018fa:	f6 c4 08             	test   $0x8,%ah
  8018fd:	74 63                	je     801962 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  8018ff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  801905:	83 ec 0c             	sub    $0xc,%esp
  801908:	6a 05                	push   $0x5
  80190a:	68 00 f0 7f 00       	push   $0x7ff000
  80190f:	6a 00                	push   $0x0
  801911:	53                   	push   %ebx
  801912:	6a 00                	push   $0x0
  801914:	e8 f5 fd ff ff       	call   80170e <sys_page_map>
  801919:	83 c4 20             	add    $0x20,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 59                	js     801979 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	6a 07                	push   $0x7
  801925:	53                   	push   %ebx
  801926:	6a 00                	push   $0x0
  801928:	e8 9a fd ff ff       	call   8016c7 <sys_page_alloc>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 5a                	js     80198e <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  801934:	83 ec 04             	sub    $0x4,%esp
  801937:	68 00 10 00 00       	push   $0x1000
  80193c:	68 00 f0 7f 00       	push   $0x7ff000
  801941:	53                   	push   %ebx
  801942:	e8 f4 fa ff ff       	call   80143b <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  801947:	83 c4 08             	add    $0x8,%esp
  80194a:	68 00 f0 7f 00       	push   $0x7ff000
  80194f:	6a 00                	push   $0x0
  801951:	e8 fe fd ff ff       	call   801754 <sys_page_unmap>
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	78 46                	js     8019a3 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  80195d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801960:	c9                   	leave  
  801961:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	68 3a 3a 80 00       	push   $0x803a3a
  80196a:	68 d3 00 00 00       	push   $0xd3
  80196f:	68 56 3a 80 00       	push   $0x803a56
  801974:	e8 27 f1 ff ff       	call   800aa0 <_panic>
		panic("pgfault: %e\n", r);
  801979:	50                   	push   %eax
  80197a:	68 61 3a 80 00       	push   $0x803a61
  80197f:	68 df 00 00 00       	push   $0xdf
  801984:	68 56 3a 80 00       	push   $0x803a56
  801989:	e8 12 f1 ff ff       	call   800aa0 <_panic>
		panic("pgfault: %e\n", r);
  80198e:	50                   	push   %eax
  80198f:	68 61 3a 80 00       	push   $0x803a61
  801994:	68 e3 00 00 00       	push   $0xe3
  801999:	68 56 3a 80 00       	push   $0x803a56
  80199e:	e8 fd f0 ff ff       	call   800aa0 <_panic>
		panic("pgfault: %e\n", r);
  8019a3:	50                   	push   %eax
  8019a4:	68 61 3a 80 00       	push   $0x803a61
  8019a9:	68 e9 00 00 00       	push   $0xe9
  8019ae:	68 56 3a 80 00       	push   $0x803a56
  8019b3:	e8 e8 f0 ff ff       	call   800aa0 <_panic>

008019b8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8019b8:	f3 0f 1e fb          	endbr32 
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	57                   	push   %edi
  8019c0:	56                   	push   %esi
  8019c1:	53                   	push   %ebx
  8019c2:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  8019c5:	68 d8 18 80 00       	push   $0x8018d8
  8019ca:	e8 96 16 00 00       	call   803065 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8019cf:	b8 07 00 00 00       	mov    $0x7,%eax
  8019d4:	cd 30                	int    $0x30
  8019d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	78 2d                	js     801a0d <fork+0x55>
  8019e0:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8019e2:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8019e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019eb:	0f 85 9b 00 00 00    	jne    801a8c <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  8019f1:	e8 8b fc ff ff       	call   801681 <sys_getenvid>
  8019f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8019fb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8019fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a03:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801a08:	e9 71 01 00 00       	jmp    801b7e <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  801a0d:	50                   	push   %eax
  801a0e:	68 6e 3a 80 00       	push   $0x803a6e
  801a13:	68 2a 01 00 00       	push   $0x12a
  801a18:	68 56 3a 80 00       	push   $0x803a56
  801a1d:	e8 7e f0 ff ff       	call   800aa0 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801a22:	c1 e6 0c             	shl    $0xc,%esi
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	68 07 0e 00 00       	push   $0xe07
  801a2d:	56                   	push   %esi
  801a2e:	57                   	push   %edi
  801a2f:	56                   	push   %esi
  801a30:	6a 00                	push   $0x0
  801a32:	e8 d7 fc ff ff       	call   80170e <sys_page_map>
  801a37:	83 c4 20             	add    $0x20,%esp
  801a3a:	eb 3e                	jmp    801a7a <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801a3c:	c1 e6 0c             	shl    $0xc,%esi
  801a3f:	83 ec 0c             	sub    $0xc,%esp
  801a42:	68 05 08 00 00       	push   $0x805
  801a47:	56                   	push   %esi
  801a48:	57                   	push   %edi
  801a49:	56                   	push   %esi
  801a4a:	6a 00                	push   $0x0
  801a4c:	e8 bd fc ff ff       	call   80170e <sys_page_map>
  801a51:	83 c4 20             	add    $0x20,%esp
  801a54:	85 c0                	test   %eax,%eax
  801a56:	0f 88 bc 00 00 00    	js     801b18 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801a5c:	83 ec 0c             	sub    $0xc,%esp
  801a5f:	68 05 08 00 00       	push   $0x805
  801a64:	56                   	push   %esi
  801a65:	6a 00                	push   $0x0
  801a67:	56                   	push   %esi
  801a68:	6a 00                	push   $0x0
  801a6a:	e8 9f fc ff ff       	call   80170e <sys_page_map>
  801a6f:	83 c4 20             	add    $0x20,%esp
  801a72:	85 c0                	test   %eax,%eax
  801a74:	0f 88 b3 00 00 00    	js     801b2d <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801a7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a80:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801a86:	0f 84 b6 00 00 00    	je     801b42 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	c1 e8 16             	shr    $0x16,%eax
  801a91:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a98:	a8 01                	test   $0x1,%al
  801a9a:	74 de                	je     801a7a <fork+0xc2>
  801a9c:	89 de                	mov    %ebx,%esi
  801a9e:	c1 ee 0c             	shr    $0xc,%esi
  801aa1:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801aa8:	a8 01                	test   $0x1,%al
  801aaa:	74 ce                	je     801a7a <fork+0xc2>
  801aac:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801ab3:	a8 04                	test   $0x4,%al
  801ab5:	74 c3                	je     801a7a <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801ab7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801abe:	f6 c4 04             	test   $0x4,%ah
  801ac1:	0f 85 5b ff ff ff    	jne    801a22 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801ac7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801ace:	a8 02                	test   $0x2,%al
  801ad0:	0f 85 66 ff ff ff    	jne    801a3c <fork+0x84>
  801ad6:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801add:	f6 c4 08             	test   $0x8,%ah
  801ae0:	0f 85 56 ff ff ff    	jne    801a3c <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801ae6:	c1 e6 0c             	shl    $0xc,%esi
  801ae9:	83 ec 0c             	sub    $0xc,%esp
  801aec:	6a 05                	push   $0x5
  801aee:	56                   	push   %esi
  801aef:	57                   	push   %edi
  801af0:	56                   	push   %esi
  801af1:	6a 00                	push   $0x0
  801af3:	e8 16 fc ff ff       	call   80170e <sys_page_map>
  801af8:	83 c4 20             	add    $0x20,%esp
  801afb:	85 c0                	test   %eax,%eax
  801afd:	0f 89 77 ff ff ff    	jns    801a7a <fork+0xc2>
		panic("duppage: %e\n", r);
  801b03:	50                   	push   %eax
  801b04:	68 7e 3a 80 00       	push   $0x803a7e
  801b09:	68 0c 01 00 00       	push   $0x10c
  801b0e:	68 56 3a 80 00       	push   $0x803a56
  801b13:	e8 88 ef ff ff       	call   800aa0 <_panic>
			panic("duppage: %e\n", r);
  801b18:	50                   	push   %eax
  801b19:	68 7e 3a 80 00       	push   $0x803a7e
  801b1e:	68 05 01 00 00       	push   $0x105
  801b23:	68 56 3a 80 00       	push   $0x803a56
  801b28:	e8 73 ef ff ff       	call   800aa0 <_panic>
			panic("duppage: %e\n", r);
  801b2d:	50                   	push   %eax
  801b2e:	68 7e 3a 80 00       	push   $0x803a7e
  801b33:	68 09 01 00 00       	push   $0x109
  801b38:	68 56 3a 80 00       	push   $0x803a56
  801b3d:	e8 5e ef ff ff       	call   800aa0 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	6a 07                	push   $0x7
  801b47:	68 00 f0 bf ee       	push   $0xeebff000
  801b4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b4f:	e8 73 fb ff ff       	call   8016c7 <sys_page_alloc>
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	85 c0                	test   %eax,%eax
  801b59:	78 2e                	js     801b89 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801b5b:	83 ec 08             	sub    $0x8,%esp
  801b5e:	68 d8 30 80 00       	push   $0x8030d8
  801b63:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801b66:	57                   	push   %edi
  801b67:	e8 ba fc ff ff       	call   801826 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801b6c:	83 c4 08             	add    $0x8,%esp
  801b6f:	6a 02                	push   $0x2
  801b71:	57                   	push   %edi
  801b72:	e8 23 fc ff ff       	call   80179a <sys_env_set_status>
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 20                	js     801b9e <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b84:	5b                   	pop    %ebx
  801b85:	5e                   	pop    %esi
  801b86:	5f                   	pop    %edi
  801b87:	5d                   	pop    %ebp
  801b88:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801b89:	50                   	push   %eax
  801b8a:	68 8b 3a 80 00       	push   $0x803a8b
  801b8f:	68 3e 01 00 00       	push   $0x13e
  801b94:	68 56 3a 80 00       	push   $0x803a56
  801b99:	e8 02 ef ff ff       	call   800aa0 <_panic>
		panic("sys_env_set_status: %e", r);
  801b9e:	50                   	push   %eax
  801b9f:	68 9e 3a 80 00       	push   $0x803a9e
  801ba4:	68 43 01 00 00       	push   $0x143
  801ba9:	68 56 3a 80 00       	push   $0x803a56
  801bae:	e8 ed ee ff ff       	call   800aa0 <_panic>

00801bb3 <sfork>:

// Challenge!
int
sfork(void)
{
  801bb3:	f3 0f 1e fb          	endbr32 
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801bbd:	68 b5 3a 80 00       	push   $0x803ab5
  801bc2:	68 4c 01 00 00       	push   $0x14c
  801bc7:	68 56 3a 80 00       	push   $0x803a56
  801bcc:	e8 cf ee ff ff       	call   800aa0 <_panic>

00801bd1 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801bd1:	f3 0f 1e fb          	endbr32 
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bde:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801be1:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801be3:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801be6:	83 3a 01             	cmpl   $0x1,(%edx)
  801be9:	7e 09                	jle    801bf4 <argstart+0x23>
  801beb:	ba e1 34 80 00       	mov    $0x8034e1,%edx
  801bf0:	85 c9                	test   %ecx,%ecx
  801bf2:	75 05                	jne    801bf9 <argstart+0x28>
  801bf4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf9:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801bfc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    

00801c05 <argnext>:

int
argnext(struct Argstate *args)
{
  801c05:	f3 0f 1e fb          	endbr32 
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	53                   	push   %ebx
  801c0d:	83 ec 04             	sub    $0x4,%esp
  801c10:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801c13:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c1a:	8b 43 08             	mov    0x8(%ebx),%eax
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	74 74                	je     801c95 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  801c21:	80 38 00             	cmpb   $0x0,(%eax)
  801c24:	75 48                	jne    801c6e <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c26:	8b 0b                	mov    (%ebx),%ecx
  801c28:	83 39 01             	cmpl   $0x1,(%ecx)
  801c2b:	74 5a                	je     801c87 <argnext+0x82>
		    || args->argv[1][0] != '-'
  801c2d:	8b 53 04             	mov    0x4(%ebx),%edx
  801c30:	8b 42 04             	mov    0x4(%edx),%eax
  801c33:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c36:	75 4f                	jne    801c87 <argnext+0x82>
		    || args->argv[1][1] == '\0')
  801c38:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801c3c:	74 49                	je     801c87 <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801c3e:	83 c0 01             	add    $0x1,%eax
  801c41:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	8b 01                	mov    (%ecx),%eax
  801c49:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801c50:	50                   	push   %eax
  801c51:	8d 42 08             	lea    0x8(%edx),%eax
  801c54:	50                   	push   %eax
  801c55:	83 c2 04             	add    $0x4,%edx
  801c58:	52                   	push   %edx
  801c59:	e8 dd f7 ff ff       	call   80143b <memmove>
		(*args->argc)--;
  801c5e:	8b 03                	mov    (%ebx),%eax
  801c60:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c63:	8b 43 08             	mov    0x8(%ebx),%eax
  801c66:	83 c4 10             	add    $0x10,%esp
  801c69:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c6c:	74 13                	je     801c81 <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801c6e:	8b 43 08             	mov    0x8(%ebx),%eax
  801c71:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  801c74:	83 c0 01             	add    $0x1,%eax
  801c77:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801c7a:	89 d0                	mov    %edx,%eax
  801c7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c81:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801c85:	75 e7                	jne    801c6e <argnext+0x69>
	args->curarg = 0;
  801c87:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801c8e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801c93:	eb e5                	jmp    801c7a <argnext+0x75>
		return -1;
  801c95:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801c9a:	eb de                	jmp    801c7a <argnext+0x75>

00801c9c <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801c9c:	f3 0f 1e fb          	endbr32 
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 04             	sub    $0x4,%esp
  801ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801caa:	8b 43 08             	mov    0x8(%ebx),%eax
  801cad:	85 c0                	test   %eax,%eax
  801caf:	74 12                	je     801cc3 <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  801cb1:	80 38 00             	cmpb   $0x0,(%eax)
  801cb4:	74 12                	je     801cc8 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  801cb6:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801cb9:	c7 43 08 e1 34 80 00 	movl   $0x8034e1,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801cc0:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    
	} else if (*args->argc > 1) {
  801cc8:	8b 13                	mov    (%ebx),%edx
  801cca:	83 3a 01             	cmpl   $0x1,(%edx)
  801ccd:	7f 10                	jg     801cdf <argnextvalue+0x43>
		args->argvalue = 0;
  801ccf:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801cd6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801cdd:	eb e1                	jmp    801cc0 <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  801cdf:	8b 43 04             	mov    0x4(%ebx),%eax
  801ce2:	8b 48 04             	mov    0x4(%eax),%ecx
  801ce5:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 12                	mov    (%edx),%edx
  801ced:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801cf4:	52                   	push   %edx
  801cf5:	8d 50 08             	lea    0x8(%eax),%edx
  801cf8:	52                   	push   %edx
  801cf9:	83 c0 04             	add    $0x4,%eax
  801cfc:	50                   	push   %eax
  801cfd:	e8 39 f7 ff ff       	call   80143b <memmove>
		(*args->argc)--;
  801d02:	8b 03                	mov    (%ebx),%eax
  801d04:	83 28 01             	subl   $0x1,(%eax)
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	eb b4                	jmp    801cc0 <argnextvalue+0x24>

00801d0c <argvalue>:
{
  801d0c:	f3 0f 1e fb          	endbr32 
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 08             	sub    $0x8,%esp
  801d16:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d19:	8b 42 0c             	mov    0xc(%edx),%eax
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	74 02                	je     801d22 <argvalue+0x16>
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	52                   	push   %edx
  801d26:	e8 71 ff ff ff       	call   801c9c <argnextvalue>
  801d2b:	83 c4 10             	add    $0x10,%esp
  801d2e:	eb f0                	jmp    801d20 <argvalue+0x14>

00801d30 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801d30:	f3 0f 1e fb          	endbr32 
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	05 00 00 00 30       	add    $0x30000000,%eax
  801d3f:	c1 e8 0c             	shr    $0xc,%eax
}
  801d42:	5d                   	pop    %ebp
  801d43:	c3                   	ret    

00801d44 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d44:	f3 0f 1e fb          	endbr32 
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801d53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d58:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801d5d:	5d                   	pop    %ebp
  801d5e:	c3                   	ret    

00801d5f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d5f:	f3 0f 1e fb          	endbr32 
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d6b:	89 c2                	mov    %eax,%edx
  801d6d:	c1 ea 16             	shr    $0x16,%edx
  801d70:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801d77:	f6 c2 01             	test   $0x1,%dl
  801d7a:	74 2d                	je     801da9 <fd_alloc+0x4a>
  801d7c:	89 c2                	mov    %eax,%edx
  801d7e:	c1 ea 0c             	shr    $0xc,%edx
  801d81:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d88:	f6 c2 01             	test   $0x1,%dl
  801d8b:	74 1c                	je     801da9 <fd_alloc+0x4a>
  801d8d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801d92:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801d97:	75 d2                	jne    801d6b <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801da2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801da7:	eb 0a                	jmp    801db3 <fd_alloc+0x54>
			*fd_store = fd;
  801da9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dac:	89 01                	mov    %eax,(%ecx)
			return 0;
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    

00801db5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801db5:	f3 0f 1e fb          	endbr32 
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801dbf:	83 f8 1f             	cmp    $0x1f,%eax
  801dc2:	77 30                	ja     801df4 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801dc4:	c1 e0 0c             	shl    $0xc,%eax
  801dc7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801dcc:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801dd2:	f6 c2 01             	test   $0x1,%dl
  801dd5:	74 24                	je     801dfb <fd_lookup+0x46>
  801dd7:	89 c2                	mov    %eax,%edx
  801dd9:	c1 ea 0c             	shr    $0xc,%edx
  801ddc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801de3:	f6 c2 01             	test   $0x1,%dl
  801de6:	74 1a                	je     801e02 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801deb:	89 02                	mov    %eax,(%edx)
	return 0;
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    
		return -E_INVAL;
  801df4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801df9:	eb f7                	jmp    801df2 <fd_lookup+0x3d>
		return -E_INVAL;
  801dfb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e00:	eb f0                	jmp    801df2 <fd_lookup+0x3d>
  801e02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e07:	eb e9                	jmp    801df2 <fd_lookup+0x3d>

00801e09 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e09:	f3 0f 1e fb          	endbr32 
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 08             	sub    $0x8,%esp
  801e13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e16:	ba 48 3b 80 00       	mov    $0x803b48,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801e1b:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801e20:	39 08                	cmp    %ecx,(%eax)
  801e22:	74 33                	je     801e57 <dev_lookup+0x4e>
  801e24:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801e27:	8b 02                	mov    (%edx),%eax
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	75 f3                	jne    801e20 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e2d:	a1 24 54 80 00       	mov    0x805424,%eax
  801e32:	8b 40 48             	mov    0x48(%eax),%eax
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	51                   	push   %ecx
  801e39:	50                   	push   %eax
  801e3a:	68 cc 3a 80 00       	push   $0x803acc
  801e3f:	e8 43 ed ff ff       	call   800b87 <cprintf>
	*dev = 0;
  801e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    
			*dev = devtab[i];
  801e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e5a:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	eb f2                	jmp    801e55 <dev_lookup+0x4c>

00801e63 <fd_close>:
{
  801e63:	f3 0f 1e fb          	endbr32 
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	57                   	push   %edi
  801e6b:	56                   	push   %esi
  801e6c:	53                   	push   %ebx
  801e6d:	83 ec 24             	sub    $0x24,%esp
  801e70:	8b 75 08             	mov    0x8(%ebp),%esi
  801e73:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e79:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e7a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801e80:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e83:	50                   	push   %eax
  801e84:	e8 2c ff ff ff       	call   801db5 <fd_lookup>
  801e89:	89 c3                	mov    %eax,%ebx
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	78 05                	js     801e97 <fd_close+0x34>
	    || fd != fd2)
  801e92:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801e95:	74 16                	je     801ead <fd_close+0x4a>
		return (must_exist ? r : 0);
  801e97:	89 f8                	mov    %edi,%eax
  801e99:	84 c0                	test   %al,%al
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea0:	0f 44 d8             	cmove  %eax,%ebx
}
  801ea3:	89 d8                	mov    %ebx,%eax
  801ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea8:	5b                   	pop    %ebx
  801ea9:	5e                   	pop    %esi
  801eaa:	5f                   	pop    %edi
  801eab:	5d                   	pop    %ebp
  801eac:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ead:	83 ec 08             	sub    $0x8,%esp
  801eb0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801eb3:	50                   	push   %eax
  801eb4:	ff 36                	pushl  (%esi)
  801eb6:	e8 4e ff ff ff       	call   801e09 <dev_lookup>
  801ebb:	89 c3                	mov    %eax,%ebx
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	78 1a                	js     801ede <fd_close+0x7b>
		if (dev->dev_close)
  801ec4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801eca:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	74 0b                	je     801ede <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	56                   	push   %esi
  801ed7:	ff d0                	call   *%eax
  801ed9:	89 c3                	mov    %eax,%ebx
  801edb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801ede:	83 ec 08             	sub    $0x8,%esp
  801ee1:	56                   	push   %esi
  801ee2:	6a 00                	push   $0x0
  801ee4:	e8 6b f8 ff ff       	call   801754 <sys_page_unmap>
	return r;
  801ee9:	83 c4 10             	add    $0x10,%esp
  801eec:	eb b5                	jmp    801ea3 <fd_close+0x40>

00801eee <close>:

int
close(int fdnum)
{
  801eee:	f3 0f 1e fb          	endbr32 
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ef8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801efb:	50                   	push   %eax
  801efc:	ff 75 08             	pushl  0x8(%ebp)
  801eff:	e8 b1 fe ff ff       	call   801db5 <fd_lookup>
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	85 c0                	test   %eax,%eax
  801f09:	79 02                	jns    801f0d <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    
		return fd_close(fd, 1);
  801f0d:	83 ec 08             	sub    $0x8,%esp
  801f10:	6a 01                	push   $0x1
  801f12:	ff 75 f4             	pushl  -0xc(%ebp)
  801f15:	e8 49 ff ff ff       	call   801e63 <fd_close>
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	eb ec                	jmp    801f0b <close+0x1d>

00801f1f <close_all>:

void
close_all(void)
{
  801f1f:	f3 0f 1e fb          	endbr32 
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	53                   	push   %ebx
  801f27:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f2a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801f2f:	83 ec 0c             	sub    $0xc,%esp
  801f32:	53                   	push   %ebx
  801f33:	e8 b6 ff ff ff       	call   801eee <close>
	for (i = 0; i < MAXFD; i++)
  801f38:	83 c3 01             	add    $0x1,%ebx
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	83 fb 20             	cmp    $0x20,%ebx
  801f41:	75 ec                	jne    801f2f <close_all+0x10>
}
  801f43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f48:	f3 0f 1e fb          	endbr32 
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	57                   	push   %edi
  801f50:	56                   	push   %esi
  801f51:	53                   	push   %ebx
  801f52:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f55:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f58:	50                   	push   %eax
  801f59:	ff 75 08             	pushl  0x8(%ebp)
  801f5c:	e8 54 fe ff ff       	call   801db5 <fd_lookup>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	85 c0                	test   %eax,%eax
  801f68:	0f 88 81 00 00 00    	js     801fef <dup+0xa7>
		return r;
	close(newfdnum);
  801f6e:	83 ec 0c             	sub    $0xc,%esp
  801f71:	ff 75 0c             	pushl  0xc(%ebp)
  801f74:	e8 75 ff ff ff       	call   801eee <close>

	newfd = INDEX2FD(newfdnum);
  801f79:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f7c:	c1 e6 0c             	shl    $0xc,%esi
  801f7f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801f85:	83 c4 04             	add    $0x4,%esp
  801f88:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f8b:	e8 b4 fd ff ff       	call   801d44 <fd2data>
  801f90:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801f92:	89 34 24             	mov    %esi,(%esp)
  801f95:	e8 aa fd ff ff       	call   801d44 <fd2data>
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f9f:	89 d8                	mov    %ebx,%eax
  801fa1:	c1 e8 16             	shr    $0x16,%eax
  801fa4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801fab:	a8 01                	test   $0x1,%al
  801fad:	74 11                	je     801fc0 <dup+0x78>
  801faf:	89 d8                	mov    %ebx,%eax
  801fb1:	c1 e8 0c             	shr    $0xc,%eax
  801fb4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801fbb:	f6 c2 01             	test   $0x1,%dl
  801fbe:	75 39                	jne    801ff9 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fc3:	89 d0                	mov    %edx,%eax
  801fc5:	c1 e8 0c             	shr    $0xc,%eax
  801fc8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	25 07 0e 00 00       	and    $0xe07,%eax
  801fd7:	50                   	push   %eax
  801fd8:	56                   	push   %esi
  801fd9:	6a 00                	push   $0x0
  801fdb:	52                   	push   %edx
  801fdc:	6a 00                	push   $0x0
  801fde:	e8 2b f7 ff ff       	call   80170e <sys_page_map>
  801fe3:	89 c3                	mov    %eax,%ebx
  801fe5:	83 c4 20             	add    $0x20,%esp
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	78 31                	js     80201d <dup+0xd5>
		goto err;

	return newfdnum;
  801fec:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801fef:	89 d8                	mov    %ebx,%eax
  801ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff4:	5b                   	pop    %ebx
  801ff5:	5e                   	pop    %esi
  801ff6:	5f                   	pop    %edi
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ff9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	25 07 0e 00 00       	and    $0xe07,%eax
  802008:	50                   	push   %eax
  802009:	57                   	push   %edi
  80200a:	6a 00                	push   $0x0
  80200c:	53                   	push   %ebx
  80200d:	6a 00                	push   $0x0
  80200f:	e8 fa f6 ff ff       	call   80170e <sys_page_map>
  802014:	89 c3                	mov    %eax,%ebx
  802016:	83 c4 20             	add    $0x20,%esp
  802019:	85 c0                	test   %eax,%eax
  80201b:	79 a3                	jns    801fc0 <dup+0x78>
	sys_page_unmap(0, newfd);
  80201d:	83 ec 08             	sub    $0x8,%esp
  802020:	56                   	push   %esi
  802021:	6a 00                	push   $0x0
  802023:	e8 2c f7 ff ff       	call   801754 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802028:	83 c4 08             	add    $0x8,%esp
  80202b:	57                   	push   %edi
  80202c:	6a 00                	push   $0x0
  80202e:	e8 21 f7 ff ff       	call   801754 <sys_page_unmap>
	return r;
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	eb b7                	jmp    801fef <dup+0xa7>

00802038 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802038:	f3 0f 1e fb          	endbr32 
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	53                   	push   %ebx
  802040:	83 ec 1c             	sub    $0x1c,%esp
  802043:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802046:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802049:	50                   	push   %eax
  80204a:	53                   	push   %ebx
  80204b:	e8 65 fd ff ff       	call   801db5 <fd_lookup>
  802050:	83 c4 10             	add    $0x10,%esp
  802053:	85 c0                	test   %eax,%eax
  802055:	78 3f                	js     802096 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802057:	83 ec 08             	sub    $0x8,%esp
  80205a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205d:	50                   	push   %eax
  80205e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802061:	ff 30                	pushl  (%eax)
  802063:	e8 a1 fd ff ff       	call   801e09 <dev_lookup>
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	85 c0                	test   %eax,%eax
  80206d:	78 27                	js     802096 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80206f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802072:	8b 42 08             	mov    0x8(%edx),%eax
  802075:	83 e0 03             	and    $0x3,%eax
  802078:	83 f8 01             	cmp    $0x1,%eax
  80207b:	74 1e                	je     80209b <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80207d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802080:	8b 40 08             	mov    0x8(%eax),%eax
  802083:	85 c0                	test   %eax,%eax
  802085:	74 35                	je     8020bc <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	ff 75 10             	pushl  0x10(%ebp)
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	52                   	push   %edx
  802091:	ff d0                	call   *%eax
  802093:	83 c4 10             	add    $0x10,%esp
}
  802096:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802099:	c9                   	leave  
  80209a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80209b:	a1 24 54 80 00       	mov    0x805424,%eax
  8020a0:	8b 40 48             	mov    0x48(%eax),%eax
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	53                   	push   %ebx
  8020a7:	50                   	push   %eax
  8020a8:	68 0d 3b 80 00       	push   $0x803b0d
  8020ad:	e8 d5 ea ff ff       	call   800b87 <cprintf>
		return -E_INVAL;
  8020b2:	83 c4 10             	add    $0x10,%esp
  8020b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020ba:	eb da                	jmp    802096 <read+0x5e>
		return -E_NOT_SUPP;
  8020bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020c1:	eb d3                	jmp    802096 <read+0x5e>

008020c3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8020c3:	f3 0f 1e fb          	endbr32 
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	57                   	push   %edi
  8020cb:	56                   	push   %esi
  8020cc:	53                   	push   %ebx
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020db:	eb 02                	jmp    8020df <readn+0x1c>
  8020dd:	01 c3                	add    %eax,%ebx
  8020df:	39 f3                	cmp    %esi,%ebx
  8020e1:	73 21                	jae    802104 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020e3:	83 ec 04             	sub    $0x4,%esp
  8020e6:	89 f0                	mov    %esi,%eax
  8020e8:	29 d8                	sub    %ebx,%eax
  8020ea:	50                   	push   %eax
  8020eb:	89 d8                	mov    %ebx,%eax
  8020ed:	03 45 0c             	add    0xc(%ebp),%eax
  8020f0:	50                   	push   %eax
  8020f1:	57                   	push   %edi
  8020f2:	e8 41 ff ff ff       	call   802038 <read>
		if (m < 0)
  8020f7:	83 c4 10             	add    $0x10,%esp
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	78 04                	js     802102 <readn+0x3f>
			return m;
		if (m == 0)
  8020fe:	75 dd                	jne    8020dd <readn+0x1a>
  802100:	eb 02                	jmp    802104 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802102:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802104:	89 d8                	mov    %ebx,%eax
  802106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802109:	5b                   	pop    %ebx
  80210a:	5e                   	pop    %esi
  80210b:	5f                   	pop    %edi
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    

0080210e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80210e:	f3 0f 1e fb          	endbr32 
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	53                   	push   %ebx
  802116:	83 ec 1c             	sub    $0x1c,%esp
  802119:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80211c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80211f:	50                   	push   %eax
  802120:	53                   	push   %ebx
  802121:	e8 8f fc ff ff       	call   801db5 <fd_lookup>
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	85 c0                	test   %eax,%eax
  80212b:	78 3a                	js     802167 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80212d:	83 ec 08             	sub    $0x8,%esp
  802130:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802133:	50                   	push   %eax
  802134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802137:	ff 30                	pushl  (%eax)
  802139:	e8 cb fc ff ff       	call   801e09 <dev_lookup>
  80213e:	83 c4 10             	add    $0x10,%esp
  802141:	85 c0                	test   %eax,%eax
  802143:	78 22                	js     802167 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802148:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80214c:	74 1e                	je     80216c <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80214e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802151:	8b 52 0c             	mov    0xc(%edx),%edx
  802154:	85 d2                	test   %edx,%edx
  802156:	74 35                	je     80218d <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	ff 75 10             	pushl  0x10(%ebp)
  80215e:	ff 75 0c             	pushl  0xc(%ebp)
  802161:	50                   	push   %eax
  802162:	ff d2                	call   *%edx
  802164:	83 c4 10             	add    $0x10,%esp
}
  802167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80216c:	a1 24 54 80 00       	mov    0x805424,%eax
  802171:	8b 40 48             	mov    0x48(%eax),%eax
  802174:	83 ec 04             	sub    $0x4,%esp
  802177:	53                   	push   %ebx
  802178:	50                   	push   %eax
  802179:	68 29 3b 80 00       	push   $0x803b29
  80217e:	e8 04 ea ff ff       	call   800b87 <cprintf>
		return -E_INVAL;
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80218b:	eb da                	jmp    802167 <write+0x59>
		return -E_NOT_SUPP;
  80218d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802192:	eb d3                	jmp    802167 <write+0x59>

00802194 <seek>:

int
seek(int fdnum, off_t offset)
{
  802194:	f3 0f 1e fb          	endbr32 
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80219e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a1:	50                   	push   %eax
  8021a2:	ff 75 08             	pushl  0x8(%ebp)
  8021a5:	e8 0b fc ff ff       	call   801db5 <fd_lookup>
  8021aa:	83 c4 10             	add    $0x10,%esp
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	78 0e                	js     8021bf <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8021b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8021ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8021c1:	f3 0f 1e fb          	endbr32 
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	53                   	push   %ebx
  8021c9:	83 ec 1c             	sub    $0x1c,%esp
  8021cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021d2:	50                   	push   %eax
  8021d3:	53                   	push   %ebx
  8021d4:	e8 dc fb ff ff       	call   801db5 <fd_lookup>
  8021d9:	83 c4 10             	add    $0x10,%esp
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	78 37                	js     802217 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021e0:	83 ec 08             	sub    $0x8,%esp
  8021e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e6:	50                   	push   %eax
  8021e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ea:	ff 30                	pushl  (%eax)
  8021ec:	e8 18 fc ff ff       	call   801e09 <dev_lookup>
  8021f1:	83 c4 10             	add    $0x10,%esp
  8021f4:	85 c0                	test   %eax,%eax
  8021f6:	78 1f                	js     802217 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021ff:	74 1b                	je     80221c <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802204:	8b 52 18             	mov    0x18(%edx),%edx
  802207:	85 d2                	test   %edx,%edx
  802209:	74 32                	je     80223d <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80220b:	83 ec 08             	sub    $0x8,%esp
  80220e:	ff 75 0c             	pushl  0xc(%ebp)
  802211:	50                   	push   %eax
  802212:	ff d2                	call   *%edx
  802214:	83 c4 10             	add    $0x10,%esp
}
  802217:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80221c:	a1 24 54 80 00       	mov    0x805424,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802221:	8b 40 48             	mov    0x48(%eax),%eax
  802224:	83 ec 04             	sub    $0x4,%esp
  802227:	53                   	push   %ebx
  802228:	50                   	push   %eax
  802229:	68 ec 3a 80 00       	push   $0x803aec
  80222e:	e8 54 e9 ff ff       	call   800b87 <cprintf>
		return -E_INVAL;
  802233:	83 c4 10             	add    $0x10,%esp
  802236:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223b:	eb da                	jmp    802217 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80223d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802242:	eb d3                	jmp    802217 <ftruncate+0x56>

00802244 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802244:	f3 0f 1e fb          	endbr32 
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	53                   	push   %ebx
  80224c:	83 ec 1c             	sub    $0x1c,%esp
  80224f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802252:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802255:	50                   	push   %eax
  802256:	ff 75 08             	pushl  0x8(%ebp)
  802259:	e8 57 fb ff ff       	call   801db5 <fd_lookup>
  80225e:	83 c4 10             	add    $0x10,%esp
  802261:	85 c0                	test   %eax,%eax
  802263:	78 4b                	js     8022b0 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802265:	83 ec 08             	sub    $0x8,%esp
  802268:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226b:	50                   	push   %eax
  80226c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226f:	ff 30                	pushl  (%eax)
  802271:	e8 93 fb ff ff       	call   801e09 <dev_lookup>
  802276:	83 c4 10             	add    $0x10,%esp
  802279:	85 c0                	test   %eax,%eax
  80227b:	78 33                	js     8022b0 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802284:	74 2f                	je     8022b5 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802286:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802289:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802290:	00 00 00 
	stat->st_isdir = 0;
  802293:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80229a:	00 00 00 
	stat->st_dev = dev;
  80229d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8022a3:	83 ec 08             	sub    $0x8,%esp
  8022a6:	53                   	push   %ebx
  8022a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8022aa:	ff 50 14             	call   *0x14(%eax)
  8022ad:	83 c4 10             	add    $0x10,%esp
}
  8022b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    
		return -E_NOT_SUPP;
  8022b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022ba:	eb f4                	jmp    8022b0 <fstat+0x6c>

008022bc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022bc:	f3 0f 1e fb          	endbr32 
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	56                   	push   %esi
  8022c4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022c5:	83 ec 08             	sub    $0x8,%esp
  8022c8:	6a 00                	push   $0x0
  8022ca:	ff 75 08             	pushl  0x8(%ebp)
  8022cd:	e8 fb 01 00 00       	call   8024cd <open>
  8022d2:	89 c3                	mov    %eax,%ebx
  8022d4:	83 c4 10             	add    $0x10,%esp
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	78 1b                	js     8022f6 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8022db:	83 ec 08             	sub    $0x8,%esp
  8022de:	ff 75 0c             	pushl  0xc(%ebp)
  8022e1:	50                   	push   %eax
  8022e2:	e8 5d ff ff ff       	call   802244 <fstat>
  8022e7:	89 c6                	mov    %eax,%esi
	close(fd);
  8022e9:	89 1c 24             	mov    %ebx,(%esp)
  8022ec:	e8 fd fb ff ff       	call   801eee <close>
	return r;
  8022f1:	83 c4 10             	add    $0x10,%esp
  8022f4:	89 f3                	mov    %esi,%ebx
}
  8022f6:	89 d8                	mov    %ebx,%eax
  8022f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5d                   	pop    %ebp
  8022fe:	c3                   	ret    

008022ff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	89 c6                	mov    %eax,%esi
  802306:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802308:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  80230f:	74 27                	je     802338 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802311:	6a 07                	push   $0x7
  802313:	68 00 60 80 00       	push   $0x806000
  802318:	56                   	push   %esi
  802319:	ff 35 20 54 80 00    	pushl  0x805420
  80231f:	e8 5f 0e 00 00       	call   803183 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802324:	83 c4 0c             	add    $0xc,%esp
  802327:	6a 00                	push   $0x0
  802329:	53                   	push   %ebx
  80232a:	6a 00                	push   $0x0
  80232c:	e8 cd 0d 00 00       	call   8030fe <ipc_recv>
}
  802331:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802334:	5b                   	pop    %ebx
  802335:	5e                   	pop    %esi
  802336:	5d                   	pop    %ebp
  802337:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802338:	83 ec 0c             	sub    $0xc,%esp
  80233b:	6a 01                	push   $0x1
  80233d:	e8 99 0e 00 00       	call   8031db <ipc_find_env>
  802342:	a3 20 54 80 00       	mov    %eax,0x805420
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	eb c5                	jmp    802311 <fsipc+0x12>

0080234c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80234c:	f3 0f 1e fb          	endbr32 
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	8b 40 0c             	mov    0xc(%eax),%eax
  80235c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802361:	8b 45 0c             	mov    0xc(%ebp),%eax
  802364:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802369:	ba 00 00 00 00       	mov    $0x0,%edx
  80236e:	b8 02 00 00 00       	mov    $0x2,%eax
  802373:	e8 87 ff ff ff       	call   8022ff <fsipc>
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <devfile_flush>:
{
  80237a:	f3 0f 1e fb          	endbr32 
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	8b 40 0c             	mov    0xc(%eax),%eax
  80238a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80238f:	ba 00 00 00 00       	mov    $0x0,%edx
  802394:	b8 06 00 00 00       	mov    $0x6,%eax
  802399:	e8 61 ff ff ff       	call   8022ff <fsipc>
}
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <devfile_stat>:
{
  8023a0:	f3 0f 1e fb          	endbr32 
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	53                   	push   %ebx
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b4:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8023b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8023be:	b8 05 00 00 00       	mov    $0x5,%eax
  8023c3:	e8 37 ff ff ff       	call   8022ff <fsipc>
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	78 2c                	js     8023f8 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8023cc:	83 ec 08             	sub    $0x8,%esp
  8023cf:	68 00 60 80 00       	push   $0x806000
  8023d4:	53                   	push   %ebx
  8023d5:	e8 ab ee ff ff       	call   801285 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8023da:	a1 80 60 80 00       	mov    0x806080,%eax
  8023df:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8023e5:	a1 84 60 80 00       	mov    0x806084,%eax
  8023ea:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8023f0:	83 c4 10             	add    $0x10,%esp
  8023f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <devfile_write>:
{
  8023fd:	f3 0f 1e fb          	endbr32 
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	83 ec 0c             	sub    $0xc,%esp
  802407:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80240a:	8b 55 08             	mov    0x8(%ebp),%edx
  80240d:	8b 52 0c             	mov    0xc(%edx),%edx
  802410:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  802416:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80241b:	ba f8 0f 00 00       	mov    $0xff8,%edx
  802420:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  802423:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  802428:	50                   	push   %eax
  802429:	ff 75 0c             	pushl  0xc(%ebp)
  80242c:	68 08 60 80 00       	push   $0x806008
  802431:	e8 05 f0 ff ff       	call   80143b <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  802436:	ba 00 00 00 00       	mov    $0x0,%edx
  80243b:	b8 04 00 00 00       	mov    $0x4,%eax
  802440:	e8 ba fe ff ff       	call   8022ff <fsipc>
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <devfile_read>:
{
  802447:	f3 0f 1e fb          	endbr32 
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	56                   	push   %esi
  80244f:	53                   	push   %ebx
  802450:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	8b 40 0c             	mov    0xc(%eax),%eax
  802459:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80245e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802464:	ba 00 00 00 00       	mov    $0x0,%edx
  802469:	b8 03 00 00 00       	mov    $0x3,%eax
  80246e:	e8 8c fe ff ff       	call   8022ff <fsipc>
  802473:	89 c3                	mov    %eax,%ebx
  802475:	85 c0                	test   %eax,%eax
  802477:	78 1f                	js     802498 <devfile_read+0x51>
	assert(r <= n);
  802479:	39 f0                	cmp    %esi,%eax
  80247b:	77 24                	ja     8024a1 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80247d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802482:	7f 33                	jg     8024b7 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802484:	83 ec 04             	sub    $0x4,%esp
  802487:	50                   	push   %eax
  802488:	68 00 60 80 00       	push   $0x806000
  80248d:	ff 75 0c             	pushl  0xc(%ebp)
  802490:	e8 a6 ef ff ff       	call   80143b <memmove>
	return r;
  802495:	83 c4 10             	add    $0x10,%esp
}
  802498:	89 d8                	mov    %ebx,%eax
  80249a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80249d:	5b                   	pop    %ebx
  80249e:	5e                   	pop    %esi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    
	assert(r <= n);
  8024a1:	68 58 3b 80 00       	push   $0x803b58
  8024a6:	68 07 36 80 00       	push   $0x803607
  8024ab:	6a 7c                	push   $0x7c
  8024ad:	68 5f 3b 80 00       	push   $0x803b5f
  8024b2:	e8 e9 e5 ff ff       	call   800aa0 <_panic>
	assert(r <= PGSIZE);
  8024b7:	68 6a 3b 80 00       	push   $0x803b6a
  8024bc:	68 07 36 80 00       	push   $0x803607
  8024c1:	6a 7d                	push   $0x7d
  8024c3:	68 5f 3b 80 00       	push   $0x803b5f
  8024c8:	e8 d3 e5 ff ff       	call   800aa0 <_panic>

008024cd <open>:
{
  8024cd:	f3 0f 1e fb          	endbr32 
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	56                   	push   %esi
  8024d5:	53                   	push   %ebx
  8024d6:	83 ec 1c             	sub    $0x1c,%esp
  8024d9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8024dc:	56                   	push   %esi
  8024dd:	e8 60 ed ff ff       	call   801242 <strlen>
  8024e2:	83 c4 10             	add    $0x10,%esp
  8024e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8024ea:	7f 6c                	jg     802558 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f2:	50                   	push   %eax
  8024f3:	e8 67 f8 ff ff       	call   801d5f <fd_alloc>
  8024f8:	89 c3                	mov    %eax,%ebx
  8024fa:	83 c4 10             	add    $0x10,%esp
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	78 3c                	js     80253d <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  802501:	83 ec 08             	sub    $0x8,%esp
  802504:	56                   	push   %esi
  802505:	68 00 60 80 00       	push   $0x806000
  80250a:	e8 76 ed ff ff       	call   801285 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80250f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802512:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802517:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251a:	b8 01 00 00 00       	mov    $0x1,%eax
  80251f:	e8 db fd ff ff       	call   8022ff <fsipc>
  802524:	89 c3                	mov    %eax,%ebx
  802526:	83 c4 10             	add    $0x10,%esp
  802529:	85 c0                	test   %eax,%eax
  80252b:	78 19                	js     802546 <open+0x79>
	return fd2num(fd);
  80252d:	83 ec 0c             	sub    $0xc,%esp
  802530:	ff 75 f4             	pushl  -0xc(%ebp)
  802533:	e8 f8 f7 ff ff       	call   801d30 <fd2num>
  802538:	89 c3                	mov    %eax,%ebx
  80253a:	83 c4 10             	add    $0x10,%esp
}
  80253d:	89 d8                	mov    %ebx,%eax
  80253f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802542:	5b                   	pop    %ebx
  802543:	5e                   	pop    %esi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
		fd_close(fd, 0);
  802546:	83 ec 08             	sub    $0x8,%esp
  802549:	6a 00                	push   $0x0
  80254b:	ff 75 f4             	pushl  -0xc(%ebp)
  80254e:	e8 10 f9 ff ff       	call   801e63 <fd_close>
		return r;
  802553:	83 c4 10             	add    $0x10,%esp
  802556:	eb e5                	jmp    80253d <open+0x70>
		return -E_BAD_PATH;
  802558:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80255d:	eb de                	jmp    80253d <open+0x70>

0080255f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80255f:	f3 0f 1e fb          	endbr32 
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
  802566:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802569:	ba 00 00 00 00       	mov    $0x0,%edx
  80256e:	b8 08 00 00 00       	mov    $0x8,%eax
  802573:	e8 87 fd ff ff       	call   8022ff <fsipc>
}
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80257a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80257e:	7f 01                	jg     802581 <writebuf+0x7>
  802580:	c3                   	ret    
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	53                   	push   %ebx
  802585:	83 ec 08             	sub    $0x8,%esp
  802588:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80258a:	ff 70 04             	pushl  0x4(%eax)
  80258d:	8d 40 10             	lea    0x10(%eax),%eax
  802590:	50                   	push   %eax
  802591:	ff 33                	pushl  (%ebx)
  802593:	e8 76 fb ff ff       	call   80210e <write>
		if (result > 0)
  802598:	83 c4 10             	add    $0x10,%esp
  80259b:	85 c0                	test   %eax,%eax
  80259d:	7e 03                	jle    8025a2 <writebuf+0x28>
			b->result += result;
  80259f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8025a2:	39 43 04             	cmp    %eax,0x4(%ebx)
  8025a5:	74 0d                	je     8025b4 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ae:	0f 4f c2             	cmovg  %edx,%eax
  8025b1:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8025b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <putch>:

static void
putch(int ch, void *thunk)
{
  8025b9:	f3 0f 1e fb          	endbr32 
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	53                   	push   %ebx
  8025c1:	83 ec 04             	sub    $0x4,%esp
  8025c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8025c7:	8b 53 04             	mov    0x4(%ebx),%edx
  8025ca:	8d 42 01             	lea    0x1(%edx),%eax
  8025cd:	89 43 04             	mov    %eax,0x4(%ebx)
  8025d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025d3:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8025d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8025dc:	74 06                	je     8025e4 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  8025de:	83 c4 04             	add    $0x4,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5d                   	pop    %ebp
  8025e3:	c3                   	ret    
		writebuf(b);
  8025e4:	89 d8                	mov    %ebx,%eax
  8025e6:	e8 8f ff ff ff       	call   80257a <writebuf>
		b->idx = 0;
  8025eb:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8025f2:	eb ea                	jmp    8025de <putch+0x25>

008025f4 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8025f4:	f3 0f 1e fb          	endbr32 
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80260a:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802611:	00 00 00 
	b.result = 0;
  802614:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80261b:	00 00 00 
	b.error = 1;
  80261e:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802625:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802628:	ff 75 10             	pushl  0x10(%ebp)
  80262b:	ff 75 0c             	pushl  0xc(%ebp)
  80262e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802634:	50                   	push   %eax
  802635:	68 b9 25 80 00       	push   $0x8025b9
  80263a:	e8 4b e6 ff ff       	call   800c8a <vprintfmt>
	if (b.idx > 0)
  80263f:	83 c4 10             	add    $0x10,%esp
  802642:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802649:	7f 11                	jg     80265c <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80264b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    
		writebuf(&b);
  80265c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802662:	e8 13 ff ff ff       	call   80257a <writebuf>
  802667:	eb e2                	jmp    80264b <vfprintf+0x57>

00802669 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802669:	f3 0f 1e fb          	endbr32 
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
  802670:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802673:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802676:	50                   	push   %eax
  802677:	ff 75 0c             	pushl  0xc(%ebp)
  80267a:	ff 75 08             	pushl  0x8(%ebp)
  80267d:	e8 72 ff ff ff       	call   8025f4 <vfprintf>
	va_end(ap);

	return cnt;
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <printf>:

int
printf(const char *fmt, ...)
{
  802684:	f3 0f 1e fb          	endbr32 
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80268e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802691:	50                   	push   %eax
  802692:	ff 75 08             	pushl  0x8(%ebp)
  802695:	6a 01                	push   $0x1
  802697:	e8 58 ff ff ff       	call   8025f4 <vfprintf>
	va_end(ap);

	return cnt;
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80269e:	f3 0f 1e fb          	endbr32 
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
  8026a5:	57                   	push   %edi
  8026a6:	56                   	push   %esi
  8026a7:	53                   	push   %ebx
  8026a8:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8026ae:	6a 00                	push   $0x0
  8026b0:	ff 75 08             	pushl  0x8(%ebp)
  8026b3:	e8 15 fe ff ff       	call   8024cd <open>
  8026b8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8026be:	83 c4 10             	add    $0x10,%esp
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	0f 88 e7 04 00 00    	js     802bb0 <spawn+0x512>
  8026c9:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8026cb:	83 ec 04             	sub    $0x4,%esp
  8026ce:	68 00 02 00 00       	push   $0x200
  8026d3:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8026d9:	50                   	push   %eax
  8026da:	52                   	push   %edx
  8026db:	e8 e3 f9 ff ff       	call   8020c3 <readn>
  8026e0:	83 c4 10             	add    $0x10,%esp
  8026e3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8026e8:	75 7e                	jne    802768 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  8026ea:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8026f1:	45 4c 46 
  8026f4:	75 72                	jne    802768 <spawn+0xca>
  8026f6:	b8 07 00 00 00       	mov    $0x7,%eax
  8026fb:	cd 30                	int    $0x30
  8026fd:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802703:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802709:	85 c0                	test   %eax,%eax
  80270b:	0f 88 93 04 00 00    	js     802ba4 <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802711:	25 ff 03 00 00       	and    $0x3ff,%eax
  802716:	6b f0 7c             	imul   $0x7c,%eax,%esi
  802719:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80271f:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802725:	b9 11 00 00 00       	mov    $0x11,%ecx
  80272a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80272c:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802732:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802738:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80273d:	be 00 00 00 00       	mov    $0x0,%esi
  802742:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802745:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  80274c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	74 4d                	je     8027a0 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  802753:	83 ec 0c             	sub    $0xc,%esp
  802756:	50                   	push   %eax
  802757:	e8 e6 ea ff ff       	call   801242 <strlen>
  80275c:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802760:	83 c3 01             	add    $0x1,%ebx
  802763:	83 c4 10             	add    $0x10,%esp
  802766:	eb dd                	jmp    802745 <spawn+0xa7>
		close(fd);
  802768:	83 ec 0c             	sub    $0xc,%esp
  80276b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802771:	e8 78 f7 ff ff       	call   801eee <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802776:	83 c4 0c             	add    $0xc,%esp
  802779:	68 7f 45 4c 46       	push   $0x464c457f
  80277e:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802784:	68 76 3b 80 00       	push   $0x803b76
  802789:	e8 f9 e3 ff ff       	call   800b87 <cprintf>
		return -E_NOT_EXEC;
  80278e:	83 c4 10             	add    $0x10,%esp
  802791:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802798:	ff ff ff 
  80279b:	e9 10 04 00 00       	jmp    802bb0 <spawn+0x512>
  8027a0:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8027a6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8027ac:	bf 00 10 40 00       	mov    $0x401000,%edi
  8027b1:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8027b3:	89 fa                	mov    %edi,%edx
  8027b5:	83 e2 fc             	and    $0xfffffffc,%edx
  8027b8:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8027bf:	29 c2                	sub    %eax,%edx
  8027c1:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8027c7:	8d 42 f8             	lea    -0x8(%edx),%eax
  8027ca:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8027cf:	0f 86 fe 03 00 00    	jbe    802bd3 <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8027d5:	83 ec 04             	sub    $0x4,%esp
  8027d8:	6a 07                	push   $0x7
  8027da:	68 00 00 40 00       	push   $0x400000
  8027df:	6a 00                	push   $0x0
  8027e1:	e8 e1 ee ff ff       	call   8016c7 <sys_page_alloc>
  8027e6:	83 c4 10             	add    $0x10,%esp
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	0f 88 e7 03 00 00    	js     802bd8 <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8027f1:	be 00 00 00 00       	mov    $0x0,%esi
  8027f6:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8027fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8027ff:	eb 30                	jmp    802831 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  802801:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802807:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80280d:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802810:	83 ec 08             	sub    $0x8,%esp
  802813:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802816:	57                   	push   %edi
  802817:	e8 69 ea ff ff       	call   801285 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80281c:	83 c4 04             	add    $0x4,%esp
  80281f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802822:	e8 1b ea ff ff       	call   801242 <strlen>
  802827:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80282b:	83 c6 01             	add    $0x1,%esi
  80282e:	83 c4 10             	add    $0x10,%esp
  802831:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802837:	7f c8                	jg     802801 <spawn+0x163>
	}
	argv_store[argc] = 0;
  802839:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80283f:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802845:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80284c:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802852:	0f 85 86 00 00 00    	jne    8028de <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802858:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80285e:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  802864:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802867:	89 c8                	mov    %ecx,%eax
  802869:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  80286f:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802872:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802877:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80287d:	83 ec 0c             	sub    $0xc,%esp
  802880:	6a 07                	push   $0x7
  802882:	68 00 d0 bf ee       	push   $0xeebfd000
  802887:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80288d:	68 00 00 40 00       	push   $0x400000
  802892:	6a 00                	push   $0x0
  802894:	e8 75 ee ff ff       	call   80170e <sys_page_map>
  802899:	89 c3                	mov    %eax,%ebx
  80289b:	83 c4 20             	add    $0x20,%esp
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	0f 88 3a 03 00 00    	js     802be0 <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8028a6:	83 ec 08             	sub    $0x8,%esp
  8028a9:	68 00 00 40 00       	push   $0x400000
  8028ae:	6a 00                	push   $0x0
  8028b0:	e8 9f ee ff ff       	call   801754 <sys_page_unmap>
  8028b5:	89 c3                	mov    %eax,%ebx
  8028b7:	83 c4 10             	add    $0x10,%esp
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	0f 88 1e 03 00 00    	js     802be0 <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8028c2:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8028c8:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8028cf:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8028d6:	00 00 00 
  8028d9:	e9 4f 01 00 00       	jmp    802a2d <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8028de:	68 d4 3b 80 00       	push   $0x803bd4
  8028e3:	68 07 36 80 00       	push   $0x803607
  8028e8:	68 f2 00 00 00       	push   $0xf2
  8028ed:	68 90 3b 80 00       	push   $0x803b90
  8028f2:	e8 a9 e1 ff ff       	call   800aa0 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8028f7:	83 ec 04             	sub    $0x4,%esp
  8028fa:	6a 07                	push   $0x7
  8028fc:	68 00 00 40 00       	push   $0x400000
  802901:	6a 00                	push   $0x0
  802903:	e8 bf ed ff ff       	call   8016c7 <sys_page_alloc>
  802908:	83 c4 10             	add    $0x10,%esp
  80290b:	85 c0                	test   %eax,%eax
  80290d:	0f 88 ab 02 00 00    	js     802bbe <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802913:	83 ec 08             	sub    $0x8,%esp
  802916:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80291c:	01 f0                	add    %esi,%eax
  80291e:	50                   	push   %eax
  80291f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802925:	e8 6a f8 ff ff       	call   802194 <seek>
  80292a:	83 c4 10             	add    $0x10,%esp
  80292d:	85 c0                	test   %eax,%eax
  80292f:	0f 88 90 02 00 00    	js     802bc5 <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802935:	83 ec 04             	sub    $0x4,%esp
  802938:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80293e:	29 f0                	sub    %esi,%eax
  802940:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802945:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80294a:	0f 47 c1             	cmova  %ecx,%eax
  80294d:	50                   	push   %eax
  80294e:	68 00 00 40 00       	push   $0x400000
  802953:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802959:	e8 65 f7 ff ff       	call   8020c3 <readn>
  80295e:	83 c4 10             	add    $0x10,%esp
  802961:	85 c0                	test   %eax,%eax
  802963:	0f 88 63 02 00 00    	js     802bcc <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802969:	83 ec 0c             	sub    $0xc,%esp
  80296c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802972:	53                   	push   %ebx
  802973:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802979:	68 00 00 40 00       	push   $0x400000
  80297e:	6a 00                	push   $0x0
  802980:	e8 89 ed ff ff       	call   80170e <sys_page_map>
  802985:	83 c4 20             	add    $0x20,%esp
  802988:	85 c0                	test   %eax,%eax
  80298a:	78 7c                	js     802a08 <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80298c:	83 ec 08             	sub    $0x8,%esp
  80298f:	68 00 00 40 00       	push   $0x400000
  802994:	6a 00                	push   $0x0
  802996:	e8 b9 ed ff ff       	call   801754 <sys_page_unmap>
  80299b:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80299e:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8029a4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8029aa:	89 fe                	mov    %edi,%esi
  8029ac:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8029b2:	76 69                	jbe    802a1d <spawn+0x37f>
		if (i >= filesz) {
  8029b4:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8029ba:	0f 87 37 ff ff ff    	ja     8028f7 <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8029c0:	83 ec 04             	sub    $0x4,%esp
  8029c3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8029c9:	53                   	push   %ebx
  8029ca:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8029d0:	e8 f2 ec ff ff       	call   8016c7 <sys_page_alloc>
  8029d5:	83 c4 10             	add    $0x10,%esp
  8029d8:	85 c0                	test   %eax,%eax
  8029da:	79 c2                	jns    80299e <spawn+0x300>
  8029dc:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8029de:	83 ec 0c             	sub    $0xc,%esp
  8029e1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8029e7:	e8 50 ec ff ff       	call   80163c <sys_env_destroy>
	close(fd);
  8029ec:	83 c4 04             	add    $0x4,%esp
  8029ef:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8029f5:	e8 f4 f4 ff ff       	call   801eee <close>
	return r;
  8029fa:	83 c4 10             	add    $0x10,%esp
  8029fd:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802a03:	e9 a8 01 00 00       	jmp    802bb0 <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  802a08:	50                   	push   %eax
  802a09:	68 9c 3b 80 00       	push   $0x803b9c
  802a0e:	68 25 01 00 00       	push   $0x125
  802a13:	68 90 3b 80 00       	push   $0x803b90
  802a18:	e8 83 e0 ff ff       	call   800aa0 <_panic>
  802a1d:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802a23:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802a2a:	83 c6 20             	add    $0x20,%esi
  802a2d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802a34:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802a3a:	7e 6d                	jle    802aa9 <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  802a3c:	83 3e 01             	cmpl   $0x1,(%esi)
  802a3f:	75 e2                	jne    802a23 <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802a41:	8b 46 18             	mov    0x18(%esi),%eax
  802a44:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802a47:	83 f8 01             	cmp    $0x1,%eax
  802a4a:	19 c0                	sbb    %eax,%eax
  802a4c:	83 e0 fe             	and    $0xfffffffe,%eax
  802a4f:	83 c0 07             	add    $0x7,%eax
  802a52:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802a58:	8b 4e 04             	mov    0x4(%esi),%ecx
  802a5b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802a61:	8b 56 10             	mov    0x10(%esi),%edx
  802a64:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802a6a:	8b 7e 14             	mov    0x14(%esi),%edi
  802a6d:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802a73:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802a76:	89 d8                	mov    %ebx,%eax
  802a78:	25 ff 0f 00 00       	and    $0xfff,%eax
  802a7d:	74 1a                	je     802a99 <spawn+0x3fb>
		va -= i;
  802a7f:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802a81:	01 c7                	add    %eax,%edi
  802a83:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802a89:	01 c2                	add    %eax,%edx
  802a8b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802a91:	29 c1                	sub    %eax,%ecx
  802a93:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802a99:	bf 00 00 00 00       	mov    $0x0,%edi
  802a9e:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802aa4:	e9 01 ff ff ff       	jmp    8029aa <spawn+0x30c>
	close(fd);
  802aa9:	83 ec 0c             	sub    $0xc,%esp
  802aac:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802ab2:	e8 37 f4 ff ff       	call   801eee <close>
  802ab7:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  802aba:	bb 00 00 00 00       	mov    $0x0,%ebx
  802abf:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802ac5:	eb 0e                	jmp    802ad5 <spawn+0x437>
  802ac7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802acd:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802ad3:	74 5a                	je     802b2f <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  802ad5:	89 d8                	mov    %ebx,%eax
  802ad7:	c1 e8 16             	shr    $0x16,%eax
  802ada:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802ae1:	a8 01                	test   $0x1,%al
  802ae3:	74 e2                	je     802ac7 <spawn+0x429>
  802ae5:	89 d8                	mov    %ebx,%eax
  802ae7:	c1 e8 0c             	shr    $0xc,%eax
  802aea:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802af1:	f6 c2 01             	test   $0x1,%dl
  802af4:	74 d1                	je     802ac7 <spawn+0x429>
  802af6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802afd:	f6 c2 04             	test   $0x4,%dl
  802b00:	74 c5                	je     802ac7 <spawn+0x429>
  802b02:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b09:	f6 c6 04             	test   $0x4,%dh
  802b0c:	74 b9                	je     802ac7 <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  802b0e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802b15:	83 ec 0c             	sub    $0xc,%esp
  802b18:	25 07 0e 00 00       	and    $0xe07,%eax
  802b1d:	50                   	push   %eax
  802b1e:	53                   	push   %ebx
  802b1f:	56                   	push   %esi
  802b20:	53                   	push   %ebx
  802b21:	6a 00                	push   $0x0
  802b23:	e8 e6 eb ff ff       	call   80170e <sys_page_map>
  802b28:	83 c4 20             	add    $0x20,%esp
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	79 98                	jns    802ac7 <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802b2f:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802b36:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802b39:	83 ec 08             	sub    $0x8,%esp
  802b3c:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802b42:	50                   	push   %eax
  802b43:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b49:	e8 92 ec ff ff       	call   8017e0 <sys_env_set_trapframe>
  802b4e:	83 c4 10             	add    $0x10,%esp
  802b51:	85 c0                	test   %eax,%eax
  802b53:	78 25                	js     802b7a <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802b55:	83 ec 08             	sub    $0x8,%esp
  802b58:	6a 02                	push   $0x2
  802b5a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b60:	e8 35 ec ff ff       	call   80179a <sys_env_set_status>
  802b65:	83 c4 10             	add    $0x10,%esp
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	78 23                	js     802b8f <spawn+0x4f1>
	return child;
  802b6c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802b72:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802b78:	eb 36                	jmp    802bb0 <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  802b7a:	50                   	push   %eax
  802b7b:	68 b9 3b 80 00       	push   $0x803bb9
  802b80:	68 86 00 00 00       	push   $0x86
  802b85:	68 90 3b 80 00       	push   $0x803b90
  802b8a:	e8 11 df ff ff       	call   800aa0 <_panic>
		panic("sys_env_set_status: %e", r);
  802b8f:	50                   	push   %eax
  802b90:	68 9e 3a 80 00       	push   $0x803a9e
  802b95:	68 89 00 00 00       	push   $0x89
  802b9a:	68 90 3b 80 00       	push   $0x803b90
  802b9f:	e8 fc de ff ff       	call   800aa0 <_panic>
		return r;
  802ba4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802baa:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802bb0:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bb9:	5b                   	pop    %ebx
  802bba:	5e                   	pop    %esi
  802bbb:	5f                   	pop    %edi
  802bbc:	5d                   	pop    %ebp
  802bbd:	c3                   	ret    
  802bbe:	89 c7                	mov    %eax,%edi
  802bc0:	e9 19 fe ff ff       	jmp    8029de <spawn+0x340>
  802bc5:	89 c7                	mov    %eax,%edi
  802bc7:	e9 12 fe ff ff       	jmp    8029de <spawn+0x340>
  802bcc:	89 c7                	mov    %eax,%edi
  802bce:	e9 0b fe ff ff       	jmp    8029de <spawn+0x340>
		return -E_NO_MEM;
  802bd3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  802bd8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802bde:	eb d0                	jmp    802bb0 <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  802be0:	83 ec 08             	sub    $0x8,%esp
  802be3:	68 00 00 40 00       	push   $0x400000
  802be8:	6a 00                	push   $0x0
  802bea:	e8 65 eb ff ff       	call   801754 <sys_page_unmap>
  802bef:	83 c4 10             	add    $0x10,%esp
  802bf2:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802bf8:	eb b6                	jmp    802bb0 <spawn+0x512>

00802bfa <spawnl>:
{
  802bfa:	f3 0f 1e fb          	endbr32 
  802bfe:	55                   	push   %ebp
  802bff:	89 e5                	mov    %esp,%ebp
  802c01:	57                   	push   %edi
  802c02:	56                   	push   %esi
  802c03:	53                   	push   %ebx
  802c04:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802c07:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802c0f:	8d 4a 04             	lea    0x4(%edx),%ecx
  802c12:	83 3a 00             	cmpl   $0x0,(%edx)
  802c15:	74 07                	je     802c1e <spawnl+0x24>
		argc++;
  802c17:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802c1a:	89 ca                	mov    %ecx,%edx
  802c1c:	eb f1                	jmp    802c0f <spawnl+0x15>
	const char *argv[argc+2];
  802c1e:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802c25:	89 d1                	mov    %edx,%ecx
  802c27:	83 e1 f0             	and    $0xfffffff0,%ecx
  802c2a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802c30:	89 e6                	mov    %esp,%esi
  802c32:	29 d6                	sub    %edx,%esi
  802c34:	89 f2                	mov    %esi,%edx
  802c36:	39 d4                	cmp    %edx,%esp
  802c38:	74 10                	je     802c4a <spawnl+0x50>
  802c3a:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  802c40:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802c47:	00 
  802c48:	eb ec                	jmp    802c36 <spawnl+0x3c>
  802c4a:	89 ca                	mov    %ecx,%edx
  802c4c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802c52:	29 d4                	sub    %edx,%esp
  802c54:	85 d2                	test   %edx,%edx
  802c56:	74 05                	je     802c5d <spawnl+0x63>
  802c58:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  802c5d:	8d 74 24 03          	lea    0x3(%esp),%esi
  802c61:	89 f2                	mov    %esi,%edx
  802c63:	c1 ea 02             	shr    $0x2,%edx
  802c66:	83 e6 fc             	and    $0xfffffffc,%esi
  802c69:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802c6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c6e:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802c75:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802c7c:	00 
	va_start(vl, arg0);
  802c7d:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802c80:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802c82:	b8 00 00 00 00       	mov    $0x0,%eax
  802c87:	eb 0b                	jmp    802c94 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  802c89:	83 c0 01             	add    $0x1,%eax
  802c8c:	8b 39                	mov    (%ecx),%edi
  802c8e:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802c91:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802c94:	39 d0                	cmp    %edx,%eax
  802c96:	75 f1                	jne    802c89 <spawnl+0x8f>
	return spawn(prog, argv);
  802c98:	83 ec 08             	sub    $0x8,%esp
  802c9b:	56                   	push   %esi
  802c9c:	ff 75 08             	pushl  0x8(%ebp)
  802c9f:	e8 fa f9 ff ff       	call   80269e <spawn>
}
  802ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ca7:	5b                   	pop    %ebx
  802ca8:	5e                   	pop    %esi
  802ca9:	5f                   	pop    %edi
  802caa:	5d                   	pop    %ebp
  802cab:	c3                   	ret    

00802cac <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802cac:	f3 0f 1e fb          	endbr32 
  802cb0:	55                   	push   %ebp
  802cb1:	89 e5                	mov    %esp,%ebp
  802cb3:	56                   	push   %esi
  802cb4:	53                   	push   %ebx
  802cb5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802cb8:	83 ec 0c             	sub    $0xc,%esp
  802cbb:	ff 75 08             	pushl  0x8(%ebp)
  802cbe:	e8 81 f0 ff ff       	call   801d44 <fd2data>
  802cc3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802cc5:	83 c4 08             	add    $0x8,%esp
  802cc8:	68 fa 3b 80 00       	push   $0x803bfa
  802ccd:	53                   	push   %ebx
  802cce:	e8 b2 e5 ff ff       	call   801285 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802cd3:	8b 46 04             	mov    0x4(%esi),%eax
  802cd6:	2b 06                	sub    (%esi),%eax
  802cd8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802cde:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802ce5:	00 00 00 
	stat->st_dev = &devpipe;
  802ce8:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802cef:	40 80 00 
	return 0;
}
  802cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802cfa:	5b                   	pop    %ebx
  802cfb:	5e                   	pop    %esi
  802cfc:	5d                   	pop    %ebp
  802cfd:	c3                   	ret    

00802cfe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802cfe:	f3 0f 1e fb          	endbr32 
  802d02:	55                   	push   %ebp
  802d03:	89 e5                	mov    %esp,%ebp
  802d05:	53                   	push   %ebx
  802d06:	83 ec 0c             	sub    $0xc,%esp
  802d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802d0c:	53                   	push   %ebx
  802d0d:	6a 00                	push   $0x0
  802d0f:	e8 40 ea ff ff       	call   801754 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802d14:	89 1c 24             	mov    %ebx,(%esp)
  802d17:	e8 28 f0 ff ff       	call   801d44 <fd2data>
  802d1c:	83 c4 08             	add    $0x8,%esp
  802d1f:	50                   	push   %eax
  802d20:	6a 00                	push   $0x0
  802d22:	e8 2d ea ff ff       	call   801754 <sys_page_unmap>
}
  802d27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d2a:	c9                   	leave  
  802d2b:	c3                   	ret    

00802d2c <_pipeisclosed>:
{
  802d2c:	55                   	push   %ebp
  802d2d:	89 e5                	mov    %esp,%ebp
  802d2f:	57                   	push   %edi
  802d30:	56                   	push   %esi
  802d31:	53                   	push   %ebx
  802d32:	83 ec 1c             	sub    $0x1c,%esp
  802d35:	89 c7                	mov    %eax,%edi
  802d37:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802d39:	a1 24 54 80 00       	mov    0x805424,%eax
  802d3e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802d41:	83 ec 0c             	sub    $0xc,%esp
  802d44:	57                   	push   %edi
  802d45:	e8 ce 04 00 00       	call   803218 <pageref>
  802d4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802d4d:	89 34 24             	mov    %esi,(%esp)
  802d50:	e8 c3 04 00 00       	call   803218 <pageref>
		nn = thisenv->env_runs;
  802d55:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802d5b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802d5e:	83 c4 10             	add    $0x10,%esp
  802d61:	39 cb                	cmp    %ecx,%ebx
  802d63:	74 1b                	je     802d80 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802d65:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d68:	75 cf                	jne    802d39 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d6a:	8b 42 58             	mov    0x58(%edx),%eax
  802d6d:	6a 01                	push   $0x1
  802d6f:	50                   	push   %eax
  802d70:	53                   	push   %ebx
  802d71:	68 01 3c 80 00       	push   $0x803c01
  802d76:	e8 0c de ff ff       	call   800b87 <cprintf>
  802d7b:	83 c4 10             	add    $0x10,%esp
  802d7e:	eb b9                	jmp    802d39 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802d80:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d83:	0f 94 c0             	sete   %al
  802d86:	0f b6 c0             	movzbl %al,%eax
}
  802d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d8c:	5b                   	pop    %ebx
  802d8d:	5e                   	pop    %esi
  802d8e:	5f                   	pop    %edi
  802d8f:	5d                   	pop    %ebp
  802d90:	c3                   	ret    

00802d91 <devpipe_write>:
{
  802d91:	f3 0f 1e fb          	endbr32 
  802d95:	55                   	push   %ebp
  802d96:	89 e5                	mov    %esp,%ebp
  802d98:	57                   	push   %edi
  802d99:	56                   	push   %esi
  802d9a:	53                   	push   %ebx
  802d9b:	83 ec 28             	sub    $0x28,%esp
  802d9e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802da1:	56                   	push   %esi
  802da2:	e8 9d ef ff ff       	call   801d44 <fd2data>
  802da7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802da9:	83 c4 10             	add    $0x10,%esp
  802dac:	bf 00 00 00 00       	mov    $0x0,%edi
  802db1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802db4:	74 4f                	je     802e05 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802db6:	8b 43 04             	mov    0x4(%ebx),%eax
  802db9:	8b 0b                	mov    (%ebx),%ecx
  802dbb:	8d 51 20             	lea    0x20(%ecx),%edx
  802dbe:	39 d0                	cmp    %edx,%eax
  802dc0:	72 14                	jb     802dd6 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802dc2:	89 da                	mov    %ebx,%edx
  802dc4:	89 f0                	mov    %esi,%eax
  802dc6:	e8 61 ff ff ff       	call   802d2c <_pipeisclosed>
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	75 3b                	jne    802e0a <devpipe_write+0x79>
			sys_yield();
  802dcf:	e8 d0 e8 ff ff       	call   8016a4 <sys_yield>
  802dd4:	eb e0                	jmp    802db6 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802dd9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802ddd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802de0:	89 c2                	mov    %eax,%edx
  802de2:	c1 fa 1f             	sar    $0x1f,%edx
  802de5:	89 d1                	mov    %edx,%ecx
  802de7:	c1 e9 1b             	shr    $0x1b,%ecx
  802dea:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802ded:	83 e2 1f             	and    $0x1f,%edx
  802df0:	29 ca                	sub    %ecx,%edx
  802df2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802df6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802dfa:	83 c0 01             	add    $0x1,%eax
  802dfd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802e00:	83 c7 01             	add    $0x1,%edi
  802e03:	eb ac                	jmp    802db1 <devpipe_write+0x20>
	return i;
  802e05:	8b 45 10             	mov    0x10(%ebp),%eax
  802e08:	eb 05                	jmp    802e0f <devpipe_write+0x7e>
				return 0;
  802e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e12:	5b                   	pop    %ebx
  802e13:	5e                   	pop    %esi
  802e14:	5f                   	pop    %edi
  802e15:	5d                   	pop    %ebp
  802e16:	c3                   	ret    

00802e17 <devpipe_read>:
{
  802e17:	f3 0f 1e fb          	endbr32 
  802e1b:	55                   	push   %ebp
  802e1c:	89 e5                	mov    %esp,%ebp
  802e1e:	57                   	push   %edi
  802e1f:	56                   	push   %esi
  802e20:	53                   	push   %ebx
  802e21:	83 ec 18             	sub    $0x18,%esp
  802e24:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802e27:	57                   	push   %edi
  802e28:	e8 17 ef ff ff       	call   801d44 <fd2data>
  802e2d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802e2f:	83 c4 10             	add    $0x10,%esp
  802e32:	be 00 00 00 00       	mov    $0x0,%esi
  802e37:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e3a:	75 14                	jne    802e50 <devpipe_read+0x39>
	return i;
  802e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  802e3f:	eb 02                	jmp    802e43 <devpipe_read+0x2c>
				return i;
  802e41:	89 f0                	mov    %esi,%eax
}
  802e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e46:	5b                   	pop    %ebx
  802e47:	5e                   	pop    %esi
  802e48:	5f                   	pop    %edi
  802e49:	5d                   	pop    %ebp
  802e4a:	c3                   	ret    
			sys_yield();
  802e4b:	e8 54 e8 ff ff       	call   8016a4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802e50:	8b 03                	mov    (%ebx),%eax
  802e52:	3b 43 04             	cmp    0x4(%ebx),%eax
  802e55:	75 18                	jne    802e6f <devpipe_read+0x58>
			if (i > 0)
  802e57:	85 f6                	test   %esi,%esi
  802e59:	75 e6                	jne    802e41 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802e5b:	89 da                	mov    %ebx,%edx
  802e5d:	89 f8                	mov    %edi,%eax
  802e5f:	e8 c8 fe ff ff       	call   802d2c <_pipeisclosed>
  802e64:	85 c0                	test   %eax,%eax
  802e66:	74 e3                	je     802e4b <devpipe_read+0x34>
				return 0;
  802e68:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6d:	eb d4                	jmp    802e43 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e6f:	99                   	cltd   
  802e70:	c1 ea 1b             	shr    $0x1b,%edx
  802e73:	01 d0                	add    %edx,%eax
  802e75:	83 e0 1f             	and    $0x1f,%eax
  802e78:	29 d0                	sub    %edx,%eax
  802e7a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e82:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802e85:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802e88:	83 c6 01             	add    $0x1,%esi
  802e8b:	eb aa                	jmp    802e37 <devpipe_read+0x20>

00802e8d <pipe>:
{
  802e8d:	f3 0f 1e fb          	endbr32 
  802e91:	55                   	push   %ebp
  802e92:	89 e5                	mov    %esp,%ebp
  802e94:	56                   	push   %esi
  802e95:	53                   	push   %ebx
  802e96:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e9c:	50                   	push   %eax
  802e9d:	e8 bd ee ff ff       	call   801d5f <fd_alloc>
  802ea2:	89 c3                	mov    %eax,%ebx
  802ea4:	83 c4 10             	add    $0x10,%esp
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	0f 88 23 01 00 00    	js     802fd2 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802eaf:	83 ec 04             	sub    $0x4,%esp
  802eb2:	68 07 04 00 00       	push   $0x407
  802eb7:	ff 75 f4             	pushl  -0xc(%ebp)
  802eba:	6a 00                	push   $0x0
  802ebc:	e8 06 e8 ff ff       	call   8016c7 <sys_page_alloc>
  802ec1:	89 c3                	mov    %eax,%ebx
  802ec3:	83 c4 10             	add    $0x10,%esp
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	0f 88 04 01 00 00    	js     802fd2 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802ece:	83 ec 0c             	sub    $0xc,%esp
  802ed1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ed4:	50                   	push   %eax
  802ed5:	e8 85 ee ff ff       	call   801d5f <fd_alloc>
  802eda:	89 c3                	mov    %eax,%ebx
  802edc:	83 c4 10             	add    $0x10,%esp
  802edf:	85 c0                	test   %eax,%eax
  802ee1:	0f 88 db 00 00 00    	js     802fc2 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 07 04 00 00       	push   $0x407
  802eef:	ff 75 f0             	pushl  -0x10(%ebp)
  802ef2:	6a 00                	push   $0x0
  802ef4:	e8 ce e7 ff ff       	call   8016c7 <sys_page_alloc>
  802ef9:	89 c3                	mov    %eax,%ebx
  802efb:	83 c4 10             	add    $0x10,%esp
  802efe:	85 c0                	test   %eax,%eax
  802f00:	0f 88 bc 00 00 00    	js     802fc2 <pipe+0x135>
	va = fd2data(fd0);
  802f06:	83 ec 0c             	sub    $0xc,%esp
  802f09:	ff 75 f4             	pushl  -0xc(%ebp)
  802f0c:	e8 33 ee ff ff       	call   801d44 <fd2data>
  802f11:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f13:	83 c4 0c             	add    $0xc,%esp
  802f16:	68 07 04 00 00       	push   $0x407
  802f1b:	50                   	push   %eax
  802f1c:	6a 00                	push   $0x0
  802f1e:	e8 a4 e7 ff ff       	call   8016c7 <sys_page_alloc>
  802f23:	89 c3                	mov    %eax,%ebx
  802f25:	83 c4 10             	add    $0x10,%esp
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	0f 88 82 00 00 00    	js     802fb2 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f30:	83 ec 0c             	sub    $0xc,%esp
  802f33:	ff 75 f0             	pushl  -0x10(%ebp)
  802f36:	e8 09 ee ff ff       	call   801d44 <fd2data>
  802f3b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802f42:	50                   	push   %eax
  802f43:	6a 00                	push   $0x0
  802f45:	56                   	push   %esi
  802f46:	6a 00                	push   $0x0
  802f48:	e8 c1 e7 ff ff       	call   80170e <sys_page_map>
  802f4d:	89 c3                	mov    %eax,%ebx
  802f4f:	83 c4 20             	add    $0x20,%esp
  802f52:	85 c0                	test   %eax,%eax
  802f54:	78 4e                	js     802fa4 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802f56:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f63:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f6d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f72:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802f79:	83 ec 0c             	sub    $0xc,%esp
  802f7c:	ff 75 f4             	pushl  -0xc(%ebp)
  802f7f:	e8 ac ed ff ff       	call   801d30 <fd2num>
  802f84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f87:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802f89:	83 c4 04             	add    $0x4,%esp
  802f8c:	ff 75 f0             	pushl  -0x10(%ebp)
  802f8f:	e8 9c ed ff ff       	call   801d30 <fd2num>
  802f94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f97:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802f9a:	83 c4 10             	add    $0x10,%esp
  802f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802fa2:	eb 2e                	jmp    802fd2 <pipe+0x145>
	sys_page_unmap(0, va);
  802fa4:	83 ec 08             	sub    $0x8,%esp
  802fa7:	56                   	push   %esi
  802fa8:	6a 00                	push   $0x0
  802faa:	e8 a5 e7 ff ff       	call   801754 <sys_page_unmap>
  802faf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802fb2:	83 ec 08             	sub    $0x8,%esp
  802fb5:	ff 75 f0             	pushl  -0x10(%ebp)
  802fb8:	6a 00                	push   $0x0
  802fba:	e8 95 e7 ff ff       	call   801754 <sys_page_unmap>
  802fbf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802fc2:	83 ec 08             	sub    $0x8,%esp
  802fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  802fc8:	6a 00                	push   $0x0
  802fca:	e8 85 e7 ff ff       	call   801754 <sys_page_unmap>
  802fcf:	83 c4 10             	add    $0x10,%esp
}
  802fd2:	89 d8                	mov    %ebx,%eax
  802fd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802fd7:	5b                   	pop    %ebx
  802fd8:	5e                   	pop    %esi
  802fd9:	5d                   	pop    %ebp
  802fda:	c3                   	ret    

00802fdb <pipeisclosed>:
{
  802fdb:	f3 0f 1e fb          	endbr32 
  802fdf:	55                   	push   %ebp
  802fe0:	89 e5                	mov    %esp,%ebp
  802fe2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fe5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fe8:	50                   	push   %eax
  802fe9:	ff 75 08             	pushl  0x8(%ebp)
  802fec:	e8 c4 ed ff ff       	call   801db5 <fd_lookup>
  802ff1:	83 c4 10             	add    $0x10,%esp
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	78 18                	js     803010 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802ff8:	83 ec 0c             	sub    $0xc,%esp
  802ffb:	ff 75 f4             	pushl  -0xc(%ebp)
  802ffe:	e8 41 ed ff ff       	call   801d44 <fd2data>
  803003:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	e8 1f fd ff ff       	call   802d2c <_pipeisclosed>
  80300d:	83 c4 10             	add    $0x10,%esp
}
  803010:	c9                   	leave  
  803011:	c3                   	ret    

00803012 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803012:	f3 0f 1e fb          	endbr32 
  803016:	55                   	push   %ebp
  803017:	89 e5                	mov    %esp,%ebp
  803019:	56                   	push   %esi
  80301a:	53                   	push   %ebx
  80301b:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80301e:	85 f6                	test   %esi,%esi
  803020:	74 13                	je     803035 <wait+0x23>
	e = &envs[ENVX(envid)];
  803022:	89 f3                	mov    %esi,%ebx
  803024:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80302a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80302d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803033:	eb 1b                	jmp    803050 <wait+0x3e>
	assert(envid != 0);
  803035:	68 19 3c 80 00       	push   $0x803c19
  80303a:	68 07 36 80 00       	push   $0x803607
  80303f:	6a 09                	push   $0x9
  803041:	68 24 3c 80 00       	push   $0x803c24
  803046:	e8 55 da ff ff       	call   800aa0 <_panic>
		sys_yield();
  80304b:	e8 54 e6 ff ff       	call   8016a4 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803050:	8b 43 48             	mov    0x48(%ebx),%eax
  803053:	39 f0                	cmp    %esi,%eax
  803055:	75 07                	jne    80305e <wait+0x4c>
  803057:	8b 43 54             	mov    0x54(%ebx),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	75 ed                	jne    80304b <wait+0x39>
}
  80305e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803061:	5b                   	pop    %ebx
  803062:	5e                   	pop    %esi
  803063:	5d                   	pop    %ebp
  803064:	c3                   	ret    

00803065 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803065:	f3 0f 1e fb          	endbr32 
  803069:	55                   	push   %ebp
  80306a:	89 e5                	mov    %esp,%ebp
  80306c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80306f:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  803076:	74 0a                	je     803082 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	a3 00 70 80 00       	mov    %eax,0x807000
}
  803080:	c9                   	leave  
  803081:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  803082:	83 ec 04             	sub    $0x4,%esp
  803085:	6a 07                	push   $0x7
  803087:	68 00 f0 bf ee       	push   $0xeebff000
  80308c:	6a 00                	push   $0x0
  80308e:	e8 34 e6 ff ff       	call   8016c7 <sys_page_alloc>
  803093:	83 c4 10             	add    $0x10,%esp
  803096:	85 c0                	test   %eax,%eax
  803098:	78 2a                	js     8030c4 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  80309a:	83 ec 08             	sub    $0x8,%esp
  80309d:	68 d8 30 80 00       	push   $0x8030d8
  8030a2:	6a 00                	push   $0x0
  8030a4:	e8 7d e7 ff ff       	call   801826 <sys_env_set_pgfault_upcall>
  8030a9:	83 c4 10             	add    $0x10,%esp
  8030ac:	85 c0                	test   %eax,%eax
  8030ae:	79 c8                	jns    803078 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8030b0:	83 ec 04             	sub    $0x4,%esp
  8030b3:	68 5c 3c 80 00       	push   $0x803c5c
  8030b8:	6a 25                	push   $0x25
  8030ba:	68 94 3c 80 00       	push   $0x803c94
  8030bf:	e8 dc d9 ff ff       	call   800aa0 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8030c4:	83 ec 04             	sub    $0x4,%esp
  8030c7:	68 30 3c 80 00       	push   $0x803c30
  8030cc:	6a 22                	push   $0x22
  8030ce:	68 94 3c 80 00       	push   $0x803c94
  8030d3:	e8 c8 d9 ff ff       	call   800aa0 <_panic>

008030d8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8030d8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8030d9:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8030de:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8030e0:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8030e3:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8030e7:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8030eb:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8030ee:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8030f0:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8030f4:	83 c4 08             	add    $0x8,%esp
	popal
  8030f7:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8030f8:	83 c4 04             	add    $0x4,%esp
	popfl
  8030fb:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8030fc:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8030fd:	c3                   	ret    

008030fe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8030fe:	f3 0f 1e fb          	endbr32 
  803102:	55                   	push   %ebp
  803103:	89 e5                	mov    %esp,%ebp
  803105:	56                   	push   %esi
  803106:	53                   	push   %ebx
  803107:	8b 75 08             	mov    0x8(%ebp),%esi
  80310a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  803110:	85 c0                	test   %eax,%eax
  803112:	74 3d                	je     803151 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  803114:	83 ec 0c             	sub    $0xc,%esp
  803117:	50                   	push   %eax
  803118:	e8 76 e7 ff ff       	call   801893 <sys_ipc_recv>
  80311d:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  803120:	85 f6                	test   %esi,%esi
  803122:	74 0b                	je     80312f <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  803124:	8b 15 24 54 80 00    	mov    0x805424,%edx
  80312a:	8b 52 74             	mov    0x74(%edx),%edx
  80312d:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80312f:	85 db                	test   %ebx,%ebx
  803131:	74 0b                	je     80313e <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  803133:	8b 15 24 54 80 00    	mov    0x805424,%edx
  803139:	8b 52 78             	mov    0x78(%edx),%edx
  80313c:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80313e:	85 c0                	test   %eax,%eax
  803140:	78 21                	js     803163 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  803142:	a1 24 54 80 00       	mov    0x805424,%eax
  803147:	8b 40 70             	mov    0x70(%eax),%eax
}
  80314a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80314d:	5b                   	pop    %ebx
  80314e:	5e                   	pop    %esi
  80314f:	5d                   	pop    %ebp
  803150:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  803151:	83 ec 0c             	sub    $0xc,%esp
  803154:	68 00 00 c0 ee       	push   $0xeec00000
  803159:	e8 35 e7 ff ff       	call   801893 <sys_ipc_recv>
  80315e:	83 c4 10             	add    $0x10,%esp
  803161:	eb bd                	jmp    803120 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  803163:	85 f6                	test   %esi,%esi
  803165:	74 10                	je     803177 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  803167:	85 db                	test   %ebx,%ebx
  803169:	75 df                	jne    80314a <ipc_recv+0x4c>
  80316b:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  803172:	00 00 00 
  803175:	eb d3                	jmp    80314a <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  803177:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80317e:	00 00 00 
  803181:	eb e4                	jmp    803167 <ipc_recv+0x69>

00803183 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803183:	f3 0f 1e fb          	endbr32 
  803187:	55                   	push   %ebp
  803188:	89 e5                	mov    %esp,%ebp
  80318a:	57                   	push   %edi
  80318b:	56                   	push   %esi
  80318c:	53                   	push   %ebx
  80318d:	83 ec 0c             	sub    $0xc,%esp
  803190:	8b 7d 08             	mov    0x8(%ebp),%edi
  803193:	8b 75 0c             	mov    0xc(%ebp),%esi
  803196:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  803199:	85 db                	test   %ebx,%ebx
  80319b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8031a0:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8031a3:	ff 75 14             	pushl  0x14(%ebp)
  8031a6:	53                   	push   %ebx
  8031a7:	56                   	push   %esi
  8031a8:	57                   	push   %edi
  8031a9:	e8 be e6 ff ff       	call   80186c <sys_ipc_try_send>
  8031ae:	83 c4 10             	add    $0x10,%esp
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	79 1e                	jns    8031d3 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8031b5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8031b8:	75 07                	jne    8031c1 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8031ba:	e8 e5 e4 ff ff       	call   8016a4 <sys_yield>
  8031bf:	eb e2                	jmp    8031a3 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8031c1:	50                   	push   %eax
  8031c2:	68 a2 3c 80 00       	push   $0x803ca2
  8031c7:	6a 59                	push   $0x59
  8031c9:	68 bd 3c 80 00       	push   $0x803cbd
  8031ce:	e8 cd d8 ff ff       	call   800aa0 <_panic>
	}
}
  8031d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8031d6:	5b                   	pop    %ebx
  8031d7:	5e                   	pop    %esi
  8031d8:	5f                   	pop    %edi
  8031d9:	5d                   	pop    %ebp
  8031da:	c3                   	ret    

008031db <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8031db:	f3 0f 1e fb          	endbr32 
  8031df:	55                   	push   %ebp
  8031e0:	89 e5                	mov    %esp,%ebp
  8031e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8031e5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8031ea:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8031ed:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8031f3:	8b 52 50             	mov    0x50(%edx),%edx
  8031f6:	39 ca                	cmp    %ecx,%edx
  8031f8:	74 11                	je     80320b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8031fa:	83 c0 01             	add    $0x1,%eax
  8031fd:	3d 00 04 00 00       	cmp    $0x400,%eax
  803202:	75 e6                	jne    8031ea <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  803204:	b8 00 00 00 00       	mov    $0x0,%eax
  803209:	eb 0b                	jmp    803216 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80320b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80320e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803213:	8b 40 48             	mov    0x48(%eax),%eax
}
  803216:	5d                   	pop    %ebp
  803217:	c3                   	ret    

00803218 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803218:	f3 0f 1e fb          	endbr32 
  80321c:	55                   	push   %ebp
  80321d:	89 e5                	mov    %esp,%ebp
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803222:	89 c2                	mov    %eax,%edx
  803224:	c1 ea 16             	shr    $0x16,%edx
  803227:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80322e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  803233:	f6 c1 01             	test   $0x1,%cl
  803236:	74 1c                	je     803254 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  803238:	c1 e8 0c             	shr    $0xc,%eax
  80323b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803242:	a8 01                	test   $0x1,%al
  803244:	74 0e                	je     803254 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803246:	c1 e8 0c             	shr    $0xc,%eax
  803249:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  803250:	ef 
  803251:	0f b7 d2             	movzwl %dx,%edx
}
  803254:	89 d0                	mov    %edx,%eax
  803256:	5d                   	pop    %ebp
  803257:	c3                   	ret    
  803258:	66 90                	xchg   %ax,%ax
  80325a:	66 90                	xchg   %ax,%ax
  80325c:	66 90                	xchg   %ax,%ax
  80325e:	66 90                	xchg   %ax,%ax

00803260 <__udivdi3>:
  803260:	f3 0f 1e fb          	endbr32 
  803264:	55                   	push   %ebp
  803265:	57                   	push   %edi
  803266:	56                   	push   %esi
  803267:	53                   	push   %ebx
  803268:	83 ec 1c             	sub    $0x1c,%esp
  80326b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80326f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803273:	8b 74 24 34          	mov    0x34(%esp),%esi
  803277:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80327b:	85 d2                	test   %edx,%edx
  80327d:	75 19                	jne    803298 <__udivdi3+0x38>
  80327f:	39 f3                	cmp    %esi,%ebx
  803281:	76 4d                	jbe    8032d0 <__udivdi3+0x70>
  803283:	31 ff                	xor    %edi,%edi
  803285:	89 e8                	mov    %ebp,%eax
  803287:	89 f2                	mov    %esi,%edx
  803289:	f7 f3                	div    %ebx
  80328b:	89 fa                	mov    %edi,%edx
  80328d:	83 c4 1c             	add    $0x1c,%esp
  803290:	5b                   	pop    %ebx
  803291:	5e                   	pop    %esi
  803292:	5f                   	pop    %edi
  803293:	5d                   	pop    %ebp
  803294:	c3                   	ret    
  803295:	8d 76 00             	lea    0x0(%esi),%esi
  803298:	39 f2                	cmp    %esi,%edx
  80329a:	76 14                	jbe    8032b0 <__udivdi3+0x50>
  80329c:	31 ff                	xor    %edi,%edi
  80329e:	31 c0                	xor    %eax,%eax
  8032a0:	89 fa                	mov    %edi,%edx
  8032a2:	83 c4 1c             	add    $0x1c,%esp
  8032a5:	5b                   	pop    %ebx
  8032a6:	5e                   	pop    %esi
  8032a7:	5f                   	pop    %edi
  8032a8:	5d                   	pop    %ebp
  8032a9:	c3                   	ret    
  8032aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8032b0:	0f bd fa             	bsr    %edx,%edi
  8032b3:	83 f7 1f             	xor    $0x1f,%edi
  8032b6:	75 48                	jne    803300 <__udivdi3+0xa0>
  8032b8:	39 f2                	cmp    %esi,%edx
  8032ba:	72 06                	jb     8032c2 <__udivdi3+0x62>
  8032bc:	31 c0                	xor    %eax,%eax
  8032be:	39 eb                	cmp    %ebp,%ebx
  8032c0:	77 de                	ja     8032a0 <__udivdi3+0x40>
  8032c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c7:	eb d7                	jmp    8032a0 <__udivdi3+0x40>
  8032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032d0:	89 d9                	mov    %ebx,%ecx
  8032d2:	85 db                	test   %ebx,%ebx
  8032d4:	75 0b                	jne    8032e1 <__udivdi3+0x81>
  8032d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032db:	31 d2                	xor    %edx,%edx
  8032dd:	f7 f3                	div    %ebx
  8032df:	89 c1                	mov    %eax,%ecx
  8032e1:	31 d2                	xor    %edx,%edx
  8032e3:	89 f0                	mov    %esi,%eax
  8032e5:	f7 f1                	div    %ecx
  8032e7:	89 c6                	mov    %eax,%esi
  8032e9:	89 e8                	mov    %ebp,%eax
  8032eb:	89 f7                	mov    %esi,%edi
  8032ed:	f7 f1                	div    %ecx
  8032ef:	89 fa                	mov    %edi,%edx
  8032f1:	83 c4 1c             	add    $0x1c,%esp
  8032f4:	5b                   	pop    %ebx
  8032f5:	5e                   	pop    %esi
  8032f6:	5f                   	pop    %edi
  8032f7:	5d                   	pop    %ebp
  8032f8:	c3                   	ret    
  8032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803300:	89 f9                	mov    %edi,%ecx
  803302:	b8 20 00 00 00       	mov    $0x20,%eax
  803307:	29 f8                	sub    %edi,%eax
  803309:	d3 e2                	shl    %cl,%edx
  80330b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80330f:	89 c1                	mov    %eax,%ecx
  803311:	89 da                	mov    %ebx,%edx
  803313:	d3 ea                	shr    %cl,%edx
  803315:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803319:	09 d1                	or     %edx,%ecx
  80331b:	89 f2                	mov    %esi,%edx
  80331d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803321:	89 f9                	mov    %edi,%ecx
  803323:	d3 e3                	shl    %cl,%ebx
  803325:	89 c1                	mov    %eax,%ecx
  803327:	d3 ea                	shr    %cl,%edx
  803329:	89 f9                	mov    %edi,%ecx
  80332b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80332f:	89 eb                	mov    %ebp,%ebx
  803331:	d3 e6                	shl    %cl,%esi
  803333:	89 c1                	mov    %eax,%ecx
  803335:	d3 eb                	shr    %cl,%ebx
  803337:	09 de                	or     %ebx,%esi
  803339:	89 f0                	mov    %esi,%eax
  80333b:	f7 74 24 08          	divl   0x8(%esp)
  80333f:	89 d6                	mov    %edx,%esi
  803341:	89 c3                	mov    %eax,%ebx
  803343:	f7 64 24 0c          	mull   0xc(%esp)
  803347:	39 d6                	cmp    %edx,%esi
  803349:	72 15                	jb     803360 <__udivdi3+0x100>
  80334b:	89 f9                	mov    %edi,%ecx
  80334d:	d3 e5                	shl    %cl,%ebp
  80334f:	39 c5                	cmp    %eax,%ebp
  803351:	73 04                	jae    803357 <__udivdi3+0xf7>
  803353:	39 d6                	cmp    %edx,%esi
  803355:	74 09                	je     803360 <__udivdi3+0x100>
  803357:	89 d8                	mov    %ebx,%eax
  803359:	31 ff                	xor    %edi,%edi
  80335b:	e9 40 ff ff ff       	jmp    8032a0 <__udivdi3+0x40>
  803360:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803363:	31 ff                	xor    %edi,%edi
  803365:	e9 36 ff ff ff       	jmp    8032a0 <__udivdi3+0x40>
  80336a:	66 90                	xchg   %ax,%ax
  80336c:	66 90                	xchg   %ax,%ax
  80336e:	66 90                	xchg   %ax,%ax

00803370 <__umoddi3>:
  803370:	f3 0f 1e fb          	endbr32 
  803374:	55                   	push   %ebp
  803375:	57                   	push   %edi
  803376:	56                   	push   %esi
  803377:	53                   	push   %ebx
  803378:	83 ec 1c             	sub    $0x1c,%esp
  80337b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80337f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803383:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803387:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80338b:	85 c0                	test   %eax,%eax
  80338d:	75 19                	jne    8033a8 <__umoddi3+0x38>
  80338f:	39 df                	cmp    %ebx,%edi
  803391:	76 5d                	jbe    8033f0 <__umoddi3+0x80>
  803393:	89 f0                	mov    %esi,%eax
  803395:	89 da                	mov    %ebx,%edx
  803397:	f7 f7                	div    %edi
  803399:	89 d0                	mov    %edx,%eax
  80339b:	31 d2                	xor    %edx,%edx
  80339d:	83 c4 1c             	add    $0x1c,%esp
  8033a0:	5b                   	pop    %ebx
  8033a1:	5e                   	pop    %esi
  8033a2:	5f                   	pop    %edi
  8033a3:	5d                   	pop    %ebp
  8033a4:	c3                   	ret    
  8033a5:	8d 76 00             	lea    0x0(%esi),%esi
  8033a8:	89 f2                	mov    %esi,%edx
  8033aa:	39 d8                	cmp    %ebx,%eax
  8033ac:	76 12                	jbe    8033c0 <__umoddi3+0x50>
  8033ae:	89 f0                	mov    %esi,%eax
  8033b0:	89 da                	mov    %ebx,%edx
  8033b2:	83 c4 1c             	add    $0x1c,%esp
  8033b5:	5b                   	pop    %ebx
  8033b6:	5e                   	pop    %esi
  8033b7:	5f                   	pop    %edi
  8033b8:	5d                   	pop    %ebp
  8033b9:	c3                   	ret    
  8033ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8033c0:	0f bd e8             	bsr    %eax,%ebp
  8033c3:	83 f5 1f             	xor    $0x1f,%ebp
  8033c6:	75 50                	jne    803418 <__umoddi3+0xa8>
  8033c8:	39 d8                	cmp    %ebx,%eax
  8033ca:	0f 82 e0 00 00 00    	jb     8034b0 <__umoddi3+0x140>
  8033d0:	89 d9                	mov    %ebx,%ecx
  8033d2:	39 f7                	cmp    %esi,%edi
  8033d4:	0f 86 d6 00 00 00    	jbe    8034b0 <__umoddi3+0x140>
  8033da:	89 d0                	mov    %edx,%eax
  8033dc:	89 ca                	mov    %ecx,%edx
  8033de:	83 c4 1c             	add    $0x1c,%esp
  8033e1:	5b                   	pop    %ebx
  8033e2:	5e                   	pop    %esi
  8033e3:	5f                   	pop    %edi
  8033e4:	5d                   	pop    %ebp
  8033e5:	c3                   	ret    
  8033e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8033ed:	8d 76 00             	lea    0x0(%esi),%esi
  8033f0:	89 fd                	mov    %edi,%ebp
  8033f2:	85 ff                	test   %edi,%edi
  8033f4:	75 0b                	jne    803401 <__umoddi3+0x91>
  8033f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033fb:	31 d2                	xor    %edx,%edx
  8033fd:	f7 f7                	div    %edi
  8033ff:	89 c5                	mov    %eax,%ebp
  803401:	89 d8                	mov    %ebx,%eax
  803403:	31 d2                	xor    %edx,%edx
  803405:	f7 f5                	div    %ebp
  803407:	89 f0                	mov    %esi,%eax
  803409:	f7 f5                	div    %ebp
  80340b:	89 d0                	mov    %edx,%eax
  80340d:	31 d2                	xor    %edx,%edx
  80340f:	eb 8c                	jmp    80339d <__umoddi3+0x2d>
  803411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803418:	89 e9                	mov    %ebp,%ecx
  80341a:	ba 20 00 00 00       	mov    $0x20,%edx
  80341f:	29 ea                	sub    %ebp,%edx
  803421:	d3 e0                	shl    %cl,%eax
  803423:	89 44 24 08          	mov    %eax,0x8(%esp)
  803427:	89 d1                	mov    %edx,%ecx
  803429:	89 f8                	mov    %edi,%eax
  80342b:	d3 e8                	shr    %cl,%eax
  80342d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803431:	89 54 24 04          	mov    %edx,0x4(%esp)
  803435:	8b 54 24 04          	mov    0x4(%esp),%edx
  803439:	09 c1                	or     %eax,%ecx
  80343b:	89 d8                	mov    %ebx,%eax
  80343d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803441:	89 e9                	mov    %ebp,%ecx
  803443:	d3 e7                	shl    %cl,%edi
  803445:	89 d1                	mov    %edx,%ecx
  803447:	d3 e8                	shr    %cl,%eax
  803449:	89 e9                	mov    %ebp,%ecx
  80344b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80344f:	d3 e3                	shl    %cl,%ebx
  803451:	89 c7                	mov    %eax,%edi
  803453:	89 d1                	mov    %edx,%ecx
  803455:	89 f0                	mov    %esi,%eax
  803457:	d3 e8                	shr    %cl,%eax
  803459:	89 e9                	mov    %ebp,%ecx
  80345b:	89 fa                	mov    %edi,%edx
  80345d:	d3 e6                	shl    %cl,%esi
  80345f:	09 d8                	or     %ebx,%eax
  803461:	f7 74 24 08          	divl   0x8(%esp)
  803465:	89 d1                	mov    %edx,%ecx
  803467:	89 f3                	mov    %esi,%ebx
  803469:	f7 64 24 0c          	mull   0xc(%esp)
  80346d:	89 c6                	mov    %eax,%esi
  80346f:	89 d7                	mov    %edx,%edi
  803471:	39 d1                	cmp    %edx,%ecx
  803473:	72 06                	jb     80347b <__umoddi3+0x10b>
  803475:	75 10                	jne    803487 <__umoddi3+0x117>
  803477:	39 c3                	cmp    %eax,%ebx
  803479:	73 0c                	jae    803487 <__umoddi3+0x117>
  80347b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80347f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803483:	89 d7                	mov    %edx,%edi
  803485:	89 c6                	mov    %eax,%esi
  803487:	89 ca                	mov    %ecx,%edx
  803489:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80348e:	29 f3                	sub    %esi,%ebx
  803490:	19 fa                	sbb    %edi,%edx
  803492:	89 d0                	mov    %edx,%eax
  803494:	d3 e0                	shl    %cl,%eax
  803496:	89 e9                	mov    %ebp,%ecx
  803498:	d3 eb                	shr    %cl,%ebx
  80349a:	d3 ea                	shr    %cl,%edx
  80349c:	09 d8                	or     %ebx,%eax
  80349e:	83 c4 1c             	add    $0x1c,%esp
  8034a1:	5b                   	pop    %ebx
  8034a2:	5e                   	pop    %esi
  8034a3:	5f                   	pop    %edi
  8034a4:	5d                   	pop    %ebp
  8034a5:	c3                   	ret    
  8034a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8034ad:	8d 76 00             	lea    0x0(%esi),%esi
  8034b0:	29 fe                	sub    %edi,%esi
  8034b2:	19 c3                	sbb    %eax,%ebx
  8034b4:	89 f2                	mov    %esi,%edx
  8034b6:	89 d9                	mov    %ebx,%ecx
  8034b8:	e9 1d ff ff ff       	jmp    8033da <__umoddi3+0x6a>
