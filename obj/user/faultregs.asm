
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 b8 05 00 00       	call   8005e9 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 d1 2a 80 00       	push   $0x802ad1
  800049:	68 a0 2a 80 00       	push   $0x802aa0
  80004e:	e8 e5 06 00 00       	call   800738 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 b0 2a 80 00       	push   $0x802ab0
  80005c:	68 b4 2a 80 00       	push   $0x802ab4
  800061:	e8 d2 06 00 00       	call   800738 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 c8 2a 80 00       	push   $0x802ac8
  80007b:	e8 b8 06 00 00       	call   800738 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 d2 2a 80 00       	push   $0x802ad2
  800093:	68 b4 2a 80 00       	push   $0x802ab4
  800098:	e8 9b 06 00 00       	call   800738 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 c8 2a 80 00       	push   $0x802ac8
  8000b4:	e8 7f 06 00 00       	call   800738 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 d6 2a 80 00       	push   $0x802ad6
  8000cc:	68 b4 2a 80 00       	push   $0x802ab4
  8000d1:	e8 62 06 00 00       	call   800738 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 c8 2a 80 00       	push   $0x802ac8
  8000ed:	e8 46 06 00 00       	call   800738 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 da 2a 80 00       	push   $0x802ada
  800105:	68 b4 2a 80 00       	push   $0x802ab4
  80010a:	e8 29 06 00 00       	call   800738 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 c8 2a 80 00       	push   $0x802ac8
  800126:	e8 0d 06 00 00       	call   800738 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 de 2a 80 00       	push   $0x802ade
  80013e:	68 b4 2a 80 00       	push   $0x802ab4
  800143:	e8 f0 05 00 00       	call   800738 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 c8 2a 80 00       	push   $0x802ac8
  80015f:	e8 d4 05 00 00       	call   800738 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 e2 2a 80 00       	push   $0x802ae2
  800177:	68 b4 2a 80 00       	push   $0x802ab4
  80017c:	e8 b7 05 00 00       	call   800738 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 c8 2a 80 00       	push   $0x802ac8
  800198:	e8 9b 05 00 00       	call   800738 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 e6 2a 80 00       	push   $0x802ae6
  8001b0:	68 b4 2a 80 00       	push   $0x802ab4
  8001b5:	e8 7e 05 00 00       	call   800738 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 c8 2a 80 00       	push   $0x802ac8
  8001d1:	e8 62 05 00 00       	call   800738 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 ea 2a 80 00       	push   $0x802aea
  8001e9:	68 b4 2a 80 00       	push   $0x802ab4
  8001ee:	e8 45 05 00 00       	call   800738 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 c8 2a 80 00       	push   $0x802ac8
  80020a:	e8 29 05 00 00       	call   800738 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 ee 2a 80 00       	push   $0x802aee
  800222:	68 b4 2a 80 00       	push   $0x802ab4
  800227:	e8 0c 05 00 00       	call   800738 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 c8 2a 80 00       	push   $0x802ac8
  800243:	e8 f0 04 00 00       	call   800738 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 f5 2a 80 00       	push   $0x802af5
  800253:	68 b4 2a 80 00       	push   $0x802ab4
  800258:	e8 db 04 00 00       	call   800738 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 c8 2a 80 00       	push   $0x802ac8
  800274:	e8 bf 04 00 00       	call   800738 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 f9 2a 80 00       	push   $0x802af9
  800284:	e8 af 04 00 00       	call   800738 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 c8 2a 80 00       	push   $0x802ac8
  800294:	e8 9f 04 00 00       	call   800738 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 c4 2a 80 00       	push   $0x802ac4
  8002a9:	e8 8a 04 00 00       	call   800738 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 c4 2a 80 00       	push   $0x802ac4
  8002c3:	e8 70 04 00 00       	call   800738 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 c4 2a 80 00       	push   $0x802ac4
  8002d8:	e8 5b 04 00 00       	call   800738 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 c4 2a 80 00       	push   $0x802ac4
  8002ed:	e8 46 04 00 00       	call   800738 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 c4 2a 80 00       	push   $0x802ac4
  800302:	e8 31 04 00 00       	call   800738 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 c4 2a 80 00       	push   $0x802ac4
  800317:	e8 1c 04 00 00       	call   800738 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 c4 2a 80 00       	push   $0x802ac4
  80032c:	e8 07 04 00 00       	call   800738 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 c4 2a 80 00       	push   $0x802ac4
  800341:	e8 f2 03 00 00       	call   800738 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 c4 2a 80 00       	push   $0x802ac4
  800356:	e8 dd 03 00 00       	call   800738 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 f5 2a 80 00       	push   $0x802af5
  800366:	68 b4 2a 80 00       	push   $0x802ab4
  80036b:	e8 c8 03 00 00       	call   800738 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 c4 2a 80 00       	push   $0x802ac4
  800387:	e8 ac 03 00 00       	call   800738 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 f9 2a 80 00       	push   $0x802af9
  800397:	e8 9c 03 00 00       	call   800738 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 c4 2a 80 00       	push   $0x802ac4
  8003af:	e8 84 03 00 00       	call   800738 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
}
  8003b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 c4 2a 80 00       	push   $0x802ac4
  8003c7:	e8 6c 03 00 00       	call   800738 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 f9 2a 80 00       	push   $0x802af9
  8003d7:	e8 5c 03 00 00       	call   800738 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	f3 0f 1e fb          	endbr32 
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003f1:	8b 10                	mov    (%eax),%edx
  8003f3:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f9:	0f 85 a3 00 00 00    	jne    8004a2 <pgfault+0xbe>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003ff:	8b 50 08             	mov    0x8(%eax),%edx
  800402:	89 15 40 50 80 00    	mov    %edx,0x805040
  800408:	8b 50 0c             	mov    0xc(%eax),%edx
  80040b:	89 15 44 50 80 00    	mov    %edx,0x805044
  800411:	8b 50 10             	mov    0x10(%eax),%edx
  800414:	89 15 48 50 80 00    	mov    %edx,0x805048
  80041a:	8b 50 14             	mov    0x14(%eax),%edx
  80041d:	89 15 4c 50 80 00    	mov    %edx,0x80504c
  800423:	8b 50 18             	mov    0x18(%eax),%edx
  800426:	89 15 50 50 80 00    	mov    %edx,0x805050
  80042c:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042f:	89 15 54 50 80 00    	mov    %edx,0x805054
  800435:	8b 50 20             	mov    0x20(%eax),%edx
  800438:	89 15 58 50 80 00    	mov    %edx,0x805058
  80043e:	8b 50 24             	mov    0x24(%eax),%edx
  800441:	89 15 5c 50 80 00    	mov    %edx,0x80505c
	during.eip = utf->utf_eip;
  800447:	8b 50 28             	mov    0x28(%eax),%edx
  80044a:	89 15 60 50 80 00    	mov    %edx,0x805060
	during.eflags = utf->utf_eflags & ~FL_RF;
  800450:	8b 50 2c             	mov    0x2c(%eax),%edx
  800453:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800459:	89 15 64 50 80 00    	mov    %edx,0x805064
	during.esp = utf->utf_esp;
  80045f:	8b 40 30             	mov    0x30(%eax),%eax
  800462:	a3 68 50 80 00       	mov    %eax,0x805068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	68 1f 2b 80 00       	push   $0x802b1f
  80046f:	68 2d 2b 80 00       	push   $0x802b2d
  800474:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800479:	ba 18 2b 80 00       	mov    $0x802b18,%edx
  80047e:	b8 80 50 80 00       	mov    $0x805080,%eax
  800483:	e8 ab fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800488:	83 c4 0c             	add    $0xc,%esp
  80048b:	6a 07                	push   $0x7
  80048d:	68 00 00 40 00       	push   $0x400000
  800492:	6a 00                	push   $0x0
  800494:	e8 eb 0c 00 00       	call   801184 <sys_page_alloc>
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	85 c0                	test   %eax,%eax
  80049e:	78 1a                	js     8004ba <pgfault+0xd6>
		panic("sys_page_alloc: %e", r);
}
  8004a0:	c9                   	leave  
  8004a1:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8004a2:	83 ec 0c             	sub    $0xc,%esp
  8004a5:	ff 70 28             	pushl  0x28(%eax)
  8004a8:	52                   	push   %edx
  8004a9:	68 60 2b 80 00       	push   $0x802b60
  8004ae:	6a 50                	push   $0x50
  8004b0:	68 07 2b 80 00       	push   $0x802b07
  8004b5:	e8 97 01 00 00       	call   800651 <_panic>
		panic("sys_page_alloc: %e", r);
  8004ba:	50                   	push   %eax
  8004bb:	68 34 2b 80 00       	push   $0x802b34
  8004c0:	6a 5c                	push   $0x5c
  8004c2:	68 07 2b 80 00       	push   $0x802b07
  8004c7:	e8 85 01 00 00       	call   800651 <_panic>

008004cc <umain>:

void
umain(int argc, char **argv)
{
  8004cc:	f3 0f 1e fb          	endbr32 
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004d6:	68 e4 03 80 00       	push   $0x8003e4
  8004db:	e8 64 0f 00 00       	call   801444 <set_pgfault_handler>

	asm volatile(
  8004e0:	50                   	push   %eax
  8004e1:	9c                   	pushf  
  8004e2:	58                   	pop    %eax
  8004e3:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e8:	50                   	push   %eax
  8004e9:	9d                   	popf   
  8004ea:	a3 a4 50 80 00       	mov    %eax,0x8050a4
  8004ef:	8d 05 2a 05 80 00    	lea    0x80052a,%eax
  8004f5:	a3 a0 50 80 00       	mov    %eax,0x8050a0
  8004fa:	58                   	pop    %eax
  8004fb:	89 3d 80 50 80 00    	mov    %edi,0x805080
  800501:	89 35 84 50 80 00    	mov    %esi,0x805084
  800507:	89 2d 88 50 80 00    	mov    %ebp,0x805088
  80050d:	89 1d 90 50 80 00    	mov    %ebx,0x805090
  800513:	89 15 94 50 80 00    	mov    %edx,0x805094
  800519:	89 0d 98 50 80 00    	mov    %ecx,0x805098
  80051f:	a3 9c 50 80 00       	mov    %eax,0x80509c
  800524:	89 25 a8 50 80 00    	mov    %esp,0x8050a8
  80052a:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800531:	00 00 00 
  800534:	89 3d 00 50 80 00    	mov    %edi,0x805000
  80053a:	89 35 04 50 80 00    	mov    %esi,0x805004
  800540:	89 2d 08 50 80 00    	mov    %ebp,0x805008
  800546:	89 1d 10 50 80 00    	mov    %ebx,0x805010
  80054c:	89 15 14 50 80 00    	mov    %edx,0x805014
  800552:	89 0d 18 50 80 00    	mov    %ecx,0x805018
  800558:	a3 1c 50 80 00       	mov    %eax,0x80501c
  80055d:	89 25 28 50 80 00    	mov    %esp,0x805028
  800563:	8b 3d 80 50 80 00    	mov    0x805080,%edi
  800569:	8b 35 84 50 80 00    	mov    0x805084,%esi
  80056f:	8b 2d 88 50 80 00    	mov    0x805088,%ebp
  800575:	8b 1d 90 50 80 00    	mov    0x805090,%ebx
  80057b:	8b 15 94 50 80 00    	mov    0x805094,%edx
  800581:	8b 0d 98 50 80 00    	mov    0x805098,%ecx
  800587:	a1 9c 50 80 00       	mov    0x80509c,%eax
  80058c:	8b 25 a8 50 80 00    	mov    0x8050a8,%esp
  800592:	50                   	push   %eax
  800593:	9c                   	pushf  
  800594:	58                   	pop    %eax
  800595:	a3 24 50 80 00       	mov    %eax,0x805024
  80059a:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  8005a5:	75 30                	jne    8005d7 <umain+0x10b>
		cprintf("EIP after page-fault MISMATCH\n");
	after.eip = before.eip;
  8005a7:	a1 a0 50 80 00       	mov    0x8050a0,%eax
  8005ac:	a3 20 50 80 00       	mov    %eax,0x805020

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	68 47 2b 80 00       	push   $0x802b47
  8005b9:	68 58 2b 80 00       	push   $0x802b58
  8005be:	b9 00 50 80 00       	mov    $0x805000,%ecx
  8005c3:	ba 18 2b 80 00       	mov    $0x802b18,%edx
  8005c8:	b8 80 50 80 00       	mov    $0x805080,%eax
  8005cd:	e8 61 fa ff ff       	call   800033 <check_regs>
}
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	c9                   	leave  
  8005d6:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005d7:	83 ec 0c             	sub    $0xc,%esp
  8005da:	68 94 2b 80 00       	push   $0x802b94
  8005df:	e8 54 01 00 00       	call   800738 <cprintf>
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	eb be                	jmp    8005a7 <umain+0xdb>

008005e9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005e9:	f3 0f 1e fb          	endbr32 
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	56                   	push   %esi
  8005f1:	53                   	push   %ebx
  8005f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005f5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005f8:	e8 41 0b 00 00       	call   80113e <sys_getenvid>
  8005fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  800602:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800605:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060a:	a3 b4 50 80 00       	mov    %eax,0x8050b4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80060f:	85 db                	test   %ebx,%ebx
  800611:	7e 07                	jle    80061a <libmain+0x31>
		binaryname = argv[0];
  800613:	8b 06                	mov    (%esi),%eax
  800615:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	56                   	push   %esi
  80061e:	53                   	push   %ebx
  80061f:	e8 a8 fe ff ff       	call   8004cc <umain>

	// exit gracefully
	exit();
  800624:	e8 0a 00 00 00       	call   800633 <exit>
}
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80062f:	5b                   	pop    %ebx
  800630:	5e                   	pop    %esi
  800631:	5d                   	pop    %ebp
  800632:	c3                   	ret    

00800633 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800633:	f3 0f 1e fb          	endbr32 
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80063d:	e8 8f 10 00 00       	call   8016d1 <close_all>
	sys_env_destroy(0);
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	6a 00                	push   $0x0
  800647:	e8 ad 0a 00 00       	call   8010f9 <sys_env_destroy>
}
  80064c:	83 c4 10             	add    $0x10,%esp
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800651:	f3 0f 1e fb          	endbr32 
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	56                   	push   %esi
  800659:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80065a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80065d:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800663:	e8 d6 0a 00 00       	call   80113e <sys_getenvid>
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	ff 75 08             	pushl  0x8(%ebp)
  800671:	56                   	push   %esi
  800672:	50                   	push   %eax
  800673:	68 c0 2b 80 00       	push   $0x802bc0
  800678:	e8 bb 00 00 00       	call   800738 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80067d:	83 c4 18             	add    $0x18,%esp
  800680:	53                   	push   %ebx
  800681:	ff 75 10             	pushl  0x10(%ebp)
  800684:	e8 5a 00 00 00       	call   8006e3 <vcprintf>
	cprintf("\n");
  800689:	c7 04 24 d0 2a 80 00 	movl   $0x802ad0,(%esp)
  800690:	e8 a3 00 00 00       	call   800738 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800698:	cc                   	int3   
  800699:	eb fd                	jmp    800698 <_panic+0x47>

0080069b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80069b:	f3 0f 1e fb          	endbr32 
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	53                   	push   %ebx
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006a9:	8b 13                	mov    (%ebx),%edx
  8006ab:	8d 42 01             	lea    0x1(%edx),%eax
  8006ae:	89 03                	mov    %eax,(%ebx)
  8006b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006b3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8006b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006bc:	74 09                	je     8006c7 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006be:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c5:	c9                   	leave  
  8006c6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	68 ff 00 00 00       	push   $0xff
  8006cf:	8d 43 08             	lea    0x8(%ebx),%eax
  8006d2:	50                   	push   %eax
  8006d3:	e8 dc 09 00 00       	call   8010b4 <sys_cputs>
		b->idx = 0;
  8006d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	eb db                	jmp    8006be <putch+0x23>

008006e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006e3:	f3 0f 1e fb          	endbr32 
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f7:	00 00 00 
	b.cnt = 0;
  8006fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800701:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	ff 75 08             	pushl  0x8(%ebp)
  80070a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	68 9b 06 80 00       	push   $0x80069b
  800716:	e8 20 01 00 00       	call   80083b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80071b:	83 c4 08             	add    $0x8,%esp
  80071e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800724:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80072a:	50                   	push   %eax
  80072b:	e8 84 09 00 00       	call   8010b4 <sys_cputs>

	return b.cnt;
}
  800730:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800736:	c9                   	leave  
  800737:	c3                   	ret    

00800738 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800738:	f3 0f 1e fb          	endbr32 
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800742:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800745:	50                   	push   %eax
  800746:	ff 75 08             	pushl  0x8(%ebp)
  800749:	e8 95 ff ff ff       	call   8006e3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

00800750 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	57                   	push   %edi
  800754:	56                   	push   %esi
  800755:	53                   	push   %ebx
  800756:	83 ec 1c             	sub    $0x1c,%esp
  800759:	89 c7                	mov    %eax,%edi
  80075b:	89 d6                	mov    %edx,%esi
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 55 0c             	mov    0xc(%ebp),%edx
  800763:	89 d1                	mov    %edx,%ecx
  800765:	89 c2                	mov    %eax,%edx
  800767:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800773:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800776:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800782:	72 3e                	jb     8007c2 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800784:	83 ec 0c             	sub    $0xc,%esp
  800787:	ff 75 18             	pushl  0x18(%ebp)
  80078a:	83 eb 01             	sub    $0x1,%ebx
  80078d:	53                   	push   %ebx
  80078e:	50                   	push   %eax
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 e4             	pushl  -0x1c(%ebp)
  800795:	ff 75 e0             	pushl  -0x20(%ebp)
  800798:	ff 75 dc             	pushl  -0x24(%ebp)
  80079b:	ff 75 d8             	pushl  -0x28(%ebp)
  80079e:	e8 9d 20 00 00       	call   802840 <__udivdi3>
  8007a3:	83 c4 18             	add    $0x18,%esp
  8007a6:	52                   	push   %edx
  8007a7:	50                   	push   %eax
  8007a8:	89 f2                	mov    %esi,%edx
  8007aa:	89 f8                	mov    %edi,%eax
  8007ac:	e8 9f ff ff ff       	call   800750 <printnum>
  8007b1:	83 c4 20             	add    $0x20,%esp
  8007b4:	eb 13                	jmp    8007c9 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	56                   	push   %esi
  8007ba:	ff 75 18             	pushl  0x18(%ebp)
  8007bd:	ff d7                	call   *%edi
  8007bf:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8007c2:	83 eb 01             	sub    $0x1,%ebx
  8007c5:	85 db                	test   %ebx,%ebx
  8007c7:	7f ed                	jg     8007b6 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	56                   	push   %esi
  8007cd:	83 ec 04             	sub    $0x4,%esp
  8007d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8007d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8007dc:	e8 6f 21 00 00       	call   802950 <__umoddi3>
  8007e1:	83 c4 14             	add    $0x14,%esp
  8007e4:	0f be 80 e3 2b 80 00 	movsbl 0x802be3(%eax),%eax
  8007eb:	50                   	push   %eax
  8007ec:	ff d7                	call   *%edi
}
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f4:	5b                   	pop    %ebx
  8007f5:	5e                   	pop    %esi
  8007f6:	5f                   	pop    %edi
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007f9:	f3 0f 1e fb          	endbr32 
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800803:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800807:	8b 10                	mov    (%eax),%edx
  800809:	3b 50 04             	cmp    0x4(%eax),%edx
  80080c:	73 0a                	jae    800818 <sprintputch+0x1f>
		*b->buf++ = ch;
  80080e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800811:	89 08                	mov    %ecx,(%eax)
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	88 02                	mov    %al,(%edx)
}
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <printfmt>:
{
  80081a:	f3 0f 1e fb          	endbr32 
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800827:	50                   	push   %eax
  800828:	ff 75 10             	pushl  0x10(%ebp)
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	ff 75 08             	pushl  0x8(%ebp)
  800831:	e8 05 00 00 00       	call   80083b <vprintfmt>
}
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	c9                   	leave  
  80083a:	c3                   	ret    

0080083b <vprintfmt>:
{
  80083b:	f3 0f 1e fb          	endbr32 
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	57                   	push   %edi
  800843:	56                   	push   %esi
  800844:	53                   	push   %ebx
  800845:	83 ec 3c             	sub    $0x3c,%esp
  800848:	8b 75 08             	mov    0x8(%ebp),%esi
  80084b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80084e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800851:	e9 8e 03 00 00       	jmp    800be4 <vprintfmt+0x3a9>
		padc = ' ';
  800856:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80085a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800861:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800868:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80086f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800874:	8d 47 01             	lea    0x1(%edi),%eax
  800877:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80087a:	0f b6 17             	movzbl (%edi),%edx
  80087d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800880:	3c 55                	cmp    $0x55,%al
  800882:	0f 87 df 03 00 00    	ja     800c67 <vprintfmt+0x42c>
  800888:	0f b6 c0             	movzbl %al,%eax
  80088b:	3e ff 24 85 20 2d 80 	notrack jmp *0x802d20(,%eax,4)
  800892:	00 
  800893:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800896:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80089a:	eb d8                	jmp    800874 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80089c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80089f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8008a3:	eb cf                	jmp    800874 <vprintfmt+0x39>
  8008a5:	0f b6 d2             	movzbl %dl,%edx
  8008a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8008ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8008b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8008ba:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8008bd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8008c0:	83 f9 09             	cmp    $0x9,%ecx
  8008c3:	77 55                	ja     80091a <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8008c5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8008c8:	eb e9                	jmp    8008b3 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8d 40 04             	lea    0x4(%eax),%eax
  8008d8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008e2:	79 90                	jns    800874 <vprintfmt+0x39>
				width = precision, precision = -1;
  8008e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008ea:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8008f1:	eb 81                	jmp    800874 <vprintfmt+0x39>
  8008f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f6:	85 c0                	test   %eax,%eax
  8008f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fd:	0f 49 d0             	cmovns %eax,%edx
  800900:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800903:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800906:	e9 69 ff ff ff       	jmp    800874 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80090b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80090e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800915:	e9 5a ff ff ff       	jmp    800874 <vprintfmt+0x39>
  80091a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80091d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800920:	eb bc                	jmp    8008de <vprintfmt+0xa3>
			lflag++;
  800922:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800925:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800928:	e9 47 ff ff ff       	jmp    800874 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8d 78 04             	lea    0x4(%eax),%edi
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	53                   	push   %ebx
  800937:	ff 30                	pushl  (%eax)
  800939:	ff d6                	call   *%esi
			break;
  80093b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80093e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800941:	e9 9b 02 00 00       	jmp    800be1 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	8d 78 04             	lea    0x4(%eax),%edi
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	99                   	cltd   
  80094f:	31 d0                	xor    %edx,%eax
  800951:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800953:	83 f8 0f             	cmp    $0xf,%eax
  800956:	7f 23                	jg     80097b <vprintfmt+0x140>
  800958:	8b 14 85 80 2e 80 00 	mov    0x802e80(,%eax,4),%edx
  80095f:	85 d2                	test   %edx,%edx
  800961:	74 18                	je     80097b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800963:	52                   	push   %edx
  800964:	68 29 30 80 00       	push   $0x803029
  800969:	53                   	push   %ebx
  80096a:	56                   	push   %esi
  80096b:	e8 aa fe ff ff       	call   80081a <printfmt>
  800970:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800973:	89 7d 14             	mov    %edi,0x14(%ebp)
  800976:	e9 66 02 00 00       	jmp    800be1 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80097b:	50                   	push   %eax
  80097c:	68 fb 2b 80 00       	push   $0x802bfb
  800981:	53                   	push   %ebx
  800982:	56                   	push   %esi
  800983:	e8 92 fe ff ff       	call   80081a <printfmt>
  800988:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80098b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80098e:	e9 4e 02 00 00       	jmp    800be1 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	83 c0 04             	add    $0x4,%eax
  800999:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8009a1:	85 d2                	test   %edx,%edx
  8009a3:	b8 f4 2b 80 00       	mov    $0x802bf4,%eax
  8009a8:	0f 45 c2             	cmovne %edx,%eax
  8009ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8009ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b2:	7e 06                	jle    8009ba <vprintfmt+0x17f>
  8009b4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8009b8:	75 0d                	jne    8009c7 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009bd:	89 c7                	mov    %eax,%edi
  8009bf:	03 45 e0             	add    -0x20(%ebp),%eax
  8009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009c5:	eb 55                	jmp    800a1c <vprintfmt+0x1e1>
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8009cd:	ff 75 cc             	pushl  -0x34(%ebp)
  8009d0:	e8 46 03 00 00       	call   800d1b <strnlen>
  8009d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d8:	29 c2                	sub    %eax,%edx
  8009da:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8009e2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e9:	85 ff                	test   %edi,%edi
  8009eb:	7e 11                	jle    8009fe <vprintfmt+0x1c3>
					putch(padc, putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	53                   	push   %ebx
  8009f1:	ff 75 e0             	pushl  -0x20(%ebp)
  8009f4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f6:	83 ef 01             	sub    $0x1,%edi
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	eb eb                	jmp    8009e9 <vprintfmt+0x1ae>
  8009fe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a01:	85 d2                	test   %edx,%edx
  800a03:	b8 00 00 00 00       	mov    $0x0,%eax
  800a08:	0f 49 c2             	cmovns %edx,%eax
  800a0b:	29 c2                	sub    %eax,%edx
  800a0d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800a10:	eb a8                	jmp    8009ba <vprintfmt+0x17f>
					putch(ch, putdat);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	53                   	push   %ebx
  800a16:	52                   	push   %edx
  800a17:	ff d6                	call   *%esi
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a1f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a21:	83 c7 01             	add    $0x1,%edi
  800a24:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a28:	0f be d0             	movsbl %al,%edx
  800a2b:	85 d2                	test   %edx,%edx
  800a2d:	74 4b                	je     800a7a <vprintfmt+0x23f>
  800a2f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a33:	78 06                	js     800a3b <vprintfmt+0x200>
  800a35:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800a39:	78 1e                	js     800a59 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800a3b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a3f:	74 d1                	je     800a12 <vprintfmt+0x1d7>
  800a41:	0f be c0             	movsbl %al,%eax
  800a44:	83 e8 20             	sub    $0x20,%eax
  800a47:	83 f8 5e             	cmp    $0x5e,%eax
  800a4a:	76 c6                	jbe    800a12 <vprintfmt+0x1d7>
					putch('?', putdat);
  800a4c:	83 ec 08             	sub    $0x8,%esp
  800a4f:	53                   	push   %ebx
  800a50:	6a 3f                	push   $0x3f
  800a52:	ff d6                	call   *%esi
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	eb c3                	jmp    800a1c <vprintfmt+0x1e1>
  800a59:	89 cf                	mov    %ecx,%edi
  800a5b:	eb 0e                	jmp    800a6b <vprintfmt+0x230>
				putch(' ', putdat);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	53                   	push   %ebx
  800a61:	6a 20                	push   $0x20
  800a63:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a65:	83 ef 01             	sub    $0x1,%edi
  800a68:	83 c4 10             	add    $0x10,%esp
  800a6b:	85 ff                	test   %edi,%edi
  800a6d:	7f ee                	jg     800a5d <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800a6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
  800a75:	e9 67 01 00 00       	jmp    800be1 <vprintfmt+0x3a6>
  800a7a:	89 cf                	mov    %ecx,%edi
  800a7c:	eb ed                	jmp    800a6b <vprintfmt+0x230>
	if (lflag >= 2)
  800a7e:	83 f9 01             	cmp    $0x1,%ecx
  800a81:	7f 1b                	jg     800a9e <vprintfmt+0x263>
	else if (lflag)
  800a83:	85 c9                	test   %ecx,%ecx
  800a85:	74 63                	je     800aea <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8f:	99                   	cltd   
  800a90:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	8d 40 04             	lea    0x4(%eax),%eax
  800a99:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9c:	eb 17                	jmp    800ab5 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	8b 50 04             	mov    0x4(%eax),%edx
  800aa4:	8b 00                	mov    (%eax),%eax
  800aa6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	8d 40 08             	lea    0x8(%eax),%eax
  800ab2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800ab5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ab8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800abb:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800ac0:	85 c9                	test   %ecx,%ecx
  800ac2:	0f 89 ff 00 00 00    	jns    800bc7 <vprintfmt+0x38c>
				putch('-', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	53                   	push   %ebx
  800acc:	6a 2d                	push   $0x2d
  800ace:	ff d6                	call   *%esi
				num = -(long long) num;
  800ad0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ad3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ad6:	f7 da                	neg    %edx
  800ad8:	83 d1 00             	adc    $0x0,%ecx
  800adb:	f7 d9                	neg    %ecx
  800add:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ae0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae5:	e9 dd 00 00 00       	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	8b 00                	mov    (%eax),%eax
  800aef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af2:	99                   	cltd   
  800af3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	8d 40 04             	lea    0x4(%eax),%eax
  800afc:	89 45 14             	mov    %eax,0x14(%ebp)
  800aff:	eb b4                	jmp    800ab5 <vprintfmt+0x27a>
	if (lflag >= 2)
  800b01:	83 f9 01             	cmp    $0x1,%ecx
  800b04:	7f 1e                	jg     800b24 <vprintfmt+0x2e9>
	else if (lflag)
  800b06:	85 c9                	test   %ecx,%ecx
  800b08:	74 32                	je     800b3c <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0d:	8b 10                	mov    (%eax),%edx
  800b0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b14:	8d 40 04             	lea    0x4(%eax),%eax
  800b17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b1a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800b1f:	e9 a3 00 00 00       	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	8b 10                	mov    (%eax),%edx
  800b29:	8b 48 04             	mov    0x4(%eax),%ecx
  800b2c:	8d 40 08             	lea    0x8(%eax),%eax
  800b2f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b32:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800b37:	e9 8b 00 00 00       	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3f:	8b 10                	mov    (%eax),%edx
  800b41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b46:	8d 40 04             	lea    0x4(%eax),%eax
  800b49:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b4c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800b51:	eb 74                	jmp    800bc7 <vprintfmt+0x38c>
	if (lflag >= 2)
  800b53:	83 f9 01             	cmp    $0x1,%ecx
  800b56:	7f 1b                	jg     800b73 <vprintfmt+0x338>
	else if (lflag)
  800b58:	85 c9                	test   %ecx,%ecx
  800b5a:	74 2c                	je     800b88 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5f:	8b 10                	mov    (%eax),%edx
  800b61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b66:	8d 40 04             	lea    0x4(%eax),%eax
  800b69:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b6c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800b71:	eb 54                	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800b73:	8b 45 14             	mov    0x14(%ebp),%eax
  800b76:	8b 10                	mov    (%eax),%edx
  800b78:	8b 48 04             	mov    0x4(%eax),%ecx
  800b7b:	8d 40 08             	lea    0x8(%eax),%eax
  800b7e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b81:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800b86:	eb 3f                	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b88:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8b:	8b 10                	mov    (%eax),%edx
  800b8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b92:	8d 40 04             	lea    0x4(%eax),%eax
  800b95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b98:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800b9d:	eb 28                	jmp    800bc7 <vprintfmt+0x38c>
			putch('0', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	53                   	push   %ebx
  800ba3:	6a 30                	push   $0x30
  800ba5:	ff d6                	call   *%esi
			putch('x', putdat);
  800ba7:	83 c4 08             	add    $0x8,%esp
  800baa:	53                   	push   %ebx
  800bab:	6a 78                	push   $0x78
  800bad:	ff d6                	call   *%esi
			num = (unsigned long long)
  800baf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb2:	8b 10                	mov    (%eax),%edx
  800bb4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800bb9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bbc:	8d 40 04             	lea    0x4(%eax),%eax
  800bbf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bc2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bc7:	83 ec 0c             	sub    $0xc,%esp
  800bca:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800bce:	57                   	push   %edi
  800bcf:	ff 75 e0             	pushl  -0x20(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	51                   	push   %ecx
  800bd4:	52                   	push   %edx
  800bd5:	89 da                	mov    %ebx,%edx
  800bd7:	89 f0                	mov    %esi,%eax
  800bd9:	e8 72 fb ff ff       	call   800750 <printnum>
			break;
  800bde:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800be1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be4:	83 c7 01             	add    $0x1,%edi
  800be7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800beb:	83 f8 25             	cmp    $0x25,%eax
  800bee:	0f 84 62 fc ff ff    	je     800856 <vprintfmt+0x1b>
			if (ch == '\0')
  800bf4:	85 c0                	test   %eax,%eax
  800bf6:	0f 84 8b 00 00 00    	je     800c87 <vprintfmt+0x44c>
			putch(ch, putdat);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	53                   	push   %ebx
  800c00:	50                   	push   %eax
  800c01:	ff d6                	call   *%esi
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	eb dc                	jmp    800be4 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800c08:	83 f9 01             	cmp    $0x1,%ecx
  800c0b:	7f 1b                	jg     800c28 <vprintfmt+0x3ed>
	else if (lflag)
  800c0d:	85 c9                	test   %ecx,%ecx
  800c0f:	74 2c                	je     800c3d <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	8b 10                	mov    (%eax),%edx
  800c16:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c1b:	8d 40 04             	lea    0x4(%eax),%eax
  800c1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c21:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800c26:	eb 9f                	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800c28:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2b:	8b 10                	mov    (%eax),%edx
  800c2d:	8b 48 04             	mov    0x4(%eax),%ecx
  800c30:	8d 40 08             	lea    0x8(%eax),%eax
  800c33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c36:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800c3b:	eb 8a                	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800c3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c40:	8b 10                	mov    (%eax),%edx
  800c42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c47:	8d 40 04             	lea    0x4(%eax),%eax
  800c4a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c4d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800c52:	e9 70 ff ff ff       	jmp    800bc7 <vprintfmt+0x38c>
			putch(ch, putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	53                   	push   %ebx
  800c5b:	6a 25                	push   $0x25
  800c5d:	ff d6                	call   *%esi
			break;
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	e9 7a ff ff ff       	jmp    800be1 <vprintfmt+0x3a6>
			putch('%', putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	53                   	push   %ebx
  800c6b:	6a 25                	push   $0x25
  800c6d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 f8                	mov    %edi,%eax
  800c74:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c78:	74 05                	je     800c7f <vprintfmt+0x444>
  800c7a:	83 e8 01             	sub    $0x1,%eax
  800c7d:	eb f5                	jmp    800c74 <vprintfmt+0x439>
  800c7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c82:	e9 5a ff ff ff       	jmp    800be1 <vprintfmt+0x3a6>
}
  800c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5f                   	pop    %edi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c8f:	f3 0f 1e fb          	endbr32 
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 18             	sub    $0x18,%esp
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ca2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ca6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ca9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cb0:	85 c0                	test   %eax,%eax
  800cb2:	74 26                	je     800cda <vsnprintf+0x4b>
  800cb4:	85 d2                	test   %edx,%edx
  800cb6:	7e 22                	jle    800cda <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb8:	ff 75 14             	pushl  0x14(%ebp)
  800cbb:	ff 75 10             	pushl  0x10(%ebp)
  800cbe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc1:	50                   	push   %eax
  800cc2:	68 f9 07 80 00       	push   $0x8007f9
  800cc7:	e8 6f fb ff ff       	call   80083b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ccf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cd5:	83 c4 10             	add    $0x10,%esp
}
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    
		return -E_INVAL;
  800cda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cdf:	eb f7                	jmp    800cd8 <vsnprintf+0x49>

00800ce1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce1:	f3 0f 1e fb          	endbr32 
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ceb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cee:	50                   	push   %eax
  800cef:	ff 75 10             	pushl  0x10(%ebp)
  800cf2:	ff 75 0c             	pushl  0xc(%ebp)
  800cf5:	ff 75 08             	pushl  0x8(%ebp)
  800cf8:	e8 92 ff ff ff       	call   800c8f <vsnprintf>
	va_end(ap);

	return rc;
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cff:	f3 0f 1e fb          	endbr32 
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d12:	74 05                	je     800d19 <strlen+0x1a>
		n++;
  800d14:	83 c0 01             	add    $0x1,%eax
  800d17:	eb f5                	jmp    800d0e <strlen+0xf>
	return n;
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d1b:	f3 0f 1e fb          	endbr32 
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d25:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d28:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2d:	39 d0                	cmp    %edx,%eax
  800d2f:	74 0d                	je     800d3e <strnlen+0x23>
  800d31:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d35:	74 05                	je     800d3c <strnlen+0x21>
		n++;
  800d37:	83 c0 01             	add    $0x1,%eax
  800d3a:	eb f1                	jmp    800d2d <strnlen+0x12>
  800d3c:	89 c2                	mov    %eax,%edx
	return n;
}
  800d3e:	89 d0                	mov    %edx,%eax
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d42:	f3 0f 1e fb          	endbr32 
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	53                   	push   %ebx
  800d4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800d59:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800d5c:	83 c0 01             	add    $0x1,%eax
  800d5f:	84 d2                	test   %dl,%dl
  800d61:	75 f2                	jne    800d55 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800d63:	89 c8                	mov    %ecx,%eax
  800d65:	5b                   	pop    %ebx
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d68:	f3 0f 1e fb          	endbr32 
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	53                   	push   %ebx
  800d70:	83 ec 10             	sub    $0x10,%esp
  800d73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d76:	53                   	push   %ebx
  800d77:	e8 83 ff ff ff       	call   800cff <strlen>
  800d7c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	01 d8                	add    %ebx,%eax
  800d84:	50                   	push   %eax
  800d85:	e8 b8 ff ff ff       	call   800d42 <strcpy>
	return dst;
}
  800d8a:	89 d8                	mov    %ebx,%eax
  800d8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d91:	f3 0f 1e fb          	endbr32 
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
  800d9a:	8b 75 08             	mov    0x8(%ebp),%esi
  800d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da0:	89 f3                	mov    %esi,%ebx
  800da2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800da5:	89 f0                	mov    %esi,%eax
  800da7:	39 d8                	cmp    %ebx,%eax
  800da9:	74 11                	je     800dbc <strncpy+0x2b>
		*dst++ = *src;
  800dab:	83 c0 01             	add    $0x1,%eax
  800dae:	0f b6 0a             	movzbl (%edx),%ecx
  800db1:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800db4:	80 f9 01             	cmp    $0x1,%cl
  800db7:	83 da ff             	sbb    $0xffffffff,%edx
  800dba:	eb eb                	jmp    800da7 <strncpy+0x16>
	}
	return ret;
}
  800dbc:	89 f0                	mov    %esi,%eax
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800dc2:	f3 0f 1e fb          	endbr32 
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	8b 75 08             	mov    0x8(%ebp),%esi
  800dce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd1:	8b 55 10             	mov    0x10(%ebp),%edx
  800dd4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800dd6:	85 d2                	test   %edx,%edx
  800dd8:	74 21                	je     800dfb <strlcpy+0x39>
  800dda:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800dde:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800de0:	39 c2                	cmp    %eax,%edx
  800de2:	74 14                	je     800df8 <strlcpy+0x36>
  800de4:	0f b6 19             	movzbl (%ecx),%ebx
  800de7:	84 db                	test   %bl,%bl
  800de9:	74 0b                	je     800df6 <strlcpy+0x34>
			*dst++ = *src++;
  800deb:	83 c1 01             	add    $0x1,%ecx
  800dee:	83 c2 01             	add    $0x1,%edx
  800df1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800df4:	eb ea                	jmp    800de0 <strlcpy+0x1e>
  800df6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800df8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dfb:	29 f0                	sub    %esi,%eax
}
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e01:	f3 0f 1e fb          	endbr32 
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e0e:	0f b6 01             	movzbl (%ecx),%eax
  800e11:	84 c0                	test   %al,%al
  800e13:	74 0c                	je     800e21 <strcmp+0x20>
  800e15:	3a 02                	cmp    (%edx),%al
  800e17:	75 08                	jne    800e21 <strcmp+0x20>
		p++, q++;
  800e19:	83 c1 01             	add    $0x1,%ecx
  800e1c:	83 c2 01             	add    $0x1,%edx
  800e1f:	eb ed                	jmp    800e0e <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e21:	0f b6 c0             	movzbl %al,%eax
  800e24:	0f b6 12             	movzbl (%edx),%edx
  800e27:	29 d0                	sub    %edx,%eax
}
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    

00800e2b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e2b:	f3 0f 1e fb          	endbr32 
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	53                   	push   %ebx
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e39:	89 c3                	mov    %eax,%ebx
  800e3b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e3e:	eb 06                	jmp    800e46 <strncmp+0x1b>
		n--, p++, q++;
  800e40:	83 c0 01             	add    $0x1,%eax
  800e43:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e46:	39 d8                	cmp    %ebx,%eax
  800e48:	74 16                	je     800e60 <strncmp+0x35>
  800e4a:	0f b6 08             	movzbl (%eax),%ecx
  800e4d:	84 c9                	test   %cl,%cl
  800e4f:	74 04                	je     800e55 <strncmp+0x2a>
  800e51:	3a 0a                	cmp    (%edx),%cl
  800e53:	74 eb                	je     800e40 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e55:	0f b6 00             	movzbl (%eax),%eax
  800e58:	0f b6 12             	movzbl (%edx),%edx
  800e5b:	29 d0                	sub    %edx,%eax
}
  800e5d:	5b                   	pop    %ebx
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    
		return 0;
  800e60:	b8 00 00 00 00       	mov    $0x0,%eax
  800e65:	eb f6                	jmp    800e5d <strncmp+0x32>

00800e67 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e67:	f3 0f 1e fb          	endbr32 
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e75:	0f b6 10             	movzbl (%eax),%edx
  800e78:	84 d2                	test   %dl,%dl
  800e7a:	74 09                	je     800e85 <strchr+0x1e>
		if (*s == c)
  800e7c:	38 ca                	cmp    %cl,%dl
  800e7e:	74 0a                	je     800e8a <strchr+0x23>
	for (; *s; s++)
  800e80:	83 c0 01             	add    $0x1,%eax
  800e83:	eb f0                	jmp    800e75 <strchr+0xe>
			return (char *) s;
	return 0;
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e9a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e9d:	38 ca                	cmp    %cl,%dl
  800e9f:	74 09                	je     800eaa <strfind+0x1e>
  800ea1:	84 d2                	test   %dl,%dl
  800ea3:	74 05                	je     800eaa <strfind+0x1e>
	for (; *s; s++)
  800ea5:	83 c0 01             	add    $0x1,%eax
  800ea8:	eb f0                	jmp    800e9a <strfind+0xe>
			break;
	return (char *) s;
}
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800eac:	f3 0f 1e fb          	endbr32 
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	57                   	push   %edi
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	8b 7d 08             	mov    0x8(%ebp),%edi
  800eb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ebc:	85 c9                	test   %ecx,%ecx
  800ebe:	74 31                	je     800ef1 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ec0:	89 f8                	mov    %edi,%eax
  800ec2:	09 c8                	or     %ecx,%eax
  800ec4:	a8 03                	test   $0x3,%al
  800ec6:	75 23                	jne    800eeb <memset+0x3f>
		c &= 0xFF;
  800ec8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ecc:	89 d3                	mov    %edx,%ebx
  800ece:	c1 e3 08             	shl    $0x8,%ebx
  800ed1:	89 d0                	mov    %edx,%eax
  800ed3:	c1 e0 18             	shl    $0x18,%eax
  800ed6:	89 d6                	mov    %edx,%esi
  800ed8:	c1 e6 10             	shl    $0x10,%esi
  800edb:	09 f0                	or     %esi,%eax
  800edd:	09 c2                	or     %eax,%edx
  800edf:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ee1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ee4:	89 d0                	mov    %edx,%eax
  800ee6:	fc                   	cld    
  800ee7:	f3 ab                	rep stos %eax,%es:(%edi)
  800ee9:	eb 06                	jmp    800ef1 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	fc                   	cld    
  800eef:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ef1:	89 f8                	mov    %edi,%eax
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ef8:	f3 0f 1e fb          	endbr32 
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f07:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f0a:	39 c6                	cmp    %eax,%esi
  800f0c:	73 32                	jae    800f40 <memmove+0x48>
  800f0e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f11:	39 c2                	cmp    %eax,%edx
  800f13:	76 2b                	jbe    800f40 <memmove+0x48>
		s += n;
		d += n;
  800f15:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f18:	89 fe                	mov    %edi,%esi
  800f1a:	09 ce                	or     %ecx,%esi
  800f1c:	09 d6                	or     %edx,%esi
  800f1e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f24:	75 0e                	jne    800f34 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f26:	83 ef 04             	sub    $0x4,%edi
  800f29:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f2c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f2f:	fd                   	std    
  800f30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f32:	eb 09                	jmp    800f3d <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f34:	83 ef 01             	sub    $0x1,%edi
  800f37:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f3a:	fd                   	std    
  800f3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f3d:	fc                   	cld    
  800f3e:	eb 1a                	jmp    800f5a <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f40:	89 c2                	mov    %eax,%edx
  800f42:	09 ca                	or     %ecx,%edx
  800f44:	09 f2                	or     %esi,%edx
  800f46:	f6 c2 03             	test   $0x3,%dl
  800f49:	75 0a                	jne    800f55 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f4b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f4e:	89 c7                	mov    %eax,%edi
  800f50:	fc                   	cld    
  800f51:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f53:	eb 05                	jmp    800f5a <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800f55:	89 c7                	mov    %eax,%edi
  800f57:	fc                   	cld    
  800f58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f5e:	f3 0f 1e fb          	endbr32 
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f68:	ff 75 10             	pushl  0x10(%ebp)
  800f6b:	ff 75 0c             	pushl  0xc(%ebp)
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 82 ff ff ff       	call   800ef8 <memmove>
}
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f78:	f3 0f 1e fb          	endbr32 
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f87:	89 c6                	mov    %eax,%esi
  800f89:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f8c:	39 f0                	cmp    %esi,%eax
  800f8e:	74 1c                	je     800fac <memcmp+0x34>
		if (*s1 != *s2)
  800f90:	0f b6 08             	movzbl (%eax),%ecx
  800f93:	0f b6 1a             	movzbl (%edx),%ebx
  800f96:	38 d9                	cmp    %bl,%cl
  800f98:	75 08                	jne    800fa2 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f9a:	83 c0 01             	add    $0x1,%eax
  800f9d:	83 c2 01             	add    $0x1,%edx
  800fa0:	eb ea                	jmp    800f8c <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800fa2:	0f b6 c1             	movzbl %cl,%eax
  800fa5:	0f b6 db             	movzbl %bl,%ebx
  800fa8:	29 d8                	sub    %ebx,%eax
  800faa:	eb 05                	jmp    800fb1 <memcmp+0x39>
	}

	return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fb5:	f3 0f 1e fb          	endbr32 
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fc2:	89 c2                	mov    %eax,%edx
  800fc4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fc7:	39 d0                	cmp    %edx,%eax
  800fc9:	73 09                	jae    800fd4 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fcb:	38 08                	cmp    %cl,(%eax)
  800fcd:	74 05                	je     800fd4 <memfind+0x1f>
	for (; s < ends; s++)
  800fcf:	83 c0 01             	add    $0x1,%eax
  800fd2:	eb f3                	jmp    800fc7 <memfind+0x12>
			break;
	return (void *) s;
}
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd6:	f3 0f 1e fb          	endbr32 
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	57                   	push   %edi
  800fde:	56                   	push   %esi
  800fdf:	53                   	push   %ebx
  800fe0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe6:	eb 03                	jmp    800feb <strtol+0x15>
		s++;
  800fe8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800feb:	0f b6 01             	movzbl (%ecx),%eax
  800fee:	3c 20                	cmp    $0x20,%al
  800ff0:	74 f6                	je     800fe8 <strtol+0x12>
  800ff2:	3c 09                	cmp    $0x9,%al
  800ff4:	74 f2                	je     800fe8 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ff6:	3c 2b                	cmp    $0x2b,%al
  800ff8:	74 2a                	je     801024 <strtol+0x4e>
	int neg = 0;
  800ffa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fff:	3c 2d                	cmp    $0x2d,%al
  801001:	74 2b                	je     80102e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801003:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801009:	75 0f                	jne    80101a <strtol+0x44>
  80100b:	80 39 30             	cmpb   $0x30,(%ecx)
  80100e:	74 28                	je     801038 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801010:	85 db                	test   %ebx,%ebx
  801012:	b8 0a 00 00 00       	mov    $0xa,%eax
  801017:	0f 44 d8             	cmove  %eax,%ebx
  80101a:	b8 00 00 00 00       	mov    $0x0,%eax
  80101f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801022:	eb 46                	jmp    80106a <strtol+0x94>
		s++;
  801024:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801027:	bf 00 00 00 00       	mov    $0x0,%edi
  80102c:	eb d5                	jmp    801003 <strtol+0x2d>
		s++, neg = 1;
  80102e:	83 c1 01             	add    $0x1,%ecx
  801031:	bf 01 00 00 00       	mov    $0x1,%edi
  801036:	eb cb                	jmp    801003 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801038:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80103c:	74 0e                	je     80104c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80103e:	85 db                	test   %ebx,%ebx
  801040:	75 d8                	jne    80101a <strtol+0x44>
		s++, base = 8;
  801042:	83 c1 01             	add    $0x1,%ecx
  801045:	bb 08 00 00 00       	mov    $0x8,%ebx
  80104a:	eb ce                	jmp    80101a <strtol+0x44>
		s += 2, base = 16;
  80104c:	83 c1 02             	add    $0x2,%ecx
  80104f:	bb 10 00 00 00       	mov    $0x10,%ebx
  801054:	eb c4                	jmp    80101a <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801056:	0f be d2             	movsbl %dl,%edx
  801059:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80105c:	3b 55 10             	cmp    0x10(%ebp),%edx
  80105f:	7d 3a                	jge    80109b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801061:	83 c1 01             	add    $0x1,%ecx
  801064:	0f af 45 10          	imul   0x10(%ebp),%eax
  801068:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80106a:	0f b6 11             	movzbl (%ecx),%edx
  80106d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801070:	89 f3                	mov    %esi,%ebx
  801072:	80 fb 09             	cmp    $0x9,%bl
  801075:	76 df                	jbe    801056 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801077:	8d 72 9f             	lea    -0x61(%edx),%esi
  80107a:	89 f3                	mov    %esi,%ebx
  80107c:	80 fb 19             	cmp    $0x19,%bl
  80107f:	77 08                	ja     801089 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801081:	0f be d2             	movsbl %dl,%edx
  801084:	83 ea 57             	sub    $0x57,%edx
  801087:	eb d3                	jmp    80105c <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801089:	8d 72 bf             	lea    -0x41(%edx),%esi
  80108c:	89 f3                	mov    %esi,%ebx
  80108e:	80 fb 19             	cmp    $0x19,%bl
  801091:	77 08                	ja     80109b <strtol+0xc5>
			dig = *s - 'A' + 10;
  801093:	0f be d2             	movsbl %dl,%edx
  801096:	83 ea 37             	sub    $0x37,%edx
  801099:	eb c1                	jmp    80105c <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80109b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109f:	74 05                	je     8010a6 <strtol+0xd0>
		*endptr = (char *) s;
  8010a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010a4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010a6:	89 c2                	mov    %eax,%edx
  8010a8:	f7 da                	neg    %edx
  8010aa:	85 ff                	test   %edi,%edi
  8010ac:	0f 45 c2             	cmovne %edx,%eax
}
  8010af:	5b                   	pop    %ebx
  8010b0:	5e                   	pop    %esi
  8010b1:	5f                   	pop    %edi
  8010b2:	5d                   	pop    %ebp
  8010b3:	c3                   	ret    

008010b4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010b4:	f3 0f 1e fb          	endbr32 
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	57                   	push   %edi
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010be:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	89 c3                	mov    %eax,%ebx
  8010cb:	89 c7                	mov    %eax,%edi
  8010cd:	89 c6                	mov    %eax,%esi
  8010cf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010d6:	f3 0f 1e fb          	endbr32 
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8010ea:	89 d1                	mov    %edx,%ecx
  8010ec:	89 d3                	mov    %edx,%ebx
  8010ee:	89 d7                	mov    %edx,%edi
  8010f0:	89 d6                	mov    %edx,%esi
  8010f2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010f4:	5b                   	pop    %ebx
  8010f5:	5e                   	pop    %esi
  8010f6:	5f                   	pop    %edi
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    

008010f9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010f9:	f3 0f 1e fb          	endbr32 
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	57                   	push   %edi
  801101:	56                   	push   %esi
  801102:	53                   	push   %ebx
  801103:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801106:	b9 00 00 00 00       	mov    $0x0,%ecx
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	b8 03 00 00 00       	mov    $0x3,%eax
  801113:	89 cb                	mov    %ecx,%ebx
  801115:	89 cf                	mov    %ecx,%edi
  801117:	89 ce                	mov    %ecx,%esi
  801119:	cd 30                	int    $0x30
	if(check && ret > 0)
  80111b:	85 c0                	test   %eax,%eax
  80111d:	7f 08                	jg     801127 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80111f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801122:	5b                   	pop    %ebx
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801127:	83 ec 0c             	sub    $0xc,%esp
  80112a:	50                   	push   %eax
  80112b:	6a 03                	push   $0x3
  80112d:	68 df 2e 80 00       	push   $0x802edf
  801132:	6a 23                	push   $0x23
  801134:	68 fc 2e 80 00       	push   $0x802efc
  801139:	e8 13 f5 ff ff       	call   800651 <_panic>

0080113e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80113e:	f3 0f 1e fb          	endbr32 
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	57                   	push   %edi
  801146:	56                   	push   %esi
  801147:	53                   	push   %ebx
	asm volatile("int %1\n"
  801148:	ba 00 00 00 00       	mov    $0x0,%edx
  80114d:	b8 02 00 00 00       	mov    $0x2,%eax
  801152:	89 d1                	mov    %edx,%ecx
  801154:	89 d3                	mov    %edx,%ebx
  801156:	89 d7                	mov    %edx,%edi
  801158:	89 d6                	mov    %edx,%esi
  80115a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5f                   	pop    %edi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <sys_yield>:

void
sys_yield(void)
{
  801161:	f3 0f 1e fb          	endbr32 
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	57                   	push   %edi
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80116b:	ba 00 00 00 00       	mov    $0x0,%edx
  801170:	b8 0b 00 00 00       	mov    $0xb,%eax
  801175:	89 d1                	mov    %edx,%ecx
  801177:	89 d3                	mov    %edx,%ebx
  801179:	89 d7                	mov    %edx,%edi
  80117b:	89 d6                	mov    %edx,%esi
  80117d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80117f:	5b                   	pop    %ebx
  801180:	5e                   	pop    %esi
  801181:	5f                   	pop    %edi
  801182:	5d                   	pop    %ebp
  801183:	c3                   	ret    

00801184 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801184:	f3 0f 1e fb          	endbr32 
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	57                   	push   %edi
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
  80118e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801191:	be 00 00 00 00       	mov    $0x0,%esi
  801196:	8b 55 08             	mov    0x8(%ebp),%edx
  801199:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119c:	b8 04 00 00 00       	mov    $0x4,%eax
  8011a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011a4:	89 f7                	mov    %esi,%edi
  8011a6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	7f 08                	jg     8011b4 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011af:	5b                   	pop    %ebx
  8011b0:	5e                   	pop    %esi
  8011b1:	5f                   	pop    %edi
  8011b2:	5d                   	pop    %ebp
  8011b3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b4:	83 ec 0c             	sub    $0xc,%esp
  8011b7:	50                   	push   %eax
  8011b8:	6a 04                	push   $0x4
  8011ba:	68 df 2e 80 00       	push   $0x802edf
  8011bf:	6a 23                	push   $0x23
  8011c1:	68 fc 2e 80 00       	push   $0x802efc
  8011c6:	e8 86 f4 ff ff       	call   800651 <_panic>

008011cb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011cb:	f3 0f 1e fb          	endbr32 
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	57                   	push   %edi
  8011d3:	56                   	push   %esi
  8011d4:	53                   	push   %ebx
  8011d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011de:	b8 05 00 00 00       	mov    $0x5,%eax
  8011e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011e6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011e9:	8b 75 18             	mov    0x18(%ebp),%esi
  8011ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	7f 08                	jg     8011fa <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5f                   	pop    %edi
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	6a 05                	push   $0x5
  801200:	68 df 2e 80 00       	push   $0x802edf
  801205:	6a 23                	push   $0x23
  801207:	68 fc 2e 80 00       	push   $0x802efc
  80120c:	e8 40 f4 ff ff       	call   800651 <_panic>

00801211 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801211:	f3 0f 1e fb          	endbr32 
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	57                   	push   %edi
  801219:	56                   	push   %esi
  80121a:	53                   	push   %ebx
  80121b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80121e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801223:	8b 55 08             	mov    0x8(%ebp),%edx
  801226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801229:	b8 06 00 00 00       	mov    $0x6,%eax
  80122e:	89 df                	mov    %ebx,%edi
  801230:	89 de                	mov    %ebx,%esi
  801232:	cd 30                	int    $0x30
	if(check && ret > 0)
  801234:	85 c0                	test   %eax,%eax
  801236:	7f 08                	jg     801240 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123b:	5b                   	pop    %ebx
  80123c:	5e                   	pop    %esi
  80123d:	5f                   	pop    %edi
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	50                   	push   %eax
  801244:	6a 06                	push   $0x6
  801246:	68 df 2e 80 00       	push   $0x802edf
  80124b:	6a 23                	push   $0x23
  80124d:	68 fc 2e 80 00       	push   $0x802efc
  801252:	e8 fa f3 ff ff       	call   800651 <_panic>

00801257 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801257:	f3 0f 1e fb          	endbr32 
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	57                   	push   %edi
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801264:	bb 00 00 00 00       	mov    $0x0,%ebx
  801269:	8b 55 08             	mov    0x8(%ebp),%edx
  80126c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126f:	b8 08 00 00 00       	mov    $0x8,%eax
  801274:	89 df                	mov    %ebx,%edi
  801276:	89 de                	mov    %ebx,%esi
  801278:	cd 30                	int    $0x30
	if(check && ret > 0)
  80127a:	85 c0                	test   %eax,%eax
  80127c:	7f 08                	jg     801286 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80127e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801281:	5b                   	pop    %ebx
  801282:	5e                   	pop    %esi
  801283:	5f                   	pop    %edi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801286:	83 ec 0c             	sub    $0xc,%esp
  801289:	50                   	push   %eax
  80128a:	6a 08                	push   $0x8
  80128c:	68 df 2e 80 00       	push   $0x802edf
  801291:	6a 23                	push   $0x23
  801293:	68 fc 2e 80 00       	push   $0x802efc
  801298:	e8 b4 f3 ff ff       	call   800651 <_panic>

0080129d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80129d:	f3 0f 1e fb          	endbr32 
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	57                   	push   %edi
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012af:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b5:	b8 09 00 00 00       	mov    $0x9,%eax
  8012ba:	89 df                	mov    %ebx,%edi
  8012bc:	89 de                	mov    %ebx,%esi
  8012be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	7f 08                	jg     8012cc <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012cc:	83 ec 0c             	sub    $0xc,%esp
  8012cf:	50                   	push   %eax
  8012d0:	6a 09                	push   $0x9
  8012d2:	68 df 2e 80 00       	push   $0x802edf
  8012d7:	6a 23                	push   $0x23
  8012d9:	68 fc 2e 80 00       	push   $0x802efc
  8012de:	e8 6e f3 ff ff       	call   800651 <_panic>

008012e3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012e3:	f3 0f 1e fb          	endbr32 
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	57                   	push   %edi
  8012eb:	56                   	push   %esi
  8012ec:	53                   	push   %ebx
  8012ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  801300:	89 df                	mov    %ebx,%edi
  801302:	89 de                	mov    %ebx,%esi
  801304:	cd 30                	int    $0x30
	if(check && ret > 0)
  801306:	85 c0                	test   %eax,%eax
  801308:	7f 08                	jg     801312 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130d:	5b                   	pop    %ebx
  80130e:	5e                   	pop    %esi
  80130f:	5f                   	pop    %edi
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	50                   	push   %eax
  801316:	6a 0a                	push   $0xa
  801318:	68 df 2e 80 00       	push   $0x802edf
  80131d:	6a 23                	push   $0x23
  80131f:	68 fc 2e 80 00       	push   $0x802efc
  801324:	e8 28 f3 ff ff       	call   800651 <_panic>

00801329 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801329:	f3 0f 1e fb          	endbr32 
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	57                   	push   %edi
  801331:	56                   	push   %esi
  801332:	53                   	push   %ebx
	asm volatile("int %1\n"
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801339:	b8 0c 00 00 00       	mov    $0xc,%eax
  80133e:	be 00 00 00 00       	mov    $0x0,%esi
  801343:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801346:	8b 7d 14             	mov    0x14(%ebp),%edi
  801349:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80134b:	5b                   	pop    %ebx
  80134c:	5e                   	pop    %esi
  80134d:	5f                   	pop    %edi
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    

00801350 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801350:	f3 0f 1e fb          	endbr32 
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	57                   	push   %edi
  801358:	56                   	push   %esi
  801359:	53                   	push   %ebx
  80135a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80135d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	b8 0d 00 00 00       	mov    $0xd,%eax
  80136a:	89 cb                	mov    %ecx,%ebx
  80136c:	89 cf                	mov    %ecx,%edi
  80136e:	89 ce                	mov    %ecx,%esi
  801370:	cd 30                	int    $0x30
	if(check && ret > 0)
  801372:	85 c0                	test   %eax,%eax
  801374:	7f 08                	jg     80137e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801376:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801379:	5b                   	pop    %ebx
  80137a:	5e                   	pop    %esi
  80137b:	5f                   	pop    %edi
  80137c:	5d                   	pop    %ebp
  80137d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	50                   	push   %eax
  801382:	6a 0d                	push   $0xd
  801384:	68 df 2e 80 00       	push   $0x802edf
  801389:	6a 23                	push   $0x23
  80138b:	68 fc 2e 80 00       	push   $0x802efc
  801390:	e8 bc f2 ff ff       	call   800651 <_panic>

00801395 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801395:	f3 0f 1e fb          	endbr32 
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	57                   	push   %edi
  80139d:	56                   	push   %esi
  80139e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80139f:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a4:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013a9:	89 d1                	mov    %edx,%ecx
  8013ab:	89 d3                	mov    %edx,%ebx
  8013ad:	89 d7                	mov    %edx,%edi
  8013af:	89 d6                	mov    %edx,%esi
  8013b1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013b3:	5b                   	pop    %ebx
  8013b4:	5e                   	pop    %esi
  8013b5:	5f                   	pop    %edi
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    

008013b8 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8013b8:	f3 0f 1e fb          	endbr32 
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	57                   	push   %edi
  8013c0:	56                   	push   %esi
  8013c1:	53                   	push   %ebx
  8013c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d0:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013d5:	89 df                	mov    %ebx,%edi
  8013d7:	89 de                	mov    %ebx,%esi
  8013d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	7f 08                	jg     8013e7 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e2:	5b                   	pop    %ebx
  8013e3:	5e                   	pop    %esi
  8013e4:	5f                   	pop    %edi
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e7:	83 ec 0c             	sub    $0xc,%esp
  8013ea:	50                   	push   %eax
  8013eb:	6a 0f                	push   $0xf
  8013ed:	68 df 2e 80 00       	push   $0x802edf
  8013f2:	6a 23                	push   $0x23
  8013f4:	68 fc 2e 80 00       	push   $0x802efc
  8013f9:	e8 53 f2 ff ff       	call   800651 <_panic>

008013fe <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8013fe:	f3 0f 1e fb          	endbr32 
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	57                   	push   %edi
  801406:	56                   	push   %esi
  801407:	53                   	push   %ebx
  801408:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80140b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801410:	8b 55 08             	mov    0x8(%ebp),%edx
  801413:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801416:	b8 10 00 00 00       	mov    $0x10,%eax
  80141b:	89 df                	mov    %ebx,%edi
  80141d:	89 de                	mov    %ebx,%esi
  80141f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801421:	85 c0                	test   %eax,%eax
  801423:	7f 08                	jg     80142d <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  801425:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801428:	5b                   	pop    %ebx
  801429:	5e                   	pop    %esi
  80142a:	5f                   	pop    %edi
  80142b:	5d                   	pop    %ebp
  80142c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80142d:	83 ec 0c             	sub    $0xc,%esp
  801430:	50                   	push   %eax
  801431:	6a 10                	push   $0x10
  801433:	68 df 2e 80 00       	push   $0x802edf
  801438:	6a 23                	push   $0x23
  80143a:	68 fc 2e 80 00       	push   $0x802efc
  80143f:	e8 0d f2 ff ff       	call   800651 <_panic>

00801444 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801444:	f3 0f 1e fb          	endbr32 
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80144e:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  801455:	74 0a                	je     801461 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	6a 07                	push   $0x7
  801466:	68 00 f0 bf ee       	push   $0xeebff000
  80146b:	6a 00                	push   $0x0
  80146d:	e8 12 fd ff ff       	call   801184 <sys_page_alloc>
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	85 c0                	test   %eax,%eax
  801477:	78 2a                	js     8014a3 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801479:	83 ec 08             	sub    $0x8,%esp
  80147c:	68 b7 14 80 00       	push   $0x8014b7
  801481:	6a 00                	push   $0x0
  801483:	e8 5b fe ff ff       	call   8012e3 <sys_env_set_pgfault_upcall>
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	79 c8                	jns    801457 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	68 38 2f 80 00       	push   $0x802f38
  801497:	6a 25                	push   $0x25
  801499:	68 70 2f 80 00       	push   $0x802f70
  80149e:	e8 ae f1 ff ff       	call   800651 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	68 0c 2f 80 00       	push   $0x802f0c
  8014ab:	6a 22                	push   $0x22
  8014ad:	68 70 2f 80 00       	push   $0x802f70
  8014b2:	e8 9a f1 ff ff       	call   800651 <_panic>

008014b7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014b7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014b8:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  8014bd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8014bf:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8014c2:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8014c6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8014ca:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8014cd:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8014cf:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8014d3:	83 c4 08             	add    $0x8,%esp
	popal
  8014d6:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8014d7:	83 c4 04             	add    $0x4,%esp
	popfl
  8014da:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8014db:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8014dc:	c3                   	ret    

008014dd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014dd:	f3 0f 1e fb          	endbr32 
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	05 00 00 00 30       	add    $0x30000000,%eax
  8014ec:	c1 e8 0c             	shr    $0xc,%eax
}
  8014ef:	5d                   	pop    %ebp
  8014f0:	c3                   	ret    

008014f1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014f1:	f3 0f 1e fb          	endbr32 
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801500:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801505:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80150a:	5d                   	pop    %ebp
  80150b:	c3                   	ret    

0080150c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80150c:	f3 0f 1e fb          	endbr32 
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801518:	89 c2                	mov    %eax,%edx
  80151a:	c1 ea 16             	shr    $0x16,%edx
  80151d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801524:	f6 c2 01             	test   $0x1,%dl
  801527:	74 2d                	je     801556 <fd_alloc+0x4a>
  801529:	89 c2                	mov    %eax,%edx
  80152b:	c1 ea 0c             	shr    $0xc,%edx
  80152e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801535:	f6 c2 01             	test   $0x1,%dl
  801538:	74 1c                	je     801556 <fd_alloc+0x4a>
  80153a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80153f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801544:	75 d2                	jne    801518 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80154f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801554:	eb 0a                	jmp    801560 <fd_alloc+0x54>
			*fd_store = fd;
  801556:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801559:	89 01                	mov    %eax,(%ecx)
			return 0;
  80155b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    

00801562 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801562:	f3 0f 1e fb          	endbr32 
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80156c:	83 f8 1f             	cmp    $0x1f,%eax
  80156f:	77 30                	ja     8015a1 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801571:	c1 e0 0c             	shl    $0xc,%eax
  801574:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801579:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80157f:	f6 c2 01             	test   $0x1,%dl
  801582:	74 24                	je     8015a8 <fd_lookup+0x46>
  801584:	89 c2                	mov    %eax,%edx
  801586:	c1 ea 0c             	shr    $0xc,%edx
  801589:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801590:	f6 c2 01             	test   $0x1,%dl
  801593:	74 1a                	je     8015af <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801595:	8b 55 0c             	mov    0xc(%ebp),%edx
  801598:	89 02                	mov    %eax,(%edx)
	return 0;
  80159a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159f:	5d                   	pop    %ebp
  8015a0:	c3                   	ret    
		return -E_INVAL;
  8015a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a6:	eb f7                	jmp    80159f <fd_lookup+0x3d>
		return -E_INVAL;
  8015a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ad:	eb f0                	jmp    80159f <fd_lookup+0x3d>
  8015af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b4:	eb e9                	jmp    80159f <fd_lookup+0x3d>

008015b6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015b6:	f3 0f 1e fb          	endbr32 
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c8:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015cd:	39 08                	cmp    %ecx,(%eax)
  8015cf:	74 38                	je     801609 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8015d1:	83 c2 01             	add    $0x1,%edx
  8015d4:	8b 04 95 fc 2f 80 00 	mov    0x802ffc(,%edx,4),%eax
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	75 ee                	jne    8015cd <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015df:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8015e4:	8b 40 48             	mov    0x48(%eax),%eax
  8015e7:	83 ec 04             	sub    $0x4,%esp
  8015ea:	51                   	push   %ecx
  8015eb:	50                   	push   %eax
  8015ec:	68 80 2f 80 00       	push   $0x802f80
  8015f1:	e8 42 f1 ff ff       	call   800738 <cprintf>
	*dev = 0;
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    
			*dev = devtab[i];
  801609:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80160c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
  801613:	eb f2                	jmp    801607 <dev_lookup+0x51>

00801615 <fd_close>:
{
  801615:	f3 0f 1e fb          	endbr32 
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	57                   	push   %edi
  80161d:	56                   	push   %esi
  80161e:	53                   	push   %ebx
  80161f:	83 ec 24             	sub    $0x24,%esp
  801622:	8b 75 08             	mov    0x8(%ebp),%esi
  801625:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801628:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80162b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80162c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801632:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801635:	50                   	push   %eax
  801636:	e8 27 ff ff ff       	call   801562 <fd_lookup>
  80163b:	89 c3                	mov    %eax,%ebx
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 05                	js     801649 <fd_close+0x34>
	    || fd != fd2)
  801644:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801647:	74 16                	je     80165f <fd_close+0x4a>
		return (must_exist ? r : 0);
  801649:	89 f8                	mov    %edi,%eax
  80164b:	84 c0                	test   %al,%al
  80164d:	b8 00 00 00 00       	mov    $0x0,%eax
  801652:	0f 44 d8             	cmove  %eax,%ebx
}
  801655:	89 d8                	mov    %ebx,%eax
  801657:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165a:	5b                   	pop    %ebx
  80165b:	5e                   	pop    %esi
  80165c:	5f                   	pop    %edi
  80165d:	5d                   	pop    %ebp
  80165e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801665:	50                   	push   %eax
  801666:	ff 36                	pushl  (%esi)
  801668:	e8 49 ff ff ff       	call   8015b6 <dev_lookup>
  80166d:	89 c3                	mov    %eax,%ebx
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 1a                	js     801690 <fd_close+0x7b>
		if (dev->dev_close)
  801676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801679:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80167c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801681:	85 c0                	test   %eax,%eax
  801683:	74 0b                	je     801690 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	56                   	push   %esi
  801689:	ff d0                	call   *%eax
  80168b:	89 c3                	mov    %eax,%ebx
  80168d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801690:	83 ec 08             	sub    $0x8,%esp
  801693:	56                   	push   %esi
  801694:	6a 00                	push   $0x0
  801696:	e8 76 fb ff ff       	call   801211 <sys_page_unmap>
	return r;
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	eb b5                	jmp    801655 <fd_close+0x40>

008016a0 <close>:

int
close(int fdnum)
{
  8016a0:	f3 0f 1e fb          	endbr32 
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ad:	50                   	push   %eax
  8016ae:	ff 75 08             	pushl  0x8(%ebp)
  8016b1:	e8 ac fe ff ff       	call   801562 <fd_lookup>
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	79 02                	jns    8016bf <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    
		return fd_close(fd, 1);
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	6a 01                	push   $0x1
  8016c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c7:	e8 49 ff ff ff       	call   801615 <fd_close>
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	eb ec                	jmp    8016bd <close+0x1d>

008016d1 <close_all>:

void
close_all(void)
{
  8016d1:	f3 0f 1e fb          	endbr32 
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	53                   	push   %ebx
  8016d9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016dc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	53                   	push   %ebx
  8016e5:	e8 b6 ff ff ff       	call   8016a0 <close>
	for (i = 0; i < MAXFD; i++)
  8016ea:	83 c3 01             	add    $0x1,%ebx
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	83 fb 20             	cmp    $0x20,%ebx
  8016f3:	75 ec                	jne    8016e1 <close_all+0x10>
}
  8016f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016fa:	f3 0f 1e fb          	endbr32 
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	57                   	push   %edi
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801707:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	e8 4f fe ff ff       	call   801562 <fd_lookup>
  801713:	89 c3                	mov    %eax,%ebx
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	0f 88 81 00 00 00    	js     8017a1 <dup+0xa7>
		return r;
	close(newfdnum);
  801720:	83 ec 0c             	sub    $0xc,%esp
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	e8 75 ff ff ff       	call   8016a0 <close>

	newfd = INDEX2FD(newfdnum);
  80172b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80172e:	c1 e6 0c             	shl    $0xc,%esi
  801731:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801737:	83 c4 04             	add    $0x4,%esp
  80173a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80173d:	e8 af fd ff ff       	call   8014f1 <fd2data>
  801742:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801744:	89 34 24             	mov    %esi,(%esp)
  801747:	e8 a5 fd ff ff       	call   8014f1 <fd2data>
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801751:	89 d8                	mov    %ebx,%eax
  801753:	c1 e8 16             	shr    $0x16,%eax
  801756:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80175d:	a8 01                	test   $0x1,%al
  80175f:	74 11                	je     801772 <dup+0x78>
  801761:	89 d8                	mov    %ebx,%eax
  801763:	c1 e8 0c             	shr    $0xc,%eax
  801766:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80176d:	f6 c2 01             	test   $0x1,%dl
  801770:	75 39                	jne    8017ab <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801772:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801775:	89 d0                	mov    %edx,%eax
  801777:	c1 e8 0c             	shr    $0xc,%eax
  80177a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801781:	83 ec 0c             	sub    $0xc,%esp
  801784:	25 07 0e 00 00       	and    $0xe07,%eax
  801789:	50                   	push   %eax
  80178a:	56                   	push   %esi
  80178b:	6a 00                	push   $0x0
  80178d:	52                   	push   %edx
  80178e:	6a 00                	push   $0x0
  801790:	e8 36 fa ff ff       	call   8011cb <sys_page_map>
  801795:	89 c3                	mov    %eax,%ebx
  801797:	83 c4 20             	add    $0x20,%esp
  80179a:	85 c0                	test   %eax,%eax
  80179c:	78 31                	js     8017cf <dup+0xd5>
		goto err;

	return newfdnum;
  80179e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017a1:	89 d8                	mov    %ebx,%eax
  8017a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5f                   	pop    %edi
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017ab:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	25 07 0e 00 00       	and    $0xe07,%eax
  8017ba:	50                   	push   %eax
  8017bb:	57                   	push   %edi
  8017bc:	6a 00                	push   $0x0
  8017be:	53                   	push   %ebx
  8017bf:	6a 00                	push   $0x0
  8017c1:	e8 05 fa ff ff       	call   8011cb <sys_page_map>
  8017c6:	89 c3                	mov    %eax,%ebx
  8017c8:	83 c4 20             	add    $0x20,%esp
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	79 a3                	jns    801772 <dup+0x78>
	sys_page_unmap(0, newfd);
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	56                   	push   %esi
  8017d3:	6a 00                	push   $0x0
  8017d5:	e8 37 fa ff ff       	call   801211 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017da:	83 c4 08             	add    $0x8,%esp
  8017dd:	57                   	push   %edi
  8017de:	6a 00                	push   $0x0
  8017e0:	e8 2c fa ff ff       	call   801211 <sys_page_unmap>
	return r;
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	eb b7                	jmp    8017a1 <dup+0xa7>

008017ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017ea:	f3 0f 1e fb          	endbr32 
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	53                   	push   %ebx
  8017f2:	83 ec 1c             	sub    $0x1c,%esp
  8017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017fb:	50                   	push   %eax
  8017fc:	53                   	push   %ebx
  8017fd:	e8 60 fd ff ff       	call   801562 <fd_lookup>
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	85 c0                	test   %eax,%eax
  801807:	78 3f                	js     801848 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180f:	50                   	push   %eax
  801810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801813:	ff 30                	pushl  (%eax)
  801815:	e8 9c fd ff ff       	call   8015b6 <dev_lookup>
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	85 c0                	test   %eax,%eax
  80181f:	78 27                	js     801848 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801821:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801824:	8b 42 08             	mov    0x8(%edx),%eax
  801827:	83 e0 03             	and    $0x3,%eax
  80182a:	83 f8 01             	cmp    $0x1,%eax
  80182d:	74 1e                	je     80184d <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80182f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801832:	8b 40 08             	mov    0x8(%eax),%eax
  801835:	85 c0                	test   %eax,%eax
  801837:	74 35                	je     80186e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801839:	83 ec 04             	sub    $0x4,%esp
  80183c:	ff 75 10             	pushl  0x10(%ebp)
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	52                   	push   %edx
  801843:	ff d0                	call   *%eax
  801845:	83 c4 10             	add    $0x10,%esp
}
  801848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80184d:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801852:	8b 40 48             	mov    0x48(%eax),%eax
  801855:	83 ec 04             	sub    $0x4,%esp
  801858:	53                   	push   %ebx
  801859:	50                   	push   %eax
  80185a:	68 c1 2f 80 00       	push   $0x802fc1
  80185f:	e8 d4 ee ff ff       	call   800738 <cprintf>
		return -E_INVAL;
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80186c:	eb da                	jmp    801848 <read+0x5e>
		return -E_NOT_SUPP;
  80186e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801873:	eb d3                	jmp    801848 <read+0x5e>

00801875 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801875:	f3 0f 1e fb          	endbr32 
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	57                   	push   %edi
  80187d:	56                   	push   %esi
  80187e:	53                   	push   %ebx
  80187f:	83 ec 0c             	sub    $0xc,%esp
  801882:	8b 7d 08             	mov    0x8(%ebp),%edi
  801885:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801888:	bb 00 00 00 00       	mov    $0x0,%ebx
  80188d:	eb 02                	jmp    801891 <readn+0x1c>
  80188f:	01 c3                	add    %eax,%ebx
  801891:	39 f3                	cmp    %esi,%ebx
  801893:	73 21                	jae    8018b6 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	89 f0                	mov    %esi,%eax
  80189a:	29 d8                	sub    %ebx,%eax
  80189c:	50                   	push   %eax
  80189d:	89 d8                	mov    %ebx,%eax
  80189f:	03 45 0c             	add    0xc(%ebp),%eax
  8018a2:	50                   	push   %eax
  8018a3:	57                   	push   %edi
  8018a4:	e8 41 ff ff ff       	call   8017ea <read>
		if (m < 0)
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 04                	js     8018b4 <readn+0x3f>
			return m;
		if (m == 0)
  8018b0:	75 dd                	jne    80188f <readn+0x1a>
  8018b2:	eb 02                	jmp    8018b6 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018b4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018b6:	89 d8                	mov    %ebx,%eax
  8018b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5f                   	pop    %edi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    

008018c0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018c0:	f3 0f 1e fb          	endbr32 
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 1c             	sub    $0x1c,%esp
  8018cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d1:	50                   	push   %eax
  8018d2:	53                   	push   %ebx
  8018d3:	e8 8a fc ff ff       	call   801562 <fd_lookup>
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 3a                	js     801919 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018df:	83 ec 08             	sub    $0x8,%esp
  8018e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e5:	50                   	push   %eax
  8018e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e9:	ff 30                	pushl  (%eax)
  8018eb:	e8 c6 fc ff ff       	call   8015b6 <dev_lookup>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 22                	js     801919 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018fe:	74 1e                	je     80191e <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801900:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801903:	8b 52 0c             	mov    0xc(%edx),%edx
  801906:	85 d2                	test   %edx,%edx
  801908:	74 35                	je     80193f <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	ff 75 10             	pushl  0x10(%ebp)
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	50                   	push   %eax
  801914:	ff d2                	call   *%edx
  801916:	83 c4 10             	add    $0x10,%esp
}
  801919:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80191e:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801923:	8b 40 48             	mov    0x48(%eax),%eax
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	53                   	push   %ebx
  80192a:	50                   	push   %eax
  80192b:	68 dd 2f 80 00       	push   $0x802fdd
  801930:	e8 03 ee ff ff       	call   800738 <cprintf>
		return -E_INVAL;
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80193d:	eb da                	jmp    801919 <write+0x59>
		return -E_NOT_SUPP;
  80193f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801944:	eb d3                	jmp    801919 <write+0x59>

00801946 <seek>:

int
seek(int fdnum, off_t offset)
{
  801946:	f3 0f 1e fb          	endbr32 
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801950:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801953:	50                   	push   %eax
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	e8 06 fc ff ff       	call   801562 <fd_lookup>
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 0e                	js     801971 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801963:	8b 55 0c             	mov    0xc(%ebp),%edx
  801966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801969:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80196c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801973:	f3 0f 1e fb          	endbr32 
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	53                   	push   %ebx
  80197b:	83 ec 1c             	sub    $0x1c,%esp
  80197e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801981:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801984:	50                   	push   %eax
  801985:	53                   	push   %ebx
  801986:	e8 d7 fb ff ff       	call   801562 <fd_lookup>
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	85 c0                	test   %eax,%eax
  801990:	78 37                	js     8019c9 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801992:	83 ec 08             	sub    $0x8,%esp
  801995:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801998:	50                   	push   %eax
  801999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199c:	ff 30                	pushl  (%eax)
  80199e:	e8 13 fc ff ff       	call   8015b6 <dev_lookup>
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	78 1f                	js     8019c9 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019b1:	74 1b                	je     8019ce <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b6:	8b 52 18             	mov    0x18(%edx),%edx
  8019b9:	85 d2                	test   %edx,%edx
  8019bb:	74 32                	je     8019ef <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019bd:	83 ec 08             	sub    $0x8,%esp
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	50                   	push   %eax
  8019c4:	ff d2                	call   *%edx
  8019c6:	83 c4 10             	add    $0x10,%esp
}
  8019c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019ce:	a1 b4 50 80 00       	mov    0x8050b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019d3:	8b 40 48             	mov    0x48(%eax),%eax
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	53                   	push   %ebx
  8019da:	50                   	push   %eax
  8019db:	68 a0 2f 80 00       	push   $0x802fa0
  8019e0:	e8 53 ed ff ff       	call   800738 <cprintf>
		return -E_INVAL;
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ed:	eb da                	jmp    8019c9 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8019ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f4:	eb d3                	jmp    8019c9 <ftruncate+0x56>

008019f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019f6:	f3 0f 1e fb          	endbr32 
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	53                   	push   %ebx
  8019fe:	83 ec 1c             	sub    $0x1c,%esp
  801a01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a04:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a07:	50                   	push   %eax
  801a08:	ff 75 08             	pushl  0x8(%ebp)
  801a0b:	e8 52 fb ff ff       	call   801562 <fd_lookup>
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 4b                	js     801a62 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a17:	83 ec 08             	sub    $0x8,%esp
  801a1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1d:	50                   	push   %eax
  801a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a21:	ff 30                	pushl  (%eax)
  801a23:	e8 8e fb ff ff       	call   8015b6 <dev_lookup>
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 33                	js     801a62 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a36:	74 2f                	je     801a67 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a38:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a3b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a42:	00 00 00 
	stat->st_isdir = 0;
  801a45:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a4c:	00 00 00 
	stat->st_dev = dev;
  801a4f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a55:	83 ec 08             	sub    $0x8,%esp
  801a58:	53                   	push   %ebx
  801a59:	ff 75 f0             	pushl  -0x10(%ebp)
  801a5c:	ff 50 14             	call   *0x14(%eax)
  801a5f:	83 c4 10             	add    $0x10,%esp
}
  801a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    
		return -E_NOT_SUPP;
  801a67:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a6c:	eb f4                	jmp    801a62 <fstat+0x6c>

00801a6e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a6e:	f3 0f 1e fb          	endbr32 
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	56                   	push   %esi
  801a76:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a77:	83 ec 08             	sub    $0x8,%esp
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	e8 fb 01 00 00       	call   801c7f <open>
  801a84:	89 c3                	mov    %eax,%ebx
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	85 c0                	test   %eax,%eax
  801a8b:	78 1b                	js     801aa8 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801a8d:	83 ec 08             	sub    $0x8,%esp
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	50                   	push   %eax
  801a94:	e8 5d ff ff ff       	call   8019f6 <fstat>
  801a99:	89 c6                	mov    %eax,%esi
	close(fd);
  801a9b:	89 1c 24             	mov    %ebx,(%esp)
  801a9e:	e8 fd fb ff ff       	call   8016a0 <close>
	return r;
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	89 f3                	mov    %esi,%ebx
}
  801aa8:	89 d8                	mov    %ebx,%eax
  801aaa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aad:	5b                   	pop    %ebx
  801aae:	5e                   	pop    %esi
  801aaf:	5d                   	pop    %ebp
  801ab0:	c3                   	ret    

00801ab1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	56                   	push   %esi
  801ab5:	53                   	push   %ebx
  801ab6:	89 c6                	mov    %eax,%esi
  801ab8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801aba:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801ac1:	74 27                	je     801aea <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ac3:	6a 07                	push   $0x7
  801ac5:	68 00 60 80 00       	push   $0x806000
  801aca:	56                   	push   %esi
  801acb:	ff 35 ac 50 80 00    	pushl  0x8050ac
  801ad1:	e8 8e 0c 00 00       	call   802764 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ad6:	83 c4 0c             	add    $0xc,%esp
  801ad9:	6a 00                	push   $0x0
  801adb:	53                   	push   %ebx
  801adc:	6a 00                	push   $0x0
  801ade:	e8 fc 0b 00 00       	call   8026df <ipc_recv>
}
  801ae3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5e                   	pop    %esi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801aea:	83 ec 0c             	sub    $0xc,%esp
  801aed:	6a 01                	push   $0x1
  801aef:	e8 c8 0c 00 00       	call   8027bc <ipc_find_env>
  801af4:	a3 ac 50 80 00       	mov    %eax,0x8050ac
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	eb c5                	jmp    801ac3 <fsipc+0x12>

00801afe <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801afe:	f3 0f 1e fb          	endbr32 
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b0e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b16:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b20:	b8 02 00 00 00       	mov    $0x2,%eax
  801b25:	e8 87 ff ff ff       	call   801ab1 <fsipc>
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <devfile_flush>:
{
  801b2c:	f3 0f 1e fb          	endbr32 
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b41:	ba 00 00 00 00       	mov    $0x0,%edx
  801b46:	b8 06 00 00 00       	mov    $0x6,%eax
  801b4b:	e8 61 ff ff ff       	call   801ab1 <fsipc>
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <devfile_stat>:
{
  801b52:	f3 0f 1e fb          	endbr32 
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	53                   	push   %ebx
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	8b 40 0c             	mov    0xc(%eax),%eax
  801b66:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b70:	b8 05 00 00 00       	mov    $0x5,%eax
  801b75:	e8 37 ff ff ff       	call   801ab1 <fsipc>
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 2c                	js     801baa <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	68 00 60 80 00       	push   $0x806000
  801b86:	53                   	push   %ebx
  801b87:	e8 b6 f1 ff ff       	call   800d42 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b8c:	a1 80 60 80 00       	mov    0x806080,%eax
  801b91:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b97:	a1 84 60 80 00       	mov    0x806084,%eax
  801b9c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <devfile_write>:
{
  801baf:	f3 0f 1e fb          	endbr32 
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 0c             	sub    $0xc,%esp
  801bb9:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bbc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbf:	8b 52 0c             	mov    0xc(%edx),%edx
  801bc2:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801bc8:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801bcd:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801bd2:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801bd5:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801bda:	50                   	push   %eax
  801bdb:	ff 75 0c             	pushl  0xc(%ebp)
  801bde:	68 08 60 80 00       	push   $0x806008
  801be3:	e8 10 f3 ff ff       	call   800ef8 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801be8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bed:	b8 04 00 00 00       	mov    $0x4,%eax
  801bf2:	e8 ba fe ff ff       	call   801ab1 <fsipc>
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <devfile_read>:
{
  801bf9:	f3 0f 1e fb          	endbr32 
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	56                   	push   %esi
  801c01:	53                   	push   %ebx
  801c02:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c10:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c16:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1b:	b8 03 00 00 00       	mov    $0x3,%eax
  801c20:	e8 8c fe ff ff       	call   801ab1 <fsipc>
  801c25:	89 c3                	mov    %eax,%ebx
  801c27:	85 c0                	test   %eax,%eax
  801c29:	78 1f                	js     801c4a <devfile_read+0x51>
	assert(r <= n);
  801c2b:	39 f0                	cmp    %esi,%eax
  801c2d:	77 24                	ja     801c53 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801c2f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c34:	7f 33                	jg     801c69 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c36:	83 ec 04             	sub    $0x4,%esp
  801c39:	50                   	push   %eax
  801c3a:	68 00 60 80 00       	push   $0x806000
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	e8 b1 f2 ff ff       	call   800ef8 <memmove>
	return r;
  801c47:	83 c4 10             	add    $0x10,%esp
}
  801c4a:	89 d8                	mov    %ebx,%eax
  801c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5d                   	pop    %ebp
  801c52:	c3                   	ret    
	assert(r <= n);
  801c53:	68 10 30 80 00       	push   $0x803010
  801c58:	68 17 30 80 00       	push   $0x803017
  801c5d:	6a 7c                	push   $0x7c
  801c5f:	68 2c 30 80 00       	push   $0x80302c
  801c64:	e8 e8 e9 ff ff       	call   800651 <_panic>
	assert(r <= PGSIZE);
  801c69:	68 37 30 80 00       	push   $0x803037
  801c6e:	68 17 30 80 00       	push   $0x803017
  801c73:	6a 7d                	push   $0x7d
  801c75:	68 2c 30 80 00       	push   $0x80302c
  801c7a:	e8 d2 e9 ff ff       	call   800651 <_panic>

00801c7f <open>:
{
  801c7f:	f3 0f 1e fb          	endbr32 
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	83 ec 1c             	sub    $0x1c,%esp
  801c8b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c8e:	56                   	push   %esi
  801c8f:	e8 6b f0 ff ff       	call   800cff <strlen>
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c9c:	7f 6c                	jg     801d0a <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801c9e:	83 ec 0c             	sub    $0xc,%esp
  801ca1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca4:	50                   	push   %eax
  801ca5:	e8 62 f8 ff ff       	call   80150c <fd_alloc>
  801caa:	89 c3                	mov    %eax,%ebx
  801cac:	83 c4 10             	add    $0x10,%esp
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	78 3c                	js     801cef <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801cb3:	83 ec 08             	sub    $0x8,%esp
  801cb6:	56                   	push   %esi
  801cb7:	68 00 60 80 00       	push   $0x806000
  801cbc:	e8 81 f0 ff ff       	call   800d42 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc4:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ccc:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd1:	e8 db fd ff ff       	call   801ab1 <fsipc>
  801cd6:	89 c3                	mov    %eax,%ebx
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	78 19                	js     801cf8 <open+0x79>
	return fd2num(fd);
  801cdf:	83 ec 0c             	sub    $0xc,%esp
  801ce2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce5:	e8 f3 f7 ff ff       	call   8014dd <fd2num>
  801cea:	89 c3                	mov    %eax,%ebx
  801cec:	83 c4 10             	add    $0x10,%esp
}
  801cef:	89 d8                	mov    %ebx,%eax
  801cf1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf4:	5b                   	pop    %ebx
  801cf5:	5e                   	pop    %esi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
		fd_close(fd, 0);
  801cf8:	83 ec 08             	sub    $0x8,%esp
  801cfb:	6a 00                	push   $0x0
  801cfd:	ff 75 f4             	pushl  -0xc(%ebp)
  801d00:	e8 10 f9 ff ff       	call   801615 <fd_close>
		return r;
  801d05:	83 c4 10             	add    $0x10,%esp
  801d08:	eb e5                	jmp    801cef <open+0x70>
		return -E_BAD_PATH;
  801d0a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d0f:	eb de                	jmp    801cef <open+0x70>

00801d11 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d11:	f3 0f 1e fb          	endbr32 
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d20:	b8 08 00 00 00       	mov    $0x8,%eax
  801d25:	e8 87 fd ff ff       	call   801ab1 <fsipc>
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d2c:	f3 0f 1e fb          	endbr32 
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d36:	68 43 30 80 00       	push   $0x803043
  801d3b:	ff 75 0c             	pushl  0xc(%ebp)
  801d3e:	e8 ff ef ff ff       	call   800d42 <strcpy>
	return 0;
}
  801d43:	b8 00 00 00 00       	mov    $0x0,%eax
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <devsock_close>:
{
  801d4a:	f3 0f 1e fb          	endbr32 
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	53                   	push   %ebx
  801d52:	83 ec 10             	sub    $0x10,%esp
  801d55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d58:	53                   	push   %ebx
  801d59:	e8 9b 0a 00 00       	call   8027f9 <pageref>
  801d5e:	89 c2                	mov    %eax,%edx
  801d60:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801d68:	83 fa 01             	cmp    $0x1,%edx
  801d6b:	74 05                	je     801d72 <devsock_close+0x28>
}
  801d6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d72:	83 ec 0c             	sub    $0xc,%esp
  801d75:	ff 73 0c             	pushl  0xc(%ebx)
  801d78:	e8 e3 02 00 00       	call   802060 <nsipc_close>
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	eb eb                	jmp    801d6d <devsock_close+0x23>

00801d82 <devsock_write>:
{
  801d82:	f3 0f 1e fb          	endbr32 
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	ff 75 10             	pushl  0x10(%ebp)
  801d91:	ff 75 0c             	pushl  0xc(%ebp)
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	ff 70 0c             	pushl  0xc(%eax)
  801d9a:	e8 b5 03 00 00       	call   802154 <nsipc_send>
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <devsock_read>:
{
  801da1:	f3 0f 1e fb          	endbr32 
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	ff 75 10             	pushl  0x10(%ebp)
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	ff 70 0c             	pushl  0xc(%eax)
  801db9:	e8 1f 03 00 00       	call   8020dd <nsipc_recv>
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <fd2sockid>:
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dc6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dc9:	52                   	push   %edx
  801dca:	50                   	push   %eax
  801dcb:	e8 92 f7 ff ff       	call   801562 <fd_lookup>
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	78 10                	js     801de7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801de0:	39 08                	cmp    %ecx,(%eax)
  801de2:	75 05                	jne    801de9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801de4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    
		return -E_NOT_SUPP;
  801de9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dee:	eb f7                	jmp    801de7 <fd2sockid+0x27>

00801df0 <alloc_sockfd>:
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	56                   	push   %esi
  801df4:	53                   	push   %ebx
  801df5:	83 ec 1c             	sub    $0x1c,%esp
  801df8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801dfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfd:	50                   	push   %eax
  801dfe:	e8 09 f7 ff ff       	call   80150c <fd_alloc>
  801e03:	89 c3                	mov    %eax,%ebx
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	78 43                	js     801e4f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e0c:	83 ec 04             	sub    $0x4,%esp
  801e0f:	68 07 04 00 00       	push   $0x407
  801e14:	ff 75 f4             	pushl  -0xc(%ebp)
  801e17:	6a 00                	push   $0x0
  801e19:	e8 66 f3 ff ff       	call   801184 <sys_page_alloc>
  801e1e:	89 c3                	mov    %eax,%ebx
  801e20:	83 c4 10             	add    $0x10,%esp
  801e23:	85 c0                	test   %eax,%eax
  801e25:	78 28                	js     801e4f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e30:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e3c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e3f:	83 ec 0c             	sub    $0xc,%esp
  801e42:	50                   	push   %eax
  801e43:	e8 95 f6 ff ff       	call   8014dd <fd2num>
  801e48:	89 c3                	mov    %eax,%ebx
  801e4a:	83 c4 10             	add    $0x10,%esp
  801e4d:	eb 0c                	jmp    801e5b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e4f:	83 ec 0c             	sub    $0xc,%esp
  801e52:	56                   	push   %esi
  801e53:	e8 08 02 00 00       	call   802060 <nsipc_close>
		return r;
  801e58:	83 c4 10             	add    $0x10,%esp
}
  801e5b:	89 d8                	mov    %ebx,%eax
  801e5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e60:	5b                   	pop    %ebx
  801e61:	5e                   	pop    %esi
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    

00801e64 <accept>:
{
  801e64:	f3 0f 1e fb          	endbr32 
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	e8 4a ff ff ff       	call   801dc0 <fd2sockid>
  801e76:	85 c0                	test   %eax,%eax
  801e78:	78 1b                	js     801e95 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	ff 75 10             	pushl  0x10(%ebp)
  801e80:	ff 75 0c             	pushl  0xc(%ebp)
  801e83:	50                   	push   %eax
  801e84:	e8 22 01 00 00       	call   801fab <nsipc_accept>
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	78 05                	js     801e95 <accept+0x31>
	return alloc_sockfd(r);
  801e90:	e8 5b ff ff ff       	call   801df0 <alloc_sockfd>
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <bind>:
{
  801e97:	f3 0f 1e fb          	endbr32 
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	e8 17 ff ff ff       	call   801dc0 <fd2sockid>
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 12                	js     801ebf <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801ead:	83 ec 04             	sub    $0x4,%esp
  801eb0:	ff 75 10             	pushl  0x10(%ebp)
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	50                   	push   %eax
  801eb7:	e8 45 01 00 00       	call   802001 <nsipc_bind>
  801ebc:	83 c4 10             	add    $0x10,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <shutdown>:
{
  801ec1:	f3 0f 1e fb          	endbr32 
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	e8 ed fe ff ff       	call   801dc0 <fd2sockid>
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	78 0f                	js     801ee6 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801ed7:	83 ec 08             	sub    $0x8,%esp
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	50                   	push   %eax
  801ede:	e8 57 01 00 00       	call   80203a <nsipc_shutdown>
  801ee3:	83 c4 10             	add    $0x10,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <connect>:
{
  801ee8:	f3 0f 1e fb          	endbr32 
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	e8 c6 fe ff ff       	call   801dc0 <fd2sockid>
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 12                	js     801f10 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	ff 75 10             	pushl  0x10(%ebp)
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	50                   	push   %eax
  801f08:	e8 71 01 00 00       	call   80207e <nsipc_connect>
  801f0d:	83 c4 10             	add    $0x10,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <listen>:
{
  801f12:	f3 0f 1e fb          	endbr32 
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	e8 9c fe ff ff       	call   801dc0 <fd2sockid>
  801f24:	85 c0                	test   %eax,%eax
  801f26:	78 0f                	js     801f37 <listen+0x25>
	return nsipc_listen(r, backlog);
  801f28:	83 ec 08             	sub    $0x8,%esp
  801f2b:	ff 75 0c             	pushl  0xc(%ebp)
  801f2e:	50                   	push   %eax
  801f2f:	e8 83 01 00 00       	call   8020b7 <nsipc_listen>
  801f34:	83 c4 10             	add    $0x10,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f39:	f3 0f 1e fb          	endbr32 
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f43:	ff 75 10             	pushl  0x10(%ebp)
  801f46:	ff 75 0c             	pushl  0xc(%ebp)
  801f49:	ff 75 08             	pushl  0x8(%ebp)
  801f4c:	e8 65 02 00 00       	call   8021b6 <nsipc_socket>
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 05                	js     801f5d <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801f58:	e8 93 fe ff ff       	call   801df0 <alloc_sockfd>
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	53                   	push   %ebx
  801f63:	83 ec 04             	sub    $0x4,%esp
  801f66:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f68:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  801f6f:	74 26                	je     801f97 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f71:	6a 07                	push   $0x7
  801f73:	68 00 70 80 00       	push   $0x807000
  801f78:	53                   	push   %ebx
  801f79:	ff 35 b0 50 80 00    	pushl  0x8050b0
  801f7f:	e8 e0 07 00 00       	call   802764 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f84:	83 c4 0c             	add    $0xc,%esp
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	e8 4d 07 00 00       	call   8026df <ipc_recv>
}
  801f92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	6a 02                	push   $0x2
  801f9c:	e8 1b 08 00 00       	call   8027bc <ipc_find_env>
  801fa1:	a3 b0 50 80 00       	mov    %eax,0x8050b0
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	eb c6                	jmp    801f71 <nsipc+0x12>

00801fab <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fab:	f3 0f 1e fb          	endbr32 
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fbf:	8b 06                	mov    (%esi),%eax
  801fc1:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcb:	e8 8f ff ff ff       	call   801f5f <nsipc>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	79 09                	jns    801fdf <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fd6:	89 d8                	mov    %ebx,%eax
  801fd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5d                   	pop    %ebp
  801fde:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	ff 35 10 70 80 00    	pushl  0x807010
  801fe8:	68 00 70 80 00       	push   $0x807000
  801fed:	ff 75 0c             	pushl  0xc(%ebp)
  801ff0:	e8 03 ef ff ff       	call   800ef8 <memmove>
		*addrlen = ret->ret_addrlen;
  801ff5:	a1 10 70 80 00       	mov    0x807010,%eax
  801ffa:	89 06                	mov    %eax,(%esi)
  801ffc:	83 c4 10             	add    $0x10,%esp
	return r;
  801fff:	eb d5                	jmp    801fd6 <nsipc_accept+0x2b>

00802001 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802001:	f3 0f 1e fb          	endbr32 
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	53                   	push   %ebx
  802009:	83 ec 08             	sub    $0x8,%esp
  80200c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802017:	53                   	push   %ebx
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	68 04 70 80 00       	push   $0x807004
  802020:	e8 d3 ee ff ff       	call   800ef8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802025:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80202b:	b8 02 00 00 00       	mov    $0x2,%eax
  802030:	e8 2a ff ff ff       	call   801f5f <nsipc>
}
  802035:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80203a:	f3 0f 1e fb          	endbr32 
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80204c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802054:	b8 03 00 00 00       	mov    $0x3,%eax
  802059:	e8 01 ff ff ff       	call   801f5f <nsipc>
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <nsipc_close>:

int
nsipc_close(int s)
{
  802060:	f3 0f 1e fb          	endbr32 
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802072:	b8 04 00 00 00       	mov    $0x4,%eax
  802077:	e8 e3 fe ff ff       	call   801f5f <nsipc>
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80207e:	f3 0f 1e fb          	endbr32 
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	53                   	push   %ebx
  802086:	83 ec 08             	sub    $0x8,%esp
  802089:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802094:	53                   	push   %ebx
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	68 04 70 80 00       	push   $0x807004
  80209d:	e8 56 ee ff ff       	call   800ef8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020a2:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8020ad:	e8 ad fe ff ff       	call   801f5f <nsipc>
}
  8020b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020b7:	f3 0f 1e fb          	endbr32 
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cc:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020d1:	b8 06 00 00 00       	mov    $0x6,%eax
  8020d6:	e8 84 fe ff ff       	call   801f5f <nsipc>
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020dd:	f3 0f 1e fb          	endbr32 
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	56                   	push   %esi
  8020e5:	53                   	push   %ebx
  8020e6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020f1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fa:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020ff:	b8 07 00 00 00       	mov    $0x7,%eax
  802104:	e8 56 fe ff ff       	call   801f5f <nsipc>
  802109:	89 c3                	mov    %eax,%ebx
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 26                	js     802135 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80210f:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802115:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80211a:	0f 4e c6             	cmovle %esi,%eax
  80211d:	39 c3                	cmp    %eax,%ebx
  80211f:	7f 1d                	jg     80213e <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	53                   	push   %ebx
  802125:	68 00 70 80 00       	push   $0x807000
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	e8 c6 ed ff ff       	call   800ef8 <memmove>
  802132:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802135:	89 d8                	mov    %ebx,%eax
  802137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80213a:	5b                   	pop    %ebx
  80213b:	5e                   	pop    %esi
  80213c:	5d                   	pop    %ebp
  80213d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80213e:	68 4f 30 80 00       	push   $0x80304f
  802143:	68 17 30 80 00       	push   $0x803017
  802148:	6a 62                	push   $0x62
  80214a:	68 64 30 80 00       	push   $0x803064
  80214f:	e8 fd e4 ff ff       	call   800651 <_panic>

00802154 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802154:	f3 0f 1e fb          	endbr32 
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	53                   	push   %ebx
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80216a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802170:	7f 2e                	jg     8021a0 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	53                   	push   %ebx
  802176:	ff 75 0c             	pushl  0xc(%ebp)
  802179:	68 0c 70 80 00       	push   $0x80700c
  80217e:	e8 75 ed ff ff       	call   800ef8 <memmove>
	nsipcbuf.send.req_size = size;
  802183:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802189:	8b 45 14             	mov    0x14(%ebp),%eax
  80218c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802191:	b8 08 00 00 00       	mov    $0x8,%eax
  802196:	e8 c4 fd ff ff       	call   801f5f <nsipc>
}
  80219b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    
	assert(size < 1600);
  8021a0:	68 70 30 80 00       	push   $0x803070
  8021a5:	68 17 30 80 00       	push   $0x803017
  8021aa:	6a 6d                	push   $0x6d
  8021ac:	68 64 30 80 00       	push   $0x803064
  8021b1:	e8 9b e4 ff ff       	call   800651 <_panic>

008021b6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021b6:	f3 0f 1e fb          	endbr32 
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cb:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021d8:	b8 09 00 00 00       	mov    $0x9,%eax
  8021dd:	e8 7d fd ff ff       	call   801f5f <nsipc>
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021e4:	f3 0f 1e fb          	endbr32 
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	56                   	push   %esi
  8021ec:	53                   	push   %ebx
  8021ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021f0:	83 ec 0c             	sub    $0xc,%esp
  8021f3:	ff 75 08             	pushl  0x8(%ebp)
  8021f6:	e8 f6 f2 ff ff       	call   8014f1 <fd2data>
  8021fb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021fd:	83 c4 08             	add    $0x8,%esp
  802200:	68 7c 30 80 00       	push   $0x80307c
  802205:	53                   	push   %ebx
  802206:	e8 37 eb ff ff       	call   800d42 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80220b:	8b 46 04             	mov    0x4(%esi),%eax
  80220e:	2b 06                	sub    (%esi),%eax
  802210:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802216:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80221d:	00 00 00 
	stat->st_dev = &devpipe;
  802220:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802227:	40 80 00 
	return 0;
}
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
  80222f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802232:	5b                   	pop    %ebx
  802233:	5e                   	pop    %esi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    

00802236 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802236:	f3 0f 1e fb          	endbr32 
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	53                   	push   %ebx
  80223e:	83 ec 0c             	sub    $0xc,%esp
  802241:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802244:	53                   	push   %ebx
  802245:	6a 00                	push   $0x0
  802247:	e8 c5 ef ff ff       	call   801211 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80224c:	89 1c 24             	mov    %ebx,(%esp)
  80224f:	e8 9d f2 ff ff       	call   8014f1 <fd2data>
  802254:	83 c4 08             	add    $0x8,%esp
  802257:	50                   	push   %eax
  802258:	6a 00                	push   $0x0
  80225a:	e8 b2 ef ff ff       	call   801211 <sys_page_unmap>
}
  80225f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <_pipeisclosed>:
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	57                   	push   %edi
  802268:	56                   	push   %esi
  802269:	53                   	push   %ebx
  80226a:	83 ec 1c             	sub    $0x1c,%esp
  80226d:	89 c7                	mov    %eax,%edi
  80226f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802271:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802276:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802279:	83 ec 0c             	sub    $0xc,%esp
  80227c:	57                   	push   %edi
  80227d:	e8 77 05 00 00       	call   8027f9 <pageref>
  802282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802285:	89 34 24             	mov    %esi,(%esp)
  802288:	e8 6c 05 00 00       	call   8027f9 <pageref>
		nn = thisenv->env_runs;
  80228d:	8b 15 b4 50 80 00    	mov    0x8050b4,%edx
  802293:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802296:	83 c4 10             	add    $0x10,%esp
  802299:	39 cb                	cmp    %ecx,%ebx
  80229b:	74 1b                	je     8022b8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80229d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022a0:	75 cf                	jne    802271 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022a2:	8b 42 58             	mov    0x58(%edx),%eax
  8022a5:	6a 01                	push   $0x1
  8022a7:	50                   	push   %eax
  8022a8:	53                   	push   %ebx
  8022a9:	68 83 30 80 00       	push   $0x803083
  8022ae:	e8 85 e4 ff ff       	call   800738 <cprintf>
  8022b3:	83 c4 10             	add    $0x10,%esp
  8022b6:	eb b9                	jmp    802271 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022b8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022bb:	0f 94 c0             	sete   %al
  8022be:	0f b6 c0             	movzbl %al,%eax
}
  8022c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5f                   	pop    %edi
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    

008022c9 <devpipe_write>:
{
  8022c9:	f3 0f 1e fb          	endbr32 
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	57                   	push   %edi
  8022d1:	56                   	push   %esi
  8022d2:	53                   	push   %ebx
  8022d3:	83 ec 28             	sub    $0x28,%esp
  8022d6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022d9:	56                   	push   %esi
  8022da:	e8 12 f2 ff ff       	call   8014f1 <fd2data>
  8022df:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022ec:	74 4f                	je     80233d <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022ee:	8b 43 04             	mov    0x4(%ebx),%eax
  8022f1:	8b 0b                	mov    (%ebx),%ecx
  8022f3:	8d 51 20             	lea    0x20(%ecx),%edx
  8022f6:	39 d0                	cmp    %edx,%eax
  8022f8:	72 14                	jb     80230e <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8022fa:	89 da                	mov    %ebx,%edx
  8022fc:	89 f0                	mov    %esi,%eax
  8022fe:	e8 61 ff ff ff       	call   802264 <_pipeisclosed>
  802303:	85 c0                	test   %eax,%eax
  802305:	75 3b                	jne    802342 <devpipe_write+0x79>
			sys_yield();
  802307:	e8 55 ee ff ff       	call   801161 <sys_yield>
  80230c:	eb e0                	jmp    8022ee <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80230e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802311:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802315:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802318:	89 c2                	mov    %eax,%edx
  80231a:	c1 fa 1f             	sar    $0x1f,%edx
  80231d:	89 d1                	mov    %edx,%ecx
  80231f:	c1 e9 1b             	shr    $0x1b,%ecx
  802322:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802325:	83 e2 1f             	and    $0x1f,%edx
  802328:	29 ca                	sub    %ecx,%edx
  80232a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80232e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802332:	83 c0 01             	add    $0x1,%eax
  802335:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802338:	83 c7 01             	add    $0x1,%edi
  80233b:	eb ac                	jmp    8022e9 <devpipe_write+0x20>
	return i;
  80233d:	8b 45 10             	mov    0x10(%ebp),%eax
  802340:	eb 05                	jmp    802347 <devpipe_write+0x7e>
				return 0;
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802347:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80234a:	5b                   	pop    %ebx
  80234b:	5e                   	pop    %esi
  80234c:	5f                   	pop    %edi
  80234d:	5d                   	pop    %ebp
  80234e:	c3                   	ret    

0080234f <devpipe_read>:
{
  80234f:	f3 0f 1e fb          	endbr32 
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
  802356:	57                   	push   %edi
  802357:	56                   	push   %esi
  802358:	53                   	push   %ebx
  802359:	83 ec 18             	sub    $0x18,%esp
  80235c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80235f:	57                   	push   %edi
  802360:	e8 8c f1 ff ff       	call   8014f1 <fd2data>
  802365:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802367:	83 c4 10             	add    $0x10,%esp
  80236a:	be 00 00 00 00       	mov    $0x0,%esi
  80236f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802372:	75 14                	jne    802388 <devpipe_read+0x39>
	return i;
  802374:	8b 45 10             	mov    0x10(%ebp),%eax
  802377:	eb 02                	jmp    80237b <devpipe_read+0x2c>
				return i;
  802379:	89 f0                	mov    %esi,%eax
}
  80237b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80237e:	5b                   	pop    %ebx
  80237f:	5e                   	pop    %esi
  802380:	5f                   	pop    %edi
  802381:	5d                   	pop    %ebp
  802382:	c3                   	ret    
			sys_yield();
  802383:	e8 d9 ed ff ff       	call   801161 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802388:	8b 03                	mov    (%ebx),%eax
  80238a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80238d:	75 18                	jne    8023a7 <devpipe_read+0x58>
			if (i > 0)
  80238f:	85 f6                	test   %esi,%esi
  802391:	75 e6                	jne    802379 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802393:	89 da                	mov    %ebx,%edx
  802395:	89 f8                	mov    %edi,%eax
  802397:	e8 c8 fe ff ff       	call   802264 <_pipeisclosed>
  80239c:	85 c0                	test   %eax,%eax
  80239e:	74 e3                	je     802383 <devpipe_read+0x34>
				return 0;
  8023a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a5:	eb d4                	jmp    80237b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023a7:	99                   	cltd   
  8023a8:	c1 ea 1b             	shr    $0x1b,%edx
  8023ab:	01 d0                	add    %edx,%eax
  8023ad:	83 e0 1f             	and    $0x1f,%eax
  8023b0:	29 d0                	sub    %edx,%eax
  8023b2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023ba:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023bd:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023c0:	83 c6 01             	add    $0x1,%esi
  8023c3:	eb aa                	jmp    80236f <devpipe_read+0x20>

008023c5 <pipe>:
{
  8023c5:	f3 0f 1e fb          	endbr32 
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	56                   	push   %esi
  8023cd:	53                   	push   %ebx
  8023ce:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d4:	50                   	push   %eax
  8023d5:	e8 32 f1 ff ff       	call   80150c <fd_alloc>
  8023da:	89 c3                	mov    %eax,%ebx
  8023dc:	83 c4 10             	add    $0x10,%esp
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	0f 88 23 01 00 00    	js     80250a <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	68 07 04 00 00       	push   $0x407
  8023ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8023f2:	6a 00                	push   $0x0
  8023f4:	e8 8b ed ff ff       	call   801184 <sys_page_alloc>
  8023f9:	89 c3                	mov    %eax,%ebx
  8023fb:	83 c4 10             	add    $0x10,%esp
  8023fe:	85 c0                	test   %eax,%eax
  802400:	0f 88 04 01 00 00    	js     80250a <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802406:	83 ec 0c             	sub    $0xc,%esp
  802409:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80240c:	50                   	push   %eax
  80240d:	e8 fa f0 ff ff       	call   80150c <fd_alloc>
  802412:	89 c3                	mov    %eax,%ebx
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	85 c0                	test   %eax,%eax
  802419:	0f 88 db 00 00 00    	js     8024fa <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80241f:	83 ec 04             	sub    $0x4,%esp
  802422:	68 07 04 00 00       	push   $0x407
  802427:	ff 75 f0             	pushl  -0x10(%ebp)
  80242a:	6a 00                	push   $0x0
  80242c:	e8 53 ed ff ff       	call   801184 <sys_page_alloc>
  802431:	89 c3                	mov    %eax,%ebx
  802433:	83 c4 10             	add    $0x10,%esp
  802436:	85 c0                	test   %eax,%eax
  802438:	0f 88 bc 00 00 00    	js     8024fa <pipe+0x135>
	va = fd2data(fd0);
  80243e:	83 ec 0c             	sub    $0xc,%esp
  802441:	ff 75 f4             	pushl  -0xc(%ebp)
  802444:	e8 a8 f0 ff ff       	call   8014f1 <fd2data>
  802449:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80244b:	83 c4 0c             	add    $0xc,%esp
  80244e:	68 07 04 00 00       	push   $0x407
  802453:	50                   	push   %eax
  802454:	6a 00                	push   $0x0
  802456:	e8 29 ed ff ff       	call   801184 <sys_page_alloc>
  80245b:	89 c3                	mov    %eax,%ebx
  80245d:	83 c4 10             	add    $0x10,%esp
  802460:	85 c0                	test   %eax,%eax
  802462:	0f 88 82 00 00 00    	js     8024ea <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802468:	83 ec 0c             	sub    $0xc,%esp
  80246b:	ff 75 f0             	pushl  -0x10(%ebp)
  80246e:	e8 7e f0 ff ff       	call   8014f1 <fd2data>
  802473:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80247a:	50                   	push   %eax
  80247b:	6a 00                	push   $0x0
  80247d:	56                   	push   %esi
  80247e:	6a 00                	push   $0x0
  802480:	e8 46 ed ff ff       	call   8011cb <sys_page_map>
  802485:	89 c3                	mov    %eax,%ebx
  802487:	83 c4 20             	add    $0x20,%esp
  80248a:	85 c0                	test   %eax,%eax
  80248c:	78 4e                	js     8024dc <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80248e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802496:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802498:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024aa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024b1:	83 ec 0c             	sub    $0xc,%esp
  8024b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b7:	e8 21 f0 ff ff       	call   8014dd <fd2num>
  8024bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024bf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024c1:	83 c4 04             	add    $0x4,%esp
  8024c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8024c7:	e8 11 f0 ff ff       	call   8014dd <fd2num>
  8024cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024cf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024d2:	83 c4 10             	add    $0x10,%esp
  8024d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024da:	eb 2e                	jmp    80250a <pipe+0x145>
	sys_page_unmap(0, va);
  8024dc:	83 ec 08             	sub    $0x8,%esp
  8024df:	56                   	push   %esi
  8024e0:	6a 00                	push   $0x0
  8024e2:	e8 2a ed ff ff       	call   801211 <sys_page_unmap>
  8024e7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024ea:	83 ec 08             	sub    $0x8,%esp
  8024ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8024f0:	6a 00                	push   $0x0
  8024f2:	e8 1a ed ff ff       	call   801211 <sys_page_unmap>
  8024f7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8024fa:	83 ec 08             	sub    $0x8,%esp
  8024fd:	ff 75 f4             	pushl  -0xc(%ebp)
  802500:	6a 00                	push   $0x0
  802502:	e8 0a ed ff ff       	call   801211 <sys_page_unmap>
  802507:	83 c4 10             	add    $0x10,%esp
}
  80250a:	89 d8                	mov    %ebx,%eax
  80250c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80250f:	5b                   	pop    %ebx
  802510:	5e                   	pop    %esi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    

00802513 <pipeisclosed>:
{
  802513:	f3 0f 1e fb          	endbr32 
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80251d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802520:	50                   	push   %eax
  802521:	ff 75 08             	pushl  0x8(%ebp)
  802524:	e8 39 f0 ff ff       	call   801562 <fd_lookup>
  802529:	83 c4 10             	add    $0x10,%esp
  80252c:	85 c0                	test   %eax,%eax
  80252e:	78 18                	js     802548 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802530:	83 ec 0c             	sub    $0xc,%esp
  802533:	ff 75 f4             	pushl  -0xc(%ebp)
  802536:	e8 b6 ef ff ff       	call   8014f1 <fd2data>
  80253b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	e8 1f fd ff ff       	call   802264 <_pipeisclosed>
  802545:	83 c4 10             	add    $0x10,%esp
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80254a:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80254e:	b8 00 00 00 00       	mov    $0x0,%eax
  802553:	c3                   	ret    

00802554 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802554:	f3 0f 1e fb          	endbr32 
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80255e:	68 9b 30 80 00       	push   $0x80309b
  802563:	ff 75 0c             	pushl  0xc(%ebp)
  802566:	e8 d7 e7 ff ff       	call   800d42 <strcpy>
	return 0;
}
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <devcons_write>:
{
  802572:	f3 0f 1e fb          	endbr32 
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	57                   	push   %edi
  80257a:	56                   	push   %esi
  80257b:	53                   	push   %ebx
  80257c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802582:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802587:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80258d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802590:	73 31                	jae    8025c3 <devcons_write+0x51>
		m = n - tot;
  802592:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802595:	29 f3                	sub    %esi,%ebx
  802597:	83 fb 7f             	cmp    $0x7f,%ebx
  80259a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80259f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025a2:	83 ec 04             	sub    $0x4,%esp
  8025a5:	53                   	push   %ebx
  8025a6:	89 f0                	mov    %esi,%eax
  8025a8:	03 45 0c             	add    0xc(%ebp),%eax
  8025ab:	50                   	push   %eax
  8025ac:	57                   	push   %edi
  8025ad:	e8 46 e9 ff ff       	call   800ef8 <memmove>
		sys_cputs(buf, m);
  8025b2:	83 c4 08             	add    $0x8,%esp
  8025b5:	53                   	push   %ebx
  8025b6:	57                   	push   %edi
  8025b7:	e8 f8 ea ff ff       	call   8010b4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025bc:	01 de                	add    %ebx,%esi
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	eb ca                	jmp    80258d <devcons_write+0x1b>
}
  8025c3:	89 f0                	mov    %esi,%eax
  8025c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c8:	5b                   	pop    %ebx
  8025c9:	5e                   	pop    %esi
  8025ca:	5f                   	pop    %edi
  8025cb:	5d                   	pop    %ebp
  8025cc:	c3                   	ret    

008025cd <devcons_read>:
{
  8025cd:	f3 0f 1e fb          	endbr32 
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 08             	sub    $0x8,%esp
  8025d7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025e0:	74 21                	je     802603 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8025e2:	e8 ef ea ff ff       	call   8010d6 <sys_cgetc>
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	75 07                	jne    8025f2 <devcons_read+0x25>
		sys_yield();
  8025eb:	e8 71 eb ff ff       	call   801161 <sys_yield>
  8025f0:	eb f0                	jmp    8025e2 <devcons_read+0x15>
	if (c < 0)
  8025f2:	78 0f                	js     802603 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8025f4:	83 f8 04             	cmp    $0x4,%eax
  8025f7:	74 0c                	je     802605 <devcons_read+0x38>
	*(char*)vbuf = c;
  8025f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fc:	88 02                	mov    %al,(%edx)
	return 1;
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    
		return 0;
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
  80260a:	eb f7                	jmp    802603 <devcons_read+0x36>

0080260c <cputchar>:
{
  80260c:	f3 0f 1e fb          	endbr32 
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80261c:	6a 01                	push   $0x1
  80261e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802621:	50                   	push   %eax
  802622:	e8 8d ea ff ff       	call   8010b4 <sys_cputs>
}
  802627:	83 c4 10             	add    $0x10,%esp
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <getchar>:
{
  80262c:	f3 0f 1e fb          	endbr32 
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802636:	6a 01                	push   $0x1
  802638:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80263b:	50                   	push   %eax
  80263c:	6a 00                	push   $0x0
  80263e:	e8 a7 f1 ff ff       	call   8017ea <read>
	if (r < 0)
  802643:	83 c4 10             	add    $0x10,%esp
  802646:	85 c0                	test   %eax,%eax
  802648:	78 06                	js     802650 <getchar+0x24>
	if (r < 1)
  80264a:	74 06                	je     802652 <getchar+0x26>
	return c;
  80264c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    
		return -E_EOF;
  802652:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802657:	eb f7                	jmp    802650 <getchar+0x24>

00802659 <iscons>:
{
  802659:	f3 0f 1e fb          	endbr32 
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
  802660:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802663:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802666:	50                   	push   %eax
  802667:	ff 75 08             	pushl  0x8(%ebp)
  80266a:	e8 f3 ee ff ff       	call   801562 <fd_lookup>
  80266f:	83 c4 10             	add    $0x10,%esp
  802672:	85 c0                	test   %eax,%eax
  802674:	78 11                	js     802687 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80267f:	39 10                	cmp    %edx,(%eax)
  802681:	0f 94 c0             	sete   %al
  802684:	0f b6 c0             	movzbl %al,%eax
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <opencons>:
{
  802689:	f3 0f 1e fb          	endbr32 
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
  802690:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802693:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802696:	50                   	push   %eax
  802697:	e8 70 ee ff ff       	call   80150c <fd_alloc>
  80269c:	83 c4 10             	add    $0x10,%esp
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	78 3a                	js     8026dd <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	68 07 04 00 00       	push   $0x407
  8026ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ae:	6a 00                	push   $0x0
  8026b0:	e8 cf ea ff ff       	call   801184 <sys_page_alloc>
  8026b5:	83 c4 10             	add    $0x10,%esp
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	78 21                	js     8026dd <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026c5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026d1:	83 ec 0c             	sub    $0xc,%esp
  8026d4:	50                   	push   %eax
  8026d5:	e8 03 ee ff ff       	call   8014dd <fd2num>
  8026da:	83 c4 10             	add    $0x10,%esp
}
  8026dd:	c9                   	leave  
  8026de:	c3                   	ret    

008026df <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026df:	f3 0f 1e fb          	endbr32 
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	56                   	push   %esi
  8026e7:	53                   	push   %ebx
  8026e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8026eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	74 3d                	je     802732 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8026f5:	83 ec 0c             	sub    $0xc,%esp
  8026f8:	50                   	push   %eax
  8026f9:	e8 52 ec ff ff       	call   801350 <sys_ipc_recv>
  8026fe:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802701:	85 f6                	test   %esi,%esi
  802703:	74 0b                	je     802710 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802705:	8b 15 b4 50 80 00    	mov    0x8050b4,%edx
  80270b:	8b 52 74             	mov    0x74(%edx),%edx
  80270e:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802710:	85 db                	test   %ebx,%ebx
  802712:	74 0b                	je     80271f <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802714:	8b 15 b4 50 80 00    	mov    0x8050b4,%edx
  80271a:	8b 52 78             	mov    0x78(%edx),%edx
  80271d:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80271f:	85 c0                	test   %eax,%eax
  802721:	78 21                	js     802744 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802723:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802728:	8b 40 70             	mov    0x70(%eax),%eax
}
  80272b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80272e:	5b                   	pop    %ebx
  80272f:	5e                   	pop    %esi
  802730:	5d                   	pop    %ebp
  802731:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802732:	83 ec 0c             	sub    $0xc,%esp
  802735:	68 00 00 c0 ee       	push   $0xeec00000
  80273a:	e8 11 ec ff ff       	call   801350 <sys_ipc_recv>
  80273f:	83 c4 10             	add    $0x10,%esp
  802742:	eb bd                	jmp    802701 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802744:	85 f6                	test   %esi,%esi
  802746:	74 10                	je     802758 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802748:	85 db                	test   %ebx,%ebx
  80274a:	75 df                	jne    80272b <ipc_recv+0x4c>
  80274c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802753:	00 00 00 
  802756:	eb d3                	jmp    80272b <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802758:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80275f:	00 00 00 
  802762:	eb e4                	jmp    802748 <ipc_recv+0x69>

00802764 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802764:	f3 0f 1e fb          	endbr32 
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
  80276b:	57                   	push   %edi
  80276c:	56                   	push   %esi
  80276d:	53                   	push   %ebx
  80276e:	83 ec 0c             	sub    $0xc,%esp
  802771:	8b 7d 08             	mov    0x8(%ebp),%edi
  802774:	8b 75 0c             	mov    0xc(%ebp),%esi
  802777:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80277a:	85 db                	test   %ebx,%ebx
  80277c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802781:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802784:	ff 75 14             	pushl  0x14(%ebp)
  802787:	53                   	push   %ebx
  802788:	56                   	push   %esi
  802789:	57                   	push   %edi
  80278a:	e8 9a eb ff ff       	call   801329 <sys_ipc_try_send>
  80278f:	83 c4 10             	add    $0x10,%esp
  802792:	85 c0                	test   %eax,%eax
  802794:	79 1e                	jns    8027b4 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802796:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802799:	75 07                	jne    8027a2 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80279b:	e8 c1 e9 ff ff       	call   801161 <sys_yield>
  8027a0:	eb e2                	jmp    802784 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8027a2:	50                   	push   %eax
  8027a3:	68 a7 30 80 00       	push   $0x8030a7
  8027a8:	6a 59                	push   $0x59
  8027aa:	68 c2 30 80 00       	push   $0x8030c2
  8027af:	e8 9d de ff ff       	call   800651 <_panic>
	}
}
  8027b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027b7:	5b                   	pop    %ebx
  8027b8:	5e                   	pop    %esi
  8027b9:	5f                   	pop    %edi
  8027ba:	5d                   	pop    %ebp
  8027bb:	c3                   	ret    

008027bc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027bc:	f3 0f 1e fb          	endbr32 
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027c6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027cb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8027ce:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027d4:	8b 52 50             	mov    0x50(%edx),%edx
  8027d7:	39 ca                	cmp    %ecx,%edx
  8027d9:	74 11                	je     8027ec <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8027db:	83 c0 01             	add    $0x1,%eax
  8027de:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027e3:	75 e6                	jne    8027cb <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8027e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ea:	eb 0b                	jmp    8027f7 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8027ec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027f4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027f7:	5d                   	pop    %ebp
  8027f8:	c3                   	ret    

008027f9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027f9:	f3 0f 1e fb          	endbr32 
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802803:	89 c2                	mov    %eax,%edx
  802805:	c1 ea 16             	shr    $0x16,%edx
  802808:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80280f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802814:	f6 c1 01             	test   $0x1,%cl
  802817:	74 1c                	je     802835 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802819:	c1 e8 0c             	shr    $0xc,%eax
  80281c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802823:	a8 01                	test   $0x1,%al
  802825:	74 0e                	je     802835 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802827:	c1 e8 0c             	shr    $0xc,%eax
  80282a:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802831:	ef 
  802832:	0f b7 d2             	movzwl %dx,%edx
}
  802835:	89 d0                	mov    %edx,%eax
  802837:	5d                   	pop    %ebp
  802838:	c3                   	ret    
  802839:	66 90                	xchg   %ax,%ax
  80283b:	66 90                	xchg   %ax,%ax
  80283d:	66 90                	xchg   %ax,%ax
  80283f:	90                   	nop

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
