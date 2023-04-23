
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 58 06 00 00       	call   800689 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 60 80 00       	push   $0x806000
  800042:	e8 9b 0d 00 00       	call   800de2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 68 15 00 00       	call   8015c1 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 60 80 00       	push   $0x806000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 01 15 00 00       	call   801569 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 6b 14 00 00       	call   8014e4 <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	f3 0f 1e fb          	endbr32 
  800082:	55                   	push   %ebp
  800083:	89 e5                	mov    %esp,%ebp
  800085:	57                   	push   %edi
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008e:	ba 00 00 00 00       	mov    $0x0,%edx
  800093:	b8 a0 2a 80 00       	mov    $0x802aa0,%eax
  800098:	e8 96 ff ff ff       	call   800033 <xopen>
  80009d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000a0:	74 08                	je     8000aa <umain+0x2c>
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	0f 88 e9 03 00 00    	js     800493 <umain+0x415>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	0f 89 f3 03 00 00    	jns    8004a5 <umain+0x427>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b7:	b8 d5 2a 80 00       	mov    $0x802ad5,%eax
  8000bc:	e8 72 ff ff ff       	call   800033 <xopen>
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	0f 88 f0 03 00 00    	js     8004b9 <umain+0x43b>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c9:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000d0:	0f 85 f5 03 00 00    	jne    8004cb <umain+0x44d>
  8000d6:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000dd:	0f 85 e8 03 00 00    	jne    8004cb <umain+0x44d>
  8000e3:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000ea:	0f 85 db 03 00 00    	jne    8004cb <umain+0x44d>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	68 f6 2a 80 00       	push   $0x802af6
  8000f8:	e8 db 06 00 00       	call   8007d8 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000fd:	83 c4 08             	add    $0x8,%esp
  800100:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800106:	50                   	push   %eax
  800107:	68 00 c0 cc cc       	push   $0xccccc000
  80010c:	ff 15 1c 40 80 00    	call   *0x80401c
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	85 c0                	test   %eax,%eax
  800117:	0f 88 c2 03 00 00    	js     8004df <umain+0x461>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	ff 35 00 40 80 00    	pushl  0x804000
  800126:	e8 74 0c 00 00       	call   800d9f <strlen>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800131:	0f 85 ba 03 00 00    	jne    8004f1 <umain+0x473>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 18 2b 80 00       	push   $0x802b18
  80013f:	e8 94 06 00 00       	call   8007d8 <cprintf>

	memset(buf, 0, sizeof buf);
  800144:	83 c4 0c             	add    $0xc,%esp
  800147:	68 00 02 00 00       	push   $0x200
  80014c:	6a 00                	push   $0x0
  80014e:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800154:	53                   	push   %ebx
  800155:	e8 f2 0d 00 00       	call   800f4c <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  80015a:	83 c4 0c             	add    $0xc,%esp
  80015d:	68 00 02 00 00       	push   $0x200
  800162:	53                   	push   %ebx
  800163:	68 00 c0 cc cc       	push   $0xccccc000
  800168:	ff 15 10 40 80 00    	call   *0x804010
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	85 c0                	test   %eax,%eax
  800173:	0f 88 9d 03 00 00    	js     800516 <umain+0x498>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 35 00 40 80 00    	pushl  0x804000
  800182:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 13 0d 00 00       	call   800ea1 <strcmp>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	85 c0                	test   %eax,%eax
  800193:	0f 85 8f 03 00 00    	jne    800528 <umain+0x4aa>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	68 57 2b 80 00       	push   $0x802b57
  8001a1:	e8 32 06 00 00       	call   8007d8 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a6:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001ad:	ff 15 18 40 80 00    	call   *0x804018
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	0f 88 7e 03 00 00    	js     80053c <umain+0x4be>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 79 2b 80 00       	push   $0x802b79
  8001c6:	e8 0d 06 00 00       	call   8007d8 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001cb:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d3:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001db:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e3:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001eb:	83 c4 08             	add    $0x8,%esp
  8001ee:	68 00 c0 cc cc       	push   $0xccccc000
  8001f3:	6a 00                	push   $0x0
  8001f5:	e8 b7 10 00 00       	call   8012b1 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001fa:	83 c4 0c             	add    $0xc,%esp
  8001fd:	68 00 02 00 00       	push   $0x200
  800202:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80020c:	50                   	push   %eax
  80020d:	ff 15 10 40 80 00    	call   *0x804010
  800213:	83 c4 10             	add    $0x10,%esp
  800216:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800219:	0f 85 2f 03 00 00    	jne    80054e <umain+0x4d0>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 8d 2b 80 00       	push   $0x802b8d
  800227:	e8 ac 05 00 00       	call   8007d8 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80022c:	ba 02 01 00 00       	mov    $0x102,%edx
  800231:	b8 a3 2b 80 00       	mov    $0x802ba3,%eax
  800236:	e8 f8 fd ff ff       	call   800033 <xopen>
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	85 c0                	test   %eax,%eax
  800240:	0f 88 1a 03 00 00    	js     800560 <umain+0x4e2>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800246:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	ff 35 00 40 80 00    	pushl  0x804000
  800255:	e8 45 0b 00 00       	call   800d9f <strlen>
  80025a:	83 c4 0c             	add    $0xc,%esp
  80025d:	50                   	push   %eax
  80025e:	ff 35 00 40 80 00    	pushl  0x804000
  800264:	68 00 c0 cc cc       	push   $0xccccc000
  800269:	ff d3                	call   *%ebx
  80026b:	89 c3                	mov    %eax,%ebx
  80026d:	83 c4 04             	add    $0x4,%esp
  800270:	ff 35 00 40 80 00    	pushl  0x804000
  800276:	e8 24 0b 00 00       	call   800d9f <strlen>
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	39 d8                	cmp    %ebx,%eax
  800280:	0f 85 ec 02 00 00    	jne    800572 <umain+0x4f4>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	68 d5 2b 80 00       	push   $0x802bd5
  80028e:	e8 45 05 00 00       	call   8007d8 <cprintf>

	FVA->fd_offset = 0;
  800293:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  80029a:	00 00 00 
	memset(buf, 0, sizeof buf);
  80029d:	83 c4 0c             	add    $0xc,%esp
  8002a0:	68 00 02 00 00       	push   $0x200
  8002a5:	6a 00                	push   $0x0
  8002a7:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002ad:	53                   	push   %ebx
  8002ae:	e8 99 0c 00 00       	call   800f4c <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002b3:	83 c4 0c             	add    $0xc,%esp
  8002b6:	68 00 02 00 00       	push   $0x200
  8002bb:	53                   	push   %ebx
  8002bc:	68 00 c0 cc cc       	push   $0xccccc000
  8002c1:	ff 15 10 40 80 00    	call   *0x804010
  8002c7:	89 c3                	mov    %eax,%ebx
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	0f 88 b0 02 00 00    	js     800584 <umain+0x506>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	ff 35 00 40 80 00    	pushl  0x804000
  8002dd:	e8 bd 0a 00 00       	call   800d9f <strlen>
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	39 d8                	cmp    %ebx,%eax
  8002e7:	0f 85 a9 02 00 00    	jne    800596 <umain+0x518>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	ff 35 00 40 80 00    	pushl  0x804000
  8002f6:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002fc:	50                   	push   %eax
  8002fd:	e8 9f 0b 00 00       	call   800ea1 <strcmp>
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	85 c0                	test   %eax,%eax
  800307:	0f 85 9b 02 00 00    	jne    8005a8 <umain+0x52a>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	68 9c 2d 80 00       	push   $0x802d9c
  800315:	e8 be 04 00 00       	call   8007d8 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80031a:	83 c4 08             	add    $0x8,%esp
  80031d:	6a 00                	push   $0x0
  80031f:	68 a0 2a 80 00       	push   $0x802aa0
  800324:	e8 77 1a 00 00       	call   801da0 <open>
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032f:	74 08                	je     800339 <umain+0x2bb>
  800331:	85 c0                	test   %eax,%eax
  800333:	0f 88 83 02 00 00    	js     8005bc <umain+0x53e>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800339:	85 c0                	test   %eax,%eax
  80033b:	0f 89 8d 02 00 00    	jns    8005ce <umain+0x550>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	6a 00                	push   $0x0
  800346:	68 d5 2a 80 00       	push   $0x802ad5
  80034b:	e8 50 1a 00 00       	call   801da0 <open>
  800350:	83 c4 10             	add    $0x10,%esp
  800353:	85 c0                	test   %eax,%eax
  800355:	0f 88 87 02 00 00    	js     8005e2 <umain+0x564>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  80035b:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035e:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800365:	0f 85 89 02 00 00    	jne    8005f4 <umain+0x576>
  80036b:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  800372:	0f 85 7c 02 00 00    	jne    8005f4 <umain+0x576>
  800378:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037e:	85 db                	test   %ebx,%ebx
  800380:	0f 85 6e 02 00 00    	jne    8005f4 <umain+0x576>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 fc 2a 80 00       	push   $0x802afc
  80038e:	e8 45 04 00 00       	call   8007d8 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  800393:	83 c4 08             	add    $0x8,%esp
  800396:	68 01 01 00 00       	push   $0x101
  80039b:	68 04 2c 80 00       	push   $0x802c04
  8003a0:	e8 fb 19 00 00       	call   801da0 <open>
  8003a5:	89 c7                	mov    %eax,%edi
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	85 c0                	test   %eax,%eax
  8003ac:	0f 88 56 02 00 00    	js     800608 <umain+0x58a>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	68 00 02 00 00       	push   $0x200
  8003ba:	6a 00                	push   $0x0
  8003bc:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003c2:	50                   	push   %eax
  8003c3:	e8 84 0b 00 00       	call   800f4c <memset>
  8003c8:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003cb:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003cd:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003d3:	83 ec 04             	sub    $0x4,%esp
  8003d6:	68 00 02 00 00       	push   $0x200
  8003db:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003e1:	50                   	push   %eax
  8003e2:	57                   	push   %edi
  8003e3:	e8 f9 15 00 00       	call   8019e1 <write>
  8003e8:	83 c4 10             	add    $0x10,%esp
  8003eb:	85 c0                	test   %eax,%eax
  8003ed:	0f 88 27 02 00 00    	js     80061a <umain+0x59c>
  8003f3:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f9:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003ff:	75 cc                	jne    8003cd <umain+0x34f>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800401:	83 ec 0c             	sub    $0xc,%esp
  800404:	57                   	push   %edi
  800405:	e8 b7 13 00 00       	call   8017c1 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80040a:	83 c4 08             	add    $0x8,%esp
  80040d:	6a 00                	push   $0x0
  80040f:	68 04 2c 80 00       	push   $0x802c04
  800414:	e8 87 19 00 00       	call   801da0 <open>
  800419:	89 c6                	mov    %eax,%esi
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	85 c0                	test   %eax,%eax
  800420:	0f 88 0a 02 00 00    	js     800630 <umain+0x5b2>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800426:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  80042c:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800432:	83 ec 04             	sub    $0x4,%esp
  800435:	68 00 02 00 00       	push   $0x200
  80043a:	57                   	push   %edi
  80043b:	56                   	push   %esi
  80043c:	e8 55 15 00 00       	call   801996 <readn>
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	85 c0                	test   %eax,%eax
  800446:	0f 88 f6 01 00 00    	js     800642 <umain+0x5c4>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  80044c:	3d 00 02 00 00       	cmp    $0x200,%eax
  800451:	0f 85 01 02 00 00    	jne    800658 <umain+0x5da>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800457:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  80045d:	39 d8                	cmp    %ebx,%eax
  80045f:	0f 85 0e 02 00 00    	jne    800673 <umain+0x5f5>
  800465:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80046b:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  800471:	75 b9                	jne    80042c <umain+0x3ae>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800473:	83 ec 0c             	sub    $0xc,%esp
  800476:	56                   	push   %esi
  800477:	e8 45 13 00 00       	call   8017c1 <close>
	cprintf("large file is good\n");
  80047c:	c7 04 24 49 2c 80 00 	movl   $0x802c49,(%esp)
  800483:	e8 50 03 00 00       	call   8007d8 <cprintf>
}
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048e:	5b                   	pop    %ebx
  80048f:	5e                   	pop    %esi
  800490:	5f                   	pop    %edi
  800491:	5d                   	pop    %ebp
  800492:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  800493:	50                   	push   %eax
  800494:	68 ab 2a 80 00       	push   $0x802aab
  800499:	6a 20                	push   $0x20
  80049b:	68 c5 2a 80 00       	push   $0x802ac5
  8004a0:	e8 4c 02 00 00       	call   8006f1 <_panic>
		panic("serve_open /not-found succeeded!");
  8004a5:	83 ec 04             	sub    $0x4,%esp
  8004a8:	68 60 2c 80 00       	push   $0x802c60
  8004ad:	6a 22                	push   $0x22
  8004af:	68 c5 2a 80 00       	push   $0x802ac5
  8004b4:	e8 38 02 00 00       	call   8006f1 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b9:	50                   	push   %eax
  8004ba:	68 de 2a 80 00       	push   $0x802ade
  8004bf:	6a 25                	push   $0x25
  8004c1:	68 c5 2a 80 00       	push   $0x802ac5
  8004c6:	e8 26 02 00 00       	call   8006f1 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 84 2c 80 00       	push   $0x802c84
  8004d3:	6a 27                	push   $0x27
  8004d5:	68 c5 2a 80 00       	push   $0x802ac5
  8004da:	e8 12 02 00 00       	call   8006f1 <_panic>
		panic("file_stat: %e", r);
  8004df:	50                   	push   %eax
  8004e0:	68 0a 2b 80 00       	push   $0x802b0a
  8004e5:	6a 2b                	push   $0x2b
  8004e7:	68 c5 2a 80 00       	push   $0x802ac5
  8004ec:	e8 00 02 00 00       	call   8006f1 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004f1:	83 ec 0c             	sub    $0xc,%esp
  8004f4:	ff 35 00 40 80 00    	pushl  0x804000
  8004fa:	e8 a0 08 00 00       	call   800d9f <strlen>
  8004ff:	89 04 24             	mov    %eax,(%esp)
  800502:	ff 75 cc             	pushl  -0x34(%ebp)
  800505:	68 b4 2c 80 00       	push   $0x802cb4
  80050a:	6a 2d                	push   $0x2d
  80050c:	68 c5 2a 80 00       	push   $0x802ac5
  800511:	e8 db 01 00 00       	call   8006f1 <_panic>
		panic("file_read: %e", r);
  800516:	50                   	push   %eax
  800517:	68 2b 2b 80 00       	push   $0x802b2b
  80051c:	6a 32                	push   $0x32
  80051e:	68 c5 2a 80 00       	push   $0x802ac5
  800523:	e8 c9 01 00 00       	call   8006f1 <_panic>
		panic("file_read returned wrong data");
  800528:	83 ec 04             	sub    $0x4,%esp
  80052b:	68 39 2b 80 00       	push   $0x802b39
  800530:	6a 34                	push   $0x34
  800532:	68 c5 2a 80 00       	push   $0x802ac5
  800537:	e8 b5 01 00 00       	call   8006f1 <_panic>
		panic("file_close: %e", r);
  80053c:	50                   	push   %eax
  80053d:	68 6a 2b 80 00       	push   $0x802b6a
  800542:	6a 38                	push   $0x38
  800544:	68 c5 2a 80 00       	push   $0x802ac5
  800549:	e8 a3 01 00 00       	call   8006f1 <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054e:	50                   	push   %eax
  80054f:	68 dc 2c 80 00       	push   $0x802cdc
  800554:	6a 43                	push   $0x43
  800556:	68 c5 2a 80 00       	push   $0x802ac5
  80055b:	e8 91 01 00 00       	call   8006f1 <_panic>
		panic("serve_open /new-file: %e", r);
  800560:	50                   	push   %eax
  800561:	68 ad 2b 80 00       	push   $0x802bad
  800566:	6a 48                	push   $0x48
  800568:	68 c5 2a 80 00       	push   $0x802ac5
  80056d:	e8 7f 01 00 00       	call   8006f1 <_panic>
		panic("file_write: %e", r);
  800572:	53                   	push   %ebx
  800573:	68 c6 2b 80 00       	push   $0x802bc6
  800578:	6a 4b                	push   $0x4b
  80057a:	68 c5 2a 80 00       	push   $0x802ac5
  80057f:	e8 6d 01 00 00       	call   8006f1 <_panic>
		panic("file_read after file_write: %e", r);
  800584:	50                   	push   %eax
  800585:	68 14 2d 80 00       	push   $0x802d14
  80058a:	6a 51                	push   $0x51
  80058c:	68 c5 2a 80 00       	push   $0x802ac5
  800591:	e8 5b 01 00 00       	call   8006f1 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800596:	53                   	push   %ebx
  800597:	68 34 2d 80 00       	push   $0x802d34
  80059c:	6a 53                	push   $0x53
  80059e:	68 c5 2a 80 00       	push   $0x802ac5
  8005a3:	e8 49 01 00 00       	call   8006f1 <_panic>
		panic("file_read after file_write returned wrong data");
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	68 6c 2d 80 00       	push   $0x802d6c
  8005b0:	6a 55                	push   $0x55
  8005b2:	68 c5 2a 80 00       	push   $0x802ac5
  8005b7:	e8 35 01 00 00       	call   8006f1 <_panic>
		panic("open /not-found: %e", r);
  8005bc:	50                   	push   %eax
  8005bd:	68 b1 2a 80 00       	push   $0x802ab1
  8005c2:	6a 5a                	push   $0x5a
  8005c4:	68 c5 2a 80 00       	push   $0x802ac5
  8005c9:	e8 23 01 00 00       	call   8006f1 <_panic>
		panic("open /not-found succeeded!");
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	68 e9 2b 80 00       	push   $0x802be9
  8005d6:	6a 5c                	push   $0x5c
  8005d8:	68 c5 2a 80 00       	push   $0x802ac5
  8005dd:	e8 0f 01 00 00       	call   8006f1 <_panic>
		panic("open /newmotd: %e", r);
  8005e2:	50                   	push   %eax
  8005e3:	68 e4 2a 80 00       	push   $0x802ae4
  8005e8:	6a 5f                	push   $0x5f
  8005ea:	68 c5 2a 80 00       	push   $0x802ac5
  8005ef:	e8 fd 00 00 00       	call   8006f1 <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 c0 2d 80 00       	push   $0x802dc0
  8005fc:	6a 62                	push   $0x62
  8005fe:	68 c5 2a 80 00       	push   $0x802ac5
  800603:	e8 e9 00 00 00       	call   8006f1 <_panic>
		panic("creat /big: %e", f);
  800608:	50                   	push   %eax
  800609:	68 09 2c 80 00       	push   $0x802c09
  80060e:	6a 67                	push   $0x67
  800610:	68 c5 2a 80 00       	push   $0x802ac5
  800615:	e8 d7 00 00 00       	call   8006f1 <_panic>
			panic("write /big@%d: %e", i, r);
  80061a:	83 ec 0c             	sub    $0xc,%esp
  80061d:	50                   	push   %eax
  80061e:	56                   	push   %esi
  80061f:	68 18 2c 80 00       	push   $0x802c18
  800624:	6a 6c                	push   $0x6c
  800626:	68 c5 2a 80 00       	push   $0x802ac5
  80062b:	e8 c1 00 00 00       	call   8006f1 <_panic>
		panic("open /big: %e", f);
  800630:	50                   	push   %eax
  800631:	68 2a 2c 80 00       	push   $0x802c2a
  800636:	6a 71                	push   $0x71
  800638:	68 c5 2a 80 00       	push   $0x802ac5
  80063d:	e8 af 00 00 00       	call   8006f1 <_panic>
			panic("read /big@%d: %e", i, r);
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	53                   	push   %ebx
  800647:	68 38 2c 80 00       	push   $0x802c38
  80064c:	6a 75                	push   $0x75
  80064e:	68 c5 2a 80 00       	push   $0x802ac5
  800653:	e8 99 00 00 00       	call   8006f1 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	68 00 02 00 00       	push   $0x200
  800660:	50                   	push   %eax
  800661:	53                   	push   %ebx
  800662:	68 e8 2d 80 00       	push   $0x802de8
  800667:	6a 77                	push   $0x77
  800669:	68 c5 2a 80 00       	push   $0x802ac5
  80066e:	e8 7e 00 00 00       	call   8006f1 <_panic>
			panic("read /big from %d returned bad data %d",
  800673:	83 ec 0c             	sub    $0xc,%esp
  800676:	50                   	push   %eax
  800677:	53                   	push   %ebx
  800678:	68 14 2e 80 00       	push   $0x802e14
  80067d:	6a 7a                	push   $0x7a
  80067f:	68 c5 2a 80 00       	push   $0x802ac5
  800684:	e8 68 00 00 00       	call   8006f1 <_panic>

00800689 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800689:	f3 0f 1e fb          	endbr32 
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	56                   	push   %esi
  800691:	53                   	push   %ebx
  800692:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800695:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800698:	e8 41 0b 00 00       	call   8011de <sys_getenvid>
  80069d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006a2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8006a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006aa:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	85 db                	test   %ebx,%ebx
  8006b1:	7e 07                	jle    8006ba <libmain+0x31>
		binaryname = argv[0];
  8006b3:	8b 06                	mov    (%esi),%eax
  8006b5:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	56                   	push   %esi
  8006be:	53                   	push   %ebx
  8006bf:	e8 ba f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006c4:	e8 0a 00 00 00       	call   8006d3 <exit>
}
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006cf:	5b                   	pop    %ebx
  8006d0:	5e                   	pop    %esi
  8006d1:	5d                   	pop    %ebp
  8006d2:	c3                   	ret    

008006d3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006d3:	f3 0f 1e fb          	endbr32 
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8006dd:	e8 10 11 00 00       	call   8017f2 <close_all>
	sys_env_destroy(0);
  8006e2:	83 ec 0c             	sub    $0xc,%esp
  8006e5:	6a 00                	push   $0x0
  8006e7:	e8 ad 0a 00 00       	call   801199 <sys_env_destroy>
}
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	c9                   	leave  
  8006f0:	c3                   	ret    

008006f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006f1:	f3 0f 1e fb          	endbr32 
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	56                   	push   %esi
  8006f9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8006fa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006fd:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800703:	e8 d6 0a 00 00       	call   8011de <sys_getenvid>
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	ff 75 08             	pushl  0x8(%ebp)
  800711:	56                   	push   %esi
  800712:	50                   	push   %eax
  800713:	68 6c 2e 80 00       	push   $0x802e6c
  800718:	e8 bb 00 00 00       	call   8007d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80071d:	83 c4 18             	add    $0x18,%esp
  800720:	53                   	push   %ebx
  800721:	ff 75 10             	pushl  0x10(%ebp)
  800724:	e8 5a 00 00 00       	call   800783 <vcprintf>
	cprintf("\n");
  800729:	c7 04 24 e3 31 80 00 	movl   $0x8031e3,(%esp)
  800730:	e8 a3 00 00 00       	call   8007d8 <cprintf>
  800735:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800738:	cc                   	int3   
  800739:	eb fd                	jmp    800738 <_panic+0x47>

0080073b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80073b:	f3 0f 1e fb          	endbr32 
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	53                   	push   %ebx
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800749:	8b 13                	mov    (%ebx),%edx
  80074b:	8d 42 01             	lea    0x1(%edx),%eax
  80074e:	89 03                	mov    %eax,(%ebx)
  800750:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800753:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800757:	3d ff 00 00 00       	cmp    $0xff,%eax
  80075c:	74 09                	je     800767 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80075e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800765:	c9                   	leave  
  800766:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	68 ff 00 00 00       	push   $0xff
  80076f:	8d 43 08             	lea    0x8(%ebx),%eax
  800772:	50                   	push   %eax
  800773:	e8 dc 09 00 00       	call   801154 <sys_cputs>
		b->idx = 0;
  800778:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	eb db                	jmp    80075e <putch+0x23>

00800783 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800783:	f3 0f 1e fb          	endbr32 
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800790:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800797:	00 00 00 
	b.cnt = 0;
  80079a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	ff 75 08             	pushl  0x8(%ebp)
  8007aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b0:	50                   	push   %eax
  8007b1:	68 3b 07 80 00       	push   $0x80073b
  8007b6:	e8 20 01 00 00       	call   8008db <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8007bb:	83 c4 08             	add    $0x8,%esp
  8007be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007ca:	50                   	push   %eax
  8007cb:	e8 84 09 00 00       	call   801154 <sys_cputs>

	return b.cnt;
}
  8007d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    

008007d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007d8:	f3 0f 1e fb          	endbr32 
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007e2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007e5:	50                   	push   %eax
  8007e6:	ff 75 08             	pushl  0x8(%ebp)
  8007e9:	e8 95 ff ff ff       	call   800783 <vcprintf>
	va_end(ap);

	return cnt;
}
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    

008007f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	57                   	push   %edi
  8007f4:	56                   	push   %esi
  8007f5:	53                   	push   %ebx
  8007f6:	83 ec 1c             	sub    $0x1c,%esp
  8007f9:	89 c7                	mov    %eax,%edi
  8007fb:	89 d6                	mov    %edx,%esi
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
  800803:	89 d1                	mov    %edx,%ecx
  800805:	89 c2                	mov    %eax,%edx
  800807:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80080d:	8b 45 10             	mov    0x10(%ebp),%eax
  800810:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800813:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800816:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80081d:	39 c2                	cmp    %eax,%edx
  80081f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800822:	72 3e                	jb     800862 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800824:	83 ec 0c             	sub    $0xc,%esp
  800827:	ff 75 18             	pushl  0x18(%ebp)
  80082a:	83 eb 01             	sub    $0x1,%ebx
  80082d:	53                   	push   %ebx
  80082e:	50                   	push   %eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 e4             	pushl  -0x1c(%ebp)
  800835:	ff 75 e0             	pushl  -0x20(%ebp)
  800838:	ff 75 dc             	pushl  -0x24(%ebp)
  80083b:	ff 75 d8             	pushl  -0x28(%ebp)
  80083e:	e8 fd 1f 00 00       	call   802840 <__udivdi3>
  800843:	83 c4 18             	add    $0x18,%esp
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	89 f2                	mov    %esi,%edx
  80084a:	89 f8                	mov    %edi,%eax
  80084c:	e8 9f ff ff ff       	call   8007f0 <printnum>
  800851:	83 c4 20             	add    $0x20,%esp
  800854:	eb 13                	jmp    800869 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	56                   	push   %esi
  80085a:	ff 75 18             	pushl  0x18(%ebp)
  80085d:	ff d7                	call   *%edi
  80085f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800862:	83 eb 01             	sub    $0x1,%ebx
  800865:	85 db                	test   %ebx,%ebx
  800867:	7f ed                	jg     800856 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	56                   	push   %esi
  80086d:	83 ec 04             	sub    $0x4,%esp
  800870:	ff 75 e4             	pushl  -0x1c(%ebp)
  800873:	ff 75 e0             	pushl  -0x20(%ebp)
  800876:	ff 75 dc             	pushl  -0x24(%ebp)
  800879:	ff 75 d8             	pushl  -0x28(%ebp)
  80087c:	e8 cf 20 00 00       	call   802950 <__umoddi3>
  800881:	83 c4 14             	add    $0x14,%esp
  800884:	0f be 80 8f 2e 80 00 	movsbl 0x802e8f(%eax),%eax
  80088b:	50                   	push   %eax
  80088c:	ff d7                	call   *%edi
}
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800894:	5b                   	pop    %ebx
  800895:	5e                   	pop    %esi
  800896:	5f                   	pop    %edi
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800899:	f3 0f 1e fb          	endbr32 
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8008a3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8008a7:	8b 10                	mov    (%eax),%edx
  8008a9:	3b 50 04             	cmp    0x4(%eax),%edx
  8008ac:	73 0a                	jae    8008b8 <sprintputch+0x1f>
		*b->buf++ = ch;
  8008ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008b1:	89 08                	mov    %ecx,(%eax)
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	88 02                	mov    %al,(%edx)
}
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <printfmt>:
{
  8008ba:	f3 0f 1e fb          	endbr32 
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008c4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 10             	pushl  0x10(%ebp)
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 05 00 00 00       	call   8008db <vprintfmt>
}
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	c9                   	leave  
  8008da:	c3                   	ret    

008008db <vprintfmt>:
{
  8008db:	f3 0f 1e fb          	endbr32 
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	57                   	push   %edi
  8008e3:	56                   	push   %esi
  8008e4:	53                   	push   %ebx
  8008e5:	83 ec 3c             	sub    $0x3c,%esp
  8008e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8008eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008ee:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008f1:	e9 8e 03 00 00       	jmp    800c84 <vprintfmt+0x3a9>
		padc = ' ';
  8008f6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8008fa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800901:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800908:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80090f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800914:	8d 47 01             	lea    0x1(%edi),%eax
  800917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80091a:	0f b6 17             	movzbl (%edi),%edx
  80091d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800920:	3c 55                	cmp    $0x55,%al
  800922:	0f 87 df 03 00 00    	ja     800d07 <vprintfmt+0x42c>
  800928:	0f b6 c0             	movzbl %al,%eax
  80092b:	3e ff 24 85 e0 2f 80 	notrack jmp *0x802fe0(,%eax,4)
  800932:	00 
  800933:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800936:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80093a:	eb d8                	jmp    800914 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80093c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80093f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800943:	eb cf                	jmp    800914 <vprintfmt+0x39>
  800945:	0f b6 d2             	movzbl %dl,%edx
  800948:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800953:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800956:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80095a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80095d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800960:	83 f9 09             	cmp    $0x9,%ecx
  800963:	77 55                	ja     8009ba <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800965:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800968:	eb e9                	jmp    800953 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800972:	8b 45 14             	mov    0x14(%ebp),%eax
  800975:	8d 40 04             	lea    0x4(%eax),%eax
  800978:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80097b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80097e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800982:	79 90                	jns    800914 <vprintfmt+0x39>
				width = precision, precision = -1;
  800984:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800987:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80098a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800991:	eb 81                	jmp    800914 <vprintfmt+0x39>
  800993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800996:	85 c0                	test   %eax,%eax
  800998:	ba 00 00 00 00       	mov    $0x0,%edx
  80099d:	0f 49 d0             	cmovns %eax,%edx
  8009a0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009a6:	e9 69 ff ff ff       	jmp    800914 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8009ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009ae:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8009b5:	e9 5a ff ff ff       	jmp    800914 <vprintfmt+0x39>
  8009ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8009bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c0:	eb bc                	jmp    80097e <vprintfmt+0xa3>
			lflag++;
  8009c2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009c8:	e9 47 ff ff ff       	jmp    800914 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	8d 78 04             	lea    0x4(%eax),%edi
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	ff 30                	pushl  (%eax)
  8009d9:	ff d6                	call   *%esi
			break;
  8009db:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009de:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009e1:	e9 9b 02 00 00       	jmp    800c81 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	8d 78 04             	lea    0x4(%eax),%edi
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	99                   	cltd   
  8009ef:	31 d0                	xor    %edx,%eax
  8009f1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009f3:	83 f8 0f             	cmp    $0xf,%eax
  8009f6:	7f 23                	jg     800a1b <vprintfmt+0x140>
  8009f8:	8b 14 85 40 31 80 00 	mov    0x803140(,%eax,4),%edx
  8009ff:	85 d2                	test   %edx,%edx
  800a01:	74 18                	je     800a1b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800a03:	52                   	push   %edx
  800a04:	68 99 32 80 00       	push   $0x803299
  800a09:	53                   	push   %ebx
  800a0a:	56                   	push   %esi
  800a0b:	e8 aa fe ff ff       	call   8008ba <printfmt>
  800a10:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a13:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a16:	e9 66 02 00 00       	jmp    800c81 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800a1b:	50                   	push   %eax
  800a1c:	68 a7 2e 80 00       	push   $0x802ea7
  800a21:	53                   	push   %ebx
  800a22:	56                   	push   %esi
  800a23:	e8 92 fe ff ff       	call   8008ba <printfmt>
  800a28:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a2b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a2e:	e9 4e 02 00 00       	jmp    800c81 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	83 c0 04             	add    $0x4,%eax
  800a39:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800a41:	85 d2                	test   %edx,%edx
  800a43:	b8 a0 2e 80 00       	mov    $0x802ea0,%eax
  800a48:	0f 45 c2             	cmovne %edx,%eax
  800a4b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	7e 06                	jle    800a5a <vprintfmt+0x17f>
  800a54:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800a58:	75 0d                	jne    800a67 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a5d:	89 c7                	mov    %eax,%edi
  800a5f:	03 45 e0             	add    -0x20(%ebp),%eax
  800a62:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a65:	eb 55                	jmp    800abc <vprintfmt+0x1e1>
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 d8             	pushl  -0x28(%ebp)
  800a6d:	ff 75 cc             	pushl  -0x34(%ebp)
  800a70:	e8 46 03 00 00       	call   800dbb <strnlen>
  800a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a78:	29 c2                	sub    %eax,%edx
  800a7a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800a82:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800a86:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a89:	85 ff                	test   %edi,%edi
  800a8b:	7e 11                	jle    800a9e <vprintfmt+0x1c3>
					putch(padc, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	53                   	push   %ebx
  800a91:	ff 75 e0             	pushl  -0x20(%ebp)
  800a94:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a96:	83 ef 01             	sub    $0x1,%edi
  800a99:	83 c4 10             	add    $0x10,%esp
  800a9c:	eb eb                	jmp    800a89 <vprintfmt+0x1ae>
  800a9e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800aa1:	85 d2                	test   %edx,%edx
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	0f 49 c2             	cmovns %edx,%eax
  800aab:	29 c2                	sub    %eax,%edx
  800aad:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800ab0:	eb a8                	jmp    800a5a <vprintfmt+0x17f>
					putch(ch, putdat);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	53                   	push   %ebx
  800ab6:	52                   	push   %edx
  800ab7:	ff d6                	call   *%esi
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800abf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac1:	83 c7 01             	add    $0x1,%edi
  800ac4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ac8:	0f be d0             	movsbl %al,%edx
  800acb:	85 d2                	test   %edx,%edx
  800acd:	74 4b                	je     800b1a <vprintfmt+0x23f>
  800acf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ad3:	78 06                	js     800adb <vprintfmt+0x200>
  800ad5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800ad9:	78 1e                	js     800af9 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800adb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800adf:	74 d1                	je     800ab2 <vprintfmt+0x1d7>
  800ae1:	0f be c0             	movsbl %al,%eax
  800ae4:	83 e8 20             	sub    $0x20,%eax
  800ae7:	83 f8 5e             	cmp    $0x5e,%eax
  800aea:	76 c6                	jbe    800ab2 <vprintfmt+0x1d7>
					putch('?', putdat);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	53                   	push   %ebx
  800af0:	6a 3f                	push   $0x3f
  800af2:	ff d6                	call   *%esi
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	eb c3                	jmp    800abc <vprintfmt+0x1e1>
  800af9:	89 cf                	mov    %ecx,%edi
  800afb:	eb 0e                	jmp    800b0b <vprintfmt+0x230>
				putch(' ', putdat);
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	53                   	push   %ebx
  800b01:	6a 20                	push   $0x20
  800b03:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b05:	83 ef 01             	sub    $0x1,%edi
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	85 ff                	test   %edi,%edi
  800b0d:	7f ee                	jg     800afd <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800b0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	e9 67 01 00 00       	jmp    800c81 <vprintfmt+0x3a6>
  800b1a:	89 cf                	mov    %ecx,%edi
  800b1c:	eb ed                	jmp    800b0b <vprintfmt+0x230>
	if (lflag >= 2)
  800b1e:	83 f9 01             	cmp    $0x1,%ecx
  800b21:	7f 1b                	jg     800b3e <vprintfmt+0x263>
	else if (lflag)
  800b23:	85 c9                	test   %ecx,%ecx
  800b25:	74 63                	je     800b8a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b2f:	99                   	cltd   
  800b30:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b33:	8b 45 14             	mov    0x14(%ebp),%eax
  800b36:	8d 40 04             	lea    0x4(%eax),%eax
  800b39:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3c:	eb 17                	jmp    800b55 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	8b 50 04             	mov    0x4(%eax),%edx
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b49:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4f:	8d 40 08             	lea    0x8(%eax),%eax
  800b52:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800b55:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b58:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800b5b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800b60:	85 c9                	test   %ecx,%ecx
  800b62:	0f 89 ff 00 00 00    	jns    800c67 <vprintfmt+0x38c>
				putch('-', putdat);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	53                   	push   %ebx
  800b6c:	6a 2d                	push   $0x2d
  800b6e:	ff d6                	call   *%esi
				num = -(long long) num;
  800b70:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b73:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b76:	f7 da                	neg    %edx
  800b78:	83 d1 00             	adc    $0x0,%ecx
  800b7b:	f7 d9                	neg    %ecx
  800b7d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b85:	e9 dd 00 00 00       	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800b8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b92:	99                   	cltd   
  800b93:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b96:	8b 45 14             	mov    0x14(%ebp),%eax
  800b99:	8d 40 04             	lea    0x4(%eax),%eax
  800b9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b9f:	eb b4                	jmp    800b55 <vprintfmt+0x27a>
	if (lflag >= 2)
  800ba1:	83 f9 01             	cmp    $0x1,%ecx
  800ba4:	7f 1e                	jg     800bc4 <vprintfmt+0x2e9>
	else if (lflag)
  800ba6:	85 c9                	test   %ecx,%ecx
  800ba8:	74 32                	je     800bdc <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	8b 10                	mov    (%eax),%edx
  800baf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb4:	8d 40 04             	lea    0x4(%eax),%eax
  800bb7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bba:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800bbf:	e9 a3 00 00 00       	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800bc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc7:	8b 10                	mov    (%eax),%edx
  800bc9:	8b 48 04             	mov    0x4(%eax),%ecx
  800bcc:	8d 40 08             	lea    0x8(%eax),%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bd2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800bd7:	e9 8b 00 00 00       	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800bdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdf:	8b 10                	mov    (%eax),%edx
  800be1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800be6:	8d 40 04             	lea    0x4(%eax),%eax
  800be9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bec:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800bf1:	eb 74                	jmp    800c67 <vprintfmt+0x38c>
	if (lflag >= 2)
  800bf3:	83 f9 01             	cmp    $0x1,%ecx
  800bf6:	7f 1b                	jg     800c13 <vprintfmt+0x338>
	else if (lflag)
  800bf8:	85 c9                	test   %ecx,%ecx
  800bfa:	74 2c                	je     800c28 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bff:	8b 10                	mov    (%eax),%edx
  800c01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c06:	8d 40 04             	lea    0x4(%eax),%eax
  800c09:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c0c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800c11:	eb 54                	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800c13:	8b 45 14             	mov    0x14(%ebp),%eax
  800c16:	8b 10                	mov    (%eax),%edx
  800c18:	8b 48 04             	mov    0x4(%eax),%ecx
  800c1b:	8d 40 08             	lea    0x8(%eax),%eax
  800c1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c21:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800c26:	eb 3f                	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800c28:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2b:	8b 10                	mov    (%eax),%edx
  800c2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c32:	8d 40 04             	lea    0x4(%eax),%eax
  800c35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c38:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800c3d:	eb 28                	jmp    800c67 <vprintfmt+0x38c>
			putch('0', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	53                   	push   %ebx
  800c43:	6a 30                	push   $0x30
  800c45:	ff d6                	call   *%esi
			putch('x', putdat);
  800c47:	83 c4 08             	add    $0x8,%esp
  800c4a:	53                   	push   %ebx
  800c4b:	6a 78                	push   $0x78
  800c4d:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	8b 10                	mov    (%eax),%edx
  800c54:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800c59:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c5c:	8d 40 04             	lea    0x4(%eax),%eax
  800c5f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c62:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800c67:	83 ec 0c             	sub    $0xc,%esp
  800c6a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800c6e:	57                   	push   %edi
  800c6f:	ff 75 e0             	pushl  -0x20(%ebp)
  800c72:	50                   	push   %eax
  800c73:	51                   	push   %ecx
  800c74:	52                   	push   %edx
  800c75:	89 da                	mov    %ebx,%edx
  800c77:	89 f0                	mov    %esi,%eax
  800c79:	e8 72 fb ff ff       	call   8007f0 <printnum>
			break;
  800c7e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800c81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c84:	83 c7 01             	add    $0x1,%edi
  800c87:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c8b:	83 f8 25             	cmp    $0x25,%eax
  800c8e:	0f 84 62 fc ff ff    	je     8008f6 <vprintfmt+0x1b>
			if (ch == '\0')
  800c94:	85 c0                	test   %eax,%eax
  800c96:	0f 84 8b 00 00 00    	je     800d27 <vprintfmt+0x44c>
			putch(ch, putdat);
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	53                   	push   %ebx
  800ca0:	50                   	push   %eax
  800ca1:	ff d6                	call   *%esi
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	eb dc                	jmp    800c84 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800ca8:	83 f9 01             	cmp    $0x1,%ecx
  800cab:	7f 1b                	jg     800cc8 <vprintfmt+0x3ed>
	else if (lflag)
  800cad:	85 c9                	test   %ecx,%ecx
  800caf:	74 2c                	je     800cdd <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800cb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb4:	8b 10                	mov    (%eax),%edx
  800cb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbb:	8d 40 04             	lea    0x4(%eax),%eax
  800cbe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cc1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800cc6:	eb 9f                	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800cc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccb:	8b 10                	mov    (%eax),%edx
  800ccd:	8b 48 04             	mov    0x4(%eax),%ecx
  800cd0:	8d 40 08             	lea    0x8(%eax),%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cd6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800cdb:	eb 8a                	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	8b 10                	mov    (%eax),%edx
  800ce2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce7:	8d 40 04             	lea    0x4(%eax),%eax
  800cea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ced:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800cf2:	e9 70 ff ff ff       	jmp    800c67 <vprintfmt+0x38c>
			putch(ch, putdat);
  800cf7:	83 ec 08             	sub    $0x8,%esp
  800cfa:	53                   	push   %ebx
  800cfb:	6a 25                	push   $0x25
  800cfd:	ff d6                	call   *%esi
			break;
  800cff:	83 c4 10             	add    $0x10,%esp
  800d02:	e9 7a ff ff ff       	jmp    800c81 <vprintfmt+0x3a6>
			putch('%', putdat);
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	53                   	push   %ebx
  800d0b:	6a 25                	push   $0x25
  800d0d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	89 f8                	mov    %edi,%eax
  800d14:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d18:	74 05                	je     800d1f <vprintfmt+0x444>
  800d1a:	83 e8 01             	sub    $0x1,%eax
  800d1d:	eb f5                	jmp    800d14 <vprintfmt+0x439>
  800d1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d22:	e9 5a ff ff ff       	jmp    800c81 <vprintfmt+0x3a6>
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d2f:	f3 0f 1e fb          	endbr32 
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 18             	sub    $0x18,%esp
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d42:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d46:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	74 26                	je     800d7a <vsnprintf+0x4b>
  800d54:	85 d2                	test   %edx,%edx
  800d56:	7e 22                	jle    800d7a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d58:	ff 75 14             	pushl  0x14(%ebp)
  800d5b:	ff 75 10             	pushl  0x10(%ebp)
  800d5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d61:	50                   	push   %eax
  800d62:	68 99 08 80 00       	push   $0x800899
  800d67:	e8 6f fb ff ff       	call   8008db <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d75:	83 c4 10             	add    $0x10,%esp
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    
		return -E_INVAL;
  800d7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d7f:	eb f7                	jmp    800d78 <vsnprintf+0x49>

00800d81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d81:	f3 0f 1e fb          	endbr32 
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d8b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d8e:	50                   	push   %eax
  800d8f:	ff 75 10             	pushl  0x10(%ebp)
  800d92:	ff 75 0c             	pushl  0xc(%ebp)
  800d95:	ff 75 08             	pushl  0x8(%ebp)
  800d98:	e8 92 ff ff ff       	call   800d2f <vsnprintf>
	va_end(ap);

	return rc;
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d9f:	f3 0f 1e fb          	endbr32 
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800db2:	74 05                	je     800db9 <strlen+0x1a>
		n++;
  800db4:	83 c0 01             	add    $0x1,%eax
  800db7:	eb f5                	jmp    800dae <strlen+0xf>
	return n;
}
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dbb:	f3 0f 1e fb          	endbr32 
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcd:	39 d0                	cmp    %edx,%eax
  800dcf:	74 0d                	je     800dde <strnlen+0x23>
  800dd1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800dd5:	74 05                	je     800ddc <strnlen+0x21>
		n++;
  800dd7:	83 c0 01             	add    $0x1,%eax
  800dda:	eb f1                	jmp    800dcd <strnlen+0x12>
  800ddc:	89 c2                	mov    %eax,%edx
	return n;
}
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    

00800de2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800de2:	f3 0f 1e fb          	endbr32 
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	53                   	push   %ebx
  800dea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ded:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
  800df5:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800df9:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800dfc:	83 c0 01             	add    $0x1,%eax
  800dff:	84 d2                	test   %dl,%dl
  800e01:	75 f2                	jne    800df5 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800e03:	89 c8                	mov    %ecx,%eax
  800e05:	5b                   	pop    %ebx
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    

00800e08 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e08:	f3 0f 1e fb          	endbr32 
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 10             	sub    $0x10,%esp
  800e13:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e16:	53                   	push   %ebx
  800e17:	e8 83 ff ff ff       	call   800d9f <strlen>
  800e1c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	01 d8                	add    %ebx,%eax
  800e24:	50                   	push   %eax
  800e25:	e8 b8 ff ff ff       	call   800de2 <strcpy>
	return dst;
}
  800e2a:	89 d8                	mov    %ebx,%eax
  800e2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e31:	f3 0f 1e fb          	endbr32 
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	8b 75 08             	mov    0x8(%ebp),%esi
  800e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e40:	89 f3                	mov    %esi,%ebx
  800e42:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e45:	89 f0                	mov    %esi,%eax
  800e47:	39 d8                	cmp    %ebx,%eax
  800e49:	74 11                	je     800e5c <strncpy+0x2b>
		*dst++ = *src;
  800e4b:	83 c0 01             	add    $0x1,%eax
  800e4e:	0f b6 0a             	movzbl (%edx),%ecx
  800e51:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e54:	80 f9 01             	cmp    $0x1,%cl
  800e57:	83 da ff             	sbb    $0xffffffff,%edx
  800e5a:	eb eb                	jmp    800e47 <strncpy+0x16>
	}
	return ret;
}
  800e5c:	89 f0                	mov    %esi,%eax
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    

00800e62 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e62:	f3 0f 1e fb          	endbr32 
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e71:	8b 55 10             	mov    0x10(%ebp),%edx
  800e74:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e76:	85 d2                	test   %edx,%edx
  800e78:	74 21                	je     800e9b <strlcpy+0x39>
  800e7a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e7e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e80:	39 c2                	cmp    %eax,%edx
  800e82:	74 14                	je     800e98 <strlcpy+0x36>
  800e84:	0f b6 19             	movzbl (%ecx),%ebx
  800e87:	84 db                	test   %bl,%bl
  800e89:	74 0b                	je     800e96 <strlcpy+0x34>
			*dst++ = *src++;
  800e8b:	83 c1 01             	add    $0x1,%ecx
  800e8e:	83 c2 01             	add    $0x1,%edx
  800e91:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e94:	eb ea                	jmp    800e80 <strlcpy+0x1e>
  800e96:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e98:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e9b:	29 f0                	sub    %esi,%eax
}
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ea1:	f3 0f 1e fb          	endbr32 
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800eae:	0f b6 01             	movzbl (%ecx),%eax
  800eb1:	84 c0                	test   %al,%al
  800eb3:	74 0c                	je     800ec1 <strcmp+0x20>
  800eb5:	3a 02                	cmp    (%edx),%al
  800eb7:	75 08                	jne    800ec1 <strcmp+0x20>
		p++, q++;
  800eb9:	83 c1 01             	add    $0x1,%ecx
  800ebc:	83 c2 01             	add    $0x1,%edx
  800ebf:	eb ed                	jmp    800eae <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec1:	0f b6 c0             	movzbl %al,%eax
  800ec4:	0f b6 12             	movzbl (%edx),%edx
  800ec7:	29 d0                	sub    %edx,%eax
}
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ecb:	f3 0f 1e fb          	endbr32 
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	53                   	push   %ebx
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed9:	89 c3                	mov    %eax,%ebx
  800edb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ede:	eb 06                	jmp    800ee6 <strncmp+0x1b>
		n--, p++, q++;
  800ee0:	83 c0 01             	add    $0x1,%eax
  800ee3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ee6:	39 d8                	cmp    %ebx,%eax
  800ee8:	74 16                	je     800f00 <strncmp+0x35>
  800eea:	0f b6 08             	movzbl (%eax),%ecx
  800eed:	84 c9                	test   %cl,%cl
  800eef:	74 04                	je     800ef5 <strncmp+0x2a>
  800ef1:	3a 0a                	cmp    (%edx),%cl
  800ef3:	74 eb                	je     800ee0 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef5:	0f b6 00             	movzbl (%eax),%eax
  800ef8:	0f b6 12             	movzbl (%edx),%edx
  800efb:	29 d0                	sub    %edx,%eax
}
  800efd:	5b                   	pop    %ebx
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    
		return 0;
  800f00:	b8 00 00 00 00       	mov    $0x0,%eax
  800f05:	eb f6                	jmp    800efd <strncmp+0x32>

00800f07 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f07:	f3 0f 1e fb          	endbr32 
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f15:	0f b6 10             	movzbl (%eax),%edx
  800f18:	84 d2                	test   %dl,%dl
  800f1a:	74 09                	je     800f25 <strchr+0x1e>
		if (*s == c)
  800f1c:	38 ca                	cmp    %cl,%dl
  800f1e:	74 0a                	je     800f2a <strchr+0x23>
	for (; *s; s++)
  800f20:	83 c0 01             	add    $0x1,%eax
  800f23:	eb f0                	jmp    800f15 <strchr+0xe>
			return (char *) s;
	return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f2c:	f3 0f 1e fb          	endbr32 
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f3a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f3d:	38 ca                	cmp    %cl,%dl
  800f3f:	74 09                	je     800f4a <strfind+0x1e>
  800f41:	84 d2                	test   %dl,%dl
  800f43:	74 05                	je     800f4a <strfind+0x1e>
	for (; *s; s++)
  800f45:	83 c0 01             	add    $0x1,%eax
  800f48:	eb f0                	jmp    800f3a <strfind+0xe>
			break;
	return (char *) s;
}
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f4c:	f3 0f 1e fb          	endbr32 
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	57                   	push   %edi
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f5c:	85 c9                	test   %ecx,%ecx
  800f5e:	74 31                	je     800f91 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f60:	89 f8                	mov    %edi,%eax
  800f62:	09 c8                	or     %ecx,%eax
  800f64:	a8 03                	test   $0x3,%al
  800f66:	75 23                	jne    800f8b <memset+0x3f>
		c &= 0xFF;
  800f68:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f6c:	89 d3                	mov    %edx,%ebx
  800f6e:	c1 e3 08             	shl    $0x8,%ebx
  800f71:	89 d0                	mov    %edx,%eax
  800f73:	c1 e0 18             	shl    $0x18,%eax
  800f76:	89 d6                	mov    %edx,%esi
  800f78:	c1 e6 10             	shl    $0x10,%esi
  800f7b:	09 f0                	or     %esi,%eax
  800f7d:	09 c2                	or     %eax,%edx
  800f7f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f81:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f84:	89 d0                	mov    %edx,%eax
  800f86:	fc                   	cld    
  800f87:	f3 ab                	rep stos %eax,%es:(%edi)
  800f89:	eb 06                	jmp    800f91 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	fc                   	cld    
  800f8f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f91:	89 f8                	mov    %edi,%eax
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f98:	f3 0f 1e fb          	endbr32 
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	57                   	push   %edi
  800fa0:	56                   	push   %esi
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800faa:	39 c6                	cmp    %eax,%esi
  800fac:	73 32                	jae    800fe0 <memmove+0x48>
  800fae:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800fb1:	39 c2                	cmp    %eax,%edx
  800fb3:	76 2b                	jbe    800fe0 <memmove+0x48>
		s += n;
		d += n;
  800fb5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fb8:	89 fe                	mov    %edi,%esi
  800fba:	09 ce                	or     %ecx,%esi
  800fbc:	09 d6                	or     %edx,%esi
  800fbe:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800fc4:	75 0e                	jne    800fd4 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800fc6:	83 ef 04             	sub    $0x4,%edi
  800fc9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800fcc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800fcf:	fd                   	std    
  800fd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fd2:	eb 09                	jmp    800fdd <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800fd4:	83 ef 01             	sub    $0x1,%edi
  800fd7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800fda:	fd                   	std    
  800fdb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fdd:	fc                   	cld    
  800fde:	eb 1a                	jmp    800ffa <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fe0:	89 c2                	mov    %eax,%edx
  800fe2:	09 ca                	or     %ecx,%edx
  800fe4:	09 f2                	or     %esi,%edx
  800fe6:	f6 c2 03             	test   $0x3,%dl
  800fe9:	75 0a                	jne    800ff5 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800feb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fee:	89 c7                	mov    %eax,%edi
  800ff0:	fc                   	cld    
  800ff1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ff3:	eb 05                	jmp    800ffa <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800ff5:	89 c7                	mov    %eax,%edi
  800ff7:	fc                   	cld    
  800ff8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ffa:	5e                   	pop    %esi
  800ffb:	5f                   	pop    %edi
  800ffc:	5d                   	pop    %ebp
  800ffd:	c3                   	ret    

00800ffe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ffe:	f3 0f 1e fb          	endbr32 
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801008:	ff 75 10             	pushl  0x10(%ebp)
  80100b:	ff 75 0c             	pushl  0xc(%ebp)
  80100e:	ff 75 08             	pushl  0x8(%ebp)
  801011:	e8 82 ff ff ff       	call   800f98 <memmove>
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801018:	f3 0f 1e fb          	endbr32 
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8b 55 0c             	mov    0xc(%ebp),%edx
  801027:	89 c6                	mov    %eax,%esi
  801029:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80102c:	39 f0                	cmp    %esi,%eax
  80102e:	74 1c                	je     80104c <memcmp+0x34>
		if (*s1 != *s2)
  801030:	0f b6 08             	movzbl (%eax),%ecx
  801033:	0f b6 1a             	movzbl (%edx),%ebx
  801036:	38 d9                	cmp    %bl,%cl
  801038:	75 08                	jne    801042 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80103a:	83 c0 01             	add    $0x1,%eax
  80103d:	83 c2 01             	add    $0x1,%edx
  801040:	eb ea                	jmp    80102c <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801042:	0f b6 c1             	movzbl %cl,%eax
  801045:	0f b6 db             	movzbl %bl,%ebx
  801048:	29 d8                	sub    %ebx,%eax
  80104a:	eb 05                	jmp    801051 <memcmp+0x39>
	}

	return 0;
  80104c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801055:	f3 0f 1e fb          	endbr32 
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801062:	89 c2                	mov    %eax,%edx
  801064:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801067:	39 d0                	cmp    %edx,%eax
  801069:	73 09                	jae    801074 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106b:	38 08                	cmp    %cl,(%eax)
  80106d:	74 05                	je     801074 <memfind+0x1f>
	for (; s < ends; s++)
  80106f:	83 c0 01             	add    $0x1,%eax
  801072:	eb f3                	jmp    801067 <memfind+0x12>
			break;
	return (void *) s;
}
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801076:	f3 0f 1e fb          	endbr32 
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	57                   	push   %edi
  80107e:	56                   	push   %esi
  80107f:	53                   	push   %ebx
  801080:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801083:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801086:	eb 03                	jmp    80108b <strtol+0x15>
		s++;
  801088:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80108b:	0f b6 01             	movzbl (%ecx),%eax
  80108e:	3c 20                	cmp    $0x20,%al
  801090:	74 f6                	je     801088 <strtol+0x12>
  801092:	3c 09                	cmp    $0x9,%al
  801094:	74 f2                	je     801088 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801096:	3c 2b                	cmp    $0x2b,%al
  801098:	74 2a                	je     8010c4 <strtol+0x4e>
	int neg = 0;
  80109a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80109f:	3c 2d                	cmp    $0x2d,%al
  8010a1:	74 2b                	je     8010ce <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8010a9:	75 0f                	jne    8010ba <strtol+0x44>
  8010ab:	80 39 30             	cmpb   $0x30,(%ecx)
  8010ae:	74 28                	je     8010d8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8010b0:	85 db                	test   %ebx,%ebx
  8010b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010b7:	0f 44 d8             	cmove  %eax,%ebx
  8010ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8010c2:	eb 46                	jmp    80110a <strtol+0x94>
		s++;
  8010c4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8010c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8010cc:	eb d5                	jmp    8010a3 <strtol+0x2d>
		s++, neg = 1;
  8010ce:	83 c1 01             	add    $0x1,%ecx
  8010d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8010d6:	eb cb                	jmp    8010a3 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8010dc:	74 0e                	je     8010ec <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8010de:	85 db                	test   %ebx,%ebx
  8010e0:	75 d8                	jne    8010ba <strtol+0x44>
		s++, base = 8;
  8010e2:	83 c1 01             	add    $0x1,%ecx
  8010e5:	bb 08 00 00 00       	mov    $0x8,%ebx
  8010ea:	eb ce                	jmp    8010ba <strtol+0x44>
		s += 2, base = 16;
  8010ec:	83 c1 02             	add    $0x2,%ecx
  8010ef:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010f4:	eb c4                	jmp    8010ba <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8010f6:	0f be d2             	movsbl %dl,%edx
  8010f9:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010fc:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010ff:	7d 3a                	jge    80113b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801101:	83 c1 01             	add    $0x1,%ecx
  801104:	0f af 45 10          	imul   0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80110a:	0f b6 11             	movzbl (%ecx),%edx
  80110d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801110:	89 f3                	mov    %esi,%ebx
  801112:	80 fb 09             	cmp    $0x9,%bl
  801115:	76 df                	jbe    8010f6 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801117:	8d 72 9f             	lea    -0x61(%edx),%esi
  80111a:	89 f3                	mov    %esi,%ebx
  80111c:	80 fb 19             	cmp    $0x19,%bl
  80111f:	77 08                	ja     801129 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801121:	0f be d2             	movsbl %dl,%edx
  801124:	83 ea 57             	sub    $0x57,%edx
  801127:	eb d3                	jmp    8010fc <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801129:	8d 72 bf             	lea    -0x41(%edx),%esi
  80112c:	89 f3                	mov    %esi,%ebx
  80112e:	80 fb 19             	cmp    $0x19,%bl
  801131:	77 08                	ja     80113b <strtol+0xc5>
			dig = *s - 'A' + 10;
  801133:	0f be d2             	movsbl %dl,%edx
  801136:	83 ea 37             	sub    $0x37,%edx
  801139:	eb c1                	jmp    8010fc <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80113b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113f:	74 05                	je     801146 <strtol+0xd0>
		*endptr = (char *) s;
  801141:	8b 75 0c             	mov    0xc(%ebp),%esi
  801144:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801146:	89 c2                	mov    %eax,%edx
  801148:	f7 da                	neg    %edx
  80114a:	85 ff                	test   %edi,%edi
  80114c:	0f 45 c2             	cmovne %edx,%eax
}
  80114f:	5b                   	pop    %ebx
  801150:	5e                   	pop    %esi
  801151:	5f                   	pop    %edi
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    

00801154 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801154:	f3 0f 1e fb          	endbr32 
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	8b 55 08             	mov    0x8(%ebp),%edx
  801166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801169:	89 c3                	mov    %eax,%ebx
  80116b:	89 c7                	mov    %eax,%edi
  80116d:	89 c6                	mov    %eax,%esi
  80116f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801171:	5b                   	pop    %ebx
  801172:	5e                   	pop    %esi
  801173:	5f                   	pop    %edi
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <sys_cgetc>:

int
sys_cgetc(void)
{
  801176:	f3 0f 1e fb          	endbr32 
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	57                   	push   %edi
  80117e:	56                   	push   %esi
  80117f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801180:	ba 00 00 00 00       	mov    $0x0,%edx
  801185:	b8 01 00 00 00       	mov    $0x1,%eax
  80118a:	89 d1                	mov    %edx,%ecx
  80118c:	89 d3                	mov    %edx,%ebx
  80118e:	89 d7                	mov    %edx,%edi
  801190:	89 d6                	mov    %edx,%esi
  801192:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801194:	5b                   	pop    %ebx
  801195:	5e                   	pop    %esi
  801196:	5f                   	pop    %edi
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801199:	f3 0f 1e fb          	endbr32 
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	57                   	push   %edi
  8011a1:	56                   	push   %esi
  8011a2:	53                   	push   %ebx
  8011a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	b8 03 00 00 00       	mov    $0x3,%eax
  8011b3:	89 cb                	mov    %ecx,%ebx
  8011b5:	89 cf                	mov    %ecx,%edi
  8011b7:	89 ce                	mov    %ecx,%esi
  8011b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	7f 08                	jg     8011c7 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c2:	5b                   	pop    %ebx
  8011c3:	5e                   	pop    %esi
  8011c4:	5f                   	pop    %edi
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	50                   	push   %eax
  8011cb:	6a 03                	push   $0x3
  8011cd:	68 9f 31 80 00       	push   $0x80319f
  8011d2:	6a 23                	push   $0x23
  8011d4:	68 bc 31 80 00       	push   $0x8031bc
  8011d9:	e8 13 f5 ff ff       	call   8006f1 <_panic>

008011de <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8011de:	f3 0f 1e fb          	endbr32 
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	57                   	push   %edi
  8011e6:	56                   	push   %esi
  8011e7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ed:	b8 02 00 00 00       	mov    $0x2,%eax
  8011f2:	89 d1                	mov    %edx,%ecx
  8011f4:	89 d3                	mov    %edx,%ebx
  8011f6:	89 d7                	mov    %edx,%edi
  8011f8:	89 d6                	mov    %edx,%esi
  8011fa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011fc:	5b                   	pop    %ebx
  8011fd:	5e                   	pop    %esi
  8011fe:	5f                   	pop    %edi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    

00801201 <sys_yield>:

void
sys_yield(void)
{
  801201:	f3 0f 1e fb          	endbr32 
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	57                   	push   %edi
  801209:	56                   	push   %esi
  80120a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80120b:	ba 00 00 00 00       	mov    $0x0,%edx
  801210:	b8 0b 00 00 00       	mov    $0xb,%eax
  801215:	89 d1                	mov    %edx,%ecx
  801217:	89 d3                	mov    %edx,%ebx
  801219:	89 d7                	mov    %edx,%edi
  80121b:	89 d6                	mov    %edx,%esi
  80121d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5f                   	pop    %edi
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    

00801224 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801224:	f3 0f 1e fb          	endbr32 
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	57                   	push   %edi
  80122c:	56                   	push   %esi
  80122d:	53                   	push   %ebx
  80122e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801231:	be 00 00 00 00       	mov    $0x0,%esi
  801236:	8b 55 08             	mov    0x8(%ebp),%edx
  801239:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123c:	b8 04 00 00 00       	mov    $0x4,%eax
  801241:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801244:	89 f7                	mov    %esi,%edi
  801246:	cd 30                	int    $0x30
	if(check && ret > 0)
  801248:	85 c0                	test   %eax,%eax
  80124a:	7f 08                	jg     801254 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80124c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124f:	5b                   	pop    %ebx
  801250:	5e                   	pop    %esi
  801251:	5f                   	pop    %edi
  801252:	5d                   	pop    %ebp
  801253:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801254:	83 ec 0c             	sub    $0xc,%esp
  801257:	50                   	push   %eax
  801258:	6a 04                	push   $0x4
  80125a:	68 9f 31 80 00       	push   $0x80319f
  80125f:	6a 23                	push   $0x23
  801261:	68 bc 31 80 00       	push   $0x8031bc
  801266:	e8 86 f4 ff ff       	call   8006f1 <_panic>

0080126b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80126b:	f3 0f 1e fb          	endbr32 
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	57                   	push   %edi
  801273:	56                   	push   %esi
  801274:	53                   	push   %ebx
  801275:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801278:	8b 55 08             	mov    0x8(%ebp),%edx
  80127b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127e:	b8 05 00 00 00       	mov    $0x5,%eax
  801283:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801286:	8b 7d 14             	mov    0x14(%ebp),%edi
  801289:	8b 75 18             	mov    0x18(%ebp),%esi
  80128c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80128e:	85 c0                	test   %eax,%eax
  801290:	7f 08                	jg     80129a <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801295:	5b                   	pop    %ebx
  801296:	5e                   	pop    %esi
  801297:	5f                   	pop    %edi
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80129a:	83 ec 0c             	sub    $0xc,%esp
  80129d:	50                   	push   %eax
  80129e:	6a 05                	push   $0x5
  8012a0:	68 9f 31 80 00       	push   $0x80319f
  8012a5:	6a 23                	push   $0x23
  8012a7:	68 bc 31 80 00       	push   $0x8031bc
  8012ac:	e8 40 f4 ff ff       	call   8006f1 <_panic>

008012b1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012b1:	f3 0f 1e fb          	endbr32 
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	57                   	push   %edi
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8012ce:	89 df                	mov    %ebx,%edi
  8012d0:	89 de                	mov    %ebx,%esi
  8012d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	7f 08                	jg     8012e0 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	50                   	push   %eax
  8012e4:	6a 06                	push   $0x6
  8012e6:	68 9f 31 80 00       	push   $0x80319f
  8012eb:	6a 23                	push   $0x23
  8012ed:	68 bc 31 80 00       	push   $0x8031bc
  8012f2:	e8 fa f3 ff ff       	call   8006f1 <_panic>

008012f7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012f7:	f3 0f 1e fb          	endbr32 
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	57                   	push   %edi
  8012ff:	56                   	push   %esi
  801300:	53                   	push   %ebx
  801301:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801304:	bb 00 00 00 00       	mov    $0x0,%ebx
  801309:	8b 55 08             	mov    0x8(%ebp),%edx
  80130c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130f:	b8 08 00 00 00       	mov    $0x8,%eax
  801314:	89 df                	mov    %ebx,%edi
  801316:	89 de                	mov    %ebx,%esi
  801318:	cd 30                	int    $0x30
	if(check && ret > 0)
  80131a:	85 c0                	test   %eax,%eax
  80131c:	7f 08                	jg     801326 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80131e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801321:	5b                   	pop    %ebx
  801322:	5e                   	pop    %esi
  801323:	5f                   	pop    %edi
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801326:	83 ec 0c             	sub    $0xc,%esp
  801329:	50                   	push   %eax
  80132a:	6a 08                	push   $0x8
  80132c:	68 9f 31 80 00       	push   $0x80319f
  801331:	6a 23                	push   $0x23
  801333:	68 bc 31 80 00       	push   $0x8031bc
  801338:	e8 b4 f3 ff ff       	call   8006f1 <_panic>

0080133d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80133d:	f3 0f 1e fb          	endbr32 
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	57                   	push   %edi
  801345:	56                   	push   %esi
  801346:	53                   	push   %ebx
  801347:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80134a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134f:	8b 55 08             	mov    0x8(%ebp),%edx
  801352:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801355:	b8 09 00 00 00       	mov    $0x9,%eax
  80135a:	89 df                	mov    %ebx,%edi
  80135c:	89 de                	mov    %ebx,%esi
  80135e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801360:	85 c0                	test   %eax,%eax
  801362:	7f 08                	jg     80136c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801364:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801367:	5b                   	pop    %ebx
  801368:	5e                   	pop    %esi
  801369:	5f                   	pop    %edi
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	50                   	push   %eax
  801370:	6a 09                	push   $0x9
  801372:	68 9f 31 80 00       	push   $0x80319f
  801377:	6a 23                	push   $0x23
  801379:	68 bc 31 80 00       	push   $0x8031bc
  80137e:	e8 6e f3 ff ff       	call   8006f1 <_panic>

00801383 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801383:	f3 0f 1e fb          	endbr32 
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	57                   	push   %edi
  80138b:	56                   	push   %esi
  80138c:	53                   	push   %ebx
  80138d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801390:	bb 00 00 00 00       	mov    $0x0,%ebx
  801395:	8b 55 08             	mov    0x8(%ebp),%edx
  801398:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013a0:	89 df                	mov    %ebx,%edi
  8013a2:	89 de                	mov    %ebx,%esi
  8013a4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	7f 08                	jg     8013b2 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5f                   	pop    %edi
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	50                   	push   %eax
  8013b6:	6a 0a                	push   $0xa
  8013b8:	68 9f 31 80 00       	push   $0x80319f
  8013bd:	6a 23                	push   $0x23
  8013bf:	68 bc 31 80 00       	push   $0x8031bc
  8013c4:	e8 28 f3 ff ff       	call   8006f1 <_panic>

008013c9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8013c9:	f3 0f 1e fb          	endbr32 
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	57                   	push   %edi
  8013d1:	56                   	push   %esi
  8013d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8013de:	be 00 00 00 00       	mov    $0x0,%esi
  8013e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013e6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013e9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8013eb:	5b                   	pop    %ebx
  8013ec:	5e                   	pop    %esi
  8013ed:	5f                   	pop    %edi
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    

008013f0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8013f0:	f3 0f 1e fb          	endbr32 
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	57                   	push   %edi
  8013f8:	56                   	push   %esi
  8013f9:	53                   	push   %ebx
  8013fa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801402:	8b 55 08             	mov    0x8(%ebp),%edx
  801405:	b8 0d 00 00 00       	mov    $0xd,%eax
  80140a:	89 cb                	mov    %ecx,%ebx
  80140c:	89 cf                	mov    %ecx,%edi
  80140e:	89 ce                	mov    %ecx,%esi
  801410:	cd 30                	int    $0x30
	if(check && ret > 0)
  801412:	85 c0                	test   %eax,%eax
  801414:	7f 08                	jg     80141e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801416:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801419:	5b                   	pop    %ebx
  80141a:	5e                   	pop    %esi
  80141b:	5f                   	pop    %edi
  80141c:	5d                   	pop    %ebp
  80141d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	50                   	push   %eax
  801422:	6a 0d                	push   $0xd
  801424:	68 9f 31 80 00       	push   $0x80319f
  801429:	6a 23                	push   $0x23
  80142b:	68 bc 31 80 00       	push   $0x8031bc
  801430:	e8 bc f2 ff ff       	call   8006f1 <_panic>

00801435 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801435:	f3 0f 1e fb          	endbr32 
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	57                   	push   %edi
  80143d:	56                   	push   %esi
  80143e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80143f:	ba 00 00 00 00       	mov    $0x0,%edx
  801444:	b8 0e 00 00 00       	mov    $0xe,%eax
  801449:	89 d1                	mov    %edx,%ecx
  80144b:	89 d3                	mov    %edx,%ebx
  80144d:	89 d7                	mov    %edx,%edi
  80144f:	89 d6                	mov    %edx,%esi
  801451:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801453:	5b                   	pop    %ebx
  801454:	5e                   	pop    %esi
  801455:	5f                   	pop    %edi
  801456:	5d                   	pop    %ebp
  801457:	c3                   	ret    

00801458 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  801458:	f3 0f 1e fb          	endbr32 
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	57                   	push   %edi
  801460:	56                   	push   %esi
  801461:	53                   	push   %ebx
  801462:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801465:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146a:	8b 55 08             	mov    0x8(%ebp),%edx
  80146d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801470:	b8 0f 00 00 00       	mov    $0xf,%eax
  801475:	89 df                	mov    %ebx,%edi
  801477:	89 de                	mov    %ebx,%esi
  801479:	cd 30                	int    $0x30
	if(check && ret > 0)
  80147b:	85 c0                	test   %eax,%eax
  80147d:	7f 08                	jg     801487 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  80147f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801482:	5b                   	pop    %ebx
  801483:	5e                   	pop    %esi
  801484:	5f                   	pop    %edi
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801487:	83 ec 0c             	sub    $0xc,%esp
  80148a:	50                   	push   %eax
  80148b:	6a 0f                	push   $0xf
  80148d:	68 9f 31 80 00       	push   $0x80319f
  801492:	6a 23                	push   $0x23
  801494:	68 bc 31 80 00       	push   $0x8031bc
  801499:	e8 53 f2 ff ff       	call   8006f1 <_panic>

0080149e <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  80149e:	f3 0f 1e fb          	endbr32 
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	57                   	push   %edi
  8014a6:	56                   	push   %esi
  8014a7:	53                   	push   %ebx
  8014a8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8014bb:	89 df                	mov    %ebx,%edi
  8014bd:	89 de                	mov    %ebx,%esi
  8014bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	7f 08                	jg     8014cd <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  8014c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c8:	5b                   	pop    %ebx
  8014c9:	5e                   	pop    %esi
  8014ca:	5f                   	pop    %edi
  8014cb:	5d                   	pop    %ebp
  8014cc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014cd:	83 ec 0c             	sub    $0xc,%esp
  8014d0:	50                   	push   %eax
  8014d1:	6a 10                	push   $0x10
  8014d3:	68 9f 31 80 00       	push   $0x80319f
  8014d8:	6a 23                	push   $0x23
  8014da:	68 bc 31 80 00       	push   $0x8031bc
  8014df:	e8 0d f2 ff ff       	call   8006f1 <_panic>

008014e4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8014e4:	f3 0f 1e fb          	endbr32 
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	56                   	push   %esi
  8014ec:	53                   	push   %ebx
  8014ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	74 3d                	je     801537 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	50                   	push   %eax
  8014fe:	e8 ed fe ff ff       	call   8013f0 <sys_ipc_recv>
  801503:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801506:	85 f6                	test   %esi,%esi
  801508:	74 0b                	je     801515 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80150a:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801510:	8b 52 74             	mov    0x74(%edx),%edx
  801513:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801515:	85 db                	test   %ebx,%ebx
  801517:	74 0b                	je     801524 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801519:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80151f:	8b 52 78             	mov    0x78(%edx),%edx
  801522:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801524:	85 c0                	test   %eax,%eax
  801526:	78 21                	js     801549 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801528:	a1 08 50 80 00       	mov    0x805008,%eax
  80152d:	8b 40 70             	mov    0x70(%eax),%eax
}
  801530:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801533:	5b                   	pop    %ebx
  801534:	5e                   	pop    %esi
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801537:	83 ec 0c             	sub    $0xc,%esp
  80153a:	68 00 00 c0 ee       	push   $0xeec00000
  80153f:	e8 ac fe ff ff       	call   8013f0 <sys_ipc_recv>
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	eb bd                	jmp    801506 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801549:	85 f6                	test   %esi,%esi
  80154b:	74 10                	je     80155d <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80154d:	85 db                	test   %ebx,%ebx
  80154f:	75 df                	jne    801530 <ipc_recv+0x4c>
  801551:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801558:	00 00 00 
  80155b:	eb d3                	jmp    801530 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80155d:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801564:	00 00 00 
  801567:	eb e4                	jmp    80154d <ipc_recv+0x69>

00801569 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801569:	f3 0f 1e fb          	endbr32 
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	57                   	push   %edi
  801571:	56                   	push   %esi
  801572:	53                   	push   %ebx
  801573:	83 ec 0c             	sub    $0xc,%esp
  801576:	8b 7d 08             	mov    0x8(%ebp),%edi
  801579:	8b 75 0c             	mov    0xc(%ebp),%esi
  80157c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80157f:	85 db                	test   %ebx,%ebx
  801581:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801586:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801589:	ff 75 14             	pushl  0x14(%ebp)
  80158c:	53                   	push   %ebx
  80158d:	56                   	push   %esi
  80158e:	57                   	push   %edi
  80158f:	e8 35 fe ff ff       	call   8013c9 <sys_ipc_try_send>
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	85 c0                	test   %eax,%eax
  801599:	79 1e                	jns    8015b9 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80159b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80159e:	75 07                	jne    8015a7 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8015a0:	e8 5c fc ff ff       	call   801201 <sys_yield>
  8015a5:	eb e2                	jmp    801589 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8015a7:	50                   	push   %eax
  8015a8:	68 ca 31 80 00       	push   $0x8031ca
  8015ad:	6a 59                	push   $0x59
  8015af:	68 e5 31 80 00       	push   $0x8031e5
  8015b4:	e8 38 f1 ff ff       	call   8006f1 <_panic>
	}
}
  8015b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bc:	5b                   	pop    %ebx
  8015bd:	5e                   	pop    %esi
  8015be:	5f                   	pop    %edi
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    

008015c1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015c1:	f3 0f 1e fb          	endbr32 
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015d0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8015d3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8015d9:	8b 52 50             	mov    0x50(%edx),%edx
  8015dc:	39 ca                	cmp    %ecx,%edx
  8015de:	74 11                	je     8015f1 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8015e0:	83 c0 01             	add    $0x1,%eax
  8015e3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8015e8:	75 e6                	jne    8015d0 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8015ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ef:	eb 0b                	jmp    8015fc <ipc_find_env+0x3b>
			return envs[i].env_id;
  8015f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8015f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015f9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8015fc:	5d                   	pop    %ebp
  8015fd:	c3                   	ret    

008015fe <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015fe:	f3 0f 1e fb          	endbr32 
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	05 00 00 00 30       	add    $0x30000000,%eax
  80160d:	c1 e8 0c             	shr    $0xc,%eax
}
  801610:	5d                   	pop    %ebp
  801611:	c3                   	ret    

00801612 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801612:	f3 0f 1e fb          	endbr32 
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801621:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801626:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    

0080162d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80162d:	f3 0f 1e fb          	endbr32 
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801639:	89 c2                	mov    %eax,%edx
  80163b:	c1 ea 16             	shr    $0x16,%edx
  80163e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801645:	f6 c2 01             	test   $0x1,%dl
  801648:	74 2d                	je     801677 <fd_alloc+0x4a>
  80164a:	89 c2                	mov    %eax,%edx
  80164c:	c1 ea 0c             	shr    $0xc,%edx
  80164f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801656:	f6 c2 01             	test   $0x1,%dl
  801659:	74 1c                	je     801677 <fd_alloc+0x4a>
  80165b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801660:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801665:	75 d2                	jne    801639 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801670:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801675:	eb 0a                	jmp    801681 <fd_alloc+0x54>
			*fd_store = fd;
  801677:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80167a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801683:	f3 0f 1e fb          	endbr32 
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80168d:	83 f8 1f             	cmp    $0x1f,%eax
  801690:	77 30                	ja     8016c2 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801692:	c1 e0 0c             	shl    $0xc,%eax
  801695:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80169a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016a0:	f6 c2 01             	test   $0x1,%dl
  8016a3:	74 24                	je     8016c9 <fd_lookup+0x46>
  8016a5:	89 c2                	mov    %eax,%edx
  8016a7:	c1 ea 0c             	shr    $0xc,%edx
  8016aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b1:	f6 c2 01             	test   $0x1,%dl
  8016b4:	74 1a                	je     8016d0 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b9:	89 02                	mov    %eax,(%edx)
	return 0;
  8016bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c0:	5d                   	pop    %ebp
  8016c1:	c3                   	ret    
		return -E_INVAL;
  8016c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c7:	eb f7                	jmp    8016c0 <fd_lookup+0x3d>
		return -E_INVAL;
  8016c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ce:	eb f0                	jmp    8016c0 <fd_lookup+0x3d>
  8016d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d5:	eb e9                	jmp    8016c0 <fd_lookup+0x3d>

008016d7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016d7:	f3 0f 1e fb          	endbr32 
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016ee:	39 08                	cmp    %ecx,(%eax)
  8016f0:	74 38                	je     80172a <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8016f2:	83 c2 01             	add    $0x1,%edx
  8016f5:	8b 04 95 6c 32 80 00 	mov    0x80326c(,%edx,4),%eax
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	75 ee                	jne    8016ee <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801700:	a1 08 50 80 00       	mov    0x805008,%eax
  801705:	8b 40 48             	mov    0x48(%eax),%eax
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	51                   	push   %ecx
  80170c:	50                   	push   %eax
  80170d:	68 f0 31 80 00       	push   $0x8031f0
  801712:	e8 c1 f0 ff ff       	call   8007d8 <cprintf>
	*dev = 0;
  801717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    
			*dev = devtab[i];
  80172a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80172d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80172f:	b8 00 00 00 00       	mov    $0x0,%eax
  801734:	eb f2                	jmp    801728 <dev_lookup+0x51>

00801736 <fd_close>:
{
  801736:	f3 0f 1e fb          	endbr32 
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	57                   	push   %edi
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	83 ec 24             	sub    $0x24,%esp
  801743:	8b 75 08             	mov    0x8(%ebp),%esi
  801746:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801749:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80174c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80174d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801753:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801756:	50                   	push   %eax
  801757:	e8 27 ff ff ff       	call   801683 <fd_lookup>
  80175c:	89 c3                	mov    %eax,%ebx
  80175e:	83 c4 10             	add    $0x10,%esp
  801761:	85 c0                	test   %eax,%eax
  801763:	78 05                	js     80176a <fd_close+0x34>
	    || fd != fd2)
  801765:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801768:	74 16                	je     801780 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80176a:	89 f8                	mov    %edi,%eax
  80176c:	84 c0                	test   %al,%al
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
  801773:	0f 44 d8             	cmove  %eax,%ebx
}
  801776:	89 d8                	mov    %ebx,%eax
  801778:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177b:	5b                   	pop    %ebx
  80177c:	5e                   	pop    %esi
  80177d:	5f                   	pop    %edi
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801780:	83 ec 08             	sub    $0x8,%esp
  801783:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801786:	50                   	push   %eax
  801787:	ff 36                	pushl  (%esi)
  801789:	e8 49 ff ff ff       	call   8016d7 <dev_lookup>
  80178e:	89 c3                	mov    %eax,%ebx
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	85 c0                	test   %eax,%eax
  801795:	78 1a                	js     8017b1 <fd_close+0x7b>
		if (dev->dev_close)
  801797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80179a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80179d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	74 0b                	je     8017b1 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8017a6:	83 ec 0c             	sub    $0xc,%esp
  8017a9:	56                   	push   %esi
  8017aa:	ff d0                	call   *%eax
  8017ac:	89 c3                	mov    %eax,%ebx
  8017ae:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	56                   	push   %esi
  8017b5:	6a 00                	push   $0x0
  8017b7:	e8 f5 fa ff ff       	call   8012b1 <sys_page_unmap>
	return r;
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	eb b5                	jmp    801776 <fd_close+0x40>

008017c1 <close>:

int
close(int fdnum)
{
  8017c1:	f3 0f 1e fb          	endbr32 
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ce:	50                   	push   %eax
  8017cf:	ff 75 08             	pushl  0x8(%ebp)
  8017d2:	e8 ac fe ff ff       	call   801683 <fd_lookup>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	79 02                	jns    8017e0 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    
		return fd_close(fd, 1);
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	6a 01                	push   $0x1
  8017e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e8:	e8 49 ff ff ff       	call   801736 <fd_close>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	eb ec                	jmp    8017de <close+0x1d>

008017f2 <close_all>:

void
close_all(void)
{
  8017f2:	f3 0f 1e fb          	endbr32 
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017fd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801802:	83 ec 0c             	sub    $0xc,%esp
  801805:	53                   	push   %ebx
  801806:	e8 b6 ff ff ff       	call   8017c1 <close>
	for (i = 0; i < MAXFD; i++)
  80180b:	83 c3 01             	add    $0x1,%ebx
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	83 fb 20             	cmp    $0x20,%ebx
  801814:	75 ec                	jne    801802 <close_all+0x10>
}
  801816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80181b:	f3 0f 1e fb          	endbr32 
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	57                   	push   %edi
  801823:	56                   	push   %esi
  801824:	53                   	push   %ebx
  801825:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801828:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80182b:	50                   	push   %eax
  80182c:	ff 75 08             	pushl  0x8(%ebp)
  80182f:	e8 4f fe ff ff       	call   801683 <fd_lookup>
  801834:	89 c3                	mov    %eax,%ebx
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	85 c0                	test   %eax,%eax
  80183b:	0f 88 81 00 00 00    	js     8018c2 <dup+0xa7>
		return r;
	close(newfdnum);
  801841:	83 ec 0c             	sub    $0xc,%esp
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	e8 75 ff ff ff       	call   8017c1 <close>

	newfd = INDEX2FD(newfdnum);
  80184c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80184f:	c1 e6 0c             	shl    $0xc,%esi
  801852:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801858:	83 c4 04             	add    $0x4,%esp
  80185b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80185e:	e8 af fd ff ff       	call   801612 <fd2data>
  801863:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801865:	89 34 24             	mov    %esi,(%esp)
  801868:	e8 a5 fd ff ff       	call   801612 <fd2data>
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801872:	89 d8                	mov    %ebx,%eax
  801874:	c1 e8 16             	shr    $0x16,%eax
  801877:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80187e:	a8 01                	test   $0x1,%al
  801880:	74 11                	je     801893 <dup+0x78>
  801882:	89 d8                	mov    %ebx,%eax
  801884:	c1 e8 0c             	shr    $0xc,%eax
  801887:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80188e:	f6 c2 01             	test   $0x1,%dl
  801891:	75 39                	jne    8018cc <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801893:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801896:	89 d0                	mov    %edx,%eax
  801898:	c1 e8 0c             	shr    $0xc,%eax
  80189b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	25 07 0e 00 00       	and    $0xe07,%eax
  8018aa:	50                   	push   %eax
  8018ab:	56                   	push   %esi
  8018ac:	6a 00                	push   $0x0
  8018ae:	52                   	push   %edx
  8018af:	6a 00                	push   $0x0
  8018b1:	e8 b5 f9 ff ff       	call   80126b <sys_page_map>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	83 c4 20             	add    $0x20,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 31                	js     8018f0 <dup+0xd5>
		goto err;

	return newfdnum;
  8018bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018c2:	89 d8                	mov    %ebx,%eax
  8018c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5f                   	pop    %edi
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	25 07 0e 00 00       	and    $0xe07,%eax
  8018db:	50                   	push   %eax
  8018dc:	57                   	push   %edi
  8018dd:	6a 00                	push   $0x0
  8018df:	53                   	push   %ebx
  8018e0:	6a 00                	push   $0x0
  8018e2:	e8 84 f9 ff ff       	call   80126b <sys_page_map>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 20             	add    $0x20,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	79 a3                	jns    801893 <dup+0x78>
	sys_page_unmap(0, newfd);
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	56                   	push   %esi
  8018f4:	6a 00                	push   $0x0
  8018f6:	e8 b6 f9 ff ff       	call   8012b1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018fb:	83 c4 08             	add    $0x8,%esp
  8018fe:	57                   	push   %edi
  8018ff:	6a 00                	push   $0x0
  801901:	e8 ab f9 ff ff       	call   8012b1 <sys_page_unmap>
	return r;
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	eb b7                	jmp    8018c2 <dup+0xa7>

0080190b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80190b:	f3 0f 1e fb          	endbr32 
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	53                   	push   %ebx
  801913:	83 ec 1c             	sub    $0x1c,%esp
  801916:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801919:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80191c:	50                   	push   %eax
  80191d:	53                   	push   %ebx
  80191e:	e8 60 fd ff ff       	call   801683 <fd_lookup>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	78 3f                	js     801969 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80192a:	83 ec 08             	sub    $0x8,%esp
  80192d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801930:	50                   	push   %eax
  801931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801934:	ff 30                	pushl  (%eax)
  801936:	e8 9c fd ff ff       	call   8016d7 <dev_lookup>
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 27                	js     801969 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801942:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801945:	8b 42 08             	mov    0x8(%edx),%eax
  801948:	83 e0 03             	and    $0x3,%eax
  80194b:	83 f8 01             	cmp    $0x1,%eax
  80194e:	74 1e                	je     80196e <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801953:	8b 40 08             	mov    0x8(%eax),%eax
  801956:	85 c0                	test   %eax,%eax
  801958:	74 35                	je     80198f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	ff 75 10             	pushl  0x10(%ebp)
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	52                   	push   %edx
  801964:	ff d0                	call   *%eax
  801966:	83 c4 10             	add    $0x10,%esp
}
  801969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80196e:	a1 08 50 80 00       	mov    0x805008,%eax
  801973:	8b 40 48             	mov    0x48(%eax),%eax
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	53                   	push   %ebx
  80197a:	50                   	push   %eax
  80197b:	68 31 32 80 00       	push   $0x803231
  801980:	e8 53 ee ff ff       	call   8007d8 <cprintf>
		return -E_INVAL;
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198d:	eb da                	jmp    801969 <read+0x5e>
		return -E_NOT_SUPP;
  80198f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801994:	eb d3                	jmp    801969 <read+0x5e>

00801996 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801996:	f3 0f 1e fb          	endbr32 
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	57                   	push   %edi
  80199e:	56                   	push   %esi
  80199f:	53                   	push   %ebx
  8019a0:	83 ec 0c             	sub    $0xc,%esp
  8019a3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019ae:	eb 02                	jmp    8019b2 <readn+0x1c>
  8019b0:	01 c3                	add    %eax,%ebx
  8019b2:	39 f3                	cmp    %esi,%ebx
  8019b4:	73 21                	jae    8019d7 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019b6:	83 ec 04             	sub    $0x4,%esp
  8019b9:	89 f0                	mov    %esi,%eax
  8019bb:	29 d8                	sub    %ebx,%eax
  8019bd:	50                   	push   %eax
  8019be:	89 d8                	mov    %ebx,%eax
  8019c0:	03 45 0c             	add    0xc(%ebp),%eax
  8019c3:	50                   	push   %eax
  8019c4:	57                   	push   %edi
  8019c5:	e8 41 ff ff ff       	call   80190b <read>
		if (m < 0)
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	78 04                	js     8019d5 <readn+0x3f>
			return m;
		if (m == 0)
  8019d1:	75 dd                	jne    8019b0 <readn+0x1a>
  8019d3:	eb 02                	jmp    8019d7 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019d5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019d7:	89 d8                	mov    %ebx,%eax
  8019d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019dc:	5b                   	pop    %ebx
  8019dd:	5e                   	pop    %esi
  8019de:	5f                   	pop    %edi
  8019df:	5d                   	pop    %ebp
  8019e0:	c3                   	ret    

008019e1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019e1:	f3 0f 1e fb          	endbr32 
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	53                   	push   %ebx
  8019e9:	83 ec 1c             	sub    $0x1c,%esp
  8019ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f2:	50                   	push   %eax
  8019f3:	53                   	push   %ebx
  8019f4:	e8 8a fc ff ff       	call   801683 <fd_lookup>
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 3a                	js     801a3a <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a00:	83 ec 08             	sub    $0x8,%esp
  801a03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a06:	50                   	push   %eax
  801a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0a:	ff 30                	pushl  (%eax)
  801a0c:	e8 c6 fc ff ff       	call   8016d7 <dev_lookup>
  801a11:	83 c4 10             	add    $0x10,%esp
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 22                	js     801a3a <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a1f:	74 1e                	je     801a3f <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a24:	8b 52 0c             	mov    0xc(%edx),%edx
  801a27:	85 d2                	test   %edx,%edx
  801a29:	74 35                	je     801a60 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	ff 75 10             	pushl  0x10(%ebp)
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	50                   	push   %eax
  801a35:	ff d2                	call   *%edx
  801a37:	83 c4 10             	add    $0x10,%esp
}
  801a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a3f:	a1 08 50 80 00       	mov    0x805008,%eax
  801a44:	8b 40 48             	mov    0x48(%eax),%eax
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	53                   	push   %ebx
  801a4b:	50                   	push   %eax
  801a4c:	68 4d 32 80 00       	push   $0x80324d
  801a51:	e8 82 ed ff ff       	call   8007d8 <cprintf>
		return -E_INVAL;
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5e:	eb da                	jmp    801a3a <write+0x59>
		return -E_NOT_SUPP;
  801a60:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a65:	eb d3                	jmp    801a3a <write+0x59>

00801a67 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a67:	f3 0f 1e fb          	endbr32 
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a74:	50                   	push   %eax
  801a75:	ff 75 08             	pushl  0x8(%ebp)
  801a78:	e8 06 fc ff ff       	call   801683 <fd_lookup>
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 0e                	js     801a92 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a94:	f3 0f 1e fb          	endbr32 
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	53                   	push   %ebx
  801a9c:	83 ec 1c             	sub    $0x1c,%esp
  801a9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa5:	50                   	push   %eax
  801aa6:	53                   	push   %ebx
  801aa7:	e8 d7 fb ff ff       	call   801683 <fd_lookup>
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 37                	js     801aea <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab3:	83 ec 08             	sub    $0x8,%esp
  801ab6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab9:	50                   	push   %eax
  801aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abd:	ff 30                	pushl  (%eax)
  801abf:	e8 13 fc ff ff       	call   8016d7 <dev_lookup>
  801ac4:	83 c4 10             	add    $0x10,%esp
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	78 1f                	js     801aea <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ace:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ad2:	74 1b                	je     801aef <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad7:	8b 52 18             	mov    0x18(%edx),%edx
  801ada:	85 d2                	test   %edx,%edx
  801adc:	74 32                	je     801b10 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ade:	83 ec 08             	sub    $0x8,%esp
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	50                   	push   %eax
  801ae5:	ff d2                	call   *%edx
  801ae7:	83 c4 10             	add    $0x10,%esp
}
  801aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    
			thisenv->env_id, fdnum);
  801aef:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801af4:	8b 40 48             	mov    0x48(%eax),%eax
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	53                   	push   %ebx
  801afb:	50                   	push   %eax
  801afc:	68 10 32 80 00       	push   $0x803210
  801b01:	e8 d2 ec ff ff       	call   8007d8 <cprintf>
		return -E_INVAL;
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b0e:	eb da                	jmp    801aea <ftruncate+0x56>
		return -E_NOT_SUPP;
  801b10:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b15:	eb d3                	jmp    801aea <ftruncate+0x56>

00801b17 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b17:	f3 0f 1e fb          	endbr32 
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	53                   	push   %ebx
  801b1f:	83 ec 1c             	sub    $0x1c,%esp
  801b22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b25:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b28:	50                   	push   %eax
  801b29:	ff 75 08             	pushl  0x8(%ebp)
  801b2c:	e8 52 fb ff ff       	call   801683 <fd_lookup>
  801b31:	83 c4 10             	add    $0x10,%esp
  801b34:	85 c0                	test   %eax,%eax
  801b36:	78 4b                	js     801b83 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b38:	83 ec 08             	sub    $0x8,%esp
  801b3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3e:	50                   	push   %eax
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	ff 30                	pushl  (%eax)
  801b44:	e8 8e fb ff ff       	call   8016d7 <dev_lookup>
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	78 33                	js     801b83 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b53:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b57:	74 2f                	je     801b88 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b59:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b5c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b63:	00 00 00 
	stat->st_isdir = 0;
  801b66:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b6d:	00 00 00 
	stat->st_dev = dev;
  801b70:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b76:	83 ec 08             	sub    $0x8,%esp
  801b79:	53                   	push   %ebx
  801b7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801b7d:	ff 50 14             	call   *0x14(%eax)
  801b80:	83 c4 10             	add    $0x10,%esp
}
  801b83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    
		return -E_NOT_SUPP;
  801b88:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b8d:	eb f4                	jmp    801b83 <fstat+0x6c>

00801b8f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b8f:	f3 0f 1e fb          	endbr32 
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	e8 fb 01 00 00       	call   801da0 <open>
  801ba5:	89 c3                	mov    %eax,%ebx
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 1b                	js     801bc9 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801bae:	83 ec 08             	sub    $0x8,%esp
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	50                   	push   %eax
  801bb5:	e8 5d ff ff ff       	call   801b17 <fstat>
  801bba:	89 c6                	mov    %eax,%esi
	close(fd);
  801bbc:	89 1c 24             	mov    %ebx,(%esp)
  801bbf:	e8 fd fb ff ff       	call   8017c1 <close>
	return r;
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	89 f3                	mov    %esi,%ebx
}
  801bc9:	89 d8                	mov    %ebx,%eax
  801bcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bce:	5b                   	pop    %ebx
  801bcf:	5e                   	pop    %esi
  801bd0:	5d                   	pop    %ebp
  801bd1:	c3                   	ret    

00801bd2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	56                   	push   %esi
  801bd6:	53                   	push   %ebx
  801bd7:	89 c6                	mov    %eax,%esi
  801bd9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bdb:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801be2:	74 27                	je     801c0b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801be4:	6a 07                	push   $0x7
  801be6:	68 00 60 80 00       	push   $0x806000
  801beb:	56                   	push   %esi
  801bec:	ff 35 00 50 80 00    	pushl  0x805000
  801bf2:	e8 72 f9 ff ff       	call   801569 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bf7:	83 c4 0c             	add    $0xc,%esp
  801bfa:	6a 00                	push   $0x0
  801bfc:	53                   	push   %ebx
  801bfd:	6a 00                	push   $0x0
  801bff:	e8 e0 f8 ff ff       	call   8014e4 <ipc_recv>
}
  801c04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5d                   	pop    %ebp
  801c0a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c0b:	83 ec 0c             	sub    $0xc,%esp
  801c0e:	6a 01                	push   $0x1
  801c10:	e8 ac f9 ff ff       	call   8015c1 <ipc_find_env>
  801c15:	a3 00 50 80 00       	mov    %eax,0x805000
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	eb c5                	jmp    801be4 <fsipc+0x12>

00801c1f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c1f:	f3 0f 1e fb          	endbr32 
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c37:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c41:	b8 02 00 00 00       	mov    $0x2,%eax
  801c46:	e8 87 ff ff ff       	call   801bd2 <fsipc>
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <devfile_flush>:
{
  801c4d:	f3 0f 1e fb          	endbr32 
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c5d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c62:	ba 00 00 00 00       	mov    $0x0,%edx
  801c67:	b8 06 00 00 00       	mov    $0x6,%eax
  801c6c:	e8 61 ff ff ff       	call   801bd2 <fsipc>
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <devfile_stat>:
{
  801c73:	f3 0f 1e fb          	endbr32 
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	53                   	push   %ebx
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	8b 40 0c             	mov    0xc(%eax),%eax
  801c87:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c91:	b8 05 00 00 00       	mov    $0x5,%eax
  801c96:	e8 37 ff ff ff       	call   801bd2 <fsipc>
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	78 2c                	js     801ccb <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	68 00 60 80 00       	push   $0x806000
  801ca7:	53                   	push   %ebx
  801ca8:	e8 35 f1 ff ff       	call   800de2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cad:	a1 80 60 80 00       	mov    0x806080,%eax
  801cb2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cb8:	a1 84 60 80 00       	mov    0x806084,%eax
  801cbd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cc3:	83 c4 10             	add    $0x10,%esp
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <devfile_write>:
{
  801cd0:	f3 0f 1e fb          	endbr32 
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce0:	8b 52 0c             	mov    0xc(%edx),%edx
  801ce3:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801ce9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801cee:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801cf3:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801cf6:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801cfb:	50                   	push   %eax
  801cfc:	ff 75 0c             	pushl  0xc(%ebp)
  801cff:	68 08 60 80 00       	push   $0x806008
  801d04:	e8 8f f2 ff ff       	call   800f98 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801d09:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d13:	e8 ba fe ff ff       	call   801bd2 <fsipc>
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <devfile_read>:
{
  801d1a:	f3 0f 1e fb          	endbr32 
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	56                   	push   %esi
  801d22:	53                   	push   %ebx
  801d23:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d31:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d37:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3c:	b8 03 00 00 00       	mov    $0x3,%eax
  801d41:	e8 8c fe ff ff       	call   801bd2 <fsipc>
  801d46:	89 c3                	mov    %eax,%ebx
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 1f                	js     801d6b <devfile_read+0x51>
	assert(r <= n);
  801d4c:	39 f0                	cmp    %esi,%eax
  801d4e:	77 24                	ja     801d74 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801d50:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d55:	7f 33                	jg     801d8a <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	50                   	push   %eax
  801d5b:	68 00 60 80 00       	push   $0x806000
  801d60:	ff 75 0c             	pushl  0xc(%ebp)
  801d63:	e8 30 f2 ff ff       	call   800f98 <memmove>
	return r;
  801d68:	83 c4 10             	add    $0x10,%esp
}
  801d6b:	89 d8                	mov    %ebx,%eax
  801d6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    
	assert(r <= n);
  801d74:	68 80 32 80 00       	push   $0x803280
  801d79:	68 87 32 80 00       	push   $0x803287
  801d7e:	6a 7c                	push   $0x7c
  801d80:	68 9c 32 80 00       	push   $0x80329c
  801d85:	e8 67 e9 ff ff       	call   8006f1 <_panic>
	assert(r <= PGSIZE);
  801d8a:	68 a7 32 80 00       	push   $0x8032a7
  801d8f:	68 87 32 80 00       	push   $0x803287
  801d94:	6a 7d                	push   $0x7d
  801d96:	68 9c 32 80 00       	push   $0x80329c
  801d9b:	e8 51 e9 ff ff       	call   8006f1 <_panic>

00801da0 <open>:
{
  801da0:	f3 0f 1e fb          	endbr32 
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	56                   	push   %esi
  801da8:	53                   	push   %ebx
  801da9:	83 ec 1c             	sub    $0x1c,%esp
  801dac:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801daf:	56                   	push   %esi
  801db0:	e8 ea ef ff ff       	call   800d9f <strlen>
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dbd:	7f 6c                	jg     801e2b <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc5:	50                   	push   %eax
  801dc6:	e8 62 f8 ff ff       	call   80162d <fd_alloc>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	78 3c                	js     801e10 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801dd4:	83 ec 08             	sub    $0x8,%esp
  801dd7:	56                   	push   %esi
  801dd8:	68 00 60 80 00       	push   $0x806000
  801ddd:	e8 00 f0 ff ff       	call   800de2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ded:	b8 01 00 00 00       	mov    $0x1,%eax
  801df2:	e8 db fd ff ff       	call   801bd2 <fsipc>
  801df7:	89 c3                	mov    %eax,%ebx
  801df9:	83 c4 10             	add    $0x10,%esp
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	78 19                	js     801e19 <open+0x79>
	return fd2num(fd);
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	ff 75 f4             	pushl  -0xc(%ebp)
  801e06:	e8 f3 f7 ff ff       	call   8015fe <fd2num>
  801e0b:	89 c3                	mov    %eax,%ebx
  801e0d:	83 c4 10             	add    $0x10,%esp
}
  801e10:	89 d8                	mov    %ebx,%eax
  801e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    
		fd_close(fd, 0);
  801e19:	83 ec 08             	sub    $0x8,%esp
  801e1c:	6a 00                	push   $0x0
  801e1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e21:	e8 10 f9 ff ff       	call   801736 <fd_close>
		return r;
  801e26:	83 c4 10             	add    $0x10,%esp
  801e29:	eb e5                	jmp    801e10 <open+0x70>
		return -E_BAD_PATH;
  801e2b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e30:	eb de                	jmp    801e10 <open+0x70>

00801e32 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e32:	f3 0f 1e fb          	endbr32 
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e41:	b8 08 00 00 00       	mov    $0x8,%eax
  801e46:	e8 87 fd ff ff       	call   801bd2 <fsipc>
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e4d:	f3 0f 1e fb          	endbr32 
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e57:	68 b3 32 80 00       	push   $0x8032b3
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	e8 7e ef ff ff       	call   800de2 <strcpy>
	return 0;
}
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <devsock_close>:
{
  801e6b:	f3 0f 1e fb          	endbr32 
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	53                   	push   %ebx
  801e73:	83 ec 10             	sub    $0x10,%esp
  801e76:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e79:	53                   	push   %ebx
  801e7a:	e8 81 09 00 00       	call   802800 <pageref>
  801e7f:	89 c2                	mov    %eax,%edx
  801e81:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e84:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801e89:	83 fa 01             	cmp    $0x1,%edx
  801e8c:	74 05                	je     801e93 <devsock_close+0x28>
}
  801e8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	ff 73 0c             	pushl  0xc(%ebx)
  801e99:	e8 e3 02 00 00       	call   802181 <nsipc_close>
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	eb eb                	jmp    801e8e <devsock_close+0x23>

00801ea3 <devsock_write>:
{
  801ea3:	f3 0f 1e fb          	endbr32 
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	ff 75 10             	pushl  0x10(%ebp)
  801eb2:	ff 75 0c             	pushl  0xc(%ebp)
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	ff 70 0c             	pushl  0xc(%eax)
  801ebb:	e8 b5 03 00 00       	call   802275 <nsipc_send>
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <devsock_read>:
{
  801ec2:	f3 0f 1e fb          	endbr32 
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	ff 75 10             	pushl  0x10(%ebp)
  801ed1:	ff 75 0c             	pushl  0xc(%ebp)
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	ff 70 0c             	pushl  0xc(%eax)
  801eda:	e8 1f 03 00 00       	call   8021fe <nsipc_recv>
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <fd2sockid>:
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ee7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801eea:	52                   	push   %edx
  801eeb:	50                   	push   %eax
  801eec:	e8 92 f7 ff ff       	call   801683 <fd_lookup>
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	78 10                	js     801f08 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801f01:	39 08                	cmp    %ecx,(%eax)
  801f03:	75 05                	jne    801f0a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f05:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    
		return -E_NOT_SUPP;
  801f0a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f0f:	eb f7                	jmp    801f08 <fd2sockid+0x27>

00801f11 <alloc_sockfd>:
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	56                   	push   %esi
  801f15:	53                   	push   %ebx
  801f16:	83 ec 1c             	sub    $0x1c,%esp
  801f19:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1e:	50                   	push   %eax
  801f1f:	e8 09 f7 ff ff       	call   80162d <fd_alloc>
  801f24:	89 c3                	mov    %eax,%ebx
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	78 43                	js     801f70 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	68 07 04 00 00       	push   $0x407
  801f35:	ff 75 f4             	pushl  -0xc(%ebp)
  801f38:	6a 00                	push   $0x0
  801f3a:	e8 e5 f2 ff ff       	call   801224 <sys_page_alloc>
  801f3f:	89 c3                	mov    %eax,%ebx
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 28                	js     801f70 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801f51:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f56:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f5d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f60:	83 ec 0c             	sub    $0xc,%esp
  801f63:	50                   	push   %eax
  801f64:	e8 95 f6 ff ff       	call   8015fe <fd2num>
  801f69:	89 c3                	mov    %eax,%ebx
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	eb 0c                	jmp    801f7c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	56                   	push   %esi
  801f74:	e8 08 02 00 00       	call   802181 <nsipc_close>
		return r;
  801f79:	83 c4 10             	add    $0x10,%esp
}
  801f7c:	89 d8                	mov    %ebx,%eax
  801f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    

00801f85 <accept>:
{
  801f85:	f3 0f 1e fb          	endbr32 
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	e8 4a ff ff ff       	call   801ee1 <fd2sockid>
  801f97:	85 c0                	test   %eax,%eax
  801f99:	78 1b                	js     801fb6 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f9b:	83 ec 04             	sub    $0x4,%esp
  801f9e:	ff 75 10             	pushl  0x10(%ebp)
  801fa1:	ff 75 0c             	pushl  0xc(%ebp)
  801fa4:	50                   	push   %eax
  801fa5:	e8 22 01 00 00       	call   8020cc <nsipc_accept>
  801faa:	83 c4 10             	add    $0x10,%esp
  801fad:	85 c0                	test   %eax,%eax
  801faf:	78 05                	js     801fb6 <accept+0x31>
	return alloc_sockfd(r);
  801fb1:	e8 5b ff ff ff       	call   801f11 <alloc_sockfd>
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <bind>:
{
  801fb8:	f3 0f 1e fb          	endbr32 
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	e8 17 ff ff ff       	call   801ee1 <fd2sockid>
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	78 12                	js     801fe0 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801fce:	83 ec 04             	sub    $0x4,%esp
  801fd1:	ff 75 10             	pushl  0x10(%ebp)
  801fd4:	ff 75 0c             	pushl  0xc(%ebp)
  801fd7:	50                   	push   %eax
  801fd8:	e8 45 01 00 00       	call   802122 <nsipc_bind>
  801fdd:	83 c4 10             	add    $0x10,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <shutdown>:
{
  801fe2:	f3 0f 1e fb          	endbr32 
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	e8 ed fe ff ff       	call   801ee1 <fd2sockid>
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	78 0f                	js     802007 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801ff8:	83 ec 08             	sub    $0x8,%esp
  801ffb:	ff 75 0c             	pushl  0xc(%ebp)
  801ffe:	50                   	push   %eax
  801fff:	e8 57 01 00 00       	call   80215b <nsipc_shutdown>
  802004:	83 c4 10             	add    $0x10,%esp
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <connect>:
{
  802009:	f3 0f 1e fb          	endbr32 
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	e8 c6 fe ff ff       	call   801ee1 <fd2sockid>
  80201b:	85 c0                	test   %eax,%eax
  80201d:	78 12                	js     802031 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	ff 75 10             	pushl  0x10(%ebp)
  802025:	ff 75 0c             	pushl  0xc(%ebp)
  802028:	50                   	push   %eax
  802029:	e8 71 01 00 00       	call   80219f <nsipc_connect>
  80202e:	83 c4 10             	add    $0x10,%esp
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <listen>:
{
  802033:	f3 0f 1e fb          	endbr32 
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	e8 9c fe ff ff       	call   801ee1 <fd2sockid>
  802045:	85 c0                	test   %eax,%eax
  802047:	78 0f                	js     802058 <listen+0x25>
	return nsipc_listen(r, backlog);
  802049:	83 ec 08             	sub    $0x8,%esp
  80204c:	ff 75 0c             	pushl  0xc(%ebp)
  80204f:	50                   	push   %eax
  802050:	e8 83 01 00 00       	call   8021d8 <nsipc_listen>
  802055:	83 c4 10             	add    $0x10,%esp
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <socket>:

int
socket(int domain, int type, int protocol)
{
  80205a:	f3 0f 1e fb          	endbr32 
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802064:	ff 75 10             	pushl  0x10(%ebp)
  802067:	ff 75 0c             	pushl  0xc(%ebp)
  80206a:	ff 75 08             	pushl  0x8(%ebp)
  80206d:	e8 65 02 00 00       	call   8022d7 <nsipc_socket>
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	85 c0                	test   %eax,%eax
  802077:	78 05                	js     80207e <socket+0x24>
		return r;
	return alloc_sockfd(r);
  802079:	e8 93 fe ff ff       	call   801f11 <alloc_sockfd>
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	53                   	push   %ebx
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802089:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802090:	74 26                	je     8020b8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802092:	6a 07                	push   $0x7
  802094:	68 00 70 80 00       	push   $0x807000
  802099:	53                   	push   %ebx
  80209a:	ff 35 04 50 80 00    	pushl  0x805004
  8020a0:	e8 c4 f4 ff ff       	call   801569 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020a5:	83 c4 0c             	add    $0xc,%esp
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	e8 31 f4 ff ff       	call   8014e4 <ipc_recv>
}
  8020b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020b8:	83 ec 0c             	sub    $0xc,%esp
  8020bb:	6a 02                	push   $0x2
  8020bd:	e8 ff f4 ff ff       	call   8015c1 <ipc_find_env>
  8020c2:	a3 04 50 80 00       	mov    %eax,0x805004
  8020c7:	83 c4 10             	add    $0x10,%esp
  8020ca:	eb c6                	jmp    802092 <nsipc+0x12>

008020cc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020cc:	f3 0f 1e fb          	endbr32 
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	56                   	push   %esi
  8020d4:	53                   	push   %ebx
  8020d5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020e0:	8b 06                	mov    (%esi),%eax
  8020e2:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ec:	e8 8f ff ff ff       	call   802080 <nsipc>
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	79 09                	jns    802100 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020f7:	89 d8                	mov    %ebx,%eax
  8020f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fc:	5b                   	pop    %ebx
  8020fd:	5e                   	pop    %esi
  8020fe:	5d                   	pop    %ebp
  8020ff:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802100:	83 ec 04             	sub    $0x4,%esp
  802103:	ff 35 10 70 80 00    	pushl  0x807010
  802109:	68 00 70 80 00       	push   $0x807000
  80210e:	ff 75 0c             	pushl  0xc(%ebp)
  802111:	e8 82 ee ff ff       	call   800f98 <memmove>
		*addrlen = ret->ret_addrlen;
  802116:	a1 10 70 80 00       	mov    0x807010,%eax
  80211b:	89 06                	mov    %eax,(%esi)
  80211d:	83 c4 10             	add    $0x10,%esp
	return r;
  802120:	eb d5                	jmp    8020f7 <nsipc_accept+0x2b>

00802122 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802122:	f3 0f 1e fb          	endbr32 
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	53                   	push   %ebx
  80212a:	83 ec 08             	sub    $0x8,%esp
  80212d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802138:	53                   	push   %ebx
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	68 04 70 80 00       	push   $0x807004
  802141:	e8 52 ee ff ff       	call   800f98 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802146:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80214c:	b8 02 00 00 00       	mov    $0x2,%eax
  802151:	e8 2a ff ff ff       	call   802080 <nsipc>
}
  802156:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80215b:	f3 0f 1e fb          	endbr32 
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80216d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802170:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802175:	b8 03 00 00 00       	mov    $0x3,%eax
  80217a:	e8 01 ff ff ff       	call   802080 <nsipc>
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <nsipc_close>:

int
nsipc_close(int s)
{
  802181:	f3 0f 1e fb          	endbr32 
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802193:	b8 04 00 00 00       	mov    $0x4,%eax
  802198:	e8 e3 fe ff ff       	call   802080 <nsipc>
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80219f:	f3 0f 1e fb          	endbr32 
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	53                   	push   %ebx
  8021a7:	83 ec 08             	sub    $0x8,%esp
  8021aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021b5:	53                   	push   %ebx
  8021b6:	ff 75 0c             	pushl  0xc(%ebp)
  8021b9:	68 04 70 80 00       	push   $0x807004
  8021be:	e8 d5 ed ff ff       	call   800f98 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021c3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021ce:	e8 ad fe ff ff       	call   802080 <nsipc>
}
  8021d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021d8:	f3 0f 1e fb          	endbr32 
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ed:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021f2:	b8 06 00 00 00       	mov    $0x6,%eax
  8021f7:	e8 84 fe ff ff       	call   802080 <nsipc>
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021fe:	f3 0f 1e fb          	endbr32 
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	56                   	push   %esi
  802206:	53                   	push   %ebx
  802207:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802212:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802218:	8b 45 14             	mov    0x14(%ebp),%eax
  80221b:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802220:	b8 07 00 00 00       	mov    $0x7,%eax
  802225:	e8 56 fe ff ff       	call   802080 <nsipc>
  80222a:	89 c3                	mov    %eax,%ebx
  80222c:	85 c0                	test   %eax,%eax
  80222e:	78 26                	js     802256 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802230:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802236:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80223b:	0f 4e c6             	cmovle %esi,%eax
  80223e:	39 c3                	cmp    %eax,%ebx
  802240:	7f 1d                	jg     80225f <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802242:	83 ec 04             	sub    $0x4,%esp
  802245:	53                   	push   %ebx
  802246:	68 00 70 80 00       	push   $0x807000
  80224b:	ff 75 0c             	pushl  0xc(%ebp)
  80224e:	e8 45 ed ff ff       	call   800f98 <memmove>
  802253:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802256:	89 d8                	mov    %ebx,%eax
  802258:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5e                   	pop    %esi
  80225d:	5d                   	pop    %ebp
  80225e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80225f:	68 bf 32 80 00       	push   $0x8032bf
  802264:	68 87 32 80 00       	push   $0x803287
  802269:	6a 62                	push   $0x62
  80226b:	68 d4 32 80 00       	push   $0x8032d4
  802270:	e8 7c e4 ff ff       	call   8006f1 <_panic>

00802275 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802275:	f3 0f 1e fb          	endbr32 
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	53                   	push   %ebx
  80227d:	83 ec 04             	sub    $0x4,%esp
  802280:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80228b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802291:	7f 2e                	jg     8022c1 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	53                   	push   %ebx
  802297:	ff 75 0c             	pushl  0xc(%ebp)
  80229a:	68 0c 70 80 00       	push   $0x80700c
  80229f:	e8 f4 ec ff ff       	call   800f98 <memmove>
	nsipcbuf.send.req_size = size;
  8022a4:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ad:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8022b7:	e8 c4 fd ff ff       	call   802080 <nsipc>
}
  8022bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    
	assert(size < 1600);
  8022c1:	68 e0 32 80 00       	push   $0x8032e0
  8022c6:	68 87 32 80 00       	push   $0x803287
  8022cb:	6a 6d                	push   $0x6d
  8022cd:	68 d4 32 80 00       	push   $0x8032d4
  8022d2:	e8 1a e4 ff ff       	call   8006f1 <_panic>

008022d7 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022d7:	f3 0f 1e fb          	endbr32 
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ec:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022f9:	b8 09 00 00 00       	mov    $0x9,%eax
  8022fe:	e8 7d fd ff ff       	call   802080 <nsipc>
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802305:	f3 0f 1e fb          	endbr32 
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	56                   	push   %esi
  80230d:	53                   	push   %ebx
  80230e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802311:	83 ec 0c             	sub    $0xc,%esp
  802314:	ff 75 08             	pushl  0x8(%ebp)
  802317:	e8 f6 f2 ff ff       	call   801612 <fd2data>
  80231c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80231e:	83 c4 08             	add    $0x8,%esp
  802321:	68 ec 32 80 00       	push   $0x8032ec
  802326:	53                   	push   %ebx
  802327:	e8 b6 ea ff ff       	call   800de2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80232c:	8b 46 04             	mov    0x4(%esi),%eax
  80232f:	2b 06                	sub    (%esi),%eax
  802331:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802337:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80233e:	00 00 00 
	stat->st_dev = &devpipe;
  802341:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  802348:	40 80 00 
	return 0;
}
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
  802350:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802353:	5b                   	pop    %ebx
  802354:	5e                   	pop    %esi
  802355:	5d                   	pop    %ebp
  802356:	c3                   	ret    

00802357 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802357:	f3 0f 1e fb          	endbr32 
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	53                   	push   %ebx
  80235f:	83 ec 0c             	sub    $0xc,%esp
  802362:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802365:	53                   	push   %ebx
  802366:	6a 00                	push   $0x0
  802368:	e8 44 ef ff ff       	call   8012b1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80236d:	89 1c 24             	mov    %ebx,(%esp)
  802370:	e8 9d f2 ff ff       	call   801612 <fd2data>
  802375:	83 c4 08             	add    $0x8,%esp
  802378:	50                   	push   %eax
  802379:	6a 00                	push   $0x0
  80237b:	e8 31 ef ff ff       	call   8012b1 <sys_page_unmap>
}
  802380:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <_pipeisclosed>:
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	57                   	push   %edi
  802389:	56                   	push   %esi
  80238a:	53                   	push   %ebx
  80238b:	83 ec 1c             	sub    $0x1c,%esp
  80238e:	89 c7                	mov    %eax,%edi
  802390:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802392:	a1 08 50 80 00       	mov    0x805008,%eax
  802397:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80239a:	83 ec 0c             	sub    $0xc,%esp
  80239d:	57                   	push   %edi
  80239e:	e8 5d 04 00 00       	call   802800 <pageref>
  8023a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023a6:	89 34 24             	mov    %esi,(%esp)
  8023a9:	e8 52 04 00 00       	call   802800 <pageref>
		nn = thisenv->env_runs;
  8023ae:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023b4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023b7:	83 c4 10             	add    $0x10,%esp
  8023ba:	39 cb                	cmp    %ecx,%ebx
  8023bc:	74 1b                	je     8023d9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023be:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023c1:	75 cf                	jne    802392 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023c3:	8b 42 58             	mov    0x58(%edx),%eax
  8023c6:	6a 01                	push   $0x1
  8023c8:	50                   	push   %eax
  8023c9:	53                   	push   %ebx
  8023ca:	68 f3 32 80 00       	push   $0x8032f3
  8023cf:	e8 04 e4 ff ff       	call   8007d8 <cprintf>
  8023d4:	83 c4 10             	add    $0x10,%esp
  8023d7:	eb b9                	jmp    802392 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023d9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023dc:	0f 94 c0             	sete   %al
  8023df:	0f b6 c0             	movzbl %al,%eax
}
  8023e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023e5:	5b                   	pop    %ebx
  8023e6:	5e                   	pop    %esi
  8023e7:	5f                   	pop    %edi
  8023e8:	5d                   	pop    %ebp
  8023e9:	c3                   	ret    

008023ea <devpipe_write>:
{
  8023ea:	f3 0f 1e fb          	endbr32 
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	57                   	push   %edi
  8023f2:	56                   	push   %esi
  8023f3:	53                   	push   %ebx
  8023f4:	83 ec 28             	sub    $0x28,%esp
  8023f7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023fa:	56                   	push   %esi
  8023fb:	e8 12 f2 ff ff       	call   801612 <fd2data>
  802400:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802402:	83 c4 10             	add    $0x10,%esp
  802405:	bf 00 00 00 00       	mov    $0x0,%edi
  80240a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80240d:	74 4f                	je     80245e <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80240f:	8b 43 04             	mov    0x4(%ebx),%eax
  802412:	8b 0b                	mov    (%ebx),%ecx
  802414:	8d 51 20             	lea    0x20(%ecx),%edx
  802417:	39 d0                	cmp    %edx,%eax
  802419:	72 14                	jb     80242f <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80241b:	89 da                	mov    %ebx,%edx
  80241d:	89 f0                	mov    %esi,%eax
  80241f:	e8 61 ff ff ff       	call   802385 <_pipeisclosed>
  802424:	85 c0                	test   %eax,%eax
  802426:	75 3b                	jne    802463 <devpipe_write+0x79>
			sys_yield();
  802428:	e8 d4 ed ff ff       	call   801201 <sys_yield>
  80242d:	eb e0                	jmp    80240f <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80242f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802432:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802436:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802439:	89 c2                	mov    %eax,%edx
  80243b:	c1 fa 1f             	sar    $0x1f,%edx
  80243e:	89 d1                	mov    %edx,%ecx
  802440:	c1 e9 1b             	shr    $0x1b,%ecx
  802443:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802446:	83 e2 1f             	and    $0x1f,%edx
  802449:	29 ca                	sub    %ecx,%edx
  80244b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80244f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802453:	83 c0 01             	add    $0x1,%eax
  802456:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802459:	83 c7 01             	add    $0x1,%edi
  80245c:	eb ac                	jmp    80240a <devpipe_write+0x20>
	return i;
  80245e:	8b 45 10             	mov    0x10(%ebp),%eax
  802461:	eb 05                	jmp    802468 <devpipe_write+0x7e>
				return 0;
  802463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802468:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    

00802470 <devpipe_read>:
{
  802470:	f3 0f 1e fb          	endbr32 
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	57                   	push   %edi
  802478:	56                   	push   %esi
  802479:	53                   	push   %ebx
  80247a:	83 ec 18             	sub    $0x18,%esp
  80247d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802480:	57                   	push   %edi
  802481:	e8 8c f1 ff ff       	call   801612 <fd2data>
  802486:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802488:	83 c4 10             	add    $0x10,%esp
  80248b:	be 00 00 00 00       	mov    $0x0,%esi
  802490:	3b 75 10             	cmp    0x10(%ebp),%esi
  802493:	75 14                	jne    8024a9 <devpipe_read+0x39>
	return i;
  802495:	8b 45 10             	mov    0x10(%ebp),%eax
  802498:	eb 02                	jmp    80249c <devpipe_read+0x2c>
				return i;
  80249a:	89 f0                	mov    %esi,%eax
}
  80249c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80249f:	5b                   	pop    %ebx
  8024a0:	5e                   	pop    %esi
  8024a1:	5f                   	pop    %edi
  8024a2:	5d                   	pop    %ebp
  8024a3:	c3                   	ret    
			sys_yield();
  8024a4:	e8 58 ed ff ff       	call   801201 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024a9:	8b 03                	mov    (%ebx),%eax
  8024ab:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024ae:	75 18                	jne    8024c8 <devpipe_read+0x58>
			if (i > 0)
  8024b0:	85 f6                	test   %esi,%esi
  8024b2:	75 e6                	jne    80249a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8024b4:	89 da                	mov    %ebx,%edx
  8024b6:	89 f8                	mov    %edi,%eax
  8024b8:	e8 c8 fe ff ff       	call   802385 <_pipeisclosed>
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	74 e3                	je     8024a4 <devpipe_read+0x34>
				return 0;
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c6:	eb d4                	jmp    80249c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024c8:	99                   	cltd   
  8024c9:	c1 ea 1b             	shr    $0x1b,%edx
  8024cc:	01 d0                	add    %edx,%eax
  8024ce:	83 e0 1f             	and    $0x1f,%eax
  8024d1:	29 d0                	sub    %edx,%eax
  8024d3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024db:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024de:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024e1:	83 c6 01             	add    $0x1,%esi
  8024e4:	eb aa                	jmp    802490 <devpipe_read+0x20>

008024e6 <pipe>:
{
  8024e6:	f3 0f 1e fb          	endbr32 
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	56                   	push   %esi
  8024ee:	53                   	push   %ebx
  8024ef:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f5:	50                   	push   %eax
  8024f6:	e8 32 f1 ff ff       	call   80162d <fd_alloc>
  8024fb:	89 c3                	mov    %eax,%ebx
  8024fd:	83 c4 10             	add    $0x10,%esp
  802500:	85 c0                	test   %eax,%eax
  802502:	0f 88 23 01 00 00    	js     80262b <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802508:	83 ec 04             	sub    $0x4,%esp
  80250b:	68 07 04 00 00       	push   $0x407
  802510:	ff 75 f4             	pushl  -0xc(%ebp)
  802513:	6a 00                	push   $0x0
  802515:	e8 0a ed ff ff       	call   801224 <sys_page_alloc>
  80251a:	89 c3                	mov    %eax,%ebx
  80251c:	83 c4 10             	add    $0x10,%esp
  80251f:	85 c0                	test   %eax,%eax
  802521:	0f 88 04 01 00 00    	js     80262b <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802527:	83 ec 0c             	sub    $0xc,%esp
  80252a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80252d:	50                   	push   %eax
  80252e:	e8 fa f0 ff ff       	call   80162d <fd_alloc>
  802533:	89 c3                	mov    %eax,%ebx
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	85 c0                	test   %eax,%eax
  80253a:	0f 88 db 00 00 00    	js     80261b <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802540:	83 ec 04             	sub    $0x4,%esp
  802543:	68 07 04 00 00       	push   $0x407
  802548:	ff 75 f0             	pushl  -0x10(%ebp)
  80254b:	6a 00                	push   $0x0
  80254d:	e8 d2 ec ff ff       	call   801224 <sys_page_alloc>
  802552:	89 c3                	mov    %eax,%ebx
  802554:	83 c4 10             	add    $0x10,%esp
  802557:	85 c0                	test   %eax,%eax
  802559:	0f 88 bc 00 00 00    	js     80261b <pipe+0x135>
	va = fd2data(fd0);
  80255f:	83 ec 0c             	sub    $0xc,%esp
  802562:	ff 75 f4             	pushl  -0xc(%ebp)
  802565:	e8 a8 f0 ff ff       	call   801612 <fd2data>
  80256a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80256c:	83 c4 0c             	add    $0xc,%esp
  80256f:	68 07 04 00 00       	push   $0x407
  802574:	50                   	push   %eax
  802575:	6a 00                	push   $0x0
  802577:	e8 a8 ec ff ff       	call   801224 <sys_page_alloc>
  80257c:	89 c3                	mov    %eax,%ebx
  80257e:	83 c4 10             	add    $0x10,%esp
  802581:	85 c0                	test   %eax,%eax
  802583:	0f 88 82 00 00 00    	js     80260b <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802589:	83 ec 0c             	sub    $0xc,%esp
  80258c:	ff 75 f0             	pushl  -0x10(%ebp)
  80258f:	e8 7e f0 ff ff       	call   801612 <fd2data>
  802594:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80259b:	50                   	push   %eax
  80259c:	6a 00                	push   $0x0
  80259e:	56                   	push   %esi
  80259f:	6a 00                	push   $0x0
  8025a1:	e8 c5 ec ff ff       	call   80126b <sys_page_map>
  8025a6:	89 c3                	mov    %eax,%ebx
  8025a8:	83 c4 20             	add    $0x20,%esp
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	78 4e                	js     8025fd <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8025af:	a1 40 40 80 00       	mov    0x804040,%eax
  8025b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025d2:	83 ec 0c             	sub    $0xc,%esp
  8025d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d8:	e8 21 f0 ff ff       	call   8015fe <fd2num>
  8025dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025e2:	83 c4 04             	add    $0x4,%esp
  8025e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8025e8:	e8 11 f0 ff ff       	call   8015fe <fd2num>
  8025ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025f3:	83 c4 10             	add    $0x10,%esp
  8025f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025fb:	eb 2e                	jmp    80262b <pipe+0x145>
	sys_page_unmap(0, va);
  8025fd:	83 ec 08             	sub    $0x8,%esp
  802600:	56                   	push   %esi
  802601:	6a 00                	push   $0x0
  802603:	e8 a9 ec ff ff       	call   8012b1 <sys_page_unmap>
  802608:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80260b:	83 ec 08             	sub    $0x8,%esp
  80260e:	ff 75 f0             	pushl  -0x10(%ebp)
  802611:	6a 00                	push   $0x0
  802613:	e8 99 ec ff ff       	call   8012b1 <sys_page_unmap>
  802618:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80261b:	83 ec 08             	sub    $0x8,%esp
  80261e:	ff 75 f4             	pushl  -0xc(%ebp)
  802621:	6a 00                	push   $0x0
  802623:	e8 89 ec ff ff       	call   8012b1 <sys_page_unmap>
  802628:	83 c4 10             	add    $0x10,%esp
}
  80262b:	89 d8                	mov    %ebx,%eax
  80262d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802630:	5b                   	pop    %ebx
  802631:	5e                   	pop    %esi
  802632:	5d                   	pop    %ebp
  802633:	c3                   	ret    

00802634 <pipeisclosed>:
{
  802634:	f3 0f 1e fb          	endbr32 
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80263e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802641:	50                   	push   %eax
  802642:	ff 75 08             	pushl  0x8(%ebp)
  802645:	e8 39 f0 ff ff       	call   801683 <fd_lookup>
  80264a:	83 c4 10             	add    $0x10,%esp
  80264d:	85 c0                	test   %eax,%eax
  80264f:	78 18                	js     802669 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802651:	83 ec 0c             	sub    $0xc,%esp
  802654:	ff 75 f4             	pushl  -0xc(%ebp)
  802657:	e8 b6 ef ff ff       	call   801612 <fd2data>
  80265c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	e8 1f fd ff ff       	call   802385 <_pipeisclosed>
  802666:	83 c4 10             	add    $0x10,%esp
}
  802669:	c9                   	leave  
  80266a:	c3                   	ret    

0080266b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80266b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80266f:	b8 00 00 00 00       	mov    $0x0,%eax
  802674:	c3                   	ret    

00802675 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802675:	f3 0f 1e fb          	endbr32 
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
  80267c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80267f:	68 0b 33 80 00       	push   $0x80330b
  802684:	ff 75 0c             	pushl  0xc(%ebp)
  802687:	e8 56 e7 ff ff       	call   800de2 <strcpy>
	return 0;
}
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <devcons_write>:
{
  802693:	f3 0f 1e fb          	endbr32 
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	57                   	push   %edi
  80269b:	56                   	push   %esi
  80269c:	53                   	push   %ebx
  80269d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026a3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026a8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026b1:	73 31                	jae    8026e4 <devcons_write+0x51>
		m = n - tot;
  8026b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026b6:	29 f3                	sub    %esi,%ebx
  8026b8:	83 fb 7f             	cmp    $0x7f,%ebx
  8026bb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026c0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026c3:	83 ec 04             	sub    $0x4,%esp
  8026c6:	53                   	push   %ebx
  8026c7:	89 f0                	mov    %esi,%eax
  8026c9:	03 45 0c             	add    0xc(%ebp),%eax
  8026cc:	50                   	push   %eax
  8026cd:	57                   	push   %edi
  8026ce:	e8 c5 e8 ff ff       	call   800f98 <memmove>
		sys_cputs(buf, m);
  8026d3:	83 c4 08             	add    $0x8,%esp
  8026d6:	53                   	push   %ebx
  8026d7:	57                   	push   %edi
  8026d8:	e8 77 ea ff ff       	call   801154 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026dd:	01 de                	add    %ebx,%esi
  8026df:	83 c4 10             	add    $0x10,%esp
  8026e2:	eb ca                	jmp    8026ae <devcons_write+0x1b>
}
  8026e4:	89 f0                	mov    %esi,%eax
  8026e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026e9:	5b                   	pop    %ebx
  8026ea:	5e                   	pop    %esi
  8026eb:	5f                   	pop    %edi
  8026ec:	5d                   	pop    %ebp
  8026ed:	c3                   	ret    

008026ee <devcons_read>:
{
  8026ee:	f3 0f 1e fb          	endbr32 
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 08             	sub    $0x8,%esp
  8026f8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802701:	74 21                	je     802724 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802703:	e8 6e ea ff ff       	call   801176 <sys_cgetc>
  802708:	85 c0                	test   %eax,%eax
  80270a:	75 07                	jne    802713 <devcons_read+0x25>
		sys_yield();
  80270c:	e8 f0 ea ff ff       	call   801201 <sys_yield>
  802711:	eb f0                	jmp    802703 <devcons_read+0x15>
	if (c < 0)
  802713:	78 0f                	js     802724 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802715:	83 f8 04             	cmp    $0x4,%eax
  802718:	74 0c                	je     802726 <devcons_read+0x38>
	*(char*)vbuf = c;
  80271a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271d:	88 02                	mov    %al,(%edx)
	return 1;
  80271f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802724:	c9                   	leave  
  802725:	c3                   	ret    
		return 0;
  802726:	b8 00 00 00 00       	mov    $0x0,%eax
  80272b:	eb f7                	jmp    802724 <devcons_read+0x36>

0080272d <cputchar>:
{
  80272d:	f3 0f 1e fb          	endbr32 
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80273d:	6a 01                	push   $0x1
  80273f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802742:	50                   	push   %eax
  802743:	e8 0c ea ff ff       	call   801154 <sys_cputs>
}
  802748:	83 c4 10             	add    $0x10,%esp
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <getchar>:
{
  80274d:	f3 0f 1e fb          	endbr32 
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
  802754:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802757:	6a 01                	push   $0x1
  802759:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80275c:	50                   	push   %eax
  80275d:	6a 00                	push   $0x0
  80275f:	e8 a7 f1 ff ff       	call   80190b <read>
	if (r < 0)
  802764:	83 c4 10             	add    $0x10,%esp
  802767:	85 c0                	test   %eax,%eax
  802769:	78 06                	js     802771 <getchar+0x24>
	if (r < 1)
  80276b:	74 06                	je     802773 <getchar+0x26>
	return c;
  80276d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802771:	c9                   	leave  
  802772:	c3                   	ret    
		return -E_EOF;
  802773:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802778:	eb f7                	jmp    802771 <getchar+0x24>

0080277a <iscons>:
{
  80277a:	f3 0f 1e fb          	endbr32 
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802784:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802787:	50                   	push   %eax
  802788:	ff 75 08             	pushl  0x8(%ebp)
  80278b:	e8 f3 ee ff ff       	call   801683 <fd_lookup>
  802790:	83 c4 10             	add    $0x10,%esp
  802793:	85 c0                	test   %eax,%eax
  802795:	78 11                	js     8027a8 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8027a0:	39 10                	cmp    %edx,(%eax)
  8027a2:	0f 94 c0             	sete   %al
  8027a5:	0f b6 c0             	movzbl %al,%eax
}
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <opencons>:
{
  8027aa:	f3 0f 1e fb          	endbr32 
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027b7:	50                   	push   %eax
  8027b8:	e8 70 ee ff ff       	call   80162d <fd_alloc>
  8027bd:	83 c4 10             	add    $0x10,%esp
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	78 3a                	js     8027fe <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027c4:	83 ec 04             	sub    $0x4,%esp
  8027c7:	68 07 04 00 00       	push   $0x407
  8027cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8027cf:	6a 00                	push   $0x0
  8027d1:	e8 4e ea ff ff       	call   801224 <sys_page_alloc>
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	78 21                	js     8027fe <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8027e6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027f2:	83 ec 0c             	sub    $0xc,%esp
  8027f5:	50                   	push   %eax
  8027f6:	e8 03 ee ff ff       	call   8015fe <fd2num>
  8027fb:	83 c4 10             	add    $0x10,%esp
}
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802800:	f3 0f 1e fb          	endbr32 
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80280a:	89 c2                	mov    %eax,%edx
  80280c:	c1 ea 16             	shr    $0x16,%edx
  80280f:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802816:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80281b:	f6 c1 01             	test   $0x1,%cl
  80281e:	74 1c                	je     80283c <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802820:	c1 e8 0c             	shr    $0xc,%eax
  802823:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80282a:	a8 01                	test   $0x1,%al
  80282c:	74 0e                	je     80283c <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80282e:	c1 e8 0c             	shr    $0xc,%eax
  802831:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802838:	ef 
  802839:	0f b7 d2             	movzwl %dx,%edx
}
  80283c:	89 d0                	mov    %edx,%eax
  80283e:	5d                   	pop    %ebp
  80283f:	c3                   	ret    

00802840 <__udivdi3>:
  802840:	f3 0f 1e fb          	endbr32 
  802844:	55                   	push   %ebp
  802845:	57                   	push   %edi
  802846:	56                   	push   %esi
  802847:	53                   	push   %ebx
  802848:	83 ec 1c             	sub    $0x1c,%esp
  80284b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80284f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802853:	8b 74 24 34          	mov    0x34(%esp),%esi
  802857:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80285b:	85 d2                	test   %edx,%edx
  80285d:	75 19                	jne    802878 <__udivdi3+0x38>
  80285f:	39 f3                	cmp    %esi,%ebx
  802861:	76 4d                	jbe    8028b0 <__udivdi3+0x70>
  802863:	31 ff                	xor    %edi,%edi
  802865:	89 e8                	mov    %ebp,%eax
  802867:	89 f2                	mov    %esi,%edx
  802869:	f7 f3                	div    %ebx
  80286b:	89 fa                	mov    %edi,%edx
  80286d:	83 c4 1c             	add    $0x1c,%esp
  802870:	5b                   	pop    %ebx
  802871:	5e                   	pop    %esi
  802872:	5f                   	pop    %edi
  802873:	5d                   	pop    %ebp
  802874:	c3                   	ret    
  802875:	8d 76 00             	lea    0x0(%esi),%esi
  802878:	39 f2                	cmp    %esi,%edx
  80287a:	76 14                	jbe    802890 <__udivdi3+0x50>
  80287c:	31 ff                	xor    %edi,%edi
  80287e:	31 c0                	xor    %eax,%eax
  802880:	89 fa                	mov    %edi,%edx
  802882:	83 c4 1c             	add    $0x1c,%esp
  802885:	5b                   	pop    %ebx
  802886:	5e                   	pop    %esi
  802887:	5f                   	pop    %edi
  802888:	5d                   	pop    %ebp
  802889:	c3                   	ret    
  80288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802890:	0f bd fa             	bsr    %edx,%edi
  802893:	83 f7 1f             	xor    $0x1f,%edi
  802896:	75 48                	jne    8028e0 <__udivdi3+0xa0>
  802898:	39 f2                	cmp    %esi,%edx
  80289a:	72 06                	jb     8028a2 <__udivdi3+0x62>
  80289c:	31 c0                	xor    %eax,%eax
  80289e:	39 eb                	cmp    %ebp,%ebx
  8028a0:	77 de                	ja     802880 <__udivdi3+0x40>
  8028a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a7:	eb d7                	jmp    802880 <__udivdi3+0x40>
  8028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028b0:	89 d9                	mov    %ebx,%ecx
  8028b2:	85 db                	test   %ebx,%ebx
  8028b4:	75 0b                	jne    8028c1 <__udivdi3+0x81>
  8028b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bb:	31 d2                	xor    %edx,%edx
  8028bd:	f7 f3                	div    %ebx
  8028bf:	89 c1                	mov    %eax,%ecx
  8028c1:	31 d2                	xor    %edx,%edx
  8028c3:	89 f0                	mov    %esi,%eax
  8028c5:	f7 f1                	div    %ecx
  8028c7:	89 c6                	mov    %eax,%esi
  8028c9:	89 e8                	mov    %ebp,%eax
  8028cb:	89 f7                	mov    %esi,%edi
  8028cd:	f7 f1                	div    %ecx
  8028cf:	89 fa                	mov    %edi,%edx
  8028d1:	83 c4 1c             	add    $0x1c,%esp
  8028d4:	5b                   	pop    %ebx
  8028d5:	5e                   	pop    %esi
  8028d6:	5f                   	pop    %edi
  8028d7:	5d                   	pop    %ebp
  8028d8:	c3                   	ret    
  8028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028e0:	89 f9                	mov    %edi,%ecx
  8028e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028e7:	29 f8                	sub    %edi,%eax
  8028e9:	d3 e2                	shl    %cl,%edx
  8028eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028ef:	89 c1                	mov    %eax,%ecx
  8028f1:	89 da                	mov    %ebx,%edx
  8028f3:	d3 ea                	shr    %cl,%edx
  8028f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028f9:	09 d1                	or     %edx,%ecx
  8028fb:	89 f2                	mov    %esi,%edx
  8028fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802901:	89 f9                	mov    %edi,%ecx
  802903:	d3 e3                	shl    %cl,%ebx
  802905:	89 c1                	mov    %eax,%ecx
  802907:	d3 ea                	shr    %cl,%edx
  802909:	89 f9                	mov    %edi,%ecx
  80290b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80290f:	89 eb                	mov    %ebp,%ebx
  802911:	d3 e6                	shl    %cl,%esi
  802913:	89 c1                	mov    %eax,%ecx
  802915:	d3 eb                	shr    %cl,%ebx
  802917:	09 de                	or     %ebx,%esi
  802919:	89 f0                	mov    %esi,%eax
  80291b:	f7 74 24 08          	divl   0x8(%esp)
  80291f:	89 d6                	mov    %edx,%esi
  802921:	89 c3                	mov    %eax,%ebx
  802923:	f7 64 24 0c          	mull   0xc(%esp)
  802927:	39 d6                	cmp    %edx,%esi
  802929:	72 15                	jb     802940 <__udivdi3+0x100>
  80292b:	89 f9                	mov    %edi,%ecx
  80292d:	d3 e5                	shl    %cl,%ebp
  80292f:	39 c5                	cmp    %eax,%ebp
  802931:	73 04                	jae    802937 <__udivdi3+0xf7>
  802933:	39 d6                	cmp    %edx,%esi
  802935:	74 09                	je     802940 <__udivdi3+0x100>
  802937:	89 d8                	mov    %ebx,%eax
  802939:	31 ff                	xor    %edi,%edi
  80293b:	e9 40 ff ff ff       	jmp    802880 <__udivdi3+0x40>
  802940:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802943:	31 ff                	xor    %edi,%edi
  802945:	e9 36 ff ff ff       	jmp    802880 <__udivdi3+0x40>
  80294a:	66 90                	xchg   %ax,%ax
  80294c:	66 90                	xchg   %ax,%ax
  80294e:	66 90                	xchg   %ax,%ax

00802950 <__umoddi3>:
  802950:	f3 0f 1e fb          	endbr32 
  802954:	55                   	push   %ebp
  802955:	57                   	push   %edi
  802956:	56                   	push   %esi
  802957:	53                   	push   %ebx
  802958:	83 ec 1c             	sub    $0x1c,%esp
  80295b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80295f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802963:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802967:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80296b:	85 c0                	test   %eax,%eax
  80296d:	75 19                	jne    802988 <__umoddi3+0x38>
  80296f:	39 df                	cmp    %ebx,%edi
  802971:	76 5d                	jbe    8029d0 <__umoddi3+0x80>
  802973:	89 f0                	mov    %esi,%eax
  802975:	89 da                	mov    %ebx,%edx
  802977:	f7 f7                	div    %edi
  802979:	89 d0                	mov    %edx,%eax
  80297b:	31 d2                	xor    %edx,%edx
  80297d:	83 c4 1c             	add    $0x1c,%esp
  802980:	5b                   	pop    %ebx
  802981:	5e                   	pop    %esi
  802982:	5f                   	pop    %edi
  802983:	5d                   	pop    %ebp
  802984:	c3                   	ret    
  802985:	8d 76 00             	lea    0x0(%esi),%esi
  802988:	89 f2                	mov    %esi,%edx
  80298a:	39 d8                	cmp    %ebx,%eax
  80298c:	76 12                	jbe    8029a0 <__umoddi3+0x50>
  80298e:	89 f0                	mov    %esi,%eax
  802990:	89 da                	mov    %ebx,%edx
  802992:	83 c4 1c             	add    $0x1c,%esp
  802995:	5b                   	pop    %ebx
  802996:	5e                   	pop    %esi
  802997:	5f                   	pop    %edi
  802998:	5d                   	pop    %ebp
  802999:	c3                   	ret    
  80299a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029a0:	0f bd e8             	bsr    %eax,%ebp
  8029a3:	83 f5 1f             	xor    $0x1f,%ebp
  8029a6:	75 50                	jne    8029f8 <__umoddi3+0xa8>
  8029a8:	39 d8                	cmp    %ebx,%eax
  8029aa:	0f 82 e0 00 00 00    	jb     802a90 <__umoddi3+0x140>
  8029b0:	89 d9                	mov    %ebx,%ecx
  8029b2:	39 f7                	cmp    %esi,%edi
  8029b4:	0f 86 d6 00 00 00    	jbe    802a90 <__umoddi3+0x140>
  8029ba:	89 d0                	mov    %edx,%eax
  8029bc:	89 ca                	mov    %ecx,%edx
  8029be:	83 c4 1c             	add    $0x1c,%esp
  8029c1:	5b                   	pop    %ebx
  8029c2:	5e                   	pop    %esi
  8029c3:	5f                   	pop    %edi
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    
  8029c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029cd:	8d 76 00             	lea    0x0(%esi),%esi
  8029d0:	89 fd                	mov    %edi,%ebp
  8029d2:	85 ff                	test   %edi,%edi
  8029d4:	75 0b                	jne    8029e1 <__umoddi3+0x91>
  8029d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029db:	31 d2                	xor    %edx,%edx
  8029dd:	f7 f7                	div    %edi
  8029df:	89 c5                	mov    %eax,%ebp
  8029e1:	89 d8                	mov    %ebx,%eax
  8029e3:	31 d2                	xor    %edx,%edx
  8029e5:	f7 f5                	div    %ebp
  8029e7:	89 f0                	mov    %esi,%eax
  8029e9:	f7 f5                	div    %ebp
  8029eb:	89 d0                	mov    %edx,%eax
  8029ed:	31 d2                	xor    %edx,%edx
  8029ef:	eb 8c                	jmp    80297d <__umoddi3+0x2d>
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	89 e9                	mov    %ebp,%ecx
  8029fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8029ff:	29 ea                	sub    %ebp,%edx
  802a01:	d3 e0                	shl    %cl,%eax
  802a03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a07:	89 d1                	mov    %edx,%ecx
  802a09:	89 f8                	mov    %edi,%eax
  802a0b:	d3 e8                	shr    %cl,%eax
  802a0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a11:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a15:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a19:	09 c1                	or     %eax,%ecx
  802a1b:	89 d8                	mov    %ebx,%eax
  802a1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a21:	89 e9                	mov    %ebp,%ecx
  802a23:	d3 e7                	shl    %cl,%edi
  802a25:	89 d1                	mov    %edx,%ecx
  802a27:	d3 e8                	shr    %cl,%eax
  802a29:	89 e9                	mov    %ebp,%ecx
  802a2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a2f:	d3 e3                	shl    %cl,%ebx
  802a31:	89 c7                	mov    %eax,%edi
  802a33:	89 d1                	mov    %edx,%ecx
  802a35:	89 f0                	mov    %esi,%eax
  802a37:	d3 e8                	shr    %cl,%eax
  802a39:	89 e9                	mov    %ebp,%ecx
  802a3b:	89 fa                	mov    %edi,%edx
  802a3d:	d3 e6                	shl    %cl,%esi
  802a3f:	09 d8                	or     %ebx,%eax
  802a41:	f7 74 24 08          	divl   0x8(%esp)
  802a45:	89 d1                	mov    %edx,%ecx
  802a47:	89 f3                	mov    %esi,%ebx
  802a49:	f7 64 24 0c          	mull   0xc(%esp)
  802a4d:	89 c6                	mov    %eax,%esi
  802a4f:	89 d7                	mov    %edx,%edi
  802a51:	39 d1                	cmp    %edx,%ecx
  802a53:	72 06                	jb     802a5b <__umoddi3+0x10b>
  802a55:	75 10                	jne    802a67 <__umoddi3+0x117>
  802a57:	39 c3                	cmp    %eax,%ebx
  802a59:	73 0c                	jae    802a67 <__umoddi3+0x117>
  802a5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a63:	89 d7                	mov    %edx,%edi
  802a65:	89 c6                	mov    %eax,%esi
  802a67:	89 ca                	mov    %ecx,%edx
  802a69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a6e:	29 f3                	sub    %esi,%ebx
  802a70:	19 fa                	sbb    %edi,%edx
  802a72:	89 d0                	mov    %edx,%eax
  802a74:	d3 e0                	shl    %cl,%eax
  802a76:	89 e9                	mov    %ebp,%ecx
  802a78:	d3 eb                	shr    %cl,%ebx
  802a7a:	d3 ea                	shr    %cl,%edx
  802a7c:	09 d8                	or     %ebx,%eax
  802a7e:	83 c4 1c             	add    $0x1c,%esp
  802a81:	5b                   	pop    %ebx
  802a82:	5e                   	pop    %esi
  802a83:	5f                   	pop    %edi
  802a84:	5d                   	pop    %ebp
  802a85:	c3                   	ret    
  802a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a8d:	8d 76 00             	lea    0x0(%esi),%esi
  802a90:	29 fe                	sub    %edi,%esi
  802a92:	19 c3                	sbb    %eax,%ebx
  802a94:	89 f2                	mov    %esi,%edx
  802a96:	89 d9                	mov    %ebx,%ecx
  802a98:	e9 1d ff ff ff       	jmp    8029ba <__umoddi3+0x6a>
