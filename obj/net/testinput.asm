
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 39 08 00 00       	call   80086a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 7c             	sub    $0x7c,%esp
	envid_t ns_envid = sys_getenvid();
  800040:	e8 7a 13 00 00       	call   8013bf <sys_getenvid>
  800045:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800047:	c7 05 00 40 80 00 20 	movl   $0x803020,0x804000
  80004e:	30 80 00 

	output_envid = fork();
  800051:	e8 4f 17 00 00       	call   8017a5 <fork>
  800056:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  80005b:	85 c0                	test   %eax,%eax
  80005d:	0f 88 7b 01 00 00    	js     8001de <umain+0x1ab>
		panic("error forking");
	else if (output_envid == 0) {
  800063:	0f 84 89 01 00 00    	je     8001f2 <umain+0x1bf>
		output(ns_envid);
		return;
	}

	input_envid = fork();
  800069:	e8 37 17 00 00       	call   8017a5 <fork>
  80006e:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  800073:	85 c0                	test   %eax,%eax
  800075:	0f 88 8b 01 00 00    	js     800206 <umain+0x1d3>
		panic("error forking");
	else if (input_envid == 0) {
  80007b:	0f 84 99 01 00 00    	je     80021a <umain+0x1e7>
		input(ns_envid);
		return;
	}

	cprintf("Sending ARP announcement...\n");
  800081:	83 ec 0c             	sub    $0xc,%esp
  800084:	68 48 30 80 00       	push   $0x803048
  800089:	e8 2b 09 00 00       	call   8009b9 <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80008e:	c7 45 98 52 54 00 12 	movl   $0x12005452,-0x68(%ebp)
  800095:	66 c7 45 9c 34 56    	movw   $0x5634,-0x64(%ebp)
	uint32_t myip = inet_addr(IP);
  80009b:	c7 04 24 65 30 80 00 	movl   $0x803065,(%esp)
  8000a2:	e8 86 07 00 00       	call   80082d <inet_addr>
  8000a7:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000aa:	c7 04 24 6f 30 80 00 	movl   $0x80306f,(%esp)
  8000b1:	e8 77 07 00 00       	call   80082d <inet_addr>
  8000b6:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000b9:	83 c4 0c             	add    $0xc,%esp
  8000bc:	6a 07                	push   $0x7
  8000be:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c3:	6a 00                	push   $0x0
  8000c5:	e8 3b 13 00 00       	call   801405 <sys_page_alloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	0f 88 53 01 00 00    	js     800228 <umain+0x1f5>
	pkt->jp_len = sizeof(*arp);
  8000d5:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  8000dc:	00 00 00 
	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	6a 06                	push   $0x6
  8000e4:	68 ff 00 00 00       	push   $0xff
  8000e9:	68 04 b0 fe 0f       	push   $0xffeb004
  8000ee:	e8 3a 10 00 00       	call   80112d <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  8000f3:	83 c4 0c             	add    $0xc,%esp
  8000f6:	6a 06                	push   $0x6
  8000f8:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  8000fb:	53                   	push   %ebx
  8000fc:	68 0a b0 fe 0f       	push   $0xffeb00a
  800101:	e8 d9 10 00 00       	call   8011df <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  800106:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  80010d:	e8 f2 04 00 00       	call   800604 <htons>
  800112:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  800118:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80011f:	e8 e0 04 00 00       	call   800604 <htons>
  800124:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  80012a:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  800131:	e8 ce 04 00 00       	call   800604 <htons>
  800136:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  80013c:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  800143:	e8 bc 04 00 00       	call   800604 <htons>
  800148:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  80014e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800155:	e8 aa 04 00 00       	call   800604 <htons>
  80015a:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  800160:	83 c4 0c             	add    $0xc,%esp
  800163:	6a 06                	push   $0x6
  800165:	53                   	push   %ebx
  800166:	68 1a b0 fe 0f       	push   $0xffeb01a
  80016b:	e8 6f 10 00 00       	call   8011df <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800170:	83 c4 0c             	add    $0xc,%esp
  800173:	6a 04                	push   $0x4
  800175:	8d 45 90             	lea    -0x70(%ebp),%eax
  800178:	50                   	push   %eax
  800179:	68 20 b0 fe 0f       	push   $0xffeb020
  80017e:	e8 5c 10 00 00       	call   8011df <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800183:	83 c4 0c             	add    $0xc,%esp
  800186:	6a 06                	push   $0x6
  800188:	6a 00                	push   $0x0
  80018a:	68 24 b0 fe 0f       	push   $0xffeb024
  80018f:	e8 99 0f 00 00       	call   80112d <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  800194:	83 c4 0c             	add    $0xc,%esp
  800197:	6a 04                	push   $0x4
  800199:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80019c:	50                   	push   %eax
  80019d:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001a2:	e8 38 10 00 00       	call   8011df <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001a7:	6a 07                	push   $0x7
  8001a9:	68 00 b0 fe 0f       	push   $0xffeb000
  8001ae:	6a 0b                	push   $0xb
  8001b0:	ff 35 04 50 80 00    	pushl  0x805004
  8001b6:	e8 88 18 00 00       	call   801a43 <ipc_send>
	sys_page_unmap(0, pkt);
  8001bb:	83 c4 18             	add    $0x18,%esp
  8001be:	68 00 b0 fe 0f       	push   $0xffeb000
  8001c3:	6a 00                	push   $0x0
  8001c5:	e8 c8 12 00 00       	call   801492 <sys_page_unmap>
}
  8001ca:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001cd:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  8001d4:	00 00 00 
			out = buf + snprintf(buf, end - buf,
  8001d7:	89 df                	mov    %ebx,%edi
}
  8001d9:	e9 6a 01 00 00       	jmp    800348 <umain+0x315>
		panic("error forking");
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 2a 30 80 00       	push   $0x80302a
  8001e6:	6a 4d                	push   $0x4d
  8001e8:	68 38 30 80 00       	push   $0x803038
  8001ed:	e8 e0 06 00 00       	call   8008d2 <_panic>
		output(ns_envid);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	53                   	push   %ebx
  8001f6:	e8 ff 02 00 00       	call   8004fa <output>
		return;
  8001fb:	83 c4 10             	add    $0x10,%esp
		// we've received the ARP reply
		if (first)
			cprintf("Waiting for packets...\n");
		first = 0;
	}
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("error forking");
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 2a 30 80 00       	push   $0x80302a
  80020e:	6a 55                	push   $0x55
  800210:	68 38 30 80 00       	push   $0x803038
  800215:	e8 b8 06 00 00       	call   8008d2 <_panic>
		input(ns_envid);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	53                   	push   %ebx
  80021e:	e8 69 02 00 00       	call   80048c <input>
		return;
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	eb d6                	jmp    8001fe <umain+0x1cb>
		panic("sys_page_map: %e", r);
  800228:	50                   	push   %eax
  800229:	68 78 30 80 00       	push   $0x803078
  80022e:	6a 19                	push   $0x19
  800230:	68 38 30 80 00       	push   $0x803038
  800235:	e8 98 06 00 00       	call   8008d2 <_panic>
			panic("ipc_recv: %e", req);
  80023a:	50                   	push   %eax
  80023b:	68 89 30 80 00       	push   $0x803089
  800240:	6a 64                	push   $0x64
  800242:	68 38 30 80 00       	push   $0x803038
  800247:	e8 86 06 00 00       	call   8008d2 <_panic>
			panic("IPC from unexpected environment %08x", whom);
  80024c:	52                   	push   %edx
  80024d:	68 e0 30 80 00       	push   $0x8030e0
  800252:	6a 66                	push   $0x66
  800254:	68 38 30 80 00       	push   $0x803038
  800259:	e8 74 06 00 00       	call   8008d2 <_panic>
			panic("Unexpected IPC %d", req);
  80025e:	50                   	push   %eax
  80025f:	68 96 30 80 00       	push   $0x803096
  800264:	6a 68                	push   $0x68
  800266:	68 38 30 80 00       	push   $0x803038
  80026b:	e8 62 06 00 00       	call   8008d2 <_panic>
			out = buf + snprintf(buf, end - buf,
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	56                   	push   %esi
  800274:	68 a8 30 80 00       	push   $0x8030a8
  800279:	68 b0 30 80 00       	push   $0x8030b0
  80027e:	6a 50                	push   $0x50
  800280:	57                   	push   %edi
  800281:	e8 dc 0c 00 00       	call   800f62 <snprintf>
  800286:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
  800289:	83 c4 20             	add    $0x20,%esp
  80028c:	eb 41                	jmp    8002cf <umain+0x29c>
			cprintf("%.*s\n", out - buf, buf);
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	57                   	push   %edi
  800292:	89 d8                	mov    %ebx,%eax
  800294:	29 f8                	sub    %edi,%eax
  800296:	50                   	push   %eax
  800297:	68 bf 30 80 00       	push   $0x8030bf
  80029c:	e8 18 07 00 00       	call   8009b9 <cprintf>
  8002a1:	83 c4 10             	add    $0x10,%esp
		if (i % 2 == 1)
  8002a4:	89 f2                	mov    %esi,%edx
  8002a6:	c1 ea 1f             	shr    $0x1f,%edx
  8002a9:	8d 04 16             	lea    (%esi,%edx,1),%eax
  8002ac:	83 e0 01             	and    $0x1,%eax
  8002af:	29 d0                	sub    %edx,%eax
  8002b1:	83 f8 01             	cmp    $0x1,%eax
  8002b4:	74 5f                	je     800315 <umain+0x2e2>
		if (i % 16 == 7)
  8002b6:	83 7d 84 07          	cmpl   $0x7,-0x7c(%ebp)
  8002ba:	74 61                	je     80031d <umain+0x2ea>
	for (i = 0; i < len; i++) {
  8002bc:	83 c6 01             	add    $0x1,%esi
  8002bf:	39 75 80             	cmp    %esi,-0x80(%ebp)
  8002c2:	7e 61                	jle    800325 <umain+0x2f2>
  8002c4:	89 75 84             	mov    %esi,-0x7c(%ebp)
		if (i % 16 == 0)
  8002c7:	f7 c6 0f 00 00 00    	test   $0xf,%esi
  8002cd:	74 a1                	je     800270 <umain+0x23d>
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  8002cf:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002d2:	0f b6 80 04 b0 fe 0f 	movzbl 0xffeb004(%eax),%eax
  8002d9:	50                   	push   %eax
  8002da:	68 ba 30 80 00       	push   $0x8030ba
  8002df:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002e2:	29 d8                	sub    %ebx,%eax
  8002e4:	50                   	push   %eax
  8002e5:	53                   	push   %ebx
  8002e6:	e8 77 0c 00 00       	call   800f62 <snprintf>
  8002eb:	01 c3                	add    %eax,%ebx
		if (i % 16 == 15 || i == len - 1)
  8002ed:	89 f0                	mov    %esi,%eax
  8002ef:	c1 f8 1f             	sar    $0x1f,%eax
  8002f2:	c1 e8 1c             	shr    $0x1c,%eax
  8002f5:	8d 14 06             	lea    (%esi,%eax,1),%edx
  8002f8:	83 e2 0f             	and    $0xf,%edx
  8002fb:	29 c2                	sub    %eax,%edx
  8002fd:	89 55 84             	mov    %edx,-0x7c(%ebp)
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	83 fa 0f             	cmp    $0xf,%edx
  800306:	74 86                	je     80028e <umain+0x25b>
  800308:	3b b5 7c ff ff ff    	cmp    -0x84(%ebp),%esi
  80030e:	75 94                	jne    8002a4 <umain+0x271>
  800310:	e9 79 ff ff ff       	jmp    80028e <umain+0x25b>
			*(out++) = ' ';
  800315:	c6 03 20             	movb   $0x20,(%ebx)
  800318:	8d 5b 01             	lea    0x1(%ebx),%ebx
  80031b:	eb 99                	jmp    8002b6 <umain+0x283>
			*(out++) = ' ';
  80031d:	c6 03 20             	movb   $0x20,(%ebx)
  800320:	8d 5b 01             	lea    0x1(%ebx),%ebx
  800323:	eb 97                	jmp    8002bc <umain+0x289>
		cprintf("\n");
  800325:	83 ec 0c             	sub    $0xc,%esp
  800328:	68 db 30 80 00       	push   $0x8030db
  80032d:	e8 87 06 00 00       	call   8009b9 <cprintf>
		if (first)
  800332:	83 c4 10             	add    $0x10,%esp
  800335:	83 bd 78 ff ff ff 00 	cmpl   $0x0,-0x88(%ebp)
  80033c:	75 62                	jne    8003a0 <umain+0x36d>
		first = 0;
  80033e:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  800345:	00 00 00 
		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  800348:	83 ec 04             	sub    $0x4,%esp
  80034b:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80034e:	50                   	push   %eax
  80034f:	68 00 b0 fe 0f       	push   $0xffeb000
  800354:	8d 45 90             	lea    -0x70(%ebp),%eax
  800357:	50                   	push   %eax
  800358:	e8 61 16 00 00       	call   8019be <ipc_recv>
		if (req < 0)
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	85 c0                	test   %eax,%eax
  800362:	0f 88 d2 fe ff ff    	js     80023a <umain+0x207>
		if (whom != input_envid)
  800368:	8b 55 90             	mov    -0x70(%ebp),%edx
  80036b:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  800371:	0f 85 d5 fe ff ff    	jne    80024c <umain+0x219>
		if (req != NSREQ_INPUT)
  800377:	83 f8 0a             	cmp    $0xa,%eax
  80037a:	0f 85 de fe ff ff    	jne    80025e <umain+0x22b>
		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800380:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  800385:	89 45 80             	mov    %eax,-0x80(%ebp)
	char *out = NULL;
  800388:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < len; i++) {
  80038d:	be 00 00 00 00       	mov    $0x0,%esi
		if (i % 16 == 15 || i == len - 1)
  800392:	83 e8 01             	sub    $0x1,%eax
  800395:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	for (i = 0; i < len; i++) {
  80039b:	e9 1f ff ff ff       	jmp    8002bf <umain+0x28c>
			cprintf("Waiting for packets...\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 c5 30 80 00       	push   $0x8030c5
  8003a8:	e8 0c 06 00 00       	call   8009b9 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	eb 8c                	jmp    80033e <umain+0x30b>

008003b2 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8003b2:	f3 0f 1e fb          	endbr32 
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	57                   	push   %edi
  8003ba:	56                   	push   %esi
  8003bb:	53                   	push   %ebx
  8003bc:	83 ec 1c             	sub    $0x1c,%esp
  8003bf:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  8003c2:	e8 4f 12 00 00       	call   801616 <sys_time_msec>
  8003c7:	03 45 0c             	add    0xc(%ebp),%eax
  8003ca:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003cc:	c7 05 00 40 80 00 05 	movl   $0x803105,0x804000
  8003d3:	31 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003d6:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  8003d9:	eb 33                	jmp    80040e <timer+0x5c>
		if (r < 0)
  8003db:	85 c0                	test   %eax,%eax
  8003dd:	78 45                	js     800424 <timer+0x72>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8003df:	6a 00                	push   $0x0
  8003e1:	6a 00                	push   $0x0
  8003e3:	6a 0c                	push   $0xc
  8003e5:	56                   	push   %esi
  8003e6:	e8 58 16 00 00       	call   801a43 <ipc_send>
  8003eb:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003ee:	83 ec 04             	sub    $0x4,%esp
  8003f1:	6a 00                	push   $0x0
  8003f3:	6a 00                	push   $0x0
  8003f5:	57                   	push   %edi
  8003f6:	e8 c3 15 00 00       	call   8019be <ipc_recv>
  8003fb:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  8003fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800400:	83 c4 10             	add    $0x10,%esp
  800403:	39 f0                	cmp    %esi,%eax
  800405:	75 2f                	jne    800436 <timer+0x84>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800407:	e8 0a 12 00 00       	call   801616 <sys_time_msec>
  80040c:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80040e:	e8 03 12 00 00       	call   801616 <sys_time_msec>
  800413:	89 c2                	mov    %eax,%edx
  800415:	85 c0                	test   %eax,%eax
  800417:	78 c2                	js     8003db <timer+0x29>
  800419:	39 d8                	cmp    %ebx,%eax
  80041b:	73 be                	jae    8003db <timer+0x29>
			sys_yield();
  80041d:	e8 c0 0f 00 00       	call   8013e2 <sys_yield>
  800422:	eb ea                	jmp    80040e <timer+0x5c>
			panic("sys_time_msec: %e", r);
  800424:	52                   	push   %edx
  800425:	68 0e 31 80 00       	push   $0x80310e
  80042a:	6a 0f                	push   $0xf
  80042c:	68 20 31 80 00       	push   $0x803120
  800431:	e8 9c 04 00 00       	call   8008d2 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	50                   	push   %eax
  80043a:	68 2c 31 80 00       	push   $0x80312c
  80043f:	e8 75 05 00 00       	call   8009b9 <cprintf>
				continue;
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	eb a5                	jmp    8003ee <timer+0x3c>

00800449 <sleep>:
extern union Nsipc nsipcbuf;


void
sleep(int msec)
{
  800449:	f3 0f 1e fb          	endbr32 
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	53                   	push   %ebx
  800451:	83 ec 04             	sub    $0x4,%esp
       unsigned now = sys_time_msec();
  800454:	e8 bd 11 00 00       	call   801616 <sys_time_msec>
       unsigned end = now + msec;
  800459:	89 c3                	mov    %eax,%ebx
  80045b:	03 5d 08             	add    0x8(%ebp),%ebx

       if ((int)now < 0 && (int)now > -MAXERROR)
  80045e:	85 c0                	test   %eax,%eax
  800460:	79 1c                	jns    80047e <sleep+0x35>
  800462:	83 f8 f1             	cmp    $0xfffffff1,%eax
  800465:	7c 17                	jl     80047e <sleep+0x35>
               panic("sys_time_msec: %e", (int)now);
  800467:	50                   	push   %eax
  800468:	68 0e 31 80 00       	push   $0x80310e
  80046d:	6a 0e                	push   $0xe
  80046f:	68 67 31 80 00       	push   $0x803167
  800474:	e8 59 04 00 00       	call   8008d2 <_panic>

       while (sys_time_msec() < end)
               sys_yield();
  800479:	e8 64 0f 00 00       	call   8013e2 <sys_yield>
       while (sys_time_msec() < end)
  80047e:	e8 93 11 00 00       	call   801616 <sys_time_msec>
  800483:	39 d8                	cmp    %ebx,%eax
  800485:	72 f2                	jb     800479 <sleep+0x30>
}
  800487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048a:	c9                   	leave  
  80048b:	c3                   	ret    

0080048c <input>:

void
input(envid_t ns_envid)
{
  80048c:	f3 0f 1e fb          	endbr32 
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	57                   	push   %edi
  800494:	56                   	push   %esi
  800495:	53                   	push   %ebx
  800496:	81 ec 0c 06 00 00    	sub    $0x60c,%esp
  80049c:	8b 7d 08             	mov    0x8(%ebp),%edi
	binaryname = "ns_input";
  80049f:	c7 05 00 40 80 00 73 	movl   $0x803173,0x804000
  8004a6:	31 80 00 
	// another packet in to the same physical page.

	size_t len;
	char buf[RX_PKT_SIZE];
	while (1) {
		if (sys_pkt_recv(buf, &len) < 0) {
  8004a9:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8004ac:	8d 9d f6 f9 ff ff    	lea    -0x60a(%ebp),%ebx
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	56                   	push   %esi
  8004b6:	53                   	push   %ebx
  8004b7:	e8 c3 11 00 00       	call   80167f <sys_pkt_recv>
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	78 ef                	js     8004b2 <input+0x26>
			continue;
		}

		memcpy(nsipcbuf.pkt.jp_data, buf, len);
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c9:	53                   	push   %ebx
  8004ca:	68 04 70 80 00       	push   $0x807004
  8004cf:	e8 0b 0d 00 00       	call   8011df <memcpy>
		nsipcbuf.pkt.jp_len = len;
  8004d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d7:	a3 00 70 80 00       	mov    %eax,0x807000
		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_U|PTE_W);
  8004dc:	6a 07                	push   $0x7
  8004de:	68 00 70 80 00       	push   $0x807000
  8004e3:	6a 0a                	push   $0xa
  8004e5:	57                   	push   %edi
  8004e6:	e8 58 15 00 00       	call   801a43 <ipc_send>
		sleep(50);
  8004eb:	83 c4 14             	add    $0x14,%esp
  8004ee:	6a 32                	push   $0x32
  8004f0:	e8 54 ff ff ff       	call   800449 <sleep>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	eb b8                	jmp    8004b2 <input+0x26>

008004fa <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8004fa:	f3 0f 1e fb          	endbr32 
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	56                   	push   %esi
  800502:	53                   	push   %ebx
  800503:	83 ec 10             	sub    $0x10,%esp
	binaryname = "ns_output";
  800506:	c7 05 00 40 80 00 7c 	movl   $0x80317c,0x804000
  80050d:	31 80 00 
	uint32_t whom;
	int perm;
	int32_t req;

	while (1) {
		req = ipc_recv((envid_t *)&whom, &nsipcbuf,  &perm);     //接收核心网络进程发来的请求
  800510:	8d 75 f0             	lea    -0x10(%ebp),%esi
  800513:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  800516:	eb 1f                	jmp    800537 <output+0x3d>
			continue;
		}

    	struct jif_pkt *pkt = &(nsipcbuf.pkt);
    	while (sys_pkt_send(pkt->jp_data, pkt->jp_len) < 0) {        //通过系统调用发送数据包
       		sys_yield();
  800518:	e8 c5 0e 00 00       	call   8013e2 <sys_yield>
    	while (sys_pkt_send(pkt->jp_data, pkt->jp_len) < 0) {        //通过系统调用发送数据包
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	ff 35 00 70 80 00    	pushl  0x807000
  800526:	68 04 70 80 00       	push   $0x807004
  80052b:	e8 09 11 00 00       	call   801639 <sys_pkt_send>
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	85 c0                	test   %eax,%eax
  800535:	78 e1                	js     800518 <output+0x1e>
		req = ipc_recv((envid_t *)&whom, &nsipcbuf,  &perm);     //接收核心网络进程发来的请求
  800537:	83 ec 04             	sub    $0x4,%esp
  80053a:	56                   	push   %esi
  80053b:	68 00 70 80 00       	push   $0x807000
  800540:	53                   	push   %ebx
  800541:	e8 78 14 00 00       	call   8019be <ipc_recv>
		if (req != NSREQ_OUTPUT) {
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	83 f8 0b             	cmp    $0xb,%eax
  80054c:	74 cf                	je     80051d <output+0x23>
			cprintf("not a nsreq output\n");
  80054e:	83 ec 0c             	sub    $0xc,%esp
  800551:	68 86 31 80 00       	push   $0x803186
  800556:	e8 5e 04 00 00       	call   8009b9 <cprintf>
			continue;
  80055b:	83 c4 10             	add    $0x10,%esp
  80055e:	eb d7                	jmp    800537 <output+0x3d>

00800560 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800560:	f3 0f 1e fb          	endbr32 
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	57                   	push   %edi
  800568:	56                   	push   %esi
  800569:	53                   	push   %ebx
  80056a:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800573:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  800577:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  80057a:	bf 08 50 80 00       	mov    $0x805008,%edi
  80057f:	eb 2e                	jmp    8005af <inet_ntoa+0x4f>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  800581:	0f b6 c8             	movzbl %al,%ecx
  800584:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800589:	88 0a                	mov    %cl,(%edx)
  80058b:	83 c2 01             	add    $0x1,%edx
    while(i--)
  80058e:	83 e8 01             	sub    $0x1,%eax
  800591:	3c ff                	cmp    $0xff,%al
  800593:	75 ec                	jne    800581 <inet_ntoa+0x21>
  800595:	0f b6 db             	movzbl %bl,%ebx
  800598:	01 fb                	add    %edi,%ebx
    *rp++ = '.';
  80059a:	8d 7b 01             	lea    0x1(%ebx),%edi
  80059d:	c6 03 2e             	movb   $0x2e,(%ebx)
  8005a0:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  8005a3:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  8005a7:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  8005ab:	3c 04                	cmp    $0x4,%al
  8005ad:	74 45                	je     8005f4 <inet_ntoa+0x94>
  rp = str;
  8005af:	bb 00 00 00 00       	mov    $0x0,%ebx
      rem = *ap % (u8_t)10;
  8005b4:	0f b6 16             	movzbl (%esi),%edx
      *ap /= (u8_t)10;
  8005b7:	0f b6 ca             	movzbl %dl,%ecx
  8005ba:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8005bd:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  8005c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005c3:	66 c1 e8 0b          	shr    $0xb,%ax
  8005c7:	88 06                	mov    %al,(%esi)
  8005c9:	89 d9                	mov    %ebx,%ecx
      inv[i++] = '0' + rem;
  8005cb:	83 c3 01             	add    $0x1,%ebx
  8005ce:	0f b6 c9             	movzbl %cl,%ecx
  8005d1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  8005d4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005d7:	01 c0                	add    %eax,%eax
  8005d9:	89 d1                	mov    %edx,%ecx
  8005db:	29 c1                	sub    %eax,%ecx
  8005dd:	89 c8                	mov    %ecx,%eax
      inv[i++] = '0' + rem;
  8005df:	83 c0 30             	add    $0x30,%eax
  8005e2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e5:	88 44 0d ed          	mov    %al,-0x13(%ebp,%ecx,1)
    } while(*ap);
  8005e9:	80 fa 09             	cmp    $0x9,%dl
  8005ec:	77 c6                	ja     8005b4 <inet_ntoa+0x54>
  8005ee:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  8005f0:	89 d8                	mov    %ebx,%eax
  8005f2:	eb 9a                	jmp    80058e <inet_ntoa+0x2e>
    ap++;
  }
  *--rp = 0;
  8005f4:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  8005f7:	b8 08 50 80 00       	mov    $0x805008,%eax
  8005fc:	83 c4 18             	add    $0x18,%esp
  8005ff:	5b                   	pop    %ebx
  800600:	5e                   	pop    %esi
  800601:	5f                   	pop    %edi
  800602:	5d                   	pop    %ebp
  800603:	c3                   	ret    

00800604 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800604:	f3 0f 1e fb          	endbr32 
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80060b:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80060f:	66 c1 c0 08          	rol    $0x8,%ax
}
  800613:	5d                   	pop    %ebp
  800614:	c3                   	ret    

00800615 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800615:	f3 0f 1e fb          	endbr32 
  800619:	55                   	push   %ebp
  80061a:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80061c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800620:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800626:	f3 0f 1e fb          	endbr32 
  80062a:	55                   	push   %ebp
  80062b:	89 e5                	mov    %esp,%ebp
  80062d:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800630:	89 d0                	mov    %edx,%eax
  800632:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800635:	89 d1                	mov    %edx,%ecx
  800637:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  80063a:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  80063c:	89 d1                	mov    %edx,%ecx
  80063e:	c1 e1 08             	shl    $0x8,%ecx
  800641:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  800647:	09 c8                	or     %ecx,%eax
  800649:	c1 ea 08             	shr    $0x8,%edx
  80064c:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800652:	09 d0                	or     %edx,%eax
}
  800654:	5d                   	pop    %ebp
  800655:	c3                   	ret    

00800656 <inet_aton>:
{
  800656:	f3 0f 1e fb          	endbr32 
  80065a:	55                   	push   %ebp
  80065b:	89 e5                	mov    %esp,%ebp
  80065d:	57                   	push   %edi
  80065e:	56                   	push   %esi
  80065f:	53                   	push   %ebx
  800660:	83 ec 2c             	sub    $0x2c,%esp
  800663:	8b 55 08             	mov    0x8(%ebp),%edx
  c = *cp;
  800666:	0f be 02             	movsbl (%edx),%eax
  u32_t *pp = parts;
  800669:	8d 75 d8             	lea    -0x28(%ebp),%esi
  80066c:	89 75 cc             	mov    %esi,-0x34(%ebp)
  80066f:	e9 a7 00 00 00       	jmp    80071b <inet_aton+0xc5>
      c = *++cp;
  800674:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      if (c == 'x' || c == 'X') {
  800678:	89 c1                	mov    %eax,%ecx
  80067a:	83 e1 df             	and    $0xffffffdf,%ecx
  80067d:	80 f9 58             	cmp    $0x58,%cl
  800680:	74 10                	je     800692 <inet_aton+0x3c>
      c = *++cp;
  800682:	83 c2 01             	add    $0x1,%edx
  800685:	0f be c0             	movsbl %al,%eax
        base = 8;
  800688:	be 08 00 00 00       	mov    $0x8,%esi
  80068d:	e9 a3 00 00 00       	jmp    800735 <inet_aton+0xdf>
        c = *++cp;
  800692:	0f be 42 02          	movsbl 0x2(%edx),%eax
  800696:	8d 52 02             	lea    0x2(%edx),%edx
        base = 16;
  800699:	be 10 00 00 00       	mov    $0x10,%esi
  80069e:	e9 92 00 00 00       	jmp    800735 <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  8006a3:	83 fe 10             	cmp    $0x10,%esi
  8006a6:	75 4d                	jne    8006f5 <inet_aton+0x9f>
  8006a8:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  8006ab:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  8006ae:	89 c1                	mov    %eax,%ecx
  8006b0:	83 e1 df             	and    $0xffffffdf,%ecx
  8006b3:	83 e9 41             	sub    $0x41,%ecx
  8006b6:	80 f9 05             	cmp    $0x5,%cl
  8006b9:	77 3a                	ja     8006f5 <inet_aton+0x9f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8006bb:	c1 e3 04             	shl    $0x4,%ebx
  8006be:	83 c0 0a             	add    $0xa,%eax
  8006c1:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8006c5:	19 c9                	sbb    %ecx,%ecx
  8006c7:	83 e1 20             	and    $0x20,%ecx
  8006ca:	83 c1 41             	add    $0x41,%ecx
  8006cd:	29 c8                	sub    %ecx,%eax
  8006cf:	09 c3                	or     %eax,%ebx
        c = *++cp;
  8006d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006d4:	0f be 40 01          	movsbl 0x1(%eax),%eax
  8006d8:	83 c2 01             	add    $0x1,%edx
  8006db:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      if (isdigit(c)) {
  8006de:	89 c7                	mov    %eax,%edi
  8006e0:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8006e3:	80 f9 09             	cmp    $0x9,%cl
  8006e6:	77 bb                	ja     8006a3 <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  8006e8:	0f af de             	imul   %esi,%ebx
  8006eb:	8d 5c 18 d0          	lea    -0x30(%eax,%ebx,1),%ebx
        c = *++cp;
  8006ef:	0f be 42 01          	movsbl 0x1(%edx),%eax
  8006f3:	eb e3                	jmp    8006d8 <inet_aton+0x82>
    if (c == '.') {
  8006f5:	83 f8 2e             	cmp    $0x2e,%eax
  8006f8:	75 42                	jne    80073c <inet_aton+0xe6>
      if (pp >= parts + 3)
  8006fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006fd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800700:	39 c6                	cmp    %eax,%esi
  800702:	0f 84 16 01 00 00    	je     80081e <inet_aton+0x1c8>
      *pp++ = val;
  800708:	83 c6 04             	add    $0x4,%esi
  80070b:	89 75 cc             	mov    %esi,-0x34(%ebp)
  80070e:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  800711:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800714:	8d 50 01             	lea    0x1(%eax),%edx
  800717:	0f be 40 01          	movsbl 0x1(%eax),%eax
    if (!isdigit(c))
  80071b:	8d 48 d0             	lea    -0x30(%eax),%ecx
  80071e:	80 f9 09             	cmp    $0x9,%cl
  800721:	0f 87 f0 00 00 00    	ja     800817 <inet_aton+0x1c1>
    base = 10;
  800727:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  80072c:	83 f8 30             	cmp    $0x30,%eax
  80072f:	0f 84 3f ff ff ff    	je     800674 <inet_aton+0x1e>
    base = 10;
  800735:	bb 00 00 00 00       	mov    $0x0,%ebx
  80073a:	eb 9f                	jmp    8006db <inet_aton+0x85>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80073c:	85 c0                	test   %eax,%eax
  80073e:	74 29                	je     800769 <inet_aton+0x113>
    return (0);
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800745:	89 f9                	mov    %edi,%ecx
  800747:	80 f9 1f             	cmp    $0x1f,%cl
  80074a:	0f 86 d3 00 00 00    	jbe    800823 <inet_aton+0x1cd>
  800750:	84 c0                	test   %al,%al
  800752:	0f 88 cb 00 00 00    	js     800823 <inet_aton+0x1cd>
  800758:	83 f8 20             	cmp    $0x20,%eax
  80075b:	74 0c                	je     800769 <inet_aton+0x113>
  80075d:	83 e8 09             	sub    $0x9,%eax
  800760:	83 f8 04             	cmp    $0x4,%eax
  800763:	0f 87 ba 00 00 00    	ja     800823 <inet_aton+0x1cd>
  n = pp - parts + 1;
  800769:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80076c:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80076f:	29 c6                	sub    %eax,%esi
  800771:	89 f0                	mov    %esi,%eax
  800773:	c1 f8 02             	sar    $0x2,%eax
  800776:	8d 50 01             	lea    0x1(%eax),%edx
  switch (n) {
  800779:	83 f8 02             	cmp    $0x2,%eax
  80077c:	74 7a                	je     8007f8 <inet_aton+0x1a2>
  80077e:	83 fa 03             	cmp    $0x3,%edx
  800781:	7f 49                	jg     8007cc <inet_aton+0x176>
  800783:	85 d2                	test   %edx,%edx
  800785:	0f 84 98 00 00 00    	je     800823 <inet_aton+0x1cd>
  80078b:	83 fa 02             	cmp    $0x2,%edx
  80078e:	75 19                	jne    8007a9 <inet_aton+0x153>
      return (0);
  800790:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffffffUL)
  800795:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  80079b:	0f 87 82 00 00 00    	ja     800823 <inet_aton+0x1cd>
    val |= parts[0] << 24;
  8007a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007a4:	c1 e0 18             	shl    $0x18,%eax
  8007a7:	09 c3                	or     %eax,%ebx
  return (1);
  8007a9:	ba 01 00 00 00       	mov    $0x1,%edx
  if (addr)
  8007ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007b2:	74 6f                	je     800823 <inet_aton+0x1cd>
    addr->s_addr = htonl(val);
  8007b4:	83 ec 0c             	sub    $0xc,%esp
  8007b7:	53                   	push   %ebx
  8007b8:	e8 69 fe ff ff       	call   800626 <htonl>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8007c3:	89 06                	mov    %eax,(%esi)
  return (1);
  8007c5:	ba 01 00 00 00       	mov    $0x1,%edx
  8007ca:	eb 57                	jmp    800823 <inet_aton+0x1cd>
  switch (n) {
  8007cc:	83 fa 04             	cmp    $0x4,%edx
  8007cf:	75 d8                	jne    8007a9 <inet_aton+0x153>
      return (0);
  8007d1:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xff)
  8007d6:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8007dc:	77 45                	ja     800823 <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8007de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e1:	c1 e0 18             	shl    $0x18,%eax
  8007e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007e7:	c1 e2 10             	shl    $0x10,%edx
  8007ea:	09 d0                	or     %edx,%eax
  8007ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ef:	c1 e2 08             	shl    $0x8,%edx
  8007f2:	09 d0                	or     %edx,%eax
  8007f4:	09 c3                	or     %eax,%ebx
    break;
  8007f6:	eb b1                	jmp    8007a9 <inet_aton+0x153>
      return (0);
  8007f8:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffff)
  8007fd:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  800803:	77 1e                	ja     800823 <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800805:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800808:	c1 e0 18             	shl    $0x18,%eax
  80080b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80080e:	c1 e2 10             	shl    $0x10,%edx
  800811:	09 d0                	or     %edx,%eax
  800813:	09 c3                	or     %eax,%ebx
    break;
  800815:	eb 92                	jmp    8007a9 <inet_aton+0x153>
      return (0);
  800817:	ba 00 00 00 00       	mov    $0x0,%edx
  80081c:	eb 05                	jmp    800823 <inet_aton+0x1cd>
        return (0);
  80081e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800823:	89 d0                	mov    %edx,%eax
  800825:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800828:	5b                   	pop    %ebx
  800829:	5e                   	pop    %esi
  80082a:	5f                   	pop    %edi
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <inet_addr>:
{
  80082d:	f3 0f 1e fb          	endbr32 
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  800837:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80083a:	50                   	push   %eax
  80083b:	ff 75 08             	pushl  0x8(%ebp)
  80083e:	e8 13 fe ff ff       	call   800656 <inet_aton>
  800843:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  800846:	85 c0                	test   %eax,%eax
  800848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80084d:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  800851:	c9                   	leave  
  800852:	c3                   	ret    

00800853 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  800853:	f3 0f 1e fb          	endbr32 
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  80085d:	ff 75 08             	pushl  0x8(%ebp)
  800860:	e8 c1 fd ff ff       	call   800626 <htonl>
  800865:	83 c4 10             	add    $0x10,%esp
}
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80086a:	f3 0f 1e fb          	endbr32 
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	56                   	push   %esi
  800872:	53                   	push   %ebx
  800873:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800876:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800879:	e8 41 0b 00 00       	call   8013bf <sys_getenvid>
  80087e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800883:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800886:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80088b:	a3 20 50 80 00       	mov    %eax,0x805020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800890:	85 db                	test   %ebx,%ebx
  800892:	7e 07                	jle    80089b <libmain+0x31>
		binaryname = argv[0];
  800894:	8b 06                	mov    (%esi),%eax
  800896:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	56                   	push   %esi
  80089f:	53                   	push   %ebx
  8008a0:	e8 8e f7 ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8008a5:	e8 0a 00 00 00       	call   8008b4 <exit>
}
  8008aa:	83 c4 10             	add    $0x10,%esp
  8008ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008b0:	5b                   	pop    %ebx
  8008b1:	5e                   	pop    %esi
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008b4:	f3 0f 1e fb          	endbr32 
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8008be:	e8 09 14 00 00       	call   801ccc <close_all>
	sys_env_destroy(0);
  8008c3:	83 ec 0c             	sub    $0xc,%esp
  8008c6:	6a 00                	push   $0x0
  8008c8:	e8 ad 0a 00 00       	call   80137a <sys_env_destroy>
}
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008d2:	f3 0f 1e fb          	endbr32 
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	56                   	push   %esi
  8008da:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8008db:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8008de:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8008e4:	e8 d6 0a 00 00       	call   8013bf <sys_getenvid>
  8008e9:	83 ec 0c             	sub    $0xc,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	ff 75 08             	pushl  0x8(%ebp)
  8008f2:	56                   	push   %esi
  8008f3:	50                   	push   %eax
  8008f4:	68 a4 31 80 00       	push   $0x8031a4
  8008f9:	e8 bb 00 00 00       	call   8009b9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8008fe:	83 c4 18             	add    $0x18,%esp
  800901:	53                   	push   %ebx
  800902:	ff 75 10             	pushl  0x10(%ebp)
  800905:	e8 5a 00 00 00       	call   800964 <vcprintf>
	cprintf("\n");
  80090a:	c7 04 24 db 30 80 00 	movl   $0x8030db,(%esp)
  800911:	e8 a3 00 00 00       	call   8009b9 <cprintf>
  800916:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800919:	cc                   	int3   
  80091a:	eb fd                	jmp    800919 <_panic+0x47>

0080091c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80091c:	f3 0f 1e fb          	endbr32 
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	53                   	push   %ebx
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80092a:	8b 13                	mov    (%ebx),%edx
  80092c:	8d 42 01             	lea    0x1(%edx),%eax
  80092f:	89 03                	mov    %eax,(%ebx)
  800931:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800934:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800938:	3d ff 00 00 00       	cmp    $0xff,%eax
  80093d:	74 09                	je     800948 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80093f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800946:	c9                   	leave  
  800947:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	68 ff 00 00 00       	push   $0xff
  800950:	8d 43 08             	lea    0x8(%ebx),%eax
  800953:	50                   	push   %eax
  800954:	e8 dc 09 00 00       	call   801335 <sys_cputs>
		b->idx = 0;
  800959:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80095f:	83 c4 10             	add    $0x10,%esp
  800962:	eb db                	jmp    80093f <putch+0x23>

00800964 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800964:	f3 0f 1e fb          	endbr32 
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800971:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800978:	00 00 00 
	b.cnt = 0;
  80097b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800982:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800991:	50                   	push   %eax
  800992:	68 1c 09 80 00       	push   $0x80091c
  800997:	e8 20 01 00 00       	call   800abc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80099c:	83 c4 08             	add    $0x8,%esp
  80099f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8009a5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8009ab:	50                   	push   %eax
  8009ac:	e8 84 09 00 00       	call   801335 <sys_cputs>

	return b.cnt;
}
  8009b1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8009b9:	f3 0f 1e fb          	endbr32 
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009c3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8009c6:	50                   	push   %eax
  8009c7:	ff 75 08             	pushl  0x8(%ebp)
  8009ca:	e8 95 ff ff ff       	call   800964 <vcprintf>
	va_end(ap);

	return cnt;
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	57                   	push   %edi
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	83 ec 1c             	sub    $0x1c,%esp
  8009da:	89 c7                	mov    %eax,%edi
  8009dc:	89 d6                	mov    %edx,%esi
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e4:	89 d1                	mov    %edx,%ecx
  8009e6:	89 c2                	mov    %eax,%edx
  8009e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009eb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009fe:	39 c2                	cmp    %eax,%edx
  800a00:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800a03:	72 3e                	jb     800a43 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a05:	83 ec 0c             	sub    $0xc,%esp
  800a08:	ff 75 18             	pushl  0x18(%ebp)
  800a0b:	83 eb 01             	sub    $0x1,%ebx
  800a0e:	53                   	push   %ebx
  800a0f:	50                   	push   %eax
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a16:	ff 75 e0             	pushl  -0x20(%ebp)
  800a19:	ff 75 dc             	pushl  -0x24(%ebp)
  800a1c:	ff 75 d8             	pushl  -0x28(%ebp)
  800a1f:	e8 9c 23 00 00       	call   802dc0 <__udivdi3>
  800a24:	83 c4 18             	add    $0x18,%esp
  800a27:	52                   	push   %edx
  800a28:	50                   	push   %eax
  800a29:	89 f2                	mov    %esi,%edx
  800a2b:	89 f8                	mov    %edi,%eax
  800a2d:	e8 9f ff ff ff       	call   8009d1 <printnum>
  800a32:	83 c4 20             	add    $0x20,%esp
  800a35:	eb 13                	jmp    800a4a <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	56                   	push   %esi
  800a3b:	ff 75 18             	pushl  0x18(%ebp)
  800a3e:	ff d7                	call   *%edi
  800a40:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800a43:	83 eb 01             	sub    $0x1,%ebx
  800a46:	85 db                	test   %ebx,%ebx
  800a48:	7f ed                	jg     800a37 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	56                   	push   %esi
  800a4e:	83 ec 04             	sub    $0x4,%esp
  800a51:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a54:	ff 75 e0             	pushl  -0x20(%ebp)
  800a57:	ff 75 dc             	pushl  -0x24(%ebp)
  800a5a:	ff 75 d8             	pushl  -0x28(%ebp)
  800a5d:	e8 6e 24 00 00       	call   802ed0 <__umoddi3>
  800a62:	83 c4 14             	add    $0x14,%esp
  800a65:	0f be 80 c7 31 80 00 	movsbl 0x8031c7(%eax),%eax
  800a6c:	50                   	push   %eax
  800a6d:	ff d7                	call   *%edi
}
  800a6f:	83 c4 10             	add    $0x10,%esp
  800a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a75:	5b                   	pop    %ebx
  800a76:	5e                   	pop    %esi
  800a77:	5f                   	pop    %edi
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a7a:	f3 0f 1e fb          	endbr32 
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800a84:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800a88:	8b 10                	mov    (%eax),%edx
  800a8a:	3b 50 04             	cmp    0x4(%eax),%edx
  800a8d:	73 0a                	jae    800a99 <sprintputch+0x1f>
		*b->buf++ = ch;
  800a8f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a92:	89 08                	mov    %ecx,(%eax)
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	88 02                	mov    %al,(%edx)
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <printfmt>:
{
  800a9b:	f3 0f 1e fb          	endbr32 
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800aa8:	50                   	push   %eax
  800aa9:	ff 75 10             	pushl  0x10(%ebp)
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	ff 75 08             	pushl  0x8(%ebp)
  800ab2:	e8 05 00 00 00       	call   800abc <vprintfmt>
}
  800ab7:	83 c4 10             	add    $0x10,%esp
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <vprintfmt>:
{
  800abc:	f3 0f 1e fb          	endbr32 
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	57                   	push   %edi
  800ac4:	56                   	push   %esi
  800ac5:	53                   	push   %ebx
  800ac6:	83 ec 3c             	sub    $0x3c,%esp
  800ac9:	8b 75 08             	mov    0x8(%ebp),%esi
  800acc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800acf:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ad2:	e9 8e 03 00 00       	jmp    800e65 <vprintfmt+0x3a9>
		padc = ' ';
  800ad7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800adb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800ae2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800ae9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800af0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800af5:	8d 47 01             	lea    0x1(%edi),%eax
  800af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800afb:	0f b6 17             	movzbl (%edi),%edx
  800afe:	8d 42 dd             	lea    -0x23(%edx),%eax
  800b01:	3c 55                	cmp    $0x55,%al
  800b03:	0f 87 df 03 00 00    	ja     800ee8 <vprintfmt+0x42c>
  800b09:	0f b6 c0             	movzbl %al,%eax
  800b0c:	3e ff 24 85 00 33 80 	notrack jmp *0x803300(,%eax,4)
  800b13:	00 
  800b14:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800b17:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800b1b:	eb d8                	jmp    800af5 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800b1d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800b20:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800b24:	eb cf                	jmp    800af5 <vprintfmt+0x39>
  800b26:	0f b6 d2             	movzbl %dl,%edx
  800b29:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800b34:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800b37:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800b3b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800b3e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800b41:	83 f9 09             	cmp    $0x9,%ecx
  800b44:	77 55                	ja     800b9b <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800b46:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800b49:	eb e9                	jmp    800b34 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b53:	8b 45 14             	mov    0x14(%ebp),%eax
  800b56:	8d 40 04             	lea    0x4(%eax),%eax
  800b59:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800b5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800b5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b63:	79 90                	jns    800af5 <vprintfmt+0x39>
				width = precision, precision = -1;
  800b65:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b68:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b6b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800b72:	eb 81                	jmp    800af5 <vprintfmt+0x39>
  800b74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b77:	85 c0                	test   %eax,%eax
  800b79:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7e:	0f 49 d0             	cmovns %eax,%edx
  800b81:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800b84:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800b87:	e9 69 ff ff ff       	jmp    800af5 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800b8c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800b8f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800b96:	e9 5a ff ff ff       	jmp    800af5 <vprintfmt+0x39>
  800b9b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800b9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ba1:	eb bc                	jmp    800b5f <vprintfmt+0xa3>
			lflag++;
  800ba3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800ba6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800ba9:	e9 47 ff ff ff       	jmp    800af5 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	8d 78 04             	lea    0x4(%eax),%edi
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	53                   	push   %ebx
  800bb8:	ff 30                	pushl  (%eax)
  800bba:	ff d6                	call   *%esi
			break;
  800bbc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800bbf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800bc2:	e9 9b 02 00 00       	jmp    800e62 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bca:	8d 78 04             	lea    0x4(%eax),%edi
  800bcd:	8b 00                	mov    (%eax),%eax
  800bcf:	99                   	cltd   
  800bd0:	31 d0                	xor    %edx,%eax
  800bd2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bd4:	83 f8 0f             	cmp    $0xf,%eax
  800bd7:	7f 23                	jg     800bfc <vprintfmt+0x140>
  800bd9:	8b 14 85 60 34 80 00 	mov    0x803460(,%eax,4),%edx
  800be0:	85 d2                	test   %edx,%edx
  800be2:	74 18                	je     800bfc <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800be4:	52                   	push   %edx
  800be5:	68 49 36 80 00       	push   $0x803649
  800bea:	53                   	push   %ebx
  800beb:	56                   	push   %esi
  800bec:	e8 aa fe ff ff       	call   800a9b <printfmt>
  800bf1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800bf4:	89 7d 14             	mov    %edi,0x14(%ebp)
  800bf7:	e9 66 02 00 00       	jmp    800e62 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800bfc:	50                   	push   %eax
  800bfd:	68 df 31 80 00       	push   $0x8031df
  800c02:	53                   	push   %ebx
  800c03:	56                   	push   %esi
  800c04:	e8 92 fe ff ff       	call   800a9b <printfmt>
  800c09:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800c0c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800c0f:	e9 4e 02 00 00       	jmp    800e62 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800c14:	8b 45 14             	mov    0x14(%ebp),%eax
  800c17:	83 c0 04             	add    $0x4,%eax
  800c1a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800c1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c20:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800c22:	85 d2                	test   %edx,%edx
  800c24:	b8 d8 31 80 00       	mov    $0x8031d8,%eax
  800c29:	0f 45 c2             	cmovne %edx,%eax
  800c2c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800c2f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c33:	7e 06                	jle    800c3b <vprintfmt+0x17f>
  800c35:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800c39:	75 0d                	jne    800c48 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c3e:	89 c7                	mov    %eax,%edi
  800c40:	03 45 e0             	add    -0x20(%ebp),%eax
  800c43:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c46:	eb 55                	jmp    800c9d <vprintfmt+0x1e1>
  800c48:	83 ec 08             	sub    $0x8,%esp
  800c4b:	ff 75 d8             	pushl  -0x28(%ebp)
  800c4e:	ff 75 cc             	pushl  -0x34(%ebp)
  800c51:	e8 46 03 00 00       	call   800f9c <strnlen>
  800c56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c59:	29 c2                	sub    %eax,%edx
  800c5b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800c5e:	83 c4 10             	add    $0x10,%esp
  800c61:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800c63:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800c67:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800c6a:	85 ff                	test   %edi,%edi
  800c6c:	7e 11                	jle    800c7f <vprintfmt+0x1c3>
					putch(padc, putdat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	53                   	push   %ebx
  800c72:	ff 75 e0             	pushl  -0x20(%ebp)
  800c75:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800c77:	83 ef 01             	sub    $0x1,%edi
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	eb eb                	jmp    800c6a <vprintfmt+0x1ae>
  800c7f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800c82:	85 d2                	test   %edx,%edx
  800c84:	b8 00 00 00 00       	mov    $0x0,%eax
  800c89:	0f 49 c2             	cmovns %edx,%eax
  800c8c:	29 c2                	sub    %eax,%edx
  800c8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800c91:	eb a8                	jmp    800c3b <vprintfmt+0x17f>
					putch(ch, putdat);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	53                   	push   %ebx
  800c97:	52                   	push   %edx
  800c98:	ff d6                	call   *%esi
  800c9a:	83 c4 10             	add    $0x10,%esp
  800c9d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ca0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ca2:	83 c7 01             	add    $0x1,%edi
  800ca5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ca9:	0f be d0             	movsbl %al,%edx
  800cac:	85 d2                	test   %edx,%edx
  800cae:	74 4b                	je     800cfb <vprintfmt+0x23f>
  800cb0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800cb4:	78 06                	js     800cbc <vprintfmt+0x200>
  800cb6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800cba:	78 1e                	js     800cda <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800cbc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800cc0:	74 d1                	je     800c93 <vprintfmt+0x1d7>
  800cc2:	0f be c0             	movsbl %al,%eax
  800cc5:	83 e8 20             	sub    $0x20,%eax
  800cc8:	83 f8 5e             	cmp    $0x5e,%eax
  800ccb:	76 c6                	jbe    800c93 <vprintfmt+0x1d7>
					putch('?', putdat);
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	53                   	push   %ebx
  800cd1:	6a 3f                	push   $0x3f
  800cd3:	ff d6                	call   *%esi
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	eb c3                	jmp    800c9d <vprintfmt+0x1e1>
  800cda:	89 cf                	mov    %ecx,%edi
  800cdc:	eb 0e                	jmp    800cec <vprintfmt+0x230>
				putch(' ', putdat);
  800cde:	83 ec 08             	sub    $0x8,%esp
  800ce1:	53                   	push   %ebx
  800ce2:	6a 20                	push   $0x20
  800ce4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800ce6:	83 ef 01             	sub    $0x1,%edi
  800ce9:	83 c4 10             	add    $0x10,%esp
  800cec:	85 ff                	test   %edi,%edi
  800cee:	7f ee                	jg     800cde <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800cf0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800cf3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf6:	e9 67 01 00 00       	jmp    800e62 <vprintfmt+0x3a6>
  800cfb:	89 cf                	mov    %ecx,%edi
  800cfd:	eb ed                	jmp    800cec <vprintfmt+0x230>
	if (lflag >= 2)
  800cff:	83 f9 01             	cmp    $0x1,%ecx
  800d02:	7f 1b                	jg     800d1f <vprintfmt+0x263>
	else if (lflag)
  800d04:	85 c9                	test   %ecx,%ecx
  800d06:	74 63                	je     800d6b <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	8b 00                	mov    (%eax),%eax
  800d0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d10:	99                   	cltd   
  800d11:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d14:	8b 45 14             	mov    0x14(%ebp),%eax
  800d17:	8d 40 04             	lea    0x4(%eax),%eax
  800d1a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1d:	eb 17                	jmp    800d36 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800d1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d22:	8b 50 04             	mov    0x4(%eax),%edx
  800d25:	8b 00                	mov    (%eax),%eax
  800d27:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d2a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	8d 40 08             	lea    0x8(%eax),%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800d36:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800d39:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800d3c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800d41:	85 c9                	test   %ecx,%ecx
  800d43:	0f 89 ff 00 00 00    	jns    800e48 <vprintfmt+0x38c>
				putch('-', putdat);
  800d49:	83 ec 08             	sub    $0x8,%esp
  800d4c:	53                   	push   %ebx
  800d4d:	6a 2d                	push   $0x2d
  800d4f:	ff d6                	call   *%esi
				num = -(long long) num;
  800d51:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800d54:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800d57:	f7 da                	neg    %edx
  800d59:	83 d1 00             	adc    $0x0,%ecx
  800d5c:	f7 d9                	neg    %ecx
  800d5e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800d61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d66:	e9 dd 00 00 00       	jmp    800e48 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800d6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6e:	8b 00                	mov    (%eax),%eax
  800d70:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d73:	99                   	cltd   
  800d74:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d77:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7a:	8d 40 04             	lea    0x4(%eax),%eax
  800d7d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d80:	eb b4                	jmp    800d36 <vprintfmt+0x27a>
	if (lflag >= 2)
  800d82:	83 f9 01             	cmp    $0x1,%ecx
  800d85:	7f 1e                	jg     800da5 <vprintfmt+0x2e9>
	else if (lflag)
  800d87:	85 c9                	test   %ecx,%ecx
  800d89:	74 32                	je     800dbd <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800d8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8e:	8b 10                	mov    (%eax),%edx
  800d90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d95:	8d 40 04             	lea    0x4(%eax),%eax
  800d98:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d9b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800da0:	e9 a3 00 00 00       	jmp    800e48 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800da5:	8b 45 14             	mov    0x14(%ebp),%eax
  800da8:	8b 10                	mov    (%eax),%edx
  800daa:	8b 48 04             	mov    0x4(%eax),%ecx
  800dad:	8d 40 08             	lea    0x8(%eax),%eax
  800db0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800db3:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800db8:	e9 8b 00 00 00       	jmp    800e48 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800dbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc0:	8b 10                	mov    (%eax),%edx
  800dc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc7:	8d 40 04             	lea    0x4(%eax),%eax
  800dca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800dcd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800dd2:	eb 74                	jmp    800e48 <vprintfmt+0x38c>
	if (lflag >= 2)
  800dd4:	83 f9 01             	cmp    $0x1,%ecx
  800dd7:	7f 1b                	jg     800df4 <vprintfmt+0x338>
	else if (lflag)
  800dd9:	85 c9                	test   %ecx,%ecx
  800ddb:	74 2c                	je     800e09 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800ddd:	8b 45 14             	mov    0x14(%ebp),%eax
  800de0:	8b 10                	mov    (%eax),%edx
  800de2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de7:	8d 40 04             	lea    0x4(%eax),%eax
  800dea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ded:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800df2:	eb 54                	jmp    800e48 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800df4:	8b 45 14             	mov    0x14(%ebp),%eax
  800df7:	8b 10                	mov    (%eax),%edx
  800df9:	8b 48 04             	mov    0x4(%eax),%ecx
  800dfc:	8d 40 08             	lea    0x8(%eax),%eax
  800dff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800e02:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800e07:	eb 3f                	jmp    800e48 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800e09:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0c:	8b 10                	mov    (%eax),%edx
  800e0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e13:	8d 40 04             	lea    0x4(%eax),%eax
  800e16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800e19:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800e1e:	eb 28                	jmp    800e48 <vprintfmt+0x38c>
			putch('0', putdat);
  800e20:	83 ec 08             	sub    $0x8,%esp
  800e23:	53                   	push   %ebx
  800e24:	6a 30                	push   $0x30
  800e26:	ff d6                	call   *%esi
			putch('x', putdat);
  800e28:	83 c4 08             	add    $0x8,%esp
  800e2b:	53                   	push   %ebx
  800e2c:	6a 78                	push   $0x78
  800e2e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800e30:	8b 45 14             	mov    0x14(%ebp),%eax
  800e33:	8b 10                	mov    (%eax),%edx
  800e35:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800e3a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800e3d:	8d 40 04             	lea    0x4(%eax),%eax
  800e40:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e43:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800e4f:	57                   	push   %edi
  800e50:	ff 75 e0             	pushl  -0x20(%ebp)
  800e53:	50                   	push   %eax
  800e54:	51                   	push   %ecx
  800e55:	52                   	push   %edx
  800e56:	89 da                	mov    %ebx,%edx
  800e58:	89 f0                	mov    %esi,%eax
  800e5a:	e8 72 fb ff ff       	call   8009d1 <printnum>
			break;
  800e5f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800e62:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e65:	83 c7 01             	add    $0x1,%edi
  800e68:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e6c:	83 f8 25             	cmp    $0x25,%eax
  800e6f:	0f 84 62 fc ff ff    	je     800ad7 <vprintfmt+0x1b>
			if (ch == '\0')
  800e75:	85 c0                	test   %eax,%eax
  800e77:	0f 84 8b 00 00 00    	je     800f08 <vprintfmt+0x44c>
			putch(ch, putdat);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	53                   	push   %ebx
  800e81:	50                   	push   %eax
  800e82:	ff d6                	call   *%esi
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	eb dc                	jmp    800e65 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800e89:	83 f9 01             	cmp    $0x1,%ecx
  800e8c:	7f 1b                	jg     800ea9 <vprintfmt+0x3ed>
	else if (lflag)
  800e8e:	85 c9                	test   %ecx,%ecx
  800e90:	74 2c                	je     800ebe <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800e92:	8b 45 14             	mov    0x14(%ebp),%eax
  800e95:	8b 10                	mov    (%eax),%edx
  800e97:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e9c:	8d 40 04             	lea    0x4(%eax),%eax
  800e9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ea2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800ea7:	eb 9f                	jmp    800e48 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800ea9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eac:	8b 10                	mov    (%eax),%edx
  800eae:	8b 48 04             	mov    0x4(%eax),%ecx
  800eb1:	8d 40 08             	lea    0x8(%eax),%eax
  800eb4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800eb7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800ebc:	eb 8a                	jmp    800e48 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800ebe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec1:	8b 10                	mov    (%eax),%edx
  800ec3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec8:	8d 40 04             	lea    0x4(%eax),%eax
  800ecb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ece:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800ed3:	e9 70 ff ff ff       	jmp    800e48 <vprintfmt+0x38c>
			putch(ch, putdat);
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	53                   	push   %ebx
  800edc:	6a 25                	push   $0x25
  800ede:	ff d6                	call   *%esi
			break;
  800ee0:	83 c4 10             	add    $0x10,%esp
  800ee3:	e9 7a ff ff ff       	jmp    800e62 <vprintfmt+0x3a6>
			putch('%', putdat);
  800ee8:	83 ec 08             	sub    $0x8,%esp
  800eeb:	53                   	push   %ebx
  800eec:	6a 25                	push   $0x25
  800eee:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ef0:	83 c4 10             	add    $0x10,%esp
  800ef3:	89 f8                	mov    %edi,%eax
  800ef5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ef9:	74 05                	je     800f00 <vprintfmt+0x444>
  800efb:	83 e8 01             	sub    $0x1,%eax
  800efe:	eb f5                	jmp    800ef5 <vprintfmt+0x439>
  800f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f03:	e9 5a ff ff ff       	jmp    800e62 <vprintfmt+0x3a6>
}
  800f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f10:	f3 0f 1e fb          	endbr32 
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 18             	sub    $0x18,%esp
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f23:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800f27:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800f2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	74 26                	je     800f5b <vsnprintf+0x4b>
  800f35:	85 d2                	test   %edx,%edx
  800f37:	7e 22                	jle    800f5b <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f39:	ff 75 14             	pushl  0x14(%ebp)
  800f3c:	ff 75 10             	pushl  0x10(%ebp)
  800f3f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f42:	50                   	push   %eax
  800f43:	68 7a 0a 80 00       	push   $0x800a7a
  800f48:	e8 6f fb ff ff       	call   800abc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f50:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f56:	83 c4 10             	add    $0x10,%esp
}
  800f59:	c9                   	leave  
  800f5a:	c3                   	ret    
		return -E_INVAL;
  800f5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f60:	eb f7                	jmp    800f59 <vsnprintf+0x49>

00800f62 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f62:	f3 0f 1e fb          	endbr32 
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f6c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800f6f:	50                   	push   %eax
  800f70:	ff 75 10             	pushl  0x10(%ebp)
  800f73:	ff 75 0c             	pushl  0xc(%ebp)
  800f76:	ff 75 08             	pushl  0x8(%ebp)
  800f79:	e8 92 ff ff ff       	call   800f10 <vsnprintf>
	va_end(ap);

	return rc;
}
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f80:	f3 0f 1e fb          	endbr32 
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f93:	74 05                	je     800f9a <strlen+0x1a>
		n++;
  800f95:	83 c0 01             	add    $0x1,%eax
  800f98:	eb f5                	jmp    800f8f <strlen+0xf>
	return n;
}
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f9c:	f3 0f 1e fb          	endbr32 
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fae:	39 d0                	cmp    %edx,%eax
  800fb0:	74 0d                	je     800fbf <strnlen+0x23>
  800fb2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800fb6:	74 05                	je     800fbd <strnlen+0x21>
		n++;
  800fb8:	83 c0 01             	add    $0x1,%eax
  800fbb:	eb f1                	jmp    800fae <strnlen+0x12>
  800fbd:	89 c2                	mov    %eax,%edx
	return n;
}
  800fbf:	89 d0                	mov    %edx,%eax
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fc3:	f3 0f 1e fb          	endbr32 
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	53                   	push   %ebx
  800fcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800fda:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800fdd:	83 c0 01             	add    $0x1,%eax
  800fe0:	84 d2                	test   %dl,%dl
  800fe2:	75 f2                	jne    800fd6 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800fe4:	89 c8                	mov    %ecx,%eax
  800fe6:	5b                   	pop    %ebx
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    

00800fe9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fe9:	f3 0f 1e fb          	endbr32 
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	53                   	push   %ebx
  800ff1:	83 ec 10             	sub    $0x10,%esp
  800ff4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ff7:	53                   	push   %ebx
  800ff8:	e8 83 ff ff ff       	call   800f80 <strlen>
  800ffd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801000:	ff 75 0c             	pushl  0xc(%ebp)
  801003:	01 d8                	add    %ebx,%eax
  801005:	50                   	push   %eax
  801006:	e8 b8 ff ff ff       	call   800fc3 <strcpy>
	return dst;
}
  80100b:	89 d8                	mov    %ebx,%eax
  80100d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801012:	f3 0f 1e fb          	endbr32 
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	56                   	push   %esi
  80101a:	53                   	push   %ebx
  80101b:	8b 75 08             	mov    0x8(%ebp),%esi
  80101e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801021:	89 f3                	mov    %esi,%ebx
  801023:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801026:	89 f0                	mov    %esi,%eax
  801028:	39 d8                	cmp    %ebx,%eax
  80102a:	74 11                	je     80103d <strncpy+0x2b>
		*dst++ = *src;
  80102c:	83 c0 01             	add    $0x1,%eax
  80102f:	0f b6 0a             	movzbl (%edx),%ecx
  801032:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801035:	80 f9 01             	cmp    $0x1,%cl
  801038:	83 da ff             	sbb    $0xffffffff,%edx
  80103b:	eb eb                	jmp    801028 <strncpy+0x16>
	}
	return ret;
}
  80103d:	89 f0                	mov    %esi,%eax
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    

00801043 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801043:	f3 0f 1e fb          	endbr32 
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	56                   	push   %esi
  80104b:	53                   	push   %ebx
  80104c:	8b 75 08             	mov    0x8(%ebp),%esi
  80104f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801052:	8b 55 10             	mov    0x10(%ebp),%edx
  801055:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801057:	85 d2                	test   %edx,%edx
  801059:	74 21                	je     80107c <strlcpy+0x39>
  80105b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80105f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801061:	39 c2                	cmp    %eax,%edx
  801063:	74 14                	je     801079 <strlcpy+0x36>
  801065:	0f b6 19             	movzbl (%ecx),%ebx
  801068:	84 db                	test   %bl,%bl
  80106a:	74 0b                	je     801077 <strlcpy+0x34>
			*dst++ = *src++;
  80106c:	83 c1 01             	add    $0x1,%ecx
  80106f:	83 c2 01             	add    $0x1,%edx
  801072:	88 5a ff             	mov    %bl,-0x1(%edx)
  801075:	eb ea                	jmp    801061 <strlcpy+0x1e>
  801077:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801079:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80107c:	29 f0                	sub    %esi,%eax
}
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    

00801082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801082:	f3 0f 1e fb          	endbr32 
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80108f:	0f b6 01             	movzbl (%ecx),%eax
  801092:	84 c0                	test   %al,%al
  801094:	74 0c                	je     8010a2 <strcmp+0x20>
  801096:	3a 02                	cmp    (%edx),%al
  801098:	75 08                	jne    8010a2 <strcmp+0x20>
		p++, q++;
  80109a:	83 c1 01             	add    $0x1,%ecx
  80109d:	83 c2 01             	add    $0x1,%edx
  8010a0:	eb ed                	jmp    80108f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010a2:	0f b6 c0             	movzbl %al,%eax
  8010a5:	0f b6 12             	movzbl (%edx),%edx
  8010a8:	29 d0                	sub    %edx,%eax
}
  8010aa:	5d                   	pop    %ebp
  8010ab:	c3                   	ret    

008010ac <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010ac:	f3 0f 1e fb          	endbr32 
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	53                   	push   %ebx
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ba:	89 c3                	mov    %eax,%ebx
  8010bc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8010bf:	eb 06                	jmp    8010c7 <strncmp+0x1b>
		n--, p++, q++;
  8010c1:	83 c0 01             	add    $0x1,%eax
  8010c4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8010c7:	39 d8                	cmp    %ebx,%eax
  8010c9:	74 16                	je     8010e1 <strncmp+0x35>
  8010cb:	0f b6 08             	movzbl (%eax),%ecx
  8010ce:	84 c9                	test   %cl,%cl
  8010d0:	74 04                	je     8010d6 <strncmp+0x2a>
  8010d2:	3a 0a                	cmp    (%edx),%cl
  8010d4:	74 eb                	je     8010c1 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d6:	0f b6 00             	movzbl (%eax),%eax
  8010d9:	0f b6 12             	movzbl (%edx),%edx
  8010dc:	29 d0                	sub    %edx,%eax
}
  8010de:	5b                   	pop    %ebx
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    
		return 0;
  8010e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e6:	eb f6                	jmp    8010de <strncmp+0x32>

008010e8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010e8:	f3 0f 1e fb          	endbr32 
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8010f6:	0f b6 10             	movzbl (%eax),%edx
  8010f9:	84 d2                	test   %dl,%dl
  8010fb:	74 09                	je     801106 <strchr+0x1e>
		if (*s == c)
  8010fd:	38 ca                	cmp    %cl,%dl
  8010ff:	74 0a                	je     80110b <strchr+0x23>
	for (; *s; s++)
  801101:	83 c0 01             	add    $0x1,%eax
  801104:	eb f0                	jmp    8010f6 <strchr+0xe>
			return (char *) s;
	return 0;
  801106:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110b:	5d                   	pop    %ebp
  80110c:	c3                   	ret    

0080110d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80110d:	f3 0f 1e fb          	endbr32 
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80111b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80111e:	38 ca                	cmp    %cl,%dl
  801120:	74 09                	je     80112b <strfind+0x1e>
  801122:	84 d2                	test   %dl,%dl
  801124:	74 05                	je     80112b <strfind+0x1e>
	for (; *s; s++)
  801126:	83 c0 01             	add    $0x1,%eax
  801129:	eb f0                	jmp    80111b <strfind+0xe>
			break;
	return (char *) s;
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80112d:	f3 0f 1e fb          	endbr32 
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	57                   	push   %edi
  801135:	56                   	push   %esi
  801136:	53                   	push   %ebx
  801137:	8b 7d 08             	mov    0x8(%ebp),%edi
  80113a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80113d:	85 c9                	test   %ecx,%ecx
  80113f:	74 31                	je     801172 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801141:	89 f8                	mov    %edi,%eax
  801143:	09 c8                	or     %ecx,%eax
  801145:	a8 03                	test   $0x3,%al
  801147:	75 23                	jne    80116c <memset+0x3f>
		c &= 0xFF;
  801149:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80114d:	89 d3                	mov    %edx,%ebx
  80114f:	c1 e3 08             	shl    $0x8,%ebx
  801152:	89 d0                	mov    %edx,%eax
  801154:	c1 e0 18             	shl    $0x18,%eax
  801157:	89 d6                	mov    %edx,%esi
  801159:	c1 e6 10             	shl    $0x10,%esi
  80115c:	09 f0                	or     %esi,%eax
  80115e:	09 c2                	or     %eax,%edx
  801160:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801162:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801165:	89 d0                	mov    %edx,%eax
  801167:	fc                   	cld    
  801168:	f3 ab                	rep stos %eax,%es:(%edi)
  80116a:	eb 06                	jmp    801172 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	fc                   	cld    
  801170:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801172:	89 f8                	mov    %edi,%eax
  801174:	5b                   	pop    %ebx
  801175:	5e                   	pop    %esi
  801176:	5f                   	pop    %edi
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801179:	f3 0f 1e fb          	endbr32 
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	57                   	push   %edi
  801181:	56                   	push   %esi
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8b 75 0c             	mov    0xc(%ebp),%esi
  801188:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80118b:	39 c6                	cmp    %eax,%esi
  80118d:	73 32                	jae    8011c1 <memmove+0x48>
  80118f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801192:	39 c2                	cmp    %eax,%edx
  801194:	76 2b                	jbe    8011c1 <memmove+0x48>
		s += n;
		d += n;
  801196:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801199:	89 fe                	mov    %edi,%esi
  80119b:	09 ce                	or     %ecx,%esi
  80119d:	09 d6                	or     %edx,%esi
  80119f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8011a5:	75 0e                	jne    8011b5 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011a7:	83 ef 04             	sub    $0x4,%edi
  8011aa:	8d 72 fc             	lea    -0x4(%edx),%esi
  8011ad:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8011b0:	fd                   	std    
  8011b1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011b3:	eb 09                	jmp    8011be <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011b5:	83 ef 01             	sub    $0x1,%edi
  8011b8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8011bb:	fd                   	std    
  8011bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011be:	fc                   	cld    
  8011bf:	eb 1a                	jmp    8011db <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011c1:	89 c2                	mov    %eax,%edx
  8011c3:	09 ca                	or     %ecx,%edx
  8011c5:	09 f2                	or     %esi,%edx
  8011c7:	f6 c2 03             	test   $0x3,%dl
  8011ca:	75 0a                	jne    8011d6 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011cc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8011cf:	89 c7                	mov    %eax,%edi
  8011d1:	fc                   	cld    
  8011d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011d4:	eb 05                	jmp    8011db <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8011d6:	89 c7                	mov    %eax,%edi
  8011d8:	fc                   	cld    
  8011d9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8011db:	5e                   	pop    %esi
  8011dc:	5f                   	pop    %edi
  8011dd:	5d                   	pop    %ebp
  8011de:	c3                   	ret    

008011df <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8011df:	f3 0f 1e fb          	endbr32 
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8011e9:	ff 75 10             	pushl  0x10(%ebp)
  8011ec:	ff 75 0c             	pushl  0xc(%ebp)
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 82 ff ff ff       	call   801179 <memmove>
}
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    

008011f9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8011f9:	f3 0f 1e fb          	endbr32 
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	56                   	push   %esi
  801201:	53                   	push   %ebx
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8b 55 0c             	mov    0xc(%ebp),%edx
  801208:	89 c6                	mov    %eax,%esi
  80120a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80120d:	39 f0                	cmp    %esi,%eax
  80120f:	74 1c                	je     80122d <memcmp+0x34>
		if (*s1 != *s2)
  801211:	0f b6 08             	movzbl (%eax),%ecx
  801214:	0f b6 1a             	movzbl (%edx),%ebx
  801217:	38 d9                	cmp    %bl,%cl
  801219:	75 08                	jne    801223 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80121b:	83 c0 01             	add    $0x1,%eax
  80121e:	83 c2 01             	add    $0x1,%edx
  801221:	eb ea                	jmp    80120d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801223:	0f b6 c1             	movzbl %cl,%eax
  801226:	0f b6 db             	movzbl %bl,%ebx
  801229:	29 d8                	sub    %ebx,%eax
  80122b:	eb 05                	jmp    801232 <memcmp+0x39>
	}

	return 0;
  80122d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801232:	5b                   	pop    %ebx
  801233:	5e                   	pop    %esi
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801236:	f3 0f 1e fb          	endbr32 
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801243:	89 c2                	mov    %eax,%edx
  801245:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801248:	39 d0                	cmp    %edx,%eax
  80124a:	73 09                	jae    801255 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80124c:	38 08                	cmp    %cl,(%eax)
  80124e:	74 05                	je     801255 <memfind+0x1f>
	for (; s < ends; s++)
  801250:	83 c0 01             	add    $0x1,%eax
  801253:	eb f3                	jmp    801248 <memfind+0x12>
			break;
	return (void *) s;
}
  801255:	5d                   	pop    %ebp
  801256:	c3                   	ret    

00801257 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801257:	f3 0f 1e fb          	endbr32 
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	57                   	push   %edi
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801264:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801267:	eb 03                	jmp    80126c <strtol+0x15>
		s++;
  801269:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80126c:	0f b6 01             	movzbl (%ecx),%eax
  80126f:	3c 20                	cmp    $0x20,%al
  801271:	74 f6                	je     801269 <strtol+0x12>
  801273:	3c 09                	cmp    $0x9,%al
  801275:	74 f2                	je     801269 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801277:	3c 2b                	cmp    $0x2b,%al
  801279:	74 2a                	je     8012a5 <strtol+0x4e>
	int neg = 0;
  80127b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801280:	3c 2d                	cmp    $0x2d,%al
  801282:	74 2b                	je     8012af <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801284:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80128a:	75 0f                	jne    80129b <strtol+0x44>
  80128c:	80 39 30             	cmpb   $0x30,(%ecx)
  80128f:	74 28                	je     8012b9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801291:	85 db                	test   %ebx,%ebx
  801293:	b8 0a 00 00 00       	mov    $0xa,%eax
  801298:	0f 44 d8             	cmove  %eax,%ebx
  80129b:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8012a3:	eb 46                	jmp    8012eb <strtol+0x94>
		s++;
  8012a5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8012a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8012ad:	eb d5                	jmp    801284 <strtol+0x2d>
		s++, neg = 1;
  8012af:	83 c1 01             	add    $0x1,%ecx
  8012b2:	bf 01 00 00 00       	mov    $0x1,%edi
  8012b7:	eb cb                	jmp    801284 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012b9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8012bd:	74 0e                	je     8012cd <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8012bf:	85 db                	test   %ebx,%ebx
  8012c1:	75 d8                	jne    80129b <strtol+0x44>
		s++, base = 8;
  8012c3:	83 c1 01             	add    $0x1,%ecx
  8012c6:	bb 08 00 00 00       	mov    $0x8,%ebx
  8012cb:	eb ce                	jmp    80129b <strtol+0x44>
		s += 2, base = 16;
  8012cd:	83 c1 02             	add    $0x2,%ecx
  8012d0:	bb 10 00 00 00       	mov    $0x10,%ebx
  8012d5:	eb c4                	jmp    80129b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8012d7:	0f be d2             	movsbl %dl,%edx
  8012da:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8012dd:	3b 55 10             	cmp    0x10(%ebp),%edx
  8012e0:	7d 3a                	jge    80131c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8012e2:	83 c1 01             	add    $0x1,%ecx
  8012e5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012e9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8012eb:	0f b6 11             	movzbl (%ecx),%edx
  8012ee:	8d 72 d0             	lea    -0x30(%edx),%esi
  8012f1:	89 f3                	mov    %esi,%ebx
  8012f3:	80 fb 09             	cmp    $0x9,%bl
  8012f6:	76 df                	jbe    8012d7 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  8012f8:	8d 72 9f             	lea    -0x61(%edx),%esi
  8012fb:	89 f3                	mov    %esi,%ebx
  8012fd:	80 fb 19             	cmp    $0x19,%bl
  801300:	77 08                	ja     80130a <strtol+0xb3>
			dig = *s - 'a' + 10;
  801302:	0f be d2             	movsbl %dl,%edx
  801305:	83 ea 57             	sub    $0x57,%edx
  801308:	eb d3                	jmp    8012dd <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  80130a:	8d 72 bf             	lea    -0x41(%edx),%esi
  80130d:	89 f3                	mov    %esi,%ebx
  80130f:	80 fb 19             	cmp    $0x19,%bl
  801312:	77 08                	ja     80131c <strtol+0xc5>
			dig = *s - 'A' + 10;
  801314:	0f be d2             	movsbl %dl,%edx
  801317:	83 ea 37             	sub    $0x37,%edx
  80131a:	eb c1                	jmp    8012dd <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80131c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801320:	74 05                	je     801327 <strtol+0xd0>
		*endptr = (char *) s;
  801322:	8b 75 0c             	mov    0xc(%ebp),%esi
  801325:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801327:	89 c2                	mov    %eax,%edx
  801329:	f7 da                	neg    %edx
  80132b:	85 ff                	test   %edi,%edi
  80132d:	0f 45 c2             	cmovne %edx,%eax
}
  801330:	5b                   	pop    %ebx
  801331:	5e                   	pop    %esi
  801332:	5f                   	pop    %edi
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801335:	f3 0f 1e fb          	endbr32 
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	57                   	push   %edi
  80133d:	56                   	push   %esi
  80133e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80133f:	b8 00 00 00 00       	mov    $0x0,%eax
  801344:	8b 55 08             	mov    0x8(%ebp),%edx
  801347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134a:	89 c3                	mov    %eax,%ebx
  80134c:	89 c7                	mov    %eax,%edi
  80134e:	89 c6                	mov    %eax,%esi
  801350:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801352:	5b                   	pop    %ebx
  801353:	5e                   	pop    %esi
  801354:	5f                   	pop    %edi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    

00801357 <sys_cgetc>:

int
sys_cgetc(void)
{
  801357:	f3 0f 1e fb          	endbr32 
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	57                   	push   %edi
  80135f:	56                   	push   %esi
  801360:	53                   	push   %ebx
	asm volatile("int %1\n"
  801361:	ba 00 00 00 00       	mov    $0x0,%edx
  801366:	b8 01 00 00 00       	mov    $0x1,%eax
  80136b:	89 d1                	mov    %edx,%ecx
  80136d:	89 d3                	mov    %edx,%ebx
  80136f:	89 d7                	mov    %edx,%edi
  801371:	89 d6                	mov    %edx,%esi
  801373:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801375:	5b                   	pop    %ebx
  801376:	5e                   	pop    %esi
  801377:	5f                   	pop    %edi
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80137a:	f3 0f 1e fb          	endbr32 
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	57                   	push   %edi
  801382:	56                   	push   %esi
  801383:	53                   	push   %ebx
  801384:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801387:	b9 00 00 00 00       	mov    $0x0,%ecx
  80138c:	8b 55 08             	mov    0x8(%ebp),%edx
  80138f:	b8 03 00 00 00       	mov    $0x3,%eax
  801394:	89 cb                	mov    %ecx,%ebx
  801396:	89 cf                	mov    %ecx,%edi
  801398:	89 ce                	mov    %ecx,%esi
  80139a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80139c:	85 c0                	test   %eax,%eax
  80139e:	7f 08                	jg     8013a8 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a3:	5b                   	pop    %ebx
  8013a4:	5e                   	pop    %esi
  8013a5:	5f                   	pop    %edi
  8013a6:	5d                   	pop    %ebp
  8013a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a8:	83 ec 0c             	sub    $0xc,%esp
  8013ab:	50                   	push   %eax
  8013ac:	6a 03                	push   $0x3
  8013ae:	68 bf 34 80 00       	push   $0x8034bf
  8013b3:	6a 23                	push   $0x23
  8013b5:	68 dc 34 80 00       	push   $0x8034dc
  8013ba:	e8 13 f5 ff ff       	call   8008d2 <_panic>

008013bf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8013bf:	f3 0f 1e fb          	endbr32 
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	57                   	push   %edi
  8013c7:	56                   	push   %esi
  8013c8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8013d3:	89 d1                	mov    %edx,%ecx
  8013d5:	89 d3                	mov    %edx,%ebx
  8013d7:	89 d7                	mov    %edx,%edi
  8013d9:	89 d6                	mov    %edx,%esi
  8013db:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013dd:	5b                   	pop    %ebx
  8013de:	5e                   	pop    %esi
  8013df:	5f                   	pop    %edi
  8013e0:	5d                   	pop    %ebp
  8013e1:	c3                   	ret    

008013e2 <sys_yield>:

void
sys_yield(void)
{
  8013e2:	f3 0f 1e fb          	endbr32 
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	57                   	push   %edi
  8013ea:	56                   	push   %esi
  8013eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f1:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013f6:	89 d1                	mov    %edx,%ecx
  8013f8:	89 d3                	mov    %edx,%ebx
  8013fa:	89 d7                	mov    %edx,%edi
  8013fc:	89 d6                	mov    %edx,%esi
  8013fe:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801400:	5b                   	pop    %ebx
  801401:	5e                   	pop    %esi
  801402:	5f                   	pop    %edi
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    

00801405 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801405:	f3 0f 1e fb          	endbr32 
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	57                   	push   %edi
  80140d:	56                   	push   %esi
  80140e:	53                   	push   %ebx
  80140f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801412:	be 00 00 00 00       	mov    $0x0,%esi
  801417:	8b 55 08             	mov    0x8(%ebp),%edx
  80141a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141d:	b8 04 00 00 00       	mov    $0x4,%eax
  801422:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801425:	89 f7                	mov    %esi,%edi
  801427:	cd 30                	int    $0x30
	if(check && ret > 0)
  801429:	85 c0                	test   %eax,%eax
  80142b:	7f 08                	jg     801435 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801430:	5b                   	pop    %ebx
  801431:	5e                   	pop    %esi
  801432:	5f                   	pop    %edi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801435:	83 ec 0c             	sub    $0xc,%esp
  801438:	50                   	push   %eax
  801439:	6a 04                	push   $0x4
  80143b:	68 bf 34 80 00       	push   $0x8034bf
  801440:	6a 23                	push   $0x23
  801442:	68 dc 34 80 00       	push   $0x8034dc
  801447:	e8 86 f4 ff ff       	call   8008d2 <_panic>

0080144c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80144c:	f3 0f 1e fb          	endbr32 
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	57                   	push   %edi
  801454:	56                   	push   %esi
  801455:	53                   	push   %ebx
  801456:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801459:	8b 55 08             	mov    0x8(%ebp),%edx
  80145c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145f:	b8 05 00 00 00       	mov    $0x5,%eax
  801464:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801467:	8b 7d 14             	mov    0x14(%ebp),%edi
  80146a:	8b 75 18             	mov    0x18(%ebp),%esi
  80146d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80146f:	85 c0                	test   %eax,%eax
  801471:	7f 08                	jg     80147b <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801473:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801476:	5b                   	pop    %ebx
  801477:	5e                   	pop    %esi
  801478:	5f                   	pop    %edi
  801479:	5d                   	pop    %ebp
  80147a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	50                   	push   %eax
  80147f:	6a 05                	push   $0x5
  801481:	68 bf 34 80 00       	push   $0x8034bf
  801486:	6a 23                	push   $0x23
  801488:	68 dc 34 80 00       	push   $0x8034dc
  80148d:	e8 40 f4 ff ff       	call   8008d2 <_panic>

00801492 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801492:	f3 0f 1e fb          	endbr32 
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	57                   	push   %edi
  80149a:	56                   	push   %esi
  80149b:	53                   	push   %ebx
  80149c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80149f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014aa:	b8 06 00 00 00       	mov    $0x6,%eax
  8014af:	89 df                	mov    %ebx,%edi
  8014b1:	89 de                	mov    %ebx,%esi
  8014b3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	7f 08                	jg     8014c1 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8014b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014bc:	5b                   	pop    %ebx
  8014bd:	5e                   	pop    %esi
  8014be:	5f                   	pop    %edi
  8014bf:	5d                   	pop    %ebp
  8014c0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014c1:	83 ec 0c             	sub    $0xc,%esp
  8014c4:	50                   	push   %eax
  8014c5:	6a 06                	push   $0x6
  8014c7:	68 bf 34 80 00       	push   $0x8034bf
  8014cc:	6a 23                	push   $0x23
  8014ce:	68 dc 34 80 00       	push   $0x8034dc
  8014d3:	e8 fa f3 ff ff       	call   8008d2 <_panic>

008014d8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8014d8:	f3 0f 1e fb          	endbr32 
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	57                   	push   %edi
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
  8014e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f0:	b8 08 00 00 00       	mov    $0x8,%eax
  8014f5:	89 df                	mov    %ebx,%edi
  8014f7:	89 de                	mov    %ebx,%esi
  8014f9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	7f 08                	jg     801507 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8014ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801502:	5b                   	pop    %ebx
  801503:	5e                   	pop    %esi
  801504:	5f                   	pop    %edi
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801507:	83 ec 0c             	sub    $0xc,%esp
  80150a:	50                   	push   %eax
  80150b:	6a 08                	push   $0x8
  80150d:	68 bf 34 80 00       	push   $0x8034bf
  801512:	6a 23                	push   $0x23
  801514:	68 dc 34 80 00       	push   $0x8034dc
  801519:	e8 b4 f3 ff ff       	call   8008d2 <_panic>

0080151e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80151e:	f3 0f 1e fb          	endbr32 
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	57                   	push   %edi
  801526:	56                   	push   %esi
  801527:	53                   	push   %ebx
  801528:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80152b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801530:	8b 55 08             	mov    0x8(%ebp),%edx
  801533:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801536:	b8 09 00 00 00       	mov    $0x9,%eax
  80153b:	89 df                	mov    %ebx,%edi
  80153d:	89 de                	mov    %ebx,%esi
  80153f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801541:	85 c0                	test   %eax,%eax
  801543:	7f 08                	jg     80154d <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801545:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801548:	5b                   	pop    %ebx
  801549:	5e                   	pop    %esi
  80154a:	5f                   	pop    %edi
  80154b:	5d                   	pop    %ebp
  80154c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	50                   	push   %eax
  801551:	6a 09                	push   $0x9
  801553:	68 bf 34 80 00       	push   $0x8034bf
  801558:	6a 23                	push   $0x23
  80155a:	68 dc 34 80 00       	push   $0x8034dc
  80155f:	e8 6e f3 ff ff       	call   8008d2 <_panic>

00801564 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801564:	f3 0f 1e fb          	endbr32 
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	57                   	push   %edi
  80156c:	56                   	push   %esi
  80156d:	53                   	push   %ebx
  80156e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801571:	bb 00 00 00 00       	mov    $0x0,%ebx
  801576:	8b 55 08             	mov    0x8(%ebp),%edx
  801579:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801581:	89 df                	mov    %ebx,%edi
  801583:	89 de                	mov    %ebx,%esi
  801585:	cd 30                	int    $0x30
	if(check && ret > 0)
  801587:	85 c0                	test   %eax,%eax
  801589:	7f 08                	jg     801593 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80158b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80158e:	5b                   	pop    %ebx
  80158f:	5e                   	pop    %esi
  801590:	5f                   	pop    %edi
  801591:	5d                   	pop    %ebp
  801592:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801593:	83 ec 0c             	sub    $0xc,%esp
  801596:	50                   	push   %eax
  801597:	6a 0a                	push   $0xa
  801599:	68 bf 34 80 00       	push   $0x8034bf
  80159e:	6a 23                	push   $0x23
  8015a0:	68 dc 34 80 00       	push   $0x8034dc
  8015a5:	e8 28 f3 ff ff       	call   8008d2 <_panic>

008015aa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8015aa:	f3 0f 1e fb          	endbr32 
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	57                   	push   %edi
  8015b2:	56                   	push   %esi
  8015b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015ba:	b8 0c 00 00 00       	mov    $0xc,%eax
  8015bf:	be 00 00 00 00       	mov    $0x0,%esi
  8015c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015c7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015ca:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8015cc:	5b                   	pop    %ebx
  8015cd:	5e                   	pop    %esi
  8015ce:	5f                   	pop    %edi
  8015cf:	5d                   	pop    %ebp
  8015d0:	c3                   	ret    

008015d1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8015d1:	f3 0f 1e fb          	endbr32 
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	57                   	push   %edi
  8015d9:	56                   	push   %esi
  8015da:	53                   	push   %ebx
  8015db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8015eb:	89 cb                	mov    %ecx,%ebx
  8015ed:	89 cf                	mov    %ecx,%edi
  8015ef:	89 ce                	mov    %ecx,%esi
  8015f1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	7f 08                	jg     8015ff <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8015f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	5f                   	pop    %edi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015ff:	83 ec 0c             	sub    $0xc,%esp
  801602:	50                   	push   %eax
  801603:	6a 0d                	push   $0xd
  801605:	68 bf 34 80 00       	push   $0x8034bf
  80160a:	6a 23                	push   $0x23
  80160c:	68 dc 34 80 00       	push   $0x8034dc
  801611:	e8 bc f2 ff ff       	call   8008d2 <_panic>

00801616 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801616:	f3 0f 1e fb          	endbr32 
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	57                   	push   %edi
  80161e:	56                   	push   %esi
  80161f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801620:	ba 00 00 00 00       	mov    $0x0,%edx
  801625:	b8 0e 00 00 00       	mov    $0xe,%eax
  80162a:	89 d1                	mov    %edx,%ecx
  80162c:	89 d3                	mov    %edx,%ebx
  80162e:	89 d7                	mov    %edx,%edi
  801630:	89 d6                	mov    %edx,%esi
  801632:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801634:	5b                   	pop    %ebx
  801635:	5e                   	pop    %esi
  801636:	5f                   	pop    %edi
  801637:	5d                   	pop    %ebp
  801638:	c3                   	ret    

00801639 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  801639:	f3 0f 1e fb          	endbr32 
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	57                   	push   %edi
  801641:	56                   	push   %esi
  801642:	53                   	push   %ebx
  801643:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801646:	bb 00 00 00 00       	mov    $0x0,%ebx
  80164b:	8b 55 08             	mov    0x8(%ebp),%edx
  80164e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801651:	b8 0f 00 00 00       	mov    $0xf,%eax
  801656:	89 df                	mov    %ebx,%edi
  801658:	89 de                	mov    %ebx,%esi
  80165a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80165c:	85 c0                	test   %eax,%eax
  80165e:	7f 08                	jg     801668 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  801660:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801663:	5b                   	pop    %ebx
  801664:	5e                   	pop    %esi
  801665:	5f                   	pop    %edi
  801666:	5d                   	pop    %ebp
  801667:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801668:	83 ec 0c             	sub    $0xc,%esp
  80166b:	50                   	push   %eax
  80166c:	6a 0f                	push   $0xf
  80166e:	68 bf 34 80 00       	push   $0x8034bf
  801673:	6a 23                	push   $0x23
  801675:	68 dc 34 80 00       	push   $0x8034dc
  80167a:	e8 53 f2 ff ff       	call   8008d2 <_panic>

0080167f <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  80167f:	f3 0f 1e fb          	endbr32 
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	57                   	push   %edi
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80168c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801691:	8b 55 08             	mov    0x8(%ebp),%edx
  801694:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801697:	b8 10 00 00 00       	mov    $0x10,%eax
  80169c:	89 df                	mov    %ebx,%edi
  80169e:	89 de                	mov    %ebx,%esi
  8016a0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	7f 08                	jg     8016ae <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  8016a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a9:	5b                   	pop    %ebx
  8016aa:	5e                   	pop    %esi
  8016ab:	5f                   	pop    %edi
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ae:	83 ec 0c             	sub    $0xc,%esp
  8016b1:	50                   	push   %eax
  8016b2:	6a 10                	push   $0x10
  8016b4:	68 bf 34 80 00       	push   $0x8034bf
  8016b9:	6a 23                	push   $0x23
  8016bb:	68 dc 34 80 00       	push   $0x8034dc
  8016c0:	e8 0d f2 ff ff       	call   8008d2 <_panic>

008016c5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8016c5:	f3 0f 1e fb          	endbr32 
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	53                   	push   %ebx
  8016cd:	83 ec 04             	sub    $0x4,%esp
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8016d3:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  8016d5:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8016d9:	74 74                	je     80174f <pgfault+0x8a>
  8016db:	89 d8                	mov    %ebx,%eax
  8016dd:	c1 e8 0c             	shr    $0xc,%eax
  8016e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016e7:	f6 c4 08             	test   $0x8,%ah
  8016ea:	74 63                	je     80174f <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  8016ec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	6a 05                	push   $0x5
  8016f7:	68 00 f0 7f 00       	push   $0x7ff000
  8016fc:	6a 00                	push   $0x0
  8016fe:	53                   	push   %ebx
  8016ff:	6a 00                	push   $0x0
  801701:	e8 46 fd ff ff       	call   80144c <sys_page_map>
  801706:	83 c4 20             	add    $0x20,%esp
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 59                	js     801766 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  80170d:	83 ec 04             	sub    $0x4,%esp
  801710:	6a 07                	push   $0x7
  801712:	53                   	push   %ebx
  801713:	6a 00                	push   $0x0
  801715:	e8 eb fc ff ff       	call   801405 <sys_page_alloc>
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 5a                	js     80177b <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	68 00 10 00 00       	push   $0x1000
  801729:	68 00 f0 7f 00       	push   $0x7ff000
  80172e:	53                   	push   %ebx
  80172f:	e8 45 fa ff ff       	call   801179 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  801734:	83 c4 08             	add    $0x8,%esp
  801737:	68 00 f0 7f 00       	push   $0x7ff000
  80173c:	6a 00                	push   $0x0
  80173e:	e8 4f fd ff ff       	call   801492 <sys_page_unmap>
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	85 c0                	test   %eax,%eax
  801748:	78 46                	js     801790 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  80174a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  80174f:	83 ec 04             	sub    $0x4,%esp
  801752:	68 ea 34 80 00       	push   $0x8034ea
  801757:	68 d3 00 00 00       	push   $0xd3
  80175c:	68 06 35 80 00       	push   $0x803506
  801761:	e8 6c f1 ff ff       	call   8008d2 <_panic>
		panic("pgfault: %e\n", r);
  801766:	50                   	push   %eax
  801767:	68 11 35 80 00       	push   $0x803511
  80176c:	68 df 00 00 00       	push   $0xdf
  801771:	68 06 35 80 00       	push   $0x803506
  801776:	e8 57 f1 ff ff       	call   8008d2 <_panic>
		panic("pgfault: %e\n", r);
  80177b:	50                   	push   %eax
  80177c:	68 11 35 80 00       	push   $0x803511
  801781:	68 e3 00 00 00       	push   $0xe3
  801786:	68 06 35 80 00       	push   $0x803506
  80178b:	e8 42 f1 ff ff       	call   8008d2 <_panic>
		panic("pgfault: %e\n", r);
  801790:	50                   	push   %eax
  801791:	68 11 35 80 00       	push   $0x803511
  801796:	68 e9 00 00 00       	push   $0xe9
  80179b:	68 06 35 80 00       	push   $0x803506
  8017a0:	e8 2d f1 ff ff       	call   8008d2 <_panic>

008017a5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8017a5:	f3 0f 1e fb          	endbr32 
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	57                   	push   %edi
  8017ad:	56                   	push   %esi
  8017ae:	53                   	push   %ebx
  8017af:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  8017b2:	68 c5 16 80 00       	push   $0x8016c5
  8017b7:	e8 1e 15 00 00       	call   802cda <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8017bc:	b8 07 00 00 00       	mov    $0x7,%eax
  8017c1:	cd 30                	int    $0x30
  8017c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 2d                	js     8017fa <fork+0x55>
  8017cd:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8017cf:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8017d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017d8:	0f 85 9b 00 00 00    	jne    801879 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  8017de:	e8 dc fb ff ff       	call   8013bf <sys_getenvid>
  8017e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017e8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8017eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8017f0:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  8017f5:	e9 71 01 00 00       	jmp    80196b <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  8017fa:	50                   	push   %eax
  8017fb:	68 1e 35 80 00       	push   $0x80351e
  801800:	68 2a 01 00 00       	push   $0x12a
  801805:	68 06 35 80 00       	push   $0x803506
  80180a:	e8 c3 f0 ff ff       	call   8008d2 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  80180f:	c1 e6 0c             	shl    $0xc,%esi
  801812:	83 ec 0c             	sub    $0xc,%esp
  801815:	68 07 0e 00 00       	push   $0xe07
  80181a:	56                   	push   %esi
  80181b:	57                   	push   %edi
  80181c:	56                   	push   %esi
  80181d:	6a 00                	push   $0x0
  80181f:	e8 28 fc ff ff       	call   80144c <sys_page_map>
  801824:	83 c4 20             	add    $0x20,%esp
  801827:	eb 3e                	jmp    801867 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801829:	c1 e6 0c             	shl    $0xc,%esi
  80182c:	83 ec 0c             	sub    $0xc,%esp
  80182f:	68 05 08 00 00       	push   $0x805
  801834:	56                   	push   %esi
  801835:	57                   	push   %edi
  801836:	56                   	push   %esi
  801837:	6a 00                	push   $0x0
  801839:	e8 0e fc ff ff       	call   80144c <sys_page_map>
  80183e:	83 c4 20             	add    $0x20,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	0f 88 bc 00 00 00    	js     801905 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801849:	83 ec 0c             	sub    $0xc,%esp
  80184c:	68 05 08 00 00       	push   $0x805
  801851:	56                   	push   %esi
  801852:	6a 00                	push   $0x0
  801854:	56                   	push   %esi
  801855:	6a 00                	push   $0x0
  801857:	e8 f0 fb ff ff       	call   80144c <sys_page_map>
  80185c:	83 c4 20             	add    $0x20,%esp
  80185f:	85 c0                	test   %eax,%eax
  801861:	0f 88 b3 00 00 00    	js     80191a <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801867:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80186d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801873:	0f 84 b6 00 00 00    	je     80192f <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801879:	89 d8                	mov    %ebx,%eax
  80187b:	c1 e8 16             	shr    $0x16,%eax
  80187e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801885:	a8 01                	test   $0x1,%al
  801887:	74 de                	je     801867 <fork+0xc2>
  801889:	89 de                	mov    %ebx,%esi
  80188b:	c1 ee 0c             	shr    $0xc,%esi
  80188e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801895:	a8 01                	test   $0x1,%al
  801897:	74 ce                	je     801867 <fork+0xc2>
  801899:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8018a0:	a8 04                	test   $0x4,%al
  8018a2:	74 c3                	je     801867 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  8018a4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8018ab:	f6 c4 04             	test   $0x4,%ah
  8018ae:	0f 85 5b ff ff ff    	jne    80180f <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8018b4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8018bb:	a8 02                	test   $0x2,%al
  8018bd:	0f 85 66 ff ff ff    	jne    801829 <fork+0x84>
  8018c3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8018ca:	f6 c4 08             	test   $0x8,%ah
  8018cd:	0f 85 56 ff ff ff    	jne    801829 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8018d3:	c1 e6 0c             	shl    $0xc,%esi
  8018d6:	83 ec 0c             	sub    $0xc,%esp
  8018d9:	6a 05                	push   $0x5
  8018db:	56                   	push   %esi
  8018dc:	57                   	push   %edi
  8018dd:	56                   	push   %esi
  8018de:	6a 00                	push   $0x0
  8018e0:	e8 67 fb ff ff       	call   80144c <sys_page_map>
  8018e5:	83 c4 20             	add    $0x20,%esp
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	0f 89 77 ff ff ff    	jns    801867 <fork+0xc2>
		panic("duppage: %e\n", r);
  8018f0:	50                   	push   %eax
  8018f1:	68 2e 35 80 00       	push   $0x80352e
  8018f6:	68 0c 01 00 00       	push   $0x10c
  8018fb:	68 06 35 80 00       	push   $0x803506
  801900:	e8 cd ef ff ff       	call   8008d2 <_panic>
			panic("duppage: %e\n", r);
  801905:	50                   	push   %eax
  801906:	68 2e 35 80 00       	push   $0x80352e
  80190b:	68 05 01 00 00       	push   $0x105
  801910:	68 06 35 80 00       	push   $0x803506
  801915:	e8 b8 ef ff ff       	call   8008d2 <_panic>
			panic("duppage: %e\n", r);
  80191a:	50                   	push   %eax
  80191b:	68 2e 35 80 00       	push   $0x80352e
  801920:	68 09 01 00 00       	push   $0x109
  801925:	68 06 35 80 00       	push   $0x803506
  80192a:	e8 a3 ef ff ff       	call   8008d2 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	6a 07                	push   $0x7
  801934:	68 00 f0 bf ee       	push   $0xeebff000
  801939:	ff 75 e4             	pushl  -0x1c(%ebp)
  80193c:	e8 c4 fa ff ff       	call   801405 <sys_page_alloc>
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	85 c0                	test   %eax,%eax
  801946:	78 2e                	js     801976 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801948:	83 ec 08             	sub    $0x8,%esp
  80194b:	68 4d 2d 80 00       	push   $0x802d4d
  801950:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801953:	57                   	push   %edi
  801954:	e8 0b fc ff ff       	call   801564 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801959:	83 c4 08             	add    $0x8,%esp
  80195c:	6a 02                	push   $0x2
  80195e:	57                   	push   %edi
  80195f:	e8 74 fb ff ff       	call   8014d8 <sys_env_set_status>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	78 20                	js     80198b <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80196b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80196e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5f                   	pop    %edi
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801976:	50                   	push   %eax
  801977:	68 3b 35 80 00       	push   $0x80353b
  80197c:	68 3e 01 00 00       	push   $0x13e
  801981:	68 06 35 80 00       	push   $0x803506
  801986:	e8 47 ef ff ff       	call   8008d2 <_panic>
		panic("sys_env_set_status: %e", r);
  80198b:	50                   	push   %eax
  80198c:	68 4e 35 80 00       	push   $0x80354e
  801991:	68 43 01 00 00       	push   $0x143
  801996:	68 06 35 80 00       	push   $0x803506
  80199b:	e8 32 ef ff ff       	call   8008d2 <_panic>

008019a0 <sfork>:

// Challenge!
int
sfork(void)
{
  8019a0:	f3 0f 1e fb          	endbr32 
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8019aa:	68 65 35 80 00       	push   $0x803565
  8019af:	68 4c 01 00 00       	push   $0x14c
  8019b4:	68 06 35 80 00       	push   $0x803506
  8019b9:	e8 14 ef ff ff       	call   8008d2 <_panic>

008019be <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8019be:	f3 0f 1e fb          	endbr32 
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	56                   	push   %esi
  8019c6:	53                   	push   %ebx
  8019c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8019ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	74 3d                	je     801a11 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8019d4:	83 ec 0c             	sub    $0xc,%esp
  8019d7:	50                   	push   %eax
  8019d8:	e8 f4 fb ff ff       	call   8015d1 <sys_ipc_recv>
  8019dd:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8019e0:	85 f6                	test   %esi,%esi
  8019e2:	74 0b                	je     8019ef <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8019e4:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8019ea:	8b 52 74             	mov    0x74(%edx),%edx
  8019ed:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8019ef:	85 db                	test   %ebx,%ebx
  8019f1:	74 0b                	je     8019fe <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8019f3:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8019f9:	8b 52 78             	mov    0x78(%edx),%edx
  8019fc:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 21                	js     801a23 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801a02:	a1 20 50 80 00       	mov    0x805020,%eax
  801a07:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0d:	5b                   	pop    %ebx
  801a0e:	5e                   	pop    %esi
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801a11:	83 ec 0c             	sub    $0xc,%esp
  801a14:	68 00 00 c0 ee       	push   $0xeec00000
  801a19:	e8 b3 fb ff ff       	call   8015d1 <sys_ipc_recv>
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	eb bd                	jmp    8019e0 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801a23:	85 f6                	test   %esi,%esi
  801a25:	74 10                	je     801a37 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801a27:	85 db                	test   %ebx,%ebx
  801a29:	75 df                	jne    801a0a <ipc_recv+0x4c>
  801a2b:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801a32:	00 00 00 
  801a35:	eb d3                	jmp    801a0a <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801a37:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801a3e:	00 00 00 
  801a41:	eb e4                	jmp    801a27 <ipc_recv+0x69>

00801a43 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a43:	f3 0f 1e fb          	endbr32 
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	57                   	push   %edi
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	83 ec 0c             	sub    $0xc,%esp
  801a50:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a53:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a56:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801a59:	85 db                	test   %ebx,%ebx
  801a5b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a60:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801a63:	ff 75 14             	pushl  0x14(%ebp)
  801a66:	53                   	push   %ebx
  801a67:	56                   	push   %esi
  801a68:	57                   	push   %edi
  801a69:	e8 3c fb ff ff       	call   8015aa <sys_ipc_try_send>
  801a6e:	83 c4 10             	add    $0x10,%esp
  801a71:	85 c0                	test   %eax,%eax
  801a73:	79 1e                	jns    801a93 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801a75:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a78:	75 07                	jne    801a81 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801a7a:	e8 63 f9 ff ff       	call   8013e2 <sys_yield>
  801a7f:	eb e2                	jmp    801a63 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801a81:	50                   	push   %eax
  801a82:	68 7b 35 80 00       	push   $0x80357b
  801a87:	6a 59                	push   $0x59
  801a89:	68 96 35 80 00       	push   $0x803596
  801a8e:	e8 3f ee ff ff       	call   8008d2 <_panic>
	}
}
  801a93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5e                   	pop    %esi
  801a98:	5f                   	pop    %edi
  801a99:	5d                   	pop    %ebp
  801a9a:	c3                   	ret    

00801a9b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a9b:	f3 0f 1e fb          	endbr32 
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801aaa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801aad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ab3:	8b 52 50             	mov    0x50(%edx),%edx
  801ab6:	39 ca                	cmp    %ecx,%edx
  801ab8:	74 11                	je     801acb <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801aba:	83 c0 01             	add    $0x1,%eax
  801abd:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ac2:	75 e6                	jne    801aaa <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac9:	eb 0b                	jmp    801ad6 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801acb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ace:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ad3:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    

00801ad8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801ad8:	f3 0f 1e fb          	endbr32 
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	05 00 00 00 30       	add    $0x30000000,%eax
  801ae7:	c1 e8 0c             	shr    $0xc,%eax
}
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801aec:	f3 0f 1e fb          	endbr32 
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801afb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b00:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801b05:	5d                   	pop    %ebp
  801b06:	c3                   	ret    

00801b07 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b07:	f3 0f 1e fb          	endbr32 
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801b13:	89 c2                	mov    %eax,%edx
  801b15:	c1 ea 16             	shr    $0x16,%edx
  801b18:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801b1f:	f6 c2 01             	test   $0x1,%dl
  801b22:	74 2d                	je     801b51 <fd_alloc+0x4a>
  801b24:	89 c2                	mov    %eax,%edx
  801b26:	c1 ea 0c             	shr    $0xc,%edx
  801b29:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b30:	f6 c2 01             	test   $0x1,%dl
  801b33:	74 1c                	je     801b51 <fd_alloc+0x4a>
  801b35:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801b3a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801b3f:	75 d2                	jne    801b13 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801b4a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801b4f:	eb 0a                	jmp    801b5b <fd_alloc+0x54>
			*fd_store = fd;
  801b51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b54:	89 01                	mov    %eax,(%ecx)
			return 0;
  801b56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    

00801b5d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801b5d:	f3 0f 1e fb          	endbr32 
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801b67:	83 f8 1f             	cmp    $0x1f,%eax
  801b6a:	77 30                	ja     801b9c <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801b6c:	c1 e0 0c             	shl    $0xc,%eax
  801b6f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801b74:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801b7a:	f6 c2 01             	test   $0x1,%dl
  801b7d:	74 24                	je     801ba3 <fd_lookup+0x46>
  801b7f:	89 c2                	mov    %eax,%edx
  801b81:	c1 ea 0c             	shr    $0xc,%edx
  801b84:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b8b:	f6 c2 01             	test   $0x1,%dl
  801b8e:	74 1a                	je     801baa <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b93:	89 02                	mov    %eax,(%edx)
	return 0;
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    
		return -E_INVAL;
  801b9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba1:	eb f7                	jmp    801b9a <fd_lookup+0x3d>
		return -E_INVAL;
  801ba3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba8:	eb f0                	jmp    801b9a <fd_lookup+0x3d>
  801baa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801baf:	eb e9                	jmp    801b9a <fd_lookup+0x3d>

00801bb1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801bb1:	f3 0f 1e fb          	endbr32 
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc3:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801bc8:	39 08                	cmp    %ecx,(%eax)
  801bca:	74 38                	je     801c04 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801bcc:	83 c2 01             	add    $0x1,%edx
  801bcf:	8b 04 95 1c 36 80 00 	mov    0x80361c(,%edx,4),%eax
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	75 ee                	jne    801bc8 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801bda:	a1 20 50 80 00       	mov    0x805020,%eax
  801bdf:	8b 40 48             	mov    0x48(%eax),%eax
  801be2:	83 ec 04             	sub    $0x4,%esp
  801be5:	51                   	push   %ecx
  801be6:	50                   	push   %eax
  801be7:	68 a0 35 80 00       	push   $0x8035a0
  801bec:	e8 c8 ed ff ff       	call   8009b9 <cprintf>
	*dev = 0;
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    
			*dev = devtab[i];
  801c04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c07:	89 01                	mov    %eax,(%ecx)
			return 0;
  801c09:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0e:	eb f2                	jmp    801c02 <dev_lookup+0x51>

00801c10 <fd_close>:
{
  801c10:	f3 0f 1e fb          	endbr32 
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	57                   	push   %edi
  801c18:	56                   	push   %esi
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 24             	sub    $0x24,%esp
  801c1d:	8b 75 08             	mov    0x8(%ebp),%esi
  801c20:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801c23:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c26:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c27:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801c2d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801c30:	50                   	push   %eax
  801c31:	e8 27 ff ff ff       	call   801b5d <fd_lookup>
  801c36:	89 c3                	mov    %eax,%ebx
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	78 05                	js     801c44 <fd_close+0x34>
	    || fd != fd2)
  801c3f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801c42:	74 16                	je     801c5a <fd_close+0x4a>
		return (must_exist ? r : 0);
  801c44:	89 f8                	mov    %edi,%eax
  801c46:	84 c0                	test   %al,%al
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4d:	0f 44 d8             	cmove  %eax,%ebx
}
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5f                   	pop    %edi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c5a:	83 ec 08             	sub    $0x8,%esp
  801c5d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c60:	50                   	push   %eax
  801c61:	ff 36                	pushl  (%esi)
  801c63:	e8 49 ff ff ff       	call   801bb1 <dev_lookup>
  801c68:	89 c3                	mov    %eax,%ebx
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	78 1a                	js     801c8b <fd_close+0x7b>
		if (dev->dev_close)
  801c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c74:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801c77:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	74 0b                	je     801c8b <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801c80:	83 ec 0c             	sub    $0xc,%esp
  801c83:	56                   	push   %esi
  801c84:	ff d0                	call   *%eax
  801c86:	89 c3                	mov    %eax,%ebx
  801c88:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801c8b:	83 ec 08             	sub    $0x8,%esp
  801c8e:	56                   	push   %esi
  801c8f:	6a 00                	push   $0x0
  801c91:	e8 fc f7 ff ff       	call   801492 <sys_page_unmap>
	return r;
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	eb b5                	jmp    801c50 <fd_close+0x40>

00801c9b <close>:

int
close(int fdnum)
{
  801c9b:	f3 0f 1e fb          	endbr32 
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ca5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca8:	50                   	push   %eax
  801ca9:	ff 75 08             	pushl  0x8(%ebp)
  801cac:	e8 ac fe ff ff       	call   801b5d <fd_lookup>
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	79 02                	jns    801cba <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    
		return fd_close(fd, 1);
  801cba:	83 ec 08             	sub    $0x8,%esp
  801cbd:	6a 01                	push   $0x1
  801cbf:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc2:	e8 49 ff ff ff       	call   801c10 <fd_close>
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	eb ec                	jmp    801cb8 <close+0x1d>

00801ccc <close_all>:

void
close_all(void)
{
  801ccc:	f3 0f 1e fb          	endbr32 
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801cd7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801cdc:	83 ec 0c             	sub    $0xc,%esp
  801cdf:	53                   	push   %ebx
  801ce0:	e8 b6 ff ff ff       	call   801c9b <close>
	for (i = 0; i < MAXFD; i++)
  801ce5:	83 c3 01             	add    $0x1,%ebx
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	83 fb 20             	cmp    $0x20,%ebx
  801cee:	75 ec                	jne    801cdc <close_all+0x10>
}
  801cf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801cf5:	f3 0f 1e fb          	endbr32 
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	57                   	push   %edi
  801cfd:	56                   	push   %esi
  801cfe:	53                   	push   %ebx
  801cff:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d02:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801d05:	50                   	push   %eax
  801d06:	ff 75 08             	pushl  0x8(%ebp)
  801d09:	e8 4f fe ff ff       	call   801b5d <fd_lookup>
  801d0e:	89 c3                	mov    %eax,%ebx
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	85 c0                	test   %eax,%eax
  801d15:	0f 88 81 00 00 00    	js     801d9c <dup+0xa7>
		return r;
	close(newfdnum);
  801d1b:	83 ec 0c             	sub    $0xc,%esp
  801d1e:	ff 75 0c             	pushl  0xc(%ebp)
  801d21:	e8 75 ff ff ff       	call   801c9b <close>

	newfd = INDEX2FD(newfdnum);
  801d26:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d29:	c1 e6 0c             	shl    $0xc,%esi
  801d2c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801d32:	83 c4 04             	add    $0x4,%esp
  801d35:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d38:	e8 af fd ff ff       	call   801aec <fd2data>
  801d3d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801d3f:	89 34 24             	mov    %esi,(%esp)
  801d42:	e8 a5 fd ff ff       	call   801aec <fd2data>
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801d4c:	89 d8                	mov    %ebx,%eax
  801d4e:	c1 e8 16             	shr    $0x16,%eax
  801d51:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d58:	a8 01                	test   $0x1,%al
  801d5a:	74 11                	je     801d6d <dup+0x78>
  801d5c:	89 d8                	mov    %ebx,%eax
  801d5e:	c1 e8 0c             	shr    $0xc,%eax
  801d61:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801d68:	f6 c2 01             	test   $0x1,%dl
  801d6b:	75 39                	jne    801da6 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801d6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d70:	89 d0                	mov    %edx,%eax
  801d72:	c1 e8 0c             	shr    $0xc,%eax
  801d75:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	25 07 0e 00 00       	and    $0xe07,%eax
  801d84:	50                   	push   %eax
  801d85:	56                   	push   %esi
  801d86:	6a 00                	push   $0x0
  801d88:	52                   	push   %edx
  801d89:	6a 00                	push   $0x0
  801d8b:	e8 bc f6 ff ff       	call   80144c <sys_page_map>
  801d90:	89 c3                	mov    %eax,%ebx
  801d92:	83 c4 20             	add    $0x20,%esp
  801d95:	85 c0                	test   %eax,%eax
  801d97:	78 31                	js     801dca <dup+0xd5>
		goto err;

	return newfdnum;
  801d99:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da1:	5b                   	pop    %ebx
  801da2:	5e                   	pop    %esi
  801da3:	5f                   	pop    %edi
  801da4:	5d                   	pop    %ebp
  801da5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801da6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	25 07 0e 00 00       	and    $0xe07,%eax
  801db5:	50                   	push   %eax
  801db6:	57                   	push   %edi
  801db7:	6a 00                	push   $0x0
  801db9:	53                   	push   %ebx
  801dba:	6a 00                	push   $0x0
  801dbc:	e8 8b f6 ff ff       	call   80144c <sys_page_map>
  801dc1:	89 c3                	mov    %eax,%ebx
  801dc3:	83 c4 20             	add    $0x20,%esp
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	79 a3                	jns    801d6d <dup+0x78>
	sys_page_unmap(0, newfd);
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	56                   	push   %esi
  801dce:	6a 00                	push   $0x0
  801dd0:	e8 bd f6 ff ff       	call   801492 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801dd5:	83 c4 08             	add    $0x8,%esp
  801dd8:	57                   	push   %edi
  801dd9:	6a 00                	push   $0x0
  801ddb:	e8 b2 f6 ff ff       	call   801492 <sys_page_unmap>
	return r;
  801de0:	83 c4 10             	add    $0x10,%esp
  801de3:	eb b7                	jmp    801d9c <dup+0xa7>

00801de5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801de5:	f3 0f 1e fb          	endbr32 
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	53                   	push   %ebx
  801ded:	83 ec 1c             	sub    $0x1c,%esp
  801df0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801df3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801df6:	50                   	push   %eax
  801df7:	53                   	push   %ebx
  801df8:	e8 60 fd ff ff       	call   801b5d <fd_lookup>
  801dfd:	83 c4 10             	add    $0x10,%esp
  801e00:	85 c0                	test   %eax,%eax
  801e02:	78 3f                	js     801e43 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e04:	83 ec 08             	sub    $0x8,%esp
  801e07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0a:	50                   	push   %eax
  801e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0e:	ff 30                	pushl  (%eax)
  801e10:	e8 9c fd ff ff       	call   801bb1 <dev_lookup>
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	78 27                	js     801e43 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801e1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e1f:	8b 42 08             	mov    0x8(%edx),%eax
  801e22:	83 e0 03             	and    $0x3,%eax
  801e25:	83 f8 01             	cmp    $0x1,%eax
  801e28:	74 1e                	je     801e48 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2d:	8b 40 08             	mov    0x8(%eax),%eax
  801e30:	85 c0                	test   %eax,%eax
  801e32:	74 35                	je     801e69 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801e34:	83 ec 04             	sub    $0x4,%esp
  801e37:	ff 75 10             	pushl  0x10(%ebp)
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	52                   	push   %edx
  801e3e:	ff d0                	call   *%eax
  801e40:	83 c4 10             	add    $0x10,%esp
}
  801e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801e48:	a1 20 50 80 00       	mov    0x805020,%eax
  801e4d:	8b 40 48             	mov    0x48(%eax),%eax
  801e50:	83 ec 04             	sub    $0x4,%esp
  801e53:	53                   	push   %ebx
  801e54:	50                   	push   %eax
  801e55:	68 e1 35 80 00       	push   $0x8035e1
  801e5a:	e8 5a eb ff ff       	call   8009b9 <cprintf>
		return -E_INVAL;
  801e5f:	83 c4 10             	add    $0x10,%esp
  801e62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e67:	eb da                	jmp    801e43 <read+0x5e>
		return -E_NOT_SUPP;
  801e69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e6e:	eb d3                	jmp    801e43 <read+0x5e>

00801e70 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801e70:	f3 0f 1e fb          	endbr32 
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	57                   	push   %edi
  801e78:	56                   	push   %esi
  801e79:	53                   	push   %ebx
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e80:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801e83:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e88:	eb 02                	jmp    801e8c <readn+0x1c>
  801e8a:	01 c3                	add    %eax,%ebx
  801e8c:	39 f3                	cmp    %esi,%ebx
  801e8e:	73 21                	jae    801eb1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	89 f0                	mov    %esi,%eax
  801e95:	29 d8                	sub    %ebx,%eax
  801e97:	50                   	push   %eax
  801e98:	89 d8                	mov    %ebx,%eax
  801e9a:	03 45 0c             	add    0xc(%ebp),%eax
  801e9d:	50                   	push   %eax
  801e9e:	57                   	push   %edi
  801e9f:	e8 41 ff ff ff       	call   801de5 <read>
		if (m < 0)
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	78 04                	js     801eaf <readn+0x3f>
			return m;
		if (m == 0)
  801eab:	75 dd                	jne    801e8a <readn+0x1a>
  801ead:	eb 02                	jmp    801eb1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801eaf:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801eb1:	89 d8                	mov    %ebx,%eax
  801eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eb6:	5b                   	pop    %ebx
  801eb7:	5e                   	pop    %esi
  801eb8:	5f                   	pop    %edi
  801eb9:	5d                   	pop    %ebp
  801eba:	c3                   	ret    

00801ebb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ebb:	f3 0f 1e fb          	endbr32 
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	53                   	push   %ebx
  801ec3:	83 ec 1c             	sub    $0x1c,%esp
  801ec6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ec9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ecc:	50                   	push   %eax
  801ecd:	53                   	push   %ebx
  801ece:	e8 8a fc ff ff       	call   801b5d <fd_lookup>
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	78 3a                	js     801f14 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801eda:	83 ec 08             	sub    $0x8,%esp
  801edd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee0:	50                   	push   %eax
  801ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee4:	ff 30                	pushl  (%eax)
  801ee6:	e8 c6 fc ff ff       	call   801bb1 <dev_lookup>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	78 22                	js     801f14 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ef9:	74 1e                	je     801f19 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801efb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efe:	8b 52 0c             	mov    0xc(%edx),%edx
  801f01:	85 d2                	test   %edx,%edx
  801f03:	74 35                	je     801f3a <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	ff 75 10             	pushl  0x10(%ebp)
  801f0b:	ff 75 0c             	pushl  0xc(%ebp)
  801f0e:	50                   	push   %eax
  801f0f:	ff d2                	call   *%edx
  801f11:	83 c4 10             	add    $0x10,%esp
}
  801f14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801f19:	a1 20 50 80 00       	mov    0x805020,%eax
  801f1e:	8b 40 48             	mov    0x48(%eax),%eax
  801f21:	83 ec 04             	sub    $0x4,%esp
  801f24:	53                   	push   %ebx
  801f25:	50                   	push   %eax
  801f26:	68 fd 35 80 00       	push   $0x8035fd
  801f2b:	e8 89 ea ff ff       	call   8009b9 <cprintf>
		return -E_INVAL;
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f38:	eb da                	jmp    801f14 <write+0x59>
		return -E_NOT_SUPP;
  801f3a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f3f:	eb d3                	jmp    801f14 <write+0x59>

00801f41 <seek>:

int
seek(int fdnum, off_t offset)
{
  801f41:	f3 0f 1e fb          	endbr32 
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4e:	50                   	push   %eax
  801f4f:	ff 75 08             	pushl  0x8(%ebp)
  801f52:	e8 06 fc ff ff       	call   801b5d <fd_lookup>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	78 0e                	js     801f6c <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801f6e:	f3 0f 1e fb          	endbr32 
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	53                   	push   %ebx
  801f76:	83 ec 1c             	sub    $0x1c,%esp
  801f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f7c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f7f:	50                   	push   %eax
  801f80:	53                   	push   %ebx
  801f81:	e8 d7 fb ff ff       	call   801b5d <fd_lookup>
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 37                	js     801fc4 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f8d:	83 ec 08             	sub    $0x8,%esp
  801f90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f93:	50                   	push   %eax
  801f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f97:	ff 30                	pushl  (%eax)
  801f99:	e8 13 fc ff ff       	call   801bb1 <dev_lookup>
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	78 1f                	js     801fc4 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801fac:	74 1b                	je     801fc9 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb1:	8b 52 18             	mov    0x18(%edx),%edx
  801fb4:	85 d2                	test   %edx,%edx
  801fb6:	74 32                	je     801fea <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801fb8:	83 ec 08             	sub    $0x8,%esp
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	50                   	push   %eax
  801fbf:	ff d2                	call   *%edx
  801fc1:	83 c4 10             	add    $0x10,%esp
}
  801fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    
			thisenv->env_id, fdnum);
  801fc9:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801fce:	8b 40 48             	mov    0x48(%eax),%eax
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	53                   	push   %ebx
  801fd5:	50                   	push   %eax
  801fd6:	68 c0 35 80 00       	push   $0x8035c0
  801fdb:	e8 d9 e9 ff ff       	call   8009b9 <cprintf>
		return -E_INVAL;
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fe8:	eb da                	jmp    801fc4 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801fea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fef:	eb d3                	jmp    801fc4 <ftruncate+0x56>

00801ff1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ff1:	f3 0f 1e fb          	endbr32 
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	53                   	push   %ebx
  801ff9:	83 ec 1c             	sub    $0x1c,%esp
  801ffc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802002:	50                   	push   %eax
  802003:	ff 75 08             	pushl  0x8(%ebp)
  802006:	e8 52 fb ff ff       	call   801b5d <fd_lookup>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 4b                	js     80205d <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802012:	83 ec 08             	sub    $0x8,%esp
  802015:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802018:	50                   	push   %eax
  802019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201c:	ff 30                	pushl  (%eax)
  80201e:	e8 8e fb ff ff       	call   801bb1 <dev_lookup>
  802023:	83 c4 10             	add    $0x10,%esp
  802026:	85 c0                	test   %eax,%eax
  802028:	78 33                	js     80205d <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802031:	74 2f                	je     802062 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802033:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802036:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80203d:	00 00 00 
	stat->st_isdir = 0;
  802040:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802047:	00 00 00 
	stat->st_dev = dev;
  80204a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802050:	83 ec 08             	sub    $0x8,%esp
  802053:	53                   	push   %ebx
  802054:	ff 75 f0             	pushl  -0x10(%ebp)
  802057:	ff 50 14             	call   *0x14(%eax)
  80205a:	83 c4 10             	add    $0x10,%esp
}
  80205d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802060:	c9                   	leave  
  802061:	c3                   	ret    
		return -E_NOT_SUPP;
  802062:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802067:	eb f4                	jmp    80205d <fstat+0x6c>

00802069 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802069:	f3 0f 1e fb          	endbr32 
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	56                   	push   %esi
  802071:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802072:	83 ec 08             	sub    $0x8,%esp
  802075:	6a 00                	push   $0x0
  802077:	ff 75 08             	pushl  0x8(%ebp)
  80207a:	e8 fb 01 00 00       	call   80227a <open>
  80207f:	89 c3                	mov    %eax,%ebx
  802081:	83 c4 10             	add    $0x10,%esp
  802084:	85 c0                	test   %eax,%eax
  802086:	78 1b                	js     8020a3 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  802088:	83 ec 08             	sub    $0x8,%esp
  80208b:	ff 75 0c             	pushl  0xc(%ebp)
  80208e:	50                   	push   %eax
  80208f:	e8 5d ff ff ff       	call   801ff1 <fstat>
  802094:	89 c6                	mov    %eax,%esi
	close(fd);
  802096:	89 1c 24             	mov    %ebx,(%esp)
  802099:	e8 fd fb ff ff       	call   801c9b <close>
	return r;
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	89 f3                	mov    %esi,%ebx
}
  8020a3:	89 d8                	mov    %ebx,%eax
  8020a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a8:	5b                   	pop    %ebx
  8020a9:	5e                   	pop    %esi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    

008020ac <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	56                   	push   %esi
  8020b0:	53                   	push   %ebx
  8020b1:	89 c6                	mov    %eax,%esi
  8020b3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8020b5:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  8020bc:	74 27                	je     8020e5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8020be:	6a 07                	push   $0x7
  8020c0:	68 00 60 80 00       	push   $0x806000
  8020c5:	56                   	push   %esi
  8020c6:	ff 35 18 50 80 00    	pushl  0x805018
  8020cc:	e8 72 f9 ff ff       	call   801a43 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8020d1:	83 c4 0c             	add    $0xc,%esp
  8020d4:	6a 00                	push   $0x0
  8020d6:	53                   	push   %ebx
  8020d7:	6a 00                	push   $0x0
  8020d9:	e8 e0 f8 ff ff       	call   8019be <ipc_recv>
}
  8020de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8020e5:	83 ec 0c             	sub    $0xc,%esp
  8020e8:	6a 01                	push   $0x1
  8020ea:	e8 ac f9 ff ff       	call   801a9b <ipc_find_env>
  8020ef:	a3 18 50 80 00       	mov    %eax,0x805018
  8020f4:	83 c4 10             	add    $0x10,%esp
  8020f7:	eb c5                	jmp    8020be <fsipc+0x12>

008020f9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8020f9:	f3 0f 1e fb          	endbr32 
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	8b 40 0c             	mov    0xc(%eax),%eax
  802109:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80210e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802111:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802116:	ba 00 00 00 00       	mov    $0x0,%edx
  80211b:	b8 02 00 00 00       	mov    $0x2,%eax
  802120:	e8 87 ff ff ff       	call   8020ac <fsipc>
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <devfile_flush>:
{
  802127:	f3 0f 1e fb          	endbr32 
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	8b 40 0c             	mov    0xc(%eax),%eax
  802137:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80213c:	ba 00 00 00 00       	mov    $0x0,%edx
  802141:	b8 06 00 00 00       	mov    $0x6,%eax
  802146:	e8 61 ff ff ff       	call   8020ac <fsipc>
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <devfile_stat>:
{
  80214d:	f3 0f 1e fb          	endbr32 
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	53                   	push   %ebx
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	8b 40 0c             	mov    0xc(%eax),%eax
  802161:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802166:	ba 00 00 00 00       	mov    $0x0,%edx
  80216b:	b8 05 00 00 00       	mov    $0x5,%eax
  802170:	e8 37 ff ff ff       	call   8020ac <fsipc>
  802175:	85 c0                	test   %eax,%eax
  802177:	78 2c                	js     8021a5 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802179:	83 ec 08             	sub    $0x8,%esp
  80217c:	68 00 60 80 00       	push   $0x806000
  802181:	53                   	push   %ebx
  802182:	e8 3c ee ff ff       	call   800fc3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802187:	a1 80 60 80 00       	mov    0x806080,%eax
  80218c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802192:	a1 84 60 80 00       	mov    0x806084,%eax
  802197:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80219d:	83 c4 10             	add    $0x10,%esp
  8021a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <devfile_write>:
{
  8021aa:	f3 0f 1e fb          	endbr32 
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 0c             	sub    $0xc,%esp
  8021b4:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ba:	8b 52 0c             	mov    0xc(%edx),%edx
  8021bd:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8021c3:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8021c8:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8021cd:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8021d0:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8021d5:	50                   	push   %eax
  8021d6:	ff 75 0c             	pushl  0xc(%ebp)
  8021d9:	68 08 60 80 00       	push   $0x806008
  8021de:	e8 96 ef ff ff       	call   801179 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8021e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e8:	b8 04 00 00 00       	mov    $0x4,%eax
  8021ed:	e8 ba fe ff ff       	call   8020ac <fsipc>
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <devfile_read>:
{
  8021f4:	f3 0f 1e fb          	endbr32 
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	56                   	push   %esi
  8021fc:	53                   	push   %ebx
  8021fd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8b 40 0c             	mov    0xc(%eax),%eax
  802206:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80220b:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802211:	ba 00 00 00 00       	mov    $0x0,%edx
  802216:	b8 03 00 00 00       	mov    $0x3,%eax
  80221b:	e8 8c fe ff ff       	call   8020ac <fsipc>
  802220:	89 c3                	mov    %eax,%ebx
  802222:	85 c0                	test   %eax,%eax
  802224:	78 1f                	js     802245 <devfile_read+0x51>
	assert(r <= n);
  802226:	39 f0                	cmp    %esi,%eax
  802228:	77 24                	ja     80224e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80222a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80222f:	7f 33                	jg     802264 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	50                   	push   %eax
  802235:	68 00 60 80 00       	push   $0x806000
  80223a:	ff 75 0c             	pushl  0xc(%ebp)
  80223d:	e8 37 ef ff ff       	call   801179 <memmove>
	return r;
  802242:	83 c4 10             	add    $0x10,%esp
}
  802245:	89 d8                	mov    %ebx,%eax
  802247:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224a:	5b                   	pop    %ebx
  80224b:	5e                   	pop    %esi
  80224c:	5d                   	pop    %ebp
  80224d:	c3                   	ret    
	assert(r <= n);
  80224e:	68 30 36 80 00       	push   $0x803630
  802253:	68 37 36 80 00       	push   $0x803637
  802258:	6a 7c                	push   $0x7c
  80225a:	68 4c 36 80 00       	push   $0x80364c
  80225f:	e8 6e e6 ff ff       	call   8008d2 <_panic>
	assert(r <= PGSIZE);
  802264:	68 57 36 80 00       	push   $0x803657
  802269:	68 37 36 80 00       	push   $0x803637
  80226e:	6a 7d                	push   $0x7d
  802270:	68 4c 36 80 00       	push   $0x80364c
  802275:	e8 58 e6 ff ff       	call   8008d2 <_panic>

0080227a <open>:
{
  80227a:	f3 0f 1e fb          	endbr32 
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	56                   	push   %esi
  802282:	53                   	push   %ebx
  802283:	83 ec 1c             	sub    $0x1c,%esp
  802286:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802289:	56                   	push   %esi
  80228a:	e8 f1 ec ff ff       	call   800f80 <strlen>
  80228f:	83 c4 10             	add    $0x10,%esp
  802292:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802297:	7f 6c                	jg     802305 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  802299:	83 ec 0c             	sub    $0xc,%esp
  80229c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80229f:	50                   	push   %eax
  8022a0:	e8 62 f8 ff ff       	call   801b07 <fd_alloc>
  8022a5:	89 c3                	mov    %eax,%ebx
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	78 3c                	js     8022ea <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8022ae:	83 ec 08             	sub    $0x8,%esp
  8022b1:	56                   	push   %esi
  8022b2:	68 00 60 80 00       	push   $0x806000
  8022b7:	e8 07 ed ff ff       	call   800fc3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8022bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bf:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8022c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cc:	e8 db fd ff ff       	call   8020ac <fsipc>
  8022d1:	89 c3                	mov    %eax,%ebx
  8022d3:	83 c4 10             	add    $0x10,%esp
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	78 19                	js     8022f3 <open+0x79>
	return fd2num(fd);
  8022da:	83 ec 0c             	sub    $0xc,%esp
  8022dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e0:	e8 f3 f7 ff ff       	call   801ad8 <fd2num>
  8022e5:	89 c3                	mov    %eax,%ebx
  8022e7:	83 c4 10             	add    $0x10,%esp
}
  8022ea:	89 d8                	mov    %ebx,%eax
  8022ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    
		fd_close(fd, 0);
  8022f3:	83 ec 08             	sub    $0x8,%esp
  8022f6:	6a 00                	push   $0x0
  8022f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8022fb:	e8 10 f9 ff ff       	call   801c10 <fd_close>
		return r;
  802300:	83 c4 10             	add    $0x10,%esp
  802303:	eb e5                	jmp    8022ea <open+0x70>
		return -E_BAD_PATH;
  802305:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80230a:	eb de                	jmp    8022ea <open+0x70>

0080230c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80230c:	f3 0f 1e fb          	endbr32 
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802316:	ba 00 00 00 00       	mov    $0x0,%edx
  80231b:	b8 08 00 00 00       	mov    $0x8,%eax
  802320:	e8 87 fd ff ff       	call   8020ac <fsipc>
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802327:	f3 0f 1e fb          	endbr32 
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802331:	68 63 36 80 00       	push   $0x803663
  802336:	ff 75 0c             	pushl  0xc(%ebp)
  802339:	e8 85 ec ff ff       	call   800fc3 <strcpy>
	return 0;
}
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <devsock_close>:
{
  802345:	f3 0f 1e fb          	endbr32 
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	53                   	push   %ebx
  80234d:	83 ec 10             	sub    $0x10,%esp
  802350:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802353:	53                   	push   %ebx
  802354:	e8 1a 0a 00 00       	call   802d73 <pageref>
  802359:	89 c2                	mov    %eax,%edx
  80235b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  802363:	83 fa 01             	cmp    $0x1,%edx
  802366:	74 05                	je     80236d <devsock_close+0x28>
}
  802368:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80236d:	83 ec 0c             	sub    $0xc,%esp
  802370:	ff 73 0c             	pushl  0xc(%ebx)
  802373:	e8 e3 02 00 00       	call   80265b <nsipc_close>
  802378:	83 c4 10             	add    $0x10,%esp
  80237b:	eb eb                	jmp    802368 <devsock_close+0x23>

0080237d <devsock_write>:
{
  80237d:	f3 0f 1e fb          	endbr32 
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802387:	6a 00                	push   $0x0
  802389:	ff 75 10             	pushl  0x10(%ebp)
  80238c:	ff 75 0c             	pushl  0xc(%ebp)
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	ff 70 0c             	pushl  0xc(%eax)
  802395:	e8 b5 03 00 00       	call   80274f <nsipc_send>
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <devsock_read>:
{
  80239c:	f3 0f 1e fb          	endbr32 
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8023a6:	6a 00                	push   $0x0
  8023a8:	ff 75 10             	pushl  0x10(%ebp)
  8023ab:	ff 75 0c             	pushl  0xc(%ebp)
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	ff 70 0c             	pushl  0xc(%eax)
  8023b4:	e8 1f 03 00 00       	call   8026d8 <nsipc_recv>
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <fd2sockid>:
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8023c1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8023c4:	52                   	push   %edx
  8023c5:	50                   	push   %eax
  8023c6:	e8 92 f7 ff ff       	call   801b5d <fd_lookup>
  8023cb:	83 c4 10             	add    $0x10,%esp
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	78 10                	js     8023e2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8023db:	39 08                	cmp    %ecx,(%eax)
  8023dd:	75 05                	jne    8023e4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8023df:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    
		return -E_NOT_SUPP;
  8023e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8023e9:	eb f7                	jmp    8023e2 <fd2sockid+0x27>

008023eb <alloc_sockfd>:
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	56                   	push   %esi
  8023ef:	53                   	push   %ebx
  8023f0:	83 ec 1c             	sub    $0x1c,%esp
  8023f3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8023f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f8:	50                   	push   %eax
  8023f9:	e8 09 f7 ff ff       	call   801b07 <fd_alloc>
  8023fe:	89 c3                	mov    %eax,%ebx
  802400:	83 c4 10             	add    $0x10,%esp
  802403:	85 c0                	test   %eax,%eax
  802405:	78 43                	js     80244a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	68 07 04 00 00       	push   $0x407
  80240f:	ff 75 f4             	pushl  -0xc(%ebp)
  802412:	6a 00                	push   $0x0
  802414:	e8 ec ef ff ff       	call   801405 <sys_page_alloc>
  802419:	89 c3                	mov    %eax,%ebx
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	85 c0                	test   %eax,%eax
  802420:	78 28                	js     80244a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80242b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802437:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80243a:	83 ec 0c             	sub    $0xc,%esp
  80243d:	50                   	push   %eax
  80243e:	e8 95 f6 ff ff       	call   801ad8 <fd2num>
  802443:	89 c3                	mov    %eax,%ebx
  802445:	83 c4 10             	add    $0x10,%esp
  802448:	eb 0c                	jmp    802456 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80244a:	83 ec 0c             	sub    $0xc,%esp
  80244d:	56                   	push   %esi
  80244e:	e8 08 02 00 00       	call   80265b <nsipc_close>
		return r;
  802453:	83 c4 10             	add    $0x10,%esp
}
  802456:	89 d8                	mov    %ebx,%eax
  802458:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80245b:	5b                   	pop    %ebx
  80245c:	5e                   	pop    %esi
  80245d:	5d                   	pop    %ebp
  80245e:	c3                   	ret    

0080245f <accept>:
{
  80245f:	f3 0f 1e fb          	endbr32 
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	e8 4a ff ff ff       	call   8023bb <fd2sockid>
  802471:	85 c0                	test   %eax,%eax
  802473:	78 1b                	js     802490 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802475:	83 ec 04             	sub    $0x4,%esp
  802478:	ff 75 10             	pushl  0x10(%ebp)
  80247b:	ff 75 0c             	pushl  0xc(%ebp)
  80247e:	50                   	push   %eax
  80247f:	e8 22 01 00 00       	call   8025a6 <nsipc_accept>
  802484:	83 c4 10             	add    $0x10,%esp
  802487:	85 c0                	test   %eax,%eax
  802489:	78 05                	js     802490 <accept+0x31>
	return alloc_sockfd(r);
  80248b:	e8 5b ff ff ff       	call   8023eb <alloc_sockfd>
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <bind>:
{
  802492:	f3 0f 1e fb          	endbr32 
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	e8 17 ff ff ff       	call   8023bb <fd2sockid>
  8024a4:	85 c0                	test   %eax,%eax
  8024a6:	78 12                	js     8024ba <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	ff 75 10             	pushl  0x10(%ebp)
  8024ae:	ff 75 0c             	pushl  0xc(%ebp)
  8024b1:	50                   	push   %eax
  8024b2:	e8 45 01 00 00       	call   8025fc <nsipc_bind>
  8024b7:	83 c4 10             	add    $0x10,%esp
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <shutdown>:
{
  8024bc:	f3 0f 1e fb          	endbr32 
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	e8 ed fe ff ff       	call   8023bb <fd2sockid>
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	78 0f                	js     8024e1 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8024d2:	83 ec 08             	sub    $0x8,%esp
  8024d5:	ff 75 0c             	pushl  0xc(%ebp)
  8024d8:	50                   	push   %eax
  8024d9:	e8 57 01 00 00       	call   802635 <nsipc_shutdown>
  8024de:	83 c4 10             	add    $0x10,%esp
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <connect>:
{
  8024e3:	f3 0f 1e fb          	endbr32 
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
  8024ea:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	e8 c6 fe ff ff       	call   8023bb <fd2sockid>
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	78 12                	js     80250b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	ff 75 10             	pushl  0x10(%ebp)
  8024ff:	ff 75 0c             	pushl  0xc(%ebp)
  802502:	50                   	push   %eax
  802503:	e8 71 01 00 00       	call   802679 <nsipc_connect>
  802508:	83 c4 10             	add    $0x10,%esp
}
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    

0080250d <listen>:
{
  80250d:	f3 0f 1e fb          	endbr32 
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
  802514:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802517:	8b 45 08             	mov    0x8(%ebp),%eax
  80251a:	e8 9c fe ff ff       	call   8023bb <fd2sockid>
  80251f:	85 c0                	test   %eax,%eax
  802521:	78 0f                	js     802532 <listen+0x25>
	return nsipc_listen(r, backlog);
  802523:	83 ec 08             	sub    $0x8,%esp
  802526:	ff 75 0c             	pushl  0xc(%ebp)
  802529:	50                   	push   %eax
  80252a:	e8 83 01 00 00       	call   8026b2 <nsipc_listen>
  80252f:	83 c4 10             	add    $0x10,%esp
}
  802532:	c9                   	leave  
  802533:	c3                   	ret    

00802534 <socket>:

int
socket(int domain, int type, int protocol)
{
  802534:	f3 0f 1e fb          	endbr32 
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80253e:	ff 75 10             	pushl  0x10(%ebp)
  802541:	ff 75 0c             	pushl  0xc(%ebp)
  802544:	ff 75 08             	pushl  0x8(%ebp)
  802547:	e8 65 02 00 00       	call   8027b1 <nsipc_socket>
  80254c:	83 c4 10             	add    $0x10,%esp
  80254f:	85 c0                	test   %eax,%eax
  802551:	78 05                	js     802558 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  802553:	e8 93 fe ff ff       	call   8023eb <alloc_sockfd>
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	53                   	push   %ebx
  80255e:	83 ec 04             	sub    $0x4,%esp
  802561:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802563:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  80256a:	74 26                	je     802592 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80256c:	6a 07                	push   $0x7
  80256e:	68 00 70 80 00       	push   $0x807000
  802573:	53                   	push   %ebx
  802574:	ff 35 1c 50 80 00    	pushl  0x80501c
  80257a:	e8 c4 f4 ff ff       	call   801a43 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80257f:	83 c4 0c             	add    $0xc,%esp
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	e8 31 f4 ff ff       	call   8019be <ipc_recv>
}
  80258d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802590:	c9                   	leave  
  802591:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	6a 02                	push   $0x2
  802597:	e8 ff f4 ff ff       	call   801a9b <ipc_find_env>
  80259c:	a3 1c 50 80 00       	mov    %eax,0x80501c
  8025a1:	83 c4 10             	add    $0x10,%esp
  8025a4:	eb c6                	jmp    80256c <nsipc+0x12>

008025a6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025a6:	f3 0f 1e fb          	endbr32 
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	56                   	push   %esi
  8025ae:	53                   	push   %ebx
  8025af:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8025ba:	8b 06                	mov    (%esi),%eax
  8025bc:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8025c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c6:	e8 8f ff ff ff       	call   80255a <nsipc>
  8025cb:	89 c3                	mov    %eax,%ebx
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	79 09                	jns    8025da <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8025d1:	89 d8                	mov    %ebx,%eax
  8025d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025d6:	5b                   	pop    %ebx
  8025d7:	5e                   	pop    %esi
  8025d8:	5d                   	pop    %ebp
  8025d9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8025da:	83 ec 04             	sub    $0x4,%esp
  8025dd:	ff 35 10 70 80 00    	pushl  0x807010
  8025e3:	68 00 70 80 00       	push   $0x807000
  8025e8:	ff 75 0c             	pushl  0xc(%ebp)
  8025eb:	e8 89 eb ff ff       	call   801179 <memmove>
		*addrlen = ret->ret_addrlen;
  8025f0:	a1 10 70 80 00       	mov    0x807010,%eax
  8025f5:	89 06                	mov    %eax,(%esi)
  8025f7:	83 c4 10             	add    $0x10,%esp
	return r;
  8025fa:	eb d5                	jmp    8025d1 <nsipc_accept+0x2b>

008025fc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8025fc:	f3 0f 1e fb          	endbr32 
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	53                   	push   %ebx
  802604:	83 ec 08             	sub    $0x8,%esp
  802607:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802612:	53                   	push   %ebx
  802613:	ff 75 0c             	pushl  0xc(%ebp)
  802616:	68 04 70 80 00       	push   $0x807004
  80261b:	e8 59 eb ff ff       	call   801179 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802620:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802626:	b8 02 00 00 00       	mov    $0x2,%eax
  80262b:	e8 2a ff ff ff       	call   80255a <nsipc>
}
  802630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802635:	f3 0f 1e fb          	endbr32 
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
  80263c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80264a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80264f:	b8 03 00 00 00       	mov    $0x3,%eax
  802654:	e8 01 ff ff ff       	call   80255a <nsipc>
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <nsipc_close>:

int
nsipc_close(int s)
{
  80265b:	f3 0f 1e fb          	endbr32 
  80265f:	55                   	push   %ebp
  802660:	89 e5                	mov    %esp,%ebp
  802662:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80266d:	b8 04 00 00 00       	mov    $0x4,%eax
  802672:	e8 e3 fe ff ff       	call   80255a <nsipc>
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802679:	f3 0f 1e fb          	endbr32 
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	53                   	push   %ebx
  802681:	83 ec 08             	sub    $0x8,%esp
  802684:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80268f:	53                   	push   %ebx
  802690:	ff 75 0c             	pushl  0xc(%ebp)
  802693:	68 04 70 80 00       	push   $0x807004
  802698:	e8 dc ea ff ff       	call   801179 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80269d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8026a3:	b8 05 00 00 00       	mov    $0x5,%eax
  8026a8:	e8 ad fe ff ff       	call   80255a <nsipc>
}
  8026ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026b0:	c9                   	leave  
  8026b1:	c3                   	ret    

008026b2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8026b2:	f3 0f 1e fb          	endbr32 
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
  8026b9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8026c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8026cc:	b8 06 00 00 00       	mov    $0x6,%eax
  8026d1:	e8 84 fe ff ff       	call   80255a <nsipc>
}
  8026d6:	c9                   	leave  
  8026d7:	c3                   	ret    

008026d8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8026d8:	f3 0f 1e fb          	endbr32 
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	56                   	push   %esi
  8026e0:	53                   	push   %ebx
  8026e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8026ec:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8026f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8026f5:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8026fa:	b8 07 00 00 00       	mov    $0x7,%eax
  8026ff:	e8 56 fe ff ff       	call   80255a <nsipc>
  802704:	89 c3                	mov    %eax,%ebx
  802706:	85 c0                	test   %eax,%eax
  802708:	78 26                	js     802730 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80270a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802710:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802715:	0f 4e c6             	cmovle %esi,%eax
  802718:	39 c3                	cmp    %eax,%ebx
  80271a:	7f 1d                	jg     802739 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80271c:	83 ec 04             	sub    $0x4,%esp
  80271f:	53                   	push   %ebx
  802720:	68 00 70 80 00       	push   $0x807000
  802725:	ff 75 0c             	pushl  0xc(%ebp)
  802728:	e8 4c ea ff ff       	call   801179 <memmove>
  80272d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802730:	89 d8                	mov    %ebx,%eax
  802732:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802735:	5b                   	pop    %ebx
  802736:	5e                   	pop    %esi
  802737:	5d                   	pop    %ebp
  802738:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802739:	68 6f 36 80 00       	push   $0x80366f
  80273e:	68 37 36 80 00       	push   $0x803637
  802743:	6a 62                	push   $0x62
  802745:	68 84 36 80 00       	push   $0x803684
  80274a:	e8 83 e1 ff ff       	call   8008d2 <_panic>

0080274f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80274f:	f3 0f 1e fb          	endbr32 
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
  802756:	53                   	push   %ebx
  802757:	83 ec 04             	sub    $0x4,%esp
  80275a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80275d:	8b 45 08             	mov    0x8(%ebp),%eax
  802760:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802765:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80276b:	7f 2e                	jg     80279b <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80276d:	83 ec 04             	sub    $0x4,%esp
  802770:	53                   	push   %ebx
  802771:	ff 75 0c             	pushl  0xc(%ebp)
  802774:	68 0c 70 80 00       	push   $0x80700c
  802779:	e8 fb e9 ff ff       	call   801179 <memmove>
	nsipcbuf.send.req_size = size;
  80277e:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802784:	8b 45 14             	mov    0x14(%ebp),%eax
  802787:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80278c:	b8 08 00 00 00       	mov    $0x8,%eax
  802791:	e8 c4 fd ff ff       	call   80255a <nsipc>
}
  802796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802799:	c9                   	leave  
  80279a:	c3                   	ret    
	assert(size < 1600);
  80279b:	68 90 36 80 00       	push   $0x803690
  8027a0:	68 37 36 80 00       	push   $0x803637
  8027a5:	6a 6d                	push   $0x6d
  8027a7:	68 84 36 80 00       	push   $0x803684
  8027ac:	e8 21 e1 ff ff       	call   8008d2 <_panic>

008027b1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8027b1:	f3 0f 1e fb          	endbr32 
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8027c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8027cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ce:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8027d3:	b8 09 00 00 00       	mov    $0x9,%eax
  8027d8:	e8 7d fd ff ff       	call   80255a <nsipc>
}
  8027dd:	c9                   	leave  
  8027de:	c3                   	ret    

008027df <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8027df:	f3 0f 1e fb          	endbr32 
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	56                   	push   %esi
  8027e7:	53                   	push   %ebx
  8027e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8027eb:	83 ec 0c             	sub    $0xc,%esp
  8027ee:	ff 75 08             	pushl  0x8(%ebp)
  8027f1:	e8 f6 f2 ff ff       	call   801aec <fd2data>
  8027f6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8027f8:	83 c4 08             	add    $0x8,%esp
  8027fb:	68 9c 36 80 00       	push   $0x80369c
  802800:	53                   	push   %ebx
  802801:	e8 bd e7 ff ff       	call   800fc3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802806:	8b 46 04             	mov    0x4(%esi),%eax
  802809:	2b 06                	sub    (%esi),%eax
  80280b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802811:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802818:	00 00 00 
	stat->st_dev = &devpipe;
  80281b:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802822:	40 80 00 
	return 0;
}
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
  80282a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80282d:	5b                   	pop    %ebx
  80282e:	5e                   	pop    %esi
  80282f:	5d                   	pop    %ebp
  802830:	c3                   	ret    

00802831 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802831:	f3 0f 1e fb          	endbr32 
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	53                   	push   %ebx
  802839:	83 ec 0c             	sub    $0xc,%esp
  80283c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80283f:	53                   	push   %ebx
  802840:	6a 00                	push   $0x0
  802842:	e8 4b ec ff ff       	call   801492 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802847:	89 1c 24             	mov    %ebx,(%esp)
  80284a:	e8 9d f2 ff ff       	call   801aec <fd2data>
  80284f:	83 c4 08             	add    $0x8,%esp
  802852:	50                   	push   %eax
  802853:	6a 00                	push   $0x0
  802855:	e8 38 ec ff ff       	call   801492 <sys_page_unmap>
}
  80285a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <_pipeisclosed>:
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
  802862:	57                   	push   %edi
  802863:	56                   	push   %esi
  802864:	53                   	push   %ebx
  802865:	83 ec 1c             	sub    $0x1c,%esp
  802868:	89 c7                	mov    %eax,%edi
  80286a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80286c:	a1 20 50 80 00       	mov    0x805020,%eax
  802871:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802874:	83 ec 0c             	sub    $0xc,%esp
  802877:	57                   	push   %edi
  802878:	e8 f6 04 00 00       	call   802d73 <pageref>
  80287d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802880:	89 34 24             	mov    %esi,(%esp)
  802883:	e8 eb 04 00 00       	call   802d73 <pageref>
		nn = thisenv->env_runs;
  802888:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80288e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802891:	83 c4 10             	add    $0x10,%esp
  802894:	39 cb                	cmp    %ecx,%ebx
  802896:	74 1b                	je     8028b3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802898:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80289b:	75 cf                	jne    80286c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80289d:	8b 42 58             	mov    0x58(%edx),%eax
  8028a0:	6a 01                	push   $0x1
  8028a2:	50                   	push   %eax
  8028a3:	53                   	push   %ebx
  8028a4:	68 a3 36 80 00       	push   $0x8036a3
  8028a9:	e8 0b e1 ff ff       	call   8009b9 <cprintf>
  8028ae:	83 c4 10             	add    $0x10,%esp
  8028b1:	eb b9                	jmp    80286c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8028b3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8028b6:	0f 94 c0             	sete   %al
  8028b9:	0f b6 c0             	movzbl %al,%eax
}
  8028bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028bf:	5b                   	pop    %ebx
  8028c0:	5e                   	pop    %esi
  8028c1:	5f                   	pop    %edi
  8028c2:	5d                   	pop    %ebp
  8028c3:	c3                   	ret    

008028c4 <devpipe_write>:
{
  8028c4:	f3 0f 1e fb          	endbr32 
  8028c8:	55                   	push   %ebp
  8028c9:	89 e5                	mov    %esp,%ebp
  8028cb:	57                   	push   %edi
  8028cc:	56                   	push   %esi
  8028cd:	53                   	push   %ebx
  8028ce:	83 ec 28             	sub    $0x28,%esp
  8028d1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8028d4:	56                   	push   %esi
  8028d5:	e8 12 f2 ff ff       	call   801aec <fd2data>
  8028da:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8028dc:	83 c4 10             	add    $0x10,%esp
  8028df:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8028e7:	74 4f                	je     802938 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8028e9:	8b 43 04             	mov    0x4(%ebx),%eax
  8028ec:	8b 0b                	mov    (%ebx),%ecx
  8028ee:	8d 51 20             	lea    0x20(%ecx),%edx
  8028f1:	39 d0                	cmp    %edx,%eax
  8028f3:	72 14                	jb     802909 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8028f5:	89 da                	mov    %ebx,%edx
  8028f7:	89 f0                	mov    %esi,%eax
  8028f9:	e8 61 ff ff ff       	call   80285f <_pipeisclosed>
  8028fe:	85 c0                	test   %eax,%eax
  802900:	75 3b                	jne    80293d <devpipe_write+0x79>
			sys_yield();
  802902:	e8 db ea ff ff       	call   8013e2 <sys_yield>
  802907:	eb e0                	jmp    8028e9 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802909:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80290c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802910:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802913:	89 c2                	mov    %eax,%edx
  802915:	c1 fa 1f             	sar    $0x1f,%edx
  802918:	89 d1                	mov    %edx,%ecx
  80291a:	c1 e9 1b             	shr    $0x1b,%ecx
  80291d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802920:	83 e2 1f             	and    $0x1f,%edx
  802923:	29 ca                	sub    %ecx,%edx
  802925:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802929:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80292d:	83 c0 01             	add    $0x1,%eax
  802930:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802933:	83 c7 01             	add    $0x1,%edi
  802936:	eb ac                	jmp    8028e4 <devpipe_write+0x20>
	return i;
  802938:	8b 45 10             	mov    0x10(%ebp),%eax
  80293b:	eb 05                	jmp    802942 <devpipe_write+0x7e>
				return 0;
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802942:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802945:	5b                   	pop    %ebx
  802946:	5e                   	pop    %esi
  802947:	5f                   	pop    %edi
  802948:	5d                   	pop    %ebp
  802949:	c3                   	ret    

0080294a <devpipe_read>:
{
  80294a:	f3 0f 1e fb          	endbr32 
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	57                   	push   %edi
  802952:	56                   	push   %esi
  802953:	53                   	push   %ebx
  802954:	83 ec 18             	sub    $0x18,%esp
  802957:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80295a:	57                   	push   %edi
  80295b:	e8 8c f1 ff ff       	call   801aec <fd2data>
  802960:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802962:	83 c4 10             	add    $0x10,%esp
  802965:	be 00 00 00 00       	mov    $0x0,%esi
  80296a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80296d:	75 14                	jne    802983 <devpipe_read+0x39>
	return i;
  80296f:	8b 45 10             	mov    0x10(%ebp),%eax
  802972:	eb 02                	jmp    802976 <devpipe_read+0x2c>
				return i;
  802974:	89 f0                	mov    %esi,%eax
}
  802976:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802979:	5b                   	pop    %ebx
  80297a:	5e                   	pop    %esi
  80297b:	5f                   	pop    %edi
  80297c:	5d                   	pop    %ebp
  80297d:	c3                   	ret    
			sys_yield();
  80297e:	e8 5f ea ff ff       	call   8013e2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802983:	8b 03                	mov    (%ebx),%eax
  802985:	3b 43 04             	cmp    0x4(%ebx),%eax
  802988:	75 18                	jne    8029a2 <devpipe_read+0x58>
			if (i > 0)
  80298a:	85 f6                	test   %esi,%esi
  80298c:	75 e6                	jne    802974 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80298e:	89 da                	mov    %ebx,%edx
  802990:	89 f8                	mov    %edi,%eax
  802992:	e8 c8 fe ff ff       	call   80285f <_pipeisclosed>
  802997:	85 c0                	test   %eax,%eax
  802999:	74 e3                	je     80297e <devpipe_read+0x34>
				return 0;
  80299b:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a0:	eb d4                	jmp    802976 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8029a2:	99                   	cltd   
  8029a3:	c1 ea 1b             	shr    $0x1b,%edx
  8029a6:	01 d0                	add    %edx,%eax
  8029a8:	83 e0 1f             	and    $0x1f,%eax
  8029ab:	29 d0                	sub    %edx,%eax
  8029ad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8029b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029b5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8029b8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8029bb:	83 c6 01             	add    $0x1,%esi
  8029be:	eb aa                	jmp    80296a <devpipe_read+0x20>

008029c0 <pipe>:
{
  8029c0:	f3 0f 1e fb          	endbr32 
  8029c4:	55                   	push   %ebp
  8029c5:	89 e5                	mov    %esp,%ebp
  8029c7:	56                   	push   %esi
  8029c8:	53                   	push   %ebx
  8029c9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8029cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029cf:	50                   	push   %eax
  8029d0:	e8 32 f1 ff ff       	call   801b07 <fd_alloc>
  8029d5:	89 c3                	mov    %eax,%ebx
  8029d7:	83 c4 10             	add    $0x10,%esp
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	0f 88 23 01 00 00    	js     802b05 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	68 07 04 00 00       	push   $0x407
  8029ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8029ed:	6a 00                	push   $0x0
  8029ef:	e8 11 ea ff ff       	call   801405 <sys_page_alloc>
  8029f4:	89 c3                	mov    %eax,%ebx
  8029f6:	83 c4 10             	add    $0x10,%esp
  8029f9:	85 c0                	test   %eax,%eax
  8029fb:	0f 88 04 01 00 00    	js     802b05 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802a01:	83 ec 0c             	sub    $0xc,%esp
  802a04:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802a07:	50                   	push   %eax
  802a08:	e8 fa f0 ff ff       	call   801b07 <fd_alloc>
  802a0d:	89 c3                	mov    %eax,%ebx
  802a0f:	83 c4 10             	add    $0x10,%esp
  802a12:	85 c0                	test   %eax,%eax
  802a14:	0f 88 db 00 00 00    	js     802af5 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a1a:	83 ec 04             	sub    $0x4,%esp
  802a1d:	68 07 04 00 00       	push   $0x407
  802a22:	ff 75 f0             	pushl  -0x10(%ebp)
  802a25:	6a 00                	push   $0x0
  802a27:	e8 d9 e9 ff ff       	call   801405 <sys_page_alloc>
  802a2c:	89 c3                	mov    %eax,%ebx
  802a2e:	83 c4 10             	add    $0x10,%esp
  802a31:	85 c0                	test   %eax,%eax
  802a33:	0f 88 bc 00 00 00    	js     802af5 <pipe+0x135>
	va = fd2data(fd0);
  802a39:	83 ec 0c             	sub    $0xc,%esp
  802a3c:	ff 75 f4             	pushl  -0xc(%ebp)
  802a3f:	e8 a8 f0 ff ff       	call   801aec <fd2data>
  802a44:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a46:	83 c4 0c             	add    $0xc,%esp
  802a49:	68 07 04 00 00       	push   $0x407
  802a4e:	50                   	push   %eax
  802a4f:	6a 00                	push   $0x0
  802a51:	e8 af e9 ff ff       	call   801405 <sys_page_alloc>
  802a56:	89 c3                	mov    %eax,%ebx
  802a58:	83 c4 10             	add    $0x10,%esp
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	0f 88 82 00 00 00    	js     802ae5 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a63:	83 ec 0c             	sub    $0xc,%esp
  802a66:	ff 75 f0             	pushl  -0x10(%ebp)
  802a69:	e8 7e f0 ff ff       	call   801aec <fd2data>
  802a6e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802a75:	50                   	push   %eax
  802a76:	6a 00                	push   $0x0
  802a78:	56                   	push   %esi
  802a79:	6a 00                	push   $0x0
  802a7b:	e8 cc e9 ff ff       	call   80144c <sys_page_map>
  802a80:	89 c3                	mov    %eax,%ebx
  802a82:	83 c4 20             	add    $0x20,%esp
  802a85:	85 c0                	test   %eax,%eax
  802a87:	78 4e                	js     802ad7 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802a89:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a91:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802a93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a96:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802aac:	83 ec 0c             	sub    $0xc,%esp
  802aaf:	ff 75 f4             	pushl  -0xc(%ebp)
  802ab2:	e8 21 f0 ff ff       	call   801ad8 <fd2num>
  802ab7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802aba:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802abc:	83 c4 04             	add    $0x4,%esp
  802abf:	ff 75 f0             	pushl  -0x10(%ebp)
  802ac2:	e8 11 f0 ff ff       	call   801ad8 <fd2num>
  802ac7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802aca:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802acd:	83 c4 10             	add    $0x10,%esp
  802ad0:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ad5:	eb 2e                	jmp    802b05 <pipe+0x145>
	sys_page_unmap(0, va);
  802ad7:	83 ec 08             	sub    $0x8,%esp
  802ada:	56                   	push   %esi
  802adb:	6a 00                	push   $0x0
  802add:	e8 b0 e9 ff ff       	call   801492 <sys_page_unmap>
  802ae2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802ae5:	83 ec 08             	sub    $0x8,%esp
  802ae8:	ff 75 f0             	pushl  -0x10(%ebp)
  802aeb:	6a 00                	push   $0x0
  802aed:	e8 a0 e9 ff ff       	call   801492 <sys_page_unmap>
  802af2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802af5:	83 ec 08             	sub    $0x8,%esp
  802af8:	ff 75 f4             	pushl  -0xc(%ebp)
  802afb:	6a 00                	push   $0x0
  802afd:	e8 90 e9 ff ff       	call   801492 <sys_page_unmap>
  802b02:	83 c4 10             	add    $0x10,%esp
}
  802b05:	89 d8                	mov    %ebx,%eax
  802b07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b0a:	5b                   	pop    %ebx
  802b0b:	5e                   	pop    %esi
  802b0c:	5d                   	pop    %ebp
  802b0d:	c3                   	ret    

00802b0e <pipeisclosed>:
{
  802b0e:	f3 0f 1e fb          	endbr32 
  802b12:	55                   	push   %ebp
  802b13:	89 e5                	mov    %esp,%ebp
  802b15:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b1b:	50                   	push   %eax
  802b1c:	ff 75 08             	pushl  0x8(%ebp)
  802b1f:	e8 39 f0 ff ff       	call   801b5d <fd_lookup>
  802b24:	83 c4 10             	add    $0x10,%esp
  802b27:	85 c0                	test   %eax,%eax
  802b29:	78 18                	js     802b43 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802b2b:	83 ec 0c             	sub    $0xc,%esp
  802b2e:	ff 75 f4             	pushl  -0xc(%ebp)
  802b31:	e8 b6 ef ff ff       	call   801aec <fd2data>
  802b36:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	e8 1f fd ff ff       	call   80285f <_pipeisclosed>
  802b40:	83 c4 10             	add    $0x10,%esp
}
  802b43:	c9                   	leave  
  802b44:	c3                   	ret    

00802b45 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802b45:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802b49:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4e:	c3                   	ret    

00802b4f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802b4f:	f3 0f 1e fb          	endbr32 
  802b53:	55                   	push   %ebp
  802b54:	89 e5                	mov    %esp,%ebp
  802b56:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802b59:	68 bb 36 80 00       	push   $0x8036bb
  802b5e:	ff 75 0c             	pushl  0xc(%ebp)
  802b61:	e8 5d e4 ff ff       	call   800fc3 <strcpy>
	return 0;
}
  802b66:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6b:	c9                   	leave  
  802b6c:	c3                   	ret    

00802b6d <devcons_write>:
{
  802b6d:	f3 0f 1e fb          	endbr32 
  802b71:	55                   	push   %ebp
  802b72:	89 e5                	mov    %esp,%ebp
  802b74:	57                   	push   %edi
  802b75:	56                   	push   %esi
  802b76:	53                   	push   %ebx
  802b77:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802b7d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802b82:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802b88:	3b 75 10             	cmp    0x10(%ebp),%esi
  802b8b:	73 31                	jae    802bbe <devcons_write+0x51>
		m = n - tot;
  802b8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b90:	29 f3                	sub    %esi,%ebx
  802b92:	83 fb 7f             	cmp    $0x7f,%ebx
  802b95:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802b9a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802b9d:	83 ec 04             	sub    $0x4,%esp
  802ba0:	53                   	push   %ebx
  802ba1:	89 f0                	mov    %esi,%eax
  802ba3:	03 45 0c             	add    0xc(%ebp),%eax
  802ba6:	50                   	push   %eax
  802ba7:	57                   	push   %edi
  802ba8:	e8 cc e5 ff ff       	call   801179 <memmove>
		sys_cputs(buf, m);
  802bad:	83 c4 08             	add    $0x8,%esp
  802bb0:	53                   	push   %ebx
  802bb1:	57                   	push   %edi
  802bb2:	e8 7e e7 ff ff       	call   801335 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802bb7:	01 de                	add    %ebx,%esi
  802bb9:	83 c4 10             	add    $0x10,%esp
  802bbc:	eb ca                	jmp    802b88 <devcons_write+0x1b>
}
  802bbe:	89 f0                	mov    %esi,%eax
  802bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bc3:	5b                   	pop    %ebx
  802bc4:	5e                   	pop    %esi
  802bc5:	5f                   	pop    %edi
  802bc6:	5d                   	pop    %ebp
  802bc7:	c3                   	ret    

00802bc8 <devcons_read>:
{
  802bc8:	f3 0f 1e fb          	endbr32 
  802bcc:	55                   	push   %ebp
  802bcd:	89 e5                	mov    %esp,%ebp
  802bcf:	83 ec 08             	sub    $0x8,%esp
  802bd2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802bd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802bdb:	74 21                	je     802bfe <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802bdd:	e8 75 e7 ff ff       	call   801357 <sys_cgetc>
  802be2:	85 c0                	test   %eax,%eax
  802be4:	75 07                	jne    802bed <devcons_read+0x25>
		sys_yield();
  802be6:	e8 f7 e7 ff ff       	call   8013e2 <sys_yield>
  802beb:	eb f0                	jmp    802bdd <devcons_read+0x15>
	if (c < 0)
  802bed:	78 0f                	js     802bfe <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802bef:	83 f8 04             	cmp    $0x4,%eax
  802bf2:	74 0c                	je     802c00 <devcons_read+0x38>
	*(char*)vbuf = c;
  802bf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf7:	88 02                	mov    %al,(%edx)
	return 1;
  802bf9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802bfe:	c9                   	leave  
  802bff:	c3                   	ret    
		return 0;
  802c00:	b8 00 00 00 00       	mov    $0x0,%eax
  802c05:	eb f7                	jmp    802bfe <devcons_read+0x36>

00802c07 <cputchar>:
{
  802c07:	f3 0f 1e fb          	endbr32 
  802c0b:	55                   	push   %ebp
  802c0c:	89 e5                	mov    %esp,%ebp
  802c0e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802c17:	6a 01                	push   $0x1
  802c19:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802c1c:	50                   	push   %eax
  802c1d:	e8 13 e7 ff ff       	call   801335 <sys_cputs>
}
  802c22:	83 c4 10             	add    $0x10,%esp
  802c25:	c9                   	leave  
  802c26:	c3                   	ret    

00802c27 <getchar>:
{
  802c27:	f3 0f 1e fb          	endbr32 
  802c2b:	55                   	push   %ebp
  802c2c:	89 e5                	mov    %esp,%ebp
  802c2e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802c31:	6a 01                	push   $0x1
  802c33:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802c36:	50                   	push   %eax
  802c37:	6a 00                	push   $0x0
  802c39:	e8 a7 f1 ff ff       	call   801de5 <read>
	if (r < 0)
  802c3e:	83 c4 10             	add    $0x10,%esp
  802c41:	85 c0                	test   %eax,%eax
  802c43:	78 06                	js     802c4b <getchar+0x24>
	if (r < 1)
  802c45:	74 06                	je     802c4d <getchar+0x26>
	return c;
  802c47:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802c4b:	c9                   	leave  
  802c4c:	c3                   	ret    
		return -E_EOF;
  802c4d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802c52:	eb f7                	jmp    802c4b <getchar+0x24>

00802c54 <iscons>:
{
  802c54:	f3 0f 1e fb          	endbr32 
  802c58:	55                   	push   %ebp
  802c59:	89 e5                	mov    %esp,%ebp
  802c5b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c61:	50                   	push   %eax
  802c62:	ff 75 08             	pushl  0x8(%ebp)
  802c65:	e8 f3 ee ff ff       	call   801b5d <fd_lookup>
  802c6a:	83 c4 10             	add    $0x10,%esp
  802c6d:	85 c0                	test   %eax,%eax
  802c6f:	78 11                	js     802c82 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802c7a:	39 10                	cmp    %edx,(%eax)
  802c7c:	0f 94 c0             	sete   %al
  802c7f:	0f b6 c0             	movzbl %al,%eax
}
  802c82:	c9                   	leave  
  802c83:	c3                   	ret    

00802c84 <opencons>:
{
  802c84:	f3 0f 1e fb          	endbr32 
  802c88:	55                   	push   %ebp
  802c89:	89 e5                	mov    %esp,%ebp
  802c8b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802c8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c91:	50                   	push   %eax
  802c92:	e8 70 ee ff ff       	call   801b07 <fd_alloc>
  802c97:	83 c4 10             	add    $0x10,%esp
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	78 3a                	js     802cd8 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c9e:	83 ec 04             	sub    $0x4,%esp
  802ca1:	68 07 04 00 00       	push   $0x407
  802ca6:	ff 75 f4             	pushl  -0xc(%ebp)
  802ca9:	6a 00                	push   $0x0
  802cab:	e8 55 e7 ff ff       	call   801405 <sys_page_alloc>
  802cb0:	83 c4 10             	add    $0x10,%esp
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	78 21                	js     802cd8 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802cc0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802ccc:	83 ec 0c             	sub    $0xc,%esp
  802ccf:	50                   	push   %eax
  802cd0:	e8 03 ee ff ff       	call   801ad8 <fd2num>
  802cd5:	83 c4 10             	add    $0x10,%esp
}
  802cd8:	c9                   	leave  
  802cd9:	c3                   	ret    

00802cda <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802cda:	f3 0f 1e fb          	endbr32 
  802cde:	55                   	push   %ebp
  802cdf:	89 e5                	mov    %esp,%ebp
  802ce1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802ce4:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802ceb:	74 0a                	je     802cf7 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802cf5:	c9                   	leave  
  802cf6:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802cf7:	83 ec 04             	sub    $0x4,%esp
  802cfa:	6a 07                	push   $0x7
  802cfc:	68 00 f0 bf ee       	push   $0xeebff000
  802d01:	6a 00                	push   $0x0
  802d03:	e8 fd e6 ff ff       	call   801405 <sys_page_alloc>
  802d08:	83 c4 10             	add    $0x10,%esp
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	78 2a                	js     802d39 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802d0f:	83 ec 08             	sub    $0x8,%esp
  802d12:	68 4d 2d 80 00       	push   $0x802d4d
  802d17:	6a 00                	push   $0x0
  802d19:	e8 46 e8 ff ff       	call   801564 <sys_env_set_pgfault_upcall>
  802d1e:	83 c4 10             	add    $0x10,%esp
  802d21:	85 c0                	test   %eax,%eax
  802d23:	79 c8                	jns    802ced <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	68 f4 36 80 00       	push   $0x8036f4
  802d2d:	6a 25                	push   $0x25
  802d2f:	68 2c 37 80 00       	push   $0x80372c
  802d34:	e8 99 db ff ff       	call   8008d2 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802d39:	83 ec 04             	sub    $0x4,%esp
  802d3c:	68 c8 36 80 00       	push   $0x8036c8
  802d41:	6a 22                	push   $0x22
  802d43:	68 2c 37 80 00       	push   $0x80372c
  802d48:	e8 85 db ff ff       	call   8008d2 <_panic>

00802d4d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802d4d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802d4e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802d53:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802d55:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802d58:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802d5c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802d60:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802d63:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802d65:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802d69:	83 c4 08             	add    $0x8,%esp
	popal
  802d6c:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802d6d:	83 c4 04             	add    $0x4,%esp
	popfl
  802d70:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802d71:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802d72:	c3                   	ret    

00802d73 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d73:	f3 0f 1e fb          	endbr32 
  802d77:	55                   	push   %ebp
  802d78:	89 e5                	mov    %esp,%ebp
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d7d:	89 c2                	mov    %eax,%edx
  802d7f:	c1 ea 16             	shr    $0x16,%edx
  802d82:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802d89:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802d8e:	f6 c1 01             	test   $0x1,%cl
  802d91:	74 1c                	je     802daf <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802d93:	c1 e8 0c             	shr    $0xc,%eax
  802d96:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802d9d:	a8 01                	test   $0x1,%al
  802d9f:	74 0e                	je     802daf <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802da1:	c1 e8 0c             	shr    $0xc,%eax
  802da4:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802dab:	ef 
  802dac:	0f b7 d2             	movzwl %dx,%edx
}
  802daf:	89 d0                	mov    %edx,%eax
  802db1:	5d                   	pop    %ebp
  802db2:	c3                   	ret    
  802db3:	66 90                	xchg   %ax,%ax
  802db5:	66 90                	xchg   %ax,%ax
  802db7:	66 90                	xchg   %ax,%ax
  802db9:	66 90                	xchg   %ax,%ax
  802dbb:	66 90                	xchg   %ax,%ax
  802dbd:	66 90                	xchg   %ax,%ax
  802dbf:	90                   	nop

00802dc0 <__udivdi3>:
  802dc0:	f3 0f 1e fb          	endbr32 
  802dc4:	55                   	push   %ebp
  802dc5:	57                   	push   %edi
  802dc6:	56                   	push   %esi
  802dc7:	53                   	push   %ebx
  802dc8:	83 ec 1c             	sub    $0x1c,%esp
  802dcb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802dcf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802dd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  802dd7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802ddb:	85 d2                	test   %edx,%edx
  802ddd:	75 19                	jne    802df8 <__udivdi3+0x38>
  802ddf:	39 f3                	cmp    %esi,%ebx
  802de1:	76 4d                	jbe    802e30 <__udivdi3+0x70>
  802de3:	31 ff                	xor    %edi,%edi
  802de5:	89 e8                	mov    %ebp,%eax
  802de7:	89 f2                	mov    %esi,%edx
  802de9:	f7 f3                	div    %ebx
  802deb:	89 fa                	mov    %edi,%edx
  802ded:	83 c4 1c             	add    $0x1c,%esp
  802df0:	5b                   	pop    %ebx
  802df1:	5e                   	pop    %esi
  802df2:	5f                   	pop    %edi
  802df3:	5d                   	pop    %ebp
  802df4:	c3                   	ret    
  802df5:	8d 76 00             	lea    0x0(%esi),%esi
  802df8:	39 f2                	cmp    %esi,%edx
  802dfa:	76 14                	jbe    802e10 <__udivdi3+0x50>
  802dfc:	31 ff                	xor    %edi,%edi
  802dfe:	31 c0                	xor    %eax,%eax
  802e00:	89 fa                	mov    %edi,%edx
  802e02:	83 c4 1c             	add    $0x1c,%esp
  802e05:	5b                   	pop    %ebx
  802e06:	5e                   	pop    %esi
  802e07:	5f                   	pop    %edi
  802e08:	5d                   	pop    %ebp
  802e09:	c3                   	ret    
  802e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e10:	0f bd fa             	bsr    %edx,%edi
  802e13:	83 f7 1f             	xor    $0x1f,%edi
  802e16:	75 48                	jne    802e60 <__udivdi3+0xa0>
  802e18:	39 f2                	cmp    %esi,%edx
  802e1a:	72 06                	jb     802e22 <__udivdi3+0x62>
  802e1c:	31 c0                	xor    %eax,%eax
  802e1e:	39 eb                	cmp    %ebp,%ebx
  802e20:	77 de                	ja     802e00 <__udivdi3+0x40>
  802e22:	b8 01 00 00 00       	mov    $0x1,%eax
  802e27:	eb d7                	jmp    802e00 <__udivdi3+0x40>
  802e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e30:	89 d9                	mov    %ebx,%ecx
  802e32:	85 db                	test   %ebx,%ebx
  802e34:	75 0b                	jne    802e41 <__udivdi3+0x81>
  802e36:	b8 01 00 00 00       	mov    $0x1,%eax
  802e3b:	31 d2                	xor    %edx,%edx
  802e3d:	f7 f3                	div    %ebx
  802e3f:	89 c1                	mov    %eax,%ecx
  802e41:	31 d2                	xor    %edx,%edx
  802e43:	89 f0                	mov    %esi,%eax
  802e45:	f7 f1                	div    %ecx
  802e47:	89 c6                	mov    %eax,%esi
  802e49:	89 e8                	mov    %ebp,%eax
  802e4b:	89 f7                	mov    %esi,%edi
  802e4d:	f7 f1                	div    %ecx
  802e4f:	89 fa                	mov    %edi,%edx
  802e51:	83 c4 1c             	add    $0x1c,%esp
  802e54:	5b                   	pop    %ebx
  802e55:	5e                   	pop    %esi
  802e56:	5f                   	pop    %edi
  802e57:	5d                   	pop    %ebp
  802e58:	c3                   	ret    
  802e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e60:	89 f9                	mov    %edi,%ecx
  802e62:	b8 20 00 00 00       	mov    $0x20,%eax
  802e67:	29 f8                	sub    %edi,%eax
  802e69:	d3 e2                	shl    %cl,%edx
  802e6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e6f:	89 c1                	mov    %eax,%ecx
  802e71:	89 da                	mov    %ebx,%edx
  802e73:	d3 ea                	shr    %cl,%edx
  802e75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e79:	09 d1                	or     %edx,%ecx
  802e7b:	89 f2                	mov    %esi,%edx
  802e7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e81:	89 f9                	mov    %edi,%ecx
  802e83:	d3 e3                	shl    %cl,%ebx
  802e85:	89 c1                	mov    %eax,%ecx
  802e87:	d3 ea                	shr    %cl,%edx
  802e89:	89 f9                	mov    %edi,%ecx
  802e8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802e8f:	89 eb                	mov    %ebp,%ebx
  802e91:	d3 e6                	shl    %cl,%esi
  802e93:	89 c1                	mov    %eax,%ecx
  802e95:	d3 eb                	shr    %cl,%ebx
  802e97:	09 de                	or     %ebx,%esi
  802e99:	89 f0                	mov    %esi,%eax
  802e9b:	f7 74 24 08          	divl   0x8(%esp)
  802e9f:	89 d6                	mov    %edx,%esi
  802ea1:	89 c3                	mov    %eax,%ebx
  802ea3:	f7 64 24 0c          	mull   0xc(%esp)
  802ea7:	39 d6                	cmp    %edx,%esi
  802ea9:	72 15                	jb     802ec0 <__udivdi3+0x100>
  802eab:	89 f9                	mov    %edi,%ecx
  802ead:	d3 e5                	shl    %cl,%ebp
  802eaf:	39 c5                	cmp    %eax,%ebp
  802eb1:	73 04                	jae    802eb7 <__udivdi3+0xf7>
  802eb3:	39 d6                	cmp    %edx,%esi
  802eb5:	74 09                	je     802ec0 <__udivdi3+0x100>
  802eb7:	89 d8                	mov    %ebx,%eax
  802eb9:	31 ff                	xor    %edi,%edi
  802ebb:	e9 40 ff ff ff       	jmp    802e00 <__udivdi3+0x40>
  802ec0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ec3:	31 ff                	xor    %edi,%edi
  802ec5:	e9 36 ff ff ff       	jmp    802e00 <__udivdi3+0x40>
  802eca:	66 90                	xchg   %ax,%ax
  802ecc:	66 90                	xchg   %ax,%ax
  802ece:	66 90                	xchg   %ax,%ax

00802ed0 <__umoddi3>:
  802ed0:	f3 0f 1e fb          	endbr32 
  802ed4:	55                   	push   %ebp
  802ed5:	57                   	push   %edi
  802ed6:	56                   	push   %esi
  802ed7:	53                   	push   %ebx
  802ed8:	83 ec 1c             	sub    $0x1c,%esp
  802edb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802edf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ee3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802ee7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	75 19                	jne    802f08 <__umoddi3+0x38>
  802eef:	39 df                	cmp    %ebx,%edi
  802ef1:	76 5d                	jbe    802f50 <__umoddi3+0x80>
  802ef3:	89 f0                	mov    %esi,%eax
  802ef5:	89 da                	mov    %ebx,%edx
  802ef7:	f7 f7                	div    %edi
  802ef9:	89 d0                	mov    %edx,%eax
  802efb:	31 d2                	xor    %edx,%edx
  802efd:	83 c4 1c             	add    $0x1c,%esp
  802f00:	5b                   	pop    %ebx
  802f01:	5e                   	pop    %esi
  802f02:	5f                   	pop    %edi
  802f03:	5d                   	pop    %ebp
  802f04:	c3                   	ret    
  802f05:	8d 76 00             	lea    0x0(%esi),%esi
  802f08:	89 f2                	mov    %esi,%edx
  802f0a:	39 d8                	cmp    %ebx,%eax
  802f0c:	76 12                	jbe    802f20 <__umoddi3+0x50>
  802f0e:	89 f0                	mov    %esi,%eax
  802f10:	89 da                	mov    %ebx,%edx
  802f12:	83 c4 1c             	add    $0x1c,%esp
  802f15:	5b                   	pop    %ebx
  802f16:	5e                   	pop    %esi
  802f17:	5f                   	pop    %edi
  802f18:	5d                   	pop    %ebp
  802f19:	c3                   	ret    
  802f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f20:	0f bd e8             	bsr    %eax,%ebp
  802f23:	83 f5 1f             	xor    $0x1f,%ebp
  802f26:	75 50                	jne    802f78 <__umoddi3+0xa8>
  802f28:	39 d8                	cmp    %ebx,%eax
  802f2a:	0f 82 e0 00 00 00    	jb     803010 <__umoddi3+0x140>
  802f30:	89 d9                	mov    %ebx,%ecx
  802f32:	39 f7                	cmp    %esi,%edi
  802f34:	0f 86 d6 00 00 00    	jbe    803010 <__umoddi3+0x140>
  802f3a:	89 d0                	mov    %edx,%eax
  802f3c:	89 ca                	mov    %ecx,%edx
  802f3e:	83 c4 1c             	add    $0x1c,%esp
  802f41:	5b                   	pop    %ebx
  802f42:	5e                   	pop    %esi
  802f43:	5f                   	pop    %edi
  802f44:	5d                   	pop    %ebp
  802f45:	c3                   	ret    
  802f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f4d:	8d 76 00             	lea    0x0(%esi),%esi
  802f50:	89 fd                	mov    %edi,%ebp
  802f52:	85 ff                	test   %edi,%edi
  802f54:	75 0b                	jne    802f61 <__umoddi3+0x91>
  802f56:	b8 01 00 00 00       	mov    $0x1,%eax
  802f5b:	31 d2                	xor    %edx,%edx
  802f5d:	f7 f7                	div    %edi
  802f5f:	89 c5                	mov    %eax,%ebp
  802f61:	89 d8                	mov    %ebx,%eax
  802f63:	31 d2                	xor    %edx,%edx
  802f65:	f7 f5                	div    %ebp
  802f67:	89 f0                	mov    %esi,%eax
  802f69:	f7 f5                	div    %ebp
  802f6b:	89 d0                	mov    %edx,%eax
  802f6d:	31 d2                	xor    %edx,%edx
  802f6f:	eb 8c                	jmp    802efd <__umoddi3+0x2d>
  802f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f78:	89 e9                	mov    %ebp,%ecx
  802f7a:	ba 20 00 00 00       	mov    $0x20,%edx
  802f7f:	29 ea                	sub    %ebp,%edx
  802f81:	d3 e0                	shl    %cl,%eax
  802f83:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f87:	89 d1                	mov    %edx,%ecx
  802f89:	89 f8                	mov    %edi,%eax
  802f8b:	d3 e8                	shr    %cl,%eax
  802f8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802f91:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f95:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f99:	09 c1                	or     %eax,%ecx
  802f9b:	89 d8                	mov    %ebx,%eax
  802f9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802fa1:	89 e9                	mov    %ebp,%ecx
  802fa3:	d3 e7                	shl    %cl,%edi
  802fa5:	89 d1                	mov    %edx,%ecx
  802fa7:	d3 e8                	shr    %cl,%eax
  802fa9:	89 e9                	mov    %ebp,%ecx
  802fab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802faf:	d3 e3                	shl    %cl,%ebx
  802fb1:	89 c7                	mov    %eax,%edi
  802fb3:	89 d1                	mov    %edx,%ecx
  802fb5:	89 f0                	mov    %esi,%eax
  802fb7:	d3 e8                	shr    %cl,%eax
  802fb9:	89 e9                	mov    %ebp,%ecx
  802fbb:	89 fa                	mov    %edi,%edx
  802fbd:	d3 e6                	shl    %cl,%esi
  802fbf:	09 d8                	or     %ebx,%eax
  802fc1:	f7 74 24 08          	divl   0x8(%esp)
  802fc5:	89 d1                	mov    %edx,%ecx
  802fc7:	89 f3                	mov    %esi,%ebx
  802fc9:	f7 64 24 0c          	mull   0xc(%esp)
  802fcd:	89 c6                	mov    %eax,%esi
  802fcf:	89 d7                	mov    %edx,%edi
  802fd1:	39 d1                	cmp    %edx,%ecx
  802fd3:	72 06                	jb     802fdb <__umoddi3+0x10b>
  802fd5:	75 10                	jne    802fe7 <__umoddi3+0x117>
  802fd7:	39 c3                	cmp    %eax,%ebx
  802fd9:	73 0c                	jae    802fe7 <__umoddi3+0x117>
  802fdb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802fdf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802fe3:	89 d7                	mov    %edx,%edi
  802fe5:	89 c6                	mov    %eax,%esi
  802fe7:	89 ca                	mov    %ecx,%edx
  802fe9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802fee:	29 f3                	sub    %esi,%ebx
  802ff0:	19 fa                	sbb    %edi,%edx
  802ff2:	89 d0                	mov    %edx,%eax
  802ff4:	d3 e0                	shl    %cl,%eax
  802ff6:	89 e9                	mov    %ebp,%ecx
  802ff8:	d3 eb                	shr    %cl,%ebx
  802ffa:	d3 ea                	shr    %cl,%edx
  802ffc:	09 d8                	or     %ebx,%eax
  802ffe:	83 c4 1c             	add    $0x1c,%esp
  803001:	5b                   	pop    %ebx
  803002:	5e                   	pop    %esi
  803003:	5f                   	pop    %edi
  803004:	5d                   	pop    %ebp
  803005:	c3                   	ret    
  803006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80300d:	8d 76 00             	lea    0x0(%esi),%esi
  803010:	29 fe                	sub    %edi,%esi
  803012:	19 c3                	sbb    %eax,%ebx
  803014:	89 f2                	mov    %esi,%edx
  803016:	89 d9                	mov    %ebx,%ecx
  803018:	e9 1d ff ff ff       	jmp    802f3a <__umoddi3+0x6a>
