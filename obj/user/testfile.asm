
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
  80003d:	68 00 50 80 00       	push   $0x805000
  800042:	e8 9b 0d 00 00       	call   800de2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 54 80 00    	mov    %ebx,0x805400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 b9 14 00 00       	call   801512 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 50 80 00       	push   $0x805000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 52 14 00 00       	call   8014ba <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 bc 13 00 00       	call   801435 <ipc_recv>
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
  800093:	b8 40 25 80 00       	mov    $0x802540,%eax
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
  8000b7:	b8 75 25 80 00       	mov    $0x802575,%eax
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
  8000f3:	68 96 25 80 00       	push   $0x802596
  8000f8:	e8 db 06 00 00       	call   8007d8 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000fd:	83 c4 08             	add    $0x8,%esp
  800100:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800106:	50                   	push   %eax
  800107:	68 00 c0 cc cc       	push   $0xccccc000
  80010c:	ff 15 1c 30 80 00    	call   *0x80301c
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	85 c0                	test   %eax,%eax
  800117:	0f 88 c2 03 00 00    	js     8004df <umain+0x461>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	ff 35 00 30 80 00    	pushl  0x803000
  800126:	e8 74 0c 00 00       	call   800d9f <strlen>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800131:	0f 85 ba 03 00 00    	jne    8004f1 <umain+0x473>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 b8 25 80 00       	push   $0x8025b8
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
  800168:	ff 15 10 30 80 00    	call   *0x803010
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	85 c0                	test   %eax,%eax
  800173:	0f 88 9d 03 00 00    	js     800516 <umain+0x498>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 35 00 30 80 00    	pushl  0x803000
  800182:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 13 0d 00 00       	call   800ea1 <strcmp>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	85 c0                	test   %eax,%eax
  800193:	0f 85 8f 03 00 00    	jne    800528 <umain+0x4aa>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	68 f7 25 80 00       	push   $0x8025f7
  8001a1:	e8 32 06 00 00       	call   8007d8 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a6:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001ad:	ff 15 18 30 80 00    	call   *0x803018
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	0f 88 7e 03 00 00    	js     80053c <umain+0x4be>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 19 26 80 00       	push   $0x802619
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
  80020d:	ff 15 10 30 80 00    	call   *0x803010
  800213:	83 c4 10             	add    $0x10,%esp
  800216:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800219:	0f 85 2f 03 00 00    	jne    80054e <umain+0x4d0>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 2d 26 80 00       	push   $0x80262d
  800227:	e8 ac 05 00 00       	call   8007d8 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80022c:	ba 02 01 00 00       	mov    $0x102,%edx
  800231:	b8 43 26 80 00       	mov    $0x802643,%eax
  800236:	e8 f8 fd ff ff       	call   800033 <xopen>
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	85 c0                	test   %eax,%eax
  800240:	0f 88 1a 03 00 00    	js     800560 <umain+0x4e2>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800246:	8b 1d 14 30 80 00    	mov    0x803014,%ebx
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	ff 35 00 30 80 00    	pushl  0x803000
  800255:	e8 45 0b 00 00       	call   800d9f <strlen>
  80025a:	83 c4 0c             	add    $0xc,%esp
  80025d:	50                   	push   %eax
  80025e:	ff 35 00 30 80 00    	pushl  0x803000
  800264:	68 00 c0 cc cc       	push   $0xccccc000
  800269:	ff d3                	call   *%ebx
  80026b:	89 c3                	mov    %eax,%ebx
  80026d:	83 c4 04             	add    $0x4,%esp
  800270:	ff 35 00 30 80 00    	pushl  0x803000
  800276:	e8 24 0b 00 00       	call   800d9f <strlen>
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	39 d8                	cmp    %ebx,%eax
  800280:	0f 85 ec 02 00 00    	jne    800572 <umain+0x4f4>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	68 75 26 80 00       	push   $0x802675
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
  8002c1:	ff 15 10 30 80 00    	call   *0x803010
  8002c7:	89 c3                	mov    %eax,%ebx
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	0f 88 b0 02 00 00    	js     800584 <umain+0x506>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	ff 35 00 30 80 00    	pushl  0x803000
  8002dd:	e8 bd 0a 00 00       	call   800d9f <strlen>
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	39 d8                	cmp    %ebx,%eax
  8002e7:	0f 85 a9 02 00 00    	jne    800596 <umain+0x518>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	ff 35 00 30 80 00    	pushl  0x803000
  8002f6:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002fc:	50                   	push   %eax
  8002fd:	e8 9f 0b 00 00       	call   800ea1 <strcmp>
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	85 c0                	test   %eax,%eax
  800307:	0f 85 9b 02 00 00    	jne    8005a8 <umain+0x52a>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	68 3c 28 80 00       	push   $0x80283c
  800315:	e8 be 04 00 00       	call   8007d8 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80031a:	83 c4 08             	add    $0x8,%esp
  80031d:	6a 00                	push   $0x0
  80031f:	68 40 25 80 00       	push   $0x802540
  800324:	e8 c3 19 00 00       	call   801cec <open>
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
  800346:	68 75 25 80 00       	push   $0x802575
  80034b:	e8 9c 19 00 00       	call   801cec <open>
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
  800389:	68 9c 25 80 00       	push   $0x80259c
  80038e:	e8 45 04 00 00       	call   8007d8 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  800393:	83 c4 08             	add    $0x8,%esp
  800396:	68 01 01 00 00       	push   $0x101
  80039b:	68 a4 26 80 00       	push   $0x8026a4
  8003a0:	e8 47 19 00 00       	call   801cec <open>
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
  8003e3:	e8 45 15 00 00       	call   80192d <write>
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
  800405:	e8 03 13 00 00       	call   80170d <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80040a:	83 c4 08             	add    $0x8,%esp
  80040d:	6a 00                	push   $0x0
  80040f:	68 a4 26 80 00       	push   $0x8026a4
  800414:	e8 d3 18 00 00       	call   801cec <open>
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
  80043c:	e8 a1 14 00 00       	call   8018e2 <readn>
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
  800477:	e8 91 12 00 00       	call   80170d <close>
	cprintf("large file is good\n");
  80047c:	c7 04 24 e9 26 80 00 	movl   $0x8026e9,(%esp)
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
  800494:	68 4b 25 80 00       	push   $0x80254b
  800499:	6a 20                	push   $0x20
  80049b:	68 65 25 80 00       	push   $0x802565
  8004a0:	e8 4c 02 00 00       	call   8006f1 <_panic>
		panic("serve_open /not-found succeeded!");
  8004a5:	83 ec 04             	sub    $0x4,%esp
  8004a8:	68 00 27 80 00       	push   $0x802700
  8004ad:	6a 22                	push   $0x22
  8004af:	68 65 25 80 00       	push   $0x802565
  8004b4:	e8 38 02 00 00       	call   8006f1 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b9:	50                   	push   %eax
  8004ba:	68 7e 25 80 00       	push   $0x80257e
  8004bf:	6a 25                	push   $0x25
  8004c1:	68 65 25 80 00       	push   $0x802565
  8004c6:	e8 26 02 00 00       	call   8006f1 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 24 27 80 00       	push   $0x802724
  8004d3:	6a 27                	push   $0x27
  8004d5:	68 65 25 80 00       	push   $0x802565
  8004da:	e8 12 02 00 00       	call   8006f1 <_panic>
		panic("file_stat: %e", r);
  8004df:	50                   	push   %eax
  8004e0:	68 aa 25 80 00       	push   $0x8025aa
  8004e5:	6a 2b                	push   $0x2b
  8004e7:	68 65 25 80 00       	push   $0x802565
  8004ec:	e8 00 02 00 00       	call   8006f1 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004f1:	83 ec 0c             	sub    $0xc,%esp
  8004f4:	ff 35 00 30 80 00    	pushl  0x803000
  8004fa:	e8 a0 08 00 00       	call   800d9f <strlen>
  8004ff:	89 04 24             	mov    %eax,(%esp)
  800502:	ff 75 cc             	pushl  -0x34(%ebp)
  800505:	68 54 27 80 00       	push   $0x802754
  80050a:	6a 2d                	push   $0x2d
  80050c:	68 65 25 80 00       	push   $0x802565
  800511:	e8 db 01 00 00       	call   8006f1 <_panic>
		panic("file_read: %e", r);
  800516:	50                   	push   %eax
  800517:	68 cb 25 80 00       	push   $0x8025cb
  80051c:	6a 32                	push   $0x32
  80051e:	68 65 25 80 00       	push   $0x802565
  800523:	e8 c9 01 00 00       	call   8006f1 <_panic>
		panic("file_read returned wrong data");
  800528:	83 ec 04             	sub    $0x4,%esp
  80052b:	68 d9 25 80 00       	push   $0x8025d9
  800530:	6a 34                	push   $0x34
  800532:	68 65 25 80 00       	push   $0x802565
  800537:	e8 b5 01 00 00       	call   8006f1 <_panic>
		panic("file_close: %e", r);
  80053c:	50                   	push   %eax
  80053d:	68 0a 26 80 00       	push   $0x80260a
  800542:	6a 38                	push   $0x38
  800544:	68 65 25 80 00       	push   $0x802565
  800549:	e8 a3 01 00 00       	call   8006f1 <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054e:	50                   	push   %eax
  80054f:	68 7c 27 80 00       	push   $0x80277c
  800554:	6a 43                	push   $0x43
  800556:	68 65 25 80 00       	push   $0x802565
  80055b:	e8 91 01 00 00       	call   8006f1 <_panic>
		panic("serve_open /new-file: %e", r);
  800560:	50                   	push   %eax
  800561:	68 4d 26 80 00       	push   $0x80264d
  800566:	6a 48                	push   $0x48
  800568:	68 65 25 80 00       	push   $0x802565
  80056d:	e8 7f 01 00 00       	call   8006f1 <_panic>
		panic("file_write: %e", r);
  800572:	53                   	push   %ebx
  800573:	68 66 26 80 00       	push   $0x802666
  800578:	6a 4b                	push   $0x4b
  80057a:	68 65 25 80 00       	push   $0x802565
  80057f:	e8 6d 01 00 00       	call   8006f1 <_panic>
		panic("file_read after file_write: %e", r);
  800584:	50                   	push   %eax
  800585:	68 b4 27 80 00       	push   $0x8027b4
  80058a:	6a 51                	push   $0x51
  80058c:	68 65 25 80 00       	push   $0x802565
  800591:	e8 5b 01 00 00       	call   8006f1 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800596:	53                   	push   %ebx
  800597:	68 d4 27 80 00       	push   $0x8027d4
  80059c:	6a 53                	push   $0x53
  80059e:	68 65 25 80 00       	push   $0x802565
  8005a3:	e8 49 01 00 00       	call   8006f1 <_panic>
		panic("file_read after file_write returned wrong data");
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	68 0c 28 80 00       	push   $0x80280c
  8005b0:	6a 55                	push   $0x55
  8005b2:	68 65 25 80 00       	push   $0x802565
  8005b7:	e8 35 01 00 00       	call   8006f1 <_panic>
		panic("open /not-found: %e", r);
  8005bc:	50                   	push   %eax
  8005bd:	68 51 25 80 00       	push   $0x802551
  8005c2:	6a 5a                	push   $0x5a
  8005c4:	68 65 25 80 00       	push   $0x802565
  8005c9:	e8 23 01 00 00       	call   8006f1 <_panic>
		panic("open /not-found succeeded!");
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	68 89 26 80 00       	push   $0x802689
  8005d6:	6a 5c                	push   $0x5c
  8005d8:	68 65 25 80 00       	push   $0x802565
  8005dd:	e8 0f 01 00 00       	call   8006f1 <_panic>
		panic("open /newmotd: %e", r);
  8005e2:	50                   	push   %eax
  8005e3:	68 84 25 80 00       	push   $0x802584
  8005e8:	6a 5f                	push   $0x5f
  8005ea:	68 65 25 80 00       	push   $0x802565
  8005ef:	e8 fd 00 00 00       	call   8006f1 <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 60 28 80 00       	push   $0x802860
  8005fc:	6a 62                	push   $0x62
  8005fe:	68 65 25 80 00       	push   $0x802565
  800603:	e8 e9 00 00 00       	call   8006f1 <_panic>
		panic("creat /big: %e", f);
  800608:	50                   	push   %eax
  800609:	68 a9 26 80 00       	push   $0x8026a9
  80060e:	6a 67                	push   $0x67
  800610:	68 65 25 80 00       	push   $0x802565
  800615:	e8 d7 00 00 00       	call   8006f1 <_panic>
			panic("write /big@%d: %e", i, r);
  80061a:	83 ec 0c             	sub    $0xc,%esp
  80061d:	50                   	push   %eax
  80061e:	56                   	push   %esi
  80061f:	68 b8 26 80 00       	push   $0x8026b8
  800624:	6a 6c                	push   $0x6c
  800626:	68 65 25 80 00       	push   $0x802565
  80062b:	e8 c1 00 00 00       	call   8006f1 <_panic>
		panic("open /big: %e", f);
  800630:	50                   	push   %eax
  800631:	68 ca 26 80 00       	push   $0x8026ca
  800636:	6a 71                	push   $0x71
  800638:	68 65 25 80 00       	push   $0x802565
  80063d:	e8 af 00 00 00       	call   8006f1 <_panic>
			panic("read /big@%d: %e", i, r);
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	53                   	push   %ebx
  800647:	68 d8 26 80 00       	push   $0x8026d8
  80064c:	6a 75                	push   $0x75
  80064e:	68 65 25 80 00       	push   $0x802565
  800653:	e8 99 00 00 00       	call   8006f1 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	68 00 02 00 00       	push   $0x200
  800660:	50                   	push   %eax
  800661:	53                   	push   %ebx
  800662:	68 88 28 80 00       	push   $0x802888
  800667:	6a 77                	push   $0x77
  800669:	68 65 25 80 00       	push   $0x802565
  80066e:	e8 7e 00 00 00       	call   8006f1 <_panic>
			panic("read /big from %d returned bad data %d",
  800673:	83 ec 0c             	sub    $0xc,%esp
  800676:	50                   	push   %eax
  800677:	53                   	push   %ebx
  800678:	68 b4 28 80 00       	push   $0x8028b4
  80067d:	6a 7a                	push   $0x7a
  80067f:	68 65 25 80 00       	push   $0x802565
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
  8006aa:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	85 db                	test   %ebx,%ebx
  8006b1:	7e 07                	jle    8006ba <libmain+0x31>
		binaryname = argv[0];
  8006b3:	8b 06                	mov    (%esi),%eax
  8006b5:	a3 04 30 80 00       	mov    %eax,0x803004

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
  8006dd:	e8 5c 10 00 00       	call   80173e <close_all>
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
  8006fd:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800703:	e8 d6 0a 00 00       	call   8011de <sys_getenvid>
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	ff 75 08             	pushl  0x8(%ebp)
  800711:	56                   	push   %esi
  800712:	50                   	push   %eax
  800713:	68 0c 29 80 00       	push   $0x80290c
  800718:	e8 bb 00 00 00       	call   8007d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80071d:	83 c4 18             	add    $0x18,%esp
  800720:	53                   	push   %ebx
  800721:	ff 75 10             	pushl  0x10(%ebp)
  800724:	e8 5a 00 00 00       	call   800783 <vcprintf>
	cprintf("\n");
  800729:	c7 04 24 83 2c 80 00 	movl   $0x802c83,(%esp)
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
  80083e:	e8 9d 1a 00 00       	call   8022e0 <__udivdi3>
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
  80087c:	e8 6f 1b 00 00       	call   8023f0 <__umoddi3>
  800881:	83 c4 14             	add    $0x14,%esp
  800884:	0f be 80 2f 29 80 00 	movsbl 0x80292f(%eax),%eax
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
  80092b:	3e ff 24 85 80 2a 80 	notrack jmp *0x802a80(,%eax,4)
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
  8009f8:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  8009ff:	85 d2                	test   %edx,%edx
  800a01:	74 18                	je     800a1b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800a03:	52                   	push   %edx
  800a04:	68 35 2d 80 00       	push   $0x802d35
  800a09:	53                   	push   %ebx
  800a0a:	56                   	push   %esi
  800a0b:	e8 aa fe ff ff       	call   8008ba <printfmt>
  800a10:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a13:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a16:	e9 66 02 00 00       	jmp    800c81 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800a1b:	50                   	push   %eax
  800a1c:	68 47 29 80 00       	push   $0x802947
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
  800a43:	b8 40 29 80 00       	mov    $0x802940,%eax
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
  8011cd:	68 3f 2c 80 00       	push   $0x802c3f
  8011d2:	6a 23                	push   $0x23
  8011d4:	68 5c 2c 80 00       	push   $0x802c5c
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
  80125a:	68 3f 2c 80 00       	push   $0x802c3f
  80125f:	6a 23                	push   $0x23
  801261:	68 5c 2c 80 00       	push   $0x802c5c
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
  8012a0:	68 3f 2c 80 00       	push   $0x802c3f
  8012a5:	6a 23                	push   $0x23
  8012a7:	68 5c 2c 80 00       	push   $0x802c5c
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
  8012e6:	68 3f 2c 80 00       	push   $0x802c3f
  8012eb:	6a 23                	push   $0x23
  8012ed:	68 5c 2c 80 00       	push   $0x802c5c
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
  80132c:	68 3f 2c 80 00       	push   $0x802c3f
  801331:	6a 23                	push   $0x23
  801333:	68 5c 2c 80 00       	push   $0x802c5c
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
  801372:	68 3f 2c 80 00       	push   $0x802c3f
  801377:	6a 23                	push   $0x23
  801379:	68 5c 2c 80 00       	push   $0x802c5c
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
  8013b8:	68 3f 2c 80 00       	push   $0x802c3f
  8013bd:	6a 23                	push   $0x23
  8013bf:	68 5c 2c 80 00       	push   $0x802c5c
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
  801424:	68 3f 2c 80 00       	push   $0x802c3f
  801429:	6a 23                	push   $0x23
  80142b:	68 5c 2c 80 00       	push   $0x802c5c
  801430:	e8 bc f2 ff ff       	call   8006f1 <_panic>

00801435 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801435:	f3 0f 1e fb          	endbr32 
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	56                   	push   %esi
  80143d:	53                   	push   %ebx
  80143e:	8b 75 08             	mov    0x8(%ebp),%esi
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801447:	85 c0                	test   %eax,%eax
  801449:	74 3d                	je     801488 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80144b:	83 ec 0c             	sub    $0xc,%esp
  80144e:	50                   	push   %eax
  80144f:	e8 9c ff ff ff       	call   8013f0 <sys_ipc_recv>
  801454:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801457:	85 f6                	test   %esi,%esi
  801459:	74 0b                	je     801466 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80145b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801461:	8b 52 74             	mov    0x74(%edx),%edx
  801464:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801466:	85 db                	test   %ebx,%ebx
  801468:	74 0b                	je     801475 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80146a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801470:	8b 52 78             	mov    0x78(%edx),%edx
  801473:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801475:	85 c0                	test   %eax,%eax
  801477:	78 21                	js     80149a <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801479:	a1 04 40 80 00       	mov    0x804004,%eax
  80147e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801481:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801484:	5b                   	pop    %ebx
  801485:	5e                   	pop    %esi
  801486:	5d                   	pop    %ebp
  801487:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	68 00 00 c0 ee       	push   $0xeec00000
  801490:	e8 5b ff ff ff       	call   8013f0 <sys_ipc_recv>
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	eb bd                	jmp    801457 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80149a:	85 f6                	test   %esi,%esi
  80149c:	74 10                	je     8014ae <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80149e:	85 db                	test   %ebx,%ebx
  8014a0:	75 df                	jne    801481 <ipc_recv+0x4c>
  8014a2:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8014a9:	00 00 00 
  8014ac:	eb d3                	jmp    801481 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8014ae:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8014b5:	00 00 00 
  8014b8:	eb e4                	jmp    80149e <ipc_recv+0x69>

008014ba <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014ba:	f3 0f 1e fb          	endbr32 
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	57                   	push   %edi
  8014c2:	56                   	push   %esi
  8014c3:	53                   	push   %ebx
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014ca:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8014d0:	85 db                	test   %ebx,%ebx
  8014d2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8014d7:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8014da:	ff 75 14             	pushl  0x14(%ebp)
  8014dd:	53                   	push   %ebx
  8014de:	56                   	push   %esi
  8014df:	57                   	push   %edi
  8014e0:	e8 e4 fe ff ff       	call   8013c9 <sys_ipc_try_send>
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	79 1e                	jns    80150a <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8014ec:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014ef:	75 07                	jne    8014f8 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8014f1:	e8 0b fd ff ff       	call   801201 <sys_yield>
  8014f6:	eb e2                	jmp    8014da <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8014f8:	50                   	push   %eax
  8014f9:	68 6a 2c 80 00       	push   $0x802c6a
  8014fe:	6a 59                	push   $0x59
  801500:	68 85 2c 80 00       	push   $0x802c85
  801505:	e8 e7 f1 ff ff       	call   8006f1 <_panic>
	}
}
  80150a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150d:	5b                   	pop    %ebx
  80150e:	5e                   	pop    %esi
  80150f:	5f                   	pop    %edi
  801510:	5d                   	pop    %ebp
  801511:	c3                   	ret    

00801512 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801512:	f3 0f 1e fb          	endbr32 
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801521:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801524:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80152a:	8b 52 50             	mov    0x50(%edx),%edx
  80152d:	39 ca                	cmp    %ecx,%edx
  80152f:	74 11                	je     801542 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801531:	83 c0 01             	add    $0x1,%eax
  801534:	3d 00 04 00 00       	cmp    $0x400,%eax
  801539:	75 e6                	jne    801521 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
  801540:	eb 0b                	jmp    80154d <ipc_find_env+0x3b>
			return envs[i].env_id;
  801542:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801545:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80154a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80154d:	5d                   	pop    %ebp
  80154e:	c3                   	ret    

0080154f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80154f:	f3 0f 1e fb          	endbr32 
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	05 00 00 00 30       	add    $0x30000000,%eax
  80155e:	c1 e8 0c             	shr    $0xc,%eax
}
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    

00801563 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801563:	f3 0f 1e fb          	endbr32 
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801572:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801577:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    

0080157e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80157e:	f3 0f 1e fb          	endbr32 
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80158a:	89 c2                	mov    %eax,%edx
  80158c:	c1 ea 16             	shr    $0x16,%edx
  80158f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801596:	f6 c2 01             	test   $0x1,%dl
  801599:	74 2d                	je     8015c8 <fd_alloc+0x4a>
  80159b:	89 c2                	mov    %eax,%edx
  80159d:	c1 ea 0c             	shr    $0xc,%edx
  8015a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015a7:	f6 c2 01             	test   $0x1,%dl
  8015aa:	74 1c                	je     8015c8 <fd_alloc+0x4a>
  8015ac:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015b1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015b6:	75 d2                	jne    80158a <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015c1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015c6:	eb 0a                	jmp    8015d2 <fd_alloc+0x54>
			*fd_store = fd;
  8015c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    

008015d4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015d4:	f3 0f 1e fb          	endbr32 
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015de:	83 f8 1f             	cmp    $0x1f,%eax
  8015e1:	77 30                	ja     801613 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015e3:	c1 e0 0c             	shl    $0xc,%eax
  8015e6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015eb:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015f1:	f6 c2 01             	test   $0x1,%dl
  8015f4:	74 24                	je     80161a <fd_lookup+0x46>
  8015f6:	89 c2                	mov    %eax,%edx
  8015f8:	c1 ea 0c             	shr    $0xc,%edx
  8015fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801602:	f6 c2 01             	test   $0x1,%dl
  801605:	74 1a                	je     801621 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160a:	89 02                	mov    %eax,(%edx)
	return 0;
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    
		return -E_INVAL;
  801613:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801618:	eb f7                	jmp    801611 <fd_lookup+0x3d>
		return -E_INVAL;
  80161a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161f:	eb f0                	jmp    801611 <fd_lookup+0x3d>
  801621:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801626:	eb e9                	jmp    801611 <fd_lookup+0x3d>

00801628 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801628:	f3 0f 1e fb          	endbr32 
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 08             	sub    $0x8,%esp
  801632:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801635:	ba 0c 2d 80 00       	mov    $0x802d0c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80163a:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80163f:	39 08                	cmp    %ecx,(%eax)
  801641:	74 33                	je     801676 <dev_lookup+0x4e>
  801643:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801646:	8b 02                	mov    (%edx),%eax
  801648:	85 c0                	test   %eax,%eax
  80164a:	75 f3                	jne    80163f <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80164c:	a1 04 40 80 00       	mov    0x804004,%eax
  801651:	8b 40 48             	mov    0x48(%eax),%eax
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	51                   	push   %ecx
  801658:	50                   	push   %eax
  801659:	68 90 2c 80 00       	push   $0x802c90
  80165e:	e8 75 f1 ff ff       	call   8007d8 <cprintf>
	*dev = 0;
  801663:	8b 45 0c             	mov    0xc(%ebp),%eax
  801666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    
			*dev = devtab[i];
  801676:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801679:	89 01                	mov    %eax,(%ecx)
			return 0;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
  801680:	eb f2                	jmp    801674 <dev_lookup+0x4c>

00801682 <fd_close>:
{
  801682:	f3 0f 1e fb          	endbr32 
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	57                   	push   %edi
  80168a:	56                   	push   %esi
  80168b:	53                   	push   %ebx
  80168c:	83 ec 24             	sub    $0x24,%esp
  80168f:	8b 75 08             	mov    0x8(%ebp),%esi
  801692:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801695:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801698:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801699:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80169f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016a2:	50                   	push   %eax
  8016a3:	e8 2c ff ff ff       	call   8015d4 <fd_lookup>
  8016a8:	89 c3                	mov    %eax,%ebx
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	78 05                	js     8016b6 <fd_close+0x34>
	    || fd != fd2)
  8016b1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016b4:	74 16                	je     8016cc <fd_close+0x4a>
		return (must_exist ? r : 0);
  8016b6:	89 f8                	mov    %edi,%eax
  8016b8:	84 c0                	test   %al,%al
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bf:	0f 44 d8             	cmove  %eax,%ebx
}
  8016c2:	89 d8                	mov    %ebx,%eax
  8016c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c7:	5b                   	pop    %ebx
  8016c8:	5e                   	pop    %esi
  8016c9:	5f                   	pop    %edi
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016cc:	83 ec 08             	sub    $0x8,%esp
  8016cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016d2:	50                   	push   %eax
  8016d3:	ff 36                	pushl  (%esi)
  8016d5:	e8 4e ff ff ff       	call   801628 <dev_lookup>
  8016da:	89 c3                	mov    %eax,%ebx
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 1a                	js     8016fd <fd_close+0x7b>
		if (dev->dev_close)
  8016e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016e9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	74 0b                	je     8016fd <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	56                   	push   %esi
  8016f6:	ff d0                	call   *%eax
  8016f8:	89 c3                	mov    %eax,%ebx
  8016fa:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	56                   	push   %esi
  801701:	6a 00                	push   $0x0
  801703:	e8 a9 fb ff ff       	call   8012b1 <sys_page_unmap>
	return r;
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	eb b5                	jmp    8016c2 <fd_close+0x40>

0080170d <close>:

int
close(int fdnum)
{
  80170d:	f3 0f 1e fb          	endbr32 
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801717:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171a:	50                   	push   %eax
  80171b:	ff 75 08             	pushl  0x8(%ebp)
  80171e:	e8 b1 fe ff ff       	call   8015d4 <fd_lookup>
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	85 c0                	test   %eax,%eax
  801728:	79 02                	jns    80172c <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    
		return fd_close(fd, 1);
  80172c:	83 ec 08             	sub    $0x8,%esp
  80172f:	6a 01                	push   $0x1
  801731:	ff 75 f4             	pushl  -0xc(%ebp)
  801734:	e8 49 ff ff ff       	call   801682 <fd_close>
  801739:	83 c4 10             	add    $0x10,%esp
  80173c:	eb ec                	jmp    80172a <close+0x1d>

0080173e <close_all>:

void
close_all(void)
{
  80173e:	f3 0f 1e fb          	endbr32 
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	53                   	push   %ebx
  801746:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801749:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	53                   	push   %ebx
  801752:	e8 b6 ff ff ff       	call   80170d <close>
	for (i = 0; i < MAXFD; i++)
  801757:	83 c3 01             	add    $0x1,%ebx
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	83 fb 20             	cmp    $0x20,%ebx
  801760:	75 ec                	jne    80174e <close_all+0x10>
}
  801762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801767:	f3 0f 1e fb          	endbr32 
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	57                   	push   %edi
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801774:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801777:	50                   	push   %eax
  801778:	ff 75 08             	pushl  0x8(%ebp)
  80177b:	e8 54 fe ff ff       	call   8015d4 <fd_lookup>
  801780:	89 c3                	mov    %eax,%ebx
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	0f 88 81 00 00 00    	js     80180e <dup+0xa7>
		return r;
	close(newfdnum);
  80178d:	83 ec 0c             	sub    $0xc,%esp
  801790:	ff 75 0c             	pushl  0xc(%ebp)
  801793:	e8 75 ff ff ff       	call   80170d <close>

	newfd = INDEX2FD(newfdnum);
  801798:	8b 75 0c             	mov    0xc(%ebp),%esi
  80179b:	c1 e6 0c             	shl    $0xc,%esi
  80179e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017a4:	83 c4 04             	add    $0x4,%esp
  8017a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017aa:	e8 b4 fd ff ff       	call   801563 <fd2data>
  8017af:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017b1:	89 34 24             	mov    %esi,(%esp)
  8017b4:	e8 aa fd ff ff       	call   801563 <fd2data>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017be:	89 d8                	mov    %ebx,%eax
  8017c0:	c1 e8 16             	shr    $0x16,%eax
  8017c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017ca:	a8 01                	test   $0x1,%al
  8017cc:	74 11                	je     8017df <dup+0x78>
  8017ce:	89 d8                	mov    %ebx,%eax
  8017d0:	c1 e8 0c             	shr    $0xc,%eax
  8017d3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017da:	f6 c2 01             	test   $0x1,%dl
  8017dd:	75 39                	jne    801818 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	c1 e8 0c             	shr    $0xc,%eax
  8017e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017ee:	83 ec 0c             	sub    $0xc,%esp
  8017f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8017f6:	50                   	push   %eax
  8017f7:	56                   	push   %esi
  8017f8:	6a 00                	push   $0x0
  8017fa:	52                   	push   %edx
  8017fb:	6a 00                	push   $0x0
  8017fd:	e8 69 fa ff ff       	call   80126b <sys_page_map>
  801802:	89 c3                	mov    %eax,%ebx
  801804:	83 c4 20             	add    $0x20,%esp
  801807:	85 c0                	test   %eax,%eax
  801809:	78 31                	js     80183c <dup+0xd5>
		goto err;

	return newfdnum;
  80180b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80180e:	89 d8                	mov    %ebx,%eax
  801810:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5f                   	pop    %edi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801818:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	25 07 0e 00 00       	and    $0xe07,%eax
  801827:	50                   	push   %eax
  801828:	57                   	push   %edi
  801829:	6a 00                	push   $0x0
  80182b:	53                   	push   %ebx
  80182c:	6a 00                	push   $0x0
  80182e:	e8 38 fa ff ff       	call   80126b <sys_page_map>
  801833:	89 c3                	mov    %eax,%ebx
  801835:	83 c4 20             	add    $0x20,%esp
  801838:	85 c0                	test   %eax,%eax
  80183a:	79 a3                	jns    8017df <dup+0x78>
	sys_page_unmap(0, newfd);
  80183c:	83 ec 08             	sub    $0x8,%esp
  80183f:	56                   	push   %esi
  801840:	6a 00                	push   $0x0
  801842:	e8 6a fa ff ff       	call   8012b1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801847:	83 c4 08             	add    $0x8,%esp
  80184a:	57                   	push   %edi
  80184b:	6a 00                	push   $0x0
  80184d:	e8 5f fa ff ff       	call   8012b1 <sys_page_unmap>
	return r;
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	eb b7                	jmp    80180e <dup+0xa7>

00801857 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801857:	f3 0f 1e fb          	endbr32 
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	53                   	push   %ebx
  80185f:	83 ec 1c             	sub    $0x1c,%esp
  801862:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801865:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801868:	50                   	push   %eax
  801869:	53                   	push   %ebx
  80186a:	e8 65 fd ff ff       	call   8015d4 <fd_lookup>
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	85 c0                	test   %eax,%eax
  801874:	78 3f                	js     8018b5 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801876:	83 ec 08             	sub    $0x8,%esp
  801879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187c:	50                   	push   %eax
  80187d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801880:	ff 30                	pushl  (%eax)
  801882:	e8 a1 fd ff ff       	call   801628 <dev_lookup>
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 27                	js     8018b5 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80188e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801891:	8b 42 08             	mov    0x8(%edx),%eax
  801894:	83 e0 03             	and    $0x3,%eax
  801897:	83 f8 01             	cmp    $0x1,%eax
  80189a:	74 1e                	je     8018ba <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189f:	8b 40 08             	mov    0x8(%eax),%eax
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	74 35                	je     8018db <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	ff 75 10             	pushl  0x10(%ebp)
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	52                   	push   %edx
  8018b0:	ff d0                	call   *%eax
  8018b2:	83 c4 10             	add    $0x10,%esp
}
  8018b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ba:	a1 04 40 80 00       	mov    0x804004,%eax
  8018bf:	8b 40 48             	mov    0x48(%eax),%eax
  8018c2:	83 ec 04             	sub    $0x4,%esp
  8018c5:	53                   	push   %ebx
  8018c6:	50                   	push   %eax
  8018c7:	68 d1 2c 80 00       	push   $0x802cd1
  8018cc:	e8 07 ef ff ff       	call   8007d8 <cprintf>
		return -E_INVAL;
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d9:	eb da                	jmp    8018b5 <read+0x5e>
		return -E_NOT_SUPP;
  8018db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e0:	eb d3                	jmp    8018b5 <read+0x5e>

008018e2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018e2:	f3 0f 1e fb          	endbr32 
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	57                   	push   %edi
  8018ea:	56                   	push   %esi
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 0c             	sub    $0xc,%esp
  8018ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018f2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018fa:	eb 02                	jmp    8018fe <readn+0x1c>
  8018fc:	01 c3                	add    %eax,%ebx
  8018fe:	39 f3                	cmp    %esi,%ebx
  801900:	73 21                	jae    801923 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	89 f0                	mov    %esi,%eax
  801907:	29 d8                	sub    %ebx,%eax
  801909:	50                   	push   %eax
  80190a:	89 d8                	mov    %ebx,%eax
  80190c:	03 45 0c             	add    0xc(%ebp),%eax
  80190f:	50                   	push   %eax
  801910:	57                   	push   %edi
  801911:	e8 41 ff ff ff       	call   801857 <read>
		if (m < 0)
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 04                	js     801921 <readn+0x3f>
			return m;
		if (m == 0)
  80191d:	75 dd                	jne    8018fc <readn+0x1a>
  80191f:	eb 02                	jmp    801923 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801921:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801923:	89 d8                	mov    %ebx,%eax
  801925:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801928:	5b                   	pop    %ebx
  801929:	5e                   	pop    %esi
  80192a:	5f                   	pop    %edi
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    

0080192d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80192d:	f3 0f 1e fb          	endbr32 
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	53                   	push   %ebx
  801935:	83 ec 1c             	sub    $0x1c,%esp
  801938:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80193b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80193e:	50                   	push   %eax
  80193f:	53                   	push   %ebx
  801940:	e8 8f fc ff ff       	call   8015d4 <fd_lookup>
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	85 c0                	test   %eax,%eax
  80194a:	78 3a                	js     801986 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80194c:	83 ec 08             	sub    $0x8,%esp
  80194f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801952:	50                   	push   %eax
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	ff 30                	pushl  (%eax)
  801958:	e8 cb fc ff ff       	call   801628 <dev_lookup>
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	85 c0                	test   %eax,%eax
  801962:	78 22                	js     801986 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801967:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80196b:	74 1e                	je     80198b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80196d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801970:	8b 52 0c             	mov    0xc(%edx),%edx
  801973:	85 d2                	test   %edx,%edx
  801975:	74 35                	je     8019ac <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	ff 75 10             	pushl  0x10(%ebp)
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	50                   	push   %eax
  801981:	ff d2                	call   *%edx
  801983:	83 c4 10             	add    $0x10,%esp
}
  801986:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801989:	c9                   	leave  
  80198a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80198b:	a1 04 40 80 00       	mov    0x804004,%eax
  801990:	8b 40 48             	mov    0x48(%eax),%eax
  801993:	83 ec 04             	sub    $0x4,%esp
  801996:	53                   	push   %ebx
  801997:	50                   	push   %eax
  801998:	68 ed 2c 80 00       	push   $0x802ced
  80199d:	e8 36 ee ff ff       	call   8007d8 <cprintf>
		return -E_INVAL;
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019aa:	eb da                	jmp    801986 <write+0x59>
		return -E_NOT_SUPP;
  8019ac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b1:	eb d3                	jmp    801986 <write+0x59>

008019b3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019b3:	f3 0f 1e fb          	endbr32 
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c0:	50                   	push   %eax
  8019c1:	ff 75 08             	pushl  0x8(%ebp)
  8019c4:	e8 0b fc ff ff       	call   8015d4 <fd_lookup>
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	78 0e                	js     8019de <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8019d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019e0:	f3 0f 1e fb          	endbr32 
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 1c             	sub    $0x1c,%esp
  8019eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f1:	50                   	push   %eax
  8019f2:	53                   	push   %ebx
  8019f3:	e8 dc fb ff ff       	call   8015d4 <fd_lookup>
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 37                	js     801a36 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a05:	50                   	push   %eax
  801a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a09:	ff 30                	pushl  (%eax)
  801a0b:	e8 18 fc ff ff       	call   801628 <dev_lookup>
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 1f                	js     801a36 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a1e:	74 1b                	je     801a3b <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a23:	8b 52 18             	mov    0x18(%edx),%edx
  801a26:	85 d2                	test   %edx,%edx
  801a28:	74 32                	je     801a5c <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	50                   	push   %eax
  801a31:	ff d2                	call   *%edx
  801a33:	83 c4 10             	add    $0x10,%esp
}
  801a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a3b:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a40:	8b 40 48             	mov    0x48(%eax),%eax
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	53                   	push   %ebx
  801a47:	50                   	push   %eax
  801a48:	68 b0 2c 80 00       	push   $0x802cb0
  801a4d:	e8 86 ed ff ff       	call   8007d8 <cprintf>
		return -E_INVAL;
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5a:	eb da                	jmp    801a36 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801a5c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a61:	eb d3                	jmp    801a36 <ftruncate+0x56>

00801a63 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a63:	f3 0f 1e fb          	endbr32 
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	53                   	push   %ebx
  801a6b:	83 ec 1c             	sub    $0x1c,%esp
  801a6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a74:	50                   	push   %eax
  801a75:	ff 75 08             	pushl  0x8(%ebp)
  801a78:	e8 57 fb ff ff       	call   8015d4 <fd_lookup>
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 4b                	js     801acf <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a84:	83 ec 08             	sub    $0x8,%esp
  801a87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8a:	50                   	push   %eax
  801a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8e:	ff 30                	pushl  (%eax)
  801a90:	e8 93 fb ff ff       	call   801628 <dev_lookup>
  801a95:	83 c4 10             	add    $0x10,%esp
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	78 33                	js     801acf <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801aa3:	74 2f                	je     801ad4 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aa5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801aa8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801aaf:	00 00 00 
	stat->st_isdir = 0;
  801ab2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ab9:	00 00 00 
	stat->st_dev = dev;
  801abc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ac2:	83 ec 08             	sub    $0x8,%esp
  801ac5:	53                   	push   %ebx
  801ac6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac9:	ff 50 14             	call   *0x14(%eax)
  801acc:	83 c4 10             	add    $0x10,%esp
}
  801acf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    
		return -E_NOT_SUPP;
  801ad4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad9:	eb f4                	jmp    801acf <fstat+0x6c>

00801adb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801adb:	f3 0f 1e fb          	endbr32 
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	6a 00                	push   $0x0
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	e8 fb 01 00 00       	call   801cec <open>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 1b                	js     801b15 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	50                   	push   %eax
  801b01:	e8 5d ff ff ff       	call   801a63 <fstat>
  801b06:	89 c6                	mov    %eax,%esi
	close(fd);
  801b08:	89 1c 24             	mov    %ebx,(%esp)
  801b0b:	e8 fd fb ff ff       	call   80170d <close>
	return r;
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	89 f3                	mov    %esi,%ebx
}
  801b15:	89 d8                	mov    %ebx,%eax
  801b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1a:	5b                   	pop    %ebx
  801b1b:	5e                   	pop    %esi
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    

00801b1e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	56                   	push   %esi
  801b22:	53                   	push   %ebx
  801b23:	89 c6                	mov    %eax,%esi
  801b25:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b27:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b2e:	74 27                	je     801b57 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b30:	6a 07                	push   $0x7
  801b32:	68 00 50 80 00       	push   $0x805000
  801b37:	56                   	push   %esi
  801b38:	ff 35 00 40 80 00    	pushl  0x804000
  801b3e:	e8 77 f9 ff ff       	call   8014ba <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b43:	83 c4 0c             	add    $0xc,%esp
  801b46:	6a 00                	push   $0x0
  801b48:	53                   	push   %ebx
  801b49:	6a 00                	push   $0x0
  801b4b:	e8 e5 f8 ff ff       	call   801435 <ipc_recv>
}
  801b50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5d                   	pop    %ebp
  801b56:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	6a 01                	push   $0x1
  801b5c:	e8 b1 f9 ff ff       	call   801512 <ipc_find_env>
  801b61:	a3 00 40 80 00       	mov    %eax,0x804000
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	eb c5                	jmp    801b30 <fsipc+0x12>

00801b6b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b6b:	f3 0f 1e fb          	endbr32 
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b88:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8d:	b8 02 00 00 00       	mov    $0x2,%eax
  801b92:	e8 87 ff ff ff       	call   801b1e <fsipc>
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <devfile_flush>:
{
  801b99:	f3 0f 1e fb          	endbr32 
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba9:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801bae:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb3:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb8:	e8 61 ff ff ff       	call   801b1e <fsipc>
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <devfile_stat>:
{
  801bbf:	f3 0f 1e fb          	endbr32 
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bdd:	b8 05 00 00 00       	mov    $0x5,%eax
  801be2:	e8 37 ff ff ff       	call   801b1e <fsipc>
  801be7:	85 c0                	test   %eax,%eax
  801be9:	78 2c                	js     801c17 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801beb:	83 ec 08             	sub    $0x8,%esp
  801bee:	68 00 50 80 00       	push   $0x805000
  801bf3:	53                   	push   %ebx
  801bf4:	e8 e9 f1 ff ff       	call   800de2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bf9:	a1 80 50 80 00       	mov    0x805080,%eax
  801bfe:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c04:	a1 84 50 80 00       	mov    0x805084,%eax
  801c09:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <devfile_write>:
{
  801c1c:	f3 0f 1e fb          	endbr32 
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 0c             	sub    $0xc,%esp
  801c26:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c29:	8b 55 08             	mov    0x8(%ebp),%edx
  801c2c:	8b 52 0c             	mov    0xc(%edx),%edx
  801c2f:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801c35:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801c3a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801c3f:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801c42:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801c47:	50                   	push   %eax
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	68 08 50 80 00       	push   $0x805008
  801c50:	e8 43 f3 ff ff       	call   800f98 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801c55:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5a:	b8 04 00 00 00       	mov    $0x4,%eax
  801c5f:	e8 ba fe ff ff       	call   801b1e <fsipc>
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <devfile_read>:
{
  801c66:	f3 0f 1e fb          	endbr32 
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	56                   	push   %esi
  801c6e:	53                   	push   %ebx
  801c6f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8b 40 0c             	mov    0xc(%eax),%eax
  801c78:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c7d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c83:	ba 00 00 00 00       	mov    $0x0,%edx
  801c88:	b8 03 00 00 00       	mov    $0x3,%eax
  801c8d:	e8 8c fe ff ff       	call   801b1e <fsipc>
  801c92:	89 c3                	mov    %eax,%ebx
  801c94:	85 c0                	test   %eax,%eax
  801c96:	78 1f                	js     801cb7 <devfile_read+0x51>
	assert(r <= n);
  801c98:	39 f0                	cmp    %esi,%eax
  801c9a:	77 24                	ja     801cc0 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801c9c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ca1:	7f 33                	jg     801cd6 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ca3:	83 ec 04             	sub    $0x4,%esp
  801ca6:	50                   	push   %eax
  801ca7:	68 00 50 80 00       	push   $0x805000
  801cac:	ff 75 0c             	pushl  0xc(%ebp)
  801caf:	e8 e4 f2 ff ff       	call   800f98 <memmove>
	return r;
  801cb4:	83 c4 10             	add    $0x10,%esp
}
  801cb7:	89 d8                	mov    %ebx,%eax
  801cb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbc:	5b                   	pop    %ebx
  801cbd:	5e                   	pop    %esi
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    
	assert(r <= n);
  801cc0:	68 1c 2d 80 00       	push   $0x802d1c
  801cc5:	68 23 2d 80 00       	push   $0x802d23
  801cca:	6a 7c                	push   $0x7c
  801ccc:	68 38 2d 80 00       	push   $0x802d38
  801cd1:	e8 1b ea ff ff       	call   8006f1 <_panic>
	assert(r <= PGSIZE);
  801cd6:	68 43 2d 80 00       	push   $0x802d43
  801cdb:	68 23 2d 80 00       	push   $0x802d23
  801ce0:	6a 7d                	push   $0x7d
  801ce2:	68 38 2d 80 00       	push   $0x802d38
  801ce7:	e8 05 ea ff ff       	call   8006f1 <_panic>

00801cec <open>:
{
  801cec:	f3 0f 1e fb          	endbr32 
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	56                   	push   %esi
  801cf4:	53                   	push   %ebx
  801cf5:	83 ec 1c             	sub    $0x1c,%esp
  801cf8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cfb:	56                   	push   %esi
  801cfc:	e8 9e f0 ff ff       	call   800d9f <strlen>
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d09:	7f 6c                	jg     801d77 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801d0b:	83 ec 0c             	sub    $0xc,%esp
  801d0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d11:	50                   	push   %eax
  801d12:	e8 67 f8 ff ff       	call   80157e <fd_alloc>
  801d17:	89 c3                	mov    %eax,%ebx
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	78 3c                	js     801d5c <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801d20:	83 ec 08             	sub    $0x8,%esp
  801d23:	56                   	push   %esi
  801d24:	68 00 50 80 00       	push   $0x805000
  801d29:	e8 b4 f0 ff ff       	call   800de2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d31:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d39:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3e:	e8 db fd ff ff       	call   801b1e <fsipc>
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 19                	js     801d65 <open+0x79>
	return fd2num(fd);
  801d4c:	83 ec 0c             	sub    $0xc,%esp
  801d4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d52:	e8 f8 f7 ff ff       	call   80154f <fd2num>
  801d57:	89 c3                	mov    %eax,%ebx
  801d59:	83 c4 10             	add    $0x10,%esp
}
  801d5c:	89 d8                	mov    %ebx,%eax
  801d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d61:	5b                   	pop    %ebx
  801d62:	5e                   	pop    %esi
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    
		fd_close(fd, 0);
  801d65:	83 ec 08             	sub    $0x8,%esp
  801d68:	6a 00                	push   $0x0
  801d6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6d:	e8 10 f9 ff ff       	call   801682 <fd_close>
		return r;
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	eb e5                	jmp    801d5c <open+0x70>
		return -E_BAD_PATH;
  801d77:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d7c:	eb de                	jmp    801d5c <open+0x70>

00801d7e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d7e:	f3 0f 1e fb          	endbr32 
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d88:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8d:	b8 08 00 00 00       	mov    $0x8,%eax
  801d92:	e8 87 fd ff ff       	call   801b1e <fsipc>
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d99:	f3 0f 1e fb          	endbr32 
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	56                   	push   %esi
  801da1:	53                   	push   %ebx
  801da2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801da5:	83 ec 0c             	sub    $0xc,%esp
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	e8 b3 f7 ff ff       	call   801563 <fd2data>
  801db0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801db2:	83 c4 08             	add    $0x8,%esp
  801db5:	68 4f 2d 80 00       	push   $0x802d4f
  801dba:	53                   	push   %ebx
  801dbb:	e8 22 f0 ff ff       	call   800de2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dc0:	8b 46 04             	mov    0x4(%esi),%eax
  801dc3:	2b 06                	sub    (%esi),%eax
  801dc5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dcb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dd2:	00 00 00 
	stat->st_dev = &devpipe;
  801dd5:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801ddc:	30 80 00 
	return 0;
}
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  801de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    

00801deb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801deb:	f3 0f 1e fb          	endbr32 
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	53                   	push   %ebx
  801df3:	83 ec 0c             	sub    $0xc,%esp
  801df6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801df9:	53                   	push   %ebx
  801dfa:	6a 00                	push   $0x0
  801dfc:	e8 b0 f4 ff ff       	call   8012b1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e01:	89 1c 24             	mov    %ebx,(%esp)
  801e04:	e8 5a f7 ff ff       	call   801563 <fd2data>
  801e09:	83 c4 08             	add    $0x8,%esp
  801e0c:	50                   	push   %eax
  801e0d:	6a 00                	push   $0x0
  801e0f:	e8 9d f4 ff ff       	call   8012b1 <sys_page_unmap>
}
  801e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <_pipeisclosed>:
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	57                   	push   %edi
  801e1d:	56                   	push   %esi
  801e1e:	53                   	push   %ebx
  801e1f:	83 ec 1c             	sub    $0x1c,%esp
  801e22:	89 c7                	mov    %eax,%edi
  801e24:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e26:	a1 04 40 80 00       	mov    0x804004,%eax
  801e2b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e2e:	83 ec 0c             	sub    $0xc,%esp
  801e31:	57                   	push   %edi
  801e32:	e8 5d 04 00 00       	call   802294 <pageref>
  801e37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e3a:	89 34 24             	mov    %esi,(%esp)
  801e3d:	e8 52 04 00 00       	call   802294 <pageref>
		nn = thisenv->env_runs;
  801e42:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e48:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	39 cb                	cmp    %ecx,%ebx
  801e50:	74 1b                	je     801e6d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e52:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e55:	75 cf                	jne    801e26 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e57:	8b 42 58             	mov    0x58(%edx),%eax
  801e5a:	6a 01                	push   $0x1
  801e5c:	50                   	push   %eax
  801e5d:	53                   	push   %ebx
  801e5e:	68 56 2d 80 00       	push   $0x802d56
  801e63:	e8 70 e9 ff ff       	call   8007d8 <cprintf>
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	eb b9                	jmp    801e26 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e6d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e70:	0f 94 c0             	sete   %al
  801e73:	0f b6 c0             	movzbl %al,%eax
}
  801e76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e79:	5b                   	pop    %ebx
  801e7a:	5e                   	pop    %esi
  801e7b:	5f                   	pop    %edi
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <devpipe_write>:
{
  801e7e:	f3 0f 1e fb          	endbr32 
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	57                   	push   %edi
  801e86:	56                   	push   %esi
  801e87:	53                   	push   %ebx
  801e88:	83 ec 28             	sub    $0x28,%esp
  801e8b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e8e:	56                   	push   %esi
  801e8f:	e8 cf f6 ff ff       	call   801563 <fd2data>
  801e94:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	bf 00 00 00 00       	mov    $0x0,%edi
  801e9e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ea1:	74 4f                	je     801ef2 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ea3:	8b 43 04             	mov    0x4(%ebx),%eax
  801ea6:	8b 0b                	mov    (%ebx),%ecx
  801ea8:	8d 51 20             	lea    0x20(%ecx),%edx
  801eab:	39 d0                	cmp    %edx,%eax
  801ead:	72 14                	jb     801ec3 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801eaf:	89 da                	mov    %ebx,%edx
  801eb1:	89 f0                	mov    %esi,%eax
  801eb3:	e8 61 ff ff ff       	call   801e19 <_pipeisclosed>
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	75 3b                	jne    801ef7 <devpipe_write+0x79>
			sys_yield();
  801ebc:	e8 40 f3 ff ff       	call   801201 <sys_yield>
  801ec1:	eb e0                	jmp    801ea3 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ec6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eca:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ecd:	89 c2                	mov    %eax,%edx
  801ecf:	c1 fa 1f             	sar    $0x1f,%edx
  801ed2:	89 d1                	mov    %edx,%ecx
  801ed4:	c1 e9 1b             	shr    $0x1b,%ecx
  801ed7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801eda:	83 e2 1f             	and    $0x1f,%edx
  801edd:	29 ca                	sub    %ecx,%edx
  801edf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ee3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ee7:	83 c0 01             	add    $0x1,%eax
  801eea:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801eed:	83 c7 01             	add    $0x1,%edi
  801ef0:	eb ac                	jmp    801e9e <devpipe_write+0x20>
	return i;
  801ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef5:	eb 05                	jmp    801efc <devpipe_write+0x7e>
				return 0;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5f                   	pop    %edi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    

00801f04 <devpipe_read>:
{
  801f04:	f3 0f 1e fb          	endbr32 
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	57                   	push   %edi
  801f0c:	56                   	push   %esi
  801f0d:	53                   	push   %ebx
  801f0e:	83 ec 18             	sub    $0x18,%esp
  801f11:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f14:	57                   	push   %edi
  801f15:	e8 49 f6 ff ff       	call   801563 <fd2data>
  801f1a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	be 00 00 00 00       	mov    $0x0,%esi
  801f24:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f27:	75 14                	jne    801f3d <devpipe_read+0x39>
	return i;
  801f29:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2c:	eb 02                	jmp    801f30 <devpipe_read+0x2c>
				return i;
  801f2e:	89 f0                	mov    %esi,%eax
}
  801f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f33:	5b                   	pop    %ebx
  801f34:	5e                   	pop    %esi
  801f35:	5f                   	pop    %edi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    
			sys_yield();
  801f38:	e8 c4 f2 ff ff       	call   801201 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f3d:	8b 03                	mov    (%ebx),%eax
  801f3f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f42:	75 18                	jne    801f5c <devpipe_read+0x58>
			if (i > 0)
  801f44:	85 f6                	test   %esi,%esi
  801f46:	75 e6                	jne    801f2e <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801f48:	89 da                	mov    %ebx,%edx
  801f4a:	89 f8                	mov    %edi,%eax
  801f4c:	e8 c8 fe ff ff       	call   801e19 <_pipeisclosed>
  801f51:	85 c0                	test   %eax,%eax
  801f53:	74 e3                	je     801f38 <devpipe_read+0x34>
				return 0;
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5a:	eb d4                	jmp    801f30 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f5c:	99                   	cltd   
  801f5d:	c1 ea 1b             	shr    $0x1b,%edx
  801f60:	01 d0                	add    %edx,%eax
  801f62:	83 e0 1f             	and    $0x1f,%eax
  801f65:	29 d0                	sub    %edx,%eax
  801f67:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f6f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f72:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f75:	83 c6 01             	add    $0x1,%esi
  801f78:	eb aa                	jmp    801f24 <devpipe_read+0x20>

00801f7a <pipe>:
{
  801f7a:	f3 0f 1e fb          	endbr32 
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	56                   	push   %esi
  801f82:	53                   	push   %ebx
  801f83:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f89:	50                   	push   %eax
  801f8a:	e8 ef f5 ff ff       	call   80157e <fd_alloc>
  801f8f:	89 c3                	mov    %eax,%ebx
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	85 c0                	test   %eax,%eax
  801f96:	0f 88 23 01 00 00    	js     8020bf <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	68 07 04 00 00       	push   $0x407
  801fa4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa7:	6a 00                	push   $0x0
  801fa9:	e8 76 f2 ff ff       	call   801224 <sys_page_alloc>
  801fae:	89 c3                	mov    %eax,%ebx
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	0f 88 04 01 00 00    	js     8020bf <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801fbb:	83 ec 0c             	sub    $0xc,%esp
  801fbe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fc1:	50                   	push   %eax
  801fc2:	e8 b7 f5 ff ff       	call   80157e <fd_alloc>
  801fc7:	89 c3                	mov    %eax,%ebx
  801fc9:	83 c4 10             	add    $0x10,%esp
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	0f 88 db 00 00 00    	js     8020af <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd4:	83 ec 04             	sub    $0x4,%esp
  801fd7:	68 07 04 00 00       	push   $0x407
  801fdc:	ff 75 f0             	pushl  -0x10(%ebp)
  801fdf:	6a 00                	push   $0x0
  801fe1:	e8 3e f2 ff ff       	call   801224 <sys_page_alloc>
  801fe6:	89 c3                	mov    %eax,%ebx
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	85 c0                	test   %eax,%eax
  801fed:	0f 88 bc 00 00 00    	js     8020af <pipe+0x135>
	va = fd2data(fd0);
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff9:	e8 65 f5 ff ff       	call   801563 <fd2data>
  801ffe:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802000:	83 c4 0c             	add    $0xc,%esp
  802003:	68 07 04 00 00       	push   $0x407
  802008:	50                   	push   %eax
  802009:	6a 00                	push   $0x0
  80200b:	e8 14 f2 ff ff       	call   801224 <sys_page_alloc>
  802010:	89 c3                	mov    %eax,%ebx
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	85 c0                	test   %eax,%eax
  802017:	0f 88 82 00 00 00    	js     80209f <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	ff 75 f0             	pushl  -0x10(%ebp)
  802023:	e8 3b f5 ff ff       	call   801563 <fd2data>
  802028:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80202f:	50                   	push   %eax
  802030:	6a 00                	push   $0x0
  802032:	56                   	push   %esi
  802033:	6a 00                	push   $0x0
  802035:	e8 31 f2 ff ff       	call   80126b <sys_page_map>
  80203a:	89 c3                	mov    %eax,%ebx
  80203c:	83 c4 20             	add    $0x20,%esp
  80203f:	85 c0                	test   %eax,%eax
  802041:	78 4e                	js     802091 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802043:	a1 24 30 80 00       	mov    0x803024,%eax
  802048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80204d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802050:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80205a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80205c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802066:	83 ec 0c             	sub    $0xc,%esp
  802069:	ff 75 f4             	pushl  -0xc(%ebp)
  80206c:	e8 de f4 ff ff       	call   80154f <fd2num>
  802071:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802074:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802076:	83 c4 04             	add    $0x4,%esp
  802079:	ff 75 f0             	pushl  -0x10(%ebp)
  80207c:	e8 ce f4 ff ff       	call   80154f <fd2num>
  802081:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802084:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802087:	83 c4 10             	add    $0x10,%esp
  80208a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80208f:	eb 2e                	jmp    8020bf <pipe+0x145>
	sys_page_unmap(0, va);
  802091:	83 ec 08             	sub    $0x8,%esp
  802094:	56                   	push   %esi
  802095:	6a 00                	push   $0x0
  802097:	e8 15 f2 ff ff       	call   8012b1 <sys_page_unmap>
  80209c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80209f:	83 ec 08             	sub    $0x8,%esp
  8020a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a5:	6a 00                	push   $0x0
  8020a7:	e8 05 f2 ff ff       	call   8012b1 <sys_page_unmap>
  8020ac:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020af:	83 ec 08             	sub    $0x8,%esp
  8020b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b5:	6a 00                	push   $0x0
  8020b7:	e8 f5 f1 ff ff       	call   8012b1 <sys_page_unmap>
  8020bc:	83 c4 10             	add    $0x10,%esp
}
  8020bf:	89 d8                	mov    %ebx,%eax
  8020c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c4:	5b                   	pop    %ebx
  8020c5:	5e                   	pop    %esi
  8020c6:	5d                   	pop    %ebp
  8020c7:	c3                   	ret    

008020c8 <pipeisclosed>:
{
  8020c8:	f3 0f 1e fb          	endbr32 
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d5:	50                   	push   %eax
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	e8 f6 f4 ff ff       	call   8015d4 <fd_lookup>
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	78 18                	js     8020fd <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8020e5:	83 ec 0c             	sub    $0xc,%esp
  8020e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020eb:	e8 73 f4 ff ff       	call   801563 <fd2data>
  8020f0:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	e8 1f fd ff ff       	call   801e19 <_pipeisclosed>
  8020fa:	83 c4 10             	add    $0x10,%esp
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020ff:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	c3                   	ret    

00802109 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802109:	f3 0f 1e fb          	endbr32 
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802113:	68 6e 2d 80 00       	push   $0x802d6e
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	e8 c2 ec ff ff       	call   800de2 <strcpy>
	return 0;
}
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <devcons_write>:
{
  802127:	f3 0f 1e fb          	endbr32 
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	57                   	push   %edi
  80212f:	56                   	push   %esi
  802130:	53                   	push   %ebx
  802131:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802137:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80213c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802142:	3b 75 10             	cmp    0x10(%ebp),%esi
  802145:	73 31                	jae    802178 <devcons_write+0x51>
		m = n - tot;
  802147:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80214a:	29 f3                	sub    %esi,%ebx
  80214c:	83 fb 7f             	cmp    $0x7f,%ebx
  80214f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802154:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802157:	83 ec 04             	sub    $0x4,%esp
  80215a:	53                   	push   %ebx
  80215b:	89 f0                	mov    %esi,%eax
  80215d:	03 45 0c             	add    0xc(%ebp),%eax
  802160:	50                   	push   %eax
  802161:	57                   	push   %edi
  802162:	e8 31 ee ff ff       	call   800f98 <memmove>
		sys_cputs(buf, m);
  802167:	83 c4 08             	add    $0x8,%esp
  80216a:	53                   	push   %ebx
  80216b:	57                   	push   %edi
  80216c:	e8 e3 ef ff ff       	call   801154 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802171:	01 de                	add    %ebx,%esi
  802173:	83 c4 10             	add    $0x10,%esp
  802176:	eb ca                	jmp    802142 <devcons_write+0x1b>
}
  802178:	89 f0                	mov    %esi,%eax
  80217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5f                   	pop    %edi
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    

00802182 <devcons_read>:
{
  802182:	f3 0f 1e fb          	endbr32 
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 08             	sub    $0x8,%esp
  80218c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802191:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802195:	74 21                	je     8021b8 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802197:	e8 da ef ff ff       	call   801176 <sys_cgetc>
  80219c:	85 c0                	test   %eax,%eax
  80219e:	75 07                	jne    8021a7 <devcons_read+0x25>
		sys_yield();
  8021a0:	e8 5c f0 ff ff       	call   801201 <sys_yield>
  8021a5:	eb f0                	jmp    802197 <devcons_read+0x15>
	if (c < 0)
  8021a7:	78 0f                	js     8021b8 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8021a9:	83 f8 04             	cmp    $0x4,%eax
  8021ac:	74 0c                	je     8021ba <devcons_read+0x38>
	*(char*)vbuf = c;
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	88 02                	mov    %al,(%edx)
	return 1;
  8021b3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    
		return 0;
  8021ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bf:	eb f7                	jmp    8021b8 <devcons_read+0x36>

008021c1 <cputchar>:
{
  8021c1:	f3 0f 1e fb          	endbr32 
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021d1:	6a 01                	push   $0x1
  8021d3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021d6:	50                   	push   %eax
  8021d7:	e8 78 ef ff ff       	call   801154 <sys_cputs>
}
  8021dc:	83 c4 10             	add    $0x10,%esp
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <getchar>:
{
  8021e1:	f3 0f 1e fb          	endbr32 
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021eb:	6a 01                	push   $0x1
  8021ed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f0:	50                   	push   %eax
  8021f1:	6a 00                	push   $0x0
  8021f3:	e8 5f f6 ff ff       	call   801857 <read>
	if (r < 0)
  8021f8:	83 c4 10             	add    $0x10,%esp
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	78 06                	js     802205 <getchar+0x24>
	if (r < 1)
  8021ff:	74 06                	je     802207 <getchar+0x26>
	return c;
  802201:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    
		return -E_EOF;
  802207:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80220c:	eb f7                	jmp    802205 <getchar+0x24>

0080220e <iscons>:
{
  80220e:	f3 0f 1e fb          	endbr32 
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802218:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80221b:	50                   	push   %eax
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	e8 b0 f3 ff ff       	call   8015d4 <fd_lookup>
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	85 c0                	test   %eax,%eax
  802229:	78 11                	js     80223c <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802234:	39 10                	cmp    %edx,(%eax)
  802236:	0f 94 c0             	sete   %al
  802239:	0f b6 c0             	movzbl %al,%eax
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <opencons>:
{
  80223e:	f3 0f 1e fb          	endbr32 
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802248:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80224b:	50                   	push   %eax
  80224c:	e8 2d f3 ff ff       	call   80157e <fd_alloc>
  802251:	83 c4 10             	add    $0x10,%esp
  802254:	85 c0                	test   %eax,%eax
  802256:	78 3a                	js     802292 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802258:	83 ec 04             	sub    $0x4,%esp
  80225b:	68 07 04 00 00       	push   $0x407
  802260:	ff 75 f4             	pushl  -0xc(%ebp)
  802263:	6a 00                	push   $0x0
  802265:	e8 ba ef ff ff       	call   801224 <sys_page_alloc>
  80226a:	83 c4 10             	add    $0x10,%esp
  80226d:	85 c0                	test   %eax,%eax
  80226f:	78 21                	js     802292 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802274:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80227a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802286:	83 ec 0c             	sub    $0xc,%esp
  802289:	50                   	push   %eax
  80228a:	e8 c0 f2 ff ff       	call   80154f <fd2num>
  80228f:	83 c4 10             	add    $0x10,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802294:	f3 0f 1e fb          	endbr32 
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80229e:	89 c2                	mov    %eax,%edx
  8022a0:	c1 ea 16             	shr    $0x16,%edx
  8022a3:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022aa:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022af:	f6 c1 01             	test   $0x1,%cl
  8022b2:	74 1c                	je     8022d0 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8022b4:	c1 e8 0c             	shr    $0xc,%eax
  8022b7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022be:	a8 01                	test   $0x1,%al
  8022c0:	74 0e                	je     8022d0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022c2:	c1 e8 0c             	shr    $0xc,%eax
  8022c5:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022cc:	ef 
  8022cd:	0f b7 d2             	movzwl %dx,%edx
}
  8022d0:	89 d0                	mov    %edx,%eax
  8022d2:	5d                   	pop    %ebp
  8022d3:	c3                   	ret    
  8022d4:	66 90                	xchg   %ax,%ax
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	66 90                	xchg   %ax,%ax
  8022da:	66 90                	xchg   %ax,%ax
  8022dc:	66 90                	xchg   %ax,%ax
  8022de:	66 90                	xchg   %ax,%ax

008022e0 <__udivdi3>:
  8022e0:	f3 0f 1e fb          	endbr32 
  8022e4:	55                   	push   %ebp
  8022e5:	57                   	push   %edi
  8022e6:	56                   	push   %esi
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 1c             	sub    $0x1c,%esp
  8022eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022fb:	85 d2                	test   %edx,%edx
  8022fd:	75 19                	jne    802318 <__udivdi3+0x38>
  8022ff:	39 f3                	cmp    %esi,%ebx
  802301:	76 4d                	jbe    802350 <__udivdi3+0x70>
  802303:	31 ff                	xor    %edi,%edi
  802305:	89 e8                	mov    %ebp,%eax
  802307:	89 f2                	mov    %esi,%edx
  802309:	f7 f3                	div    %ebx
  80230b:	89 fa                	mov    %edi,%edx
  80230d:	83 c4 1c             	add    $0x1c,%esp
  802310:	5b                   	pop    %ebx
  802311:	5e                   	pop    %esi
  802312:	5f                   	pop    %edi
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    
  802315:	8d 76 00             	lea    0x0(%esi),%esi
  802318:	39 f2                	cmp    %esi,%edx
  80231a:	76 14                	jbe    802330 <__udivdi3+0x50>
  80231c:	31 ff                	xor    %edi,%edi
  80231e:	31 c0                	xor    %eax,%eax
  802320:	89 fa                	mov    %edi,%edx
  802322:	83 c4 1c             	add    $0x1c,%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5f                   	pop    %edi
  802328:	5d                   	pop    %ebp
  802329:	c3                   	ret    
  80232a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802330:	0f bd fa             	bsr    %edx,%edi
  802333:	83 f7 1f             	xor    $0x1f,%edi
  802336:	75 48                	jne    802380 <__udivdi3+0xa0>
  802338:	39 f2                	cmp    %esi,%edx
  80233a:	72 06                	jb     802342 <__udivdi3+0x62>
  80233c:	31 c0                	xor    %eax,%eax
  80233e:	39 eb                	cmp    %ebp,%ebx
  802340:	77 de                	ja     802320 <__udivdi3+0x40>
  802342:	b8 01 00 00 00       	mov    $0x1,%eax
  802347:	eb d7                	jmp    802320 <__udivdi3+0x40>
  802349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802350:	89 d9                	mov    %ebx,%ecx
  802352:	85 db                	test   %ebx,%ebx
  802354:	75 0b                	jne    802361 <__udivdi3+0x81>
  802356:	b8 01 00 00 00       	mov    $0x1,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	f7 f3                	div    %ebx
  80235f:	89 c1                	mov    %eax,%ecx
  802361:	31 d2                	xor    %edx,%edx
  802363:	89 f0                	mov    %esi,%eax
  802365:	f7 f1                	div    %ecx
  802367:	89 c6                	mov    %eax,%esi
  802369:	89 e8                	mov    %ebp,%eax
  80236b:	89 f7                	mov    %esi,%edi
  80236d:	f7 f1                	div    %ecx
  80236f:	89 fa                	mov    %edi,%edx
  802371:	83 c4 1c             	add    $0x1c,%esp
  802374:	5b                   	pop    %ebx
  802375:	5e                   	pop    %esi
  802376:	5f                   	pop    %edi
  802377:	5d                   	pop    %ebp
  802378:	c3                   	ret    
  802379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802380:	89 f9                	mov    %edi,%ecx
  802382:	b8 20 00 00 00       	mov    $0x20,%eax
  802387:	29 f8                	sub    %edi,%eax
  802389:	d3 e2                	shl    %cl,%edx
  80238b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80238f:	89 c1                	mov    %eax,%ecx
  802391:	89 da                	mov    %ebx,%edx
  802393:	d3 ea                	shr    %cl,%edx
  802395:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802399:	09 d1                	or     %edx,%ecx
  80239b:	89 f2                	mov    %esi,%edx
  80239d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023a1:	89 f9                	mov    %edi,%ecx
  8023a3:	d3 e3                	shl    %cl,%ebx
  8023a5:	89 c1                	mov    %eax,%ecx
  8023a7:	d3 ea                	shr    %cl,%edx
  8023a9:	89 f9                	mov    %edi,%ecx
  8023ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023af:	89 eb                	mov    %ebp,%ebx
  8023b1:	d3 e6                	shl    %cl,%esi
  8023b3:	89 c1                	mov    %eax,%ecx
  8023b5:	d3 eb                	shr    %cl,%ebx
  8023b7:	09 de                	or     %ebx,%esi
  8023b9:	89 f0                	mov    %esi,%eax
  8023bb:	f7 74 24 08          	divl   0x8(%esp)
  8023bf:	89 d6                	mov    %edx,%esi
  8023c1:	89 c3                	mov    %eax,%ebx
  8023c3:	f7 64 24 0c          	mull   0xc(%esp)
  8023c7:	39 d6                	cmp    %edx,%esi
  8023c9:	72 15                	jb     8023e0 <__udivdi3+0x100>
  8023cb:	89 f9                	mov    %edi,%ecx
  8023cd:	d3 e5                	shl    %cl,%ebp
  8023cf:	39 c5                	cmp    %eax,%ebp
  8023d1:	73 04                	jae    8023d7 <__udivdi3+0xf7>
  8023d3:	39 d6                	cmp    %edx,%esi
  8023d5:	74 09                	je     8023e0 <__udivdi3+0x100>
  8023d7:	89 d8                	mov    %ebx,%eax
  8023d9:	31 ff                	xor    %edi,%edi
  8023db:	e9 40 ff ff ff       	jmp    802320 <__udivdi3+0x40>
  8023e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023e3:	31 ff                	xor    %edi,%edi
  8023e5:	e9 36 ff ff ff       	jmp    802320 <__udivdi3+0x40>
  8023ea:	66 90                	xchg   %ax,%ax
  8023ec:	66 90                	xchg   %ax,%ax
  8023ee:	66 90                	xchg   %ax,%ax

008023f0 <__umoddi3>:
  8023f0:	f3 0f 1e fb          	endbr32 
  8023f4:	55                   	push   %ebp
  8023f5:	57                   	push   %edi
  8023f6:	56                   	push   %esi
  8023f7:	53                   	push   %ebx
  8023f8:	83 ec 1c             	sub    $0x1c,%esp
  8023fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802403:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802407:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80240b:	85 c0                	test   %eax,%eax
  80240d:	75 19                	jne    802428 <__umoddi3+0x38>
  80240f:	39 df                	cmp    %ebx,%edi
  802411:	76 5d                	jbe    802470 <__umoddi3+0x80>
  802413:	89 f0                	mov    %esi,%eax
  802415:	89 da                	mov    %ebx,%edx
  802417:	f7 f7                	div    %edi
  802419:	89 d0                	mov    %edx,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	83 c4 1c             	add    $0x1c,%esp
  802420:	5b                   	pop    %ebx
  802421:	5e                   	pop    %esi
  802422:	5f                   	pop    %edi
  802423:	5d                   	pop    %ebp
  802424:	c3                   	ret    
  802425:	8d 76 00             	lea    0x0(%esi),%esi
  802428:	89 f2                	mov    %esi,%edx
  80242a:	39 d8                	cmp    %ebx,%eax
  80242c:	76 12                	jbe    802440 <__umoddi3+0x50>
  80242e:	89 f0                	mov    %esi,%eax
  802430:	89 da                	mov    %ebx,%edx
  802432:	83 c4 1c             	add    $0x1c,%esp
  802435:	5b                   	pop    %ebx
  802436:	5e                   	pop    %esi
  802437:	5f                   	pop    %edi
  802438:	5d                   	pop    %ebp
  802439:	c3                   	ret    
  80243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802440:	0f bd e8             	bsr    %eax,%ebp
  802443:	83 f5 1f             	xor    $0x1f,%ebp
  802446:	75 50                	jne    802498 <__umoddi3+0xa8>
  802448:	39 d8                	cmp    %ebx,%eax
  80244a:	0f 82 e0 00 00 00    	jb     802530 <__umoddi3+0x140>
  802450:	89 d9                	mov    %ebx,%ecx
  802452:	39 f7                	cmp    %esi,%edi
  802454:	0f 86 d6 00 00 00    	jbe    802530 <__umoddi3+0x140>
  80245a:	89 d0                	mov    %edx,%eax
  80245c:	89 ca                	mov    %ecx,%edx
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	89 fd                	mov    %edi,%ebp
  802472:	85 ff                	test   %edi,%edi
  802474:	75 0b                	jne    802481 <__umoddi3+0x91>
  802476:	b8 01 00 00 00       	mov    $0x1,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	f7 f7                	div    %edi
  80247f:	89 c5                	mov    %eax,%ebp
  802481:	89 d8                	mov    %ebx,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f5                	div    %ebp
  802487:	89 f0                	mov    %esi,%eax
  802489:	f7 f5                	div    %ebp
  80248b:	89 d0                	mov    %edx,%eax
  80248d:	31 d2                	xor    %edx,%edx
  80248f:	eb 8c                	jmp    80241d <__umoddi3+0x2d>
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	ba 20 00 00 00       	mov    $0x20,%edx
  80249f:	29 ea                	sub    %ebp,%edx
  8024a1:	d3 e0                	shl    %cl,%eax
  8024a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	89 f8                	mov    %edi,%eax
  8024ab:	d3 e8                	shr    %cl,%eax
  8024ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024b9:	09 c1                	or     %eax,%ecx
  8024bb:	89 d8                	mov    %ebx,%eax
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e7                	shl    %cl,%edi
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024cf:	d3 e3                	shl    %cl,%ebx
  8024d1:	89 c7                	mov    %eax,%edi
  8024d3:	89 d1                	mov    %edx,%ecx
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 fa                	mov    %edi,%edx
  8024dd:	d3 e6                	shl    %cl,%esi
  8024df:	09 d8                	or     %ebx,%eax
  8024e1:	f7 74 24 08          	divl   0x8(%esp)
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	89 f3                	mov    %esi,%ebx
  8024e9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	89 d7                	mov    %edx,%edi
  8024f1:	39 d1                	cmp    %edx,%ecx
  8024f3:	72 06                	jb     8024fb <__umoddi3+0x10b>
  8024f5:	75 10                	jne    802507 <__umoddi3+0x117>
  8024f7:	39 c3                	cmp    %eax,%ebx
  8024f9:	73 0c                	jae    802507 <__umoddi3+0x117>
  8024fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802503:	89 d7                	mov    %edx,%edi
  802505:	89 c6                	mov    %eax,%esi
  802507:	89 ca                	mov    %ecx,%edx
  802509:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80250e:	29 f3                	sub    %esi,%ebx
  802510:	19 fa                	sbb    %edi,%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	d3 e0                	shl    %cl,%eax
  802516:	89 e9                	mov    %ebp,%ecx
  802518:	d3 eb                	shr    %cl,%ebx
  80251a:	d3 ea                	shr    %cl,%edx
  80251c:	09 d8                	or     %ebx,%eax
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	29 fe                	sub    %edi,%esi
  802532:	19 c3                	sbb    %eax,%ebx
  802534:	89 f2                	mov    %esi,%edx
  802536:	89 d9                	mov    %ebx,%ecx
  802538:	e9 1d ff ff ff       	jmp    80245a <__umoddi3+0x6a>
