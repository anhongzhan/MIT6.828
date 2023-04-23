
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 a3 02 00 00       	call   8002d4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
	envid_t ns_envid = sys_getenvid();
  80003c:	e8 e8 0d 00 00       	call   800e29 <sys_getenvid>
  800041:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  800043:	c7 05 00 40 80 00 80 	movl   $0x802a80,0x804000
  80004a:	2a 80 00 

	output_envid = fork();
  80004d:	e8 bd 11 00 00       	call   80120f <fork>
  800052:	a3 00 50 80 00       	mov    %eax,0x805000
	if (output_envid < 0)
  800057:	85 c0                	test   %eax,%eax
  800059:	0f 88 93 00 00 00    	js     8000f2 <umain+0xbf>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80005f:	bb 00 00 00 00       	mov    $0x0,%ebx
	else if (output_envid == 0) {
  800064:	0f 84 9c 00 00 00    	je     800106 <umain+0xd3>
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80006a:	83 ec 04             	sub    $0x4,%esp
  80006d:	6a 07                	push   $0x7
  80006f:	68 00 b0 fe 0f       	push   $0xffeb000
  800074:	6a 00                	push   $0x0
  800076:	e8 f4 0d 00 00       	call   800e6f <sys_page_alloc>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	85 c0                	test   %eax,%eax
  800080:	0f 88 8e 00 00 00    	js     800114 <umain+0xe1>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800086:	53                   	push   %ebx
  800087:	68 bd 2a 80 00       	push   $0x802abd
  80008c:	68 fc 0f 00 00       	push   $0xffc
  800091:	68 04 b0 fe 0f       	push   $0xffeb004
  800096:	e8 31 09 00 00       	call   8009cc <snprintf>
  80009b:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8000a0:	83 c4 08             	add    $0x8,%esp
  8000a3:	53                   	push   %ebx
  8000a4:	68 c9 2a 80 00       	push   $0x802ac9
  8000a9:	e8 75 03 00 00       	call   800423 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000ae:	6a 07                	push   $0x7
  8000b0:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b5:	6a 0b                	push   $0xb
  8000b7:	ff 35 00 50 80 00    	pushl  0x805000
  8000bd:	e8 eb 13 00 00       	call   8014ad <ipc_send>
		sys_page_unmap(0, pkt);
  8000c2:	83 c4 18             	add    $0x18,%esp
  8000c5:	68 00 b0 fe 0f       	push   $0xffeb000
  8000ca:	6a 00                	push   $0x0
  8000cc:	e8 2b 0e 00 00       	call   800efc <sys_page_unmap>
	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000d1:	83 c3 01             	add    $0x1,%ebx
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	83 fb 0a             	cmp    $0xa,%ebx
  8000da:	75 8e                	jne    80006a <umain+0x37>
  8000dc:	bb 14 00 00 00       	mov    $0x14,%ebx
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  8000e1:	e8 66 0d 00 00       	call   800e4c <sys_yield>
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  8000e6:	83 eb 01             	sub    $0x1,%ebx
  8000e9:	75 f6                	jne    8000e1 <umain+0xae>
}
  8000eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5d                   	pop    %ebp
  8000f1:	c3                   	ret    
		panic("error forking");
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 8b 2a 80 00       	push   $0x802a8b
  8000fa:	6a 16                	push   $0x16
  8000fc:	68 99 2a 80 00       	push   $0x802a99
  800101:	e8 36 02 00 00       	call   80033c <_panic>
		output(ns_envid);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	56                   	push   %esi
  80010a:	e8 5f 01 00 00       	call   80026e <output>
		return;
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	eb d7                	jmp    8000eb <umain+0xb8>
			panic("sys_page_alloc: %e", r);
  800114:	50                   	push   %eax
  800115:	68 aa 2a 80 00       	push   $0x802aaa
  80011a:	6a 1e                	push   $0x1e
  80011c:	68 99 2a 80 00       	push   $0x802a99
  800121:	e8 16 02 00 00       	call   80033c <_panic>

00800126 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800126:	f3 0f 1e fb          	endbr32 
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	57                   	push   %edi
  80012e:	56                   	push   %esi
  80012f:	53                   	push   %ebx
  800130:	83 ec 1c             	sub    $0x1c,%esp
  800133:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  800136:	e8 45 0f 00 00       	call   801080 <sys_time_msec>
  80013b:	03 45 0c             	add    0xc(%ebp),%eax
  80013e:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  800140:	c7 05 00 40 80 00 e1 	movl   $0x802ae1,0x804000
  800147:	2a 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80014a:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  80014d:	eb 33                	jmp    800182 <timer+0x5c>
		if (r < 0)
  80014f:	85 c0                	test   %eax,%eax
  800151:	78 45                	js     800198 <timer+0x72>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  800153:	6a 00                	push   $0x0
  800155:	6a 00                	push   $0x0
  800157:	6a 0c                	push   $0xc
  800159:	56                   	push   %esi
  80015a:	e8 4e 13 00 00       	call   8014ad <ipc_send>
  80015f:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	6a 00                	push   $0x0
  800167:	6a 00                	push   $0x0
  800169:	57                   	push   %edi
  80016a:	e8 b9 12 00 00       	call   801428 <ipc_recv>
  80016f:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  800171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800174:	83 c4 10             	add    $0x10,%esp
  800177:	39 f0                	cmp    %esi,%eax
  800179:	75 2f                	jne    8001aa <timer+0x84>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  80017b:	e8 00 0f 00 00       	call   801080 <sys_time_msec>
  800180:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800182:	e8 f9 0e 00 00       	call   801080 <sys_time_msec>
  800187:	89 c2                	mov    %eax,%edx
  800189:	85 c0                	test   %eax,%eax
  80018b:	78 c2                	js     80014f <timer+0x29>
  80018d:	39 d8                	cmp    %ebx,%eax
  80018f:	73 be                	jae    80014f <timer+0x29>
			sys_yield();
  800191:	e8 b6 0c 00 00       	call   800e4c <sys_yield>
  800196:	eb ea                	jmp    800182 <timer+0x5c>
			panic("sys_time_msec: %e", r);
  800198:	52                   	push   %edx
  800199:	68 ea 2a 80 00       	push   $0x802aea
  80019e:	6a 0f                	push   $0xf
  8001a0:	68 fc 2a 80 00       	push   $0x802afc
  8001a5:	e8 92 01 00 00       	call   80033c <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	50                   	push   %eax
  8001ae:	68 08 2b 80 00       	push   $0x802b08
  8001b3:	e8 6b 02 00 00       	call   800423 <cprintf>
				continue;
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	eb a5                	jmp    800162 <timer+0x3c>

008001bd <sleep>:
extern union Nsipc nsipcbuf;


void
sleep(int msec)
{
  8001bd:	f3 0f 1e fb          	endbr32 
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 04             	sub    $0x4,%esp
       unsigned now = sys_time_msec();
  8001c8:	e8 b3 0e 00 00       	call   801080 <sys_time_msec>
       unsigned end = now + msec;
  8001cd:	89 c3                	mov    %eax,%ebx
  8001cf:	03 5d 08             	add    0x8(%ebp),%ebx

       if ((int)now < 0 && (int)now > -MAXERROR)
  8001d2:	85 c0                	test   %eax,%eax
  8001d4:	79 1c                	jns    8001f2 <sleep+0x35>
  8001d6:	83 f8 f1             	cmp    $0xfffffff1,%eax
  8001d9:	7c 17                	jl     8001f2 <sleep+0x35>
               panic("sys_time_msec: %e", (int)now);
  8001db:	50                   	push   %eax
  8001dc:	68 ea 2a 80 00       	push   $0x802aea
  8001e1:	6a 0e                	push   $0xe
  8001e3:	68 43 2b 80 00       	push   $0x802b43
  8001e8:	e8 4f 01 00 00       	call   80033c <_panic>

       while (sys_time_msec() < end)
               sys_yield();
  8001ed:	e8 5a 0c 00 00       	call   800e4c <sys_yield>
       while (sys_time_msec() < end)
  8001f2:	e8 89 0e 00 00       	call   801080 <sys_time_msec>
  8001f7:	39 d8                	cmp    %ebx,%eax
  8001f9:	72 f2                	jb     8001ed <sleep+0x30>
}
  8001fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001fe:	c9                   	leave  
  8001ff:	c3                   	ret    

00800200 <input>:

void
input(envid_t ns_envid)
{
  800200:	f3 0f 1e fb          	endbr32 
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	81 ec 0c 06 00 00    	sub    $0x60c,%esp
  800210:	8b 7d 08             	mov    0x8(%ebp),%edi
	binaryname = "ns_input";
  800213:	c7 05 00 40 80 00 4f 	movl   $0x802b4f,0x804000
  80021a:	2b 80 00 
	// another packet in to the same physical page.

	size_t len;
	char buf[RX_PKT_SIZE];
	while (1) {
		if (sys_pkt_recv(buf, &len) < 0) {
  80021d:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800220:	8d 9d f6 f9 ff ff    	lea    -0x60a(%ebp),%ebx
  800226:	83 ec 08             	sub    $0x8,%esp
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	e8 b9 0e 00 00       	call   8010e9 <sys_pkt_recv>
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	85 c0                	test   %eax,%eax
  800235:	78 ef                	js     800226 <input+0x26>
			continue;
		}

		memcpy(nsipcbuf.pkt.jp_data, buf, len);
  800237:	83 ec 04             	sub    $0x4,%esp
  80023a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023d:	53                   	push   %ebx
  80023e:	68 04 70 80 00       	push   $0x807004
  800243:	e8 01 0a 00 00       	call   800c49 <memcpy>
		nsipcbuf.pkt.jp_len = len;
  800248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024b:	a3 00 70 80 00       	mov    %eax,0x807000
		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_U|PTE_W);
  800250:	6a 07                	push   $0x7
  800252:	68 00 70 80 00       	push   $0x807000
  800257:	6a 0a                	push   $0xa
  800259:	57                   	push   %edi
  80025a:	e8 4e 12 00 00       	call   8014ad <ipc_send>
		sleep(50);
  80025f:	83 c4 14             	add    $0x14,%esp
  800262:	6a 32                	push   $0x32
  800264:	e8 54 ff ff ff       	call   8001bd <sleep>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	eb b8                	jmp    800226 <input+0x26>

0080026e <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  80026e:	f3 0f 1e fb          	endbr32 
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 10             	sub    $0x10,%esp
	binaryname = "ns_output";
  80027a:	c7 05 00 40 80 00 58 	movl   $0x802b58,0x804000
  800281:	2b 80 00 
	uint32_t whom;
	int perm;
	int32_t req;

	while (1) {
		req = ipc_recv((envid_t *)&whom, &nsipcbuf,  &perm);     //接收核心网络进程发来的请求
  800284:	8d 75 f0             	lea    -0x10(%ebp),%esi
  800287:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80028a:	eb 1f                	jmp    8002ab <output+0x3d>
			continue;
		}

    	struct jif_pkt *pkt = &(nsipcbuf.pkt);
    	while (sys_pkt_send(pkt->jp_data, pkt->jp_len) < 0) {        //通过系统调用发送数据包
       		sys_yield();
  80028c:	e8 bb 0b 00 00       	call   800e4c <sys_yield>
    	while (sys_pkt_send(pkt->jp_data, pkt->jp_len) < 0) {        //通过系统调用发送数据包
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	ff 35 00 70 80 00    	pushl  0x807000
  80029a:	68 04 70 80 00       	push   $0x807004
  80029f:	e8 ff 0d 00 00       	call   8010a3 <sys_pkt_send>
  8002a4:	83 c4 10             	add    $0x10,%esp
  8002a7:	85 c0                	test   %eax,%eax
  8002a9:	78 e1                	js     80028c <output+0x1e>
		req = ipc_recv((envid_t *)&whom, &nsipcbuf,  &perm);     //接收核心网络进程发来的请求
  8002ab:	83 ec 04             	sub    $0x4,%esp
  8002ae:	56                   	push   %esi
  8002af:	68 00 70 80 00       	push   $0x807000
  8002b4:	53                   	push   %ebx
  8002b5:	e8 6e 11 00 00       	call   801428 <ipc_recv>
		if (req != NSREQ_OUTPUT) {
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	83 f8 0b             	cmp    $0xb,%eax
  8002c0:	74 cf                	je     800291 <output+0x23>
			cprintf("not a nsreq output\n");
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	68 62 2b 80 00       	push   $0x802b62
  8002ca:	e8 54 01 00 00       	call   800423 <cprintf>
			continue;
  8002cf:	83 c4 10             	add    $0x10,%esp
  8002d2:	eb d7                	jmp    8002ab <output+0x3d>

008002d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d4:	f3 0f 1e fb          	endbr32 
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
  8002dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e3:	e8 41 0b 00 00       	call   800e29 <sys_getenvid>
  8002e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ed:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f5:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fa:	85 db                	test   %ebx,%ebx
  8002fc:	7e 07                	jle    800305 <libmain+0x31>
		binaryname = argv[0];
  8002fe:	8b 06                	mov    (%esi),%eax
  800300:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	56                   	push   %esi
  800309:	53                   	push   %ebx
  80030a:	e8 24 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80030f:	e8 0a 00 00 00       	call   80031e <exit>
}
  800314:	83 c4 10             	add    $0x10,%esp
  800317:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80031a:	5b                   	pop    %ebx
  80031b:	5e                   	pop    %esi
  80031c:	5d                   	pop    %ebp
  80031d:	c3                   	ret    

0080031e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80031e:	f3 0f 1e fb          	endbr32 
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800328:	e8 09 14 00 00       	call   801736 <close_all>
	sys_env_destroy(0);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	6a 00                	push   $0x0
  800332:	e8 ad 0a 00 00       	call   800de4 <sys_env_destroy>
}
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	c9                   	leave  
  80033b:	c3                   	ret    

0080033c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033c:	f3 0f 1e fb          	endbr32 
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	56                   	push   %esi
  800344:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800345:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800348:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80034e:	e8 d6 0a 00 00       	call   800e29 <sys_getenvid>
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 0c             	pushl  0xc(%ebp)
  800359:	ff 75 08             	pushl  0x8(%ebp)
  80035c:	56                   	push   %esi
  80035d:	50                   	push   %eax
  80035e:	68 80 2b 80 00       	push   $0x802b80
  800363:	e8 bb 00 00 00       	call   800423 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800368:	83 c4 18             	add    $0x18,%esp
  80036b:	53                   	push   %ebx
  80036c:	ff 75 10             	pushl  0x10(%ebp)
  80036f:	e8 5a 00 00 00       	call   8003ce <vcprintf>
	cprintf("\n");
  800374:	c7 04 24 61 2f 80 00 	movl   $0x802f61,(%esp)
  80037b:	e8 a3 00 00 00       	call   800423 <cprintf>
  800380:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800383:	cc                   	int3   
  800384:	eb fd                	jmp    800383 <_panic+0x47>

00800386 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800386:	f3 0f 1e fb          	endbr32 
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	53                   	push   %ebx
  80038e:	83 ec 04             	sub    $0x4,%esp
  800391:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800394:	8b 13                	mov    (%ebx),%edx
  800396:	8d 42 01             	lea    0x1(%edx),%eax
  800399:	89 03                	mov    %eax,(%ebx)
  80039b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80039e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a7:	74 09                	je     8003b2 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b0:	c9                   	leave  
  8003b1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	68 ff 00 00 00       	push   $0xff
  8003ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8003bd:	50                   	push   %eax
  8003be:	e8 dc 09 00 00       	call   800d9f <sys_cputs>
		b->idx = 0;
  8003c3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	eb db                	jmp    8003a9 <putch+0x23>

008003ce <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003ce:	f3 0f 1e fb          	endbr32 
  8003d2:	55                   	push   %ebp
  8003d3:	89 e5                	mov    %esp,%ebp
  8003d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e2:	00 00 00 
	b.cnt = 0;
  8003e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003ef:	ff 75 0c             	pushl  0xc(%ebp)
  8003f2:	ff 75 08             	pushl  0x8(%ebp)
  8003f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003fb:	50                   	push   %eax
  8003fc:	68 86 03 80 00       	push   $0x800386
  800401:	e8 20 01 00 00       	call   800526 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80040f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800415:	50                   	push   %eax
  800416:	e8 84 09 00 00       	call   800d9f <sys_cputs>

	return b.cnt;
}
  80041b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800421:	c9                   	leave  
  800422:	c3                   	ret    

00800423 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800423:	f3 0f 1e fb          	endbr32 
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80042d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800430:	50                   	push   %eax
  800431:	ff 75 08             	pushl  0x8(%ebp)
  800434:	e8 95 ff ff ff       	call   8003ce <vcprintf>
	va_end(ap);

	return cnt;
}
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	57                   	push   %edi
  80043f:	56                   	push   %esi
  800440:	53                   	push   %ebx
  800441:	83 ec 1c             	sub    $0x1c,%esp
  800444:	89 c7                	mov    %eax,%edi
  800446:	89 d6                	mov    %edx,%esi
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044e:	89 d1                	mov    %edx,%ecx
  800450:	89 c2                	mov    %eax,%edx
  800452:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800455:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800458:	8b 45 10             	mov    0x10(%ebp),%eax
  80045b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80045e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800461:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800468:	39 c2                	cmp    %eax,%edx
  80046a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80046d:	72 3e                	jb     8004ad <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	ff 75 18             	pushl  0x18(%ebp)
  800475:	83 eb 01             	sub    $0x1,%ebx
  800478:	53                   	push   %ebx
  800479:	50                   	push   %eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800480:	ff 75 e0             	pushl  -0x20(%ebp)
  800483:	ff 75 dc             	pushl  -0x24(%ebp)
  800486:	ff 75 d8             	pushl  -0x28(%ebp)
  800489:	e8 92 23 00 00       	call   802820 <__udivdi3>
  80048e:	83 c4 18             	add    $0x18,%esp
  800491:	52                   	push   %edx
  800492:	50                   	push   %eax
  800493:	89 f2                	mov    %esi,%edx
  800495:	89 f8                	mov    %edi,%eax
  800497:	e8 9f ff ff ff       	call   80043b <printnum>
  80049c:	83 c4 20             	add    $0x20,%esp
  80049f:	eb 13                	jmp    8004b4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	56                   	push   %esi
  8004a5:	ff 75 18             	pushl  0x18(%ebp)
  8004a8:	ff d7                	call   *%edi
  8004aa:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004ad:	83 eb 01             	sub    $0x1,%ebx
  8004b0:	85 db                	test   %ebx,%ebx
  8004b2:	7f ed                	jg     8004a1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	56                   	push   %esi
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004be:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c7:	e8 64 24 00 00       	call   802930 <__umoddi3>
  8004cc:	83 c4 14             	add    $0x14,%esp
  8004cf:	0f be 80 a3 2b 80 00 	movsbl 0x802ba3(%eax),%eax
  8004d6:	50                   	push   %eax
  8004d7:	ff d7                	call   *%edi
}
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004df:	5b                   	pop    %ebx
  8004e0:	5e                   	pop    %esi
  8004e1:	5f                   	pop    %edi
  8004e2:	5d                   	pop    %ebp
  8004e3:	c3                   	ret    

008004e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e4:	f3 0f 1e fb          	endbr32 
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004ee:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f2:	8b 10                	mov    (%eax),%edx
  8004f4:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f7:	73 0a                	jae    800503 <sprintputch+0x1f>
		*b->buf++ = ch;
  8004f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004fc:	89 08                	mov    %ecx,(%eax)
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	88 02                	mov    %al,(%edx)
}
  800503:	5d                   	pop    %ebp
  800504:	c3                   	ret    

00800505 <printfmt>:
{
  800505:	f3 0f 1e fb          	endbr32 
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80050f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800512:	50                   	push   %eax
  800513:	ff 75 10             	pushl  0x10(%ebp)
  800516:	ff 75 0c             	pushl  0xc(%ebp)
  800519:	ff 75 08             	pushl  0x8(%ebp)
  80051c:	e8 05 00 00 00       	call   800526 <vprintfmt>
}
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	c9                   	leave  
  800525:	c3                   	ret    

00800526 <vprintfmt>:
{
  800526:	f3 0f 1e fb          	endbr32 
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	57                   	push   %edi
  80052e:	56                   	push   %esi
  80052f:	53                   	push   %ebx
  800530:	83 ec 3c             	sub    $0x3c,%esp
  800533:	8b 75 08             	mov    0x8(%ebp),%esi
  800536:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800539:	8b 7d 10             	mov    0x10(%ebp),%edi
  80053c:	e9 8e 03 00 00       	jmp    8008cf <vprintfmt+0x3a9>
		padc = ' ';
  800541:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800545:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80054c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800553:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80055f:	8d 47 01             	lea    0x1(%edi),%eax
  800562:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800565:	0f b6 17             	movzbl (%edi),%edx
  800568:	8d 42 dd             	lea    -0x23(%edx),%eax
  80056b:	3c 55                	cmp    $0x55,%al
  80056d:	0f 87 df 03 00 00    	ja     800952 <vprintfmt+0x42c>
  800573:	0f b6 c0             	movzbl %al,%eax
  800576:	3e ff 24 85 e0 2c 80 	notrack jmp *0x802ce0(,%eax,4)
  80057d:	00 
  80057e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800581:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800585:	eb d8                	jmp    80055f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800587:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80058a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80058e:	eb cf                	jmp    80055f <vprintfmt+0x39>
  800590:	0f b6 d2             	movzbl %dl,%edx
  800593:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800596:	b8 00 00 00 00       	mov    $0x0,%eax
  80059b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80059e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005ab:	83 f9 09             	cmp    $0x9,%ecx
  8005ae:	77 55                	ja     800605 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005b0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b3:	eb e9                	jmp    80059e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8d 40 04             	lea    0x4(%eax),%eax
  8005c3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005cd:	79 90                	jns    80055f <vprintfmt+0x39>
				width = precision, precision = -1;
  8005cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005dc:	eb 81                	jmp    80055f <vprintfmt+0x39>
  8005de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e1:	85 c0                	test   %eax,%eax
  8005e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e8:	0f 49 d0             	cmovns %eax,%edx
  8005eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f1:	e9 69 ff ff ff       	jmp    80055f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800600:	e9 5a ff ff ff       	jmp    80055f <vprintfmt+0x39>
  800605:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800608:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060b:	eb bc                	jmp    8005c9 <vprintfmt+0xa3>
			lflag++;
  80060d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800613:	e9 47 ff ff ff       	jmp    80055f <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 78 04             	lea    0x4(%eax),%edi
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	53                   	push   %ebx
  800622:	ff 30                	pushl  (%eax)
  800624:	ff d6                	call   *%esi
			break;
  800626:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800629:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80062c:	e9 9b 02 00 00       	jmp    8008cc <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8d 78 04             	lea    0x4(%eax),%edi
  800637:	8b 00                	mov    (%eax),%eax
  800639:	99                   	cltd   
  80063a:	31 d0                	xor    %edx,%eax
  80063c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80063e:	83 f8 0f             	cmp    $0xf,%eax
  800641:	7f 23                	jg     800666 <vprintfmt+0x140>
  800643:	8b 14 85 40 2e 80 00 	mov    0x802e40(,%eax,4),%edx
  80064a:	85 d2                	test   %edx,%edx
  80064c:	74 18                	je     800666 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80064e:	52                   	push   %edx
  80064f:	68 19 30 80 00       	push   $0x803019
  800654:	53                   	push   %ebx
  800655:	56                   	push   %esi
  800656:	e8 aa fe ff ff       	call   800505 <printfmt>
  80065b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80065e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800661:	e9 66 02 00 00       	jmp    8008cc <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800666:	50                   	push   %eax
  800667:	68 bb 2b 80 00       	push   $0x802bbb
  80066c:	53                   	push   %ebx
  80066d:	56                   	push   %esi
  80066e:	e8 92 fe ff ff       	call   800505 <printfmt>
  800673:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800676:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800679:	e9 4e 02 00 00       	jmp    8008cc <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	83 c0 04             	add    $0x4,%eax
  800684:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80068c:	85 d2                	test   %edx,%edx
  80068e:	b8 b4 2b 80 00       	mov    $0x802bb4,%eax
  800693:	0f 45 c2             	cmovne %edx,%eax
  800696:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800699:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069d:	7e 06                	jle    8006a5 <vprintfmt+0x17f>
  80069f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a3:	75 0d                	jne    8006b2 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006a8:	89 c7                	mov    %eax,%edi
  8006aa:	03 45 e0             	add    -0x20(%ebp),%eax
  8006ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b0:	eb 55                	jmp    800707 <vprintfmt+0x1e1>
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b8:	ff 75 cc             	pushl  -0x34(%ebp)
  8006bb:	e8 46 03 00 00       	call   800a06 <strnlen>
  8006c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c3:	29 c2                	sub    %eax,%edx
  8006c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006cd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	85 ff                	test   %edi,%edi
  8006d6:	7e 11                	jle    8006e9 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8006df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e1:	83 ef 01             	sub    $0x1,%edi
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	eb eb                	jmp    8006d4 <vprintfmt+0x1ae>
  8006e9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ec:	85 d2                	test   %edx,%edx
  8006ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f3:	0f 49 c2             	cmovns %edx,%eax
  8006f6:	29 c2                	sub    %eax,%edx
  8006f8:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006fb:	eb a8                	jmp    8006a5 <vprintfmt+0x17f>
					putch(ch, putdat);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	53                   	push   %ebx
  800701:	52                   	push   %edx
  800702:	ff d6                	call   *%esi
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80070a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070c:	83 c7 01             	add    $0x1,%edi
  80070f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800713:	0f be d0             	movsbl %al,%edx
  800716:	85 d2                	test   %edx,%edx
  800718:	74 4b                	je     800765 <vprintfmt+0x23f>
  80071a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80071e:	78 06                	js     800726 <vprintfmt+0x200>
  800720:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800724:	78 1e                	js     800744 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800726:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80072a:	74 d1                	je     8006fd <vprintfmt+0x1d7>
  80072c:	0f be c0             	movsbl %al,%eax
  80072f:	83 e8 20             	sub    $0x20,%eax
  800732:	83 f8 5e             	cmp    $0x5e,%eax
  800735:	76 c6                	jbe    8006fd <vprintfmt+0x1d7>
					putch('?', putdat);
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	53                   	push   %ebx
  80073b:	6a 3f                	push   $0x3f
  80073d:	ff d6                	call   *%esi
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	eb c3                	jmp    800707 <vprintfmt+0x1e1>
  800744:	89 cf                	mov    %ecx,%edi
  800746:	eb 0e                	jmp    800756 <vprintfmt+0x230>
				putch(' ', putdat);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	53                   	push   %ebx
  80074c:	6a 20                	push   $0x20
  80074e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800750:	83 ef 01             	sub    $0x1,%edi
  800753:	83 c4 10             	add    $0x10,%esp
  800756:	85 ff                	test   %edi,%edi
  800758:	7f ee                	jg     800748 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80075a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
  800760:	e9 67 01 00 00       	jmp    8008cc <vprintfmt+0x3a6>
  800765:	89 cf                	mov    %ecx,%edi
  800767:	eb ed                	jmp    800756 <vprintfmt+0x230>
	if (lflag >= 2)
  800769:	83 f9 01             	cmp    $0x1,%ecx
  80076c:	7f 1b                	jg     800789 <vprintfmt+0x263>
	else if (lflag)
  80076e:	85 c9                	test   %ecx,%ecx
  800770:	74 63                	je     8007d5 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077a:	99                   	cltd   
  80077b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8d 40 04             	lea    0x4(%eax),%eax
  800784:	89 45 14             	mov    %eax,0x14(%ebp)
  800787:	eb 17                	jmp    8007a0 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8b 50 04             	mov    0x4(%eax),%edx
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800794:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 40 08             	lea    0x8(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007a0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007a6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007ab:	85 c9                	test   %ecx,%ecx
  8007ad:	0f 89 ff 00 00 00    	jns    8008b2 <vprintfmt+0x38c>
				putch('-', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	6a 2d                	push   $0x2d
  8007b9:	ff d6                	call   *%esi
				num = -(long long) num;
  8007bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007be:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007c1:	f7 da                	neg    %edx
  8007c3:	83 d1 00             	adc    $0x0,%ecx
  8007c6:	f7 d9                	neg    %ecx
  8007c8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d0:	e9 dd 00 00 00       	jmp    8008b2 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dd:	99                   	cltd   
  8007de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8d 40 04             	lea    0x4(%eax),%eax
  8007e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ea:	eb b4                	jmp    8007a0 <vprintfmt+0x27a>
	if (lflag >= 2)
  8007ec:	83 f9 01             	cmp    $0x1,%ecx
  8007ef:	7f 1e                	jg     80080f <vprintfmt+0x2e9>
	else if (lflag)
  8007f1:	85 c9                	test   %ecx,%ecx
  8007f3:	74 32                	je     800827 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8b 10                	mov    (%eax),%edx
  8007fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ff:	8d 40 04             	lea    0x4(%eax),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800805:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80080a:	e9 a3 00 00 00       	jmp    8008b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8b 10                	mov    (%eax),%edx
  800814:	8b 48 04             	mov    0x4(%eax),%ecx
  800817:	8d 40 08             	lea    0x8(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800822:	e9 8b 00 00 00       	jmp    8008b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8b 10                	mov    (%eax),%edx
  80082c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800831:	8d 40 04             	lea    0x4(%eax),%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800837:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80083c:	eb 74                	jmp    8008b2 <vprintfmt+0x38c>
	if (lflag >= 2)
  80083e:	83 f9 01             	cmp    $0x1,%ecx
  800841:	7f 1b                	jg     80085e <vprintfmt+0x338>
	else if (lflag)
  800843:	85 c9                	test   %ecx,%ecx
  800845:	74 2c                	je     800873 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	8b 10                	mov    (%eax),%edx
  80084c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800851:	8d 40 04             	lea    0x4(%eax),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800857:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80085c:	eb 54                	jmp    8008b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8b 10                	mov    (%eax),%edx
  800863:	8b 48 04             	mov    0x4(%eax),%ecx
  800866:	8d 40 08             	lea    0x8(%eax),%eax
  800869:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80086c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800871:	eb 3f                	jmp    8008b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8b 10                	mov    (%eax),%edx
  800878:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087d:	8d 40 04             	lea    0x4(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800883:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800888:	eb 28                	jmp    8008b2 <vprintfmt+0x38c>
			putch('0', putdat);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	53                   	push   %ebx
  80088e:	6a 30                	push   $0x30
  800890:	ff d6                	call   *%esi
			putch('x', putdat);
  800892:	83 c4 08             	add    $0x8,%esp
  800895:	53                   	push   %ebx
  800896:	6a 78                	push   $0x78
  800898:	ff d6                	call   *%esi
			num = (unsigned long long)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8b 10                	mov    (%eax),%edx
  80089f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008a4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a7:	8d 40 04             	lea    0x4(%eax),%eax
  8008aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ad:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008b9:	57                   	push   %edi
  8008ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8008bd:	50                   	push   %eax
  8008be:	51                   	push   %ecx
  8008bf:	52                   	push   %edx
  8008c0:	89 da                	mov    %ebx,%edx
  8008c2:	89 f0                	mov    %esi,%eax
  8008c4:	e8 72 fb ff ff       	call   80043b <printnum>
			break;
  8008c9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cf:	83 c7 01             	add    $0x1,%edi
  8008d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d6:	83 f8 25             	cmp    $0x25,%eax
  8008d9:	0f 84 62 fc ff ff    	je     800541 <vprintfmt+0x1b>
			if (ch == '\0')
  8008df:	85 c0                	test   %eax,%eax
  8008e1:	0f 84 8b 00 00 00    	je     800972 <vprintfmt+0x44c>
			putch(ch, putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	53                   	push   %ebx
  8008eb:	50                   	push   %eax
  8008ec:	ff d6                	call   *%esi
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	eb dc                	jmp    8008cf <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008f3:	83 f9 01             	cmp    $0x1,%ecx
  8008f6:	7f 1b                	jg     800913 <vprintfmt+0x3ed>
	else if (lflag)
  8008f8:	85 c9                	test   %ecx,%ecx
  8008fa:	74 2c                	je     800928 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	8b 10                	mov    (%eax),%edx
  800901:	b9 00 00 00 00       	mov    $0x0,%ecx
  800906:	8d 40 04             	lea    0x4(%eax),%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800911:	eb 9f                	jmp    8008b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8b 10                	mov    (%eax),%edx
  800918:	8b 48 04             	mov    0x4(%eax),%ecx
  80091b:	8d 40 08             	lea    0x8(%eax),%eax
  80091e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800921:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800926:	eb 8a                	jmp    8008b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8b 10                	mov    (%eax),%edx
  80092d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800932:	8d 40 04             	lea    0x4(%eax),%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800938:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80093d:	e9 70 ff ff ff       	jmp    8008b2 <vprintfmt+0x38c>
			putch(ch, putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	53                   	push   %ebx
  800946:	6a 25                	push   $0x25
  800948:	ff d6                	call   *%esi
			break;
  80094a:	83 c4 10             	add    $0x10,%esp
  80094d:	e9 7a ff ff ff       	jmp    8008cc <vprintfmt+0x3a6>
			putch('%', putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	53                   	push   %ebx
  800956:	6a 25                	push   $0x25
  800958:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80095a:	83 c4 10             	add    $0x10,%esp
  80095d:	89 f8                	mov    %edi,%eax
  80095f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800963:	74 05                	je     80096a <vprintfmt+0x444>
  800965:	83 e8 01             	sub    $0x1,%eax
  800968:	eb f5                	jmp    80095f <vprintfmt+0x439>
  80096a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096d:	e9 5a ff ff ff       	jmp    8008cc <vprintfmt+0x3a6>
}
  800972:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800975:	5b                   	pop    %ebx
  800976:	5e                   	pop    %esi
  800977:	5f                   	pop    %edi
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097a:	f3 0f 1e fb          	endbr32 
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 18             	sub    $0x18,%esp
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80098d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800991:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800994:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099b:	85 c0                	test   %eax,%eax
  80099d:	74 26                	je     8009c5 <vsnprintf+0x4b>
  80099f:	85 d2                	test   %edx,%edx
  8009a1:	7e 22                	jle    8009c5 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a3:	ff 75 14             	pushl  0x14(%ebp)
  8009a6:	ff 75 10             	pushl  0x10(%ebp)
  8009a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ac:	50                   	push   %eax
  8009ad:	68 e4 04 80 00       	push   $0x8004e4
  8009b2:	e8 6f fb ff ff       	call   800526 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c0:	83 c4 10             	add    $0x10,%esp
}
  8009c3:	c9                   	leave  
  8009c4:	c3                   	ret    
		return -E_INVAL;
  8009c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009ca:	eb f7                	jmp    8009c3 <vsnprintf+0x49>

008009cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009d9:	50                   	push   %eax
  8009da:	ff 75 10             	pushl  0x10(%ebp)
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	ff 75 08             	pushl  0x8(%ebp)
  8009e3:	e8 92 ff ff ff       	call   80097a <vsnprintf>
	va_end(ap);

	return rc;
}
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ea:	f3 0f 1e fb          	endbr32 
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009fd:	74 05                	je     800a04 <strlen+0x1a>
		n++;
  8009ff:	83 c0 01             	add    $0x1,%eax
  800a02:	eb f5                	jmp    8009f9 <strlen+0xf>
	return n;
}
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a06:	f3 0f 1e fb          	endbr32 
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a10:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a13:	b8 00 00 00 00       	mov    $0x0,%eax
  800a18:	39 d0                	cmp    %edx,%eax
  800a1a:	74 0d                	je     800a29 <strnlen+0x23>
  800a1c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a20:	74 05                	je     800a27 <strnlen+0x21>
		n++;
  800a22:	83 c0 01             	add    $0x1,%eax
  800a25:	eb f1                	jmp    800a18 <strnlen+0x12>
  800a27:	89 c2                	mov    %eax,%edx
	return n;
}
  800a29:	89 d0                	mov    %edx,%eax
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2d:	f3 0f 1e fb          	endbr32 
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	53                   	push   %ebx
  800a35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a47:	83 c0 01             	add    $0x1,%eax
  800a4a:	84 d2                	test   %dl,%dl
  800a4c:	75 f2                	jne    800a40 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a4e:	89 c8                	mov    %ecx,%eax
  800a50:	5b                   	pop    %ebx
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a53:	f3 0f 1e fb          	endbr32 
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	53                   	push   %ebx
  800a5b:	83 ec 10             	sub    $0x10,%esp
  800a5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a61:	53                   	push   %ebx
  800a62:	e8 83 ff ff ff       	call   8009ea <strlen>
  800a67:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	01 d8                	add    %ebx,%eax
  800a6f:	50                   	push   %eax
  800a70:	e8 b8 ff ff ff       	call   800a2d <strcpy>
	return dst;
}
  800a75:	89 d8                	mov    %ebx,%eax
  800a77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a7c:	f3 0f 1e fb          	endbr32 
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	56                   	push   %esi
  800a84:	53                   	push   %ebx
  800a85:	8b 75 08             	mov    0x8(%ebp),%esi
  800a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8b:	89 f3                	mov    %esi,%ebx
  800a8d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a90:	89 f0                	mov    %esi,%eax
  800a92:	39 d8                	cmp    %ebx,%eax
  800a94:	74 11                	je     800aa7 <strncpy+0x2b>
		*dst++ = *src;
  800a96:	83 c0 01             	add    $0x1,%eax
  800a99:	0f b6 0a             	movzbl (%edx),%ecx
  800a9c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a9f:	80 f9 01             	cmp    $0x1,%cl
  800aa2:	83 da ff             	sbb    $0xffffffff,%edx
  800aa5:	eb eb                	jmp    800a92 <strncpy+0x16>
	}
	return ret;
}
  800aa7:	89 f0                	mov    %esi,%eax
  800aa9:	5b                   	pop    %ebx
  800aaa:	5e                   	pop    %esi
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aad:	f3 0f 1e fb          	endbr32 
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800abc:	8b 55 10             	mov    0x10(%ebp),%edx
  800abf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac1:	85 d2                	test   %edx,%edx
  800ac3:	74 21                	je     800ae6 <strlcpy+0x39>
  800ac5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ac9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800acb:	39 c2                	cmp    %eax,%edx
  800acd:	74 14                	je     800ae3 <strlcpy+0x36>
  800acf:	0f b6 19             	movzbl (%ecx),%ebx
  800ad2:	84 db                	test   %bl,%bl
  800ad4:	74 0b                	je     800ae1 <strlcpy+0x34>
			*dst++ = *src++;
  800ad6:	83 c1 01             	add    $0x1,%ecx
  800ad9:	83 c2 01             	add    $0x1,%edx
  800adc:	88 5a ff             	mov    %bl,-0x1(%edx)
  800adf:	eb ea                	jmp    800acb <strlcpy+0x1e>
  800ae1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae6:	29 f0                	sub    %esi,%eax
}
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aec:	f3 0f 1e fb          	endbr32 
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af9:	0f b6 01             	movzbl (%ecx),%eax
  800afc:	84 c0                	test   %al,%al
  800afe:	74 0c                	je     800b0c <strcmp+0x20>
  800b00:	3a 02                	cmp    (%edx),%al
  800b02:	75 08                	jne    800b0c <strcmp+0x20>
		p++, q++;
  800b04:	83 c1 01             	add    $0x1,%ecx
  800b07:	83 c2 01             	add    $0x1,%edx
  800b0a:	eb ed                	jmp    800af9 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0c:	0f b6 c0             	movzbl %al,%eax
  800b0f:	0f b6 12             	movzbl (%edx),%edx
  800b12:	29 d0                	sub    %edx,%eax
}
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b16:	f3 0f 1e fb          	endbr32 
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	53                   	push   %ebx
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b24:	89 c3                	mov    %eax,%ebx
  800b26:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b29:	eb 06                	jmp    800b31 <strncmp+0x1b>
		n--, p++, q++;
  800b2b:	83 c0 01             	add    $0x1,%eax
  800b2e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b31:	39 d8                	cmp    %ebx,%eax
  800b33:	74 16                	je     800b4b <strncmp+0x35>
  800b35:	0f b6 08             	movzbl (%eax),%ecx
  800b38:	84 c9                	test   %cl,%cl
  800b3a:	74 04                	je     800b40 <strncmp+0x2a>
  800b3c:	3a 0a                	cmp    (%edx),%cl
  800b3e:	74 eb                	je     800b2b <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b40:	0f b6 00             	movzbl (%eax),%eax
  800b43:	0f b6 12             	movzbl (%edx),%edx
  800b46:	29 d0                	sub    %edx,%eax
}
  800b48:	5b                   	pop    %ebx
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    
		return 0;
  800b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b50:	eb f6                	jmp    800b48 <strncmp+0x32>

00800b52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b52:	f3 0f 1e fb          	endbr32 
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b60:	0f b6 10             	movzbl (%eax),%edx
  800b63:	84 d2                	test   %dl,%dl
  800b65:	74 09                	je     800b70 <strchr+0x1e>
		if (*s == c)
  800b67:	38 ca                	cmp    %cl,%dl
  800b69:	74 0a                	je     800b75 <strchr+0x23>
	for (; *s; s++)
  800b6b:	83 c0 01             	add    $0x1,%eax
  800b6e:	eb f0                	jmp    800b60 <strchr+0xe>
			return (char *) s;
	return 0;
  800b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b77:	f3 0f 1e fb          	endbr32 
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b85:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b88:	38 ca                	cmp    %cl,%dl
  800b8a:	74 09                	je     800b95 <strfind+0x1e>
  800b8c:	84 d2                	test   %dl,%dl
  800b8e:	74 05                	je     800b95 <strfind+0x1e>
	for (; *s; s++)
  800b90:	83 c0 01             	add    $0x1,%eax
  800b93:	eb f0                	jmp    800b85 <strfind+0xe>
			break;
	return (char *) s;
}
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b97:	f3 0f 1e fb          	endbr32 
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	57                   	push   %edi
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
  800ba1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba7:	85 c9                	test   %ecx,%ecx
  800ba9:	74 31                	je     800bdc <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bab:	89 f8                	mov    %edi,%eax
  800bad:	09 c8                	or     %ecx,%eax
  800baf:	a8 03                	test   $0x3,%al
  800bb1:	75 23                	jne    800bd6 <memset+0x3f>
		c &= 0xFF;
  800bb3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb7:	89 d3                	mov    %edx,%ebx
  800bb9:	c1 e3 08             	shl    $0x8,%ebx
  800bbc:	89 d0                	mov    %edx,%eax
  800bbe:	c1 e0 18             	shl    $0x18,%eax
  800bc1:	89 d6                	mov    %edx,%esi
  800bc3:	c1 e6 10             	shl    $0x10,%esi
  800bc6:	09 f0                	or     %esi,%eax
  800bc8:	09 c2                	or     %eax,%edx
  800bca:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bcc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bcf:	89 d0                	mov    %edx,%eax
  800bd1:	fc                   	cld    
  800bd2:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd4:	eb 06                	jmp    800bdc <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd9:	fc                   	cld    
  800bda:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bdc:	89 f8                	mov    %edi,%eax
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be3:	f3 0f 1e fb          	endbr32 
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf5:	39 c6                	cmp    %eax,%esi
  800bf7:	73 32                	jae    800c2b <memmove+0x48>
  800bf9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bfc:	39 c2                	cmp    %eax,%edx
  800bfe:	76 2b                	jbe    800c2b <memmove+0x48>
		s += n;
		d += n;
  800c00:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c03:	89 fe                	mov    %edi,%esi
  800c05:	09 ce                	or     %ecx,%esi
  800c07:	09 d6                	or     %edx,%esi
  800c09:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c0f:	75 0e                	jne    800c1f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c11:	83 ef 04             	sub    $0x4,%edi
  800c14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c1a:	fd                   	std    
  800c1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1d:	eb 09                	jmp    800c28 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c1f:	83 ef 01             	sub    $0x1,%edi
  800c22:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c25:	fd                   	std    
  800c26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c28:	fc                   	cld    
  800c29:	eb 1a                	jmp    800c45 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2b:	89 c2                	mov    %eax,%edx
  800c2d:	09 ca                	or     %ecx,%edx
  800c2f:	09 f2                	or     %esi,%edx
  800c31:	f6 c2 03             	test   $0x3,%dl
  800c34:	75 0a                	jne    800c40 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c39:	89 c7                	mov    %eax,%edi
  800c3b:	fc                   	cld    
  800c3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3e:	eb 05                	jmp    800c45 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c40:	89 c7                	mov    %eax,%edi
  800c42:	fc                   	cld    
  800c43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c49:	f3 0f 1e fb          	endbr32 
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c53:	ff 75 10             	pushl  0x10(%ebp)
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	ff 75 08             	pushl  0x8(%ebp)
  800c5c:	e8 82 ff ff ff       	call   800be3 <memmove>
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c63:	f3 0f 1e fb          	endbr32 
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c72:	89 c6                	mov    %eax,%esi
  800c74:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c77:	39 f0                	cmp    %esi,%eax
  800c79:	74 1c                	je     800c97 <memcmp+0x34>
		if (*s1 != *s2)
  800c7b:	0f b6 08             	movzbl (%eax),%ecx
  800c7e:	0f b6 1a             	movzbl (%edx),%ebx
  800c81:	38 d9                	cmp    %bl,%cl
  800c83:	75 08                	jne    800c8d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c85:	83 c0 01             	add    $0x1,%eax
  800c88:	83 c2 01             	add    $0x1,%edx
  800c8b:	eb ea                	jmp    800c77 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c8d:	0f b6 c1             	movzbl %cl,%eax
  800c90:	0f b6 db             	movzbl %bl,%ebx
  800c93:	29 d8                	sub    %ebx,%eax
  800c95:	eb 05                	jmp    800c9c <memcmp+0x39>
	}

	return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca0:	f3 0f 1e fb          	endbr32 
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cad:	89 c2                	mov    %eax,%edx
  800caf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb2:	39 d0                	cmp    %edx,%eax
  800cb4:	73 09                	jae    800cbf <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb6:	38 08                	cmp    %cl,(%eax)
  800cb8:	74 05                	je     800cbf <memfind+0x1f>
	for (; s < ends; s++)
  800cba:	83 c0 01             	add    $0x1,%eax
  800cbd:	eb f3                	jmp    800cb2 <memfind+0x12>
			break;
	return (void *) s;
}
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc1:	f3 0f 1e fb          	endbr32 
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd1:	eb 03                	jmp    800cd6 <strtol+0x15>
		s++;
  800cd3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd6:	0f b6 01             	movzbl (%ecx),%eax
  800cd9:	3c 20                	cmp    $0x20,%al
  800cdb:	74 f6                	je     800cd3 <strtol+0x12>
  800cdd:	3c 09                	cmp    $0x9,%al
  800cdf:	74 f2                	je     800cd3 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ce1:	3c 2b                	cmp    $0x2b,%al
  800ce3:	74 2a                	je     800d0f <strtol+0x4e>
	int neg = 0;
  800ce5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cea:	3c 2d                	cmp    $0x2d,%al
  800cec:	74 2b                	je     800d19 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cee:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf4:	75 0f                	jne    800d05 <strtol+0x44>
  800cf6:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf9:	74 28                	je     800d23 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cfb:	85 db                	test   %ebx,%ebx
  800cfd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d02:	0f 44 d8             	cmove  %eax,%ebx
  800d05:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0d:	eb 46                	jmp    800d55 <strtol+0x94>
		s++;
  800d0f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d12:	bf 00 00 00 00       	mov    $0x0,%edi
  800d17:	eb d5                	jmp    800cee <strtol+0x2d>
		s++, neg = 1;
  800d19:	83 c1 01             	add    $0x1,%ecx
  800d1c:	bf 01 00 00 00       	mov    $0x1,%edi
  800d21:	eb cb                	jmp    800cee <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d23:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d27:	74 0e                	je     800d37 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d29:	85 db                	test   %ebx,%ebx
  800d2b:	75 d8                	jne    800d05 <strtol+0x44>
		s++, base = 8;
  800d2d:	83 c1 01             	add    $0x1,%ecx
  800d30:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d35:	eb ce                	jmp    800d05 <strtol+0x44>
		s += 2, base = 16;
  800d37:	83 c1 02             	add    $0x2,%ecx
  800d3a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d3f:	eb c4                	jmp    800d05 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d41:	0f be d2             	movsbl %dl,%edx
  800d44:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d47:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d4a:	7d 3a                	jge    800d86 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d4c:	83 c1 01             	add    $0x1,%ecx
  800d4f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d53:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d55:	0f b6 11             	movzbl (%ecx),%edx
  800d58:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d5b:	89 f3                	mov    %esi,%ebx
  800d5d:	80 fb 09             	cmp    $0x9,%bl
  800d60:	76 df                	jbe    800d41 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d62:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d65:	89 f3                	mov    %esi,%ebx
  800d67:	80 fb 19             	cmp    $0x19,%bl
  800d6a:	77 08                	ja     800d74 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d6c:	0f be d2             	movsbl %dl,%edx
  800d6f:	83 ea 57             	sub    $0x57,%edx
  800d72:	eb d3                	jmp    800d47 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d74:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d77:	89 f3                	mov    %esi,%ebx
  800d79:	80 fb 19             	cmp    $0x19,%bl
  800d7c:	77 08                	ja     800d86 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d7e:	0f be d2             	movsbl %dl,%edx
  800d81:	83 ea 37             	sub    $0x37,%edx
  800d84:	eb c1                	jmp    800d47 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8a:	74 05                	je     800d91 <strtol+0xd0>
		*endptr = (char *) s;
  800d8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d8f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d91:	89 c2                	mov    %eax,%edx
  800d93:	f7 da                	neg    %edx
  800d95:	85 ff                	test   %edi,%edi
  800d97:	0f 45 c2             	cmovne %edx,%eax
}
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d9f:	f3 0f 1e fb          	endbr32 
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dae:	8b 55 08             	mov    0x8(%ebp),%edx
  800db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db4:	89 c3                	mov    %eax,%ebx
  800db6:	89 c7                	mov    %eax,%edi
  800db8:	89 c6                	mov    %eax,%esi
  800dba:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc1:	f3 0f 1e fb          	endbr32 
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd0:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd5:	89 d1                	mov    %edx,%ecx
  800dd7:	89 d3                	mov    %edx,%ebx
  800dd9:	89 d7                	mov    %edx,%edi
  800ddb:	89 d6                	mov    %edx,%esi
  800ddd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800de4:	f3 0f 1e fb          	endbr32 
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dfe:	89 cb                	mov    %ecx,%ebx
  800e00:	89 cf                	mov    %ecx,%edi
  800e02:	89 ce                	mov    %ecx,%esi
  800e04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	7f 08                	jg     800e12 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e12:	83 ec 0c             	sub    $0xc,%esp
  800e15:	50                   	push   %eax
  800e16:	6a 03                	push   $0x3
  800e18:	68 9f 2e 80 00       	push   $0x802e9f
  800e1d:	6a 23                	push   $0x23
  800e1f:	68 bc 2e 80 00       	push   $0x802ebc
  800e24:	e8 13 f5 ff ff       	call   80033c <_panic>

00800e29 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e29:	f3 0f 1e fb          	endbr32 
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	57                   	push   %edi
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e33:	ba 00 00 00 00       	mov    $0x0,%edx
  800e38:	b8 02 00 00 00       	mov    $0x2,%eax
  800e3d:	89 d1                	mov    %edx,%ecx
  800e3f:	89 d3                	mov    %edx,%ebx
  800e41:	89 d7                	mov    %edx,%edi
  800e43:	89 d6                	mov    %edx,%esi
  800e45:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <sys_yield>:

void
sys_yield(void)
{
  800e4c:	f3 0f 1e fb          	endbr32 
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e56:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e60:	89 d1                	mov    %edx,%ecx
  800e62:	89 d3                	mov    %edx,%ebx
  800e64:	89 d7                	mov    %edx,%edi
  800e66:	89 d6                	mov    %edx,%esi
  800e68:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e6f:	f3 0f 1e fb          	endbr32 
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7c:	be 00 00 00 00       	mov    $0x0,%esi
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e87:	b8 04 00 00 00       	mov    $0x4,%eax
  800e8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8f:	89 f7                	mov    %esi,%edi
  800e91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	7f 08                	jg     800e9f <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	50                   	push   %eax
  800ea3:	6a 04                	push   $0x4
  800ea5:	68 9f 2e 80 00       	push   $0x802e9f
  800eaa:	6a 23                	push   $0x23
  800eac:	68 bc 2e 80 00       	push   $0x802ebc
  800eb1:	e8 86 f4 ff ff       	call   80033c <_panic>

00800eb6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb6:	f3 0f 1e fb          	endbr32 
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	57                   	push   %edi
  800ebe:	56                   	push   %esi
  800ebf:	53                   	push   %ebx
  800ec0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec9:	b8 05 00 00 00       	mov    $0x5,%eax
  800ece:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	7f 08                	jg     800ee5 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee5:	83 ec 0c             	sub    $0xc,%esp
  800ee8:	50                   	push   %eax
  800ee9:	6a 05                	push   $0x5
  800eeb:	68 9f 2e 80 00       	push   $0x802e9f
  800ef0:	6a 23                	push   $0x23
  800ef2:	68 bc 2e 80 00       	push   $0x802ebc
  800ef7:	e8 40 f4 ff ff       	call   80033c <_panic>

00800efc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800efc:	f3 0f 1e fb          	endbr32 
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
  800f06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f14:	b8 06 00 00 00       	mov    $0x6,%eax
  800f19:	89 df                	mov    %ebx,%edi
  800f1b:	89 de                	mov    %ebx,%esi
  800f1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	7f 08                	jg     800f2b <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2b:	83 ec 0c             	sub    $0xc,%esp
  800f2e:	50                   	push   %eax
  800f2f:	6a 06                	push   $0x6
  800f31:	68 9f 2e 80 00       	push   $0x802e9f
  800f36:	6a 23                	push   $0x23
  800f38:	68 bc 2e 80 00       	push   $0x802ebc
  800f3d:	e8 fa f3 ff ff       	call   80033c <_panic>

00800f42 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f42:	f3 0f 1e fb          	endbr32 
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5a:	b8 08 00 00 00       	mov    $0x8,%eax
  800f5f:	89 df                	mov    %ebx,%edi
  800f61:	89 de                	mov    %ebx,%esi
  800f63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f65:	85 c0                	test   %eax,%eax
  800f67:	7f 08                	jg     800f71 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f71:	83 ec 0c             	sub    $0xc,%esp
  800f74:	50                   	push   %eax
  800f75:	6a 08                	push   $0x8
  800f77:	68 9f 2e 80 00       	push   $0x802e9f
  800f7c:	6a 23                	push   $0x23
  800f7e:	68 bc 2e 80 00       	push   $0x802ebc
  800f83:	e8 b4 f3 ff ff       	call   80033c <_panic>

00800f88 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f88:	f3 0f 1e fb          	endbr32 
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	57                   	push   %edi
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
  800f92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa5:	89 df                	mov    %ebx,%edi
  800fa7:	89 de                	mov    %ebx,%esi
  800fa9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fab:	85 c0                	test   %eax,%eax
  800fad:	7f 08                	jg     800fb7 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb7:	83 ec 0c             	sub    $0xc,%esp
  800fba:	50                   	push   %eax
  800fbb:	6a 09                	push   $0x9
  800fbd:	68 9f 2e 80 00       	push   $0x802e9f
  800fc2:	6a 23                	push   $0x23
  800fc4:	68 bc 2e 80 00       	push   $0x802ebc
  800fc9:	e8 6e f3 ff ff       	call   80033c <_panic>

00800fce <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fce:	f3 0f 1e fb          	endbr32 
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
  800fd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800feb:	89 df                	mov    %ebx,%edi
  800fed:	89 de                	mov    %ebx,%esi
  800fef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	7f 08                	jg     800ffd <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5f                   	pop    %edi
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffd:	83 ec 0c             	sub    $0xc,%esp
  801000:	50                   	push   %eax
  801001:	6a 0a                	push   $0xa
  801003:	68 9f 2e 80 00       	push   $0x802e9f
  801008:	6a 23                	push   $0x23
  80100a:	68 bc 2e 80 00       	push   $0x802ebc
  80100f:	e8 28 f3 ff ff       	call   80033c <_panic>

00801014 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801014:	f3 0f 1e fb          	endbr32 
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801024:	b8 0c 00 00 00       	mov    $0xc,%eax
  801029:	be 00 00 00 00       	mov    $0x0,%esi
  80102e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801031:	8b 7d 14             	mov    0x14(%ebp),%edi
  801034:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801036:	5b                   	pop    %ebx
  801037:	5e                   	pop    %esi
  801038:	5f                   	pop    %edi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80103b:	f3 0f 1e fb          	endbr32 
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	57                   	push   %edi
  801043:	56                   	push   %esi
  801044:	53                   	push   %ebx
  801045:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104d:	8b 55 08             	mov    0x8(%ebp),%edx
  801050:	b8 0d 00 00 00       	mov    $0xd,%eax
  801055:	89 cb                	mov    %ecx,%ebx
  801057:	89 cf                	mov    %ecx,%edi
  801059:	89 ce                	mov    %ecx,%esi
  80105b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	7f 08                	jg     801069 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801061:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801064:	5b                   	pop    %ebx
  801065:	5e                   	pop    %esi
  801066:	5f                   	pop    %edi
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	6a 0d                	push   $0xd
  80106f:	68 9f 2e 80 00       	push   $0x802e9f
  801074:	6a 23                	push   $0x23
  801076:	68 bc 2e 80 00       	push   $0x802ebc
  80107b:	e8 bc f2 ff ff       	call   80033c <_panic>

00801080 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801080:	f3 0f 1e fb          	endbr32 
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
	asm volatile("int %1\n"
  80108a:	ba 00 00 00 00       	mov    $0x0,%edx
  80108f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801094:	89 d1                	mov    %edx,%ecx
  801096:	89 d3                	mov    %edx,%ebx
  801098:	89 d7                	mov    %edx,%edi
  80109a:	89 d6                	mov    %edx,%esi
  80109c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8010a3:	f3 0f 1e fb          	endbr32 
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	57                   	push   %edi
  8010ab:	56                   	push   %esi
  8010ac:	53                   	push   %ebx
  8010ad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bb:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010c0:	89 df                	mov    %ebx,%edi
  8010c2:	89 de                	mov    %ebx,%esi
  8010c4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	7f 08                	jg     8010d2 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8010ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010cd:	5b                   	pop    %ebx
  8010ce:	5e                   	pop    %esi
  8010cf:	5f                   	pop    %edi
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d2:	83 ec 0c             	sub    $0xc,%esp
  8010d5:	50                   	push   %eax
  8010d6:	6a 0f                	push   $0xf
  8010d8:	68 9f 2e 80 00       	push   $0x802e9f
  8010dd:	6a 23                	push   $0x23
  8010df:	68 bc 2e 80 00       	push   $0x802ebc
  8010e4:	e8 53 f2 ff ff       	call   80033c <_panic>

008010e9 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8010e9:	f3 0f 1e fb          	endbr32 
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	57                   	push   %edi
  8010f1:	56                   	push   %esi
  8010f2:	53                   	push   %ebx
  8010f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801101:	b8 10 00 00 00       	mov    $0x10,%eax
  801106:	89 df                	mov    %ebx,%edi
  801108:	89 de                	mov    %ebx,%esi
  80110a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110c:	85 c0                	test   %eax,%eax
  80110e:	7f 08                	jg     801118 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  801110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801118:	83 ec 0c             	sub    $0xc,%esp
  80111b:	50                   	push   %eax
  80111c:	6a 10                	push   $0x10
  80111e:	68 9f 2e 80 00       	push   $0x802e9f
  801123:	6a 23                	push   $0x23
  801125:	68 bc 2e 80 00       	push   $0x802ebc
  80112a:	e8 0d f2 ff ff       	call   80033c <_panic>

0080112f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80112f:	f3 0f 1e fb          	endbr32 
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	53                   	push   %ebx
  801137:	83 ec 04             	sub    $0x4,%esp
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80113d:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  80113f:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801143:	74 74                	je     8011b9 <pgfault+0x8a>
  801145:	89 d8                	mov    %ebx,%eax
  801147:	c1 e8 0c             	shr    $0xc,%eax
  80114a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801151:	f6 c4 08             	test   $0x8,%ah
  801154:	74 63                	je     8011b9 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801156:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	6a 05                	push   $0x5
  801161:	68 00 f0 7f 00       	push   $0x7ff000
  801166:	6a 00                	push   $0x0
  801168:	53                   	push   %ebx
  801169:	6a 00                	push   $0x0
  80116b:	e8 46 fd ff ff       	call   800eb6 <sys_page_map>
  801170:	83 c4 20             	add    $0x20,%esp
  801173:	85 c0                	test   %eax,%eax
  801175:	78 59                	js     8011d0 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  801177:	83 ec 04             	sub    $0x4,%esp
  80117a:	6a 07                	push   $0x7
  80117c:	53                   	push   %ebx
  80117d:	6a 00                	push   $0x0
  80117f:	e8 eb fc ff ff       	call   800e6f <sys_page_alloc>
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	85 c0                	test   %eax,%eax
  801189:	78 5a                	js     8011e5 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  80118b:	83 ec 04             	sub    $0x4,%esp
  80118e:	68 00 10 00 00       	push   $0x1000
  801193:	68 00 f0 7f 00       	push   $0x7ff000
  801198:	53                   	push   %ebx
  801199:	e8 45 fa ff ff       	call   800be3 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  80119e:	83 c4 08             	add    $0x8,%esp
  8011a1:	68 00 f0 7f 00       	push   $0x7ff000
  8011a6:	6a 00                	push   $0x0
  8011a8:	e8 4f fd ff ff       	call   800efc <sys_page_unmap>
  8011ad:	83 c4 10             	add    $0x10,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	78 46                	js     8011fa <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  8011b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b7:	c9                   	leave  
  8011b8:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  8011b9:	83 ec 04             	sub    $0x4,%esp
  8011bc:	68 ca 2e 80 00       	push   $0x802eca
  8011c1:	68 d3 00 00 00       	push   $0xd3
  8011c6:	68 e6 2e 80 00       	push   $0x802ee6
  8011cb:	e8 6c f1 ff ff       	call   80033c <_panic>
		panic("pgfault: %e\n", r);
  8011d0:	50                   	push   %eax
  8011d1:	68 f1 2e 80 00       	push   $0x802ef1
  8011d6:	68 df 00 00 00       	push   $0xdf
  8011db:	68 e6 2e 80 00       	push   $0x802ee6
  8011e0:	e8 57 f1 ff ff       	call   80033c <_panic>
		panic("pgfault: %e\n", r);
  8011e5:	50                   	push   %eax
  8011e6:	68 f1 2e 80 00       	push   $0x802ef1
  8011eb:	68 e3 00 00 00       	push   $0xe3
  8011f0:	68 e6 2e 80 00       	push   $0x802ee6
  8011f5:	e8 42 f1 ff ff       	call   80033c <_panic>
		panic("pgfault: %e\n", r);
  8011fa:	50                   	push   %eax
  8011fb:	68 f1 2e 80 00       	push   $0x802ef1
  801200:	68 e9 00 00 00       	push   $0xe9
  801205:	68 e6 2e 80 00       	push   $0x802ee6
  80120a:	e8 2d f1 ff ff       	call   80033c <_panic>

0080120f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80120f:	f3 0f 1e fb          	endbr32 
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	57                   	push   %edi
  801217:	56                   	push   %esi
  801218:	53                   	push   %ebx
  801219:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  80121c:	68 2f 11 80 00       	push   $0x80112f
  801221:	e8 1e 15 00 00       	call   802744 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801226:	b8 07 00 00 00       	mov    $0x7,%eax
  80122b:	cd 30                	int    $0x30
  80122d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	78 2d                	js     801264 <fork+0x55>
  801237:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801239:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80123e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801242:	0f 85 9b 00 00 00    	jne    8012e3 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801248:	e8 dc fb ff ff       	call   800e29 <sys_getenvid>
  80124d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801252:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801255:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80125a:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80125f:	e9 71 01 00 00       	jmp    8013d5 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  801264:	50                   	push   %eax
  801265:	68 fe 2e 80 00       	push   $0x802efe
  80126a:	68 2a 01 00 00       	push   $0x12a
  80126f:	68 e6 2e 80 00       	push   $0x802ee6
  801274:	e8 c3 f0 ff ff       	call   80033c <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801279:	c1 e6 0c             	shl    $0xc,%esi
  80127c:	83 ec 0c             	sub    $0xc,%esp
  80127f:	68 07 0e 00 00       	push   $0xe07
  801284:	56                   	push   %esi
  801285:	57                   	push   %edi
  801286:	56                   	push   %esi
  801287:	6a 00                	push   $0x0
  801289:	e8 28 fc ff ff       	call   800eb6 <sys_page_map>
  80128e:	83 c4 20             	add    $0x20,%esp
  801291:	eb 3e                	jmp    8012d1 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801293:	c1 e6 0c             	shl    $0xc,%esi
  801296:	83 ec 0c             	sub    $0xc,%esp
  801299:	68 05 08 00 00       	push   $0x805
  80129e:	56                   	push   %esi
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	6a 00                	push   $0x0
  8012a3:	e8 0e fc ff ff       	call   800eb6 <sys_page_map>
  8012a8:	83 c4 20             	add    $0x20,%esp
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	0f 88 bc 00 00 00    	js     80136f <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8012b3:	83 ec 0c             	sub    $0xc,%esp
  8012b6:	68 05 08 00 00       	push   $0x805
  8012bb:	56                   	push   %esi
  8012bc:	6a 00                	push   $0x0
  8012be:	56                   	push   %esi
  8012bf:	6a 00                	push   $0x0
  8012c1:	e8 f0 fb ff ff       	call   800eb6 <sys_page_map>
  8012c6:	83 c4 20             	add    $0x20,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	0f 88 b3 00 00 00    	js     801384 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8012d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012d7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012dd:	0f 84 b6 00 00 00    	je     801399 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8012e3:	89 d8                	mov    %ebx,%eax
  8012e5:	c1 e8 16             	shr    $0x16,%eax
  8012e8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ef:	a8 01                	test   $0x1,%al
  8012f1:	74 de                	je     8012d1 <fork+0xc2>
  8012f3:	89 de                	mov    %ebx,%esi
  8012f5:	c1 ee 0c             	shr    $0xc,%esi
  8012f8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012ff:	a8 01                	test   $0x1,%al
  801301:	74 ce                	je     8012d1 <fork+0xc2>
  801303:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80130a:	a8 04                	test   $0x4,%al
  80130c:	74 c3                	je     8012d1 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  80130e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801315:	f6 c4 04             	test   $0x4,%ah
  801318:	0f 85 5b ff ff ff    	jne    801279 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  80131e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801325:	a8 02                	test   $0x2,%al
  801327:	0f 85 66 ff ff ff    	jne    801293 <fork+0x84>
  80132d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801334:	f6 c4 08             	test   $0x8,%ah
  801337:	0f 85 56 ff ff ff    	jne    801293 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80133d:	c1 e6 0c             	shl    $0xc,%esi
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	6a 05                	push   $0x5
  801345:	56                   	push   %esi
  801346:	57                   	push   %edi
  801347:	56                   	push   %esi
  801348:	6a 00                	push   $0x0
  80134a:	e8 67 fb ff ff       	call   800eb6 <sys_page_map>
  80134f:	83 c4 20             	add    $0x20,%esp
  801352:	85 c0                	test   %eax,%eax
  801354:	0f 89 77 ff ff ff    	jns    8012d1 <fork+0xc2>
		panic("duppage: %e\n", r);
  80135a:	50                   	push   %eax
  80135b:	68 0e 2f 80 00       	push   $0x802f0e
  801360:	68 0c 01 00 00       	push   $0x10c
  801365:	68 e6 2e 80 00       	push   $0x802ee6
  80136a:	e8 cd ef ff ff       	call   80033c <_panic>
			panic("duppage: %e\n", r);
  80136f:	50                   	push   %eax
  801370:	68 0e 2f 80 00       	push   $0x802f0e
  801375:	68 05 01 00 00       	push   $0x105
  80137a:	68 e6 2e 80 00       	push   $0x802ee6
  80137f:	e8 b8 ef ff ff       	call   80033c <_panic>
			panic("duppage: %e\n", r);
  801384:	50                   	push   %eax
  801385:	68 0e 2f 80 00       	push   $0x802f0e
  80138a:	68 09 01 00 00       	push   $0x109
  80138f:	68 e6 2e 80 00       	push   $0x802ee6
  801394:	e8 a3 ef ff ff       	call   80033c <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	6a 07                	push   $0x7
  80139e:	68 00 f0 bf ee       	push   $0xeebff000
  8013a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013a6:	e8 c4 fa ff ff       	call   800e6f <sys_page_alloc>
  8013ab:	83 c4 10             	add    $0x10,%esp
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 2e                	js     8013e0 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	68 b7 27 80 00       	push   $0x8027b7
  8013ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013bd:	57                   	push   %edi
  8013be:	e8 0b fc ff ff       	call   800fce <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8013c3:	83 c4 08             	add    $0x8,%esp
  8013c6:	6a 02                	push   $0x2
  8013c8:	57                   	push   %edi
  8013c9:	e8 74 fb ff ff       	call   800f42 <sys_env_set_status>
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	78 20                	js     8013f5 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8013d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013db:	5b                   	pop    %ebx
  8013dc:	5e                   	pop    %esi
  8013dd:	5f                   	pop    %edi
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8013e0:	50                   	push   %eax
  8013e1:	68 aa 2a 80 00       	push   $0x802aaa
  8013e6:	68 3e 01 00 00       	push   $0x13e
  8013eb:	68 e6 2e 80 00       	push   $0x802ee6
  8013f0:	e8 47 ef ff ff       	call   80033c <_panic>
		panic("sys_env_set_status: %e", r);
  8013f5:	50                   	push   %eax
  8013f6:	68 1b 2f 80 00       	push   $0x802f1b
  8013fb:	68 43 01 00 00       	push   $0x143
  801400:	68 e6 2e 80 00       	push   $0x802ee6
  801405:	e8 32 ef ff ff       	call   80033c <_panic>

0080140a <sfork>:

// Challenge!
int
sfork(void)
{
  80140a:	f3 0f 1e fb          	endbr32 
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801414:	68 32 2f 80 00       	push   $0x802f32
  801419:	68 4c 01 00 00       	push   $0x14c
  80141e:	68 e6 2e 80 00       	push   $0x802ee6
  801423:	e8 14 ef ff ff       	call   80033c <_panic>

00801428 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801428:	f3 0f 1e fb          	endbr32 
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	56                   	push   %esi
  801430:	53                   	push   %ebx
  801431:	8b 75 08             	mov    0x8(%ebp),%esi
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80143a:	85 c0                	test   %eax,%eax
  80143c:	74 3d                	je     80147b <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80143e:	83 ec 0c             	sub    $0xc,%esp
  801441:	50                   	push   %eax
  801442:	e8 f4 fb ff ff       	call   80103b <sys_ipc_recv>
  801447:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80144a:	85 f6                	test   %esi,%esi
  80144c:	74 0b                	je     801459 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80144e:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  801454:	8b 52 74             	mov    0x74(%edx),%edx
  801457:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801459:	85 db                	test   %ebx,%ebx
  80145b:	74 0b                	je     801468 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80145d:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  801463:	8b 52 78             	mov    0x78(%edx),%edx
  801466:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 21                	js     80148d <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80146c:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801471:	8b 40 70             	mov    0x70(%eax),%eax
}
  801474:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801477:	5b                   	pop    %ebx
  801478:	5e                   	pop    %esi
  801479:	5d                   	pop    %ebp
  80147a:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	68 00 00 c0 ee       	push   $0xeec00000
  801483:	e8 b3 fb ff ff       	call   80103b <sys_ipc_recv>
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	eb bd                	jmp    80144a <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80148d:	85 f6                	test   %esi,%esi
  80148f:	74 10                	je     8014a1 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801491:	85 db                	test   %ebx,%ebx
  801493:	75 df                	jne    801474 <ipc_recv+0x4c>
  801495:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80149c:	00 00 00 
  80149f:	eb d3                	jmp    801474 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8014a1:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8014a8:	00 00 00 
  8014ab:	eb e4                	jmp    801491 <ipc_recv+0x69>

008014ad <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014ad:	f3 0f 1e fb          	endbr32 
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	57                   	push   %edi
  8014b5:	56                   	push   %esi
  8014b6:	53                   	push   %ebx
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8014c3:	85 db                	test   %ebx,%ebx
  8014c5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8014ca:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8014cd:	ff 75 14             	pushl  0x14(%ebp)
  8014d0:	53                   	push   %ebx
  8014d1:	56                   	push   %esi
  8014d2:	57                   	push   %edi
  8014d3:	e8 3c fb ff ff       	call   801014 <sys_ipc_try_send>
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	79 1e                	jns    8014fd <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8014df:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014e2:	75 07                	jne    8014eb <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8014e4:	e8 63 f9 ff ff       	call   800e4c <sys_yield>
  8014e9:	eb e2                	jmp    8014cd <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8014eb:	50                   	push   %eax
  8014ec:	68 48 2f 80 00       	push   $0x802f48
  8014f1:	6a 59                	push   $0x59
  8014f3:	68 63 2f 80 00       	push   $0x802f63
  8014f8:	e8 3f ee ff ff       	call   80033c <_panic>
	}
}
  8014fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801500:	5b                   	pop    %ebx
  801501:	5e                   	pop    %esi
  801502:	5f                   	pop    %edi
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    

00801505 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801505:	f3 0f 1e fb          	endbr32 
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80150f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801514:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801517:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80151d:	8b 52 50             	mov    0x50(%edx),%edx
  801520:	39 ca                	cmp    %ecx,%edx
  801522:	74 11                	je     801535 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801524:	83 c0 01             	add    $0x1,%eax
  801527:	3d 00 04 00 00       	cmp    $0x400,%eax
  80152c:	75 e6                	jne    801514 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
  801533:	eb 0b                	jmp    801540 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801535:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801538:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80153d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801540:	5d                   	pop    %ebp
  801541:	c3                   	ret    

00801542 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801542:	f3 0f 1e fb          	endbr32 
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	05 00 00 00 30       	add    $0x30000000,%eax
  801551:	c1 e8 0c             	shr    $0xc,%eax
}
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    

00801556 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801556:	f3 0f 1e fb          	endbr32 
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801565:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80156a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80156f:	5d                   	pop    %ebp
  801570:	c3                   	ret    

00801571 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801571:	f3 0f 1e fb          	endbr32 
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80157d:	89 c2                	mov    %eax,%edx
  80157f:	c1 ea 16             	shr    $0x16,%edx
  801582:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801589:	f6 c2 01             	test   $0x1,%dl
  80158c:	74 2d                	je     8015bb <fd_alloc+0x4a>
  80158e:	89 c2                	mov    %eax,%edx
  801590:	c1 ea 0c             	shr    $0xc,%edx
  801593:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80159a:	f6 c2 01             	test   $0x1,%dl
  80159d:	74 1c                	je     8015bb <fd_alloc+0x4a>
  80159f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015a4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015a9:	75 d2                	jne    80157d <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015b4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015b9:	eb 0a                	jmp    8015c5 <fd_alloc+0x54>
			*fd_store = fd;
  8015bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015be:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    

008015c7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015c7:	f3 0f 1e fb          	endbr32 
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015d1:	83 f8 1f             	cmp    $0x1f,%eax
  8015d4:	77 30                	ja     801606 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015d6:	c1 e0 0c             	shl    $0xc,%eax
  8015d9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015de:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015e4:	f6 c2 01             	test   $0x1,%dl
  8015e7:	74 24                	je     80160d <fd_lookup+0x46>
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	c1 ea 0c             	shr    $0xc,%edx
  8015ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015f5:	f6 c2 01             	test   $0x1,%dl
  8015f8:	74 1a                	je     801614 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fd:	89 02                	mov    %eax,(%edx)
	return 0;
  8015ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801604:	5d                   	pop    %ebp
  801605:	c3                   	ret    
		return -E_INVAL;
  801606:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160b:	eb f7                	jmp    801604 <fd_lookup+0x3d>
		return -E_INVAL;
  80160d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801612:	eb f0                	jmp    801604 <fd_lookup+0x3d>
  801614:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801619:	eb e9                	jmp    801604 <fd_lookup+0x3d>

0080161b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80161b:	f3 0f 1e fb          	endbr32 
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801628:	ba 00 00 00 00       	mov    $0x0,%edx
  80162d:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801632:	39 08                	cmp    %ecx,(%eax)
  801634:	74 38                	je     80166e <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801636:	83 c2 01             	add    $0x1,%edx
  801639:	8b 04 95 ec 2f 80 00 	mov    0x802fec(,%edx,4),%eax
  801640:	85 c0                	test   %eax,%eax
  801642:	75 ee                	jne    801632 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801644:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801649:	8b 40 48             	mov    0x48(%eax),%eax
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	51                   	push   %ecx
  801650:	50                   	push   %eax
  801651:	68 70 2f 80 00       	push   $0x802f70
  801656:	e8 c8 ed ff ff       	call   800423 <cprintf>
	*dev = 0;
  80165b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    
			*dev = devtab[i];
  80166e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801671:	89 01                	mov    %eax,(%ecx)
			return 0;
  801673:	b8 00 00 00 00       	mov    $0x0,%eax
  801678:	eb f2                	jmp    80166c <dev_lookup+0x51>

0080167a <fd_close>:
{
  80167a:	f3 0f 1e fb          	endbr32 
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	57                   	push   %edi
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
  801684:	83 ec 24             	sub    $0x24,%esp
  801687:	8b 75 08             	mov    0x8(%ebp),%esi
  80168a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80168d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801690:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801691:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801697:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80169a:	50                   	push   %eax
  80169b:	e8 27 ff ff ff       	call   8015c7 <fd_lookup>
  8016a0:	89 c3                	mov    %eax,%ebx
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 05                	js     8016ae <fd_close+0x34>
	    || fd != fd2)
  8016a9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016ac:	74 16                	je     8016c4 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8016ae:	89 f8                	mov    %edi,%eax
  8016b0:	84 c0                	test   %al,%al
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b7:	0f 44 d8             	cmove  %eax,%ebx
}
  8016ba:	89 d8                	mov    %ebx,%eax
  8016bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016bf:	5b                   	pop    %ebx
  8016c0:	5e                   	pop    %esi
  8016c1:	5f                   	pop    %edi
  8016c2:	5d                   	pop    %ebp
  8016c3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016c4:	83 ec 08             	sub    $0x8,%esp
  8016c7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 36                	pushl  (%esi)
  8016cd:	e8 49 ff ff ff       	call   80161b <dev_lookup>
  8016d2:	89 c3                	mov    %eax,%ebx
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	78 1a                	js     8016f5 <fd_close+0x7b>
		if (dev->dev_close)
  8016db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016de:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	74 0b                	je     8016f5 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	56                   	push   %esi
  8016ee:	ff d0                	call   *%eax
  8016f0:	89 c3                	mov    %eax,%ebx
  8016f2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	56                   	push   %esi
  8016f9:	6a 00                	push   $0x0
  8016fb:	e8 fc f7 ff ff       	call   800efc <sys_page_unmap>
	return r;
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	eb b5                	jmp    8016ba <fd_close+0x40>

00801705 <close>:

int
close(int fdnum)
{
  801705:	f3 0f 1e fb          	endbr32 
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80170f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801712:	50                   	push   %eax
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	e8 ac fe ff ff       	call   8015c7 <fd_lookup>
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	85 c0                	test   %eax,%eax
  801720:	79 02                	jns    801724 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    
		return fd_close(fd, 1);
  801724:	83 ec 08             	sub    $0x8,%esp
  801727:	6a 01                	push   $0x1
  801729:	ff 75 f4             	pushl  -0xc(%ebp)
  80172c:	e8 49 ff ff ff       	call   80167a <fd_close>
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	eb ec                	jmp    801722 <close+0x1d>

00801736 <close_all>:

void
close_all(void)
{
  801736:	f3 0f 1e fb          	endbr32 
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801741:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	53                   	push   %ebx
  80174a:	e8 b6 ff ff ff       	call   801705 <close>
	for (i = 0; i < MAXFD; i++)
  80174f:	83 c3 01             	add    $0x1,%ebx
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	83 fb 20             	cmp    $0x20,%ebx
  801758:	75 ec                	jne    801746 <close_all+0x10>
}
  80175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80175f:	f3 0f 1e fb          	endbr32 
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	57                   	push   %edi
  801767:	56                   	push   %esi
  801768:	53                   	push   %ebx
  801769:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80176c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80176f:	50                   	push   %eax
  801770:	ff 75 08             	pushl  0x8(%ebp)
  801773:	e8 4f fe ff ff       	call   8015c7 <fd_lookup>
  801778:	89 c3                	mov    %eax,%ebx
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	85 c0                	test   %eax,%eax
  80177f:	0f 88 81 00 00 00    	js     801806 <dup+0xa7>
		return r;
	close(newfdnum);
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	ff 75 0c             	pushl  0xc(%ebp)
  80178b:	e8 75 ff ff ff       	call   801705 <close>

	newfd = INDEX2FD(newfdnum);
  801790:	8b 75 0c             	mov    0xc(%ebp),%esi
  801793:	c1 e6 0c             	shl    $0xc,%esi
  801796:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80179c:	83 c4 04             	add    $0x4,%esp
  80179f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017a2:	e8 af fd ff ff       	call   801556 <fd2data>
  8017a7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017a9:	89 34 24             	mov    %esi,(%esp)
  8017ac:	e8 a5 fd ff ff       	call   801556 <fd2data>
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017b6:	89 d8                	mov    %ebx,%eax
  8017b8:	c1 e8 16             	shr    $0x16,%eax
  8017bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017c2:	a8 01                	test   $0x1,%al
  8017c4:	74 11                	je     8017d7 <dup+0x78>
  8017c6:	89 d8                	mov    %ebx,%eax
  8017c8:	c1 e8 0c             	shr    $0xc,%eax
  8017cb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017d2:	f6 c2 01             	test   $0x1,%dl
  8017d5:	75 39                	jne    801810 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017da:	89 d0                	mov    %edx,%eax
  8017dc:	c1 e8 0c             	shr    $0xc,%eax
  8017df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017e6:	83 ec 0c             	sub    $0xc,%esp
  8017e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8017ee:	50                   	push   %eax
  8017ef:	56                   	push   %esi
  8017f0:	6a 00                	push   $0x0
  8017f2:	52                   	push   %edx
  8017f3:	6a 00                	push   $0x0
  8017f5:	e8 bc f6 ff ff       	call   800eb6 <sys_page_map>
  8017fa:	89 c3                	mov    %eax,%ebx
  8017fc:	83 c4 20             	add    $0x20,%esp
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 31                	js     801834 <dup+0xd5>
		goto err;

	return newfdnum;
  801803:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801806:	89 d8                	mov    %ebx,%eax
  801808:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5f                   	pop    %edi
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801810:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801817:	83 ec 0c             	sub    $0xc,%esp
  80181a:	25 07 0e 00 00       	and    $0xe07,%eax
  80181f:	50                   	push   %eax
  801820:	57                   	push   %edi
  801821:	6a 00                	push   $0x0
  801823:	53                   	push   %ebx
  801824:	6a 00                	push   $0x0
  801826:	e8 8b f6 ff ff       	call   800eb6 <sys_page_map>
  80182b:	89 c3                	mov    %eax,%ebx
  80182d:	83 c4 20             	add    $0x20,%esp
  801830:	85 c0                	test   %eax,%eax
  801832:	79 a3                	jns    8017d7 <dup+0x78>
	sys_page_unmap(0, newfd);
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	56                   	push   %esi
  801838:	6a 00                	push   $0x0
  80183a:	e8 bd f6 ff ff       	call   800efc <sys_page_unmap>
	sys_page_unmap(0, nva);
  80183f:	83 c4 08             	add    $0x8,%esp
  801842:	57                   	push   %edi
  801843:	6a 00                	push   $0x0
  801845:	e8 b2 f6 ff ff       	call   800efc <sys_page_unmap>
	return r;
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	eb b7                	jmp    801806 <dup+0xa7>

0080184f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80184f:	f3 0f 1e fb          	endbr32 
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	53                   	push   %ebx
  801857:	83 ec 1c             	sub    $0x1c,%esp
  80185a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801860:	50                   	push   %eax
  801861:	53                   	push   %ebx
  801862:	e8 60 fd ff ff       	call   8015c7 <fd_lookup>
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	85 c0                	test   %eax,%eax
  80186c:	78 3f                	js     8018ad <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801874:	50                   	push   %eax
  801875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801878:	ff 30                	pushl  (%eax)
  80187a:	e8 9c fd ff ff       	call   80161b <dev_lookup>
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	78 27                	js     8018ad <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801886:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801889:	8b 42 08             	mov    0x8(%edx),%eax
  80188c:	83 e0 03             	and    $0x3,%eax
  80188f:	83 f8 01             	cmp    $0x1,%eax
  801892:	74 1e                	je     8018b2 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801897:	8b 40 08             	mov    0x8(%eax),%eax
  80189a:	85 c0                	test   %eax,%eax
  80189c:	74 35                	je     8018d3 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	ff 75 10             	pushl  0x10(%ebp)
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	52                   	push   %edx
  8018a8:	ff d0                	call   *%eax
  8018aa:	83 c4 10             	add    $0x10,%esp
}
  8018ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018b2:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8018b7:	8b 40 48             	mov    0x48(%eax),%eax
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	53                   	push   %ebx
  8018be:	50                   	push   %eax
  8018bf:	68 b1 2f 80 00       	push   $0x802fb1
  8018c4:	e8 5a eb ff ff       	call   800423 <cprintf>
		return -E_INVAL;
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d1:	eb da                	jmp    8018ad <read+0x5e>
		return -E_NOT_SUPP;
  8018d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d8:	eb d3                	jmp    8018ad <read+0x5e>

008018da <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018da:	f3 0f 1e fb          	endbr32 
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	57                   	push   %edi
  8018e2:	56                   	push   %esi
  8018e3:	53                   	push   %ebx
  8018e4:	83 ec 0c             	sub    $0xc,%esp
  8018e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018ea:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018f2:	eb 02                	jmp    8018f6 <readn+0x1c>
  8018f4:	01 c3                	add    %eax,%ebx
  8018f6:	39 f3                	cmp    %esi,%ebx
  8018f8:	73 21                	jae    80191b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	89 f0                	mov    %esi,%eax
  8018ff:	29 d8                	sub    %ebx,%eax
  801901:	50                   	push   %eax
  801902:	89 d8                	mov    %ebx,%eax
  801904:	03 45 0c             	add    0xc(%ebp),%eax
  801907:	50                   	push   %eax
  801908:	57                   	push   %edi
  801909:	e8 41 ff ff ff       	call   80184f <read>
		if (m < 0)
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	85 c0                	test   %eax,%eax
  801913:	78 04                	js     801919 <readn+0x3f>
			return m;
		if (m == 0)
  801915:	75 dd                	jne    8018f4 <readn+0x1a>
  801917:	eb 02                	jmp    80191b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801919:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80191b:	89 d8                	mov    %ebx,%eax
  80191d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801920:	5b                   	pop    %ebx
  801921:	5e                   	pop    %esi
  801922:	5f                   	pop    %edi
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801925:	f3 0f 1e fb          	endbr32 
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	53                   	push   %ebx
  80192d:	83 ec 1c             	sub    $0x1c,%esp
  801930:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801933:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801936:	50                   	push   %eax
  801937:	53                   	push   %ebx
  801938:	e8 8a fc ff ff       	call   8015c7 <fd_lookup>
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	85 c0                	test   %eax,%eax
  801942:	78 3a                	js     80197e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194a:	50                   	push   %eax
  80194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194e:	ff 30                	pushl  (%eax)
  801950:	e8 c6 fc ff ff       	call   80161b <dev_lookup>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 22                	js     80197e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80195c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801963:	74 1e                	je     801983 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801968:	8b 52 0c             	mov    0xc(%edx),%edx
  80196b:	85 d2                	test   %edx,%edx
  80196d:	74 35                	je     8019a4 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80196f:	83 ec 04             	sub    $0x4,%esp
  801972:	ff 75 10             	pushl  0x10(%ebp)
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	50                   	push   %eax
  801979:	ff d2                	call   *%edx
  80197b:	83 c4 10             	add    $0x10,%esp
}
  80197e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801981:	c9                   	leave  
  801982:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801983:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801988:	8b 40 48             	mov    0x48(%eax),%eax
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	53                   	push   %ebx
  80198f:	50                   	push   %eax
  801990:	68 cd 2f 80 00       	push   $0x802fcd
  801995:	e8 89 ea ff ff       	call   800423 <cprintf>
		return -E_INVAL;
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a2:	eb da                	jmp    80197e <write+0x59>
		return -E_NOT_SUPP;
  8019a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019a9:	eb d3                	jmp    80197e <write+0x59>

008019ab <seek>:

int
seek(int fdnum, off_t offset)
{
  8019ab:	f3 0f 1e fb          	endbr32 
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b8:	50                   	push   %eax
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	e8 06 fc ff ff       	call   8015c7 <fd_lookup>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 0e                	js     8019d6 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ce:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019d8:	f3 0f 1e fb          	endbr32 
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	53                   	push   %ebx
  8019e0:	83 ec 1c             	sub    $0x1c,%esp
  8019e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e9:	50                   	push   %eax
  8019ea:	53                   	push   %ebx
  8019eb:	e8 d7 fb ff ff       	call   8015c7 <fd_lookup>
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	78 37                	js     801a2e <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f7:	83 ec 08             	sub    $0x8,%esp
  8019fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fd:	50                   	push   %eax
  8019fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a01:	ff 30                	pushl  (%eax)
  801a03:	e8 13 fc ff ff       	call   80161b <dev_lookup>
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	78 1f                	js     801a2e <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a12:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a16:	74 1b                	je     801a33 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a1b:	8b 52 18             	mov    0x18(%edx),%edx
  801a1e:	85 d2                	test   %edx,%edx
  801a20:	74 32                	je     801a54 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a22:	83 ec 08             	sub    $0x8,%esp
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	50                   	push   %eax
  801a29:	ff d2                	call   *%edx
  801a2b:	83 c4 10             	add    $0x10,%esp
}
  801a2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a33:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a38:	8b 40 48             	mov    0x48(%eax),%eax
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	53                   	push   %ebx
  801a3f:	50                   	push   %eax
  801a40:	68 90 2f 80 00       	push   $0x802f90
  801a45:	e8 d9 e9 ff ff       	call   800423 <cprintf>
		return -E_INVAL;
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a52:	eb da                	jmp    801a2e <ftruncate+0x56>
		return -E_NOT_SUPP;
  801a54:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a59:	eb d3                	jmp    801a2e <ftruncate+0x56>

00801a5b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a5b:	f3 0f 1e fb          	endbr32 
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	53                   	push   %ebx
  801a63:	83 ec 1c             	sub    $0x1c,%esp
  801a66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a69:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a6c:	50                   	push   %eax
  801a6d:	ff 75 08             	pushl  0x8(%ebp)
  801a70:	e8 52 fb ff ff       	call   8015c7 <fd_lookup>
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	78 4b                	js     801ac7 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a82:	50                   	push   %eax
  801a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a86:	ff 30                	pushl  (%eax)
  801a88:	e8 8e fb ff ff       	call   80161b <dev_lookup>
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 33                	js     801ac7 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a97:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a9b:	74 2f                	je     801acc <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a9d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801aa0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801aa7:	00 00 00 
	stat->st_isdir = 0;
  801aaa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ab1:	00 00 00 
	stat->st_dev = dev;
  801ab4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801aba:	83 ec 08             	sub    $0x8,%esp
  801abd:	53                   	push   %ebx
  801abe:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac1:	ff 50 14             	call   *0x14(%eax)
  801ac4:	83 c4 10             	add    $0x10,%esp
}
  801ac7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    
		return -E_NOT_SUPP;
  801acc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad1:	eb f4                	jmp    801ac7 <fstat+0x6c>

00801ad3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ad3:	f3 0f 1e fb          	endbr32 
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	56                   	push   %esi
  801adb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801adc:	83 ec 08             	sub    $0x8,%esp
  801adf:	6a 00                	push   $0x0
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 fb 01 00 00       	call   801ce4 <open>
  801ae9:	89 c3                	mov    %eax,%ebx
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 1b                	js     801b0d <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801af2:	83 ec 08             	sub    $0x8,%esp
  801af5:	ff 75 0c             	pushl  0xc(%ebp)
  801af8:	50                   	push   %eax
  801af9:	e8 5d ff ff ff       	call   801a5b <fstat>
  801afe:	89 c6                	mov    %eax,%esi
	close(fd);
  801b00:	89 1c 24             	mov    %ebx,(%esp)
  801b03:	e8 fd fb ff ff       	call   801705 <close>
	return r;
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	89 f3                	mov    %esi,%ebx
}
  801b0d:	89 d8                	mov    %ebx,%eax
  801b0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b12:	5b                   	pop    %ebx
  801b13:	5e                   	pop    %esi
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    

00801b16 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	56                   	push   %esi
  801b1a:	53                   	push   %ebx
  801b1b:	89 c6                	mov    %eax,%esi
  801b1d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b1f:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801b26:	74 27                	je     801b4f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b28:	6a 07                	push   $0x7
  801b2a:	68 00 60 80 00       	push   $0x806000
  801b2f:	56                   	push   %esi
  801b30:	ff 35 04 50 80 00    	pushl  0x805004
  801b36:	e8 72 f9 ff ff       	call   8014ad <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b3b:	83 c4 0c             	add    $0xc,%esp
  801b3e:	6a 00                	push   $0x0
  801b40:	53                   	push   %ebx
  801b41:	6a 00                	push   $0x0
  801b43:	e8 e0 f8 ff ff       	call   801428 <ipc_recv>
}
  801b48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4b:	5b                   	pop    %ebx
  801b4c:	5e                   	pop    %esi
  801b4d:	5d                   	pop    %ebp
  801b4e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	6a 01                	push   $0x1
  801b54:	e8 ac f9 ff ff       	call   801505 <ipc_find_env>
  801b59:	a3 04 50 80 00       	mov    %eax,0x805004
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	eb c5                	jmp    801b28 <fsipc+0x12>

00801b63 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b63:	f3 0f 1e fb          	endbr32 
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8b 40 0c             	mov    0xc(%eax),%eax
  801b73:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b80:	ba 00 00 00 00       	mov    $0x0,%edx
  801b85:	b8 02 00 00 00       	mov    $0x2,%eax
  801b8a:	e8 87 ff ff ff       	call   801b16 <fsipc>
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <devfile_flush>:
{
  801b91:	f3 0f 1e fb          	endbr32 
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba1:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ba6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bab:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb0:	e8 61 ff ff ff       	call   801b16 <fsipc>
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <devfile_stat>:
{
  801bb7:	f3 0f 1e fb          	endbr32 
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	53                   	push   %ebx
  801bbf:	83 ec 04             	sub    $0x4,%esp
  801bc2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcb:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd5:	b8 05 00 00 00       	mov    $0x5,%eax
  801bda:	e8 37 ff ff ff       	call   801b16 <fsipc>
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 2c                	js     801c0f <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	68 00 60 80 00       	push   $0x806000
  801beb:	53                   	push   %ebx
  801bec:	e8 3c ee ff ff       	call   800a2d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bf1:	a1 80 60 80 00       	mov    0x806080,%eax
  801bf6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bfc:	a1 84 60 80 00       	mov    0x806084,%eax
  801c01:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <devfile_write>:
{
  801c14:	f3 0f 1e fb          	endbr32 
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 0c             	sub    $0xc,%esp
  801c1e:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c21:	8b 55 08             	mov    0x8(%ebp),%edx
  801c24:	8b 52 0c             	mov    0xc(%edx),%edx
  801c27:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801c2d:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801c32:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801c37:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801c3a:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801c3f:	50                   	push   %eax
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	68 08 60 80 00       	push   $0x806008
  801c48:	e8 96 ef ff ff       	call   800be3 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c52:	b8 04 00 00 00       	mov    $0x4,%eax
  801c57:	e8 ba fe ff ff       	call   801b16 <fsipc>
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <devfile_read>:
{
  801c5e:	f3 0f 1e fb          	endbr32 
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	56                   	push   %esi
  801c66:	53                   	push   %ebx
  801c67:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c70:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c75:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c80:	b8 03 00 00 00       	mov    $0x3,%eax
  801c85:	e8 8c fe ff ff       	call   801b16 <fsipc>
  801c8a:	89 c3                	mov    %eax,%ebx
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	78 1f                	js     801caf <devfile_read+0x51>
	assert(r <= n);
  801c90:	39 f0                	cmp    %esi,%eax
  801c92:	77 24                	ja     801cb8 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801c94:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c99:	7f 33                	jg     801cce <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	50                   	push   %eax
  801c9f:	68 00 60 80 00       	push   $0x806000
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	e8 37 ef ff ff       	call   800be3 <memmove>
	return r;
  801cac:	83 c4 10             	add    $0x10,%esp
}
  801caf:	89 d8                	mov    %ebx,%eax
  801cb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb4:	5b                   	pop    %ebx
  801cb5:	5e                   	pop    %esi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
	assert(r <= n);
  801cb8:	68 00 30 80 00       	push   $0x803000
  801cbd:	68 07 30 80 00       	push   $0x803007
  801cc2:	6a 7c                	push   $0x7c
  801cc4:	68 1c 30 80 00       	push   $0x80301c
  801cc9:	e8 6e e6 ff ff       	call   80033c <_panic>
	assert(r <= PGSIZE);
  801cce:	68 27 30 80 00       	push   $0x803027
  801cd3:	68 07 30 80 00       	push   $0x803007
  801cd8:	6a 7d                	push   $0x7d
  801cda:	68 1c 30 80 00       	push   $0x80301c
  801cdf:	e8 58 e6 ff ff       	call   80033c <_panic>

00801ce4 <open>:
{
  801ce4:	f3 0f 1e fb          	endbr32 
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	56                   	push   %esi
  801cec:	53                   	push   %ebx
  801ced:	83 ec 1c             	sub    $0x1c,%esp
  801cf0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cf3:	56                   	push   %esi
  801cf4:	e8 f1 ec ff ff       	call   8009ea <strlen>
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d01:	7f 6c                	jg     801d6f <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801d03:	83 ec 0c             	sub    $0xc,%esp
  801d06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d09:	50                   	push   %eax
  801d0a:	e8 62 f8 ff ff       	call   801571 <fd_alloc>
  801d0f:	89 c3                	mov    %eax,%ebx
  801d11:	83 c4 10             	add    $0x10,%esp
  801d14:	85 c0                	test   %eax,%eax
  801d16:	78 3c                	js     801d54 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801d18:	83 ec 08             	sub    $0x8,%esp
  801d1b:	56                   	push   %esi
  801d1c:	68 00 60 80 00       	push   $0x806000
  801d21:	e8 07 ed ff ff       	call   800a2d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d29:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d31:	b8 01 00 00 00       	mov    $0x1,%eax
  801d36:	e8 db fd ff ff       	call   801b16 <fsipc>
  801d3b:	89 c3                	mov    %eax,%ebx
  801d3d:	83 c4 10             	add    $0x10,%esp
  801d40:	85 c0                	test   %eax,%eax
  801d42:	78 19                	js     801d5d <open+0x79>
	return fd2num(fd);
  801d44:	83 ec 0c             	sub    $0xc,%esp
  801d47:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4a:	e8 f3 f7 ff ff       	call   801542 <fd2num>
  801d4f:	89 c3                	mov    %eax,%ebx
  801d51:	83 c4 10             	add    $0x10,%esp
}
  801d54:	89 d8                	mov    %ebx,%eax
  801d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d59:	5b                   	pop    %ebx
  801d5a:	5e                   	pop    %esi
  801d5b:	5d                   	pop    %ebp
  801d5c:	c3                   	ret    
		fd_close(fd, 0);
  801d5d:	83 ec 08             	sub    $0x8,%esp
  801d60:	6a 00                	push   $0x0
  801d62:	ff 75 f4             	pushl  -0xc(%ebp)
  801d65:	e8 10 f9 ff ff       	call   80167a <fd_close>
		return r;
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	eb e5                	jmp    801d54 <open+0x70>
		return -E_BAD_PATH;
  801d6f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d74:	eb de                	jmp    801d54 <open+0x70>

00801d76 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d76:	f3 0f 1e fb          	endbr32 
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d80:	ba 00 00 00 00       	mov    $0x0,%edx
  801d85:	b8 08 00 00 00       	mov    $0x8,%eax
  801d8a:	e8 87 fd ff ff       	call   801b16 <fsipc>
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d91:	f3 0f 1e fb          	endbr32 
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d9b:	68 33 30 80 00       	push   $0x803033
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	e8 85 ec ff ff       	call   800a2d <strcpy>
	return 0;
}
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <devsock_close>:
{
  801daf:	f3 0f 1e fb          	endbr32 
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	53                   	push   %ebx
  801db7:	83 ec 10             	sub    $0x10,%esp
  801dba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dbd:	53                   	push   %ebx
  801dbe:	e8 1a 0a 00 00       	call   8027dd <pageref>
  801dc3:	89 c2                	mov    %eax,%edx
  801dc5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801dcd:	83 fa 01             	cmp    $0x1,%edx
  801dd0:	74 05                	je     801dd7 <devsock_close+0x28>
}
  801dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dd7:	83 ec 0c             	sub    $0xc,%esp
  801dda:	ff 73 0c             	pushl  0xc(%ebx)
  801ddd:	e8 e3 02 00 00       	call   8020c5 <nsipc_close>
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	eb eb                	jmp    801dd2 <devsock_close+0x23>

00801de7 <devsock_write>:
{
  801de7:	f3 0f 1e fb          	endbr32 
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	ff 75 10             	pushl  0x10(%ebp)
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	ff 70 0c             	pushl  0xc(%eax)
  801dff:	e8 b5 03 00 00       	call   8021b9 <nsipc_send>
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <devsock_read>:
{
  801e06:	f3 0f 1e fb          	endbr32 
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	ff 75 10             	pushl  0x10(%ebp)
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	ff 70 0c             	pushl  0xc(%eax)
  801e1e:	e8 1f 03 00 00       	call   802142 <nsipc_recv>
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <fd2sockid>:
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e2b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e2e:	52                   	push   %edx
  801e2f:	50                   	push   %eax
  801e30:	e8 92 f7 ff ff       	call   8015c7 <fd_lookup>
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 10                	js     801e4c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3f:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e45:	39 08                	cmp    %ecx,(%eax)
  801e47:	75 05                	jne    801e4e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e49:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    
		return -E_NOT_SUPP;
  801e4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e53:	eb f7                	jmp    801e4c <fd2sockid+0x27>

00801e55 <alloc_sockfd>:
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	56                   	push   %esi
  801e59:	53                   	push   %ebx
  801e5a:	83 ec 1c             	sub    $0x1c,%esp
  801e5d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e62:	50                   	push   %eax
  801e63:	e8 09 f7 ff ff       	call   801571 <fd_alloc>
  801e68:	89 c3                	mov    %eax,%ebx
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	85 c0                	test   %eax,%eax
  801e6f:	78 43                	js     801eb4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	68 07 04 00 00       	push   $0x407
  801e79:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7c:	6a 00                	push   $0x0
  801e7e:	e8 ec ef ff ff       	call   800e6f <sys_page_alloc>
  801e83:	89 c3                	mov    %eax,%ebx
  801e85:	83 c4 10             	add    $0x10,%esp
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	78 28                	js     801eb4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8f:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e95:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ea1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	50                   	push   %eax
  801ea8:	e8 95 f6 ff ff       	call   801542 <fd2num>
  801ead:	89 c3                	mov    %eax,%ebx
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	eb 0c                	jmp    801ec0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	56                   	push   %esi
  801eb8:	e8 08 02 00 00       	call   8020c5 <nsipc_close>
		return r;
  801ebd:	83 c4 10             	add    $0x10,%esp
}
  801ec0:	89 d8                	mov    %ebx,%eax
  801ec2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec5:	5b                   	pop    %ebx
  801ec6:	5e                   	pop    %esi
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    

00801ec9 <accept>:
{
  801ec9:	f3 0f 1e fb          	endbr32 
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	e8 4a ff ff ff       	call   801e25 <fd2sockid>
  801edb:	85 c0                	test   %eax,%eax
  801edd:	78 1b                	js     801efa <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	ff 75 10             	pushl  0x10(%ebp)
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	50                   	push   %eax
  801ee9:	e8 22 01 00 00       	call   802010 <nsipc_accept>
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	78 05                	js     801efa <accept+0x31>
	return alloc_sockfd(r);
  801ef5:	e8 5b ff ff ff       	call   801e55 <alloc_sockfd>
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <bind>:
{
  801efc:	f3 0f 1e fb          	endbr32 
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	e8 17 ff ff ff       	call   801e25 <fd2sockid>
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	78 12                	js     801f24 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	ff 75 10             	pushl  0x10(%ebp)
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	50                   	push   %eax
  801f1c:	e8 45 01 00 00       	call   802066 <nsipc_bind>
  801f21:	83 c4 10             	add    $0x10,%esp
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <shutdown>:
{
  801f26:	f3 0f 1e fb          	endbr32 
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	e8 ed fe ff ff       	call   801e25 <fd2sockid>
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	78 0f                	js     801f4b <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801f3c:	83 ec 08             	sub    $0x8,%esp
  801f3f:	ff 75 0c             	pushl  0xc(%ebp)
  801f42:	50                   	push   %eax
  801f43:	e8 57 01 00 00       	call   80209f <nsipc_shutdown>
  801f48:	83 c4 10             	add    $0x10,%esp
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <connect>:
{
  801f4d:	f3 0f 1e fb          	endbr32 
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	e8 c6 fe ff ff       	call   801e25 <fd2sockid>
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 12                	js     801f75 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801f63:	83 ec 04             	sub    $0x4,%esp
  801f66:	ff 75 10             	pushl  0x10(%ebp)
  801f69:	ff 75 0c             	pushl  0xc(%ebp)
  801f6c:	50                   	push   %eax
  801f6d:	e8 71 01 00 00       	call   8020e3 <nsipc_connect>
  801f72:	83 c4 10             	add    $0x10,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <listen>:
{
  801f77:	f3 0f 1e fb          	endbr32 
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	e8 9c fe ff ff       	call   801e25 <fd2sockid>
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 0f                	js     801f9c <listen+0x25>
	return nsipc_listen(r, backlog);
  801f8d:	83 ec 08             	sub    $0x8,%esp
  801f90:	ff 75 0c             	pushl  0xc(%ebp)
  801f93:	50                   	push   %eax
  801f94:	e8 83 01 00 00       	call   80211c <nsipc_listen>
  801f99:	83 c4 10             	add    $0x10,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <socket>:

int
socket(int domain, int type, int protocol)
{
  801f9e:	f3 0f 1e fb          	endbr32 
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fa8:	ff 75 10             	pushl  0x10(%ebp)
  801fab:	ff 75 0c             	pushl  0xc(%ebp)
  801fae:	ff 75 08             	pushl  0x8(%ebp)
  801fb1:	e8 65 02 00 00       	call   80221b <nsipc_socket>
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	78 05                	js     801fc2 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801fbd:	e8 93 fe ff ff       	call   801e55 <alloc_sockfd>
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	53                   	push   %ebx
  801fc8:	83 ec 04             	sub    $0x4,%esp
  801fcb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fcd:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  801fd4:	74 26                	je     801ffc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fd6:	6a 07                	push   $0x7
  801fd8:	68 00 70 80 00       	push   $0x807000
  801fdd:	53                   	push   %ebx
  801fde:	ff 35 08 50 80 00    	pushl  0x805008
  801fe4:	e8 c4 f4 ff ff       	call   8014ad <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fe9:	83 c4 0c             	add    $0xc,%esp
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	e8 31 f4 ff ff       	call   801428 <ipc_recv>
}
  801ff7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ffc:	83 ec 0c             	sub    $0xc,%esp
  801fff:	6a 02                	push   $0x2
  802001:	e8 ff f4 ff ff       	call   801505 <ipc_find_env>
  802006:	a3 08 50 80 00       	mov    %eax,0x805008
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	eb c6                	jmp    801fd6 <nsipc+0x12>

00802010 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802010:	f3 0f 1e fb          	endbr32 
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	56                   	push   %esi
  802018:	53                   	push   %ebx
  802019:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802024:	8b 06                	mov    (%esi),%eax
  802026:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80202b:	b8 01 00 00 00       	mov    $0x1,%eax
  802030:	e8 8f ff ff ff       	call   801fc4 <nsipc>
  802035:	89 c3                	mov    %eax,%ebx
  802037:	85 c0                	test   %eax,%eax
  802039:	79 09                	jns    802044 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80203b:	89 d8                	mov    %ebx,%eax
  80203d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802044:	83 ec 04             	sub    $0x4,%esp
  802047:	ff 35 10 70 80 00    	pushl  0x807010
  80204d:	68 00 70 80 00       	push   $0x807000
  802052:	ff 75 0c             	pushl  0xc(%ebp)
  802055:	e8 89 eb ff ff       	call   800be3 <memmove>
		*addrlen = ret->ret_addrlen;
  80205a:	a1 10 70 80 00       	mov    0x807010,%eax
  80205f:	89 06                	mov    %eax,(%esi)
  802061:	83 c4 10             	add    $0x10,%esp
	return r;
  802064:	eb d5                	jmp    80203b <nsipc_accept+0x2b>

00802066 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802066:	f3 0f 1e fb          	endbr32 
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	53                   	push   %ebx
  80206e:	83 ec 08             	sub    $0x8,%esp
  802071:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80207c:	53                   	push   %ebx
  80207d:	ff 75 0c             	pushl  0xc(%ebp)
  802080:	68 04 70 80 00       	push   $0x807004
  802085:	e8 59 eb ff ff       	call   800be3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80208a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802090:	b8 02 00 00 00       	mov    $0x2,%eax
  802095:	e8 2a ff ff ff       	call   801fc4 <nsipc>
}
  80209a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80209f:	f3 0f 1e fb          	endbr32 
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b4:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8020be:	e8 01 ff ff ff       	call   801fc4 <nsipc>
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <nsipc_close>:

int
nsipc_close(int s)
{
  8020c5:	f3 0f 1e fb          	endbr32 
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020d7:	b8 04 00 00 00       	mov    $0x4,%eax
  8020dc:	e8 e3 fe ff ff       	call   801fc4 <nsipc>
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020e3:	f3 0f 1e fb          	endbr32 
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	53                   	push   %ebx
  8020eb:	83 ec 08             	sub    $0x8,%esp
  8020ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020f9:	53                   	push   %ebx
  8020fa:	ff 75 0c             	pushl  0xc(%ebp)
  8020fd:	68 04 70 80 00       	push   $0x807004
  802102:	e8 dc ea ff ff       	call   800be3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802107:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80210d:	b8 05 00 00 00       	mov    $0x5,%eax
  802112:	e8 ad fe ff ff       	call   801fc4 <nsipc>
}
  802117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80211c:	f3 0f 1e fb          	endbr32 
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802136:	b8 06 00 00 00       	mov    $0x6,%eax
  80213b:	e8 84 fe ff ff       	call   801fc4 <nsipc>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802142:	f3 0f 1e fb          	endbr32 
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	56                   	push   %esi
  80214a:	53                   	push   %ebx
  80214b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802156:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80215c:	8b 45 14             	mov    0x14(%ebp),%eax
  80215f:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802164:	b8 07 00 00 00       	mov    $0x7,%eax
  802169:	e8 56 fe ff ff       	call   801fc4 <nsipc>
  80216e:	89 c3                	mov    %eax,%ebx
  802170:	85 c0                	test   %eax,%eax
  802172:	78 26                	js     80219a <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802174:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80217a:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80217f:	0f 4e c6             	cmovle %esi,%eax
  802182:	39 c3                	cmp    %eax,%ebx
  802184:	7f 1d                	jg     8021a3 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802186:	83 ec 04             	sub    $0x4,%esp
  802189:	53                   	push   %ebx
  80218a:	68 00 70 80 00       	push   $0x807000
  80218f:	ff 75 0c             	pushl  0xc(%ebp)
  802192:	e8 4c ea ff ff       	call   800be3 <memmove>
  802197:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80219a:	89 d8                	mov    %ebx,%eax
  80219c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5d                   	pop    %ebp
  8021a2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021a3:	68 3f 30 80 00       	push   $0x80303f
  8021a8:	68 07 30 80 00       	push   $0x803007
  8021ad:	6a 62                	push   $0x62
  8021af:	68 54 30 80 00       	push   $0x803054
  8021b4:	e8 83 e1 ff ff       	call   80033c <_panic>

008021b9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021b9:	f3 0f 1e fb          	endbr32 
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	53                   	push   %ebx
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021cf:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021d5:	7f 2e                	jg     802205 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	53                   	push   %ebx
  8021db:	ff 75 0c             	pushl  0xc(%ebp)
  8021de:	68 0c 70 80 00       	push   $0x80700c
  8021e3:	e8 fb e9 ff ff       	call   800be3 <memmove>
	nsipcbuf.send.req_size = size;
  8021e8:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021f6:	b8 08 00 00 00       	mov    $0x8,%eax
  8021fb:	e8 c4 fd ff ff       	call   801fc4 <nsipc>
}
  802200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802203:	c9                   	leave  
  802204:	c3                   	ret    
	assert(size < 1600);
  802205:	68 60 30 80 00       	push   $0x803060
  80220a:	68 07 30 80 00       	push   $0x803007
  80220f:	6a 6d                	push   $0x6d
  802211:	68 54 30 80 00       	push   $0x803054
  802216:	e8 21 e1 ff ff       	call   80033c <_panic>

0080221b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80221b:	f3 0f 1e fb          	endbr32 
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80222d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802230:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802235:	8b 45 10             	mov    0x10(%ebp),%eax
  802238:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80223d:	b8 09 00 00 00       	mov    $0x9,%eax
  802242:	e8 7d fd ff ff       	call   801fc4 <nsipc>
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802249:	f3 0f 1e fb          	endbr32 
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	56                   	push   %esi
  802251:	53                   	push   %ebx
  802252:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	e8 f6 f2 ff ff       	call   801556 <fd2data>
  802260:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802262:	83 c4 08             	add    $0x8,%esp
  802265:	68 6c 30 80 00       	push   $0x80306c
  80226a:	53                   	push   %ebx
  80226b:	e8 bd e7 ff ff       	call   800a2d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802270:	8b 46 04             	mov    0x4(%esi),%eax
  802273:	2b 06                	sub    (%esi),%eax
  802275:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80227b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802282:	00 00 00 
	stat->st_dev = &devpipe;
  802285:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80228c:	40 80 00 
	return 0;
}
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
  802294:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5d                   	pop    %ebp
  80229a:	c3                   	ret    

0080229b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80229b:	f3 0f 1e fb          	endbr32 
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	53                   	push   %ebx
  8022a3:	83 ec 0c             	sub    $0xc,%esp
  8022a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022a9:	53                   	push   %ebx
  8022aa:	6a 00                	push   $0x0
  8022ac:	e8 4b ec ff ff       	call   800efc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022b1:	89 1c 24             	mov    %ebx,(%esp)
  8022b4:	e8 9d f2 ff ff       	call   801556 <fd2data>
  8022b9:	83 c4 08             	add    $0x8,%esp
  8022bc:	50                   	push   %eax
  8022bd:	6a 00                	push   $0x0
  8022bf:	e8 38 ec ff ff       	call   800efc <sys_page_unmap>
}
  8022c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <_pipeisclosed>:
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	57                   	push   %edi
  8022cd:	56                   	push   %esi
  8022ce:	53                   	push   %ebx
  8022cf:	83 ec 1c             	sub    $0x1c,%esp
  8022d2:	89 c7                	mov    %eax,%edi
  8022d4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022d6:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8022db:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022de:	83 ec 0c             	sub    $0xc,%esp
  8022e1:	57                   	push   %edi
  8022e2:	e8 f6 04 00 00       	call   8027dd <pageref>
  8022e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022ea:	89 34 24             	mov    %esi,(%esp)
  8022ed:	e8 eb 04 00 00       	call   8027dd <pageref>
		nn = thisenv->env_runs;
  8022f2:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8022f8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022fb:	83 c4 10             	add    $0x10,%esp
  8022fe:	39 cb                	cmp    %ecx,%ebx
  802300:	74 1b                	je     80231d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802302:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802305:	75 cf                	jne    8022d6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802307:	8b 42 58             	mov    0x58(%edx),%eax
  80230a:	6a 01                	push   $0x1
  80230c:	50                   	push   %eax
  80230d:	53                   	push   %ebx
  80230e:	68 73 30 80 00       	push   $0x803073
  802313:	e8 0b e1 ff ff       	call   800423 <cprintf>
  802318:	83 c4 10             	add    $0x10,%esp
  80231b:	eb b9                	jmp    8022d6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80231d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802320:	0f 94 c0             	sete   %al
  802323:	0f b6 c0             	movzbl %al,%eax
}
  802326:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802329:	5b                   	pop    %ebx
  80232a:	5e                   	pop    %esi
  80232b:	5f                   	pop    %edi
  80232c:	5d                   	pop    %ebp
  80232d:	c3                   	ret    

0080232e <devpipe_write>:
{
  80232e:	f3 0f 1e fb          	endbr32 
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	57                   	push   %edi
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
  802338:	83 ec 28             	sub    $0x28,%esp
  80233b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80233e:	56                   	push   %esi
  80233f:	e8 12 f2 ff ff       	call   801556 <fd2data>
  802344:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802346:	83 c4 10             	add    $0x10,%esp
  802349:	bf 00 00 00 00       	mov    $0x0,%edi
  80234e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802351:	74 4f                	je     8023a2 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802353:	8b 43 04             	mov    0x4(%ebx),%eax
  802356:	8b 0b                	mov    (%ebx),%ecx
  802358:	8d 51 20             	lea    0x20(%ecx),%edx
  80235b:	39 d0                	cmp    %edx,%eax
  80235d:	72 14                	jb     802373 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80235f:	89 da                	mov    %ebx,%edx
  802361:	89 f0                	mov    %esi,%eax
  802363:	e8 61 ff ff ff       	call   8022c9 <_pipeisclosed>
  802368:	85 c0                	test   %eax,%eax
  80236a:	75 3b                	jne    8023a7 <devpipe_write+0x79>
			sys_yield();
  80236c:	e8 db ea ff ff       	call   800e4c <sys_yield>
  802371:	eb e0                	jmp    802353 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802373:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802376:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80237a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80237d:	89 c2                	mov    %eax,%edx
  80237f:	c1 fa 1f             	sar    $0x1f,%edx
  802382:	89 d1                	mov    %edx,%ecx
  802384:	c1 e9 1b             	shr    $0x1b,%ecx
  802387:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80238a:	83 e2 1f             	and    $0x1f,%edx
  80238d:	29 ca                	sub    %ecx,%edx
  80238f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802393:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802397:	83 c0 01             	add    $0x1,%eax
  80239a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80239d:	83 c7 01             	add    $0x1,%edi
  8023a0:	eb ac                	jmp    80234e <devpipe_write+0x20>
	return i;
  8023a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a5:	eb 05                	jmp    8023ac <devpipe_write+0x7e>
				return 0;
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5f                   	pop    %edi
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    

008023b4 <devpipe_read>:
{
  8023b4:	f3 0f 1e fb          	endbr32 
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	57                   	push   %edi
  8023bc:	56                   	push   %esi
  8023bd:	53                   	push   %ebx
  8023be:	83 ec 18             	sub    $0x18,%esp
  8023c1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023c4:	57                   	push   %edi
  8023c5:	e8 8c f1 ff ff       	call   801556 <fd2data>
  8023ca:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	be 00 00 00 00       	mov    $0x0,%esi
  8023d4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023d7:	75 14                	jne    8023ed <devpipe_read+0x39>
	return i;
  8023d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023dc:	eb 02                	jmp    8023e0 <devpipe_read+0x2c>
				return i;
  8023de:	89 f0                	mov    %esi,%eax
}
  8023e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023e3:	5b                   	pop    %ebx
  8023e4:	5e                   	pop    %esi
  8023e5:	5f                   	pop    %edi
  8023e6:	5d                   	pop    %ebp
  8023e7:	c3                   	ret    
			sys_yield();
  8023e8:	e8 5f ea ff ff       	call   800e4c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023ed:	8b 03                	mov    (%ebx),%eax
  8023ef:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023f2:	75 18                	jne    80240c <devpipe_read+0x58>
			if (i > 0)
  8023f4:	85 f6                	test   %esi,%esi
  8023f6:	75 e6                	jne    8023de <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8023f8:	89 da                	mov    %ebx,%edx
  8023fa:	89 f8                	mov    %edi,%eax
  8023fc:	e8 c8 fe ff ff       	call   8022c9 <_pipeisclosed>
  802401:	85 c0                	test   %eax,%eax
  802403:	74 e3                	je     8023e8 <devpipe_read+0x34>
				return 0;
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
  80240a:	eb d4                	jmp    8023e0 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80240c:	99                   	cltd   
  80240d:	c1 ea 1b             	shr    $0x1b,%edx
  802410:	01 d0                	add    %edx,%eax
  802412:	83 e0 1f             	and    $0x1f,%eax
  802415:	29 d0                	sub    %edx,%eax
  802417:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80241c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80241f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802422:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802425:	83 c6 01             	add    $0x1,%esi
  802428:	eb aa                	jmp    8023d4 <devpipe_read+0x20>

0080242a <pipe>:
{
  80242a:	f3 0f 1e fb          	endbr32 
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	56                   	push   %esi
  802432:	53                   	push   %ebx
  802433:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802436:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802439:	50                   	push   %eax
  80243a:	e8 32 f1 ff ff       	call   801571 <fd_alloc>
  80243f:	89 c3                	mov    %eax,%ebx
  802441:	83 c4 10             	add    $0x10,%esp
  802444:	85 c0                	test   %eax,%eax
  802446:	0f 88 23 01 00 00    	js     80256f <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	68 07 04 00 00       	push   $0x407
  802454:	ff 75 f4             	pushl  -0xc(%ebp)
  802457:	6a 00                	push   $0x0
  802459:	e8 11 ea ff ff       	call   800e6f <sys_page_alloc>
  80245e:	89 c3                	mov    %eax,%ebx
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	85 c0                	test   %eax,%eax
  802465:	0f 88 04 01 00 00    	js     80256f <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80246b:	83 ec 0c             	sub    $0xc,%esp
  80246e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802471:	50                   	push   %eax
  802472:	e8 fa f0 ff ff       	call   801571 <fd_alloc>
  802477:	89 c3                	mov    %eax,%ebx
  802479:	83 c4 10             	add    $0x10,%esp
  80247c:	85 c0                	test   %eax,%eax
  80247e:	0f 88 db 00 00 00    	js     80255f <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802484:	83 ec 04             	sub    $0x4,%esp
  802487:	68 07 04 00 00       	push   $0x407
  80248c:	ff 75 f0             	pushl  -0x10(%ebp)
  80248f:	6a 00                	push   $0x0
  802491:	e8 d9 e9 ff ff       	call   800e6f <sys_page_alloc>
  802496:	89 c3                	mov    %eax,%ebx
  802498:	83 c4 10             	add    $0x10,%esp
  80249b:	85 c0                	test   %eax,%eax
  80249d:	0f 88 bc 00 00 00    	js     80255f <pipe+0x135>
	va = fd2data(fd0);
  8024a3:	83 ec 0c             	sub    $0xc,%esp
  8024a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8024a9:	e8 a8 f0 ff ff       	call   801556 <fd2data>
  8024ae:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024b0:	83 c4 0c             	add    $0xc,%esp
  8024b3:	68 07 04 00 00       	push   $0x407
  8024b8:	50                   	push   %eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	e8 af e9 ff ff       	call   800e6f <sys_page_alloc>
  8024c0:	89 c3                	mov    %eax,%ebx
  8024c2:	83 c4 10             	add    $0x10,%esp
  8024c5:	85 c0                	test   %eax,%eax
  8024c7:	0f 88 82 00 00 00    	js     80254f <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024cd:	83 ec 0c             	sub    $0xc,%esp
  8024d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8024d3:	e8 7e f0 ff ff       	call   801556 <fd2data>
  8024d8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024df:	50                   	push   %eax
  8024e0:	6a 00                	push   $0x0
  8024e2:	56                   	push   %esi
  8024e3:	6a 00                	push   $0x0
  8024e5:	e8 cc e9 ff ff       	call   800eb6 <sys_page_map>
  8024ea:	89 c3                	mov    %eax,%ebx
  8024ec:	83 c4 20             	add    $0x20,%esp
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	78 4e                	js     802541 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8024f3:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802500:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802507:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80250c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802516:	83 ec 0c             	sub    $0xc,%esp
  802519:	ff 75 f4             	pushl  -0xc(%ebp)
  80251c:	e8 21 f0 ff ff       	call   801542 <fd2num>
  802521:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802524:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802526:	83 c4 04             	add    $0x4,%esp
  802529:	ff 75 f0             	pushl  -0x10(%ebp)
  80252c:	e8 11 f0 ff ff       	call   801542 <fd2num>
  802531:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802534:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802537:	83 c4 10             	add    $0x10,%esp
  80253a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80253f:	eb 2e                	jmp    80256f <pipe+0x145>
	sys_page_unmap(0, va);
  802541:	83 ec 08             	sub    $0x8,%esp
  802544:	56                   	push   %esi
  802545:	6a 00                	push   $0x0
  802547:	e8 b0 e9 ff ff       	call   800efc <sys_page_unmap>
  80254c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80254f:	83 ec 08             	sub    $0x8,%esp
  802552:	ff 75 f0             	pushl  -0x10(%ebp)
  802555:	6a 00                	push   $0x0
  802557:	e8 a0 e9 ff ff       	call   800efc <sys_page_unmap>
  80255c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80255f:	83 ec 08             	sub    $0x8,%esp
  802562:	ff 75 f4             	pushl  -0xc(%ebp)
  802565:	6a 00                	push   $0x0
  802567:	e8 90 e9 ff ff       	call   800efc <sys_page_unmap>
  80256c:	83 c4 10             	add    $0x10,%esp
}
  80256f:	89 d8                	mov    %ebx,%eax
  802571:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802574:	5b                   	pop    %ebx
  802575:	5e                   	pop    %esi
  802576:	5d                   	pop    %ebp
  802577:	c3                   	ret    

00802578 <pipeisclosed>:
{
  802578:	f3 0f 1e fb          	endbr32 
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802582:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802585:	50                   	push   %eax
  802586:	ff 75 08             	pushl  0x8(%ebp)
  802589:	e8 39 f0 ff ff       	call   8015c7 <fd_lookup>
  80258e:	83 c4 10             	add    $0x10,%esp
  802591:	85 c0                	test   %eax,%eax
  802593:	78 18                	js     8025ad <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802595:	83 ec 0c             	sub    $0xc,%esp
  802598:	ff 75 f4             	pushl  -0xc(%ebp)
  80259b:	e8 b6 ef ff ff       	call   801556 <fd2data>
  8025a0:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	e8 1f fd ff ff       	call   8022c9 <_pipeisclosed>
  8025aa:	83 c4 10             	add    $0x10,%esp
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025af:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	c3                   	ret    

008025b9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025b9:	f3 0f 1e fb          	endbr32 
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025c3:	68 8b 30 80 00       	push   $0x80308b
  8025c8:	ff 75 0c             	pushl  0xc(%ebp)
  8025cb:	e8 5d e4 ff ff       	call   800a2d <strcpy>
	return 0;
}
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <devcons_write>:
{
  8025d7:	f3 0f 1e fb          	endbr32 
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	57                   	push   %edi
  8025df:	56                   	push   %esi
  8025e0:	53                   	push   %ebx
  8025e1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8025e7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025ec:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025f2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025f5:	73 31                	jae    802628 <devcons_write+0x51>
		m = n - tot;
  8025f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025fa:	29 f3                	sub    %esi,%ebx
  8025fc:	83 fb 7f             	cmp    $0x7f,%ebx
  8025ff:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802604:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802607:	83 ec 04             	sub    $0x4,%esp
  80260a:	53                   	push   %ebx
  80260b:	89 f0                	mov    %esi,%eax
  80260d:	03 45 0c             	add    0xc(%ebp),%eax
  802610:	50                   	push   %eax
  802611:	57                   	push   %edi
  802612:	e8 cc e5 ff ff       	call   800be3 <memmove>
		sys_cputs(buf, m);
  802617:	83 c4 08             	add    $0x8,%esp
  80261a:	53                   	push   %ebx
  80261b:	57                   	push   %edi
  80261c:	e8 7e e7 ff ff       	call   800d9f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802621:	01 de                	add    %ebx,%esi
  802623:	83 c4 10             	add    $0x10,%esp
  802626:	eb ca                	jmp    8025f2 <devcons_write+0x1b>
}
  802628:	89 f0                	mov    %esi,%eax
  80262a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80262d:	5b                   	pop    %ebx
  80262e:	5e                   	pop    %esi
  80262f:	5f                   	pop    %edi
  802630:	5d                   	pop    %ebp
  802631:	c3                   	ret    

00802632 <devcons_read>:
{
  802632:	f3 0f 1e fb          	endbr32 
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 08             	sub    $0x8,%esp
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802641:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802645:	74 21                	je     802668 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802647:	e8 75 e7 ff ff       	call   800dc1 <sys_cgetc>
  80264c:	85 c0                	test   %eax,%eax
  80264e:	75 07                	jne    802657 <devcons_read+0x25>
		sys_yield();
  802650:	e8 f7 e7 ff ff       	call   800e4c <sys_yield>
  802655:	eb f0                	jmp    802647 <devcons_read+0x15>
	if (c < 0)
  802657:	78 0f                	js     802668 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802659:	83 f8 04             	cmp    $0x4,%eax
  80265c:	74 0c                	je     80266a <devcons_read+0x38>
	*(char*)vbuf = c;
  80265e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802661:	88 02                	mov    %al,(%edx)
	return 1;
  802663:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802668:	c9                   	leave  
  802669:	c3                   	ret    
		return 0;
  80266a:	b8 00 00 00 00       	mov    $0x0,%eax
  80266f:	eb f7                	jmp    802668 <devcons_read+0x36>

00802671 <cputchar>:
{
  802671:	f3 0f 1e fb          	endbr32 
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802681:	6a 01                	push   $0x1
  802683:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802686:	50                   	push   %eax
  802687:	e8 13 e7 ff ff       	call   800d9f <sys_cputs>
}
  80268c:	83 c4 10             	add    $0x10,%esp
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <getchar>:
{
  802691:	f3 0f 1e fb          	endbr32 
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80269b:	6a 01                	push   $0x1
  80269d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026a0:	50                   	push   %eax
  8026a1:	6a 00                	push   $0x0
  8026a3:	e8 a7 f1 ff ff       	call   80184f <read>
	if (r < 0)
  8026a8:	83 c4 10             	add    $0x10,%esp
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	78 06                	js     8026b5 <getchar+0x24>
	if (r < 1)
  8026af:	74 06                	je     8026b7 <getchar+0x26>
	return c;
  8026b1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    
		return -E_EOF;
  8026b7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026bc:	eb f7                	jmp    8026b5 <getchar+0x24>

008026be <iscons>:
{
  8026be:	f3 0f 1e fb          	endbr32 
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026cb:	50                   	push   %eax
  8026cc:	ff 75 08             	pushl  0x8(%ebp)
  8026cf:	e8 f3 ee ff ff       	call   8015c7 <fd_lookup>
  8026d4:	83 c4 10             	add    $0x10,%esp
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	78 11                	js     8026ec <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026e4:	39 10                	cmp    %edx,(%eax)
  8026e6:	0f 94 c0             	sete   %al
  8026e9:	0f b6 c0             	movzbl %al,%eax
}
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <opencons>:
{
  8026ee:	f3 0f 1e fb          	endbr32 
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026fb:	50                   	push   %eax
  8026fc:	e8 70 ee ff ff       	call   801571 <fd_alloc>
  802701:	83 c4 10             	add    $0x10,%esp
  802704:	85 c0                	test   %eax,%eax
  802706:	78 3a                	js     802742 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802708:	83 ec 04             	sub    $0x4,%esp
  80270b:	68 07 04 00 00       	push   $0x407
  802710:	ff 75 f4             	pushl  -0xc(%ebp)
  802713:	6a 00                	push   $0x0
  802715:	e8 55 e7 ff ff       	call   800e6f <sys_page_alloc>
  80271a:	83 c4 10             	add    $0x10,%esp
  80271d:	85 c0                	test   %eax,%eax
  80271f:	78 21                	js     802742 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80272a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802736:	83 ec 0c             	sub    $0xc,%esp
  802739:	50                   	push   %eax
  80273a:	e8 03 ee ff ff       	call   801542 <fd2num>
  80273f:	83 c4 10             	add    $0x10,%esp
}
  802742:	c9                   	leave  
  802743:	c3                   	ret    

00802744 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802744:	f3 0f 1e fb          	endbr32 
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80274e:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802755:	74 0a                	je     802761 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802757:	8b 45 08             	mov    0x8(%ebp),%eax
  80275a:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80275f:	c9                   	leave  
  802760:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	6a 07                	push   $0x7
  802766:	68 00 f0 bf ee       	push   $0xeebff000
  80276b:	6a 00                	push   $0x0
  80276d:	e8 fd e6 ff ff       	call   800e6f <sys_page_alloc>
  802772:	83 c4 10             	add    $0x10,%esp
  802775:	85 c0                	test   %eax,%eax
  802777:	78 2a                	js     8027a3 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802779:	83 ec 08             	sub    $0x8,%esp
  80277c:	68 b7 27 80 00       	push   $0x8027b7
  802781:	6a 00                	push   $0x0
  802783:	e8 46 e8 ff ff       	call   800fce <sys_env_set_pgfault_upcall>
  802788:	83 c4 10             	add    $0x10,%esp
  80278b:	85 c0                	test   %eax,%eax
  80278d:	79 c8                	jns    802757 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80278f:	83 ec 04             	sub    $0x4,%esp
  802792:	68 c4 30 80 00       	push   $0x8030c4
  802797:	6a 25                	push   $0x25
  802799:	68 fc 30 80 00       	push   $0x8030fc
  80279e:	e8 99 db ff ff       	call   80033c <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8027a3:	83 ec 04             	sub    $0x4,%esp
  8027a6:	68 98 30 80 00       	push   $0x803098
  8027ab:	6a 22                	push   $0x22
  8027ad:	68 fc 30 80 00       	push   $0x8030fc
  8027b2:	e8 85 db ff ff       	call   80033c <_panic>

008027b7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027b7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027b8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027bd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027bf:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8027c2:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8027c6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8027ca:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027cd:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8027cf:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8027d3:	83 c4 08             	add    $0x8,%esp
	popal
  8027d6:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8027d7:	83 c4 04             	add    $0x4,%esp
	popfl
  8027da:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8027db:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8027dc:	c3                   	ret    

008027dd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027dd:	f3 0f 1e fb          	endbr32 
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027e7:	89 c2                	mov    %eax,%edx
  8027e9:	c1 ea 16             	shr    $0x16,%edx
  8027ec:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8027f3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8027f8:	f6 c1 01             	test   $0x1,%cl
  8027fb:	74 1c                	je     802819 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8027fd:	c1 e8 0c             	shr    $0xc,%eax
  802800:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802807:	a8 01                	test   $0x1,%al
  802809:	74 0e                	je     802819 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80280b:	c1 e8 0c             	shr    $0xc,%eax
  80280e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802815:	ef 
  802816:	0f b7 d2             	movzwl %dx,%edx
}
  802819:	89 d0                	mov    %edx,%eax
  80281b:	5d                   	pop    %ebp
  80281c:	c3                   	ret    
  80281d:	66 90                	xchg   %ax,%ax
  80281f:	90                   	nop

00802820 <__udivdi3>:
  802820:	f3 0f 1e fb          	endbr32 
  802824:	55                   	push   %ebp
  802825:	57                   	push   %edi
  802826:	56                   	push   %esi
  802827:	53                   	push   %ebx
  802828:	83 ec 1c             	sub    $0x1c,%esp
  80282b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80282f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802833:	8b 74 24 34          	mov    0x34(%esp),%esi
  802837:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80283b:	85 d2                	test   %edx,%edx
  80283d:	75 19                	jne    802858 <__udivdi3+0x38>
  80283f:	39 f3                	cmp    %esi,%ebx
  802841:	76 4d                	jbe    802890 <__udivdi3+0x70>
  802843:	31 ff                	xor    %edi,%edi
  802845:	89 e8                	mov    %ebp,%eax
  802847:	89 f2                	mov    %esi,%edx
  802849:	f7 f3                	div    %ebx
  80284b:	89 fa                	mov    %edi,%edx
  80284d:	83 c4 1c             	add    $0x1c,%esp
  802850:	5b                   	pop    %ebx
  802851:	5e                   	pop    %esi
  802852:	5f                   	pop    %edi
  802853:	5d                   	pop    %ebp
  802854:	c3                   	ret    
  802855:	8d 76 00             	lea    0x0(%esi),%esi
  802858:	39 f2                	cmp    %esi,%edx
  80285a:	76 14                	jbe    802870 <__udivdi3+0x50>
  80285c:	31 ff                	xor    %edi,%edi
  80285e:	31 c0                	xor    %eax,%eax
  802860:	89 fa                	mov    %edi,%edx
  802862:	83 c4 1c             	add    $0x1c,%esp
  802865:	5b                   	pop    %ebx
  802866:	5e                   	pop    %esi
  802867:	5f                   	pop    %edi
  802868:	5d                   	pop    %ebp
  802869:	c3                   	ret    
  80286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802870:	0f bd fa             	bsr    %edx,%edi
  802873:	83 f7 1f             	xor    $0x1f,%edi
  802876:	75 48                	jne    8028c0 <__udivdi3+0xa0>
  802878:	39 f2                	cmp    %esi,%edx
  80287a:	72 06                	jb     802882 <__udivdi3+0x62>
  80287c:	31 c0                	xor    %eax,%eax
  80287e:	39 eb                	cmp    %ebp,%ebx
  802880:	77 de                	ja     802860 <__udivdi3+0x40>
  802882:	b8 01 00 00 00       	mov    $0x1,%eax
  802887:	eb d7                	jmp    802860 <__udivdi3+0x40>
  802889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802890:	89 d9                	mov    %ebx,%ecx
  802892:	85 db                	test   %ebx,%ebx
  802894:	75 0b                	jne    8028a1 <__udivdi3+0x81>
  802896:	b8 01 00 00 00       	mov    $0x1,%eax
  80289b:	31 d2                	xor    %edx,%edx
  80289d:	f7 f3                	div    %ebx
  80289f:	89 c1                	mov    %eax,%ecx
  8028a1:	31 d2                	xor    %edx,%edx
  8028a3:	89 f0                	mov    %esi,%eax
  8028a5:	f7 f1                	div    %ecx
  8028a7:	89 c6                	mov    %eax,%esi
  8028a9:	89 e8                	mov    %ebp,%eax
  8028ab:	89 f7                	mov    %esi,%edi
  8028ad:	f7 f1                	div    %ecx
  8028af:	89 fa                	mov    %edi,%edx
  8028b1:	83 c4 1c             	add    $0x1c,%esp
  8028b4:	5b                   	pop    %ebx
  8028b5:	5e                   	pop    %esi
  8028b6:	5f                   	pop    %edi
  8028b7:	5d                   	pop    %ebp
  8028b8:	c3                   	ret    
  8028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028c0:	89 f9                	mov    %edi,%ecx
  8028c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028c7:	29 f8                	sub    %edi,%eax
  8028c9:	d3 e2                	shl    %cl,%edx
  8028cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028cf:	89 c1                	mov    %eax,%ecx
  8028d1:	89 da                	mov    %ebx,%edx
  8028d3:	d3 ea                	shr    %cl,%edx
  8028d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028d9:	09 d1                	or     %edx,%ecx
  8028db:	89 f2                	mov    %esi,%edx
  8028dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028e1:	89 f9                	mov    %edi,%ecx
  8028e3:	d3 e3                	shl    %cl,%ebx
  8028e5:	89 c1                	mov    %eax,%ecx
  8028e7:	d3 ea                	shr    %cl,%edx
  8028e9:	89 f9                	mov    %edi,%ecx
  8028eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028ef:	89 eb                	mov    %ebp,%ebx
  8028f1:	d3 e6                	shl    %cl,%esi
  8028f3:	89 c1                	mov    %eax,%ecx
  8028f5:	d3 eb                	shr    %cl,%ebx
  8028f7:	09 de                	or     %ebx,%esi
  8028f9:	89 f0                	mov    %esi,%eax
  8028fb:	f7 74 24 08          	divl   0x8(%esp)
  8028ff:	89 d6                	mov    %edx,%esi
  802901:	89 c3                	mov    %eax,%ebx
  802903:	f7 64 24 0c          	mull   0xc(%esp)
  802907:	39 d6                	cmp    %edx,%esi
  802909:	72 15                	jb     802920 <__udivdi3+0x100>
  80290b:	89 f9                	mov    %edi,%ecx
  80290d:	d3 e5                	shl    %cl,%ebp
  80290f:	39 c5                	cmp    %eax,%ebp
  802911:	73 04                	jae    802917 <__udivdi3+0xf7>
  802913:	39 d6                	cmp    %edx,%esi
  802915:	74 09                	je     802920 <__udivdi3+0x100>
  802917:	89 d8                	mov    %ebx,%eax
  802919:	31 ff                	xor    %edi,%edi
  80291b:	e9 40 ff ff ff       	jmp    802860 <__udivdi3+0x40>
  802920:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802923:	31 ff                	xor    %edi,%edi
  802925:	e9 36 ff ff ff       	jmp    802860 <__udivdi3+0x40>
  80292a:	66 90                	xchg   %ax,%ax
  80292c:	66 90                	xchg   %ax,%ax
  80292e:	66 90                	xchg   %ax,%ax

00802930 <__umoddi3>:
  802930:	f3 0f 1e fb          	endbr32 
  802934:	55                   	push   %ebp
  802935:	57                   	push   %edi
  802936:	56                   	push   %esi
  802937:	53                   	push   %ebx
  802938:	83 ec 1c             	sub    $0x1c,%esp
  80293b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80293f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802943:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802947:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80294b:	85 c0                	test   %eax,%eax
  80294d:	75 19                	jne    802968 <__umoddi3+0x38>
  80294f:	39 df                	cmp    %ebx,%edi
  802951:	76 5d                	jbe    8029b0 <__umoddi3+0x80>
  802953:	89 f0                	mov    %esi,%eax
  802955:	89 da                	mov    %ebx,%edx
  802957:	f7 f7                	div    %edi
  802959:	89 d0                	mov    %edx,%eax
  80295b:	31 d2                	xor    %edx,%edx
  80295d:	83 c4 1c             	add    $0x1c,%esp
  802960:	5b                   	pop    %ebx
  802961:	5e                   	pop    %esi
  802962:	5f                   	pop    %edi
  802963:	5d                   	pop    %ebp
  802964:	c3                   	ret    
  802965:	8d 76 00             	lea    0x0(%esi),%esi
  802968:	89 f2                	mov    %esi,%edx
  80296a:	39 d8                	cmp    %ebx,%eax
  80296c:	76 12                	jbe    802980 <__umoddi3+0x50>
  80296e:	89 f0                	mov    %esi,%eax
  802970:	89 da                	mov    %ebx,%edx
  802972:	83 c4 1c             	add    $0x1c,%esp
  802975:	5b                   	pop    %ebx
  802976:	5e                   	pop    %esi
  802977:	5f                   	pop    %edi
  802978:	5d                   	pop    %ebp
  802979:	c3                   	ret    
  80297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802980:	0f bd e8             	bsr    %eax,%ebp
  802983:	83 f5 1f             	xor    $0x1f,%ebp
  802986:	75 50                	jne    8029d8 <__umoddi3+0xa8>
  802988:	39 d8                	cmp    %ebx,%eax
  80298a:	0f 82 e0 00 00 00    	jb     802a70 <__umoddi3+0x140>
  802990:	89 d9                	mov    %ebx,%ecx
  802992:	39 f7                	cmp    %esi,%edi
  802994:	0f 86 d6 00 00 00    	jbe    802a70 <__umoddi3+0x140>
  80299a:	89 d0                	mov    %edx,%eax
  80299c:	89 ca                	mov    %ecx,%edx
  80299e:	83 c4 1c             	add    $0x1c,%esp
  8029a1:	5b                   	pop    %ebx
  8029a2:	5e                   	pop    %esi
  8029a3:	5f                   	pop    %edi
  8029a4:	5d                   	pop    %ebp
  8029a5:	c3                   	ret    
  8029a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029ad:	8d 76 00             	lea    0x0(%esi),%esi
  8029b0:	89 fd                	mov    %edi,%ebp
  8029b2:	85 ff                	test   %edi,%edi
  8029b4:	75 0b                	jne    8029c1 <__umoddi3+0x91>
  8029b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bb:	31 d2                	xor    %edx,%edx
  8029bd:	f7 f7                	div    %edi
  8029bf:	89 c5                	mov    %eax,%ebp
  8029c1:	89 d8                	mov    %ebx,%eax
  8029c3:	31 d2                	xor    %edx,%edx
  8029c5:	f7 f5                	div    %ebp
  8029c7:	89 f0                	mov    %esi,%eax
  8029c9:	f7 f5                	div    %ebp
  8029cb:	89 d0                	mov    %edx,%eax
  8029cd:	31 d2                	xor    %edx,%edx
  8029cf:	eb 8c                	jmp    80295d <__umoddi3+0x2d>
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	89 e9                	mov    %ebp,%ecx
  8029da:	ba 20 00 00 00       	mov    $0x20,%edx
  8029df:	29 ea                	sub    %ebp,%edx
  8029e1:	d3 e0                	shl    %cl,%eax
  8029e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029e7:	89 d1                	mov    %edx,%ecx
  8029e9:	89 f8                	mov    %edi,%eax
  8029eb:	d3 e8                	shr    %cl,%eax
  8029ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029f9:	09 c1                	or     %eax,%ecx
  8029fb:	89 d8                	mov    %ebx,%eax
  8029fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a01:	89 e9                	mov    %ebp,%ecx
  802a03:	d3 e7                	shl    %cl,%edi
  802a05:	89 d1                	mov    %edx,%ecx
  802a07:	d3 e8                	shr    %cl,%eax
  802a09:	89 e9                	mov    %ebp,%ecx
  802a0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a0f:	d3 e3                	shl    %cl,%ebx
  802a11:	89 c7                	mov    %eax,%edi
  802a13:	89 d1                	mov    %edx,%ecx
  802a15:	89 f0                	mov    %esi,%eax
  802a17:	d3 e8                	shr    %cl,%eax
  802a19:	89 e9                	mov    %ebp,%ecx
  802a1b:	89 fa                	mov    %edi,%edx
  802a1d:	d3 e6                	shl    %cl,%esi
  802a1f:	09 d8                	or     %ebx,%eax
  802a21:	f7 74 24 08          	divl   0x8(%esp)
  802a25:	89 d1                	mov    %edx,%ecx
  802a27:	89 f3                	mov    %esi,%ebx
  802a29:	f7 64 24 0c          	mull   0xc(%esp)
  802a2d:	89 c6                	mov    %eax,%esi
  802a2f:	89 d7                	mov    %edx,%edi
  802a31:	39 d1                	cmp    %edx,%ecx
  802a33:	72 06                	jb     802a3b <__umoddi3+0x10b>
  802a35:	75 10                	jne    802a47 <__umoddi3+0x117>
  802a37:	39 c3                	cmp    %eax,%ebx
  802a39:	73 0c                	jae    802a47 <__umoddi3+0x117>
  802a3b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a3f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a43:	89 d7                	mov    %edx,%edi
  802a45:	89 c6                	mov    %eax,%esi
  802a47:	89 ca                	mov    %ecx,%edx
  802a49:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a4e:	29 f3                	sub    %esi,%ebx
  802a50:	19 fa                	sbb    %edi,%edx
  802a52:	89 d0                	mov    %edx,%eax
  802a54:	d3 e0                	shl    %cl,%eax
  802a56:	89 e9                	mov    %ebp,%ecx
  802a58:	d3 eb                	shr    %cl,%ebx
  802a5a:	d3 ea                	shr    %cl,%edx
  802a5c:	09 d8                	or     %ebx,%eax
  802a5e:	83 c4 1c             	add    $0x1c,%esp
  802a61:	5b                   	pop    %ebx
  802a62:	5e                   	pop    %esi
  802a63:	5f                   	pop    %edi
  802a64:	5d                   	pop    %ebp
  802a65:	c3                   	ret    
  802a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a6d:	8d 76 00             	lea    0x0(%esi),%esi
  802a70:	29 fe                	sub    %edi,%esi
  802a72:	19 c3                	sbb    %eax,%ebx
  802a74:	89 f2                	mov    %esi,%edx
  802a76:	89 d9                	mov    %ebx,%ecx
  802a78:	e9 1d ff ff ff       	jmp    80299a <__umoddi3+0x6a>
