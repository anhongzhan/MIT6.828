
obj/user/echosrv.debug:     file format elf32-i386


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
  80002c:	e8 d0 04 00 00       	call   800501 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 70 29 80 00       	push   $0x802970
  80003f:	e8 c2 05 00 00       	call   800606 <cprintf>
	exit();
  800044:	e8 02 05 00 00       	call   80054b <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:

void
handle_client(int sock)
{
  80004e:	f3 0f 1e fb          	endbr32 
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	57                   	push   %edi
  800056:	56                   	push   %esi
  800057:	53                   	push   %ebx
  800058:	83 ec 30             	sub    $0x30,%esp
  80005b:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005e:	6a 20                	push   $0x20
  800060:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800063:	50                   	push   %eax
  800064:	56                   	push   %esi
  800065:	e8 b5 15 00 00       	call   80161f <read>
  80006a:	89 c3                	mov    %eax,%ebx
  80006c:	83 c4 10             	add    $0x10,%esp
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80006f:	8d 7d c8             	lea    -0x38(%ebp),%edi
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800072:	85 c0                	test   %eax,%eax
  800074:	79 3d                	jns    8000b3 <handle_client+0x65>
		die("Failed to receive initial bytes from client");
  800076:	b8 74 29 80 00       	mov    $0x802974,%eax
  80007b:	e8 b3 ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	56                   	push   %esi
  800084:	e8 4c 14 00 00       	call   8014d5 <close>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5f                   	pop    %edi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    
			die("Failed to send bytes to client");
  800094:	b8 a0 29 80 00       	mov    $0x8029a0,%eax
  800099:	e8 95 ff ff ff       	call   800033 <die>
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	6a 20                	push   $0x20
  8000a3:	57                   	push   %edi
  8000a4:	56                   	push   %esi
  8000a5:	e8 75 15 00 00       	call   80161f <read>
  8000aa:	89 c3                	mov    %eax,%ebx
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	78 18                	js     8000cb <handle_client+0x7d>
	while (received > 0) {
  8000b3:	85 db                	test   %ebx,%ebx
  8000b5:	7e c9                	jle    800080 <handle_client+0x32>
		if (write(sock, buffer, received) != received)
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	53                   	push   %ebx
  8000bb:	57                   	push   %edi
  8000bc:	56                   	push   %esi
  8000bd:	e8 33 16 00 00       	call   8016f5 <write>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	39 d8                	cmp    %ebx,%eax
  8000c7:	74 d5                	je     80009e <handle_client+0x50>
  8000c9:	eb c9                	jmp    800094 <handle_client+0x46>
			die("Failed to receive additional bytes from client");
  8000cb:	b8 c0 29 80 00       	mov    $0x8029c0,%eax
  8000d0:	e8 5e ff ff ff       	call   800033 <die>
  8000d5:	eb dc                	jmp    8000b3 <handle_client+0x65>

008000d7 <umain>:

void
umain(int argc, char **argv)
{
  8000d7:	f3 0f 1e fb          	endbr32 
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 40             	sub    $0x40,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000e4:	6a 06                	push   $0x6
  8000e6:	6a 01                	push   $0x1
  8000e8:	6a 02                	push   $0x2
  8000ea:	e8 7f 1c 00 00       	call   801d6e <socket>
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	0f 88 86 00 00 00    	js     800182 <umain+0xab>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 38 29 80 00       	push   $0x802938
  800104:	e8 fd 04 00 00       	call   800606 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800109:	83 c4 0c             	add    $0xc,%esp
  80010c:	6a 10                	push   $0x10
  80010e:	6a 00                	push   $0x0
  800110:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800113:	53                   	push   %ebx
  800114:	e8 61 0c 00 00       	call   800d7a <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  800119:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  80011d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800124:	e8 94 01 00 00       	call   8002bd <htonl>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  80012c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800133:	e8 63 01 00 00       	call   80029b <htons>
  800138:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  80013c:	c7 04 24 47 29 80 00 	movl   $0x802947,(%esp)
  800143:	e8 be 04 00 00       	call   800606 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800148:	83 c4 0c             	add    $0xc,%esp
  80014b:	6a 10                	push   $0x10
  80014d:	53                   	push   %ebx
  80014e:	56                   	push   %esi
  80014f:	e8 78 1b 00 00       	call   801ccc <bind>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	85 c0                	test   %eax,%eax
  800159:	78 36                	js     800191 <umain+0xba>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	6a 05                	push   $0x5
  800160:	56                   	push   %esi
  800161:	e8 e1 1b 00 00       	call   801d47 <listen>
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	85 c0                	test   %eax,%eax
  80016b:	78 30                	js     80019d <umain+0xc6>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 57 29 80 00       	push   $0x802957
  800175:	e8 8c 04 00 00       	call   800606 <cprintf>
  80017a:	83 c4 10             	add    $0x10,%esp
	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
  80017d:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  800180:	eb 55                	jmp    8001d7 <umain+0x100>
		die("Failed to create socket");
  800182:	b8 20 29 80 00       	mov    $0x802920,%eax
  800187:	e8 a7 fe ff ff       	call   800033 <die>
  80018c:	e9 6b ff ff ff       	jmp    8000fc <umain+0x25>
		die("Failed to bind the server socket");
  800191:	b8 f0 29 80 00       	mov    $0x8029f0,%eax
  800196:	e8 98 fe ff ff       	call   800033 <die>
  80019b:	eb be                	jmp    80015b <umain+0x84>
		die("Failed to listen on server socket");
  80019d:	b8 14 2a 80 00       	mov    $0x802a14,%eax
  8001a2:	e8 8c fe ff ff       	call   800033 <die>
  8001a7:	eb c4                	jmp    80016d <umain+0x96>
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001a9:	b8 38 2a 80 00       	mov    $0x802a38,%eax
  8001ae:	e8 80 fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	ff 75 cc             	pushl  -0x34(%ebp)
  8001b9:	e8 39 00 00 00       	call   8001f7 <inet_ntoa>
  8001be:	83 c4 08             	add    $0x8,%esp
  8001c1:	50                   	push   %eax
  8001c2:	68 5e 29 80 00       	push   $0x80295e
  8001c7:	e8 3a 04 00 00       	call   800606 <cprintf>
		handle_client(clientsock);
  8001cc:	89 1c 24             	mov    %ebx,(%esp)
  8001cf:	e8 7a fe ff ff       	call   80004e <handle_client>
	while (1) {
  8001d4:	83 c4 10             	add    $0x10,%esp
		unsigned int clientlen = sizeof(echoclient);
  8001d7:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		     accept(serversock, (struct sockaddr *) &echoclient,
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	57                   	push   %edi
  8001e2:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001e5:	50                   	push   %eax
  8001e6:	56                   	push   %esi
  8001e7:	e8 ad 1a 00 00       	call   801c99 <accept>
  8001ec:	89 c3                	mov    %eax,%ebx
		if ((clientsock =
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	78 b4                	js     8001a9 <umain+0xd2>
  8001f5:	eb bc                	jmp    8001b3 <umain+0xdc>

008001f7 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001f7:	f3 0f 1e fb          	endbr32 
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	57                   	push   %edi
  8001ff:	56                   	push   %esi
  800200:	53                   	push   %ebx
  800201:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800204:	8b 45 08             	mov    0x8(%ebp),%eax
  800207:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80020a:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  80020e:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800211:	bf 00 40 80 00       	mov    $0x804000,%edi
  800216:	eb 2e                	jmp    800246 <inet_ntoa+0x4f>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  800218:	0f b6 c8             	movzbl %al,%ecx
  80021b:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800220:	88 0a                	mov    %cl,(%edx)
  800222:	83 c2 01             	add    $0x1,%edx
    while(i--)
  800225:	83 e8 01             	sub    $0x1,%eax
  800228:	3c ff                	cmp    $0xff,%al
  80022a:	75 ec                	jne    800218 <inet_ntoa+0x21>
  80022c:	0f b6 db             	movzbl %bl,%ebx
  80022f:	01 fb                	add    %edi,%ebx
    *rp++ = '.';
  800231:	8d 7b 01             	lea    0x1(%ebx),%edi
  800234:	c6 03 2e             	movb   $0x2e,(%ebx)
  800237:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  80023a:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  80023e:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800242:	3c 04                	cmp    $0x4,%al
  800244:	74 45                	je     80028b <inet_ntoa+0x94>
  rp = str;
  800246:	bb 00 00 00 00       	mov    $0x0,%ebx
      rem = *ap % (u8_t)10;
  80024b:	0f b6 16             	movzbl (%esi),%edx
      *ap /= (u8_t)10;
  80024e:	0f b6 ca             	movzbl %dl,%ecx
  800251:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800254:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  800257:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80025a:	66 c1 e8 0b          	shr    $0xb,%ax
  80025e:	88 06                	mov    %al,(%esi)
  800260:	89 d9                	mov    %ebx,%ecx
      inv[i++] = '0' + rem;
  800262:	83 c3 01             	add    $0x1,%ebx
  800265:	0f b6 c9             	movzbl %cl,%ecx
  800268:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  80026b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80026e:	01 c0                	add    %eax,%eax
  800270:	89 d1                	mov    %edx,%ecx
  800272:	29 c1                	sub    %eax,%ecx
  800274:	89 c8                	mov    %ecx,%eax
      inv[i++] = '0' + rem;
  800276:	83 c0 30             	add    $0x30,%eax
  800279:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80027c:	88 44 0d ed          	mov    %al,-0x13(%ebp,%ecx,1)
    } while(*ap);
  800280:	80 fa 09             	cmp    $0x9,%dl
  800283:	77 c6                	ja     80024b <inet_ntoa+0x54>
  800285:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800287:	89 d8                	mov    %ebx,%eax
  800289:	eb 9a                	jmp    800225 <inet_ntoa+0x2e>
    ap++;
  }
  *--rp = 0;
  80028b:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  80028e:	b8 00 40 80 00       	mov    $0x804000,%eax
  800293:	83 c4 18             	add    $0x18,%esp
  800296:	5b                   	pop    %ebx
  800297:	5e                   	pop    %esi
  800298:	5f                   	pop    %edi
  800299:	5d                   	pop    %ebp
  80029a:	c3                   	ret    

0080029b <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80029b:	f3 0f 1e fb          	endbr32 
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002a2:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002a6:	66 c1 c0 08          	rol    $0x8,%ax
}
  8002aa:	5d                   	pop    %ebp
  8002ab:	c3                   	ret    

008002ac <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002ac:	f3 0f 1e fb          	endbr32 
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002b3:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002b7:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  8002bb:	5d                   	pop    %ebp
  8002bc:	c3                   	ret    

008002bd <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002bd:	f3 0f 1e fb          	endbr32 
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8002c7:	89 d0                	mov    %edx,%eax
  8002c9:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002cc:	89 d1                	mov    %edx,%ecx
  8002ce:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002d1:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002d3:	89 d1                	mov    %edx,%ecx
  8002d5:	c1 e1 08             	shl    $0x8,%ecx
  8002d8:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002de:	09 c8                	or     %ecx,%eax
  8002e0:	c1 ea 08             	shr    $0x8,%edx
  8002e3:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002e9:	09 d0                	or     %edx,%eax
}
  8002eb:	5d                   	pop    %ebp
  8002ec:	c3                   	ret    

008002ed <inet_aton>:
{
  8002ed:	f3 0f 1e fb          	endbr32 
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	57                   	push   %edi
  8002f5:	56                   	push   %esi
  8002f6:	53                   	push   %ebx
  8002f7:	83 ec 2c             	sub    $0x2c,%esp
  8002fa:	8b 55 08             	mov    0x8(%ebp),%edx
  c = *cp;
  8002fd:	0f be 02             	movsbl (%edx),%eax
  u32_t *pp = parts;
  800300:	8d 75 d8             	lea    -0x28(%ebp),%esi
  800303:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800306:	e9 a7 00 00 00       	jmp    8003b2 <inet_aton+0xc5>
      c = *++cp;
  80030b:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      if (c == 'x' || c == 'X') {
  80030f:	89 c1                	mov    %eax,%ecx
  800311:	83 e1 df             	and    $0xffffffdf,%ecx
  800314:	80 f9 58             	cmp    $0x58,%cl
  800317:	74 10                	je     800329 <inet_aton+0x3c>
      c = *++cp;
  800319:	83 c2 01             	add    $0x1,%edx
  80031c:	0f be c0             	movsbl %al,%eax
        base = 8;
  80031f:	be 08 00 00 00       	mov    $0x8,%esi
  800324:	e9 a3 00 00 00       	jmp    8003cc <inet_aton+0xdf>
        c = *++cp;
  800329:	0f be 42 02          	movsbl 0x2(%edx),%eax
  80032d:	8d 52 02             	lea    0x2(%edx),%edx
        base = 16;
  800330:	be 10 00 00 00       	mov    $0x10,%esi
  800335:	e9 92 00 00 00       	jmp    8003cc <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  80033a:	83 fe 10             	cmp    $0x10,%esi
  80033d:	75 4d                	jne    80038c <inet_aton+0x9f>
  80033f:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800342:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800345:	89 c1                	mov    %eax,%ecx
  800347:	83 e1 df             	and    $0xffffffdf,%ecx
  80034a:	83 e9 41             	sub    $0x41,%ecx
  80034d:	80 f9 05             	cmp    $0x5,%cl
  800350:	77 3a                	ja     80038c <inet_aton+0x9f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800352:	c1 e3 04             	shl    $0x4,%ebx
  800355:	83 c0 0a             	add    $0xa,%eax
  800358:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  80035c:	19 c9                	sbb    %ecx,%ecx
  80035e:	83 e1 20             	and    $0x20,%ecx
  800361:	83 c1 41             	add    $0x41,%ecx
  800364:	29 c8                	sub    %ecx,%eax
  800366:	09 c3                	or     %eax,%ebx
        c = *++cp;
  800368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80036b:	0f be 40 01          	movsbl 0x1(%eax),%eax
  80036f:	83 c2 01             	add    $0x1,%edx
  800372:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      if (isdigit(c)) {
  800375:	89 c7                	mov    %eax,%edi
  800377:	8d 48 d0             	lea    -0x30(%eax),%ecx
  80037a:	80 f9 09             	cmp    $0x9,%cl
  80037d:	77 bb                	ja     80033a <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  80037f:	0f af de             	imul   %esi,%ebx
  800382:	8d 5c 18 d0          	lea    -0x30(%eax,%ebx,1),%ebx
        c = *++cp;
  800386:	0f be 42 01          	movsbl 0x1(%edx),%eax
  80038a:	eb e3                	jmp    80036f <inet_aton+0x82>
    if (c == '.') {
  80038c:	83 f8 2e             	cmp    $0x2e,%eax
  80038f:	75 42                	jne    8003d3 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800391:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800394:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800397:	39 c6                	cmp    %eax,%esi
  800399:	0f 84 16 01 00 00    	je     8004b5 <inet_aton+0x1c8>
      *pp++ = val;
  80039f:	83 c6 04             	add    $0x4,%esi
  8003a2:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8003a5:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	8d 50 01             	lea    0x1(%eax),%edx
  8003ae:	0f be 40 01          	movsbl 0x1(%eax),%eax
    if (!isdigit(c))
  8003b2:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8003b5:	80 f9 09             	cmp    $0x9,%cl
  8003b8:	0f 87 f0 00 00 00    	ja     8004ae <inet_aton+0x1c1>
    base = 10;
  8003be:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  8003c3:	83 f8 30             	cmp    $0x30,%eax
  8003c6:	0f 84 3f ff ff ff    	je     80030b <inet_aton+0x1e>
    base = 10;
  8003cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d1:	eb 9f                	jmp    800372 <inet_aton+0x85>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003d3:	85 c0                	test   %eax,%eax
  8003d5:	74 29                	je     800400 <inet_aton+0x113>
    return (0);
  8003d7:	ba 00 00 00 00       	mov    $0x0,%edx
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003dc:	89 f9                	mov    %edi,%ecx
  8003de:	80 f9 1f             	cmp    $0x1f,%cl
  8003e1:	0f 86 d3 00 00 00    	jbe    8004ba <inet_aton+0x1cd>
  8003e7:	84 c0                	test   %al,%al
  8003e9:	0f 88 cb 00 00 00    	js     8004ba <inet_aton+0x1cd>
  8003ef:	83 f8 20             	cmp    $0x20,%eax
  8003f2:	74 0c                	je     800400 <inet_aton+0x113>
  8003f4:	83 e8 09             	sub    $0x9,%eax
  8003f7:	83 f8 04             	cmp    $0x4,%eax
  8003fa:	0f 87 ba 00 00 00    	ja     8004ba <inet_aton+0x1cd>
  n = pp - parts + 1;
  800400:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800403:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800406:	29 c6                	sub    %eax,%esi
  800408:	89 f0                	mov    %esi,%eax
  80040a:	c1 f8 02             	sar    $0x2,%eax
  80040d:	8d 50 01             	lea    0x1(%eax),%edx
  switch (n) {
  800410:	83 f8 02             	cmp    $0x2,%eax
  800413:	74 7a                	je     80048f <inet_aton+0x1a2>
  800415:	83 fa 03             	cmp    $0x3,%edx
  800418:	7f 49                	jg     800463 <inet_aton+0x176>
  80041a:	85 d2                	test   %edx,%edx
  80041c:	0f 84 98 00 00 00    	je     8004ba <inet_aton+0x1cd>
  800422:	83 fa 02             	cmp    $0x2,%edx
  800425:	75 19                	jne    800440 <inet_aton+0x153>
      return (0);
  800427:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffffffUL)
  80042c:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  800432:	0f 87 82 00 00 00    	ja     8004ba <inet_aton+0x1cd>
    val |= parts[0] << 24;
  800438:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80043b:	c1 e0 18             	shl    $0x18,%eax
  80043e:	09 c3                	or     %eax,%ebx
  return (1);
  800440:	ba 01 00 00 00       	mov    $0x1,%edx
  if (addr)
  800445:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800449:	74 6f                	je     8004ba <inet_aton+0x1cd>
    addr->s_addr = htonl(val);
  80044b:	83 ec 0c             	sub    $0xc,%esp
  80044e:	53                   	push   %ebx
  80044f:	e8 69 fe ff ff       	call   8002bd <htonl>
  800454:	83 c4 10             	add    $0x10,%esp
  800457:	8b 75 0c             	mov    0xc(%ebp),%esi
  80045a:	89 06                	mov    %eax,(%esi)
  return (1);
  80045c:	ba 01 00 00 00       	mov    $0x1,%edx
  800461:	eb 57                	jmp    8004ba <inet_aton+0x1cd>
  switch (n) {
  800463:	83 fa 04             	cmp    $0x4,%edx
  800466:	75 d8                	jne    800440 <inet_aton+0x153>
      return (0);
  800468:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xff)
  80046d:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800473:	77 45                	ja     8004ba <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800475:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800478:	c1 e0 18             	shl    $0x18,%eax
  80047b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80047e:	c1 e2 10             	shl    $0x10,%edx
  800481:	09 d0                	or     %edx,%eax
  800483:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800486:	c1 e2 08             	shl    $0x8,%edx
  800489:	09 d0                	or     %edx,%eax
  80048b:	09 c3                	or     %eax,%ebx
    break;
  80048d:	eb b1                	jmp    800440 <inet_aton+0x153>
      return (0);
  80048f:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffff)
  800494:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  80049a:	77 1e                	ja     8004ba <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80049c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049f:	c1 e0 18             	shl    $0x18,%eax
  8004a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004a5:	c1 e2 10             	shl    $0x10,%edx
  8004a8:	09 d0                	or     %edx,%eax
  8004aa:	09 c3                	or     %eax,%ebx
    break;
  8004ac:	eb 92                	jmp    800440 <inet_aton+0x153>
      return (0);
  8004ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b3:	eb 05                	jmp    8004ba <inet_aton+0x1cd>
        return (0);
  8004b5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ba:	89 d0                	mov    %edx,%eax
  8004bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bf:	5b                   	pop    %ebx
  8004c0:	5e                   	pop    %esi
  8004c1:	5f                   	pop    %edi
  8004c2:	5d                   	pop    %ebp
  8004c3:	c3                   	ret    

008004c4 <inet_addr>:
{
  8004c4:	f3 0f 1e fb          	endbr32 
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  8004ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004d1:	50                   	push   %eax
  8004d2:	ff 75 08             	pushl  0x8(%ebp)
  8004d5:	e8 13 fe ff ff       	call   8002ed <inet_aton>
  8004da:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8004dd:	85 c0                	test   %eax,%eax
  8004df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004e4:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004ea:	f3 0f 1e fb          	endbr32 
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8004f4:	ff 75 08             	pushl  0x8(%ebp)
  8004f7:	e8 c1 fd ff ff       	call   8002bd <htonl>
  8004fc:	83 c4 10             	add    $0x10,%esp
}
  8004ff:	c9                   	leave  
  800500:	c3                   	ret    

00800501 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800501:	f3 0f 1e fb          	endbr32 
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	56                   	push   %esi
  800509:	53                   	push   %ebx
  80050a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80050d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800510:	e8 f7 0a 00 00       	call   80100c <sys_getenvid>
  800515:	25 ff 03 00 00       	and    $0x3ff,%eax
  80051a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80051d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800522:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800527:	85 db                	test   %ebx,%ebx
  800529:	7e 07                	jle    800532 <libmain+0x31>
		binaryname = argv[0];
  80052b:	8b 06                	mov    (%esi),%eax
  80052d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	56                   	push   %esi
  800536:	53                   	push   %ebx
  800537:	e8 9b fb ff ff       	call   8000d7 <umain>

	// exit gracefully
	exit();
  80053c:	e8 0a 00 00 00       	call   80054b <exit>
}
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800547:	5b                   	pop    %ebx
  800548:	5e                   	pop    %esi
  800549:	5d                   	pop    %ebp
  80054a:	c3                   	ret    

0080054b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80054b:	f3 0f 1e fb          	endbr32 
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800555:	e8 ac 0f 00 00       	call   801506 <close_all>
	sys_env_destroy(0);
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	6a 00                	push   $0x0
  80055f:	e8 63 0a 00 00       	call   800fc7 <sys_env_destroy>
}
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800569:	f3 0f 1e fb          	endbr32 
  80056d:	55                   	push   %ebp
  80056e:	89 e5                	mov    %esp,%ebp
  800570:	53                   	push   %ebx
  800571:	83 ec 04             	sub    $0x4,%esp
  800574:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800577:	8b 13                	mov    (%ebx),%edx
  800579:	8d 42 01             	lea    0x1(%edx),%eax
  80057c:	89 03                	mov    %eax,(%ebx)
  80057e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800581:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800585:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058a:	74 09                	je     800595 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80058c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800593:	c9                   	leave  
  800594:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	68 ff 00 00 00       	push   $0xff
  80059d:	8d 43 08             	lea    0x8(%ebx),%eax
  8005a0:	50                   	push   %eax
  8005a1:	e8 dc 09 00 00       	call   800f82 <sys_cputs>
		b->idx = 0;
  8005a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	eb db                	jmp    80058c <putch+0x23>

008005b1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005b1:	f3 0f 1e fb          	endbr32 
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c5:	00 00 00 
	b.cnt = 0;
  8005c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005d2:	ff 75 0c             	pushl  0xc(%ebp)
  8005d5:	ff 75 08             	pushl  0x8(%ebp)
  8005d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	68 69 05 80 00       	push   $0x800569
  8005e4:	e8 20 01 00 00       	call   800709 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005e9:	83 c4 08             	add    $0x8,%esp
  8005ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005f8:	50                   	push   %eax
  8005f9:	e8 84 09 00 00       	call   800f82 <sys_cputs>

	return b.cnt;
}
  8005fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800604:	c9                   	leave  
  800605:	c3                   	ret    

00800606 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800606:	f3 0f 1e fb          	endbr32 
  80060a:	55                   	push   %ebp
  80060b:	89 e5                	mov    %esp,%ebp
  80060d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800610:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800613:	50                   	push   %eax
  800614:	ff 75 08             	pushl  0x8(%ebp)
  800617:	e8 95 ff ff ff       	call   8005b1 <vcprintf>
	va_end(ap);

	return cnt;
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	57                   	push   %edi
  800622:	56                   	push   %esi
  800623:	53                   	push   %ebx
  800624:	83 ec 1c             	sub    $0x1c,%esp
  800627:	89 c7                	mov    %eax,%edi
  800629:	89 d6                	mov    %edx,%esi
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800631:	89 d1                	mov    %edx,%ecx
  800633:	89 c2                	mov    %eax,%edx
  800635:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800638:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80063b:	8b 45 10             	mov    0x10(%ebp),%eax
  80063e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800641:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800644:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80064b:	39 c2                	cmp    %eax,%edx
  80064d:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800650:	72 3e                	jb     800690 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	ff 75 18             	pushl  0x18(%ebp)
  800658:	83 eb 01             	sub    $0x1,%ebx
  80065b:	53                   	push   %ebx
  80065c:	50                   	push   %eax
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 e4             	pushl  -0x1c(%ebp)
  800663:	ff 75 e0             	pushl  -0x20(%ebp)
  800666:	ff 75 dc             	pushl  -0x24(%ebp)
  800669:	ff 75 d8             	pushl  -0x28(%ebp)
  80066c:	e8 4f 20 00 00       	call   8026c0 <__udivdi3>
  800671:	83 c4 18             	add    $0x18,%esp
  800674:	52                   	push   %edx
  800675:	50                   	push   %eax
  800676:	89 f2                	mov    %esi,%edx
  800678:	89 f8                	mov    %edi,%eax
  80067a:	e8 9f ff ff ff       	call   80061e <printnum>
  80067f:	83 c4 20             	add    $0x20,%esp
  800682:	eb 13                	jmp    800697 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	56                   	push   %esi
  800688:	ff 75 18             	pushl  0x18(%ebp)
  80068b:	ff d7                	call   *%edi
  80068d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800690:	83 eb 01             	sub    $0x1,%ebx
  800693:	85 db                	test   %ebx,%ebx
  800695:	7f ed                	jg     800684 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	56                   	push   %esi
  80069b:	83 ec 04             	sub    $0x4,%esp
  80069e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8006a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006aa:	e8 21 21 00 00       	call   8027d0 <__umoddi3>
  8006af:	83 c4 14             	add    $0x14,%esp
  8006b2:	0f be 80 65 2a 80 00 	movsbl 0x802a65(%eax),%eax
  8006b9:	50                   	push   %eax
  8006ba:	ff d7                	call   *%edi
}
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006c2:	5b                   	pop    %ebx
  8006c3:	5e                   	pop    %esi
  8006c4:	5f                   	pop    %edi
  8006c5:	5d                   	pop    %ebp
  8006c6:	c3                   	ret    

008006c7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006c7:	f3 0f 1e fb          	endbr32 
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006d1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006d5:	8b 10                	mov    (%eax),%edx
  8006d7:	3b 50 04             	cmp    0x4(%eax),%edx
  8006da:	73 0a                	jae    8006e6 <sprintputch+0x1f>
		*b->buf++ = ch;
  8006dc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006df:	89 08                	mov    %ecx,(%eax)
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	88 02                	mov    %al,(%edx)
}
  8006e6:	5d                   	pop    %ebp
  8006e7:	c3                   	ret    

008006e8 <printfmt>:
{
  8006e8:	f3 0f 1e fb          	endbr32 
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
  8006ef:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006f5:	50                   	push   %eax
  8006f6:	ff 75 10             	pushl  0x10(%ebp)
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	ff 75 08             	pushl  0x8(%ebp)
  8006ff:	e8 05 00 00 00       	call   800709 <vprintfmt>
}
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <vprintfmt>:
{
  800709:	f3 0f 1e fb          	endbr32 
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	57                   	push   %edi
  800711:	56                   	push   %esi
  800712:	53                   	push   %ebx
  800713:	83 ec 3c             	sub    $0x3c,%esp
  800716:	8b 75 08             	mov    0x8(%ebp),%esi
  800719:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80071c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80071f:	e9 8e 03 00 00       	jmp    800ab2 <vprintfmt+0x3a9>
		padc = ' ';
  800724:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800728:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80072f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800736:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80073d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800742:	8d 47 01             	lea    0x1(%edi),%eax
  800745:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800748:	0f b6 17             	movzbl (%edi),%edx
  80074b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80074e:	3c 55                	cmp    $0x55,%al
  800750:	0f 87 df 03 00 00    	ja     800b35 <vprintfmt+0x42c>
  800756:	0f b6 c0             	movzbl %al,%eax
  800759:	3e ff 24 85 a0 2b 80 	notrack jmp *0x802ba0(,%eax,4)
  800760:	00 
  800761:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800764:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800768:	eb d8                	jmp    800742 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80076a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80076d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800771:	eb cf                	jmp    800742 <vprintfmt+0x39>
  800773:	0f b6 d2             	movzbl %dl,%edx
  800776:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800779:	b8 00 00 00 00       	mov    $0x0,%eax
  80077e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800781:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800784:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800788:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80078b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80078e:	83 f9 09             	cmp    $0x9,%ecx
  800791:	77 55                	ja     8007e8 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800793:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800796:	eb e9                	jmp    800781 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b0:	79 90                	jns    800742 <vprintfmt+0x39>
				width = precision, precision = -1;
  8007b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007bf:	eb 81                	jmp    800742 <vprintfmt+0x39>
  8007c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cb:	0f 49 d0             	cmovns %eax,%edx
  8007ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007d4:	e9 69 ff ff ff       	jmp    800742 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8007d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007dc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007e3:	e9 5a ff ff ff       	jmp    800742 <vprintfmt+0x39>
  8007e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ee:	eb bc                	jmp    8007ac <vprintfmt+0xa3>
			lflag++;
  8007f0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007f6:	e9 47 ff ff ff       	jmp    800742 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 78 04             	lea    0x4(%eax),%edi
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	53                   	push   %ebx
  800805:	ff 30                	pushl  (%eax)
  800807:	ff d6                	call   *%esi
			break;
  800809:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80080c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80080f:	e9 9b 02 00 00       	jmp    800aaf <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 78 04             	lea    0x4(%eax),%edi
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	99                   	cltd   
  80081d:	31 d0                	xor    %edx,%eax
  80081f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800821:	83 f8 0f             	cmp    $0xf,%eax
  800824:	7f 23                	jg     800849 <vprintfmt+0x140>
  800826:	8b 14 85 00 2d 80 00 	mov    0x802d00(,%eax,4),%edx
  80082d:	85 d2                	test   %edx,%edx
  80082f:	74 18                	je     800849 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800831:	52                   	push   %edx
  800832:	68 35 2e 80 00       	push   $0x802e35
  800837:	53                   	push   %ebx
  800838:	56                   	push   %esi
  800839:	e8 aa fe ff ff       	call   8006e8 <printfmt>
  80083e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800841:	89 7d 14             	mov    %edi,0x14(%ebp)
  800844:	e9 66 02 00 00       	jmp    800aaf <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800849:	50                   	push   %eax
  80084a:	68 7d 2a 80 00       	push   $0x802a7d
  80084f:	53                   	push   %ebx
  800850:	56                   	push   %esi
  800851:	e8 92 fe ff ff       	call   8006e8 <printfmt>
  800856:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800859:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80085c:	e9 4e 02 00 00       	jmp    800aaf <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 c0 04             	add    $0x4,%eax
  800867:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80086f:	85 d2                	test   %edx,%edx
  800871:	b8 76 2a 80 00       	mov    $0x802a76,%eax
  800876:	0f 45 c2             	cmovne %edx,%eax
  800879:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80087c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800880:	7e 06                	jle    800888 <vprintfmt+0x17f>
  800882:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800886:	75 0d                	jne    800895 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800888:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80088b:	89 c7                	mov    %eax,%edi
  80088d:	03 45 e0             	add    -0x20(%ebp),%eax
  800890:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800893:	eb 55                	jmp    8008ea <vprintfmt+0x1e1>
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 d8             	pushl  -0x28(%ebp)
  80089b:	ff 75 cc             	pushl  -0x34(%ebp)
  80089e:	e8 46 03 00 00       	call   800be9 <strnlen>
  8008a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a6:	29 c2                	sub    %eax,%edx
  8008a8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8008ab:	83 c4 10             	add    $0x10,%esp
  8008ae:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8008b0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	85 ff                	test   %edi,%edi
  8008b9:	7e 11                	jle    8008cc <vprintfmt+0x1c3>
					putch(padc, putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8008c2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c4:	83 ef 01             	sub    $0x1,%edi
  8008c7:	83 c4 10             	add    $0x10,%esp
  8008ca:	eb eb                	jmp    8008b7 <vprintfmt+0x1ae>
  8008cc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008cf:	85 d2                	test   %edx,%edx
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	0f 49 c2             	cmovns %edx,%eax
  8008d9:	29 c2                	sub    %eax,%edx
  8008db:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008de:	eb a8                	jmp    800888 <vprintfmt+0x17f>
					putch(ch, putdat);
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	53                   	push   %ebx
  8008e4:	52                   	push   %edx
  8008e5:	ff d6                	call   *%esi
  8008e7:	83 c4 10             	add    $0x10,%esp
  8008ea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008ed:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ef:	83 c7 01             	add    $0x1,%edi
  8008f2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008f6:	0f be d0             	movsbl %al,%edx
  8008f9:	85 d2                	test   %edx,%edx
  8008fb:	74 4b                	je     800948 <vprintfmt+0x23f>
  8008fd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800901:	78 06                	js     800909 <vprintfmt+0x200>
  800903:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800907:	78 1e                	js     800927 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800909:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80090d:	74 d1                	je     8008e0 <vprintfmt+0x1d7>
  80090f:	0f be c0             	movsbl %al,%eax
  800912:	83 e8 20             	sub    $0x20,%eax
  800915:	83 f8 5e             	cmp    $0x5e,%eax
  800918:	76 c6                	jbe    8008e0 <vprintfmt+0x1d7>
					putch('?', putdat);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	53                   	push   %ebx
  80091e:	6a 3f                	push   $0x3f
  800920:	ff d6                	call   *%esi
  800922:	83 c4 10             	add    $0x10,%esp
  800925:	eb c3                	jmp    8008ea <vprintfmt+0x1e1>
  800927:	89 cf                	mov    %ecx,%edi
  800929:	eb 0e                	jmp    800939 <vprintfmt+0x230>
				putch(' ', putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	53                   	push   %ebx
  80092f:	6a 20                	push   $0x20
  800931:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800933:	83 ef 01             	sub    $0x1,%edi
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	85 ff                	test   %edi,%edi
  80093b:	7f ee                	jg     80092b <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80093d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
  800943:	e9 67 01 00 00       	jmp    800aaf <vprintfmt+0x3a6>
  800948:	89 cf                	mov    %ecx,%edi
  80094a:	eb ed                	jmp    800939 <vprintfmt+0x230>
	if (lflag >= 2)
  80094c:	83 f9 01             	cmp    $0x1,%ecx
  80094f:	7f 1b                	jg     80096c <vprintfmt+0x263>
	else if (lflag)
  800951:	85 c9                	test   %ecx,%ecx
  800953:	74 63                	je     8009b8 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095d:	99                   	cltd   
  80095e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8d 40 04             	lea    0x4(%eax),%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
  80096a:	eb 17                	jmp    800983 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80096c:	8b 45 14             	mov    0x14(%ebp),%eax
  80096f:	8b 50 04             	mov    0x4(%eax),%edx
  800972:	8b 00                	mov    (%eax),%eax
  800974:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800977:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80097a:	8b 45 14             	mov    0x14(%ebp),%eax
  80097d:	8d 40 08             	lea    0x8(%eax),%eax
  800980:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800983:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800986:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800989:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80098e:	85 c9                	test   %ecx,%ecx
  800990:	0f 89 ff 00 00 00    	jns    800a95 <vprintfmt+0x38c>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	53                   	push   %ebx
  80099a:	6a 2d                	push   $0x2d
  80099c:	ff d6                	call   *%esi
				num = -(long long) num;
  80099e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8009a4:	f7 da                	neg    %edx
  8009a6:	83 d1 00             	adc    $0x0,%ecx
  8009a9:	f7 d9                	neg    %ecx
  8009ab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b3:	e9 dd 00 00 00       	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c0:	99                   	cltd   
  8009c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8d 40 04             	lea    0x4(%eax),%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cd:	eb b4                	jmp    800983 <vprintfmt+0x27a>
	if (lflag >= 2)
  8009cf:	83 f9 01             	cmp    $0x1,%ecx
  8009d2:	7f 1e                	jg     8009f2 <vprintfmt+0x2e9>
	else if (lflag)
  8009d4:	85 c9                	test   %ecx,%ecx
  8009d6:	74 32                	je     800a0a <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8009d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009db:	8b 10                	mov    (%eax),%edx
  8009dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e2:	8d 40 04             	lea    0x4(%eax),%eax
  8009e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009e8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8009ed:	e9 a3 00 00 00       	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	8b 10                	mov    (%eax),%edx
  8009f7:	8b 48 04             	mov    0x4(%eax),%ecx
  8009fa:	8d 40 08             	lea    0x8(%eax),%eax
  8009fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a00:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800a05:	e9 8b 00 00 00       	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0d:	8b 10                	mov    (%eax),%edx
  800a0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a14:	8d 40 04             	lea    0x4(%eax),%eax
  800a17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a1a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800a1f:	eb 74                	jmp    800a95 <vprintfmt+0x38c>
	if (lflag >= 2)
  800a21:	83 f9 01             	cmp    $0x1,%ecx
  800a24:	7f 1b                	jg     800a41 <vprintfmt+0x338>
	else if (lflag)
  800a26:	85 c9                	test   %ecx,%ecx
  800a28:	74 2c                	je     800a56 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	8b 10                	mov    (%eax),%edx
  800a2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a34:	8d 40 04             	lea    0x4(%eax),%eax
  800a37:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a3a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800a3f:	eb 54                	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	8b 10                	mov    (%eax),%edx
  800a46:	8b 48 04             	mov    0x4(%eax),%ecx
  800a49:	8d 40 08             	lea    0x8(%eax),%eax
  800a4c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a4f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800a54:	eb 3f                	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	8b 10                	mov    (%eax),%edx
  800a5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a60:	8d 40 04             	lea    0x4(%eax),%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a66:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800a6b:	eb 28                	jmp    800a95 <vprintfmt+0x38c>
			putch('0', putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	53                   	push   %ebx
  800a71:	6a 30                	push   $0x30
  800a73:	ff d6                	call   *%esi
			putch('x', putdat);
  800a75:	83 c4 08             	add    $0x8,%esp
  800a78:	53                   	push   %ebx
  800a79:	6a 78                	push   $0x78
  800a7b:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	8b 10                	mov    (%eax),%edx
  800a82:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a87:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a8a:	8d 40 04             	lea    0x4(%eax),%eax
  800a8d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a90:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a95:	83 ec 0c             	sub    $0xc,%esp
  800a98:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a9c:	57                   	push   %edi
  800a9d:	ff 75 e0             	pushl  -0x20(%ebp)
  800aa0:	50                   	push   %eax
  800aa1:	51                   	push   %ecx
  800aa2:	52                   	push   %edx
  800aa3:	89 da                	mov    %ebx,%edx
  800aa5:	89 f0                	mov    %esi,%eax
  800aa7:	e8 72 fb ff ff       	call   80061e <printnum>
			break;
  800aac:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800aaf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab2:	83 c7 01             	add    $0x1,%edi
  800ab5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ab9:	83 f8 25             	cmp    $0x25,%eax
  800abc:	0f 84 62 fc ff ff    	je     800724 <vprintfmt+0x1b>
			if (ch == '\0')
  800ac2:	85 c0                	test   %eax,%eax
  800ac4:	0f 84 8b 00 00 00    	je     800b55 <vprintfmt+0x44c>
			putch(ch, putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	53                   	push   %ebx
  800ace:	50                   	push   %eax
  800acf:	ff d6                	call   *%esi
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	eb dc                	jmp    800ab2 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800ad6:	83 f9 01             	cmp    $0x1,%ecx
  800ad9:	7f 1b                	jg     800af6 <vprintfmt+0x3ed>
	else if (lflag)
  800adb:	85 c9                	test   %ecx,%ecx
  800add:	74 2c                	je     800b0b <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	8b 10                	mov    (%eax),%edx
  800ae4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae9:	8d 40 04             	lea    0x4(%eax),%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aef:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800af4:	eb 9f                	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	8b 10                	mov    (%eax),%edx
  800afb:	8b 48 04             	mov    0x4(%eax),%ecx
  800afe:	8d 40 08             	lea    0x8(%eax),%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b04:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800b09:	eb 8a                	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	8b 10                	mov    (%eax),%edx
  800b10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b15:	8d 40 04             	lea    0x4(%eax),%eax
  800b18:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b1b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800b20:	e9 70 ff ff ff       	jmp    800a95 <vprintfmt+0x38c>
			putch(ch, putdat);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	53                   	push   %ebx
  800b29:	6a 25                	push   $0x25
  800b2b:	ff d6                	call   *%esi
			break;
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	e9 7a ff ff ff       	jmp    800aaf <vprintfmt+0x3a6>
			putch('%', putdat);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	53                   	push   %ebx
  800b39:	6a 25                	push   $0x25
  800b3b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	89 f8                	mov    %edi,%eax
  800b42:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b46:	74 05                	je     800b4d <vprintfmt+0x444>
  800b48:	83 e8 01             	sub    $0x1,%eax
  800b4b:	eb f5                	jmp    800b42 <vprintfmt+0x439>
  800b4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b50:	e9 5a ff ff ff       	jmp    800aaf <vprintfmt+0x3a6>
}
  800b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b58:	5b                   	pop    %ebx
  800b59:	5e                   	pop    %esi
  800b5a:	5f                   	pop    %edi
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b5d:	f3 0f 1e fb          	endbr32 
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 18             	sub    $0x18,%esp
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b70:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b74:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b7e:	85 c0                	test   %eax,%eax
  800b80:	74 26                	je     800ba8 <vsnprintf+0x4b>
  800b82:	85 d2                	test   %edx,%edx
  800b84:	7e 22                	jle    800ba8 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b86:	ff 75 14             	pushl  0x14(%ebp)
  800b89:	ff 75 10             	pushl  0x10(%ebp)
  800b8c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b8f:	50                   	push   %eax
  800b90:	68 c7 06 80 00       	push   $0x8006c7
  800b95:	e8 6f fb ff ff       	call   800709 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    
		return -E_INVAL;
  800ba8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bad:	eb f7                	jmp    800ba6 <vsnprintf+0x49>

00800baf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800baf:	f3 0f 1e fb          	endbr32 
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bbc:	50                   	push   %eax
  800bbd:	ff 75 10             	pushl  0x10(%ebp)
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	ff 75 08             	pushl  0x8(%ebp)
  800bc6:	e8 92 ff ff ff       	call   800b5d <vsnprintf>
	va_end(ap);

	return rc;
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800be0:	74 05                	je     800be7 <strlen+0x1a>
		n++;
  800be2:	83 c0 01             	add    $0x1,%eax
  800be5:	eb f5                	jmp    800bdc <strlen+0xf>
	return n;
}
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800be9:	f3 0f 1e fb          	endbr32 
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfb:	39 d0                	cmp    %edx,%eax
  800bfd:	74 0d                	je     800c0c <strnlen+0x23>
  800bff:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c03:	74 05                	je     800c0a <strnlen+0x21>
		n++;
  800c05:	83 c0 01             	add    $0x1,%eax
  800c08:	eb f1                	jmp    800bfb <strnlen+0x12>
  800c0a:	89 c2                	mov    %eax,%edx
	return n;
}
  800c0c:	89 d0                	mov    %edx,%eax
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c10:	f3 0f 1e fb          	endbr32 
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	53                   	push   %ebx
  800c18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c23:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800c27:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800c2a:	83 c0 01             	add    $0x1,%eax
  800c2d:	84 d2                	test   %dl,%dl
  800c2f:	75 f2                	jne    800c23 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800c31:	89 c8                	mov    %ecx,%eax
  800c33:	5b                   	pop    %ebx
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c36:	f3 0f 1e fb          	endbr32 
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	53                   	push   %ebx
  800c3e:	83 ec 10             	sub    $0x10,%esp
  800c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c44:	53                   	push   %ebx
  800c45:	e8 83 ff ff ff       	call   800bcd <strlen>
  800c4a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	01 d8                	add    %ebx,%eax
  800c52:	50                   	push   %eax
  800c53:	e8 b8 ff ff ff       	call   800c10 <strcpy>
	return dst;
}
  800c58:	89 d8                	mov    %ebx,%eax
  800c5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c5f:	f3 0f 1e fb          	endbr32 
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	8b 75 08             	mov    0x8(%ebp),%esi
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6e:	89 f3                	mov    %esi,%ebx
  800c70:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c73:	89 f0                	mov    %esi,%eax
  800c75:	39 d8                	cmp    %ebx,%eax
  800c77:	74 11                	je     800c8a <strncpy+0x2b>
		*dst++ = *src;
  800c79:	83 c0 01             	add    $0x1,%eax
  800c7c:	0f b6 0a             	movzbl (%edx),%ecx
  800c7f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c82:	80 f9 01             	cmp    $0x1,%cl
  800c85:	83 da ff             	sbb    $0xffffffff,%edx
  800c88:	eb eb                	jmp    800c75 <strncpy+0x16>
	}
	return ret;
}
  800c8a:	89 f0                	mov    %esi,%eax
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c90:	f3 0f 1e fb          	endbr32 
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9f:	8b 55 10             	mov    0x10(%ebp),%edx
  800ca2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ca4:	85 d2                	test   %edx,%edx
  800ca6:	74 21                	je     800cc9 <strlcpy+0x39>
  800ca8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cac:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cae:	39 c2                	cmp    %eax,%edx
  800cb0:	74 14                	je     800cc6 <strlcpy+0x36>
  800cb2:	0f b6 19             	movzbl (%ecx),%ebx
  800cb5:	84 db                	test   %bl,%bl
  800cb7:	74 0b                	je     800cc4 <strlcpy+0x34>
			*dst++ = *src++;
  800cb9:	83 c1 01             	add    $0x1,%ecx
  800cbc:	83 c2 01             	add    $0x1,%edx
  800cbf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cc2:	eb ea                	jmp    800cae <strlcpy+0x1e>
  800cc4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cc6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc9:	29 f0                	sub    %esi,%eax
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ccf:	f3 0f 1e fb          	endbr32 
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cdc:	0f b6 01             	movzbl (%ecx),%eax
  800cdf:	84 c0                	test   %al,%al
  800ce1:	74 0c                	je     800cef <strcmp+0x20>
  800ce3:	3a 02                	cmp    (%edx),%al
  800ce5:	75 08                	jne    800cef <strcmp+0x20>
		p++, q++;
  800ce7:	83 c1 01             	add    $0x1,%ecx
  800cea:	83 c2 01             	add    $0x1,%edx
  800ced:	eb ed                	jmp    800cdc <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cef:	0f b6 c0             	movzbl %al,%eax
  800cf2:	0f b6 12             	movzbl (%edx),%edx
  800cf5:	29 d0                	sub    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf9:	f3 0f 1e fb          	endbr32 
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	53                   	push   %ebx
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d07:	89 c3                	mov    %eax,%ebx
  800d09:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d0c:	eb 06                	jmp    800d14 <strncmp+0x1b>
		n--, p++, q++;
  800d0e:	83 c0 01             	add    $0x1,%eax
  800d11:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d14:	39 d8                	cmp    %ebx,%eax
  800d16:	74 16                	je     800d2e <strncmp+0x35>
  800d18:	0f b6 08             	movzbl (%eax),%ecx
  800d1b:	84 c9                	test   %cl,%cl
  800d1d:	74 04                	je     800d23 <strncmp+0x2a>
  800d1f:	3a 0a                	cmp    (%edx),%cl
  800d21:	74 eb                	je     800d0e <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	0f b6 00             	movzbl (%eax),%eax
  800d26:	0f b6 12             	movzbl (%edx),%edx
  800d29:	29 d0                	sub    %edx,%eax
}
  800d2b:	5b                   	pop    %ebx
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    
		return 0;
  800d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d33:	eb f6                	jmp    800d2b <strncmp+0x32>

00800d35 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d35:	f3 0f 1e fb          	endbr32 
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d43:	0f b6 10             	movzbl (%eax),%edx
  800d46:	84 d2                	test   %dl,%dl
  800d48:	74 09                	je     800d53 <strchr+0x1e>
		if (*s == c)
  800d4a:	38 ca                	cmp    %cl,%dl
  800d4c:	74 0a                	je     800d58 <strchr+0x23>
	for (; *s; s++)
  800d4e:	83 c0 01             	add    $0x1,%eax
  800d51:	eb f0                	jmp    800d43 <strchr+0xe>
			return (char *) s;
	return 0;
  800d53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5a:	f3 0f 1e fb          	endbr32 
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d68:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d6b:	38 ca                	cmp    %cl,%dl
  800d6d:	74 09                	je     800d78 <strfind+0x1e>
  800d6f:	84 d2                	test   %dl,%dl
  800d71:	74 05                	je     800d78 <strfind+0x1e>
	for (; *s; s++)
  800d73:	83 c0 01             	add    $0x1,%eax
  800d76:	eb f0                	jmp    800d68 <strfind+0xe>
			break;
	return (char *) s;
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d7a:	f3 0f 1e fb          	endbr32 
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d87:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d8a:	85 c9                	test   %ecx,%ecx
  800d8c:	74 31                	je     800dbf <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d8e:	89 f8                	mov    %edi,%eax
  800d90:	09 c8                	or     %ecx,%eax
  800d92:	a8 03                	test   $0x3,%al
  800d94:	75 23                	jne    800db9 <memset+0x3f>
		c &= 0xFF;
  800d96:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d9a:	89 d3                	mov    %edx,%ebx
  800d9c:	c1 e3 08             	shl    $0x8,%ebx
  800d9f:	89 d0                	mov    %edx,%eax
  800da1:	c1 e0 18             	shl    $0x18,%eax
  800da4:	89 d6                	mov    %edx,%esi
  800da6:	c1 e6 10             	shl    $0x10,%esi
  800da9:	09 f0                	or     %esi,%eax
  800dab:	09 c2                	or     %eax,%edx
  800dad:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800daf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800db2:	89 d0                	mov    %edx,%eax
  800db4:	fc                   	cld    
  800db5:	f3 ab                	rep stos %eax,%es:(%edi)
  800db7:	eb 06                	jmp    800dbf <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	fc                   	cld    
  800dbd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dbf:	89 f8                	mov    %edi,%eax
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dc6:	f3 0f 1e fb          	endbr32 
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd8:	39 c6                	cmp    %eax,%esi
  800dda:	73 32                	jae    800e0e <memmove+0x48>
  800ddc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ddf:	39 c2                	cmp    %eax,%edx
  800de1:	76 2b                	jbe    800e0e <memmove+0x48>
		s += n;
		d += n;
  800de3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800de6:	89 fe                	mov    %edi,%esi
  800de8:	09 ce                	or     %ecx,%esi
  800dea:	09 d6                	or     %edx,%esi
  800dec:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800df2:	75 0e                	jne    800e02 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800df4:	83 ef 04             	sub    $0x4,%edi
  800df7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dfa:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800dfd:	fd                   	std    
  800dfe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e00:	eb 09                	jmp    800e0b <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e02:	83 ef 01             	sub    $0x1,%edi
  800e05:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e08:	fd                   	std    
  800e09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e0b:	fc                   	cld    
  800e0c:	eb 1a                	jmp    800e28 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e0e:	89 c2                	mov    %eax,%edx
  800e10:	09 ca                	or     %ecx,%edx
  800e12:	09 f2                	or     %esi,%edx
  800e14:	f6 c2 03             	test   $0x3,%dl
  800e17:	75 0a                	jne    800e23 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e19:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e1c:	89 c7                	mov    %eax,%edi
  800e1e:	fc                   	cld    
  800e1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e21:	eb 05                	jmp    800e28 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800e23:	89 c7                	mov    %eax,%edi
  800e25:	fc                   	cld    
  800e26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e2c:	f3 0f 1e fb          	endbr32 
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e36:	ff 75 10             	pushl  0x10(%ebp)
  800e39:	ff 75 0c             	pushl  0xc(%ebp)
  800e3c:	ff 75 08             	pushl  0x8(%ebp)
  800e3f:	e8 82 ff ff ff       	call   800dc6 <memmove>
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e46:	f3 0f 1e fb          	endbr32 
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e55:	89 c6                	mov    %eax,%esi
  800e57:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e5a:	39 f0                	cmp    %esi,%eax
  800e5c:	74 1c                	je     800e7a <memcmp+0x34>
		if (*s1 != *s2)
  800e5e:	0f b6 08             	movzbl (%eax),%ecx
  800e61:	0f b6 1a             	movzbl (%edx),%ebx
  800e64:	38 d9                	cmp    %bl,%cl
  800e66:	75 08                	jne    800e70 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e68:	83 c0 01             	add    $0x1,%eax
  800e6b:	83 c2 01             	add    $0x1,%edx
  800e6e:	eb ea                	jmp    800e5a <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800e70:	0f b6 c1             	movzbl %cl,%eax
  800e73:	0f b6 db             	movzbl %bl,%ebx
  800e76:	29 d8                	sub    %ebx,%eax
  800e78:	eb 05                	jmp    800e7f <memcmp+0x39>
	}

	return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7f:	5b                   	pop    %ebx
  800e80:	5e                   	pop    %esi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e83:	f3 0f 1e fb          	endbr32 
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e90:	89 c2                	mov    %eax,%edx
  800e92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e95:	39 d0                	cmp    %edx,%eax
  800e97:	73 09                	jae    800ea2 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e99:	38 08                	cmp    %cl,(%eax)
  800e9b:	74 05                	je     800ea2 <memfind+0x1f>
	for (; s < ends; s++)
  800e9d:	83 c0 01             	add    $0x1,%eax
  800ea0:	eb f3                	jmp    800e95 <memfind+0x12>
			break;
	return (void *) s;
}
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ea4:	f3 0f 1e fb          	endbr32 
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	57                   	push   %edi
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
  800eae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb4:	eb 03                	jmp    800eb9 <strtol+0x15>
		s++;
  800eb6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800eb9:	0f b6 01             	movzbl (%ecx),%eax
  800ebc:	3c 20                	cmp    $0x20,%al
  800ebe:	74 f6                	je     800eb6 <strtol+0x12>
  800ec0:	3c 09                	cmp    $0x9,%al
  800ec2:	74 f2                	je     800eb6 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ec4:	3c 2b                	cmp    $0x2b,%al
  800ec6:	74 2a                	je     800ef2 <strtol+0x4e>
	int neg = 0;
  800ec8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ecd:	3c 2d                	cmp    $0x2d,%al
  800ecf:	74 2b                	je     800efc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ed1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ed7:	75 0f                	jne    800ee8 <strtol+0x44>
  800ed9:	80 39 30             	cmpb   $0x30,(%ecx)
  800edc:	74 28                	je     800f06 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee5:	0f 44 d8             	cmove  %eax,%ebx
  800ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  800eed:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ef0:	eb 46                	jmp    800f38 <strtol+0x94>
		s++;
  800ef2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ef5:	bf 00 00 00 00       	mov    $0x0,%edi
  800efa:	eb d5                	jmp    800ed1 <strtol+0x2d>
		s++, neg = 1;
  800efc:	83 c1 01             	add    $0x1,%ecx
  800eff:	bf 01 00 00 00       	mov    $0x1,%edi
  800f04:	eb cb                	jmp    800ed1 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f06:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f0a:	74 0e                	je     800f1a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800f0c:	85 db                	test   %ebx,%ebx
  800f0e:	75 d8                	jne    800ee8 <strtol+0x44>
		s++, base = 8;
  800f10:	83 c1 01             	add    $0x1,%ecx
  800f13:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f18:	eb ce                	jmp    800ee8 <strtol+0x44>
		s += 2, base = 16;
  800f1a:	83 c1 02             	add    $0x2,%ecx
  800f1d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f22:	eb c4                	jmp    800ee8 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800f24:	0f be d2             	movsbl %dl,%edx
  800f27:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f2a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f2d:	7d 3a                	jge    800f69 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f2f:	83 c1 01             	add    $0x1,%ecx
  800f32:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f36:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f38:	0f b6 11             	movzbl (%ecx),%edx
  800f3b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f3e:	89 f3                	mov    %esi,%ebx
  800f40:	80 fb 09             	cmp    $0x9,%bl
  800f43:	76 df                	jbe    800f24 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800f45:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f48:	89 f3                	mov    %esi,%ebx
  800f4a:	80 fb 19             	cmp    $0x19,%bl
  800f4d:	77 08                	ja     800f57 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f4f:	0f be d2             	movsbl %dl,%edx
  800f52:	83 ea 57             	sub    $0x57,%edx
  800f55:	eb d3                	jmp    800f2a <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800f57:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f5a:	89 f3                	mov    %esi,%ebx
  800f5c:	80 fb 19             	cmp    $0x19,%bl
  800f5f:	77 08                	ja     800f69 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f61:	0f be d2             	movsbl %dl,%edx
  800f64:	83 ea 37             	sub    $0x37,%edx
  800f67:	eb c1                	jmp    800f2a <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6d:	74 05                	je     800f74 <strtol+0xd0>
		*endptr = (char *) s;
  800f6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f72:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f74:	89 c2                	mov    %eax,%edx
  800f76:	f7 da                	neg    %edx
  800f78:	85 ff                	test   %edi,%edi
  800f7a:	0f 45 c2             	cmovne %edx,%eax
}
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f82:	f3 0f 1e fb          	endbr32 
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f97:	89 c3                	mov    %eax,%ebx
  800f99:	89 c7                	mov    %eax,%edi
  800f9b:	89 c6                	mov    %eax,%esi
  800f9d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f9f:	5b                   	pop    %ebx
  800fa0:	5e                   	pop    %esi
  800fa1:	5f                   	pop    %edi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fa4:	f3 0f 1e fb          	endbr32 
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb8:	89 d1                	mov    %edx,%ecx
  800fba:	89 d3                	mov    %edx,%ebx
  800fbc:	89 d7                	mov    %edx,%edi
  800fbe:	89 d6                	mov    %edx,%esi
  800fc0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fc7:	f3 0f 1e fb          	endbr32 
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	b8 03 00 00 00       	mov    $0x3,%eax
  800fe1:	89 cb                	mov    %ecx,%ebx
  800fe3:	89 cf                	mov    %ecx,%edi
  800fe5:	89 ce                	mov    %ecx,%esi
  800fe7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7f 08                	jg     800ff5 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	50                   	push   %eax
  800ff9:	6a 03                	push   $0x3
  800ffb:	68 5f 2d 80 00       	push   $0x802d5f
  801000:	6a 23                	push   $0x23
  801002:	68 7c 2d 80 00       	push   $0x802d7c
  801007:	e8 08 15 00 00       	call   802514 <_panic>

0080100c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80100c:	f3 0f 1e fb          	endbr32 
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	57                   	push   %edi
  801014:	56                   	push   %esi
  801015:	53                   	push   %ebx
	asm volatile("int %1\n"
  801016:	ba 00 00 00 00       	mov    $0x0,%edx
  80101b:	b8 02 00 00 00       	mov    $0x2,%eax
  801020:	89 d1                	mov    %edx,%ecx
  801022:	89 d3                	mov    %edx,%ebx
  801024:	89 d7                	mov    %edx,%edi
  801026:	89 d6                	mov    %edx,%esi
  801028:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5f                   	pop    %edi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <sys_yield>:

void
sys_yield(void)
{
  80102f:	f3 0f 1e fb          	endbr32 
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
	asm volatile("int %1\n"
  801039:	ba 00 00 00 00       	mov    $0x0,%edx
  80103e:	b8 0b 00 00 00       	mov    $0xb,%eax
  801043:	89 d1                	mov    %edx,%ecx
  801045:	89 d3                	mov    %edx,%ebx
  801047:	89 d7                	mov    %edx,%edi
  801049:	89 d6                	mov    %edx,%esi
  80104b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801052:	f3 0f 1e fb          	endbr32 
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	57                   	push   %edi
  80105a:	56                   	push   %esi
  80105b:	53                   	push   %ebx
  80105c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80105f:	be 00 00 00 00       	mov    $0x0,%esi
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106a:	b8 04 00 00 00       	mov    $0x4,%eax
  80106f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801072:	89 f7                	mov    %esi,%edi
  801074:	cd 30                	int    $0x30
	if(check && ret > 0)
  801076:	85 c0                	test   %eax,%eax
  801078:	7f 08                	jg     801082 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80107a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	50                   	push   %eax
  801086:	6a 04                	push   $0x4
  801088:	68 5f 2d 80 00       	push   $0x802d5f
  80108d:	6a 23                	push   $0x23
  80108f:	68 7c 2d 80 00       	push   $0x802d7c
  801094:	e8 7b 14 00 00       	call   802514 <_panic>

00801099 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801099:	f3 0f 1e fb          	endbr32 
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8010b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	7f 08                	jg     8010c8 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c3:	5b                   	pop    %ebx
  8010c4:	5e                   	pop    %esi
  8010c5:	5f                   	pop    %edi
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c8:	83 ec 0c             	sub    $0xc,%esp
  8010cb:	50                   	push   %eax
  8010cc:	6a 05                	push   $0x5
  8010ce:	68 5f 2d 80 00       	push   $0x802d5f
  8010d3:	6a 23                	push   $0x23
  8010d5:	68 7c 2d 80 00       	push   $0x802d7c
  8010da:	e8 35 14 00 00       	call   802514 <_panic>

008010df <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010df:	f3 0f 1e fb          	endbr32 
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	57                   	push   %edi
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
  8010e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8010fc:	89 df                	mov    %ebx,%edi
  8010fe:	89 de                	mov    %ebx,%esi
  801100:	cd 30                	int    $0x30
	if(check && ret > 0)
  801102:	85 c0                	test   %eax,%eax
  801104:	7f 08                	jg     80110e <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801109:	5b                   	pop    %ebx
  80110a:	5e                   	pop    %esi
  80110b:	5f                   	pop    %edi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	6a 06                	push   $0x6
  801114:	68 5f 2d 80 00       	push   $0x802d5f
  801119:	6a 23                	push   $0x23
  80111b:	68 7c 2d 80 00       	push   $0x802d7c
  801120:	e8 ef 13 00 00       	call   802514 <_panic>

00801125 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801125:	f3 0f 1e fb          	endbr32 
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	57                   	push   %edi
  80112d:	56                   	push   %esi
  80112e:	53                   	push   %ebx
  80112f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801132:	bb 00 00 00 00       	mov    $0x0,%ebx
  801137:	8b 55 08             	mov    0x8(%ebp),%edx
  80113a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113d:	b8 08 00 00 00       	mov    $0x8,%eax
  801142:	89 df                	mov    %ebx,%edi
  801144:	89 de                	mov    %ebx,%esi
  801146:	cd 30                	int    $0x30
	if(check && ret > 0)
  801148:	85 c0                	test   %eax,%eax
  80114a:	7f 08                	jg     801154 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80114c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114f:	5b                   	pop    %ebx
  801150:	5e                   	pop    %esi
  801151:	5f                   	pop    %edi
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801154:	83 ec 0c             	sub    $0xc,%esp
  801157:	50                   	push   %eax
  801158:	6a 08                	push   $0x8
  80115a:	68 5f 2d 80 00       	push   $0x802d5f
  80115f:	6a 23                	push   $0x23
  801161:	68 7c 2d 80 00       	push   $0x802d7c
  801166:	e8 a9 13 00 00       	call   802514 <_panic>

0080116b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80116b:	f3 0f 1e fb          	endbr32 
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801178:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117d:	8b 55 08             	mov    0x8(%ebp),%edx
  801180:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801183:	b8 09 00 00 00       	mov    $0x9,%eax
  801188:	89 df                	mov    %ebx,%edi
  80118a:	89 de                	mov    %ebx,%esi
  80118c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80118e:	85 c0                	test   %eax,%eax
  801190:	7f 08                	jg     80119a <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	50                   	push   %eax
  80119e:	6a 09                	push   $0x9
  8011a0:	68 5f 2d 80 00       	push   $0x802d5f
  8011a5:	6a 23                	push   $0x23
  8011a7:	68 7c 2d 80 00       	push   $0x802d7c
  8011ac:	e8 63 13 00 00       	call   802514 <_panic>

008011b1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011b1:	f3 0f 1e fb          	endbr32 
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	57                   	push   %edi
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011ce:	89 df                	mov    %ebx,%edi
  8011d0:	89 de                	mov    %ebx,%esi
  8011d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	7f 08                	jg     8011e0 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011db:	5b                   	pop    %ebx
  8011dc:	5e                   	pop    %esi
  8011dd:	5f                   	pop    %edi
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e0:	83 ec 0c             	sub    $0xc,%esp
  8011e3:	50                   	push   %eax
  8011e4:	6a 0a                	push   $0xa
  8011e6:	68 5f 2d 80 00       	push   $0x802d5f
  8011eb:	6a 23                	push   $0x23
  8011ed:	68 7c 2d 80 00       	push   $0x802d7c
  8011f2:	e8 1d 13 00 00       	call   802514 <_panic>

008011f7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011f7:	f3 0f 1e fb          	endbr32 
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	57                   	push   %edi
  8011ff:	56                   	push   %esi
  801200:	53                   	push   %ebx
	asm volatile("int %1\n"
  801201:	8b 55 08             	mov    0x8(%ebp),%edx
  801204:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801207:	b8 0c 00 00 00       	mov    $0xc,%eax
  80120c:	be 00 00 00 00       	mov    $0x0,%esi
  801211:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801214:	8b 7d 14             	mov    0x14(%ebp),%edi
  801217:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    

0080121e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80121e:	f3 0f 1e fb          	endbr32 
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	57                   	push   %edi
  801226:	56                   	push   %esi
  801227:	53                   	push   %ebx
  801228:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80122b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801230:	8b 55 08             	mov    0x8(%ebp),%edx
  801233:	b8 0d 00 00 00       	mov    $0xd,%eax
  801238:	89 cb                	mov    %ecx,%ebx
  80123a:	89 cf                	mov    %ecx,%edi
  80123c:	89 ce                	mov    %ecx,%esi
  80123e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801240:	85 c0                	test   %eax,%eax
  801242:	7f 08                	jg     80124c <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5f                   	pop    %edi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80124c:	83 ec 0c             	sub    $0xc,%esp
  80124f:	50                   	push   %eax
  801250:	6a 0d                	push   $0xd
  801252:	68 5f 2d 80 00       	push   $0x802d5f
  801257:	6a 23                	push   $0x23
  801259:	68 7c 2d 80 00       	push   $0x802d7c
  80125e:	e8 b1 12 00 00       	call   802514 <_panic>

00801263 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801263:	f3 0f 1e fb          	endbr32 
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	57                   	push   %edi
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80126d:	ba 00 00 00 00       	mov    $0x0,%edx
  801272:	b8 0e 00 00 00       	mov    $0xe,%eax
  801277:	89 d1                	mov    %edx,%ecx
  801279:	89 d3                	mov    %edx,%ebx
  80127b:	89 d7                	mov    %edx,%edi
  80127d:	89 d6                	mov    %edx,%esi
  80127f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801281:	5b                   	pop    %ebx
  801282:	5e                   	pop    %esi
  801283:	5f                   	pop    %edi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    

00801286 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  801286:	f3 0f 1e fb          	endbr32 
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	57                   	push   %edi
  80128e:	56                   	push   %esi
  80128f:	53                   	push   %ebx
  801290:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801293:	bb 00 00 00 00       	mov    $0x0,%ebx
  801298:	8b 55 08             	mov    0x8(%ebp),%edx
  80129b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129e:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012a3:	89 df                	mov    %ebx,%edi
  8012a5:	89 de                	mov    %ebx,%esi
  8012a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	7f 08                	jg     8012b5 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8012ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b0:	5b                   	pop    %ebx
  8012b1:	5e                   	pop    %esi
  8012b2:	5f                   	pop    %edi
  8012b3:	5d                   	pop    %ebp
  8012b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b5:	83 ec 0c             	sub    $0xc,%esp
  8012b8:	50                   	push   %eax
  8012b9:	6a 0f                	push   $0xf
  8012bb:	68 5f 2d 80 00       	push   $0x802d5f
  8012c0:	6a 23                	push   $0x23
  8012c2:	68 7c 2d 80 00       	push   $0x802d7c
  8012c7:	e8 48 12 00 00       	call   802514 <_panic>

008012cc <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8012cc:	f3 0f 1e fb          	endbr32 
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	57                   	push   %edi
  8012d4:	56                   	push   %esi
  8012d5:	53                   	push   %ebx
  8012d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012de:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8012e9:	89 df                	mov    %ebx,%edi
  8012eb:	89 de                	mov    %ebx,%esi
  8012ed:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	7f 08                	jg     8012fb <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  8012f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f6:	5b                   	pop    %ebx
  8012f7:	5e                   	pop    %esi
  8012f8:	5f                   	pop    %edi
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	50                   	push   %eax
  8012ff:	6a 10                	push   $0x10
  801301:	68 5f 2d 80 00       	push   $0x802d5f
  801306:	6a 23                	push   $0x23
  801308:	68 7c 2d 80 00       	push   $0x802d7c
  80130d:	e8 02 12 00 00       	call   802514 <_panic>

00801312 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801312:	f3 0f 1e fb          	endbr32 
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	05 00 00 00 30       	add    $0x30000000,%eax
  801321:	c1 e8 0c             	shr    $0xc,%eax
}
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    

00801326 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801326:	f3 0f 1e fb          	endbr32 
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801335:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80133a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80133f:	5d                   	pop    %ebp
  801340:	c3                   	ret    

00801341 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801341:	f3 0f 1e fb          	endbr32 
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80134d:	89 c2                	mov    %eax,%edx
  80134f:	c1 ea 16             	shr    $0x16,%edx
  801352:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801359:	f6 c2 01             	test   $0x1,%dl
  80135c:	74 2d                	je     80138b <fd_alloc+0x4a>
  80135e:	89 c2                	mov    %eax,%edx
  801360:	c1 ea 0c             	shr    $0xc,%edx
  801363:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136a:	f6 c2 01             	test   $0x1,%dl
  80136d:	74 1c                	je     80138b <fd_alloc+0x4a>
  80136f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801374:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801379:	75 d2                	jne    80134d <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801384:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801389:	eb 0a                	jmp    801395 <fd_alloc+0x54>
			*fd_store = fd;
  80138b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80138e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801390:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801397:	f3 0f 1e fb          	endbr32 
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013a1:	83 f8 1f             	cmp    $0x1f,%eax
  8013a4:	77 30                	ja     8013d6 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013a6:	c1 e0 0c             	shl    $0xc,%eax
  8013a9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013ae:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013b4:	f6 c2 01             	test   $0x1,%dl
  8013b7:	74 24                	je     8013dd <fd_lookup+0x46>
  8013b9:	89 c2                	mov    %eax,%edx
  8013bb:	c1 ea 0c             	shr    $0xc,%edx
  8013be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c5:	f6 c2 01             	test   $0x1,%dl
  8013c8:	74 1a                	je     8013e4 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cd:	89 02                	mov    %eax,(%edx)
	return 0;
  8013cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d4:	5d                   	pop    %ebp
  8013d5:	c3                   	ret    
		return -E_INVAL;
  8013d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013db:	eb f7                	jmp    8013d4 <fd_lookup+0x3d>
		return -E_INVAL;
  8013dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e2:	eb f0                	jmp    8013d4 <fd_lookup+0x3d>
  8013e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e9:	eb e9                	jmp    8013d4 <fd_lookup+0x3d>

008013eb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013eb:	f3 0f 1e fb          	endbr32 
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 08             	sub    $0x8,%esp
  8013f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fd:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801402:	39 08                	cmp    %ecx,(%eax)
  801404:	74 38                	je     80143e <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801406:	83 c2 01             	add    $0x1,%edx
  801409:	8b 04 95 08 2e 80 00 	mov    0x802e08(,%edx,4),%eax
  801410:	85 c0                	test   %eax,%eax
  801412:	75 ee                	jne    801402 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801414:	a1 18 40 80 00       	mov    0x804018,%eax
  801419:	8b 40 48             	mov    0x48(%eax),%eax
  80141c:	83 ec 04             	sub    $0x4,%esp
  80141f:	51                   	push   %ecx
  801420:	50                   	push   %eax
  801421:	68 8c 2d 80 00       	push   $0x802d8c
  801426:	e8 db f1 ff ff       	call   800606 <cprintf>
	*dev = 0;
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    
			*dev = devtab[i];
  80143e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801441:	89 01                	mov    %eax,(%ecx)
			return 0;
  801443:	b8 00 00 00 00       	mov    $0x0,%eax
  801448:	eb f2                	jmp    80143c <dev_lookup+0x51>

0080144a <fd_close>:
{
  80144a:	f3 0f 1e fb          	endbr32 
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	57                   	push   %edi
  801452:	56                   	push   %esi
  801453:	53                   	push   %ebx
  801454:	83 ec 24             	sub    $0x24,%esp
  801457:	8b 75 08             	mov    0x8(%ebp),%esi
  80145a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80145d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801460:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801461:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801467:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80146a:	50                   	push   %eax
  80146b:	e8 27 ff ff ff       	call   801397 <fd_lookup>
  801470:	89 c3                	mov    %eax,%ebx
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	85 c0                	test   %eax,%eax
  801477:	78 05                	js     80147e <fd_close+0x34>
	    || fd != fd2)
  801479:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80147c:	74 16                	je     801494 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80147e:	89 f8                	mov    %edi,%eax
  801480:	84 c0                	test   %al,%al
  801482:	b8 00 00 00 00       	mov    $0x0,%eax
  801487:	0f 44 d8             	cmove  %eax,%ebx
}
  80148a:	89 d8                	mov    %ebx,%eax
  80148c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80148f:	5b                   	pop    %ebx
  801490:	5e                   	pop    %esi
  801491:	5f                   	pop    %edi
  801492:	5d                   	pop    %ebp
  801493:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80149a:	50                   	push   %eax
  80149b:	ff 36                	pushl  (%esi)
  80149d:	e8 49 ff ff ff       	call   8013eb <dev_lookup>
  8014a2:	89 c3                	mov    %eax,%ebx
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 1a                	js     8014c5 <fd_close+0x7b>
		if (dev->dev_close)
  8014ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ae:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	74 0b                	je     8014c5 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	56                   	push   %esi
  8014be:	ff d0                	call   *%eax
  8014c0:	89 c3                	mov    %eax,%ebx
  8014c2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014c5:	83 ec 08             	sub    $0x8,%esp
  8014c8:	56                   	push   %esi
  8014c9:	6a 00                	push   $0x0
  8014cb:	e8 0f fc ff ff       	call   8010df <sys_page_unmap>
	return r;
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	eb b5                	jmp    80148a <fd_close+0x40>

008014d5 <close>:

int
close(int fdnum)
{
  8014d5:	f3 0f 1e fb          	endbr32 
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e2:	50                   	push   %eax
  8014e3:	ff 75 08             	pushl  0x8(%ebp)
  8014e6:	e8 ac fe ff ff       	call   801397 <fd_lookup>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	79 02                	jns    8014f4 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    
		return fd_close(fd, 1);
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	6a 01                	push   $0x1
  8014f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8014fc:	e8 49 ff ff ff       	call   80144a <fd_close>
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	eb ec                	jmp    8014f2 <close+0x1d>

00801506 <close_all>:

void
close_all(void)
{
  801506:	f3 0f 1e fb          	endbr32 
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	53                   	push   %ebx
  80150e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801511:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801516:	83 ec 0c             	sub    $0xc,%esp
  801519:	53                   	push   %ebx
  80151a:	e8 b6 ff ff ff       	call   8014d5 <close>
	for (i = 0; i < MAXFD; i++)
  80151f:	83 c3 01             	add    $0x1,%ebx
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	83 fb 20             	cmp    $0x20,%ebx
  801528:	75 ec                	jne    801516 <close_all+0x10>
}
  80152a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80152f:	f3 0f 1e fb          	endbr32 
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	57                   	push   %edi
  801537:	56                   	push   %esi
  801538:	53                   	push   %ebx
  801539:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80153c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	ff 75 08             	pushl  0x8(%ebp)
  801543:	e8 4f fe ff ff       	call   801397 <fd_lookup>
  801548:	89 c3                	mov    %eax,%ebx
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	85 c0                	test   %eax,%eax
  80154f:	0f 88 81 00 00 00    	js     8015d6 <dup+0xa7>
		return r;
	close(newfdnum);
  801555:	83 ec 0c             	sub    $0xc,%esp
  801558:	ff 75 0c             	pushl  0xc(%ebp)
  80155b:	e8 75 ff ff ff       	call   8014d5 <close>

	newfd = INDEX2FD(newfdnum);
  801560:	8b 75 0c             	mov    0xc(%ebp),%esi
  801563:	c1 e6 0c             	shl    $0xc,%esi
  801566:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80156c:	83 c4 04             	add    $0x4,%esp
  80156f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801572:	e8 af fd ff ff       	call   801326 <fd2data>
  801577:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801579:	89 34 24             	mov    %esi,(%esp)
  80157c:	e8 a5 fd ff ff       	call   801326 <fd2data>
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801586:	89 d8                	mov    %ebx,%eax
  801588:	c1 e8 16             	shr    $0x16,%eax
  80158b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801592:	a8 01                	test   $0x1,%al
  801594:	74 11                	je     8015a7 <dup+0x78>
  801596:	89 d8                	mov    %ebx,%eax
  801598:	c1 e8 0c             	shr    $0xc,%eax
  80159b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015a2:	f6 c2 01             	test   $0x1,%dl
  8015a5:	75 39                	jne    8015e0 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015aa:	89 d0                	mov    %edx,%eax
  8015ac:	c1 e8 0c             	shr    $0xc,%eax
  8015af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b6:	83 ec 0c             	sub    $0xc,%esp
  8015b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8015be:	50                   	push   %eax
  8015bf:	56                   	push   %esi
  8015c0:	6a 00                	push   $0x0
  8015c2:	52                   	push   %edx
  8015c3:	6a 00                	push   $0x0
  8015c5:	e8 cf fa ff ff       	call   801099 <sys_page_map>
  8015ca:	89 c3                	mov    %eax,%ebx
  8015cc:	83 c4 20             	add    $0x20,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 31                	js     801604 <dup+0xd5>
		goto err;

	return newfdnum;
  8015d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015d6:	89 d8                	mov    %ebx,%eax
  8015d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015db:	5b                   	pop    %ebx
  8015dc:	5e                   	pop    %esi
  8015dd:	5f                   	pop    %edi
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ef:	50                   	push   %eax
  8015f0:	57                   	push   %edi
  8015f1:	6a 00                	push   $0x0
  8015f3:	53                   	push   %ebx
  8015f4:	6a 00                	push   $0x0
  8015f6:	e8 9e fa ff ff       	call   801099 <sys_page_map>
  8015fb:	89 c3                	mov    %eax,%ebx
  8015fd:	83 c4 20             	add    $0x20,%esp
  801600:	85 c0                	test   %eax,%eax
  801602:	79 a3                	jns    8015a7 <dup+0x78>
	sys_page_unmap(0, newfd);
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	56                   	push   %esi
  801608:	6a 00                	push   $0x0
  80160a:	e8 d0 fa ff ff       	call   8010df <sys_page_unmap>
	sys_page_unmap(0, nva);
  80160f:	83 c4 08             	add    $0x8,%esp
  801612:	57                   	push   %edi
  801613:	6a 00                	push   $0x0
  801615:	e8 c5 fa ff ff       	call   8010df <sys_page_unmap>
	return r;
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	eb b7                	jmp    8015d6 <dup+0xa7>

0080161f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80161f:	f3 0f 1e fb          	endbr32 
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	53                   	push   %ebx
  801627:	83 ec 1c             	sub    $0x1c,%esp
  80162a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801630:	50                   	push   %eax
  801631:	53                   	push   %ebx
  801632:	e8 60 fd ff ff       	call   801397 <fd_lookup>
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 3f                	js     80167d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163e:	83 ec 08             	sub    $0x8,%esp
  801641:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801644:	50                   	push   %eax
  801645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801648:	ff 30                	pushl  (%eax)
  80164a:	e8 9c fd ff ff       	call   8013eb <dev_lookup>
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	85 c0                	test   %eax,%eax
  801654:	78 27                	js     80167d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801656:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801659:	8b 42 08             	mov    0x8(%edx),%eax
  80165c:	83 e0 03             	and    $0x3,%eax
  80165f:	83 f8 01             	cmp    $0x1,%eax
  801662:	74 1e                	je     801682 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801667:	8b 40 08             	mov    0x8(%eax),%eax
  80166a:	85 c0                	test   %eax,%eax
  80166c:	74 35                	je     8016a3 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	ff 75 10             	pushl  0x10(%ebp)
  801674:	ff 75 0c             	pushl  0xc(%ebp)
  801677:	52                   	push   %edx
  801678:	ff d0                	call   *%eax
  80167a:	83 c4 10             	add    $0x10,%esp
}
  80167d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801680:	c9                   	leave  
  801681:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801682:	a1 18 40 80 00       	mov    0x804018,%eax
  801687:	8b 40 48             	mov    0x48(%eax),%eax
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	53                   	push   %ebx
  80168e:	50                   	push   %eax
  80168f:	68 cd 2d 80 00       	push   $0x802dcd
  801694:	e8 6d ef ff ff       	call   800606 <cprintf>
		return -E_INVAL;
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a1:	eb da                	jmp    80167d <read+0x5e>
		return -E_NOT_SUPP;
  8016a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a8:	eb d3                	jmp    80167d <read+0x5e>

008016aa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016aa:	f3 0f 1e fb          	endbr32 
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	57                   	push   %edi
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016ba:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c2:	eb 02                	jmp    8016c6 <readn+0x1c>
  8016c4:	01 c3                	add    %eax,%ebx
  8016c6:	39 f3                	cmp    %esi,%ebx
  8016c8:	73 21                	jae    8016eb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	89 f0                	mov    %esi,%eax
  8016cf:	29 d8                	sub    %ebx,%eax
  8016d1:	50                   	push   %eax
  8016d2:	89 d8                	mov    %ebx,%eax
  8016d4:	03 45 0c             	add    0xc(%ebp),%eax
  8016d7:	50                   	push   %eax
  8016d8:	57                   	push   %edi
  8016d9:	e8 41 ff ff ff       	call   80161f <read>
		if (m < 0)
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	78 04                	js     8016e9 <readn+0x3f>
			return m;
		if (m == 0)
  8016e5:	75 dd                	jne    8016c4 <readn+0x1a>
  8016e7:	eb 02                	jmp    8016eb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016e9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016eb:	89 d8                	mov    %ebx,%eax
  8016ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f0:	5b                   	pop    %ebx
  8016f1:	5e                   	pop    %esi
  8016f2:	5f                   	pop    %edi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016f5:	f3 0f 1e fb          	endbr32 
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	53                   	push   %ebx
  8016fd:	83 ec 1c             	sub    $0x1c,%esp
  801700:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801703:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801706:	50                   	push   %eax
  801707:	53                   	push   %ebx
  801708:	e8 8a fc ff ff       	call   801397 <fd_lookup>
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	85 c0                	test   %eax,%eax
  801712:	78 3a                	js     80174e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801714:	83 ec 08             	sub    $0x8,%esp
  801717:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171a:	50                   	push   %eax
  80171b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171e:	ff 30                	pushl  (%eax)
  801720:	e8 c6 fc ff ff       	call   8013eb <dev_lookup>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	85 c0                	test   %eax,%eax
  80172a:	78 22                	js     80174e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801733:	74 1e                	je     801753 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801738:	8b 52 0c             	mov    0xc(%edx),%edx
  80173b:	85 d2                	test   %edx,%edx
  80173d:	74 35                	je     801774 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	ff 75 10             	pushl  0x10(%ebp)
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	50                   	push   %eax
  801749:	ff d2                	call   *%edx
  80174b:	83 c4 10             	add    $0x10,%esp
}
  80174e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801751:	c9                   	leave  
  801752:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801753:	a1 18 40 80 00       	mov    0x804018,%eax
  801758:	8b 40 48             	mov    0x48(%eax),%eax
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	53                   	push   %ebx
  80175f:	50                   	push   %eax
  801760:	68 e9 2d 80 00       	push   $0x802de9
  801765:	e8 9c ee ff ff       	call   800606 <cprintf>
		return -E_INVAL;
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801772:	eb da                	jmp    80174e <write+0x59>
		return -E_NOT_SUPP;
  801774:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801779:	eb d3                	jmp    80174e <write+0x59>

0080177b <seek>:

int
seek(int fdnum, off_t offset)
{
  80177b:	f3 0f 1e fb          	endbr32 
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801785:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801788:	50                   	push   %eax
  801789:	ff 75 08             	pushl  0x8(%ebp)
  80178c:	e8 06 fc ff ff       	call   801397 <fd_lookup>
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	85 c0                	test   %eax,%eax
  801796:	78 0e                	js     8017a6 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017a8:	f3 0f 1e fb          	endbr32 
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 1c             	sub    $0x1c,%esp
  8017b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b9:	50                   	push   %eax
  8017ba:	53                   	push   %ebx
  8017bb:	e8 d7 fb ff ff       	call   801397 <fd_lookup>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 37                	js     8017fe <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c7:	83 ec 08             	sub    $0x8,%esp
  8017ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cd:	50                   	push   %eax
  8017ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d1:	ff 30                	pushl  (%eax)
  8017d3:	e8 13 fc ff ff       	call   8013eb <dev_lookup>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 1f                	js     8017fe <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017e6:	74 1b                	je     801803 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017eb:	8b 52 18             	mov    0x18(%edx),%edx
  8017ee:	85 d2                	test   %edx,%edx
  8017f0:	74 32                	je     801824 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017f2:	83 ec 08             	sub    $0x8,%esp
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	50                   	push   %eax
  8017f9:	ff d2                	call   *%edx
  8017fb:	83 c4 10             	add    $0x10,%esp
}
  8017fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801801:	c9                   	leave  
  801802:	c3                   	ret    
			thisenv->env_id, fdnum);
  801803:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801808:	8b 40 48             	mov    0x48(%eax),%eax
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	53                   	push   %ebx
  80180f:	50                   	push   %eax
  801810:	68 ac 2d 80 00       	push   $0x802dac
  801815:	e8 ec ed ff ff       	call   800606 <cprintf>
		return -E_INVAL;
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801822:	eb da                	jmp    8017fe <ftruncate+0x56>
		return -E_NOT_SUPP;
  801824:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801829:	eb d3                	jmp    8017fe <ftruncate+0x56>

0080182b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80182b:	f3 0f 1e fb          	endbr32 
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	53                   	push   %ebx
  801833:	83 ec 1c             	sub    $0x1c,%esp
  801836:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801839:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80183c:	50                   	push   %eax
  80183d:	ff 75 08             	pushl  0x8(%ebp)
  801840:	e8 52 fb ff ff       	call   801397 <fd_lookup>
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	85 c0                	test   %eax,%eax
  80184a:	78 4b                	js     801897 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801852:	50                   	push   %eax
  801853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801856:	ff 30                	pushl  (%eax)
  801858:	e8 8e fb ff ff       	call   8013eb <dev_lookup>
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	85 c0                	test   %eax,%eax
  801862:	78 33                	js     801897 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801867:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80186b:	74 2f                	je     80189c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80186d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801870:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801877:	00 00 00 
	stat->st_isdir = 0;
  80187a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801881:	00 00 00 
	stat->st_dev = dev;
  801884:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	53                   	push   %ebx
  80188e:	ff 75 f0             	pushl  -0x10(%ebp)
  801891:	ff 50 14             	call   *0x14(%eax)
  801894:	83 c4 10             	add    $0x10,%esp
}
  801897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    
		return -E_NOT_SUPP;
  80189c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a1:	eb f4                	jmp    801897 <fstat+0x6c>

008018a3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018a3:	f3 0f 1e fb          	endbr32 
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018ac:	83 ec 08             	sub    $0x8,%esp
  8018af:	6a 00                	push   $0x0
  8018b1:	ff 75 08             	pushl  0x8(%ebp)
  8018b4:	e8 fb 01 00 00       	call   801ab4 <open>
  8018b9:	89 c3                	mov    %eax,%ebx
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	78 1b                	js     8018dd <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	50                   	push   %eax
  8018c9:	e8 5d ff ff ff       	call   80182b <fstat>
  8018ce:	89 c6                	mov    %eax,%esi
	close(fd);
  8018d0:	89 1c 24             	mov    %ebx,(%esp)
  8018d3:	e8 fd fb ff ff       	call   8014d5 <close>
	return r;
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	89 f3                	mov    %esi,%ebx
}
  8018dd:	89 d8                	mov    %ebx,%eax
  8018df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	56                   	push   %esi
  8018ea:	53                   	push   %ebx
  8018eb:	89 c6                	mov    %eax,%esi
  8018ed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018ef:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  8018f6:	74 27                	je     80191f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018f8:	6a 07                	push   $0x7
  8018fa:	68 00 50 80 00       	push   $0x805000
  8018ff:	56                   	push   %esi
  801900:	ff 35 10 40 80 00    	pushl  0x804010
  801906:	e8 d8 0c 00 00       	call   8025e3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80190b:	83 c4 0c             	add    $0xc,%esp
  80190e:	6a 00                	push   $0x0
  801910:	53                   	push   %ebx
  801911:	6a 00                	push   $0x0
  801913:	e8 46 0c 00 00       	call   80255e <ipc_recv>
}
  801918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191b:	5b                   	pop    %ebx
  80191c:	5e                   	pop    %esi
  80191d:	5d                   	pop    %ebp
  80191e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	6a 01                	push   $0x1
  801924:	e8 12 0d 00 00       	call   80263b <ipc_find_env>
  801929:	a3 10 40 80 00       	mov    %eax,0x804010
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	eb c5                	jmp    8018f8 <fsipc+0x12>

00801933 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801933:	f3 0f 1e fb          	endbr32 
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	8b 40 0c             	mov    0xc(%eax),%eax
  801943:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801950:	ba 00 00 00 00       	mov    $0x0,%edx
  801955:	b8 02 00 00 00       	mov    $0x2,%eax
  80195a:	e8 87 ff ff ff       	call   8018e6 <fsipc>
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <devfile_flush>:
{
  801961:	f3 0f 1e fb          	endbr32 
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8b 40 0c             	mov    0xc(%eax),%eax
  801971:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801976:	ba 00 00 00 00       	mov    $0x0,%edx
  80197b:	b8 06 00 00 00       	mov    $0x6,%eax
  801980:	e8 61 ff ff ff       	call   8018e6 <fsipc>
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <devfile_stat>:
{
  801987:	f3 0f 1e fb          	endbr32 
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	53                   	push   %ebx
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	8b 40 0c             	mov    0xc(%eax),%eax
  80199b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a5:	b8 05 00 00 00       	mov    $0x5,%eax
  8019aa:	e8 37 ff ff ff       	call   8018e6 <fsipc>
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 2c                	js     8019df <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019b3:	83 ec 08             	sub    $0x8,%esp
  8019b6:	68 00 50 80 00       	push   $0x805000
  8019bb:	53                   	push   %ebx
  8019bc:	e8 4f f2 ff ff       	call   800c10 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019c1:	a1 80 50 80 00       	mov    0x805080,%eax
  8019c6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019cc:	a1 84 50 80 00       	mov    0x805084,%eax
  8019d1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <devfile_write>:
{
  8019e4:	f3 0f 1e fb          	endbr32 
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 0c             	sub    $0xc,%esp
  8019ee:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8019f7:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8019fd:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a02:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a07:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801a0a:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a0f:	50                   	push   %eax
  801a10:	ff 75 0c             	pushl  0xc(%ebp)
  801a13:	68 08 50 80 00       	push   $0x805008
  801a18:	e8 a9 f3 ff ff       	call   800dc6 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a22:	b8 04 00 00 00       	mov    $0x4,%eax
  801a27:	e8 ba fe ff ff       	call   8018e6 <fsipc>
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <devfile_read>:
{
  801a2e:	f3 0f 1e fb          	endbr32 
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	56                   	push   %esi
  801a36:	53                   	push   %ebx
  801a37:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a40:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a45:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a50:	b8 03 00 00 00       	mov    $0x3,%eax
  801a55:	e8 8c fe ff ff       	call   8018e6 <fsipc>
  801a5a:	89 c3                	mov    %eax,%ebx
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	78 1f                	js     801a7f <devfile_read+0x51>
	assert(r <= n);
  801a60:	39 f0                	cmp    %esi,%eax
  801a62:	77 24                	ja     801a88 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a64:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a69:	7f 33                	jg     801a9e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a6b:	83 ec 04             	sub    $0x4,%esp
  801a6e:	50                   	push   %eax
  801a6f:	68 00 50 80 00       	push   $0x805000
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	e8 4a f3 ff ff       	call   800dc6 <memmove>
	return r;
  801a7c:	83 c4 10             	add    $0x10,%esp
}
  801a7f:	89 d8                	mov    %ebx,%eax
  801a81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    
	assert(r <= n);
  801a88:	68 1c 2e 80 00       	push   $0x802e1c
  801a8d:	68 23 2e 80 00       	push   $0x802e23
  801a92:	6a 7c                	push   $0x7c
  801a94:	68 38 2e 80 00       	push   $0x802e38
  801a99:	e8 76 0a 00 00       	call   802514 <_panic>
	assert(r <= PGSIZE);
  801a9e:	68 43 2e 80 00       	push   $0x802e43
  801aa3:	68 23 2e 80 00       	push   $0x802e23
  801aa8:	6a 7d                	push   $0x7d
  801aaa:	68 38 2e 80 00       	push   $0x802e38
  801aaf:	e8 60 0a 00 00       	call   802514 <_panic>

00801ab4 <open>:
{
  801ab4:	f3 0f 1e fb          	endbr32 
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	56                   	push   %esi
  801abc:	53                   	push   %ebx
  801abd:	83 ec 1c             	sub    $0x1c,%esp
  801ac0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ac3:	56                   	push   %esi
  801ac4:	e8 04 f1 ff ff       	call   800bcd <strlen>
  801ac9:	83 c4 10             	add    $0x10,%esp
  801acc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ad1:	7f 6c                	jg     801b3f <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad9:	50                   	push   %eax
  801ada:	e8 62 f8 ff ff       	call   801341 <fd_alloc>
  801adf:	89 c3                	mov    %eax,%ebx
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	78 3c                	js     801b24 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	56                   	push   %esi
  801aec:	68 00 50 80 00       	push   $0x805000
  801af1:	e8 1a f1 ff ff       	call   800c10 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801afe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b01:	b8 01 00 00 00       	mov    $0x1,%eax
  801b06:	e8 db fd ff ff       	call   8018e6 <fsipc>
  801b0b:	89 c3                	mov    %eax,%ebx
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	85 c0                	test   %eax,%eax
  801b12:	78 19                	js     801b2d <open+0x79>
	return fd2num(fd);
  801b14:	83 ec 0c             	sub    $0xc,%esp
  801b17:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1a:	e8 f3 f7 ff ff       	call   801312 <fd2num>
  801b1f:	89 c3                	mov    %eax,%ebx
  801b21:	83 c4 10             	add    $0x10,%esp
}
  801b24:	89 d8                	mov    %ebx,%eax
  801b26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b29:	5b                   	pop    %ebx
  801b2a:	5e                   	pop    %esi
  801b2b:	5d                   	pop    %ebp
  801b2c:	c3                   	ret    
		fd_close(fd, 0);
  801b2d:	83 ec 08             	sub    $0x8,%esp
  801b30:	6a 00                	push   $0x0
  801b32:	ff 75 f4             	pushl  -0xc(%ebp)
  801b35:	e8 10 f9 ff ff       	call   80144a <fd_close>
		return r;
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	eb e5                	jmp    801b24 <open+0x70>
		return -E_BAD_PATH;
  801b3f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b44:	eb de                	jmp    801b24 <open+0x70>

00801b46 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b46:	f3 0f 1e fb          	endbr32 
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b50:	ba 00 00 00 00       	mov    $0x0,%edx
  801b55:	b8 08 00 00 00       	mov    $0x8,%eax
  801b5a:	e8 87 fd ff ff       	call   8018e6 <fsipc>
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b61:	f3 0f 1e fb          	endbr32 
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b6b:	68 4f 2e 80 00       	push   $0x802e4f
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	e8 98 f0 ff ff       	call   800c10 <strcpy>
	return 0;
}
  801b78:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <devsock_close>:
{
  801b7f:	f3 0f 1e fb          	endbr32 
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	53                   	push   %ebx
  801b87:	83 ec 10             	sub    $0x10,%esp
  801b8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b8d:	53                   	push   %ebx
  801b8e:	e8 e5 0a 00 00       	call   802678 <pageref>
  801b93:	89 c2                	mov    %eax,%edx
  801b95:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b98:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801b9d:	83 fa 01             	cmp    $0x1,%edx
  801ba0:	74 05                	je     801ba7 <devsock_close+0x28>
}
  801ba2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ba7:	83 ec 0c             	sub    $0xc,%esp
  801baa:	ff 73 0c             	pushl  0xc(%ebx)
  801bad:	e8 e3 02 00 00       	call   801e95 <nsipc_close>
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	eb eb                	jmp    801ba2 <devsock_close+0x23>

00801bb7 <devsock_write>:
{
  801bb7:	f3 0f 1e fb          	endbr32 
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	ff 75 10             	pushl  0x10(%ebp)
  801bc6:	ff 75 0c             	pushl  0xc(%ebp)
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	ff 70 0c             	pushl  0xc(%eax)
  801bcf:	e8 b5 03 00 00       	call   801f89 <nsipc_send>
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <devsock_read>:
{
  801bd6:	f3 0f 1e fb          	endbr32 
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	ff 75 10             	pushl  0x10(%ebp)
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	ff 70 0c             	pushl  0xc(%eax)
  801bee:	e8 1f 03 00 00       	call   801f12 <nsipc_recv>
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <fd2sockid>:
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bfb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bfe:	52                   	push   %edx
  801bff:	50                   	push   %eax
  801c00:	e8 92 f7 ff ff       	call   801397 <fd_lookup>
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	78 10                	js     801c1c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0f:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c15:	39 08                	cmp    %ecx,(%eax)
  801c17:	75 05                	jne    801c1e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c19:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    
		return -E_NOT_SUPP;
  801c1e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c23:	eb f7                	jmp    801c1c <fd2sockid+0x27>

00801c25 <alloc_sockfd>:
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	56                   	push   %esi
  801c29:	53                   	push   %ebx
  801c2a:	83 ec 1c             	sub    $0x1c,%esp
  801c2d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c32:	50                   	push   %eax
  801c33:	e8 09 f7 ff ff       	call   801341 <fd_alloc>
  801c38:	89 c3                	mov    %eax,%ebx
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 43                	js     801c84 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	68 07 04 00 00       	push   $0x407
  801c49:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4c:	6a 00                	push   $0x0
  801c4e:	e8 ff f3 ff ff       	call   801052 <sys_page_alloc>
  801c53:	89 c3                	mov    %eax,%ebx
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	78 28                	js     801c84 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c65:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c71:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c74:	83 ec 0c             	sub    $0xc,%esp
  801c77:	50                   	push   %eax
  801c78:	e8 95 f6 ff ff       	call   801312 <fd2num>
  801c7d:	89 c3                	mov    %eax,%ebx
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	eb 0c                	jmp    801c90 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	56                   	push   %esi
  801c88:	e8 08 02 00 00       	call   801e95 <nsipc_close>
		return r;
  801c8d:	83 c4 10             	add    $0x10,%esp
}
  801c90:	89 d8                	mov    %ebx,%eax
  801c92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c95:	5b                   	pop    %ebx
  801c96:	5e                   	pop    %esi
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    

00801c99 <accept>:
{
  801c99:	f3 0f 1e fb          	endbr32 
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	e8 4a ff ff ff       	call   801bf5 <fd2sockid>
  801cab:	85 c0                	test   %eax,%eax
  801cad:	78 1b                	js     801cca <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801caf:	83 ec 04             	sub    $0x4,%esp
  801cb2:	ff 75 10             	pushl  0x10(%ebp)
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	50                   	push   %eax
  801cb9:	e8 22 01 00 00       	call   801de0 <nsipc_accept>
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	78 05                	js     801cca <accept+0x31>
	return alloc_sockfd(r);
  801cc5:	e8 5b ff ff ff       	call   801c25 <alloc_sockfd>
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <bind>:
{
  801ccc:	f3 0f 1e fb          	endbr32 
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	e8 17 ff ff ff       	call   801bf5 <fd2sockid>
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 12                	js     801cf4 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801ce2:	83 ec 04             	sub    $0x4,%esp
  801ce5:	ff 75 10             	pushl  0x10(%ebp)
  801ce8:	ff 75 0c             	pushl  0xc(%ebp)
  801ceb:	50                   	push   %eax
  801cec:	e8 45 01 00 00       	call   801e36 <nsipc_bind>
  801cf1:	83 c4 10             	add    $0x10,%esp
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <shutdown>:
{
  801cf6:	f3 0f 1e fb          	endbr32 
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	e8 ed fe ff ff       	call   801bf5 <fd2sockid>
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 0f                	js     801d1b <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d0c:	83 ec 08             	sub    $0x8,%esp
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	50                   	push   %eax
  801d13:	e8 57 01 00 00       	call   801e6f <nsipc_shutdown>
  801d18:	83 c4 10             	add    $0x10,%esp
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <connect>:
{
  801d1d:	f3 0f 1e fb          	endbr32 
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	e8 c6 fe ff ff       	call   801bf5 <fd2sockid>
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	78 12                	js     801d45 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d33:	83 ec 04             	sub    $0x4,%esp
  801d36:	ff 75 10             	pushl  0x10(%ebp)
  801d39:	ff 75 0c             	pushl  0xc(%ebp)
  801d3c:	50                   	push   %eax
  801d3d:	e8 71 01 00 00       	call   801eb3 <nsipc_connect>
  801d42:	83 c4 10             	add    $0x10,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <listen>:
{
  801d47:	f3 0f 1e fb          	endbr32 
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	e8 9c fe ff ff       	call   801bf5 <fd2sockid>
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 0f                	js     801d6c <listen+0x25>
	return nsipc_listen(r, backlog);
  801d5d:	83 ec 08             	sub    $0x8,%esp
  801d60:	ff 75 0c             	pushl  0xc(%ebp)
  801d63:	50                   	push   %eax
  801d64:	e8 83 01 00 00       	call   801eec <nsipc_listen>
  801d69:	83 c4 10             	add    $0x10,%esp
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <socket>:

int
socket(int domain, int type, int protocol)
{
  801d6e:	f3 0f 1e fb          	endbr32 
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d78:	ff 75 10             	pushl  0x10(%ebp)
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	e8 65 02 00 00       	call   801feb <nsipc_socket>
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	78 05                	js     801d92 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d8d:	e8 93 fe ff ff       	call   801c25 <alloc_sockfd>
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	53                   	push   %ebx
  801d98:	83 ec 04             	sub    $0x4,%esp
  801d9b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d9d:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801da4:	74 26                	je     801dcc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801da6:	6a 07                	push   $0x7
  801da8:	68 00 60 80 00       	push   $0x806000
  801dad:	53                   	push   %ebx
  801dae:	ff 35 14 40 80 00    	pushl  0x804014
  801db4:	e8 2a 08 00 00       	call   8025e3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801db9:	83 c4 0c             	add    $0xc,%esp
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	e8 97 07 00 00       	call   80255e <ipc_recv>
}
  801dc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801dcc:	83 ec 0c             	sub    $0xc,%esp
  801dcf:	6a 02                	push   $0x2
  801dd1:	e8 65 08 00 00       	call   80263b <ipc_find_env>
  801dd6:	a3 14 40 80 00       	mov    %eax,0x804014
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	eb c6                	jmp    801da6 <nsipc+0x12>

00801de0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801de0:	f3 0f 1e fb          	endbr32 
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	56                   	push   %esi
  801de8:	53                   	push   %ebx
  801de9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801df4:	8b 06                	mov    (%esi),%eax
  801df6:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801dfb:	b8 01 00 00 00       	mov    $0x1,%eax
  801e00:	e8 8f ff ff ff       	call   801d94 <nsipc>
  801e05:	89 c3                	mov    %eax,%ebx
  801e07:	85 c0                	test   %eax,%eax
  801e09:	79 09                	jns    801e14 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e0b:	89 d8                	mov    %ebx,%eax
  801e0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e10:	5b                   	pop    %ebx
  801e11:	5e                   	pop    %esi
  801e12:	5d                   	pop    %ebp
  801e13:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e14:	83 ec 04             	sub    $0x4,%esp
  801e17:	ff 35 10 60 80 00    	pushl  0x806010
  801e1d:	68 00 60 80 00       	push   $0x806000
  801e22:	ff 75 0c             	pushl  0xc(%ebp)
  801e25:	e8 9c ef ff ff       	call   800dc6 <memmove>
		*addrlen = ret->ret_addrlen;
  801e2a:	a1 10 60 80 00       	mov    0x806010,%eax
  801e2f:	89 06                	mov    %eax,(%esi)
  801e31:	83 c4 10             	add    $0x10,%esp
	return r;
  801e34:	eb d5                	jmp    801e0b <nsipc_accept+0x2b>

00801e36 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e36:	f3 0f 1e fb          	endbr32 
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	53                   	push   %ebx
  801e3e:	83 ec 08             	sub    $0x8,%esp
  801e41:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e4c:	53                   	push   %ebx
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	68 04 60 80 00       	push   $0x806004
  801e55:	e8 6c ef ff ff       	call   800dc6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e5a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e60:	b8 02 00 00 00       	mov    $0x2,%eax
  801e65:	e8 2a ff ff ff       	call   801d94 <nsipc>
}
  801e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e6f:	f3 0f 1e fb          	endbr32 
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e84:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e89:	b8 03 00 00 00       	mov    $0x3,%eax
  801e8e:	e8 01 ff ff ff       	call   801d94 <nsipc>
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <nsipc_close>:

int
nsipc_close(int s)
{
  801e95:	f3 0f 1e fb          	endbr32 
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ea7:	b8 04 00 00 00       	mov    $0x4,%eax
  801eac:	e8 e3 fe ff ff       	call   801d94 <nsipc>
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801eb3:	f3 0f 1e fb          	endbr32 
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	53                   	push   %ebx
  801ebb:	83 ec 08             	sub    $0x8,%esp
  801ebe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ec9:	53                   	push   %ebx
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	68 04 60 80 00       	push   $0x806004
  801ed2:	e8 ef ee ff ff       	call   800dc6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ed7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801edd:	b8 05 00 00 00       	mov    $0x5,%eax
  801ee2:	e8 ad fe ff ff       	call   801d94 <nsipc>
}
  801ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801eec:	f3 0f 1e fb          	endbr32 
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f01:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f06:	b8 06 00 00 00       	mov    $0x6,%eax
  801f0b:	e8 84 fe ff ff       	call   801d94 <nsipc>
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f12:	f3 0f 1e fb          	endbr32 
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	56                   	push   %esi
  801f1a:	53                   	push   %ebx
  801f1b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f26:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f2c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f2f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f34:	b8 07 00 00 00       	mov    $0x7,%eax
  801f39:	e8 56 fe ff ff       	call   801d94 <nsipc>
  801f3e:	89 c3                	mov    %eax,%ebx
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 26                	js     801f6a <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f44:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f4a:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f4f:	0f 4e c6             	cmovle %esi,%eax
  801f52:	39 c3                	cmp    %eax,%ebx
  801f54:	7f 1d                	jg     801f73 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	53                   	push   %ebx
  801f5a:	68 00 60 80 00       	push   $0x806000
  801f5f:	ff 75 0c             	pushl  0xc(%ebp)
  801f62:	e8 5f ee ff ff       	call   800dc6 <memmove>
  801f67:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f6a:	89 d8                	mov    %ebx,%eax
  801f6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f73:	68 5b 2e 80 00       	push   $0x802e5b
  801f78:	68 23 2e 80 00       	push   $0x802e23
  801f7d:	6a 62                	push   $0x62
  801f7f:	68 70 2e 80 00       	push   $0x802e70
  801f84:	e8 8b 05 00 00       	call   802514 <_panic>

00801f89 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f89:	f3 0f 1e fb          	endbr32 
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	53                   	push   %ebx
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f9f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fa5:	7f 2e                	jg     801fd5 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	53                   	push   %ebx
  801fab:	ff 75 0c             	pushl  0xc(%ebp)
  801fae:	68 0c 60 80 00       	push   $0x80600c
  801fb3:	e8 0e ee ff ff       	call   800dc6 <memmove>
	nsipcbuf.send.req_size = size;
  801fb8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801fc6:	b8 08 00 00 00       	mov    $0x8,%eax
  801fcb:	e8 c4 fd ff ff       	call   801d94 <nsipc>
}
  801fd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    
	assert(size < 1600);
  801fd5:	68 7c 2e 80 00       	push   $0x802e7c
  801fda:	68 23 2e 80 00       	push   $0x802e23
  801fdf:	6a 6d                	push   $0x6d
  801fe1:	68 70 2e 80 00       	push   $0x802e70
  801fe6:	e8 29 05 00 00       	call   802514 <_panic>

00801feb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801feb:	f3 0f 1e fb          	endbr32 
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802000:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802005:	8b 45 10             	mov    0x10(%ebp),%eax
  802008:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80200d:	b8 09 00 00 00       	mov    $0x9,%eax
  802012:	e8 7d fd ff ff       	call   801d94 <nsipc>
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802019:	f3 0f 1e fb          	endbr32 
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	56                   	push   %esi
  802021:	53                   	push   %ebx
  802022:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802025:	83 ec 0c             	sub    $0xc,%esp
  802028:	ff 75 08             	pushl  0x8(%ebp)
  80202b:	e8 f6 f2 ff ff       	call   801326 <fd2data>
  802030:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802032:	83 c4 08             	add    $0x8,%esp
  802035:	68 88 2e 80 00       	push   $0x802e88
  80203a:	53                   	push   %ebx
  80203b:	e8 d0 eb ff ff       	call   800c10 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802040:	8b 46 04             	mov    0x4(%esi),%eax
  802043:	2b 06                	sub    (%esi),%eax
  802045:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80204b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802052:	00 00 00 
	stat->st_dev = &devpipe;
  802055:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80205c:	30 80 00 
	return 0;
}
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
  802064:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5d                   	pop    %ebp
  80206a:	c3                   	ret    

0080206b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80206b:	f3 0f 1e fb          	endbr32 
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	53                   	push   %ebx
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802079:	53                   	push   %ebx
  80207a:	6a 00                	push   $0x0
  80207c:	e8 5e f0 ff ff       	call   8010df <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802081:	89 1c 24             	mov    %ebx,(%esp)
  802084:	e8 9d f2 ff ff       	call   801326 <fd2data>
  802089:	83 c4 08             	add    $0x8,%esp
  80208c:	50                   	push   %eax
  80208d:	6a 00                	push   $0x0
  80208f:	e8 4b f0 ff ff       	call   8010df <sys_page_unmap>
}
  802094:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <_pipeisclosed>:
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	57                   	push   %edi
  80209d:	56                   	push   %esi
  80209e:	53                   	push   %ebx
  80209f:	83 ec 1c             	sub    $0x1c,%esp
  8020a2:	89 c7                	mov    %eax,%edi
  8020a4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020a6:	a1 18 40 80 00       	mov    0x804018,%eax
  8020ab:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020ae:	83 ec 0c             	sub    $0xc,%esp
  8020b1:	57                   	push   %edi
  8020b2:	e8 c1 05 00 00       	call   802678 <pageref>
  8020b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020ba:	89 34 24             	mov    %esi,(%esp)
  8020bd:	e8 b6 05 00 00       	call   802678 <pageref>
		nn = thisenv->env_runs;
  8020c2:	8b 15 18 40 80 00    	mov    0x804018,%edx
  8020c8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	39 cb                	cmp    %ecx,%ebx
  8020d0:	74 1b                	je     8020ed <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020d2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020d5:	75 cf                	jne    8020a6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020d7:	8b 42 58             	mov    0x58(%edx),%eax
  8020da:	6a 01                	push   $0x1
  8020dc:	50                   	push   %eax
  8020dd:	53                   	push   %ebx
  8020de:	68 8f 2e 80 00       	push   $0x802e8f
  8020e3:	e8 1e e5 ff ff       	call   800606 <cprintf>
  8020e8:	83 c4 10             	add    $0x10,%esp
  8020eb:	eb b9                	jmp    8020a6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020ed:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020f0:	0f 94 c0             	sete   %al
  8020f3:	0f b6 c0             	movzbl %al,%eax
}
  8020f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f9:	5b                   	pop    %ebx
  8020fa:	5e                   	pop    %esi
  8020fb:	5f                   	pop    %edi
  8020fc:	5d                   	pop    %ebp
  8020fd:	c3                   	ret    

008020fe <devpipe_write>:
{
  8020fe:	f3 0f 1e fb          	endbr32 
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	57                   	push   %edi
  802106:	56                   	push   %esi
  802107:	53                   	push   %ebx
  802108:	83 ec 28             	sub    $0x28,%esp
  80210b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80210e:	56                   	push   %esi
  80210f:	e8 12 f2 ff ff       	call   801326 <fd2data>
  802114:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802116:	83 c4 10             	add    $0x10,%esp
  802119:	bf 00 00 00 00       	mov    $0x0,%edi
  80211e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802121:	74 4f                	je     802172 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802123:	8b 43 04             	mov    0x4(%ebx),%eax
  802126:	8b 0b                	mov    (%ebx),%ecx
  802128:	8d 51 20             	lea    0x20(%ecx),%edx
  80212b:	39 d0                	cmp    %edx,%eax
  80212d:	72 14                	jb     802143 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80212f:	89 da                	mov    %ebx,%edx
  802131:	89 f0                	mov    %esi,%eax
  802133:	e8 61 ff ff ff       	call   802099 <_pipeisclosed>
  802138:	85 c0                	test   %eax,%eax
  80213a:	75 3b                	jne    802177 <devpipe_write+0x79>
			sys_yield();
  80213c:	e8 ee ee ff ff       	call   80102f <sys_yield>
  802141:	eb e0                	jmp    802123 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802143:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802146:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80214a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80214d:	89 c2                	mov    %eax,%edx
  80214f:	c1 fa 1f             	sar    $0x1f,%edx
  802152:	89 d1                	mov    %edx,%ecx
  802154:	c1 e9 1b             	shr    $0x1b,%ecx
  802157:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80215a:	83 e2 1f             	and    $0x1f,%edx
  80215d:	29 ca                	sub    %ecx,%edx
  80215f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802163:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802167:	83 c0 01             	add    $0x1,%eax
  80216a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80216d:	83 c7 01             	add    $0x1,%edi
  802170:	eb ac                	jmp    80211e <devpipe_write+0x20>
	return i;
  802172:	8b 45 10             	mov    0x10(%ebp),%eax
  802175:	eb 05                	jmp    80217c <devpipe_write+0x7e>
				return 0;
  802177:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80217c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217f:	5b                   	pop    %ebx
  802180:	5e                   	pop    %esi
  802181:	5f                   	pop    %edi
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    

00802184 <devpipe_read>:
{
  802184:	f3 0f 1e fb          	endbr32 
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	57                   	push   %edi
  80218c:	56                   	push   %esi
  80218d:	53                   	push   %ebx
  80218e:	83 ec 18             	sub    $0x18,%esp
  802191:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802194:	57                   	push   %edi
  802195:	e8 8c f1 ff ff       	call   801326 <fd2data>
  80219a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80219c:	83 c4 10             	add    $0x10,%esp
  80219f:	be 00 00 00 00       	mov    $0x0,%esi
  8021a4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a7:	75 14                	jne    8021bd <devpipe_read+0x39>
	return i;
  8021a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ac:	eb 02                	jmp    8021b0 <devpipe_read+0x2c>
				return i;
  8021ae:	89 f0                	mov    %esi,%eax
}
  8021b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021b3:	5b                   	pop    %ebx
  8021b4:	5e                   	pop    %esi
  8021b5:	5f                   	pop    %edi
  8021b6:	5d                   	pop    %ebp
  8021b7:	c3                   	ret    
			sys_yield();
  8021b8:	e8 72 ee ff ff       	call   80102f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8021bd:	8b 03                	mov    (%ebx),%eax
  8021bf:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021c2:	75 18                	jne    8021dc <devpipe_read+0x58>
			if (i > 0)
  8021c4:	85 f6                	test   %esi,%esi
  8021c6:	75 e6                	jne    8021ae <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8021c8:	89 da                	mov    %ebx,%edx
  8021ca:	89 f8                	mov    %edi,%eax
  8021cc:	e8 c8 fe ff ff       	call   802099 <_pipeisclosed>
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	74 e3                	je     8021b8 <devpipe_read+0x34>
				return 0;
  8021d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021da:	eb d4                	jmp    8021b0 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021dc:	99                   	cltd   
  8021dd:	c1 ea 1b             	shr    $0x1b,%edx
  8021e0:	01 d0                	add    %edx,%eax
  8021e2:	83 e0 1f             	and    $0x1f,%eax
  8021e5:	29 d0                	sub    %edx,%eax
  8021e7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021ef:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021f2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021f5:	83 c6 01             	add    $0x1,%esi
  8021f8:	eb aa                	jmp    8021a4 <devpipe_read+0x20>

008021fa <pipe>:
{
  8021fa:	f3 0f 1e fb          	endbr32 
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	56                   	push   %esi
  802202:	53                   	push   %ebx
  802203:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802206:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802209:	50                   	push   %eax
  80220a:	e8 32 f1 ff ff       	call   801341 <fd_alloc>
  80220f:	89 c3                	mov    %eax,%ebx
  802211:	83 c4 10             	add    $0x10,%esp
  802214:	85 c0                	test   %eax,%eax
  802216:	0f 88 23 01 00 00    	js     80233f <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80221c:	83 ec 04             	sub    $0x4,%esp
  80221f:	68 07 04 00 00       	push   $0x407
  802224:	ff 75 f4             	pushl  -0xc(%ebp)
  802227:	6a 00                	push   $0x0
  802229:	e8 24 ee ff ff       	call   801052 <sys_page_alloc>
  80222e:	89 c3                	mov    %eax,%ebx
  802230:	83 c4 10             	add    $0x10,%esp
  802233:	85 c0                	test   %eax,%eax
  802235:	0f 88 04 01 00 00    	js     80233f <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80223b:	83 ec 0c             	sub    $0xc,%esp
  80223e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802241:	50                   	push   %eax
  802242:	e8 fa f0 ff ff       	call   801341 <fd_alloc>
  802247:	89 c3                	mov    %eax,%ebx
  802249:	83 c4 10             	add    $0x10,%esp
  80224c:	85 c0                	test   %eax,%eax
  80224e:	0f 88 db 00 00 00    	js     80232f <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 07 04 00 00       	push   $0x407
  80225c:	ff 75 f0             	pushl  -0x10(%ebp)
  80225f:	6a 00                	push   $0x0
  802261:	e8 ec ed ff ff       	call   801052 <sys_page_alloc>
  802266:	89 c3                	mov    %eax,%ebx
  802268:	83 c4 10             	add    $0x10,%esp
  80226b:	85 c0                	test   %eax,%eax
  80226d:	0f 88 bc 00 00 00    	js     80232f <pipe+0x135>
	va = fd2data(fd0);
  802273:	83 ec 0c             	sub    $0xc,%esp
  802276:	ff 75 f4             	pushl  -0xc(%ebp)
  802279:	e8 a8 f0 ff ff       	call   801326 <fd2data>
  80227e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802280:	83 c4 0c             	add    $0xc,%esp
  802283:	68 07 04 00 00       	push   $0x407
  802288:	50                   	push   %eax
  802289:	6a 00                	push   $0x0
  80228b:	e8 c2 ed ff ff       	call   801052 <sys_page_alloc>
  802290:	89 c3                	mov    %eax,%ebx
  802292:	83 c4 10             	add    $0x10,%esp
  802295:	85 c0                	test   %eax,%eax
  802297:	0f 88 82 00 00 00    	js     80231f <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80229d:	83 ec 0c             	sub    $0xc,%esp
  8022a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8022a3:	e8 7e f0 ff ff       	call   801326 <fd2data>
  8022a8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022af:	50                   	push   %eax
  8022b0:	6a 00                	push   $0x0
  8022b2:	56                   	push   %esi
  8022b3:	6a 00                	push   $0x0
  8022b5:	e8 df ed ff ff       	call   801099 <sys_page_map>
  8022ba:	89 c3                	mov    %eax,%ebx
  8022bc:	83 c4 20             	add    $0x20,%esp
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	78 4e                	js     802311 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8022c3:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8022c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022da:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022df:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022e6:	83 ec 0c             	sub    $0xc,%esp
  8022e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ec:	e8 21 f0 ff ff       	call   801312 <fd2num>
  8022f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022f4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022f6:	83 c4 04             	add    $0x4,%esp
  8022f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8022fc:	e8 11 f0 ff ff       	call   801312 <fd2num>
  802301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802304:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802307:	83 c4 10             	add    $0x10,%esp
  80230a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80230f:	eb 2e                	jmp    80233f <pipe+0x145>
	sys_page_unmap(0, va);
  802311:	83 ec 08             	sub    $0x8,%esp
  802314:	56                   	push   %esi
  802315:	6a 00                	push   $0x0
  802317:	e8 c3 ed ff ff       	call   8010df <sys_page_unmap>
  80231c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80231f:	83 ec 08             	sub    $0x8,%esp
  802322:	ff 75 f0             	pushl  -0x10(%ebp)
  802325:	6a 00                	push   $0x0
  802327:	e8 b3 ed ff ff       	call   8010df <sys_page_unmap>
  80232c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80232f:	83 ec 08             	sub    $0x8,%esp
  802332:	ff 75 f4             	pushl  -0xc(%ebp)
  802335:	6a 00                	push   $0x0
  802337:	e8 a3 ed ff ff       	call   8010df <sys_page_unmap>
  80233c:	83 c4 10             	add    $0x10,%esp
}
  80233f:	89 d8                	mov    %ebx,%eax
  802341:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802344:	5b                   	pop    %ebx
  802345:	5e                   	pop    %esi
  802346:	5d                   	pop    %ebp
  802347:	c3                   	ret    

00802348 <pipeisclosed>:
{
  802348:	f3 0f 1e fb          	endbr32 
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802352:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802355:	50                   	push   %eax
  802356:	ff 75 08             	pushl  0x8(%ebp)
  802359:	e8 39 f0 ff ff       	call   801397 <fd_lookup>
  80235e:	83 c4 10             	add    $0x10,%esp
  802361:	85 c0                	test   %eax,%eax
  802363:	78 18                	js     80237d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802365:	83 ec 0c             	sub    $0xc,%esp
  802368:	ff 75 f4             	pushl  -0xc(%ebp)
  80236b:	e8 b6 ef ff ff       	call   801326 <fd2data>
  802370:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	e8 1f fd ff ff       	call   802099 <_pipeisclosed>
  80237a:	83 c4 10             	add    $0x10,%esp
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80237f:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
  802388:	c3                   	ret    

00802389 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802389:	f3 0f 1e fb          	endbr32 
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802393:	68 a7 2e 80 00       	push   $0x802ea7
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	e8 70 e8 ff ff       	call   800c10 <strcpy>
	return 0;
}
  8023a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <devcons_write>:
{
  8023a7:	f3 0f 1e fb          	endbr32 
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	57                   	push   %edi
  8023af:	56                   	push   %esi
  8023b0:	53                   	push   %ebx
  8023b1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023b7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023bc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023c2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023c5:	73 31                	jae    8023f8 <devcons_write+0x51>
		m = n - tot;
  8023c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023ca:	29 f3                	sub    %esi,%ebx
  8023cc:	83 fb 7f             	cmp    $0x7f,%ebx
  8023cf:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023d4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	53                   	push   %ebx
  8023db:	89 f0                	mov    %esi,%eax
  8023dd:	03 45 0c             	add    0xc(%ebp),%eax
  8023e0:	50                   	push   %eax
  8023e1:	57                   	push   %edi
  8023e2:	e8 df e9 ff ff       	call   800dc6 <memmove>
		sys_cputs(buf, m);
  8023e7:	83 c4 08             	add    $0x8,%esp
  8023ea:	53                   	push   %ebx
  8023eb:	57                   	push   %edi
  8023ec:	e8 91 eb ff ff       	call   800f82 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023f1:	01 de                	add    %ebx,%esi
  8023f3:	83 c4 10             	add    $0x10,%esp
  8023f6:	eb ca                	jmp    8023c2 <devcons_write+0x1b>
}
  8023f8:	89 f0                	mov    %esi,%eax
  8023fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023fd:	5b                   	pop    %ebx
  8023fe:	5e                   	pop    %esi
  8023ff:	5f                   	pop    %edi
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    

00802402 <devcons_read>:
{
  802402:	f3 0f 1e fb          	endbr32 
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 08             	sub    $0x8,%esp
  80240c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802411:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802415:	74 21                	je     802438 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802417:	e8 88 eb ff ff       	call   800fa4 <sys_cgetc>
  80241c:	85 c0                	test   %eax,%eax
  80241e:	75 07                	jne    802427 <devcons_read+0x25>
		sys_yield();
  802420:	e8 0a ec ff ff       	call   80102f <sys_yield>
  802425:	eb f0                	jmp    802417 <devcons_read+0x15>
	if (c < 0)
  802427:	78 0f                	js     802438 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802429:	83 f8 04             	cmp    $0x4,%eax
  80242c:	74 0c                	je     80243a <devcons_read+0x38>
	*(char*)vbuf = c;
  80242e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802431:	88 02                	mov    %al,(%edx)
	return 1;
  802433:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    
		return 0;
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
  80243f:	eb f7                	jmp    802438 <devcons_read+0x36>

00802441 <cputchar>:
{
  802441:	f3 0f 1e fb          	endbr32 
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802451:	6a 01                	push   $0x1
  802453:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802456:	50                   	push   %eax
  802457:	e8 26 eb ff ff       	call   800f82 <sys_cputs>
}
  80245c:	83 c4 10             	add    $0x10,%esp
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <getchar>:
{
  802461:	f3 0f 1e fb          	endbr32 
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80246b:	6a 01                	push   $0x1
  80246d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802470:	50                   	push   %eax
  802471:	6a 00                	push   $0x0
  802473:	e8 a7 f1 ff ff       	call   80161f <read>
	if (r < 0)
  802478:	83 c4 10             	add    $0x10,%esp
  80247b:	85 c0                	test   %eax,%eax
  80247d:	78 06                	js     802485 <getchar+0x24>
	if (r < 1)
  80247f:	74 06                	je     802487 <getchar+0x26>
	return c;
  802481:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802485:	c9                   	leave  
  802486:	c3                   	ret    
		return -E_EOF;
  802487:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80248c:	eb f7                	jmp    802485 <getchar+0x24>

0080248e <iscons>:
{
  80248e:	f3 0f 1e fb          	endbr32 
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802498:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249b:	50                   	push   %eax
  80249c:	ff 75 08             	pushl  0x8(%ebp)
  80249f:	e8 f3 ee ff ff       	call   801397 <fd_lookup>
  8024a4:	83 c4 10             	add    $0x10,%esp
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	78 11                	js     8024bc <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024b4:	39 10                	cmp    %edx,(%eax)
  8024b6:	0f 94 c0             	sete   %al
  8024b9:	0f b6 c0             	movzbl %al,%eax
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <opencons>:
{
  8024be:	f3 0f 1e fb          	endbr32 
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
  8024c5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024cb:	50                   	push   %eax
  8024cc:	e8 70 ee ff ff       	call   801341 <fd_alloc>
  8024d1:	83 c4 10             	add    $0x10,%esp
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	78 3a                	js     802512 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024d8:	83 ec 04             	sub    $0x4,%esp
  8024db:	68 07 04 00 00       	push   $0x407
  8024e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8024e3:	6a 00                	push   $0x0
  8024e5:	e8 68 eb ff ff       	call   801052 <sys_page_alloc>
  8024ea:	83 c4 10             	add    $0x10,%esp
  8024ed:	85 c0                	test   %eax,%eax
  8024ef:	78 21                	js     802512 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024fa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802506:	83 ec 0c             	sub    $0xc,%esp
  802509:	50                   	push   %eax
  80250a:	e8 03 ee ff ff       	call   801312 <fd2num>
  80250f:	83 c4 10             	add    $0x10,%esp
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802514:	f3 0f 1e fb          	endbr32 
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	56                   	push   %esi
  80251c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80251d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802520:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802526:	e8 e1 ea ff ff       	call   80100c <sys_getenvid>
  80252b:	83 ec 0c             	sub    $0xc,%esp
  80252e:	ff 75 0c             	pushl  0xc(%ebp)
  802531:	ff 75 08             	pushl  0x8(%ebp)
  802534:	56                   	push   %esi
  802535:	50                   	push   %eax
  802536:	68 b4 2e 80 00       	push   $0x802eb4
  80253b:	e8 c6 e0 ff ff       	call   800606 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802540:	83 c4 18             	add    $0x18,%esp
  802543:	53                   	push   %ebx
  802544:	ff 75 10             	pushl  0x10(%ebp)
  802547:	e8 65 e0 ff ff       	call   8005b1 <vcprintf>
	cprintf("\n");
  80254c:	c7 04 24 f0 2e 80 00 	movl   $0x802ef0,(%esp)
  802553:	e8 ae e0 ff ff       	call   800606 <cprintf>
  802558:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80255b:	cc                   	int3   
  80255c:	eb fd                	jmp    80255b <_panic+0x47>

0080255e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80255e:	f3 0f 1e fb          	endbr32 
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	56                   	push   %esi
  802566:	53                   	push   %ebx
  802567:	8b 75 08             	mov    0x8(%ebp),%esi
  80256a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802570:	85 c0                	test   %eax,%eax
  802572:	74 3d                	je     8025b1 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802574:	83 ec 0c             	sub    $0xc,%esp
  802577:	50                   	push   %eax
  802578:	e8 a1 ec ff ff       	call   80121e <sys_ipc_recv>
  80257d:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802580:	85 f6                	test   %esi,%esi
  802582:	74 0b                	je     80258f <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802584:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80258a:	8b 52 74             	mov    0x74(%edx),%edx
  80258d:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80258f:	85 db                	test   %ebx,%ebx
  802591:	74 0b                	je     80259e <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802593:	8b 15 18 40 80 00    	mov    0x804018,%edx
  802599:	8b 52 78             	mov    0x78(%edx),%edx
  80259c:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	78 21                	js     8025c3 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8025a2:	a1 18 40 80 00       	mov    0x804018,%eax
  8025a7:	8b 40 70             	mov    0x70(%eax),%eax
}
  8025aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ad:	5b                   	pop    %ebx
  8025ae:	5e                   	pop    %esi
  8025af:	5d                   	pop    %ebp
  8025b0:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8025b1:	83 ec 0c             	sub    $0xc,%esp
  8025b4:	68 00 00 c0 ee       	push   $0xeec00000
  8025b9:	e8 60 ec ff ff       	call   80121e <sys_ipc_recv>
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	eb bd                	jmp    802580 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8025c3:	85 f6                	test   %esi,%esi
  8025c5:	74 10                	je     8025d7 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8025c7:	85 db                	test   %ebx,%ebx
  8025c9:	75 df                	jne    8025aa <ipc_recv+0x4c>
  8025cb:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8025d2:	00 00 00 
  8025d5:	eb d3                	jmp    8025aa <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8025d7:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8025de:	00 00 00 
  8025e1:	eb e4                	jmp    8025c7 <ipc_recv+0x69>

008025e3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025e3:	f3 0f 1e fb          	endbr32 
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	57                   	push   %edi
  8025eb:	56                   	push   %esi
  8025ec:	53                   	push   %ebx
  8025ed:	83 ec 0c             	sub    $0xc,%esp
  8025f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8025f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8025f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8025f9:	85 db                	test   %ebx,%ebx
  8025fb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802600:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802603:	ff 75 14             	pushl  0x14(%ebp)
  802606:	53                   	push   %ebx
  802607:	56                   	push   %esi
  802608:	57                   	push   %edi
  802609:	e8 e9 eb ff ff       	call   8011f7 <sys_ipc_try_send>
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	85 c0                	test   %eax,%eax
  802613:	79 1e                	jns    802633 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802615:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802618:	75 07                	jne    802621 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80261a:	e8 10 ea ff ff       	call   80102f <sys_yield>
  80261f:	eb e2                	jmp    802603 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802621:	50                   	push   %eax
  802622:	68 d7 2e 80 00       	push   $0x802ed7
  802627:	6a 59                	push   $0x59
  802629:	68 f2 2e 80 00       	push   $0x802ef2
  80262e:	e8 e1 fe ff ff       	call   802514 <_panic>
	}
}
  802633:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802636:	5b                   	pop    %ebx
  802637:	5e                   	pop    %esi
  802638:	5f                   	pop    %edi
  802639:	5d                   	pop    %ebp
  80263a:	c3                   	ret    

0080263b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80263b:	f3 0f 1e fb          	endbr32 
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802645:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80264a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80264d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802653:	8b 52 50             	mov    0x50(%edx),%edx
  802656:	39 ca                	cmp    %ecx,%edx
  802658:	74 11                	je     80266b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80265a:	83 c0 01             	add    $0x1,%eax
  80265d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802662:	75 e6                	jne    80264a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802664:	b8 00 00 00 00       	mov    $0x0,%eax
  802669:	eb 0b                	jmp    802676 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80266b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80266e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802673:	8b 40 48             	mov    0x48(%eax),%eax
}
  802676:	5d                   	pop    %ebp
  802677:	c3                   	ret    

00802678 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802678:	f3 0f 1e fb          	endbr32 
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802682:	89 c2                	mov    %eax,%edx
  802684:	c1 ea 16             	shr    $0x16,%edx
  802687:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80268e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802693:	f6 c1 01             	test   $0x1,%cl
  802696:	74 1c                	je     8026b4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802698:	c1 e8 0c             	shr    $0xc,%eax
  80269b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8026a2:	a8 01                	test   $0x1,%al
  8026a4:	74 0e                	je     8026b4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026a6:	c1 e8 0c             	shr    $0xc,%eax
  8026a9:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8026b0:	ef 
  8026b1:	0f b7 d2             	movzwl %dx,%edx
}
  8026b4:	89 d0                	mov    %edx,%eax
  8026b6:	5d                   	pop    %ebp
  8026b7:	c3                   	ret    
  8026b8:	66 90                	xchg   %ax,%ax
  8026ba:	66 90                	xchg   %ax,%ax
  8026bc:	66 90                	xchg   %ax,%ax
  8026be:	66 90                	xchg   %ax,%ax

008026c0 <__udivdi3>:
  8026c0:	f3 0f 1e fb          	endbr32 
  8026c4:	55                   	push   %ebp
  8026c5:	57                   	push   %edi
  8026c6:	56                   	push   %esi
  8026c7:	53                   	push   %ebx
  8026c8:	83 ec 1c             	sub    $0x1c,%esp
  8026cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8026cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8026d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8026db:	85 d2                	test   %edx,%edx
  8026dd:	75 19                	jne    8026f8 <__udivdi3+0x38>
  8026df:	39 f3                	cmp    %esi,%ebx
  8026e1:	76 4d                	jbe    802730 <__udivdi3+0x70>
  8026e3:	31 ff                	xor    %edi,%edi
  8026e5:	89 e8                	mov    %ebp,%eax
  8026e7:	89 f2                	mov    %esi,%edx
  8026e9:	f7 f3                	div    %ebx
  8026eb:	89 fa                	mov    %edi,%edx
  8026ed:	83 c4 1c             	add    $0x1c,%esp
  8026f0:	5b                   	pop    %ebx
  8026f1:	5e                   	pop    %esi
  8026f2:	5f                   	pop    %edi
  8026f3:	5d                   	pop    %ebp
  8026f4:	c3                   	ret    
  8026f5:	8d 76 00             	lea    0x0(%esi),%esi
  8026f8:	39 f2                	cmp    %esi,%edx
  8026fa:	76 14                	jbe    802710 <__udivdi3+0x50>
  8026fc:	31 ff                	xor    %edi,%edi
  8026fe:	31 c0                	xor    %eax,%eax
  802700:	89 fa                	mov    %edi,%edx
  802702:	83 c4 1c             	add    $0x1c,%esp
  802705:	5b                   	pop    %ebx
  802706:	5e                   	pop    %esi
  802707:	5f                   	pop    %edi
  802708:	5d                   	pop    %ebp
  802709:	c3                   	ret    
  80270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802710:	0f bd fa             	bsr    %edx,%edi
  802713:	83 f7 1f             	xor    $0x1f,%edi
  802716:	75 48                	jne    802760 <__udivdi3+0xa0>
  802718:	39 f2                	cmp    %esi,%edx
  80271a:	72 06                	jb     802722 <__udivdi3+0x62>
  80271c:	31 c0                	xor    %eax,%eax
  80271e:	39 eb                	cmp    %ebp,%ebx
  802720:	77 de                	ja     802700 <__udivdi3+0x40>
  802722:	b8 01 00 00 00       	mov    $0x1,%eax
  802727:	eb d7                	jmp    802700 <__udivdi3+0x40>
  802729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802730:	89 d9                	mov    %ebx,%ecx
  802732:	85 db                	test   %ebx,%ebx
  802734:	75 0b                	jne    802741 <__udivdi3+0x81>
  802736:	b8 01 00 00 00       	mov    $0x1,%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	f7 f3                	div    %ebx
  80273f:	89 c1                	mov    %eax,%ecx
  802741:	31 d2                	xor    %edx,%edx
  802743:	89 f0                	mov    %esi,%eax
  802745:	f7 f1                	div    %ecx
  802747:	89 c6                	mov    %eax,%esi
  802749:	89 e8                	mov    %ebp,%eax
  80274b:	89 f7                	mov    %esi,%edi
  80274d:	f7 f1                	div    %ecx
  80274f:	89 fa                	mov    %edi,%edx
  802751:	83 c4 1c             	add    $0x1c,%esp
  802754:	5b                   	pop    %ebx
  802755:	5e                   	pop    %esi
  802756:	5f                   	pop    %edi
  802757:	5d                   	pop    %ebp
  802758:	c3                   	ret    
  802759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802760:	89 f9                	mov    %edi,%ecx
  802762:	b8 20 00 00 00       	mov    $0x20,%eax
  802767:	29 f8                	sub    %edi,%eax
  802769:	d3 e2                	shl    %cl,%edx
  80276b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80276f:	89 c1                	mov    %eax,%ecx
  802771:	89 da                	mov    %ebx,%edx
  802773:	d3 ea                	shr    %cl,%edx
  802775:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802779:	09 d1                	or     %edx,%ecx
  80277b:	89 f2                	mov    %esi,%edx
  80277d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802781:	89 f9                	mov    %edi,%ecx
  802783:	d3 e3                	shl    %cl,%ebx
  802785:	89 c1                	mov    %eax,%ecx
  802787:	d3 ea                	shr    %cl,%edx
  802789:	89 f9                	mov    %edi,%ecx
  80278b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80278f:	89 eb                	mov    %ebp,%ebx
  802791:	d3 e6                	shl    %cl,%esi
  802793:	89 c1                	mov    %eax,%ecx
  802795:	d3 eb                	shr    %cl,%ebx
  802797:	09 de                	or     %ebx,%esi
  802799:	89 f0                	mov    %esi,%eax
  80279b:	f7 74 24 08          	divl   0x8(%esp)
  80279f:	89 d6                	mov    %edx,%esi
  8027a1:	89 c3                	mov    %eax,%ebx
  8027a3:	f7 64 24 0c          	mull   0xc(%esp)
  8027a7:	39 d6                	cmp    %edx,%esi
  8027a9:	72 15                	jb     8027c0 <__udivdi3+0x100>
  8027ab:	89 f9                	mov    %edi,%ecx
  8027ad:	d3 e5                	shl    %cl,%ebp
  8027af:	39 c5                	cmp    %eax,%ebp
  8027b1:	73 04                	jae    8027b7 <__udivdi3+0xf7>
  8027b3:	39 d6                	cmp    %edx,%esi
  8027b5:	74 09                	je     8027c0 <__udivdi3+0x100>
  8027b7:	89 d8                	mov    %ebx,%eax
  8027b9:	31 ff                	xor    %edi,%edi
  8027bb:	e9 40 ff ff ff       	jmp    802700 <__udivdi3+0x40>
  8027c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027c3:	31 ff                	xor    %edi,%edi
  8027c5:	e9 36 ff ff ff       	jmp    802700 <__udivdi3+0x40>
  8027ca:	66 90                	xchg   %ax,%ax
  8027cc:	66 90                	xchg   %ax,%ax
  8027ce:	66 90                	xchg   %ax,%ax

008027d0 <__umoddi3>:
  8027d0:	f3 0f 1e fb          	endbr32 
  8027d4:	55                   	push   %ebp
  8027d5:	57                   	push   %edi
  8027d6:	56                   	push   %esi
  8027d7:	53                   	push   %ebx
  8027d8:	83 ec 1c             	sub    $0x1c,%esp
  8027db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8027e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8027e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	75 19                	jne    802808 <__umoddi3+0x38>
  8027ef:	39 df                	cmp    %ebx,%edi
  8027f1:	76 5d                	jbe    802850 <__umoddi3+0x80>
  8027f3:	89 f0                	mov    %esi,%eax
  8027f5:	89 da                	mov    %ebx,%edx
  8027f7:	f7 f7                	div    %edi
  8027f9:	89 d0                	mov    %edx,%eax
  8027fb:	31 d2                	xor    %edx,%edx
  8027fd:	83 c4 1c             	add    $0x1c,%esp
  802800:	5b                   	pop    %ebx
  802801:	5e                   	pop    %esi
  802802:	5f                   	pop    %edi
  802803:	5d                   	pop    %ebp
  802804:	c3                   	ret    
  802805:	8d 76 00             	lea    0x0(%esi),%esi
  802808:	89 f2                	mov    %esi,%edx
  80280a:	39 d8                	cmp    %ebx,%eax
  80280c:	76 12                	jbe    802820 <__umoddi3+0x50>
  80280e:	89 f0                	mov    %esi,%eax
  802810:	89 da                	mov    %ebx,%edx
  802812:	83 c4 1c             	add    $0x1c,%esp
  802815:	5b                   	pop    %ebx
  802816:	5e                   	pop    %esi
  802817:	5f                   	pop    %edi
  802818:	5d                   	pop    %ebp
  802819:	c3                   	ret    
  80281a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802820:	0f bd e8             	bsr    %eax,%ebp
  802823:	83 f5 1f             	xor    $0x1f,%ebp
  802826:	75 50                	jne    802878 <__umoddi3+0xa8>
  802828:	39 d8                	cmp    %ebx,%eax
  80282a:	0f 82 e0 00 00 00    	jb     802910 <__umoddi3+0x140>
  802830:	89 d9                	mov    %ebx,%ecx
  802832:	39 f7                	cmp    %esi,%edi
  802834:	0f 86 d6 00 00 00    	jbe    802910 <__umoddi3+0x140>
  80283a:	89 d0                	mov    %edx,%eax
  80283c:	89 ca                	mov    %ecx,%edx
  80283e:	83 c4 1c             	add    $0x1c,%esp
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5f                   	pop    %edi
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    
  802846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80284d:	8d 76 00             	lea    0x0(%esi),%esi
  802850:	89 fd                	mov    %edi,%ebp
  802852:	85 ff                	test   %edi,%edi
  802854:	75 0b                	jne    802861 <__umoddi3+0x91>
  802856:	b8 01 00 00 00       	mov    $0x1,%eax
  80285b:	31 d2                	xor    %edx,%edx
  80285d:	f7 f7                	div    %edi
  80285f:	89 c5                	mov    %eax,%ebp
  802861:	89 d8                	mov    %ebx,%eax
  802863:	31 d2                	xor    %edx,%edx
  802865:	f7 f5                	div    %ebp
  802867:	89 f0                	mov    %esi,%eax
  802869:	f7 f5                	div    %ebp
  80286b:	89 d0                	mov    %edx,%eax
  80286d:	31 d2                	xor    %edx,%edx
  80286f:	eb 8c                	jmp    8027fd <__umoddi3+0x2d>
  802871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802878:	89 e9                	mov    %ebp,%ecx
  80287a:	ba 20 00 00 00       	mov    $0x20,%edx
  80287f:	29 ea                	sub    %ebp,%edx
  802881:	d3 e0                	shl    %cl,%eax
  802883:	89 44 24 08          	mov    %eax,0x8(%esp)
  802887:	89 d1                	mov    %edx,%ecx
  802889:	89 f8                	mov    %edi,%eax
  80288b:	d3 e8                	shr    %cl,%eax
  80288d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802891:	89 54 24 04          	mov    %edx,0x4(%esp)
  802895:	8b 54 24 04          	mov    0x4(%esp),%edx
  802899:	09 c1                	or     %eax,%ecx
  80289b:	89 d8                	mov    %ebx,%eax
  80289d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028a1:	89 e9                	mov    %ebp,%ecx
  8028a3:	d3 e7                	shl    %cl,%edi
  8028a5:	89 d1                	mov    %edx,%ecx
  8028a7:	d3 e8                	shr    %cl,%eax
  8028a9:	89 e9                	mov    %ebp,%ecx
  8028ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028af:	d3 e3                	shl    %cl,%ebx
  8028b1:	89 c7                	mov    %eax,%edi
  8028b3:	89 d1                	mov    %edx,%ecx
  8028b5:	89 f0                	mov    %esi,%eax
  8028b7:	d3 e8                	shr    %cl,%eax
  8028b9:	89 e9                	mov    %ebp,%ecx
  8028bb:	89 fa                	mov    %edi,%edx
  8028bd:	d3 e6                	shl    %cl,%esi
  8028bf:	09 d8                	or     %ebx,%eax
  8028c1:	f7 74 24 08          	divl   0x8(%esp)
  8028c5:	89 d1                	mov    %edx,%ecx
  8028c7:	89 f3                	mov    %esi,%ebx
  8028c9:	f7 64 24 0c          	mull   0xc(%esp)
  8028cd:	89 c6                	mov    %eax,%esi
  8028cf:	89 d7                	mov    %edx,%edi
  8028d1:	39 d1                	cmp    %edx,%ecx
  8028d3:	72 06                	jb     8028db <__umoddi3+0x10b>
  8028d5:	75 10                	jne    8028e7 <__umoddi3+0x117>
  8028d7:	39 c3                	cmp    %eax,%ebx
  8028d9:	73 0c                	jae    8028e7 <__umoddi3+0x117>
  8028db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8028df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8028e3:	89 d7                	mov    %edx,%edi
  8028e5:	89 c6                	mov    %eax,%esi
  8028e7:	89 ca                	mov    %ecx,%edx
  8028e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028ee:	29 f3                	sub    %esi,%ebx
  8028f0:	19 fa                	sbb    %edi,%edx
  8028f2:	89 d0                	mov    %edx,%eax
  8028f4:	d3 e0                	shl    %cl,%eax
  8028f6:	89 e9                	mov    %ebp,%ecx
  8028f8:	d3 eb                	shr    %cl,%ebx
  8028fa:	d3 ea                	shr    %cl,%edx
  8028fc:	09 d8                	or     %ebx,%eax
  8028fe:	83 c4 1c             	add    $0x1c,%esp
  802901:	5b                   	pop    %ebx
  802902:	5e                   	pop    %esi
  802903:	5f                   	pop    %edi
  802904:	5d                   	pop    %ebp
  802905:	c3                   	ret    
  802906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80290d:	8d 76 00             	lea    0x0(%esi),%esi
  802910:	29 fe                	sub    %edi,%esi
  802912:	19 c3                	sbb    %eax,%ebx
  802914:	89 f2                	mov    %esi,%edx
  802916:	89 d9                	mov    %ebx,%ecx
  802918:	e9 1d ff ff ff       	jmp    80283a <__umoddi3+0x6a>
