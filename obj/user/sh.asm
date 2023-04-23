
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
  80004a:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
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
  800069:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800070:	7e 59                	jle    8000cb <_gettoken+0x98>
			cprintf("GETTOKEN NULL\n");
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	68 40 3a 80 00       	push   $0x803a40
  80007a:	e8 08 0b 00 00       	call   800b87 <cprintf>
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	eb 47                	jmp    8000cb <_gettoken+0x98>
		cprintf("GETTOKEN: %s\n", s);
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	53                   	push   %ebx
  800088:	68 4f 3a 80 00       	push   $0x803a4f
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
  8000a5:	68 5d 3a 80 00       	push   $0x803a5d
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
  8000c2:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
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
  8000d8:	68 62 3a 80 00       	push   $0x803a62
  8000dd:	e8 a5 0a 00 00       	call   800b87 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb e4                	jmp    8000cb <_gettoken+0x98>
	if (strchr(SYMBOLS, *s)) {
  8000e7:	83 ec 08             	sub    $0x8,%esp
  8000ea:	0f be c0             	movsbl %al,%eax
  8000ed:	50                   	push   %eax
  8000ee:	68 73 3a 80 00       	push   $0x803a73
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
  80010f:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800116:	7e b3                	jle    8000cb <_gettoken+0x98>
			cprintf("TOK %c\n", t);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	56                   	push   %esi
  80011c:	68 67 3a 80 00       	push   $0x803a67
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
  800140:	68 6f 3a 80 00       	push   $0x803a6f
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
  80015b:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800162:	0f 8e 63 ff ff ff    	jle    8000cb <_gettoken+0x98>
		t = **p2;
  800168:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  80016b:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 37                	pushl  (%edi)
  800173:	68 7b 3a 80 00       	push   $0x803a7b
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
  8001a7:	68 0c 60 80 00       	push   $0x80600c
  8001ac:	68 10 60 80 00       	push   $0x806010
  8001b1:	50                   	push   %eax
  8001b2:	e8 7c fe ff ff       	call   800033 <_gettoken>
  8001b7:	a3 08 60 80 00       	mov    %eax,0x806008
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
  8001c6:	a1 08 60 80 00       	mov    0x806008,%eax
  8001cb:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001d0:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 0c 60 80 00       	push   $0x80600c
  8001e3:	68 10 60 80 00       	push   $0x806010
  8001e8:	ff 35 0c 60 80 00    	pushl  0x80600c
  8001ee:	e8 40 fe ff ff       	call   800033 <_gettoken>
  8001f3:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  8001f8:	a1 04 60 80 00       	mov    0x806004,%eax
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
  800272:	e8 0a 23 00 00       	call   802581 <open>
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
  80028c:	e8 6b 1d 00 00       	call   801ffc <dup>
				close(fd);
  800291:	89 1c 24             	mov    %ebx,(%esp)
  800294:	e8 09 1d 00 00       	call   801fa2 <close>
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
  8002b6:	e8 3e 31 00 00       	call   8033f9 <pipe>
  8002bb:	83 c4 10             	add    $0x10,%esp
  8002be:	85 c0                	test   %eax,%eax
  8002c0:	0f 88 28 01 00 00    	js     8003ee <runcmd+0x1ec>
			if (debug)
  8002c6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8002cd:	0f 85 36 01 00 00    	jne    800409 <runcmd+0x207>
			if ((r = fork()) < 0) {
  8002d3:	e8 8f 17 00 00       	call   801a67 <fork>
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
  8002ff:	e8 9e 1c 00 00       	call   801fa2 <close>
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
  800323:	68 85 3a 80 00       	push   $0x803a85
  800328:	e8 5a 08 00 00       	call   800b87 <cprintf>
				exit();
  80032d:	e8 50 07 00 00       	call   800a82 <exit>
  800332:	83 c4 10             	add    $0x10,%esp
  800335:	eb da                	jmp    800311 <runcmd+0x10f>
				cprintf("syntax error: < not followed by word\n");
  800337:	83 ec 0c             	sub    $0xc,%esp
  80033a:	68 d0 3b 80 00       	push   $0x803bd0
  80033f:	e8 43 08 00 00       	call   800b87 <cprintf>
				exit();
  800344:	e8 39 07 00 00       	call   800a82 <exit>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	e9 19 ff ff ff       	jmp    80026a <runcmd+0x68>
				cprintf("case <:open err - %e\n", fd);
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	50                   	push   %eax
  800355:	68 99 3a 80 00       	push   $0x803a99
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
  80038a:	e8 f2 21 00 00       	call   802581 <open>
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
  8003a6:	68 f8 3b 80 00       	push   $0x803bf8
  8003ab:	e8 d7 07 00 00       	call   800b87 <cprintf>
				exit();
  8003b0:	e8 cd 06 00 00       	call   800a82 <exit>
  8003b5:	83 c4 10             	add    $0x10,%esp
  8003b8:	eb c5                	jmp    80037f <runcmd+0x17d>
				cprintf("open %s for write: %e", t, fd);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	50                   	push   %eax
  8003be:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003c1:	68 af 3a 80 00       	push   $0x803aaf
  8003c6:	e8 bc 07 00 00       	call   800b87 <cprintf>
				exit();
  8003cb:	e8 b2 06 00 00       	call   800a82 <exit>
  8003d0:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	6a 01                	push   $0x1
  8003d8:	53                   	push   %ebx
  8003d9:	e8 1e 1c 00 00       	call   801ffc <dup>
				close(fd);
  8003de:	89 1c 24             	mov    %ebx,(%esp)
  8003e1:	e8 bc 1b 00 00       	call   801fa2 <close>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	e9 39 fe ff ff       	jmp    800227 <runcmd+0x25>
				cprintf("pipe: %e", r);
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	50                   	push   %eax
  8003f2:	68 c5 3a 80 00       	push   $0x803ac5
  8003f7:	e8 8b 07 00 00       	call   800b87 <cprintf>
				exit();
  8003fc:	e8 81 06 00 00       	call   800a82 <exit>
  800401:	83 c4 10             	add    $0x10,%esp
  800404:	e9 bd fe ff ff       	jmp    8002c6 <runcmd+0xc4>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800412:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800418:	68 ce 3a 80 00       	push   $0x803ace
  80041d:	e8 65 07 00 00       	call   800b87 <cprintf>
  800422:	83 c4 10             	add    $0x10,%esp
  800425:	e9 a9 fe ff ff       	jmp    8002d3 <runcmd+0xd1>
				cprintf("fork: %e", r);
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	50                   	push   %eax
  80042e:	68 f5 3f 80 00       	push   $0x803ff5
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
  800458:	e8 45 1b 00 00       	call   801fa2 <close>
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
  80047c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800483:	0f 85 08 01 00 00    	jne    800591 <runcmd+0x38f>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	8d 45 a8             	lea    -0x58(%ebp),%eax
  80048f:	50                   	push   %eax
  800490:	ff 75 a8             	pushl  -0x58(%ebp)
  800493:	e8 ba 22 00 00       	call   802752 <spawn>
  800498:	89 c6                	mov    %eax,%esi
  80049a:	83 c4 10             	add    $0x10,%esp
  80049d:	85 c0                	test   %eax,%eax
  80049f:	0f 88 3a 01 00 00    	js     8005df <runcmd+0x3dd>
	close_all();
  8004a5:	e8 29 1b 00 00       	call   801fd3 <close_all>
		if (debug)
  8004aa:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004b1:	0f 85 75 01 00 00    	jne    80062c <runcmd+0x42a>
		wait(r);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	56                   	push   %esi
  8004bb:	e8 be 30 00 00       	call   80357e <wait>
		if (debug)
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004ca:	0f 85 7b 01 00 00    	jne    80064b <runcmd+0x449>
	if (pipe_child) {
  8004d0:	85 db                	test   %ebx,%ebx
  8004d2:	74 19                	je     8004ed <runcmd+0x2eb>
		wait(pipe_child);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	53                   	push   %ebx
  8004d8:	e8 a1 30 00 00       	call   80357e <wait>
		if (debug)
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
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
  800500:	e8 f7 1a 00 00       	call   801ffc <dup>
					close(p[0]);
  800505:	83 c4 04             	add    $0x4,%esp
  800508:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80050e:	e8 8f 1a 00 00       	call   801fa2 <close>
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	e9 db fd ff ff       	jmp    8002f6 <runcmd+0xf4>
					dup(p[1], 1);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	6a 01                	push   $0x1
  800520:	50                   	push   %eax
  800521:	e8 d6 1a 00 00       	call   801ffc <dup>
					close(p[1]);
  800526:	83 c4 04             	add    $0x4,%esp
  800529:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80052f:	e8 6e 1a 00 00       	call   801fa2 <close>
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	e9 13 ff ff ff       	jmp    80044f <runcmd+0x24d>
			panic("bad return %d from gettoken", c);
  80053c:	53                   	push   %ebx
  80053d:	68 db 3a 80 00       	push   $0x803adb
  800542:	6a 7c                	push   $0x7c
  800544:	68 f7 3a 80 00       	push   $0x803af7
  800549:	e8 52 05 00 00       	call   800aa0 <_panic>
		if (debug)
  80054e:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800555:	74 9b                	je     8004f2 <runcmd+0x2f0>
			cprintf("EMPTY COMMAND\n");
  800557:	83 ec 0c             	sub    $0xc,%esp
  80055a:	68 01 3b 80 00       	push   $0x803b01
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
  800591:	a1 28 64 80 00       	mov    0x806428,%eax
  800596:	8b 40 48             	mov    0x48(%eax),%eax
  800599:	83 ec 08             	sub    $0x8,%esp
  80059c:	50                   	push   %eax
  80059d:	68 10 3b 80 00       	push   $0x803b10
  8005a2:	e8 e0 05 00 00       	call   800b87 <cprintf>
  8005a7:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	eb 11                	jmp    8005c0 <runcmd+0x3be>
			cprintf(" %s", argv[i]);
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	50                   	push   %eax
  8005b3:	68 98 3b 80 00       	push   $0x803b98
  8005b8:	e8 ca 05 00 00       	call   800b87 <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
  8005c0:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005c3:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	75 e5                	jne    8005af <runcmd+0x3ad>
		cprintf("\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 60 3a 80 00       	push   $0x803a60
  8005d2:	e8 b0 05 00 00       	call   800b87 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	e9 aa fe ff ff       	jmp    800489 <runcmd+0x287>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	50                   	push   %eax
  8005e3:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e6:	68 1e 3b 80 00       	push   $0x803b1e
  8005eb:	e8 97 05 00 00       	call   800b87 <cprintf>
	close_all();
  8005f0:	e8 de 19 00 00       	call   801fd3 <close_all>
  8005f5:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005f8:	85 db                	test   %ebx,%ebx
  8005fa:	0f 84 ed fe ff ff    	je     8004ed <runcmd+0x2eb>
		if (debug)
  800600:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800607:	0f 84 c7 fe ff ff    	je     8004d4 <runcmd+0x2d2>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  80060d:	a1 28 64 80 00       	mov    0x806428,%eax
  800612:	8b 40 48             	mov    0x48(%eax),%eax
  800615:	83 ec 04             	sub    $0x4,%esp
  800618:	53                   	push   %ebx
  800619:	50                   	push   %eax
  80061a:	68 57 3b 80 00       	push   $0x803b57
  80061f:	e8 63 05 00 00       	call   800b87 <cprintf>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	e9 a8 fe ff ff       	jmp    8004d4 <runcmd+0x2d2>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  80062c:	a1 28 64 80 00       	mov    0x806428,%eax
  800631:	8b 40 48             	mov    0x48(%eax),%eax
  800634:	56                   	push   %esi
  800635:	ff 75 a8             	pushl  -0x58(%ebp)
  800638:	50                   	push   %eax
  800639:	68 2c 3b 80 00       	push   $0x803b2c
  80063e:	e8 44 05 00 00       	call   800b87 <cprintf>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	e9 6c fe ff ff       	jmp    8004b7 <runcmd+0x2b5>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80064b:	a1 28 64 80 00       	mov    0x806428,%eax
  800650:	8b 40 48             	mov    0x48(%eax),%eax
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	50                   	push   %eax
  800657:	68 41 3b 80 00       	push   $0x803b41
  80065c:	e8 26 05 00 00       	call   800b87 <cprintf>
  800661:	83 c4 10             	add    $0x10,%esp
  800664:	eb 92                	jmp    8005f8 <runcmd+0x3f6>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800666:	a1 28 64 80 00       	mov    0x806428,%eax
  80066b:	8b 40 48             	mov    0x48(%eax),%eax
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	50                   	push   %eax
  800672:	68 41 3b 80 00       	push   $0x803b41
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
  80068e:	68 20 3c 80 00       	push   $0x803c20
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
  8006ba:	e8 c1 15 00 00       	call   801c80 <argstart>
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
  8006d8:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
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
  8006ec:	e8 c3 15 00 00       	call   801cb4 <argnext>
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
  800721:	bf 9c 3b 80 00       	mov    $0x803b9c,%edi
  800726:	b8 00 00 00 00       	mov    $0x0,%eax
  80072b:	0f 44 f8             	cmove  %eax,%edi
  80072e:	e9 06 01 00 00       	jmp    800839 <umain+0x197>
		usage();
  800733:	e8 4c ff ff ff       	call   800684 <usage>
  800738:	eb da                	jmp    800714 <umain+0x72>
		close(0);
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	e8 5e 18 00 00       	call   801fa2 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800744:	83 c4 08             	add    $0x8,%esp
  800747:	6a 00                	push   $0x0
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	ff 70 04             	pushl  0x4(%eax)
  80074f:	e8 2d 1e 00 00       	call   802581 <open>
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	85 c0                	test   %eax,%eax
  800759:	78 1b                	js     800776 <umain+0xd4>
		assert(r == 0);
  80075b:	74 bd                	je     80071a <umain+0x78>
  80075d:	68 80 3b 80 00       	push   $0x803b80
  800762:	68 87 3b 80 00       	push   $0x803b87
  800767:	68 2d 01 00 00       	push   $0x12d
  80076c:	68 f7 3a 80 00       	push   $0x803af7
  800771:	e8 2a 03 00 00       	call   800aa0 <_panic>
			panic("open %s: %e", argv[1], r);
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	50                   	push   %eax
  80077a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077d:	ff 70 04             	pushl  0x4(%eax)
  800780:	68 74 3b 80 00       	push   $0x803b74
  800785:	68 2c 01 00 00       	push   $0x12c
  80078a:	68 f7 3a 80 00       	push   $0x803af7
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
  8007a8:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007af:	75 0a                	jne    8007bb <umain+0x119>
				cprintf("EXITING\n");
			exit();	// end of file
  8007b1:	e8 cc 02 00 00       	call   800a82 <exit>
  8007b6:	e9 94 00 00 00       	jmp    80084f <umain+0x1ad>
				cprintf("EXITING\n");
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	68 9f 3b 80 00       	push   $0x803b9f
  8007c3:	e8 bf 03 00 00       	call   800b87 <cprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	eb e4                	jmp    8007b1 <umain+0x10f>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	68 a8 3b 80 00       	push   $0x803ba8
  8007d6:	e8 ac 03 00 00       	call   800b87 <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	eb 7c                	jmp    80085c <umain+0x1ba>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	53                   	push   %ebx
  8007e4:	68 b2 3b 80 00       	push   $0x803bb2
  8007e9:	e8 4a 1f 00 00       	call   802738 <printf>
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	eb 78                	jmp    80086b <umain+0x1c9>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007f3:	83 ec 0c             	sub    $0xc,%esp
  8007f6:	68 b8 3b 80 00       	push   $0x803bb8
  8007fb:	e8 87 03 00 00       	call   800b87 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
  800803:	eb 73                	jmp    800878 <umain+0x1d6>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  800805:	50                   	push   %eax
  800806:	68 f5 3f 80 00       	push   $0x803ff5
  80080b:	68 44 01 00 00       	push   $0x144
  800810:	68 f7 3a 80 00       	push   $0x803af7
  800815:	e8 86 02 00 00       	call   800aa0 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	50                   	push   %eax
  80081e:	68 c5 3b 80 00       	push   $0x803bc5
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
  800831:	e8 48 2d 00 00       	call   80357e <wait>
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
  80084f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800856:	0f 85 71 ff ff ff    	jne    8007cd <umain+0x12b>
		if (buf[0] == '#')
  80085c:	80 3b 23             	cmpb   $0x23,(%ebx)
  80085f:	74 d8                	je     800839 <umain+0x197>
		if (echocmds)
  800861:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800865:	0f 85 75 ff ff ff    	jne    8007e0 <umain+0x13e>
		if (debug)
  80086b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800872:	0f 85 7b ff ff ff    	jne    8007f3 <umain+0x151>
		if ((r = fork()) < 0)
  800878:	e8 ea 11 00 00       	call   801a67 <fork>
  80087d:	89 c6                	mov    %eax,%esi
  80087f:	85 c0                	test   %eax,%eax
  800881:	78 82                	js     800805 <umain+0x163>
		if (debug)
  800883:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
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
  8008b7:	68 41 3c 80 00       	push   $0x803c41
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
  800997:	e8 50 17 00 00       	call   8020ec <read>
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
  8009c3:	e8 9c 14 00 00       	call   801e64 <fd_lookup>
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	78 11                	js     8009e0 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8009cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d2:	8b 15 00 50 80 00    	mov    0x805000,%edx
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
  8009f0:	e8 19 14 00 00       	call   801e0e <fd_alloc>
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
  800a18:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800a1e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a23:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a2a:	83 ec 0c             	sub    $0xc,%esp
  800a2d:	50                   	push   %eax
  800a2e:	e8 ac 13 00 00       	call   801ddf <fd2num>
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
  800a59:	a3 28 64 80 00       	mov    %eax,0x806428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	7e 07                	jle    800a69 <libmain+0x31>
		binaryname = argv[0];
  800a62:	8b 06                	mov    (%esi),%eax
  800a64:	a3 1c 50 80 00       	mov    %eax,0x80501c

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
  800a8c:	e8 42 15 00 00       	call   801fd3 <close_all>
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
  800aac:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800ab2:	e8 ca 0b 00 00       	call   801681 <sys_getenvid>
  800ab7:	83 ec 0c             	sub    $0xc,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	56                   	push   %esi
  800ac1:	50                   	push   %eax
  800ac2:	68 58 3c 80 00       	push   $0x803c58
  800ac7:	e8 bb 00 00 00       	call   800b87 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800acc:	83 c4 18             	add    $0x18,%esp
  800acf:	53                   	push   %ebx
  800ad0:	ff 75 10             	pushl  0x10(%ebp)
  800ad3:	e8 5a 00 00 00       	call   800b32 <vcprintf>
	cprintf("\n");
  800ad8:	c7 04 24 60 3a 80 00 	movl   $0x803a60,(%esp)
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
  800bed:	e8 de 2b 00 00       	call   8037d0 <__udivdi3>
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
  800c2b:	e8 b0 2c 00 00       	call   8038e0 <__umoddi3>
  800c30:	83 c4 14             	add    $0x14,%esp
  800c33:	0f be 80 7b 3c 80 00 	movsbl 0x803c7b(%eax),%eax
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
  800cda:	3e ff 24 85 c0 3d 80 	notrack jmp *0x803dc0(,%eax,4)
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
  800da7:	8b 14 85 20 3f 80 00 	mov    0x803f20(,%eax,4),%edx
  800dae:	85 d2                	test   %edx,%edx
  800db0:	74 18                	je     800dca <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800db2:	52                   	push   %edx
  800db3:	68 99 3b 80 00       	push   $0x803b99
  800db8:	53                   	push   %ebx
  800db9:	56                   	push   %esi
  800dba:	e8 aa fe ff ff       	call   800c69 <printfmt>
  800dbf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dc2:	89 7d 14             	mov    %edi,0x14(%ebp)
  800dc5:	e9 66 02 00 00       	jmp    801030 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800dca:	50                   	push   %eax
  800dcb:	68 93 3c 80 00       	push   $0x803c93
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
  800df2:	b8 8c 3c 80 00       	mov    $0x803c8c,%eax
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
  801166:	68 99 3b 80 00       	push   $0x803b99
  80116b:	6a 01                	push   $0x1
  80116d:	e8 ab 15 00 00       	call   80271d <fprintf>
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
  8011a1:	68 7f 3f 80 00       	push   $0x803f7f
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
  8011d9:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
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
  801222:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  801229:	b8 20 60 80 00       	mov    $0x806020,%eax
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
  801670:	68 8f 3f 80 00       	push   $0x803f8f
  801675:	6a 23                	push   $0x23
  801677:	68 ac 3f 80 00       	push   $0x803fac
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
  8016fd:	68 8f 3f 80 00       	push   $0x803f8f
  801702:	6a 23                	push   $0x23
  801704:	68 ac 3f 80 00       	push   $0x803fac
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
  801743:	68 8f 3f 80 00       	push   $0x803f8f
  801748:	6a 23                	push   $0x23
  80174a:	68 ac 3f 80 00       	push   $0x803fac
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
  801789:	68 8f 3f 80 00       	push   $0x803f8f
  80178e:	6a 23                	push   $0x23
  801790:	68 ac 3f 80 00       	push   $0x803fac
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
  8017cf:	68 8f 3f 80 00       	push   $0x803f8f
  8017d4:	6a 23                	push   $0x23
  8017d6:	68 ac 3f 80 00       	push   $0x803fac
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
  801815:	68 8f 3f 80 00       	push   $0x803f8f
  80181a:	6a 23                	push   $0x23
  80181c:	68 ac 3f 80 00       	push   $0x803fac
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
  80185b:	68 8f 3f 80 00       	push   $0x803f8f
  801860:	6a 23                	push   $0x23
  801862:	68 ac 3f 80 00       	push   $0x803fac
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
  8018c7:	68 8f 3f 80 00       	push   $0x803f8f
  8018cc:	6a 23                	push   $0x23
  8018ce:	68 ac 3f 80 00       	push   $0x803fac
  8018d3:	e8 c8 f1 ff ff       	call   800aa0 <_panic>

008018d8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8018d8:	f3 0f 1e fb          	endbr32 
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	57                   	push   %edi
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e7:	b8 0e 00 00 00       	mov    $0xe,%eax
  8018ec:	89 d1                	mov    %edx,%ecx
  8018ee:	89 d3                	mov    %edx,%ebx
  8018f0:	89 d7                	mov    %edx,%edi
  8018f2:	89 d6                	mov    %edx,%esi
  8018f4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8018f6:	5b                   	pop    %ebx
  8018f7:	5e                   	pop    %esi
  8018f8:	5f                   	pop    %edi
  8018f9:	5d                   	pop    %ebp
  8018fa:	c3                   	ret    

008018fb <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8018fb:	f3 0f 1e fb          	endbr32 
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	57                   	push   %edi
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801908:	bb 00 00 00 00       	mov    $0x0,%ebx
  80190d:	8b 55 08             	mov    0x8(%ebp),%edx
  801910:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801913:	b8 0f 00 00 00       	mov    $0xf,%eax
  801918:	89 df                	mov    %ebx,%edi
  80191a:	89 de                	mov    %ebx,%esi
  80191c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80191e:	85 c0                	test   %eax,%eax
  801920:	7f 08                	jg     80192a <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  801922:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801925:	5b                   	pop    %ebx
  801926:	5e                   	pop    %esi
  801927:	5f                   	pop    %edi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80192a:	83 ec 0c             	sub    $0xc,%esp
  80192d:	50                   	push   %eax
  80192e:	6a 0f                	push   $0xf
  801930:	68 8f 3f 80 00       	push   $0x803f8f
  801935:	6a 23                	push   $0x23
  801937:	68 ac 3f 80 00       	push   $0x803fac
  80193c:	e8 5f f1 ff ff       	call   800aa0 <_panic>

00801941 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  801941:	f3 0f 1e fb          	endbr32 
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	57                   	push   %edi
  801949:	56                   	push   %esi
  80194a:	53                   	push   %ebx
  80194b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80194e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801953:	8b 55 08             	mov    0x8(%ebp),%edx
  801956:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801959:	b8 10 00 00 00       	mov    $0x10,%eax
  80195e:	89 df                	mov    %ebx,%edi
  801960:	89 de                	mov    %ebx,%esi
  801962:	cd 30                	int    $0x30
	if(check && ret > 0)
  801964:	85 c0                	test   %eax,%eax
  801966:	7f 08                	jg     801970 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  801968:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5f                   	pop    %edi
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801970:	83 ec 0c             	sub    $0xc,%esp
  801973:	50                   	push   %eax
  801974:	6a 10                	push   $0x10
  801976:	68 8f 3f 80 00       	push   $0x803f8f
  80197b:	6a 23                	push   $0x23
  80197d:	68 ac 3f 80 00       	push   $0x803fac
  801982:	e8 19 f1 ff ff       	call   800aa0 <_panic>

00801987 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801987:	f3 0f 1e fb          	endbr32 
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	53                   	push   %ebx
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801995:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  801997:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80199b:	74 74                	je     801a11 <pgfault+0x8a>
  80199d:	89 d8                	mov    %ebx,%eax
  80199f:	c1 e8 0c             	shr    $0xc,%eax
  8019a2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019a9:	f6 c4 08             	test   $0x8,%ah
  8019ac:	74 63                	je     801a11 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  8019ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	6a 05                	push   $0x5
  8019b9:	68 00 f0 7f 00       	push   $0x7ff000
  8019be:	6a 00                	push   $0x0
  8019c0:	53                   	push   %ebx
  8019c1:	6a 00                	push   $0x0
  8019c3:	e8 46 fd ff ff       	call   80170e <sys_page_map>
  8019c8:	83 c4 20             	add    $0x20,%esp
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 59                	js     801a28 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	6a 07                	push   $0x7
  8019d4:	53                   	push   %ebx
  8019d5:	6a 00                	push   $0x0
  8019d7:	e8 eb fc ff ff       	call   8016c7 <sys_page_alloc>
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	78 5a                	js     801a3d <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	68 00 10 00 00       	push   $0x1000
  8019eb:	68 00 f0 7f 00       	push   $0x7ff000
  8019f0:	53                   	push   %ebx
  8019f1:	e8 45 fa ff ff       	call   80143b <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  8019f6:	83 c4 08             	add    $0x8,%esp
  8019f9:	68 00 f0 7f 00       	push   $0x7ff000
  8019fe:	6a 00                	push   $0x0
  801a00:	e8 4f fd ff ff       	call   801754 <sys_page_unmap>
  801a05:	83 c4 10             	add    $0x10,%esp
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 46                	js     801a52 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  801a0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	68 ba 3f 80 00       	push   $0x803fba
  801a19:	68 d3 00 00 00       	push   $0xd3
  801a1e:	68 d6 3f 80 00       	push   $0x803fd6
  801a23:	e8 78 f0 ff ff       	call   800aa0 <_panic>
		panic("pgfault: %e\n", r);
  801a28:	50                   	push   %eax
  801a29:	68 e1 3f 80 00       	push   $0x803fe1
  801a2e:	68 df 00 00 00       	push   $0xdf
  801a33:	68 d6 3f 80 00       	push   $0x803fd6
  801a38:	e8 63 f0 ff ff       	call   800aa0 <_panic>
		panic("pgfault: %e\n", r);
  801a3d:	50                   	push   %eax
  801a3e:	68 e1 3f 80 00       	push   $0x803fe1
  801a43:	68 e3 00 00 00       	push   $0xe3
  801a48:	68 d6 3f 80 00       	push   $0x803fd6
  801a4d:	e8 4e f0 ff ff       	call   800aa0 <_panic>
		panic("pgfault: %e\n", r);
  801a52:	50                   	push   %eax
  801a53:	68 e1 3f 80 00       	push   $0x803fe1
  801a58:	68 e9 00 00 00       	push   $0xe9
  801a5d:	68 d6 3f 80 00       	push   $0x803fd6
  801a62:	e8 39 f0 ff ff       	call   800aa0 <_panic>

00801a67 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801a67:	f3 0f 1e fb          	endbr32 
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	57                   	push   %edi
  801a6f:	56                   	push   %esi
  801a70:	53                   	push   %ebx
  801a71:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801a74:	68 87 19 80 00       	push   $0x801987
  801a79:	e8 53 1b 00 00       	call   8035d1 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a7e:	b8 07 00 00 00       	mov    $0x7,%eax
  801a83:	cd 30                	int    $0x30
  801a85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	78 2d                	js     801abc <fork+0x55>
  801a8f:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801a91:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801a96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a9a:	0f 85 9b 00 00 00    	jne    801b3b <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801aa0:	e8 dc fb ff ff       	call   801681 <sys_getenvid>
  801aa5:	25 ff 03 00 00       	and    $0x3ff,%eax
  801aaa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801aad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ab2:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801ab7:	e9 71 01 00 00       	jmp    801c2d <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  801abc:	50                   	push   %eax
  801abd:	68 ee 3f 80 00       	push   $0x803fee
  801ac2:	68 2a 01 00 00       	push   $0x12a
  801ac7:	68 d6 3f 80 00       	push   $0x803fd6
  801acc:	e8 cf ef ff ff       	call   800aa0 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801ad1:	c1 e6 0c             	shl    $0xc,%esi
  801ad4:	83 ec 0c             	sub    $0xc,%esp
  801ad7:	68 07 0e 00 00       	push   $0xe07
  801adc:	56                   	push   %esi
  801add:	57                   	push   %edi
  801ade:	56                   	push   %esi
  801adf:	6a 00                	push   $0x0
  801ae1:	e8 28 fc ff ff       	call   80170e <sys_page_map>
  801ae6:	83 c4 20             	add    $0x20,%esp
  801ae9:	eb 3e                	jmp    801b29 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801aeb:	c1 e6 0c             	shl    $0xc,%esi
  801aee:	83 ec 0c             	sub    $0xc,%esp
  801af1:	68 05 08 00 00       	push   $0x805
  801af6:	56                   	push   %esi
  801af7:	57                   	push   %edi
  801af8:	56                   	push   %esi
  801af9:	6a 00                	push   $0x0
  801afb:	e8 0e fc ff ff       	call   80170e <sys_page_map>
  801b00:	83 c4 20             	add    $0x20,%esp
  801b03:	85 c0                	test   %eax,%eax
  801b05:	0f 88 bc 00 00 00    	js     801bc7 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801b0b:	83 ec 0c             	sub    $0xc,%esp
  801b0e:	68 05 08 00 00       	push   $0x805
  801b13:	56                   	push   %esi
  801b14:	6a 00                	push   $0x0
  801b16:	56                   	push   %esi
  801b17:	6a 00                	push   $0x0
  801b19:	e8 f0 fb ff ff       	call   80170e <sys_page_map>
  801b1e:	83 c4 20             	add    $0x20,%esp
  801b21:	85 c0                	test   %eax,%eax
  801b23:	0f 88 b3 00 00 00    	js     801bdc <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801b29:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b2f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801b35:	0f 84 b6 00 00 00    	je     801bf1 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801b3b:	89 d8                	mov    %ebx,%eax
  801b3d:	c1 e8 16             	shr    $0x16,%eax
  801b40:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b47:	a8 01                	test   $0x1,%al
  801b49:	74 de                	je     801b29 <fork+0xc2>
  801b4b:	89 de                	mov    %ebx,%esi
  801b4d:	c1 ee 0c             	shr    $0xc,%esi
  801b50:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b57:	a8 01                	test   $0x1,%al
  801b59:	74 ce                	je     801b29 <fork+0xc2>
  801b5b:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b62:	a8 04                	test   $0x4,%al
  801b64:	74 c3                	je     801b29 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801b66:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b6d:	f6 c4 04             	test   $0x4,%ah
  801b70:	0f 85 5b ff ff ff    	jne    801ad1 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801b76:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b7d:	a8 02                	test   $0x2,%al
  801b7f:	0f 85 66 ff ff ff    	jne    801aeb <fork+0x84>
  801b85:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801b8c:	f6 c4 08             	test   $0x8,%ah
  801b8f:	0f 85 56 ff ff ff    	jne    801aeb <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801b95:	c1 e6 0c             	shl    $0xc,%esi
  801b98:	83 ec 0c             	sub    $0xc,%esp
  801b9b:	6a 05                	push   $0x5
  801b9d:	56                   	push   %esi
  801b9e:	57                   	push   %edi
  801b9f:	56                   	push   %esi
  801ba0:	6a 00                	push   $0x0
  801ba2:	e8 67 fb ff ff       	call   80170e <sys_page_map>
  801ba7:	83 c4 20             	add    $0x20,%esp
  801baa:	85 c0                	test   %eax,%eax
  801bac:	0f 89 77 ff ff ff    	jns    801b29 <fork+0xc2>
		panic("duppage: %e\n", r);
  801bb2:	50                   	push   %eax
  801bb3:	68 fe 3f 80 00       	push   $0x803ffe
  801bb8:	68 0c 01 00 00       	push   $0x10c
  801bbd:	68 d6 3f 80 00       	push   $0x803fd6
  801bc2:	e8 d9 ee ff ff       	call   800aa0 <_panic>
			panic("duppage: %e\n", r);
  801bc7:	50                   	push   %eax
  801bc8:	68 fe 3f 80 00       	push   $0x803ffe
  801bcd:	68 05 01 00 00       	push   $0x105
  801bd2:	68 d6 3f 80 00       	push   $0x803fd6
  801bd7:	e8 c4 ee ff ff       	call   800aa0 <_panic>
			panic("duppage: %e\n", r);
  801bdc:	50                   	push   %eax
  801bdd:	68 fe 3f 80 00       	push   $0x803ffe
  801be2:	68 09 01 00 00       	push   $0x109
  801be7:	68 d6 3f 80 00       	push   $0x803fd6
  801bec:	e8 af ee ff ff       	call   800aa0 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	6a 07                	push   $0x7
  801bf6:	68 00 f0 bf ee       	push   $0xeebff000
  801bfb:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bfe:	e8 c4 fa ff ff       	call   8016c7 <sys_page_alloc>
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 2e                	js     801c38 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801c0a:	83 ec 08             	sub    $0x8,%esp
  801c0d:	68 44 36 80 00       	push   $0x803644
  801c12:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801c15:	57                   	push   %edi
  801c16:	e8 0b fc ff ff       	call   801826 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801c1b:	83 c4 08             	add    $0x8,%esp
  801c1e:	6a 02                	push   $0x2
  801c20:	57                   	push   %edi
  801c21:	e8 74 fb ff ff       	call   80179a <sys_env_set_status>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 20                	js     801c4d <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801c2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801c38:	50                   	push   %eax
  801c39:	68 0b 40 80 00       	push   $0x80400b
  801c3e:	68 3e 01 00 00       	push   $0x13e
  801c43:	68 d6 3f 80 00       	push   $0x803fd6
  801c48:	e8 53 ee ff ff       	call   800aa0 <_panic>
		panic("sys_env_set_status: %e", r);
  801c4d:	50                   	push   %eax
  801c4e:	68 1e 40 80 00       	push   $0x80401e
  801c53:	68 43 01 00 00       	push   $0x143
  801c58:	68 d6 3f 80 00       	push   $0x803fd6
  801c5d:	e8 3e ee ff ff       	call   800aa0 <_panic>

00801c62 <sfork>:

// Challenge!
int
sfork(void)
{
  801c62:	f3 0f 1e fb          	endbr32 
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801c6c:	68 35 40 80 00       	push   $0x804035
  801c71:	68 4c 01 00 00       	push   $0x14c
  801c76:	68 d6 3f 80 00       	push   $0x803fd6
  801c7b:	e8 20 ee ff ff       	call   800aa0 <_panic>

00801c80 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801c80:	f3 0f 1e fb          	endbr32 
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8d:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801c90:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801c92:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801c95:	83 3a 01             	cmpl   $0x1,(%edx)
  801c98:	7e 09                	jle    801ca3 <argstart+0x23>
  801c9a:	ba 61 3a 80 00       	mov    $0x803a61,%edx
  801c9f:	85 c9                	test   %ecx,%ecx
  801ca1:	75 05                	jne    801ca8 <argstart+0x28>
  801ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca8:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801cab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    

00801cb4 <argnext>:

int
argnext(struct Argstate *args)
{
  801cb4:	f3 0f 1e fb          	endbr32 
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801cc2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801cc9:	8b 43 08             	mov    0x8(%ebx),%eax
  801ccc:	85 c0                	test   %eax,%eax
  801cce:	74 74                	je     801d44 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  801cd0:	80 38 00             	cmpb   $0x0,(%eax)
  801cd3:	75 48                	jne    801d1d <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801cd5:	8b 0b                	mov    (%ebx),%ecx
  801cd7:	83 39 01             	cmpl   $0x1,(%ecx)
  801cda:	74 5a                	je     801d36 <argnext+0x82>
		    || args->argv[1][0] != '-'
  801cdc:	8b 53 04             	mov    0x4(%ebx),%edx
  801cdf:	8b 42 04             	mov    0x4(%edx),%eax
  801ce2:	80 38 2d             	cmpb   $0x2d,(%eax)
  801ce5:	75 4f                	jne    801d36 <argnext+0x82>
		    || args->argv[1][1] == '\0')
  801ce7:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801ceb:	74 49                	je     801d36 <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801ced:	83 c0 01             	add    $0x1,%eax
  801cf0:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	8b 01                	mov    (%ecx),%eax
  801cf8:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801cff:	50                   	push   %eax
  801d00:	8d 42 08             	lea    0x8(%edx),%eax
  801d03:	50                   	push   %eax
  801d04:	83 c2 04             	add    $0x4,%edx
  801d07:	52                   	push   %edx
  801d08:	e8 2e f7 ff ff       	call   80143b <memmove>
		(*args->argc)--;
  801d0d:	8b 03                	mov    (%ebx),%eax
  801d0f:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801d12:	8b 43 08             	mov    0x8(%ebx),%eax
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	80 38 2d             	cmpb   $0x2d,(%eax)
  801d1b:	74 13                	je     801d30 <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801d1d:	8b 43 08             	mov    0x8(%ebx),%eax
  801d20:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  801d23:	83 c0 01             	add    $0x1,%eax
  801d26:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801d30:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801d34:	75 e7                	jne    801d1d <argnext+0x69>
	args->curarg = 0;
  801d36:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801d3d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801d42:	eb e5                	jmp    801d29 <argnext+0x75>
		return -1;
  801d44:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801d49:	eb de                	jmp    801d29 <argnext+0x75>

00801d4b <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801d4b:	f3 0f 1e fb          	endbr32 
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	53                   	push   %ebx
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801d59:	8b 43 08             	mov    0x8(%ebx),%eax
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	74 12                	je     801d72 <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  801d60:	80 38 00             	cmpb   $0x0,(%eax)
  801d63:	74 12                	je     801d77 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  801d65:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801d68:	c7 43 08 61 3a 80 00 	movl   $0x803a61,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801d6f:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    
	} else if (*args->argc > 1) {
  801d77:	8b 13                	mov    (%ebx),%edx
  801d79:	83 3a 01             	cmpl   $0x1,(%edx)
  801d7c:	7f 10                	jg     801d8e <argnextvalue+0x43>
		args->argvalue = 0;
  801d7e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801d85:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801d8c:	eb e1                	jmp    801d6f <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  801d8e:	8b 43 04             	mov    0x4(%ebx),%eax
  801d91:	8b 48 04             	mov    0x4(%eax),%ecx
  801d94:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	8b 12                	mov    (%edx),%edx
  801d9c:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801da3:	52                   	push   %edx
  801da4:	8d 50 08             	lea    0x8(%eax),%edx
  801da7:	52                   	push   %edx
  801da8:	83 c0 04             	add    $0x4,%eax
  801dab:	50                   	push   %eax
  801dac:	e8 8a f6 ff ff       	call   80143b <memmove>
		(*args->argc)--;
  801db1:	8b 03                	mov    (%ebx),%eax
  801db3:	83 28 01             	subl   $0x1,(%eax)
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	eb b4                	jmp    801d6f <argnextvalue+0x24>

00801dbb <argvalue>:
{
  801dbb:	f3 0f 1e fb          	endbr32 
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 08             	sub    $0x8,%esp
  801dc5:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801dc8:	8b 42 0c             	mov    0xc(%edx),%eax
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	74 02                	je     801dd1 <argvalue+0x16>
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801dd1:	83 ec 0c             	sub    $0xc,%esp
  801dd4:	52                   	push   %edx
  801dd5:	e8 71 ff ff ff       	call   801d4b <argnextvalue>
  801dda:	83 c4 10             	add    $0x10,%esp
  801ddd:	eb f0                	jmp    801dcf <argvalue+0x14>

00801ddf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801ddf:	f3 0f 1e fb          	endbr32 
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	05 00 00 00 30       	add    $0x30000000,%eax
  801dee:	c1 e8 0c             	shr    $0xc,%eax
}
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    

00801df3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801df3:	f3 0f 1e fb          	endbr32 
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801e02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e07:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801e0c:	5d                   	pop    %ebp
  801e0d:	c3                   	ret    

00801e0e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e0e:	f3 0f 1e fb          	endbr32 
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e1a:	89 c2                	mov    %eax,%edx
  801e1c:	c1 ea 16             	shr    $0x16,%edx
  801e1f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801e26:	f6 c2 01             	test   $0x1,%dl
  801e29:	74 2d                	je     801e58 <fd_alloc+0x4a>
  801e2b:	89 c2                	mov    %eax,%edx
  801e2d:	c1 ea 0c             	shr    $0xc,%edx
  801e30:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e37:	f6 c2 01             	test   $0x1,%dl
  801e3a:	74 1c                	je     801e58 <fd_alloc+0x4a>
  801e3c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801e41:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801e46:	75 d2                	jne    801e1a <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801e51:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801e56:	eb 0a                	jmp    801e62 <fd_alloc+0x54>
			*fd_store = fd;
  801e58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e5b:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    

00801e64 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e64:	f3 0f 1e fb          	endbr32 
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e6e:	83 f8 1f             	cmp    $0x1f,%eax
  801e71:	77 30                	ja     801ea3 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801e73:	c1 e0 0c             	shl    $0xc,%eax
  801e76:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e7b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801e81:	f6 c2 01             	test   $0x1,%dl
  801e84:	74 24                	je     801eaa <fd_lookup+0x46>
  801e86:	89 c2                	mov    %eax,%edx
  801e88:	c1 ea 0c             	shr    $0xc,%edx
  801e8b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e92:	f6 c2 01             	test   $0x1,%dl
  801e95:	74 1a                	je     801eb1 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9a:	89 02                	mov    %eax,(%edx)
	return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    
		return -E_INVAL;
  801ea3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ea8:	eb f7                	jmp    801ea1 <fd_lookup+0x3d>
		return -E_INVAL;
  801eaa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eaf:	eb f0                	jmp    801ea1 <fd_lookup+0x3d>
  801eb1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eb6:	eb e9                	jmp    801ea1 <fd_lookup+0x3d>

00801eb8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801eb8:	f3 0f 1e fb          	endbr32 
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 08             	sub    $0x8,%esp
  801ec2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801ec5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eca:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801ecf:	39 08                	cmp    %ecx,(%eax)
  801ed1:	74 38                	je     801f0b <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801ed3:	83 c2 01             	add    $0x1,%edx
  801ed6:	8b 04 95 c8 40 80 00 	mov    0x8040c8(,%edx,4),%eax
  801edd:	85 c0                	test   %eax,%eax
  801edf:	75 ee                	jne    801ecf <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ee1:	a1 28 64 80 00       	mov    0x806428,%eax
  801ee6:	8b 40 48             	mov    0x48(%eax),%eax
  801ee9:	83 ec 04             	sub    $0x4,%esp
  801eec:	51                   	push   %ecx
  801eed:	50                   	push   %eax
  801eee:	68 4c 40 80 00       	push   $0x80404c
  801ef3:	e8 8f ec ff ff       	call   800b87 <cprintf>
	*dev = 0;
  801ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801f01:	83 c4 10             	add    $0x10,%esp
  801f04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    
			*dev = devtab[i];
  801f0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f0e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
  801f15:	eb f2                	jmp    801f09 <dev_lookup+0x51>

00801f17 <fd_close>:
{
  801f17:	f3 0f 1e fb          	endbr32 
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	57                   	push   %edi
  801f1f:	56                   	push   %esi
  801f20:	53                   	push   %ebx
  801f21:	83 ec 24             	sub    $0x24,%esp
  801f24:	8b 75 08             	mov    0x8(%ebp),%esi
  801f27:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f2a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f2d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f2e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801f34:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f37:	50                   	push   %eax
  801f38:	e8 27 ff ff ff       	call   801e64 <fd_lookup>
  801f3d:	89 c3                	mov    %eax,%ebx
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	85 c0                	test   %eax,%eax
  801f44:	78 05                	js     801f4b <fd_close+0x34>
	    || fd != fd2)
  801f46:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801f49:	74 16                	je     801f61 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801f4b:	89 f8                	mov    %edi,%eax
  801f4d:	84 c0                	test   %al,%al
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f54:	0f 44 d8             	cmove  %eax,%ebx
}
  801f57:	89 d8                	mov    %ebx,%eax
  801f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f5c:	5b                   	pop    %ebx
  801f5d:	5e                   	pop    %esi
  801f5e:	5f                   	pop    %edi
  801f5f:	5d                   	pop    %ebp
  801f60:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f61:	83 ec 08             	sub    $0x8,%esp
  801f64:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f67:	50                   	push   %eax
  801f68:	ff 36                	pushl  (%esi)
  801f6a:	e8 49 ff ff ff       	call   801eb8 <dev_lookup>
  801f6f:	89 c3                	mov    %eax,%ebx
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	85 c0                	test   %eax,%eax
  801f76:	78 1a                	js     801f92 <fd_close+0x7b>
		if (dev->dev_close)
  801f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f7b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801f7e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801f83:	85 c0                	test   %eax,%eax
  801f85:	74 0b                	je     801f92 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	56                   	push   %esi
  801f8b:	ff d0                	call   *%eax
  801f8d:	89 c3                	mov    %eax,%ebx
  801f8f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801f92:	83 ec 08             	sub    $0x8,%esp
  801f95:	56                   	push   %esi
  801f96:	6a 00                	push   $0x0
  801f98:	e8 b7 f7 ff ff       	call   801754 <sys_page_unmap>
	return r;
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	eb b5                	jmp    801f57 <fd_close+0x40>

00801fa2 <close>:

int
close(int fdnum)
{
  801fa2:	f3 0f 1e fb          	endbr32 
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801faf:	50                   	push   %eax
  801fb0:	ff 75 08             	pushl  0x8(%ebp)
  801fb3:	e8 ac fe ff ff       	call   801e64 <fd_lookup>
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	79 02                	jns    801fc1 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    
		return fd_close(fd, 1);
  801fc1:	83 ec 08             	sub    $0x8,%esp
  801fc4:	6a 01                	push   $0x1
  801fc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc9:	e8 49 ff ff ff       	call   801f17 <fd_close>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	eb ec                	jmp    801fbf <close+0x1d>

00801fd3 <close_all>:

void
close_all(void)
{
  801fd3:	f3 0f 1e fb          	endbr32 
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	53                   	push   %ebx
  801fdb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fde:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	53                   	push   %ebx
  801fe7:	e8 b6 ff ff ff       	call   801fa2 <close>
	for (i = 0; i < MAXFD; i++)
  801fec:	83 c3 01             	add    $0x1,%ebx
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	83 fb 20             	cmp    $0x20,%ebx
  801ff5:	75 ec                	jne    801fe3 <close_all+0x10>
}
  801ff7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ffc:	f3 0f 1e fb          	endbr32 
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	57                   	push   %edi
  802004:	56                   	push   %esi
  802005:	53                   	push   %ebx
  802006:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802009:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80200c:	50                   	push   %eax
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	e8 4f fe ff ff       	call   801e64 <fd_lookup>
  802015:	89 c3                	mov    %eax,%ebx
  802017:	83 c4 10             	add    $0x10,%esp
  80201a:	85 c0                	test   %eax,%eax
  80201c:	0f 88 81 00 00 00    	js     8020a3 <dup+0xa7>
		return r;
	close(newfdnum);
  802022:	83 ec 0c             	sub    $0xc,%esp
  802025:	ff 75 0c             	pushl  0xc(%ebp)
  802028:	e8 75 ff ff ff       	call   801fa2 <close>

	newfd = INDEX2FD(newfdnum);
  80202d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802030:	c1 e6 0c             	shl    $0xc,%esi
  802033:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802039:	83 c4 04             	add    $0x4,%esp
  80203c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80203f:	e8 af fd ff ff       	call   801df3 <fd2data>
  802044:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802046:	89 34 24             	mov    %esi,(%esp)
  802049:	e8 a5 fd ff ff       	call   801df3 <fd2data>
  80204e:	83 c4 10             	add    $0x10,%esp
  802051:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802053:	89 d8                	mov    %ebx,%eax
  802055:	c1 e8 16             	shr    $0x16,%eax
  802058:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80205f:	a8 01                	test   $0x1,%al
  802061:	74 11                	je     802074 <dup+0x78>
  802063:	89 d8                	mov    %ebx,%eax
  802065:	c1 e8 0c             	shr    $0xc,%eax
  802068:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80206f:	f6 c2 01             	test   $0x1,%dl
  802072:	75 39                	jne    8020ad <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802074:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802077:	89 d0                	mov    %edx,%eax
  802079:	c1 e8 0c             	shr    $0xc,%eax
  80207c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	25 07 0e 00 00       	and    $0xe07,%eax
  80208b:	50                   	push   %eax
  80208c:	56                   	push   %esi
  80208d:	6a 00                	push   $0x0
  80208f:	52                   	push   %edx
  802090:	6a 00                	push   $0x0
  802092:	e8 77 f6 ff ff       	call   80170e <sys_page_map>
  802097:	89 c3                	mov    %eax,%ebx
  802099:	83 c4 20             	add    $0x20,%esp
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 31                	js     8020d1 <dup+0xd5>
		goto err;

	return newfdnum;
  8020a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8020a3:	89 d8                	mov    %ebx,%eax
  8020a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a8:	5b                   	pop    %ebx
  8020a9:	5e                   	pop    %esi
  8020aa:	5f                   	pop    %edi
  8020ab:	5d                   	pop    %ebp
  8020ac:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020b4:	83 ec 0c             	sub    $0xc,%esp
  8020b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8020bc:	50                   	push   %eax
  8020bd:	57                   	push   %edi
  8020be:	6a 00                	push   $0x0
  8020c0:	53                   	push   %ebx
  8020c1:	6a 00                	push   $0x0
  8020c3:	e8 46 f6 ff ff       	call   80170e <sys_page_map>
  8020c8:	89 c3                	mov    %eax,%ebx
  8020ca:	83 c4 20             	add    $0x20,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	79 a3                	jns    802074 <dup+0x78>
	sys_page_unmap(0, newfd);
  8020d1:	83 ec 08             	sub    $0x8,%esp
  8020d4:	56                   	push   %esi
  8020d5:	6a 00                	push   $0x0
  8020d7:	e8 78 f6 ff ff       	call   801754 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8020dc:	83 c4 08             	add    $0x8,%esp
  8020df:	57                   	push   %edi
  8020e0:	6a 00                	push   $0x0
  8020e2:	e8 6d f6 ff ff       	call   801754 <sys_page_unmap>
	return r;
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	eb b7                	jmp    8020a3 <dup+0xa7>

008020ec <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020ec:	f3 0f 1e fb          	endbr32 
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	53                   	push   %ebx
  8020f4:	83 ec 1c             	sub    $0x1c,%esp
  8020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020fd:	50                   	push   %eax
  8020fe:	53                   	push   %ebx
  8020ff:	e8 60 fd ff ff       	call   801e64 <fd_lookup>
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	85 c0                	test   %eax,%eax
  802109:	78 3f                	js     80214a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80210b:	83 ec 08             	sub    $0x8,%esp
  80210e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802111:	50                   	push   %eax
  802112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802115:	ff 30                	pushl  (%eax)
  802117:	e8 9c fd ff ff       	call   801eb8 <dev_lookup>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 27                	js     80214a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802123:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802126:	8b 42 08             	mov    0x8(%edx),%eax
  802129:	83 e0 03             	and    $0x3,%eax
  80212c:	83 f8 01             	cmp    $0x1,%eax
  80212f:	74 1e                	je     80214f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	8b 40 08             	mov    0x8(%eax),%eax
  802137:	85 c0                	test   %eax,%eax
  802139:	74 35                	je     802170 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	ff 75 10             	pushl  0x10(%ebp)
  802141:	ff 75 0c             	pushl  0xc(%ebp)
  802144:	52                   	push   %edx
  802145:	ff d0                	call   *%eax
  802147:	83 c4 10             	add    $0x10,%esp
}
  80214a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80214f:	a1 28 64 80 00       	mov    0x806428,%eax
  802154:	8b 40 48             	mov    0x48(%eax),%eax
  802157:	83 ec 04             	sub    $0x4,%esp
  80215a:	53                   	push   %ebx
  80215b:	50                   	push   %eax
  80215c:	68 8d 40 80 00       	push   $0x80408d
  802161:	e8 21 ea ff ff       	call   800b87 <cprintf>
		return -E_INVAL;
  802166:	83 c4 10             	add    $0x10,%esp
  802169:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80216e:	eb da                	jmp    80214a <read+0x5e>
		return -E_NOT_SUPP;
  802170:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802175:	eb d3                	jmp    80214a <read+0x5e>

00802177 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802177:	f3 0f 1e fb          	endbr32 
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	57                   	push   %edi
  80217f:	56                   	push   %esi
  802180:	53                   	push   %ebx
  802181:	83 ec 0c             	sub    $0xc,%esp
  802184:	8b 7d 08             	mov    0x8(%ebp),%edi
  802187:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80218a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80218f:	eb 02                	jmp    802193 <readn+0x1c>
  802191:	01 c3                	add    %eax,%ebx
  802193:	39 f3                	cmp    %esi,%ebx
  802195:	73 21                	jae    8021b8 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802197:	83 ec 04             	sub    $0x4,%esp
  80219a:	89 f0                	mov    %esi,%eax
  80219c:	29 d8                	sub    %ebx,%eax
  80219e:	50                   	push   %eax
  80219f:	89 d8                	mov    %ebx,%eax
  8021a1:	03 45 0c             	add    0xc(%ebp),%eax
  8021a4:	50                   	push   %eax
  8021a5:	57                   	push   %edi
  8021a6:	e8 41 ff ff ff       	call   8020ec <read>
		if (m < 0)
  8021ab:	83 c4 10             	add    $0x10,%esp
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	78 04                	js     8021b6 <readn+0x3f>
			return m;
		if (m == 0)
  8021b2:	75 dd                	jne    802191 <readn+0x1a>
  8021b4:	eb 02                	jmp    8021b8 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021b6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8021b8:	89 d8                	mov    %ebx,%eax
  8021ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021bd:	5b                   	pop    %ebx
  8021be:	5e                   	pop    %esi
  8021bf:	5f                   	pop    %edi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    

008021c2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8021c2:	f3 0f 1e fb          	endbr32 
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	53                   	push   %ebx
  8021ca:	83 ec 1c             	sub    $0x1c,%esp
  8021cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021d3:	50                   	push   %eax
  8021d4:	53                   	push   %ebx
  8021d5:	e8 8a fc ff ff       	call   801e64 <fd_lookup>
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 3a                	js     80221b <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021e1:	83 ec 08             	sub    $0x8,%esp
  8021e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e7:	50                   	push   %eax
  8021e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021eb:	ff 30                	pushl  (%eax)
  8021ed:	e8 c6 fc ff ff       	call   801eb8 <dev_lookup>
  8021f2:	83 c4 10             	add    $0x10,%esp
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	78 22                	js     80221b <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802200:	74 1e                	je     802220 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802202:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802205:	8b 52 0c             	mov    0xc(%edx),%edx
  802208:	85 d2                	test   %edx,%edx
  80220a:	74 35                	je     802241 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80220c:	83 ec 04             	sub    $0x4,%esp
  80220f:	ff 75 10             	pushl  0x10(%ebp)
  802212:	ff 75 0c             	pushl  0xc(%ebp)
  802215:	50                   	push   %eax
  802216:	ff d2                	call   *%edx
  802218:	83 c4 10             	add    $0x10,%esp
}
  80221b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802220:	a1 28 64 80 00       	mov    0x806428,%eax
  802225:	8b 40 48             	mov    0x48(%eax),%eax
  802228:	83 ec 04             	sub    $0x4,%esp
  80222b:	53                   	push   %ebx
  80222c:	50                   	push   %eax
  80222d:	68 a9 40 80 00       	push   $0x8040a9
  802232:	e8 50 e9 ff ff       	call   800b87 <cprintf>
		return -E_INVAL;
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223f:	eb da                	jmp    80221b <write+0x59>
		return -E_NOT_SUPP;
  802241:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802246:	eb d3                	jmp    80221b <write+0x59>

00802248 <seek>:

int
seek(int fdnum, off_t offset)
{
  802248:	f3 0f 1e fb          	endbr32 
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802252:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802255:	50                   	push   %eax
  802256:	ff 75 08             	pushl  0x8(%ebp)
  802259:	e8 06 fc ff ff       	call   801e64 <fd_lookup>
  80225e:	83 c4 10             	add    $0x10,%esp
  802261:	85 c0                	test   %eax,%eax
  802263:	78 0e                	js     802273 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  802265:	8b 55 0c             	mov    0xc(%ebp),%edx
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802275:	f3 0f 1e fb          	endbr32 
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	53                   	push   %ebx
  80227d:	83 ec 1c             	sub    $0x1c,%esp
  802280:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802283:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802286:	50                   	push   %eax
  802287:	53                   	push   %ebx
  802288:	e8 d7 fb ff ff       	call   801e64 <fd_lookup>
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	85 c0                	test   %eax,%eax
  802292:	78 37                	js     8022cb <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802294:	83 ec 08             	sub    $0x8,%esp
  802297:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80229a:	50                   	push   %eax
  80229b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229e:	ff 30                	pushl  (%eax)
  8022a0:	e8 13 fc ff ff       	call   801eb8 <dev_lookup>
  8022a5:	83 c4 10             	add    $0x10,%esp
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	78 1f                	js     8022cb <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022af:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8022b3:	74 1b                	je     8022d0 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8022b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b8:	8b 52 18             	mov    0x18(%edx),%edx
  8022bb:	85 d2                	test   %edx,%edx
  8022bd:	74 32                	je     8022f1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8022bf:	83 ec 08             	sub    $0x8,%esp
  8022c2:	ff 75 0c             	pushl  0xc(%ebp)
  8022c5:	50                   	push   %eax
  8022c6:	ff d2                	call   *%edx
  8022c8:	83 c4 10             	add    $0x10,%esp
}
  8022cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    
			thisenv->env_id, fdnum);
  8022d0:	a1 28 64 80 00       	mov    0x806428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8022d5:	8b 40 48             	mov    0x48(%eax),%eax
  8022d8:	83 ec 04             	sub    $0x4,%esp
  8022db:	53                   	push   %ebx
  8022dc:	50                   	push   %eax
  8022dd:	68 6c 40 80 00       	push   $0x80406c
  8022e2:	e8 a0 e8 ff ff       	call   800b87 <cprintf>
		return -E_INVAL;
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022ef:	eb da                	jmp    8022cb <ftruncate+0x56>
		return -E_NOT_SUPP;
  8022f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022f6:	eb d3                	jmp    8022cb <ftruncate+0x56>

008022f8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022f8:	f3 0f 1e fb          	endbr32 
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	53                   	push   %ebx
  802300:	83 ec 1c             	sub    $0x1c,%esp
  802303:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802306:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802309:	50                   	push   %eax
  80230a:	ff 75 08             	pushl  0x8(%ebp)
  80230d:	e8 52 fb ff ff       	call   801e64 <fd_lookup>
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	85 c0                	test   %eax,%eax
  802317:	78 4b                	js     802364 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802319:	83 ec 08             	sub    $0x8,%esp
  80231c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80231f:	50                   	push   %eax
  802320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802323:	ff 30                	pushl  (%eax)
  802325:	e8 8e fb ff ff       	call   801eb8 <dev_lookup>
  80232a:	83 c4 10             	add    $0x10,%esp
  80232d:	85 c0                	test   %eax,%eax
  80232f:	78 33                	js     802364 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802338:	74 2f                	je     802369 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80233a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80233d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802344:	00 00 00 
	stat->st_isdir = 0;
  802347:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80234e:	00 00 00 
	stat->st_dev = dev;
  802351:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802357:	83 ec 08             	sub    $0x8,%esp
  80235a:	53                   	push   %ebx
  80235b:	ff 75 f0             	pushl  -0x10(%ebp)
  80235e:	ff 50 14             	call   *0x14(%eax)
  802361:	83 c4 10             	add    $0x10,%esp
}
  802364:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802367:	c9                   	leave  
  802368:	c3                   	ret    
		return -E_NOT_SUPP;
  802369:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80236e:	eb f4                	jmp    802364 <fstat+0x6c>

00802370 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802370:	f3 0f 1e fb          	endbr32 
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
  802377:	56                   	push   %esi
  802378:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802379:	83 ec 08             	sub    $0x8,%esp
  80237c:	6a 00                	push   $0x0
  80237e:	ff 75 08             	pushl  0x8(%ebp)
  802381:	e8 fb 01 00 00       	call   802581 <open>
  802386:	89 c3                	mov    %eax,%ebx
  802388:	83 c4 10             	add    $0x10,%esp
  80238b:	85 c0                	test   %eax,%eax
  80238d:	78 1b                	js     8023aa <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80238f:	83 ec 08             	sub    $0x8,%esp
  802392:	ff 75 0c             	pushl  0xc(%ebp)
  802395:	50                   	push   %eax
  802396:	e8 5d ff ff ff       	call   8022f8 <fstat>
  80239b:	89 c6                	mov    %eax,%esi
	close(fd);
  80239d:	89 1c 24             	mov    %ebx,(%esp)
  8023a0:	e8 fd fb ff ff       	call   801fa2 <close>
	return r;
  8023a5:	83 c4 10             	add    $0x10,%esp
  8023a8:	89 f3                	mov    %esi,%ebx
}
  8023aa:	89 d8                	mov    %ebx,%eax
  8023ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5d                   	pop    %ebp
  8023b2:	c3                   	ret    

008023b3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
  8023b6:	56                   	push   %esi
  8023b7:	53                   	push   %ebx
  8023b8:	89 c6                	mov    %eax,%esi
  8023ba:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8023bc:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  8023c3:	74 27                	je     8023ec <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8023c5:	6a 07                	push   $0x7
  8023c7:	68 00 70 80 00       	push   $0x807000
  8023cc:	56                   	push   %esi
  8023cd:	ff 35 20 64 80 00    	pushl  0x806420
  8023d3:	e8 17 13 00 00       	call   8036ef <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8023d8:	83 c4 0c             	add    $0xc,%esp
  8023db:	6a 00                	push   $0x0
  8023dd:	53                   	push   %ebx
  8023de:	6a 00                	push   $0x0
  8023e0:	e8 85 12 00 00       	call   80366a <ipc_recv>
}
  8023e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023e8:	5b                   	pop    %ebx
  8023e9:	5e                   	pop    %esi
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023ec:	83 ec 0c             	sub    $0xc,%esp
  8023ef:	6a 01                	push   $0x1
  8023f1:	e8 51 13 00 00       	call   803747 <ipc_find_env>
  8023f6:	a3 20 64 80 00       	mov    %eax,0x806420
  8023fb:	83 c4 10             	add    $0x10,%esp
  8023fe:	eb c5                	jmp    8023c5 <fsipc+0x12>

00802400 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802400:	f3 0f 1e fb          	endbr32 
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	8b 40 0c             	mov    0xc(%eax),%eax
  802410:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  802415:	8b 45 0c             	mov    0xc(%ebp),%eax
  802418:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80241d:	ba 00 00 00 00       	mov    $0x0,%edx
  802422:	b8 02 00 00 00       	mov    $0x2,%eax
  802427:	e8 87 ff ff ff       	call   8023b3 <fsipc>
}
  80242c:	c9                   	leave  
  80242d:	c3                   	ret    

0080242e <devfile_flush>:
{
  80242e:	f3 0f 1e fb          	endbr32 
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	8b 40 0c             	mov    0xc(%eax),%eax
  80243e:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802443:	ba 00 00 00 00       	mov    $0x0,%edx
  802448:	b8 06 00 00 00       	mov    $0x6,%eax
  80244d:	e8 61 ff ff ff       	call   8023b3 <fsipc>
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <devfile_stat>:
{
  802454:	f3 0f 1e fb          	endbr32 
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	53                   	push   %ebx
  80245c:	83 ec 04             	sub    $0x4,%esp
  80245f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	8b 40 0c             	mov    0xc(%eax),%eax
  802468:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80246d:	ba 00 00 00 00       	mov    $0x0,%edx
  802472:	b8 05 00 00 00       	mov    $0x5,%eax
  802477:	e8 37 ff ff ff       	call   8023b3 <fsipc>
  80247c:	85 c0                	test   %eax,%eax
  80247e:	78 2c                	js     8024ac <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802480:	83 ec 08             	sub    $0x8,%esp
  802483:	68 00 70 80 00       	push   $0x807000
  802488:	53                   	push   %ebx
  802489:	e8 f7 ed ff ff       	call   801285 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80248e:	a1 80 70 80 00       	mov    0x807080,%eax
  802493:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802499:	a1 84 70 80 00       	mov    0x807084,%eax
  80249e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8024a4:	83 c4 10             	add    $0x10,%esp
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <devfile_write>:
{
  8024b1:	f3 0f 1e fb          	endbr32 
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 0c             	sub    $0xc,%esp
  8024bb:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8024be:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8024c4:	89 15 00 70 80 00    	mov    %edx,0x807000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8024ca:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8024cf:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8024d4:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8024d7:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8024dc:	50                   	push   %eax
  8024dd:	ff 75 0c             	pushl  0xc(%ebp)
  8024e0:	68 08 70 80 00       	push   $0x807008
  8024e5:	e8 51 ef ff ff       	call   80143b <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8024ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ef:	b8 04 00 00 00       	mov    $0x4,%eax
  8024f4:	e8 ba fe ff ff       	call   8023b3 <fsipc>
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <devfile_read>:
{
  8024fb:	f3 0f 1e fb          	endbr32 
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	56                   	push   %esi
  802503:	53                   	push   %ebx
  802504:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	8b 40 0c             	mov    0xc(%eax),%eax
  80250d:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  802512:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802518:	ba 00 00 00 00       	mov    $0x0,%edx
  80251d:	b8 03 00 00 00       	mov    $0x3,%eax
  802522:	e8 8c fe ff ff       	call   8023b3 <fsipc>
  802527:	89 c3                	mov    %eax,%ebx
  802529:	85 c0                	test   %eax,%eax
  80252b:	78 1f                	js     80254c <devfile_read+0x51>
	assert(r <= n);
  80252d:	39 f0                	cmp    %esi,%eax
  80252f:	77 24                	ja     802555 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  802531:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802536:	7f 33                	jg     80256b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802538:	83 ec 04             	sub    $0x4,%esp
  80253b:	50                   	push   %eax
  80253c:	68 00 70 80 00       	push   $0x807000
  802541:	ff 75 0c             	pushl  0xc(%ebp)
  802544:	e8 f2 ee ff ff       	call   80143b <memmove>
	return r;
  802549:	83 c4 10             	add    $0x10,%esp
}
  80254c:	89 d8                	mov    %ebx,%eax
  80254e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5d                   	pop    %ebp
  802554:	c3                   	ret    
	assert(r <= n);
  802555:	68 dc 40 80 00       	push   $0x8040dc
  80255a:	68 87 3b 80 00       	push   $0x803b87
  80255f:	6a 7c                	push   $0x7c
  802561:	68 e3 40 80 00       	push   $0x8040e3
  802566:	e8 35 e5 ff ff       	call   800aa0 <_panic>
	assert(r <= PGSIZE);
  80256b:	68 ee 40 80 00       	push   $0x8040ee
  802570:	68 87 3b 80 00       	push   $0x803b87
  802575:	6a 7d                	push   $0x7d
  802577:	68 e3 40 80 00       	push   $0x8040e3
  80257c:	e8 1f e5 ff ff       	call   800aa0 <_panic>

00802581 <open>:
{
  802581:	f3 0f 1e fb          	endbr32 
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	56                   	push   %esi
  802589:	53                   	push   %ebx
  80258a:	83 ec 1c             	sub    $0x1c,%esp
  80258d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802590:	56                   	push   %esi
  802591:	e8 ac ec ff ff       	call   801242 <strlen>
  802596:	83 c4 10             	add    $0x10,%esp
  802599:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80259e:	7f 6c                	jg     80260c <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8025a0:	83 ec 0c             	sub    $0xc,%esp
  8025a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025a6:	50                   	push   %eax
  8025a7:	e8 62 f8 ff ff       	call   801e0e <fd_alloc>
  8025ac:	89 c3                	mov    %eax,%ebx
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	78 3c                	js     8025f1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8025b5:	83 ec 08             	sub    $0x8,%esp
  8025b8:	56                   	push   %esi
  8025b9:	68 00 70 80 00       	push   $0x807000
  8025be:	e8 c2 ec ff ff       	call   801285 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8025c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c6:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8025cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d3:	e8 db fd ff ff       	call   8023b3 <fsipc>
  8025d8:	89 c3                	mov    %eax,%ebx
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	78 19                	js     8025fa <open+0x79>
	return fd2num(fd);
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e7:	e8 f3 f7 ff ff       	call   801ddf <fd2num>
  8025ec:	89 c3                	mov    %eax,%ebx
  8025ee:	83 c4 10             	add    $0x10,%esp
}
  8025f1:	89 d8                	mov    %ebx,%eax
  8025f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025f6:	5b                   	pop    %ebx
  8025f7:	5e                   	pop    %esi
  8025f8:	5d                   	pop    %ebp
  8025f9:	c3                   	ret    
		fd_close(fd, 0);
  8025fa:	83 ec 08             	sub    $0x8,%esp
  8025fd:	6a 00                	push   $0x0
  8025ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802602:	e8 10 f9 ff ff       	call   801f17 <fd_close>
		return r;
  802607:	83 c4 10             	add    $0x10,%esp
  80260a:	eb e5                	jmp    8025f1 <open+0x70>
		return -E_BAD_PATH;
  80260c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802611:	eb de                	jmp    8025f1 <open+0x70>

00802613 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802613:	f3 0f 1e fb          	endbr32 
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80261d:	ba 00 00 00 00       	mov    $0x0,%edx
  802622:	b8 08 00 00 00       	mov    $0x8,%eax
  802627:	e8 87 fd ff ff       	call   8023b3 <fsipc>
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80262e:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802632:	7f 01                	jg     802635 <writebuf+0x7>
  802634:	c3                   	ret    
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	53                   	push   %ebx
  802639:	83 ec 08             	sub    $0x8,%esp
  80263c:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80263e:	ff 70 04             	pushl  0x4(%eax)
  802641:	8d 40 10             	lea    0x10(%eax),%eax
  802644:	50                   	push   %eax
  802645:	ff 33                	pushl  (%ebx)
  802647:	e8 76 fb ff ff       	call   8021c2 <write>
		if (result > 0)
  80264c:	83 c4 10             	add    $0x10,%esp
  80264f:	85 c0                	test   %eax,%eax
  802651:	7e 03                	jle    802656 <writebuf+0x28>
			b->result += result;
  802653:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802656:	39 43 04             	cmp    %eax,0x4(%ebx)
  802659:	74 0d                	je     802668 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80265b:	85 c0                	test   %eax,%eax
  80265d:	ba 00 00 00 00       	mov    $0x0,%edx
  802662:	0f 4f c2             	cmovg  %edx,%eax
  802665:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <putch>:

static void
putch(int ch, void *thunk)
{
  80266d:	f3 0f 1e fb          	endbr32 
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	53                   	push   %ebx
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80267b:	8b 53 04             	mov    0x4(%ebx),%edx
  80267e:	8d 42 01             	lea    0x1(%edx),%eax
  802681:	89 43 04             	mov    %eax,0x4(%ebx)
  802684:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802687:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80268b:	3d 00 01 00 00       	cmp    $0x100,%eax
  802690:	74 06                	je     802698 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  802692:	83 c4 04             	add    $0x4,%esp
  802695:	5b                   	pop    %ebx
  802696:	5d                   	pop    %ebp
  802697:	c3                   	ret    
		writebuf(b);
  802698:	89 d8                	mov    %ebx,%eax
  80269a:	e8 8f ff ff ff       	call   80262e <writebuf>
		b->idx = 0;
  80269f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8026a6:	eb ea                	jmp    802692 <putch+0x25>

008026a8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8026a8:	f3 0f 1e fb          	endbr32 
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
  8026af:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8026be:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8026c5:	00 00 00 
	b.result = 0;
  8026c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8026cf:	00 00 00 
	b.error = 1;
  8026d2:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8026d9:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8026dc:	ff 75 10             	pushl  0x10(%ebp)
  8026df:	ff 75 0c             	pushl  0xc(%ebp)
  8026e2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8026e8:	50                   	push   %eax
  8026e9:	68 6d 26 80 00       	push   $0x80266d
  8026ee:	e8 97 e5 ff ff       	call   800c8a <vprintfmt>
	if (b.idx > 0)
  8026f3:	83 c4 10             	add    $0x10,%esp
  8026f6:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8026fd:	7f 11                	jg     802710 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8026ff:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    
		writebuf(&b);
  802710:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802716:	e8 13 ff ff ff       	call   80262e <writebuf>
  80271b:	eb e2                	jmp    8026ff <vfprintf+0x57>

0080271d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80271d:	f3 0f 1e fb          	endbr32 
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
  802724:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802727:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80272a:	50                   	push   %eax
  80272b:	ff 75 0c             	pushl  0xc(%ebp)
  80272e:	ff 75 08             	pushl  0x8(%ebp)
  802731:	e8 72 ff ff ff       	call   8026a8 <vfprintf>
	va_end(ap);

	return cnt;
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <printf>:

int
printf(const char *fmt, ...)
{
  802738:	f3 0f 1e fb          	endbr32 
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
  80273f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802742:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802745:	50                   	push   %eax
  802746:	ff 75 08             	pushl  0x8(%ebp)
  802749:	6a 01                	push   $0x1
  80274b:	e8 58 ff ff ff       	call   8026a8 <vfprintf>
	va_end(ap);

	return cnt;
}
  802750:	c9                   	leave  
  802751:	c3                   	ret    

00802752 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802752:	f3 0f 1e fb          	endbr32 
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	57                   	push   %edi
  80275a:	56                   	push   %esi
  80275b:	53                   	push   %ebx
  80275c:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802762:	6a 00                	push   $0x0
  802764:	ff 75 08             	pushl  0x8(%ebp)
  802767:	e8 15 fe ff ff       	call   802581 <open>
  80276c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802772:	83 c4 10             	add    $0x10,%esp
  802775:	85 c0                	test   %eax,%eax
  802777:	0f 88 e7 04 00 00    	js     802c64 <spawn+0x512>
  80277d:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80277f:	83 ec 04             	sub    $0x4,%esp
  802782:	68 00 02 00 00       	push   $0x200
  802787:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80278d:	50                   	push   %eax
  80278e:	52                   	push   %edx
  80278f:	e8 e3 f9 ff ff       	call   802177 <readn>
  802794:	83 c4 10             	add    $0x10,%esp
  802797:	3d 00 02 00 00       	cmp    $0x200,%eax
  80279c:	75 7e                	jne    80281c <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  80279e:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8027a5:	45 4c 46 
  8027a8:	75 72                	jne    80281c <spawn+0xca>
  8027aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8027af:	cd 30                	int    $0x30
  8027b1:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8027b7:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	0f 88 93 04 00 00    	js     802c58 <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8027c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8027ca:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8027cd:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8027d3:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8027d9:	b9 11 00 00 00       	mov    $0x11,%ecx
  8027de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8027e0:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8027e6:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8027ec:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8027f1:	be 00 00 00 00       	mov    $0x0,%esi
  8027f6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8027f9:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  802800:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	74 4d                	je     802854 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  802807:	83 ec 0c             	sub    $0xc,%esp
  80280a:	50                   	push   %eax
  80280b:	e8 32 ea ff ff       	call   801242 <strlen>
  802810:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802814:	83 c3 01             	add    $0x1,%ebx
  802817:	83 c4 10             	add    $0x10,%esp
  80281a:	eb dd                	jmp    8027f9 <spawn+0xa7>
		close(fd);
  80281c:	83 ec 0c             	sub    $0xc,%esp
  80281f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802825:	e8 78 f7 ff ff       	call   801fa2 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80282a:	83 c4 0c             	add    $0xc,%esp
  80282d:	68 7f 45 4c 46       	push   $0x464c457f
  802832:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802838:	68 fa 40 80 00       	push   $0x8040fa
  80283d:	e8 45 e3 ff ff       	call   800b87 <cprintf>
		return -E_NOT_EXEC;
  802842:	83 c4 10             	add    $0x10,%esp
  802845:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  80284c:	ff ff ff 
  80284f:	e9 10 04 00 00       	jmp    802c64 <spawn+0x512>
  802854:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80285a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802860:	bf 00 10 40 00       	mov    $0x401000,%edi
  802865:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802867:	89 fa                	mov    %edi,%edx
  802869:	83 e2 fc             	and    $0xfffffffc,%edx
  80286c:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802873:	29 c2                	sub    %eax,%edx
  802875:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80287b:	8d 42 f8             	lea    -0x8(%edx),%eax
  80287e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802883:	0f 86 fe 03 00 00    	jbe    802c87 <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	6a 07                	push   $0x7
  80288e:	68 00 00 40 00       	push   $0x400000
  802893:	6a 00                	push   $0x0
  802895:	e8 2d ee ff ff       	call   8016c7 <sys_page_alloc>
  80289a:	83 c4 10             	add    $0x10,%esp
  80289d:	85 c0                	test   %eax,%eax
  80289f:	0f 88 e7 03 00 00    	js     802c8c <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8028a5:	be 00 00 00 00       	mov    $0x0,%esi
  8028aa:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8028b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8028b3:	eb 30                	jmp    8028e5 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  8028b5:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8028bb:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8028c1:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8028c4:	83 ec 08             	sub    $0x8,%esp
  8028c7:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8028ca:	57                   	push   %edi
  8028cb:	e8 b5 e9 ff ff       	call   801285 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8028d0:	83 c4 04             	add    $0x4,%esp
  8028d3:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8028d6:	e8 67 e9 ff ff       	call   801242 <strlen>
  8028db:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8028df:	83 c6 01             	add    $0x1,%esi
  8028e2:	83 c4 10             	add    $0x10,%esp
  8028e5:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8028eb:	7f c8                	jg     8028b5 <spawn+0x163>
	}
	argv_store[argc] = 0;
  8028ed:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8028f3:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8028f9:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802900:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802906:	0f 85 86 00 00 00    	jne    802992 <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80290c:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802912:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  802918:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  80291b:	89 c8                	mov    %ecx,%eax
  80291d:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802923:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802926:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80292b:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802931:	83 ec 0c             	sub    $0xc,%esp
  802934:	6a 07                	push   $0x7
  802936:	68 00 d0 bf ee       	push   $0xeebfd000
  80293b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802941:	68 00 00 40 00       	push   $0x400000
  802946:	6a 00                	push   $0x0
  802948:	e8 c1 ed ff ff       	call   80170e <sys_page_map>
  80294d:	89 c3                	mov    %eax,%ebx
  80294f:	83 c4 20             	add    $0x20,%esp
  802952:	85 c0                	test   %eax,%eax
  802954:	0f 88 3a 03 00 00    	js     802c94 <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80295a:	83 ec 08             	sub    $0x8,%esp
  80295d:	68 00 00 40 00       	push   $0x400000
  802962:	6a 00                	push   $0x0
  802964:	e8 eb ed ff ff       	call   801754 <sys_page_unmap>
  802969:	89 c3                	mov    %eax,%ebx
  80296b:	83 c4 10             	add    $0x10,%esp
  80296e:	85 c0                	test   %eax,%eax
  802970:	0f 88 1e 03 00 00    	js     802c94 <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802976:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80297c:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802983:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  80298a:	00 00 00 
  80298d:	e9 4f 01 00 00       	jmp    802ae1 <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802992:	68 58 41 80 00       	push   $0x804158
  802997:	68 87 3b 80 00       	push   $0x803b87
  80299c:	68 f2 00 00 00       	push   $0xf2
  8029a1:	68 14 41 80 00       	push   $0x804114
  8029a6:	e8 f5 e0 ff ff       	call   800aa0 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8029ab:	83 ec 04             	sub    $0x4,%esp
  8029ae:	6a 07                	push   $0x7
  8029b0:	68 00 00 40 00       	push   $0x400000
  8029b5:	6a 00                	push   $0x0
  8029b7:	e8 0b ed ff ff       	call   8016c7 <sys_page_alloc>
  8029bc:	83 c4 10             	add    $0x10,%esp
  8029bf:	85 c0                	test   %eax,%eax
  8029c1:	0f 88 ab 02 00 00    	js     802c72 <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8029c7:	83 ec 08             	sub    $0x8,%esp
  8029ca:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8029d0:	01 f0                	add    %esi,%eax
  8029d2:	50                   	push   %eax
  8029d3:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8029d9:	e8 6a f8 ff ff       	call   802248 <seek>
  8029de:	83 c4 10             	add    $0x10,%esp
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	0f 88 90 02 00 00    	js     802c79 <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8029e9:	83 ec 04             	sub    $0x4,%esp
  8029ec:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8029f2:	29 f0                	sub    %esi,%eax
  8029f4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8029f9:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8029fe:	0f 47 c1             	cmova  %ecx,%eax
  802a01:	50                   	push   %eax
  802a02:	68 00 00 40 00       	push   $0x400000
  802a07:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802a0d:	e8 65 f7 ff ff       	call   802177 <readn>
  802a12:	83 c4 10             	add    $0x10,%esp
  802a15:	85 c0                	test   %eax,%eax
  802a17:	0f 88 63 02 00 00    	js     802c80 <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802a1d:	83 ec 0c             	sub    $0xc,%esp
  802a20:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802a26:	53                   	push   %ebx
  802a27:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802a2d:	68 00 00 40 00       	push   $0x400000
  802a32:	6a 00                	push   $0x0
  802a34:	e8 d5 ec ff ff       	call   80170e <sys_page_map>
  802a39:	83 c4 20             	add    $0x20,%esp
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	78 7c                	js     802abc <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802a40:	83 ec 08             	sub    $0x8,%esp
  802a43:	68 00 00 40 00       	push   $0x400000
  802a48:	6a 00                	push   $0x0
  802a4a:	e8 05 ed ff ff       	call   801754 <sys_page_unmap>
  802a4f:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802a52:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802a58:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802a5e:	89 fe                	mov    %edi,%esi
  802a60:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802a66:	76 69                	jbe    802ad1 <spawn+0x37f>
		if (i >= filesz) {
  802a68:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802a6e:	0f 87 37 ff ff ff    	ja     8029ab <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802a74:	83 ec 04             	sub    $0x4,%esp
  802a77:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802a7d:	53                   	push   %ebx
  802a7e:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802a84:	e8 3e ec ff ff       	call   8016c7 <sys_page_alloc>
  802a89:	83 c4 10             	add    $0x10,%esp
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	79 c2                	jns    802a52 <spawn+0x300>
  802a90:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802a92:	83 ec 0c             	sub    $0xc,%esp
  802a95:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802a9b:	e8 9c eb ff ff       	call   80163c <sys_env_destroy>
	close(fd);
  802aa0:	83 c4 04             	add    $0x4,%esp
  802aa3:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802aa9:	e8 f4 f4 ff ff       	call   801fa2 <close>
	return r;
  802aae:	83 c4 10             	add    $0x10,%esp
  802ab1:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802ab7:	e9 a8 01 00 00       	jmp    802c64 <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  802abc:	50                   	push   %eax
  802abd:	68 20 41 80 00       	push   $0x804120
  802ac2:	68 25 01 00 00       	push   $0x125
  802ac7:	68 14 41 80 00       	push   $0x804114
  802acc:	e8 cf df ff ff       	call   800aa0 <_panic>
  802ad1:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ad7:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802ade:	83 c6 20             	add    $0x20,%esi
  802ae1:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802ae8:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802aee:	7e 6d                	jle    802b5d <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  802af0:	83 3e 01             	cmpl   $0x1,(%esi)
  802af3:	75 e2                	jne    802ad7 <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802af5:	8b 46 18             	mov    0x18(%esi),%eax
  802af8:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802afb:	83 f8 01             	cmp    $0x1,%eax
  802afe:	19 c0                	sbb    %eax,%eax
  802b00:	83 e0 fe             	and    $0xfffffffe,%eax
  802b03:	83 c0 07             	add    $0x7,%eax
  802b06:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802b0c:	8b 4e 04             	mov    0x4(%esi),%ecx
  802b0f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802b15:	8b 56 10             	mov    0x10(%esi),%edx
  802b18:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802b1e:	8b 7e 14             	mov    0x14(%esi),%edi
  802b21:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802b27:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802b2a:	89 d8                	mov    %ebx,%eax
  802b2c:	25 ff 0f 00 00       	and    $0xfff,%eax
  802b31:	74 1a                	je     802b4d <spawn+0x3fb>
		va -= i;
  802b33:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802b35:	01 c7                	add    %eax,%edi
  802b37:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802b3d:	01 c2                	add    %eax,%edx
  802b3f:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802b45:	29 c1                	sub    %eax,%ecx
  802b47:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802b4d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b52:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802b58:	e9 01 ff ff ff       	jmp    802a5e <spawn+0x30c>
	close(fd);
  802b5d:	83 ec 0c             	sub    $0xc,%esp
  802b60:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b66:	e8 37 f4 ff ff       	call   801fa2 <close>
  802b6b:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  802b6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b73:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802b79:	eb 0e                	jmp    802b89 <spawn+0x437>
  802b7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802b81:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802b87:	74 5a                	je     802be3 <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  802b89:	89 d8                	mov    %ebx,%eax
  802b8b:	c1 e8 16             	shr    $0x16,%eax
  802b8e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802b95:	a8 01                	test   $0x1,%al
  802b97:	74 e2                	je     802b7b <spawn+0x429>
  802b99:	89 d8                	mov    %ebx,%eax
  802b9b:	c1 e8 0c             	shr    $0xc,%eax
  802b9e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802ba5:	f6 c2 01             	test   $0x1,%dl
  802ba8:	74 d1                	je     802b7b <spawn+0x429>
  802baa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802bb1:	f6 c2 04             	test   $0x4,%dl
  802bb4:	74 c5                	je     802b7b <spawn+0x429>
  802bb6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802bbd:	f6 c6 04             	test   $0x4,%dh
  802bc0:	74 b9                	je     802b7b <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  802bc2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802bc9:	83 ec 0c             	sub    $0xc,%esp
  802bcc:	25 07 0e 00 00       	and    $0xe07,%eax
  802bd1:	50                   	push   %eax
  802bd2:	53                   	push   %ebx
  802bd3:	56                   	push   %esi
  802bd4:	53                   	push   %ebx
  802bd5:	6a 00                	push   $0x0
  802bd7:	e8 32 eb ff ff       	call   80170e <sys_page_map>
  802bdc:	83 c4 20             	add    $0x20,%esp
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	79 98                	jns    802b7b <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802be3:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802bea:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802bed:	83 ec 08             	sub    $0x8,%esp
  802bf0:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802bf6:	50                   	push   %eax
  802bf7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802bfd:	e8 de eb ff ff       	call   8017e0 <sys_env_set_trapframe>
  802c02:	83 c4 10             	add    $0x10,%esp
  802c05:	85 c0                	test   %eax,%eax
  802c07:	78 25                	js     802c2e <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802c09:	83 ec 08             	sub    $0x8,%esp
  802c0c:	6a 02                	push   $0x2
  802c0e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802c14:	e8 81 eb ff ff       	call   80179a <sys_env_set_status>
  802c19:	83 c4 10             	add    $0x10,%esp
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	78 23                	js     802c43 <spawn+0x4f1>
	return child;
  802c20:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802c26:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802c2c:	eb 36                	jmp    802c64 <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  802c2e:	50                   	push   %eax
  802c2f:	68 3d 41 80 00       	push   $0x80413d
  802c34:	68 86 00 00 00       	push   $0x86
  802c39:	68 14 41 80 00       	push   $0x804114
  802c3e:	e8 5d de ff ff       	call   800aa0 <_panic>
		panic("sys_env_set_status: %e", r);
  802c43:	50                   	push   %eax
  802c44:	68 1e 40 80 00       	push   $0x80401e
  802c49:	68 89 00 00 00       	push   $0x89
  802c4e:	68 14 41 80 00       	push   $0x804114
  802c53:	e8 48 de ff ff       	call   800aa0 <_panic>
		return r;
  802c58:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802c5e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802c64:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c6d:	5b                   	pop    %ebx
  802c6e:	5e                   	pop    %esi
  802c6f:	5f                   	pop    %edi
  802c70:	5d                   	pop    %ebp
  802c71:	c3                   	ret    
  802c72:	89 c7                	mov    %eax,%edi
  802c74:	e9 19 fe ff ff       	jmp    802a92 <spawn+0x340>
  802c79:	89 c7                	mov    %eax,%edi
  802c7b:	e9 12 fe ff ff       	jmp    802a92 <spawn+0x340>
  802c80:	89 c7                	mov    %eax,%edi
  802c82:	e9 0b fe ff ff       	jmp    802a92 <spawn+0x340>
		return -E_NO_MEM;
  802c87:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  802c8c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802c92:	eb d0                	jmp    802c64 <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  802c94:	83 ec 08             	sub    $0x8,%esp
  802c97:	68 00 00 40 00       	push   $0x400000
  802c9c:	6a 00                	push   $0x0
  802c9e:	e8 b1 ea ff ff       	call   801754 <sys_page_unmap>
  802ca3:	83 c4 10             	add    $0x10,%esp
  802ca6:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802cac:	eb b6                	jmp    802c64 <spawn+0x512>

00802cae <spawnl>:
{
  802cae:	f3 0f 1e fb          	endbr32 
  802cb2:	55                   	push   %ebp
  802cb3:	89 e5                	mov    %esp,%ebp
  802cb5:	57                   	push   %edi
  802cb6:	56                   	push   %esi
  802cb7:	53                   	push   %ebx
  802cb8:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802cbb:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802cbe:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802cc3:	8d 4a 04             	lea    0x4(%edx),%ecx
  802cc6:	83 3a 00             	cmpl   $0x0,(%edx)
  802cc9:	74 07                	je     802cd2 <spawnl+0x24>
		argc++;
  802ccb:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802cce:	89 ca                	mov    %ecx,%edx
  802cd0:	eb f1                	jmp    802cc3 <spawnl+0x15>
	const char *argv[argc+2];
  802cd2:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802cd9:	89 d1                	mov    %edx,%ecx
  802cdb:	83 e1 f0             	and    $0xfffffff0,%ecx
  802cde:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802ce4:	89 e6                	mov    %esp,%esi
  802ce6:	29 d6                	sub    %edx,%esi
  802ce8:	89 f2                	mov    %esi,%edx
  802cea:	39 d4                	cmp    %edx,%esp
  802cec:	74 10                	je     802cfe <spawnl+0x50>
  802cee:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  802cf4:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802cfb:	00 
  802cfc:	eb ec                	jmp    802cea <spawnl+0x3c>
  802cfe:	89 ca                	mov    %ecx,%edx
  802d00:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802d06:	29 d4                	sub    %edx,%esp
  802d08:	85 d2                	test   %edx,%edx
  802d0a:	74 05                	je     802d11 <spawnl+0x63>
  802d0c:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  802d11:	8d 74 24 03          	lea    0x3(%esp),%esi
  802d15:	89 f2                	mov    %esi,%edx
  802d17:	c1 ea 02             	shr    $0x2,%edx
  802d1a:	83 e6 fc             	and    $0xfffffffc,%esi
  802d1d:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802d1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d22:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802d29:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802d30:	00 
	va_start(vl, arg0);
  802d31:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802d34:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802d36:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3b:	eb 0b                	jmp    802d48 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  802d3d:	83 c0 01             	add    $0x1,%eax
  802d40:	8b 39                	mov    (%ecx),%edi
  802d42:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802d45:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802d48:	39 d0                	cmp    %edx,%eax
  802d4a:	75 f1                	jne    802d3d <spawnl+0x8f>
	return spawn(prog, argv);
  802d4c:	83 ec 08             	sub    $0x8,%esp
  802d4f:	56                   	push   %esi
  802d50:	ff 75 08             	pushl  0x8(%ebp)
  802d53:	e8 fa f9 ff ff       	call   802752 <spawn>
}
  802d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d5b:	5b                   	pop    %ebx
  802d5c:	5e                   	pop    %esi
  802d5d:	5f                   	pop    %edi
  802d5e:	5d                   	pop    %ebp
  802d5f:	c3                   	ret    

00802d60 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802d60:	f3 0f 1e fb          	endbr32 
  802d64:	55                   	push   %ebp
  802d65:	89 e5                	mov    %esp,%ebp
  802d67:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802d6a:	68 7e 41 80 00       	push   $0x80417e
  802d6f:	ff 75 0c             	pushl  0xc(%ebp)
  802d72:	e8 0e e5 ff ff       	call   801285 <strcpy>
	return 0;
}
  802d77:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7c:	c9                   	leave  
  802d7d:	c3                   	ret    

00802d7e <devsock_close>:
{
  802d7e:	f3 0f 1e fb          	endbr32 
  802d82:	55                   	push   %ebp
  802d83:	89 e5                	mov    %esp,%ebp
  802d85:	53                   	push   %ebx
  802d86:	83 ec 10             	sub    $0x10,%esp
  802d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802d8c:	53                   	push   %ebx
  802d8d:	e8 f2 09 00 00       	call   803784 <pageref>
  802d92:	89 c2                	mov    %eax,%edx
  802d94:	83 c4 10             	add    $0x10,%esp
		return 0;
  802d97:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  802d9c:	83 fa 01             	cmp    $0x1,%edx
  802d9f:	74 05                	je     802da6 <devsock_close+0x28>
}
  802da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802da6:	83 ec 0c             	sub    $0xc,%esp
  802da9:	ff 73 0c             	pushl  0xc(%ebx)
  802dac:	e8 e3 02 00 00       	call   803094 <nsipc_close>
  802db1:	83 c4 10             	add    $0x10,%esp
  802db4:	eb eb                	jmp    802da1 <devsock_close+0x23>

00802db6 <devsock_write>:
{
  802db6:	f3 0f 1e fb          	endbr32 
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
  802dbd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802dc0:	6a 00                	push   $0x0
  802dc2:	ff 75 10             	pushl  0x10(%ebp)
  802dc5:	ff 75 0c             	pushl  0xc(%ebp)
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	ff 70 0c             	pushl  0xc(%eax)
  802dce:	e8 b5 03 00 00       	call   803188 <nsipc_send>
}
  802dd3:	c9                   	leave  
  802dd4:	c3                   	ret    

00802dd5 <devsock_read>:
{
  802dd5:	f3 0f 1e fb          	endbr32 
  802dd9:	55                   	push   %ebp
  802dda:	89 e5                	mov    %esp,%ebp
  802ddc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802ddf:	6a 00                	push   $0x0
  802de1:	ff 75 10             	pushl  0x10(%ebp)
  802de4:	ff 75 0c             	pushl  0xc(%ebp)
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	ff 70 0c             	pushl  0xc(%eax)
  802ded:	e8 1f 03 00 00       	call   803111 <nsipc_recv>
}
  802df2:	c9                   	leave  
  802df3:	c3                   	ret    

00802df4 <fd2sockid>:
{
  802df4:	55                   	push   %ebp
  802df5:	89 e5                	mov    %esp,%ebp
  802df7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802dfa:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802dfd:	52                   	push   %edx
  802dfe:	50                   	push   %eax
  802dff:	e8 60 f0 ff ff       	call   801e64 <fd_lookup>
  802e04:	83 c4 10             	add    $0x10,%esp
  802e07:	85 c0                	test   %eax,%eax
  802e09:	78 10                	js     802e1b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  802e14:	39 08                	cmp    %ecx,(%eax)
  802e16:	75 05                	jne    802e1d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802e1b:	c9                   	leave  
  802e1c:	c3                   	ret    
		return -E_NOT_SUPP;
  802e1d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e22:	eb f7                	jmp    802e1b <fd2sockid+0x27>

00802e24 <alloc_sockfd>:
{
  802e24:	55                   	push   %ebp
  802e25:	89 e5                	mov    %esp,%ebp
  802e27:	56                   	push   %esi
  802e28:	53                   	push   %ebx
  802e29:	83 ec 1c             	sub    $0x1c,%esp
  802e2c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802e2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e31:	50                   	push   %eax
  802e32:	e8 d7 ef ff ff       	call   801e0e <fd_alloc>
  802e37:	89 c3                	mov    %eax,%ebx
  802e39:	83 c4 10             	add    $0x10,%esp
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	78 43                	js     802e83 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	68 07 04 00 00       	push   $0x407
  802e48:	ff 75 f4             	pushl  -0xc(%ebp)
  802e4b:	6a 00                	push   $0x0
  802e4d:	e8 75 e8 ff ff       	call   8016c7 <sys_page_alloc>
  802e52:	89 c3                	mov    %eax,%ebx
  802e54:	83 c4 10             	add    $0x10,%esp
  802e57:	85 c0                	test   %eax,%eax
  802e59:	78 28                	js     802e83 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  802e64:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802e70:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802e73:	83 ec 0c             	sub    $0xc,%esp
  802e76:	50                   	push   %eax
  802e77:	e8 63 ef ff ff       	call   801ddf <fd2num>
  802e7c:	89 c3                	mov    %eax,%ebx
  802e7e:	83 c4 10             	add    $0x10,%esp
  802e81:	eb 0c                	jmp    802e8f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802e83:	83 ec 0c             	sub    $0xc,%esp
  802e86:	56                   	push   %esi
  802e87:	e8 08 02 00 00       	call   803094 <nsipc_close>
		return r;
  802e8c:	83 c4 10             	add    $0x10,%esp
}
  802e8f:	89 d8                	mov    %ebx,%eax
  802e91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e94:	5b                   	pop    %ebx
  802e95:	5e                   	pop    %esi
  802e96:	5d                   	pop    %ebp
  802e97:	c3                   	ret    

00802e98 <accept>:
{
  802e98:	f3 0f 1e fb          	endbr32 
  802e9c:	55                   	push   %ebp
  802e9d:	89 e5                	mov    %esp,%ebp
  802e9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	e8 4a ff ff ff       	call   802df4 <fd2sockid>
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	78 1b                	js     802ec9 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802eae:	83 ec 04             	sub    $0x4,%esp
  802eb1:	ff 75 10             	pushl  0x10(%ebp)
  802eb4:	ff 75 0c             	pushl  0xc(%ebp)
  802eb7:	50                   	push   %eax
  802eb8:	e8 22 01 00 00       	call   802fdf <nsipc_accept>
  802ebd:	83 c4 10             	add    $0x10,%esp
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	78 05                	js     802ec9 <accept+0x31>
	return alloc_sockfd(r);
  802ec4:	e8 5b ff ff ff       	call   802e24 <alloc_sockfd>
}
  802ec9:	c9                   	leave  
  802eca:	c3                   	ret    

00802ecb <bind>:
{
  802ecb:	f3 0f 1e fb          	endbr32 
  802ecf:	55                   	push   %ebp
  802ed0:	89 e5                	mov    %esp,%ebp
  802ed2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	e8 17 ff ff ff       	call   802df4 <fd2sockid>
  802edd:	85 c0                	test   %eax,%eax
  802edf:	78 12                	js     802ef3 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  802ee1:	83 ec 04             	sub    $0x4,%esp
  802ee4:	ff 75 10             	pushl  0x10(%ebp)
  802ee7:	ff 75 0c             	pushl  0xc(%ebp)
  802eea:	50                   	push   %eax
  802eeb:	e8 45 01 00 00       	call   803035 <nsipc_bind>
  802ef0:	83 c4 10             	add    $0x10,%esp
}
  802ef3:	c9                   	leave  
  802ef4:	c3                   	ret    

00802ef5 <shutdown>:
{
  802ef5:	f3 0f 1e fb          	endbr32 
  802ef9:	55                   	push   %ebp
  802efa:	89 e5                	mov    %esp,%ebp
  802efc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	e8 ed fe ff ff       	call   802df4 <fd2sockid>
  802f07:	85 c0                	test   %eax,%eax
  802f09:	78 0f                	js     802f1a <shutdown+0x25>
	return nsipc_shutdown(r, how);
  802f0b:	83 ec 08             	sub    $0x8,%esp
  802f0e:	ff 75 0c             	pushl  0xc(%ebp)
  802f11:	50                   	push   %eax
  802f12:	e8 57 01 00 00       	call   80306e <nsipc_shutdown>
  802f17:	83 c4 10             	add    $0x10,%esp
}
  802f1a:	c9                   	leave  
  802f1b:	c3                   	ret    

00802f1c <connect>:
{
  802f1c:	f3 0f 1e fb          	endbr32 
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
  802f23:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	e8 c6 fe ff ff       	call   802df4 <fd2sockid>
  802f2e:	85 c0                	test   %eax,%eax
  802f30:	78 12                	js     802f44 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  802f32:	83 ec 04             	sub    $0x4,%esp
  802f35:	ff 75 10             	pushl  0x10(%ebp)
  802f38:	ff 75 0c             	pushl  0xc(%ebp)
  802f3b:	50                   	push   %eax
  802f3c:	e8 71 01 00 00       	call   8030b2 <nsipc_connect>
  802f41:	83 c4 10             	add    $0x10,%esp
}
  802f44:	c9                   	leave  
  802f45:	c3                   	ret    

00802f46 <listen>:
{
  802f46:	f3 0f 1e fb          	endbr32 
  802f4a:	55                   	push   %ebp
  802f4b:	89 e5                	mov    %esp,%ebp
  802f4d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	e8 9c fe ff ff       	call   802df4 <fd2sockid>
  802f58:	85 c0                	test   %eax,%eax
  802f5a:	78 0f                	js     802f6b <listen+0x25>
	return nsipc_listen(r, backlog);
  802f5c:	83 ec 08             	sub    $0x8,%esp
  802f5f:	ff 75 0c             	pushl  0xc(%ebp)
  802f62:	50                   	push   %eax
  802f63:	e8 83 01 00 00       	call   8030eb <nsipc_listen>
  802f68:	83 c4 10             	add    $0x10,%esp
}
  802f6b:	c9                   	leave  
  802f6c:	c3                   	ret    

00802f6d <socket>:

int
socket(int domain, int type, int protocol)
{
  802f6d:	f3 0f 1e fb          	endbr32 
  802f71:	55                   	push   %ebp
  802f72:	89 e5                	mov    %esp,%ebp
  802f74:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802f77:	ff 75 10             	pushl  0x10(%ebp)
  802f7a:	ff 75 0c             	pushl  0xc(%ebp)
  802f7d:	ff 75 08             	pushl  0x8(%ebp)
  802f80:	e8 65 02 00 00       	call   8031ea <nsipc_socket>
  802f85:	83 c4 10             	add    $0x10,%esp
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	78 05                	js     802f91 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  802f8c:	e8 93 fe ff ff       	call   802e24 <alloc_sockfd>
}
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    

00802f93 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802f93:	55                   	push   %ebp
  802f94:	89 e5                	mov    %esp,%ebp
  802f96:	53                   	push   %ebx
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802f9c:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  802fa3:	74 26                	je     802fcb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802fa5:	6a 07                	push   $0x7
  802fa7:	68 00 80 80 00       	push   $0x808000
  802fac:	53                   	push   %ebx
  802fad:	ff 35 24 64 80 00    	pushl  0x806424
  802fb3:	e8 37 07 00 00       	call   8036ef <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802fb8:	83 c4 0c             	add    $0xc,%esp
  802fbb:	6a 00                	push   $0x0
  802fbd:	6a 00                	push   $0x0
  802fbf:	6a 00                	push   $0x0
  802fc1:	e8 a4 06 00 00       	call   80366a <ipc_recv>
}
  802fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fc9:	c9                   	leave  
  802fca:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802fcb:	83 ec 0c             	sub    $0xc,%esp
  802fce:	6a 02                	push   $0x2
  802fd0:	e8 72 07 00 00       	call   803747 <ipc_find_env>
  802fd5:	a3 24 64 80 00       	mov    %eax,0x806424
  802fda:	83 c4 10             	add    $0x10,%esp
  802fdd:	eb c6                	jmp    802fa5 <nsipc+0x12>

00802fdf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802fdf:	f3 0f 1e fb          	endbr32 
  802fe3:	55                   	push   %ebp
  802fe4:	89 e5                	mov    %esp,%ebp
  802fe6:	56                   	push   %esi
  802fe7:	53                   	push   %ebx
  802fe8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802ff3:	8b 06                	mov    (%esi),%eax
  802ff5:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802ffa:	b8 01 00 00 00       	mov    $0x1,%eax
  802fff:	e8 8f ff ff ff       	call   802f93 <nsipc>
  803004:	89 c3                	mov    %eax,%ebx
  803006:	85 c0                	test   %eax,%eax
  803008:	79 09                	jns    803013 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80300a:	89 d8                	mov    %ebx,%eax
  80300c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80300f:	5b                   	pop    %ebx
  803010:	5e                   	pop    %esi
  803011:	5d                   	pop    %ebp
  803012:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803013:	83 ec 04             	sub    $0x4,%esp
  803016:	ff 35 10 80 80 00    	pushl  0x808010
  80301c:	68 00 80 80 00       	push   $0x808000
  803021:	ff 75 0c             	pushl  0xc(%ebp)
  803024:	e8 12 e4 ff ff       	call   80143b <memmove>
		*addrlen = ret->ret_addrlen;
  803029:	a1 10 80 80 00       	mov    0x808010,%eax
  80302e:	89 06                	mov    %eax,(%esi)
  803030:	83 c4 10             	add    $0x10,%esp
	return r;
  803033:	eb d5                	jmp    80300a <nsipc_accept+0x2b>

00803035 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803035:	f3 0f 1e fb          	endbr32 
  803039:	55                   	push   %ebp
  80303a:	89 e5                	mov    %esp,%ebp
  80303c:	53                   	push   %ebx
  80303d:	83 ec 08             	sub    $0x8,%esp
  803040:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80304b:	53                   	push   %ebx
  80304c:	ff 75 0c             	pushl  0xc(%ebp)
  80304f:	68 04 80 80 00       	push   $0x808004
  803054:	e8 e2 e3 ff ff       	call   80143b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803059:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  80305f:	b8 02 00 00 00       	mov    $0x2,%eax
  803064:	e8 2a ff ff ff       	call   802f93 <nsipc>
}
  803069:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80306c:	c9                   	leave  
  80306d:	c3                   	ret    

0080306e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80306e:	f3 0f 1e fb          	endbr32 
  803072:	55                   	push   %ebp
  803073:	89 e5                	mov    %esp,%ebp
  803075:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803080:	8b 45 0c             	mov    0xc(%ebp),%eax
  803083:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803088:	b8 03 00 00 00       	mov    $0x3,%eax
  80308d:	e8 01 ff ff ff       	call   802f93 <nsipc>
}
  803092:	c9                   	leave  
  803093:	c3                   	ret    

00803094 <nsipc_close>:

int
nsipc_close(int s)
{
  803094:	f3 0f 1e fb          	endbr32 
  803098:	55                   	push   %ebp
  803099:	89 e5                	mov    %esp,%ebp
  80309b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8030a6:	b8 04 00 00 00       	mov    $0x4,%eax
  8030ab:	e8 e3 fe ff ff       	call   802f93 <nsipc>
}
  8030b0:	c9                   	leave  
  8030b1:	c3                   	ret    

008030b2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8030b2:	f3 0f 1e fb          	endbr32 
  8030b6:	55                   	push   %ebp
  8030b7:	89 e5                	mov    %esp,%ebp
  8030b9:	53                   	push   %ebx
  8030ba:	83 ec 08             	sub    $0x8,%esp
  8030bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8030c8:	53                   	push   %ebx
  8030c9:	ff 75 0c             	pushl  0xc(%ebp)
  8030cc:	68 04 80 80 00       	push   $0x808004
  8030d1:	e8 65 e3 ff ff       	call   80143b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8030d6:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8030dc:	b8 05 00 00 00       	mov    $0x5,%eax
  8030e1:	e8 ad fe ff ff       	call   802f93 <nsipc>
}
  8030e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030e9:	c9                   	leave  
  8030ea:	c3                   	ret    

008030eb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8030eb:	f3 0f 1e fb          	endbr32 
  8030ef:	55                   	push   %ebp
  8030f0:	89 e5                	mov    %esp,%ebp
  8030f2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8030fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803100:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803105:	b8 06 00 00 00       	mov    $0x6,%eax
  80310a:	e8 84 fe ff ff       	call   802f93 <nsipc>
}
  80310f:	c9                   	leave  
  803110:	c3                   	ret    

00803111 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803111:	f3 0f 1e fb          	endbr32 
  803115:	55                   	push   %ebp
  803116:	89 e5                	mov    %esp,%ebp
  803118:	56                   	push   %esi
  803119:	53                   	push   %ebx
  80311a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803125:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80312b:	8b 45 14             	mov    0x14(%ebp),%eax
  80312e:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803133:	b8 07 00 00 00       	mov    $0x7,%eax
  803138:	e8 56 fe ff ff       	call   802f93 <nsipc>
  80313d:	89 c3                	mov    %eax,%ebx
  80313f:	85 c0                	test   %eax,%eax
  803141:	78 26                	js     803169 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  803143:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  803149:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80314e:	0f 4e c6             	cmovle %esi,%eax
  803151:	39 c3                	cmp    %eax,%ebx
  803153:	7f 1d                	jg     803172 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	53                   	push   %ebx
  803159:	68 00 80 80 00       	push   $0x808000
  80315e:	ff 75 0c             	pushl  0xc(%ebp)
  803161:	e8 d5 e2 ff ff       	call   80143b <memmove>
  803166:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803169:	89 d8                	mov    %ebx,%eax
  80316b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80316e:	5b                   	pop    %ebx
  80316f:	5e                   	pop    %esi
  803170:	5d                   	pop    %ebp
  803171:	c3                   	ret    
		assert(r < 1600 && r <= len);
  803172:	68 8a 41 80 00       	push   $0x80418a
  803177:	68 87 3b 80 00       	push   $0x803b87
  80317c:	6a 62                	push   $0x62
  80317e:	68 9f 41 80 00       	push   $0x80419f
  803183:	e8 18 d9 ff ff       	call   800aa0 <_panic>

00803188 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803188:	f3 0f 1e fb          	endbr32 
  80318c:	55                   	push   %ebp
  80318d:	89 e5                	mov    %esp,%ebp
  80318f:	53                   	push   %ebx
  803190:	83 ec 04             	sub    $0x4,%esp
  803193:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  80319e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8031a4:	7f 2e                	jg     8031d4 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	53                   	push   %ebx
  8031aa:	ff 75 0c             	pushl  0xc(%ebp)
  8031ad:	68 0c 80 80 00       	push   $0x80800c
  8031b2:	e8 84 e2 ff ff       	call   80143b <memmove>
	nsipcbuf.send.req_size = size;
  8031b7:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8031bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8031c0:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8031c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8031ca:	e8 c4 fd ff ff       	call   802f93 <nsipc>
}
  8031cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031d2:	c9                   	leave  
  8031d3:	c3                   	ret    
	assert(size < 1600);
  8031d4:	68 ab 41 80 00       	push   $0x8041ab
  8031d9:	68 87 3b 80 00       	push   $0x803b87
  8031de:	6a 6d                	push   $0x6d
  8031e0:	68 9f 41 80 00       	push   $0x80419f
  8031e5:	e8 b6 d8 ff ff       	call   800aa0 <_panic>

008031ea <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8031ea:	f3 0f 1e fb          	endbr32 
  8031ee:	55                   	push   %ebp
  8031ef:	89 e5                	mov    %esp,%ebp
  8031f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8031fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ff:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803204:	8b 45 10             	mov    0x10(%ebp),%eax
  803207:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80320c:	b8 09 00 00 00       	mov    $0x9,%eax
  803211:	e8 7d fd ff ff       	call   802f93 <nsipc>
}
  803216:	c9                   	leave  
  803217:	c3                   	ret    

00803218 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803218:	f3 0f 1e fb          	endbr32 
  80321c:	55                   	push   %ebp
  80321d:	89 e5                	mov    %esp,%ebp
  80321f:	56                   	push   %esi
  803220:	53                   	push   %ebx
  803221:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803224:	83 ec 0c             	sub    $0xc,%esp
  803227:	ff 75 08             	pushl  0x8(%ebp)
  80322a:	e8 c4 eb ff ff       	call   801df3 <fd2data>
  80322f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803231:	83 c4 08             	add    $0x8,%esp
  803234:	68 b7 41 80 00       	push   $0x8041b7
  803239:	53                   	push   %ebx
  80323a:	e8 46 e0 ff ff       	call   801285 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80323f:	8b 46 04             	mov    0x4(%esi),%eax
  803242:	2b 06                	sub    (%esi),%eax
  803244:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80324a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803251:	00 00 00 
	stat->st_dev = &devpipe;
  803254:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  80325b:	50 80 00 
	return 0;
}
  80325e:	b8 00 00 00 00       	mov    $0x0,%eax
  803263:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803266:	5b                   	pop    %ebx
  803267:	5e                   	pop    %esi
  803268:	5d                   	pop    %ebp
  803269:	c3                   	ret    

0080326a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80326a:	f3 0f 1e fb          	endbr32 
  80326e:	55                   	push   %ebp
  80326f:	89 e5                	mov    %esp,%ebp
  803271:	53                   	push   %ebx
  803272:	83 ec 0c             	sub    $0xc,%esp
  803275:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803278:	53                   	push   %ebx
  803279:	6a 00                	push   $0x0
  80327b:	e8 d4 e4 ff ff       	call   801754 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803280:	89 1c 24             	mov    %ebx,(%esp)
  803283:	e8 6b eb ff ff       	call   801df3 <fd2data>
  803288:	83 c4 08             	add    $0x8,%esp
  80328b:	50                   	push   %eax
  80328c:	6a 00                	push   $0x0
  80328e:	e8 c1 e4 ff ff       	call   801754 <sys_page_unmap>
}
  803293:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803296:	c9                   	leave  
  803297:	c3                   	ret    

00803298 <_pipeisclosed>:
{
  803298:	55                   	push   %ebp
  803299:	89 e5                	mov    %esp,%ebp
  80329b:	57                   	push   %edi
  80329c:	56                   	push   %esi
  80329d:	53                   	push   %ebx
  80329e:	83 ec 1c             	sub    $0x1c,%esp
  8032a1:	89 c7                	mov    %eax,%edi
  8032a3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8032a5:	a1 28 64 80 00       	mov    0x806428,%eax
  8032aa:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8032ad:	83 ec 0c             	sub    $0xc,%esp
  8032b0:	57                   	push   %edi
  8032b1:	e8 ce 04 00 00       	call   803784 <pageref>
  8032b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8032b9:	89 34 24             	mov    %esi,(%esp)
  8032bc:	e8 c3 04 00 00       	call   803784 <pageref>
		nn = thisenv->env_runs;
  8032c1:	8b 15 28 64 80 00    	mov    0x806428,%edx
  8032c7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8032ca:	83 c4 10             	add    $0x10,%esp
  8032cd:	39 cb                	cmp    %ecx,%ebx
  8032cf:	74 1b                	je     8032ec <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8032d1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8032d4:	75 cf                	jne    8032a5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032d6:	8b 42 58             	mov    0x58(%edx),%eax
  8032d9:	6a 01                	push   $0x1
  8032db:	50                   	push   %eax
  8032dc:	53                   	push   %ebx
  8032dd:	68 be 41 80 00       	push   $0x8041be
  8032e2:	e8 a0 d8 ff ff       	call   800b87 <cprintf>
  8032e7:	83 c4 10             	add    $0x10,%esp
  8032ea:	eb b9                	jmp    8032a5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8032ec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8032ef:	0f 94 c0             	sete   %al
  8032f2:	0f b6 c0             	movzbl %al,%eax
}
  8032f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8032f8:	5b                   	pop    %ebx
  8032f9:	5e                   	pop    %esi
  8032fa:	5f                   	pop    %edi
  8032fb:	5d                   	pop    %ebp
  8032fc:	c3                   	ret    

008032fd <devpipe_write>:
{
  8032fd:	f3 0f 1e fb          	endbr32 
  803301:	55                   	push   %ebp
  803302:	89 e5                	mov    %esp,%ebp
  803304:	57                   	push   %edi
  803305:	56                   	push   %esi
  803306:	53                   	push   %ebx
  803307:	83 ec 28             	sub    $0x28,%esp
  80330a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80330d:	56                   	push   %esi
  80330e:	e8 e0 ea ff ff       	call   801df3 <fd2data>
  803313:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803315:	83 c4 10             	add    $0x10,%esp
  803318:	bf 00 00 00 00       	mov    $0x0,%edi
  80331d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803320:	74 4f                	je     803371 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803322:	8b 43 04             	mov    0x4(%ebx),%eax
  803325:	8b 0b                	mov    (%ebx),%ecx
  803327:	8d 51 20             	lea    0x20(%ecx),%edx
  80332a:	39 d0                	cmp    %edx,%eax
  80332c:	72 14                	jb     803342 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80332e:	89 da                	mov    %ebx,%edx
  803330:	89 f0                	mov    %esi,%eax
  803332:	e8 61 ff ff ff       	call   803298 <_pipeisclosed>
  803337:	85 c0                	test   %eax,%eax
  803339:	75 3b                	jne    803376 <devpipe_write+0x79>
			sys_yield();
  80333b:	e8 64 e3 ff ff       	call   8016a4 <sys_yield>
  803340:	eb e0                	jmp    803322 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803345:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803349:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80334c:	89 c2                	mov    %eax,%edx
  80334e:	c1 fa 1f             	sar    $0x1f,%edx
  803351:	89 d1                	mov    %edx,%ecx
  803353:	c1 e9 1b             	shr    $0x1b,%ecx
  803356:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803359:	83 e2 1f             	and    $0x1f,%edx
  80335c:	29 ca                	sub    %ecx,%edx
  80335e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803362:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803366:	83 c0 01             	add    $0x1,%eax
  803369:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80336c:	83 c7 01             	add    $0x1,%edi
  80336f:	eb ac                	jmp    80331d <devpipe_write+0x20>
	return i;
  803371:	8b 45 10             	mov    0x10(%ebp),%eax
  803374:	eb 05                	jmp    80337b <devpipe_write+0x7e>
				return 0;
  803376:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80337b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80337e:	5b                   	pop    %ebx
  80337f:	5e                   	pop    %esi
  803380:	5f                   	pop    %edi
  803381:	5d                   	pop    %ebp
  803382:	c3                   	ret    

00803383 <devpipe_read>:
{
  803383:	f3 0f 1e fb          	endbr32 
  803387:	55                   	push   %ebp
  803388:	89 e5                	mov    %esp,%ebp
  80338a:	57                   	push   %edi
  80338b:	56                   	push   %esi
  80338c:	53                   	push   %ebx
  80338d:	83 ec 18             	sub    $0x18,%esp
  803390:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803393:	57                   	push   %edi
  803394:	e8 5a ea ff ff       	call   801df3 <fd2data>
  803399:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80339b:	83 c4 10             	add    $0x10,%esp
  80339e:	be 00 00 00 00       	mov    $0x0,%esi
  8033a3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8033a6:	75 14                	jne    8033bc <devpipe_read+0x39>
	return i;
  8033a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ab:	eb 02                	jmp    8033af <devpipe_read+0x2c>
				return i;
  8033ad:	89 f0                	mov    %esi,%eax
}
  8033af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8033b2:	5b                   	pop    %ebx
  8033b3:	5e                   	pop    %esi
  8033b4:	5f                   	pop    %edi
  8033b5:	5d                   	pop    %ebp
  8033b6:	c3                   	ret    
			sys_yield();
  8033b7:	e8 e8 e2 ff ff       	call   8016a4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8033bc:	8b 03                	mov    (%ebx),%eax
  8033be:	3b 43 04             	cmp    0x4(%ebx),%eax
  8033c1:	75 18                	jne    8033db <devpipe_read+0x58>
			if (i > 0)
  8033c3:	85 f6                	test   %esi,%esi
  8033c5:	75 e6                	jne    8033ad <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8033c7:	89 da                	mov    %ebx,%edx
  8033c9:	89 f8                	mov    %edi,%eax
  8033cb:	e8 c8 fe ff ff       	call   803298 <_pipeisclosed>
  8033d0:	85 c0                	test   %eax,%eax
  8033d2:	74 e3                	je     8033b7 <devpipe_read+0x34>
				return 0;
  8033d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d9:	eb d4                	jmp    8033af <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8033db:	99                   	cltd   
  8033dc:	c1 ea 1b             	shr    $0x1b,%edx
  8033df:	01 d0                	add    %edx,%eax
  8033e1:	83 e0 1f             	and    $0x1f,%eax
  8033e4:	29 d0                	sub    %edx,%eax
  8033e6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8033eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8033ee:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8033f1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8033f4:	83 c6 01             	add    $0x1,%esi
  8033f7:	eb aa                	jmp    8033a3 <devpipe_read+0x20>

008033f9 <pipe>:
{
  8033f9:	f3 0f 1e fb          	endbr32 
  8033fd:	55                   	push   %ebp
  8033fe:	89 e5                	mov    %esp,%ebp
  803400:	56                   	push   %esi
  803401:	53                   	push   %ebx
  803402:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803405:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803408:	50                   	push   %eax
  803409:	e8 00 ea ff ff       	call   801e0e <fd_alloc>
  80340e:	89 c3                	mov    %eax,%ebx
  803410:	83 c4 10             	add    $0x10,%esp
  803413:	85 c0                	test   %eax,%eax
  803415:	0f 88 23 01 00 00    	js     80353e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80341b:	83 ec 04             	sub    $0x4,%esp
  80341e:	68 07 04 00 00       	push   $0x407
  803423:	ff 75 f4             	pushl  -0xc(%ebp)
  803426:	6a 00                	push   $0x0
  803428:	e8 9a e2 ff ff       	call   8016c7 <sys_page_alloc>
  80342d:	89 c3                	mov    %eax,%ebx
  80342f:	83 c4 10             	add    $0x10,%esp
  803432:	85 c0                	test   %eax,%eax
  803434:	0f 88 04 01 00 00    	js     80353e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80343a:	83 ec 0c             	sub    $0xc,%esp
  80343d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803440:	50                   	push   %eax
  803441:	e8 c8 e9 ff ff       	call   801e0e <fd_alloc>
  803446:	89 c3                	mov    %eax,%ebx
  803448:	83 c4 10             	add    $0x10,%esp
  80344b:	85 c0                	test   %eax,%eax
  80344d:	0f 88 db 00 00 00    	js     80352e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803453:	83 ec 04             	sub    $0x4,%esp
  803456:	68 07 04 00 00       	push   $0x407
  80345b:	ff 75 f0             	pushl  -0x10(%ebp)
  80345e:	6a 00                	push   $0x0
  803460:	e8 62 e2 ff ff       	call   8016c7 <sys_page_alloc>
  803465:	89 c3                	mov    %eax,%ebx
  803467:	83 c4 10             	add    $0x10,%esp
  80346a:	85 c0                	test   %eax,%eax
  80346c:	0f 88 bc 00 00 00    	js     80352e <pipe+0x135>
	va = fd2data(fd0);
  803472:	83 ec 0c             	sub    $0xc,%esp
  803475:	ff 75 f4             	pushl  -0xc(%ebp)
  803478:	e8 76 e9 ff ff       	call   801df3 <fd2data>
  80347d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80347f:	83 c4 0c             	add    $0xc,%esp
  803482:	68 07 04 00 00       	push   $0x407
  803487:	50                   	push   %eax
  803488:	6a 00                	push   $0x0
  80348a:	e8 38 e2 ff ff       	call   8016c7 <sys_page_alloc>
  80348f:	89 c3                	mov    %eax,%ebx
  803491:	83 c4 10             	add    $0x10,%esp
  803494:	85 c0                	test   %eax,%eax
  803496:	0f 88 82 00 00 00    	js     80351e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80349c:	83 ec 0c             	sub    $0xc,%esp
  80349f:	ff 75 f0             	pushl  -0x10(%ebp)
  8034a2:	e8 4c e9 ff ff       	call   801df3 <fd2data>
  8034a7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8034ae:	50                   	push   %eax
  8034af:	6a 00                	push   $0x0
  8034b1:	56                   	push   %esi
  8034b2:	6a 00                	push   $0x0
  8034b4:	e8 55 e2 ff ff       	call   80170e <sys_page_map>
  8034b9:	89 c3                	mov    %eax,%ebx
  8034bb:	83 c4 20             	add    $0x20,%esp
  8034be:	85 c0                	test   %eax,%eax
  8034c0:	78 4e                	js     803510 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8034c2:	a1 58 50 80 00       	mov    0x805058,%eax
  8034c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ca:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8034cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034cf:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8034d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8034db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034de:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8034e5:	83 ec 0c             	sub    $0xc,%esp
  8034e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8034eb:	e8 ef e8 ff ff       	call   801ddf <fd2num>
  8034f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8034f3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8034f5:	83 c4 04             	add    $0x4,%esp
  8034f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8034fb:	e8 df e8 ff ff       	call   801ddf <fd2num>
  803500:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803503:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803506:	83 c4 10             	add    $0x10,%esp
  803509:	bb 00 00 00 00       	mov    $0x0,%ebx
  80350e:	eb 2e                	jmp    80353e <pipe+0x145>
	sys_page_unmap(0, va);
  803510:	83 ec 08             	sub    $0x8,%esp
  803513:	56                   	push   %esi
  803514:	6a 00                	push   $0x0
  803516:	e8 39 e2 ff ff       	call   801754 <sys_page_unmap>
  80351b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80351e:	83 ec 08             	sub    $0x8,%esp
  803521:	ff 75 f0             	pushl  -0x10(%ebp)
  803524:	6a 00                	push   $0x0
  803526:	e8 29 e2 ff ff       	call   801754 <sys_page_unmap>
  80352b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80352e:	83 ec 08             	sub    $0x8,%esp
  803531:	ff 75 f4             	pushl  -0xc(%ebp)
  803534:	6a 00                	push   $0x0
  803536:	e8 19 e2 ff ff       	call   801754 <sys_page_unmap>
  80353b:	83 c4 10             	add    $0x10,%esp
}
  80353e:	89 d8                	mov    %ebx,%eax
  803540:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5d                   	pop    %ebp
  803546:	c3                   	ret    

00803547 <pipeisclosed>:
{
  803547:	f3 0f 1e fb          	endbr32 
  80354b:	55                   	push   %ebp
  80354c:	89 e5                	mov    %esp,%ebp
  80354e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803551:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803554:	50                   	push   %eax
  803555:	ff 75 08             	pushl  0x8(%ebp)
  803558:	e8 07 e9 ff ff       	call   801e64 <fd_lookup>
  80355d:	83 c4 10             	add    $0x10,%esp
  803560:	85 c0                	test   %eax,%eax
  803562:	78 18                	js     80357c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  803564:	83 ec 0c             	sub    $0xc,%esp
  803567:	ff 75 f4             	pushl  -0xc(%ebp)
  80356a:	e8 84 e8 ff ff       	call   801df3 <fd2data>
  80356f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	e8 1f fd ff ff       	call   803298 <_pipeisclosed>
  803579:	83 c4 10             	add    $0x10,%esp
}
  80357c:	c9                   	leave  
  80357d:	c3                   	ret    

0080357e <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80357e:	f3 0f 1e fb          	endbr32 
  803582:	55                   	push   %ebp
  803583:	89 e5                	mov    %esp,%ebp
  803585:	56                   	push   %esi
  803586:	53                   	push   %ebx
  803587:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80358a:	85 f6                	test   %esi,%esi
  80358c:	74 13                	je     8035a1 <wait+0x23>
	e = &envs[ENVX(envid)];
  80358e:	89 f3                	mov    %esi,%ebx
  803590:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803596:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803599:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80359f:	eb 1b                	jmp    8035bc <wait+0x3e>
	assert(envid != 0);
  8035a1:	68 d6 41 80 00       	push   $0x8041d6
  8035a6:	68 87 3b 80 00       	push   $0x803b87
  8035ab:	6a 09                	push   $0x9
  8035ad:	68 e1 41 80 00       	push   $0x8041e1
  8035b2:	e8 e9 d4 ff ff       	call   800aa0 <_panic>
		sys_yield();
  8035b7:	e8 e8 e0 ff ff       	call   8016a4 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8035bc:	8b 43 48             	mov    0x48(%ebx),%eax
  8035bf:	39 f0                	cmp    %esi,%eax
  8035c1:	75 07                	jne    8035ca <wait+0x4c>
  8035c3:	8b 43 54             	mov    0x54(%ebx),%eax
  8035c6:	85 c0                	test   %eax,%eax
  8035c8:	75 ed                	jne    8035b7 <wait+0x39>
}
  8035ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8035cd:	5b                   	pop    %ebx
  8035ce:	5e                   	pop    %esi
  8035cf:	5d                   	pop    %ebp
  8035d0:	c3                   	ret    

008035d1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8035d1:	f3 0f 1e fb          	endbr32 
  8035d5:	55                   	push   %ebp
  8035d6:	89 e5                	mov    %esp,%ebp
  8035d8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8035db:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8035e2:	74 0a                	je     8035ee <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8035e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e7:	a3 00 90 80 00       	mov    %eax,0x809000
}
  8035ec:	c9                   	leave  
  8035ed:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  8035ee:	83 ec 04             	sub    $0x4,%esp
  8035f1:	6a 07                	push   $0x7
  8035f3:	68 00 f0 bf ee       	push   $0xeebff000
  8035f8:	6a 00                	push   $0x0
  8035fa:	e8 c8 e0 ff ff       	call   8016c7 <sys_page_alloc>
  8035ff:	83 c4 10             	add    $0x10,%esp
  803602:	85 c0                	test   %eax,%eax
  803604:	78 2a                	js     803630 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  803606:	83 ec 08             	sub    $0x8,%esp
  803609:	68 44 36 80 00       	push   $0x803644
  80360e:	6a 00                	push   $0x0
  803610:	e8 11 e2 ff ff       	call   801826 <sys_env_set_pgfault_upcall>
  803615:	83 c4 10             	add    $0x10,%esp
  803618:	85 c0                	test   %eax,%eax
  80361a:	79 c8                	jns    8035e4 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80361c:	83 ec 04             	sub    $0x4,%esp
  80361f:	68 18 42 80 00       	push   $0x804218
  803624:	6a 25                	push   $0x25
  803626:	68 50 42 80 00       	push   $0x804250
  80362b:	e8 70 d4 ff ff       	call   800aa0 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  803630:	83 ec 04             	sub    $0x4,%esp
  803633:	68 ec 41 80 00       	push   $0x8041ec
  803638:	6a 22                	push   $0x22
  80363a:	68 50 42 80 00       	push   $0x804250
  80363f:	e8 5c d4 ff ff       	call   800aa0 <_panic>

00803644 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803644:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803645:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  80364a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80364c:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  80364f:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  803653:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  803657:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80365a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80365c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  803660:	83 c4 08             	add    $0x8,%esp
	popal
  803663:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  803664:	83 c4 04             	add    $0x4,%esp
	popfl
  803667:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  803668:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  803669:	c3                   	ret    

0080366a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80366a:	f3 0f 1e fb          	endbr32 
  80366e:	55                   	push   %ebp
  80366f:	89 e5                	mov    %esp,%ebp
  803671:	56                   	push   %esi
  803672:	53                   	push   %ebx
  803673:	8b 75 08             	mov    0x8(%ebp),%esi
  803676:	8b 45 0c             	mov    0xc(%ebp),%eax
  803679:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80367c:	85 c0                	test   %eax,%eax
  80367e:	74 3d                	je     8036bd <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  803680:	83 ec 0c             	sub    $0xc,%esp
  803683:	50                   	push   %eax
  803684:	e8 0a e2 ff ff       	call   801893 <sys_ipc_recv>
  803689:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80368c:	85 f6                	test   %esi,%esi
  80368e:	74 0b                	je     80369b <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  803690:	8b 15 28 64 80 00    	mov    0x806428,%edx
  803696:	8b 52 74             	mov    0x74(%edx),%edx
  803699:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80369b:	85 db                	test   %ebx,%ebx
  80369d:	74 0b                	je     8036aa <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80369f:	8b 15 28 64 80 00    	mov    0x806428,%edx
  8036a5:	8b 52 78             	mov    0x78(%edx),%edx
  8036a8:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	78 21                	js     8036cf <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8036ae:	a1 28 64 80 00       	mov    0x806428,%eax
  8036b3:	8b 40 70             	mov    0x70(%eax),%eax
}
  8036b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8036b9:	5b                   	pop    %ebx
  8036ba:	5e                   	pop    %esi
  8036bb:	5d                   	pop    %ebp
  8036bc:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8036bd:	83 ec 0c             	sub    $0xc,%esp
  8036c0:	68 00 00 c0 ee       	push   $0xeec00000
  8036c5:	e8 c9 e1 ff ff       	call   801893 <sys_ipc_recv>
  8036ca:	83 c4 10             	add    $0x10,%esp
  8036cd:	eb bd                	jmp    80368c <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8036cf:	85 f6                	test   %esi,%esi
  8036d1:	74 10                	je     8036e3 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8036d3:	85 db                	test   %ebx,%ebx
  8036d5:	75 df                	jne    8036b6 <ipc_recv+0x4c>
  8036d7:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8036de:	00 00 00 
  8036e1:	eb d3                	jmp    8036b6 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8036e3:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8036ea:	00 00 00 
  8036ed:	eb e4                	jmp    8036d3 <ipc_recv+0x69>

008036ef <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8036ef:	f3 0f 1e fb          	endbr32 
  8036f3:	55                   	push   %ebp
  8036f4:	89 e5                	mov    %esp,%ebp
  8036f6:	57                   	push   %edi
  8036f7:	56                   	push   %esi
  8036f8:	53                   	push   %ebx
  8036f9:	83 ec 0c             	sub    $0xc,%esp
  8036fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8036ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  803702:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  803705:	85 db                	test   %ebx,%ebx
  803707:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80370c:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80370f:	ff 75 14             	pushl  0x14(%ebp)
  803712:	53                   	push   %ebx
  803713:	56                   	push   %esi
  803714:	57                   	push   %edi
  803715:	e8 52 e1 ff ff       	call   80186c <sys_ipc_try_send>
  80371a:	83 c4 10             	add    $0x10,%esp
  80371d:	85 c0                	test   %eax,%eax
  80371f:	79 1e                	jns    80373f <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  803721:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803724:	75 07                	jne    80372d <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  803726:	e8 79 df ff ff       	call   8016a4 <sys_yield>
  80372b:	eb e2                	jmp    80370f <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80372d:	50                   	push   %eax
  80372e:	68 5e 42 80 00       	push   $0x80425e
  803733:	6a 59                	push   $0x59
  803735:	68 79 42 80 00       	push   $0x804279
  80373a:	e8 61 d3 ff ff       	call   800aa0 <_panic>
	}
}
  80373f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803742:	5b                   	pop    %ebx
  803743:	5e                   	pop    %esi
  803744:	5f                   	pop    %edi
  803745:	5d                   	pop    %ebp
  803746:	c3                   	ret    

00803747 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803747:	f3 0f 1e fb          	endbr32 
  80374b:	55                   	push   %ebp
  80374c:	89 e5                	mov    %esp,%ebp
  80374e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803751:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803756:	6b d0 7c             	imul   $0x7c,%eax,%edx
  803759:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80375f:	8b 52 50             	mov    0x50(%edx),%edx
  803762:	39 ca                	cmp    %ecx,%edx
  803764:	74 11                	je     803777 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  803766:	83 c0 01             	add    $0x1,%eax
  803769:	3d 00 04 00 00       	cmp    $0x400,%eax
  80376e:	75 e6                	jne    803756 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  803770:	b8 00 00 00 00       	mov    $0x0,%eax
  803775:	eb 0b                	jmp    803782 <ipc_find_env+0x3b>
			return envs[i].env_id;
  803777:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80377a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80377f:	8b 40 48             	mov    0x48(%eax),%eax
}
  803782:	5d                   	pop    %ebp
  803783:	c3                   	ret    

00803784 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803784:	f3 0f 1e fb          	endbr32 
  803788:	55                   	push   %ebp
  803789:	89 e5                	mov    %esp,%ebp
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80378e:	89 c2                	mov    %eax,%edx
  803790:	c1 ea 16             	shr    $0x16,%edx
  803793:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80379a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80379f:	f6 c1 01             	test   $0x1,%cl
  8037a2:	74 1c                	je     8037c0 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8037a4:	c1 e8 0c             	shr    $0xc,%eax
  8037a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8037ae:	a8 01                	test   $0x1,%al
  8037b0:	74 0e                	je     8037c0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8037b2:	c1 e8 0c             	shr    $0xc,%eax
  8037b5:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8037bc:	ef 
  8037bd:	0f b7 d2             	movzwl %dx,%edx
}
  8037c0:	89 d0                	mov    %edx,%eax
  8037c2:	5d                   	pop    %ebp
  8037c3:	c3                   	ret    
  8037c4:	66 90                	xchg   %ax,%ax
  8037c6:	66 90                	xchg   %ax,%ax
  8037c8:	66 90                	xchg   %ax,%ax
  8037ca:	66 90                	xchg   %ax,%ax
  8037cc:	66 90                	xchg   %ax,%ax
  8037ce:	66 90                	xchg   %ax,%ax

008037d0 <__udivdi3>:
  8037d0:	f3 0f 1e fb          	endbr32 
  8037d4:	55                   	push   %ebp
  8037d5:	57                   	push   %edi
  8037d6:	56                   	push   %esi
  8037d7:	53                   	push   %ebx
  8037d8:	83 ec 1c             	sub    $0x1c,%esp
  8037db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8037df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8037e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8037eb:	85 d2                	test   %edx,%edx
  8037ed:	75 19                	jne    803808 <__udivdi3+0x38>
  8037ef:	39 f3                	cmp    %esi,%ebx
  8037f1:	76 4d                	jbe    803840 <__udivdi3+0x70>
  8037f3:	31 ff                	xor    %edi,%edi
  8037f5:	89 e8                	mov    %ebp,%eax
  8037f7:	89 f2                	mov    %esi,%edx
  8037f9:	f7 f3                	div    %ebx
  8037fb:	89 fa                	mov    %edi,%edx
  8037fd:	83 c4 1c             	add    $0x1c,%esp
  803800:	5b                   	pop    %ebx
  803801:	5e                   	pop    %esi
  803802:	5f                   	pop    %edi
  803803:	5d                   	pop    %ebp
  803804:	c3                   	ret    
  803805:	8d 76 00             	lea    0x0(%esi),%esi
  803808:	39 f2                	cmp    %esi,%edx
  80380a:	76 14                	jbe    803820 <__udivdi3+0x50>
  80380c:	31 ff                	xor    %edi,%edi
  80380e:	31 c0                	xor    %eax,%eax
  803810:	89 fa                	mov    %edi,%edx
  803812:	83 c4 1c             	add    $0x1c,%esp
  803815:	5b                   	pop    %ebx
  803816:	5e                   	pop    %esi
  803817:	5f                   	pop    %edi
  803818:	5d                   	pop    %ebp
  803819:	c3                   	ret    
  80381a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803820:	0f bd fa             	bsr    %edx,%edi
  803823:	83 f7 1f             	xor    $0x1f,%edi
  803826:	75 48                	jne    803870 <__udivdi3+0xa0>
  803828:	39 f2                	cmp    %esi,%edx
  80382a:	72 06                	jb     803832 <__udivdi3+0x62>
  80382c:	31 c0                	xor    %eax,%eax
  80382e:	39 eb                	cmp    %ebp,%ebx
  803830:	77 de                	ja     803810 <__udivdi3+0x40>
  803832:	b8 01 00 00 00       	mov    $0x1,%eax
  803837:	eb d7                	jmp    803810 <__udivdi3+0x40>
  803839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803840:	89 d9                	mov    %ebx,%ecx
  803842:	85 db                	test   %ebx,%ebx
  803844:	75 0b                	jne    803851 <__udivdi3+0x81>
  803846:	b8 01 00 00 00       	mov    $0x1,%eax
  80384b:	31 d2                	xor    %edx,%edx
  80384d:	f7 f3                	div    %ebx
  80384f:	89 c1                	mov    %eax,%ecx
  803851:	31 d2                	xor    %edx,%edx
  803853:	89 f0                	mov    %esi,%eax
  803855:	f7 f1                	div    %ecx
  803857:	89 c6                	mov    %eax,%esi
  803859:	89 e8                	mov    %ebp,%eax
  80385b:	89 f7                	mov    %esi,%edi
  80385d:	f7 f1                	div    %ecx
  80385f:	89 fa                	mov    %edi,%edx
  803861:	83 c4 1c             	add    $0x1c,%esp
  803864:	5b                   	pop    %ebx
  803865:	5e                   	pop    %esi
  803866:	5f                   	pop    %edi
  803867:	5d                   	pop    %ebp
  803868:	c3                   	ret    
  803869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803870:	89 f9                	mov    %edi,%ecx
  803872:	b8 20 00 00 00       	mov    $0x20,%eax
  803877:	29 f8                	sub    %edi,%eax
  803879:	d3 e2                	shl    %cl,%edx
  80387b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80387f:	89 c1                	mov    %eax,%ecx
  803881:	89 da                	mov    %ebx,%edx
  803883:	d3 ea                	shr    %cl,%edx
  803885:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803889:	09 d1                	or     %edx,%ecx
  80388b:	89 f2                	mov    %esi,%edx
  80388d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803891:	89 f9                	mov    %edi,%ecx
  803893:	d3 e3                	shl    %cl,%ebx
  803895:	89 c1                	mov    %eax,%ecx
  803897:	d3 ea                	shr    %cl,%edx
  803899:	89 f9                	mov    %edi,%ecx
  80389b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80389f:	89 eb                	mov    %ebp,%ebx
  8038a1:	d3 e6                	shl    %cl,%esi
  8038a3:	89 c1                	mov    %eax,%ecx
  8038a5:	d3 eb                	shr    %cl,%ebx
  8038a7:	09 de                	or     %ebx,%esi
  8038a9:	89 f0                	mov    %esi,%eax
  8038ab:	f7 74 24 08          	divl   0x8(%esp)
  8038af:	89 d6                	mov    %edx,%esi
  8038b1:	89 c3                	mov    %eax,%ebx
  8038b3:	f7 64 24 0c          	mull   0xc(%esp)
  8038b7:	39 d6                	cmp    %edx,%esi
  8038b9:	72 15                	jb     8038d0 <__udivdi3+0x100>
  8038bb:	89 f9                	mov    %edi,%ecx
  8038bd:	d3 e5                	shl    %cl,%ebp
  8038bf:	39 c5                	cmp    %eax,%ebp
  8038c1:	73 04                	jae    8038c7 <__udivdi3+0xf7>
  8038c3:	39 d6                	cmp    %edx,%esi
  8038c5:	74 09                	je     8038d0 <__udivdi3+0x100>
  8038c7:	89 d8                	mov    %ebx,%eax
  8038c9:	31 ff                	xor    %edi,%edi
  8038cb:	e9 40 ff ff ff       	jmp    803810 <__udivdi3+0x40>
  8038d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038d3:	31 ff                	xor    %edi,%edi
  8038d5:	e9 36 ff ff ff       	jmp    803810 <__udivdi3+0x40>
  8038da:	66 90                	xchg   %ax,%ax
  8038dc:	66 90                	xchg   %ax,%ax
  8038de:	66 90                	xchg   %ax,%ax

008038e0 <__umoddi3>:
  8038e0:	f3 0f 1e fb          	endbr32 
  8038e4:	55                   	push   %ebp
  8038e5:	57                   	push   %edi
  8038e6:	56                   	push   %esi
  8038e7:	53                   	push   %ebx
  8038e8:	83 ec 1c             	sub    $0x1c,%esp
  8038eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8038f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8038f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038fb:	85 c0                	test   %eax,%eax
  8038fd:	75 19                	jne    803918 <__umoddi3+0x38>
  8038ff:	39 df                	cmp    %ebx,%edi
  803901:	76 5d                	jbe    803960 <__umoddi3+0x80>
  803903:	89 f0                	mov    %esi,%eax
  803905:	89 da                	mov    %ebx,%edx
  803907:	f7 f7                	div    %edi
  803909:	89 d0                	mov    %edx,%eax
  80390b:	31 d2                	xor    %edx,%edx
  80390d:	83 c4 1c             	add    $0x1c,%esp
  803910:	5b                   	pop    %ebx
  803911:	5e                   	pop    %esi
  803912:	5f                   	pop    %edi
  803913:	5d                   	pop    %ebp
  803914:	c3                   	ret    
  803915:	8d 76 00             	lea    0x0(%esi),%esi
  803918:	89 f2                	mov    %esi,%edx
  80391a:	39 d8                	cmp    %ebx,%eax
  80391c:	76 12                	jbe    803930 <__umoddi3+0x50>
  80391e:	89 f0                	mov    %esi,%eax
  803920:	89 da                	mov    %ebx,%edx
  803922:	83 c4 1c             	add    $0x1c,%esp
  803925:	5b                   	pop    %ebx
  803926:	5e                   	pop    %esi
  803927:	5f                   	pop    %edi
  803928:	5d                   	pop    %ebp
  803929:	c3                   	ret    
  80392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803930:	0f bd e8             	bsr    %eax,%ebp
  803933:	83 f5 1f             	xor    $0x1f,%ebp
  803936:	75 50                	jne    803988 <__umoddi3+0xa8>
  803938:	39 d8                	cmp    %ebx,%eax
  80393a:	0f 82 e0 00 00 00    	jb     803a20 <__umoddi3+0x140>
  803940:	89 d9                	mov    %ebx,%ecx
  803942:	39 f7                	cmp    %esi,%edi
  803944:	0f 86 d6 00 00 00    	jbe    803a20 <__umoddi3+0x140>
  80394a:	89 d0                	mov    %edx,%eax
  80394c:	89 ca                	mov    %ecx,%edx
  80394e:	83 c4 1c             	add    $0x1c,%esp
  803951:	5b                   	pop    %ebx
  803952:	5e                   	pop    %esi
  803953:	5f                   	pop    %edi
  803954:	5d                   	pop    %ebp
  803955:	c3                   	ret    
  803956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80395d:	8d 76 00             	lea    0x0(%esi),%esi
  803960:	89 fd                	mov    %edi,%ebp
  803962:	85 ff                	test   %edi,%edi
  803964:	75 0b                	jne    803971 <__umoddi3+0x91>
  803966:	b8 01 00 00 00       	mov    $0x1,%eax
  80396b:	31 d2                	xor    %edx,%edx
  80396d:	f7 f7                	div    %edi
  80396f:	89 c5                	mov    %eax,%ebp
  803971:	89 d8                	mov    %ebx,%eax
  803973:	31 d2                	xor    %edx,%edx
  803975:	f7 f5                	div    %ebp
  803977:	89 f0                	mov    %esi,%eax
  803979:	f7 f5                	div    %ebp
  80397b:	89 d0                	mov    %edx,%eax
  80397d:	31 d2                	xor    %edx,%edx
  80397f:	eb 8c                	jmp    80390d <__umoddi3+0x2d>
  803981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803988:	89 e9                	mov    %ebp,%ecx
  80398a:	ba 20 00 00 00       	mov    $0x20,%edx
  80398f:	29 ea                	sub    %ebp,%edx
  803991:	d3 e0                	shl    %cl,%eax
  803993:	89 44 24 08          	mov    %eax,0x8(%esp)
  803997:	89 d1                	mov    %edx,%ecx
  803999:	89 f8                	mov    %edi,%eax
  80399b:	d3 e8                	shr    %cl,%eax
  80399d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8039a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039a9:	09 c1                	or     %eax,%ecx
  8039ab:	89 d8                	mov    %ebx,%eax
  8039ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039b1:	89 e9                	mov    %ebp,%ecx
  8039b3:	d3 e7                	shl    %cl,%edi
  8039b5:	89 d1                	mov    %edx,%ecx
  8039b7:	d3 e8                	shr    %cl,%eax
  8039b9:	89 e9                	mov    %ebp,%ecx
  8039bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039bf:	d3 e3                	shl    %cl,%ebx
  8039c1:	89 c7                	mov    %eax,%edi
  8039c3:	89 d1                	mov    %edx,%ecx
  8039c5:	89 f0                	mov    %esi,%eax
  8039c7:	d3 e8                	shr    %cl,%eax
  8039c9:	89 e9                	mov    %ebp,%ecx
  8039cb:	89 fa                	mov    %edi,%edx
  8039cd:	d3 e6                	shl    %cl,%esi
  8039cf:	09 d8                	or     %ebx,%eax
  8039d1:	f7 74 24 08          	divl   0x8(%esp)
  8039d5:	89 d1                	mov    %edx,%ecx
  8039d7:	89 f3                	mov    %esi,%ebx
  8039d9:	f7 64 24 0c          	mull   0xc(%esp)
  8039dd:	89 c6                	mov    %eax,%esi
  8039df:	89 d7                	mov    %edx,%edi
  8039e1:	39 d1                	cmp    %edx,%ecx
  8039e3:	72 06                	jb     8039eb <__umoddi3+0x10b>
  8039e5:	75 10                	jne    8039f7 <__umoddi3+0x117>
  8039e7:	39 c3                	cmp    %eax,%ebx
  8039e9:	73 0c                	jae    8039f7 <__umoddi3+0x117>
  8039eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8039ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8039f3:	89 d7                	mov    %edx,%edi
  8039f5:	89 c6                	mov    %eax,%esi
  8039f7:	89 ca                	mov    %ecx,%edx
  8039f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8039fe:	29 f3                	sub    %esi,%ebx
  803a00:	19 fa                	sbb    %edi,%edx
  803a02:	89 d0                	mov    %edx,%eax
  803a04:	d3 e0                	shl    %cl,%eax
  803a06:	89 e9                	mov    %ebp,%ecx
  803a08:	d3 eb                	shr    %cl,%ebx
  803a0a:	d3 ea                	shr    %cl,%edx
  803a0c:	09 d8                	or     %ebx,%eax
  803a0e:	83 c4 1c             	add    $0x1c,%esp
  803a11:	5b                   	pop    %ebx
  803a12:	5e                   	pop    %esi
  803a13:	5f                   	pop    %edi
  803a14:	5d                   	pop    %ebp
  803a15:	c3                   	ret    
  803a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803a1d:	8d 76 00             	lea    0x0(%esi),%esi
  803a20:	29 fe                	sub    %edi,%esi
  803a22:	19 c3                	sbb    %eax,%ebx
  803a24:	89 f2                	mov    %esi,%edx
  803a26:	89 d9                	mov    %ebx,%ecx
  803a28:	e9 1d ff ff ff       	jmp    80394a <__umoddi3+0x6a>
