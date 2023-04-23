
obj/user/echotest.debug:     file format elf32-i386


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
  80002c:	e8 b2 04 00 00       	call   8004e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 00 29 80 00       	push   $0x802900
  80003f:	e8 a4 05 00 00       	call   8005e8 <cprintf>
	exit();
  800044:	e8 e4 04 00 00       	call   80052d <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <umain>:

void umain(int argc, char **argv)
{
  80004e:	f3 0f 1e fb          	endbr32 
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	57                   	push   %edi
  800056:	56                   	push   %esi
  800057:	53                   	push   %ebx
  800058:	83 ec 58             	sub    $0x58,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  80005b:	68 04 29 80 00       	push   $0x802904
  800060:	e8 83 05 00 00       	call   8005e8 <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800065:	c7 04 24 14 29 80 00 	movl   $0x802914,(%esp)
  80006c:	e8 35 04 00 00       	call   8004a6 <inet_addr>
  800071:	83 c4 0c             	add    $0xc,%esp
  800074:	50                   	push   %eax
  800075:	68 14 29 80 00       	push   $0x802914
  80007a:	68 1e 29 80 00       	push   $0x80291e
  80007f:	e8 64 05 00 00       	call   8005e8 <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800084:	83 c4 0c             	add    $0xc,%esp
  800087:	6a 06                	push   $0x6
  800089:	6a 01                	push   $0x1
  80008b:	6a 02                	push   $0x2
  80008d:	e8 be 1c 00 00       	call   801d50 <socket>
  800092:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	85 c0                	test   %eax,%eax
  80009a:	0f 88 b4 00 00 00    	js     800154 <umain+0x106>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 4b 29 80 00       	push   $0x80294b
  8000a8:	e8 3b 05 00 00       	call   8005e8 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 10                	push   $0x10
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000b7:	53                   	push   %ebx
  8000b8:	e8 9f 0c 00 00       	call   800d5c <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000bd:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000c1:	c7 04 24 14 29 80 00 	movl   $0x802914,(%esp)
  8000c8:	e8 d9 03 00 00       	call   8004a6 <inet_addr>
  8000cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000d0:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000d7:	e8 a1 01 00 00       	call   80027d <htons>
  8000dc:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  8000e0:	c7 04 24 5a 29 80 00 	movl   $0x80295a,(%esp)
  8000e7:	e8 fc 04 00 00       	call   8005e8 <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8000ec:	83 c4 0c             	add    $0xc,%esp
  8000ef:	6a 10                	push   $0x10
  8000f1:	53                   	push   %ebx
  8000f2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8000f5:	e8 05 1c 00 00       	call   801cff <connect>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	78 62                	js     800163 <umain+0x115>
		die("Failed to connect with server");

	cprintf("connected to server\n");
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	68 95 29 80 00       	push   $0x802995
  800109:	e8 da 04 00 00       	call   8005e8 <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80010e:	83 c4 04             	add    $0x4,%esp
  800111:	ff 35 00 30 80 00    	pushl  0x803000
  800117:	e8 93 0a 00 00       	call   800baf <strlen>
  80011c:	89 c7                	mov    %eax,%edi
  80011e:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  800121:	83 c4 0c             	add    $0xc,%esp
  800124:	50                   	push   %eax
  800125:	ff 35 00 30 80 00    	pushl  0x803000
  80012b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80012e:	e8 a4 15 00 00       	call   8016d7 <write>
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	39 c7                	cmp    %eax,%edi
  800138:	75 35                	jne    80016f <umain+0x121>
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 aa 29 80 00       	push   $0x8029aa
  800142:	e8 a1 04 00 00       	call   8005e8 <cprintf>
	while (received < echolen) {
  800147:	83 c4 10             	add    $0x10,%esp
	int received = 0;
  80014a:	be 00 00 00 00       	mov    $0x0,%esi
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80014f:	8d 7d b8             	lea    -0x48(%ebp),%edi
	while (received < echolen) {
  800152:	eb 3a                	jmp    80018e <umain+0x140>
		die("Failed to create socket");
  800154:	b8 33 29 80 00       	mov    $0x802933,%eax
  800159:	e8 d5 fe ff ff       	call   800033 <die>
  80015e:	e9 3d ff ff ff       	jmp    8000a0 <umain+0x52>
		die("Failed to connect with server");
  800163:	b8 77 29 80 00       	mov    $0x802977,%eax
  800168:	e8 c6 fe ff ff       	call   800033 <die>
  80016d:	eb 92                	jmp    800101 <umain+0xb3>
		die("Mismatch in number of sent bytes");
  80016f:	b8 c4 29 80 00       	mov    $0x8029c4,%eax
  800174:	e8 ba fe ff ff       	call   800033 <die>
  800179:	eb bf                	jmp    80013a <umain+0xec>
			die("Failed to receive bytes from server");
		}
		received += bytes;
  80017b:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  80017d:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	57                   	push   %edi
  800186:	e8 5d 04 00 00       	call   8005e8 <cprintf>
  80018b:	83 c4 10             	add    $0x10,%esp
	while (received < echolen) {
  80018e:	3b 75 b0             	cmp    -0x50(%ebp),%esi
  800191:	73 23                	jae    8001b6 <umain+0x168>
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800193:	83 ec 04             	sub    $0x4,%esp
  800196:	6a 1f                	push   $0x1f
  800198:	57                   	push   %edi
  800199:	ff 75 b4             	pushl  -0x4c(%ebp)
  80019c:	e8 60 14 00 00       	call   801601 <read>
  8001a1:	89 c3                	mov    %eax,%ebx
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	85 c0                	test   %eax,%eax
  8001a8:	7f d1                	jg     80017b <umain+0x12d>
			die("Failed to receive bytes from server");
  8001aa:	b8 e8 29 80 00       	mov    $0x8029e8,%eax
  8001af:	e8 7f fe ff ff       	call   800033 <die>
  8001b4:	eb c5                	jmp    80017b <umain+0x12d>
	}
	cprintf("\n");
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 b4 29 80 00       	push   $0x8029b4
  8001be:	e8 25 04 00 00       	call   8005e8 <cprintf>

	close(sock);
  8001c3:	83 c4 04             	add    $0x4,%esp
  8001c6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8001c9:	e8 e9 12 00 00       	call   8014b7 <close>
}
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d4:	5b                   	pop    %ebx
  8001d5:	5e                   	pop    %esi
  8001d6:	5f                   	pop    %edi
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    

008001d9 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001d9:	f3 0f 1e fb          	endbr32 
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	57                   	push   %edi
  8001e1:	56                   	push   %esi
  8001e2:	53                   	push   %ebx
  8001e3:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8001ec:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  8001f0:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  8001f3:	bf 00 40 80 00       	mov    $0x804000,%edi
  8001f8:	eb 2e                	jmp    800228 <inet_ntoa+0x4f>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  8001fa:	0f b6 c8             	movzbl %al,%ecx
  8001fd:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800202:	88 0a                	mov    %cl,(%edx)
  800204:	83 c2 01             	add    $0x1,%edx
    while(i--)
  800207:	83 e8 01             	sub    $0x1,%eax
  80020a:	3c ff                	cmp    $0xff,%al
  80020c:	75 ec                	jne    8001fa <inet_ntoa+0x21>
  80020e:	0f b6 db             	movzbl %bl,%ebx
  800211:	01 fb                	add    %edi,%ebx
    *rp++ = '.';
  800213:	8d 7b 01             	lea    0x1(%ebx),%edi
  800216:	c6 03 2e             	movb   $0x2e,(%ebx)
  800219:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  80021c:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800220:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800224:	3c 04                	cmp    $0x4,%al
  800226:	74 45                	je     80026d <inet_ntoa+0x94>
  rp = str;
  800228:	bb 00 00 00 00       	mov    $0x0,%ebx
      rem = *ap % (u8_t)10;
  80022d:	0f b6 16             	movzbl (%esi),%edx
      *ap /= (u8_t)10;
  800230:	0f b6 ca             	movzbl %dl,%ecx
  800233:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800236:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  800239:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80023c:	66 c1 e8 0b          	shr    $0xb,%ax
  800240:	88 06                	mov    %al,(%esi)
  800242:	89 d9                	mov    %ebx,%ecx
      inv[i++] = '0' + rem;
  800244:	83 c3 01             	add    $0x1,%ebx
  800247:	0f b6 c9             	movzbl %cl,%ecx
  80024a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  80024d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800250:	01 c0                	add    %eax,%eax
  800252:	89 d1                	mov    %edx,%ecx
  800254:	29 c1                	sub    %eax,%ecx
  800256:	89 c8                	mov    %ecx,%eax
      inv[i++] = '0' + rem;
  800258:	83 c0 30             	add    $0x30,%eax
  80025b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80025e:	88 44 0d ed          	mov    %al,-0x13(%ebp,%ecx,1)
    } while(*ap);
  800262:	80 fa 09             	cmp    $0x9,%dl
  800265:	77 c6                	ja     80022d <inet_ntoa+0x54>
  800267:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800269:	89 d8                	mov    %ebx,%eax
  80026b:	eb 9a                	jmp    800207 <inet_ntoa+0x2e>
    ap++;
  }
  *--rp = 0;
  80026d:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800270:	b8 00 40 80 00       	mov    $0x804000,%eax
  800275:	83 c4 18             	add    $0x18,%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80027d:	f3 0f 1e fb          	endbr32 
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800284:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800288:	66 c1 c0 08          	rol    $0x8,%ax
}
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    

0080028e <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80028e:	f3 0f 1e fb          	endbr32 
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800295:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800299:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    

0080029f <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80029f:	f3 0f 1e fb          	endbr32 
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8002a9:	89 d0                	mov    %edx,%eax
  8002ab:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002ae:	89 d1                	mov    %edx,%ecx
  8002b0:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002b3:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	c1 e1 08             	shl    $0x8,%ecx
  8002ba:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002c0:	09 c8                	or     %ecx,%eax
  8002c2:	c1 ea 08             	shr    $0x8,%edx
  8002c5:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002cb:	09 d0                	or     %edx,%eax
}
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <inet_aton>:
{
  8002cf:	f3 0f 1e fb          	endbr32 
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	57                   	push   %edi
  8002d7:	56                   	push   %esi
  8002d8:	53                   	push   %ebx
  8002d9:	83 ec 2c             	sub    $0x2c,%esp
  8002dc:	8b 55 08             	mov    0x8(%ebp),%edx
  c = *cp;
  8002df:	0f be 02             	movsbl (%edx),%eax
  u32_t *pp = parts;
  8002e2:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8002e5:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8002e8:	e9 a7 00 00 00       	jmp    800394 <inet_aton+0xc5>
      c = *++cp;
  8002ed:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      if (c == 'x' || c == 'X') {
  8002f1:	89 c1                	mov    %eax,%ecx
  8002f3:	83 e1 df             	and    $0xffffffdf,%ecx
  8002f6:	80 f9 58             	cmp    $0x58,%cl
  8002f9:	74 10                	je     80030b <inet_aton+0x3c>
      c = *++cp;
  8002fb:	83 c2 01             	add    $0x1,%edx
  8002fe:	0f be c0             	movsbl %al,%eax
        base = 8;
  800301:	be 08 00 00 00       	mov    $0x8,%esi
  800306:	e9 a3 00 00 00       	jmp    8003ae <inet_aton+0xdf>
        c = *++cp;
  80030b:	0f be 42 02          	movsbl 0x2(%edx),%eax
  80030f:	8d 52 02             	lea    0x2(%edx),%edx
        base = 16;
  800312:	be 10 00 00 00       	mov    $0x10,%esi
  800317:	e9 92 00 00 00       	jmp    8003ae <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  80031c:	83 fe 10             	cmp    $0x10,%esi
  80031f:	75 4d                	jne    80036e <inet_aton+0x9f>
  800321:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800324:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800327:	89 c1                	mov    %eax,%ecx
  800329:	83 e1 df             	and    $0xffffffdf,%ecx
  80032c:	83 e9 41             	sub    $0x41,%ecx
  80032f:	80 f9 05             	cmp    $0x5,%cl
  800332:	77 3a                	ja     80036e <inet_aton+0x9f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800334:	c1 e3 04             	shl    $0x4,%ebx
  800337:	83 c0 0a             	add    $0xa,%eax
  80033a:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  80033e:	19 c9                	sbb    %ecx,%ecx
  800340:	83 e1 20             	and    $0x20,%ecx
  800343:	83 c1 41             	add    $0x41,%ecx
  800346:	29 c8                	sub    %ecx,%eax
  800348:	09 c3                	or     %eax,%ebx
        c = *++cp;
  80034a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034d:	0f be 40 01          	movsbl 0x1(%eax),%eax
  800351:	83 c2 01             	add    $0x1,%edx
  800354:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      if (isdigit(c)) {
  800357:	89 c7                	mov    %eax,%edi
  800359:	8d 48 d0             	lea    -0x30(%eax),%ecx
  80035c:	80 f9 09             	cmp    $0x9,%cl
  80035f:	77 bb                	ja     80031c <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  800361:	0f af de             	imul   %esi,%ebx
  800364:	8d 5c 18 d0          	lea    -0x30(%eax,%ebx,1),%ebx
        c = *++cp;
  800368:	0f be 42 01          	movsbl 0x1(%edx),%eax
  80036c:	eb e3                	jmp    800351 <inet_aton+0x82>
    if (c == '.') {
  80036e:	83 f8 2e             	cmp    $0x2e,%eax
  800371:	75 42                	jne    8003b5 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800373:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800376:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800379:	39 c6                	cmp    %eax,%esi
  80037b:	0f 84 16 01 00 00    	je     800497 <inet_aton+0x1c8>
      *pp++ = val;
  800381:	83 c6 04             	add    $0x4,%esi
  800384:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800387:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  80038a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038d:	8d 50 01             	lea    0x1(%eax),%edx
  800390:	0f be 40 01          	movsbl 0x1(%eax),%eax
    if (!isdigit(c))
  800394:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800397:	80 f9 09             	cmp    $0x9,%cl
  80039a:	0f 87 f0 00 00 00    	ja     800490 <inet_aton+0x1c1>
    base = 10;
  8003a0:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  8003a5:	83 f8 30             	cmp    $0x30,%eax
  8003a8:	0f 84 3f ff ff ff    	je     8002ed <inet_aton+0x1e>
    base = 10;
  8003ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b3:	eb 9f                	jmp    800354 <inet_aton+0x85>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	74 29                	je     8003e2 <inet_aton+0x113>
    return (0);
  8003b9:	ba 00 00 00 00       	mov    $0x0,%edx
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003be:	89 f9                	mov    %edi,%ecx
  8003c0:	80 f9 1f             	cmp    $0x1f,%cl
  8003c3:	0f 86 d3 00 00 00    	jbe    80049c <inet_aton+0x1cd>
  8003c9:	84 c0                	test   %al,%al
  8003cb:	0f 88 cb 00 00 00    	js     80049c <inet_aton+0x1cd>
  8003d1:	83 f8 20             	cmp    $0x20,%eax
  8003d4:	74 0c                	je     8003e2 <inet_aton+0x113>
  8003d6:	83 e8 09             	sub    $0x9,%eax
  8003d9:	83 f8 04             	cmp    $0x4,%eax
  8003dc:	0f 87 ba 00 00 00    	ja     80049c <inet_aton+0x1cd>
  n = pp - parts + 1;
  8003e2:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8003e5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8003e8:	29 c6                	sub    %eax,%esi
  8003ea:	89 f0                	mov    %esi,%eax
  8003ec:	c1 f8 02             	sar    $0x2,%eax
  8003ef:	8d 50 01             	lea    0x1(%eax),%edx
  switch (n) {
  8003f2:	83 f8 02             	cmp    $0x2,%eax
  8003f5:	74 7a                	je     800471 <inet_aton+0x1a2>
  8003f7:	83 fa 03             	cmp    $0x3,%edx
  8003fa:	7f 49                	jg     800445 <inet_aton+0x176>
  8003fc:	85 d2                	test   %edx,%edx
  8003fe:	0f 84 98 00 00 00    	je     80049c <inet_aton+0x1cd>
  800404:	83 fa 02             	cmp    $0x2,%edx
  800407:	75 19                	jne    800422 <inet_aton+0x153>
      return (0);
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffffffUL)
  80040e:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  800414:	0f 87 82 00 00 00    	ja     80049c <inet_aton+0x1cd>
    val |= parts[0] << 24;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	c1 e0 18             	shl    $0x18,%eax
  800420:	09 c3                	or     %eax,%ebx
  return (1);
  800422:	ba 01 00 00 00       	mov    $0x1,%edx
  if (addr)
  800427:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80042b:	74 6f                	je     80049c <inet_aton+0x1cd>
    addr->s_addr = htonl(val);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	53                   	push   %ebx
  800431:	e8 69 fe ff ff       	call   80029f <htonl>
  800436:	83 c4 10             	add    $0x10,%esp
  800439:	8b 75 0c             	mov    0xc(%ebp),%esi
  80043c:	89 06                	mov    %eax,(%esi)
  return (1);
  80043e:	ba 01 00 00 00       	mov    $0x1,%edx
  800443:	eb 57                	jmp    80049c <inet_aton+0x1cd>
  switch (n) {
  800445:	83 fa 04             	cmp    $0x4,%edx
  800448:	75 d8                	jne    800422 <inet_aton+0x153>
      return (0);
  80044a:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xff)
  80044f:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800455:	77 45                	ja     80049c <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800457:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045a:	c1 e0 18             	shl    $0x18,%eax
  80045d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800460:	c1 e2 10             	shl    $0x10,%edx
  800463:	09 d0                	or     %edx,%eax
  800465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800468:	c1 e2 08             	shl    $0x8,%edx
  80046b:	09 d0                	or     %edx,%eax
  80046d:	09 c3                	or     %eax,%ebx
    break;
  80046f:	eb b1                	jmp    800422 <inet_aton+0x153>
      return (0);
  800471:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffff)
  800476:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  80047c:	77 1e                	ja     80049c <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80047e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800481:	c1 e0 18             	shl    $0x18,%eax
  800484:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800487:	c1 e2 10             	shl    $0x10,%edx
  80048a:	09 d0                	or     %edx,%eax
  80048c:	09 c3                	or     %eax,%ebx
    break;
  80048e:	eb 92                	jmp    800422 <inet_aton+0x153>
      return (0);
  800490:	ba 00 00 00 00       	mov    $0x0,%edx
  800495:	eb 05                	jmp    80049c <inet_aton+0x1cd>
        return (0);
  800497:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80049c:	89 d0                	mov    %edx,%eax
  80049e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004a1:	5b                   	pop    %ebx
  8004a2:	5e                   	pop    %esi
  8004a3:	5f                   	pop    %edi
  8004a4:	5d                   	pop    %ebp
  8004a5:	c3                   	ret    

008004a6 <inet_addr>:
{
  8004a6:	f3 0f 1e fb          	endbr32 
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  8004b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004b3:	50                   	push   %eax
  8004b4:	ff 75 08             	pushl  0x8(%ebp)
  8004b7:	e8 13 fe ff ff       	call   8002cf <inet_aton>
  8004bc:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004c6:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004cc:	f3 0f 1e fb          	endbr32 
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	e8 c1 fd ff ff       	call   80029f <htonl>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004e3:	f3 0f 1e fb          	endbr32 
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	56                   	push   %esi
  8004eb:	53                   	push   %ebx
  8004ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004ef:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004f2:	e8 f7 0a 00 00       	call   800fee <sys_getenvid>
  8004f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004fc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800504:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800509:	85 db                	test   %ebx,%ebx
  80050b:	7e 07                	jle    800514 <libmain+0x31>
		binaryname = argv[0];
  80050d:	8b 06                	mov    (%esi),%eax
  80050f:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	56                   	push   %esi
  800518:	53                   	push   %ebx
  800519:	e8 30 fb ff ff       	call   80004e <umain>

	// exit gracefully
	exit();
  80051e:	e8 0a 00 00 00       	call   80052d <exit>
}
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800529:	5b                   	pop    %ebx
  80052a:	5e                   	pop    %esi
  80052b:	5d                   	pop    %ebp
  80052c:	c3                   	ret    

0080052d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80052d:	f3 0f 1e fb          	endbr32 
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800537:	e8 ac 0f 00 00       	call   8014e8 <close_all>
	sys_env_destroy(0);
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	6a 00                	push   $0x0
  800541:	e8 63 0a 00 00       	call   800fa9 <sys_env_destroy>
}
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	c9                   	leave  
  80054a:	c3                   	ret    

0080054b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80054b:	f3 0f 1e fb          	endbr32 
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	53                   	push   %ebx
  800553:	83 ec 04             	sub    $0x4,%esp
  800556:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800559:	8b 13                	mov    (%ebx),%edx
  80055b:	8d 42 01             	lea    0x1(%edx),%eax
  80055e:	89 03                	mov    %eax,(%ebx)
  800560:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800563:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800567:	3d ff 00 00 00       	cmp    $0xff,%eax
  80056c:	74 09                	je     800577 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80056e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	68 ff 00 00 00       	push   $0xff
  80057f:	8d 43 08             	lea    0x8(%ebx),%eax
  800582:	50                   	push   %eax
  800583:	e8 dc 09 00 00       	call   800f64 <sys_cputs>
		b->idx = 0;
  800588:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	eb db                	jmp    80056e <putch+0x23>

00800593 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800593:	f3 0f 1e fb          	endbr32 
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005a7:	00 00 00 
	b.cnt = 0;
  8005aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005b1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005b4:	ff 75 0c             	pushl  0xc(%ebp)
  8005b7:	ff 75 08             	pushl  0x8(%ebp)
  8005ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c0:	50                   	push   %eax
  8005c1:	68 4b 05 80 00       	push   $0x80054b
  8005c6:	e8 20 01 00 00       	call   8006eb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005cb:	83 c4 08             	add    $0x8,%esp
  8005ce:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005d4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005da:	50                   	push   %eax
  8005db:	e8 84 09 00 00       	call   800f64 <sys_cputs>

	return b.cnt;
}
  8005e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005e6:	c9                   	leave  
  8005e7:	c3                   	ret    

008005e8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005e8:	f3 0f 1e fb          	endbr32 
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005f2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005f5:	50                   	push   %eax
  8005f6:	ff 75 08             	pushl  0x8(%ebp)
  8005f9:	e8 95 ff ff ff       	call   800593 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005fe:	c9                   	leave  
  8005ff:	c3                   	ret    

00800600 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800600:	55                   	push   %ebp
  800601:	89 e5                	mov    %esp,%ebp
  800603:	57                   	push   %edi
  800604:	56                   	push   %esi
  800605:	53                   	push   %ebx
  800606:	83 ec 1c             	sub    $0x1c,%esp
  800609:	89 c7                	mov    %eax,%edi
  80060b:	89 d6                	mov    %edx,%esi
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 55 0c             	mov    0xc(%ebp),%edx
  800613:	89 d1                	mov    %edx,%ecx
  800615:	89 c2                	mov    %eax,%edx
  800617:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80061d:	8b 45 10             	mov    0x10(%ebp),%eax
  800620:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800623:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80062d:	39 c2                	cmp    %eax,%edx
  80062f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800632:	72 3e                	jb     800672 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800634:	83 ec 0c             	sub    $0xc,%esp
  800637:	ff 75 18             	pushl  0x18(%ebp)
  80063a:	83 eb 01             	sub    $0x1,%ebx
  80063d:	53                   	push   %ebx
  80063e:	50                   	push   %eax
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	ff 75 e4             	pushl  -0x1c(%ebp)
  800645:	ff 75 e0             	pushl  -0x20(%ebp)
  800648:	ff 75 dc             	pushl  -0x24(%ebp)
  80064b:	ff 75 d8             	pushl  -0x28(%ebp)
  80064e:	e8 4d 20 00 00       	call   8026a0 <__udivdi3>
  800653:	83 c4 18             	add    $0x18,%esp
  800656:	52                   	push   %edx
  800657:	50                   	push   %eax
  800658:	89 f2                	mov    %esi,%edx
  80065a:	89 f8                	mov    %edi,%eax
  80065c:	e8 9f ff ff ff       	call   800600 <printnum>
  800661:	83 c4 20             	add    $0x20,%esp
  800664:	eb 13                	jmp    800679 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	56                   	push   %esi
  80066a:	ff 75 18             	pushl  0x18(%ebp)
  80066d:	ff d7                	call   *%edi
  80066f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800672:	83 eb 01             	sub    $0x1,%ebx
  800675:	85 db                	test   %ebx,%ebx
  800677:	7f ed                	jg     800666 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	56                   	push   %esi
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	ff 75 e4             	pushl  -0x1c(%ebp)
  800683:	ff 75 e0             	pushl  -0x20(%ebp)
  800686:	ff 75 dc             	pushl  -0x24(%ebp)
  800689:	ff 75 d8             	pushl  -0x28(%ebp)
  80068c:	e8 1f 21 00 00       	call   8027b0 <__umoddi3>
  800691:	83 c4 14             	add    $0x14,%esp
  800694:	0f be 80 16 2a 80 00 	movsbl 0x802a16(%eax),%eax
  80069b:	50                   	push   %eax
  80069c:	ff d7                	call   *%edi
}
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a4:	5b                   	pop    %ebx
  8006a5:	5e                   	pop    %esi
  8006a6:	5f                   	pop    %edi
  8006a7:	5d                   	pop    %ebp
  8006a8:	c3                   	ret    

008006a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006a9:	f3 0f 1e fb          	endbr32 
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
  8006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006b3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006b7:	8b 10                	mov    (%eax),%edx
  8006b9:	3b 50 04             	cmp    0x4(%eax),%edx
  8006bc:	73 0a                	jae    8006c8 <sprintputch+0x1f>
		*b->buf++ = ch;
  8006be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006c1:	89 08                	mov    %ecx,(%eax)
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	88 02                	mov    %al,(%edx)
}
  8006c8:	5d                   	pop    %ebp
  8006c9:	c3                   	ret    

008006ca <printfmt>:
{
  8006ca:	f3 0f 1e fb          	endbr32 
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006d4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006d7:	50                   	push   %eax
  8006d8:	ff 75 10             	pushl  0x10(%ebp)
  8006db:	ff 75 0c             	pushl  0xc(%ebp)
  8006de:	ff 75 08             	pushl  0x8(%ebp)
  8006e1:	e8 05 00 00 00       	call   8006eb <vprintfmt>
}
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	c9                   	leave  
  8006ea:	c3                   	ret    

008006eb <vprintfmt>:
{
  8006eb:	f3 0f 1e fb          	endbr32 
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
  8006f2:	57                   	push   %edi
  8006f3:	56                   	push   %esi
  8006f4:	53                   	push   %ebx
  8006f5:	83 ec 3c             	sub    $0x3c,%esp
  8006f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006fe:	8b 7d 10             	mov    0x10(%ebp),%edi
  800701:	e9 8e 03 00 00       	jmp    800a94 <vprintfmt+0x3a9>
		padc = ' ';
  800706:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80070a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800711:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800718:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80071f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800724:	8d 47 01             	lea    0x1(%edi),%eax
  800727:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072a:	0f b6 17             	movzbl (%edi),%edx
  80072d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800730:	3c 55                	cmp    $0x55,%al
  800732:	0f 87 df 03 00 00    	ja     800b17 <vprintfmt+0x42c>
  800738:	0f b6 c0             	movzbl %al,%eax
  80073b:	3e ff 24 85 60 2b 80 	notrack jmp *0x802b60(,%eax,4)
  800742:	00 
  800743:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800746:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80074a:	eb d8                	jmp    800724 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80074c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80074f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800753:	eb cf                	jmp    800724 <vprintfmt+0x39>
  800755:	0f b6 d2             	movzbl %dl,%edx
  800758:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80075b:	b8 00 00 00 00       	mov    $0x0,%eax
  800760:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800763:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800766:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80076a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80076d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800770:	83 f9 09             	cmp    $0x9,%ecx
  800773:	77 55                	ja     8007ca <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800775:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800778:	eb e9                	jmp    800763 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8d 40 04             	lea    0x4(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80078b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80078e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800792:	79 90                	jns    800724 <vprintfmt+0x39>
				width = precision, precision = -1;
  800794:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800797:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80079a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007a1:	eb 81                	jmp    800724 <vprintfmt+0x39>
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	85 c0                	test   %eax,%eax
  8007a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ad:	0f 49 d0             	cmovns %eax,%edx
  8007b0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007b6:	e9 69 ff ff ff       	jmp    800724 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8007bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007be:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007c5:	e9 5a ff ff ff       	jmp    800724 <vprintfmt+0x39>
  8007ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d0:	eb bc                	jmp    80078e <vprintfmt+0xa3>
			lflag++;
  8007d2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007d8:	e9 47 ff ff ff       	jmp    800724 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8d 78 04             	lea    0x4(%eax),%edi
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	53                   	push   %ebx
  8007e7:	ff 30                	pushl  (%eax)
  8007e9:	ff d6                	call   *%esi
			break;
  8007eb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007ee:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007f1:	e9 9b 02 00 00       	jmp    800a91 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8d 78 04             	lea    0x4(%eax),%edi
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	99                   	cltd   
  8007ff:	31 d0                	xor    %edx,%eax
  800801:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800803:	83 f8 0f             	cmp    $0xf,%eax
  800806:	7f 23                	jg     80082b <vprintfmt+0x140>
  800808:	8b 14 85 c0 2c 80 00 	mov    0x802cc0(,%eax,4),%edx
  80080f:	85 d2                	test   %edx,%edx
  800811:	74 18                	je     80082b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800813:	52                   	push   %edx
  800814:	68 f5 2d 80 00       	push   $0x802df5
  800819:	53                   	push   %ebx
  80081a:	56                   	push   %esi
  80081b:	e8 aa fe ff ff       	call   8006ca <printfmt>
  800820:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800823:	89 7d 14             	mov    %edi,0x14(%ebp)
  800826:	e9 66 02 00 00       	jmp    800a91 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80082b:	50                   	push   %eax
  80082c:	68 2e 2a 80 00       	push   $0x802a2e
  800831:	53                   	push   %ebx
  800832:	56                   	push   %esi
  800833:	e8 92 fe ff ff       	call   8006ca <printfmt>
  800838:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80083b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80083e:	e9 4e 02 00 00       	jmp    800a91 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800851:	85 d2                	test   %edx,%edx
  800853:	b8 27 2a 80 00       	mov    $0x802a27,%eax
  800858:	0f 45 c2             	cmovne %edx,%eax
  80085b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80085e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800862:	7e 06                	jle    80086a <vprintfmt+0x17f>
  800864:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800868:	75 0d                	jne    800877 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80086a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80086d:	89 c7                	mov    %eax,%edi
  80086f:	03 45 e0             	add    -0x20(%ebp),%eax
  800872:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800875:	eb 55                	jmp    8008cc <vprintfmt+0x1e1>
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 d8             	pushl  -0x28(%ebp)
  80087d:	ff 75 cc             	pushl  -0x34(%ebp)
  800880:	e8 46 03 00 00       	call   800bcb <strnlen>
  800885:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800888:	29 c2                	sub    %eax,%edx
  80088a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800892:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800896:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800899:	85 ff                	test   %edi,%edi
  80089b:	7e 11                	jle    8008ae <vprintfmt+0x1c3>
					putch(padc, putdat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	53                   	push   %ebx
  8008a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8008a4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a6:	83 ef 01             	sub    $0x1,%edi
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	eb eb                	jmp    800899 <vprintfmt+0x1ae>
  8008ae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b8:	0f 49 c2             	cmovns %edx,%eax
  8008bb:	29 c2                	sub    %eax,%edx
  8008bd:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008c0:	eb a8                	jmp    80086a <vprintfmt+0x17f>
					putch(ch, putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	53                   	push   %ebx
  8008c6:	52                   	push   %edx
  8008c7:	ff d6                	call   *%esi
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008cf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d1:	83 c7 01             	add    $0x1,%edi
  8008d4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d8:	0f be d0             	movsbl %al,%edx
  8008db:	85 d2                	test   %edx,%edx
  8008dd:	74 4b                	je     80092a <vprintfmt+0x23f>
  8008df:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008e3:	78 06                	js     8008eb <vprintfmt+0x200>
  8008e5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008e9:	78 1e                	js     800909 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008ef:	74 d1                	je     8008c2 <vprintfmt+0x1d7>
  8008f1:	0f be c0             	movsbl %al,%eax
  8008f4:	83 e8 20             	sub    $0x20,%eax
  8008f7:	83 f8 5e             	cmp    $0x5e,%eax
  8008fa:	76 c6                	jbe    8008c2 <vprintfmt+0x1d7>
					putch('?', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	6a 3f                	push   $0x3f
  800902:	ff d6                	call   *%esi
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	eb c3                	jmp    8008cc <vprintfmt+0x1e1>
  800909:	89 cf                	mov    %ecx,%edi
  80090b:	eb 0e                	jmp    80091b <vprintfmt+0x230>
				putch(' ', putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	53                   	push   %ebx
  800911:	6a 20                	push   $0x20
  800913:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800915:	83 ef 01             	sub    $0x1,%edi
  800918:	83 c4 10             	add    $0x10,%esp
  80091b:	85 ff                	test   %edi,%edi
  80091d:	7f ee                	jg     80090d <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80091f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800922:	89 45 14             	mov    %eax,0x14(%ebp)
  800925:	e9 67 01 00 00       	jmp    800a91 <vprintfmt+0x3a6>
  80092a:	89 cf                	mov    %ecx,%edi
  80092c:	eb ed                	jmp    80091b <vprintfmt+0x230>
	if (lflag >= 2)
  80092e:	83 f9 01             	cmp    $0x1,%ecx
  800931:	7f 1b                	jg     80094e <vprintfmt+0x263>
	else if (lflag)
  800933:	85 c9                	test   %ecx,%ecx
  800935:	74 63                	je     80099a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093f:	99                   	cltd   
  800940:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8d 40 04             	lea    0x4(%eax),%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
  80094c:	eb 17                	jmp    800965 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8b 50 04             	mov    0x4(%eax),%edx
  800954:	8b 00                	mov    (%eax),%eax
  800956:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800959:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	8d 40 08             	lea    0x8(%eax),%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800965:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800968:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80096b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800970:	85 c9                	test   %ecx,%ecx
  800972:	0f 89 ff 00 00 00    	jns    800a77 <vprintfmt+0x38c>
				putch('-', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	53                   	push   %ebx
  80097c:	6a 2d                	push   $0x2d
  80097e:	ff d6                	call   *%esi
				num = -(long long) num;
  800980:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800983:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800986:	f7 da                	neg    %edx
  800988:	83 d1 00             	adc    $0x0,%ecx
  80098b:	f7 d9                	neg    %ecx
  80098d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800990:	b8 0a 00 00 00       	mov    $0xa,%eax
  800995:	e9 dd 00 00 00       	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a2:	99                   	cltd   
  8009a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	8d 40 04             	lea    0x4(%eax),%eax
  8009ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8009af:	eb b4                	jmp    800965 <vprintfmt+0x27a>
	if (lflag >= 2)
  8009b1:	83 f9 01             	cmp    $0x1,%ecx
  8009b4:	7f 1e                	jg     8009d4 <vprintfmt+0x2e9>
	else if (lflag)
  8009b6:	85 c9                	test   %ecx,%ecx
  8009b8:	74 32                	je     8009ec <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	8b 10                	mov    (%eax),%edx
  8009bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009c4:	8d 40 04             	lea    0x4(%eax),%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009ca:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8009cf:	e9 a3 00 00 00       	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	8b 10                	mov    (%eax),%edx
  8009d9:	8b 48 04             	mov    0x4(%eax),%ecx
  8009dc:	8d 40 08             	lea    0x8(%eax),%eax
  8009df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009e2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8009e7:	e9 8b 00 00 00       	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	8b 10                	mov    (%eax),%edx
  8009f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009f6:	8d 40 04             	lea    0x4(%eax),%eax
  8009f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009fc:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800a01:	eb 74                	jmp    800a77 <vprintfmt+0x38c>
	if (lflag >= 2)
  800a03:	83 f9 01             	cmp    $0x1,%ecx
  800a06:	7f 1b                	jg     800a23 <vprintfmt+0x338>
	else if (lflag)
  800a08:	85 c9                	test   %ecx,%ecx
  800a0a:	74 2c                	je     800a38 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	8b 10                	mov    (%eax),%edx
  800a11:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a16:	8d 40 04             	lea    0x4(%eax),%eax
  800a19:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a1c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800a21:	eb 54                	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	8b 10                	mov    (%eax),%edx
  800a28:	8b 48 04             	mov    0x4(%eax),%ecx
  800a2b:	8d 40 08             	lea    0x8(%eax),%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a31:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800a36:	eb 3f                	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	8b 10                	mov    (%eax),%edx
  800a3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a42:	8d 40 04             	lea    0x4(%eax),%eax
  800a45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a48:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800a4d:	eb 28                	jmp    800a77 <vprintfmt+0x38c>
			putch('0', putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	53                   	push   %ebx
  800a53:	6a 30                	push   $0x30
  800a55:	ff d6                	call   *%esi
			putch('x', putdat);
  800a57:	83 c4 08             	add    $0x8,%esp
  800a5a:	53                   	push   %ebx
  800a5b:	6a 78                	push   $0x78
  800a5d:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a62:	8b 10                	mov    (%eax),%edx
  800a64:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a69:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a6c:	8d 40 04             	lea    0x4(%eax),%eax
  800a6f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a72:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a77:	83 ec 0c             	sub    $0xc,%esp
  800a7a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a7e:	57                   	push   %edi
  800a7f:	ff 75 e0             	pushl  -0x20(%ebp)
  800a82:	50                   	push   %eax
  800a83:	51                   	push   %ecx
  800a84:	52                   	push   %edx
  800a85:	89 da                	mov    %ebx,%edx
  800a87:	89 f0                	mov    %esi,%eax
  800a89:	e8 72 fb ff ff       	call   800600 <printnum>
			break;
  800a8e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a94:	83 c7 01             	add    $0x1,%edi
  800a97:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a9b:	83 f8 25             	cmp    $0x25,%eax
  800a9e:	0f 84 62 fc ff ff    	je     800706 <vprintfmt+0x1b>
			if (ch == '\0')
  800aa4:	85 c0                	test   %eax,%eax
  800aa6:	0f 84 8b 00 00 00    	je     800b37 <vprintfmt+0x44c>
			putch(ch, putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	53                   	push   %ebx
  800ab0:	50                   	push   %eax
  800ab1:	ff d6                	call   *%esi
  800ab3:	83 c4 10             	add    $0x10,%esp
  800ab6:	eb dc                	jmp    800a94 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800ab8:	83 f9 01             	cmp    $0x1,%ecx
  800abb:	7f 1b                	jg     800ad8 <vprintfmt+0x3ed>
	else if (lflag)
  800abd:	85 c9                	test   %ecx,%ecx
  800abf:	74 2c                	je     800aed <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	8b 10                	mov    (%eax),%edx
  800ac6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800acb:	8d 40 04             	lea    0x4(%eax),%eax
  800ace:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800ad6:	eb 9f                	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	8b 10                	mov    (%eax),%edx
  800add:	8b 48 04             	mov    0x4(%eax),%ecx
  800ae0:	8d 40 08             	lea    0x8(%eax),%eax
  800ae3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800aeb:	eb 8a                	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	8b 10                	mov    (%eax),%edx
  800af2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af7:	8d 40 04             	lea    0x4(%eax),%eax
  800afa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800afd:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800b02:	e9 70 ff ff ff       	jmp    800a77 <vprintfmt+0x38c>
			putch(ch, putdat);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	53                   	push   %ebx
  800b0b:	6a 25                	push   $0x25
  800b0d:	ff d6                	call   *%esi
			break;
  800b0f:	83 c4 10             	add    $0x10,%esp
  800b12:	e9 7a ff ff ff       	jmp    800a91 <vprintfmt+0x3a6>
			putch('%', putdat);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	53                   	push   %ebx
  800b1b:	6a 25                	push   $0x25
  800b1d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	89 f8                	mov    %edi,%eax
  800b24:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b28:	74 05                	je     800b2f <vprintfmt+0x444>
  800b2a:	83 e8 01             	sub    $0x1,%eax
  800b2d:	eb f5                	jmp    800b24 <vprintfmt+0x439>
  800b2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b32:	e9 5a ff ff ff       	jmp    800a91 <vprintfmt+0x3a6>
}
  800b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3a:	5b                   	pop    %ebx
  800b3b:	5e                   	pop    %esi
  800b3c:	5f                   	pop    %edi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b3f:	f3 0f 1e fb          	endbr32 
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 18             	sub    $0x18,%esp
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b52:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b56:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b60:	85 c0                	test   %eax,%eax
  800b62:	74 26                	je     800b8a <vsnprintf+0x4b>
  800b64:	85 d2                	test   %edx,%edx
  800b66:	7e 22                	jle    800b8a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b68:	ff 75 14             	pushl  0x14(%ebp)
  800b6b:	ff 75 10             	pushl  0x10(%ebp)
  800b6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b71:	50                   	push   %eax
  800b72:	68 a9 06 80 00       	push   $0x8006a9
  800b77:	e8 6f fb ff ff       	call   8006eb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b85:	83 c4 10             	add    $0x10,%esp
}
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    
		return -E_INVAL;
  800b8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b8f:	eb f7                	jmp    800b88 <vsnprintf+0x49>

00800b91 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b91:	f3 0f 1e fb          	endbr32 
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 10             	pushl  0x10(%ebp)
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 92 ff ff ff       	call   800b3f <vsnprintf>
	va_end(ap);

	return rc;
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800baf:	f3 0f 1e fb          	endbr32 
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbe:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bc2:	74 05                	je     800bc9 <strlen+0x1a>
		n++;
  800bc4:	83 c0 01             	add    $0x1,%eax
  800bc7:	eb f5                	jmp    800bbe <strlen+0xf>
	return n;
}
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bcb:	f3 0f 1e fb          	endbr32 
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	39 d0                	cmp    %edx,%eax
  800bdf:	74 0d                	je     800bee <strnlen+0x23>
  800be1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800be5:	74 05                	je     800bec <strnlen+0x21>
		n++;
  800be7:	83 c0 01             	add    $0x1,%eax
  800bea:	eb f1                	jmp    800bdd <strnlen+0x12>
  800bec:	89 c2                	mov    %eax,%edx
	return n;
}
  800bee:	89 d0                	mov    %edx,%eax
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf2:	f3 0f 1e fb          	endbr32 
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	53                   	push   %ebx
  800bfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c00:	b8 00 00 00 00       	mov    $0x0,%eax
  800c05:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800c09:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800c0c:	83 c0 01             	add    $0x1,%eax
  800c0f:	84 d2                	test   %dl,%dl
  800c11:	75 f2                	jne    800c05 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800c13:	89 c8                	mov    %ecx,%eax
  800c15:	5b                   	pop    %ebx
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c18:	f3 0f 1e fb          	endbr32 
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	53                   	push   %ebx
  800c20:	83 ec 10             	sub    $0x10,%esp
  800c23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c26:	53                   	push   %ebx
  800c27:	e8 83 ff ff ff       	call   800baf <strlen>
  800c2c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c2f:	ff 75 0c             	pushl  0xc(%ebp)
  800c32:	01 d8                	add    %ebx,%eax
  800c34:	50                   	push   %eax
  800c35:	e8 b8 ff ff ff       	call   800bf2 <strcpy>
	return dst;
}
  800c3a:	89 d8                	mov    %ebx,%eax
  800c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c41:	f3 0f 1e fb          	endbr32 
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	8b 75 08             	mov    0x8(%ebp),%esi
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	89 f3                	mov    %esi,%ebx
  800c52:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c55:	89 f0                	mov    %esi,%eax
  800c57:	39 d8                	cmp    %ebx,%eax
  800c59:	74 11                	je     800c6c <strncpy+0x2b>
		*dst++ = *src;
  800c5b:	83 c0 01             	add    $0x1,%eax
  800c5e:	0f b6 0a             	movzbl (%edx),%ecx
  800c61:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c64:	80 f9 01             	cmp    $0x1,%cl
  800c67:	83 da ff             	sbb    $0xffffffff,%edx
  800c6a:	eb eb                	jmp    800c57 <strncpy+0x16>
	}
	return ret;
}
  800c6c:	89 f0                	mov    %esi,%eax
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c72:	f3 0f 1e fb          	endbr32 
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
  800c7b:	8b 75 08             	mov    0x8(%ebp),%esi
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	8b 55 10             	mov    0x10(%ebp),%edx
  800c84:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c86:	85 d2                	test   %edx,%edx
  800c88:	74 21                	je     800cab <strlcpy+0x39>
  800c8a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c8e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c90:	39 c2                	cmp    %eax,%edx
  800c92:	74 14                	je     800ca8 <strlcpy+0x36>
  800c94:	0f b6 19             	movzbl (%ecx),%ebx
  800c97:	84 db                	test   %bl,%bl
  800c99:	74 0b                	je     800ca6 <strlcpy+0x34>
			*dst++ = *src++;
  800c9b:	83 c1 01             	add    $0x1,%ecx
  800c9e:	83 c2 01             	add    $0x1,%edx
  800ca1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ca4:	eb ea                	jmp    800c90 <strlcpy+0x1e>
  800ca6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ca8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cab:	29 f0                	sub    %esi,%eax
}
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb1:	f3 0f 1e fb          	endbr32 
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cbe:	0f b6 01             	movzbl (%ecx),%eax
  800cc1:	84 c0                	test   %al,%al
  800cc3:	74 0c                	je     800cd1 <strcmp+0x20>
  800cc5:	3a 02                	cmp    (%edx),%al
  800cc7:	75 08                	jne    800cd1 <strcmp+0x20>
		p++, q++;
  800cc9:	83 c1 01             	add    $0x1,%ecx
  800ccc:	83 c2 01             	add    $0x1,%edx
  800ccf:	eb ed                	jmp    800cbe <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd1:	0f b6 c0             	movzbl %al,%eax
  800cd4:	0f b6 12             	movzbl (%edx),%edx
  800cd7:	29 d0                	sub    %edx,%eax
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cdb:	f3 0f 1e fb          	endbr32 
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	53                   	push   %ebx
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	89 c3                	mov    %eax,%ebx
  800ceb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cee:	eb 06                	jmp    800cf6 <strncmp+0x1b>
		n--, p++, q++;
  800cf0:	83 c0 01             	add    $0x1,%eax
  800cf3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cf6:	39 d8                	cmp    %ebx,%eax
  800cf8:	74 16                	je     800d10 <strncmp+0x35>
  800cfa:	0f b6 08             	movzbl (%eax),%ecx
  800cfd:	84 c9                	test   %cl,%cl
  800cff:	74 04                	je     800d05 <strncmp+0x2a>
  800d01:	3a 0a                	cmp    (%edx),%cl
  800d03:	74 eb                	je     800cf0 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d05:	0f b6 00             	movzbl (%eax),%eax
  800d08:	0f b6 12             	movzbl (%edx),%edx
  800d0b:	29 d0                	sub    %edx,%eax
}
  800d0d:	5b                   	pop    %ebx
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    
		return 0;
  800d10:	b8 00 00 00 00       	mov    $0x0,%eax
  800d15:	eb f6                	jmp    800d0d <strncmp+0x32>

00800d17 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d17:	f3 0f 1e fb          	endbr32 
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d25:	0f b6 10             	movzbl (%eax),%edx
  800d28:	84 d2                	test   %dl,%dl
  800d2a:	74 09                	je     800d35 <strchr+0x1e>
		if (*s == c)
  800d2c:	38 ca                	cmp    %cl,%dl
  800d2e:	74 0a                	je     800d3a <strchr+0x23>
	for (; *s; s++)
  800d30:	83 c0 01             	add    $0x1,%eax
  800d33:	eb f0                	jmp    800d25 <strchr+0xe>
			return (char *) s;
	return 0;
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d3c:	f3 0f 1e fb          	endbr32 
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d4a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d4d:	38 ca                	cmp    %cl,%dl
  800d4f:	74 09                	je     800d5a <strfind+0x1e>
  800d51:	84 d2                	test   %dl,%dl
  800d53:	74 05                	je     800d5a <strfind+0x1e>
	for (; *s; s++)
  800d55:	83 c0 01             	add    $0x1,%eax
  800d58:	eb f0                	jmp    800d4a <strfind+0xe>
			break;
	return (char *) s;
}
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d5c:	f3 0f 1e fb          	endbr32 
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d69:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d6c:	85 c9                	test   %ecx,%ecx
  800d6e:	74 31                	je     800da1 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d70:	89 f8                	mov    %edi,%eax
  800d72:	09 c8                	or     %ecx,%eax
  800d74:	a8 03                	test   $0x3,%al
  800d76:	75 23                	jne    800d9b <memset+0x3f>
		c &= 0xFF;
  800d78:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d7c:	89 d3                	mov    %edx,%ebx
  800d7e:	c1 e3 08             	shl    $0x8,%ebx
  800d81:	89 d0                	mov    %edx,%eax
  800d83:	c1 e0 18             	shl    $0x18,%eax
  800d86:	89 d6                	mov    %edx,%esi
  800d88:	c1 e6 10             	shl    $0x10,%esi
  800d8b:	09 f0                	or     %esi,%eax
  800d8d:	09 c2                	or     %eax,%edx
  800d8f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d91:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d94:	89 d0                	mov    %edx,%eax
  800d96:	fc                   	cld    
  800d97:	f3 ab                	rep stos %eax,%es:(%edi)
  800d99:	eb 06                	jmp    800da1 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	fc                   	cld    
  800d9f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800da1:	89 f8                	mov    %edi,%eax
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800da8:	f3 0f 1e fb          	endbr32 
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dba:	39 c6                	cmp    %eax,%esi
  800dbc:	73 32                	jae    800df0 <memmove+0x48>
  800dbe:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dc1:	39 c2                	cmp    %eax,%edx
  800dc3:	76 2b                	jbe    800df0 <memmove+0x48>
		s += n;
		d += n;
  800dc5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dc8:	89 fe                	mov    %edi,%esi
  800dca:	09 ce                	or     %ecx,%esi
  800dcc:	09 d6                	or     %edx,%esi
  800dce:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dd4:	75 0e                	jne    800de4 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dd6:	83 ef 04             	sub    $0x4,%edi
  800dd9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ddc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ddf:	fd                   	std    
  800de0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800de2:	eb 09                	jmp    800ded <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800de4:	83 ef 01             	sub    $0x1,%edi
  800de7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800dea:	fd                   	std    
  800deb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ded:	fc                   	cld    
  800dee:	eb 1a                	jmp    800e0a <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df0:	89 c2                	mov    %eax,%edx
  800df2:	09 ca                	or     %ecx,%edx
  800df4:	09 f2                	or     %esi,%edx
  800df6:	f6 c2 03             	test   $0x3,%dl
  800df9:	75 0a                	jne    800e05 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dfb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dfe:	89 c7                	mov    %eax,%edi
  800e00:	fc                   	cld    
  800e01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e03:	eb 05                	jmp    800e0a <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800e05:	89 c7                	mov    %eax,%edi
  800e07:	fc                   	cld    
  800e08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    

00800e0e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e0e:	f3 0f 1e fb          	endbr32 
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e18:	ff 75 10             	pushl  0x10(%ebp)
  800e1b:	ff 75 0c             	pushl  0xc(%ebp)
  800e1e:	ff 75 08             	pushl  0x8(%ebp)
  800e21:	e8 82 ff ff ff       	call   800da8 <memmove>
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e28:	f3 0f 1e fb          	endbr32 
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e37:	89 c6                	mov    %eax,%esi
  800e39:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3c:	39 f0                	cmp    %esi,%eax
  800e3e:	74 1c                	je     800e5c <memcmp+0x34>
		if (*s1 != *s2)
  800e40:	0f b6 08             	movzbl (%eax),%ecx
  800e43:	0f b6 1a             	movzbl (%edx),%ebx
  800e46:	38 d9                	cmp    %bl,%cl
  800e48:	75 08                	jne    800e52 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e4a:	83 c0 01             	add    $0x1,%eax
  800e4d:	83 c2 01             	add    $0x1,%edx
  800e50:	eb ea                	jmp    800e3c <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800e52:	0f b6 c1             	movzbl %cl,%eax
  800e55:	0f b6 db             	movzbl %bl,%ebx
  800e58:	29 d8                	sub    %ebx,%eax
  800e5a:	eb 05                	jmp    800e61 <memcmp+0x39>
	}

	return 0;
  800e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e65:	f3 0f 1e fb          	endbr32 
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e72:	89 c2                	mov    %eax,%edx
  800e74:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e77:	39 d0                	cmp    %edx,%eax
  800e79:	73 09                	jae    800e84 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e7b:	38 08                	cmp    %cl,(%eax)
  800e7d:	74 05                	je     800e84 <memfind+0x1f>
	for (; s < ends; s++)
  800e7f:	83 c0 01             	add    $0x1,%eax
  800e82:	eb f3                	jmp    800e77 <memfind+0x12>
			break;
	return (void *) s;
}
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e86:	f3 0f 1e fb          	endbr32 
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
  800e90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e96:	eb 03                	jmp    800e9b <strtol+0x15>
		s++;
  800e98:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e9b:	0f b6 01             	movzbl (%ecx),%eax
  800e9e:	3c 20                	cmp    $0x20,%al
  800ea0:	74 f6                	je     800e98 <strtol+0x12>
  800ea2:	3c 09                	cmp    $0x9,%al
  800ea4:	74 f2                	je     800e98 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ea6:	3c 2b                	cmp    $0x2b,%al
  800ea8:	74 2a                	je     800ed4 <strtol+0x4e>
	int neg = 0;
  800eaa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800eaf:	3c 2d                	cmp    $0x2d,%al
  800eb1:	74 2b                	je     800ede <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eb9:	75 0f                	jne    800eca <strtol+0x44>
  800ebb:	80 39 30             	cmpb   $0x30,(%ecx)
  800ebe:	74 28                	je     800ee8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ec0:	85 db                	test   %ebx,%ebx
  800ec2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec7:	0f 44 d8             	cmove  %eax,%ebx
  800eca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ed2:	eb 46                	jmp    800f1a <strtol+0x94>
		s++;
  800ed4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ed7:	bf 00 00 00 00       	mov    $0x0,%edi
  800edc:	eb d5                	jmp    800eb3 <strtol+0x2d>
		s++, neg = 1;
  800ede:	83 c1 01             	add    $0x1,%ecx
  800ee1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ee6:	eb cb                	jmp    800eb3 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800eec:	74 0e                	je     800efc <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800eee:	85 db                	test   %ebx,%ebx
  800ef0:	75 d8                	jne    800eca <strtol+0x44>
		s++, base = 8;
  800ef2:	83 c1 01             	add    $0x1,%ecx
  800ef5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800efa:	eb ce                	jmp    800eca <strtol+0x44>
		s += 2, base = 16;
  800efc:	83 c1 02             	add    $0x2,%ecx
  800eff:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f04:	eb c4                	jmp    800eca <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800f06:	0f be d2             	movsbl %dl,%edx
  800f09:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f0c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f0f:	7d 3a                	jge    800f4b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f11:	83 c1 01             	add    $0x1,%ecx
  800f14:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f18:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f1a:	0f b6 11             	movzbl (%ecx),%edx
  800f1d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f20:	89 f3                	mov    %esi,%ebx
  800f22:	80 fb 09             	cmp    $0x9,%bl
  800f25:	76 df                	jbe    800f06 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800f27:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f2a:	89 f3                	mov    %esi,%ebx
  800f2c:	80 fb 19             	cmp    $0x19,%bl
  800f2f:	77 08                	ja     800f39 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f31:	0f be d2             	movsbl %dl,%edx
  800f34:	83 ea 57             	sub    $0x57,%edx
  800f37:	eb d3                	jmp    800f0c <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800f39:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f3c:	89 f3                	mov    %esi,%ebx
  800f3e:	80 fb 19             	cmp    $0x19,%bl
  800f41:	77 08                	ja     800f4b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f43:	0f be d2             	movsbl %dl,%edx
  800f46:	83 ea 37             	sub    $0x37,%edx
  800f49:	eb c1                	jmp    800f0c <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f4f:	74 05                	je     800f56 <strtol+0xd0>
		*endptr = (char *) s;
  800f51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f54:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f56:	89 c2                	mov    %eax,%edx
  800f58:	f7 da                	neg    %edx
  800f5a:	85 ff                	test   %edi,%edi
  800f5c:	0f 45 c2             	cmovne %edx,%eax
}
  800f5f:	5b                   	pop    %ebx
  800f60:	5e                   	pop    %esi
  800f61:	5f                   	pop    %edi
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f64:	f3 0f 1e fb          	endbr32 
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	89 c3                	mov    %eax,%ebx
  800f7b:	89 c7                	mov    %eax,%edi
  800f7d:	89 c6                	mov    %eax,%esi
  800f7f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f86:	f3 0f 1e fb          	endbr32 
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f90:	ba 00 00 00 00       	mov    $0x0,%edx
  800f95:	b8 01 00 00 00       	mov    $0x1,%eax
  800f9a:	89 d1                	mov    %edx,%ecx
  800f9c:	89 d3                	mov    %edx,%ebx
  800f9e:	89 d7                	mov    %edx,%edi
  800fa0:	89 d6                	mov    %edx,%esi
  800fa2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fa9:	f3 0f 1e fb          	endbr32 
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbe:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc3:	89 cb                	mov    %ecx,%ebx
  800fc5:	89 cf                	mov    %ecx,%edi
  800fc7:	89 ce                	mov    %ecx,%esi
  800fc9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	7f 08                	jg     800fd7 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd2:	5b                   	pop    %ebx
  800fd3:	5e                   	pop    %esi
  800fd4:	5f                   	pop    %edi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd7:	83 ec 0c             	sub    $0xc,%esp
  800fda:	50                   	push   %eax
  800fdb:	6a 03                	push   $0x3
  800fdd:	68 1f 2d 80 00       	push   $0x802d1f
  800fe2:	6a 23                	push   $0x23
  800fe4:	68 3c 2d 80 00       	push   $0x802d3c
  800fe9:	e8 08 15 00 00       	call   8024f6 <_panic>

00800fee <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fee:	f3 0f 1e fb          	endbr32 
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	57                   	push   %edi
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ffd:	b8 02 00 00 00       	mov    $0x2,%eax
  801002:	89 d1                	mov    %edx,%ecx
  801004:	89 d3                	mov    %edx,%ebx
  801006:	89 d7                	mov    %edx,%edi
  801008:	89 d6                	mov    %edx,%esi
  80100a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <sys_yield>:

void
sys_yield(void)
{
  801011:	f3 0f 1e fb          	endbr32 
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	57                   	push   %edi
  801019:	56                   	push   %esi
  80101a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101b:	ba 00 00 00 00       	mov    $0x0,%edx
  801020:	b8 0b 00 00 00       	mov    $0xb,%eax
  801025:	89 d1                	mov    %edx,%ecx
  801027:	89 d3                	mov    %edx,%ebx
  801029:	89 d7                	mov    %edx,%edi
  80102b:	89 d6                	mov    %edx,%esi
  80102d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801034:	f3 0f 1e fb          	endbr32 
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
  80103e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801041:	be 00 00 00 00       	mov    $0x0,%esi
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104c:	b8 04 00 00 00       	mov    $0x4,%eax
  801051:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801054:	89 f7                	mov    %esi,%edi
  801056:	cd 30                	int    $0x30
	if(check && ret > 0)
  801058:	85 c0                	test   %eax,%eax
  80105a:	7f 08                	jg     801064 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80105c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105f:	5b                   	pop    %ebx
  801060:	5e                   	pop    %esi
  801061:	5f                   	pop    %edi
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801064:	83 ec 0c             	sub    $0xc,%esp
  801067:	50                   	push   %eax
  801068:	6a 04                	push   $0x4
  80106a:	68 1f 2d 80 00       	push   $0x802d1f
  80106f:	6a 23                	push   $0x23
  801071:	68 3c 2d 80 00       	push   $0x802d3c
  801076:	e8 7b 14 00 00       	call   8024f6 <_panic>

0080107b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80107b:	f3 0f 1e fb          	endbr32 
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
  801085:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108e:	b8 05 00 00 00       	mov    $0x5,%eax
  801093:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801096:	8b 7d 14             	mov    0x14(%ebp),%edi
  801099:	8b 75 18             	mov    0x18(%ebp),%esi
  80109c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	7f 08                	jg     8010aa <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a5:	5b                   	pop    %ebx
  8010a6:	5e                   	pop    %esi
  8010a7:	5f                   	pop    %edi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010aa:	83 ec 0c             	sub    $0xc,%esp
  8010ad:	50                   	push   %eax
  8010ae:	6a 05                	push   $0x5
  8010b0:	68 1f 2d 80 00       	push   $0x802d1f
  8010b5:	6a 23                	push   $0x23
  8010b7:	68 3c 2d 80 00       	push   $0x802d3c
  8010bc:	e8 35 14 00 00       	call   8024f6 <_panic>

008010c1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010c1:	f3 0f 1e fb          	endbr32 
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	57                   	push   %edi
  8010c9:	56                   	push   %esi
  8010ca:	53                   	push   %ebx
  8010cb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8010de:	89 df                	mov    %ebx,%edi
  8010e0:	89 de                	mov    %ebx,%esi
  8010e2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	7f 08                	jg     8010f0 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	50                   	push   %eax
  8010f4:	6a 06                	push   $0x6
  8010f6:	68 1f 2d 80 00       	push   $0x802d1f
  8010fb:	6a 23                	push   $0x23
  8010fd:	68 3c 2d 80 00       	push   $0x802d3c
  801102:	e8 ef 13 00 00       	call   8024f6 <_panic>

00801107 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801107:	f3 0f 1e fb          	endbr32 
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
  801111:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801114:	bb 00 00 00 00       	mov    $0x0,%ebx
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
  80111c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111f:	b8 08 00 00 00       	mov    $0x8,%eax
  801124:	89 df                	mov    %ebx,%edi
  801126:	89 de                	mov    %ebx,%esi
  801128:	cd 30                	int    $0x30
	if(check && ret > 0)
  80112a:	85 c0                	test   %eax,%eax
  80112c:	7f 08                	jg     801136 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80112e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	50                   	push   %eax
  80113a:	6a 08                	push   $0x8
  80113c:	68 1f 2d 80 00       	push   $0x802d1f
  801141:	6a 23                	push   $0x23
  801143:	68 3c 2d 80 00       	push   $0x802d3c
  801148:	e8 a9 13 00 00       	call   8024f6 <_panic>

0080114d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80114d:	f3 0f 1e fb          	endbr32 
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	57                   	push   %edi
  801155:	56                   	push   %esi
  801156:	53                   	push   %ebx
  801157:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80115a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115f:	8b 55 08             	mov    0x8(%ebp),%edx
  801162:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801165:	b8 09 00 00 00       	mov    $0x9,%eax
  80116a:	89 df                	mov    %ebx,%edi
  80116c:	89 de                	mov    %ebx,%esi
  80116e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801170:	85 c0                	test   %eax,%eax
  801172:	7f 08                	jg     80117c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801174:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801177:	5b                   	pop    %ebx
  801178:	5e                   	pop    %esi
  801179:	5f                   	pop    %edi
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80117c:	83 ec 0c             	sub    $0xc,%esp
  80117f:	50                   	push   %eax
  801180:	6a 09                	push   $0x9
  801182:	68 1f 2d 80 00       	push   $0x802d1f
  801187:	6a 23                	push   $0x23
  801189:	68 3c 2d 80 00       	push   $0x802d3c
  80118e:	e8 63 13 00 00       	call   8024f6 <_panic>

00801193 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801193:	f3 0f 1e fb          	endbr32 
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	57                   	push   %edi
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
  80119d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011b0:	89 df                	mov    %ebx,%edi
  8011b2:	89 de                	mov    %ebx,%esi
  8011b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	7f 08                	jg     8011c2 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011bd:	5b                   	pop    %ebx
  8011be:	5e                   	pop    %esi
  8011bf:	5f                   	pop    %edi
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c2:	83 ec 0c             	sub    $0xc,%esp
  8011c5:	50                   	push   %eax
  8011c6:	6a 0a                	push   $0xa
  8011c8:	68 1f 2d 80 00       	push   $0x802d1f
  8011cd:	6a 23                	push   $0x23
  8011cf:	68 3c 2d 80 00       	push   $0x802d3c
  8011d4:	e8 1d 13 00 00       	call   8024f6 <_panic>

008011d9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011d9:	f3 0f 1e fb          	endbr32 
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	57                   	push   %edi
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011ee:	be 00 00 00 00       	mov    $0x0,%esi
  8011f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011f9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801200:	f3 0f 1e fb          	endbr32 
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	57                   	push   %edi
  801208:	56                   	push   %esi
  801209:	53                   	push   %ebx
  80120a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80120d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801212:	8b 55 08             	mov    0x8(%ebp),%edx
  801215:	b8 0d 00 00 00       	mov    $0xd,%eax
  80121a:	89 cb                	mov    %ecx,%ebx
  80121c:	89 cf                	mov    %ecx,%edi
  80121e:	89 ce                	mov    %ecx,%esi
  801220:	cd 30                	int    $0x30
	if(check && ret > 0)
  801222:	85 c0                	test   %eax,%eax
  801224:	7f 08                	jg     80122e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801229:	5b                   	pop    %ebx
  80122a:	5e                   	pop    %esi
  80122b:	5f                   	pop    %edi
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	50                   	push   %eax
  801232:	6a 0d                	push   $0xd
  801234:	68 1f 2d 80 00       	push   $0x802d1f
  801239:	6a 23                	push   $0x23
  80123b:	68 3c 2d 80 00       	push   $0x802d3c
  801240:	e8 b1 12 00 00       	call   8024f6 <_panic>

00801245 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801245:	f3 0f 1e fb          	endbr32 
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	57                   	push   %edi
  80124d:	56                   	push   %esi
  80124e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80124f:	ba 00 00 00 00       	mov    $0x0,%edx
  801254:	b8 0e 00 00 00       	mov    $0xe,%eax
  801259:	89 d1                	mov    %edx,%ecx
  80125b:	89 d3                	mov    %edx,%ebx
  80125d:	89 d7                	mov    %edx,%edi
  80125f:	89 d6                	mov    %edx,%esi
  801261:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5f                   	pop    %edi
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    

00801268 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  801268:	f3 0f 1e fb          	endbr32 
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	57                   	push   %edi
  801270:	56                   	push   %esi
  801271:	53                   	push   %ebx
  801272:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801275:	bb 00 00 00 00       	mov    $0x0,%ebx
  80127a:	8b 55 08             	mov    0x8(%ebp),%edx
  80127d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801280:	b8 0f 00 00 00       	mov    $0xf,%eax
  801285:	89 df                	mov    %ebx,%edi
  801287:	89 de                	mov    %ebx,%esi
  801289:	cd 30                	int    $0x30
	if(check && ret > 0)
  80128b:	85 c0                	test   %eax,%eax
  80128d:	7f 08                	jg     801297 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  80128f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801292:	5b                   	pop    %ebx
  801293:	5e                   	pop    %esi
  801294:	5f                   	pop    %edi
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801297:	83 ec 0c             	sub    $0xc,%esp
  80129a:	50                   	push   %eax
  80129b:	6a 0f                	push   $0xf
  80129d:	68 1f 2d 80 00       	push   $0x802d1f
  8012a2:	6a 23                	push   $0x23
  8012a4:	68 3c 2d 80 00       	push   $0x802d3c
  8012a9:	e8 48 12 00 00       	call   8024f6 <_panic>

008012ae <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8012ae:	f3 0f 1e fb          	endbr32 
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	57                   	push   %edi
  8012b6:	56                   	push   %esi
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8012cb:	89 df                	mov    %ebx,%edi
  8012cd:	89 de                	mov    %ebx,%esi
  8012cf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	7f 08                	jg     8012dd <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  8012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d8:	5b                   	pop    %ebx
  8012d9:	5e                   	pop    %esi
  8012da:	5f                   	pop    %edi
  8012db:	5d                   	pop    %ebp
  8012dc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012dd:	83 ec 0c             	sub    $0xc,%esp
  8012e0:	50                   	push   %eax
  8012e1:	6a 10                	push   $0x10
  8012e3:	68 1f 2d 80 00       	push   $0x802d1f
  8012e8:	6a 23                	push   $0x23
  8012ea:	68 3c 2d 80 00       	push   $0x802d3c
  8012ef:	e8 02 12 00 00       	call   8024f6 <_panic>

008012f4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012f4:	f3 0f 1e fb          	endbr32 
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	05 00 00 00 30       	add    $0x30000000,%eax
  801303:	c1 e8 0c             	shr    $0xc,%eax
}
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    

00801308 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801308:	f3 0f 1e fb          	endbr32 
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801317:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80131c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    

00801323 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801323:	f3 0f 1e fb          	endbr32 
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80132f:	89 c2                	mov    %eax,%edx
  801331:	c1 ea 16             	shr    $0x16,%edx
  801334:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80133b:	f6 c2 01             	test   $0x1,%dl
  80133e:	74 2d                	je     80136d <fd_alloc+0x4a>
  801340:	89 c2                	mov    %eax,%edx
  801342:	c1 ea 0c             	shr    $0xc,%edx
  801345:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134c:	f6 c2 01             	test   $0x1,%dl
  80134f:	74 1c                	je     80136d <fd_alloc+0x4a>
  801351:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801356:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80135b:	75 d2                	jne    80132f <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801366:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80136b:	eb 0a                	jmp    801377 <fd_alloc+0x54>
			*fd_store = fd;
  80136d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801370:	89 01                	mov    %eax,(%ecx)
			return 0;
  801372:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801377:	5d                   	pop    %ebp
  801378:	c3                   	ret    

00801379 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801379:	f3 0f 1e fb          	endbr32 
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801383:	83 f8 1f             	cmp    $0x1f,%eax
  801386:	77 30                	ja     8013b8 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801388:	c1 e0 0c             	shl    $0xc,%eax
  80138b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801390:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801396:	f6 c2 01             	test   $0x1,%dl
  801399:	74 24                	je     8013bf <fd_lookup+0x46>
  80139b:	89 c2                	mov    %eax,%edx
  80139d:	c1 ea 0c             	shr    $0xc,%edx
  8013a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013a7:	f6 c2 01             	test   $0x1,%dl
  8013aa:	74 1a                	je     8013c6 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013af:	89 02                	mov    %eax,(%edx)
	return 0;
  8013b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    
		return -E_INVAL;
  8013b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bd:	eb f7                	jmp    8013b6 <fd_lookup+0x3d>
		return -E_INVAL;
  8013bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c4:	eb f0                	jmp    8013b6 <fd_lookup+0x3d>
  8013c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013cb:	eb e9                	jmp    8013b6 <fd_lookup+0x3d>

008013cd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013cd:	f3 0f 1e fb          	endbr32 
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013da:	ba 00 00 00 00       	mov    $0x0,%edx
  8013df:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013e4:	39 08                	cmp    %ecx,(%eax)
  8013e6:	74 38                	je     801420 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8013e8:	83 c2 01             	add    $0x1,%edx
  8013eb:	8b 04 95 c8 2d 80 00 	mov    0x802dc8(,%edx,4),%eax
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	75 ee                	jne    8013e4 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013f6:	a1 18 40 80 00       	mov    0x804018,%eax
  8013fb:	8b 40 48             	mov    0x48(%eax),%eax
  8013fe:	83 ec 04             	sub    $0x4,%esp
  801401:	51                   	push   %ecx
  801402:	50                   	push   %eax
  801403:	68 4c 2d 80 00       	push   $0x802d4c
  801408:	e8 db f1 ff ff       	call   8005e8 <cprintf>
	*dev = 0;
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    
			*dev = devtab[i];
  801420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801423:	89 01                	mov    %eax,(%ecx)
			return 0;
  801425:	b8 00 00 00 00       	mov    $0x0,%eax
  80142a:	eb f2                	jmp    80141e <dev_lookup+0x51>

0080142c <fd_close>:
{
  80142c:	f3 0f 1e fb          	endbr32 
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	57                   	push   %edi
  801434:	56                   	push   %esi
  801435:	53                   	push   %ebx
  801436:	83 ec 24             	sub    $0x24,%esp
  801439:	8b 75 08             	mov    0x8(%ebp),%esi
  80143c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80143f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801442:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801443:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801449:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80144c:	50                   	push   %eax
  80144d:	e8 27 ff ff ff       	call   801379 <fd_lookup>
  801452:	89 c3                	mov    %eax,%ebx
  801454:	83 c4 10             	add    $0x10,%esp
  801457:	85 c0                	test   %eax,%eax
  801459:	78 05                	js     801460 <fd_close+0x34>
	    || fd != fd2)
  80145b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80145e:	74 16                	je     801476 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801460:	89 f8                	mov    %edi,%eax
  801462:	84 c0                	test   %al,%al
  801464:	b8 00 00 00 00       	mov    $0x0,%eax
  801469:	0f 44 d8             	cmove  %eax,%ebx
}
  80146c:	89 d8                	mov    %ebx,%eax
  80146e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5f                   	pop    %edi
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80147c:	50                   	push   %eax
  80147d:	ff 36                	pushl  (%esi)
  80147f:	e8 49 ff ff ff       	call   8013cd <dev_lookup>
  801484:	89 c3                	mov    %eax,%ebx
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	85 c0                	test   %eax,%eax
  80148b:	78 1a                	js     8014a7 <fd_close+0x7b>
		if (dev->dev_close)
  80148d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801490:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801493:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801498:	85 c0                	test   %eax,%eax
  80149a:	74 0b                	je     8014a7 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	56                   	push   %esi
  8014a0:	ff d0                	call   *%eax
  8014a2:	89 c3                	mov    %eax,%ebx
  8014a4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	56                   	push   %esi
  8014ab:	6a 00                	push   $0x0
  8014ad:	e8 0f fc ff ff       	call   8010c1 <sys_page_unmap>
	return r;
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	eb b5                	jmp    80146c <fd_close+0x40>

008014b7 <close>:

int
close(int fdnum)
{
  8014b7:	f3 0f 1e fb          	endbr32 
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c4:	50                   	push   %eax
  8014c5:	ff 75 08             	pushl  0x8(%ebp)
  8014c8:	e8 ac fe ff ff       	call   801379 <fd_lookup>
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	79 02                	jns    8014d6 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    
		return fd_close(fd, 1);
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	6a 01                	push   $0x1
  8014db:	ff 75 f4             	pushl  -0xc(%ebp)
  8014de:	e8 49 ff ff ff       	call   80142c <fd_close>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	eb ec                	jmp    8014d4 <close+0x1d>

008014e8 <close_all>:

void
close_all(void)
{
  8014e8:	f3 0f 1e fb          	endbr32 
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	53                   	push   %ebx
  8014f0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014f3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014f8:	83 ec 0c             	sub    $0xc,%esp
  8014fb:	53                   	push   %ebx
  8014fc:	e8 b6 ff ff ff       	call   8014b7 <close>
	for (i = 0; i < MAXFD; i++)
  801501:	83 c3 01             	add    $0x1,%ebx
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	83 fb 20             	cmp    $0x20,%ebx
  80150a:	75 ec                	jne    8014f8 <close_all+0x10>
}
  80150c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801511:	f3 0f 1e fb          	endbr32 
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	57                   	push   %edi
  801519:	56                   	push   %esi
  80151a:	53                   	push   %ebx
  80151b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80151e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801521:	50                   	push   %eax
  801522:	ff 75 08             	pushl  0x8(%ebp)
  801525:	e8 4f fe ff ff       	call   801379 <fd_lookup>
  80152a:	89 c3                	mov    %eax,%ebx
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	0f 88 81 00 00 00    	js     8015b8 <dup+0xa7>
		return r;
	close(newfdnum);
  801537:	83 ec 0c             	sub    $0xc,%esp
  80153a:	ff 75 0c             	pushl  0xc(%ebp)
  80153d:	e8 75 ff ff ff       	call   8014b7 <close>

	newfd = INDEX2FD(newfdnum);
  801542:	8b 75 0c             	mov    0xc(%ebp),%esi
  801545:	c1 e6 0c             	shl    $0xc,%esi
  801548:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80154e:	83 c4 04             	add    $0x4,%esp
  801551:	ff 75 e4             	pushl  -0x1c(%ebp)
  801554:	e8 af fd ff ff       	call   801308 <fd2data>
  801559:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80155b:	89 34 24             	mov    %esi,(%esp)
  80155e:	e8 a5 fd ff ff       	call   801308 <fd2data>
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801568:	89 d8                	mov    %ebx,%eax
  80156a:	c1 e8 16             	shr    $0x16,%eax
  80156d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801574:	a8 01                	test   $0x1,%al
  801576:	74 11                	je     801589 <dup+0x78>
  801578:	89 d8                	mov    %ebx,%eax
  80157a:	c1 e8 0c             	shr    $0xc,%eax
  80157d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801584:	f6 c2 01             	test   $0x1,%dl
  801587:	75 39                	jne    8015c2 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801589:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80158c:	89 d0                	mov    %edx,%eax
  80158e:	c1 e8 0c             	shr    $0xc,%eax
  801591:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801598:	83 ec 0c             	sub    $0xc,%esp
  80159b:	25 07 0e 00 00       	and    $0xe07,%eax
  8015a0:	50                   	push   %eax
  8015a1:	56                   	push   %esi
  8015a2:	6a 00                	push   $0x0
  8015a4:	52                   	push   %edx
  8015a5:	6a 00                	push   $0x0
  8015a7:	e8 cf fa ff ff       	call   80107b <sys_page_map>
  8015ac:	89 c3                	mov    %eax,%ebx
  8015ae:	83 c4 20             	add    $0x20,%esp
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	78 31                	js     8015e6 <dup+0xd5>
		goto err;

	return newfdnum;
  8015b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015b8:	89 d8                	mov    %ebx,%eax
  8015ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bd:	5b                   	pop    %ebx
  8015be:	5e                   	pop    %esi
  8015bf:	5f                   	pop    %edi
  8015c0:	5d                   	pop    %ebp
  8015c1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015c9:	83 ec 0c             	sub    $0xc,%esp
  8015cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8015d1:	50                   	push   %eax
  8015d2:	57                   	push   %edi
  8015d3:	6a 00                	push   $0x0
  8015d5:	53                   	push   %ebx
  8015d6:	6a 00                	push   $0x0
  8015d8:	e8 9e fa ff ff       	call   80107b <sys_page_map>
  8015dd:	89 c3                	mov    %eax,%ebx
  8015df:	83 c4 20             	add    $0x20,%esp
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	79 a3                	jns    801589 <dup+0x78>
	sys_page_unmap(0, newfd);
  8015e6:	83 ec 08             	sub    $0x8,%esp
  8015e9:	56                   	push   %esi
  8015ea:	6a 00                	push   $0x0
  8015ec:	e8 d0 fa ff ff       	call   8010c1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015f1:	83 c4 08             	add    $0x8,%esp
  8015f4:	57                   	push   %edi
  8015f5:	6a 00                	push   $0x0
  8015f7:	e8 c5 fa ff ff       	call   8010c1 <sys_page_unmap>
	return r;
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	eb b7                	jmp    8015b8 <dup+0xa7>

00801601 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801601:	f3 0f 1e fb          	endbr32 
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	53                   	push   %ebx
  801609:	83 ec 1c             	sub    $0x1c,%esp
  80160c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801612:	50                   	push   %eax
  801613:	53                   	push   %ebx
  801614:	e8 60 fd ff ff       	call   801379 <fd_lookup>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 3f                	js     80165f <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801620:	83 ec 08             	sub    $0x8,%esp
  801623:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801626:	50                   	push   %eax
  801627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162a:	ff 30                	pushl  (%eax)
  80162c:	e8 9c fd ff ff       	call   8013cd <dev_lookup>
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	85 c0                	test   %eax,%eax
  801636:	78 27                	js     80165f <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801638:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163b:	8b 42 08             	mov    0x8(%edx),%eax
  80163e:	83 e0 03             	and    $0x3,%eax
  801641:	83 f8 01             	cmp    $0x1,%eax
  801644:	74 1e                	je     801664 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801649:	8b 40 08             	mov    0x8(%eax),%eax
  80164c:	85 c0                	test   %eax,%eax
  80164e:	74 35                	je     801685 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	ff 75 10             	pushl  0x10(%ebp)
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	52                   	push   %edx
  80165a:	ff d0                	call   *%eax
  80165c:	83 c4 10             	add    $0x10,%esp
}
  80165f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801662:	c9                   	leave  
  801663:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801664:	a1 18 40 80 00       	mov    0x804018,%eax
  801669:	8b 40 48             	mov    0x48(%eax),%eax
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	53                   	push   %ebx
  801670:	50                   	push   %eax
  801671:	68 8d 2d 80 00       	push   $0x802d8d
  801676:	e8 6d ef ff ff       	call   8005e8 <cprintf>
		return -E_INVAL;
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801683:	eb da                	jmp    80165f <read+0x5e>
		return -E_NOT_SUPP;
  801685:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80168a:	eb d3                	jmp    80165f <read+0x5e>

0080168c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80168c:	f3 0f 1e fb          	endbr32 
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	57                   	push   %edi
  801694:	56                   	push   %esi
  801695:	53                   	push   %ebx
  801696:	83 ec 0c             	sub    $0xc,%esp
  801699:	8b 7d 08             	mov    0x8(%ebp),%edi
  80169c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80169f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a4:	eb 02                	jmp    8016a8 <readn+0x1c>
  8016a6:	01 c3                	add    %eax,%ebx
  8016a8:	39 f3                	cmp    %esi,%ebx
  8016aa:	73 21                	jae    8016cd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	89 f0                	mov    %esi,%eax
  8016b1:	29 d8                	sub    %ebx,%eax
  8016b3:	50                   	push   %eax
  8016b4:	89 d8                	mov    %ebx,%eax
  8016b6:	03 45 0c             	add    0xc(%ebp),%eax
  8016b9:	50                   	push   %eax
  8016ba:	57                   	push   %edi
  8016bb:	e8 41 ff ff ff       	call   801601 <read>
		if (m < 0)
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	78 04                	js     8016cb <readn+0x3f>
			return m;
		if (m == 0)
  8016c7:	75 dd                	jne    8016a6 <readn+0x1a>
  8016c9:	eb 02                	jmp    8016cd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016cb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016cd:	89 d8                	mov    %ebx,%eax
  8016cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d2:	5b                   	pop    %ebx
  8016d3:	5e                   	pop    %esi
  8016d4:	5f                   	pop    %edi
  8016d5:	5d                   	pop    %ebp
  8016d6:	c3                   	ret    

008016d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016d7:	f3 0f 1e fb          	endbr32 
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	53                   	push   %ebx
  8016df:	83 ec 1c             	sub    $0x1c,%esp
  8016e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e8:	50                   	push   %eax
  8016e9:	53                   	push   %ebx
  8016ea:	e8 8a fc ff ff       	call   801379 <fd_lookup>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	78 3a                	js     801730 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fc:	50                   	push   %eax
  8016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801700:	ff 30                	pushl  (%eax)
  801702:	e8 c6 fc ff ff       	call   8013cd <dev_lookup>
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 22                	js     801730 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80170e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801711:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801715:	74 1e                	je     801735 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171a:	8b 52 0c             	mov    0xc(%edx),%edx
  80171d:	85 d2                	test   %edx,%edx
  80171f:	74 35                	je     801756 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	ff 75 10             	pushl  0x10(%ebp)
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	50                   	push   %eax
  80172b:	ff d2                	call   *%edx
  80172d:	83 c4 10             	add    $0x10,%esp
}
  801730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801733:	c9                   	leave  
  801734:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801735:	a1 18 40 80 00       	mov    0x804018,%eax
  80173a:	8b 40 48             	mov    0x48(%eax),%eax
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	53                   	push   %ebx
  801741:	50                   	push   %eax
  801742:	68 a9 2d 80 00       	push   $0x802da9
  801747:	e8 9c ee ff ff       	call   8005e8 <cprintf>
		return -E_INVAL;
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801754:	eb da                	jmp    801730 <write+0x59>
		return -E_NOT_SUPP;
  801756:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80175b:	eb d3                	jmp    801730 <write+0x59>

0080175d <seek>:

int
seek(int fdnum, off_t offset)
{
  80175d:	f3 0f 1e fb          	endbr32 
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801767:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176a:	50                   	push   %eax
  80176b:	ff 75 08             	pushl  0x8(%ebp)
  80176e:	e8 06 fc ff ff       	call   801379 <fd_lookup>
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	85 c0                	test   %eax,%eax
  801778:	78 0e                	js     801788 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80177a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801780:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80178a:	f3 0f 1e fb          	endbr32 
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	53                   	push   %ebx
  801792:	83 ec 1c             	sub    $0x1c,%esp
  801795:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801798:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179b:	50                   	push   %eax
  80179c:	53                   	push   %ebx
  80179d:	e8 d7 fb ff ff       	call   801379 <fd_lookup>
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 37                	js     8017e0 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017af:	50                   	push   %eax
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	ff 30                	pushl  (%eax)
  8017b5:	e8 13 fc ff ff       	call   8013cd <dev_lookup>
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 1f                	js     8017e0 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017c8:	74 1b                	je     8017e5 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017cd:	8b 52 18             	mov    0x18(%edx),%edx
  8017d0:	85 d2                	test   %edx,%edx
  8017d2:	74 32                	je     801806 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	50                   	push   %eax
  8017db:	ff d2                	call   *%edx
  8017dd:	83 c4 10             	add    $0x10,%esp
}
  8017e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017e5:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017ea:	8b 40 48             	mov    0x48(%eax),%eax
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	53                   	push   %ebx
  8017f1:	50                   	push   %eax
  8017f2:	68 6c 2d 80 00       	push   $0x802d6c
  8017f7:	e8 ec ed ff ff       	call   8005e8 <cprintf>
		return -E_INVAL;
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801804:	eb da                	jmp    8017e0 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801806:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80180b:	eb d3                	jmp    8017e0 <ftruncate+0x56>

0080180d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80180d:	f3 0f 1e fb          	endbr32 
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	53                   	push   %ebx
  801815:	83 ec 1c             	sub    $0x1c,%esp
  801818:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181e:	50                   	push   %eax
  80181f:	ff 75 08             	pushl  0x8(%ebp)
  801822:	e8 52 fb ff ff       	call   801379 <fd_lookup>
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	85 c0                	test   %eax,%eax
  80182c:	78 4b                	js     801879 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182e:	83 ec 08             	sub    $0x8,%esp
  801831:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801834:	50                   	push   %eax
  801835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801838:	ff 30                	pushl  (%eax)
  80183a:	e8 8e fb ff ff       	call   8013cd <dev_lookup>
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	78 33                	js     801879 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801849:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80184d:	74 2f                	je     80187e <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80184f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801852:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801859:	00 00 00 
	stat->st_isdir = 0;
  80185c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801863:	00 00 00 
	stat->st_dev = dev;
  801866:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	53                   	push   %ebx
  801870:	ff 75 f0             	pushl  -0x10(%ebp)
  801873:	ff 50 14             	call   *0x14(%eax)
  801876:	83 c4 10             	add    $0x10,%esp
}
  801879:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    
		return -E_NOT_SUPP;
  80187e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801883:	eb f4                	jmp    801879 <fstat+0x6c>

00801885 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801885:	f3 0f 1e fb          	endbr32 
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	56                   	push   %esi
  80188d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80188e:	83 ec 08             	sub    $0x8,%esp
  801891:	6a 00                	push   $0x0
  801893:	ff 75 08             	pushl  0x8(%ebp)
  801896:	e8 fb 01 00 00       	call   801a96 <open>
  80189b:	89 c3                	mov    %eax,%ebx
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	78 1b                	js     8018bf <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018a4:	83 ec 08             	sub    $0x8,%esp
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	50                   	push   %eax
  8018ab:	e8 5d ff ff ff       	call   80180d <fstat>
  8018b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8018b2:	89 1c 24             	mov    %ebx,(%esp)
  8018b5:	e8 fd fb ff ff       	call   8014b7 <close>
	return r;
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	89 f3                	mov    %esi,%ebx
}
  8018bf:	89 d8                	mov    %ebx,%eax
  8018c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c4:	5b                   	pop    %ebx
  8018c5:	5e                   	pop    %esi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    

008018c8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	56                   	push   %esi
  8018cc:	53                   	push   %ebx
  8018cd:	89 c6                	mov    %eax,%esi
  8018cf:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018d1:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  8018d8:	74 27                	je     801901 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018da:	6a 07                	push   $0x7
  8018dc:	68 00 50 80 00       	push   $0x805000
  8018e1:	56                   	push   %esi
  8018e2:	ff 35 10 40 80 00    	pushl  0x804010
  8018e8:	e8 d8 0c 00 00       	call   8025c5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018ed:	83 c4 0c             	add    $0xc,%esp
  8018f0:	6a 00                	push   $0x0
  8018f2:	53                   	push   %ebx
  8018f3:	6a 00                	push   $0x0
  8018f5:	e8 46 0c 00 00       	call   802540 <ipc_recv>
}
  8018fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5e                   	pop    %esi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801901:	83 ec 0c             	sub    $0xc,%esp
  801904:	6a 01                	push   $0x1
  801906:	e8 12 0d 00 00       	call   80261d <ipc_find_env>
  80190b:	a3 10 40 80 00       	mov    %eax,0x804010
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	eb c5                	jmp    8018da <fsipc+0x12>

00801915 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801915:	f3 0f 1e fb          	endbr32 
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	8b 40 0c             	mov    0xc(%eax),%eax
  801925:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80192a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801932:	ba 00 00 00 00       	mov    $0x0,%edx
  801937:	b8 02 00 00 00       	mov    $0x2,%eax
  80193c:	e8 87 ff ff ff       	call   8018c8 <fsipc>
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <devfile_flush>:
{
  801943:	f3 0f 1e fb          	endbr32 
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8b 40 0c             	mov    0xc(%eax),%eax
  801953:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801958:	ba 00 00 00 00       	mov    $0x0,%edx
  80195d:	b8 06 00 00 00       	mov    $0x6,%eax
  801962:	e8 61 ff ff ff       	call   8018c8 <fsipc>
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <devfile_stat>:
{
  801969:	f3 0f 1e fb          	endbr32 
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	53                   	push   %ebx
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8b 40 0c             	mov    0xc(%eax),%eax
  80197d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801982:	ba 00 00 00 00       	mov    $0x0,%edx
  801987:	b8 05 00 00 00       	mov    $0x5,%eax
  80198c:	e8 37 ff ff ff       	call   8018c8 <fsipc>
  801991:	85 c0                	test   %eax,%eax
  801993:	78 2c                	js     8019c1 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801995:	83 ec 08             	sub    $0x8,%esp
  801998:	68 00 50 80 00       	push   $0x805000
  80199d:	53                   	push   %ebx
  80199e:	e8 4f f2 ff ff       	call   800bf2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019a3:	a1 80 50 80 00       	mov    0x805080,%eax
  8019a8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019ae:	a1 84 50 80 00       	mov    0x805084,%eax
  8019b3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <devfile_write>:
{
  8019c6:	f3 0f 1e fb          	endbr32 
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 0c             	sub    $0xc,%esp
  8019d0:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d6:	8b 52 0c             	mov    0xc(%edx),%edx
  8019d9:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8019df:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019e4:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019e9:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8019ec:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019f1:	50                   	push   %eax
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	68 08 50 80 00       	push   $0x805008
  8019fa:	e8 a9 f3 ff ff       	call   800da8 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8019ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801a04:	b8 04 00 00 00       	mov    $0x4,%eax
  801a09:	e8 ba fe ff ff       	call   8018c8 <fsipc>
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <devfile_read>:
{
  801a10:	f3 0f 1e fb          	endbr32 
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
  801a19:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a22:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a27:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a32:	b8 03 00 00 00       	mov    $0x3,%eax
  801a37:	e8 8c fe ff ff       	call   8018c8 <fsipc>
  801a3c:	89 c3                	mov    %eax,%ebx
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 1f                	js     801a61 <devfile_read+0x51>
	assert(r <= n);
  801a42:	39 f0                	cmp    %esi,%eax
  801a44:	77 24                	ja     801a6a <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a46:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a4b:	7f 33                	jg     801a80 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	50                   	push   %eax
  801a51:	68 00 50 80 00       	push   $0x805000
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	e8 4a f3 ff ff       	call   800da8 <memmove>
	return r;
  801a5e:	83 c4 10             	add    $0x10,%esp
}
  801a61:	89 d8                	mov    %ebx,%eax
  801a63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a66:	5b                   	pop    %ebx
  801a67:	5e                   	pop    %esi
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    
	assert(r <= n);
  801a6a:	68 dc 2d 80 00       	push   $0x802ddc
  801a6f:	68 e3 2d 80 00       	push   $0x802de3
  801a74:	6a 7c                	push   $0x7c
  801a76:	68 f8 2d 80 00       	push   $0x802df8
  801a7b:	e8 76 0a 00 00       	call   8024f6 <_panic>
	assert(r <= PGSIZE);
  801a80:	68 03 2e 80 00       	push   $0x802e03
  801a85:	68 e3 2d 80 00       	push   $0x802de3
  801a8a:	6a 7d                	push   $0x7d
  801a8c:	68 f8 2d 80 00       	push   $0x802df8
  801a91:	e8 60 0a 00 00       	call   8024f6 <_panic>

00801a96 <open>:
{
  801a96:	f3 0f 1e fb          	endbr32 
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	56                   	push   %esi
  801a9e:	53                   	push   %ebx
  801a9f:	83 ec 1c             	sub    $0x1c,%esp
  801aa2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801aa5:	56                   	push   %esi
  801aa6:	e8 04 f1 ff ff       	call   800baf <strlen>
  801aab:	83 c4 10             	add    $0x10,%esp
  801aae:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ab3:	7f 6c                	jg     801b21 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801ab5:	83 ec 0c             	sub    $0xc,%esp
  801ab8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abb:	50                   	push   %eax
  801abc:	e8 62 f8 ff ff       	call   801323 <fd_alloc>
  801ac1:	89 c3                	mov    %eax,%ebx
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 3c                	js     801b06 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801aca:	83 ec 08             	sub    $0x8,%esp
  801acd:	56                   	push   %esi
  801ace:	68 00 50 80 00       	push   $0x805000
  801ad3:	e8 1a f1 ff ff       	call   800bf2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ae0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae8:	e8 db fd ff ff       	call   8018c8 <fsipc>
  801aed:	89 c3                	mov    %eax,%ebx
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 19                	js     801b0f <open+0x79>
	return fd2num(fd);
  801af6:	83 ec 0c             	sub    $0xc,%esp
  801af9:	ff 75 f4             	pushl  -0xc(%ebp)
  801afc:	e8 f3 f7 ff ff       	call   8012f4 <fd2num>
  801b01:	89 c3                	mov    %eax,%ebx
  801b03:	83 c4 10             	add    $0x10,%esp
}
  801b06:	89 d8                	mov    %ebx,%eax
  801b08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5e                   	pop    %esi
  801b0d:	5d                   	pop    %ebp
  801b0e:	c3                   	ret    
		fd_close(fd, 0);
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 f4             	pushl  -0xc(%ebp)
  801b17:	e8 10 f9 ff ff       	call   80142c <fd_close>
		return r;
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	eb e5                	jmp    801b06 <open+0x70>
		return -E_BAD_PATH;
  801b21:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b26:	eb de                	jmp    801b06 <open+0x70>

00801b28 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b28:	f3 0f 1e fb          	endbr32 
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b32:	ba 00 00 00 00       	mov    $0x0,%edx
  801b37:	b8 08 00 00 00       	mov    $0x8,%eax
  801b3c:	e8 87 fd ff ff       	call   8018c8 <fsipc>
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b43:	f3 0f 1e fb          	endbr32 
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b4d:	68 0f 2e 80 00       	push   $0x802e0f
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	e8 98 f0 ff ff       	call   800bf2 <strcpy>
	return 0;
}
  801b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <devsock_close>:
{
  801b61:	f3 0f 1e fb          	endbr32 
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	53                   	push   %ebx
  801b69:	83 ec 10             	sub    $0x10,%esp
  801b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b6f:	53                   	push   %ebx
  801b70:	e8 e5 0a 00 00       	call   80265a <pageref>
  801b75:	89 c2                	mov    %eax,%edx
  801b77:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801b7f:	83 fa 01             	cmp    $0x1,%edx
  801b82:	74 05                	je     801b89 <devsock_close+0x28>
}
  801b84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b89:	83 ec 0c             	sub    $0xc,%esp
  801b8c:	ff 73 0c             	pushl  0xc(%ebx)
  801b8f:	e8 e3 02 00 00       	call   801e77 <nsipc_close>
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	eb eb                	jmp    801b84 <devsock_close+0x23>

00801b99 <devsock_write>:
{
  801b99:	f3 0f 1e fb          	endbr32 
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	ff 70 0c             	pushl  0xc(%eax)
  801bb1:	e8 b5 03 00 00       	call   801f6b <nsipc_send>
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <devsock_read>:
{
  801bb8:	f3 0f 1e fb          	endbr32 
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	ff 75 10             	pushl  0x10(%ebp)
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	ff 70 0c             	pushl  0xc(%eax)
  801bd0:	e8 1f 03 00 00       	call   801ef4 <nsipc_recv>
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <fd2sockid>:
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bdd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801be0:	52                   	push   %edx
  801be1:	50                   	push   %eax
  801be2:	e8 92 f7 ff ff       	call   801379 <fd_lookup>
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 10                	js     801bfe <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801bf7:	39 08                	cmp    %ecx,(%eax)
  801bf9:	75 05                	jne    801c00 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801bfb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    
		return -E_NOT_SUPP;
  801c00:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c05:	eb f7                	jmp    801bfe <fd2sockid+0x27>

00801c07 <alloc_sockfd>:
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	56                   	push   %esi
  801c0b:	53                   	push   %ebx
  801c0c:	83 ec 1c             	sub    $0x1c,%esp
  801c0f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c14:	50                   	push   %eax
  801c15:	e8 09 f7 ff ff       	call   801323 <fd_alloc>
  801c1a:	89 c3                	mov    %eax,%ebx
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 43                	js     801c66 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	68 07 04 00 00       	push   $0x407
  801c2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2e:	6a 00                	push   $0x0
  801c30:	e8 ff f3 ff ff       	call   801034 <sys_page_alloc>
  801c35:	89 c3                	mov    %eax,%ebx
  801c37:	83 c4 10             	add    $0x10,%esp
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	78 28                	js     801c66 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c41:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801c47:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c53:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c56:	83 ec 0c             	sub    $0xc,%esp
  801c59:	50                   	push   %eax
  801c5a:	e8 95 f6 ff ff       	call   8012f4 <fd2num>
  801c5f:	89 c3                	mov    %eax,%ebx
  801c61:	83 c4 10             	add    $0x10,%esp
  801c64:	eb 0c                	jmp    801c72 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c66:	83 ec 0c             	sub    $0xc,%esp
  801c69:	56                   	push   %esi
  801c6a:	e8 08 02 00 00       	call   801e77 <nsipc_close>
		return r;
  801c6f:	83 c4 10             	add    $0x10,%esp
}
  801c72:	89 d8                	mov    %ebx,%eax
  801c74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    

00801c7b <accept>:
{
  801c7b:	f3 0f 1e fb          	endbr32 
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	e8 4a ff ff ff       	call   801bd7 <fd2sockid>
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	78 1b                	js     801cac <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c91:	83 ec 04             	sub    $0x4,%esp
  801c94:	ff 75 10             	pushl  0x10(%ebp)
  801c97:	ff 75 0c             	pushl  0xc(%ebp)
  801c9a:	50                   	push   %eax
  801c9b:	e8 22 01 00 00       	call   801dc2 <nsipc_accept>
  801ca0:	83 c4 10             	add    $0x10,%esp
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	78 05                	js     801cac <accept+0x31>
	return alloc_sockfd(r);
  801ca7:	e8 5b ff ff ff       	call   801c07 <alloc_sockfd>
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <bind>:
{
  801cae:	f3 0f 1e fb          	endbr32 
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	e8 17 ff ff ff       	call   801bd7 <fd2sockid>
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	78 12                	js     801cd6 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	ff 75 10             	pushl  0x10(%ebp)
  801cca:	ff 75 0c             	pushl  0xc(%ebp)
  801ccd:	50                   	push   %eax
  801cce:	e8 45 01 00 00       	call   801e18 <nsipc_bind>
  801cd3:	83 c4 10             	add    $0x10,%esp
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <shutdown>:
{
  801cd8:	f3 0f 1e fb          	endbr32 
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	e8 ed fe ff ff       	call   801bd7 <fd2sockid>
  801cea:	85 c0                	test   %eax,%eax
  801cec:	78 0f                	js     801cfd <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801cee:	83 ec 08             	sub    $0x8,%esp
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	50                   	push   %eax
  801cf5:	e8 57 01 00 00       	call   801e51 <nsipc_shutdown>
  801cfa:	83 c4 10             	add    $0x10,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <connect>:
{
  801cff:	f3 0f 1e fb          	endbr32 
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	e8 c6 fe ff ff       	call   801bd7 <fd2sockid>
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 12                	js     801d27 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d15:	83 ec 04             	sub    $0x4,%esp
  801d18:	ff 75 10             	pushl  0x10(%ebp)
  801d1b:	ff 75 0c             	pushl  0xc(%ebp)
  801d1e:	50                   	push   %eax
  801d1f:	e8 71 01 00 00       	call   801e95 <nsipc_connect>
  801d24:	83 c4 10             	add    $0x10,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <listen>:
{
  801d29:	f3 0f 1e fb          	endbr32 
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	e8 9c fe ff ff       	call   801bd7 <fd2sockid>
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	78 0f                	js     801d4e <listen+0x25>
	return nsipc_listen(r, backlog);
  801d3f:	83 ec 08             	sub    $0x8,%esp
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	50                   	push   %eax
  801d46:	e8 83 01 00 00       	call   801ece <nsipc_listen>
  801d4b:	83 c4 10             	add    $0x10,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d50:	f3 0f 1e fb          	endbr32 
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d5a:	ff 75 10             	pushl  0x10(%ebp)
  801d5d:	ff 75 0c             	pushl  0xc(%ebp)
  801d60:	ff 75 08             	pushl  0x8(%ebp)
  801d63:	e8 65 02 00 00       	call   801fcd <nsipc_socket>
  801d68:	83 c4 10             	add    $0x10,%esp
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	78 05                	js     801d74 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d6f:	e8 93 fe ff ff       	call   801c07 <alloc_sockfd>
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	53                   	push   %ebx
  801d7a:	83 ec 04             	sub    $0x4,%esp
  801d7d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d7f:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801d86:	74 26                	je     801dae <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d88:	6a 07                	push   $0x7
  801d8a:	68 00 60 80 00       	push   $0x806000
  801d8f:	53                   	push   %ebx
  801d90:	ff 35 14 40 80 00    	pushl  0x804014
  801d96:	e8 2a 08 00 00       	call   8025c5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d9b:	83 c4 0c             	add    $0xc,%esp
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	e8 97 07 00 00       	call   802540 <ipc_recv>
}
  801da9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801dae:	83 ec 0c             	sub    $0xc,%esp
  801db1:	6a 02                	push   $0x2
  801db3:	e8 65 08 00 00       	call   80261d <ipc_find_env>
  801db8:	a3 14 40 80 00       	mov    %eax,0x804014
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	eb c6                	jmp    801d88 <nsipc+0x12>

00801dc2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dc2:	f3 0f 1e fb          	endbr32 
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	56                   	push   %esi
  801dca:	53                   	push   %ebx
  801dcb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801dd6:	8b 06                	mov    (%esi),%eax
  801dd8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ddd:	b8 01 00 00 00       	mov    $0x1,%eax
  801de2:	e8 8f ff ff ff       	call   801d76 <nsipc>
  801de7:	89 c3                	mov    %eax,%ebx
  801de9:	85 c0                	test   %eax,%eax
  801deb:	79 09                	jns    801df6 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ded:	89 d8                	mov    %ebx,%eax
  801def:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df2:	5b                   	pop    %ebx
  801df3:	5e                   	pop    %esi
  801df4:	5d                   	pop    %ebp
  801df5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	ff 35 10 60 80 00    	pushl  0x806010
  801dff:	68 00 60 80 00       	push   $0x806000
  801e04:	ff 75 0c             	pushl  0xc(%ebp)
  801e07:	e8 9c ef ff ff       	call   800da8 <memmove>
		*addrlen = ret->ret_addrlen;
  801e0c:	a1 10 60 80 00       	mov    0x806010,%eax
  801e11:	89 06                	mov    %eax,(%esi)
  801e13:	83 c4 10             	add    $0x10,%esp
	return r;
  801e16:	eb d5                	jmp    801ded <nsipc_accept+0x2b>

00801e18 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e18:	f3 0f 1e fb          	endbr32 
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	53                   	push   %ebx
  801e20:	83 ec 08             	sub    $0x8,%esp
  801e23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e2e:	53                   	push   %ebx
  801e2f:	ff 75 0c             	pushl  0xc(%ebp)
  801e32:	68 04 60 80 00       	push   $0x806004
  801e37:	e8 6c ef ff ff       	call   800da8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e3c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e42:	b8 02 00 00 00       	mov    $0x2,%eax
  801e47:	e8 2a ff ff ff       	call   801d76 <nsipc>
}
  801e4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e51:	f3 0f 1e fb          	endbr32 
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e66:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e6b:	b8 03 00 00 00       	mov    $0x3,%eax
  801e70:	e8 01 ff ff ff       	call   801d76 <nsipc>
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <nsipc_close>:

int
nsipc_close(int s)
{
  801e77:	f3 0f 1e fb          	endbr32 
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e81:	8b 45 08             	mov    0x8(%ebp),%eax
  801e84:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e89:	b8 04 00 00 00       	mov    $0x4,%eax
  801e8e:	e8 e3 fe ff ff       	call   801d76 <nsipc>
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e95:	f3 0f 1e fb          	endbr32 
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	53                   	push   %ebx
  801e9d:	83 ec 08             	sub    $0x8,%esp
  801ea0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801eab:	53                   	push   %ebx
  801eac:	ff 75 0c             	pushl  0xc(%ebp)
  801eaf:	68 04 60 80 00       	push   $0x806004
  801eb4:	e8 ef ee ff ff       	call   800da8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801eb9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ebf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ec4:	e8 ad fe ff ff       	call   801d76 <nsipc>
}
  801ec9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ece:	f3 0f 1e fb          	endbr32 
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ee8:	b8 06 00 00 00       	mov    $0x6,%eax
  801eed:	e8 84 fe ff ff       	call   801d76 <nsipc>
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ef4:	f3 0f 1e fb          	endbr32 
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	56                   	push   %esi
  801efc:	53                   	push   %ebx
  801efd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f08:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f11:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f16:	b8 07 00 00 00       	mov    $0x7,%eax
  801f1b:	e8 56 fe ff ff       	call   801d76 <nsipc>
  801f20:	89 c3                	mov    %eax,%ebx
  801f22:	85 c0                	test   %eax,%eax
  801f24:	78 26                	js     801f4c <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f26:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f2c:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f31:	0f 4e c6             	cmovle %esi,%eax
  801f34:	39 c3                	cmp    %eax,%ebx
  801f36:	7f 1d                	jg     801f55 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	53                   	push   %ebx
  801f3c:	68 00 60 80 00       	push   $0x806000
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	e8 5f ee ff ff       	call   800da8 <memmove>
  801f49:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f4c:	89 d8                	mov    %ebx,%eax
  801f4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f51:	5b                   	pop    %ebx
  801f52:	5e                   	pop    %esi
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f55:	68 1b 2e 80 00       	push   $0x802e1b
  801f5a:	68 e3 2d 80 00       	push   $0x802de3
  801f5f:	6a 62                	push   $0x62
  801f61:	68 30 2e 80 00       	push   $0x802e30
  801f66:	e8 8b 05 00 00       	call   8024f6 <_panic>

00801f6b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f6b:	f3 0f 1e fb          	endbr32 
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	53                   	push   %ebx
  801f73:	83 ec 04             	sub    $0x4,%esp
  801f76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f81:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f87:	7f 2e                	jg     801fb7 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f89:	83 ec 04             	sub    $0x4,%esp
  801f8c:	53                   	push   %ebx
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	68 0c 60 80 00       	push   $0x80600c
  801f95:	e8 0e ee ff ff       	call   800da8 <memmove>
	nsipcbuf.send.req_size = size;
  801f9a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801fa0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801fa8:	b8 08 00 00 00       	mov    $0x8,%eax
  801fad:	e8 c4 fd ff ff       	call   801d76 <nsipc>
}
  801fb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    
	assert(size < 1600);
  801fb7:	68 3c 2e 80 00       	push   $0x802e3c
  801fbc:	68 e3 2d 80 00       	push   $0x802de3
  801fc1:	6a 6d                	push   $0x6d
  801fc3:	68 30 2e 80 00       	push   $0x802e30
  801fc8:	e8 29 05 00 00       	call   8024f6 <_panic>

00801fcd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fcd:	f3 0f 1e fb          	endbr32 
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe2:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fea:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801fef:	b8 09 00 00 00       	mov    $0x9,%eax
  801ff4:	e8 7d fd ff ff       	call   801d76 <nsipc>
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ffb:	f3 0f 1e fb          	endbr32 
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	ff 75 08             	pushl  0x8(%ebp)
  80200d:	e8 f6 f2 ff ff       	call   801308 <fd2data>
  802012:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802014:	83 c4 08             	add    $0x8,%esp
  802017:	68 48 2e 80 00       	push   $0x802e48
  80201c:	53                   	push   %ebx
  80201d:	e8 d0 eb ff ff       	call   800bf2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802022:	8b 46 04             	mov    0x4(%esi),%eax
  802025:	2b 06                	sub    (%esi),%eax
  802027:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80202d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802034:	00 00 00 
	stat->st_dev = &devpipe;
  802037:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  80203e:	30 80 00 
	return 0;
}
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802049:	5b                   	pop    %ebx
  80204a:	5e                   	pop    %esi
  80204b:	5d                   	pop    %ebp
  80204c:	c3                   	ret    

0080204d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80204d:	f3 0f 1e fb          	endbr32 
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	53                   	push   %ebx
  802055:	83 ec 0c             	sub    $0xc,%esp
  802058:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80205b:	53                   	push   %ebx
  80205c:	6a 00                	push   $0x0
  80205e:	e8 5e f0 ff ff       	call   8010c1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802063:	89 1c 24             	mov    %ebx,(%esp)
  802066:	e8 9d f2 ff ff       	call   801308 <fd2data>
  80206b:	83 c4 08             	add    $0x8,%esp
  80206e:	50                   	push   %eax
  80206f:	6a 00                	push   $0x0
  802071:	e8 4b f0 ff ff       	call   8010c1 <sys_page_unmap>
}
  802076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <_pipeisclosed>:
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	57                   	push   %edi
  80207f:	56                   	push   %esi
  802080:	53                   	push   %ebx
  802081:	83 ec 1c             	sub    $0x1c,%esp
  802084:	89 c7                	mov    %eax,%edi
  802086:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802088:	a1 18 40 80 00       	mov    0x804018,%eax
  80208d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802090:	83 ec 0c             	sub    $0xc,%esp
  802093:	57                   	push   %edi
  802094:	e8 c1 05 00 00       	call   80265a <pageref>
  802099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80209c:	89 34 24             	mov    %esi,(%esp)
  80209f:	e8 b6 05 00 00       	call   80265a <pageref>
		nn = thisenv->env_runs;
  8020a4:	8b 15 18 40 80 00    	mov    0x804018,%edx
  8020aa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020ad:	83 c4 10             	add    $0x10,%esp
  8020b0:	39 cb                	cmp    %ecx,%ebx
  8020b2:	74 1b                	je     8020cf <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020b4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020b7:	75 cf                	jne    802088 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020b9:	8b 42 58             	mov    0x58(%edx),%eax
  8020bc:	6a 01                	push   $0x1
  8020be:	50                   	push   %eax
  8020bf:	53                   	push   %ebx
  8020c0:	68 4f 2e 80 00       	push   $0x802e4f
  8020c5:	e8 1e e5 ff ff       	call   8005e8 <cprintf>
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	eb b9                	jmp    802088 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020cf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020d2:	0f 94 c0             	sete   %al
  8020d5:	0f b6 c0             	movzbl %al,%eax
}
  8020d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020db:	5b                   	pop    %ebx
  8020dc:	5e                   	pop    %esi
  8020dd:	5f                   	pop    %edi
  8020de:	5d                   	pop    %ebp
  8020df:	c3                   	ret    

008020e0 <devpipe_write>:
{
  8020e0:	f3 0f 1e fb          	endbr32 
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	57                   	push   %edi
  8020e8:	56                   	push   %esi
  8020e9:	53                   	push   %ebx
  8020ea:	83 ec 28             	sub    $0x28,%esp
  8020ed:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020f0:	56                   	push   %esi
  8020f1:	e8 12 f2 ff ff       	call   801308 <fd2data>
  8020f6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802100:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802103:	74 4f                	je     802154 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802105:	8b 43 04             	mov    0x4(%ebx),%eax
  802108:	8b 0b                	mov    (%ebx),%ecx
  80210a:	8d 51 20             	lea    0x20(%ecx),%edx
  80210d:	39 d0                	cmp    %edx,%eax
  80210f:	72 14                	jb     802125 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802111:	89 da                	mov    %ebx,%edx
  802113:	89 f0                	mov    %esi,%eax
  802115:	e8 61 ff ff ff       	call   80207b <_pipeisclosed>
  80211a:	85 c0                	test   %eax,%eax
  80211c:	75 3b                	jne    802159 <devpipe_write+0x79>
			sys_yield();
  80211e:	e8 ee ee ff ff       	call   801011 <sys_yield>
  802123:	eb e0                	jmp    802105 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802125:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802128:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80212c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80212f:	89 c2                	mov    %eax,%edx
  802131:	c1 fa 1f             	sar    $0x1f,%edx
  802134:	89 d1                	mov    %edx,%ecx
  802136:	c1 e9 1b             	shr    $0x1b,%ecx
  802139:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80213c:	83 e2 1f             	and    $0x1f,%edx
  80213f:	29 ca                	sub    %ecx,%edx
  802141:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802145:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802149:	83 c0 01             	add    $0x1,%eax
  80214c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80214f:	83 c7 01             	add    $0x1,%edi
  802152:	eb ac                	jmp    802100 <devpipe_write+0x20>
	return i;
  802154:	8b 45 10             	mov    0x10(%ebp),%eax
  802157:	eb 05                	jmp    80215e <devpipe_write+0x7e>
				return 0;
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5f                   	pop    %edi
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    

00802166 <devpipe_read>:
{
  802166:	f3 0f 1e fb          	endbr32 
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	57                   	push   %edi
  80216e:	56                   	push   %esi
  80216f:	53                   	push   %ebx
  802170:	83 ec 18             	sub    $0x18,%esp
  802173:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802176:	57                   	push   %edi
  802177:	e8 8c f1 ff ff       	call   801308 <fd2data>
  80217c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	be 00 00 00 00       	mov    $0x0,%esi
  802186:	3b 75 10             	cmp    0x10(%ebp),%esi
  802189:	75 14                	jne    80219f <devpipe_read+0x39>
	return i;
  80218b:	8b 45 10             	mov    0x10(%ebp),%eax
  80218e:	eb 02                	jmp    802192 <devpipe_read+0x2c>
				return i;
  802190:	89 f0                	mov    %esi,%eax
}
  802192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802195:	5b                   	pop    %ebx
  802196:	5e                   	pop    %esi
  802197:	5f                   	pop    %edi
  802198:	5d                   	pop    %ebp
  802199:	c3                   	ret    
			sys_yield();
  80219a:	e8 72 ee ff ff       	call   801011 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80219f:	8b 03                	mov    (%ebx),%eax
  8021a1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021a4:	75 18                	jne    8021be <devpipe_read+0x58>
			if (i > 0)
  8021a6:	85 f6                	test   %esi,%esi
  8021a8:	75 e6                	jne    802190 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8021aa:	89 da                	mov    %ebx,%edx
  8021ac:	89 f8                	mov    %edi,%eax
  8021ae:	e8 c8 fe ff ff       	call   80207b <_pipeisclosed>
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	74 e3                	je     80219a <devpipe_read+0x34>
				return 0;
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bc:	eb d4                	jmp    802192 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021be:	99                   	cltd   
  8021bf:	c1 ea 1b             	shr    $0x1b,%edx
  8021c2:	01 d0                	add    %edx,%eax
  8021c4:	83 e0 1f             	and    $0x1f,%eax
  8021c7:	29 d0                	sub    %edx,%eax
  8021c9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021d1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021d4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021d7:	83 c6 01             	add    $0x1,%esi
  8021da:	eb aa                	jmp    802186 <devpipe_read+0x20>

008021dc <pipe>:
{
  8021dc:	f3 0f 1e fb          	endbr32 
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	56                   	push   %esi
  8021e4:	53                   	push   %ebx
  8021e5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021eb:	50                   	push   %eax
  8021ec:	e8 32 f1 ff ff       	call   801323 <fd_alloc>
  8021f1:	89 c3                	mov    %eax,%ebx
  8021f3:	83 c4 10             	add    $0x10,%esp
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	0f 88 23 01 00 00    	js     802321 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	68 07 04 00 00       	push   $0x407
  802206:	ff 75 f4             	pushl  -0xc(%ebp)
  802209:	6a 00                	push   $0x0
  80220b:	e8 24 ee ff ff       	call   801034 <sys_page_alloc>
  802210:	89 c3                	mov    %eax,%ebx
  802212:	83 c4 10             	add    $0x10,%esp
  802215:	85 c0                	test   %eax,%eax
  802217:	0f 88 04 01 00 00    	js     802321 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80221d:	83 ec 0c             	sub    $0xc,%esp
  802220:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802223:	50                   	push   %eax
  802224:	e8 fa f0 ff ff       	call   801323 <fd_alloc>
  802229:	89 c3                	mov    %eax,%ebx
  80222b:	83 c4 10             	add    $0x10,%esp
  80222e:	85 c0                	test   %eax,%eax
  802230:	0f 88 db 00 00 00    	js     802311 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	68 07 04 00 00       	push   $0x407
  80223e:	ff 75 f0             	pushl  -0x10(%ebp)
  802241:	6a 00                	push   $0x0
  802243:	e8 ec ed ff ff       	call   801034 <sys_page_alloc>
  802248:	89 c3                	mov    %eax,%ebx
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	85 c0                	test   %eax,%eax
  80224f:	0f 88 bc 00 00 00    	js     802311 <pipe+0x135>
	va = fd2data(fd0);
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	ff 75 f4             	pushl  -0xc(%ebp)
  80225b:	e8 a8 f0 ff ff       	call   801308 <fd2data>
  802260:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802262:	83 c4 0c             	add    $0xc,%esp
  802265:	68 07 04 00 00       	push   $0x407
  80226a:	50                   	push   %eax
  80226b:	6a 00                	push   $0x0
  80226d:	e8 c2 ed ff ff       	call   801034 <sys_page_alloc>
  802272:	89 c3                	mov    %eax,%ebx
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	85 c0                	test   %eax,%eax
  802279:	0f 88 82 00 00 00    	js     802301 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80227f:	83 ec 0c             	sub    $0xc,%esp
  802282:	ff 75 f0             	pushl  -0x10(%ebp)
  802285:	e8 7e f0 ff ff       	call   801308 <fd2data>
  80228a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802291:	50                   	push   %eax
  802292:	6a 00                	push   $0x0
  802294:	56                   	push   %esi
  802295:	6a 00                	push   $0x0
  802297:	e8 df ed ff ff       	call   80107b <sys_page_map>
  80229c:	89 c3                	mov    %eax,%ebx
  80229e:	83 c4 20             	add    $0x20,%esp
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	78 4e                	js     8022f3 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8022a5:	a1 40 30 80 00       	mov    0x803040,%eax
  8022aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ad:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022bc:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ce:	e8 21 f0 ff ff       	call   8012f4 <fd2num>
  8022d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022d6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022d8:	83 c4 04             	add    $0x4,%esp
  8022db:	ff 75 f0             	pushl  -0x10(%ebp)
  8022de:	e8 11 f0 ff ff       	call   8012f4 <fd2num>
  8022e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022e6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022e9:	83 c4 10             	add    $0x10,%esp
  8022ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022f1:	eb 2e                	jmp    802321 <pipe+0x145>
	sys_page_unmap(0, va);
  8022f3:	83 ec 08             	sub    $0x8,%esp
  8022f6:	56                   	push   %esi
  8022f7:	6a 00                	push   $0x0
  8022f9:	e8 c3 ed ff ff       	call   8010c1 <sys_page_unmap>
  8022fe:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802301:	83 ec 08             	sub    $0x8,%esp
  802304:	ff 75 f0             	pushl  -0x10(%ebp)
  802307:	6a 00                	push   $0x0
  802309:	e8 b3 ed ff ff       	call   8010c1 <sys_page_unmap>
  80230e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802311:	83 ec 08             	sub    $0x8,%esp
  802314:	ff 75 f4             	pushl  -0xc(%ebp)
  802317:	6a 00                	push   $0x0
  802319:	e8 a3 ed ff ff       	call   8010c1 <sys_page_unmap>
  80231e:	83 c4 10             	add    $0x10,%esp
}
  802321:	89 d8                	mov    %ebx,%eax
  802323:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802326:	5b                   	pop    %ebx
  802327:	5e                   	pop    %esi
  802328:	5d                   	pop    %ebp
  802329:	c3                   	ret    

0080232a <pipeisclosed>:
{
  80232a:	f3 0f 1e fb          	endbr32 
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802334:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802337:	50                   	push   %eax
  802338:	ff 75 08             	pushl  0x8(%ebp)
  80233b:	e8 39 f0 ff ff       	call   801379 <fd_lookup>
  802340:	83 c4 10             	add    $0x10,%esp
  802343:	85 c0                	test   %eax,%eax
  802345:	78 18                	js     80235f <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802347:	83 ec 0c             	sub    $0xc,%esp
  80234a:	ff 75 f4             	pushl  -0xc(%ebp)
  80234d:	e8 b6 ef ff ff       	call   801308 <fd2data>
  802352:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	e8 1f fd ff ff       	call   80207b <_pipeisclosed>
  80235c:	83 c4 10             	add    $0x10,%esp
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802361:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802365:	b8 00 00 00 00       	mov    $0x0,%eax
  80236a:	c3                   	ret    

0080236b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80236b:	f3 0f 1e fb          	endbr32 
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802375:	68 67 2e 80 00       	push   $0x802e67
  80237a:	ff 75 0c             	pushl  0xc(%ebp)
  80237d:	e8 70 e8 ff ff       	call   800bf2 <strcpy>
	return 0;
}
  802382:	b8 00 00 00 00       	mov    $0x0,%eax
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <devcons_write>:
{
  802389:	f3 0f 1e fb          	endbr32 
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	57                   	push   %edi
  802391:	56                   	push   %esi
  802392:	53                   	push   %ebx
  802393:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802399:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80239e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023a4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023a7:	73 31                	jae    8023da <devcons_write+0x51>
		m = n - tot;
  8023a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023ac:	29 f3                	sub    %esi,%ebx
  8023ae:	83 fb 7f             	cmp    $0x7f,%ebx
  8023b1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023b6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	53                   	push   %ebx
  8023bd:	89 f0                	mov    %esi,%eax
  8023bf:	03 45 0c             	add    0xc(%ebp),%eax
  8023c2:	50                   	push   %eax
  8023c3:	57                   	push   %edi
  8023c4:	e8 df e9 ff ff       	call   800da8 <memmove>
		sys_cputs(buf, m);
  8023c9:	83 c4 08             	add    $0x8,%esp
  8023cc:	53                   	push   %ebx
  8023cd:	57                   	push   %edi
  8023ce:	e8 91 eb ff ff       	call   800f64 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023d3:	01 de                	add    %ebx,%esi
  8023d5:	83 c4 10             	add    $0x10,%esp
  8023d8:	eb ca                	jmp    8023a4 <devcons_write+0x1b>
}
  8023da:	89 f0                	mov    %esi,%eax
  8023dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5f                   	pop    %edi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    

008023e4 <devcons_read>:
{
  8023e4:	f3 0f 1e fb          	endbr32 
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	83 ec 08             	sub    $0x8,%esp
  8023ee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023f7:	74 21                	je     80241a <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8023f9:	e8 88 eb ff ff       	call   800f86 <sys_cgetc>
  8023fe:	85 c0                	test   %eax,%eax
  802400:	75 07                	jne    802409 <devcons_read+0x25>
		sys_yield();
  802402:	e8 0a ec ff ff       	call   801011 <sys_yield>
  802407:	eb f0                	jmp    8023f9 <devcons_read+0x15>
	if (c < 0)
  802409:	78 0f                	js     80241a <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80240b:	83 f8 04             	cmp    $0x4,%eax
  80240e:	74 0c                	je     80241c <devcons_read+0x38>
	*(char*)vbuf = c;
  802410:	8b 55 0c             	mov    0xc(%ebp),%edx
  802413:	88 02                	mov    %al,(%edx)
	return 1;
  802415:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    
		return 0;
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
  802421:	eb f7                	jmp    80241a <devcons_read+0x36>

00802423 <cputchar>:
{
  802423:	f3 0f 1e fb          	endbr32 
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802433:	6a 01                	push   $0x1
  802435:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802438:	50                   	push   %eax
  802439:	e8 26 eb ff ff       	call   800f64 <sys_cputs>
}
  80243e:	83 c4 10             	add    $0x10,%esp
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <getchar>:
{
  802443:	f3 0f 1e fb          	endbr32 
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80244d:	6a 01                	push   $0x1
  80244f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802452:	50                   	push   %eax
  802453:	6a 00                	push   $0x0
  802455:	e8 a7 f1 ff ff       	call   801601 <read>
	if (r < 0)
  80245a:	83 c4 10             	add    $0x10,%esp
  80245d:	85 c0                	test   %eax,%eax
  80245f:	78 06                	js     802467 <getchar+0x24>
	if (r < 1)
  802461:	74 06                	je     802469 <getchar+0x26>
	return c;
  802463:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    
		return -E_EOF;
  802469:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80246e:	eb f7                	jmp    802467 <getchar+0x24>

00802470 <iscons>:
{
  802470:	f3 0f 1e fb          	endbr32 
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80247a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80247d:	50                   	push   %eax
  80247e:	ff 75 08             	pushl  0x8(%ebp)
  802481:	e8 f3 ee ff ff       	call   801379 <fd_lookup>
  802486:	83 c4 10             	add    $0x10,%esp
  802489:	85 c0                	test   %eax,%eax
  80248b:	78 11                	js     80249e <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802496:	39 10                	cmp    %edx,(%eax)
  802498:	0f 94 c0             	sete   %al
  80249b:	0f b6 c0             	movzbl %al,%eax
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <opencons>:
{
  8024a0:	f3 0f 1e fb          	endbr32 
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ad:	50                   	push   %eax
  8024ae:	e8 70 ee ff ff       	call   801323 <fd_alloc>
  8024b3:	83 c4 10             	add    $0x10,%esp
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	78 3a                	js     8024f4 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024ba:	83 ec 04             	sub    $0x4,%esp
  8024bd:	68 07 04 00 00       	push   $0x407
  8024c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c5:	6a 00                	push   $0x0
  8024c7:	e8 68 eb ff ff       	call   801034 <sys_page_alloc>
  8024cc:	83 c4 10             	add    $0x10,%esp
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	78 21                	js     8024f4 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8024dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024e8:	83 ec 0c             	sub    $0xc,%esp
  8024eb:	50                   	push   %eax
  8024ec:	e8 03 ee ff ff       	call   8012f4 <fd2num>
  8024f1:	83 c4 10             	add    $0x10,%esp
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8024f6:	f3 0f 1e fb          	endbr32 
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	56                   	push   %esi
  8024fe:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8024ff:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802502:	8b 35 04 30 80 00    	mov    0x803004,%esi
  802508:	e8 e1 ea ff ff       	call   800fee <sys_getenvid>
  80250d:	83 ec 0c             	sub    $0xc,%esp
  802510:	ff 75 0c             	pushl  0xc(%ebp)
  802513:	ff 75 08             	pushl  0x8(%ebp)
  802516:	56                   	push   %esi
  802517:	50                   	push   %eax
  802518:	68 74 2e 80 00       	push   $0x802e74
  80251d:	e8 c6 e0 ff ff       	call   8005e8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802522:	83 c4 18             	add    $0x18,%esp
  802525:	53                   	push   %ebx
  802526:	ff 75 10             	pushl  0x10(%ebp)
  802529:	e8 65 e0 ff ff       	call   800593 <vcprintf>
	cprintf("\n");
  80252e:	c7 04 24 b4 29 80 00 	movl   $0x8029b4,(%esp)
  802535:	e8 ae e0 ff ff       	call   8005e8 <cprintf>
  80253a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80253d:	cc                   	int3   
  80253e:	eb fd                	jmp    80253d <_panic+0x47>

00802540 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802540:	f3 0f 1e fb          	endbr32 
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	56                   	push   %esi
  802548:	53                   	push   %ebx
  802549:	8b 75 08             	mov    0x8(%ebp),%esi
  80254c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802552:	85 c0                	test   %eax,%eax
  802554:	74 3d                	je     802593 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802556:	83 ec 0c             	sub    $0xc,%esp
  802559:	50                   	push   %eax
  80255a:	e8 a1 ec ff ff       	call   801200 <sys_ipc_recv>
  80255f:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802562:	85 f6                	test   %esi,%esi
  802564:	74 0b                	je     802571 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802566:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80256c:	8b 52 74             	mov    0x74(%edx),%edx
  80256f:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802571:	85 db                	test   %ebx,%ebx
  802573:	74 0b                	je     802580 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802575:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80257b:	8b 52 78             	mov    0x78(%edx),%edx
  80257e:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802580:	85 c0                	test   %eax,%eax
  802582:	78 21                	js     8025a5 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802584:	a1 18 40 80 00       	mov    0x804018,%eax
  802589:	8b 40 70             	mov    0x70(%eax),%eax
}
  80258c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80258f:	5b                   	pop    %ebx
  802590:	5e                   	pop    %esi
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802593:	83 ec 0c             	sub    $0xc,%esp
  802596:	68 00 00 c0 ee       	push   $0xeec00000
  80259b:	e8 60 ec ff ff       	call   801200 <sys_ipc_recv>
  8025a0:	83 c4 10             	add    $0x10,%esp
  8025a3:	eb bd                	jmp    802562 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8025a5:	85 f6                	test   %esi,%esi
  8025a7:	74 10                	je     8025b9 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8025a9:	85 db                	test   %ebx,%ebx
  8025ab:	75 df                	jne    80258c <ipc_recv+0x4c>
  8025ad:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8025b4:	00 00 00 
  8025b7:	eb d3                	jmp    80258c <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8025b9:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8025c0:	00 00 00 
  8025c3:	eb e4                	jmp    8025a9 <ipc_recv+0x69>

008025c5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025c5:	f3 0f 1e fb          	endbr32 
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	57                   	push   %edi
  8025cd:	56                   	push   %esi
  8025ce:	53                   	push   %ebx
  8025cf:	83 ec 0c             	sub    $0xc,%esp
  8025d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8025d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8025d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8025db:	85 db                	test   %ebx,%ebx
  8025dd:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8025e2:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8025e5:	ff 75 14             	pushl  0x14(%ebp)
  8025e8:	53                   	push   %ebx
  8025e9:	56                   	push   %esi
  8025ea:	57                   	push   %edi
  8025eb:	e8 e9 eb ff ff       	call   8011d9 <sys_ipc_try_send>
  8025f0:	83 c4 10             	add    $0x10,%esp
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	79 1e                	jns    802615 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8025f7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025fa:	75 07                	jne    802603 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8025fc:	e8 10 ea ff ff       	call   801011 <sys_yield>
  802601:	eb e2                	jmp    8025e5 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802603:	50                   	push   %eax
  802604:	68 97 2e 80 00       	push   $0x802e97
  802609:	6a 59                	push   $0x59
  80260b:	68 b2 2e 80 00       	push   $0x802eb2
  802610:	e8 e1 fe ff ff       	call   8024f6 <_panic>
	}
}
  802615:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802618:	5b                   	pop    %ebx
  802619:	5e                   	pop    %esi
  80261a:	5f                   	pop    %edi
  80261b:	5d                   	pop    %ebp
  80261c:	c3                   	ret    

0080261d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80261d:	f3 0f 1e fb          	endbr32 
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
  802624:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802627:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80262c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80262f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802635:	8b 52 50             	mov    0x50(%edx),%edx
  802638:	39 ca                	cmp    %ecx,%edx
  80263a:	74 11                	je     80264d <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80263c:	83 c0 01             	add    $0x1,%eax
  80263f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802644:	75 e6                	jne    80262c <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802646:	b8 00 00 00 00       	mov    $0x0,%eax
  80264b:	eb 0b                	jmp    802658 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80264d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802650:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802655:	8b 40 48             	mov    0x48(%eax),%eax
}
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    

0080265a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80265a:	f3 0f 1e fb          	endbr32 
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802664:	89 c2                	mov    %eax,%edx
  802666:	c1 ea 16             	shr    $0x16,%edx
  802669:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802670:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802675:	f6 c1 01             	test   $0x1,%cl
  802678:	74 1c                	je     802696 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80267a:	c1 e8 0c             	shr    $0xc,%eax
  80267d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802684:	a8 01                	test   $0x1,%al
  802686:	74 0e                	je     802696 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802688:	c1 e8 0c             	shr    $0xc,%eax
  80268b:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802692:	ef 
  802693:	0f b7 d2             	movzwl %dx,%edx
}
  802696:	89 d0                	mov    %edx,%eax
  802698:	5d                   	pop    %ebp
  802699:	c3                   	ret    
  80269a:	66 90                	xchg   %ax,%ax
  80269c:	66 90                	xchg   %ax,%ax
  80269e:	66 90                	xchg   %ax,%ax

008026a0 <__udivdi3>:
  8026a0:	f3 0f 1e fb          	endbr32 
  8026a4:	55                   	push   %ebp
  8026a5:	57                   	push   %edi
  8026a6:	56                   	push   %esi
  8026a7:	53                   	push   %ebx
  8026a8:	83 ec 1c             	sub    $0x1c,%esp
  8026ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8026af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8026b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8026bb:	85 d2                	test   %edx,%edx
  8026bd:	75 19                	jne    8026d8 <__udivdi3+0x38>
  8026bf:	39 f3                	cmp    %esi,%ebx
  8026c1:	76 4d                	jbe    802710 <__udivdi3+0x70>
  8026c3:	31 ff                	xor    %edi,%edi
  8026c5:	89 e8                	mov    %ebp,%eax
  8026c7:	89 f2                	mov    %esi,%edx
  8026c9:	f7 f3                	div    %ebx
  8026cb:	89 fa                	mov    %edi,%edx
  8026cd:	83 c4 1c             	add    $0x1c,%esp
  8026d0:	5b                   	pop    %ebx
  8026d1:	5e                   	pop    %esi
  8026d2:	5f                   	pop    %edi
  8026d3:	5d                   	pop    %ebp
  8026d4:	c3                   	ret    
  8026d5:	8d 76 00             	lea    0x0(%esi),%esi
  8026d8:	39 f2                	cmp    %esi,%edx
  8026da:	76 14                	jbe    8026f0 <__udivdi3+0x50>
  8026dc:	31 ff                	xor    %edi,%edi
  8026de:	31 c0                	xor    %eax,%eax
  8026e0:	89 fa                	mov    %edi,%edx
  8026e2:	83 c4 1c             	add    $0x1c,%esp
  8026e5:	5b                   	pop    %ebx
  8026e6:	5e                   	pop    %esi
  8026e7:	5f                   	pop    %edi
  8026e8:	5d                   	pop    %ebp
  8026e9:	c3                   	ret    
  8026ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026f0:	0f bd fa             	bsr    %edx,%edi
  8026f3:	83 f7 1f             	xor    $0x1f,%edi
  8026f6:	75 48                	jne    802740 <__udivdi3+0xa0>
  8026f8:	39 f2                	cmp    %esi,%edx
  8026fa:	72 06                	jb     802702 <__udivdi3+0x62>
  8026fc:	31 c0                	xor    %eax,%eax
  8026fe:	39 eb                	cmp    %ebp,%ebx
  802700:	77 de                	ja     8026e0 <__udivdi3+0x40>
  802702:	b8 01 00 00 00       	mov    $0x1,%eax
  802707:	eb d7                	jmp    8026e0 <__udivdi3+0x40>
  802709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802710:	89 d9                	mov    %ebx,%ecx
  802712:	85 db                	test   %ebx,%ebx
  802714:	75 0b                	jne    802721 <__udivdi3+0x81>
  802716:	b8 01 00 00 00       	mov    $0x1,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	f7 f3                	div    %ebx
  80271f:	89 c1                	mov    %eax,%ecx
  802721:	31 d2                	xor    %edx,%edx
  802723:	89 f0                	mov    %esi,%eax
  802725:	f7 f1                	div    %ecx
  802727:	89 c6                	mov    %eax,%esi
  802729:	89 e8                	mov    %ebp,%eax
  80272b:	89 f7                	mov    %esi,%edi
  80272d:	f7 f1                	div    %ecx
  80272f:	89 fa                	mov    %edi,%edx
  802731:	83 c4 1c             	add    $0x1c,%esp
  802734:	5b                   	pop    %ebx
  802735:	5e                   	pop    %esi
  802736:	5f                   	pop    %edi
  802737:	5d                   	pop    %ebp
  802738:	c3                   	ret    
  802739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802740:	89 f9                	mov    %edi,%ecx
  802742:	b8 20 00 00 00       	mov    $0x20,%eax
  802747:	29 f8                	sub    %edi,%eax
  802749:	d3 e2                	shl    %cl,%edx
  80274b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80274f:	89 c1                	mov    %eax,%ecx
  802751:	89 da                	mov    %ebx,%edx
  802753:	d3 ea                	shr    %cl,%edx
  802755:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802759:	09 d1                	or     %edx,%ecx
  80275b:	89 f2                	mov    %esi,%edx
  80275d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802761:	89 f9                	mov    %edi,%ecx
  802763:	d3 e3                	shl    %cl,%ebx
  802765:	89 c1                	mov    %eax,%ecx
  802767:	d3 ea                	shr    %cl,%edx
  802769:	89 f9                	mov    %edi,%ecx
  80276b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80276f:	89 eb                	mov    %ebp,%ebx
  802771:	d3 e6                	shl    %cl,%esi
  802773:	89 c1                	mov    %eax,%ecx
  802775:	d3 eb                	shr    %cl,%ebx
  802777:	09 de                	or     %ebx,%esi
  802779:	89 f0                	mov    %esi,%eax
  80277b:	f7 74 24 08          	divl   0x8(%esp)
  80277f:	89 d6                	mov    %edx,%esi
  802781:	89 c3                	mov    %eax,%ebx
  802783:	f7 64 24 0c          	mull   0xc(%esp)
  802787:	39 d6                	cmp    %edx,%esi
  802789:	72 15                	jb     8027a0 <__udivdi3+0x100>
  80278b:	89 f9                	mov    %edi,%ecx
  80278d:	d3 e5                	shl    %cl,%ebp
  80278f:	39 c5                	cmp    %eax,%ebp
  802791:	73 04                	jae    802797 <__udivdi3+0xf7>
  802793:	39 d6                	cmp    %edx,%esi
  802795:	74 09                	je     8027a0 <__udivdi3+0x100>
  802797:	89 d8                	mov    %ebx,%eax
  802799:	31 ff                	xor    %edi,%edi
  80279b:	e9 40 ff ff ff       	jmp    8026e0 <__udivdi3+0x40>
  8027a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027a3:	31 ff                	xor    %edi,%edi
  8027a5:	e9 36 ff ff ff       	jmp    8026e0 <__udivdi3+0x40>
  8027aa:	66 90                	xchg   %ax,%ax
  8027ac:	66 90                	xchg   %ax,%ax
  8027ae:	66 90                	xchg   %ax,%ax

008027b0 <__umoddi3>:
  8027b0:	f3 0f 1e fb          	endbr32 
  8027b4:	55                   	push   %ebp
  8027b5:	57                   	push   %edi
  8027b6:	56                   	push   %esi
  8027b7:	53                   	push   %ebx
  8027b8:	83 ec 1c             	sub    $0x1c,%esp
  8027bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8027c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8027c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	75 19                	jne    8027e8 <__umoddi3+0x38>
  8027cf:	39 df                	cmp    %ebx,%edi
  8027d1:	76 5d                	jbe    802830 <__umoddi3+0x80>
  8027d3:	89 f0                	mov    %esi,%eax
  8027d5:	89 da                	mov    %ebx,%edx
  8027d7:	f7 f7                	div    %edi
  8027d9:	89 d0                	mov    %edx,%eax
  8027db:	31 d2                	xor    %edx,%edx
  8027dd:	83 c4 1c             	add    $0x1c,%esp
  8027e0:	5b                   	pop    %ebx
  8027e1:	5e                   	pop    %esi
  8027e2:	5f                   	pop    %edi
  8027e3:	5d                   	pop    %ebp
  8027e4:	c3                   	ret    
  8027e5:	8d 76 00             	lea    0x0(%esi),%esi
  8027e8:	89 f2                	mov    %esi,%edx
  8027ea:	39 d8                	cmp    %ebx,%eax
  8027ec:	76 12                	jbe    802800 <__umoddi3+0x50>
  8027ee:	89 f0                	mov    %esi,%eax
  8027f0:	89 da                	mov    %ebx,%edx
  8027f2:	83 c4 1c             	add    $0x1c,%esp
  8027f5:	5b                   	pop    %ebx
  8027f6:	5e                   	pop    %esi
  8027f7:	5f                   	pop    %edi
  8027f8:	5d                   	pop    %ebp
  8027f9:	c3                   	ret    
  8027fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802800:	0f bd e8             	bsr    %eax,%ebp
  802803:	83 f5 1f             	xor    $0x1f,%ebp
  802806:	75 50                	jne    802858 <__umoddi3+0xa8>
  802808:	39 d8                	cmp    %ebx,%eax
  80280a:	0f 82 e0 00 00 00    	jb     8028f0 <__umoddi3+0x140>
  802810:	89 d9                	mov    %ebx,%ecx
  802812:	39 f7                	cmp    %esi,%edi
  802814:	0f 86 d6 00 00 00    	jbe    8028f0 <__umoddi3+0x140>
  80281a:	89 d0                	mov    %edx,%eax
  80281c:	89 ca                	mov    %ecx,%edx
  80281e:	83 c4 1c             	add    $0x1c,%esp
  802821:	5b                   	pop    %ebx
  802822:	5e                   	pop    %esi
  802823:	5f                   	pop    %edi
  802824:	5d                   	pop    %ebp
  802825:	c3                   	ret    
  802826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80282d:	8d 76 00             	lea    0x0(%esi),%esi
  802830:	89 fd                	mov    %edi,%ebp
  802832:	85 ff                	test   %edi,%edi
  802834:	75 0b                	jne    802841 <__umoddi3+0x91>
  802836:	b8 01 00 00 00       	mov    $0x1,%eax
  80283b:	31 d2                	xor    %edx,%edx
  80283d:	f7 f7                	div    %edi
  80283f:	89 c5                	mov    %eax,%ebp
  802841:	89 d8                	mov    %ebx,%eax
  802843:	31 d2                	xor    %edx,%edx
  802845:	f7 f5                	div    %ebp
  802847:	89 f0                	mov    %esi,%eax
  802849:	f7 f5                	div    %ebp
  80284b:	89 d0                	mov    %edx,%eax
  80284d:	31 d2                	xor    %edx,%edx
  80284f:	eb 8c                	jmp    8027dd <__umoddi3+0x2d>
  802851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802858:	89 e9                	mov    %ebp,%ecx
  80285a:	ba 20 00 00 00       	mov    $0x20,%edx
  80285f:	29 ea                	sub    %ebp,%edx
  802861:	d3 e0                	shl    %cl,%eax
  802863:	89 44 24 08          	mov    %eax,0x8(%esp)
  802867:	89 d1                	mov    %edx,%ecx
  802869:	89 f8                	mov    %edi,%eax
  80286b:	d3 e8                	shr    %cl,%eax
  80286d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802871:	89 54 24 04          	mov    %edx,0x4(%esp)
  802875:	8b 54 24 04          	mov    0x4(%esp),%edx
  802879:	09 c1                	or     %eax,%ecx
  80287b:	89 d8                	mov    %ebx,%eax
  80287d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802881:	89 e9                	mov    %ebp,%ecx
  802883:	d3 e7                	shl    %cl,%edi
  802885:	89 d1                	mov    %edx,%ecx
  802887:	d3 e8                	shr    %cl,%eax
  802889:	89 e9                	mov    %ebp,%ecx
  80288b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80288f:	d3 e3                	shl    %cl,%ebx
  802891:	89 c7                	mov    %eax,%edi
  802893:	89 d1                	mov    %edx,%ecx
  802895:	89 f0                	mov    %esi,%eax
  802897:	d3 e8                	shr    %cl,%eax
  802899:	89 e9                	mov    %ebp,%ecx
  80289b:	89 fa                	mov    %edi,%edx
  80289d:	d3 e6                	shl    %cl,%esi
  80289f:	09 d8                	or     %ebx,%eax
  8028a1:	f7 74 24 08          	divl   0x8(%esp)
  8028a5:	89 d1                	mov    %edx,%ecx
  8028a7:	89 f3                	mov    %esi,%ebx
  8028a9:	f7 64 24 0c          	mull   0xc(%esp)
  8028ad:	89 c6                	mov    %eax,%esi
  8028af:	89 d7                	mov    %edx,%edi
  8028b1:	39 d1                	cmp    %edx,%ecx
  8028b3:	72 06                	jb     8028bb <__umoddi3+0x10b>
  8028b5:	75 10                	jne    8028c7 <__umoddi3+0x117>
  8028b7:	39 c3                	cmp    %eax,%ebx
  8028b9:	73 0c                	jae    8028c7 <__umoddi3+0x117>
  8028bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8028bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8028c3:	89 d7                	mov    %edx,%edi
  8028c5:	89 c6                	mov    %eax,%esi
  8028c7:	89 ca                	mov    %ecx,%edx
  8028c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028ce:	29 f3                	sub    %esi,%ebx
  8028d0:	19 fa                	sbb    %edi,%edx
  8028d2:	89 d0                	mov    %edx,%eax
  8028d4:	d3 e0                	shl    %cl,%eax
  8028d6:	89 e9                	mov    %ebp,%ecx
  8028d8:	d3 eb                	shr    %cl,%ebx
  8028da:	d3 ea                	shr    %cl,%edx
  8028dc:	09 d8                	or     %ebx,%eax
  8028de:	83 c4 1c             	add    $0x1c,%esp
  8028e1:	5b                   	pop    %ebx
  8028e2:	5e                   	pop    %esi
  8028e3:	5f                   	pop    %edi
  8028e4:	5d                   	pop    %ebp
  8028e5:	c3                   	ret    
  8028e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028ed:	8d 76 00             	lea    0x0(%esi),%esi
  8028f0:	29 fe                	sub    %edi,%esi
  8028f2:	19 c3                	sbb    %eax,%ebx
  8028f4:	89 f2                	mov    %esi,%edx
  8028f6:	89 d9                	mov    %ebx,%ecx
  8028f8:	e9 1d ff ff ff       	jmp    80281a <__umoddi3+0x6a>
