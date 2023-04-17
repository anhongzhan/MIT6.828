
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
  80003d:	c7 05 00 30 80 00 00 	movl   $0x801f00,0x803000
  800044:	1f 80 00 
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
  80006f:	a3 04 40 80 00       	mov    %eax,0x804004

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
  8000a2:	e8 df 04 00 00       	call   800586 <close_all>
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
  80012f:	68 0f 1f 80 00       	push   $0x801f0f
  800134:	6a 23                	push   $0x23
  800136:	68 2c 1f 80 00       	push   $0x801f2c
  80013b:	e8 9c 0f 00 00       	call   8010dc <_panic>

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
  8001bc:	68 0f 1f 80 00       	push   $0x801f0f
  8001c1:	6a 23                	push   $0x23
  8001c3:	68 2c 1f 80 00       	push   $0x801f2c
  8001c8:	e8 0f 0f 00 00       	call   8010dc <_panic>

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
  800202:	68 0f 1f 80 00       	push   $0x801f0f
  800207:	6a 23                	push   $0x23
  800209:	68 2c 1f 80 00       	push   $0x801f2c
  80020e:	e8 c9 0e 00 00       	call   8010dc <_panic>

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
  800248:	68 0f 1f 80 00       	push   $0x801f0f
  80024d:	6a 23                	push   $0x23
  80024f:	68 2c 1f 80 00       	push   $0x801f2c
  800254:	e8 83 0e 00 00       	call   8010dc <_panic>

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
  80028e:	68 0f 1f 80 00       	push   $0x801f0f
  800293:	6a 23                	push   $0x23
  800295:	68 2c 1f 80 00       	push   $0x801f2c
  80029a:	e8 3d 0e 00 00       	call   8010dc <_panic>

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
  8002d4:	68 0f 1f 80 00       	push   $0x801f0f
  8002d9:	6a 23                	push   $0x23
  8002db:	68 2c 1f 80 00       	push   $0x801f2c
  8002e0:	e8 f7 0d 00 00       	call   8010dc <_panic>

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
  80031a:	68 0f 1f 80 00       	push   $0x801f0f
  80031f:	6a 23                	push   $0x23
  800321:	68 2c 1f 80 00       	push   $0x801f2c
  800326:	e8 b1 0d 00 00       	call   8010dc <_panic>

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
  800386:	68 0f 1f 80 00       	push   $0x801f0f
  80038b:	6a 23                	push   $0x23
  80038d:	68 2c 1f 80 00       	push   $0x801f2c
  800392:	e8 45 0d 00 00       	call   8010dc <_panic>

00800397 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800397:	f3 0f 1e fb          	endbr32 
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	05 00 00 00 30       	add    $0x30000000,%eax
  8003a6:	c1 e8 0c             	shr    $0xc,%eax
}
  8003a9:	5d                   	pop    %ebp
  8003aa:	c3                   	ret    

008003ab <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003ab:	f3 0f 1e fb          	endbr32 
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003bf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003c4:	5d                   	pop    %ebp
  8003c5:	c3                   	ret    

008003c6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003c6:	f3 0f 1e fb          	endbr32 
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003d2:	89 c2                	mov    %eax,%edx
  8003d4:	c1 ea 16             	shr    $0x16,%edx
  8003d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003de:	f6 c2 01             	test   $0x1,%dl
  8003e1:	74 2d                	je     800410 <fd_alloc+0x4a>
  8003e3:	89 c2                	mov    %eax,%edx
  8003e5:	c1 ea 0c             	shr    $0xc,%edx
  8003e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003ef:	f6 c2 01             	test   $0x1,%dl
  8003f2:	74 1c                	je     800410 <fd_alloc+0x4a>
  8003f4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003f9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003fe:	75 d2                	jne    8003d2 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800409:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80040e:	eb 0a                	jmp    80041a <fd_alloc+0x54>
			*fd_store = fd;
  800410:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800413:	89 01                	mov    %eax,(%ecx)
			return 0;
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    

0080041c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80041c:	f3 0f 1e fb          	endbr32 
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800426:	83 f8 1f             	cmp    $0x1f,%eax
  800429:	77 30                	ja     80045b <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80042b:	c1 e0 0c             	shl    $0xc,%eax
  80042e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800433:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800439:	f6 c2 01             	test   $0x1,%dl
  80043c:	74 24                	je     800462 <fd_lookup+0x46>
  80043e:	89 c2                	mov    %eax,%edx
  800440:	c1 ea 0c             	shr    $0xc,%edx
  800443:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80044a:	f6 c2 01             	test   $0x1,%dl
  80044d:	74 1a                	je     800469 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80044f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800452:	89 02                	mov    %eax,(%edx)
	return 0;
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800459:	5d                   	pop    %ebp
  80045a:	c3                   	ret    
		return -E_INVAL;
  80045b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800460:	eb f7                	jmp    800459 <fd_lookup+0x3d>
		return -E_INVAL;
  800462:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800467:	eb f0                	jmp    800459 <fd_lookup+0x3d>
  800469:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80046e:	eb e9                	jmp    800459 <fd_lookup+0x3d>

00800470 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800470:	f3 0f 1e fb          	endbr32 
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	83 ec 08             	sub    $0x8,%esp
  80047a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80047d:	ba b8 1f 80 00       	mov    $0x801fb8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800482:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800487:	39 08                	cmp    %ecx,(%eax)
  800489:	74 33                	je     8004be <dev_lookup+0x4e>
  80048b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80048e:	8b 02                	mov    (%edx),%eax
  800490:	85 c0                	test   %eax,%eax
  800492:	75 f3                	jne    800487 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800494:	a1 04 40 80 00       	mov    0x804004,%eax
  800499:	8b 40 48             	mov    0x48(%eax),%eax
  80049c:	83 ec 04             	sub    $0x4,%esp
  80049f:	51                   	push   %ecx
  8004a0:	50                   	push   %eax
  8004a1:	68 3c 1f 80 00       	push   $0x801f3c
  8004a6:	e8 18 0d 00 00       	call   8011c3 <cprintf>
	*dev = 0;
  8004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004b4:	83 c4 10             	add    $0x10,%esp
  8004b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004bc:	c9                   	leave  
  8004bd:	c3                   	ret    
			*dev = devtab[i];
  8004be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c8:	eb f2                	jmp    8004bc <dev_lookup+0x4c>

008004ca <fd_close>:
{
  8004ca:	f3 0f 1e fb          	endbr32 
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	57                   	push   %edi
  8004d2:	56                   	push   %esi
  8004d3:	53                   	push   %ebx
  8004d4:	83 ec 24             	sub    $0x24,%esp
  8004d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004da:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004e0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004e1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004e7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004ea:	50                   	push   %eax
  8004eb:	e8 2c ff ff ff       	call   80041c <fd_lookup>
  8004f0:	89 c3                	mov    %eax,%ebx
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	85 c0                	test   %eax,%eax
  8004f7:	78 05                	js     8004fe <fd_close+0x34>
	    || fd != fd2)
  8004f9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004fc:	74 16                	je     800514 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8004fe:	89 f8                	mov    %edi,%eax
  800500:	84 c0                	test   %al,%al
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	0f 44 d8             	cmove  %eax,%ebx
}
  80050a:	89 d8                	mov    %ebx,%eax
  80050c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80050f:	5b                   	pop    %ebx
  800510:	5e                   	pop    %esi
  800511:	5f                   	pop    %edi
  800512:	5d                   	pop    %ebp
  800513:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80051a:	50                   	push   %eax
  80051b:	ff 36                	pushl  (%esi)
  80051d:	e8 4e ff ff ff       	call   800470 <dev_lookup>
  800522:	89 c3                	mov    %eax,%ebx
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	85 c0                	test   %eax,%eax
  800529:	78 1a                	js     800545 <fd_close+0x7b>
		if (dev->dev_close)
  80052b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800531:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800536:	85 c0                	test   %eax,%eax
  800538:	74 0b                	je     800545 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80053a:	83 ec 0c             	sub    $0xc,%esp
  80053d:	56                   	push   %esi
  80053e:	ff d0                	call   *%eax
  800540:	89 c3                	mov    %eax,%ebx
  800542:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	56                   	push   %esi
  800549:	6a 00                	push   $0x0
  80054b:	e8 c3 fc ff ff       	call   800213 <sys_page_unmap>
	return r;
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	eb b5                	jmp    80050a <fd_close+0x40>

00800555 <close>:

int
close(int fdnum)
{
  800555:	f3 0f 1e fb          	endbr32 
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
  80055c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80055f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800562:	50                   	push   %eax
  800563:	ff 75 08             	pushl  0x8(%ebp)
  800566:	e8 b1 fe ff ff       	call   80041c <fd_lookup>
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	85 c0                	test   %eax,%eax
  800570:	79 02                	jns    800574 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800572:	c9                   	leave  
  800573:	c3                   	ret    
		return fd_close(fd, 1);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	6a 01                	push   $0x1
  800579:	ff 75 f4             	pushl  -0xc(%ebp)
  80057c:	e8 49 ff ff ff       	call   8004ca <fd_close>
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	eb ec                	jmp    800572 <close+0x1d>

00800586 <close_all>:

void
close_all(void)
{
  800586:	f3 0f 1e fb          	endbr32 
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
  80058d:	53                   	push   %ebx
  80058e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800591:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800596:	83 ec 0c             	sub    $0xc,%esp
  800599:	53                   	push   %ebx
  80059a:	e8 b6 ff ff ff       	call   800555 <close>
	for (i = 0; i < MAXFD; i++)
  80059f:	83 c3 01             	add    $0x1,%ebx
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	83 fb 20             	cmp    $0x20,%ebx
  8005a8:	75 ec                	jne    800596 <close_all+0x10>
}
  8005aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005af:	f3 0f 1e fb          	endbr32 
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	57                   	push   %edi
  8005b7:	56                   	push   %esi
  8005b8:	53                   	push   %ebx
  8005b9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 54 fe ff ff       	call   80041c <fd_lookup>
  8005c8:	89 c3                	mov    %eax,%ebx
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	85 c0                	test   %eax,%eax
  8005cf:	0f 88 81 00 00 00    	js     800656 <dup+0xa7>
		return r;
	close(newfdnum);
  8005d5:	83 ec 0c             	sub    $0xc,%esp
  8005d8:	ff 75 0c             	pushl  0xc(%ebp)
  8005db:	e8 75 ff ff ff       	call   800555 <close>

	newfd = INDEX2FD(newfdnum);
  8005e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005e3:	c1 e6 0c             	shl    $0xc,%esi
  8005e6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005ec:	83 c4 04             	add    $0x4,%esp
  8005ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005f2:	e8 b4 fd ff ff       	call   8003ab <fd2data>
  8005f7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005f9:	89 34 24             	mov    %esi,(%esp)
  8005fc:	e8 aa fd ff ff       	call   8003ab <fd2data>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800606:	89 d8                	mov    %ebx,%eax
  800608:	c1 e8 16             	shr    $0x16,%eax
  80060b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800612:	a8 01                	test   $0x1,%al
  800614:	74 11                	je     800627 <dup+0x78>
  800616:	89 d8                	mov    %ebx,%eax
  800618:	c1 e8 0c             	shr    $0xc,%eax
  80061b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800622:	f6 c2 01             	test   $0x1,%dl
  800625:	75 39                	jne    800660 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800627:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80062a:	89 d0                	mov    %edx,%eax
  80062c:	c1 e8 0c             	shr    $0xc,%eax
  80062f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800636:	83 ec 0c             	sub    $0xc,%esp
  800639:	25 07 0e 00 00       	and    $0xe07,%eax
  80063e:	50                   	push   %eax
  80063f:	56                   	push   %esi
  800640:	6a 00                	push   $0x0
  800642:	52                   	push   %edx
  800643:	6a 00                	push   $0x0
  800645:	e8 83 fb ff ff       	call   8001cd <sys_page_map>
  80064a:	89 c3                	mov    %eax,%ebx
  80064c:	83 c4 20             	add    $0x20,%esp
  80064f:	85 c0                	test   %eax,%eax
  800651:	78 31                	js     800684 <dup+0xd5>
		goto err;

	return newfdnum;
  800653:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800656:	89 d8                	mov    %ebx,%eax
  800658:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5e                   	pop    %esi
  80065d:	5f                   	pop    %edi
  80065e:	5d                   	pop    %ebp
  80065f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800660:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800667:	83 ec 0c             	sub    $0xc,%esp
  80066a:	25 07 0e 00 00       	and    $0xe07,%eax
  80066f:	50                   	push   %eax
  800670:	57                   	push   %edi
  800671:	6a 00                	push   $0x0
  800673:	53                   	push   %ebx
  800674:	6a 00                	push   $0x0
  800676:	e8 52 fb ff ff       	call   8001cd <sys_page_map>
  80067b:	89 c3                	mov    %eax,%ebx
  80067d:	83 c4 20             	add    $0x20,%esp
  800680:	85 c0                	test   %eax,%eax
  800682:	79 a3                	jns    800627 <dup+0x78>
	sys_page_unmap(0, newfd);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	56                   	push   %esi
  800688:	6a 00                	push   $0x0
  80068a:	e8 84 fb ff ff       	call   800213 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80068f:	83 c4 08             	add    $0x8,%esp
  800692:	57                   	push   %edi
  800693:	6a 00                	push   $0x0
  800695:	e8 79 fb ff ff       	call   800213 <sys_page_unmap>
	return r;
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	eb b7                	jmp    800656 <dup+0xa7>

0080069f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80069f:	f3 0f 1e fb          	endbr32 
  8006a3:	55                   	push   %ebp
  8006a4:	89 e5                	mov    %esp,%ebp
  8006a6:	53                   	push   %ebx
  8006a7:	83 ec 1c             	sub    $0x1c,%esp
  8006aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006b0:	50                   	push   %eax
  8006b1:	53                   	push   %ebx
  8006b2:	e8 65 fd ff ff       	call   80041c <fd_lookup>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	85 c0                	test   %eax,%eax
  8006bc:	78 3f                	js     8006fd <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006c4:	50                   	push   %eax
  8006c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c8:	ff 30                	pushl  (%eax)
  8006ca:	e8 a1 fd ff ff       	call   800470 <dev_lookup>
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	85 c0                	test   %eax,%eax
  8006d4:	78 27                	js     8006fd <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006d9:	8b 42 08             	mov    0x8(%edx),%eax
  8006dc:	83 e0 03             	and    $0x3,%eax
  8006df:	83 f8 01             	cmp    $0x1,%eax
  8006e2:	74 1e                	je     800702 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e7:	8b 40 08             	mov    0x8(%eax),%eax
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	74 35                	je     800723 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006ee:	83 ec 04             	sub    $0x4,%esp
  8006f1:	ff 75 10             	pushl  0x10(%ebp)
  8006f4:	ff 75 0c             	pushl  0xc(%ebp)
  8006f7:	52                   	push   %edx
  8006f8:	ff d0                	call   *%eax
  8006fa:	83 c4 10             	add    $0x10,%esp
}
  8006fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800700:	c9                   	leave  
  800701:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800702:	a1 04 40 80 00       	mov    0x804004,%eax
  800707:	8b 40 48             	mov    0x48(%eax),%eax
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	53                   	push   %ebx
  80070e:	50                   	push   %eax
  80070f:	68 7d 1f 80 00       	push   $0x801f7d
  800714:	e8 aa 0a 00 00       	call   8011c3 <cprintf>
		return -E_INVAL;
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800721:	eb da                	jmp    8006fd <read+0x5e>
		return -E_NOT_SUPP;
  800723:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800728:	eb d3                	jmp    8006fd <read+0x5e>

0080072a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80072a:	f3 0f 1e fb          	endbr32 
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	57                   	push   %edi
  800732:	56                   	push   %esi
  800733:	53                   	push   %ebx
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	8b 7d 08             	mov    0x8(%ebp),%edi
  80073a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80073d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800742:	eb 02                	jmp    800746 <readn+0x1c>
  800744:	01 c3                	add    %eax,%ebx
  800746:	39 f3                	cmp    %esi,%ebx
  800748:	73 21                	jae    80076b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80074a:	83 ec 04             	sub    $0x4,%esp
  80074d:	89 f0                	mov    %esi,%eax
  80074f:	29 d8                	sub    %ebx,%eax
  800751:	50                   	push   %eax
  800752:	89 d8                	mov    %ebx,%eax
  800754:	03 45 0c             	add    0xc(%ebp),%eax
  800757:	50                   	push   %eax
  800758:	57                   	push   %edi
  800759:	e8 41 ff ff ff       	call   80069f <read>
		if (m < 0)
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	85 c0                	test   %eax,%eax
  800763:	78 04                	js     800769 <readn+0x3f>
			return m;
		if (m == 0)
  800765:	75 dd                	jne    800744 <readn+0x1a>
  800767:	eb 02                	jmp    80076b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800769:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80076b:	89 d8                	mov    %ebx,%eax
  80076d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800770:	5b                   	pop    %ebx
  800771:	5e                   	pop    %esi
  800772:	5f                   	pop    %edi
  800773:	5d                   	pop    %ebp
  800774:	c3                   	ret    

00800775 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800775:	f3 0f 1e fb          	endbr32 
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	53                   	push   %ebx
  80077d:	83 ec 1c             	sub    $0x1c,%esp
  800780:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800783:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800786:	50                   	push   %eax
  800787:	53                   	push   %ebx
  800788:	e8 8f fc ff ff       	call   80041c <fd_lookup>
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	85 c0                	test   %eax,%eax
  800792:	78 3a                	js     8007ce <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80079a:	50                   	push   %eax
  80079b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079e:	ff 30                	pushl  (%eax)
  8007a0:	e8 cb fc ff ff       	call   800470 <dev_lookup>
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	85 c0                	test   %eax,%eax
  8007aa:	78 22                	js     8007ce <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007af:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007b3:	74 1e                	je     8007d3 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b8:	8b 52 0c             	mov    0xc(%edx),%edx
  8007bb:	85 d2                	test   %edx,%edx
  8007bd:	74 35                	je     8007f4 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	ff 75 10             	pushl  0x10(%ebp)
  8007c5:	ff 75 0c             	pushl  0xc(%ebp)
  8007c8:	50                   	push   %eax
  8007c9:	ff d2                	call   *%edx
  8007cb:	83 c4 10             	add    $0x10,%esp
}
  8007ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007d3:	a1 04 40 80 00       	mov    0x804004,%eax
  8007d8:	8b 40 48             	mov    0x48(%eax),%eax
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	53                   	push   %ebx
  8007df:	50                   	push   %eax
  8007e0:	68 99 1f 80 00       	push   $0x801f99
  8007e5:	e8 d9 09 00 00       	call   8011c3 <cprintf>
		return -E_INVAL;
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f2:	eb da                	jmp    8007ce <write+0x59>
		return -E_NOT_SUPP;
  8007f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007f9:	eb d3                	jmp    8007ce <write+0x59>

008007fb <seek>:

int
seek(int fdnum, off_t offset)
{
  8007fb:	f3 0f 1e fb          	endbr32 
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800805:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800808:	50                   	push   %eax
  800809:	ff 75 08             	pushl  0x8(%ebp)
  80080c:	e8 0b fc ff ff       	call   80041c <fd_lookup>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	85 c0                	test   %eax,%eax
  800816:	78 0e                	js     800826 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80081e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800821:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800826:	c9                   	leave  
  800827:	c3                   	ret    

00800828 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800828:	f3 0f 1e fb          	endbr32 
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	53                   	push   %ebx
  800830:	83 ec 1c             	sub    $0x1c,%esp
  800833:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800836:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800839:	50                   	push   %eax
  80083a:	53                   	push   %ebx
  80083b:	e8 dc fb ff ff       	call   80041c <fd_lookup>
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	85 c0                	test   %eax,%eax
  800845:	78 37                	js     80087e <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80084d:	50                   	push   %eax
  80084e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800851:	ff 30                	pushl  (%eax)
  800853:	e8 18 fc ff ff       	call   800470 <dev_lookup>
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	85 c0                	test   %eax,%eax
  80085d:	78 1f                	js     80087e <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80085f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800862:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800866:	74 1b                	je     800883 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086b:	8b 52 18             	mov    0x18(%edx),%edx
  80086e:	85 d2                	test   %edx,%edx
  800870:	74 32                	je     8008a4 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	50                   	push   %eax
  800879:	ff d2                	call   *%edx
  80087b:	83 c4 10             	add    $0x10,%esp
}
  80087e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800881:	c9                   	leave  
  800882:	c3                   	ret    
			thisenv->env_id, fdnum);
  800883:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800888:	8b 40 48             	mov    0x48(%eax),%eax
  80088b:	83 ec 04             	sub    $0x4,%esp
  80088e:	53                   	push   %ebx
  80088f:	50                   	push   %eax
  800890:	68 5c 1f 80 00       	push   $0x801f5c
  800895:	e8 29 09 00 00       	call   8011c3 <cprintf>
		return -E_INVAL;
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a2:	eb da                	jmp    80087e <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008a9:	eb d3                	jmp    80087e <ftruncate+0x56>

008008ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008ab:	f3 0f 1e fb          	endbr32 
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	53                   	push   %ebx
  8008b3:	83 ec 1c             	sub    $0x1c,%esp
  8008b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008bc:	50                   	push   %eax
  8008bd:	ff 75 08             	pushl  0x8(%ebp)
  8008c0:	e8 57 fb ff ff       	call   80041c <fd_lookup>
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	85 c0                	test   %eax,%eax
  8008ca:	78 4b                	js     800917 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008cc:	83 ec 08             	sub    $0x8,%esp
  8008cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008d2:	50                   	push   %eax
  8008d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d6:	ff 30                	pushl  (%eax)
  8008d8:	e8 93 fb ff ff       	call   800470 <dev_lookup>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	85 c0                	test   %eax,%eax
  8008e2:	78 33                	js     800917 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008eb:	74 2f                	je     80091c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008ed:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008f0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008f7:	00 00 00 
	stat->st_isdir = 0;
  8008fa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800901:	00 00 00 
	stat->st_dev = dev;
  800904:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	53                   	push   %ebx
  80090e:	ff 75 f0             	pushl  -0x10(%ebp)
  800911:	ff 50 14             	call   *0x14(%eax)
  800914:	83 c4 10             	add    $0x10,%esp
}
  800917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    
		return -E_NOT_SUPP;
  80091c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800921:	eb f4                	jmp    800917 <fstat+0x6c>

00800923 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800923:	f3 0f 1e fb          	endbr32 
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	6a 00                	push   $0x0
  800931:	ff 75 08             	pushl  0x8(%ebp)
  800934:	e8 fb 01 00 00       	call   800b34 <open>
  800939:	89 c3                	mov    %eax,%ebx
  80093b:	83 c4 10             	add    $0x10,%esp
  80093e:	85 c0                	test   %eax,%eax
  800940:	78 1b                	js     80095d <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	e8 5d ff ff ff       	call   8008ab <fstat>
  80094e:	89 c6                	mov    %eax,%esi
	close(fd);
  800950:	89 1c 24             	mov    %ebx,(%esp)
  800953:	e8 fd fb ff ff       	call   800555 <close>
	return r;
  800958:	83 c4 10             	add    $0x10,%esp
  80095b:	89 f3                	mov    %esi,%ebx
}
  80095d:	89 d8                	mov    %ebx,%eax
  80095f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800962:	5b                   	pop    %ebx
  800963:	5e                   	pop    %esi
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	56                   	push   %esi
  80096a:	53                   	push   %ebx
  80096b:	89 c6                	mov    %eax,%esi
  80096d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80096f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800976:	74 27                	je     80099f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800978:	6a 07                	push   $0x7
  80097a:	68 00 50 80 00       	push   $0x805000
  80097f:	56                   	push   %esi
  800980:	ff 35 00 40 80 00    	pushl  0x804000
  800986:	e8 39 12 00 00       	call   801bc4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80098b:	83 c4 0c             	add    $0xc,%esp
  80098e:	6a 00                	push   $0x0
  800990:	53                   	push   %ebx
  800991:	6a 00                	push   $0x0
  800993:	e8 a7 11 00 00       	call   801b3f <ipc_recv>
}
  800998:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80099b:	5b                   	pop    %ebx
  80099c:	5e                   	pop    %esi
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80099f:	83 ec 0c             	sub    $0xc,%esp
  8009a2:	6a 01                	push   $0x1
  8009a4:	e8 73 12 00 00       	call   801c1c <ipc_find_env>
  8009a9:	a3 00 40 80 00       	mov    %eax,0x804000
  8009ae:	83 c4 10             	add    $0x10,%esp
  8009b1:	eb c5                	jmp    800978 <fsipc+0x12>

008009b3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009b3:	f3 0f 1e fb          	endbr32 
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8009c3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d5:	b8 02 00 00 00       	mov    $0x2,%eax
  8009da:	e8 87 ff ff ff       	call   800966 <fsipc>
}
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <devfile_flush>:
{
  8009e1:	f3 0f 1e fb          	endbr32 
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8009f1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	b8 06 00 00 00       	mov    $0x6,%eax
  800a00:	e8 61 ff ff ff       	call   800966 <fsipc>
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <devfile_stat>:
{
  800a07:	f3 0f 1e fb          	endbr32 
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	53                   	push   %ebx
  800a0f:	83 ec 04             	sub    $0x4,%esp
  800a12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	8b 40 0c             	mov    0xc(%eax),%eax
  800a1b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a20:	ba 00 00 00 00       	mov    $0x0,%edx
  800a25:	b8 05 00 00 00       	mov    $0x5,%eax
  800a2a:	e8 37 ff ff ff       	call   800966 <fsipc>
  800a2f:	85 c0                	test   %eax,%eax
  800a31:	78 2c                	js     800a5f <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	68 00 50 80 00       	push   $0x805000
  800a3b:	53                   	push   %ebx
  800a3c:	e8 8c 0d 00 00       	call   8017cd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a41:	a1 80 50 80 00       	mov    0x805080,%eax
  800a46:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a4c:	a1 84 50 80 00       	mov    0x805084,%eax
  800a51:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a62:	c9                   	leave  
  800a63:	c3                   	ret    

00800a64 <devfile_write>:
{
  800a64:	f3 0f 1e fb          	endbr32 
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	83 ec 0c             	sub    $0xc,%esp
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a71:	8b 55 08             	mov    0x8(%ebp),%edx
  800a74:	8b 52 0c             	mov    0xc(%edx),%edx
  800a77:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800a7d:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a82:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a87:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800a8a:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a8f:	50                   	push   %eax
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	68 08 50 80 00       	push   $0x805008
  800a98:	e8 e6 0e 00 00       	call   801983 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa2:	b8 04 00 00 00       	mov    $0x4,%eax
  800aa7:	e8 ba fe ff ff       	call   800966 <fsipc>
}
  800aac:	c9                   	leave  
  800aad:	c3                   	ret    

00800aae <devfile_read>:
{
  800aae:	f3 0f 1e fb          	endbr32 
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	56                   	push   %esi
  800ab6:	53                   	push   %ebx
  800ab7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 40 0c             	mov    0xc(%eax),%eax
  800ac0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ac5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800acb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ad5:	e8 8c fe ff ff       	call   800966 <fsipc>
  800ada:	89 c3                	mov    %eax,%ebx
  800adc:	85 c0                	test   %eax,%eax
  800ade:	78 1f                	js     800aff <devfile_read+0x51>
	assert(r <= n);
  800ae0:	39 f0                	cmp    %esi,%eax
  800ae2:	77 24                	ja     800b08 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800ae4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ae9:	7f 33                	jg     800b1e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aeb:	83 ec 04             	sub    $0x4,%esp
  800aee:	50                   	push   %eax
  800aef:	68 00 50 80 00       	push   $0x805000
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	e8 87 0e 00 00       	call   801983 <memmove>
	return r;
  800afc:	83 c4 10             	add    $0x10,%esp
}
  800aff:	89 d8                	mov    %ebx,%eax
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    
	assert(r <= n);
  800b08:	68 c8 1f 80 00       	push   $0x801fc8
  800b0d:	68 cf 1f 80 00       	push   $0x801fcf
  800b12:	6a 7c                	push   $0x7c
  800b14:	68 e4 1f 80 00       	push   $0x801fe4
  800b19:	e8 be 05 00 00       	call   8010dc <_panic>
	assert(r <= PGSIZE);
  800b1e:	68 ef 1f 80 00       	push   $0x801fef
  800b23:	68 cf 1f 80 00       	push   $0x801fcf
  800b28:	6a 7d                	push   $0x7d
  800b2a:	68 e4 1f 80 00       	push   $0x801fe4
  800b2f:	e8 a8 05 00 00       	call   8010dc <_panic>

00800b34 <open>:
{
  800b34:	f3 0f 1e fb          	endbr32 
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	56                   	push   %esi
  800b3c:	53                   	push   %ebx
  800b3d:	83 ec 1c             	sub    $0x1c,%esp
  800b40:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b43:	56                   	push   %esi
  800b44:	e8 41 0c 00 00       	call   80178a <strlen>
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b51:	7f 6c                	jg     800bbf <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b53:	83 ec 0c             	sub    $0xc,%esp
  800b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 67 f8 ff ff       	call   8003c6 <fd_alloc>
  800b5f:	89 c3                	mov    %eax,%ebx
  800b61:	83 c4 10             	add    $0x10,%esp
  800b64:	85 c0                	test   %eax,%eax
  800b66:	78 3c                	js     800ba4 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	56                   	push   %esi
  800b6c:	68 00 50 80 00       	push   $0x805000
  800b71:	e8 57 0c 00 00       	call   8017cd <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b81:	b8 01 00 00 00       	mov    $0x1,%eax
  800b86:	e8 db fd ff ff       	call   800966 <fsipc>
  800b8b:	89 c3                	mov    %eax,%ebx
  800b8d:	83 c4 10             	add    $0x10,%esp
  800b90:	85 c0                	test   %eax,%eax
  800b92:	78 19                	js     800bad <open+0x79>
	return fd2num(fd);
  800b94:	83 ec 0c             	sub    $0xc,%esp
  800b97:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9a:	e8 f8 f7 ff ff       	call   800397 <fd2num>
  800b9f:	89 c3                	mov    %eax,%ebx
  800ba1:	83 c4 10             	add    $0x10,%esp
}
  800ba4:	89 d8                	mov    %ebx,%eax
  800ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    
		fd_close(fd, 0);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	6a 00                	push   $0x0
  800bb2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb5:	e8 10 f9 ff ff       	call   8004ca <fd_close>
		return r;
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	eb e5                	jmp    800ba4 <open+0x70>
		return -E_BAD_PATH;
  800bbf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bc4:	eb de                	jmp    800ba4 <open+0x70>

00800bc6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bc6:	f3 0f 1e fb          	endbr32 
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	b8 08 00 00 00       	mov    $0x8,%eax
  800bda:	e8 87 fd ff ff       	call   800966 <fsipc>
}
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800be1:	f3 0f 1e fb          	endbr32 
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
  800bea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bed:	83 ec 0c             	sub    $0xc,%esp
  800bf0:	ff 75 08             	pushl  0x8(%ebp)
  800bf3:	e8 b3 f7 ff ff       	call   8003ab <fd2data>
  800bf8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bfa:	83 c4 08             	add    $0x8,%esp
  800bfd:	68 fb 1f 80 00       	push   $0x801ffb
  800c02:	53                   	push   %ebx
  800c03:	e8 c5 0b 00 00       	call   8017cd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c08:	8b 46 04             	mov    0x4(%esi),%eax
  800c0b:	2b 06                	sub    (%esi),%eax
  800c0d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c13:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c1a:	00 00 00 
	stat->st_dev = &devpipe;
  800c1d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c24:	30 80 00 
	return 0;
}
  800c27:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c33:	f3 0f 1e fb          	endbr32 
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	53                   	push   %ebx
  800c3b:	83 ec 0c             	sub    $0xc,%esp
  800c3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c41:	53                   	push   %ebx
  800c42:	6a 00                	push   $0x0
  800c44:	e8 ca f5 ff ff       	call   800213 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c49:	89 1c 24             	mov    %ebx,(%esp)
  800c4c:	e8 5a f7 ff ff       	call   8003ab <fd2data>
  800c51:	83 c4 08             	add    $0x8,%esp
  800c54:	50                   	push   %eax
  800c55:	6a 00                	push   $0x0
  800c57:	e8 b7 f5 ff ff       	call   800213 <sys_page_unmap>
}
  800c5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <_pipeisclosed>:
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	57                   	push   %edi
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
  800c67:	83 ec 1c             	sub    $0x1c,%esp
  800c6a:	89 c7                	mov    %eax,%edi
  800c6c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c6e:	a1 04 40 80 00       	mov    0x804004,%eax
  800c73:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c76:	83 ec 0c             	sub    $0xc,%esp
  800c79:	57                   	push   %edi
  800c7a:	e8 da 0f 00 00       	call   801c59 <pageref>
  800c7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c82:	89 34 24             	mov    %esi,(%esp)
  800c85:	e8 cf 0f 00 00       	call   801c59 <pageref>
		nn = thisenv->env_runs;
  800c8a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c90:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c93:	83 c4 10             	add    $0x10,%esp
  800c96:	39 cb                	cmp    %ecx,%ebx
  800c98:	74 1b                	je     800cb5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c9a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c9d:	75 cf                	jne    800c6e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c9f:	8b 42 58             	mov    0x58(%edx),%eax
  800ca2:	6a 01                	push   $0x1
  800ca4:	50                   	push   %eax
  800ca5:	53                   	push   %ebx
  800ca6:	68 02 20 80 00       	push   $0x802002
  800cab:	e8 13 05 00 00       	call   8011c3 <cprintf>
  800cb0:	83 c4 10             	add    $0x10,%esp
  800cb3:	eb b9                	jmp    800c6e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800cb5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cb8:	0f 94 c0             	sete   %al
  800cbb:	0f b6 c0             	movzbl %al,%eax
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <devpipe_write>:
{
  800cc6:	f3 0f 1e fb          	endbr32 
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	57                   	push   %edi
  800cce:	56                   	push   %esi
  800ccf:	53                   	push   %ebx
  800cd0:	83 ec 28             	sub    $0x28,%esp
  800cd3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cd6:	56                   	push   %esi
  800cd7:	e8 cf f6 ff ff       	call   8003ab <fd2data>
  800cdc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800ce9:	74 4f                	je     800d3a <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800ceb:	8b 43 04             	mov    0x4(%ebx),%eax
  800cee:	8b 0b                	mov    (%ebx),%ecx
  800cf0:	8d 51 20             	lea    0x20(%ecx),%edx
  800cf3:	39 d0                	cmp    %edx,%eax
  800cf5:	72 14                	jb     800d0b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800cf7:	89 da                	mov    %ebx,%edx
  800cf9:	89 f0                	mov    %esi,%eax
  800cfb:	e8 61 ff ff ff       	call   800c61 <_pipeisclosed>
  800d00:	85 c0                	test   %eax,%eax
  800d02:	75 3b                	jne    800d3f <devpipe_write+0x79>
			sys_yield();
  800d04:	e8 5a f4 ff ff       	call   800163 <sys_yield>
  800d09:	eb e0                	jmp    800ceb <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d12:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d15:	89 c2                	mov    %eax,%edx
  800d17:	c1 fa 1f             	sar    $0x1f,%edx
  800d1a:	89 d1                	mov    %edx,%ecx
  800d1c:	c1 e9 1b             	shr    $0x1b,%ecx
  800d1f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d22:	83 e2 1f             	and    $0x1f,%edx
  800d25:	29 ca                	sub    %ecx,%edx
  800d27:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d2b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d2f:	83 c0 01             	add    $0x1,%eax
  800d32:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d35:	83 c7 01             	add    $0x1,%edi
  800d38:	eb ac                	jmp    800ce6 <devpipe_write+0x20>
	return i;
  800d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3d:	eb 05                	jmp    800d44 <devpipe_write+0x7e>
				return 0;
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <devpipe_read>:
{
  800d4c:	f3 0f 1e fb          	endbr32 
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	83 ec 18             	sub    $0x18,%esp
  800d59:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d5c:	57                   	push   %edi
  800d5d:	e8 49 f6 ff ff       	call   8003ab <fd2data>
  800d62:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d64:	83 c4 10             	add    $0x10,%esp
  800d67:	be 00 00 00 00       	mov    $0x0,%esi
  800d6c:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d6f:	75 14                	jne    800d85 <devpipe_read+0x39>
	return i;
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	eb 02                	jmp    800d78 <devpipe_read+0x2c>
				return i;
  800d76:	89 f0                	mov    %esi,%eax
}
  800d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    
			sys_yield();
  800d80:	e8 de f3 ff ff       	call   800163 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d85:	8b 03                	mov    (%ebx),%eax
  800d87:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d8a:	75 18                	jne    800da4 <devpipe_read+0x58>
			if (i > 0)
  800d8c:	85 f6                	test   %esi,%esi
  800d8e:	75 e6                	jne    800d76 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d90:	89 da                	mov    %ebx,%edx
  800d92:	89 f8                	mov    %edi,%eax
  800d94:	e8 c8 fe ff ff       	call   800c61 <_pipeisclosed>
  800d99:	85 c0                	test   %eax,%eax
  800d9b:	74 e3                	je     800d80 <devpipe_read+0x34>
				return 0;
  800d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800da2:	eb d4                	jmp    800d78 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800da4:	99                   	cltd   
  800da5:	c1 ea 1b             	shr    $0x1b,%edx
  800da8:	01 d0                	add    %edx,%eax
  800daa:	83 e0 1f             	and    $0x1f,%eax
  800dad:	29 d0                	sub    %edx,%eax
  800daf:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800db4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800dba:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800dbd:	83 c6 01             	add    $0x1,%esi
  800dc0:	eb aa                	jmp    800d6c <devpipe_read+0x20>

00800dc2 <pipe>:
{
  800dc2:	f3 0f 1e fb          	endbr32 
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dd1:	50                   	push   %eax
  800dd2:	e8 ef f5 ff ff       	call   8003c6 <fd_alloc>
  800dd7:	89 c3                	mov    %eax,%ebx
  800dd9:	83 c4 10             	add    $0x10,%esp
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	0f 88 23 01 00 00    	js     800f07 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	68 07 04 00 00       	push   $0x407
  800dec:	ff 75 f4             	pushl  -0xc(%ebp)
  800def:	6a 00                	push   $0x0
  800df1:	e8 90 f3 ff ff       	call   800186 <sys_page_alloc>
  800df6:	89 c3                	mov    %eax,%ebx
  800df8:	83 c4 10             	add    $0x10,%esp
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	0f 88 04 01 00 00    	js     800f07 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e09:	50                   	push   %eax
  800e0a:	e8 b7 f5 ff ff       	call   8003c6 <fd_alloc>
  800e0f:	89 c3                	mov    %eax,%ebx
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	85 c0                	test   %eax,%eax
  800e16:	0f 88 db 00 00 00    	js     800ef7 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1c:	83 ec 04             	sub    $0x4,%esp
  800e1f:	68 07 04 00 00       	push   $0x407
  800e24:	ff 75 f0             	pushl  -0x10(%ebp)
  800e27:	6a 00                	push   $0x0
  800e29:	e8 58 f3 ff ff       	call   800186 <sys_page_alloc>
  800e2e:	89 c3                	mov    %eax,%ebx
  800e30:	83 c4 10             	add    $0x10,%esp
  800e33:	85 c0                	test   %eax,%eax
  800e35:	0f 88 bc 00 00 00    	js     800ef7 <pipe+0x135>
	va = fd2data(fd0);
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e41:	e8 65 f5 ff ff       	call   8003ab <fd2data>
  800e46:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e48:	83 c4 0c             	add    $0xc,%esp
  800e4b:	68 07 04 00 00       	push   $0x407
  800e50:	50                   	push   %eax
  800e51:	6a 00                	push   $0x0
  800e53:	e8 2e f3 ff ff       	call   800186 <sys_page_alloc>
  800e58:	89 c3                	mov    %eax,%ebx
  800e5a:	83 c4 10             	add    $0x10,%esp
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	0f 88 82 00 00 00    	js     800ee7 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e65:	83 ec 0c             	sub    $0xc,%esp
  800e68:	ff 75 f0             	pushl  -0x10(%ebp)
  800e6b:	e8 3b f5 ff ff       	call   8003ab <fd2data>
  800e70:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e77:	50                   	push   %eax
  800e78:	6a 00                	push   $0x0
  800e7a:	56                   	push   %esi
  800e7b:	6a 00                	push   $0x0
  800e7d:	e8 4b f3 ff ff       	call   8001cd <sys_page_map>
  800e82:	89 c3                	mov    %eax,%ebx
  800e84:	83 c4 20             	add    $0x20,%esp
  800e87:	85 c0                	test   %eax,%eax
  800e89:	78 4e                	js     800ed9 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e8b:	a1 20 30 80 00       	mov    0x803020,%eax
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e98:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ea2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800eae:	83 ec 0c             	sub    $0xc,%esp
  800eb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb4:	e8 de f4 ff ff       	call   800397 <fd2num>
  800eb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800ebe:	83 c4 04             	add    $0x4,%esp
  800ec1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ec4:	e8 ce f4 ff ff       	call   800397 <fd2num>
  800ec9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ecc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ecf:	83 c4 10             	add    $0x10,%esp
  800ed2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed7:	eb 2e                	jmp    800f07 <pipe+0x145>
	sys_page_unmap(0, va);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	56                   	push   %esi
  800edd:	6a 00                	push   $0x0
  800edf:	e8 2f f3 ff ff       	call   800213 <sys_page_unmap>
  800ee4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 f0             	pushl  -0x10(%ebp)
  800eed:	6a 00                	push   $0x0
  800eef:	e8 1f f3 ff ff       	call   800213 <sys_page_unmap>
  800ef4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 f4             	pushl  -0xc(%ebp)
  800efd:	6a 00                	push   $0x0
  800eff:	e8 0f f3 ff ff       	call   800213 <sys_page_unmap>
  800f04:	83 c4 10             	add    $0x10,%esp
}
  800f07:	89 d8                	mov    %ebx,%eax
  800f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f0c:	5b                   	pop    %ebx
  800f0d:	5e                   	pop    %esi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <pipeisclosed>:
{
  800f10:	f3 0f 1e fb          	endbr32 
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	ff 75 08             	pushl  0x8(%ebp)
  800f21:	e8 f6 f4 ff ff       	call   80041c <fd_lookup>
  800f26:	83 c4 10             	add    $0x10,%esp
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	78 18                	js     800f45 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	ff 75 f4             	pushl  -0xc(%ebp)
  800f33:	e8 73 f4 ff ff       	call   8003ab <fd2data>
  800f38:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3d:	e8 1f fd ff ff       	call   800c61 <_pipeisclosed>
  800f42:	83 c4 10             	add    $0x10,%esp
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f47:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f50:	c3                   	ret    

00800f51 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f51:	f3 0f 1e fb          	endbr32 
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f5b:	68 1a 20 80 00       	push   $0x80201a
  800f60:	ff 75 0c             	pushl  0xc(%ebp)
  800f63:	e8 65 08 00 00       	call   8017cd <strcpy>
	return 0;
}
  800f68:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <devcons_write>:
{
  800f6f:	f3 0f 1e fb          	endbr32 
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
  800f79:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f7f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f84:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f8a:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f8d:	73 31                	jae    800fc0 <devcons_write+0x51>
		m = n - tot;
  800f8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f92:	29 f3                	sub    %esi,%ebx
  800f94:	83 fb 7f             	cmp    $0x7f,%ebx
  800f97:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f9c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f9f:	83 ec 04             	sub    $0x4,%esp
  800fa2:	53                   	push   %ebx
  800fa3:	89 f0                	mov    %esi,%eax
  800fa5:	03 45 0c             	add    0xc(%ebp),%eax
  800fa8:	50                   	push   %eax
  800fa9:	57                   	push   %edi
  800faa:	e8 d4 09 00 00       	call   801983 <memmove>
		sys_cputs(buf, m);
  800faf:	83 c4 08             	add    $0x8,%esp
  800fb2:	53                   	push   %ebx
  800fb3:	57                   	push   %edi
  800fb4:	e8 fd f0 ff ff       	call   8000b6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fb9:	01 de                	add    %ebx,%esi
  800fbb:	83 c4 10             	add    $0x10,%esp
  800fbe:	eb ca                	jmp    800f8a <devcons_write+0x1b>
}
  800fc0:	89 f0                	mov    %esi,%eax
  800fc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc5:	5b                   	pop    %ebx
  800fc6:	5e                   	pop    %esi
  800fc7:	5f                   	pop    %edi
  800fc8:	5d                   	pop    %ebp
  800fc9:	c3                   	ret    

00800fca <devcons_read>:
{
  800fca:	f3 0f 1e fb          	endbr32 
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 08             	sub    $0x8,%esp
  800fd4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800fd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdd:	74 21                	je     801000 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800fdf:	e8 f4 f0 ff ff       	call   8000d8 <sys_cgetc>
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	75 07                	jne    800fef <devcons_read+0x25>
		sys_yield();
  800fe8:	e8 76 f1 ff ff       	call   800163 <sys_yield>
  800fed:	eb f0                	jmp    800fdf <devcons_read+0x15>
	if (c < 0)
  800fef:	78 0f                	js     801000 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800ff1:	83 f8 04             	cmp    $0x4,%eax
  800ff4:	74 0c                	je     801002 <devcons_read+0x38>
	*(char*)vbuf = c;
  800ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff9:	88 02                	mov    %al,(%edx)
	return 1;
  800ffb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801000:	c9                   	leave  
  801001:	c3                   	ret    
		return 0;
  801002:	b8 00 00 00 00       	mov    $0x0,%eax
  801007:	eb f7                	jmp    801000 <devcons_read+0x36>

00801009 <cputchar>:
{
  801009:	f3 0f 1e fb          	endbr32 
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801019:	6a 01                	push   $0x1
  80101b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80101e:	50                   	push   %eax
  80101f:	e8 92 f0 ff ff       	call   8000b6 <sys_cputs>
}
  801024:	83 c4 10             	add    $0x10,%esp
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <getchar>:
{
  801029:	f3 0f 1e fb          	endbr32 
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801033:	6a 01                	push   $0x1
  801035:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801038:	50                   	push   %eax
  801039:	6a 00                	push   $0x0
  80103b:	e8 5f f6 ff ff       	call   80069f <read>
	if (r < 0)
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	85 c0                	test   %eax,%eax
  801045:	78 06                	js     80104d <getchar+0x24>
	if (r < 1)
  801047:	74 06                	je     80104f <getchar+0x26>
	return c;
  801049:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    
		return -E_EOF;
  80104f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801054:	eb f7                	jmp    80104d <getchar+0x24>

00801056 <iscons>:
{
  801056:	f3 0f 1e fb          	endbr32 
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801060:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801063:	50                   	push   %eax
  801064:	ff 75 08             	pushl  0x8(%ebp)
  801067:	e8 b0 f3 ff ff       	call   80041c <fd_lookup>
  80106c:	83 c4 10             	add    $0x10,%esp
  80106f:	85 c0                	test   %eax,%eax
  801071:	78 11                	js     801084 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801076:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80107c:	39 10                	cmp    %edx,(%eax)
  80107e:	0f 94 c0             	sete   %al
  801081:	0f b6 c0             	movzbl %al,%eax
}
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <opencons>:
{
  801086:	f3 0f 1e fb          	endbr32 
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801090:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801093:	50                   	push   %eax
  801094:	e8 2d f3 ff ff       	call   8003c6 <fd_alloc>
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	85 c0                	test   %eax,%eax
  80109e:	78 3a                	js     8010da <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010a0:	83 ec 04             	sub    $0x4,%esp
  8010a3:	68 07 04 00 00       	push   $0x407
  8010a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ab:	6a 00                	push   $0x0
  8010ad:	e8 d4 f0 ff ff       	call   800186 <sys_page_alloc>
  8010b2:	83 c4 10             	add    $0x10,%esp
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	78 21                	js     8010da <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bc:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010c2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010ce:	83 ec 0c             	sub    $0xc,%esp
  8010d1:	50                   	push   %eax
  8010d2:	e8 c0 f2 ff ff       	call   800397 <fd2num>
  8010d7:	83 c4 10             	add    $0x10,%esp
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010dc:	f3 0f 1e fb          	endbr32 
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	56                   	push   %esi
  8010e4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010e5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010e8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010ee:	e8 4d f0 ff ff       	call   800140 <sys_getenvid>
  8010f3:	83 ec 0c             	sub    $0xc,%esp
  8010f6:	ff 75 0c             	pushl  0xc(%ebp)
  8010f9:	ff 75 08             	pushl  0x8(%ebp)
  8010fc:	56                   	push   %esi
  8010fd:	50                   	push   %eax
  8010fe:	68 28 20 80 00       	push   $0x802028
  801103:	e8 bb 00 00 00       	call   8011c3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801108:	83 c4 18             	add    $0x18,%esp
  80110b:	53                   	push   %ebx
  80110c:	ff 75 10             	pushl  0x10(%ebp)
  80110f:	e8 5a 00 00 00       	call   80116e <vcprintf>
	cprintf("\n");
  801114:	c7 04 24 58 23 80 00 	movl   $0x802358,(%esp)
  80111b:	e8 a3 00 00 00       	call   8011c3 <cprintf>
  801120:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801123:	cc                   	int3   
  801124:	eb fd                	jmp    801123 <_panic+0x47>

00801126 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801126:	f3 0f 1e fb          	endbr32 
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	53                   	push   %ebx
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801134:	8b 13                	mov    (%ebx),%edx
  801136:	8d 42 01             	lea    0x1(%edx),%eax
  801139:	89 03                	mov    %eax,(%ebx)
  80113b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801142:	3d ff 00 00 00       	cmp    $0xff,%eax
  801147:	74 09                	je     801152 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801149:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80114d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801150:	c9                   	leave  
  801151:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801152:	83 ec 08             	sub    $0x8,%esp
  801155:	68 ff 00 00 00       	push   $0xff
  80115a:	8d 43 08             	lea    0x8(%ebx),%eax
  80115d:	50                   	push   %eax
  80115e:	e8 53 ef ff ff       	call   8000b6 <sys_cputs>
		b->idx = 0;
  801163:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	eb db                	jmp    801149 <putch+0x23>

0080116e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80116e:	f3 0f 1e fb          	endbr32 
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80117b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801182:	00 00 00 
	b.cnt = 0;
  801185:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80118c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80118f:	ff 75 0c             	pushl  0xc(%ebp)
  801192:	ff 75 08             	pushl  0x8(%ebp)
  801195:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80119b:	50                   	push   %eax
  80119c:	68 26 11 80 00       	push   $0x801126
  8011a1:	e8 20 01 00 00       	call   8012c6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011a6:	83 c4 08             	add    $0x8,%esp
  8011a9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8011af:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011b5:	50                   	push   %eax
  8011b6:	e8 fb ee ff ff       	call   8000b6 <sys_cputs>

	return b.cnt;
}
  8011bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011c3:	f3 0f 1e fb          	endbr32 
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011cd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011d0:	50                   	push   %eax
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	e8 95 ff ff ff       	call   80116e <vcprintf>
	va_end(ap);

	return cnt;
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	57                   	push   %edi
  8011df:	56                   	push   %esi
  8011e0:	53                   	push   %ebx
  8011e1:	83 ec 1c             	sub    $0x1c,%esp
  8011e4:	89 c7                	mov    %eax,%edi
  8011e6:	89 d6                	mov    %edx,%esi
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ee:	89 d1                	mov    %edx,%ecx
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801201:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801208:	39 c2                	cmp    %eax,%edx
  80120a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80120d:	72 3e                	jb     80124d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80120f:	83 ec 0c             	sub    $0xc,%esp
  801212:	ff 75 18             	pushl  0x18(%ebp)
  801215:	83 eb 01             	sub    $0x1,%ebx
  801218:	53                   	push   %ebx
  801219:	50                   	push   %eax
  80121a:	83 ec 08             	sub    $0x8,%esp
  80121d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801220:	ff 75 e0             	pushl  -0x20(%ebp)
  801223:	ff 75 dc             	pushl  -0x24(%ebp)
  801226:	ff 75 d8             	pushl  -0x28(%ebp)
  801229:	e8 72 0a 00 00       	call   801ca0 <__udivdi3>
  80122e:	83 c4 18             	add    $0x18,%esp
  801231:	52                   	push   %edx
  801232:	50                   	push   %eax
  801233:	89 f2                	mov    %esi,%edx
  801235:	89 f8                	mov    %edi,%eax
  801237:	e8 9f ff ff ff       	call   8011db <printnum>
  80123c:	83 c4 20             	add    $0x20,%esp
  80123f:	eb 13                	jmp    801254 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801241:	83 ec 08             	sub    $0x8,%esp
  801244:	56                   	push   %esi
  801245:	ff 75 18             	pushl  0x18(%ebp)
  801248:	ff d7                	call   *%edi
  80124a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80124d:	83 eb 01             	sub    $0x1,%ebx
  801250:	85 db                	test   %ebx,%ebx
  801252:	7f ed                	jg     801241 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801254:	83 ec 08             	sub    $0x8,%esp
  801257:	56                   	push   %esi
  801258:	83 ec 04             	sub    $0x4,%esp
  80125b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80125e:	ff 75 e0             	pushl  -0x20(%ebp)
  801261:	ff 75 dc             	pushl  -0x24(%ebp)
  801264:	ff 75 d8             	pushl  -0x28(%ebp)
  801267:	e8 44 0b 00 00       	call   801db0 <__umoddi3>
  80126c:	83 c4 14             	add    $0x14,%esp
  80126f:	0f be 80 4b 20 80 00 	movsbl 0x80204b(%eax),%eax
  801276:	50                   	push   %eax
  801277:	ff d7                	call   *%edi
}
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127f:	5b                   	pop    %ebx
  801280:	5e                   	pop    %esi
  801281:	5f                   	pop    %edi
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801284:	f3 0f 1e fb          	endbr32 
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80128e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801292:	8b 10                	mov    (%eax),%edx
  801294:	3b 50 04             	cmp    0x4(%eax),%edx
  801297:	73 0a                	jae    8012a3 <sprintputch+0x1f>
		*b->buf++ = ch;
  801299:	8d 4a 01             	lea    0x1(%edx),%ecx
  80129c:	89 08                	mov    %ecx,(%eax)
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	88 02                	mov    %al,(%edx)
}
  8012a3:	5d                   	pop    %ebp
  8012a4:	c3                   	ret    

008012a5 <printfmt>:
{
  8012a5:	f3 0f 1e fb          	endbr32 
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012af:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 10             	pushl  0x10(%ebp)
  8012b6:	ff 75 0c             	pushl  0xc(%ebp)
  8012b9:	ff 75 08             	pushl  0x8(%ebp)
  8012bc:	e8 05 00 00 00       	call   8012c6 <vprintfmt>
}
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <vprintfmt>:
{
  8012c6:	f3 0f 1e fb          	endbr32 
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	57                   	push   %edi
  8012ce:	56                   	push   %esi
  8012cf:	53                   	push   %ebx
  8012d0:	83 ec 3c             	sub    $0x3c,%esp
  8012d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8012d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012d9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012dc:	e9 8e 03 00 00       	jmp    80166f <vprintfmt+0x3a9>
		padc = ' ';
  8012e1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012e5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012ec:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012fa:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8012ff:	8d 47 01             	lea    0x1(%edi),%eax
  801302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801305:	0f b6 17             	movzbl (%edi),%edx
  801308:	8d 42 dd             	lea    -0x23(%edx),%eax
  80130b:	3c 55                	cmp    $0x55,%al
  80130d:	0f 87 df 03 00 00    	ja     8016f2 <vprintfmt+0x42c>
  801313:	0f b6 c0             	movzbl %al,%eax
  801316:	3e ff 24 85 80 21 80 	notrack jmp *0x802180(,%eax,4)
  80131d:	00 
  80131e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801321:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801325:	eb d8                	jmp    8012ff <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801327:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80132a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80132e:	eb cf                	jmp    8012ff <vprintfmt+0x39>
  801330:	0f b6 d2             	movzbl %dl,%edx
  801333:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801336:	b8 00 00 00 00       	mov    $0x0,%eax
  80133b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80133e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801341:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801345:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801348:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80134b:	83 f9 09             	cmp    $0x9,%ecx
  80134e:	77 55                	ja     8013a5 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801350:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801353:	eb e9                	jmp    80133e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80135d:	8b 45 14             	mov    0x14(%ebp),%eax
  801360:	8d 40 04             	lea    0x4(%eax),%eax
  801363:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801369:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136d:	79 90                	jns    8012ff <vprintfmt+0x39>
				width = precision, precision = -1;
  80136f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801372:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801375:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80137c:	eb 81                	jmp    8012ff <vprintfmt+0x39>
  80137e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801381:	85 c0                	test   %eax,%eax
  801383:	ba 00 00 00 00       	mov    $0x0,%edx
  801388:	0f 49 d0             	cmovns %eax,%edx
  80138b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80138e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801391:	e9 69 ff ff ff       	jmp    8012ff <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801399:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013a0:	e9 5a ff ff ff       	jmp    8012ff <vprintfmt+0x39>
  8013a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013ab:	eb bc                	jmp    801369 <vprintfmt+0xa3>
			lflag++;
  8013ad:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013b3:	e9 47 ff ff ff       	jmp    8012ff <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	8d 78 04             	lea    0x4(%eax),%edi
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	53                   	push   %ebx
  8013c2:	ff 30                	pushl  (%eax)
  8013c4:	ff d6                	call   *%esi
			break;
  8013c6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013c9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013cc:	e9 9b 02 00 00       	jmp    80166c <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8013d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d4:	8d 78 04             	lea    0x4(%eax),%edi
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	99                   	cltd   
  8013da:	31 d0                	xor    %edx,%eax
  8013dc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013de:	83 f8 0f             	cmp    $0xf,%eax
  8013e1:	7f 23                	jg     801406 <vprintfmt+0x140>
  8013e3:	8b 14 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%edx
  8013ea:	85 d2                	test   %edx,%edx
  8013ec:	74 18                	je     801406 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8013ee:	52                   	push   %edx
  8013ef:	68 e1 1f 80 00       	push   $0x801fe1
  8013f4:	53                   	push   %ebx
  8013f5:	56                   	push   %esi
  8013f6:	e8 aa fe ff ff       	call   8012a5 <printfmt>
  8013fb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8013fe:	89 7d 14             	mov    %edi,0x14(%ebp)
  801401:	e9 66 02 00 00       	jmp    80166c <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801406:	50                   	push   %eax
  801407:	68 63 20 80 00       	push   $0x802063
  80140c:	53                   	push   %ebx
  80140d:	56                   	push   %esi
  80140e:	e8 92 fe ff ff       	call   8012a5 <printfmt>
  801413:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801416:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801419:	e9 4e 02 00 00       	jmp    80166c <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80141e:	8b 45 14             	mov    0x14(%ebp),%eax
  801421:	83 c0 04             	add    $0x4,%eax
  801424:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801427:	8b 45 14             	mov    0x14(%ebp),%eax
  80142a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80142c:	85 d2                	test   %edx,%edx
  80142e:	b8 5c 20 80 00       	mov    $0x80205c,%eax
  801433:	0f 45 c2             	cmovne %edx,%eax
  801436:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801439:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80143d:	7e 06                	jle    801445 <vprintfmt+0x17f>
  80143f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801443:	75 0d                	jne    801452 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801445:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801448:	89 c7                	mov    %eax,%edi
  80144a:	03 45 e0             	add    -0x20(%ebp),%eax
  80144d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801450:	eb 55                	jmp    8014a7 <vprintfmt+0x1e1>
  801452:	83 ec 08             	sub    $0x8,%esp
  801455:	ff 75 d8             	pushl  -0x28(%ebp)
  801458:	ff 75 cc             	pushl  -0x34(%ebp)
  80145b:	e8 46 03 00 00       	call   8017a6 <strnlen>
  801460:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80146d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801471:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801474:	85 ff                	test   %edi,%edi
  801476:	7e 11                	jle    801489 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	53                   	push   %ebx
  80147c:	ff 75 e0             	pushl  -0x20(%ebp)
  80147f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801481:	83 ef 01             	sub    $0x1,%edi
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	eb eb                	jmp    801474 <vprintfmt+0x1ae>
  801489:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80148c:	85 d2                	test   %edx,%edx
  80148e:	b8 00 00 00 00       	mov    $0x0,%eax
  801493:	0f 49 c2             	cmovns %edx,%eax
  801496:	29 c2                	sub    %eax,%edx
  801498:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80149b:	eb a8                	jmp    801445 <vprintfmt+0x17f>
					putch(ch, putdat);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	53                   	push   %ebx
  8014a1:	52                   	push   %edx
  8014a2:	ff d6                	call   *%esi
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014aa:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014ac:	83 c7 01             	add    $0x1,%edi
  8014af:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014b3:	0f be d0             	movsbl %al,%edx
  8014b6:	85 d2                	test   %edx,%edx
  8014b8:	74 4b                	je     801505 <vprintfmt+0x23f>
  8014ba:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014be:	78 06                	js     8014c6 <vprintfmt+0x200>
  8014c0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014c4:	78 1e                	js     8014e4 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014ca:	74 d1                	je     80149d <vprintfmt+0x1d7>
  8014cc:	0f be c0             	movsbl %al,%eax
  8014cf:	83 e8 20             	sub    $0x20,%eax
  8014d2:	83 f8 5e             	cmp    $0x5e,%eax
  8014d5:	76 c6                	jbe    80149d <vprintfmt+0x1d7>
					putch('?', putdat);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	53                   	push   %ebx
  8014db:	6a 3f                	push   $0x3f
  8014dd:	ff d6                	call   *%esi
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	eb c3                	jmp    8014a7 <vprintfmt+0x1e1>
  8014e4:	89 cf                	mov    %ecx,%edi
  8014e6:	eb 0e                	jmp    8014f6 <vprintfmt+0x230>
				putch(' ', putdat);
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	53                   	push   %ebx
  8014ec:	6a 20                	push   $0x20
  8014ee:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8014f0:	83 ef 01             	sub    $0x1,%edi
  8014f3:	83 c4 10             	add    $0x10,%esp
  8014f6:	85 ff                	test   %edi,%edi
  8014f8:	7f ee                	jg     8014e8 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8014fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014fd:	89 45 14             	mov    %eax,0x14(%ebp)
  801500:	e9 67 01 00 00       	jmp    80166c <vprintfmt+0x3a6>
  801505:	89 cf                	mov    %ecx,%edi
  801507:	eb ed                	jmp    8014f6 <vprintfmt+0x230>
	if (lflag >= 2)
  801509:	83 f9 01             	cmp    $0x1,%ecx
  80150c:	7f 1b                	jg     801529 <vprintfmt+0x263>
	else if (lflag)
  80150e:	85 c9                	test   %ecx,%ecx
  801510:	74 63                	je     801575 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80151a:	99                   	cltd   
  80151b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80151e:	8b 45 14             	mov    0x14(%ebp),%eax
  801521:	8d 40 04             	lea    0x4(%eax),%eax
  801524:	89 45 14             	mov    %eax,0x14(%ebp)
  801527:	eb 17                	jmp    801540 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801529:	8b 45 14             	mov    0x14(%ebp),%eax
  80152c:	8b 50 04             	mov    0x4(%eax),%edx
  80152f:	8b 00                	mov    (%eax),%eax
  801531:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801534:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801537:	8b 45 14             	mov    0x14(%ebp),%eax
  80153a:	8d 40 08             	lea    0x8(%eax),%eax
  80153d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801540:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801543:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801546:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80154b:	85 c9                	test   %ecx,%ecx
  80154d:	0f 89 ff 00 00 00    	jns    801652 <vprintfmt+0x38c>
				putch('-', putdat);
  801553:	83 ec 08             	sub    $0x8,%esp
  801556:	53                   	push   %ebx
  801557:	6a 2d                	push   $0x2d
  801559:	ff d6                	call   *%esi
				num = -(long long) num;
  80155b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80155e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801561:	f7 da                	neg    %edx
  801563:	83 d1 00             	adc    $0x0,%ecx
  801566:	f7 d9                	neg    %ecx
  801568:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80156b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801570:	e9 dd 00 00 00       	jmp    801652 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801575:	8b 45 14             	mov    0x14(%ebp),%eax
  801578:	8b 00                	mov    (%eax),%eax
  80157a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80157d:	99                   	cltd   
  80157e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801581:	8b 45 14             	mov    0x14(%ebp),%eax
  801584:	8d 40 04             	lea    0x4(%eax),%eax
  801587:	89 45 14             	mov    %eax,0x14(%ebp)
  80158a:	eb b4                	jmp    801540 <vprintfmt+0x27a>
	if (lflag >= 2)
  80158c:	83 f9 01             	cmp    $0x1,%ecx
  80158f:	7f 1e                	jg     8015af <vprintfmt+0x2e9>
	else if (lflag)
  801591:	85 c9                	test   %ecx,%ecx
  801593:	74 32                	je     8015c7 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801595:	8b 45 14             	mov    0x14(%ebp),%eax
  801598:	8b 10                	mov    (%eax),%edx
  80159a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80159f:	8d 40 04             	lea    0x4(%eax),%eax
  8015a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015a5:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8015aa:	e9 a3 00 00 00       	jmp    801652 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015af:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b2:	8b 10                	mov    (%eax),%edx
  8015b4:	8b 48 04             	mov    0x4(%eax),%ecx
  8015b7:	8d 40 08             	lea    0x8(%eax),%eax
  8015ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015bd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015c2:	e9 8b 00 00 00       	jmp    801652 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ca:	8b 10                	mov    (%eax),%edx
  8015cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015d1:	8d 40 04             	lea    0x4(%eax),%eax
  8015d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015d7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8015dc:	eb 74                	jmp    801652 <vprintfmt+0x38c>
	if (lflag >= 2)
  8015de:	83 f9 01             	cmp    $0x1,%ecx
  8015e1:	7f 1b                	jg     8015fe <vprintfmt+0x338>
	else if (lflag)
  8015e3:	85 c9                	test   %ecx,%ecx
  8015e5:	74 2c                	je     801613 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8015e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ea:	8b 10                	mov    (%eax),%edx
  8015ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015f1:	8d 40 04             	lea    0x4(%eax),%eax
  8015f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015f7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8015fc:	eb 54                	jmp    801652 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801601:	8b 10                	mov    (%eax),%edx
  801603:	8b 48 04             	mov    0x4(%eax),%ecx
  801606:	8d 40 08             	lea    0x8(%eax),%eax
  801609:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80160c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801611:	eb 3f                	jmp    801652 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801613:	8b 45 14             	mov    0x14(%ebp),%eax
  801616:	8b 10                	mov    (%eax),%edx
  801618:	b9 00 00 00 00       	mov    $0x0,%ecx
  80161d:	8d 40 04             	lea    0x4(%eax),%eax
  801620:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801623:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801628:	eb 28                	jmp    801652 <vprintfmt+0x38c>
			putch('0', putdat);
  80162a:	83 ec 08             	sub    $0x8,%esp
  80162d:	53                   	push   %ebx
  80162e:	6a 30                	push   $0x30
  801630:	ff d6                	call   *%esi
			putch('x', putdat);
  801632:	83 c4 08             	add    $0x8,%esp
  801635:	53                   	push   %ebx
  801636:	6a 78                	push   $0x78
  801638:	ff d6                	call   *%esi
			num = (unsigned long long)
  80163a:	8b 45 14             	mov    0x14(%ebp),%eax
  80163d:	8b 10                	mov    (%eax),%edx
  80163f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801644:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801647:	8d 40 04             	lea    0x4(%eax),%eax
  80164a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80164d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801652:	83 ec 0c             	sub    $0xc,%esp
  801655:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801659:	57                   	push   %edi
  80165a:	ff 75 e0             	pushl  -0x20(%ebp)
  80165d:	50                   	push   %eax
  80165e:	51                   	push   %ecx
  80165f:	52                   	push   %edx
  801660:	89 da                	mov    %ebx,%edx
  801662:	89 f0                	mov    %esi,%eax
  801664:	e8 72 fb ff ff       	call   8011db <printnum>
			break;
  801669:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80166c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80166f:	83 c7 01             	add    $0x1,%edi
  801672:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801676:	83 f8 25             	cmp    $0x25,%eax
  801679:	0f 84 62 fc ff ff    	je     8012e1 <vprintfmt+0x1b>
			if (ch == '\0')
  80167f:	85 c0                	test   %eax,%eax
  801681:	0f 84 8b 00 00 00    	je     801712 <vprintfmt+0x44c>
			putch(ch, putdat);
  801687:	83 ec 08             	sub    $0x8,%esp
  80168a:	53                   	push   %ebx
  80168b:	50                   	push   %eax
  80168c:	ff d6                	call   *%esi
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	eb dc                	jmp    80166f <vprintfmt+0x3a9>
	if (lflag >= 2)
  801693:	83 f9 01             	cmp    $0x1,%ecx
  801696:	7f 1b                	jg     8016b3 <vprintfmt+0x3ed>
	else if (lflag)
  801698:	85 c9                	test   %ecx,%ecx
  80169a:	74 2c                	je     8016c8 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80169c:	8b 45 14             	mov    0x14(%ebp),%eax
  80169f:	8b 10                	mov    (%eax),%edx
  8016a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016a6:	8d 40 04             	lea    0x4(%eax),%eax
  8016a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016ac:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8016b1:	eb 9f                	jmp    801652 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8016b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b6:	8b 10                	mov    (%eax),%edx
  8016b8:	8b 48 04             	mov    0x4(%eax),%ecx
  8016bb:	8d 40 08             	lea    0x8(%eax),%eax
  8016be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016c1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016c6:	eb 8a                	jmp    801652 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cb:	8b 10                	mov    (%eax),%edx
  8016cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d2:	8d 40 04             	lea    0x4(%eax),%eax
  8016d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016d8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8016dd:	e9 70 ff ff ff       	jmp    801652 <vprintfmt+0x38c>
			putch(ch, putdat);
  8016e2:	83 ec 08             	sub    $0x8,%esp
  8016e5:	53                   	push   %ebx
  8016e6:	6a 25                	push   $0x25
  8016e8:	ff d6                	call   *%esi
			break;
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	e9 7a ff ff ff       	jmp    80166c <vprintfmt+0x3a6>
			putch('%', putdat);
  8016f2:	83 ec 08             	sub    $0x8,%esp
  8016f5:	53                   	push   %ebx
  8016f6:	6a 25                	push   $0x25
  8016f8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	89 f8                	mov    %edi,%eax
  8016ff:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801703:	74 05                	je     80170a <vprintfmt+0x444>
  801705:	83 e8 01             	sub    $0x1,%eax
  801708:	eb f5                	jmp    8016ff <vprintfmt+0x439>
  80170a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80170d:	e9 5a ff ff ff       	jmp    80166c <vprintfmt+0x3a6>
}
  801712:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5f                   	pop    %edi
  801718:	5d                   	pop    %ebp
  801719:	c3                   	ret    

0080171a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80171a:	f3 0f 1e fb          	endbr32 
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 18             	sub    $0x18,%esp
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80172a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80172d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801731:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801734:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80173b:	85 c0                	test   %eax,%eax
  80173d:	74 26                	je     801765 <vsnprintf+0x4b>
  80173f:	85 d2                	test   %edx,%edx
  801741:	7e 22                	jle    801765 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801743:	ff 75 14             	pushl  0x14(%ebp)
  801746:	ff 75 10             	pushl  0x10(%ebp)
  801749:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80174c:	50                   	push   %eax
  80174d:	68 84 12 80 00       	push   $0x801284
  801752:	e8 6f fb ff ff       	call   8012c6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80175d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801760:	83 c4 10             	add    $0x10,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    
		return -E_INVAL;
  801765:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176a:	eb f7                	jmp    801763 <vsnprintf+0x49>

0080176c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80176c:	f3 0f 1e fb          	endbr32 
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801776:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801779:	50                   	push   %eax
  80177a:	ff 75 10             	pushl  0x10(%ebp)
  80177d:	ff 75 0c             	pushl  0xc(%ebp)
  801780:	ff 75 08             	pushl  0x8(%ebp)
  801783:	e8 92 ff ff ff       	call   80171a <vsnprintf>
	va_end(ap);

	return rc;
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80178a:	f3 0f 1e fb          	endbr32 
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
  801799:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80179d:	74 05                	je     8017a4 <strlen+0x1a>
		n++;
  80179f:	83 c0 01             	add    $0x1,%eax
  8017a2:	eb f5                	jmp    801799 <strlen+0xf>
	return n;
}
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    

008017a6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017a6:	f3 0f 1e fb          	endbr32 
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b8:	39 d0                	cmp    %edx,%eax
  8017ba:	74 0d                	je     8017c9 <strnlen+0x23>
  8017bc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017c0:	74 05                	je     8017c7 <strnlen+0x21>
		n++;
  8017c2:	83 c0 01             	add    $0x1,%eax
  8017c5:	eb f1                	jmp    8017b8 <strnlen+0x12>
  8017c7:	89 c2                	mov    %eax,%edx
	return n;
}
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    

008017cd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017cd:	f3 0f 1e fb          	endbr32 
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	53                   	push   %ebx
  8017d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8017db:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8017e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8017e7:	83 c0 01             	add    $0x1,%eax
  8017ea:	84 d2                	test   %dl,%dl
  8017ec:	75 f2                	jne    8017e0 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8017ee:	89 c8                	mov    %ecx,%eax
  8017f0:	5b                   	pop    %ebx
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8017f3:	f3 0f 1e fb          	endbr32 
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	53                   	push   %ebx
  8017fb:	83 ec 10             	sub    $0x10,%esp
  8017fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801801:	53                   	push   %ebx
  801802:	e8 83 ff ff ff       	call   80178a <strlen>
  801807:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80180a:	ff 75 0c             	pushl  0xc(%ebp)
  80180d:	01 d8                	add    %ebx,%eax
  80180f:	50                   	push   %eax
  801810:	e8 b8 ff ff ff       	call   8017cd <strcpy>
	return dst;
}
  801815:	89 d8                	mov    %ebx,%eax
  801817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80181c:	f3 0f 1e fb          	endbr32 
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	56                   	push   %esi
  801824:	53                   	push   %ebx
  801825:	8b 75 08             	mov    0x8(%ebp),%esi
  801828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182b:	89 f3                	mov    %esi,%ebx
  80182d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801830:	89 f0                	mov    %esi,%eax
  801832:	39 d8                	cmp    %ebx,%eax
  801834:	74 11                	je     801847 <strncpy+0x2b>
		*dst++ = *src;
  801836:	83 c0 01             	add    $0x1,%eax
  801839:	0f b6 0a             	movzbl (%edx),%ecx
  80183c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80183f:	80 f9 01             	cmp    $0x1,%cl
  801842:	83 da ff             	sbb    $0xffffffff,%edx
  801845:	eb eb                	jmp    801832 <strncpy+0x16>
	}
	return ret;
}
  801847:	89 f0                	mov    %esi,%eax
  801849:	5b                   	pop    %ebx
  80184a:	5e                   	pop    %esi
  80184b:	5d                   	pop    %ebp
  80184c:	c3                   	ret    

0080184d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80184d:	f3 0f 1e fb          	endbr32 
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	56                   	push   %esi
  801855:	53                   	push   %ebx
  801856:	8b 75 08             	mov    0x8(%ebp),%esi
  801859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80185c:	8b 55 10             	mov    0x10(%ebp),%edx
  80185f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801861:	85 d2                	test   %edx,%edx
  801863:	74 21                	je     801886 <strlcpy+0x39>
  801865:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801869:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80186b:	39 c2                	cmp    %eax,%edx
  80186d:	74 14                	je     801883 <strlcpy+0x36>
  80186f:	0f b6 19             	movzbl (%ecx),%ebx
  801872:	84 db                	test   %bl,%bl
  801874:	74 0b                	je     801881 <strlcpy+0x34>
			*dst++ = *src++;
  801876:	83 c1 01             	add    $0x1,%ecx
  801879:	83 c2 01             	add    $0x1,%edx
  80187c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80187f:	eb ea                	jmp    80186b <strlcpy+0x1e>
  801881:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801883:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801886:	29 f0                	sub    %esi,%eax
}
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80188c:	f3 0f 1e fb          	endbr32 
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801899:	0f b6 01             	movzbl (%ecx),%eax
  80189c:	84 c0                	test   %al,%al
  80189e:	74 0c                	je     8018ac <strcmp+0x20>
  8018a0:	3a 02                	cmp    (%edx),%al
  8018a2:	75 08                	jne    8018ac <strcmp+0x20>
		p++, q++;
  8018a4:	83 c1 01             	add    $0x1,%ecx
  8018a7:	83 c2 01             	add    $0x1,%edx
  8018aa:	eb ed                	jmp    801899 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018ac:	0f b6 c0             	movzbl %al,%eax
  8018af:	0f b6 12             	movzbl (%edx),%edx
  8018b2:	29 d0                	sub    %edx,%eax
}
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018b6:	f3 0f 1e fb          	endbr32 
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	53                   	push   %ebx
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c4:	89 c3                	mov    %eax,%ebx
  8018c6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018c9:	eb 06                	jmp    8018d1 <strncmp+0x1b>
		n--, p++, q++;
  8018cb:	83 c0 01             	add    $0x1,%eax
  8018ce:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8018d1:	39 d8                	cmp    %ebx,%eax
  8018d3:	74 16                	je     8018eb <strncmp+0x35>
  8018d5:	0f b6 08             	movzbl (%eax),%ecx
  8018d8:	84 c9                	test   %cl,%cl
  8018da:	74 04                	je     8018e0 <strncmp+0x2a>
  8018dc:	3a 0a                	cmp    (%edx),%cl
  8018de:	74 eb                	je     8018cb <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018e0:	0f b6 00             	movzbl (%eax),%eax
  8018e3:	0f b6 12             	movzbl (%edx),%edx
  8018e6:	29 d0                	sub    %edx,%eax
}
  8018e8:	5b                   	pop    %ebx
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    
		return 0;
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f0:	eb f6                	jmp    8018e8 <strncmp+0x32>

008018f2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018f2:	f3 0f 1e fb          	endbr32 
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801900:	0f b6 10             	movzbl (%eax),%edx
  801903:	84 d2                	test   %dl,%dl
  801905:	74 09                	je     801910 <strchr+0x1e>
		if (*s == c)
  801907:	38 ca                	cmp    %cl,%dl
  801909:	74 0a                	je     801915 <strchr+0x23>
	for (; *s; s++)
  80190b:	83 c0 01             	add    $0x1,%eax
  80190e:	eb f0                	jmp    801900 <strchr+0xe>
			return (char *) s;
	return 0;
  801910:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801915:	5d                   	pop    %ebp
  801916:	c3                   	ret    

00801917 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801917:	f3 0f 1e fb          	endbr32 
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801925:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801928:	38 ca                	cmp    %cl,%dl
  80192a:	74 09                	je     801935 <strfind+0x1e>
  80192c:	84 d2                	test   %dl,%dl
  80192e:	74 05                	je     801935 <strfind+0x1e>
	for (; *s; s++)
  801930:	83 c0 01             	add    $0x1,%eax
  801933:	eb f0                	jmp    801925 <strfind+0xe>
			break;
	return (char *) s;
}
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801937:	f3 0f 1e fb          	endbr32 
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	57                   	push   %edi
  80193f:	56                   	push   %esi
  801940:	53                   	push   %ebx
  801941:	8b 7d 08             	mov    0x8(%ebp),%edi
  801944:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801947:	85 c9                	test   %ecx,%ecx
  801949:	74 31                	je     80197c <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80194b:	89 f8                	mov    %edi,%eax
  80194d:	09 c8                	or     %ecx,%eax
  80194f:	a8 03                	test   $0x3,%al
  801951:	75 23                	jne    801976 <memset+0x3f>
		c &= 0xFF;
  801953:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801957:	89 d3                	mov    %edx,%ebx
  801959:	c1 e3 08             	shl    $0x8,%ebx
  80195c:	89 d0                	mov    %edx,%eax
  80195e:	c1 e0 18             	shl    $0x18,%eax
  801961:	89 d6                	mov    %edx,%esi
  801963:	c1 e6 10             	shl    $0x10,%esi
  801966:	09 f0                	or     %esi,%eax
  801968:	09 c2                	or     %eax,%edx
  80196a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80196c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80196f:	89 d0                	mov    %edx,%eax
  801971:	fc                   	cld    
  801972:	f3 ab                	rep stos %eax,%es:(%edi)
  801974:	eb 06                	jmp    80197c <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801976:	8b 45 0c             	mov    0xc(%ebp),%eax
  801979:	fc                   	cld    
  80197a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80197c:	89 f8                	mov    %edi,%eax
  80197e:	5b                   	pop    %ebx
  80197f:	5e                   	pop    %esi
  801980:	5f                   	pop    %edi
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    

00801983 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801983:	f3 0f 1e fb          	endbr32 
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	57                   	push   %edi
  80198b:	56                   	push   %esi
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801992:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801995:	39 c6                	cmp    %eax,%esi
  801997:	73 32                	jae    8019cb <memmove+0x48>
  801999:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80199c:	39 c2                	cmp    %eax,%edx
  80199e:	76 2b                	jbe    8019cb <memmove+0x48>
		s += n;
		d += n;
  8019a0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019a3:	89 fe                	mov    %edi,%esi
  8019a5:	09 ce                	or     %ecx,%esi
  8019a7:	09 d6                	or     %edx,%esi
  8019a9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019af:	75 0e                	jne    8019bf <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019b1:	83 ef 04             	sub    $0x4,%edi
  8019b4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019b7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019ba:	fd                   	std    
  8019bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019bd:	eb 09                	jmp    8019c8 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019bf:	83 ef 01             	sub    $0x1,%edi
  8019c2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019c5:	fd                   	std    
  8019c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019c8:	fc                   	cld    
  8019c9:	eb 1a                	jmp    8019e5 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019cb:	89 c2                	mov    %eax,%edx
  8019cd:	09 ca                	or     %ecx,%edx
  8019cf:	09 f2                	or     %esi,%edx
  8019d1:	f6 c2 03             	test   $0x3,%dl
  8019d4:	75 0a                	jne    8019e0 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019d6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019d9:	89 c7                	mov    %eax,%edi
  8019db:	fc                   	cld    
  8019dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019de:	eb 05                	jmp    8019e5 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8019e0:	89 c7                	mov    %eax,%edi
  8019e2:	fc                   	cld    
  8019e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019e5:	5e                   	pop    %esi
  8019e6:	5f                   	pop    %edi
  8019e7:	5d                   	pop    %ebp
  8019e8:	c3                   	ret    

008019e9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019e9:	f3 0f 1e fb          	endbr32 
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8019f3:	ff 75 10             	pushl  0x10(%ebp)
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	e8 82 ff ff ff       	call   801983 <memmove>
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a03:	f3 0f 1e fb          	endbr32 
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	56                   	push   %esi
  801a0b:	53                   	push   %ebx
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a12:	89 c6                	mov    %eax,%esi
  801a14:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a17:	39 f0                	cmp    %esi,%eax
  801a19:	74 1c                	je     801a37 <memcmp+0x34>
		if (*s1 != *s2)
  801a1b:	0f b6 08             	movzbl (%eax),%ecx
  801a1e:	0f b6 1a             	movzbl (%edx),%ebx
  801a21:	38 d9                	cmp    %bl,%cl
  801a23:	75 08                	jne    801a2d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a25:	83 c0 01             	add    $0x1,%eax
  801a28:	83 c2 01             	add    $0x1,%edx
  801a2b:	eb ea                	jmp    801a17 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a2d:	0f b6 c1             	movzbl %cl,%eax
  801a30:	0f b6 db             	movzbl %bl,%ebx
  801a33:	29 d8                	sub    %ebx,%eax
  801a35:	eb 05                	jmp    801a3c <memcmp+0x39>
	}

	return 0;
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3c:	5b                   	pop    %ebx
  801a3d:	5e                   	pop    %esi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    

00801a40 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a40:	f3 0f 1e fb          	endbr32 
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a4d:	89 c2                	mov    %eax,%edx
  801a4f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a52:	39 d0                	cmp    %edx,%eax
  801a54:	73 09                	jae    801a5f <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a56:	38 08                	cmp    %cl,(%eax)
  801a58:	74 05                	je     801a5f <memfind+0x1f>
	for (; s < ends; s++)
  801a5a:	83 c0 01             	add    $0x1,%eax
  801a5d:	eb f3                	jmp    801a52 <memfind+0x12>
			break;
	return (void *) s;
}
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    

00801a61 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a61:	f3 0f 1e fb          	endbr32 
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	57                   	push   %edi
  801a69:	56                   	push   %esi
  801a6a:	53                   	push   %ebx
  801a6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a71:	eb 03                	jmp    801a76 <strtol+0x15>
		s++;
  801a73:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801a76:	0f b6 01             	movzbl (%ecx),%eax
  801a79:	3c 20                	cmp    $0x20,%al
  801a7b:	74 f6                	je     801a73 <strtol+0x12>
  801a7d:	3c 09                	cmp    $0x9,%al
  801a7f:	74 f2                	je     801a73 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801a81:	3c 2b                	cmp    $0x2b,%al
  801a83:	74 2a                	je     801aaf <strtol+0x4e>
	int neg = 0;
  801a85:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801a8a:	3c 2d                	cmp    $0x2d,%al
  801a8c:	74 2b                	je     801ab9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a8e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801a94:	75 0f                	jne    801aa5 <strtol+0x44>
  801a96:	80 39 30             	cmpb   $0x30,(%ecx)
  801a99:	74 28                	je     801ac3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a9b:	85 db                	test   %ebx,%ebx
  801a9d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801aa2:	0f 44 d8             	cmove  %eax,%ebx
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aaa:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801aad:	eb 46                	jmp    801af5 <strtol+0x94>
		s++;
  801aaf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801ab2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ab7:	eb d5                	jmp    801a8e <strtol+0x2d>
		s++, neg = 1;
  801ab9:	83 c1 01             	add    $0x1,%ecx
  801abc:	bf 01 00 00 00       	mov    $0x1,%edi
  801ac1:	eb cb                	jmp    801a8e <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ac3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ac7:	74 0e                	je     801ad7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801ac9:	85 db                	test   %ebx,%ebx
  801acb:	75 d8                	jne    801aa5 <strtol+0x44>
		s++, base = 8;
  801acd:	83 c1 01             	add    $0x1,%ecx
  801ad0:	bb 08 00 00 00       	mov    $0x8,%ebx
  801ad5:	eb ce                	jmp    801aa5 <strtol+0x44>
		s += 2, base = 16;
  801ad7:	83 c1 02             	add    $0x2,%ecx
  801ada:	bb 10 00 00 00       	mov    $0x10,%ebx
  801adf:	eb c4                	jmp    801aa5 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801ae1:	0f be d2             	movsbl %dl,%edx
  801ae4:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ae7:	3b 55 10             	cmp    0x10(%ebp),%edx
  801aea:	7d 3a                	jge    801b26 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801aec:	83 c1 01             	add    $0x1,%ecx
  801aef:	0f af 45 10          	imul   0x10(%ebp),%eax
  801af3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801af5:	0f b6 11             	movzbl (%ecx),%edx
  801af8:	8d 72 d0             	lea    -0x30(%edx),%esi
  801afb:	89 f3                	mov    %esi,%ebx
  801afd:	80 fb 09             	cmp    $0x9,%bl
  801b00:	76 df                	jbe    801ae1 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801b02:	8d 72 9f             	lea    -0x61(%edx),%esi
  801b05:	89 f3                	mov    %esi,%ebx
  801b07:	80 fb 19             	cmp    $0x19,%bl
  801b0a:	77 08                	ja     801b14 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801b0c:	0f be d2             	movsbl %dl,%edx
  801b0f:	83 ea 57             	sub    $0x57,%edx
  801b12:	eb d3                	jmp    801ae7 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801b14:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b17:	89 f3                	mov    %esi,%ebx
  801b19:	80 fb 19             	cmp    $0x19,%bl
  801b1c:	77 08                	ja     801b26 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b1e:	0f be d2             	movsbl %dl,%edx
  801b21:	83 ea 37             	sub    $0x37,%edx
  801b24:	eb c1                	jmp    801ae7 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b2a:	74 05                	je     801b31 <strtol+0xd0>
		*endptr = (char *) s;
  801b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b2f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b31:	89 c2                	mov    %eax,%edx
  801b33:	f7 da                	neg    %edx
  801b35:	85 ff                	test   %edi,%edi
  801b37:	0f 45 c2             	cmovne %edx,%eax
}
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5f                   	pop    %edi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    

00801b3f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b3f:	f3 0f 1e fb          	endbr32 
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	8b 75 08             	mov    0x8(%ebp),%esi
  801b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b51:	85 c0                	test   %eax,%eax
  801b53:	74 3d                	je     801b92 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b55:	83 ec 0c             	sub    $0xc,%esp
  801b58:	50                   	push   %eax
  801b59:	e8 f4 e7 ff ff       	call   800352 <sys_ipc_recv>
  801b5e:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b61:	85 f6                	test   %esi,%esi
  801b63:	74 0b                	je     801b70 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b65:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b6b:	8b 52 74             	mov    0x74(%edx),%edx
  801b6e:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b70:	85 db                	test   %ebx,%ebx
  801b72:	74 0b                	je     801b7f <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b74:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b7a:	8b 52 78             	mov    0x78(%edx),%edx
  801b7d:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 21                	js     801ba4 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b83:	a1 04 40 80 00       	mov    0x804004,%eax
  801b88:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8e:	5b                   	pop    %ebx
  801b8f:	5e                   	pop    %esi
  801b90:	5d                   	pop    %ebp
  801b91:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801b92:	83 ec 0c             	sub    $0xc,%esp
  801b95:	68 00 00 c0 ee       	push   $0xeec00000
  801b9a:	e8 b3 e7 ff ff       	call   800352 <sys_ipc_recv>
  801b9f:	83 c4 10             	add    $0x10,%esp
  801ba2:	eb bd                	jmp    801b61 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801ba4:	85 f6                	test   %esi,%esi
  801ba6:	74 10                	je     801bb8 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801ba8:	85 db                	test   %ebx,%ebx
  801baa:	75 df                	jne    801b8b <ipc_recv+0x4c>
  801bac:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bb3:	00 00 00 
  801bb6:	eb d3                	jmp    801b8b <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801bb8:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bbf:	00 00 00 
  801bc2:	eb e4                	jmp    801ba8 <ipc_recv+0x69>

00801bc4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bc4:	f3 0f 1e fb          	endbr32 
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	57                   	push   %edi
  801bcc:	56                   	push   %esi
  801bcd:	53                   	push   %ebx
  801bce:	83 ec 0c             	sub    $0xc,%esp
  801bd1:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bd4:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bda:	85 db                	test   %ebx,%ebx
  801bdc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801be1:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801be4:	ff 75 14             	pushl  0x14(%ebp)
  801be7:	53                   	push   %ebx
  801be8:	56                   	push   %esi
  801be9:	57                   	push   %edi
  801bea:	e8 3c e7 ff ff       	call   80032b <sys_ipc_try_send>
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	79 1e                	jns    801c14 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801bf6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801bf9:	75 07                	jne    801c02 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801bfb:	e8 63 e5 ff ff       	call   800163 <sys_yield>
  801c00:	eb e2                	jmp    801be4 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c02:	50                   	push   %eax
  801c03:	68 3f 23 80 00       	push   $0x80233f
  801c08:	6a 59                	push   $0x59
  801c0a:	68 5a 23 80 00       	push   $0x80235a
  801c0f:	e8 c8 f4 ff ff       	call   8010dc <_panic>
	}
}
  801c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    

00801c1c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c1c:	f3 0f 1e fb          	endbr32 
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c26:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c2b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c2e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c34:	8b 52 50             	mov    0x50(%edx),%edx
  801c37:	39 ca                	cmp    %ecx,%edx
  801c39:	74 11                	je     801c4c <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c3b:	83 c0 01             	add    $0x1,%eax
  801c3e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c43:	75 e6                	jne    801c2b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4a:	eb 0b                	jmp    801c57 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c4c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c4f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c54:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c59:	f3 0f 1e fb          	endbr32 
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c63:	89 c2                	mov    %eax,%edx
  801c65:	c1 ea 16             	shr    $0x16,%edx
  801c68:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c6f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c74:	f6 c1 01             	test   $0x1,%cl
  801c77:	74 1c                	je     801c95 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c79:	c1 e8 0c             	shr    $0xc,%eax
  801c7c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c83:	a8 01                	test   $0x1,%al
  801c85:	74 0e                	je     801c95 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c87:	c1 e8 0c             	shr    $0xc,%eax
  801c8a:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c91:	ef 
  801c92:	0f b7 d2             	movzwl %dx,%edx
}
  801c95:	89 d0                	mov    %edx,%eax
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    
  801c99:	66 90                	xchg   %ax,%ax
  801c9b:	66 90                	xchg   %ax,%ax
  801c9d:	66 90                	xchg   %ax,%ax
  801c9f:	90                   	nop

00801ca0 <__udivdi3>:
  801ca0:	f3 0f 1e fb          	endbr32 
  801ca4:	55                   	push   %ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 1c             	sub    $0x1c,%esp
  801cab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801caf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cb7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cbb:	85 d2                	test   %edx,%edx
  801cbd:	75 19                	jne    801cd8 <__udivdi3+0x38>
  801cbf:	39 f3                	cmp    %esi,%ebx
  801cc1:	76 4d                	jbe    801d10 <__udivdi3+0x70>
  801cc3:	31 ff                	xor    %edi,%edi
  801cc5:	89 e8                	mov    %ebp,%eax
  801cc7:	89 f2                	mov    %esi,%edx
  801cc9:	f7 f3                	div    %ebx
  801ccb:	89 fa                	mov    %edi,%edx
  801ccd:	83 c4 1c             	add    $0x1c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
  801cd5:	8d 76 00             	lea    0x0(%esi),%esi
  801cd8:	39 f2                	cmp    %esi,%edx
  801cda:	76 14                	jbe    801cf0 <__udivdi3+0x50>
  801cdc:	31 ff                	xor    %edi,%edi
  801cde:	31 c0                	xor    %eax,%eax
  801ce0:	89 fa                	mov    %edi,%edx
  801ce2:	83 c4 1c             	add    $0x1c,%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5f                   	pop    %edi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    
  801cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801cf0:	0f bd fa             	bsr    %edx,%edi
  801cf3:	83 f7 1f             	xor    $0x1f,%edi
  801cf6:	75 48                	jne    801d40 <__udivdi3+0xa0>
  801cf8:	39 f2                	cmp    %esi,%edx
  801cfa:	72 06                	jb     801d02 <__udivdi3+0x62>
  801cfc:	31 c0                	xor    %eax,%eax
  801cfe:	39 eb                	cmp    %ebp,%ebx
  801d00:	77 de                	ja     801ce0 <__udivdi3+0x40>
  801d02:	b8 01 00 00 00       	mov    $0x1,%eax
  801d07:	eb d7                	jmp    801ce0 <__udivdi3+0x40>
  801d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d10:	89 d9                	mov    %ebx,%ecx
  801d12:	85 db                	test   %ebx,%ebx
  801d14:	75 0b                	jne    801d21 <__udivdi3+0x81>
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1b:	31 d2                	xor    %edx,%edx
  801d1d:	f7 f3                	div    %ebx
  801d1f:	89 c1                	mov    %eax,%ecx
  801d21:	31 d2                	xor    %edx,%edx
  801d23:	89 f0                	mov    %esi,%eax
  801d25:	f7 f1                	div    %ecx
  801d27:	89 c6                	mov    %eax,%esi
  801d29:	89 e8                	mov    %ebp,%eax
  801d2b:	89 f7                	mov    %esi,%edi
  801d2d:	f7 f1                	div    %ecx
  801d2f:	89 fa                	mov    %edi,%edx
  801d31:	83 c4 1c             	add    $0x1c,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
  801d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d40:	89 f9                	mov    %edi,%ecx
  801d42:	b8 20 00 00 00       	mov    $0x20,%eax
  801d47:	29 f8                	sub    %edi,%eax
  801d49:	d3 e2                	shl    %cl,%edx
  801d4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d4f:	89 c1                	mov    %eax,%ecx
  801d51:	89 da                	mov    %ebx,%edx
  801d53:	d3 ea                	shr    %cl,%edx
  801d55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d59:	09 d1                	or     %edx,%ecx
  801d5b:	89 f2                	mov    %esi,%edx
  801d5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d61:	89 f9                	mov    %edi,%ecx
  801d63:	d3 e3                	shl    %cl,%ebx
  801d65:	89 c1                	mov    %eax,%ecx
  801d67:	d3 ea                	shr    %cl,%edx
  801d69:	89 f9                	mov    %edi,%ecx
  801d6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d6f:	89 eb                	mov    %ebp,%ebx
  801d71:	d3 e6                	shl    %cl,%esi
  801d73:	89 c1                	mov    %eax,%ecx
  801d75:	d3 eb                	shr    %cl,%ebx
  801d77:	09 de                	or     %ebx,%esi
  801d79:	89 f0                	mov    %esi,%eax
  801d7b:	f7 74 24 08          	divl   0x8(%esp)
  801d7f:	89 d6                	mov    %edx,%esi
  801d81:	89 c3                	mov    %eax,%ebx
  801d83:	f7 64 24 0c          	mull   0xc(%esp)
  801d87:	39 d6                	cmp    %edx,%esi
  801d89:	72 15                	jb     801da0 <__udivdi3+0x100>
  801d8b:	89 f9                	mov    %edi,%ecx
  801d8d:	d3 e5                	shl    %cl,%ebp
  801d8f:	39 c5                	cmp    %eax,%ebp
  801d91:	73 04                	jae    801d97 <__udivdi3+0xf7>
  801d93:	39 d6                	cmp    %edx,%esi
  801d95:	74 09                	je     801da0 <__udivdi3+0x100>
  801d97:	89 d8                	mov    %ebx,%eax
  801d99:	31 ff                	xor    %edi,%edi
  801d9b:	e9 40 ff ff ff       	jmp    801ce0 <__udivdi3+0x40>
  801da0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801da3:	31 ff                	xor    %edi,%edi
  801da5:	e9 36 ff ff ff       	jmp    801ce0 <__udivdi3+0x40>
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	66 90                	xchg   %ax,%ax
  801dae:	66 90                	xchg   %ax,%ax

00801db0 <__umoddi3>:
  801db0:	f3 0f 1e fb          	endbr32 
  801db4:	55                   	push   %ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 1c             	sub    $0x1c,%esp
  801dbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dbf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801dc3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801dc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	75 19                	jne    801de8 <__umoddi3+0x38>
  801dcf:	39 df                	cmp    %ebx,%edi
  801dd1:	76 5d                	jbe    801e30 <__umoddi3+0x80>
  801dd3:	89 f0                	mov    %esi,%eax
  801dd5:	89 da                	mov    %ebx,%edx
  801dd7:	f7 f7                	div    %edi
  801dd9:	89 d0                	mov    %edx,%eax
  801ddb:	31 d2                	xor    %edx,%edx
  801ddd:	83 c4 1c             	add    $0x1c,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    
  801de5:	8d 76 00             	lea    0x0(%esi),%esi
  801de8:	89 f2                	mov    %esi,%edx
  801dea:	39 d8                	cmp    %ebx,%eax
  801dec:	76 12                	jbe    801e00 <__umoddi3+0x50>
  801dee:	89 f0                	mov    %esi,%eax
  801df0:	89 da                	mov    %ebx,%edx
  801df2:	83 c4 1c             	add    $0x1c,%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5f                   	pop    %edi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    
  801dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e00:	0f bd e8             	bsr    %eax,%ebp
  801e03:	83 f5 1f             	xor    $0x1f,%ebp
  801e06:	75 50                	jne    801e58 <__umoddi3+0xa8>
  801e08:	39 d8                	cmp    %ebx,%eax
  801e0a:	0f 82 e0 00 00 00    	jb     801ef0 <__umoddi3+0x140>
  801e10:	89 d9                	mov    %ebx,%ecx
  801e12:	39 f7                	cmp    %esi,%edi
  801e14:	0f 86 d6 00 00 00    	jbe    801ef0 <__umoddi3+0x140>
  801e1a:	89 d0                	mov    %edx,%eax
  801e1c:	89 ca                	mov    %ecx,%edx
  801e1e:	83 c4 1c             	add    $0x1c,%esp
  801e21:	5b                   	pop    %ebx
  801e22:	5e                   	pop    %esi
  801e23:	5f                   	pop    %edi
  801e24:	5d                   	pop    %ebp
  801e25:	c3                   	ret    
  801e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e2d:	8d 76 00             	lea    0x0(%esi),%esi
  801e30:	89 fd                	mov    %edi,%ebp
  801e32:	85 ff                	test   %edi,%edi
  801e34:	75 0b                	jne    801e41 <__umoddi3+0x91>
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	31 d2                	xor    %edx,%edx
  801e3d:	f7 f7                	div    %edi
  801e3f:	89 c5                	mov    %eax,%ebp
  801e41:	89 d8                	mov    %ebx,%eax
  801e43:	31 d2                	xor    %edx,%edx
  801e45:	f7 f5                	div    %ebp
  801e47:	89 f0                	mov    %esi,%eax
  801e49:	f7 f5                	div    %ebp
  801e4b:	89 d0                	mov    %edx,%eax
  801e4d:	31 d2                	xor    %edx,%edx
  801e4f:	eb 8c                	jmp    801ddd <__umoddi3+0x2d>
  801e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e58:	89 e9                	mov    %ebp,%ecx
  801e5a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e5f:	29 ea                	sub    %ebp,%edx
  801e61:	d3 e0                	shl    %cl,%eax
  801e63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e67:	89 d1                	mov    %edx,%ecx
  801e69:	89 f8                	mov    %edi,%eax
  801e6b:	d3 e8                	shr    %cl,%eax
  801e6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e71:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e75:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e79:	09 c1                	or     %eax,%ecx
  801e7b:	89 d8                	mov    %ebx,%eax
  801e7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e81:	89 e9                	mov    %ebp,%ecx
  801e83:	d3 e7                	shl    %cl,%edi
  801e85:	89 d1                	mov    %edx,%ecx
  801e87:	d3 e8                	shr    %cl,%eax
  801e89:	89 e9                	mov    %ebp,%ecx
  801e8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e8f:	d3 e3                	shl    %cl,%ebx
  801e91:	89 c7                	mov    %eax,%edi
  801e93:	89 d1                	mov    %edx,%ecx
  801e95:	89 f0                	mov    %esi,%eax
  801e97:	d3 e8                	shr    %cl,%eax
  801e99:	89 e9                	mov    %ebp,%ecx
  801e9b:	89 fa                	mov    %edi,%edx
  801e9d:	d3 e6                	shl    %cl,%esi
  801e9f:	09 d8                	or     %ebx,%eax
  801ea1:	f7 74 24 08          	divl   0x8(%esp)
  801ea5:	89 d1                	mov    %edx,%ecx
  801ea7:	89 f3                	mov    %esi,%ebx
  801ea9:	f7 64 24 0c          	mull   0xc(%esp)
  801ead:	89 c6                	mov    %eax,%esi
  801eaf:	89 d7                	mov    %edx,%edi
  801eb1:	39 d1                	cmp    %edx,%ecx
  801eb3:	72 06                	jb     801ebb <__umoddi3+0x10b>
  801eb5:	75 10                	jne    801ec7 <__umoddi3+0x117>
  801eb7:	39 c3                	cmp    %eax,%ebx
  801eb9:	73 0c                	jae    801ec7 <__umoddi3+0x117>
  801ebb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801ebf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ec3:	89 d7                	mov    %edx,%edi
  801ec5:	89 c6                	mov    %eax,%esi
  801ec7:	89 ca                	mov    %ecx,%edx
  801ec9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ece:	29 f3                	sub    %esi,%ebx
  801ed0:	19 fa                	sbb    %edi,%edx
  801ed2:	89 d0                	mov    %edx,%eax
  801ed4:	d3 e0                	shl    %cl,%eax
  801ed6:	89 e9                	mov    %ebp,%ecx
  801ed8:	d3 eb                	shr    %cl,%ebx
  801eda:	d3 ea                	shr    %cl,%edx
  801edc:	09 d8                	or     %ebx,%eax
  801ede:	83 c4 1c             	add    $0x1c,%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5f                   	pop    %edi
  801ee4:	5d                   	pop    %ebp
  801ee5:	c3                   	ret    
  801ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801eed:	8d 76 00             	lea    0x0(%esi),%esi
  801ef0:	29 fe                	sub    %edi,%esi
  801ef2:	19 c3                	sbb    %eax,%ebx
  801ef4:	89 f2                	mov    %esi,%edx
  801ef6:	89 d9                	mov    %ebx,%ecx
  801ef8:	e9 1d ff ff ff       	jmp    801e1a <__umoddi3+0x6a>
