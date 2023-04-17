
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
  800044:	68 71 25 80 00       	push   $0x802571
  800049:	68 40 25 80 00       	push   $0x802540
  80004e:	e8 e5 06 00 00       	call   800738 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 50 25 80 00       	push   $0x802550
  80005c:	68 54 25 80 00       	push   $0x802554
  800061:	e8 d2 06 00 00       	call   800738 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 68 25 80 00       	push   $0x802568
  80007b:	e8 b8 06 00 00       	call   800738 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 72 25 80 00       	push   $0x802572
  800093:	68 54 25 80 00       	push   $0x802554
  800098:	e8 9b 06 00 00       	call   800738 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 68 25 80 00       	push   $0x802568
  8000b4:	e8 7f 06 00 00       	call   800738 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 76 25 80 00       	push   $0x802576
  8000cc:	68 54 25 80 00       	push   $0x802554
  8000d1:	e8 62 06 00 00       	call   800738 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 68 25 80 00       	push   $0x802568
  8000ed:	e8 46 06 00 00       	call   800738 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 7a 25 80 00       	push   $0x80257a
  800105:	68 54 25 80 00       	push   $0x802554
  80010a:	e8 29 06 00 00       	call   800738 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 68 25 80 00       	push   $0x802568
  800126:	e8 0d 06 00 00       	call   800738 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 7e 25 80 00       	push   $0x80257e
  80013e:	68 54 25 80 00       	push   $0x802554
  800143:	e8 f0 05 00 00       	call   800738 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 68 25 80 00       	push   $0x802568
  80015f:	e8 d4 05 00 00       	call   800738 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 82 25 80 00       	push   $0x802582
  800177:	68 54 25 80 00       	push   $0x802554
  80017c:	e8 b7 05 00 00       	call   800738 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 68 25 80 00       	push   $0x802568
  800198:	e8 9b 05 00 00       	call   800738 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 86 25 80 00       	push   $0x802586
  8001b0:	68 54 25 80 00       	push   $0x802554
  8001b5:	e8 7e 05 00 00       	call   800738 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 68 25 80 00       	push   $0x802568
  8001d1:	e8 62 05 00 00       	call   800738 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 8a 25 80 00       	push   $0x80258a
  8001e9:	68 54 25 80 00       	push   $0x802554
  8001ee:	e8 45 05 00 00       	call   800738 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 68 25 80 00       	push   $0x802568
  80020a:	e8 29 05 00 00       	call   800738 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 8e 25 80 00       	push   $0x80258e
  800222:	68 54 25 80 00       	push   $0x802554
  800227:	e8 0c 05 00 00       	call   800738 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 68 25 80 00       	push   $0x802568
  800243:	e8 f0 04 00 00       	call   800738 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 95 25 80 00       	push   $0x802595
  800253:	68 54 25 80 00       	push   $0x802554
  800258:	e8 db 04 00 00       	call   800738 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 68 25 80 00       	push   $0x802568
  800274:	e8 bf 04 00 00       	call   800738 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 99 25 80 00       	push   $0x802599
  800284:	e8 af 04 00 00       	call   800738 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 68 25 80 00       	push   $0x802568
  800294:	e8 9f 04 00 00       	call   800738 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 64 25 80 00       	push   $0x802564
  8002a9:	e8 8a 04 00 00       	call   800738 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 64 25 80 00       	push   $0x802564
  8002c3:	e8 70 04 00 00       	call   800738 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 64 25 80 00       	push   $0x802564
  8002d8:	e8 5b 04 00 00       	call   800738 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 64 25 80 00       	push   $0x802564
  8002ed:	e8 46 04 00 00       	call   800738 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 64 25 80 00       	push   $0x802564
  800302:	e8 31 04 00 00       	call   800738 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 64 25 80 00       	push   $0x802564
  800317:	e8 1c 04 00 00       	call   800738 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 64 25 80 00       	push   $0x802564
  80032c:	e8 07 04 00 00       	call   800738 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 64 25 80 00       	push   $0x802564
  800341:	e8 f2 03 00 00       	call   800738 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 64 25 80 00       	push   $0x802564
  800356:	e8 dd 03 00 00       	call   800738 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 95 25 80 00       	push   $0x802595
  800366:	68 54 25 80 00       	push   $0x802554
  80036b:	e8 c8 03 00 00       	call   800738 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 64 25 80 00       	push   $0x802564
  800387:	e8 ac 03 00 00       	call   800738 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 99 25 80 00       	push   $0x802599
  800397:	e8 9c 03 00 00       	call   800738 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 64 25 80 00       	push   $0x802564
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
  8003c2:	68 64 25 80 00       	push   $0x802564
  8003c7:	e8 6c 03 00 00       	call   800738 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 99 25 80 00       	push   $0x802599
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
  800402:	89 15 40 40 80 00    	mov    %edx,0x804040
  800408:	8b 50 0c             	mov    0xc(%eax),%edx
  80040b:	89 15 44 40 80 00    	mov    %edx,0x804044
  800411:	8b 50 10             	mov    0x10(%eax),%edx
  800414:	89 15 48 40 80 00    	mov    %edx,0x804048
  80041a:	8b 50 14             	mov    0x14(%eax),%edx
  80041d:	89 15 4c 40 80 00    	mov    %edx,0x80404c
  800423:	8b 50 18             	mov    0x18(%eax),%edx
  800426:	89 15 50 40 80 00    	mov    %edx,0x804050
  80042c:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042f:	89 15 54 40 80 00    	mov    %edx,0x804054
  800435:	8b 50 20             	mov    0x20(%eax),%edx
  800438:	89 15 58 40 80 00    	mov    %edx,0x804058
  80043e:	8b 50 24             	mov    0x24(%eax),%edx
  800441:	89 15 5c 40 80 00    	mov    %edx,0x80405c
	during.eip = utf->utf_eip;
  800447:	8b 50 28             	mov    0x28(%eax),%edx
  80044a:	89 15 60 40 80 00    	mov    %edx,0x804060
	during.eflags = utf->utf_eflags & ~FL_RF;
  800450:	8b 50 2c             	mov    0x2c(%eax),%edx
  800453:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800459:	89 15 64 40 80 00    	mov    %edx,0x804064
	during.esp = utf->utf_esp;
  80045f:	8b 40 30             	mov    0x30(%eax),%eax
  800462:	a3 68 40 80 00       	mov    %eax,0x804068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	68 bf 25 80 00       	push   $0x8025bf
  80046f:	68 cd 25 80 00       	push   $0x8025cd
  800474:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800479:	ba b8 25 80 00       	mov    $0x8025b8,%edx
  80047e:	b8 80 40 80 00       	mov    $0x804080,%eax
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
  8004a9:	68 00 26 80 00       	push   $0x802600
  8004ae:	6a 50                	push   $0x50
  8004b0:	68 a7 25 80 00       	push   $0x8025a7
  8004b5:	e8 97 01 00 00       	call   800651 <_panic>
		panic("sys_page_alloc: %e", r);
  8004ba:	50                   	push   %eax
  8004bb:	68 d4 25 80 00       	push   $0x8025d4
  8004c0:	6a 5c                	push   $0x5c
  8004c2:	68 a7 25 80 00       	push   $0x8025a7
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
  8004db:	e8 b5 0e 00 00       	call   801395 <set_pgfault_handler>

	asm volatile(
  8004e0:	50                   	push   %eax
  8004e1:	9c                   	pushf  
  8004e2:	58                   	pop    %eax
  8004e3:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e8:	50                   	push   %eax
  8004e9:	9d                   	popf   
  8004ea:	a3 a4 40 80 00       	mov    %eax,0x8040a4
  8004ef:	8d 05 2a 05 80 00    	lea    0x80052a,%eax
  8004f5:	a3 a0 40 80 00       	mov    %eax,0x8040a0
  8004fa:	58                   	pop    %eax
  8004fb:	89 3d 80 40 80 00    	mov    %edi,0x804080
  800501:	89 35 84 40 80 00    	mov    %esi,0x804084
  800507:	89 2d 88 40 80 00    	mov    %ebp,0x804088
  80050d:	89 1d 90 40 80 00    	mov    %ebx,0x804090
  800513:	89 15 94 40 80 00    	mov    %edx,0x804094
  800519:	89 0d 98 40 80 00    	mov    %ecx,0x804098
  80051f:	a3 9c 40 80 00       	mov    %eax,0x80409c
  800524:	89 25 a8 40 80 00    	mov    %esp,0x8040a8
  80052a:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800531:	00 00 00 
  800534:	89 3d 00 40 80 00    	mov    %edi,0x804000
  80053a:	89 35 04 40 80 00    	mov    %esi,0x804004
  800540:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  800546:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  80054c:	89 15 14 40 80 00    	mov    %edx,0x804014
  800552:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  800558:	a3 1c 40 80 00       	mov    %eax,0x80401c
  80055d:	89 25 28 40 80 00    	mov    %esp,0x804028
  800563:	8b 3d 80 40 80 00    	mov    0x804080,%edi
  800569:	8b 35 84 40 80 00    	mov    0x804084,%esi
  80056f:	8b 2d 88 40 80 00    	mov    0x804088,%ebp
  800575:	8b 1d 90 40 80 00    	mov    0x804090,%ebx
  80057b:	8b 15 94 40 80 00    	mov    0x804094,%edx
  800581:	8b 0d 98 40 80 00    	mov    0x804098,%ecx
  800587:	a1 9c 40 80 00       	mov    0x80409c,%eax
  80058c:	8b 25 a8 40 80 00    	mov    0x8040a8,%esp
  800592:	50                   	push   %eax
  800593:	9c                   	pushf  
  800594:	58                   	pop    %eax
  800595:	a3 24 40 80 00       	mov    %eax,0x804024
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
  8005a7:	a1 a0 40 80 00       	mov    0x8040a0,%eax
  8005ac:	a3 20 40 80 00       	mov    %eax,0x804020

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	68 e7 25 80 00       	push   $0x8025e7
  8005b9:	68 f8 25 80 00       	push   $0x8025f8
  8005be:	b9 00 40 80 00       	mov    $0x804000,%ecx
  8005c3:	ba b8 25 80 00       	mov    $0x8025b8,%edx
  8005c8:	b8 80 40 80 00       	mov    $0x804080,%eax
  8005cd:	e8 61 fa ff ff       	call   800033 <check_regs>
}
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	c9                   	leave  
  8005d6:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005d7:	83 ec 0c             	sub    $0xc,%esp
  8005da:	68 34 26 80 00       	push   $0x802634
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
  80060a:	a3 b0 40 80 00       	mov    %eax,0x8040b0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80060f:	85 db                	test   %ebx,%ebx
  800611:	7e 07                	jle    80061a <libmain+0x31>
		binaryname = argv[0];
  800613:	8b 06                	mov    (%esi),%eax
  800615:	a3 00 30 80 00       	mov    %eax,0x803000

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
  80063d:	e8 db 0f 00 00       	call   80161d <close_all>
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
  80065d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800663:	e8 d6 0a 00 00       	call   80113e <sys_getenvid>
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	ff 75 08             	pushl  0x8(%ebp)
  800671:	56                   	push   %esi
  800672:	50                   	push   %eax
  800673:	68 60 26 80 00       	push   $0x802660
  800678:	e8 bb 00 00 00       	call   800738 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80067d:	83 c4 18             	add    $0x18,%esp
  800680:	53                   	push   %ebx
  800681:	ff 75 10             	pushl  0x10(%ebp)
  800684:	e8 5a 00 00 00       	call   8006e3 <vcprintf>
	cprintf("\n");
  800689:	c7 04 24 70 25 80 00 	movl   $0x802570,(%esp)
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
  80079e:	e8 2d 1b 00 00       	call   8022d0 <__udivdi3>
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
  8007dc:	e8 ff 1b 00 00       	call   8023e0 <__umoddi3>
  8007e1:	83 c4 14             	add    $0x14,%esp
  8007e4:	0f be 80 83 26 80 00 	movsbl 0x802683(%eax),%eax
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
  80088b:	3e ff 24 85 c0 27 80 	notrack jmp *0x8027c0(,%eax,4)
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
  800958:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  80095f:	85 d2                	test   %edx,%edx
  800961:	74 18                	je     80097b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800963:	52                   	push   %edx
  800964:	68 c5 2a 80 00       	push   $0x802ac5
  800969:	53                   	push   %ebx
  80096a:	56                   	push   %esi
  80096b:	e8 aa fe ff ff       	call   80081a <printfmt>
  800970:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800973:	89 7d 14             	mov    %edi,0x14(%ebp)
  800976:	e9 66 02 00 00       	jmp    800be1 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80097b:	50                   	push   %eax
  80097c:	68 9b 26 80 00       	push   $0x80269b
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
  8009a3:	b8 94 26 80 00       	mov    $0x802694,%eax
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
  80112d:	68 7f 29 80 00       	push   $0x80297f
  801132:	6a 23                	push   $0x23
  801134:	68 9c 29 80 00       	push   $0x80299c
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
  8011ba:	68 7f 29 80 00       	push   $0x80297f
  8011bf:	6a 23                	push   $0x23
  8011c1:	68 9c 29 80 00       	push   $0x80299c
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
  801200:	68 7f 29 80 00       	push   $0x80297f
  801205:	6a 23                	push   $0x23
  801207:	68 9c 29 80 00       	push   $0x80299c
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
  801246:	68 7f 29 80 00       	push   $0x80297f
  80124b:	6a 23                	push   $0x23
  80124d:	68 9c 29 80 00       	push   $0x80299c
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
  80128c:	68 7f 29 80 00       	push   $0x80297f
  801291:	6a 23                	push   $0x23
  801293:	68 9c 29 80 00       	push   $0x80299c
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
  8012d2:	68 7f 29 80 00       	push   $0x80297f
  8012d7:	6a 23                	push   $0x23
  8012d9:	68 9c 29 80 00       	push   $0x80299c
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
  801318:	68 7f 29 80 00       	push   $0x80297f
  80131d:	6a 23                	push   $0x23
  80131f:	68 9c 29 80 00       	push   $0x80299c
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
  801384:	68 7f 29 80 00       	push   $0x80297f
  801389:	6a 23                	push   $0x23
  80138b:	68 9c 29 80 00       	push   $0x80299c
  801390:	e8 bc f2 ff ff       	call   800651 <_panic>

00801395 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801395:	f3 0f 1e fb          	endbr32 
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80139f:	83 3d b4 40 80 00 00 	cmpl   $0x0,0x8040b4
  8013a6:	74 0a                	je     8013b2 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	a3 b4 40 80 00       	mov    %eax,0x8040b4
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	6a 07                	push   $0x7
  8013b7:	68 00 f0 bf ee       	push   $0xeebff000
  8013bc:	6a 00                	push   $0x0
  8013be:	e8 c1 fd ff ff       	call   801184 <sys_page_alloc>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 2a                	js     8013f4 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  8013ca:	83 ec 08             	sub    $0x8,%esp
  8013cd:	68 08 14 80 00       	push   $0x801408
  8013d2:	6a 00                	push   $0x0
  8013d4:	e8 0a ff ff ff       	call   8012e3 <sys_env_set_pgfault_upcall>
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	79 c8                	jns    8013a8 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8013e0:	83 ec 04             	sub    $0x4,%esp
  8013e3:	68 d8 29 80 00       	push   $0x8029d8
  8013e8:	6a 25                	push   $0x25
  8013ea:	68 10 2a 80 00       	push   $0x802a10
  8013ef:	e8 5d f2 ff ff       	call   800651 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8013f4:	83 ec 04             	sub    $0x4,%esp
  8013f7:	68 ac 29 80 00       	push   $0x8029ac
  8013fc:	6a 22                	push   $0x22
  8013fe:	68 10 2a 80 00       	push   $0x802a10
  801403:	e8 49 f2 ff ff       	call   800651 <_panic>

00801408 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801408:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801409:	a1 b4 40 80 00       	mov    0x8040b4,%eax
	call *%eax
  80140e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801410:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  801413:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801417:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80141b:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80141e:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801420:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  801424:	83 c4 08             	add    $0x8,%esp
	popal
  801427:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  801428:	83 c4 04             	add    $0x4,%esp
	popfl
  80142b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  80142c:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  80142d:	c3                   	ret    

0080142e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80142e:	f3 0f 1e fb          	endbr32 
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	05 00 00 00 30       	add    $0x30000000,%eax
  80143d:	c1 e8 0c             	shr    $0xc,%eax
}
  801440:	5d                   	pop    %ebp
  801441:	c3                   	ret    

00801442 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801442:	f3 0f 1e fb          	endbr32 
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801456:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80145b:	5d                   	pop    %ebp
  80145c:	c3                   	ret    

0080145d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80145d:	f3 0f 1e fb          	endbr32 
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801469:	89 c2                	mov    %eax,%edx
  80146b:	c1 ea 16             	shr    $0x16,%edx
  80146e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801475:	f6 c2 01             	test   $0x1,%dl
  801478:	74 2d                	je     8014a7 <fd_alloc+0x4a>
  80147a:	89 c2                	mov    %eax,%edx
  80147c:	c1 ea 0c             	shr    $0xc,%edx
  80147f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801486:	f6 c2 01             	test   $0x1,%dl
  801489:	74 1c                	je     8014a7 <fd_alloc+0x4a>
  80148b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801490:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801495:	75 d2                	jne    801469 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014a0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014a5:	eb 0a                	jmp    8014b1 <fd_alloc+0x54>
			*fd_store = fd;
  8014a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014aa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b1:	5d                   	pop    %ebp
  8014b2:	c3                   	ret    

008014b3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014b3:	f3 0f 1e fb          	endbr32 
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014bd:	83 f8 1f             	cmp    $0x1f,%eax
  8014c0:	77 30                	ja     8014f2 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014c2:	c1 e0 0c             	shl    $0xc,%eax
  8014c5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014ca:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014d0:	f6 c2 01             	test   $0x1,%dl
  8014d3:	74 24                	je     8014f9 <fd_lookup+0x46>
  8014d5:	89 c2                	mov    %eax,%edx
  8014d7:	c1 ea 0c             	shr    $0xc,%edx
  8014da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014e1:	f6 c2 01             	test   $0x1,%dl
  8014e4:	74 1a                	je     801500 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e9:	89 02                	mov    %eax,(%edx)
	return 0;
  8014eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f0:	5d                   	pop    %ebp
  8014f1:	c3                   	ret    
		return -E_INVAL;
  8014f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f7:	eb f7                	jmp    8014f0 <fd_lookup+0x3d>
		return -E_INVAL;
  8014f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fe:	eb f0                	jmp    8014f0 <fd_lookup+0x3d>
  801500:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801505:	eb e9                	jmp    8014f0 <fd_lookup+0x3d>

00801507 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801507:	f3 0f 1e fb          	endbr32 
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801514:	ba 9c 2a 80 00       	mov    $0x802a9c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801519:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80151e:	39 08                	cmp    %ecx,(%eax)
  801520:	74 33                	je     801555 <dev_lookup+0x4e>
  801522:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801525:	8b 02                	mov    (%edx),%eax
  801527:	85 c0                	test   %eax,%eax
  801529:	75 f3                	jne    80151e <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80152b:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801530:	8b 40 48             	mov    0x48(%eax),%eax
  801533:	83 ec 04             	sub    $0x4,%esp
  801536:	51                   	push   %ecx
  801537:	50                   	push   %eax
  801538:	68 20 2a 80 00       	push   $0x802a20
  80153d:	e8 f6 f1 ff ff       	call   800738 <cprintf>
	*dev = 0;
  801542:	8b 45 0c             	mov    0xc(%ebp),%eax
  801545:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801553:	c9                   	leave  
  801554:	c3                   	ret    
			*dev = devtab[i];
  801555:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801558:	89 01                	mov    %eax,(%ecx)
			return 0;
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	eb f2                	jmp    801553 <dev_lookup+0x4c>

00801561 <fd_close>:
{
  801561:	f3 0f 1e fb          	endbr32 
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	57                   	push   %edi
  801569:	56                   	push   %esi
  80156a:	53                   	push   %ebx
  80156b:	83 ec 24             	sub    $0x24,%esp
  80156e:	8b 75 08             	mov    0x8(%ebp),%esi
  801571:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801574:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801577:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801578:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80157e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801581:	50                   	push   %eax
  801582:	e8 2c ff ff ff       	call   8014b3 <fd_lookup>
  801587:	89 c3                	mov    %eax,%ebx
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 05                	js     801595 <fd_close+0x34>
	    || fd != fd2)
  801590:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801593:	74 16                	je     8015ab <fd_close+0x4a>
		return (must_exist ? r : 0);
  801595:	89 f8                	mov    %edi,%eax
  801597:	84 c0                	test   %al,%al
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
  80159e:	0f 44 d8             	cmove  %eax,%ebx
}
  8015a1:	89 d8                	mov    %ebx,%eax
  8015a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a6:	5b                   	pop    %ebx
  8015a7:	5e                   	pop    %esi
  8015a8:	5f                   	pop    %edi
  8015a9:	5d                   	pop    %ebp
  8015aa:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015b1:	50                   	push   %eax
  8015b2:	ff 36                	pushl  (%esi)
  8015b4:	e8 4e ff ff ff       	call   801507 <dev_lookup>
  8015b9:	89 c3                	mov    %eax,%ebx
  8015bb:	83 c4 10             	add    $0x10,%esp
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	78 1a                	js     8015dc <fd_close+0x7b>
		if (dev->dev_close)
  8015c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015c8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	74 0b                	je     8015dc <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8015d1:	83 ec 0c             	sub    $0xc,%esp
  8015d4:	56                   	push   %esi
  8015d5:	ff d0                	call   *%eax
  8015d7:	89 c3                	mov    %eax,%ebx
  8015d9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015dc:	83 ec 08             	sub    $0x8,%esp
  8015df:	56                   	push   %esi
  8015e0:	6a 00                	push   $0x0
  8015e2:	e8 2a fc ff ff       	call   801211 <sys_page_unmap>
	return r;
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	eb b5                	jmp    8015a1 <fd_close+0x40>

008015ec <close>:

int
close(int fdnum)
{
  8015ec:	f3 0f 1e fb          	endbr32 
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	ff 75 08             	pushl  0x8(%ebp)
  8015fd:	e8 b1 fe ff ff       	call   8014b3 <fd_lookup>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	85 c0                	test   %eax,%eax
  801607:	79 02                	jns    80160b <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    
		return fd_close(fd, 1);
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	6a 01                	push   $0x1
  801610:	ff 75 f4             	pushl  -0xc(%ebp)
  801613:	e8 49 ff ff ff       	call   801561 <fd_close>
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	eb ec                	jmp    801609 <close+0x1d>

0080161d <close_all>:

void
close_all(void)
{
  80161d:	f3 0f 1e fb          	endbr32 
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	53                   	push   %ebx
  801625:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801628:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80162d:	83 ec 0c             	sub    $0xc,%esp
  801630:	53                   	push   %ebx
  801631:	e8 b6 ff ff ff       	call   8015ec <close>
	for (i = 0; i < MAXFD; i++)
  801636:	83 c3 01             	add    $0x1,%ebx
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	83 fb 20             	cmp    $0x20,%ebx
  80163f:	75 ec                	jne    80162d <close_all+0x10>
}
  801641:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801646:	f3 0f 1e fb          	endbr32 
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	57                   	push   %edi
  80164e:	56                   	push   %esi
  80164f:	53                   	push   %ebx
  801650:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801653:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801656:	50                   	push   %eax
  801657:	ff 75 08             	pushl  0x8(%ebp)
  80165a:	e8 54 fe ff ff       	call   8014b3 <fd_lookup>
  80165f:	89 c3                	mov    %eax,%ebx
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	85 c0                	test   %eax,%eax
  801666:	0f 88 81 00 00 00    	js     8016ed <dup+0xa7>
		return r;
	close(newfdnum);
  80166c:	83 ec 0c             	sub    $0xc,%esp
  80166f:	ff 75 0c             	pushl  0xc(%ebp)
  801672:	e8 75 ff ff ff       	call   8015ec <close>

	newfd = INDEX2FD(newfdnum);
  801677:	8b 75 0c             	mov    0xc(%ebp),%esi
  80167a:	c1 e6 0c             	shl    $0xc,%esi
  80167d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801683:	83 c4 04             	add    $0x4,%esp
  801686:	ff 75 e4             	pushl  -0x1c(%ebp)
  801689:	e8 b4 fd ff ff       	call   801442 <fd2data>
  80168e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801690:	89 34 24             	mov    %esi,(%esp)
  801693:	e8 aa fd ff ff       	call   801442 <fd2data>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80169d:	89 d8                	mov    %ebx,%eax
  80169f:	c1 e8 16             	shr    $0x16,%eax
  8016a2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016a9:	a8 01                	test   $0x1,%al
  8016ab:	74 11                	je     8016be <dup+0x78>
  8016ad:	89 d8                	mov    %ebx,%eax
  8016af:	c1 e8 0c             	shr    $0xc,%eax
  8016b2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016b9:	f6 c2 01             	test   $0x1,%dl
  8016bc:	75 39                	jne    8016f7 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016c1:	89 d0                	mov    %edx,%eax
  8016c3:	c1 e8 0c             	shr    $0xc,%eax
  8016c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016cd:	83 ec 0c             	sub    $0xc,%esp
  8016d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8016d5:	50                   	push   %eax
  8016d6:	56                   	push   %esi
  8016d7:	6a 00                	push   $0x0
  8016d9:	52                   	push   %edx
  8016da:	6a 00                	push   $0x0
  8016dc:	e8 ea fa ff ff       	call   8011cb <sys_page_map>
  8016e1:	89 c3                	mov    %eax,%ebx
  8016e3:	83 c4 20             	add    $0x20,%esp
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 31                	js     80171b <dup+0xd5>
		goto err;

	return newfdnum;
  8016ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016ed:	89 d8                	mov    %ebx,%eax
  8016ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016f7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016fe:	83 ec 0c             	sub    $0xc,%esp
  801701:	25 07 0e 00 00       	and    $0xe07,%eax
  801706:	50                   	push   %eax
  801707:	57                   	push   %edi
  801708:	6a 00                	push   $0x0
  80170a:	53                   	push   %ebx
  80170b:	6a 00                	push   $0x0
  80170d:	e8 b9 fa ff ff       	call   8011cb <sys_page_map>
  801712:	89 c3                	mov    %eax,%ebx
  801714:	83 c4 20             	add    $0x20,%esp
  801717:	85 c0                	test   %eax,%eax
  801719:	79 a3                	jns    8016be <dup+0x78>
	sys_page_unmap(0, newfd);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	56                   	push   %esi
  80171f:	6a 00                	push   $0x0
  801721:	e8 eb fa ff ff       	call   801211 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801726:	83 c4 08             	add    $0x8,%esp
  801729:	57                   	push   %edi
  80172a:	6a 00                	push   $0x0
  80172c:	e8 e0 fa ff ff       	call   801211 <sys_page_unmap>
	return r;
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	eb b7                	jmp    8016ed <dup+0xa7>

00801736 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801736:	f3 0f 1e fb          	endbr32 
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 1c             	sub    $0x1c,%esp
  801741:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801744:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801747:	50                   	push   %eax
  801748:	53                   	push   %ebx
  801749:	e8 65 fd ff ff       	call   8014b3 <fd_lookup>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	78 3f                	js     801794 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175b:	50                   	push   %eax
  80175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175f:	ff 30                	pushl  (%eax)
  801761:	e8 a1 fd ff ff       	call   801507 <dev_lookup>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 27                	js     801794 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80176d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801770:	8b 42 08             	mov    0x8(%edx),%eax
  801773:	83 e0 03             	and    $0x3,%eax
  801776:	83 f8 01             	cmp    $0x1,%eax
  801779:	74 1e                	je     801799 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80177b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177e:	8b 40 08             	mov    0x8(%eax),%eax
  801781:	85 c0                	test   %eax,%eax
  801783:	74 35                	je     8017ba <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	ff 75 10             	pushl  0x10(%ebp)
  80178b:	ff 75 0c             	pushl  0xc(%ebp)
  80178e:	52                   	push   %edx
  80178f:	ff d0                	call   *%eax
  801791:	83 c4 10             	add    $0x10,%esp
}
  801794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801797:	c9                   	leave  
  801798:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801799:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  80179e:	8b 40 48             	mov    0x48(%eax),%eax
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	53                   	push   %ebx
  8017a5:	50                   	push   %eax
  8017a6:	68 61 2a 80 00       	push   $0x802a61
  8017ab:	e8 88 ef ff ff       	call   800738 <cprintf>
		return -E_INVAL;
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b8:	eb da                	jmp    801794 <read+0x5e>
		return -E_NOT_SUPP;
  8017ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017bf:	eb d3                	jmp    801794 <read+0x5e>

008017c1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017c1:	f3 0f 1e fb          	endbr32 
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	57                   	push   %edi
  8017c9:	56                   	push   %esi
  8017ca:	53                   	push   %ebx
  8017cb:	83 ec 0c             	sub    $0xc,%esp
  8017ce:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017d9:	eb 02                	jmp    8017dd <readn+0x1c>
  8017db:	01 c3                	add    %eax,%ebx
  8017dd:	39 f3                	cmp    %esi,%ebx
  8017df:	73 21                	jae    801802 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	89 f0                	mov    %esi,%eax
  8017e6:	29 d8                	sub    %ebx,%eax
  8017e8:	50                   	push   %eax
  8017e9:	89 d8                	mov    %ebx,%eax
  8017eb:	03 45 0c             	add    0xc(%ebp),%eax
  8017ee:	50                   	push   %eax
  8017ef:	57                   	push   %edi
  8017f0:	e8 41 ff ff ff       	call   801736 <read>
		if (m < 0)
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	78 04                	js     801800 <readn+0x3f>
			return m;
		if (m == 0)
  8017fc:	75 dd                	jne    8017db <readn+0x1a>
  8017fe:	eb 02                	jmp    801802 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801800:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801802:	89 d8                	mov    %ebx,%eax
  801804:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801807:	5b                   	pop    %ebx
  801808:	5e                   	pop    %esi
  801809:	5f                   	pop    %edi
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    

0080180c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80180c:	f3 0f 1e fb          	endbr32 
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	53                   	push   %ebx
  801814:	83 ec 1c             	sub    $0x1c,%esp
  801817:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181d:	50                   	push   %eax
  80181e:	53                   	push   %ebx
  80181f:	e8 8f fc ff ff       	call   8014b3 <fd_lookup>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	85 c0                	test   %eax,%eax
  801829:	78 3a                	js     801865 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182b:	83 ec 08             	sub    $0x8,%esp
  80182e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801831:	50                   	push   %eax
  801832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801835:	ff 30                	pushl  (%eax)
  801837:	e8 cb fc ff ff       	call   801507 <dev_lookup>
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 22                	js     801865 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801846:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80184a:	74 1e                	je     80186a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80184c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184f:	8b 52 0c             	mov    0xc(%edx),%edx
  801852:	85 d2                	test   %edx,%edx
  801854:	74 35                	je     80188b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801856:	83 ec 04             	sub    $0x4,%esp
  801859:	ff 75 10             	pushl  0x10(%ebp)
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	ff d2                	call   *%edx
  801862:	83 c4 10             	add    $0x10,%esp
}
  801865:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801868:	c9                   	leave  
  801869:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80186a:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  80186f:	8b 40 48             	mov    0x48(%eax),%eax
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	53                   	push   %ebx
  801876:	50                   	push   %eax
  801877:	68 7d 2a 80 00       	push   $0x802a7d
  80187c:	e8 b7 ee ff ff       	call   800738 <cprintf>
		return -E_INVAL;
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801889:	eb da                	jmp    801865 <write+0x59>
		return -E_NOT_SUPP;
  80188b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801890:	eb d3                	jmp    801865 <write+0x59>

00801892 <seek>:

int
seek(int fdnum, off_t offset)
{
  801892:	f3 0f 1e fb          	endbr32 
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 08             	pushl  0x8(%ebp)
  8018a3:	e8 0b fc ff ff       	call   8014b3 <fd_lookup>
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 0e                	js     8018bd <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018bf:	f3 0f 1e fb          	endbr32 
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	53                   	push   %ebx
  8018c7:	83 ec 1c             	sub    $0x1c,%esp
  8018ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d0:	50                   	push   %eax
  8018d1:	53                   	push   %ebx
  8018d2:	e8 dc fb ff ff       	call   8014b3 <fd_lookup>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	78 37                	js     801915 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e4:	50                   	push   %eax
  8018e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e8:	ff 30                	pushl  (%eax)
  8018ea:	e8 18 fc ff ff       	call   801507 <dev_lookup>
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 1f                	js     801915 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018fd:	74 1b                	je     80191a <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801902:	8b 52 18             	mov    0x18(%edx),%edx
  801905:	85 d2                	test   %edx,%edx
  801907:	74 32                	je     80193b <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801909:	83 ec 08             	sub    $0x8,%esp
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	50                   	push   %eax
  801910:	ff d2                	call   *%edx
  801912:	83 c4 10             	add    $0x10,%esp
}
  801915:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801918:	c9                   	leave  
  801919:	c3                   	ret    
			thisenv->env_id, fdnum);
  80191a:	a1 b0 40 80 00       	mov    0x8040b0,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80191f:	8b 40 48             	mov    0x48(%eax),%eax
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	53                   	push   %ebx
  801926:	50                   	push   %eax
  801927:	68 40 2a 80 00       	push   $0x802a40
  80192c:	e8 07 ee ff ff       	call   800738 <cprintf>
		return -E_INVAL;
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801939:	eb da                	jmp    801915 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80193b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801940:	eb d3                	jmp    801915 <ftruncate+0x56>

00801942 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801942:	f3 0f 1e fb          	endbr32 
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	53                   	push   %ebx
  80194a:	83 ec 1c             	sub    $0x1c,%esp
  80194d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801950:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801953:	50                   	push   %eax
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	e8 57 fb ff ff       	call   8014b3 <fd_lookup>
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 4b                	js     8019ae <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801963:	83 ec 08             	sub    $0x8,%esp
  801966:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801969:	50                   	push   %eax
  80196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196d:	ff 30                	pushl  (%eax)
  80196f:	e8 93 fb ff ff       	call   801507 <dev_lookup>
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	85 c0                	test   %eax,%eax
  801979:	78 33                	js     8019ae <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801982:	74 2f                	je     8019b3 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801984:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801987:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80198e:	00 00 00 
	stat->st_isdir = 0;
  801991:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801998:	00 00 00 
	stat->st_dev = dev;
  80199b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019a1:	83 ec 08             	sub    $0x8,%esp
  8019a4:	53                   	push   %ebx
  8019a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a8:	ff 50 14             	call   *0x14(%eax)
  8019ab:	83 c4 10             	add    $0x10,%esp
}
  8019ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    
		return -E_NOT_SUPP;
  8019b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b8:	eb f4                	jmp    8019ae <fstat+0x6c>

008019ba <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019ba:	f3 0f 1e fb          	endbr32 
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	56                   	push   %esi
  8019c2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	6a 00                	push   $0x0
  8019c8:	ff 75 08             	pushl  0x8(%ebp)
  8019cb:	e8 fb 01 00 00       	call   801bcb <open>
  8019d0:	89 c3                	mov    %eax,%ebx
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	78 1b                	js     8019f4 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8019d9:	83 ec 08             	sub    $0x8,%esp
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	50                   	push   %eax
  8019e0:	e8 5d ff ff ff       	call   801942 <fstat>
  8019e5:	89 c6                	mov    %eax,%esi
	close(fd);
  8019e7:	89 1c 24             	mov    %ebx,(%esp)
  8019ea:	e8 fd fb ff ff       	call   8015ec <close>
	return r;
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	89 f3                	mov    %esi,%ebx
}
  8019f4:	89 d8                	mov    %ebx,%eax
  8019f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5e                   	pop    %esi
  8019fb:	5d                   	pop    %ebp
  8019fc:	c3                   	ret    

008019fd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	56                   	push   %esi
  801a01:	53                   	push   %ebx
  801a02:	89 c6                	mov    %eax,%esi
  801a04:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a06:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  801a0d:	74 27                	je     801a36 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a0f:	6a 07                	push   $0x7
  801a11:	68 00 50 80 00       	push   $0x805000
  801a16:	56                   	push   %esi
  801a17:	ff 35 ac 40 80 00    	pushl  0x8040ac
  801a1d:	e8 d6 07 00 00       	call   8021f8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a22:	83 c4 0c             	add    $0xc,%esp
  801a25:	6a 00                	push   $0x0
  801a27:	53                   	push   %ebx
  801a28:	6a 00                	push   $0x0
  801a2a:	e8 44 07 00 00       	call   802173 <ipc_recv>
}
  801a2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a32:	5b                   	pop    %ebx
  801a33:	5e                   	pop    %esi
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a36:	83 ec 0c             	sub    $0xc,%esp
  801a39:	6a 01                	push   $0x1
  801a3b:	e8 10 08 00 00       	call   802250 <ipc_find_env>
  801a40:	a3 ac 40 80 00       	mov    %eax,0x8040ac
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	eb c5                	jmp    801a0f <fsipc+0x12>

00801a4a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a4a:	f3 0f 1e fb          	endbr32 
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a62:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a67:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6c:	b8 02 00 00 00       	mov    $0x2,%eax
  801a71:	e8 87 ff ff ff       	call   8019fd <fsipc>
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <devfile_flush>:
{
  801a78:	f3 0f 1e fb          	endbr32 
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	8b 40 0c             	mov    0xc(%eax),%eax
  801a88:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a92:	b8 06 00 00 00       	mov    $0x6,%eax
  801a97:	e8 61 ff ff ff       	call   8019fd <fsipc>
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <devfile_stat>:
{
  801a9e:	f3 0f 1e fb          	endbr32 
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	53                   	push   %ebx
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  801abc:	b8 05 00 00 00       	mov    $0x5,%eax
  801ac1:	e8 37 ff ff ff       	call   8019fd <fsipc>
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 2c                	js     801af6 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801aca:	83 ec 08             	sub    $0x8,%esp
  801acd:	68 00 50 80 00       	push   $0x805000
  801ad2:	53                   	push   %ebx
  801ad3:	e8 6a f2 ff ff       	call   800d42 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ad8:	a1 80 50 80 00       	mov    0x805080,%eax
  801add:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ae3:	a1 84 50 80 00       	mov    0x805084,%eax
  801ae8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <devfile_write>:
{
  801afb:	f3 0f 1e fb          	endbr32 
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 0c             	sub    $0xc,%esp
  801b05:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b08:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0b:	8b 52 0c             	mov    0xc(%edx),%edx
  801b0e:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801b14:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b19:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801b1e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801b21:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801b26:	50                   	push   %eax
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	68 08 50 80 00       	push   $0x805008
  801b2f:	e8 c4 f3 ff ff       	call   800ef8 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801b34:	ba 00 00 00 00       	mov    $0x0,%edx
  801b39:	b8 04 00 00 00       	mov    $0x4,%eax
  801b3e:	e8 ba fe ff ff       	call   8019fd <fsipc>
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <devfile_read>:
{
  801b45:	f3 0f 1e fb          	endbr32 
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	56                   	push   %esi
  801b4d:	53                   	push   %ebx
  801b4e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	8b 40 0c             	mov    0xc(%eax),%eax
  801b57:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b5c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b62:	ba 00 00 00 00       	mov    $0x0,%edx
  801b67:	b8 03 00 00 00       	mov    $0x3,%eax
  801b6c:	e8 8c fe ff ff       	call   8019fd <fsipc>
  801b71:	89 c3                	mov    %eax,%ebx
  801b73:	85 c0                	test   %eax,%eax
  801b75:	78 1f                	js     801b96 <devfile_read+0x51>
	assert(r <= n);
  801b77:	39 f0                	cmp    %esi,%eax
  801b79:	77 24                	ja     801b9f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801b7b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b80:	7f 33                	jg     801bb5 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b82:	83 ec 04             	sub    $0x4,%esp
  801b85:	50                   	push   %eax
  801b86:	68 00 50 80 00       	push   $0x805000
  801b8b:	ff 75 0c             	pushl  0xc(%ebp)
  801b8e:	e8 65 f3 ff ff       	call   800ef8 <memmove>
	return r;
  801b93:	83 c4 10             	add    $0x10,%esp
}
  801b96:	89 d8                	mov    %ebx,%eax
  801b98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5d                   	pop    %ebp
  801b9e:	c3                   	ret    
	assert(r <= n);
  801b9f:	68 ac 2a 80 00       	push   $0x802aac
  801ba4:	68 b3 2a 80 00       	push   $0x802ab3
  801ba9:	6a 7c                	push   $0x7c
  801bab:	68 c8 2a 80 00       	push   $0x802ac8
  801bb0:	e8 9c ea ff ff       	call   800651 <_panic>
	assert(r <= PGSIZE);
  801bb5:	68 d3 2a 80 00       	push   $0x802ad3
  801bba:	68 b3 2a 80 00       	push   $0x802ab3
  801bbf:	6a 7d                	push   $0x7d
  801bc1:	68 c8 2a 80 00       	push   $0x802ac8
  801bc6:	e8 86 ea ff ff       	call   800651 <_panic>

00801bcb <open>:
{
  801bcb:	f3 0f 1e fb          	endbr32 
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 1c             	sub    $0x1c,%esp
  801bd7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bda:	56                   	push   %esi
  801bdb:	e8 1f f1 ff ff       	call   800cff <strlen>
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801be8:	7f 6c                	jg     801c56 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801bea:	83 ec 0c             	sub    $0xc,%esp
  801bed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf0:	50                   	push   %eax
  801bf1:	e8 67 f8 ff ff       	call   80145d <fd_alloc>
  801bf6:	89 c3                	mov    %eax,%ebx
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	78 3c                	js     801c3b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	56                   	push   %esi
  801c03:	68 00 50 80 00       	push   $0x805000
  801c08:	e8 35 f1 ff ff       	call   800d42 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c10:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c18:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1d:	e8 db fd ff ff       	call   8019fd <fsipc>
  801c22:	89 c3                	mov    %eax,%ebx
  801c24:	83 c4 10             	add    $0x10,%esp
  801c27:	85 c0                	test   %eax,%eax
  801c29:	78 19                	js     801c44 <open+0x79>
	return fd2num(fd);
  801c2b:	83 ec 0c             	sub    $0xc,%esp
  801c2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c31:	e8 f8 f7 ff ff       	call   80142e <fd2num>
  801c36:	89 c3                	mov    %eax,%ebx
  801c38:	83 c4 10             	add    $0x10,%esp
}
  801c3b:	89 d8                	mov    %ebx,%eax
  801c3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c40:	5b                   	pop    %ebx
  801c41:	5e                   	pop    %esi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
		fd_close(fd, 0);
  801c44:	83 ec 08             	sub    $0x8,%esp
  801c47:	6a 00                	push   $0x0
  801c49:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4c:	e8 10 f9 ff ff       	call   801561 <fd_close>
		return r;
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	eb e5                	jmp    801c3b <open+0x70>
		return -E_BAD_PATH;
  801c56:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c5b:	eb de                	jmp    801c3b <open+0x70>

00801c5d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c5d:	f3 0f 1e fb          	endbr32 
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c67:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6c:	b8 08 00 00 00       	mov    $0x8,%eax
  801c71:	e8 87 fd ff ff       	call   8019fd <fsipc>
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c78:	f3 0f 1e fb          	endbr32 
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	56                   	push   %esi
  801c80:	53                   	push   %ebx
  801c81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	ff 75 08             	pushl  0x8(%ebp)
  801c8a:	e8 b3 f7 ff ff       	call   801442 <fd2data>
  801c8f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c91:	83 c4 08             	add    $0x8,%esp
  801c94:	68 df 2a 80 00       	push   $0x802adf
  801c99:	53                   	push   %ebx
  801c9a:	e8 a3 f0 ff ff       	call   800d42 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c9f:	8b 46 04             	mov    0x4(%esi),%eax
  801ca2:	2b 06                	sub    (%esi),%eax
  801ca4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801caa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cb1:	00 00 00 
	stat->st_dev = &devpipe;
  801cb4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801cbb:	30 80 00 
	return 0;
}
  801cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc6:	5b                   	pop    %ebx
  801cc7:	5e                   	pop    %esi
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    

00801cca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cca:	f3 0f 1e fb          	endbr32 
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	53                   	push   %ebx
  801cd2:	83 ec 0c             	sub    $0xc,%esp
  801cd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cd8:	53                   	push   %ebx
  801cd9:	6a 00                	push   $0x0
  801cdb:	e8 31 f5 ff ff       	call   801211 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ce0:	89 1c 24             	mov    %ebx,(%esp)
  801ce3:	e8 5a f7 ff ff       	call   801442 <fd2data>
  801ce8:	83 c4 08             	add    $0x8,%esp
  801ceb:	50                   	push   %eax
  801cec:	6a 00                	push   $0x0
  801cee:	e8 1e f5 ff ff       	call   801211 <sys_page_unmap>
}
  801cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <_pipeisclosed>:
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	57                   	push   %edi
  801cfc:	56                   	push   %esi
  801cfd:	53                   	push   %ebx
  801cfe:	83 ec 1c             	sub    $0x1c,%esp
  801d01:	89 c7                	mov    %eax,%edi
  801d03:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d05:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801d0a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	57                   	push   %edi
  801d11:	e8 77 05 00 00       	call   80228d <pageref>
  801d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d19:	89 34 24             	mov    %esi,(%esp)
  801d1c:	e8 6c 05 00 00       	call   80228d <pageref>
		nn = thisenv->env_runs;
  801d21:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  801d27:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	39 cb                	cmp    %ecx,%ebx
  801d2f:	74 1b                	je     801d4c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d31:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d34:	75 cf                	jne    801d05 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d36:	8b 42 58             	mov    0x58(%edx),%eax
  801d39:	6a 01                	push   $0x1
  801d3b:	50                   	push   %eax
  801d3c:	53                   	push   %ebx
  801d3d:	68 e6 2a 80 00       	push   $0x802ae6
  801d42:	e8 f1 e9 ff ff       	call   800738 <cprintf>
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	eb b9                	jmp    801d05 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d4c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d4f:	0f 94 c0             	sete   %al
  801d52:	0f b6 c0             	movzbl %al,%eax
}
  801d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d58:	5b                   	pop    %ebx
  801d59:	5e                   	pop    %esi
  801d5a:	5f                   	pop    %edi
  801d5b:	5d                   	pop    %ebp
  801d5c:	c3                   	ret    

00801d5d <devpipe_write>:
{
  801d5d:	f3 0f 1e fb          	endbr32 
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	57                   	push   %edi
  801d65:	56                   	push   %esi
  801d66:	53                   	push   %ebx
  801d67:	83 ec 28             	sub    $0x28,%esp
  801d6a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d6d:	56                   	push   %esi
  801d6e:	e8 cf f6 ff ff       	call   801442 <fd2data>
  801d73:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	bf 00 00 00 00       	mov    $0x0,%edi
  801d7d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d80:	74 4f                	je     801dd1 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d82:	8b 43 04             	mov    0x4(%ebx),%eax
  801d85:	8b 0b                	mov    (%ebx),%ecx
  801d87:	8d 51 20             	lea    0x20(%ecx),%edx
  801d8a:	39 d0                	cmp    %edx,%eax
  801d8c:	72 14                	jb     801da2 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d8e:	89 da                	mov    %ebx,%edx
  801d90:	89 f0                	mov    %esi,%eax
  801d92:	e8 61 ff ff ff       	call   801cf8 <_pipeisclosed>
  801d97:	85 c0                	test   %eax,%eax
  801d99:	75 3b                	jne    801dd6 <devpipe_write+0x79>
			sys_yield();
  801d9b:	e8 c1 f3 ff ff       	call   801161 <sys_yield>
  801da0:	eb e0                	jmp    801d82 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801da5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801da9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dac:	89 c2                	mov    %eax,%edx
  801dae:	c1 fa 1f             	sar    $0x1f,%edx
  801db1:	89 d1                	mov    %edx,%ecx
  801db3:	c1 e9 1b             	shr    $0x1b,%ecx
  801db6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801db9:	83 e2 1f             	and    $0x1f,%edx
  801dbc:	29 ca                	sub    %ecx,%edx
  801dbe:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dc2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dc6:	83 c0 01             	add    $0x1,%eax
  801dc9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dcc:	83 c7 01             	add    $0x1,%edi
  801dcf:	eb ac                	jmp    801d7d <devpipe_write+0x20>
	return i;
  801dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd4:	eb 05                	jmp    801ddb <devpipe_write+0x7e>
				return 0;
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dde:	5b                   	pop    %ebx
  801ddf:	5e                   	pop    %esi
  801de0:	5f                   	pop    %edi
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <devpipe_read>:
{
  801de3:	f3 0f 1e fb          	endbr32 
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	57                   	push   %edi
  801deb:	56                   	push   %esi
  801dec:	53                   	push   %ebx
  801ded:	83 ec 18             	sub    $0x18,%esp
  801df0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801df3:	57                   	push   %edi
  801df4:	e8 49 f6 ff ff       	call   801442 <fd2data>
  801df9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	be 00 00 00 00       	mov    $0x0,%esi
  801e03:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e06:	75 14                	jne    801e1c <devpipe_read+0x39>
	return i;
  801e08:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0b:	eb 02                	jmp    801e0f <devpipe_read+0x2c>
				return i;
  801e0d:	89 f0                	mov    %esi,%eax
}
  801e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5e                   	pop    %esi
  801e14:	5f                   	pop    %edi
  801e15:	5d                   	pop    %ebp
  801e16:	c3                   	ret    
			sys_yield();
  801e17:	e8 45 f3 ff ff       	call   801161 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e1c:	8b 03                	mov    (%ebx),%eax
  801e1e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e21:	75 18                	jne    801e3b <devpipe_read+0x58>
			if (i > 0)
  801e23:	85 f6                	test   %esi,%esi
  801e25:	75 e6                	jne    801e0d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801e27:	89 da                	mov    %ebx,%edx
  801e29:	89 f8                	mov    %edi,%eax
  801e2b:	e8 c8 fe ff ff       	call   801cf8 <_pipeisclosed>
  801e30:	85 c0                	test   %eax,%eax
  801e32:	74 e3                	je     801e17 <devpipe_read+0x34>
				return 0;
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
  801e39:	eb d4                	jmp    801e0f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e3b:	99                   	cltd   
  801e3c:	c1 ea 1b             	shr    $0x1b,%edx
  801e3f:	01 d0                	add    %edx,%eax
  801e41:	83 e0 1f             	and    $0x1f,%eax
  801e44:	29 d0                	sub    %edx,%eax
  801e46:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e4e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e51:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e54:	83 c6 01             	add    $0x1,%esi
  801e57:	eb aa                	jmp    801e03 <devpipe_read+0x20>

00801e59 <pipe>:
{
  801e59:	f3 0f 1e fb          	endbr32 
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
  801e62:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e68:	50                   	push   %eax
  801e69:	e8 ef f5 ff ff       	call   80145d <fd_alloc>
  801e6e:	89 c3                	mov    %eax,%ebx
  801e70:	83 c4 10             	add    $0x10,%esp
  801e73:	85 c0                	test   %eax,%eax
  801e75:	0f 88 23 01 00 00    	js     801f9e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	68 07 04 00 00       	push   $0x407
  801e83:	ff 75 f4             	pushl  -0xc(%ebp)
  801e86:	6a 00                	push   $0x0
  801e88:	e8 f7 f2 ff ff       	call   801184 <sys_page_alloc>
  801e8d:	89 c3                	mov    %eax,%ebx
  801e8f:	83 c4 10             	add    $0x10,%esp
  801e92:	85 c0                	test   %eax,%eax
  801e94:	0f 88 04 01 00 00    	js     801f9e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea0:	50                   	push   %eax
  801ea1:	e8 b7 f5 ff ff       	call   80145d <fd_alloc>
  801ea6:	89 c3                	mov    %eax,%ebx
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	85 c0                	test   %eax,%eax
  801ead:	0f 88 db 00 00 00    	js     801f8e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb3:	83 ec 04             	sub    $0x4,%esp
  801eb6:	68 07 04 00 00       	push   $0x407
  801ebb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ebe:	6a 00                	push   $0x0
  801ec0:	e8 bf f2 ff ff       	call   801184 <sys_page_alloc>
  801ec5:	89 c3                	mov    %eax,%ebx
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	0f 88 bc 00 00 00    	js     801f8e <pipe+0x135>
	va = fd2data(fd0);
  801ed2:	83 ec 0c             	sub    $0xc,%esp
  801ed5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed8:	e8 65 f5 ff ff       	call   801442 <fd2data>
  801edd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801edf:	83 c4 0c             	add    $0xc,%esp
  801ee2:	68 07 04 00 00       	push   $0x407
  801ee7:	50                   	push   %eax
  801ee8:	6a 00                	push   $0x0
  801eea:	e8 95 f2 ff ff       	call   801184 <sys_page_alloc>
  801eef:	89 c3                	mov    %eax,%ebx
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	0f 88 82 00 00 00    	js     801f7e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efc:	83 ec 0c             	sub    $0xc,%esp
  801eff:	ff 75 f0             	pushl  -0x10(%ebp)
  801f02:	e8 3b f5 ff ff       	call   801442 <fd2data>
  801f07:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f0e:	50                   	push   %eax
  801f0f:	6a 00                	push   $0x0
  801f11:	56                   	push   %esi
  801f12:	6a 00                	push   $0x0
  801f14:	e8 b2 f2 ff ff       	call   8011cb <sys_page_map>
  801f19:	89 c3                	mov    %eax,%ebx
  801f1b:	83 c4 20             	add    $0x20,%esp
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	78 4e                	js     801f70 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801f22:	a1 20 30 80 00       	mov    0x803020,%eax
  801f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f39:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4b:	e8 de f4 ff ff       	call   80142e <fd2num>
  801f50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f53:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f55:	83 c4 04             	add    $0x4,%esp
  801f58:	ff 75 f0             	pushl  -0x10(%ebp)
  801f5b:	e8 ce f4 ff ff       	call   80142e <fd2num>
  801f60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f63:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f6e:	eb 2e                	jmp    801f9e <pipe+0x145>
	sys_page_unmap(0, va);
  801f70:	83 ec 08             	sub    $0x8,%esp
  801f73:	56                   	push   %esi
  801f74:	6a 00                	push   $0x0
  801f76:	e8 96 f2 ff ff       	call   801211 <sys_page_unmap>
  801f7b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f7e:	83 ec 08             	sub    $0x8,%esp
  801f81:	ff 75 f0             	pushl  -0x10(%ebp)
  801f84:	6a 00                	push   $0x0
  801f86:	e8 86 f2 ff ff       	call   801211 <sys_page_unmap>
  801f8b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f8e:	83 ec 08             	sub    $0x8,%esp
  801f91:	ff 75 f4             	pushl  -0xc(%ebp)
  801f94:	6a 00                	push   $0x0
  801f96:	e8 76 f2 ff ff       	call   801211 <sys_page_unmap>
  801f9b:	83 c4 10             	add    $0x10,%esp
}
  801f9e:	89 d8                	mov    %ebx,%eax
  801fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    

00801fa7 <pipeisclosed>:
{
  801fa7:	f3 0f 1e fb          	endbr32 
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb4:	50                   	push   %eax
  801fb5:	ff 75 08             	pushl  0x8(%ebp)
  801fb8:	e8 f6 f4 ff ff       	call   8014b3 <fd_lookup>
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	78 18                	js     801fdc <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fca:	e8 73 f4 ff ff       	call   801442 <fd2data>
  801fcf:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	e8 1f fd ff ff       	call   801cf8 <_pipeisclosed>
  801fd9:	83 c4 10             	add    $0x10,%esp
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fde:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe7:	c3                   	ret    

00801fe8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fe8:	f3 0f 1e fb          	endbr32 
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ff2:	68 fe 2a 80 00       	push   $0x802afe
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	e8 43 ed ff ff       	call   800d42 <strcpy>
	return 0;
}
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <devcons_write>:
{
  802006:	f3 0f 1e fb          	endbr32 
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	57                   	push   %edi
  80200e:	56                   	push   %esi
  80200f:	53                   	push   %ebx
  802010:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802016:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80201b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802021:	3b 75 10             	cmp    0x10(%ebp),%esi
  802024:	73 31                	jae    802057 <devcons_write+0x51>
		m = n - tot;
  802026:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802029:	29 f3                	sub    %esi,%ebx
  80202b:	83 fb 7f             	cmp    $0x7f,%ebx
  80202e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802033:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802036:	83 ec 04             	sub    $0x4,%esp
  802039:	53                   	push   %ebx
  80203a:	89 f0                	mov    %esi,%eax
  80203c:	03 45 0c             	add    0xc(%ebp),%eax
  80203f:	50                   	push   %eax
  802040:	57                   	push   %edi
  802041:	e8 b2 ee ff ff       	call   800ef8 <memmove>
		sys_cputs(buf, m);
  802046:	83 c4 08             	add    $0x8,%esp
  802049:	53                   	push   %ebx
  80204a:	57                   	push   %edi
  80204b:	e8 64 f0 ff ff       	call   8010b4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802050:	01 de                	add    %ebx,%esi
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	eb ca                	jmp    802021 <devcons_write+0x1b>
}
  802057:	89 f0                	mov    %esi,%eax
  802059:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80205c:	5b                   	pop    %ebx
  80205d:	5e                   	pop    %esi
  80205e:	5f                   	pop    %edi
  80205f:	5d                   	pop    %ebp
  802060:	c3                   	ret    

00802061 <devcons_read>:
{
  802061:	f3 0f 1e fb          	endbr32 
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 08             	sub    $0x8,%esp
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802070:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802074:	74 21                	je     802097 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802076:	e8 5b f0 ff ff       	call   8010d6 <sys_cgetc>
  80207b:	85 c0                	test   %eax,%eax
  80207d:	75 07                	jne    802086 <devcons_read+0x25>
		sys_yield();
  80207f:	e8 dd f0 ff ff       	call   801161 <sys_yield>
  802084:	eb f0                	jmp    802076 <devcons_read+0x15>
	if (c < 0)
  802086:	78 0f                	js     802097 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802088:	83 f8 04             	cmp    $0x4,%eax
  80208b:	74 0c                	je     802099 <devcons_read+0x38>
	*(char*)vbuf = c;
  80208d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802090:	88 02                	mov    %al,(%edx)
	return 1;
  802092:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    
		return 0;
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	eb f7                	jmp    802097 <devcons_read+0x36>

008020a0 <cputchar>:
{
  8020a0:	f3 0f 1e fb          	endbr32 
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020b0:	6a 01                	push   $0x1
  8020b2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020b5:	50                   	push   %eax
  8020b6:	e8 f9 ef ff ff       	call   8010b4 <sys_cputs>
}
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <getchar>:
{
  8020c0:	f3 0f 1e fb          	endbr32 
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020ca:	6a 01                	push   $0x1
  8020cc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020cf:	50                   	push   %eax
  8020d0:	6a 00                	push   $0x0
  8020d2:	e8 5f f6 ff ff       	call   801736 <read>
	if (r < 0)
  8020d7:	83 c4 10             	add    $0x10,%esp
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	78 06                	js     8020e4 <getchar+0x24>
	if (r < 1)
  8020de:	74 06                	je     8020e6 <getchar+0x26>
	return c;
  8020e0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    
		return -E_EOF;
  8020e6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020eb:	eb f7                	jmp    8020e4 <getchar+0x24>

008020ed <iscons>:
{
  8020ed:	f3 0f 1e fb          	endbr32 
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fa:	50                   	push   %eax
  8020fb:	ff 75 08             	pushl  0x8(%ebp)
  8020fe:	e8 b0 f3 ff ff       	call   8014b3 <fd_lookup>
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	78 11                	js     80211b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802113:	39 10                	cmp    %edx,(%eax)
  802115:	0f 94 c0             	sete   %al
  802118:	0f b6 c0             	movzbl %al,%eax
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <opencons>:
{
  80211d:	f3 0f 1e fb          	endbr32 
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802127:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212a:	50                   	push   %eax
  80212b:	e8 2d f3 ff ff       	call   80145d <fd_alloc>
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	85 c0                	test   %eax,%eax
  802135:	78 3a                	js     802171 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	68 07 04 00 00       	push   $0x407
  80213f:	ff 75 f4             	pushl  -0xc(%ebp)
  802142:	6a 00                	push   $0x0
  802144:	e8 3b f0 ff ff       	call   801184 <sys_page_alloc>
  802149:	83 c4 10             	add    $0x10,%esp
  80214c:	85 c0                	test   %eax,%eax
  80214e:	78 21                	js     802171 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802153:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802159:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802165:	83 ec 0c             	sub    $0xc,%esp
  802168:	50                   	push   %eax
  802169:	e8 c0 f2 ff ff       	call   80142e <fd2num>
  80216e:	83 c4 10             	add    $0x10,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802173:	f3 0f 1e fb          	endbr32 
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	56                   	push   %esi
  80217b:	53                   	push   %ebx
  80217c:	8b 75 08             	mov    0x8(%ebp),%esi
  80217f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802182:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802185:	85 c0                	test   %eax,%eax
  802187:	74 3d                	je     8021c6 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802189:	83 ec 0c             	sub    $0xc,%esp
  80218c:	50                   	push   %eax
  80218d:	e8 be f1 ff ff       	call   801350 <sys_ipc_recv>
  802192:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802195:	85 f6                	test   %esi,%esi
  802197:	74 0b                	je     8021a4 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802199:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  80219f:	8b 52 74             	mov    0x74(%edx),%edx
  8021a2:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8021a4:	85 db                	test   %ebx,%ebx
  8021a6:	74 0b                	je     8021b3 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8021a8:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  8021ae:	8b 52 78             	mov    0x78(%edx),%edx
  8021b1:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	78 21                	js     8021d8 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8021b7:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8021bc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c2:	5b                   	pop    %ebx
  8021c3:	5e                   	pop    %esi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8021c6:	83 ec 0c             	sub    $0xc,%esp
  8021c9:	68 00 00 c0 ee       	push   $0xeec00000
  8021ce:	e8 7d f1 ff ff       	call   801350 <sys_ipc_recv>
  8021d3:	83 c4 10             	add    $0x10,%esp
  8021d6:	eb bd                	jmp    802195 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8021d8:	85 f6                	test   %esi,%esi
  8021da:	74 10                	je     8021ec <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8021dc:	85 db                	test   %ebx,%ebx
  8021de:	75 df                	jne    8021bf <ipc_recv+0x4c>
  8021e0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021e7:	00 00 00 
  8021ea:	eb d3                	jmp    8021bf <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8021ec:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021f3:	00 00 00 
  8021f6:	eb e4                	jmp    8021dc <ipc_recv+0x69>

008021f8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021f8:	f3 0f 1e fb          	endbr32 
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	57                   	push   %edi
  802200:	56                   	push   %esi
  802201:	53                   	push   %ebx
  802202:	83 ec 0c             	sub    $0xc,%esp
  802205:	8b 7d 08             	mov    0x8(%ebp),%edi
  802208:	8b 75 0c             	mov    0xc(%ebp),%esi
  80220b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80220e:	85 db                	test   %ebx,%ebx
  802210:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802215:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802218:	ff 75 14             	pushl  0x14(%ebp)
  80221b:	53                   	push   %ebx
  80221c:	56                   	push   %esi
  80221d:	57                   	push   %edi
  80221e:	e8 06 f1 ff ff       	call   801329 <sys_ipc_try_send>
  802223:	83 c4 10             	add    $0x10,%esp
  802226:	85 c0                	test   %eax,%eax
  802228:	79 1e                	jns    802248 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80222a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80222d:	75 07                	jne    802236 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80222f:	e8 2d ef ff ff       	call   801161 <sys_yield>
  802234:	eb e2                	jmp    802218 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802236:	50                   	push   %eax
  802237:	68 0a 2b 80 00       	push   $0x802b0a
  80223c:	6a 59                	push   $0x59
  80223e:	68 25 2b 80 00       	push   $0x802b25
  802243:	e8 09 e4 ff ff       	call   800651 <_panic>
	}
}
  802248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5f                   	pop    %edi
  80224e:	5d                   	pop    %ebp
  80224f:	c3                   	ret    

00802250 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802250:	f3 0f 1e fb          	endbr32 
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80225f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802262:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802268:	8b 52 50             	mov    0x50(%edx),%edx
  80226b:	39 ca                	cmp    %ecx,%edx
  80226d:	74 11                	je     802280 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80226f:	83 c0 01             	add    $0x1,%eax
  802272:	3d 00 04 00 00       	cmp    $0x400,%eax
  802277:	75 e6                	jne    80225f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	eb 0b                	jmp    80228b <ipc_find_env+0x3b>
			return envs[i].env_id;
  802280:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802283:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802288:	8b 40 48             	mov    0x48(%eax),%eax
}
  80228b:	5d                   	pop    %ebp
  80228c:	c3                   	ret    

0080228d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80228d:	f3 0f 1e fb          	endbr32 
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802297:	89 c2                	mov    %eax,%edx
  802299:	c1 ea 16             	shr    $0x16,%edx
  80229c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022a3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022a8:	f6 c1 01             	test   $0x1,%cl
  8022ab:	74 1c                	je     8022c9 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8022ad:	c1 e8 0c             	shr    $0xc,%eax
  8022b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022b7:	a8 01                	test   $0x1,%al
  8022b9:	74 0e                	je     8022c9 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022bb:	c1 e8 0c             	shr    $0xc,%eax
  8022be:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022c5:	ef 
  8022c6:	0f b7 d2             	movzwl %dx,%edx
}
  8022c9:	89 d0                	mov    %edx,%eax
  8022cb:	5d                   	pop    %ebp
  8022cc:	c3                   	ret    
  8022cd:	66 90                	xchg   %ax,%ax
  8022cf:	90                   	nop

008022d0 <__udivdi3>:
  8022d0:	f3 0f 1e fb          	endbr32 
  8022d4:	55                   	push   %ebp
  8022d5:	57                   	push   %edi
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
  8022d8:	83 ec 1c             	sub    $0x1c,%esp
  8022db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022eb:	85 d2                	test   %edx,%edx
  8022ed:	75 19                	jne    802308 <__udivdi3+0x38>
  8022ef:	39 f3                	cmp    %esi,%ebx
  8022f1:	76 4d                	jbe    802340 <__udivdi3+0x70>
  8022f3:	31 ff                	xor    %edi,%edi
  8022f5:	89 e8                	mov    %ebp,%eax
  8022f7:	89 f2                	mov    %esi,%edx
  8022f9:	f7 f3                	div    %ebx
  8022fb:	89 fa                	mov    %edi,%edx
  8022fd:	83 c4 1c             	add    $0x1c,%esp
  802300:	5b                   	pop    %ebx
  802301:	5e                   	pop    %esi
  802302:	5f                   	pop    %edi
  802303:	5d                   	pop    %ebp
  802304:	c3                   	ret    
  802305:	8d 76 00             	lea    0x0(%esi),%esi
  802308:	39 f2                	cmp    %esi,%edx
  80230a:	76 14                	jbe    802320 <__udivdi3+0x50>
  80230c:	31 ff                	xor    %edi,%edi
  80230e:	31 c0                	xor    %eax,%eax
  802310:	89 fa                	mov    %edi,%edx
  802312:	83 c4 1c             	add    $0x1c,%esp
  802315:	5b                   	pop    %ebx
  802316:	5e                   	pop    %esi
  802317:	5f                   	pop    %edi
  802318:	5d                   	pop    %ebp
  802319:	c3                   	ret    
  80231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802320:	0f bd fa             	bsr    %edx,%edi
  802323:	83 f7 1f             	xor    $0x1f,%edi
  802326:	75 48                	jne    802370 <__udivdi3+0xa0>
  802328:	39 f2                	cmp    %esi,%edx
  80232a:	72 06                	jb     802332 <__udivdi3+0x62>
  80232c:	31 c0                	xor    %eax,%eax
  80232e:	39 eb                	cmp    %ebp,%ebx
  802330:	77 de                	ja     802310 <__udivdi3+0x40>
  802332:	b8 01 00 00 00       	mov    $0x1,%eax
  802337:	eb d7                	jmp    802310 <__udivdi3+0x40>
  802339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802340:	89 d9                	mov    %ebx,%ecx
  802342:	85 db                	test   %ebx,%ebx
  802344:	75 0b                	jne    802351 <__udivdi3+0x81>
  802346:	b8 01 00 00 00       	mov    $0x1,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	f7 f3                	div    %ebx
  80234f:	89 c1                	mov    %eax,%ecx
  802351:	31 d2                	xor    %edx,%edx
  802353:	89 f0                	mov    %esi,%eax
  802355:	f7 f1                	div    %ecx
  802357:	89 c6                	mov    %eax,%esi
  802359:	89 e8                	mov    %ebp,%eax
  80235b:	89 f7                	mov    %esi,%edi
  80235d:	f7 f1                	div    %ecx
  80235f:	89 fa                	mov    %edi,%edx
  802361:	83 c4 1c             	add    $0x1c,%esp
  802364:	5b                   	pop    %ebx
  802365:	5e                   	pop    %esi
  802366:	5f                   	pop    %edi
  802367:	5d                   	pop    %ebp
  802368:	c3                   	ret    
  802369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802370:	89 f9                	mov    %edi,%ecx
  802372:	b8 20 00 00 00       	mov    $0x20,%eax
  802377:	29 f8                	sub    %edi,%eax
  802379:	d3 e2                	shl    %cl,%edx
  80237b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	89 da                	mov    %ebx,%edx
  802383:	d3 ea                	shr    %cl,%edx
  802385:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802389:	09 d1                	or     %edx,%ecx
  80238b:	89 f2                	mov    %esi,%edx
  80238d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802391:	89 f9                	mov    %edi,%ecx
  802393:	d3 e3                	shl    %cl,%ebx
  802395:	89 c1                	mov    %eax,%ecx
  802397:	d3 ea                	shr    %cl,%edx
  802399:	89 f9                	mov    %edi,%ecx
  80239b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80239f:	89 eb                	mov    %ebp,%ebx
  8023a1:	d3 e6                	shl    %cl,%esi
  8023a3:	89 c1                	mov    %eax,%ecx
  8023a5:	d3 eb                	shr    %cl,%ebx
  8023a7:	09 de                	or     %ebx,%esi
  8023a9:	89 f0                	mov    %esi,%eax
  8023ab:	f7 74 24 08          	divl   0x8(%esp)
  8023af:	89 d6                	mov    %edx,%esi
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	f7 64 24 0c          	mull   0xc(%esp)
  8023b7:	39 d6                	cmp    %edx,%esi
  8023b9:	72 15                	jb     8023d0 <__udivdi3+0x100>
  8023bb:	89 f9                	mov    %edi,%ecx
  8023bd:	d3 e5                	shl    %cl,%ebp
  8023bf:	39 c5                	cmp    %eax,%ebp
  8023c1:	73 04                	jae    8023c7 <__udivdi3+0xf7>
  8023c3:	39 d6                	cmp    %edx,%esi
  8023c5:	74 09                	je     8023d0 <__udivdi3+0x100>
  8023c7:	89 d8                	mov    %ebx,%eax
  8023c9:	31 ff                	xor    %edi,%edi
  8023cb:	e9 40 ff ff ff       	jmp    802310 <__udivdi3+0x40>
  8023d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023d3:	31 ff                	xor    %edi,%edi
  8023d5:	e9 36 ff ff ff       	jmp    802310 <__udivdi3+0x40>
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__umoddi3>:
  8023e0:	f3 0f 1e fb          	endbr32 
  8023e4:	55                   	push   %ebp
  8023e5:	57                   	push   %edi
  8023e6:	56                   	push   %esi
  8023e7:	53                   	push   %ebx
  8023e8:	83 ec 1c             	sub    $0x1c,%esp
  8023eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	75 19                	jne    802418 <__umoddi3+0x38>
  8023ff:	39 df                	cmp    %ebx,%edi
  802401:	76 5d                	jbe    802460 <__umoddi3+0x80>
  802403:	89 f0                	mov    %esi,%eax
  802405:	89 da                	mov    %ebx,%edx
  802407:	f7 f7                	div    %edi
  802409:	89 d0                	mov    %edx,%eax
  80240b:	31 d2                	xor    %edx,%edx
  80240d:	83 c4 1c             	add    $0x1c,%esp
  802410:	5b                   	pop    %ebx
  802411:	5e                   	pop    %esi
  802412:	5f                   	pop    %edi
  802413:	5d                   	pop    %ebp
  802414:	c3                   	ret    
  802415:	8d 76 00             	lea    0x0(%esi),%esi
  802418:	89 f2                	mov    %esi,%edx
  80241a:	39 d8                	cmp    %ebx,%eax
  80241c:	76 12                	jbe    802430 <__umoddi3+0x50>
  80241e:	89 f0                	mov    %esi,%eax
  802420:	89 da                	mov    %ebx,%edx
  802422:	83 c4 1c             	add    $0x1c,%esp
  802425:	5b                   	pop    %ebx
  802426:	5e                   	pop    %esi
  802427:	5f                   	pop    %edi
  802428:	5d                   	pop    %ebp
  802429:	c3                   	ret    
  80242a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802430:	0f bd e8             	bsr    %eax,%ebp
  802433:	83 f5 1f             	xor    $0x1f,%ebp
  802436:	75 50                	jne    802488 <__umoddi3+0xa8>
  802438:	39 d8                	cmp    %ebx,%eax
  80243a:	0f 82 e0 00 00 00    	jb     802520 <__umoddi3+0x140>
  802440:	89 d9                	mov    %ebx,%ecx
  802442:	39 f7                	cmp    %esi,%edi
  802444:	0f 86 d6 00 00 00    	jbe    802520 <__umoddi3+0x140>
  80244a:	89 d0                	mov    %edx,%eax
  80244c:	89 ca                	mov    %ecx,%edx
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	89 fd                	mov    %edi,%ebp
  802462:	85 ff                	test   %edi,%edi
  802464:	75 0b                	jne    802471 <__umoddi3+0x91>
  802466:	b8 01 00 00 00       	mov    $0x1,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	f7 f7                	div    %edi
  80246f:	89 c5                	mov    %eax,%ebp
  802471:	89 d8                	mov    %ebx,%eax
  802473:	31 d2                	xor    %edx,%edx
  802475:	f7 f5                	div    %ebp
  802477:	89 f0                	mov    %esi,%eax
  802479:	f7 f5                	div    %ebp
  80247b:	89 d0                	mov    %edx,%eax
  80247d:	31 d2                	xor    %edx,%edx
  80247f:	eb 8c                	jmp    80240d <__umoddi3+0x2d>
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 e9                	mov    %ebp,%ecx
  80248a:	ba 20 00 00 00       	mov    $0x20,%edx
  80248f:	29 ea                	sub    %ebp,%edx
  802491:	d3 e0                	shl    %cl,%eax
  802493:	89 44 24 08          	mov    %eax,0x8(%esp)
  802497:	89 d1                	mov    %edx,%ecx
  802499:	89 f8                	mov    %edi,%eax
  80249b:	d3 e8                	shr    %cl,%eax
  80249d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024a9:	09 c1                	or     %eax,%ecx
  8024ab:	89 d8                	mov    %ebx,%eax
  8024ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024b1:	89 e9                	mov    %ebp,%ecx
  8024b3:	d3 e7                	shl    %cl,%edi
  8024b5:	89 d1                	mov    %edx,%ecx
  8024b7:	d3 e8                	shr    %cl,%eax
  8024b9:	89 e9                	mov    %ebp,%ecx
  8024bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024bf:	d3 e3                	shl    %cl,%ebx
  8024c1:	89 c7                	mov    %eax,%edi
  8024c3:	89 d1                	mov    %edx,%ecx
  8024c5:	89 f0                	mov    %esi,%eax
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	89 fa                	mov    %edi,%edx
  8024cd:	d3 e6                	shl    %cl,%esi
  8024cf:	09 d8                	or     %ebx,%eax
  8024d1:	f7 74 24 08          	divl   0x8(%esp)
  8024d5:	89 d1                	mov    %edx,%ecx
  8024d7:	89 f3                	mov    %esi,%ebx
  8024d9:	f7 64 24 0c          	mull   0xc(%esp)
  8024dd:	89 c6                	mov    %eax,%esi
  8024df:	89 d7                	mov    %edx,%edi
  8024e1:	39 d1                	cmp    %edx,%ecx
  8024e3:	72 06                	jb     8024eb <__umoddi3+0x10b>
  8024e5:	75 10                	jne    8024f7 <__umoddi3+0x117>
  8024e7:	39 c3                	cmp    %eax,%ebx
  8024e9:	73 0c                	jae    8024f7 <__umoddi3+0x117>
  8024eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024f3:	89 d7                	mov    %edx,%edi
  8024f5:	89 c6                	mov    %eax,%esi
  8024f7:	89 ca                	mov    %ecx,%edx
  8024f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024fe:	29 f3                	sub    %esi,%ebx
  802500:	19 fa                	sbb    %edi,%edx
  802502:	89 d0                	mov    %edx,%eax
  802504:	d3 e0                	shl    %cl,%eax
  802506:	89 e9                	mov    %ebp,%ecx
  802508:	d3 eb                	shr    %cl,%ebx
  80250a:	d3 ea                	shr    %cl,%edx
  80250c:	09 d8                	or     %ebx,%eax
  80250e:	83 c4 1c             	add    $0x1c,%esp
  802511:	5b                   	pop    %ebx
  802512:	5e                   	pop    %esi
  802513:	5f                   	pop    %edi
  802514:	5d                   	pop    %ebp
  802515:	c3                   	ret    
  802516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80251d:	8d 76 00             	lea    0x0(%esi),%esi
  802520:	29 fe                	sub    %edi,%esi
  802522:	19 c3                	sbb    %eax,%ebx
  802524:	89 f2                	mov    %esi,%edx
  802526:	89 d9                	mov    %ebx,%ecx
  802528:	e9 1d ff ff ff       	jmp    80244a <__umoddi3+0x6a>
