
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 21 00 00 00       	call   800052 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  80003d:	68 00 00 10 00       	push   $0x100000
  800042:	ff 35 00 30 80 00    	pushl  0x803000
  800048:	e8 6d 00 00 00       	call   8000ba <sys_cputs>
}
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	c9                   	leave  
  800051:	c3                   	ret    

00800052 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800052:	f3 0f 1e fb          	endbr32 
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800061:	e8 de 00 00 00       	call   800144 <sys_getenvid>
  800066:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800073:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800078:	85 db                	test   %ebx,%ebx
  80007a:	7e 07                	jle    800083 <libmain+0x31>
		binaryname = argv[0];
  80007c:	8b 06                	mov    (%esi),%eax
  80007e:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800083:	83 ec 08             	sub    $0x8,%esp
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	e8 a6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008d:	e8 0a 00 00 00       	call   80009c <exit>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800098:	5b                   	pop    %ebx
  800099:	5e                   	pop    %esi
  80009a:	5d                   	pop    %ebp
  80009b:	c3                   	ret    

0080009c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009c:	f3 0f 1e fb          	endbr32 
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a6:	e8 93 05 00 00       	call   80063e <close_all>
	sys_env_destroy(0);
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	6a 00                	push   $0x0
  8000b0:	e8 4a 00 00 00       	call   8000ff <sys_env_destroy>
}
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	c9                   	leave  
  8000b9:	c3                   	ret    

008000ba <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ba:	f3 0f 1e fb          	endbr32 
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	57                   	push   %edi
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000cf:	89 c3                	mov    %eax,%ebx
  8000d1:	89 c7                	mov    %eax,%edi
  8000d3:	89 c6                	mov    %eax,%esi
  8000d5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000dc:	f3 0f 1e fb          	endbr32 
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f0:	89 d1                	mov    %edx,%ecx
  8000f2:	89 d3                	mov    %edx,%ebx
  8000f4:	89 d7                	mov    %edx,%edi
  8000f6:	89 d6                	mov    %edx,%esi
  8000f8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5f                   	pop    %edi
  8000fd:	5d                   	pop    %ebp
  8000fe:	c3                   	ret    

008000ff <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ff:	f3 0f 1e fb          	endbr32 
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	57                   	push   %edi
  800107:	56                   	push   %esi
  800108:	53                   	push   %ebx
  800109:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80010c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800111:	8b 55 08             	mov    0x8(%ebp),%edx
  800114:	b8 03 00 00 00       	mov    $0x3,%eax
  800119:	89 cb                	mov    %ecx,%ebx
  80011b:	89 cf                	mov    %ecx,%edi
  80011d:	89 ce                	mov    %ecx,%esi
  80011f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800121:	85 c0                	test   %eax,%eax
  800123:	7f 08                	jg     80012d <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800125:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5f                   	pop    %edi
  80012b:	5d                   	pop    %ebp
  80012c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	6a 03                	push   $0x3
  800133:	68 98 24 80 00       	push   $0x802498
  800138:	6a 23                	push   $0x23
  80013a:	68 b5 24 80 00       	push   $0x8024b5
  80013f:	e8 08 15 00 00       	call   80164c <_panic>

00800144 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800144:	f3 0f 1e fb          	endbr32 
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	57                   	push   %edi
  80014c:	56                   	push   %esi
  80014d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014e:	ba 00 00 00 00       	mov    $0x0,%edx
  800153:	b8 02 00 00 00       	mov    $0x2,%eax
  800158:	89 d1                	mov    %edx,%ecx
  80015a:	89 d3                	mov    %edx,%ebx
  80015c:	89 d7                	mov    %edx,%edi
  80015e:	89 d6                	mov    %edx,%esi
  800160:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800162:	5b                   	pop    %ebx
  800163:	5e                   	pop    %esi
  800164:	5f                   	pop    %edi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    

00800167 <sys_yield>:

void
sys_yield(void)
{
  800167:	f3 0f 1e fb          	endbr32 
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	57                   	push   %edi
  80016f:	56                   	push   %esi
  800170:	53                   	push   %ebx
	asm volatile("int %1\n"
  800171:	ba 00 00 00 00       	mov    $0x0,%edx
  800176:	b8 0b 00 00 00       	mov    $0xb,%eax
  80017b:	89 d1                	mov    %edx,%ecx
  80017d:	89 d3                	mov    %edx,%ebx
  80017f:	89 d7                	mov    %edx,%edi
  800181:	89 d6                	mov    %edx,%esi
  800183:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    

0080018a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80018a:	f3 0f 1e fb          	endbr32 
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	57                   	push   %edi
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
  800194:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800197:	be 00 00 00 00       	mov    $0x0,%esi
  80019c:	8b 55 08             	mov    0x8(%ebp),%edx
  80019f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8001a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001aa:	89 f7                	mov    %esi,%edi
  8001ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	7f 08                	jg     8001ba <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b5:	5b                   	pop    %ebx
  8001b6:	5e                   	pop    %esi
  8001b7:	5f                   	pop    %edi
  8001b8:	5d                   	pop    %ebp
  8001b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	6a 04                	push   $0x4
  8001c0:	68 98 24 80 00       	push   $0x802498
  8001c5:	6a 23                	push   $0x23
  8001c7:	68 b5 24 80 00       	push   $0x8024b5
  8001cc:	e8 7b 14 00 00       	call   80164c <_panic>

008001d1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d1:	f3 0f 1e fb          	endbr32 
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	57                   	push   %edi
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001de:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ec:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f4:	85 c0                	test   %eax,%eax
  8001f6:	7f 08                	jg     800200 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fb:	5b                   	pop    %ebx
  8001fc:	5e                   	pop    %esi
  8001fd:	5f                   	pop    %edi
  8001fe:	5d                   	pop    %ebp
  8001ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800200:	83 ec 0c             	sub    $0xc,%esp
  800203:	50                   	push   %eax
  800204:	6a 05                	push   $0x5
  800206:	68 98 24 80 00       	push   $0x802498
  80020b:	6a 23                	push   $0x23
  80020d:	68 b5 24 80 00       	push   $0x8024b5
  800212:	e8 35 14 00 00       	call   80164c <_panic>

00800217 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800217:	f3 0f 1e fb          	endbr32 
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	57                   	push   %edi
  80021f:	56                   	push   %esi
  800220:	53                   	push   %ebx
  800221:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800224:	bb 00 00 00 00       	mov    $0x0,%ebx
  800229:	8b 55 08             	mov    0x8(%ebp),%edx
  80022c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022f:	b8 06 00 00 00       	mov    $0x6,%eax
  800234:	89 df                	mov    %ebx,%edi
  800236:	89 de                	mov    %ebx,%esi
  800238:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023a:	85 c0                	test   %eax,%eax
  80023c:	7f 08                	jg     800246 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80023e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800241:	5b                   	pop    %ebx
  800242:	5e                   	pop    %esi
  800243:	5f                   	pop    %edi
  800244:	5d                   	pop    %ebp
  800245:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	50                   	push   %eax
  80024a:	6a 06                	push   $0x6
  80024c:	68 98 24 80 00       	push   $0x802498
  800251:	6a 23                	push   $0x23
  800253:	68 b5 24 80 00       	push   $0x8024b5
  800258:	e8 ef 13 00 00       	call   80164c <_panic>

0080025d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80025d:	f3 0f 1e fb          	endbr32 
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	57                   	push   %edi
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026f:	8b 55 08             	mov    0x8(%ebp),%edx
  800272:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800275:	b8 08 00 00 00       	mov    $0x8,%eax
  80027a:	89 df                	mov    %ebx,%edi
  80027c:	89 de                	mov    %ebx,%esi
  80027e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800280:	85 c0                	test   %eax,%eax
  800282:	7f 08                	jg     80028c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800284:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800287:	5b                   	pop    %ebx
  800288:	5e                   	pop    %esi
  800289:	5f                   	pop    %edi
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	6a 08                	push   $0x8
  800292:	68 98 24 80 00       	push   $0x802498
  800297:	6a 23                	push   $0x23
  800299:	68 b5 24 80 00       	push   $0x8024b5
  80029e:	e8 a9 13 00 00       	call   80164c <_panic>

008002a3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a3:	f3 0f 1e fb          	endbr32 
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	57                   	push   %edi
  8002ab:	56                   	push   %esi
  8002ac:	53                   	push   %ebx
  8002ad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bb:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c0:	89 df                	mov    %ebx,%edi
  8002c2:	89 de                	mov    %ebx,%esi
  8002c4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c6:	85 c0                	test   %eax,%eax
  8002c8:	7f 08                	jg     8002d2 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cd:	5b                   	pop    %ebx
  8002ce:	5e                   	pop    %esi
  8002cf:	5f                   	pop    %edi
  8002d0:	5d                   	pop    %ebp
  8002d1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	50                   	push   %eax
  8002d6:	6a 09                	push   $0x9
  8002d8:	68 98 24 80 00       	push   $0x802498
  8002dd:	6a 23                	push   $0x23
  8002df:	68 b5 24 80 00       	push   $0x8024b5
  8002e4:	e8 63 13 00 00       	call   80164c <_panic>

008002e9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e9:	f3 0f 1e fb          	endbr32 
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800301:	b8 0a 00 00 00       	mov    $0xa,%eax
  800306:	89 df                	mov    %ebx,%edi
  800308:	89 de                	mov    %ebx,%esi
  80030a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80030c:	85 c0                	test   %eax,%eax
  80030e:	7f 08                	jg     800318 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800313:	5b                   	pop    %ebx
  800314:	5e                   	pop    %esi
  800315:	5f                   	pop    %edi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	6a 0a                	push   $0xa
  80031e:	68 98 24 80 00       	push   $0x802498
  800323:	6a 23                	push   $0x23
  800325:	68 b5 24 80 00       	push   $0x8024b5
  80032a:	e8 1d 13 00 00       	call   80164c <_panic>

0080032f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032f:	f3 0f 1e fb          	endbr32 
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	57                   	push   %edi
  800337:	56                   	push   %esi
  800338:	53                   	push   %ebx
	asm volatile("int %1\n"
  800339:	8b 55 08             	mov    0x8(%ebp),%edx
  80033c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800344:	be 00 00 00 00       	mov    $0x0,%esi
  800349:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80034c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80034f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800351:	5b                   	pop    %ebx
  800352:	5e                   	pop    %esi
  800353:	5f                   	pop    %edi
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800356:	f3 0f 1e fb          	endbr32 
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	57                   	push   %edi
  80035e:	56                   	push   %esi
  80035f:	53                   	push   %ebx
  800360:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800363:	b9 00 00 00 00       	mov    $0x0,%ecx
  800368:	8b 55 08             	mov    0x8(%ebp),%edx
  80036b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800370:	89 cb                	mov    %ecx,%ebx
  800372:	89 cf                	mov    %ecx,%edi
  800374:	89 ce                	mov    %ecx,%esi
  800376:	cd 30                	int    $0x30
	if(check && ret > 0)
  800378:	85 c0                	test   %eax,%eax
  80037a:	7f 08                	jg     800384 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80037c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	6a 0d                	push   $0xd
  80038a:	68 98 24 80 00       	push   $0x802498
  80038f:	6a 23                	push   $0x23
  800391:	68 b5 24 80 00       	push   $0x8024b5
  800396:	e8 b1 12 00 00       	call   80164c <_panic>

0080039b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80039b:	f3 0f 1e fb          	endbr32 
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	57                   	push   %edi
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003af:	89 d1                	mov    %edx,%ecx
  8003b1:	89 d3                	mov    %edx,%ebx
  8003b3:	89 d7                	mov    %edx,%edi
  8003b5:	89 d6                	mov    %edx,%esi
  8003b7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003b9:	5b                   	pop    %ebx
  8003ba:	5e                   	pop    %esi
  8003bb:	5f                   	pop    %edi
  8003bc:	5d                   	pop    %ebp
  8003bd:	c3                   	ret    

008003be <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8003be:	f3 0f 1e fb          	endbr32 
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	57                   	push   %edi
  8003c6:	56                   	push   %esi
  8003c7:	53                   	push   %ebx
  8003c8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003d6:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003db:	89 df                	mov    %ebx,%edi
  8003dd:	89 de                	mov    %ebx,%esi
  8003df:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003e1:	85 c0                	test   %eax,%eax
  8003e3:	7f 08                	jg     8003ed <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8003e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e8:	5b                   	pop    %ebx
  8003e9:	5e                   	pop    %esi
  8003ea:	5f                   	pop    %edi
  8003eb:	5d                   	pop    %ebp
  8003ec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003ed:	83 ec 0c             	sub    $0xc,%esp
  8003f0:	50                   	push   %eax
  8003f1:	6a 0f                	push   $0xf
  8003f3:	68 98 24 80 00       	push   $0x802498
  8003f8:	6a 23                	push   $0x23
  8003fa:	68 b5 24 80 00       	push   $0x8024b5
  8003ff:	e8 48 12 00 00       	call   80164c <_panic>

00800404 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800404:	f3 0f 1e fb          	endbr32 
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	57                   	push   %edi
  80040c:	56                   	push   %esi
  80040d:	53                   	push   %ebx
  80040e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800411:	bb 00 00 00 00       	mov    $0x0,%ebx
  800416:	8b 55 08             	mov    0x8(%ebp),%edx
  800419:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80041c:	b8 10 00 00 00       	mov    $0x10,%eax
  800421:	89 df                	mov    %ebx,%edi
  800423:	89 de                	mov    %ebx,%esi
  800425:	cd 30                	int    $0x30
	if(check && ret > 0)
  800427:	85 c0                	test   %eax,%eax
  800429:	7f 08                	jg     800433 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  80042b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80042e:	5b                   	pop    %ebx
  80042f:	5e                   	pop    %esi
  800430:	5f                   	pop    %edi
  800431:	5d                   	pop    %ebp
  800432:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	50                   	push   %eax
  800437:	6a 10                	push   $0x10
  800439:	68 98 24 80 00       	push   $0x802498
  80043e:	6a 23                	push   $0x23
  800440:	68 b5 24 80 00       	push   $0x8024b5
  800445:	e8 02 12 00 00       	call   80164c <_panic>

0080044a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80044a:	f3 0f 1e fb          	endbr32 
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	05 00 00 00 30       	add    $0x30000000,%eax
  800459:	c1 e8 0c             	shr    $0xc,%eax
}
  80045c:	5d                   	pop    %ebp
  80045d:	c3                   	ret    

0080045e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80045e:	f3 0f 1e fb          	endbr32 
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80046d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800472:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800477:	5d                   	pop    %ebp
  800478:	c3                   	ret    

00800479 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800479:	f3 0f 1e fb          	endbr32 
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800485:	89 c2                	mov    %eax,%edx
  800487:	c1 ea 16             	shr    $0x16,%edx
  80048a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800491:	f6 c2 01             	test   $0x1,%dl
  800494:	74 2d                	je     8004c3 <fd_alloc+0x4a>
  800496:	89 c2                	mov    %eax,%edx
  800498:	c1 ea 0c             	shr    $0xc,%edx
  80049b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004a2:	f6 c2 01             	test   $0x1,%dl
  8004a5:	74 1c                	je     8004c3 <fd_alloc+0x4a>
  8004a7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8004ac:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8004b1:	75 d2                	jne    800485 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004bc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8004c1:	eb 0a                	jmp    8004cd <fd_alloc+0x54>
			*fd_store = fd;
  8004c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    

008004cf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004cf:	f3 0f 1e fb          	endbr32 
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004d9:	83 f8 1f             	cmp    $0x1f,%eax
  8004dc:	77 30                	ja     80050e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004de:	c1 e0 0c             	shl    $0xc,%eax
  8004e1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004e6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8004ec:	f6 c2 01             	test   $0x1,%dl
  8004ef:	74 24                	je     800515 <fd_lookup+0x46>
  8004f1:	89 c2                	mov    %eax,%edx
  8004f3:	c1 ea 0c             	shr    $0xc,%edx
  8004f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004fd:	f6 c2 01             	test   $0x1,%dl
  800500:	74 1a                	je     80051c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800502:	8b 55 0c             	mov    0xc(%ebp),%edx
  800505:	89 02                	mov    %eax,(%edx)
	return 0;
  800507:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80050c:	5d                   	pop    %ebp
  80050d:	c3                   	ret    
		return -E_INVAL;
  80050e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800513:	eb f7                	jmp    80050c <fd_lookup+0x3d>
		return -E_INVAL;
  800515:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80051a:	eb f0                	jmp    80050c <fd_lookup+0x3d>
  80051c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800521:	eb e9                	jmp    80050c <fd_lookup+0x3d>

00800523 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800523:	f3 0f 1e fb          	endbr32 
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800530:	ba 00 00 00 00       	mov    $0x0,%edx
  800535:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80053a:	39 08                	cmp    %ecx,(%eax)
  80053c:	74 38                	je     800576 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80053e:	83 c2 01             	add    $0x1,%edx
  800541:	8b 04 95 40 25 80 00 	mov    0x802540(,%edx,4),%eax
  800548:	85 c0                	test   %eax,%eax
  80054a:	75 ee                	jne    80053a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80054c:	a1 08 40 80 00       	mov    0x804008,%eax
  800551:	8b 40 48             	mov    0x48(%eax),%eax
  800554:	83 ec 04             	sub    $0x4,%esp
  800557:	51                   	push   %ecx
  800558:	50                   	push   %eax
  800559:	68 c4 24 80 00       	push   $0x8024c4
  80055e:	e8 d0 11 00 00       	call   801733 <cprintf>
	*dev = 0;
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800574:	c9                   	leave  
  800575:	c3                   	ret    
			*dev = devtab[i];
  800576:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800579:	89 01                	mov    %eax,(%ecx)
			return 0;
  80057b:	b8 00 00 00 00       	mov    $0x0,%eax
  800580:	eb f2                	jmp    800574 <dev_lookup+0x51>

00800582 <fd_close>:
{
  800582:	f3 0f 1e fb          	endbr32 
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
  800589:	57                   	push   %edi
  80058a:	56                   	push   %esi
  80058b:	53                   	push   %ebx
  80058c:	83 ec 24             	sub    $0x24,%esp
  80058f:	8b 75 08             	mov    0x8(%ebp),%esi
  800592:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800595:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800598:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800599:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80059f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005a2:	50                   	push   %eax
  8005a3:	e8 27 ff ff ff       	call   8004cf <fd_lookup>
  8005a8:	89 c3                	mov    %eax,%ebx
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	85 c0                	test   %eax,%eax
  8005af:	78 05                	js     8005b6 <fd_close+0x34>
	    || fd != fd2)
  8005b1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8005b4:	74 16                	je     8005cc <fd_close+0x4a>
		return (must_exist ? r : 0);
  8005b6:	89 f8                	mov    %edi,%eax
  8005b8:	84 c0                	test   %al,%al
  8005ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bf:	0f 44 d8             	cmove  %eax,%ebx
}
  8005c2:	89 d8                	mov    %ebx,%eax
  8005c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c7:	5b                   	pop    %ebx
  8005c8:	5e                   	pop    %esi
  8005c9:	5f                   	pop    %edi
  8005ca:	5d                   	pop    %ebp
  8005cb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005d2:	50                   	push   %eax
  8005d3:	ff 36                	pushl  (%esi)
  8005d5:	e8 49 ff ff ff       	call   800523 <dev_lookup>
  8005da:	89 c3                	mov    %eax,%ebx
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	85 c0                	test   %eax,%eax
  8005e1:	78 1a                	js     8005fd <fd_close+0x7b>
		if (dev->dev_close)
  8005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8005e9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8005ee:	85 c0                	test   %eax,%eax
  8005f0:	74 0b                	je     8005fd <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8005f2:	83 ec 0c             	sub    $0xc,%esp
  8005f5:	56                   	push   %esi
  8005f6:	ff d0                	call   *%eax
  8005f8:	89 c3                	mov    %eax,%ebx
  8005fa:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	56                   	push   %esi
  800601:	6a 00                	push   $0x0
  800603:	e8 0f fc ff ff       	call   800217 <sys_page_unmap>
	return r;
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	eb b5                	jmp    8005c2 <fd_close+0x40>

0080060d <close>:

int
close(int fdnum)
{
  80060d:	f3 0f 1e fb          	endbr32 
  800611:	55                   	push   %ebp
  800612:	89 e5                	mov    %esp,%ebp
  800614:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800617:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80061a:	50                   	push   %eax
  80061b:	ff 75 08             	pushl  0x8(%ebp)
  80061e:	e8 ac fe ff ff       	call   8004cf <fd_lookup>
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	85 c0                	test   %eax,%eax
  800628:	79 02                	jns    80062c <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80062a:	c9                   	leave  
  80062b:	c3                   	ret    
		return fd_close(fd, 1);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	6a 01                	push   $0x1
  800631:	ff 75 f4             	pushl  -0xc(%ebp)
  800634:	e8 49 ff ff ff       	call   800582 <fd_close>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	eb ec                	jmp    80062a <close+0x1d>

0080063e <close_all>:

void
close_all(void)
{
  80063e:	f3 0f 1e fb          	endbr32 
  800642:	55                   	push   %ebp
  800643:	89 e5                	mov    %esp,%ebp
  800645:	53                   	push   %ebx
  800646:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800649:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	53                   	push   %ebx
  800652:	e8 b6 ff ff ff       	call   80060d <close>
	for (i = 0; i < MAXFD; i++)
  800657:	83 c3 01             	add    $0x1,%ebx
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	83 fb 20             	cmp    $0x20,%ebx
  800660:	75 ec                	jne    80064e <close_all+0x10>
}
  800662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800667:	f3 0f 1e fb          	endbr32 
  80066b:	55                   	push   %ebp
  80066c:	89 e5                	mov    %esp,%ebp
  80066e:	57                   	push   %edi
  80066f:	56                   	push   %esi
  800670:	53                   	push   %ebx
  800671:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800674:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800677:	50                   	push   %eax
  800678:	ff 75 08             	pushl  0x8(%ebp)
  80067b:	e8 4f fe ff ff       	call   8004cf <fd_lookup>
  800680:	89 c3                	mov    %eax,%ebx
  800682:	83 c4 10             	add    $0x10,%esp
  800685:	85 c0                	test   %eax,%eax
  800687:	0f 88 81 00 00 00    	js     80070e <dup+0xa7>
		return r;
	close(newfdnum);
  80068d:	83 ec 0c             	sub    $0xc,%esp
  800690:	ff 75 0c             	pushl  0xc(%ebp)
  800693:	e8 75 ff ff ff       	call   80060d <close>

	newfd = INDEX2FD(newfdnum);
  800698:	8b 75 0c             	mov    0xc(%ebp),%esi
  80069b:	c1 e6 0c             	shl    $0xc,%esi
  80069e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8006a4:	83 c4 04             	add    $0x4,%esp
  8006a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006aa:	e8 af fd ff ff       	call   80045e <fd2data>
  8006af:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8006b1:	89 34 24             	mov    %esi,(%esp)
  8006b4:	e8 a5 fd ff ff       	call   80045e <fd2data>
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006be:	89 d8                	mov    %ebx,%eax
  8006c0:	c1 e8 16             	shr    $0x16,%eax
  8006c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006ca:	a8 01                	test   $0x1,%al
  8006cc:	74 11                	je     8006df <dup+0x78>
  8006ce:	89 d8                	mov    %ebx,%eax
  8006d0:	c1 e8 0c             	shr    $0xc,%eax
  8006d3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006da:	f6 c2 01             	test   $0x1,%dl
  8006dd:	75 39                	jne    800718 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006e2:	89 d0                	mov    %edx,%eax
  8006e4:	c1 e8 0c             	shr    $0xc,%eax
  8006e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8006f6:	50                   	push   %eax
  8006f7:	56                   	push   %esi
  8006f8:	6a 00                	push   $0x0
  8006fa:	52                   	push   %edx
  8006fb:	6a 00                	push   $0x0
  8006fd:	e8 cf fa ff ff       	call   8001d1 <sys_page_map>
  800702:	89 c3                	mov    %eax,%ebx
  800704:	83 c4 20             	add    $0x20,%esp
  800707:	85 c0                	test   %eax,%eax
  800709:	78 31                	js     80073c <dup+0xd5>
		goto err;

	return newfdnum;
  80070b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80070e:	89 d8                	mov    %ebx,%eax
  800710:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800713:	5b                   	pop    %ebx
  800714:	5e                   	pop    %esi
  800715:	5f                   	pop    %edi
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800718:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80071f:	83 ec 0c             	sub    $0xc,%esp
  800722:	25 07 0e 00 00       	and    $0xe07,%eax
  800727:	50                   	push   %eax
  800728:	57                   	push   %edi
  800729:	6a 00                	push   $0x0
  80072b:	53                   	push   %ebx
  80072c:	6a 00                	push   $0x0
  80072e:	e8 9e fa ff ff       	call   8001d1 <sys_page_map>
  800733:	89 c3                	mov    %eax,%ebx
  800735:	83 c4 20             	add    $0x20,%esp
  800738:	85 c0                	test   %eax,%eax
  80073a:	79 a3                	jns    8006df <dup+0x78>
	sys_page_unmap(0, newfd);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	56                   	push   %esi
  800740:	6a 00                	push   $0x0
  800742:	e8 d0 fa ff ff       	call   800217 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800747:	83 c4 08             	add    $0x8,%esp
  80074a:	57                   	push   %edi
  80074b:	6a 00                	push   $0x0
  80074d:	e8 c5 fa ff ff       	call   800217 <sys_page_unmap>
	return r;
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	eb b7                	jmp    80070e <dup+0xa7>

00800757 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800757:	f3 0f 1e fb          	endbr32 
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	53                   	push   %ebx
  80075f:	83 ec 1c             	sub    $0x1c,%esp
  800762:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800765:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800768:	50                   	push   %eax
  800769:	53                   	push   %ebx
  80076a:	e8 60 fd ff ff       	call   8004cf <fd_lookup>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	85 c0                	test   %eax,%eax
  800774:	78 3f                	js     8007b5 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80077c:	50                   	push   %eax
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	ff 30                	pushl  (%eax)
  800782:	e8 9c fd ff ff       	call   800523 <dev_lookup>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	85 c0                	test   %eax,%eax
  80078c:	78 27                	js     8007b5 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80078e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800791:	8b 42 08             	mov    0x8(%edx),%eax
  800794:	83 e0 03             	and    $0x3,%eax
  800797:	83 f8 01             	cmp    $0x1,%eax
  80079a:	74 1e                	je     8007ba <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079f:	8b 40 08             	mov    0x8(%eax),%eax
  8007a2:	85 c0                	test   %eax,%eax
  8007a4:	74 35                	je     8007db <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8007a6:	83 ec 04             	sub    $0x4,%esp
  8007a9:	ff 75 10             	pushl  0x10(%ebp)
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	52                   	push   %edx
  8007b0:	ff d0                	call   *%eax
  8007b2:	83 c4 10             	add    $0x10,%esp
}
  8007b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8007bf:	8b 40 48             	mov    0x48(%eax),%eax
  8007c2:	83 ec 04             	sub    $0x4,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	50                   	push   %eax
  8007c7:	68 05 25 80 00       	push   $0x802505
  8007cc:	e8 62 0f 00 00       	call   801733 <cprintf>
		return -E_INVAL;
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d9:	eb da                	jmp    8007b5 <read+0x5e>
		return -E_NOT_SUPP;
  8007db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007e0:	eb d3                	jmp    8007b5 <read+0x5e>

008007e2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007e2:	f3 0f 1e fb          	endbr32 
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	57                   	push   %edi
  8007ea:	56                   	push   %esi
  8007eb:	53                   	push   %ebx
  8007ec:	83 ec 0c             	sub    $0xc,%esp
  8007ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007f2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007fa:	eb 02                	jmp    8007fe <readn+0x1c>
  8007fc:	01 c3                	add    %eax,%ebx
  8007fe:	39 f3                	cmp    %esi,%ebx
  800800:	73 21                	jae    800823 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800802:	83 ec 04             	sub    $0x4,%esp
  800805:	89 f0                	mov    %esi,%eax
  800807:	29 d8                	sub    %ebx,%eax
  800809:	50                   	push   %eax
  80080a:	89 d8                	mov    %ebx,%eax
  80080c:	03 45 0c             	add    0xc(%ebp),%eax
  80080f:	50                   	push   %eax
  800810:	57                   	push   %edi
  800811:	e8 41 ff ff ff       	call   800757 <read>
		if (m < 0)
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	85 c0                	test   %eax,%eax
  80081b:	78 04                	js     800821 <readn+0x3f>
			return m;
		if (m == 0)
  80081d:	75 dd                	jne    8007fc <readn+0x1a>
  80081f:	eb 02                	jmp    800823 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800821:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800823:	89 d8                	mov    %ebx,%eax
  800825:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800828:	5b                   	pop    %ebx
  800829:	5e                   	pop    %esi
  80082a:	5f                   	pop    %edi
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80082d:	f3 0f 1e fb          	endbr32 
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	53                   	push   %ebx
  800835:	83 ec 1c             	sub    $0x1c,%esp
  800838:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80083b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80083e:	50                   	push   %eax
  80083f:	53                   	push   %ebx
  800840:	e8 8a fc ff ff       	call   8004cf <fd_lookup>
  800845:	83 c4 10             	add    $0x10,%esp
  800848:	85 c0                	test   %eax,%eax
  80084a:	78 3a                	js     800886 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800852:	50                   	push   %eax
  800853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800856:	ff 30                	pushl  (%eax)
  800858:	e8 c6 fc ff ff       	call   800523 <dev_lookup>
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	85 c0                	test   %eax,%eax
  800862:	78 22                	js     800886 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800867:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80086b:	74 1e                	je     80088b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80086d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800870:	8b 52 0c             	mov    0xc(%edx),%edx
  800873:	85 d2                	test   %edx,%edx
  800875:	74 35                	je     8008ac <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	ff 75 10             	pushl  0x10(%ebp)
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	50                   	push   %eax
  800881:	ff d2                	call   *%edx
  800883:	83 c4 10             	add    $0x10,%esp
}
  800886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800889:	c9                   	leave  
  80088a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80088b:	a1 08 40 80 00       	mov    0x804008,%eax
  800890:	8b 40 48             	mov    0x48(%eax),%eax
  800893:	83 ec 04             	sub    $0x4,%esp
  800896:	53                   	push   %ebx
  800897:	50                   	push   %eax
  800898:	68 21 25 80 00       	push   $0x802521
  80089d:	e8 91 0e 00 00       	call   801733 <cprintf>
		return -E_INVAL;
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008aa:	eb da                	jmp    800886 <write+0x59>
		return -E_NOT_SUPP;
  8008ac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008b1:	eb d3                	jmp    800886 <write+0x59>

008008b3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8008b3:	f3 0f 1e fb          	endbr32 
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008c0:	50                   	push   %eax
  8008c1:	ff 75 08             	pushl  0x8(%ebp)
  8008c4:	e8 06 fc ff ff       	call   8004cf <fd_lookup>
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	78 0e                	js     8008de <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8008d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    

008008e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008e0:	f3 0f 1e fb          	endbr32 
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	53                   	push   %ebx
  8008e8:	83 ec 1c             	sub    $0x1c,%esp
  8008eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008f1:	50                   	push   %eax
  8008f2:	53                   	push   %ebx
  8008f3:	e8 d7 fb ff ff       	call   8004cf <fd_lookup>
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	78 37                	js     800936 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800905:	50                   	push   %eax
  800906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800909:	ff 30                	pushl  (%eax)
  80090b:	e8 13 fc ff ff       	call   800523 <dev_lookup>
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	85 c0                	test   %eax,%eax
  800915:	78 1f                	js     800936 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80091a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80091e:	74 1b                	je     80093b <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800920:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800923:	8b 52 18             	mov    0x18(%edx),%edx
  800926:	85 d2                	test   %edx,%edx
  800928:	74 32                	je     80095c <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	ff d2                	call   *%edx
  800933:	83 c4 10             	add    $0x10,%esp
}
  800936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800939:	c9                   	leave  
  80093a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80093b:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800940:	8b 40 48             	mov    0x48(%eax),%eax
  800943:	83 ec 04             	sub    $0x4,%esp
  800946:	53                   	push   %ebx
  800947:	50                   	push   %eax
  800948:	68 e4 24 80 00       	push   $0x8024e4
  80094d:	e8 e1 0d 00 00       	call   801733 <cprintf>
		return -E_INVAL;
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80095a:	eb da                	jmp    800936 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80095c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800961:	eb d3                	jmp    800936 <ftruncate+0x56>

00800963 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800963:	f3 0f 1e fb          	endbr32 
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	53                   	push   %ebx
  80096b:	83 ec 1c             	sub    $0x1c,%esp
  80096e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800971:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800974:	50                   	push   %eax
  800975:	ff 75 08             	pushl  0x8(%ebp)
  800978:	e8 52 fb ff ff       	call   8004cf <fd_lookup>
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	85 c0                	test   %eax,%eax
  800982:	78 4b                	js     8009cf <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098e:	ff 30                	pushl  (%eax)
  800990:	e8 8e fb ff ff       	call   800523 <dev_lookup>
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	85 c0                	test   %eax,%eax
  80099a:	78 33                	js     8009cf <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80099c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8009a3:	74 2f                	je     8009d4 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8009a5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8009a8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8009af:	00 00 00 
	stat->st_isdir = 0;
  8009b2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009b9:	00 00 00 
	stat->st_dev = dev;
  8009bc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	53                   	push   %ebx
  8009c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c9:	ff 50 14             	call   *0x14(%eax)
  8009cc:	83 c4 10             	add    $0x10,%esp
}
  8009cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d2:	c9                   	leave  
  8009d3:	c3                   	ret    
		return -E_NOT_SUPP;
  8009d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8009d9:	eb f4                	jmp    8009cf <fstat+0x6c>

008009db <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009db:	f3 0f 1e fb          	endbr32 
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	56                   	push   %esi
  8009e3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	6a 00                	push   $0x0
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	e8 fb 01 00 00       	call   800bec <open>
  8009f1:	89 c3                	mov    %eax,%ebx
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	85 c0                	test   %eax,%eax
  8009f8:	78 1b                	js     800a15 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	50                   	push   %eax
  800a01:	e8 5d ff ff ff       	call   800963 <fstat>
  800a06:	89 c6                	mov    %eax,%esi
	close(fd);
  800a08:	89 1c 24             	mov    %ebx,(%esp)
  800a0b:	e8 fd fb ff ff       	call   80060d <close>
	return r;
  800a10:	83 c4 10             	add    $0x10,%esp
  800a13:	89 f3                	mov    %esi,%ebx
}
  800a15:	89 d8                	mov    %ebx,%eax
  800a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a1a:	5b                   	pop    %ebx
  800a1b:	5e                   	pop    %esi
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	56                   	push   %esi
  800a22:	53                   	push   %ebx
  800a23:	89 c6                	mov    %eax,%esi
  800a25:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a27:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a2e:	74 27                	je     800a57 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a30:	6a 07                	push   $0x7
  800a32:	68 00 50 80 00       	push   $0x805000
  800a37:	56                   	push   %esi
  800a38:	ff 35 00 40 80 00    	pushl  0x804000
  800a3e:	e8 f1 16 00 00       	call   802134 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a43:	83 c4 0c             	add    $0xc,%esp
  800a46:	6a 00                	push   $0x0
  800a48:	53                   	push   %ebx
  800a49:	6a 00                	push   $0x0
  800a4b:	e8 5f 16 00 00       	call   8020af <ipc_recv>
}
  800a50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a53:	5b                   	pop    %ebx
  800a54:	5e                   	pop    %esi
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a57:	83 ec 0c             	sub    $0xc,%esp
  800a5a:	6a 01                	push   $0x1
  800a5c:	e8 2b 17 00 00       	call   80218c <ipc_find_env>
  800a61:	a3 00 40 80 00       	mov    %eax,0x804000
  800a66:	83 c4 10             	add    $0x10,%esp
  800a69:	eb c5                	jmp    800a30 <fsipc+0x12>

00800a6b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a6b:	f3 0f 1e fb          	endbr32 
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	8b 40 0c             	mov    0xc(%eax),%eax
  800a7b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a83:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a88:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8d:	b8 02 00 00 00       	mov    $0x2,%eax
  800a92:	e8 87 ff ff ff       	call   800a1e <fsipc>
}
  800a97:	c9                   	leave  
  800a98:	c3                   	ret    

00800a99 <devfile_flush>:
{
  800a99:	f3 0f 1e fb          	endbr32 
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 40 0c             	mov    0xc(%eax),%eax
  800aa9:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800aae:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab3:	b8 06 00 00 00       	mov    $0x6,%eax
  800ab8:	e8 61 ff ff ff       	call   800a1e <fsipc>
}
  800abd:	c9                   	leave  
  800abe:	c3                   	ret    

00800abf <devfile_stat>:
{
  800abf:	f3 0f 1e fb          	endbr32 
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	53                   	push   %ebx
  800ac7:	83 ec 04             	sub    $0x4,%esp
  800aca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8b 40 0c             	mov    0xc(%eax),%eax
  800ad3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800ad8:	ba 00 00 00 00       	mov    $0x0,%edx
  800add:	b8 05 00 00 00       	mov    $0x5,%eax
  800ae2:	e8 37 ff ff ff       	call   800a1e <fsipc>
  800ae7:	85 c0                	test   %eax,%eax
  800ae9:	78 2c                	js     800b17 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	68 00 50 80 00       	push   $0x805000
  800af3:	53                   	push   %ebx
  800af4:	e8 44 12 00 00       	call   801d3d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800af9:	a1 80 50 80 00       	mov    0x805080,%eax
  800afe:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b04:	a1 84 50 80 00       	mov    0x805084,%eax
  800b09:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b0f:	83 c4 10             	add    $0x10,%esp
  800b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <devfile_write>:
{
  800b1c:	f3 0f 1e fb          	endbr32 
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	83 ec 0c             	sub    $0xc,%esp
  800b26:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800b29:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2c:	8b 52 0c             	mov    0xc(%edx),%edx
  800b2f:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800b35:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800b3a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800b3f:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800b42:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800b47:	50                   	push   %eax
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	68 08 50 80 00       	push   $0x805008
  800b50:	e8 9e 13 00 00       	call   801ef3 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800b55:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5a:	b8 04 00 00 00       	mov    $0x4,%eax
  800b5f:	e8 ba fe ff ff       	call   800a1e <fsipc>
}
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <devfile_read>:
{
  800b66:	f3 0f 1e fb          	endbr32 
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	56                   	push   %esi
  800b6e:	53                   	push   %ebx
  800b6f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8b 40 0c             	mov    0xc(%eax),%eax
  800b78:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b7d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b83:	ba 00 00 00 00       	mov    $0x0,%edx
  800b88:	b8 03 00 00 00       	mov    $0x3,%eax
  800b8d:	e8 8c fe ff ff       	call   800a1e <fsipc>
  800b92:	89 c3                	mov    %eax,%ebx
  800b94:	85 c0                	test   %eax,%eax
  800b96:	78 1f                	js     800bb7 <devfile_read+0x51>
	assert(r <= n);
  800b98:	39 f0                	cmp    %esi,%eax
  800b9a:	77 24                	ja     800bc0 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b9c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ba1:	7f 33                	jg     800bd6 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ba3:	83 ec 04             	sub    $0x4,%esp
  800ba6:	50                   	push   %eax
  800ba7:	68 00 50 80 00       	push   $0x805000
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	e8 3f 13 00 00       	call   801ef3 <memmove>
	return r;
  800bb4:	83 c4 10             	add    $0x10,%esp
}
  800bb7:	89 d8                	mov    %ebx,%eax
  800bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    
	assert(r <= n);
  800bc0:	68 54 25 80 00       	push   $0x802554
  800bc5:	68 5b 25 80 00       	push   $0x80255b
  800bca:	6a 7c                	push   $0x7c
  800bcc:	68 70 25 80 00       	push   $0x802570
  800bd1:	e8 76 0a 00 00       	call   80164c <_panic>
	assert(r <= PGSIZE);
  800bd6:	68 7b 25 80 00       	push   $0x80257b
  800bdb:	68 5b 25 80 00       	push   $0x80255b
  800be0:	6a 7d                	push   $0x7d
  800be2:	68 70 25 80 00       	push   $0x802570
  800be7:	e8 60 0a 00 00       	call   80164c <_panic>

00800bec <open>:
{
  800bec:	f3 0f 1e fb          	endbr32 
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
  800bf5:	83 ec 1c             	sub    $0x1c,%esp
  800bf8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800bfb:	56                   	push   %esi
  800bfc:	e8 f9 10 00 00       	call   801cfa <strlen>
  800c01:	83 c4 10             	add    $0x10,%esp
  800c04:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c09:	7f 6c                	jg     800c77 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800c0b:	83 ec 0c             	sub    $0xc,%esp
  800c0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c11:	50                   	push   %eax
  800c12:	e8 62 f8 ff ff       	call   800479 <fd_alloc>
  800c17:	89 c3                	mov    %eax,%ebx
  800c19:	83 c4 10             	add    $0x10,%esp
  800c1c:	85 c0                	test   %eax,%eax
  800c1e:	78 3c                	js     800c5c <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	56                   	push   %esi
  800c24:	68 00 50 80 00       	push   $0x805000
  800c29:	e8 0f 11 00 00       	call   801d3d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c39:	b8 01 00 00 00       	mov    $0x1,%eax
  800c3e:	e8 db fd ff ff       	call   800a1e <fsipc>
  800c43:	89 c3                	mov    %eax,%ebx
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	85 c0                	test   %eax,%eax
  800c4a:	78 19                	js     800c65 <open+0x79>
	return fd2num(fd);
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c52:	e8 f3 f7 ff ff       	call   80044a <fd2num>
  800c57:	89 c3                	mov    %eax,%ebx
  800c59:	83 c4 10             	add    $0x10,%esp
}
  800c5c:	89 d8                	mov    %ebx,%eax
  800c5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    
		fd_close(fd, 0);
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	6a 00                	push   $0x0
  800c6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6d:	e8 10 f9 ff ff       	call   800582 <fd_close>
		return r;
  800c72:	83 c4 10             	add    $0x10,%esp
  800c75:	eb e5                	jmp    800c5c <open+0x70>
		return -E_BAD_PATH;
  800c77:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c7c:	eb de                	jmp    800c5c <open+0x70>

00800c7e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c7e:	f3 0f 1e fb          	endbr32 
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c88:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c92:	e8 87 fd ff ff       	call   800a1e <fsipc>
}
  800c97:	c9                   	leave  
  800c98:	c3                   	ret    

00800c99 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800ca3:	68 87 25 80 00       	push   $0x802587
  800ca8:	ff 75 0c             	pushl  0xc(%ebp)
  800cab:	e8 8d 10 00 00       	call   801d3d <strcpy>
	return 0;
}
  800cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb5:	c9                   	leave  
  800cb6:	c3                   	ret    

00800cb7 <devsock_close>:
{
  800cb7:	f3 0f 1e fb          	endbr32 
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	53                   	push   %ebx
  800cbf:	83 ec 10             	sub    $0x10,%esp
  800cc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800cc5:	53                   	push   %ebx
  800cc6:	e8 fe 14 00 00       	call   8021c9 <pageref>
  800ccb:	89 c2                	mov    %eax,%edx
  800ccd:	83 c4 10             	add    $0x10,%esp
		return 0;
  800cd0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800cd5:	83 fa 01             	cmp    $0x1,%edx
  800cd8:	74 05                	je     800cdf <devsock_close+0x28>
}
  800cda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800cdf:	83 ec 0c             	sub    $0xc,%esp
  800ce2:	ff 73 0c             	pushl  0xc(%ebx)
  800ce5:	e8 e3 02 00 00       	call   800fcd <nsipc_close>
  800cea:	83 c4 10             	add    $0x10,%esp
  800ced:	eb eb                	jmp    800cda <devsock_close+0x23>

00800cef <devsock_write>:
{
  800cef:	f3 0f 1e fb          	endbr32 
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800cf9:	6a 00                	push   $0x0
  800cfb:	ff 75 10             	pushl  0x10(%ebp)
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	ff 70 0c             	pushl  0xc(%eax)
  800d07:	e8 b5 03 00 00       	call   8010c1 <nsipc_send>
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <devsock_read>:
{
  800d0e:	f3 0f 1e fb          	endbr32 
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800d18:	6a 00                	push   $0x0
  800d1a:	ff 75 10             	pushl  0x10(%ebp)
  800d1d:	ff 75 0c             	pushl  0xc(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff 70 0c             	pushl  0xc(%eax)
  800d26:	e8 1f 03 00 00       	call   80104a <nsipc_recv>
}
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <fd2sockid>:
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800d33:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d36:	52                   	push   %edx
  800d37:	50                   	push   %eax
  800d38:	e8 92 f7 ff ff       	call   8004cf <fd_lookup>
  800d3d:	83 c4 10             	add    $0x10,%esp
  800d40:	85 c0                	test   %eax,%eax
  800d42:	78 10                	js     800d54 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d47:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  800d4d:	39 08                	cmp    %ecx,(%eax)
  800d4f:	75 05                	jne    800d56 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800d51:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800d54:	c9                   	leave  
  800d55:	c3                   	ret    
		return -E_NOT_SUPP;
  800d56:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d5b:	eb f7                	jmp    800d54 <fd2sockid+0x27>

00800d5d <alloc_sockfd>:
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
  800d62:	83 ec 1c             	sub    $0x1c,%esp
  800d65:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d6a:	50                   	push   %eax
  800d6b:	e8 09 f7 ff ff       	call   800479 <fd_alloc>
  800d70:	89 c3                	mov    %eax,%ebx
  800d72:	83 c4 10             	add    $0x10,%esp
  800d75:	85 c0                	test   %eax,%eax
  800d77:	78 43                	js     800dbc <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d79:	83 ec 04             	sub    $0x4,%esp
  800d7c:	68 07 04 00 00       	push   $0x407
  800d81:	ff 75 f4             	pushl  -0xc(%ebp)
  800d84:	6a 00                	push   $0x0
  800d86:	e8 ff f3 ff ff       	call   80018a <sys_page_alloc>
  800d8b:	89 c3                	mov    %eax,%ebx
  800d8d:	83 c4 10             	add    $0x10,%esp
  800d90:	85 c0                	test   %eax,%eax
  800d92:	78 28                	js     800dbc <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d97:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800d9d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800da9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	50                   	push   %eax
  800db0:	e8 95 f6 ff ff       	call   80044a <fd2num>
  800db5:	89 c3                	mov    %eax,%ebx
  800db7:	83 c4 10             	add    $0x10,%esp
  800dba:	eb 0c                	jmp    800dc8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800dbc:	83 ec 0c             	sub    $0xc,%esp
  800dbf:	56                   	push   %esi
  800dc0:	e8 08 02 00 00       	call   800fcd <nsipc_close>
		return r;
  800dc5:	83 c4 10             	add    $0x10,%esp
}
  800dc8:	89 d8                	mov    %ebx,%eax
  800dca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dcd:	5b                   	pop    %ebx
  800dce:	5e                   	pop    %esi
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <accept>:
{
  800dd1:	f3 0f 1e fb          	endbr32 
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	e8 4a ff ff ff       	call   800d2d <fd2sockid>
  800de3:	85 c0                	test   %eax,%eax
  800de5:	78 1b                	js     800e02 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800de7:	83 ec 04             	sub    $0x4,%esp
  800dea:	ff 75 10             	pushl  0x10(%ebp)
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	50                   	push   %eax
  800df1:	e8 22 01 00 00       	call   800f18 <nsipc_accept>
  800df6:	83 c4 10             	add    $0x10,%esp
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	78 05                	js     800e02 <accept+0x31>
	return alloc_sockfd(r);
  800dfd:	e8 5b ff ff ff       	call   800d5d <alloc_sockfd>
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <bind>:
{
  800e04:	f3 0f 1e fb          	endbr32 
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	e8 17 ff ff ff       	call   800d2d <fd2sockid>
  800e16:	85 c0                	test   %eax,%eax
  800e18:	78 12                	js     800e2c <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800e1a:	83 ec 04             	sub    $0x4,%esp
  800e1d:	ff 75 10             	pushl  0x10(%ebp)
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	50                   	push   %eax
  800e24:	e8 45 01 00 00       	call   800f6e <nsipc_bind>
  800e29:	83 c4 10             	add    $0x10,%esp
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <shutdown>:
{
  800e2e:	f3 0f 1e fb          	endbr32 
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	e8 ed fe ff ff       	call   800d2d <fd2sockid>
  800e40:	85 c0                	test   %eax,%eax
  800e42:	78 0f                	js     800e53 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800e44:	83 ec 08             	sub    $0x8,%esp
  800e47:	ff 75 0c             	pushl  0xc(%ebp)
  800e4a:	50                   	push   %eax
  800e4b:	e8 57 01 00 00       	call   800fa7 <nsipc_shutdown>
  800e50:	83 c4 10             	add    $0x10,%esp
}
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <connect>:
{
  800e55:	f3 0f 1e fb          	endbr32 
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	e8 c6 fe ff ff       	call   800d2d <fd2sockid>
  800e67:	85 c0                	test   %eax,%eax
  800e69:	78 12                	js     800e7d <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e6b:	83 ec 04             	sub    $0x4,%esp
  800e6e:	ff 75 10             	pushl  0x10(%ebp)
  800e71:	ff 75 0c             	pushl  0xc(%ebp)
  800e74:	50                   	push   %eax
  800e75:	e8 71 01 00 00       	call   800feb <nsipc_connect>
  800e7a:	83 c4 10             	add    $0x10,%esp
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <listen>:
{
  800e7f:	f3 0f 1e fb          	endbr32 
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	e8 9c fe ff ff       	call   800d2d <fd2sockid>
  800e91:	85 c0                	test   %eax,%eax
  800e93:	78 0f                	js     800ea4 <listen+0x25>
	return nsipc_listen(r, backlog);
  800e95:	83 ec 08             	sub    $0x8,%esp
  800e98:	ff 75 0c             	pushl  0xc(%ebp)
  800e9b:	50                   	push   %eax
  800e9c:	e8 83 01 00 00       	call   801024 <nsipc_listen>
  800ea1:	83 c4 10             	add    $0x10,%esp
}
  800ea4:	c9                   	leave  
  800ea5:	c3                   	ret    

00800ea6 <socket>:

int
socket(int domain, int type, int protocol)
{
  800ea6:	f3 0f 1e fb          	endbr32 
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800eb0:	ff 75 10             	pushl  0x10(%ebp)
  800eb3:	ff 75 0c             	pushl  0xc(%ebp)
  800eb6:	ff 75 08             	pushl  0x8(%ebp)
  800eb9:	e8 65 02 00 00       	call   801123 <nsipc_socket>
  800ebe:	83 c4 10             	add    $0x10,%esp
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	78 05                	js     800eca <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800ec5:	e8 93 fe ff ff       	call   800d5d <alloc_sockfd>
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	53                   	push   %ebx
  800ed0:	83 ec 04             	sub    $0x4,%esp
  800ed3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800ed5:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800edc:	74 26                	je     800f04 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800ede:	6a 07                	push   $0x7
  800ee0:	68 00 60 80 00       	push   $0x806000
  800ee5:	53                   	push   %ebx
  800ee6:	ff 35 04 40 80 00    	pushl  0x804004
  800eec:	e8 43 12 00 00       	call   802134 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800ef1:	83 c4 0c             	add    $0xc,%esp
  800ef4:	6a 00                	push   $0x0
  800ef6:	6a 00                	push   $0x0
  800ef8:	6a 00                	push   $0x0
  800efa:	e8 b0 11 00 00       	call   8020af <ipc_recv>
}
  800eff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f02:	c9                   	leave  
  800f03:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	6a 02                	push   $0x2
  800f09:	e8 7e 12 00 00       	call   80218c <ipc_find_env>
  800f0e:	a3 04 40 80 00       	mov    %eax,0x804004
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	eb c6                	jmp    800ede <nsipc+0x12>

00800f18 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f18:	f3 0f 1e fb          	endbr32 
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
  800f21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800f2c:	8b 06                	mov    (%esi),%eax
  800f2e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800f33:	b8 01 00 00 00       	mov    $0x1,%eax
  800f38:	e8 8f ff ff ff       	call   800ecc <nsipc>
  800f3d:	89 c3                	mov    %eax,%ebx
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	79 09                	jns    800f4c <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800f43:	89 d8                	mov    %ebx,%eax
  800f45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f48:	5b                   	pop    %ebx
  800f49:	5e                   	pop    %esi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	ff 35 10 60 80 00    	pushl  0x806010
  800f55:	68 00 60 80 00       	push   $0x806000
  800f5a:	ff 75 0c             	pushl  0xc(%ebp)
  800f5d:	e8 91 0f 00 00       	call   801ef3 <memmove>
		*addrlen = ret->ret_addrlen;
  800f62:	a1 10 60 80 00       	mov    0x806010,%eax
  800f67:	89 06                	mov    %eax,(%esi)
  800f69:	83 c4 10             	add    $0x10,%esp
	return r;
  800f6c:	eb d5                	jmp    800f43 <nsipc_accept+0x2b>

00800f6e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f6e:	f3 0f 1e fb          	endbr32 
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	53                   	push   %ebx
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f84:	53                   	push   %ebx
  800f85:	ff 75 0c             	pushl  0xc(%ebp)
  800f88:	68 04 60 80 00       	push   $0x806004
  800f8d:	e8 61 0f 00 00       	call   801ef3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f92:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f98:	b8 02 00 00 00       	mov    $0x2,%eax
  800f9d:	e8 2a ff ff ff       	call   800ecc <nsipc>
}
  800fa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fa5:	c9                   	leave  
  800fa6:	c3                   	ret    

00800fa7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800fa7:	f3 0f 1e fb          	endbr32 
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800fc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc6:	e8 01 ff ff ff       	call   800ecc <nsipc>
}
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <nsipc_close>:

int
nsipc_close(int s)
{
  800fcd:	f3 0f 1e fb          	endbr32 
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800fdf:	b8 04 00 00 00       	mov    $0x4,%eax
  800fe4:	e8 e3 fe ff ff       	call   800ecc <nsipc>
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800feb:	f3 0f 1e fb          	endbr32 
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	53                   	push   %ebx
  800ff3:	83 ec 08             	sub    $0x8,%esp
  800ff6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801001:	53                   	push   %ebx
  801002:	ff 75 0c             	pushl  0xc(%ebp)
  801005:	68 04 60 80 00       	push   $0x806004
  80100a:	e8 e4 0e 00 00       	call   801ef3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80100f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801015:	b8 05 00 00 00       	mov    $0x5,%eax
  80101a:	e8 ad fe ff ff       	call   800ecc <nsipc>
}
  80101f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801022:	c9                   	leave  
  801023:	c3                   	ret    

00801024 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801024:	f3 0f 1e fb          	endbr32 
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80103e:	b8 06 00 00 00       	mov    $0x6,%eax
  801043:	e8 84 fe ff ff       	call   800ecc <nsipc>
}
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80104a:	f3 0f 1e fb          	endbr32 
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80105e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801064:	8b 45 14             	mov    0x14(%ebp),%eax
  801067:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80106c:	b8 07 00 00 00       	mov    $0x7,%eax
  801071:	e8 56 fe ff ff       	call   800ecc <nsipc>
  801076:	89 c3                	mov    %eax,%ebx
  801078:	85 c0                	test   %eax,%eax
  80107a:	78 26                	js     8010a2 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80107c:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801082:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801087:	0f 4e c6             	cmovle %esi,%eax
  80108a:	39 c3                	cmp    %eax,%ebx
  80108c:	7f 1d                	jg     8010ab <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80108e:	83 ec 04             	sub    $0x4,%esp
  801091:	53                   	push   %ebx
  801092:	68 00 60 80 00       	push   $0x806000
  801097:	ff 75 0c             	pushl  0xc(%ebp)
  80109a:	e8 54 0e 00 00       	call   801ef3 <memmove>
  80109f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8010a2:	89 d8                	mov    %ebx,%eax
  8010a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010a7:	5b                   	pop    %ebx
  8010a8:	5e                   	pop    %esi
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8010ab:	68 93 25 80 00       	push   $0x802593
  8010b0:	68 5b 25 80 00       	push   $0x80255b
  8010b5:	6a 62                	push   $0x62
  8010b7:	68 a8 25 80 00       	push   $0x8025a8
  8010bc:	e8 8b 05 00 00       	call   80164c <_panic>

008010c1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8010c1:	f3 0f 1e fb          	endbr32 
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8010d7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8010dd:	7f 2e                	jg     80110d <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8010df:	83 ec 04             	sub    $0x4,%esp
  8010e2:	53                   	push   %ebx
  8010e3:	ff 75 0c             	pushl  0xc(%ebp)
  8010e6:	68 0c 60 80 00       	push   $0x80600c
  8010eb:	e8 03 0e 00 00       	call   801ef3 <memmove>
	nsipcbuf.send.req_size = size;
  8010f0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8010f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8010fe:	b8 08 00 00 00       	mov    $0x8,%eax
  801103:	e8 c4 fd ff ff       	call   800ecc <nsipc>
}
  801108:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    
	assert(size < 1600);
  80110d:	68 b4 25 80 00       	push   $0x8025b4
  801112:	68 5b 25 80 00       	push   $0x80255b
  801117:	6a 6d                	push   $0x6d
  801119:	68 a8 25 80 00       	push   $0x8025a8
  80111e:	e8 29 05 00 00       	call   80164c <_panic>

00801123 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801123:	f3 0f 1e fb          	endbr32 
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801135:	8b 45 0c             	mov    0xc(%ebp),%eax
  801138:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801145:	b8 09 00 00 00       	mov    $0x9,%eax
  80114a:	e8 7d fd ff ff       	call   800ecc <nsipc>
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801151:	f3 0f 1e fb          	endbr32 
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	56                   	push   %esi
  801159:	53                   	push   %ebx
  80115a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	ff 75 08             	pushl  0x8(%ebp)
  801163:	e8 f6 f2 ff ff       	call   80045e <fd2data>
  801168:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80116a:	83 c4 08             	add    $0x8,%esp
  80116d:	68 c0 25 80 00       	push   $0x8025c0
  801172:	53                   	push   %ebx
  801173:	e8 c5 0b 00 00       	call   801d3d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801178:	8b 46 04             	mov    0x4(%esi),%eax
  80117b:	2b 06                	sub    (%esi),%eax
  80117d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801183:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80118a:	00 00 00 
	stat->st_dev = &devpipe;
  80118d:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801194:	30 80 00 
	return 0;
}
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
  80119c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8011a3:	f3 0f 1e fb          	endbr32 
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	53                   	push   %ebx
  8011ab:	83 ec 0c             	sub    $0xc,%esp
  8011ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8011b1:	53                   	push   %ebx
  8011b2:	6a 00                	push   $0x0
  8011b4:	e8 5e f0 ff ff       	call   800217 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011b9:	89 1c 24             	mov    %ebx,(%esp)
  8011bc:	e8 9d f2 ff ff       	call   80045e <fd2data>
  8011c1:	83 c4 08             	add    $0x8,%esp
  8011c4:	50                   	push   %eax
  8011c5:	6a 00                	push   $0x0
  8011c7:	e8 4b f0 ff ff       	call   800217 <sys_page_unmap>
}
  8011cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <_pipeisclosed>:
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	57                   	push   %edi
  8011d5:	56                   	push   %esi
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 1c             	sub    $0x1c,%esp
  8011da:	89 c7                	mov    %eax,%edi
  8011dc:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8011de:	a1 08 40 80 00       	mov    0x804008,%eax
  8011e3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8011e6:	83 ec 0c             	sub    $0xc,%esp
  8011e9:	57                   	push   %edi
  8011ea:	e8 da 0f 00 00       	call   8021c9 <pageref>
  8011ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011f2:	89 34 24             	mov    %esi,(%esp)
  8011f5:	e8 cf 0f 00 00       	call   8021c9 <pageref>
		nn = thisenv->env_runs;
  8011fa:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801200:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	39 cb                	cmp    %ecx,%ebx
  801208:	74 1b                	je     801225 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80120a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80120d:	75 cf                	jne    8011de <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80120f:	8b 42 58             	mov    0x58(%edx),%eax
  801212:	6a 01                	push   $0x1
  801214:	50                   	push   %eax
  801215:	53                   	push   %ebx
  801216:	68 c7 25 80 00       	push   $0x8025c7
  80121b:	e8 13 05 00 00       	call   801733 <cprintf>
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	eb b9                	jmp    8011de <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801225:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801228:	0f 94 c0             	sete   %al
  80122b:	0f b6 c0             	movzbl %al,%eax
}
  80122e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801231:	5b                   	pop    %ebx
  801232:	5e                   	pop    %esi
  801233:	5f                   	pop    %edi
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <devpipe_write>:
{
  801236:	f3 0f 1e fb          	endbr32 
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	57                   	push   %edi
  80123e:	56                   	push   %esi
  80123f:	53                   	push   %ebx
  801240:	83 ec 28             	sub    $0x28,%esp
  801243:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801246:	56                   	push   %esi
  801247:	e8 12 f2 ff ff       	call   80045e <fd2data>
  80124c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80124e:	83 c4 10             	add    $0x10,%esp
  801251:	bf 00 00 00 00       	mov    $0x0,%edi
  801256:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801259:	74 4f                	je     8012aa <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80125b:	8b 43 04             	mov    0x4(%ebx),%eax
  80125e:	8b 0b                	mov    (%ebx),%ecx
  801260:	8d 51 20             	lea    0x20(%ecx),%edx
  801263:	39 d0                	cmp    %edx,%eax
  801265:	72 14                	jb     80127b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801267:	89 da                	mov    %ebx,%edx
  801269:	89 f0                	mov    %esi,%eax
  80126b:	e8 61 ff ff ff       	call   8011d1 <_pipeisclosed>
  801270:	85 c0                	test   %eax,%eax
  801272:	75 3b                	jne    8012af <devpipe_write+0x79>
			sys_yield();
  801274:	e8 ee ee ff ff       	call   800167 <sys_yield>
  801279:	eb e0                	jmp    80125b <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80127b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801282:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801285:	89 c2                	mov    %eax,%edx
  801287:	c1 fa 1f             	sar    $0x1f,%edx
  80128a:	89 d1                	mov    %edx,%ecx
  80128c:	c1 e9 1b             	shr    $0x1b,%ecx
  80128f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801292:	83 e2 1f             	and    $0x1f,%edx
  801295:	29 ca                	sub    %ecx,%edx
  801297:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80129b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80129f:	83 c0 01             	add    $0x1,%eax
  8012a2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8012a5:	83 c7 01             	add    $0x1,%edi
  8012a8:	eb ac                	jmp    801256 <devpipe_write+0x20>
	return i;
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	eb 05                	jmp    8012b4 <devpipe_write+0x7e>
				return 0;
  8012af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5f                   	pop    %edi
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <devpipe_read>:
{
  8012bc:	f3 0f 1e fb          	endbr32 
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	57                   	push   %edi
  8012c4:	56                   	push   %esi
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 18             	sub    $0x18,%esp
  8012c9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8012cc:	57                   	push   %edi
  8012cd:	e8 8c f1 ff ff       	call   80045e <fd2data>
  8012d2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	be 00 00 00 00       	mov    $0x0,%esi
  8012dc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012df:	75 14                	jne    8012f5 <devpipe_read+0x39>
	return i;
  8012e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e4:	eb 02                	jmp    8012e8 <devpipe_read+0x2c>
				return i;
  8012e6:	89 f0                	mov    %esi,%eax
}
  8012e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5f                   	pop    %edi
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    
			sys_yield();
  8012f0:	e8 72 ee ff ff       	call   800167 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8012f5:	8b 03                	mov    (%ebx),%eax
  8012f7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8012fa:	75 18                	jne    801314 <devpipe_read+0x58>
			if (i > 0)
  8012fc:	85 f6                	test   %esi,%esi
  8012fe:	75 e6                	jne    8012e6 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801300:	89 da                	mov    %ebx,%edx
  801302:	89 f8                	mov    %edi,%eax
  801304:	e8 c8 fe ff ff       	call   8011d1 <_pipeisclosed>
  801309:	85 c0                	test   %eax,%eax
  80130b:	74 e3                	je     8012f0 <devpipe_read+0x34>
				return 0;
  80130d:	b8 00 00 00 00       	mov    $0x0,%eax
  801312:	eb d4                	jmp    8012e8 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801314:	99                   	cltd   
  801315:	c1 ea 1b             	shr    $0x1b,%edx
  801318:	01 d0                	add    %edx,%eax
  80131a:	83 e0 1f             	and    $0x1f,%eax
  80131d:	29 d0                	sub    %edx,%eax
  80131f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801324:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801327:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80132a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80132d:	83 c6 01             	add    $0x1,%esi
  801330:	eb aa                	jmp    8012dc <devpipe_read+0x20>

00801332 <pipe>:
{
  801332:	f3 0f 1e fb          	endbr32 
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80133e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801341:	50                   	push   %eax
  801342:	e8 32 f1 ff ff       	call   800479 <fd_alloc>
  801347:	89 c3                	mov    %eax,%ebx
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	0f 88 23 01 00 00    	js     801477 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801354:	83 ec 04             	sub    $0x4,%esp
  801357:	68 07 04 00 00       	push   $0x407
  80135c:	ff 75 f4             	pushl  -0xc(%ebp)
  80135f:	6a 00                	push   $0x0
  801361:	e8 24 ee ff ff       	call   80018a <sys_page_alloc>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	0f 88 04 01 00 00    	js     801477 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801373:	83 ec 0c             	sub    $0xc,%esp
  801376:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801379:	50                   	push   %eax
  80137a:	e8 fa f0 ff ff       	call   800479 <fd_alloc>
  80137f:	89 c3                	mov    %eax,%ebx
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	0f 88 db 00 00 00    	js     801467 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	68 07 04 00 00       	push   $0x407
  801394:	ff 75 f0             	pushl  -0x10(%ebp)
  801397:	6a 00                	push   $0x0
  801399:	e8 ec ed ff ff       	call   80018a <sys_page_alloc>
  80139e:	89 c3                	mov    %eax,%ebx
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	0f 88 bc 00 00 00    	js     801467 <pipe+0x135>
	va = fd2data(fd0);
  8013ab:	83 ec 0c             	sub    $0xc,%esp
  8013ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8013b1:	e8 a8 f0 ff ff       	call   80045e <fd2data>
  8013b6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013b8:	83 c4 0c             	add    $0xc,%esp
  8013bb:	68 07 04 00 00       	push   $0x407
  8013c0:	50                   	push   %eax
  8013c1:	6a 00                	push   $0x0
  8013c3:	e8 c2 ed ff ff       	call   80018a <sys_page_alloc>
  8013c8:	89 c3                	mov    %eax,%ebx
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	0f 88 82 00 00 00    	js     801457 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013d5:	83 ec 0c             	sub    $0xc,%esp
  8013d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8013db:	e8 7e f0 ff ff       	call   80045e <fd2data>
  8013e0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8013e7:	50                   	push   %eax
  8013e8:	6a 00                	push   $0x0
  8013ea:	56                   	push   %esi
  8013eb:	6a 00                	push   $0x0
  8013ed:	e8 df ed ff ff       	call   8001d1 <sys_page_map>
  8013f2:	89 c3                	mov    %eax,%ebx
  8013f4:	83 c4 20             	add    $0x20,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	78 4e                	js     801449 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8013fb:	a1 40 30 80 00       	mov    0x803040,%eax
  801400:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801403:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801405:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801408:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80140f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801412:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801417:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	ff 75 f4             	pushl  -0xc(%ebp)
  801424:	e8 21 f0 ff ff       	call   80044a <fd2num>
  801429:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80142e:	83 c4 04             	add    $0x4,%esp
  801431:	ff 75 f0             	pushl  -0x10(%ebp)
  801434:	e8 11 f0 ff ff       	call   80044a <fd2num>
  801439:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80143c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80143f:	83 c4 10             	add    $0x10,%esp
  801442:	bb 00 00 00 00       	mov    $0x0,%ebx
  801447:	eb 2e                	jmp    801477 <pipe+0x145>
	sys_page_unmap(0, va);
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	56                   	push   %esi
  80144d:	6a 00                	push   $0x0
  80144f:	e8 c3 ed ff ff       	call   800217 <sys_page_unmap>
  801454:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801457:	83 ec 08             	sub    $0x8,%esp
  80145a:	ff 75 f0             	pushl  -0x10(%ebp)
  80145d:	6a 00                	push   $0x0
  80145f:	e8 b3 ed ff ff       	call   800217 <sys_page_unmap>
  801464:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801467:	83 ec 08             	sub    $0x8,%esp
  80146a:	ff 75 f4             	pushl  -0xc(%ebp)
  80146d:	6a 00                	push   $0x0
  80146f:	e8 a3 ed ff ff       	call   800217 <sys_page_unmap>
  801474:	83 c4 10             	add    $0x10,%esp
}
  801477:	89 d8                	mov    %ebx,%eax
  801479:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80147c:	5b                   	pop    %ebx
  80147d:	5e                   	pop    %esi
  80147e:	5d                   	pop    %ebp
  80147f:	c3                   	ret    

00801480 <pipeisclosed>:
{
  801480:	f3 0f 1e fb          	endbr32 
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80148a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148d:	50                   	push   %eax
  80148e:	ff 75 08             	pushl  0x8(%ebp)
  801491:	e8 39 f0 ff ff       	call   8004cf <fd_lookup>
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 18                	js     8014b5 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80149d:	83 ec 0c             	sub    $0xc,%esp
  8014a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a3:	e8 b6 ef ff ff       	call   80045e <fd2data>
  8014a8:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8014aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ad:	e8 1f fd ff ff       	call   8011d1 <_pipeisclosed>
  8014b2:	83 c4 10             	add    $0x10,%esp
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8014b7:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8014bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c0:	c3                   	ret    

008014c1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8014c1:	f3 0f 1e fb          	endbr32 
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8014cb:	68 df 25 80 00       	push   $0x8025df
  8014d0:	ff 75 0c             	pushl  0xc(%ebp)
  8014d3:	e8 65 08 00 00       	call   801d3d <strcpy>
	return 0;
}
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <devcons_write>:
{
  8014df:	f3 0f 1e fb          	endbr32 
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	57                   	push   %edi
  8014e7:	56                   	push   %esi
  8014e8:	53                   	push   %ebx
  8014e9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8014ef:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8014f4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8014fa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014fd:	73 31                	jae    801530 <devcons_write+0x51>
		m = n - tot;
  8014ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801502:	29 f3                	sub    %esi,%ebx
  801504:	83 fb 7f             	cmp    $0x7f,%ebx
  801507:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80150c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	53                   	push   %ebx
  801513:	89 f0                	mov    %esi,%eax
  801515:	03 45 0c             	add    0xc(%ebp),%eax
  801518:	50                   	push   %eax
  801519:	57                   	push   %edi
  80151a:	e8 d4 09 00 00       	call   801ef3 <memmove>
		sys_cputs(buf, m);
  80151f:	83 c4 08             	add    $0x8,%esp
  801522:	53                   	push   %ebx
  801523:	57                   	push   %edi
  801524:	e8 91 eb ff ff       	call   8000ba <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801529:	01 de                	add    %ebx,%esi
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	eb ca                	jmp    8014fa <devcons_write+0x1b>
}
  801530:	89 f0                	mov    %esi,%eax
  801532:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801535:	5b                   	pop    %ebx
  801536:	5e                   	pop    %esi
  801537:	5f                   	pop    %edi
  801538:	5d                   	pop    %ebp
  801539:	c3                   	ret    

0080153a <devcons_read>:
{
  80153a:	f3 0f 1e fb          	endbr32 
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 08             	sub    $0x8,%esp
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801549:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154d:	74 21                	je     801570 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80154f:	e8 88 eb ff ff       	call   8000dc <sys_cgetc>
  801554:	85 c0                	test   %eax,%eax
  801556:	75 07                	jne    80155f <devcons_read+0x25>
		sys_yield();
  801558:	e8 0a ec ff ff       	call   800167 <sys_yield>
  80155d:	eb f0                	jmp    80154f <devcons_read+0x15>
	if (c < 0)
  80155f:	78 0f                	js     801570 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801561:	83 f8 04             	cmp    $0x4,%eax
  801564:	74 0c                	je     801572 <devcons_read+0x38>
	*(char*)vbuf = c;
  801566:	8b 55 0c             	mov    0xc(%ebp),%edx
  801569:	88 02                	mov    %al,(%edx)
	return 1;
  80156b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    
		return 0;
  801572:	b8 00 00 00 00       	mov    $0x0,%eax
  801577:	eb f7                	jmp    801570 <devcons_read+0x36>

00801579 <cputchar>:
{
  801579:	f3 0f 1e fb          	endbr32 
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801589:	6a 01                	push   $0x1
  80158b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80158e:	50                   	push   %eax
  80158f:	e8 26 eb ff ff       	call   8000ba <sys_cputs>
}
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <getchar>:
{
  801599:	f3 0f 1e fb          	endbr32 
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8015a3:	6a 01                	push   $0x1
  8015a5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8015a8:	50                   	push   %eax
  8015a9:	6a 00                	push   $0x0
  8015ab:	e8 a7 f1 ff ff       	call   800757 <read>
	if (r < 0)
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 06                	js     8015bd <getchar+0x24>
	if (r < 1)
  8015b7:	74 06                	je     8015bf <getchar+0x26>
	return c;
  8015b9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    
		return -E_EOF;
  8015bf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8015c4:	eb f7                	jmp    8015bd <getchar+0x24>

008015c6 <iscons>:
{
  8015c6:	f3 0f 1e fb          	endbr32 
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d3:	50                   	push   %eax
  8015d4:	ff 75 08             	pushl  0x8(%ebp)
  8015d7:	e8 f3 ee ff ff       	call   8004cf <fd_lookup>
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 11                	js     8015f4 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e6:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8015ec:	39 10                	cmp    %edx,(%eax)
  8015ee:	0f 94 c0             	sete   %al
  8015f1:	0f b6 c0             	movzbl %al,%eax
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <opencons>:
{
  8015f6:	f3 0f 1e fb          	endbr32 
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801600:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801603:	50                   	push   %eax
  801604:	e8 70 ee ff ff       	call   800479 <fd_alloc>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 3a                	js     80164a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	68 07 04 00 00       	push   $0x407
  801618:	ff 75 f4             	pushl  -0xc(%ebp)
  80161b:	6a 00                	push   $0x0
  80161d:	e8 68 eb ff ff       	call   80018a <sys_page_alloc>
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	85 c0                	test   %eax,%eax
  801627:	78 21                	js     80164a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  801632:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801637:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80163e:	83 ec 0c             	sub    $0xc,%esp
  801641:	50                   	push   %eax
  801642:	e8 03 ee ff ff       	call   80044a <fd2num>
  801647:	83 c4 10             	add    $0x10,%esp
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80164c:	f3 0f 1e fb          	endbr32 
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801655:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801658:	8b 35 04 30 80 00    	mov    0x803004,%esi
  80165e:	e8 e1 ea ff ff       	call   800144 <sys_getenvid>
  801663:	83 ec 0c             	sub    $0xc,%esp
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	ff 75 08             	pushl  0x8(%ebp)
  80166c:	56                   	push   %esi
  80166d:	50                   	push   %eax
  80166e:	68 ec 25 80 00       	push   $0x8025ec
  801673:	e8 bb 00 00 00       	call   801733 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801678:	83 c4 18             	add    $0x18,%esp
  80167b:	53                   	push   %ebx
  80167c:	ff 75 10             	pushl  0x10(%ebp)
  80167f:	e8 5a 00 00 00       	call   8016de <vcprintf>
	cprintf("\n");
  801684:	c7 04 24 38 29 80 00 	movl   $0x802938,(%esp)
  80168b:	e8 a3 00 00 00       	call   801733 <cprintf>
  801690:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801693:	cc                   	int3   
  801694:	eb fd                	jmp    801693 <_panic+0x47>

00801696 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801696:	f3 0f 1e fb          	endbr32 
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	53                   	push   %ebx
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8016a4:	8b 13                	mov    (%ebx),%edx
  8016a6:	8d 42 01             	lea    0x1(%edx),%eax
  8016a9:	89 03                	mov    %eax,(%ebx)
  8016ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ae:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8016b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8016b7:	74 09                	je     8016c2 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8016b9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8016bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8016c2:	83 ec 08             	sub    $0x8,%esp
  8016c5:	68 ff 00 00 00       	push   $0xff
  8016ca:	8d 43 08             	lea    0x8(%ebx),%eax
  8016cd:	50                   	push   %eax
  8016ce:	e8 e7 e9 ff ff       	call   8000ba <sys_cputs>
		b->idx = 0;
  8016d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	eb db                	jmp    8016b9 <putch+0x23>

008016de <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8016de:	f3 0f 1e fb          	endbr32 
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016f2:	00 00 00 
	b.cnt = 0;
  8016f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8016fc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	ff 75 08             	pushl  0x8(%ebp)
  801705:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80170b:	50                   	push   %eax
  80170c:	68 96 16 80 00       	push   $0x801696
  801711:	e8 20 01 00 00       	call   801836 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801716:	83 c4 08             	add    $0x8,%esp
  801719:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80171f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801725:	50                   	push   %eax
  801726:	e8 8f e9 ff ff       	call   8000ba <sys_cputs>

	return b.cnt;
}
  80172b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801733:	f3 0f 1e fb          	endbr32 
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80173d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801740:	50                   	push   %eax
  801741:	ff 75 08             	pushl  0x8(%ebp)
  801744:	e8 95 ff ff ff       	call   8016de <vcprintf>
	va_end(ap);

	return cnt;
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	57                   	push   %edi
  80174f:	56                   	push   %esi
  801750:	53                   	push   %ebx
  801751:	83 ec 1c             	sub    $0x1c,%esp
  801754:	89 c7                	mov    %eax,%edi
  801756:	89 d6                	mov    %edx,%esi
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	89 d1                	mov    %edx,%ecx
  801760:	89 c2                	mov    %eax,%edx
  801762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801765:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801768:	8b 45 10             	mov    0x10(%ebp),%eax
  80176b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80176e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801771:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801778:	39 c2                	cmp    %eax,%edx
  80177a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80177d:	72 3e                	jb     8017bd <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80177f:	83 ec 0c             	sub    $0xc,%esp
  801782:	ff 75 18             	pushl  0x18(%ebp)
  801785:	83 eb 01             	sub    $0x1,%ebx
  801788:	53                   	push   %ebx
  801789:	50                   	push   %eax
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801790:	ff 75 e0             	pushl  -0x20(%ebp)
  801793:	ff 75 dc             	pushl  -0x24(%ebp)
  801796:	ff 75 d8             	pushl  -0x28(%ebp)
  801799:	e8 72 0a 00 00       	call   802210 <__udivdi3>
  80179e:	83 c4 18             	add    $0x18,%esp
  8017a1:	52                   	push   %edx
  8017a2:	50                   	push   %eax
  8017a3:	89 f2                	mov    %esi,%edx
  8017a5:	89 f8                	mov    %edi,%eax
  8017a7:	e8 9f ff ff ff       	call   80174b <printnum>
  8017ac:	83 c4 20             	add    $0x20,%esp
  8017af:	eb 13                	jmp    8017c4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	56                   	push   %esi
  8017b5:	ff 75 18             	pushl  0x18(%ebp)
  8017b8:	ff d7                	call   *%edi
  8017ba:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8017bd:	83 eb 01             	sub    $0x1,%ebx
  8017c0:	85 db                	test   %ebx,%ebx
  8017c2:	7f ed                	jg     8017b1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017c4:	83 ec 08             	sub    $0x8,%esp
  8017c7:	56                   	push   %esi
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8017d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8017d4:	ff 75 d8             	pushl  -0x28(%ebp)
  8017d7:	e8 44 0b 00 00       	call   802320 <__umoddi3>
  8017dc:	83 c4 14             	add    $0x14,%esp
  8017df:	0f be 80 0f 26 80 00 	movsbl 0x80260f(%eax),%eax
  8017e6:	50                   	push   %eax
  8017e7:	ff d7                	call   *%edi
}
  8017e9:	83 c4 10             	add    $0x10,%esp
  8017ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ef:	5b                   	pop    %ebx
  8017f0:	5e                   	pop    %esi
  8017f1:	5f                   	pop    %edi
  8017f2:	5d                   	pop    %ebp
  8017f3:	c3                   	ret    

008017f4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017f4:	f3 0f 1e fb          	endbr32 
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8017fe:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801802:	8b 10                	mov    (%eax),%edx
  801804:	3b 50 04             	cmp    0x4(%eax),%edx
  801807:	73 0a                	jae    801813 <sprintputch+0x1f>
		*b->buf++ = ch;
  801809:	8d 4a 01             	lea    0x1(%edx),%ecx
  80180c:	89 08                	mov    %ecx,(%eax)
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	88 02                	mov    %al,(%edx)
}
  801813:	5d                   	pop    %ebp
  801814:	c3                   	ret    

00801815 <printfmt>:
{
  801815:	f3 0f 1e fb          	endbr32 
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80181f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801822:	50                   	push   %eax
  801823:	ff 75 10             	pushl  0x10(%ebp)
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	e8 05 00 00 00       	call   801836 <vprintfmt>
}
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <vprintfmt>:
{
  801836:	f3 0f 1e fb          	endbr32 
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	57                   	push   %edi
  80183e:	56                   	push   %esi
  80183f:	53                   	push   %ebx
  801840:	83 ec 3c             	sub    $0x3c,%esp
  801843:	8b 75 08             	mov    0x8(%ebp),%esi
  801846:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801849:	8b 7d 10             	mov    0x10(%ebp),%edi
  80184c:	e9 8e 03 00 00       	jmp    801bdf <vprintfmt+0x3a9>
		padc = ' ';
  801851:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801855:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80185c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801863:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80186a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80186f:	8d 47 01             	lea    0x1(%edi),%eax
  801872:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801875:	0f b6 17             	movzbl (%edi),%edx
  801878:	8d 42 dd             	lea    -0x23(%edx),%eax
  80187b:	3c 55                	cmp    $0x55,%al
  80187d:	0f 87 df 03 00 00    	ja     801c62 <vprintfmt+0x42c>
  801883:	0f b6 c0             	movzbl %al,%eax
  801886:	3e ff 24 85 60 27 80 	notrack jmp *0x802760(,%eax,4)
  80188d:	00 
  80188e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801891:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801895:	eb d8                	jmp    80186f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801897:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80189a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80189e:	eb cf                	jmp    80186f <vprintfmt+0x39>
  8018a0:	0f b6 d2             	movzbl %dl,%edx
  8018a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8018a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8018ae:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8018b1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8018b5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8018b8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8018bb:	83 f9 09             	cmp    $0x9,%ecx
  8018be:	77 55                	ja     801915 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8018c0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8018c3:	eb e9                	jmp    8018ae <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8018c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c8:	8b 00                	mov    (%eax),%eax
  8018ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d0:	8d 40 04             	lea    0x4(%eax),%eax
  8018d3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8018d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018dd:	79 90                	jns    80186f <vprintfmt+0x39>
				width = precision, precision = -1;
  8018df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018e5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8018ec:	eb 81                	jmp    80186f <vprintfmt+0x39>
  8018ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	0f 49 d0             	cmovns %eax,%edx
  8018fb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801901:	e9 69 ff ff ff       	jmp    80186f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801906:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801909:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801910:	e9 5a ff ff ff       	jmp    80186f <vprintfmt+0x39>
  801915:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801918:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80191b:	eb bc                	jmp    8018d9 <vprintfmt+0xa3>
			lflag++;
  80191d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801920:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801923:	e9 47 ff ff ff       	jmp    80186f <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801928:	8b 45 14             	mov    0x14(%ebp),%eax
  80192b:	8d 78 04             	lea    0x4(%eax),%edi
  80192e:	83 ec 08             	sub    $0x8,%esp
  801931:	53                   	push   %ebx
  801932:	ff 30                	pushl  (%eax)
  801934:	ff d6                	call   *%esi
			break;
  801936:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801939:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80193c:	e9 9b 02 00 00       	jmp    801bdc <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801941:	8b 45 14             	mov    0x14(%ebp),%eax
  801944:	8d 78 04             	lea    0x4(%eax),%edi
  801947:	8b 00                	mov    (%eax),%eax
  801949:	99                   	cltd   
  80194a:	31 d0                	xor    %edx,%eax
  80194c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80194e:	83 f8 0f             	cmp    $0xf,%eax
  801951:	7f 23                	jg     801976 <vprintfmt+0x140>
  801953:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  80195a:	85 d2                	test   %edx,%edx
  80195c:	74 18                	je     801976 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80195e:	52                   	push   %edx
  80195f:	68 6d 25 80 00       	push   $0x80256d
  801964:	53                   	push   %ebx
  801965:	56                   	push   %esi
  801966:	e8 aa fe ff ff       	call   801815 <printfmt>
  80196b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80196e:	89 7d 14             	mov    %edi,0x14(%ebp)
  801971:	e9 66 02 00 00       	jmp    801bdc <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801976:	50                   	push   %eax
  801977:	68 27 26 80 00       	push   $0x802627
  80197c:	53                   	push   %ebx
  80197d:	56                   	push   %esi
  80197e:	e8 92 fe ff ff       	call   801815 <printfmt>
  801983:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801986:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801989:	e9 4e 02 00 00       	jmp    801bdc <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80198e:	8b 45 14             	mov    0x14(%ebp),%eax
  801991:	83 c0 04             	add    $0x4,%eax
  801994:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801997:	8b 45 14             	mov    0x14(%ebp),%eax
  80199a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80199c:	85 d2                	test   %edx,%edx
  80199e:	b8 20 26 80 00       	mov    $0x802620,%eax
  8019a3:	0f 45 c2             	cmovne %edx,%eax
  8019a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8019a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019ad:	7e 06                	jle    8019b5 <vprintfmt+0x17f>
  8019af:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8019b3:	75 0d                	jne    8019c2 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019b8:	89 c7                	mov    %eax,%edi
  8019ba:	03 45 e0             	add    -0x20(%ebp),%eax
  8019bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019c0:	eb 55                	jmp    801a17 <vprintfmt+0x1e1>
  8019c2:	83 ec 08             	sub    $0x8,%esp
  8019c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8019c8:	ff 75 cc             	pushl  -0x34(%ebp)
  8019cb:	e8 46 03 00 00       	call   801d16 <strnlen>
  8019d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019d3:	29 c2                	sub    %eax,%edx
  8019d5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8019d8:	83 c4 10             	add    $0x10,%esp
  8019db:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8019dd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8019e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8019e4:	85 ff                	test   %edi,%edi
  8019e6:	7e 11                	jle    8019f9 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8019e8:	83 ec 08             	sub    $0x8,%esp
  8019eb:	53                   	push   %ebx
  8019ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8019ef:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8019f1:	83 ef 01             	sub    $0x1,%edi
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	eb eb                	jmp    8019e4 <vprintfmt+0x1ae>
  8019f9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019fc:	85 d2                	test   %edx,%edx
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801a03:	0f 49 c2             	cmovns %edx,%eax
  801a06:	29 c2                	sub    %eax,%edx
  801a08:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801a0b:	eb a8                	jmp    8019b5 <vprintfmt+0x17f>
					putch(ch, putdat);
  801a0d:	83 ec 08             	sub    $0x8,%esp
  801a10:	53                   	push   %ebx
  801a11:	52                   	push   %edx
  801a12:	ff d6                	call   *%esi
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801a1a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a1c:	83 c7 01             	add    $0x1,%edi
  801a1f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a23:	0f be d0             	movsbl %al,%edx
  801a26:	85 d2                	test   %edx,%edx
  801a28:	74 4b                	je     801a75 <vprintfmt+0x23f>
  801a2a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a2e:	78 06                	js     801a36 <vprintfmt+0x200>
  801a30:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801a34:	78 1e                	js     801a54 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801a36:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a3a:	74 d1                	je     801a0d <vprintfmt+0x1d7>
  801a3c:	0f be c0             	movsbl %al,%eax
  801a3f:	83 e8 20             	sub    $0x20,%eax
  801a42:	83 f8 5e             	cmp    $0x5e,%eax
  801a45:	76 c6                	jbe    801a0d <vprintfmt+0x1d7>
					putch('?', putdat);
  801a47:	83 ec 08             	sub    $0x8,%esp
  801a4a:	53                   	push   %ebx
  801a4b:	6a 3f                	push   $0x3f
  801a4d:	ff d6                	call   *%esi
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	eb c3                	jmp    801a17 <vprintfmt+0x1e1>
  801a54:	89 cf                	mov    %ecx,%edi
  801a56:	eb 0e                	jmp    801a66 <vprintfmt+0x230>
				putch(' ', putdat);
  801a58:	83 ec 08             	sub    $0x8,%esp
  801a5b:	53                   	push   %ebx
  801a5c:	6a 20                	push   $0x20
  801a5e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801a60:	83 ef 01             	sub    $0x1,%edi
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	85 ff                	test   %edi,%edi
  801a68:	7f ee                	jg     801a58 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a6d:	89 45 14             	mov    %eax,0x14(%ebp)
  801a70:	e9 67 01 00 00       	jmp    801bdc <vprintfmt+0x3a6>
  801a75:	89 cf                	mov    %ecx,%edi
  801a77:	eb ed                	jmp    801a66 <vprintfmt+0x230>
	if (lflag >= 2)
  801a79:	83 f9 01             	cmp    $0x1,%ecx
  801a7c:	7f 1b                	jg     801a99 <vprintfmt+0x263>
	else if (lflag)
  801a7e:	85 c9                	test   %ecx,%ecx
  801a80:	74 63                	je     801ae5 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a82:	8b 45 14             	mov    0x14(%ebp),%eax
  801a85:	8b 00                	mov    (%eax),%eax
  801a87:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a8a:	99                   	cltd   
  801a8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a91:	8d 40 04             	lea    0x4(%eax),%eax
  801a94:	89 45 14             	mov    %eax,0x14(%ebp)
  801a97:	eb 17                	jmp    801ab0 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a99:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9c:	8b 50 04             	mov    0x4(%eax),%edx
  801a9f:	8b 00                	mov    (%eax),%eax
  801aa1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aa4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aaa:	8d 40 08             	lea    0x8(%eax),%eax
  801aad:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801ab0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ab3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801ab6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801abb:	85 c9                	test   %ecx,%ecx
  801abd:	0f 89 ff 00 00 00    	jns    801bc2 <vprintfmt+0x38c>
				putch('-', putdat);
  801ac3:	83 ec 08             	sub    $0x8,%esp
  801ac6:	53                   	push   %ebx
  801ac7:	6a 2d                	push   $0x2d
  801ac9:	ff d6                	call   *%esi
				num = -(long long) num;
  801acb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ace:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801ad1:	f7 da                	neg    %edx
  801ad3:	83 d1 00             	adc    $0x0,%ecx
  801ad6:	f7 d9                	neg    %ecx
  801ad8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801adb:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ae0:	e9 dd 00 00 00       	jmp    801bc2 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae8:	8b 00                	mov    (%eax),%eax
  801aea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aed:	99                   	cltd   
  801aee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801af1:	8b 45 14             	mov    0x14(%ebp),%eax
  801af4:	8d 40 04             	lea    0x4(%eax),%eax
  801af7:	89 45 14             	mov    %eax,0x14(%ebp)
  801afa:	eb b4                	jmp    801ab0 <vprintfmt+0x27a>
	if (lflag >= 2)
  801afc:	83 f9 01             	cmp    $0x1,%ecx
  801aff:	7f 1e                	jg     801b1f <vprintfmt+0x2e9>
	else if (lflag)
  801b01:	85 c9                	test   %ecx,%ecx
  801b03:	74 32                	je     801b37 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801b05:	8b 45 14             	mov    0x14(%ebp),%eax
  801b08:	8b 10                	mov    (%eax),%edx
  801b0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b0f:	8d 40 04             	lea    0x4(%eax),%eax
  801b12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b15:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801b1a:	e9 a3 00 00 00       	jmp    801bc2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b22:	8b 10                	mov    (%eax),%edx
  801b24:	8b 48 04             	mov    0x4(%eax),%ecx
  801b27:	8d 40 08             	lea    0x8(%eax),%eax
  801b2a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b2d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801b32:	e9 8b 00 00 00       	jmp    801bc2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b37:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3a:	8b 10                	mov    (%eax),%edx
  801b3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b41:	8d 40 04             	lea    0x4(%eax),%eax
  801b44:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b47:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801b4c:	eb 74                	jmp    801bc2 <vprintfmt+0x38c>
	if (lflag >= 2)
  801b4e:	83 f9 01             	cmp    $0x1,%ecx
  801b51:	7f 1b                	jg     801b6e <vprintfmt+0x338>
	else if (lflag)
  801b53:	85 c9                	test   %ecx,%ecx
  801b55:	74 2c                	je     801b83 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801b57:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5a:	8b 10                	mov    (%eax),%edx
  801b5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b61:	8d 40 04             	lea    0x4(%eax),%eax
  801b64:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b67:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b6c:	eb 54                	jmp    801bc2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b71:	8b 10                	mov    (%eax),%edx
  801b73:	8b 48 04             	mov    0x4(%eax),%ecx
  801b76:	8d 40 08             	lea    0x8(%eax),%eax
  801b79:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b7c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b81:	eb 3f                	jmp    801bc2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b83:	8b 45 14             	mov    0x14(%ebp),%eax
  801b86:	8b 10                	mov    (%eax),%edx
  801b88:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b8d:	8d 40 04             	lea    0x4(%eax),%eax
  801b90:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b93:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b98:	eb 28                	jmp    801bc2 <vprintfmt+0x38c>
			putch('0', putdat);
  801b9a:	83 ec 08             	sub    $0x8,%esp
  801b9d:	53                   	push   %ebx
  801b9e:	6a 30                	push   $0x30
  801ba0:	ff d6                	call   *%esi
			putch('x', putdat);
  801ba2:	83 c4 08             	add    $0x8,%esp
  801ba5:	53                   	push   %ebx
  801ba6:	6a 78                	push   $0x78
  801ba8:	ff d6                	call   *%esi
			num = (unsigned long long)
  801baa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bad:	8b 10                	mov    (%eax),%edx
  801baf:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801bb4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801bb7:	8d 40 04             	lea    0x4(%eax),%eax
  801bba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bbd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801bc2:	83 ec 0c             	sub    $0xc,%esp
  801bc5:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801bc9:	57                   	push   %edi
  801bca:	ff 75 e0             	pushl  -0x20(%ebp)
  801bcd:	50                   	push   %eax
  801bce:	51                   	push   %ecx
  801bcf:	52                   	push   %edx
  801bd0:	89 da                	mov    %ebx,%edx
  801bd2:	89 f0                	mov    %esi,%eax
  801bd4:	e8 72 fb ff ff       	call   80174b <printnum>
			break;
  801bd9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801bdc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bdf:	83 c7 01             	add    $0x1,%edi
  801be2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801be6:	83 f8 25             	cmp    $0x25,%eax
  801be9:	0f 84 62 fc ff ff    	je     801851 <vprintfmt+0x1b>
			if (ch == '\0')
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	0f 84 8b 00 00 00    	je     801c82 <vprintfmt+0x44c>
			putch(ch, putdat);
  801bf7:	83 ec 08             	sub    $0x8,%esp
  801bfa:	53                   	push   %ebx
  801bfb:	50                   	push   %eax
  801bfc:	ff d6                	call   *%esi
  801bfe:	83 c4 10             	add    $0x10,%esp
  801c01:	eb dc                	jmp    801bdf <vprintfmt+0x3a9>
	if (lflag >= 2)
  801c03:	83 f9 01             	cmp    $0x1,%ecx
  801c06:	7f 1b                	jg     801c23 <vprintfmt+0x3ed>
	else if (lflag)
  801c08:	85 c9                	test   %ecx,%ecx
  801c0a:	74 2c                	je     801c38 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0f:	8b 10                	mov    (%eax),%edx
  801c11:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c16:	8d 40 04             	lea    0x4(%eax),%eax
  801c19:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c1c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801c21:	eb 9f                	jmp    801bc2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801c23:	8b 45 14             	mov    0x14(%ebp),%eax
  801c26:	8b 10                	mov    (%eax),%edx
  801c28:	8b 48 04             	mov    0x4(%eax),%ecx
  801c2b:	8d 40 08             	lea    0x8(%eax),%eax
  801c2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c31:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801c36:	eb 8a                	jmp    801bc2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801c38:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3b:	8b 10                	mov    (%eax),%edx
  801c3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c42:	8d 40 04             	lea    0x4(%eax),%eax
  801c45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c48:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801c4d:	e9 70 ff ff ff       	jmp    801bc2 <vprintfmt+0x38c>
			putch(ch, putdat);
  801c52:	83 ec 08             	sub    $0x8,%esp
  801c55:	53                   	push   %ebx
  801c56:	6a 25                	push   $0x25
  801c58:	ff d6                	call   *%esi
			break;
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	e9 7a ff ff ff       	jmp    801bdc <vprintfmt+0x3a6>
			putch('%', putdat);
  801c62:	83 ec 08             	sub    $0x8,%esp
  801c65:	53                   	push   %ebx
  801c66:	6a 25                	push   $0x25
  801c68:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	89 f8                	mov    %edi,%eax
  801c6f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c73:	74 05                	je     801c7a <vprintfmt+0x444>
  801c75:	83 e8 01             	sub    $0x1,%eax
  801c78:	eb f5                	jmp    801c6f <vprintfmt+0x439>
  801c7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c7d:	e9 5a ff ff ff       	jmp    801bdc <vprintfmt+0x3a6>
}
  801c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c85:	5b                   	pop    %ebx
  801c86:	5e                   	pop    %esi
  801c87:	5f                   	pop    %edi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    

00801c8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c8a:	f3 0f 1e fb          	endbr32 
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 18             	sub    $0x18,%esp
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c9d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801ca1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801ca4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cab:	85 c0                	test   %eax,%eax
  801cad:	74 26                	je     801cd5 <vsnprintf+0x4b>
  801caf:	85 d2                	test   %edx,%edx
  801cb1:	7e 22                	jle    801cd5 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801cb3:	ff 75 14             	pushl  0x14(%ebp)
  801cb6:	ff 75 10             	pushl  0x10(%ebp)
  801cb9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801cbc:	50                   	push   %eax
  801cbd:	68 f4 17 80 00       	push   $0x8017f4
  801cc2:	e8 6f fb ff ff       	call   801836 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd0:	83 c4 10             	add    $0x10,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    
		return -E_INVAL;
  801cd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cda:	eb f7                	jmp    801cd3 <vsnprintf+0x49>

00801cdc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801cdc:	f3 0f 1e fb          	endbr32 
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ce6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801ce9:	50                   	push   %eax
  801cea:	ff 75 10             	pushl  0x10(%ebp)
  801ced:	ff 75 0c             	pushl  0xc(%ebp)
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	e8 92 ff ff ff       	call   801c8a <vsnprintf>
	va_end(ap);

	return rc;
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801cfa:	f3 0f 1e fb          	endbr32 
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801d04:	b8 00 00 00 00       	mov    $0x0,%eax
  801d09:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801d0d:	74 05                	je     801d14 <strlen+0x1a>
		n++;
  801d0f:	83 c0 01             	add    $0x1,%eax
  801d12:	eb f5                	jmp    801d09 <strlen+0xf>
	return n;
}
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    

00801d16 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801d16:	f3 0f 1e fb          	endbr32 
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d20:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	39 d0                	cmp    %edx,%eax
  801d2a:	74 0d                	je     801d39 <strnlen+0x23>
  801d2c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801d30:	74 05                	je     801d37 <strnlen+0x21>
		n++;
  801d32:	83 c0 01             	add    $0x1,%eax
  801d35:	eb f1                	jmp    801d28 <strnlen+0x12>
  801d37:	89 c2                	mov    %eax,%edx
	return n;
}
  801d39:	89 d0                	mov    %edx,%eax
  801d3b:	5d                   	pop    %ebp
  801d3c:	c3                   	ret    

00801d3d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d3d:	f3 0f 1e fb          	endbr32 
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	53                   	push   %ebx
  801d45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d50:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801d54:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801d57:	83 c0 01             	add    $0x1,%eax
  801d5a:	84 d2                	test   %dl,%dl
  801d5c:	75 f2                	jne    801d50 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801d5e:	89 c8                	mov    %ecx,%eax
  801d60:	5b                   	pop    %ebx
  801d61:	5d                   	pop    %ebp
  801d62:	c3                   	ret    

00801d63 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d63:	f3 0f 1e fb          	endbr32 
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	53                   	push   %ebx
  801d6b:	83 ec 10             	sub    $0x10,%esp
  801d6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d71:	53                   	push   %ebx
  801d72:	e8 83 ff ff ff       	call   801cfa <strlen>
  801d77:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	01 d8                	add    %ebx,%eax
  801d7f:	50                   	push   %eax
  801d80:	e8 b8 ff ff ff       	call   801d3d <strcpy>
	return dst;
}
  801d85:	89 d8                	mov    %ebx,%eax
  801d87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d8c:	f3 0f 1e fb          	endbr32 
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	8b 75 08             	mov    0x8(%ebp),%esi
  801d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9b:	89 f3                	mov    %esi,%ebx
  801d9d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801da0:	89 f0                	mov    %esi,%eax
  801da2:	39 d8                	cmp    %ebx,%eax
  801da4:	74 11                	je     801db7 <strncpy+0x2b>
		*dst++ = *src;
  801da6:	83 c0 01             	add    $0x1,%eax
  801da9:	0f b6 0a             	movzbl (%edx),%ecx
  801dac:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801daf:	80 f9 01             	cmp    $0x1,%cl
  801db2:	83 da ff             	sbb    $0xffffffff,%edx
  801db5:	eb eb                	jmp    801da2 <strncpy+0x16>
	}
	return ret;
}
  801db7:	89 f0                	mov    %esi,%eax
  801db9:	5b                   	pop    %ebx
  801dba:	5e                   	pop    %esi
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    

00801dbd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801dbd:	f3 0f 1e fb          	endbr32 
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	56                   	push   %esi
  801dc5:	53                   	push   %ebx
  801dc6:	8b 75 08             	mov    0x8(%ebp),%esi
  801dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dcc:	8b 55 10             	mov    0x10(%ebp),%edx
  801dcf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801dd1:	85 d2                	test   %edx,%edx
  801dd3:	74 21                	je     801df6 <strlcpy+0x39>
  801dd5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801dd9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801ddb:	39 c2                	cmp    %eax,%edx
  801ddd:	74 14                	je     801df3 <strlcpy+0x36>
  801ddf:	0f b6 19             	movzbl (%ecx),%ebx
  801de2:	84 db                	test   %bl,%bl
  801de4:	74 0b                	je     801df1 <strlcpy+0x34>
			*dst++ = *src++;
  801de6:	83 c1 01             	add    $0x1,%ecx
  801de9:	83 c2 01             	add    $0x1,%edx
  801dec:	88 5a ff             	mov    %bl,-0x1(%edx)
  801def:	eb ea                	jmp    801ddb <strlcpy+0x1e>
  801df1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801df3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801df6:	29 f0                	sub    %esi,%eax
}
  801df8:	5b                   	pop    %ebx
  801df9:	5e                   	pop    %esi
  801dfa:	5d                   	pop    %ebp
  801dfb:	c3                   	ret    

00801dfc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801dfc:	f3 0f 1e fb          	endbr32 
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e06:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801e09:	0f b6 01             	movzbl (%ecx),%eax
  801e0c:	84 c0                	test   %al,%al
  801e0e:	74 0c                	je     801e1c <strcmp+0x20>
  801e10:	3a 02                	cmp    (%edx),%al
  801e12:	75 08                	jne    801e1c <strcmp+0x20>
		p++, q++;
  801e14:	83 c1 01             	add    $0x1,%ecx
  801e17:	83 c2 01             	add    $0x1,%edx
  801e1a:	eb ed                	jmp    801e09 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e1c:	0f b6 c0             	movzbl %al,%eax
  801e1f:	0f b6 12             	movzbl (%edx),%edx
  801e22:	29 d0                	sub    %edx,%eax
}
  801e24:	5d                   	pop    %ebp
  801e25:	c3                   	ret    

00801e26 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801e26:	f3 0f 1e fb          	endbr32 
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	53                   	push   %ebx
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e34:	89 c3                	mov    %eax,%ebx
  801e36:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801e39:	eb 06                	jmp    801e41 <strncmp+0x1b>
		n--, p++, q++;
  801e3b:	83 c0 01             	add    $0x1,%eax
  801e3e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801e41:	39 d8                	cmp    %ebx,%eax
  801e43:	74 16                	je     801e5b <strncmp+0x35>
  801e45:	0f b6 08             	movzbl (%eax),%ecx
  801e48:	84 c9                	test   %cl,%cl
  801e4a:	74 04                	je     801e50 <strncmp+0x2a>
  801e4c:	3a 0a                	cmp    (%edx),%cl
  801e4e:	74 eb                	je     801e3b <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e50:	0f b6 00             	movzbl (%eax),%eax
  801e53:	0f b6 12             	movzbl (%edx),%edx
  801e56:	29 d0                	sub    %edx,%eax
}
  801e58:	5b                   	pop    %ebx
  801e59:	5d                   	pop    %ebp
  801e5a:	c3                   	ret    
		return 0;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e60:	eb f6                	jmp    801e58 <strncmp+0x32>

00801e62 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e62:	f3 0f 1e fb          	endbr32 
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e70:	0f b6 10             	movzbl (%eax),%edx
  801e73:	84 d2                	test   %dl,%dl
  801e75:	74 09                	je     801e80 <strchr+0x1e>
		if (*s == c)
  801e77:	38 ca                	cmp    %cl,%dl
  801e79:	74 0a                	je     801e85 <strchr+0x23>
	for (; *s; s++)
  801e7b:	83 c0 01             	add    $0x1,%eax
  801e7e:	eb f0                	jmp    801e70 <strchr+0xe>
			return (char *) s;
	return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e85:	5d                   	pop    %ebp
  801e86:	c3                   	ret    

00801e87 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e87:	f3 0f 1e fb          	endbr32 
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e95:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e98:	38 ca                	cmp    %cl,%dl
  801e9a:	74 09                	je     801ea5 <strfind+0x1e>
  801e9c:	84 d2                	test   %dl,%dl
  801e9e:	74 05                	je     801ea5 <strfind+0x1e>
	for (; *s; s++)
  801ea0:	83 c0 01             	add    $0x1,%eax
  801ea3:	eb f0                	jmp    801e95 <strfind+0xe>
			break;
	return (char *) s;
}
  801ea5:	5d                   	pop    %ebp
  801ea6:	c3                   	ret    

00801ea7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ea7:	f3 0f 1e fb          	endbr32 
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	57                   	push   %edi
  801eaf:	56                   	push   %esi
  801eb0:	53                   	push   %ebx
  801eb1:	8b 7d 08             	mov    0x8(%ebp),%edi
  801eb4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801eb7:	85 c9                	test   %ecx,%ecx
  801eb9:	74 31                	je     801eec <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ebb:	89 f8                	mov    %edi,%eax
  801ebd:	09 c8                	or     %ecx,%eax
  801ebf:	a8 03                	test   $0x3,%al
  801ec1:	75 23                	jne    801ee6 <memset+0x3f>
		c &= 0xFF;
  801ec3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ec7:	89 d3                	mov    %edx,%ebx
  801ec9:	c1 e3 08             	shl    $0x8,%ebx
  801ecc:	89 d0                	mov    %edx,%eax
  801ece:	c1 e0 18             	shl    $0x18,%eax
  801ed1:	89 d6                	mov    %edx,%esi
  801ed3:	c1 e6 10             	shl    $0x10,%esi
  801ed6:	09 f0                	or     %esi,%eax
  801ed8:	09 c2                	or     %eax,%edx
  801eda:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801edc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801edf:	89 d0                	mov    %edx,%eax
  801ee1:	fc                   	cld    
  801ee2:	f3 ab                	rep stos %eax,%es:(%edi)
  801ee4:	eb 06                	jmp    801eec <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee9:	fc                   	cld    
  801eea:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801eec:	89 f8                	mov    %edi,%eax
  801eee:	5b                   	pop    %ebx
  801eef:	5e                   	pop    %esi
  801ef0:	5f                   	pop    %edi
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    

00801ef3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801ef3:	f3 0f 1e fb          	endbr32 
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	57                   	push   %edi
  801efb:	56                   	push   %esi
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f02:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801f05:	39 c6                	cmp    %eax,%esi
  801f07:	73 32                	jae    801f3b <memmove+0x48>
  801f09:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801f0c:	39 c2                	cmp    %eax,%edx
  801f0e:	76 2b                	jbe    801f3b <memmove+0x48>
		s += n;
		d += n;
  801f10:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f13:	89 fe                	mov    %edi,%esi
  801f15:	09 ce                	or     %ecx,%esi
  801f17:	09 d6                	or     %edx,%esi
  801f19:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801f1f:	75 0e                	jne    801f2f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801f21:	83 ef 04             	sub    $0x4,%edi
  801f24:	8d 72 fc             	lea    -0x4(%edx),%esi
  801f27:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801f2a:	fd                   	std    
  801f2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f2d:	eb 09                	jmp    801f38 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f2f:	83 ef 01             	sub    $0x1,%edi
  801f32:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801f35:	fd                   	std    
  801f36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f38:	fc                   	cld    
  801f39:	eb 1a                	jmp    801f55 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f3b:	89 c2                	mov    %eax,%edx
  801f3d:	09 ca                	or     %ecx,%edx
  801f3f:	09 f2                	or     %esi,%edx
  801f41:	f6 c2 03             	test   $0x3,%dl
  801f44:	75 0a                	jne    801f50 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f46:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801f49:	89 c7                	mov    %eax,%edi
  801f4b:	fc                   	cld    
  801f4c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f4e:	eb 05                	jmp    801f55 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801f50:	89 c7                	mov    %eax,%edi
  801f52:	fc                   	cld    
  801f53:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801f55:	5e                   	pop    %esi
  801f56:	5f                   	pop    %edi
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    

00801f59 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f59:	f3 0f 1e fb          	endbr32 
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f63:	ff 75 10             	pushl  0x10(%ebp)
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	e8 82 ff ff ff       	call   801ef3 <memmove>
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f73:	f3 0f 1e fb          	endbr32 
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	56                   	push   %esi
  801f7b:	53                   	push   %ebx
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f82:	89 c6                	mov    %eax,%esi
  801f84:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f87:	39 f0                	cmp    %esi,%eax
  801f89:	74 1c                	je     801fa7 <memcmp+0x34>
		if (*s1 != *s2)
  801f8b:	0f b6 08             	movzbl (%eax),%ecx
  801f8e:	0f b6 1a             	movzbl (%edx),%ebx
  801f91:	38 d9                	cmp    %bl,%cl
  801f93:	75 08                	jne    801f9d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f95:	83 c0 01             	add    $0x1,%eax
  801f98:	83 c2 01             	add    $0x1,%edx
  801f9b:	eb ea                	jmp    801f87 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f9d:	0f b6 c1             	movzbl %cl,%eax
  801fa0:	0f b6 db             	movzbl %bl,%ebx
  801fa3:	29 d8                	sub    %ebx,%eax
  801fa5:	eb 05                	jmp    801fac <memcmp+0x39>
	}

	return 0;
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fac:	5b                   	pop    %ebx
  801fad:	5e                   	pop    %esi
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    

00801fb0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801fb0:	f3 0f 1e fb          	endbr32 
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801fbd:	89 c2                	mov    %eax,%edx
  801fbf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801fc2:	39 d0                	cmp    %edx,%eax
  801fc4:	73 09                	jae    801fcf <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fc6:	38 08                	cmp    %cl,(%eax)
  801fc8:	74 05                	je     801fcf <memfind+0x1f>
	for (; s < ends; s++)
  801fca:	83 c0 01             	add    $0x1,%eax
  801fcd:	eb f3                	jmp    801fc2 <memfind+0x12>
			break;
	return (void *) s;
}
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    

00801fd1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fd1:	f3 0f 1e fb          	endbr32 
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	57                   	push   %edi
  801fd9:	56                   	push   %esi
  801fda:	53                   	push   %ebx
  801fdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fde:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801fe1:	eb 03                	jmp    801fe6 <strtol+0x15>
		s++;
  801fe3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801fe6:	0f b6 01             	movzbl (%ecx),%eax
  801fe9:	3c 20                	cmp    $0x20,%al
  801feb:	74 f6                	je     801fe3 <strtol+0x12>
  801fed:	3c 09                	cmp    $0x9,%al
  801fef:	74 f2                	je     801fe3 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801ff1:	3c 2b                	cmp    $0x2b,%al
  801ff3:	74 2a                	je     80201f <strtol+0x4e>
	int neg = 0;
  801ff5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ffa:	3c 2d                	cmp    $0x2d,%al
  801ffc:	74 2b                	je     802029 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ffe:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  802004:	75 0f                	jne    802015 <strtol+0x44>
  802006:	80 39 30             	cmpb   $0x30,(%ecx)
  802009:	74 28                	je     802033 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80200b:	85 db                	test   %ebx,%ebx
  80200d:	b8 0a 00 00 00       	mov    $0xa,%eax
  802012:	0f 44 d8             	cmove  %eax,%ebx
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
  80201a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80201d:	eb 46                	jmp    802065 <strtol+0x94>
		s++;
  80201f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  802022:	bf 00 00 00 00       	mov    $0x0,%edi
  802027:	eb d5                	jmp    801ffe <strtol+0x2d>
		s++, neg = 1;
  802029:	83 c1 01             	add    $0x1,%ecx
  80202c:	bf 01 00 00 00       	mov    $0x1,%edi
  802031:	eb cb                	jmp    801ffe <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802033:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802037:	74 0e                	je     802047 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802039:	85 db                	test   %ebx,%ebx
  80203b:	75 d8                	jne    802015 <strtol+0x44>
		s++, base = 8;
  80203d:	83 c1 01             	add    $0x1,%ecx
  802040:	bb 08 00 00 00       	mov    $0x8,%ebx
  802045:	eb ce                	jmp    802015 <strtol+0x44>
		s += 2, base = 16;
  802047:	83 c1 02             	add    $0x2,%ecx
  80204a:	bb 10 00 00 00       	mov    $0x10,%ebx
  80204f:	eb c4                	jmp    802015 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  802051:	0f be d2             	movsbl %dl,%edx
  802054:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802057:	3b 55 10             	cmp    0x10(%ebp),%edx
  80205a:	7d 3a                	jge    802096 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80205c:	83 c1 01             	add    $0x1,%ecx
  80205f:	0f af 45 10          	imul   0x10(%ebp),%eax
  802063:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802065:	0f b6 11             	movzbl (%ecx),%edx
  802068:	8d 72 d0             	lea    -0x30(%edx),%esi
  80206b:	89 f3                	mov    %esi,%ebx
  80206d:	80 fb 09             	cmp    $0x9,%bl
  802070:	76 df                	jbe    802051 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  802072:	8d 72 9f             	lea    -0x61(%edx),%esi
  802075:	89 f3                	mov    %esi,%ebx
  802077:	80 fb 19             	cmp    $0x19,%bl
  80207a:	77 08                	ja     802084 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80207c:	0f be d2             	movsbl %dl,%edx
  80207f:	83 ea 57             	sub    $0x57,%edx
  802082:	eb d3                	jmp    802057 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802084:	8d 72 bf             	lea    -0x41(%edx),%esi
  802087:	89 f3                	mov    %esi,%ebx
  802089:	80 fb 19             	cmp    $0x19,%bl
  80208c:	77 08                	ja     802096 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80208e:	0f be d2             	movsbl %dl,%edx
  802091:	83 ea 37             	sub    $0x37,%edx
  802094:	eb c1                	jmp    802057 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802096:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80209a:	74 05                	je     8020a1 <strtol+0xd0>
		*endptr = (char *) s;
  80209c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80209f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8020a1:	89 c2                	mov    %eax,%edx
  8020a3:	f7 da                	neg    %edx
  8020a5:	85 ff                	test   %edi,%edi
  8020a7:	0f 45 c2             	cmovne %edx,%eax
}
  8020aa:	5b                   	pop    %ebx
  8020ab:	5e                   	pop    %esi
  8020ac:	5f                   	pop    %edi
  8020ad:	5d                   	pop    %ebp
  8020ae:	c3                   	ret    

008020af <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020af:	f3 0f 1e fb          	endbr32 
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8020bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	74 3d                	je     802102 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020c5:	83 ec 0c             	sub    $0xc,%esp
  8020c8:	50                   	push   %eax
  8020c9:	e8 88 e2 ff ff       	call   800356 <sys_ipc_recv>
  8020ce:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020d1:	85 f6                	test   %esi,%esi
  8020d3:	74 0b                	je     8020e0 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020d5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020db:	8b 52 74             	mov    0x74(%edx),%edx
  8020de:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020e0:	85 db                	test   %ebx,%ebx
  8020e2:	74 0b                	je     8020ef <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020e4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020ea:	8b 52 78             	mov    0x78(%edx),%edx
  8020ed:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 21                	js     802114 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8020f3:	a1 08 40 80 00       	mov    0x804008,%eax
  8020f8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fe:	5b                   	pop    %ebx
  8020ff:	5e                   	pop    %esi
  802100:	5d                   	pop    %ebp
  802101:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802102:	83 ec 0c             	sub    $0xc,%esp
  802105:	68 00 00 c0 ee       	push   $0xeec00000
  80210a:	e8 47 e2 ff ff       	call   800356 <sys_ipc_recv>
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	eb bd                	jmp    8020d1 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802114:	85 f6                	test   %esi,%esi
  802116:	74 10                	je     802128 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802118:	85 db                	test   %ebx,%ebx
  80211a:	75 df                	jne    8020fb <ipc_recv+0x4c>
  80211c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802123:	00 00 00 
  802126:	eb d3                	jmp    8020fb <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802128:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80212f:	00 00 00 
  802132:	eb e4                	jmp    802118 <ipc_recv+0x69>

00802134 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802134:	f3 0f 1e fb          	endbr32 
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	57                   	push   %edi
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	8b 7d 08             	mov    0x8(%ebp),%edi
  802144:	8b 75 0c             	mov    0xc(%ebp),%esi
  802147:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80214a:	85 db                	test   %ebx,%ebx
  80214c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802151:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802154:	ff 75 14             	pushl  0x14(%ebp)
  802157:	53                   	push   %ebx
  802158:	56                   	push   %esi
  802159:	57                   	push   %edi
  80215a:	e8 d0 e1 ff ff       	call   80032f <sys_ipc_try_send>
  80215f:	83 c4 10             	add    $0x10,%esp
  802162:	85 c0                	test   %eax,%eax
  802164:	79 1e                	jns    802184 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802166:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802169:	75 07                	jne    802172 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80216b:	e8 f7 df ff ff       	call   800167 <sys_yield>
  802170:	eb e2                	jmp    802154 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802172:	50                   	push   %eax
  802173:	68 1f 29 80 00       	push   $0x80291f
  802178:	6a 59                	push   $0x59
  80217a:	68 3a 29 80 00       	push   $0x80293a
  80217f:	e8 c8 f4 ff ff       	call   80164c <_panic>
	}
}
  802184:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5f                   	pop    %edi
  80218a:	5d                   	pop    %ebp
  80218b:	c3                   	ret    

0080218c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80218c:	f3 0f 1e fb          	endbr32 
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80219b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80219e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021a4:	8b 52 50             	mov    0x50(%edx),%edx
  8021a7:	39 ca                	cmp    %ecx,%edx
  8021a9:	74 11                	je     8021bc <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021ab:	83 c0 01             	add    $0x1,%eax
  8021ae:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021b3:	75 e6                	jne    80219b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ba:	eb 0b                	jmp    8021c7 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021bc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021c4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    

008021c9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021c9:	f3 0f 1e fb          	endbr32 
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021d3:	89 c2                	mov    %eax,%edx
  8021d5:	c1 ea 16             	shr    $0x16,%edx
  8021d8:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021df:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021e4:	f6 c1 01             	test   $0x1,%cl
  8021e7:	74 1c                	je     802205 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021e9:	c1 e8 0c             	shr    $0xc,%eax
  8021ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021f3:	a8 01                	test   $0x1,%al
  8021f5:	74 0e                	je     802205 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021f7:	c1 e8 0c             	shr    $0xc,%eax
  8021fa:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802201:	ef 
  802202:	0f b7 d2             	movzwl %dx,%edx
}
  802205:	89 d0                	mov    %edx,%eax
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    
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
