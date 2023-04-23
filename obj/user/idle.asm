
obj/user/idle.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  80003d:	c7 05 00 30 80 00 80 	movl   $0x802480,0x803000
  800044:	24 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800047:	e8 17 01 00 00       	call   800163 <sys_yield>
  80004c:	eb f9                	jmp    800047 <umain+0x14>

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	f3 0f 1e fb          	endbr32 
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005d:	e8 de 00 00 00       	call   800140 <sys_getenvid>
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800074:	85 db                	test   %ebx,%ebx
  800076:	7e 07                	jle    80007f <libmain+0x31>
		binaryname = argv[0];
  800078:	8b 06                	mov    (%esi),%eax
  80007a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	e8 aa ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800089:	e8 0a 00 00 00       	call   800098 <exit>
}
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	f3 0f 1e fb          	endbr32 
  80009c:	55                   	push   %ebp
  80009d:	89 e5                	mov    %esp,%ebp
  80009f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a2:	e8 93 05 00 00       	call   80063a <close_all>
	sys_env_destroy(0);
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	6a 00                	push   $0x0
  8000ac:	e8 4a 00 00 00       	call   8000fb <sys_env_destroy>
}
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	c9                   	leave  
  8000b5:	c3                   	ret    

008000b6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b6:	f3 0f 1e fb          	endbr32 
  8000ba:	55                   	push   %ebp
  8000bb:	89 e5                	mov    %esp,%ebp
  8000bd:	57                   	push   %edi
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000cb:	89 c3                	mov    %eax,%ebx
  8000cd:	89 c7                	mov    %eax,%edi
  8000cf:	89 c6                	mov    %eax,%esi
  8000d1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d3:	5b                   	pop    %ebx
  8000d4:	5e                   	pop    %esi
  8000d5:	5f                   	pop    %edi
  8000d6:	5d                   	pop    %ebp
  8000d7:	c3                   	ret    

008000d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d8:	f3 0f 1e fb          	endbr32 
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ec:	89 d1                	mov    %edx,%ecx
  8000ee:	89 d3                	mov    %edx,%ebx
  8000f0:	89 d7                	mov    %edx,%edi
  8000f2:	89 d6                	mov    %edx,%esi
  8000f4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f6:	5b                   	pop    %ebx
  8000f7:	5e                   	pop    %esi
  8000f8:	5f                   	pop    %edi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000fb:	f3 0f 1e fb          	endbr32 
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	57                   	push   %edi
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800108:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010d:	8b 55 08             	mov    0x8(%ebp),%edx
  800110:	b8 03 00 00 00       	mov    $0x3,%eax
  800115:	89 cb                	mov    %ecx,%ebx
  800117:	89 cf                	mov    %ecx,%edi
  800119:	89 ce                	mov    %ecx,%esi
  80011b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80011d:	85 c0                	test   %eax,%eax
  80011f:	7f 08                	jg     800129 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800121:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800124:	5b                   	pop    %ebx
  800125:	5e                   	pop    %esi
  800126:	5f                   	pop    %edi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800129:	83 ec 0c             	sub    $0xc,%esp
  80012c:	50                   	push   %eax
  80012d:	6a 03                	push   $0x3
  80012f:	68 8f 24 80 00       	push   $0x80248f
  800134:	6a 23                	push   $0x23
  800136:	68 ac 24 80 00       	push   $0x8024ac
  80013b:	e8 08 15 00 00       	call   801648 <_panic>

00800140 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800140:	f3 0f 1e fb          	endbr32 
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	57                   	push   %edi
  800148:	56                   	push   %esi
  800149:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014a:	ba 00 00 00 00       	mov    $0x0,%edx
  80014f:	b8 02 00 00 00       	mov    $0x2,%eax
  800154:	89 d1                	mov    %edx,%ecx
  800156:	89 d3                	mov    %edx,%ebx
  800158:	89 d7                	mov    %edx,%edi
  80015a:	89 d6                	mov    %edx,%esi
  80015c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015e:	5b                   	pop    %ebx
  80015f:	5e                   	pop    %esi
  800160:	5f                   	pop    %edi
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    

00800163 <sys_yield>:

void
sys_yield(void)
{
  800163:	f3 0f 1e fb          	endbr32 
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	57                   	push   %edi
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80016d:	ba 00 00 00 00       	mov    $0x0,%edx
  800172:	b8 0b 00 00 00       	mov    $0xb,%eax
  800177:	89 d1                	mov    %edx,%ecx
  800179:	89 d3                	mov    %edx,%ebx
  80017b:	89 d7                	mov    %edx,%edi
  80017d:	89 d6                	mov    %edx,%esi
  80017f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800181:	5b                   	pop    %ebx
  800182:	5e                   	pop    %esi
  800183:	5f                   	pop    %edi
  800184:	5d                   	pop    %ebp
  800185:	c3                   	ret    

00800186 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800186:	f3 0f 1e fb          	endbr32 
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	57                   	push   %edi
  80018e:	56                   	push   %esi
  80018f:	53                   	push   %ebx
  800190:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800193:	be 00 00 00 00       	mov    $0x0,%esi
  800198:	8b 55 08             	mov    0x8(%ebp),%edx
  80019b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019e:	b8 04 00 00 00       	mov    $0x4,%eax
  8001a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a6:	89 f7                	mov    %esi,%edi
  8001a8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001aa:	85 c0                	test   %eax,%eax
  8001ac:	7f 08                	jg     8001b6 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b1:	5b                   	pop    %ebx
  8001b2:	5e                   	pop    %esi
  8001b3:	5f                   	pop    %edi
  8001b4:	5d                   	pop    %ebp
  8001b5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	6a 04                	push   $0x4
  8001bc:	68 8f 24 80 00       	push   $0x80248f
  8001c1:	6a 23                	push   $0x23
  8001c3:	68 ac 24 80 00       	push   $0x8024ac
  8001c8:	e8 7b 14 00 00       	call   801648 <_panic>

008001cd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001cd:	f3 0f 1e fb          	endbr32 
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	57                   	push   %edi
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001da:	8b 55 08             	mov    0x8(%ebp),%edx
  8001dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001eb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	7f 08                	jg     8001fc <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f7:	5b                   	pop    %ebx
  8001f8:	5e                   	pop    %esi
  8001f9:	5f                   	pop    %edi
  8001fa:	5d                   	pop    %ebp
  8001fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	50                   	push   %eax
  800200:	6a 05                	push   $0x5
  800202:	68 8f 24 80 00       	push   $0x80248f
  800207:	6a 23                	push   $0x23
  800209:	68 ac 24 80 00       	push   $0x8024ac
  80020e:	e8 35 14 00 00       	call   801648 <_panic>

00800213 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800213:	f3 0f 1e fb          	endbr32 
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	57                   	push   %edi
  80021b:	56                   	push   %esi
  80021c:	53                   	push   %ebx
  80021d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	8b 55 08             	mov    0x8(%ebp),%edx
  800228:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022b:	b8 06 00 00 00       	mov    $0x6,%eax
  800230:	89 df                	mov    %ebx,%edi
  800232:	89 de                	mov    %ebx,%esi
  800234:	cd 30                	int    $0x30
	if(check && ret > 0)
  800236:	85 c0                	test   %eax,%eax
  800238:	7f 08                	jg     800242 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	50                   	push   %eax
  800246:	6a 06                	push   $0x6
  800248:	68 8f 24 80 00       	push   $0x80248f
  80024d:	6a 23                	push   $0x23
  80024f:	68 ac 24 80 00       	push   $0x8024ac
  800254:	e8 ef 13 00 00       	call   801648 <_panic>

00800259 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800259:	f3 0f 1e fb          	endbr32 
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	57                   	push   %edi
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
  800263:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800266:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026b:	8b 55 08             	mov    0x8(%ebp),%edx
  80026e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800271:	b8 08 00 00 00       	mov    $0x8,%eax
  800276:	89 df                	mov    %ebx,%edi
  800278:	89 de                	mov    %ebx,%esi
  80027a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027c:	85 c0                	test   %eax,%eax
  80027e:	7f 08                	jg     800288 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800283:	5b                   	pop    %ebx
  800284:	5e                   	pop    %esi
  800285:	5f                   	pop    %edi
  800286:	5d                   	pop    %ebp
  800287:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	50                   	push   %eax
  80028c:	6a 08                	push   $0x8
  80028e:	68 8f 24 80 00       	push   $0x80248f
  800293:	6a 23                	push   $0x23
  800295:	68 ac 24 80 00       	push   $0x8024ac
  80029a:	e8 a9 13 00 00       	call   801648 <_panic>

0080029f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80029f:	f3 0f 1e fb          	endbr32 
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	57                   	push   %edi
  8002a7:	56                   	push   %esi
  8002a8:	53                   	push   %ebx
  8002a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b7:	b8 09 00 00 00       	mov    $0x9,%eax
  8002bc:	89 df                	mov    %ebx,%edi
  8002be:	89 de                	mov    %ebx,%esi
  8002c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	7f 08                	jg     8002ce <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c9:	5b                   	pop    %ebx
  8002ca:	5e                   	pop    %esi
  8002cb:	5f                   	pop    %edi
  8002cc:	5d                   	pop    %ebp
  8002cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	6a 09                	push   $0x9
  8002d4:	68 8f 24 80 00       	push   $0x80248f
  8002d9:	6a 23                	push   $0x23
  8002db:	68 ac 24 80 00       	push   $0x8024ac
  8002e0:	e8 63 13 00 00       	call   801648 <_panic>

008002e5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e5:	f3 0f 1e fb          	endbr32 
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	57                   	push   %edi
  8002ed:	56                   	push   %esi
  8002ee:	53                   	push   %ebx
  8002ef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800302:	89 df                	mov    %ebx,%edi
  800304:	89 de                	mov    %ebx,%esi
  800306:	cd 30                	int    $0x30
	if(check && ret > 0)
  800308:	85 c0                	test   %eax,%eax
  80030a:	7f 08                	jg     800314 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80030c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030f:	5b                   	pop    %ebx
  800310:	5e                   	pop    %esi
  800311:	5f                   	pop    %edi
  800312:	5d                   	pop    %ebp
  800313:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800314:	83 ec 0c             	sub    $0xc,%esp
  800317:	50                   	push   %eax
  800318:	6a 0a                	push   $0xa
  80031a:	68 8f 24 80 00       	push   $0x80248f
  80031f:	6a 23                	push   $0x23
  800321:	68 ac 24 80 00       	push   $0x8024ac
  800326:	e8 1d 13 00 00       	call   801648 <_panic>

0080032b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032b:	f3 0f 1e fb          	endbr32 
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	57                   	push   %edi
  800333:	56                   	push   %esi
  800334:	53                   	push   %ebx
	asm volatile("int %1\n"
  800335:	8b 55 08             	mov    0x8(%ebp),%edx
  800338:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800340:	be 00 00 00 00       	mov    $0x0,%esi
  800345:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800348:	8b 7d 14             	mov    0x14(%ebp),%edi
  80034b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80034d:	5b                   	pop    %ebx
  80034e:	5e                   	pop    %esi
  80034f:	5f                   	pop    %edi
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    

00800352 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800352:	f3 0f 1e fb          	endbr32 
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	57                   	push   %edi
  80035a:	56                   	push   %esi
  80035b:	53                   	push   %ebx
  80035c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80035f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800364:	8b 55 08             	mov    0x8(%ebp),%edx
  800367:	b8 0d 00 00 00       	mov    $0xd,%eax
  80036c:	89 cb                	mov    %ecx,%ebx
  80036e:	89 cf                	mov    %ecx,%edi
  800370:	89 ce                	mov    %ecx,%esi
  800372:	cd 30                	int    $0x30
	if(check && ret > 0)
  800374:	85 c0                	test   %eax,%eax
  800376:	7f 08                	jg     800380 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037b:	5b                   	pop    %ebx
  80037c:	5e                   	pop    %esi
  80037d:	5f                   	pop    %edi
  80037e:	5d                   	pop    %ebp
  80037f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800380:	83 ec 0c             	sub    $0xc,%esp
  800383:	50                   	push   %eax
  800384:	6a 0d                	push   $0xd
  800386:	68 8f 24 80 00       	push   $0x80248f
  80038b:	6a 23                	push   $0x23
  80038d:	68 ac 24 80 00       	push   $0x8024ac
  800392:	e8 b1 12 00 00       	call   801648 <_panic>

00800397 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800397:	f3 0f 1e fb          	endbr32 
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	57                   	push   %edi
  80039f:	56                   	push   %esi
  8003a0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003ab:	89 d1                	mov    %edx,%ecx
  8003ad:	89 d3                	mov    %edx,%ebx
  8003af:	89 d7                	mov    %edx,%edi
  8003b1:	89 d6                	mov    %edx,%esi
  8003b3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003b5:	5b                   	pop    %ebx
  8003b6:	5e                   	pop    %esi
  8003b7:	5f                   	pop    %edi
  8003b8:	5d                   	pop    %ebp
  8003b9:	c3                   	ret    

008003ba <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8003ba:	f3 0f 1e fb          	endbr32 
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	57                   	push   %edi
  8003c2:	56                   	push   %esi
  8003c3:	53                   	push   %ebx
  8003c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003d2:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003d7:	89 df                	mov    %ebx,%edi
  8003d9:	89 de                	mov    %ebx,%esi
  8003db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003dd:	85 c0                	test   %eax,%eax
  8003df:	7f 08                	jg     8003e9 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8003e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e4:	5b                   	pop    %ebx
  8003e5:	5e                   	pop    %esi
  8003e6:	5f                   	pop    %edi
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	50                   	push   %eax
  8003ed:	6a 0f                	push   $0xf
  8003ef:	68 8f 24 80 00       	push   $0x80248f
  8003f4:	6a 23                	push   $0x23
  8003f6:	68 ac 24 80 00       	push   $0x8024ac
  8003fb:	e8 48 12 00 00       	call   801648 <_panic>

00800400 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800400:	f3 0f 1e fb          	endbr32 
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	57                   	push   %edi
  800408:	56                   	push   %esi
  800409:	53                   	push   %ebx
  80040a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80040d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800412:	8b 55 08             	mov    0x8(%ebp),%edx
  800415:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800418:	b8 10 00 00 00       	mov    $0x10,%eax
  80041d:	89 df                	mov    %ebx,%edi
  80041f:	89 de                	mov    %ebx,%esi
  800421:	cd 30                	int    $0x30
	if(check && ret > 0)
  800423:	85 c0                	test   %eax,%eax
  800425:	7f 08                	jg     80042f <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800427:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80042a:	5b                   	pop    %ebx
  80042b:	5e                   	pop    %esi
  80042c:	5f                   	pop    %edi
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80042f:	83 ec 0c             	sub    $0xc,%esp
  800432:	50                   	push   %eax
  800433:	6a 10                	push   $0x10
  800435:	68 8f 24 80 00       	push   $0x80248f
  80043a:	6a 23                	push   $0x23
  80043c:	68 ac 24 80 00       	push   $0x8024ac
  800441:	e8 02 12 00 00       	call   801648 <_panic>

00800446 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800446:	f3 0f 1e fb          	endbr32 
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	05 00 00 00 30       	add    $0x30000000,%eax
  800455:	c1 e8 0c             	shr    $0xc,%eax
}
  800458:	5d                   	pop    %ebp
  800459:	c3                   	ret    

0080045a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80045a:	f3 0f 1e fb          	endbr32 
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800469:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80046e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800475:	f3 0f 1e fb          	endbr32 
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800481:	89 c2                	mov    %eax,%edx
  800483:	c1 ea 16             	shr    $0x16,%edx
  800486:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80048d:	f6 c2 01             	test   $0x1,%dl
  800490:	74 2d                	je     8004bf <fd_alloc+0x4a>
  800492:	89 c2                	mov    %eax,%edx
  800494:	c1 ea 0c             	shr    $0xc,%edx
  800497:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80049e:	f6 c2 01             	test   $0x1,%dl
  8004a1:	74 1c                	je     8004bf <fd_alloc+0x4a>
  8004a3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8004a8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8004ad:	75 d2                	jne    800481 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004b8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8004bd:	eb 0a                	jmp    8004c9 <fd_alloc+0x54>
			*fd_store = fd;
  8004bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004c9:	5d                   	pop    %ebp
  8004ca:	c3                   	ret    

008004cb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004cb:	f3 0f 1e fb          	endbr32 
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004d5:	83 f8 1f             	cmp    $0x1f,%eax
  8004d8:	77 30                	ja     80050a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004da:	c1 e0 0c             	shl    $0xc,%eax
  8004dd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004e2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8004e8:	f6 c2 01             	test   $0x1,%dl
  8004eb:	74 24                	je     800511 <fd_lookup+0x46>
  8004ed:	89 c2                	mov    %eax,%edx
  8004ef:	c1 ea 0c             	shr    $0xc,%edx
  8004f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004f9:	f6 c2 01             	test   $0x1,%dl
  8004fc:	74 1a                	je     800518 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800501:	89 02                	mov    %eax,(%edx)
	return 0;
  800503:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800508:	5d                   	pop    %ebp
  800509:	c3                   	ret    
		return -E_INVAL;
  80050a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80050f:	eb f7                	jmp    800508 <fd_lookup+0x3d>
		return -E_INVAL;
  800511:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800516:	eb f0                	jmp    800508 <fd_lookup+0x3d>
  800518:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80051d:	eb e9                	jmp    800508 <fd_lookup+0x3d>

0080051f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80051f:	f3 0f 1e fb          	endbr32 
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80052c:	ba 00 00 00 00       	mov    $0x0,%edx
  800531:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800536:	39 08                	cmp    %ecx,(%eax)
  800538:	74 38                	je     800572 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80053a:	83 c2 01             	add    $0x1,%edx
  80053d:	8b 04 95 38 25 80 00 	mov    0x802538(,%edx,4),%eax
  800544:	85 c0                	test   %eax,%eax
  800546:	75 ee                	jne    800536 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800548:	a1 08 40 80 00       	mov    0x804008,%eax
  80054d:	8b 40 48             	mov    0x48(%eax),%eax
  800550:	83 ec 04             	sub    $0x4,%esp
  800553:	51                   	push   %ecx
  800554:	50                   	push   %eax
  800555:	68 bc 24 80 00       	push   $0x8024bc
  80055a:	e8 d0 11 00 00       	call   80172f <cprintf>
	*dev = 0;
  80055f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800570:	c9                   	leave  
  800571:	c3                   	ret    
			*dev = devtab[i];
  800572:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800575:	89 01                	mov    %eax,(%ecx)
			return 0;
  800577:	b8 00 00 00 00       	mov    $0x0,%eax
  80057c:	eb f2                	jmp    800570 <dev_lookup+0x51>

0080057e <fd_close>:
{
  80057e:	f3 0f 1e fb          	endbr32 
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	57                   	push   %edi
  800586:	56                   	push   %esi
  800587:	53                   	push   %ebx
  800588:	83 ec 24             	sub    $0x24,%esp
  80058b:	8b 75 08             	mov    0x8(%ebp),%esi
  80058e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800591:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800594:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800595:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80059b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80059e:	50                   	push   %eax
  80059f:	e8 27 ff ff ff       	call   8004cb <fd_lookup>
  8005a4:	89 c3                	mov    %eax,%ebx
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	85 c0                	test   %eax,%eax
  8005ab:	78 05                	js     8005b2 <fd_close+0x34>
	    || fd != fd2)
  8005ad:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8005b0:	74 16                	je     8005c8 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8005b2:	89 f8                	mov    %edi,%eax
  8005b4:	84 c0                	test   %al,%al
  8005b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bb:	0f 44 d8             	cmove  %eax,%ebx
}
  8005be:	89 d8                	mov    %ebx,%eax
  8005c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c3:	5b                   	pop    %ebx
  8005c4:	5e                   	pop    %esi
  8005c5:	5f                   	pop    %edi
  8005c6:	5d                   	pop    %ebp
  8005c7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005ce:	50                   	push   %eax
  8005cf:	ff 36                	pushl  (%esi)
  8005d1:	e8 49 ff ff ff       	call   80051f <dev_lookup>
  8005d6:	89 c3                	mov    %eax,%ebx
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	85 c0                	test   %eax,%eax
  8005dd:	78 1a                	js     8005f9 <fd_close+0x7b>
		if (dev->dev_close)
  8005df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8005e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8005ea:	85 c0                	test   %eax,%eax
  8005ec:	74 0b                	je     8005f9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	56                   	push   %esi
  8005f2:	ff d0                	call   *%eax
  8005f4:	89 c3                	mov    %eax,%ebx
  8005f6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	56                   	push   %esi
  8005fd:	6a 00                	push   $0x0
  8005ff:	e8 0f fc ff ff       	call   800213 <sys_page_unmap>
	return r;
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	eb b5                	jmp    8005be <fd_close+0x40>

00800609 <close>:

int
close(int fdnum)
{
  800609:	f3 0f 1e fb          	endbr32 
  80060d:	55                   	push   %ebp
  80060e:	89 e5                	mov    %esp,%ebp
  800610:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800613:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800616:	50                   	push   %eax
  800617:	ff 75 08             	pushl  0x8(%ebp)
  80061a:	e8 ac fe ff ff       	call   8004cb <fd_lookup>
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	85 c0                	test   %eax,%eax
  800624:	79 02                	jns    800628 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800626:	c9                   	leave  
  800627:	c3                   	ret    
		return fd_close(fd, 1);
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	6a 01                	push   $0x1
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	e8 49 ff ff ff       	call   80057e <fd_close>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	eb ec                	jmp    800626 <close+0x1d>

0080063a <close_all>:

void
close_all(void)
{
  80063a:	f3 0f 1e fb          	endbr32 
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	53                   	push   %ebx
  800642:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800645:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80064a:	83 ec 0c             	sub    $0xc,%esp
  80064d:	53                   	push   %ebx
  80064e:	e8 b6 ff ff ff       	call   800609 <close>
	for (i = 0; i < MAXFD; i++)
  800653:	83 c3 01             	add    $0x1,%ebx
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	83 fb 20             	cmp    $0x20,%ebx
  80065c:	75 ec                	jne    80064a <close_all+0x10>
}
  80065e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800661:	c9                   	leave  
  800662:	c3                   	ret    

00800663 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800663:	f3 0f 1e fb          	endbr32 
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	57                   	push   %edi
  80066b:	56                   	push   %esi
  80066c:	53                   	push   %ebx
  80066d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800670:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800673:	50                   	push   %eax
  800674:	ff 75 08             	pushl  0x8(%ebp)
  800677:	e8 4f fe ff ff       	call   8004cb <fd_lookup>
  80067c:	89 c3                	mov    %eax,%ebx
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	85 c0                	test   %eax,%eax
  800683:	0f 88 81 00 00 00    	js     80070a <dup+0xa7>
		return r;
	close(newfdnum);
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	e8 75 ff ff ff       	call   800609 <close>

	newfd = INDEX2FD(newfdnum);
  800694:	8b 75 0c             	mov    0xc(%ebp),%esi
  800697:	c1 e6 0c             	shl    $0xc,%esi
  80069a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8006a0:	83 c4 04             	add    $0x4,%esp
  8006a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006a6:	e8 af fd ff ff       	call   80045a <fd2data>
  8006ab:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8006ad:	89 34 24             	mov    %esi,(%esp)
  8006b0:	e8 a5 fd ff ff       	call   80045a <fd2data>
  8006b5:	83 c4 10             	add    $0x10,%esp
  8006b8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006ba:	89 d8                	mov    %ebx,%eax
  8006bc:	c1 e8 16             	shr    $0x16,%eax
  8006bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006c6:	a8 01                	test   $0x1,%al
  8006c8:	74 11                	je     8006db <dup+0x78>
  8006ca:	89 d8                	mov    %ebx,%eax
  8006cc:	c1 e8 0c             	shr    $0xc,%eax
  8006cf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006d6:	f6 c2 01             	test   $0x1,%dl
  8006d9:	75 39                	jne    800714 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006de:	89 d0                	mov    %edx,%eax
  8006e0:	c1 e8 0c             	shr    $0xc,%eax
  8006e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8006f2:	50                   	push   %eax
  8006f3:	56                   	push   %esi
  8006f4:	6a 00                	push   $0x0
  8006f6:	52                   	push   %edx
  8006f7:	6a 00                	push   $0x0
  8006f9:	e8 cf fa ff ff       	call   8001cd <sys_page_map>
  8006fe:	89 c3                	mov    %eax,%ebx
  800700:	83 c4 20             	add    $0x20,%esp
  800703:	85 c0                	test   %eax,%eax
  800705:	78 31                	js     800738 <dup+0xd5>
		goto err;

	return newfdnum;
  800707:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80070a:	89 d8                	mov    %ebx,%eax
  80070c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80070f:	5b                   	pop    %ebx
  800710:	5e                   	pop    %esi
  800711:	5f                   	pop    %edi
  800712:	5d                   	pop    %ebp
  800713:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800714:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80071b:	83 ec 0c             	sub    $0xc,%esp
  80071e:	25 07 0e 00 00       	and    $0xe07,%eax
  800723:	50                   	push   %eax
  800724:	57                   	push   %edi
  800725:	6a 00                	push   $0x0
  800727:	53                   	push   %ebx
  800728:	6a 00                	push   $0x0
  80072a:	e8 9e fa ff ff       	call   8001cd <sys_page_map>
  80072f:	89 c3                	mov    %eax,%ebx
  800731:	83 c4 20             	add    $0x20,%esp
  800734:	85 c0                	test   %eax,%eax
  800736:	79 a3                	jns    8006db <dup+0x78>
	sys_page_unmap(0, newfd);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	56                   	push   %esi
  80073c:	6a 00                	push   $0x0
  80073e:	e8 d0 fa ff ff       	call   800213 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800743:	83 c4 08             	add    $0x8,%esp
  800746:	57                   	push   %edi
  800747:	6a 00                	push   $0x0
  800749:	e8 c5 fa ff ff       	call   800213 <sys_page_unmap>
	return r;
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	eb b7                	jmp    80070a <dup+0xa7>

00800753 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800753:	f3 0f 1e fb          	endbr32 
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	53                   	push   %ebx
  80075b:	83 ec 1c             	sub    $0x1c,%esp
  80075e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800761:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	53                   	push   %ebx
  800766:	e8 60 fd ff ff       	call   8004cb <fd_lookup>
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	85 c0                	test   %eax,%eax
  800770:	78 3f                	js     8007b1 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800778:	50                   	push   %eax
  800779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077c:	ff 30                	pushl  (%eax)
  80077e:	e8 9c fd ff ff       	call   80051f <dev_lookup>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	85 c0                	test   %eax,%eax
  800788:	78 27                	js     8007b1 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80078a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80078d:	8b 42 08             	mov    0x8(%edx),%eax
  800790:	83 e0 03             	and    $0x3,%eax
  800793:	83 f8 01             	cmp    $0x1,%eax
  800796:	74 1e                	je     8007b6 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079b:	8b 40 08             	mov    0x8(%eax),%eax
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	74 35                	je     8007d7 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8007a2:	83 ec 04             	sub    $0x4,%esp
  8007a5:	ff 75 10             	pushl  0x10(%ebp)
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	52                   	push   %edx
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
}
  8007b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8007bb:	8b 40 48             	mov    0x48(%eax),%eax
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	53                   	push   %ebx
  8007c2:	50                   	push   %eax
  8007c3:	68 fd 24 80 00       	push   $0x8024fd
  8007c8:	e8 62 0f 00 00       	call   80172f <cprintf>
		return -E_INVAL;
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d5:	eb da                	jmp    8007b1 <read+0x5e>
		return -E_NOT_SUPP;
  8007d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007dc:	eb d3                	jmp    8007b1 <read+0x5e>

008007de <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007de:	f3 0f 1e fb          	endbr32 
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	57                   	push   %edi
  8007e6:	56                   	push   %esi
  8007e7:	53                   	push   %ebx
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007ee:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f6:	eb 02                	jmp    8007fa <readn+0x1c>
  8007f8:	01 c3                	add    %eax,%ebx
  8007fa:	39 f3                	cmp    %esi,%ebx
  8007fc:	73 21                	jae    80081f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	89 f0                	mov    %esi,%eax
  800803:	29 d8                	sub    %ebx,%eax
  800805:	50                   	push   %eax
  800806:	89 d8                	mov    %ebx,%eax
  800808:	03 45 0c             	add    0xc(%ebp),%eax
  80080b:	50                   	push   %eax
  80080c:	57                   	push   %edi
  80080d:	e8 41 ff ff ff       	call   800753 <read>
		if (m < 0)
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	85 c0                	test   %eax,%eax
  800817:	78 04                	js     80081d <readn+0x3f>
			return m;
		if (m == 0)
  800819:	75 dd                	jne    8007f8 <readn+0x1a>
  80081b:	eb 02                	jmp    80081f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80081d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80081f:	89 d8                	mov    %ebx,%eax
  800821:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800824:	5b                   	pop    %ebx
  800825:	5e                   	pop    %esi
  800826:	5f                   	pop    %edi
  800827:	5d                   	pop    %ebp
  800828:	c3                   	ret    

00800829 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800829:	f3 0f 1e fb          	endbr32 
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	53                   	push   %ebx
  800831:	83 ec 1c             	sub    $0x1c,%esp
  800834:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800837:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80083a:	50                   	push   %eax
  80083b:	53                   	push   %ebx
  80083c:	e8 8a fc ff ff       	call   8004cb <fd_lookup>
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	85 c0                	test   %eax,%eax
  800846:	78 3a                	js     800882 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80084e:	50                   	push   %eax
  80084f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800852:	ff 30                	pushl  (%eax)
  800854:	e8 c6 fc ff ff       	call   80051f <dev_lookup>
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	85 c0                	test   %eax,%eax
  80085e:	78 22                	js     800882 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800863:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800867:	74 1e                	je     800887 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800869:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086c:	8b 52 0c             	mov    0xc(%edx),%edx
  80086f:	85 d2                	test   %edx,%edx
  800871:	74 35                	je     8008a8 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800873:	83 ec 04             	sub    $0x4,%esp
  800876:	ff 75 10             	pushl  0x10(%ebp)
  800879:	ff 75 0c             	pushl  0xc(%ebp)
  80087c:	50                   	push   %eax
  80087d:	ff d2                	call   *%edx
  80087f:	83 c4 10             	add    $0x10,%esp
}
  800882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800885:	c9                   	leave  
  800886:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800887:	a1 08 40 80 00       	mov    0x804008,%eax
  80088c:	8b 40 48             	mov    0x48(%eax),%eax
  80088f:	83 ec 04             	sub    $0x4,%esp
  800892:	53                   	push   %ebx
  800893:	50                   	push   %eax
  800894:	68 19 25 80 00       	push   $0x802519
  800899:	e8 91 0e 00 00       	call   80172f <cprintf>
		return -E_INVAL;
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a6:	eb da                	jmp    800882 <write+0x59>
		return -E_NOT_SUPP;
  8008a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008ad:	eb d3                	jmp    800882 <write+0x59>

008008af <seek>:

int
seek(int fdnum, off_t offset)
{
  8008af:	f3 0f 1e fb          	endbr32 
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008bc:	50                   	push   %eax
  8008bd:	ff 75 08             	pushl  0x8(%ebp)
  8008c0:	e8 06 fc ff ff       	call   8004cb <fd_lookup>
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	85 c0                	test   %eax,%eax
  8008ca:	78 0e                	js     8008da <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8008cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008da:	c9                   	leave  
  8008db:	c3                   	ret    

008008dc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008dc:	f3 0f 1e fb          	endbr32 
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	53                   	push   %ebx
  8008e4:	83 ec 1c             	sub    $0x1c,%esp
  8008e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008ed:	50                   	push   %eax
  8008ee:	53                   	push   %ebx
  8008ef:	e8 d7 fb ff ff       	call   8004cb <fd_lookup>
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	85 c0                	test   %eax,%eax
  8008f9:	78 37                	js     800932 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800901:	50                   	push   %eax
  800902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800905:	ff 30                	pushl  (%eax)
  800907:	e8 13 fc ff ff       	call   80051f <dev_lookup>
  80090c:	83 c4 10             	add    $0x10,%esp
  80090f:	85 c0                	test   %eax,%eax
  800911:	78 1f                	js     800932 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800916:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80091a:	74 1b                	je     800937 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80091c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80091f:	8b 52 18             	mov    0x18(%edx),%edx
  800922:	85 d2                	test   %edx,%edx
  800924:	74 32                	je     800958 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	50                   	push   %eax
  80092d:	ff d2                	call   *%edx
  80092f:	83 c4 10             	add    $0x10,%esp
}
  800932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800935:	c9                   	leave  
  800936:	c3                   	ret    
			thisenv->env_id, fdnum);
  800937:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80093c:	8b 40 48             	mov    0x48(%eax),%eax
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	53                   	push   %ebx
  800943:	50                   	push   %eax
  800944:	68 dc 24 80 00       	push   $0x8024dc
  800949:	e8 e1 0d 00 00       	call   80172f <cprintf>
		return -E_INVAL;
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800956:	eb da                	jmp    800932 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800958:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80095d:	eb d3                	jmp    800932 <ftruncate+0x56>

0080095f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80095f:	f3 0f 1e fb          	endbr32 
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	53                   	push   %ebx
  800967:	83 ec 1c             	sub    $0x1c,%esp
  80096a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80096d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800970:	50                   	push   %eax
  800971:	ff 75 08             	pushl  0x8(%ebp)
  800974:	e8 52 fb ff ff       	call   8004cb <fd_lookup>
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	85 c0                	test   %eax,%eax
  80097e:	78 4b                	js     8009cb <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800986:	50                   	push   %eax
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	ff 30                	pushl  (%eax)
  80098c:	e8 8e fb ff ff       	call   80051f <dev_lookup>
  800991:	83 c4 10             	add    $0x10,%esp
  800994:	85 c0                	test   %eax,%eax
  800996:	78 33                	js     8009cb <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80099f:	74 2f                	je     8009d0 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8009a1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8009a4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8009ab:	00 00 00 
	stat->st_isdir = 0;
  8009ae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009b5:	00 00 00 
	stat->st_dev = dev;
  8009b8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	53                   	push   %ebx
  8009c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c5:	ff 50 14             	call   *0x14(%eax)
  8009c8:	83 c4 10             	add    $0x10,%esp
}
  8009cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    
		return -E_NOT_SUPP;
  8009d0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8009d5:	eb f4                	jmp    8009cb <fstat+0x6c>

008009d7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009d7:	f3 0f 1e fb          	endbr32 
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	56                   	push   %esi
  8009df:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	6a 00                	push   $0x0
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 fb 01 00 00       	call   800be8 <open>
  8009ed:	89 c3                	mov    %eax,%ebx
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	85 c0                	test   %eax,%eax
  8009f4:	78 1b                	js     800a11 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	50                   	push   %eax
  8009fd:	e8 5d ff ff ff       	call   80095f <fstat>
  800a02:	89 c6                	mov    %eax,%esi
	close(fd);
  800a04:	89 1c 24             	mov    %ebx,(%esp)
  800a07:	e8 fd fb ff ff       	call   800609 <close>
	return r;
  800a0c:	83 c4 10             	add    $0x10,%esp
  800a0f:	89 f3                	mov    %esi,%ebx
}
  800a11:	89 d8                	mov    %ebx,%eax
  800a13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a16:	5b                   	pop    %ebx
  800a17:	5e                   	pop    %esi
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	56                   	push   %esi
  800a1e:	53                   	push   %ebx
  800a1f:	89 c6                	mov    %eax,%esi
  800a21:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a23:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a2a:	74 27                	je     800a53 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a2c:	6a 07                	push   $0x7
  800a2e:	68 00 50 80 00       	push   $0x805000
  800a33:	56                   	push   %esi
  800a34:	ff 35 00 40 80 00    	pushl  0x804000
  800a3a:	e8 f1 16 00 00       	call   802130 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a3f:	83 c4 0c             	add    $0xc,%esp
  800a42:	6a 00                	push   $0x0
  800a44:	53                   	push   %ebx
  800a45:	6a 00                	push   $0x0
  800a47:	e8 5f 16 00 00       	call   8020ab <ipc_recv>
}
  800a4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4f:	5b                   	pop    %ebx
  800a50:	5e                   	pop    %esi
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a53:	83 ec 0c             	sub    $0xc,%esp
  800a56:	6a 01                	push   $0x1
  800a58:	e8 2b 17 00 00       	call   802188 <ipc_find_env>
  800a5d:	a3 00 40 80 00       	mov    %eax,0x804000
  800a62:	83 c4 10             	add    $0x10,%esp
  800a65:	eb c5                	jmp    800a2c <fsipc+0x12>

00800a67 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a67:	f3 0f 1e fb          	endbr32 
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	8b 40 0c             	mov    0xc(%eax),%eax
  800a77:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a84:	ba 00 00 00 00       	mov    $0x0,%edx
  800a89:	b8 02 00 00 00       	mov    $0x2,%eax
  800a8e:	e8 87 ff ff ff       	call   800a1a <fsipc>
}
  800a93:	c9                   	leave  
  800a94:	c3                   	ret    

00800a95 <devfile_flush>:
{
  800a95:	f3 0f 1e fb          	endbr32 
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  800aa5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aaf:	b8 06 00 00 00       	mov    $0x6,%eax
  800ab4:	e8 61 ff ff ff       	call   800a1a <fsipc>
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <devfile_stat>:
{
  800abb:	f3 0f 1e fb          	endbr32 
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	53                   	push   %ebx
  800ac3:	83 ec 04             	sub    $0x4,%esp
  800ac6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 40 0c             	mov    0xc(%eax),%eax
  800acf:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800ad4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad9:	b8 05 00 00 00       	mov    $0x5,%eax
  800ade:	e8 37 ff ff ff       	call   800a1a <fsipc>
  800ae3:	85 c0                	test   %eax,%eax
  800ae5:	78 2c                	js     800b13 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	68 00 50 80 00       	push   $0x805000
  800aef:	53                   	push   %ebx
  800af0:	e8 44 12 00 00       	call   801d39 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800af5:	a1 80 50 80 00       	mov    0x805080,%eax
  800afa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b00:	a1 84 50 80 00       	mov    0x805084,%eax
  800b05:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b0b:	83 c4 10             	add    $0x10,%esp
  800b0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <devfile_write>:
{
  800b18:	f3 0f 1e fb          	endbr32 
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 0c             	sub    $0xc,%esp
  800b22:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800b25:	8b 55 08             	mov    0x8(%ebp),%edx
  800b28:	8b 52 0c             	mov    0xc(%edx),%edx
  800b2b:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800b31:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800b36:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800b3b:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800b3e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800b43:	50                   	push   %eax
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	68 08 50 80 00       	push   $0x805008
  800b4c:	e8 9e 13 00 00       	call   801eef <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800b51:	ba 00 00 00 00       	mov    $0x0,%edx
  800b56:	b8 04 00 00 00       	mov    $0x4,%eax
  800b5b:	e8 ba fe ff ff       	call   800a1a <fsipc>
}
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <devfile_read>:
{
  800b62:	f3 0f 1e fb          	endbr32 
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	56                   	push   %esi
  800b6a:	53                   	push   %ebx
  800b6b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8b 40 0c             	mov    0xc(%eax),%eax
  800b74:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b79:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b84:	b8 03 00 00 00       	mov    $0x3,%eax
  800b89:	e8 8c fe ff ff       	call   800a1a <fsipc>
  800b8e:	89 c3                	mov    %eax,%ebx
  800b90:	85 c0                	test   %eax,%eax
  800b92:	78 1f                	js     800bb3 <devfile_read+0x51>
	assert(r <= n);
  800b94:	39 f0                	cmp    %esi,%eax
  800b96:	77 24                	ja     800bbc <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b98:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b9d:	7f 33                	jg     800bd2 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b9f:	83 ec 04             	sub    $0x4,%esp
  800ba2:	50                   	push   %eax
  800ba3:	68 00 50 80 00       	push   $0x805000
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	e8 3f 13 00 00       	call   801eef <memmove>
	return r;
  800bb0:	83 c4 10             	add    $0x10,%esp
}
  800bb3:	89 d8                	mov    %ebx,%eax
  800bb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb8:	5b                   	pop    %ebx
  800bb9:	5e                   	pop    %esi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    
	assert(r <= n);
  800bbc:	68 4c 25 80 00       	push   $0x80254c
  800bc1:	68 53 25 80 00       	push   $0x802553
  800bc6:	6a 7c                	push   $0x7c
  800bc8:	68 68 25 80 00       	push   $0x802568
  800bcd:	e8 76 0a 00 00       	call   801648 <_panic>
	assert(r <= PGSIZE);
  800bd2:	68 73 25 80 00       	push   $0x802573
  800bd7:	68 53 25 80 00       	push   $0x802553
  800bdc:	6a 7d                	push   $0x7d
  800bde:	68 68 25 80 00       	push   $0x802568
  800be3:	e8 60 0a 00 00       	call   801648 <_panic>

00800be8 <open>:
{
  800be8:	f3 0f 1e fb          	endbr32 
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
  800bf1:	83 ec 1c             	sub    $0x1c,%esp
  800bf4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800bf7:	56                   	push   %esi
  800bf8:	e8 f9 10 00 00       	call   801cf6 <strlen>
  800bfd:	83 c4 10             	add    $0x10,%esp
  800c00:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c05:	7f 6c                	jg     800c73 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800c07:	83 ec 0c             	sub    $0xc,%esp
  800c0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c0d:	50                   	push   %eax
  800c0e:	e8 62 f8 ff ff       	call   800475 <fd_alloc>
  800c13:	89 c3                	mov    %eax,%ebx
  800c15:	83 c4 10             	add    $0x10,%esp
  800c18:	85 c0                	test   %eax,%eax
  800c1a:	78 3c                	js     800c58 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800c1c:	83 ec 08             	sub    $0x8,%esp
  800c1f:	56                   	push   %esi
  800c20:	68 00 50 80 00       	push   $0x805000
  800c25:	e8 0f 11 00 00       	call   801d39 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c35:	b8 01 00 00 00       	mov    $0x1,%eax
  800c3a:	e8 db fd ff ff       	call   800a1a <fsipc>
  800c3f:	89 c3                	mov    %eax,%ebx
  800c41:	83 c4 10             	add    $0x10,%esp
  800c44:	85 c0                	test   %eax,%eax
  800c46:	78 19                	js     800c61 <open+0x79>
	return fd2num(fd);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4e:	e8 f3 f7 ff ff       	call   800446 <fd2num>
  800c53:	89 c3                	mov    %eax,%ebx
  800c55:	83 c4 10             	add    $0x10,%esp
}
  800c58:	89 d8                	mov    %ebx,%eax
  800c5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    
		fd_close(fd, 0);
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	6a 00                	push   $0x0
  800c66:	ff 75 f4             	pushl  -0xc(%ebp)
  800c69:	e8 10 f9 ff ff       	call   80057e <fd_close>
		return r;
  800c6e:	83 c4 10             	add    $0x10,%esp
  800c71:	eb e5                	jmp    800c58 <open+0x70>
		return -E_BAD_PATH;
  800c73:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c78:	eb de                	jmp    800c58 <open+0x70>

00800c7a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c7a:	f3 0f 1e fb          	endbr32 
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c84:	ba 00 00 00 00       	mov    $0x0,%edx
  800c89:	b8 08 00 00 00       	mov    $0x8,%eax
  800c8e:	e8 87 fd ff ff       	call   800a1a <fsipc>
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c95:	f3 0f 1e fb          	endbr32 
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c9f:	68 7f 25 80 00       	push   $0x80257f
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	e8 8d 10 00 00       	call   801d39 <strcpy>
	return 0;
}
  800cac:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <devsock_close>:
{
  800cb3:	f3 0f 1e fb          	endbr32 
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 10             	sub    $0x10,%esp
  800cbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800cc1:	53                   	push   %ebx
  800cc2:	e8 fe 14 00 00       	call   8021c5 <pageref>
  800cc7:	89 c2                	mov    %eax,%edx
  800cc9:	83 c4 10             	add    $0x10,%esp
		return 0;
  800ccc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800cd1:	83 fa 01             	cmp    $0x1,%edx
  800cd4:	74 05                	je     800cdb <devsock_close+0x28>
}
  800cd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	ff 73 0c             	pushl  0xc(%ebx)
  800ce1:	e8 e3 02 00 00       	call   800fc9 <nsipc_close>
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	eb eb                	jmp    800cd6 <devsock_close+0x23>

00800ceb <devsock_write>:
{
  800ceb:	f3 0f 1e fb          	endbr32 
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800cf5:	6a 00                	push   $0x0
  800cf7:	ff 75 10             	pushl  0x10(%ebp)
  800cfa:	ff 75 0c             	pushl  0xc(%ebp)
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	ff 70 0c             	pushl  0xc(%eax)
  800d03:	e8 b5 03 00 00       	call   8010bd <nsipc_send>
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <devsock_read>:
{
  800d0a:	f3 0f 1e fb          	endbr32 
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800d14:	6a 00                	push   $0x0
  800d16:	ff 75 10             	pushl  0x10(%ebp)
  800d19:	ff 75 0c             	pushl  0xc(%ebp)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	ff 70 0c             	pushl  0xc(%eax)
  800d22:	e8 1f 03 00 00       	call   801046 <nsipc_recv>
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <fd2sockid>:
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800d2f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d32:	52                   	push   %edx
  800d33:	50                   	push   %eax
  800d34:	e8 92 f7 ff ff       	call   8004cb <fd_lookup>
  800d39:	83 c4 10             	add    $0x10,%esp
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	78 10                	js     800d50 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d43:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800d49:	39 08                	cmp    %ecx,(%eax)
  800d4b:	75 05                	jne    800d52 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800d4d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    
		return -E_NOT_SUPP;
  800d52:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d57:	eb f7                	jmp    800d50 <fd2sockid+0x27>

00800d59 <alloc_sockfd>:
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 1c             	sub    $0x1c,%esp
  800d61:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d66:	50                   	push   %eax
  800d67:	e8 09 f7 ff ff       	call   800475 <fd_alloc>
  800d6c:	89 c3                	mov    %eax,%ebx
  800d6e:	83 c4 10             	add    $0x10,%esp
  800d71:	85 c0                	test   %eax,%eax
  800d73:	78 43                	js     800db8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d75:	83 ec 04             	sub    $0x4,%esp
  800d78:	68 07 04 00 00       	push   $0x407
  800d7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d80:	6a 00                	push   $0x0
  800d82:	e8 ff f3 ff ff       	call   800186 <sys_page_alloc>
  800d87:	89 c3                	mov    %eax,%ebx
  800d89:	83 c4 10             	add    $0x10,%esp
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	78 28                	js     800db8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d93:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d99:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800da5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	50                   	push   %eax
  800dac:	e8 95 f6 ff ff       	call   800446 <fd2num>
  800db1:	89 c3                	mov    %eax,%ebx
  800db3:	83 c4 10             	add    $0x10,%esp
  800db6:	eb 0c                	jmp    800dc4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800db8:	83 ec 0c             	sub    $0xc,%esp
  800dbb:	56                   	push   %esi
  800dbc:	e8 08 02 00 00       	call   800fc9 <nsipc_close>
		return r;
  800dc1:	83 c4 10             	add    $0x10,%esp
}
  800dc4:	89 d8                	mov    %ebx,%eax
  800dc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <accept>:
{
  800dcd:	f3 0f 1e fb          	endbr32 
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	e8 4a ff ff ff       	call   800d29 <fd2sockid>
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	78 1b                	js     800dfe <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800de3:	83 ec 04             	sub    $0x4,%esp
  800de6:	ff 75 10             	pushl  0x10(%ebp)
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	50                   	push   %eax
  800ded:	e8 22 01 00 00       	call   800f14 <nsipc_accept>
  800df2:	83 c4 10             	add    $0x10,%esp
  800df5:	85 c0                	test   %eax,%eax
  800df7:	78 05                	js     800dfe <accept+0x31>
	return alloc_sockfd(r);
  800df9:	e8 5b ff ff ff       	call   800d59 <alloc_sockfd>
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <bind>:
{
  800e00:	f3 0f 1e fb          	endbr32 
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	e8 17 ff ff ff       	call   800d29 <fd2sockid>
  800e12:	85 c0                	test   %eax,%eax
  800e14:	78 12                	js     800e28 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800e16:	83 ec 04             	sub    $0x4,%esp
  800e19:	ff 75 10             	pushl  0x10(%ebp)
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	50                   	push   %eax
  800e20:	e8 45 01 00 00       	call   800f6a <nsipc_bind>
  800e25:	83 c4 10             	add    $0x10,%esp
}
  800e28:	c9                   	leave  
  800e29:	c3                   	ret    

00800e2a <shutdown>:
{
  800e2a:	f3 0f 1e fb          	endbr32 
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	e8 ed fe ff ff       	call   800d29 <fd2sockid>
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	78 0f                	js     800e4f <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800e40:	83 ec 08             	sub    $0x8,%esp
  800e43:	ff 75 0c             	pushl  0xc(%ebp)
  800e46:	50                   	push   %eax
  800e47:	e8 57 01 00 00       	call   800fa3 <nsipc_shutdown>
  800e4c:	83 c4 10             	add    $0x10,%esp
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <connect>:
{
  800e51:	f3 0f 1e fb          	endbr32 
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	e8 c6 fe ff ff       	call   800d29 <fd2sockid>
  800e63:	85 c0                	test   %eax,%eax
  800e65:	78 12                	js     800e79 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e67:	83 ec 04             	sub    $0x4,%esp
  800e6a:	ff 75 10             	pushl  0x10(%ebp)
  800e6d:	ff 75 0c             	pushl  0xc(%ebp)
  800e70:	50                   	push   %eax
  800e71:	e8 71 01 00 00       	call   800fe7 <nsipc_connect>
  800e76:	83 c4 10             	add    $0x10,%esp
}
  800e79:	c9                   	leave  
  800e7a:	c3                   	ret    

00800e7b <listen>:
{
  800e7b:	f3 0f 1e fb          	endbr32 
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	e8 9c fe ff ff       	call   800d29 <fd2sockid>
  800e8d:	85 c0                	test   %eax,%eax
  800e8f:	78 0f                	js     800ea0 <listen+0x25>
	return nsipc_listen(r, backlog);
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	ff 75 0c             	pushl  0xc(%ebp)
  800e97:	50                   	push   %eax
  800e98:	e8 83 01 00 00       	call   801020 <nsipc_listen>
  800e9d:	83 c4 10             	add    $0x10,%esp
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <socket>:

int
socket(int domain, int type, int protocol)
{
  800ea2:	f3 0f 1e fb          	endbr32 
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800eac:	ff 75 10             	pushl  0x10(%ebp)
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	ff 75 08             	pushl  0x8(%ebp)
  800eb5:	e8 65 02 00 00       	call   80111f <nsipc_socket>
  800eba:	83 c4 10             	add    $0x10,%esp
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	78 05                	js     800ec6 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800ec1:	e8 93 fe ff ff       	call   800d59 <alloc_sockfd>
}
  800ec6:	c9                   	leave  
  800ec7:	c3                   	ret    

00800ec8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	53                   	push   %ebx
  800ecc:	83 ec 04             	sub    $0x4,%esp
  800ecf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800ed1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800ed8:	74 26                	je     800f00 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800eda:	6a 07                	push   $0x7
  800edc:	68 00 60 80 00       	push   $0x806000
  800ee1:	53                   	push   %ebx
  800ee2:	ff 35 04 40 80 00    	pushl  0x804004
  800ee8:	e8 43 12 00 00       	call   802130 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800eed:	83 c4 0c             	add    $0xc,%esp
  800ef0:	6a 00                	push   $0x0
  800ef2:	6a 00                	push   $0x0
  800ef4:	6a 00                	push   $0x0
  800ef6:	e8 b0 11 00 00       	call   8020ab <ipc_recv>
}
  800efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800f00:	83 ec 0c             	sub    $0xc,%esp
  800f03:	6a 02                	push   $0x2
  800f05:	e8 7e 12 00 00       	call   802188 <ipc_find_env>
  800f0a:	a3 04 40 80 00       	mov    %eax,0x804004
  800f0f:	83 c4 10             	add    $0x10,%esp
  800f12:	eb c6                	jmp    800eda <nsipc+0x12>

00800f14 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f14:	f3 0f 1e fb          	endbr32 
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	56                   	push   %esi
  800f1c:	53                   	push   %ebx
  800f1d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800f28:	8b 06                	mov    (%esi),%eax
  800f2a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800f2f:	b8 01 00 00 00       	mov    $0x1,%eax
  800f34:	e8 8f ff ff ff       	call   800ec8 <nsipc>
  800f39:	89 c3                	mov    %eax,%ebx
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	79 09                	jns    800f48 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800f3f:	89 d8                	mov    %ebx,%eax
  800f41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	ff 35 10 60 80 00    	pushl  0x806010
  800f51:	68 00 60 80 00       	push   $0x806000
  800f56:	ff 75 0c             	pushl  0xc(%ebp)
  800f59:	e8 91 0f 00 00       	call   801eef <memmove>
		*addrlen = ret->ret_addrlen;
  800f5e:	a1 10 60 80 00       	mov    0x806010,%eax
  800f63:	89 06                	mov    %eax,(%esi)
  800f65:	83 c4 10             	add    $0x10,%esp
	return r;
  800f68:	eb d5                	jmp    800f3f <nsipc_accept+0x2b>

00800f6a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f6a:	f3 0f 1e fb          	endbr32 
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	53                   	push   %ebx
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f80:	53                   	push   %ebx
  800f81:	ff 75 0c             	pushl  0xc(%ebp)
  800f84:	68 04 60 80 00       	push   $0x806004
  800f89:	e8 61 0f 00 00       	call   801eef <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f8e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f94:	b8 02 00 00 00       	mov    $0x2,%eax
  800f99:	e8 2a ff ff ff       	call   800ec8 <nsipc>
}
  800f9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800fa3:	f3 0f 1e fb          	endbr32 
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800fbd:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc2:	e8 01 ff ff ff       	call   800ec8 <nsipc>
}
  800fc7:	c9                   	leave  
  800fc8:	c3                   	ret    

00800fc9 <nsipc_close>:

int
nsipc_close(int s)
{
  800fc9:	f3 0f 1e fb          	endbr32 
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800fdb:	b8 04 00 00 00       	mov    $0x4,%eax
  800fe0:	e8 e3 fe ff ff       	call   800ec8 <nsipc>
}
  800fe5:	c9                   	leave  
  800fe6:	c3                   	ret    

00800fe7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fe7:	f3 0f 1e fb          	endbr32 
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	53                   	push   %ebx
  800fef:	83 ec 08             	sub    $0x8,%esp
  800ff2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800ffd:	53                   	push   %ebx
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	68 04 60 80 00       	push   $0x806004
  801006:	e8 e4 0e 00 00       	call   801eef <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80100b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801011:	b8 05 00 00 00       	mov    $0x5,%eax
  801016:	e8 ad fe ff ff       	call   800ec8 <nsipc>
}
  80101b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801020:	f3 0f 1e fb          	endbr32 
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80103a:	b8 06 00 00 00       	mov    $0x6,%eax
  80103f:	e8 84 fe ff ff       	call   800ec8 <nsipc>
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801046:	f3 0f 1e fb          	endbr32 
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
  80104f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80105a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801060:	8b 45 14             	mov    0x14(%ebp),%eax
  801063:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801068:	b8 07 00 00 00       	mov    $0x7,%eax
  80106d:	e8 56 fe ff ff       	call   800ec8 <nsipc>
  801072:	89 c3                	mov    %eax,%ebx
  801074:	85 c0                	test   %eax,%eax
  801076:	78 26                	js     80109e <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801078:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80107e:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801083:	0f 4e c6             	cmovle %esi,%eax
  801086:	39 c3                	cmp    %eax,%ebx
  801088:	7f 1d                	jg     8010a7 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80108a:	83 ec 04             	sub    $0x4,%esp
  80108d:	53                   	push   %ebx
  80108e:	68 00 60 80 00       	push   $0x806000
  801093:	ff 75 0c             	pushl  0xc(%ebp)
  801096:	e8 54 0e 00 00       	call   801eef <memmove>
  80109b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80109e:	89 d8                	mov    %ebx,%eax
  8010a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8010a7:	68 8b 25 80 00       	push   $0x80258b
  8010ac:	68 53 25 80 00       	push   $0x802553
  8010b1:	6a 62                	push   $0x62
  8010b3:	68 a0 25 80 00       	push   $0x8025a0
  8010b8:	e8 8b 05 00 00       	call   801648 <_panic>

008010bd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8010bd:	f3 0f 1e fb          	endbr32 
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	53                   	push   %ebx
  8010c5:	83 ec 04             	sub    $0x4,%esp
  8010c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8010d3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8010d9:	7f 2e                	jg     801109 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8010db:	83 ec 04             	sub    $0x4,%esp
  8010de:	53                   	push   %ebx
  8010df:	ff 75 0c             	pushl  0xc(%ebp)
  8010e2:	68 0c 60 80 00       	push   $0x80600c
  8010e7:	e8 03 0e 00 00       	call   801eef <memmove>
	nsipcbuf.send.req_size = size;
  8010ec:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8010f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8010fa:	b8 08 00 00 00       	mov    $0x8,%eax
  8010ff:	e8 c4 fd ff ff       	call   800ec8 <nsipc>
}
  801104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801107:	c9                   	leave  
  801108:	c3                   	ret    
	assert(size < 1600);
  801109:	68 ac 25 80 00       	push   $0x8025ac
  80110e:	68 53 25 80 00       	push   $0x802553
  801113:	6a 6d                	push   $0x6d
  801115:	68 a0 25 80 00       	push   $0x8025a0
  80111a:	e8 29 05 00 00       	call   801648 <_panic>

0080111f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80111f:	f3 0f 1e fb          	endbr32 
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801139:	8b 45 10             	mov    0x10(%ebp),%eax
  80113c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801141:	b8 09 00 00 00       	mov    $0x9,%eax
  801146:	e8 7d fd ff ff       	call   800ec8 <nsipc>
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80114d:	f3 0f 1e fb          	endbr32 
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	56                   	push   %esi
  801155:	53                   	push   %ebx
  801156:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 f6 f2 ff ff       	call   80045a <fd2data>
  801164:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801166:	83 c4 08             	add    $0x8,%esp
  801169:	68 b8 25 80 00       	push   $0x8025b8
  80116e:	53                   	push   %ebx
  80116f:	e8 c5 0b 00 00       	call   801d39 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801174:	8b 46 04             	mov    0x4(%esi),%eax
  801177:	2b 06                	sub    (%esi),%eax
  801179:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80117f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801186:	00 00 00 
	stat->st_dev = &devpipe;
  801189:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801190:	30 80 00 
	return 0;
}
  801193:	b8 00 00 00 00       	mov    $0x0,%eax
  801198:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80119b:	5b                   	pop    %ebx
  80119c:	5e                   	pop    %esi
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    

0080119f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80119f:	f3 0f 1e fb          	endbr32 
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	53                   	push   %ebx
  8011a7:	83 ec 0c             	sub    $0xc,%esp
  8011aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8011ad:	53                   	push   %ebx
  8011ae:	6a 00                	push   $0x0
  8011b0:	e8 5e f0 ff ff       	call   800213 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011b5:	89 1c 24             	mov    %ebx,(%esp)
  8011b8:	e8 9d f2 ff ff       	call   80045a <fd2data>
  8011bd:	83 c4 08             	add    $0x8,%esp
  8011c0:	50                   	push   %eax
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 4b f0 ff ff       	call   800213 <sys_page_unmap>
}
  8011c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <_pipeisclosed>:
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	57                   	push   %edi
  8011d1:	56                   	push   %esi
  8011d2:	53                   	push   %ebx
  8011d3:	83 ec 1c             	sub    $0x1c,%esp
  8011d6:	89 c7                	mov    %eax,%edi
  8011d8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8011da:	a1 08 40 80 00       	mov    0x804008,%eax
  8011df:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8011e2:	83 ec 0c             	sub    $0xc,%esp
  8011e5:	57                   	push   %edi
  8011e6:	e8 da 0f 00 00       	call   8021c5 <pageref>
  8011eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011ee:	89 34 24             	mov    %esi,(%esp)
  8011f1:	e8 cf 0f 00 00       	call   8021c5 <pageref>
		nn = thisenv->env_runs;
  8011f6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011fc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	39 cb                	cmp    %ecx,%ebx
  801204:	74 1b                	je     801221 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801206:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801209:	75 cf                	jne    8011da <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80120b:	8b 42 58             	mov    0x58(%edx),%eax
  80120e:	6a 01                	push   $0x1
  801210:	50                   	push   %eax
  801211:	53                   	push   %ebx
  801212:	68 bf 25 80 00       	push   $0x8025bf
  801217:	e8 13 05 00 00       	call   80172f <cprintf>
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	eb b9                	jmp    8011da <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801221:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801224:	0f 94 c0             	sete   %al
  801227:	0f b6 c0             	movzbl %al,%eax
}
  80122a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122d:	5b                   	pop    %ebx
  80122e:	5e                   	pop    %esi
  80122f:	5f                   	pop    %edi
  801230:	5d                   	pop    %ebp
  801231:	c3                   	ret    

00801232 <devpipe_write>:
{
  801232:	f3 0f 1e fb          	endbr32 
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	57                   	push   %edi
  80123a:	56                   	push   %esi
  80123b:	53                   	push   %ebx
  80123c:	83 ec 28             	sub    $0x28,%esp
  80123f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801242:	56                   	push   %esi
  801243:	e8 12 f2 ff ff       	call   80045a <fd2data>
  801248:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	bf 00 00 00 00       	mov    $0x0,%edi
  801252:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801255:	74 4f                	je     8012a6 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801257:	8b 43 04             	mov    0x4(%ebx),%eax
  80125a:	8b 0b                	mov    (%ebx),%ecx
  80125c:	8d 51 20             	lea    0x20(%ecx),%edx
  80125f:	39 d0                	cmp    %edx,%eax
  801261:	72 14                	jb     801277 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801263:	89 da                	mov    %ebx,%edx
  801265:	89 f0                	mov    %esi,%eax
  801267:	e8 61 ff ff ff       	call   8011cd <_pipeisclosed>
  80126c:	85 c0                	test   %eax,%eax
  80126e:	75 3b                	jne    8012ab <devpipe_write+0x79>
			sys_yield();
  801270:	e8 ee ee ff ff       	call   800163 <sys_yield>
  801275:	eb e0                	jmp    801257 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80127e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801281:	89 c2                	mov    %eax,%edx
  801283:	c1 fa 1f             	sar    $0x1f,%edx
  801286:	89 d1                	mov    %edx,%ecx
  801288:	c1 e9 1b             	shr    $0x1b,%ecx
  80128b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80128e:	83 e2 1f             	and    $0x1f,%edx
  801291:	29 ca                	sub    %ecx,%edx
  801293:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801297:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80129b:	83 c0 01             	add    $0x1,%eax
  80129e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8012a1:	83 c7 01             	add    $0x1,%edi
  8012a4:	eb ac                	jmp    801252 <devpipe_write+0x20>
	return i;
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	eb 05                	jmp    8012b0 <devpipe_write+0x7e>
				return 0;
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b3:	5b                   	pop    %ebx
  8012b4:	5e                   	pop    %esi
  8012b5:	5f                   	pop    %edi
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    

008012b8 <devpipe_read>:
{
  8012b8:	f3 0f 1e fb          	endbr32 
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	57                   	push   %edi
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 18             	sub    $0x18,%esp
  8012c5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8012c8:	57                   	push   %edi
  8012c9:	e8 8c f1 ff ff       	call   80045a <fd2data>
  8012ce:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	be 00 00 00 00       	mov    $0x0,%esi
  8012d8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012db:	75 14                	jne    8012f1 <devpipe_read+0x39>
	return i;
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	eb 02                	jmp    8012e4 <devpipe_read+0x2c>
				return i;
  8012e2:	89 f0                	mov    %esi,%eax
}
  8012e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5f                   	pop    %edi
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    
			sys_yield();
  8012ec:	e8 72 ee ff ff       	call   800163 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8012f1:	8b 03                	mov    (%ebx),%eax
  8012f3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8012f6:	75 18                	jne    801310 <devpipe_read+0x58>
			if (i > 0)
  8012f8:	85 f6                	test   %esi,%esi
  8012fa:	75 e6                	jne    8012e2 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8012fc:	89 da                	mov    %ebx,%edx
  8012fe:	89 f8                	mov    %edi,%eax
  801300:	e8 c8 fe ff ff       	call   8011cd <_pipeisclosed>
  801305:	85 c0                	test   %eax,%eax
  801307:	74 e3                	je     8012ec <devpipe_read+0x34>
				return 0;
  801309:	b8 00 00 00 00       	mov    $0x0,%eax
  80130e:	eb d4                	jmp    8012e4 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801310:	99                   	cltd   
  801311:	c1 ea 1b             	shr    $0x1b,%edx
  801314:	01 d0                	add    %edx,%eax
  801316:	83 e0 1f             	and    $0x1f,%eax
  801319:	29 d0                	sub    %edx,%eax
  80131b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801320:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801323:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801326:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801329:	83 c6 01             	add    $0x1,%esi
  80132c:	eb aa                	jmp    8012d8 <devpipe_read+0x20>

0080132e <pipe>:
{
  80132e:	f3 0f 1e fb          	endbr32 
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	56                   	push   %esi
  801336:	53                   	push   %ebx
  801337:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80133a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133d:	50                   	push   %eax
  80133e:	e8 32 f1 ff ff       	call   800475 <fd_alloc>
  801343:	89 c3                	mov    %eax,%ebx
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	0f 88 23 01 00 00    	js     801473 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801350:	83 ec 04             	sub    $0x4,%esp
  801353:	68 07 04 00 00       	push   $0x407
  801358:	ff 75 f4             	pushl  -0xc(%ebp)
  80135b:	6a 00                	push   $0x0
  80135d:	e8 24 ee ff ff       	call   800186 <sys_page_alloc>
  801362:	89 c3                	mov    %eax,%ebx
  801364:	83 c4 10             	add    $0x10,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	0f 88 04 01 00 00    	js     801473 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80136f:	83 ec 0c             	sub    $0xc,%esp
  801372:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801375:	50                   	push   %eax
  801376:	e8 fa f0 ff ff       	call   800475 <fd_alloc>
  80137b:	89 c3                	mov    %eax,%ebx
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	0f 88 db 00 00 00    	js     801463 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	68 07 04 00 00       	push   $0x407
  801390:	ff 75 f0             	pushl  -0x10(%ebp)
  801393:	6a 00                	push   $0x0
  801395:	e8 ec ed ff ff       	call   800186 <sys_page_alloc>
  80139a:	89 c3                	mov    %eax,%ebx
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	0f 88 bc 00 00 00    	js     801463 <pipe+0x135>
	va = fd2data(fd0);
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ad:	e8 a8 f0 ff ff       	call   80045a <fd2data>
  8013b2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013b4:	83 c4 0c             	add    $0xc,%esp
  8013b7:	68 07 04 00 00       	push   $0x407
  8013bc:	50                   	push   %eax
  8013bd:	6a 00                	push   $0x0
  8013bf:	e8 c2 ed ff ff       	call   800186 <sys_page_alloc>
  8013c4:	89 c3                	mov    %eax,%ebx
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	0f 88 82 00 00 00    	js     801453 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013d1:	83 ec 0c             	sub    $0xc,%esp
  8013d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8013d7:	e8 7e f0 ff ff       	call   80045a <fd2data>
  8013dc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8013e3:	50                   	push   %eax
  8013e4:	6a 00                	push   $0x0
  8013e6:	56                   	push   %esi
  8013e7:	6a 00                	push   $0x0
  8013e9:	e8 df ed ff ff       	call   8001cd <sys_page_map>
  8013ee:	89 c3                	mov    %eax,%ebx
  8013f0:	83 c4 20             	add    $0x20,%esp
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	78 4e                	js     801445 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8013f7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8013fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ff:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801401:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801404:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80140b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80140e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80141a:	83 ec 0c             	sub    $0xc,%esp
  80141d:	ff 75 f4             	pushl  -0xc(%ebp)
  801420:	e8 21 f0 ff ff       	call   800446 <fd2num>
  801425:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801428:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80142a:	83 c4 04             	add    $0x4,%esp
  80142d:	ff 75 f0             	pushl  -0x10(%ebp)
  801430:	e8 11 f0 ff ff       	call   800446 <fd2num>
  801435:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801438:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801443:	eb 2e                	jmp    801473 <pipe+0x145>
	sys_page_unmap(0, va);
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	56                   	push   %esi
  801449:	6a 00                	push   $0x0
  80144b:	e8 c3 ed ff ff       	call   800213 <sys_page_unmap>
  801450:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	ff 75 f0             	pushl  -0x10(%ebp)
  801459:	6a 00                	push   $0x0
  80145b:	e8 b3 ed ff ff       	call   800213 <sys_page_unmap>
  801460:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801463:	83 ec 08             	sub    $0x8,%esp
  801466:	ff 75 f4             	pushl  -0xc(%ebp)
  801469:	6a 00                	push   $0x0
  80146b:	e8 a3 ed ff ff       	call   800213 <sys_page_unmap>
  801470:	83 c4 10             	add    $0x10,%esp
}
  801473:	89 d8                	mov    %ebx,%eax
  801475:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801478:	5b                   	pop    %ebx
  801479:	5e                   	pop    %esi
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <pipeisclosed>:
{
  80147c:	f3 0f 1e fb          	endbr32 
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801486:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801489:	50                   	push   %eax
  80148a:	ff 75 08             	pushl  0x8(%ebp)
  80148d:	e8 39 f0 ff ff       	call   8004cb <fd_lookup>
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 18                	js     8014b1 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801499:	83 ec 0c             	sub    $0xc,%esp
  80149c:	ff 75 f4             	pushl  -0xc(%ebp)
  80149f:	e8 b6 ef ff ff       	call   80045a <fd2data>
  8014a4:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a9:	e8 1f fd ff ff       	call   8011cd <_pipeisclosed>
  8014ae:	83 c4 10             	add    $0x10,%esp
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8014b3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bc:	c3                   	ret    

008014bd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8014bd:	f3 0f 1e fb          	endbr32 
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8014c7:	68 d7 25 80 00       	push   $0x8025d7
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	e8 65 08 00 00       	call   801d39 <strcpy>
	return 0;
}
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <devcons_write>:
{
  8014db:	f3 0f 1e fb          	endbr32 
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	57                   	push   %edi
  8014e3:	56                   	push   %esi
  8014e4:	53                   	push   %ebx
  8014e5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8014eb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8014f0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8014f6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014f9:	73 31                	jae    80152c <devcons_write+0x51>
		m = n - tot;
  8014fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014fe:	29 f3                	sub    %esi,%ebx
  801500:	83 fb 7f             	cmp    $0x7f,%ebx
  801503:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801508:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80150b:	83 ec 04             	sub    $0x4,%esp
  80150e:	53                   	push   %ebx
  80150f:	89 f0                	mov    %esi,%eax
  801511:	03 45 0c             	add    0xc(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	57                   	push   %edi
  801516:	e8 d4 09 00 00       	call   801eef <memmove>
		sys_cputs(buf, m);
  80151b:	83 c4 08             	add    $0x8,%esp
  80151e:	53                   	push   %ebx
  80151f:	57                   	push   %edi
  801520:	e8 91 eb ff ff       	call   8000b6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801525:	01 de                	add    %ebx,%esi
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	eb ca                	jmp    8014f6 <devcons_write+0x1b>
}
  80152c:	89 f0                	mov    %esi,%eax
  80152e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5f                   	pop    %edi
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    

00801536 <devcons_read>:
{
  801536:	f3 0f 1e fb          	endbr32 
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801545:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801549:	74 21                	je     80156c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80154b:	e8 88 eb ff ff       	call   8000d8 <sys_cgetc>
  801550:	85 c0                	test   %eax,%eax
  801552:	75 07                	jne    80155b <devcons_read+0x25>
		sys_yield();
  801554:	e8 0a ec ff ff       	call   800163 <sys_yield>
  801559:	eb f0                	jmp    80154b <devcons_read+0x15>
	if (c < 0)
  80155b:	78 0f                	js     80156c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80155d:	83 f8 04             	cmp    $0x4,%eax
  801560:	74 0c                	je     80156e <devcons_read+0x38>
	*(char*)vbuf = c;
  801562:	8b 55 0c             	mov    0xc(%ebp),%edx
  801565:	88 02                	mov    %al,(%edx)
	return 1;
  801567:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    
		return 0;
  80156e:	b8 00 00 00 00       	mov    $0x0,%eax
  801573:	eb f7                	jmp    80156c <devcons_read+0x36>

00801575 <cputchar>:
{
  801575:	f3 0f 1e fb          	endbr32 
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801585:	6a 01                	push   $0x1
  801587:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80158a:	50                   	push   %eax
  80158b:	e8 26 eb ff ff       	call   8000b6 <sys_cputs>
}
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <getchar>:
{
  801595:	f3 0f 1e fb          	endbr32 
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80159f:	6a 01                	push   $0x1
  8015a1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8015a4:	50                   	push   %eax
  8015a5:	6a 00                	push   $0x0
  8015a7:	e8 a7 f1 ff ff       	call   800753 <read>
	if (r < 0)
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	78 06                	js     8015b9 <getchar+0x24>
	if (r < 1)
  8015b3:	74 06                	je     8015bb <getchar+0x26>
	return c;
  8015b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    
		return -E_EOF;
  8015bb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8015c0:	eb f7                	jmp    8015b9 <getchar+0x24>

008015c2 <iscons>:
{
  8015c2:	f3 0f 1e fb          	endbr32 
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cf:	50                   	push   %eax
  8015d0:	ff 75 08             	pushl  0x8(%ebp)
  8015d3:	e8 f3 ee ff ff       	call   8004cb <fd_lookup>
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	78 11                	js     8015f0 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8015df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8015e8:	39 10                	cmp    %edx,(%eax)
  8015ea:	0f 94 c0             	sete   %al
  8015ed:	0f b6 c0             	movzbl %al,%eax
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <opencons>:
{
  8015f2:	f3 0f 1e fb          	endbr32 
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8015fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	e8 70 ee ff ff       	call   800475 <fd_alloc>
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	85 c0                	test   %eax,%eax
  80160a:	78 3a                	js     801646 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	68 07 04 00 00       	push   $0x407
  801614:	ff 75 f4             	pushl  -0xc(%ebp)
  801617:	6a 00                	push   $0x0
  801619:	e8 68 eb ff ff       	call   800186 <sys_page_alloc>
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	85 c0                	test   %eax,%eax
  801623:	78 21                	js     801646 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801628:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80162e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801633:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	50                   	push   %eax
  80163e:	e8 03 ee ff ff       	call   800446 <fd2num>
  801643:	83 c4 10             	add    $0x10,%esp
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801648:	f3 0f 1e fb          	endbr32 
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	56                   	push   %esi
  801650:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801651:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801654:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80165a:	e8 e1 ea ff ff       	call   800140 <sys_getenvid>
  80165f:	83 ec 0c             	sub    $0xc,%esp
  801662:	ff 75 0c             	pushl  0xc(%ebp)
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	56                   	push   %esi
  801669:	50                   	push   %eax
  80166a:	68 e4 25 80 00       	push   $0x8025e4
  80166f:	e8 bb 00 00 00       	call   80172f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801674:	83 c4 18             	add    $0x18,%esp
  801677:	53                   	push   %ebx
  801678:	ff 75 10             	pushl  0x10(%ebp)
  80167b:	e8 5a 00 00 00       	call   8016da <vcprintf>
	cprintf("\n");
  801680:	c7 04 24 18 29 80 00 	movl   $0x802918,(%esp)
  801687:	e8 a3 00 00 00       	call   80172f <cprintf>
  80168c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80168f:	cc                   	int3   
  801690:	eb fd                	jmp    80168f <_panic+0x47>

00801692 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801692:	f3 0f 1e fb          	endbr32 
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	53                   	push   %ebx
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8016a0:	8b 13                	mov    (%ebx),%edx
  8016a2:	8d 42 01             	lea    0x1(%edx),%eax
  8016a5:	89 03                	mov    %eax,(%ebx)
  8016a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8016ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8016b3:	74 09                	je     8016be <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8016b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8016b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8016be:	83 ec 08             	sub    $0x8,%esp
  8016c1:	68 ff 00 00 00       	push   $0xff
  8016c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8016c9:	50                   	push   %eax
  8016ca:	e8 e7 e9 ff ff       	call   8000b6 <sys_cputs>
		b->idx = 0;
  8016cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	eb db                	jmp    8016b5 <putch+0x23>

008016da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8016da:	f3 0f 1e fb          	endbr32 
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016ee:	00 00 00 
	b.cnt = 0;
  8016f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8016f8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	ff 75 08             	pushl  0x8(%ebp)
  801701:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801707:	50                   	push   %eax
  801708:	68 92 16 80 00       	push   $0x801692
  80170d:	e8 20 01 00 00       	call   801832 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801712:	83 c4 08             	add    $0x8,%esp
  801715:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80171b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801721:	50                   	push   %eax
  801722:	e8 8f e9 ff ff       	call   8000b6 <sys_cputs>

	return b.cnt;
}
  801727:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80172f:	f3 0f 1e fb          	endbr32 
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801739:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80173c:	50                   	push   %eax
  80173d:	ff 75 08             	pushl  0x8(%ebp)
  801740:	e8 95 ff ff ff       	call   8016da <vcprintf>
	va_end(ap);

	return cnt;
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	57                   	push   %edi
  80174b:	56                   	push   %esi
  80174c:	53                   	push   %ebx
  80174d:	83 ec 1c             	sub    $0x1c,%esp
  801750:	89 c7                	mov    %eax,%edi
  801752:	89 d6                	mov    %edx,%esi
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175a:	89 d1                	mov    %edx,%ecx
  80175c:	89 c2                	mov    %eax,%edx
  80175e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801761:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801764:	8b 45 10             	mov    0x10(%ebp),%eax
  801767:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80176a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80176d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801774:	39 c2                	cmp    %eax,%edx
  801776:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801779:	72 3e                	jb     8017b9 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80177b:	83 ec 0c             	sub    $0xc,%esp
  80177e:	ff 75 18             	pushl  0x18(%ebp)
  801781:	83 eb 01             	sub    $0x1,%ebx
  801784:	53                   	push   %ebx
  801785:	50                   	push   %eax
  801786:	83 ec 08             	sub    $0x8,%esp
  801789:	ff 75 e4             	pushl  -0x1c(%ebp)
  80178c:	ff 75 e0             	pushl  -0x20(%ebp)
  80178f:	ff 75 dc             	pushl  -0x24(%ebp)
  801792:	ff 75 d8             	pushl  -0x28(%ebp)
  801795:	e8 76 0a 00 00       	call   802210 <__udivdi3>
  80179a:	83 c4 18             	add    $0x18,%esp
  80179d:	52                   	push   %edx
  80179e:	50                   	push   %eax
  80179f:	89 f2                	mov    %esi,%edx
  8017a1:	89 f8                	mov    %edi,%eax
  8017a3:	e8 9f ff ff ff       	call   801747 <printnum>
  8017a8:	83 c4 20             	add    $0x20,%esp
  8017ab:	eb 13                	jmp    8017c0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	56                   	push   %esi
  8017b1:	ff 75 18             	pushl  0x18(%ebp)
  8017b4:	ff d7                	call   *%edi
  8017b6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8017b9:	83 eb 01             	sub    $0x1,%ebx
  8017bc:	85 db                	test   %ebx,%ebx
  8017be:	7f ed                	jg     8017ad <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017c0:	83 ec 08             	sub    $0x8,%esp
  8017c3:	56                   	push   %esi
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8017cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8017d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8017d3:	e8 48 0b 00 00       	call   802320 <__umoddi3>
  8017d8:	83 c4 14             	add    $0x14,%esp
  8017db:	0f be 80 07 26 80 00 	movsbl 0x802607(%eax),%eax
  8017e2:	50                   	push   %eax
  8017e3:	ff d7                	call   *%edi
}
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017eb:	5b                   	pop    %ebx
  8017ec:	5e                   	pop    %esi
  8017ed:	5f                   	pop    %edi
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017f0:	f3 0f 1e fb          	endbr32 
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8017fa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8017fe:	8b 10                	mov    (%eax),%edx
  801800:	3b 50 04             	cmp    0x4(%eax),%edx
  801803:	73 0a                	jae    80180f <sprintputch+0x1f>
		*b->buf++ = ch;
  801805:	8d 4a 01             	lea    0x1(%edx),%ecx
  801808:	89 08                	mov    %ecx,(%eax)
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	88 02                	mov    %al,(%edx)
}
  80180f:	5d                   	pop    %ebp
  801810:	c3                   	ret    

00801811 <printfmt>:
{
  801811:	f3 0f 1e fb          	endbr32 
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80181b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80181e:	50                   	push   %eax
  80181f:	ff 75 10             	pushl  0x10(%ebp)
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	e8 05 00 00 00       	call   801832 <vprintfmt>
}
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <vprintfmt>:
{
  801832:	f3 0f 1e fb          	endbr32 
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	57                   	push   %edi
  80183a:	56                   	push   %esi
  80183b:	53                   	push   %ebx
  80183c:	83 ec 3c             	sub    $0x3c,%esp
  80183f:	8b 75 08             	mov    0x8(%ebp),%esi
  801842:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801845:	8b 7d 10             	mov    0x10(%ebp),%edi
  801848:	e9 8e 03 00 00       	jmp    801bdb <vprintfmt+0x3a9>
		padc = ' ';
  80184d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801851:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801858:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80185f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801866:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80186b:	8d 47 01             	lea    0x1(%edi),%eax
  80186e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801871:	0f b6 17             	movzbl (%edi),%edx
  801874:	8d 42 dd             	lea    -0x23(%edx),%eax
  801877:	3c 55                	cmp    $0x55,%al
  801879:	0f 87 df 03 00 00    	ja     801c5e <vprintfmt+0x42c>
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	3e ff 24 85 40 27 80 	notrack jmp *0x802740(,%eax,4)
  801889:	00 
  80188a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80188d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801891:	eb d8                	jmp    80186b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801893:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801896:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80189a:	eb cf                	jmp    80186b <vprintfmt+0x39>
  80189c:	0f b6 d2             	movzbl %dl,%edx
  80189f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8018a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8018aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8018ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8018b1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8018b4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8018b7:	83 f9 09             	cmp    $0x9,%ecx
  8018ba:	77 55                	ja     801911 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8018bc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8018bf:	eb e9                	jmp    8018aa <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8018c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c4:	8b 00                	mov    (%eax),%eax
  8018c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cc:	8d 40 04             	lea    0x4(%eax),%eax
  8018cf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8018d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018d9:	79 90                	jns    80186b <vprintfmt+0x39>
				width = precision, precision = -1;
  8018db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8018e8:	eb 81                	jmp    80186b <vprintfmt+0x39>
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f4:	0f 49 d0             	cmovns %eax,%edx
  8018f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8018fd:	e9 69 ff ff ff       	jmp    80186b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801902:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801905:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80190c:	e9 5a ff ff ff       	jmp    80186b <vprintfmt+0x39>
  801911:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801914:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801917:	eb bc                	jmp    8018d5 <vprintfmt+0xa3>
			lflag++;
  801919:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80191c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80191f:	e9 47 ff ff ff       	jmp    80186b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801924:	8b 45 14             	mov    0x14(%ebp),%eax
  801927:	8d 78 04             	lea    0x4(%eax),%edi
  80192a:	83 ec 08             	sub    $0x8,%esp
  80192d:	53                   	push   %ebx
  80192e:	ff 30                	pushl  (%eax)
  801930:	ff d6                	call   *%esi
			break;
  801932:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801935:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801938:	e9 9b 02 00 00       	jmp    801bd8 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80193d:	8b 45 14             	mov    0x14(%ebp),%eax
  801940:	8d 78 04             	lea    0x4(%eax),%edi
  801943:	8b 00                	mov    (%eax),%eax
  801945:	99                   	cltd   
  801946:	31 d0                	xor    %edx,%eax
  801948:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80194a:	83 f8 0f             	cmp    $0xf,%eax
  80194d:	7f 23                	jg     801972 <vprintfmt+0x140>
  80194f:	8b 14 85 a0 28 80 00 	mov    0x8028a0(,%eax,4),%edx
  801956:	85 d2                	test   %edx,%edx
  801958:	74 18                	je     801972 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80195a:	52                   	push   %edx
  80195b:	68 65 25 80 00       	push   $0x802565
  801960:	53                   	push   %ebx
  801961:	56                   	push   %esi
  801962:	e8 aa fe ff ff       	call   801811 <printfmt>
  801967:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80196a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80196d:	e9 66 02 00 00       	jmp    801bd8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801972:	50                   	push   %eax
  801973:	68 1f 26 80 00       	push   $0x80261f
  801978:	53                   	push   %ebx
  801979:	56                   	push   %esi
  80197a:	e8 92 fe ff ff       	call   801811 <printfmt>
  80197f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801982:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801985:	e9 4e 02 00 00       	jmp    801bd8 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80198a:	8b 45 14             	mov    0x14(%ebp),%eax
  80198d:	83 c0 04             	add    $0x4,%eax
  801990:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801993:	8b 45 14             	mov    0x14(%ebp),%eax
  801996:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801998:	85 d2                	test   %edx,%edx
  80199a:	b8 18 26 80 00       	mov    $0x802618,%eax
  80199f:	0f 45 c2             	cmovne %edx,%eax
  8019a2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8019a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019a9:	7e 06                	jle    8019b1 <vprintfmt+0x17f>
  8019ab:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8019af:	75 0d                	jne    8019be <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019b4:	89 c7                	mov    %eax,%edi
  8019b6:	03 45 e0             	add    -0x20(%ebp),%eax
  8019b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019bc:	eb 55                	jmp    801a13 <vprintfmt+0x1e1>
  8019be:	83 ec 08             	sub    $0x8,%esp
  8019c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8019c4:	ff 75 cc             	pushl  -0x34(%ebp)
  8019c7:	e8 46 03 00 00       	call   801d12 <strnlen>
  8019cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019cf:	29 c2                	sub    %eax,%edx
  8019d1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8019d9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8019dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8019e0:	85 ff                	test   %edi,%edi
  8019e2:	7e 11                	jle    8019f5 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8019e4:	83 ec 08             	sub    $0x8,%esp
  8019e7:	53                   	push   %ebx
  8019e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8019eb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8019ed:	83 ef 01             	sub    $0x1,%edi
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	eb eb                	jmp    8019e0 <vprintfmt+0x1ae>
  8019f5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019f8:	85 d2                	test   %edx,%edx
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ff:	0f 49 c2             	cmovns %edx,%eax
  801a02:	29 c2                	sub    %eax,%edx
  801a04:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801a07:	eb a8                	jmp    8019b1 <vprintfmt+0x17f>
					putch(ch, putdat);
  801a09:	83 ec 08             	sub    $0x8,%esp
  801a0c:	53                   	push   %ebx
  801a0d:	52                   	push   %edx
  801a0e:	ff d6                	call   *%esi
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801a16:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a18:	83 c7 01             	add    $0x1,%edi
  801a1b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a1f:	0f be d0             	movsbl %al,%edx
  801a22:	85 d2                	test   %edx,%edx
  801a24:	74 4b                	je     801a71 <vprintfmt+0x23f>
  801a26:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a2a:	78 06                	js     801a32 <vprintfmt+0x200>
  801a2c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801a30:	78 1e                	js     801a50 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801a32:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a36:	74 d1                	je     801a09 <vprintfmt+0x1d7>
  801a38:	0f be c0             	movsbl %al,%eax
  801a3b:	83 e8 20             	sub    $0x20,%eax
  801a3e:	83 f8 5e             	cmp    $0x5e,%eax
  801a41:	76 c6                	jbe    801a09 <vprintfmt+0x1d7>
					putch('?', putdat);
  801a43:	83 ec 08             	sub    $0x8,%esp
  801a46:	53                   	push   %ebx
  801a47:	6a 3f                	push   $0x3f
  801a49:	ff d6                	call   *%esi
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	eb c3                	jmp    801a13 <vprintfmt+0x1e1>
  801a50:	89 cf                	mov    %ecx,%edi
  801a52:	eb 0e                	jmp    801a62 <vprintfmt+0x230>
				putch(' ', putdat);
  801a54:	83 ec 08             	sub    $0x8,%esp
  801a57:	53                   	push   %ebx
  801a58:	6a 20                	push   $0x20
  801a5a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801a5c:	83 ef 01             	sub    $0x1,%edi
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	85 ff                	test   %edi,%edi
  801a64:	7f ee                	jg     801a54 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a66:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a69:	89 45 14             	mov    %eax,0x14(%ebp)
  801a6c:	e9 67 01 00 00       	jmp    801bd8 <vprintfmt+0x3a6>
  801a71:	89 cf                	mov    %ecx,%edi
  801a73:	eb ed                	jmp    801a62 <vprintfmt+0x230>
	if (lflag >= 2)
  801a75:	83 f9 01             	cmp    $0x1,%ecx
  801a78:	7f 1b                	jg     801a95 <vprintfmt+0x263>
	else if (lflag)
  801a7a:	85 c9                	test   %ecx,%ecx
  801a7c:	74 63                	je     801ae1 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a81:	8b 00                	mov    (%eax),%eax
  801a83:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a86:	99                   	cltd   
  801a87:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8d:	8d 40 04             	lea    0x4(%eax),%eax
  801a90:	89 45 14             	mov    %eax,0x14(%ebp)
  801a93:	eb 17                	jmp    801aac <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a95:	8b 45 14             	mov    0x14(%ebp),%eax
  801a98:	8b 50 04             	mov    0x4(%eax),%edx
  801a9b:	8b 00                	mov    (%eax),%eax
  801a9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aa0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa6:	8d 40 08             	lea    0x8(%eax),%eax
  801aa9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801aac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aaf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801ab2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801ab7:	85 c9                	test   %ecx,%ecx
  801ab9:	0f 89 ff 00 00 00    	jns    801bbe <vprintfmt+0x38c>
				putch('-', putdat);
  801abf:	83 ec 08             	sub    $0x8,%esp
  801ac2:	53                   	push   %ebx
  801ac3:	6a 2d                	push   $0x2d
  801ac5:	ff d6                	call   *%esi
				num = -(long long) num;
  801ac7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801acd:	f7 da                	neg    %edx
  801acf:	83 d1 00             	adc    $0x0,%ecx
  801ad2:	f7 d9                	neg    %ecx
  801ad4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801ad7:	b8 0a 00 00 00       	mov    $0xa,%eax
  801adc:	e9 dd 00 00 00       	jmp    801bbe <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae4:	8b 00                	mov    (%eax),%eax
  801ae6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ae9:	99                   	cltd   
  801aea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801aed:	8b 45 14             	mov    0x14(%ebp),%eax
  801af0:	8d 40 04             	lea    0x4(%eax),%eax
  801af3:	89 45 14             	mov    %eax,0x14(%ebp)
  801af6:	eb b4                	jmp    801aac <vprintfmt+0x27a>
	if (lflag >= 2)
  801af8:	83 f9 01             	cmp    $0x1,%ecx
  801afb:	7f 1e                	jg     801b1b <vprintfmt+0x2e9>
	else if (lflag)
  801afd:	85 c9                	test   %ecx,%ecx
  801aff:	74 32                	je     801b33 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801b01:	8b 45 14             	mov    0x14(%ebp),%eax
  801b04:	8b 10                	mov    (%eax),%edx
  801b06:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b0b:	8d 40 04             	lea    0x4(%eax),%eax
  801b0e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b11:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801b16:	e9 a3 00 00 00       	jmp    801bbe <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1e:	8b 10                	mov    (%eax),%edx
  801b20:	8b 48 04             	mov    0x4(%eax),%ecx
  801b23:	8d 40 08             	lea    0x8(%eax),%eax
  801b26:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b29:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801b2e:	e9 8b 00 00 00       	jmp    801bbe <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b33:	8b 45 14             	mov    0x14(%ebp),%eax
  801b36:	8b 10                	mov    (%eax),%edx
  801b38:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3d:	8d 40 04             	lea    0x4(%eax),%eax
  801b40:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b43:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801b48:	eb 74                	jmp    801bbe <vprintfmt+0x38c>
	if (lflag >= 2)
  801b4a:	83 f9 01             	cmp    $0x1,%ecx
  801b4d:	7f 1b                	jg     801b6a <vprintfmt+0x338>
	else if (lflag)
  801b4f:	85 c9                	test   %ecx,%ecx
  801b51:	74 2c                	je     801b7f <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801b53:	8b 45 14             	mov    0x14(%ebp),%eax
  801b56:	8b 10                	mov    (%eax),%edx
  801b58:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b5d:	8d 40 04             	lea    0x4(%eax),%eax
  801b60:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b63:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b68:	eb 54                	jmp    801bbe <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6d:	8b 10                	mov    (%eax),%edx
  801b6f:	8b 48 04             	mov    0x4(%eax),%ecx
  801b72:	8d 40 08             	lea    0x8(%eax),%eax
  801b75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b78:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b7d:	eb 3f                	jmp    801bbe <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b82:	8b 10                	mov    (%eax),%edx
  801b84:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b89:	8d 40 04             	lea    0x4(%eax),%eax
  801b8c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b8f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b94:	eb 28                	jmp    801bbe <vprintfmt+0x38c>
			putch('0', putdat);
  801b96:	83 ec 08             	sub    $0x8,%esp
  801b99:	53                   	push   %ebx
  801b9a:	6a 30                	push   $0x30
  801b9c:	ff d6                	call   *%esi
			putch('x', putdat);
  801b9e:	83 c4 08             	add    $0x8,%esp
  801ba1:	53                   	push   %ebx
  801ba2:	6a 78                	push   $0x78
  801ba4:	ff d6                	call   *%esi
			num = (unsigned long long)
  801ba6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba9:	8b 10                	mov    (%eax),%edx
  801bab:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801bb0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801bb3:	8d 40 04             	lea    0x4(%eax),%eax
  801bb6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bb9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801bbe:	83 ec 0c             	sub    $0xc,%esp
  801bc1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801bc5:	57                   	push   %edi
  801bc6:	ff 75 e0             	pushl  -0x20(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	51                   	push   %ecx
  801bcb:	52                   	push   %edx
  801bcc:	89 da                	mov    %ebx,%edx
  801bce:	89 f0                	mov    %esi,%eax
  801bd0:	e8 72 fb ff ff       	call   801747 <printnum>
			break;
  801bd5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801bd8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bdb:	83 c7 01             	add    $0x1,%edi
  801bde:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801be2:	83 f8 25             	cmp    $0x25,%eax
  801be5:	0f 84 62 fc ff ff    	je     80184d <vprintfmt+0x1b>
			if (ch == '\0')
  801beb:	85 c0                	test   %eax,%eax
  801bed:	0f 84 8b 00 00 00    	je     801c7e <vprintfmt+0x44c>
			putch(ch, putdat);
  801bf3:	83 ec 08             	sub    $0x8,%esp
  801bf6:	53                   	push   %ebx
  801bf7:	50                   	push   %eax
  801bf8:	ff d6                	call   *%esi
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	eb dc                	jmp    801bdb <vprintfmt+0x3a9>
	if (lflag >= 2)
  801bff:	83 f9 01             	cmp    $0x1,%ecx
  801c02:	7f 1b                	jg     801c1f <vprintfmt+0x3ed>
	else if (lflag)
  801c04:	85 c9                	test   %ecx,%ecx
  801c06:	74 2c                	je     801c34 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801c08:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0b:	8b 10                	mov    (%eax),%edx
  801c0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c12:	8d 40 04             	lea    0x4(%eax),%eax
  801c15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c18:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801c1d:	eb 9f                	jmp    801bbe <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c22:	8b 10                	mov    (%eax),%edx
  801c24:	8b 48 04             	mov    0x4(%eax),%ecx
  801c27:	8d 40 08             	lea    0x8(%eax),%eax
  801c2a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c2d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801c32:	eb 8a                	jmp    801bbe <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801c34:	8b 45 14             	mov    0x14(%ebp),%eax
  801c37:	8b 10                	mov    (%eax),%edx
  801c39:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3e:	8d 40 04             	lea    0x4(%eax),%eax
  801c41:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c44:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801c49:	e9 70 ff ff ff       	jmp    801bbe <vprintfmt+0x38c>
			putch(ch, putdat);
  801c4e:	83 ec 08             	sub    $0x8,%esp
  801c51:	53                   	push   %ebx
  801c52:	6a 25                	push   $0x25
  801c54:	ff d6                	call   *%esi
			break;
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	e9 7a ff ff ff       	jmp    801bd8 <vprintfmt+0x3a6>
			putch('%', putdat);
  801c5e:	83 ec 08             	sub    $0x8,%esp
  801c61:	53                   	push   %ebx
  801c62:	6a 25                	push   $0x25
  801c64:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c66:	83 c4 10             	add    $0x10,%esp
  801c69:	89 f8                	mov    %edi,%eax
  801c6b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c6f:	74 05                	je     801c76 <vprintfmt+0x444>
  801c71:	83 e8 01             	sub    $0x1,%eax
  801c74:	eb f5                	jmp    801c6b <vprintfmt+0x439>
  801c76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c79:	e9 5a ff ff ff       	jmp    801bd8 <vprintfmt+0x3a6>
}
  801c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c81:	5b                   	pop    %ebx
  801c82:	5e                   	pop    %esi
  801c83:	5f                   	pop    %edi
  801c84:	5d                   	pop    %ebp
  801c85:	c3                   	ret    

00801c86 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c86:	f3 0f 1e fb          	endbr32 
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 18             	sub    $0x18,%esp
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c96:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c99:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c9d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801ca0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	74 26                	je     801cd1 <vsnprintf+0x4b>
  801cab:	85 d2                	test   %edx,%edx
  801cad:	7e 22                	jle    801cd1 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801caf:	ff 75 14             	pushl  0x14(%ebp)
  801cb2:	ff 75 10             	pushl  0x10(%ebp)
  801cb5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801cb8:	50                   	push   %eax
  801cb9:	68 f0 17 80 00       	push   $0x8017f0
  801cbe:	e8 6f fb ff ff       	call   801832 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccc:	83 c4 10             	add    $0x10,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    
		return -E_INVAL;
  801cd1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cd6:	eb f7                	jmp    801ccf <vsnprintf+0x49>

00801cd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801cd8:	f3 0f 1e fb          	endbr32 
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ce2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801ce5:	50                   	push   %eax
  801ce6:	ff 75 10             	pushl  0x10(%ebp)
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	ff 75 08             	pushl  0x8(%ebp)
  801cef:	e8 92 ff ff ff       	call   801c86 <vsnprintf>
	va_end(ap);

	return rc;
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801cf6:	f3 0f 1e fb          	endbr32 
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801d00:	b8 00 00 00 00       	mov    $0x0,%eax
  801d05:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801d09:	74 05                	je     801d10 <strlen+0x1a>
		n++;
  801d0b:	83 c0 01             	add    $0x1,%eax
  801d0e:	eb f5                	jmp    801d05 <strlen+0xf>
	return n;
}
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    

00801d12 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801d12:	f3 0f 1e fb          	endbr32 
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	39 d0                	cmp    %edx,%eax
  801d26:	74 0d                	je     801d35 <strnlen+0x23>
  801d28:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801d2c:	74 05                	je     801d33 <strnlen+0x21>
		n++;
  801d2e:	83 c0 01             	add    $0x1,%eax
  801d31:	eb f1                	jmp    801d24 <strnlen+0x12>
  801d33:	89 c2                	mov    %eax,%edx
	return n;
}
  801d35:	89 d0                	mov    %edx,%eax
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d39:	f3 0f 1e fb          	endbr32 
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	53                   	push   %ebx
  801d41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801d47:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801d50:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801d53:	83 c0 01             	add    $0x1,%eax
  801d56:	84 d2                	test   %dl,%dl
  801d58:	75 f2                	jne    801d4c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801d5a:	89 c8                	mov    %ecx,%eax
  801d5c:	5b                   	pop    %ebx
  801d5d:	5d                   	pop    %ebp
  801d5e:	c3                   	ret    

00801d5f <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d5f:	f3 0f 1e fb          	endbr32 
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	53                   	push   %ebx
  801d67:	83 ec 10             	sub    $0x10,%esp
  801d6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d6d:	53                   	push   %ebx
  801d6e:	e8 83 ff ff ff       	call   801cf6 <strlen>
  801d73:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	01 d8                	add    %ebx,%eax
  801d7b:	50                   	push   %eax
  801d7c:	e8 b8 ff ff ff       	call   801d39 <strcpy>
	return dst;
}
  801d81:	89 d8                	mov    %ebx,%eax
  801d83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d88:	f3 0f 1e fb          	endbr32 
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
  801d91:	8b 75 08             	mov    0x8(%ebp),%esi
  801d94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d97:	89 f3                	mov    %esi,%ebx
  801d99:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d9c:	89 f0                	mov    %esi,%eax
  801d9e:	39 d8                	cmp    %ebx,%eax
  801da0:	74 11                	je     801db3 <strncpy+0x2b>
		*dst++ = *src;
  801da2:	83 c0 01             	add    $0x1,%eax
  801da5:	0f b6 0a             	movzbl (%edx),%ecx
  801da8:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801dab:	80 f9 01             	cmp    $0x1,%cl
  801dae:	83 da ff             	sbb    $0xffffffff,%edx
  801db1:	eb eb                	jmp    801d9e <strncpy+0x16>
	}
	return ret;
}
  801db3:	89 f0                	mov    %esi,%eax
  801db5:	5b                   	pop    %ebx
  801db6:	5e                   	pop    %esi
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    

00801db9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801db9:	f3 0f 1e fb          	endbr32 
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	56                   	push   %esi
  801dc1:	53                   	push   %ebx
  801dc2:	8b 75 08             	mov    0x8(%ebp),%esi
  801dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dc8:	8b 55 10             	mov    0x10(%ebp),%edx
  801dcb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801dcd:	85 d2                	test   %edx,%edx
  801dcf:	74 21                	je     801df2 <strlcpy+0x39>
  801dd1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801dd5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801dd7:	39 c2                	cmp    %eax,%edx
  801dd9:	74 14                	je     801def <strlcpy+0x36>
  801ddb:	0f b6 19             	movzbl (%ecx),%ebx
  801dde:	84 db                	test   %bl,%bl
  801de0:	74 0b                	je     801ded <strlcpy+0x34>
			*dst++ = *src++;
  801de2:	83 c1 01             	add    $0x1,%ecx
  801de5:	83 c2 01             	add    $0x1,%edx
  801de8:	88 5a ff             	mov    %bl,-0x1(%edx)
  801deb:	eb ea                	jmp    801dd7 <strlcpy+0x1e>
  801ded:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801def:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801df2:	29 f0                	sub    %esi,%eax
}
  801df4:	5b                   	pop    %ebx
  801df5:	5e                   	pop    %esi
  801df6:	5d                   	pop    %ebp
  801df7:	c3                   	ret    

00801df8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801df8:	f3 0f 1e fb          	endbr32 
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801e05:	0f b6 01             	movzbl (%ecx),%eax
  801e08:	84 c0                	test   %al,%al
  801e0a:	74 0c                	je     801e18 <strcmp+0x20>
  801e0c:	3a 02                	cmp    (%edx),%al
  801e0e:	75 08                	jne    801e18 <strcmp+0x20>
		p++, q++;
  801e10:	83 c1 01             	add    $0x1,%ecx
  801e13:	83 c2 01             	add    $0x1,%edx
  801e16:	eb ed                	jmp    801e05 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e18:	0f b6 c0             	movzbl %al,%eax
  801e1b:	0f b6 12             	movzbl (%edx),%edx
  801e1e:	29 d0                	sub    %edx,%eax
}
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    

00801e22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801e22:	f3 0f 1e fb          	endbr32 
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	53                   	push   %ebx
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e30:	89 c3                	mov    %eax,%ebx
  801e32:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801e35:	eb 06                	jmp    801e3d <strncmp+0x1b>
		n--, p++, q++;
  801e37:	83 c0 01             	add    $0x1,%eax
  801e3a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801e3d:	39 d8                	cmp    %ebx,%eax
  801e3f:	74 16                	je     801e57 <strncmp+0x35>
  801e41:	0f b6 08             	movzbl (%eax),%ecx
  801e44:	84 c9                	test   %cl,%cl
  801e46:	74 04                	je     801e4c <strncmp+0x2a>
  801e48:	3a 0a                	cmp    (%edx),%cl
  801e4a:	74 eb                	je     801e37 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e4c:	0f b6 00             	movzbl (%eax),%eax
  801e4f:	0f b6 12             	movzbl (%edx),%edx
  801e52:	29 d0                	sub    %edx,%eax
}
  801e54:	5b                   	pop    %ebx
  801e55:	5d                   	pop    %ebp
  801e56:	c3                   	ret    
		return 0;
  801e57:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5c:	eb f6                	jmp    801e54 <strncmp+0x32>

00801e5e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e5e:	f3 0f 1e fb          	endbr32 
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e6c:	0f b6 10             	movzbl (%eax),%edx
  801e6f:	84 d2                	test   %dl,%dl
  801e71:	74 09                	je     801e7c <strchr+0x1e>
		if (*s == c)
  801e73:	38 ca                	cmp    %cl,%dl
  801e75:	74 0a                	je     801e81 <strchr+0x23>
	for (; *s; s++)
  801e77:	83 c0 01             	add    $0x1,%eax
  801e7a:	eb f0                	jmp    801e6c <strchr+0xe>
			return (char *) s;
	return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e81:	5d                   	pop    %ebp
  801e82:	c3                   	ret    

00801e83 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e83:	f3 0f 1e fb          	endbr32 
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e91:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e94:	38 ca                	cmp    %cl,%dl
  801e96:	74 09                	je     801ea1 <strfind+0x1e>
  801e98:	84 d2                	test   %dl,%dl
  801e9a:	74 05                	je     801ea1 <strfind+0x1e>
	for (; *s; s++)
  801e9c:	83 c0 01             	add    $0x1,%eax
  801e9f:	eb f0                	jmp    801e91 <strfind+0xe>
			break;
	return (char *) s;
}
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    

00801ea3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ea3:	f3 0f 1e fb          	endbr32 
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	57                   	push   %edi
  801eab:	56                   	push   %esi
  801eac:	53                   	push   %ebx
  801ead:	8b 7d 08             	mov    0x8(%ebp),%edi
  801eb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801eb3:	85 c9                	test   %ecx,%ecx
  801eb5:	74 31                	je     801ee8 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801eb7:	89 f8                	mov    %edi,%eax
  801eb9:	09 c8                	or     %ecx,%eax
  801ebb:	a8 03                	test   $0x3,%al
  801ebd:	75 23                	jne    801ee2 <memset+0x3f>
		c &= 0xFF;
  801ebf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ec3:	89 d3                	mov    %edx,%ebx
  801ec5:	c1 e3 08             	shl    $0x8,%ebx
  801ec8:	89 d0                	mov    %edx,%eax
  801eca:	c1 e0 18             	shl    $0x18,%eax
  801ecd:	89 d6                	mov    %edx,%esi
  801ecf:	c1 e6 10             	shl    $0x10,%esi
  801ed2:	09 f0                	or     %esi,%eax
  801ed4:	09 c2                	or     %eax,%edx
  801ed6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801ed8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801edb:	89 d0                	mov    %edx,%eax
  801edd:	fc                   	cld    
  801ede:	f3 ab                	rep stos %eax,%es:(%edi)
  801ee0:	eb 06                	jmp    801ee8 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee5:	fc                   	cld    
  801ee6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801ee8:	89 f8                	mov    %edi,%eax
  801eea:	5b                   	pop    %ebx
  801eeb:	5e                   	pop    %esi
  801eec:	5f                   	pop    %edi
  801eed:	5d                   	pop    %ebp
  801eee:	c3                   	ret    

00801eef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801eef:	f3 0f 1e fb          	endbr32 
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	57                   	push   %edi
  801ef7:	56                   	push   %esi
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801efe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801f01:	39 c6                	cmp    %eax,%esi
  801f03:	73 32                	jae    801f37 <memmove+0x48>
  801f05:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801f08:	39 c2                	cmp    %eax,%edx
  801f0a:	76 2b                	jbe    801f37 <memmove+0x48>
		s += n;
		d += n;
  801f0c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f0f:	89 fe                	mov    %edi,%esi
  801f11:	09 ce                	or     %ecx,%esi
  801f13:	09 d6                	or     %edx,%esi
  801f15:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801f1b:	75 0e                	jne    801f2b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801f1d:	83 ef 04             	sub    $0x4,%edi
  801f20:	8d 72 fc             	lea    -0x4(%edx),%esi
  801f23:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801f26:	fd                   	std    
  801f27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f29:	eb 09                	jmp    801f34 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f2b:	83 ef 01             	sub    $0x1,%edi
  801f2e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801f31:	fd                   	std    
  801f32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f34:	fc                   	cld    
  801f35:	eb 1a                	jmp    801f51 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f37:	89 c2                	mov    %eax,%edx
  801f39:	09 ca                	or     %ecx,%edx
  801f3b:	09 f2                	or     %esi,%edx
  801f3d:	f6 c2 03             	test   $0x3,%dl
  801f40:	75 0a                	jne    801f4c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801f45:	89 c7                	mov    %eax,%edi
  801f47:	fc                   	cld    
  801f48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f4a:	eb 05                	jmp    801f51 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801f4c:	89 c7                	mov    %eax,%edi
  801f4e:	fc                   	cld    
  801f4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801f51:	5e                   	pop    %esi
  801f52:	5f                   	pop    %edi
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    

00801f55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f55:	f3 0f 1e fb          	endbr32 
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f5f:	ff 75 10             	pushl  0x10(%ebp)
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	ff 75 08             	pushl  0x8(%ebp)
  801f68:	e8 82 ff ff ff       	call   801eef <memmove>
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f6f:	f3 0f 1e fb          	endbr32 
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	56                   	push   %esi
  801f77:	53                   	push   %ebx
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7e:	89 c6                	mov    %eax,%esi
  801f80:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f83:	39 f0                	cmp    %esi,%eax
  801f85:	74 1c                	je     801fa3 <memcmp+0x34>
		if (*s1 != *s2)
  801f87:	0f b6 08             	movzbl (%eax),%ecx
  801f8a:	0f b6 1a             	movzbl (%edx),%ebx
  801f8d:	38 d9                	cmp    %bl,%cl
  801f8f:	75 08                	jne    801f99 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f91:	83 c0 01             	add    $0x1,%eax
  801f94:	83 c2 01             	add    $0x1,%edx
  801f97:	eb ea                	jmp    801f83 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f99:	0f b6 c1             	movzbl %cl,%eax
  801f9c:	0f b6 db             	movzbl %bl,%ebx
  801f9f:	29 d8                	sub    %ebx,%eax
  801fa1:	eb 05                	jmp    801fa8 <memcmp+0x39>
	}

	return 0;
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa8:	5b                   	pop    %ebx
  801fa9:	5e                   	pop    %esi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801fac:	f3 0f 1e fb          	endbr32 
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801fb9:	89 c2                	mov    %eax,%edx
  801fbb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801fbe:	39 d0                	cmp    %edx,%eax
  801fc0:	73 09                	jae    801fcb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fc2:	38 08                	cmp    %cl,(%eax)
  801fc4:	74 05                	je     801fcb <memfind+0x1f>
	for (; s < ends; s++)
  801fc6:	83 c0 01             	add    $0x1,%eax
  801fc9:	eb f3                	jmp    801fbe <memfind+0x12>
			break;
	return (void *) s;
}
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    

00801fcd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fcd:	f3 0f 1e fb          	endbr32 
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	57                   	push   %edi
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
  801fd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fda:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801fdd:	eb 03                	jmp    801fe2 <strtol+0x15>
		s++;
  801fdf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801fe2:	0f b6 01             	movzbl (%ecx),%eax
  801fe5:	3c 20                	cmp    $0x20,%al
  801fe7:	74 f6                	je     801fdf <strtol+0x12>
  801fe9:	3c 09                	cmp    $0x9,%al
  801feb:	74 f2                	je     801fdf <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801fed:	3c 2b                	cmp    $0x2b,%al
  801fef:	74 2a                	je     80201b <strtol+0x4e>
	int neg = 0;
  801ff1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ff6:	3c 2d                	cmp    $0x2d,%al
  801ff8:	74 2b                	je     802025 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ffa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  802000:	75 0f                	jne    802011 <strtol+0x44>
  802002:	80 39 30             	cmpb   $0x30,(%ecx)
  802005:	74 28                	je     80202f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802007:	85 db                	test   %ebx,%ebx
  802009:	b8 0a 00 00 00       	mov    $0xa,%eax
  80200e:	0f 44 d8             	cmove  %eax,%ebx
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
  802016:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802019:	eb 46                	jmp    802061 <strtol+0x94>
		s++;
  80201b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80201e:	bf 00 00 00 00       	mov    $0x0,%edi
  802023:	eb d5                	jmp    801ffa <strtol+0x2d>
		s++, neg = 1;
  802025:	83 c1 01             	add    $0x1,%ecx
  802028:	bf 01 00 00 00       	mov    $0x1,%edi
  80202d:	eb cb                	jmp    801ffa <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80202f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802033:	74 0e                	je     802043 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802035:	85 db                	test   %ebx,%ebx
  802037:	75 d8                	jne    802011 <strtol+0x44>
		s++, base = 8;
  802039:	83 c1 01             	add    $0x1,%ecx
  80203c:	bb 08 00 00 00       	mov    $0x8,%ebx
  802041:	eb ce                	jmp    802011 <strtol+0x44>
		s += 2, base = 16;
  802043:	83 c1 02             	add    $0x2,%ecx
  802046:	bb 10 00 00 00       	mov    $0x10,%ebx
  80204b:	eb c4                	jmp    802011 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80204d:	0f be d2             	movsbl %dl,%edx
  802050:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802053:	3b 55 10             	cmp    0x10(%ebp),%edx
  802056:	7d 3a                	jge    802092 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802058:	83 c1 01             	add    $0x1,%ecx
  80205b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80205f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802061:	0f b6 11             	movzbl (%ecx),%edx
  802064:	8d 72 d0             	lea    -0x30(%edx),%esi
  802067:	89 f3                	mov    %esi,%ebx
  802069:	80 fb 09             	cmp    $0x9,%bl
  80206c:	76 df                	jbe    80204d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  80206e:	8d 72 9f             	lea    -0x61(%edx),%esi
  802071:	89 f3                	mov    %esi,%ebx
  802073:	80 fb 19             	cmp    $0x19,%bl
  802076:	77 08                	ja     802080 <strtol+0xb3>
			dig = *s - 'a' + 10;
  802078:	0f be d2             	movsbl %dl,%edx
  80207b:	83 ea 57             	sub    $0x57,%edx
  80207e:	eb d3                	jmp    802053 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802080:	8d 72 bf             	lea    -0x41(%edx),%esi
  802083:	89 f3                	mov    %esi,%ebx
  802085:	80 fb 19             	cmp    $0x19,%bl
  802088:	77 08                	ja     802092 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80208a:	0f be d2             	movsbl %dl,%edx
  80208d:	83 ea 37             	sub    $0x37,%edx
  802090:	eb c1                	jmp    802053 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802092:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802096:	74 05                	je     80209d <strtol+0xd0>
		*endptr = (char *) s;
  802098:	8b 75 0c             	mov    0xc(%ebp),%esi
  80209b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80209d:	89 c2                	mov    %eax,%edx
  80209f:	f7 da                	neg    %edx
  8020a1:	85 ff                	test   %edi,%edi
  8020a3:	0f 45 c2             	cmovne %edx,%eax
}
  8020a6:	5b                   	pop    %ebx
  8020a7:	5e                   	pop    %esi
  8020a8:	5f                   	pop    %edi
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    

008020ab <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020ab:	f3 0f 1e fb          	endbr32 
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	56                   	push   %esi
  8020b3:	53                   	push   %ebx
  8020b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	74 3d                	je     8020fe <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020c1:	83 ec 0c             	sub    $0xc,%esp
  8020c4:	50                   	push   %eax
  8020c5:	e8 88 e2 ff ff       	call   800352 <sys_ipc_recv>
  8020ca:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020cd:	85 f6                	test   %esi,%esi
  8020cf:	74 0b                	je     8020dc <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020d1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020d7:	8b 52 74             	mov    0x74(%edx),%edx
  8020da:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020dc:	85 db                	test   %ebx,%ebx
  8020de:	74 0b                	je     8020eb <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020e0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020e6:	8b 52 78             	mov    0x78(%edx),%edx
  8020e9:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	78 21                	js     802110 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8020ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8020f4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fa:	5b                   	pop    %ebx
  8020fb:	5e                   	pop    %esi
  8020fc:	5d                   	pop    %ebp
  8020fd:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8020fe:	83 ec 0c             	sub    $0xc,%esp
  802101:	68 00 00 c0 ee       	push   $0xeec00000
  802106:	e8 47 e2 ff ff       	call   800352 <sys_ipc_recv>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	eb bd                	jmp    8020cd <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802110:	85 f6                	test   %esi,%esi
  802112:	74 10                	je     802124 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802114:	85 db                	test   %ebx,%ebx
  802116:	75 df                	jne    8020f7 <ipc_recv+0x4c>
  802118:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80211f:	00 00 00 
  802122:	eb d3                	jmp    8020f7 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802124:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80212b:	00 00 00 
  80212e:	eb e4                	jmp    802114 <ipc_recv+0x69>

00802130 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802130:	f3 0f 1e fb          	endbr32 
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	57                   	push   %edi
  802138:	56                   	push   %esi
  802139:	53                   	push   %ebx
  80213a:	83 ec 0c             	sub    $0xc,%esp
  80213d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802140:	8b 75 0c             	mov    0xc(%ebp),%esi
  802143:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802146:	85 db                	test   %ebx,%ebx
  802148:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80214d:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802150:	ff 75 14             	pushl  0x14(%ebp)
  802153:	53                   	push   %ebx
  802154:	56                   	push   %esi
  802155:	57                   	push   %edi
  802156:	e8 d0 e1 ff ff       	call   80032b <sys_ipc_try_send>
  80215b:	83 c4 10             	add    $0x10,%esp
  80215e:	85 c0                	test   %eax,%eax
  802160:	79 1e                	jns    802180 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802162:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802165:	75 07                	jne    80216e <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802167:	e8 f7 df ff ff       	call   800163 <sys_yield>
  80216c:	eb e2                	jmp    802150 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80216e:	50                   	push   %eax
  80216f:	68 ff 28 80 00       	push   $0x8028ff
  802174:	6a 59                	push   $0x59
  802176:	68 1a 29 80 00       	push   $0x80291a
  80217b:	e8 c8 f4 ff ff       	call   801648 <_panic>
	}
}
  802180:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5f                   	pop    %edi
  802186:	5d                   	pop    %ebp
  802187:	c3                   	ret    

00802188 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802188:	f3 0f 1e fb          	endbr32 
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802192:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802197:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80219a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021a0:	8b 52 50             	mov    0x50(%edx),%edx
  8021a3:	39 ca                	cmp    %ecx,%edx
  8021a5:	74 11                	je     8021b8 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021a7:	83 c0 01             	add    $0x1,%eax
  8021aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021af:	75 e6                	jne    802197 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b6:	eb 0b                	jmp    8021c3 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021c0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    

008021c5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021c5:	f3 0f 1e fb          	endbr32 
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021cf:	89 c2                	mov    %eax,%edx
  8021d1:	c1 ea 16             	shr    $0x16,%edx
  8021d4:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021db:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021e0:	f6 c1 01             	test   $0x1,%cl
  8021e3:	74 1c                	je     802201 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021e5:	c1 e8 0c             	shr    $0xc,%eax
  8021e8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021ef:	a8 01                	test   $0x1,%al
  8021f1:	74 0e                	je     802201 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021f3:	c1 e8 0c             	shr    $0xc,%eax
  8021f6:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021fd:	ef 
  8021fe:	0f b7 d2             	movzwl %dx,%edx
}
  802201:	89 d0                	mov    %edx,%eax
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	66 90                	xchg   %ax,%ax
  802207:	66 90                	xchg   %ax,%ax
  802209:	66 90                	xchg   %ax,%ax
  80220b:	66 90                	xchg   %ax,%ax
  80220d:	66 90                	xchg   %ax,%ax
  80220f:	90                   	nop

00802210 <__udivdi3>:
  802210:	f3 0f 1e fb          	endbr32 
  802214:	55                   	push   %ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 1c             	sub    $0x1c,%esp
  80221b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80221f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802223:	8b 74 24 34          	mov    0x34(%esp),%esi
  802227:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80222b:	85 d2                	test   %edx,%edx
  80222d:	75 19                	jne    802248 <__udivdi3+0x38>
  80222f:	39 f3                	cmp    %esi,%ebx
  802231:	76 4d                	jbe    802280 <__udivdi3+0x70>
  802233:	31 ff                	xor    %edi,%edi
  802235:	89 e8                	mov    %ebp,%eax
  802237:	89 f2                	mov    %esi,%edx
  802239:	f7 f3                	div    %ebx
  80223b:	89 fa                	mov    %edi,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	39 f2                	cmp    %esi,%edx
  80224a:	76 14                	jbe    802260 <__udivdi3+0x50>
  80224c:	31 ff                	xor    %edi,%edi
  80224e:	31 c0                	xor    %eax,%eax
  802250:	89 fa                	mov    %edi,%edx
  802252:	83 c4 1c             	add    $0x1c,%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5f                   	pop    %edi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
  80225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802260:	0f bd fa             	bsr    %edx,%edi
  802263:	83 f7 1f             	xor    $0x1f,%edi
  802266:	75 48                	jne    8022b0 <__udivdi3+0xa0>
  802268:	39 f2                	cmp    %esi,%edx
  80226a:	72 06                	jb     802272 <__udivdi3+0x62>
  80226c:	31 c0                	xor    %eax,%eax
  80226e:	39 eb                	cmp    %ebp,%ebx
  802270:	77 de                	ja     802250 <__udivdi3+0x40>
  802272:	b8 01 00 00 00       	mov    $0x1,%eax
  802277:	eb d7                	jmp    802250 <__udivdi3+0x40>
  802279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802280:	89 d9                	mov    %ebx,%ecx
  802282:	85 db                	test   %ebx,%ebx
  802284:	75 0b                	jne    802291 <__udivdi3+0x81>
  802286:	b8 01 00 00 00       	mov    $0x1,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	f7 f3                	div    %ebx
  80228f:	89 c1                	mov    %eax,%ecx
  802291:	31 d2                	xor    %edx,%edx
  802293:	89 f0                	mov    %esi,%eax
  802295:	f7 f1                	div    %ecx
  802297:	89 c6                	mov    %eax,%esi
  802299:	89 e8                	mov    %ebp,%eax
  80229b:	89 f7                	mov    %esi,%edi
  80229d:	f7 f1                	div    %ecx
  80229f:	89 fa                	mov    %edi,%edx
  8022a1:	83 c4 1c             	add    $0x1c,%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5f                   	pop    %edi
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    
  8022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b0:	89 f9                	mov    %edi,%ecx
  8022b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b7:	29 f8                	sub    %edi,%eax
  8022b9:	d3 e2                	shl    %cl,%edx
  8022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	89 da                	mov    %ebx,%edx
  8022c3:	d3 ea                	shr    %cl,%edx
  8022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c9:	09 d1                	or     %edx,%ecx
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f9                	mov    %edi,%ecx
  8022d3:	d3 e3                	shl    %cl,%ebx
  8022d5:	89 c1                	mov    %eax,%ecx
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022df:	89 eb                	mov    %ebp,%ebx
  8022e1:	d3 e6                	shl    %cl,%esi
  8022e3:	89 c1                	mov    %eax,%ecx
  8022e5:	d3 eb                	shr    %cl,%ebx
  8022e7:	09 de                	or     %ebx,%esi
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	f7 74 24 08          	divl   0x8(%esp)
  8022ef:	89 d6                	mov    %edx,%esi
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	f7 64 24 0c          	mull   0xc(%esp)
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 15                	jb     802310 <__udivdi3+0x100>
  8022fb:	89 f9                	mov    %edi,%ecx
  8022fd:	d3 e5                	shl    %cl,%ebp
  8022ff:	39 c5                	cmp    %eax,%ebp
  802301:	73 04                	jae    802307 <__udivdi3+0xf7>
  802303:	39 d6                	cmp    %edx,%esi
  802305:	74 09                	je     802310 <__udivdi3+0x100>
  802307:	89 d8                	mov    %ebx,%eax
  802309:	31 ff                	xor    %edi,%edi
  80230b:	e9 40 ff ff ff       	jmp    802250 <__udivdi3+0x40>
  802310:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802313:	31 ff                	xor    %edi,%edi
  802315:	e9 36 ff ff ff       	jmp    802250 <__udivdi3+0x40>
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__umoddi3>:
  802320:	f3 0f 1e fb          	endbr32 
  802324:	55                   	push   %ebp
  802325:	57                   	push   %edi
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	83 ec 1c             	sub    $0x1c,%esp
  80232b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80232f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802333:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802337:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80233b:	85 c0                	test   %eax,%eax
  80233d:	75 19                	jne    802358 <__umoddi3+0x38>
  80233f:	39 df                	cmp    %ebx,%edi
  802341:	76 5d                	jbe    8023a0 <__umoddi3+0x80>
  802343:	89 f0                	mov    %esi,%eax
  802345:	89 da                	mov    %ebx,%edx
  802347:	f7 f7                	div    %edi
  802349:	89 d0                	mov    %edx,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	83 c4 1c             	add    $0x1c,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	89 f2                	mov    %esi,%edx
  80235a:	39 d8                	cmp    %ebx,%eax
  80235c:	76 12                	jbe    802370 <__umoddi3+0x50>
  80235e:	89 f0                	mov    %esi,%eax
  802360:	89 da                	mov    %ebx,%edx
  802362:	83 c4 1c             	add    $0x1c,%esp
  802365:	5b                   	pop    %ebx
  802366:	5e                   	pop    %esi
  802367:	5f                   	pop    %edi
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    
  80236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802370:	0f bd e8             	bsr    %eax,%ebp
  802373:	83 f5 1f             	xor    $0x1f,%ebp
  802376:	75 50                	jne    8023c8 <__umoddi3+0xa8>
  802378:	39 d8                	cmp    %ebx,%eax
  80237a:	0f 82 e0 00 00 00    	jb     802460 <__umoddi3+0x140>
  802380:	89 d9                	mov    %ebx,%ecx
  802382:	39 f7                	cmp    %esi,%edi
  802384:	0f 86 d6 00 00 00    	jbe    802460 <__umoddi3+0x140>
  80238a:	89 d0                	mov    %edx,%eax
  80238c:	89 ca                	mov    %ecx,%edx
  80238e:	83 c4 1c             	add    $0x1c,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
  802396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80239d:	8d 76 00             	lea    0x0(%esi),%esi
  8023a0:	89 fd                	mov    %edi,%ebp
  8023a2:	85 ff                	test   %edi,%edi
  8023a4:	75 0b                	jne    8023b1 <__umoddi3+0x91>
  8023a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ab:	31 d2                	xor    %edx,%edx
  8023ad:	f7 f7                	div    %edi
  8023af:	89 c5                	mov    %eax,%ebp
  8023b1:	89 d8                	mov    %ebx,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f5                	div    %ebp
  8023b7:	89 f0                	mov    %esi,%eax
  8023b9:	f7 f5                	div    %ebp
  8023bb:	89 d0                	mov    %edx,%eax
  8023bd:	31 d2                	xor    %edx,%edx
  8023bf:	eb 8c                	jmp    80234d <__umoddi3+0x2d>
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	89 e9                	mov    %ebp,%ecx
  8023ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8023cf:	29 ea                	sub    %ebp,%edx
  8023d1:	d3 e0                	shl    %cl,%eax
  8023d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023d7:	89 d1                	mov    %edx,%ecx
  8023d9:	89 f8                	mov    %edi,%eax
  8023db:	d3 e8                	shr    %cl,%eax
  8023dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023e9:	09 c1                	or     %eax,%ecx
  8023eb:	89 d8                	mov    %ebx,%eax
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 e9                	mov    %ebp,%ecx
  8023f3:	d3 e7                	shl    %cl,%edi
  8023f5:	89 d1                	mov    %edx,%ecx
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ff:	d3 e3                	shl    %cl,%ebx
  802401:	89 c7                	mov    %eax,%edi
  802403:	89 d1                	mov    %edx,%ecx
  802405:	89 f0                	mov    %esi,%eax
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 fa                	mov    %edi,%edx
  80240d:	d3 e6                	shl    %cl,%esi
  80240f:	09 d8                	or     %ebx,%eax
  802411:	f7 74 24 08          	divl   0x8(%esp)
  802415:	89 d1                	mov    %edx,%ecx
  802417:	89 f3                	mov    %esi,%ebx
  802419:	f7 64 24 0c          	mull   0xc(%esp)
  80241d:	89 c6                	mov    %eax,%esi
  80241f:	89 d7                	mov    %edx,%edi
  802421:	39 d1                	cmp    %edx,%ecx
  802423:	72 06                	jb     80242b <__umoddi3+0x10b>
  802425:	75 10                	jne    802437 <__umoddi3+0x117>
  802427:	39 c3                	cmp    %eax,%ebx
  802429:	73 0c                	jae    802437 <__umoddi3+0x117>
  80242b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80242f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802433:	89 d7                	mov    %edx,%edi
  802435:	89 c6                	mov    %eax,%esi
  802437:	89 ca                	mov    %ecx,%edx
  802439:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80243e:	29 f3                	sub    %esi,%ebx
  802440:	19 fa                	sbb    %edi,%edx
  802442:	89 d0                	mov    %edx,%eax
  802444:	d3 e0                	shl    %cl,%eax
  802446:	89 e9                	mov    %ebp,%ecx
  802448:	d3 eb                	shr    %cl,%ebx
  80244a:	d3 ea                	shr    %cl,%edx
  80244c:	09 d8                	or     %ebx,%eax
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	29 fe                	sub    %edi,%esi
  802462:	19 c3                	sbb    %eax,%ebx
  802464:	89 f2                	mov    %esi,%edx
  802466:	89 d9                	mov    %ebx,%ecx
  802468:	e9 1d ff ff ff       	jmp    80238a <__umoddi3+0x6a>
