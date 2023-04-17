
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
  800073:	a3 04 40 80 00       	mov    %eax,0x804004

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
  8000a6:	e8 df 04 00 00       	call   80058a <close_all>
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
  800133:	68 18 1f 80 00       	push   $0x801f18
  800138:	6a 23                	push   $0x23
  80013a:	68 35 1f 80 00       	push   $0x801f35
  80013f:	e8 9c 0f 00 00       	call   8010e0 <_panic>

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
  8001c0:	68 18 1f 80 00       	push   $0x801f18
  8001c5:	6a 23                	push   $0x23
  8001c7:	68 35 1f 80 00       	push   $0x801f35
  8001cc:	e8 0f 0f 00 00       	call   8010e0 <_panic>

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
  800206:	68 18 1f 80 00       	push   $0x801f18
  80020b:	6a 23                	push   $0x23
  80020d:	68 35 1f 80 00       	push   $0x801f35
  800212:	e8 c9 0e 00 00       	call   8010e0 <_panic>

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
  80024c:	68 18 1f 80 00       	push   $0x801f18
  800251:	6a 23                	push   $0x23
  800253:	68 35 1f 80 00       	push   $0x801f35
  800258:	e8 83 0e 00 00       	call   8010e0 <_panic>

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
  800292:	68 18 1f 80 00       	push   $0x801f18
  800297:	6a 23                	push   $0x23
  800299:	68 35 1f 80 00       	push   $0x801f35
  80029e:	e8 3d 0e 00 00       	call   8010e0 <_panic>

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
  8002d8:	68 18 1f 80 00       	push   $0x801f18
  8002dd:	6a 23                	push   $0x23
  8002df:	68 35 1f 80 00       	push   $0x801f35
  8002e4:	e8 f7 0d 00 00       	call   8010e0 <_panic>

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
  80031e:	68 18 1f 80 00       	push   $0x801f18
  800323:	6a 23                	push   $0x23
  800325:	68 35 1f 80 00       	push   $0x801f35
  80032a:	e8 b1 0d 00 00       	call   8010e0 <_panic>

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
  80038a:	68 18 1f 80 00       	push   $0x801f18
  80038f:	6a 23                	push   $0x23
  800391:	68 35 1f 80 00       	push   $0x801f35
  800396:	e8 45 0d 00 00       	call   8010e0 <_panic>

0080039b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80039b:	f3 0f 1e fb          	endbr32 
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a5:	05 00 00 00 30       	add    $0x30000000,%eax
  8003aa:	c1 e8 0c             	shr    $0xc,%eax
}
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003af:	f3 0f 1e fb          	endbr32 
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003c8:	5d                   	pop    %ebp
  8003c9:	c3                   	ret    

008003ca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003ca:	f3 0f 1e fb          	endbr32 
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003d6:	89 c2                	mov    %eax,%edx
  8003d8:	c1 ea 16             	shr    $0x16,%edx
  8003db:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003e2:	f6 c2 01             	test   $0x1,%dl
  8003e5:	74 2d                	je     800414 <fd_alloc+0x4a>
  8003e7:	89 c2                	mov    %eax,%edx
  8003e9:	c1 ea 0c             	shr    $0xc,%edx
  8003ec:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003f3:	f6 c2 01             	test   $0x1,%dl
  8003f6:	74 1c                	je     800414 <fd_alloc+0x4a>
  8003f8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003fd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800402:	75 d2                	jne    8003d6 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80040d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800412:	eb 0a                	jmp    80041e <fd_alloc+0x54>
			*fd_store = fd;
  800414:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800417:	89 01                	mov    %eax,(%ecx)
			return 0;
  800419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800420:	f3 0f 1e fb          	endbr32 
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80042a:	83 f8 1f             	cmp    $0x1f,%eax
  80042d:	77 30                	ja     80045f <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80042f:	c1 e0 0c             	shl    $0xc,%eax
  800432:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800437:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80043d:	f6 c2 01             	test   $0x1,%dl
  800440:	74 24                	je     800466 <fd_lookup+0x46>
  800442:	89 c2                	mov    %eax,%edx
  800444:	c1 ea 0c             	shr    $0xc,%edx
  800447:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80044e:	f6 c2 01             	test   $0x1,%dl
  800451:	74 1a                	je     80046d <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	89 02                	mov    %eax,(%edx)
	return 0;
  800458:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80045d:	5d                   	pop    %ebp
  80045e:	c3                   	ret    
		return -E_INVAL;
  80045f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800464:	eb f7                	jmp    80045d <fd_lookup+0x3d>
		return -E_INVAL;
  800466:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80046b:	eb f0                	jmp    80045d <fd_lookup+0x3d>
  80046d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800472:	eb e9                	jmp    80045d <fd_lookup+0x3d>

00800474 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800474:	f3 0f 1e fb          	endbr32 
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800481:	ba c0 1f 80 00       	mov    $0x801fc0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800486:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80048b:	39 08                	cmp    %ecx,(%eax)
  80048d:	74 33                	je     8004c2 <dev_lookup+0x4e>
  80048f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800492:	8b 02                	mov    (%edx),%eax
  800494:	85 c0                	test   %eax,%eax
  800496:	75 f3                	jne    80048b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800498:	a1 04 40 80 00       	mov    0x804004,%eax
  80049d:	8b 40 48             	mov    0x48(%eax),%eax
  8004a0:	83 ec 04             	sub    $0x4,%esp
  8004a3:	51                   	push   %ecx
  8004a4:	50                   	push   %eax
  8004a5:	68 44 1f 80 00       	push   $0x801f44
  8004aa:	e8 18 0d 00 00       	call   8011c7 <cprintf>
	*dev = 0;
  8004af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    
			*dev = devtab[i];
  8004c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cc:	eb f2                	jmp    8004c0 <dev_lookup+0x4c>

008004ce <fd_close>:
{
  8004ce:	f3 0f 1e fb          	endbr32 
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	57                   	push   %edi
  8004d6:	56                   	push   %esi
  8004d7:	53                   	push   %ebx
  8004d8:	83 ec 24             	sub    $0x24,%esp
  8004db:	8b 75 08             	mov    0x8(%ebp),%esi
  8004de:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004e4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004e5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004eb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004ee:	50                   	push   %eax
  8004ef:	e8 2c ff ff ff       	call   800420 <fd_lookup>
  8004f4:	89 c3                	mov    %eax,%ebx
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	85 c0                	test   %eax,%eax
  8004fb:	78 05                	js     800502 <fd_close+0x34>
	    || fd != fd2)
  8004fd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800500:	74 16                	je     800518 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800502:	89 f8                	mov    %edi,%eax
  800504:	84 c0                	test   %al,%al
  800506:	b8 00 00 00 00       	mov    $0x0,%eax
  80050b:	0f 44 d8             	cmove  %eax,%ebx
}
  80050e:	89 d8                	mov    %ebx,%eax
  800510:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800513:	5b                   	pop    %ebx
  800514:	5e                   	pop    %esi
  800515:	5f                   	pop    %edi
  800516:	5d                   	pop    %ebp
  800517:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80051e:	50                   	push   %eax
  80051f:	ff 36                	pushl  (%esi)
  800521:	e8 4e ff ff ff       	call   800474 <dev_lookup>
  800526:	89 c3                	mov    %eax,%ebx
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	85 c0                	test   %eax,%eax
  80052d:	78 1a                	js     800549 <fd_close+0x7b>
		if (dev->dev_close)
  80052f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800532:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800535:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80053a:	85 c0                	test   %eax,%eax
  80053c:	74 0b                	je     800549 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80053e:	83 ec 0c             	sub    $0xc,%esp
  800541:	56                   	push   %esi
  800542:	ff d0                	call   *%eax
  800544:	89 c3                	mov    %eax,%ebx
  800546:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	56                   	push   %esi
  80054d:	6a 00                	push   $0x0
  80054f:	e8 c3 fc ff ff       	call   800217 <sys_page_unmap>
	return r;
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	eb b5                	jmp    80050e <fd_close+0x40>

00800559 <close>:

int
close(int fdnum)
{
  800559:	f3 0f 1e fb          	endbr32 
  80055d:	55                   	push   %ebp
  80055e:	89 e5                	mov    %esp,%ebp
  800560:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800563:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800566:	50                   	push   %eax
  800567:	ff 75 08             	pushl  0x8(%ebp)
  80056a:	e8 b1 fe ff ff       	call   800420 <fd_lookup>
  80056f:	83 c4 10             	add    $0x10,%esp
  800572:	85 c0                	test   %eax,%eax
  800574:	79 02                	jns    800578 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800576:	c9                   	leave  
  800577:	c3                   	ret    
		return fd_close(fd, 1);
  800578:	83 ec 08             	sub    $0x8,%esp
  80057b:	6a 01                	push   $0x1
  80057d:	ff 75 f4             	pushl  -0xc(%ebp)
  800580:	e8 49 ff ff ff       	call   8004ce <fd_close>
  800585:	83 c4 10             	add    $0x10,%esp
  800588:	eb ec                	jmp    800576 <close+0x1d>

0080058a <close_all>:

void
close_all(void)
{
  80058a:	f3 0f 1e fb          	endbr32 
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	53                   	push   %ebx
  800592:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800595:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80059a:	83 ec 0c             	sub    $0xc,%esp
  80059d:	53                   	push   %ebx
  80059e:	e8 b6 ff ff ff       	call   800559 <close>
	for (i = 0; i < MAXFD; i++)
  8005a3:	83 c3 01             	add    $0x1,%ebx
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	83 fb 20             	cmp    $0x20,%ebx
  8005ac:	75 ec                	jne    80059a <close_all+0x10>
}
  8005ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005b3:	f3 0f 1e fb          	endbr32 
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	57                   	push   %edi
  8005bb:	56                   	push   %esi
  8005bc:	53                   	push   %ebx
  8005bd:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005c3:	50                   	push   %eax
  8005c4:	ff 75 08             	pushl  0x8(%ebp)
  8005c7:	e8 54 fe ff ff       	call   800420 <fd_lookup>
  8005cc:	89 c3                	mov    %eax,%ebx
  8005ce:	83 c4 10             	add    $0x10,%esp
  8005d1:	85 c0                	test   %eax,%eax
  8005d3:	0f 88 81 00 00 00    	js     80065a <dup+0xa7>
		return r;
	close(newfdnum);
  8005d9:	83 ec 0c             	sub    $0xc,%esp
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	e8 75 ff ff ff       	call   800559 <close>

	newfd = INDEX2FD(newfdnum);
  8005e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005e7:	c1 e6 0c             	shl    $0xc,%esi
  8005ea:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005f0:	83 c4 04             	add    $0x4,%esp
  8005f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005f6:	e8 b4 fd ff ff       	call   8003af <fd2data>
  8005fb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005fd:	89 34 24             	mov    %esi,(%esp)
  800600:	e8 aa fd ff ff       	call   8003af <fd2data>
  800605:	83 c4 10             	add    $0x10,%esp
  800608:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80060a:	89 d8                	mov    %ebx,%eax
  80060c:	c1 e8 16             	shr    $0x16,%eax
  80060f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800616:	a8 01                	test   $0x1,%al
  800618:	74 11                	je     80062b <dup+0x78>
  80061a:	89 d8                	mov    %ebx,%eax
  80061c:	c1 e8 0c             	shr    $0xc,%eax
  80061f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800626:	f6 c2 01             	test   $0x1,%dl
  800629:	75 39                	jne    800664 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80062b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	c1 e8 0c             	shr    $0xc,%eax
  800633:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	25 07 0e 00 00       	and    $0xe07,%eax
  800642:	50                   	push   %eax
  800643:	56                   	push   %esi
  800644:	6a 00                	push   $0x0
  800646:	52                   	push   %edx
  800647:	6a 00                	push   $0x0
  800649:	e8 83 fb ff ff       	call   8001d1 <sys_page_map>
  80064e:	89 c3                	mov    %eax,%ebx
  800650:	83 c4 20             	add    $0x20,%esp
  800653:	85 c0                	test   %eax,%eax
  800655:	78 31                	js     800688 <dup+0xd5>
		goto err;

	return newfdnum;
  800657:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80065a:	89 d8                	mov    %ebx,%eax
  80065c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80065f:	5b                   	pop    %ebx
  800660:	5e                   	pop    %esi
  800661:	5f                   	pop    %edi
  800662:	5d                   	pop    %ebp
  800663:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800664:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80066b:	83 ec 0c             	sub    $0xc,%esp
  80066e:	25 07 0e 00 00       	and    $0xe07,%eax
  800673:	50                   	push   %eax
  800674:	57                   	push   %edi
  800675:	6a 00                	push   $0x0
  800677:	53                   	push   %ebx
  800678:	6a 00                	push   $0x0
  80067a:	e8 52 fb ff ff       	call   8001d1 <sys_page_map>
  80067f:	89 c3                	mov    %eax,%ebx
  800681:	83 c4 20             	add    $0x20,%esp
  800684:	85 c0                	test   %eax,%eax
  800686:	79 a3                	jns    80062b <dup+0x78>
	sys_page_unmap(0, newfd);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	56                   	push   %esi
  80068c:	6a 00                	push   $0x0
  80068e:	e8 84 fb ff ff       	call   800217 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800693:	83 c4 08             	add    $0x8,%esp
  800696:	57                   	push   %edi
  800697:	6a 00                	push   $0x0
  800699:	e8 79 fb ff ff       	call   800217 <sys_page_unmap>
	return r;
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	eb b7                	jmp    80065a <dup+0xa7>

008006a3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006a3:	f3 0f 1e fb          	endbr32 
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
  8006aa:	53                   	push   %ebx
  8006ab:	83 ec 1c             	sub    $0x1c,%esp
  8006ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006b4:	50                   	push   %eax
  8006b5:	53                   	push   %ebx
  8006b6:	e8 65 fd ff ff       	call   800420 <fd_lookup>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	85 c0                	test   %eax,%eax
  8006c0:	78 3f                	js     800701 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006c8:	50                   	push   %eax
  8006c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cc:	ff 30                	pushl  (%eax)
  8006ce:	e8 a1 fd ff ff       	call   800474 <dev_lookup>
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	78 27                	js     800701 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006dd:	8b 42 08             	mov    0x8(%edx),%eax
  8006e0:	83 e0 03             	and    $0x3,%eax
  8006e3:	83 f8 01             	cmp    $0x1,%eax
  8006e6:	74 1e                	je     800706 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006eb:	8b 40 08             	mov    0x8(%eax),%eax
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	74 35                	je     800727 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	ff 75 10             	pushl  0x10(%ebp)
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	52                   	push   %edx
  8006fc:	ff d0                	call   *%eax
  8006fe:	83 c4 10             	add    $0x10,%esp
}
  800701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800704:	c9                   	leave  
  800705:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800706:	a1 04 40 80 00       	mov    0x804004,%eax
  80070b:	8b 40 48             	mov    0x48(%eax),%eax
  80070e:	83 ec 04             	sub    $0x4,%esp
  800711:	53                   	push   %ebx
  800712:	50                   	push   %eax
  800713:	68 85 1f 80 00       	push   $0x801f85
  800718:	e8 aa 0a 00 00       	call   8011c7 <cprintf>
		return -E_INVAL;
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800725:	eb da                	jmp    800701 <read+0x5e>
		return -E_NOT_SUPP;
  800727:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80072c:	eb d3                	jmp    800701 <read+0x5e>

0080072e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80072e:	f3 0f 1e fb          	endbr32 
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	57                   	push   %edi
  800736:	56                   	push   %esi
  800737:	53                   	push   %ebx
  800738:	83 ec 0c             	sub    $0xc,%esp
  80073b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80073e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800741:	bb 00 00 00 00       	mov    $0x0,%ebx
  800746:	eb 02                	jmp    80074a <readn+0x1c>
  800748:	01 c3                	add    %eax,%ebx
  80074a:	39 f3                	cmp    %esi,%ebx
  80074c:	73 21                	jae    80076f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80074e:	83 ec 04             	sub    $0x4,%esp
  800751:	89 f0                	mov    %esi,%eax
  800753:	29 d8                	sub    %ebx,%eax
  800755:	50                   	push   %eax
  800756:	89 d8                	mov    %ebx,%eax
  800758:	03 45 0c             	add    0xc(%ebp),%eax
  80075b:	50                   	push   %eax
  80075c:	57                   	push   %edi
  80075d:	e8 41 ff ff ff       	call   8006a3 <read>
		if (m < 0)
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	85 c0                	test   %eax,%eax
  800767:	78 04                	js     80076d <readn+0x3f>
			return m;
		if (m == 0)
  800769:	75 dd                	jne    800748 <readn+0x1a>
  80076b:	eb 02                	jmp    80076f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80076d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80076f:	89 d8                	mov    %ebx,%eax
  800771:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800774:	5b                   	pop    %ebx
  800775:	5e                   	pop    %esi
  800776:	5f                   	pop    %edi
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800779:	f3 0f 1e fb          	endbr32 
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	53                   	push   %ebx
  800781:	83 ec 1c             	sub    $0x1c,%esp
  800784:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800787:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	53                   	push   %ebx
  80078c:	e8 8f fc ff ff       	call   800420 <fd_lookup>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	85 c0                	test   %eax,%eax
  800796:	78 3a                	js     8007d2 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80079e:	50                   	push   %eax
  80079f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a2:	ff 30                	pushl  (%eax)
  8007a4:	e8 cb fc ff ff       	call   800474 <dev_lookup>
  8007a9:	83 c4 10             	add    $0x10,%esp
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	78 22                	js     8007d2 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007b7:	74 1e                	je     8007d7 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8007bf:	85 d2                	test   %edx,%edx
  8007c1:	74 35                	je     8007f8 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007c3:	83 ec 04             	sub    $0x4,%esp
  8007c6:	ff 75 10             	pushl  0x10(%ebp)
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	50                   	push   %eax
  8007cd:	ff d2                	call   *%edx
  8007cf:	83 c4 10             	add    $0x10,%esp
}
  8007d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d5:	c9                   	leave  
  8007d6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007d7:	a1 04 40 80 00       	mov    0x804004,%eax
  8007dc:	8b 40 48             	mov    0x48(%eax),%eax
  8007df:	83 ec 04             	sub    $0x4,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	50                   	push   %eax
  8007e4:	68 a1 1f 80 00       	push   $0x801fa1
  8007e9:	e8 d9 09 00 00       	call   8011c7 <cprintf>
		return -E_INVAL;
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f6:	eb da                	jmp    8007d2 <write+0x59>
		return -E_NOT_SUPP;
  8007f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007fd:	eb d3                	jmp    8007d2 <write+0x59>

008007ff <seek>:

int
seek(int fdnum, off_t offset)
{
  8007ff:	f3 0f 1e fb          	endbr32 
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800809:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80080c:	50                   	push   %eax
  80080d:	ff 75 08             	pushl  0x8(%ebp)
  800810:	e8 0b fc ff ff       	call   800420 <fd_lookup>
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	85 c0                	test   %eax,%eax
  80081a:	78 0e                	js     80082a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80081c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800822:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800825:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80082c:	f3 0f 1e fb          	endbr32 
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	53                   	push   %ebx
  800834:	83 ec 1c             	sub    $0x1c,%esp
  800837:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80083a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80083d:	50                   	push   %eax
  80083e:	53                   	push   %ebx
  80083f:	e8 dc fb ff ff       	call   800420 <fd_lookup>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	85 c0                	test   %eax,%eax
  800849:	78 37                	js     800882 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800851:	50                   	push   %eax
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	ff 30                	pushl  (%eax)
  800857:	e8 18 fc ff ff       	call   800474 <dev_lookup>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	85 c0                	test   %eax,%eax
  800861:	78 1f                	js     800882 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800866:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80086a:	74 1b                	je     800887 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80086c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086f:	8b 52 18             	mov    0x18(%edx),%edx
  800872:	85 d2                	test   %edx,%edx
  800874:	74 32                	je     8008a8 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	ff 75 0c             	pushl  0xc(%ebp)
  80087c:	50                   	push   %eax
  80087d:	ff d2                	call   *%edx
  80087f:	83 c4 10             	add    $0x10,%esp
}
  800882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800885:	c9                   	leave  
  800886:	c3                   	ret    
			thisenv->env_id, fdnum);
  800887:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80088c:	8b 40 48             	mov    0x48(%eax),%eax
  80088f:	83 ec 04             	sub    $0x4,%esp
  800892:	53                   	push   %ebx
  800893:	50                   	push   %eax
  800894:	68 64 1f 80 00       	push   $0x801f64
  800899:	e8 29 09 00 00       	call   8011c7 <cprintf>
		return -E_INVAL;
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a6:	eb da                	jmp    800882 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008ad:	eb d3                	jmp    800882 <ftruncate+0x56>

008008af <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008af:	f3 0f 1e fb          	endbr32 
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	53                   	push   %ebx
  8008b7:	83 ec 1c             	sub    $0x1c,%esp
  8008ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008c0:	50                   	push   %eax
  8008c1:	ff 75 08             	pushl  0x8(%ebp)
  8008c4:	e8 57 fb ff ff       	call   800420 <fd_lookup>
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	78 4b                	js     80091b <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008d6:	50                   	push   %eax
  8008d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008da:	ff 30                	pushl  (%eax)
  8008dc:	e8 93 fb ff ff       	call   800474 <dev_lookup>
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	85 c0                	test   %eax,%eax
  8008e6:	78 33                	js     80091b <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008eb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008ef:	74 2f                	je     800920 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008f1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008f4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008fb:	00 00 00 
	stat->st_isdir = 0;
  8008fe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800905:	00 00 00 
	stat->st_dev = dev;
  800908:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	53                   	push   %ebx
  800912:	ff 75 f0             	pushl  -0x10(%ebp)
  800915:	ff 50 14             	call   *0x14(%eax)
  800918:	83 c4 10             	add    $0x10,%esp
}
  80091b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091e:	c9                   	leave  
  80091f:	c3                   	ret    
		return -E_NOT_SUPP;
  800920:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800925:	eb f4                	jmp    80091b <fstat+0x6c>

00800927 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800927:	f3 0f 1e fb          	endbr32 
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	56                   	push   %esi
  80092f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	6a 00                	push   $0x0
  800935:	ff 75 08             	pushl  0x8(%ebp)
  800938:	e8 fb 01 00 00       	call   800b38 <open>
  80093d:	89 c3                	mov    %eax,%ebx
  80093f:	83 c4 10             	add    $0x10,%esp
  800942:	85 c0                	test   %eax,%eax
  800944:	78 1b                	js     800961 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	50                   	push   %eax
  80094d:	e8 5d ff ff ff       	call   8008af <fstat>
  800952:	89 c6                	mov    %eax,%esi
	close(fd);
  800954:	89 1c 24             	mov    %ebx,(%esp)
  800957:	e8 fd fb ff ff       	call   800559 <close>
	return r;
  80095c:	83 c4 10             	add    $0x10,%esp
  80095f:	89 f3                	mov    %esi,%ebx
}
  800961:	89 d8                	mov    %ebx,%eax
  800963:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800966:	5b                   	pop    %ebx
  800967:	5e                   	pop    %esi
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	56                   	push   %esi
  80096e:	53                   	push   %ebx
  80096f:	89 c6                	mov    %eax,%esi
  800971:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800973:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80097a:	74 27                	je     8009a3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80097c:	6a 07                	push   $0x7
  80097e:	68 00 50 80 00       	push   $0x805000
  800983:	56                   	push   %esi
  800984:	ff 35 00 40 80 00    	pushl  0x804000
  80098a:	e8 39 12 00 00       	call   801bc8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80098f:	83 c4 0c             	add    $0xc,%esp
  800992:	6a 00                	push   $0x0
  800994:	53                   	push   %ebx
  800995:	6a 00                	push   $0x0
  800997:	e8 a7 11 00 00       	call   801b43 <ipc_recv>
}
  80099c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80099f:	5b                   	pop    %ebx
  8009a0:	5e                   	pop    %esi
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	6a 01                	push   $0x1
  8009a8:	e8 73 12 00 00       	call   801c20 <ipc_find_env>
  8009ad:	a3 00 40 80 00       	mov    %eax,0x804000
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	eb c5                	jmp    80097c <fsipc+0x12>

008009b7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009b7:	f3 0f 1e fb          	endbr32 
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8009c7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cf:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d9:	b8 02 00 00 00       	mov    $0x2,%eax
  8009de:	e8 87 ff ff ff       	call   80096a <fsipc>
}
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    

008009e5 <devfile_flush>:
{
  8009e5:	f3 0f 1e fb          	endbr32 
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8009f5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ff:	b8 06 00 00 00       	mov    $0x6,%eax
  800a04:	e8 61 ff ff ff       	call   80096a <fsipc>
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <devfile_stat>:
{
  800a0b:	f3 0f 1e fb          	endbr32 
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	53                   	push   %ebx
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 40 0c             	mov    0xc(%eax),%eax
  800a1f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a24:	ba 00 00 00 00       	mov    $0x0,%edx
  800a29:	b8 05 00 00 00       	mov    $0x5,%eax
  800a2e:	e8 37 ff ff ff       	call   80096a <fsipc>
  800a33:	85 c0                	test   %eax,%eax
  800a35:	78 2c                	js     800a63 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	68 00 50 80 00       	push   $0x805000
  800a3f:	53                   	push   %ebx
  800a40:	e8 8c 0d 00 00       	call   8017d1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a45:	a1 80 50 80 00       	mov    0x805080,%eax
  800a4a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a50:	a1 84 50 80 00       	mov    0x805084,%eax
  800a55:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a66:	c9                   	leave  
  800a67:	c3                   	ret    

00800a68 <devfile_write>:
{
  800a68:	f3 0f 1e fb          	endbr32 
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a75:	8b 55 08             	mov    0x8(%ebp),%edx
  800a78:	8b 52 0c             	mov    0xc(%edx),%edx
  800a7b:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800a81:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a86:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a8b:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800a8e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a93:	50                   	push   %eax
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	68 08 50 80 00       	push   $0x805008
  800a9c:	e8 e6 0e 00 00       	call   801987 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa6:	b8 04 00 00 00       	mov    $0x4,%eax
  800aab:	e8 ba fe ff ff       	call   80096a <fsipc>
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <devfile_read>:
{
  800ab2:	f3 0f 1e fb          	endbr32 
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	56                   	push   %esi
  800aba:	53                   	push   %ebx
  800abb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8b 40 0c             	mov    0xc(%eax),%eax
  800ac4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ac9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800acf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ad9:	e8 8c fe ff ff       	call   80096a <fsipc>
  800ade:	89 c3                	mov    %eax,%ebx
  800ae0:	85 c0                	test   %eax,%eax
  800ae2:	78 1f                	js     800b03 <devfile_read+0x51>
	assert(r <= n);
  800ae4:	39 f0                	cmp    %esi,%eax
  800ae6:	77 24                	ja     800b0c <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800ae8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aed:	7f 33                	jg     800b22 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aef:	83 ec 04             	sub    $0x4,%esp
  800af2:	50                   	push   %eax
  800af3:	68 00 50 80 00       	push   $0x805000
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	e8 87 0e 00 00       	call   801987 <memmove>
	return r;
  800b00:	83 c4 10             	add    $0x10,%esp
}
  800b03:	89 d8                	mov    %ebx,%eax
  800b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    
	assert(r <= n);
  800b0c:	68 d0 1f 80 00       	push   $0x801fd0
  800b11:	68 d7 1f 80 00       	push   $0x801fd7
  800b16:	6a 7c                	push   $0x7c
  800b18:	68 ec 1f 80 00       	push   $0x801fec
  800b1d:	e8 be 05 00 00       	call   8010e0 <_panic>
	assert(r <= PGSIZE);
  800b22:	68 f7 1f 80 00       	push   $0x801ff7
  800b27:	68 d7 1f 80 00       	push   $0x801fd7
  800b2c:	6a 7d                	push   $0x7d
  800b2e:	68 ec 1f 80 00       	push   $0x801fec
  800b33:	e8 a8 05 00 00       	call   8010e0 <_panic>

00800b38 <open>:
{
  800b38:	f3 0f 1e fb          	endbr32 
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	56                   	push   %esi
  800b40:	53                   	push   %ebx
  800b41:	83 ec 1c             	sub    $0x1c,%esp
  800b44:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b47:	56                   	push   %esi
  800b48:	e8 41 0c 00 00       	call   80178e <strlen>
  800b4d:	83 c4 10             	add    $0x10,%esp
  800b50:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b55:	7f 6c                	jg     800bc3 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b57:	83 ec 0c             	sub    $0xc,%esp
  800b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b5d:	50                   	push   %eax
  800b5e:	e8 67 f8 ff ff       	call   8003ca <fd_alloc>
  800b63:	89 c3                	mov    %eax,%ebx
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	85 c0                	test   %eax,%eax
  800b6a:	78 3c                	js     800ba8 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	56                   	push   %esi
  800b70:	68 00 50 80 00       	push   $0x805000
  800b75:	e8 57 0c 00 00       	call   8017d1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b85:	b8 01 00 00 00       	mov    $0x1,%eax
  800b8a:	e8 db fd ff ff       	call   80096a <fsipc>
  800b8f:	89 c3                	mov    %eax,%ebx
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	85 c0                	test   %eax,%eax
  800b96:	78 19                	js     800bb1 <open+0x79>
	return fd2num(fd);
  800b98:	83 ec 0c             	sub    $0xc,%esp
  800b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9e:	e8 f8 f7 ff ff       	call   80039b <fd2num>
  800ba3:	89 c3                	mov    %eax,%ebx
  800ba5:	83 c4 10             	add    $0x10,%esp
}
  800ba8:	89 d8                	mov    %ebx,%eax
  800baa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    
		fd_close(fd, 0);
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	6a 00                	push   $0x0
  800bb6:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb9:	e8 10 f9 ff ff       	call   8004ce <fd_close>
		return r;
  800bbe:	83 c4 10             	add    $0x10,%esp
  800bc1:	eb e5                	jmp    800ba8 <open+0x70>
		return -E_BAD_PATH;
  800bc3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bc8:	eb de                	jmp    800ba8 <open+0x70>

00800bca <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bca:	f3 0f 1e fb          	endbr32 
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd9:	b8 08 00 00 00       	mov    $0x8,%eax
  800bde:	e8 87 fd ff ff       	call   80096a <fsipc>
}
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    

00800be5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800be5:	f3 0f 1e fb          	endbr32 
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bf1:	83 ec 0c             	sub    $0xc,%esp
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 b3 f7 ff ff       	call   8003af <fd2data>
  800bfc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bfe:	83 c4 08             	add    $0x8,%esp
  800c01:	68 03 20 80 00       	push   $0x802003
  800c06:	53                   	push   %ebx
  800c07:	e8 c5 0b 00 00       	call   8017d1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c0c:	8b 46 04             	mov    0x4(%esi),%eax
  800c0f:	2b 06                	sub    (%esi),%eax
  800c11:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c17:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c1e:	00 00 00 
	stat->st_dev = &devpipe;
  800c21:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  800c28:	30 80 00 
	return 0;
}
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c33:	5b                   	pop    %ebx
  800c34:	5e                   	pop    %esi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c37:	f3 0f 1e fb          	endbr32 
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	53                   	push   %ebx
  800c3f:	83 ec 0c             	sub    $0xc,%esp
  800c42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c45:	53                   	push   %ebx
  800c46:	6a 00                	push   $0x0
  800c48:	e8 ca f5 ff ff       	call   800217 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c4d:	89 1c 24             	mov    %ebx,(%esp)
  800c50:	e8 5a f7 ff ff       	call   8003af <fd2data>
  800c55:	83 c4 08             	add    $0x8,%esp
  800c58:	50                   	push   %eax
  800c59:	6a 00                	push   $0x0
  800c5b:	e8 b7 f5 ff ff       	call   800217 <sys_page_unmap>
}
  800c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <_pipeisclosed>:
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	57                   	push   %edi
  800c69:	56                   	push   %esi
  800c6a:	53                   	push   %ebx
  800c6b:	83 ec 1c             	sub    $0x1c,%esp
  800c6e:	89 c7                	mov    %eax,%edi
  800c70:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c72:	a1 04 40 80 00       	mov    0x804004,%eax
  800c77:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c7a:	83 ec 0c             	sub    $0xc,%esp
  800c7d:	57                   	push   %edi
  800c7e:	e8 da 0f 00 00       	call   801c5d <pageref>
  800c83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c86:	89 34 24             	mov    %esi,(%esp)
  800c89:	e8 cf 0f 00 00       	call   801c5d <pageref>
		nn = thisenv->env_runs;
  800c8e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c94:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c97:	83 c4 10             	add    $0x10,%esp
  800c9a:	39 cb                	cmp    %ecx,%ebx
  800c9c:	74 1b                	je     800cb9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c9e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ca1:	75 cf                	jne    800c72 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800ca3:	8b 42 58             	mov    0x58(%edx),%eax
  800ca6:	6a 01                	push   $0x1
  800ca8:	50                   	push   %eax
  800ca9:	53                   	push   %ebx
  800caa:	68 0a 20 80 00       	push   $0x80200a
  800caf:	e8 13 05 00 00       	call   8011c7 <cprintf>
  800cb4:	83 c4 10             	add    $0x10,%esp
  800cb7:	eb b9                	jmp    800c72 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800cb9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cbc:	0f 94 c0             	sete   %al
  800cbf:	0f b6 c0             	movzbl %al,%eax
}
  800cc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc5:	5b                   	pop    %ebx
  800cc6:	5e                   	pop    %esi
  800cc7:	5f                   	pop    %edi
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <devpipe_write>:
{
  800cca:	f3 0f 1e fb          	endbr32 
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	83 ec 28             	sub    $0x28,%esp
  800cd7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cda:	56                   	push   %esi
  800cdb:	e8 cf f6 ff ff       	call   8003af <fd2data>
  800ce0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800ce2:	83 c4 10             	add    $0x10,%esp
  800ce5:	bf 00 00 00 00       	mov    $0x0,%edi
  800cea:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800ced:	74 4f                	je     800d3e <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cef:	8b 43 04             	mov    0x4(%ebx),%eax
  800cf2:	8b 0b                	mov    (%ebx),%ecx
  800cf4:	8d 51 20             	lea    0x20(%ecx),%edx
  800cf7:	39 d0                	cmp    %edx,%eax
  800cf9:	72 14                	jb     800d0f <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800cfb:	89 da                	mov    %ebx,%edx
  800cfd:	89 f0                	mov    %esi,%eax
  800cff:	e8 61 ff ff ff       	call   800c65 <_pipeisclosed>
  800d04:	85 c0                	test   %eax,%eax
  800d06:	75 3b                	jne    800d43 <devpipe_write+0x79>
			sys_yield();
  800d08:	e8 5a f4 ff ff       	call   800167 <sys_yield>
  800d0d:	eb e0                	jmp    800cef <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d12:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d16:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d19:	89 c2                	mov    %eax,%edx
  800d1b:	c1 fa 1f             	sar    $0x1f,%edx
  800d1e:	89 d1                	mov    %edx,%ecx
  800d20:	c1 e9 1b             	shr    $0x1b,%ecx
  800d23:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d26:	83 e2 1f             	and    $0x1f,%edx
  800d29:	29 ca                	sub    %ecx,%edx
  800d2b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d2f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d33:	83 c0 01             	add    $0x1,%eax
  800d36:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d39:	83 c7 01             	add    $0x1,%edi
  800d3c:	eb ac                	jmp    800cea <devpipe_write+0x20>
	return i;
  800d3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d41:	eb 05                	jmp    800d48 <devpipe_write+0x7e>
				return 0;
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <devpipe_read>:
{
  800d50:	f3 0f 1e fb          	endbr32 
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 18             	sub    $0x18,%esp
  800d5d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d60:	57                   	push   %edi
  800d61:	e8 49 f6 ff ff       	call   8003af <fd2data>
  800d66:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d68:	83 c4 10             	add    $0x10,%esp
  800d6b:	be 00 00 00 00       	mov    $0x0,%esi
  800d70:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d73:	75 14                	jne    800d89 <devpipe_read+0x39>
	return i;
  800d75:	8b 45 10             	mov    0x10(%ebp),%eax
  800d78:	eb 02                	jmp    800d7c <devpipe_read+0x2c>
				return i;
  800d7a:	89 f0                	mov    %esi,%eax
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    
			sys_yield();
  800d84:	e8 de f3 ff ff       	call   800167 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d89:	8b 03                	mov    (%ebx),%eax
  800d8b:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d8e:	75 18                	jne    800da8 <devpipe_read+0x58>
			if (i > 0)
  800d90:	85 f6                	test   %esi,%esi
  800d92:	75 e6                	jne    800d7a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d94:	89 da                	mov    %ebx,%edx
  800d96:	89 f8                	mov    %edi,%eax
  800d98:	e8 c8 fe ff ff       	call   800c65 <_pipeisclosed>
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	74 e3                	je     800d84 <devpipe_read+0x34>
				return 0;
  800da1:	b8 00 00 00 00       	mov    $0x0,%eax
  800da6:	eb d4                	jmp    800d7c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800da8:	99                   	cltd   
  800da9:	c1 ea 1b             	shr    $0x1b,%edx
  800dac:	01 d0                	add    %edx,%eax
  800dae:	83 e0 1f             	and    $0x1f,%eax
  800db1:	29 d0                	sub    %edx,%eax
  800db3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800db8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800dbe:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800dc1:	83 c6 01             	add    $0x1,%esi
  800dc4:	eb aa                	jmp    800d70 <devpipe_read+0x20>

00800dc6 <pipe>:
{
  800dc6:	f3 0f 1e fb          	endbr32 
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
  800dcf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dd5:	50                   	push   %eax
  800dd6:	e8 ef f5 ff ff       	call   8003ca <fd_alloc>
  800ddb:	89 c3                	mov    %eax,%ebx
  800ddd:	83 c4 10             	add    $0x10,%esp
  800de0:	85 c0                	test   %eax,%eax
  800de2:	0f 88 23 01 00 00    	js     800f0b <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800de8:	83 ec 04             	sub    $0x4,%esp
  800deb:	68 07 04 00 00       	push   $0x407
  800df0:	ff 75 f4             	pushl  -0xc(%ebp)
  800df3:	6a 00                	push   $0x0
  800df5:	e8 90 f3 ff ff       	call   80018a <sys_page_alloc>
  800dfa:	89 c3                	mov    %eax,%ebx
  800dfc:	83 c4 10             	add    $0x10,%esp
  800dff:	85 c0                	test   %eax,%eax
  800e01:	0f 88 04 01 00 00    	js     800f0b <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 b7 f5 ff ff       	call   8003ca <fd_alloc>
  800e13:	89 c3                	mov    %eax,%ebx
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	0f 88 db 00 00 00    	js     800efb <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e20:	83 ec 04             	sub    $0x4,%esp
  800e23:	68 07 04 00 00       	push   $0x407
  800e28:	ff 75 f0             	pushl  -0x10(%ebp)
  800e2b:	6a 00                	push   $0x0
  800e2d:	e8 58 f3 ff ff       	call   80018a <sys_page_alloc>
  800e32:	89 c3                	mov    %eax,%ebx
  800e34:	83 c4 10             	add    $0x10,%esp
  800e37:	85 c0                	test   %eax,%eax
  800e39:	0f 88 bc 00 00 00    	js     800efb <pipe+0x135>
	va = fd2data(fd0);
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	ff 75 f4             	pushl  -0xc(%ebp)
  800e45:	e8 65 f5 ff ff       	call   8003af <fd2data>
  800e4a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e4c:	83 c4 0c             	add    $0xc,%esp
  800e4f:	68 07 04 00 00       	push   $0x407
  800e54:	50                   	push   %eax
  800e55:	6a 00                	push   $0x0
  800e57:	e8 2e f3 ff ff       	call   80018a <sys_page_alloc>
  800e5c:	89 c3                	mov    %eax,%ebx
  800e5e:	83 c4 10             	add    $0x10,%esp
  800e61:	85 c0                	test   %eax,%eax
  800e63:	0f 88 82 00 00 00    	js     800eeb <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e6f:	e8 3b f5 ff ff       	call   8003af <fd2data>
  800e74:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e7b:	50                   	push   %eax
  800e7c:	6a 00                	push   $0x0
  800e7e:	56                   	push   %esi
  800e7f:	6a 00                	push   $0x0
  800e81:	e8 4b f3 ff ff       	call   8001d1 <sys_page_map>
  800e86:	89 c3                	mov    %eax,%ebx
  800e88:	83 c4 20             	add    $0x20,%esp
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	78 4e                	js     800edd <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e8f:	a1 24 30 80 00       	mov    0x803024,%eax
  800e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e97:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800ea3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ea6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eab:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb8:	e8 de f4 ff ff       	call   80039b <fd2num>
  800ebd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800ec2:	83 c4 04             	add    $0x4,%esp
  800ec5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ec8:	e8 ce f4 ff ff       	call   80039b <fd2num>
  800ecd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ed3:	83 c4 10             	add    $0x10,%esp
  800ed6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edb:	eb 2e                	jmp    800f0b <pipe+0x145>
	sys_page_unmap(0, va);
  800edd:	83 ec 08             	sub    $0x8,%esp
  800ee0:	56                   	push   %esi
  800ee1:	6a 00                	push   $0x0
  800ee3:	e8 2f f3 ff ff       	call   800217 <sys_page_unmap>
  800ee8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800eeb:	83 ec 08             	sub    $0x8,%esp
  800eee:	ff 75 f0             	pushl  -0x10(%ebp)
  800ef1:	6a 00                	push   $0x0
  800ef3:	e8 1f f3 ff ff       	call   800217 <sys_page_unmap>
  800ef8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800efb:	83 ec 08             	sub    $0x8,%esp
  800efe:	ff 75 f4             	pushl  -0xc(%ebp)
  800f01:	6a 00                	push   $0x0
  800f03:	e8 0f f3 ff ff       	call   800217 <sys_page_unmap>
  800f08:	83 c4 10             	add    $0x10,%esp
}
  800f0b:	89 d8                	mov    %ebx,%eax
  800f0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <pipeisclosed>:
{
  800f14:	f3 0f 1e fb          	endbr32 
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f21:	50                   	push   %eax
  800f22:	ff 75 08             	pushl  0x8(%ebp)
  800f25:	e8 f6 f4 ff ff       	call   800420 <fd_lookup>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	78 18                	js     800f49 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	ff 75 f4             	pushl  -0xc(%ebp)
  800f37:	e8 73 f4 ff ff       	call   8003af <fd2data>
  800f3c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f41:	e8 1f fd ff ff       	call   800c65 <_pipeisclosed>
  800f46:	83 c4 10             	add    $0x10,%esp
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f4b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f54:	c3                   	ret    

00800f55 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f55:	f3 0f 1e fb          	endbr32 
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f5f:	68 22 20 80 00       	push   $0x802022
  800f64:	ff 75 0c             	pushl  0xc(%ebp)
  800f67:	e8 65 08 00 00       	call   8017d1 <strcpy>
	return 0;
}
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <devcons_write>:
{
  800f73:	f3 0f 1e fb          	endbr32 
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
  800f7d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f83:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f88:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f8e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f91:	73 31                	jae    800fc4 <devcons_write+0x51>
		m = n - tot;
  800f93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f96:	29 f3                	sub    %esi,%ebx
  800f98:	83 fb 7f             	cmp    $0x7f,%ebx
  800f9b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800fa0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800fa3:	83 ec 04             	sub    $0x4,%esp
  800fa6:	53                   	push   %ebx
  800fa7:	89 f0                	mov    %esi,%eax
  800fa9:	03 45 0c             	add    0xc(%ebp),%eax
  800fac:	50                   	push   %eax
  800fad:	57                   	push   %edi
  800fae:	e8 d4 09 00 00       	call   801987 <memmove>
		sys_cputs(buf, m);
  800fb3:	83 c4 08             	add    $0x8,%esp
  800fb6:	53                   	push   %ebx
  800fb7:	57                   	push   %edi
  800fb8:	e8 fd f0 ff ff       	call   8000ba <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fbd:	01 de                	add    %ebx,%esi
  800fbf:	83 c4 10             	add    $0x10,%esp
  800fc2:	eb ca                	jmp    800f8e <devcons_write+0x1b>
}
  800fc4:	89 f0                	mov    %esi,%eax
  800fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    

00800fce <devcons_read>:
{
  800fce:	f3 0f 1e fb          	endbr32 
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 08             	sub    $0x8,%esp
  800fd8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800fdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe1:	74 21                	je     801004 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800fe3:	e8 f4 f0 ff ff       	call   8000dc <sys_cgetc>
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	75 07                	jne    800ff3 <devcons_read+0x25>
		sys_yield();
  800fec:	e8 76 f1 ff ff       	call   800167 <sys_yield>
  800ff1:	eb f0                	jmp    800fe3 <devcons_read+0x15>
	if (c < 0)
  800ff3:	78 0f                	js     801004 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800ff5:	83 f8 04             	cmp    $0x4,%eax
  800ff8:	74 0c                	je     801006 <devcons_read+0x38>
	*(char*)vbuf = c;
  800ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffd:	88 02                	mov    %al,(%edx)
	return 1;
  800fff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    
		return 0;
  801006:	b8 00 00 00 00       	mov    $0x0,%eax
  80100b:	eb f7                	jmp    801004 <devcons_read+0x36>

0080100d <cputchar>:
{
  80100d:	f3 0f 1e fb          	endbr32 
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80101d:	6a 01                	push   $0x1
  80101f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801022:	50                   	push   %eax
  801023:	e8 92 f0 ff ff       	call   8000ba <sys_cputs>
}
  801028:	83 c4 10             	add    $0x10,%esp
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <getchar>:
{
  80102d:	f3 0f 1e fb          	endbr32 
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801037:	6a 01                	push   $0x1
  801039:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80103c:	50                   	push   %eax
  80103d:	6a 00                	push   $0x0
  80103f:	e8 5f f6 ff ff       	call   8006a3 <read>
	if (r < 0)
  801044:	83 c4 10             	add    $0x10,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	78 06                	js     801051 <getchar+0x24>
	if (r < 1)
  80104b:	74 06                	je     801053 <getchar+0x26>
	return c;
  80104d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    
		return -E_EOF;
  801053:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801058:	eb f7                	jmp    801051 <getchar+0x24>

0080105a <iscons>:
{
  80105a:	f3 0f 1e fb          	endbr32 
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801064:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801067:	50                   	push   %eax
  801068:	ff 75 08             	pushl  0x8(%ebp)
  80106b:	e8 b0 f3 ff ff       	call   800420 <fd_lookup>
  801070:	83 c4 10             	add    $0x10,%esp
  801073:	85 c0                	test   %eax,%eax
  801075:	78 11                	js     801088 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107a:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801080:	39 10                	cmp    %edx,(%eax)
  801082:	0f 94 c0             	sete   %al
  801085:	0f b6 c0             	movzbl %al,%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <opencons>:
{
  80108a:	f3 0f 1e fb          	endbr32 
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801094:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801097:	50                   	push   %eax
  801098:	e8 2d f3 ff ff       	call   8003ca <fd_alloc>
  80109d:	83 c4 10             	add    $0x10,%esp
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	78 3a                	js     8010de <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010a4:	83 ec 04             	sub    $0x4,%esp
  8010a7:	68 07 04 00 00       	push   $0x407
  8010ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8010af:	6a 00                	push   $0x0
  8010b1:	e8 d4 f0 ff ff       	call   80018a <sys_page_alloc>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	78 21                	js     8010de <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c0:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8010c6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010cb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010d2:	83 ec 0c             	sub    $0xc,%esp
  8010d5:	50                   	push   %eax
  8010d6:	e8 c0 f2 ff ff       	call   80039b <fd2num>
  8010db:	83 c4 10             	add    $0x10,%esp
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010e0:	f3 0f 1e fb          	endbr32 
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010e9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010ec:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8010f2:	e8 4d f0 ff ff       	call   800144 <sys_getenvid>
  8010f7:	83 ec 0c             	sub    $0xc,%esp
  8010fa:	ff 75 0c             	pushl  0xc(%ebp)
  8010fd:	ff 75 08             	pushl  0x8(%ebp)
  801100:	56                   	push   %esi
  801101:	50                   	push   %eax
  801102:	68 30 20 80 00       	push   $0x802030
  801107:	e8 bb 00 00 00       	call   8011c7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80110c:	83 c4 18             	add    $0x18,%esp
  80110f:	53                   	push   %ebx
  801110:	ff 75 10             	pushl  0x10(%ebp)
  801113:	e8 5a 00 00 00       	call   801172 <vcprintf>
	cprintf("\n");
  801118:	c7 04 24 78 23 80 00 	movl   $0x802378,(%esp)
  80111f:	e8 a3 00 00 00       	call   8011c7 <cprintf>
  801124:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801127:	cc                   	int3   
  801128:	eb fd                	jmp    801127 <_panic+0x47>

0080112a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80112a:	f3 0f 1e fb          	endbr32 
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	53                   	push   %ebx
  801132:	83 ec 04             	sub    $0x4,%esp
  801135:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801138:	8b 13                	mov    (%ebx),%edx
  80113a:	8d 42 01             	lea    0x1(%edx),%eax
  80113d:	89 03                	mov    %eax,(%ebx)
  80113f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801142:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801146:	3d ff 00 00 00       	cmp    $0xff,%eax
  80114b:	74 09                	je     801156 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80114d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801154:	c9                   	leave  
  801155:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801156:	83 ec 08             	sub    $0x8,%esp
  801159:	68 ff 00 00 00       	push   $0xff
  80115e:	8d 43 08             	lea    0x8(%ebx),%eax
  801161:	50                   	push   %eax
  801162:	e8 53 ef ff ff       	call   8000ba <sys_cputs>
		b->idx = 0;
  801167:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80116d:	83 c4 10             	add    $0x10,%esp
  801170:	eb db                	jmp    80114d <putch+0x23>

00801172 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801172:	f3 0f 1e fb          	endbr32 
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80117f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801186:	00 00 00 
	b.cnt = 0;
  801189:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801190:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	ff 75 08             	pushl  0x8(%ebp)
  801199:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80119f:	50                   	push   %eax
  8011a0:	68 2a 11 80 00       	push   $0x80112a
  8011a5:	e8 20 01 00 00       	call   8012ca <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011aa:	83 c4 08             	add    $0x8,%esp
  8011ad:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8011b3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011b9:	50                   	push   %eax
  8011ba:	e8 fb ee ff ff       	call   8000ba <sys_cputs>

	return b.cnt;
}
  8011bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011c7:	f3 0f 1e fb          	endbr32 
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011d1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011d4:	50                   	push   %eax
  8011d5:	ff 75 08             	pushl  0x8(%ebp)
  8011d8:	e8 95 ff ff ff       	call   801172 <vcprintf>
	va_end(ap);

	return cnt;
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	57                   	push   %edi
  8011e3:	56                   	push   %esi
  8011e4:	53                   	push   %ebx
  8011e5:	83 ec 1c             	sub    $0x1c,%esp
  8011e8:	89 c7                	mov    %eax,%edi
  8011ea:	89 d6                	mov    %edx,%esi
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f2:	89 d1                	mov    %edx,%ecx
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011f9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801202:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801205:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80120c:	39 c2                	cmp    %eax,%edx
  80120e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801211:	72 3e                	jb     801251 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	ff 75 18             	pushl  0x18(%ebp)
  801219:	83 eb 01             	sub    $0x1,%ebx
  80121c:	53                   	push   %ebx
  80121d:	50                   	push   %eax
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 e4             	pushl  -0x1c(%ebp)
  801224:	ff 75 e0             	pushl  -0x20(%ebp)
  801227:	ff 75 dc             	pushl  -0x24(%ebp)
  80122a:	ff 75 d8             	pushl  -0x28(%ebp)
  80122d:	e8 6e 0a 00 00       	call   801ca0 <__udivdi3>
  801232:	83 c4 18             	add    $0x18,%esp
  801235:	52                   	push   %edx
  801236:	50                   	push   %eax
  801237:	89 f2                	mov    %esi,%edx
  801239:	89 f8                	mov    %edi,%eax
  80123b:	e8 9f ff ff ff       	call   8011df <printnum>
  801240:	83 c4 20             	add    $0x20,%esp
  801243:	eb 13                	jmp    801258 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801245:	83 ec 08             	sub    $0x8,%esp
  801248:	56                   	push   %esi
  801249:	ff 75 18             	pushl  0x18(%ebp)
  80124c:	ff d7                	call   *%edi
  80124e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801251:	83 eb 01             	sub    $0x1,%ebx
  801254:	85 db                	test   %ebx,%ebx
  801256:	7f ed                	jg     801245 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	56                   	push   %esi
  80125c:	83 ec 04             	sub    $0x4,%esp
  80125f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801262:	ff 75 e0             	pushl  -0x20(%ebp)
  801265:	ff 75 dc             	pushl  -0x24(%ebp)
  801268:	ff 75 d8             	pushl  -0x28(%ebp)
  80126b:	e8 40 0b 00 00       	call   801db0 <__umoddi3>
  801270:	83 c4 14             	add    $0x14,%esp
  801273:	0f be 80 53 20 80 00 	movsbl 0x802053(%eax),%eax
  80127a:	50                   	push   %eax
  80127b:	ff d7                	call   *%edi
}
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801283:	5b                   	pop    %ebx
  801284:	5e                   	pop    %esi
  801285:	5f                   	pop    %edi
  801286:	5d                   	pop    %ebp
  801287:	c3                   	ret    

00801288 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801288:	f3 0f 1e fb          	endbr32 
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801292:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801296:	8b 10                	mov    (%eax),%edx
  801298:	3b 50 04             	cmp    0x4(%eax),%edx
  80129b:	73 0a                	jae    8012a7 <sprintputch+0x1f>
		*b->buf++ = ch;
  80129d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a0:	89 08                	mov    %ecx,(%eax)
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	88 02                	mov    %al,(%edx)
}
  8012a7:	5d                   	pop    %ebp
  8012a8:	c3                   	ret    

008012a9 <printfmt>:
{
  8012a9:	f3 0f 1e fb          	endbr32 
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012b3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012b6:	50                   	push   %eax
  8012b7:	ff 75 10             	pushl  0x10(%ebp)
  8012ba:	ff 75 0c             	pushl  0xc(%ebp)
  8012bd:	ff 75 08             	pushl  0x8(%ebp)
  8012c0:	e8 05 00 00 00       	call   8012ca <vprintfmt>
}
  8012c5:	83 c4 10             	add    $0x10,%esp
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <vprintfmt>:
{
  8012ca:	f3 0f 1e fb          	endbr32 
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	57                   	push   %edi
  8012d2:	56                   	push   %esi
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 3c             	sub    $0x3c,%esp
  8012d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012dd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012e0:	e9 8e 03 00 00       	jmp    801673 <vprintfmt+0x3a9>
		padc = ' ';
  8012e5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012e9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012f0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012fe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801303:	8d 47 01             	lea    0x1(%edi),%eax
  801306:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801309:	0f b6 17             	movzbl (%edi),%edx
  80130c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80130f:	3c 55                	cmp    $0x55,%al
  801311:	0f 87 df 03 00 00    	ja     8016f6 <vprintfmt+0x42c>
  801317:	0f b6 c0             	movzbl %al,%eax
  80131a:	3e ff 24 85 a0 21 80 	notrack jmp *0x8021a0(,%eax,4)
  801321:	00 
  801322:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801325:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801329:	eb d8                	jmp    801303 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80132b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80132e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801332:	eb cf                	jmp    801303 <vprintfmt+0x39>
  801334:	0f b6 d2             	movzbl %dl,%edx
  801337:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80133a:	b8 00 00 00 00       	mov    $0x0,%eax
  80133f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801342:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801345:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801349:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80134c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80134f:	83 f9 09             	cmp    $0x9,%ecx
  801352:	77 55                	ja     8013a9 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801354:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801357:	eb e9                	jmp    801342 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801359:	8b 45 14             	mov    0x14(%ebp),%eax
  80135c:	8b 00                	mov    (%eax),%eax
  80135e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	8d 40 04             	lea    0x4(%eax),%eax
  801367:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80136a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80136d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801371:	79 90                	jns    801303 <vprintfmt+0x39>
				width = precision, precision = -1;
  801373:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801376:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801379:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801380:	eb 81                	jmp    801303 <vprintfmt+0x39>
  801382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801385:	85 c0                	test   %eax,%eax
  801387:	ba 00 00 00 00       	mov    $0x0,%edx
  80138c:	0f 49 d0             	cmovns %eax,%edx
  80138f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801392:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801395:	e9 69 ff ff ff       	jmp    801303 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80139a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80139d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013a4:	e9 5a ff ff ff       	jmp    801303 <vprintfmt+0x39>
  8013a9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013af:	eb bc                	jmp    80136d <vprintfmt+0xa3>
			lflag++;
  8013b1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013b7:	e9 47 ff ff ff       	jmp    801303 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bf:	8d 78 04             	lea    0x4(%eax),%edi
  8013c2:	83 ec 08             	sub    $0x8,%esp
  8013c5:	53                   	push   %ebx
  8013c6:	ff 30                	pushl  (%eax)
  8013c8:	ff d6                	call   *%esi
			break;
  8013ca:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013cd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013d0:	e9 9b 02 00 00       	jmp    801670 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8013d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d8:	8d 78 04             	lea    0x4(%eax),%edi
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	99                   	cltd   
  8013de:	31 d0                	xor    %edx,%eax
  8013e0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013e2:	83 f8 0f             	cmp    $0xf,%eax
  8013e5:	7f 23                	jg     80140a <vprintfmt+0x140>
  8013e7:	8b 14 85 00 23 80 00 	mov    0x802300(,%eax,4),%edx
  8013ee:	85 d2                	test   %edx,%edx
  8013f0:	74 18                	je     80140a <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8013f2:	52                   	push   %edx
  8013f3:	68 e9 1f 80 00       	push   $0x801fe9
  8013f8:	53                   	push   %ebx
  8013f9:	56                   	push   %esi
  8013fa:	e8 aa fe ff ff       	call   8012a9 <printfmt>
  8013ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801402:	89 7d 14             	mov    %edi,0x14(%ebp)
  801405:	e9 66 02 00 00       	jmp    801670 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80140a:	50                   	push   %eax
  80140b:	68 6b 20 80 00       	push   $0x80206b
  801410:	53                   	push   %ebx
  801411:	56                   	push   %esi
  801412:	e8 92 fe ff ff       	call   8012a9 <printfmt>
  801417:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80141a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80141d:	e9 4e 02 00 00       	jmp    801670 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801422:	8b 45 14             	mov    0x14(%ebp),%eax
  801425:	83 c0 04             	add    $0x4,%eax
  801428:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80142b:	8b 45 14             	mov    0x14(%ebp),%eax
  80142e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801430:	85 d2                	test   %edx,%edx
  801432:	b8 64 20 80 00       	mov    $0x802064,%eax
  801437:	0f 45 c2             	cmovne %edx,%eax
  80143a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80143d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801441:	7e 06                	jle    801449 <vprintfmt+0x17f>
  801443:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801447:	75 0d                	jne    801456 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801449:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80144c:	89 c7                	mov    %eax,%edi
  80144e:	03 45 e0             	add    -0x20(%ebp),%eax
  801451:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801454:	eb 55                	jmp    8014ab <vprintfmt+0x1e1>
  801456:	83 ec 08             	sub    $0x8,%esp
  801459:	ff 75 d8             	pushl  -0x28(%ebp)
  80145c:	ff 75 cc             	pushl  -0x34(%ebp)
  80145f:	e8 46 03 00 00       	call   8017aa <strnlen>
  801464:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801467:	29 c2                	sub    %eax,%edx
  801469:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801471:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801475:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801478:	85 ff                	test   %edi,%edi
  80147a:	7e 11                	jle    80148d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	53                   	push   %ebx
  801480:	ff 75 e0             	pushl  -0x20(%ebp)
  801483:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801485:	83 ef 01             	sub    $0x1,%edi
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	eb eb                	jmp    801478 <vprintfmt+0x1ae>
  80148d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801490:	85 d2                	test   %edx,%edx
  801492:	b8 00 00 00 00       	mov    $0x0,%eax
  801497:	0f 49 c2             	cmovns %edx,%eax
  80149a:	29 c2                	sub    %eax,%edx
  80149c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80149f:	eb a8                	jmp    801449 <vprintfmt+0x17f>
					putch(ch, putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	53                   	push   %ebx
  8014a5:	52                   	push   %edx
  8014a6:	ff d6                	call   *%esi
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014ae:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014b0:	83 c7 01             	add    $0x1,%edi
  8014b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014b7:	0f be d0             	movsbl %al,%edx
  8014ba:	85 d2                	test   %edx,%edx
  8014bc:	74 4b                	je     801509 <vprintfmt+0x23f>
  8014be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014c2:	78 06                	js     8014ca <vprintfmt+0x200>
  8014c4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014c8:	78 1e                	js     8014e8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014ce:	74 d1                	je     8014a1 <vprintfmt+0x1d7>
  8014d0:	0f be c0             	movsbl %al,%eax
  8014d3:	83 e8 20             	sub    $0x20,%eax
  8014d6:	83 f8 5e             	cmp    $0x5e,%eax
  8014d9:	76 c6                	jbe    8014a1 <vprintfmt+0x1d7>
					putch('?', putdat);
  8014db:	83 ec 08             	sub    $0x8,%esp
  8014de:	53                   	push   %ebx
  8014df:	6a 3f                	push   $0x3f
  8014e1:	ff d6                	call   *%esi
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	eb c3                	jmp    8014ab <vprintfmt+0x1e1>
  8014e8:	89 cf                	mov    %ecx,%edi
  8014ea:	eb 0e                	jmp    8014fa <vprintfmt+0x230>
				putch(' ', putdat);
  8014ec:	83 ec 08             	sub    $0x8,%esp
  8014ef:	53                   	push   %ebx
  8014f0:	6a 20                	push   $0x20
  8014f2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8014f4:	83 ef 01             	sub    $0x1,%edi
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	85 ff                	test   %edi,%edi
  8014fc:	7f ee                	jg     8014ec <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8014fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801501:	89 45 14             	mov    %eax,0x14(%ebp)
  801504:	e9 67 01 00 00       	jmp    801670 <vprintfmt+0x3a6>
  801509:	89 cf                	mov    %ecx,%edi
  80150b:	eb ed                	jmp    8014fa <vprintfmt+0x230>
	if (lflag >= 2)
  80150d:	83 f9 01             	cmp    $0x1,%ecx
  801510:	7f 1b                	jg     80152d <vprintfmt+0x263>
	else if (lflag)
  801512:	85 c9                	test   %ecx,%ecx
  801514:	74 63                	je     801579 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801516:	8b 45 14             	mov    0x14(%ebp),%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80151e:	99                   	cltd   
  80151f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801522:	8b 45 14             	mov    0x14(%ebp),%eax
  801525:	8d 40 04             	lea    0x4(%eax),%eax
  801528:	89 45 14             	mov    %eax,0x14(%ebp)
  80152b:	eb 17                	jmp    801544 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80152d:	8b 45 14             	mov    0x14(%ebp),%eax
  801530:	8b 50 04             	mov    0x4(%eax),%edx
  801533:	8b 00                	mov    (%eax),%eax
  801535:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801538:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80153b:	8b 45 14             	mov    0x14(%ebp),%eax
  80153e:	8d 40 08             	lea    0x8(%eax),%eax
  801541:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801544:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801547:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80154a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80154f:	85 c9                	test   %ecx,%ecx
  801551:	0f 89 ff 00 00 00    	jns    801656 <vprintfmt+0x38c>
				putch('-', putdat);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	53                   	push   %ebx
  80155b:	6a 2d                	push   $0x2d
  80155d:	ff d6                	call   *%esi
				num = -(long long) num;
  80155f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801562:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801565:	f7 da                	neg    %edx
  801567:	83 d1 00             	adc    $0x0,%ecx
  80156a:	f7 d9                	neg    %ecx
  80156c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80156f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801574:	e9 dd 00 00 00       	jmp    801656 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801579:	8b 45 14             	mov    0x14(%ebp),%eax
  80157c:	8b 00                	mov    (%eax),%eax
  80157e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801581:	99                   	cltd   
  801582:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8d 40 04             	lea    0x4(%eax),%eax
  80158b:	89 45 14             	mov    %eax,0x14(%ebp)
  80158e:	eb b4                	jmp    801544 <vprintfmt+0x27a>
	if (lflag >= 2)
  801590:	83 f9 01             	cmp    $0x1,%ecx
  801593:	7f 1e                	jg     8015b3 <vprintfmt+0x2e9>
	else if (lflag)
  801595:	85 c9                	test   %ecx,%ecx
  801597:	74 32                	je     8015cb <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801599:	8b 45 14             	mov    0x14(%ebp),%eax
  80159c:	8b 10                	mov    (%eax),%edx
  80159e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015a3:	8d 40 04             	lea    0x4(%eax),%eax
  8015a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015a9:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8015ae:	e9 a3 00 00 00       	jmp    801656 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b6:	8b 10                	mov    (%eax),%edx
  8015b8:	8b 48 04             	mov    0x4(%eax),%ecx
  8015bb:	8d 40 08             	lea    0x8(%eax),%eax
  8015be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015c1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015c6:	e9 8b 00 00 00       	jmp    801656 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ce:	8b 10                	mov    (%eax),%edx
  8015d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015d5:	8d 40 04             	lea    0x4(%eax),%eax
  8015d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015db:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8015e0:	eb 74                	jmp    801656 <vprintfmt+0x38c>
	if (lflag >= 2)
  8015e2:	83 f9 01             	cmp    $0x1,%ecx
  8015e5:	7f 1b                	jg     801602 <vprintfmt+0x338>
	else if (lflag)
  8015e7:	85 c9                	test   %ecx,%ecx
  8015e9:	74 2c                	je     801617 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8015eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ee:	8b 10                	mov    (%eax),%edx
  8015f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015f5:	8d 40 04             	lea    0x4(%eax),%eax
  8015f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015fb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801600:	eb 54                	jmp    801656 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801602:	8b 45 14             	mov    0x14(%ebp),%eax
  801605:	8b 10                	mov    (%eax),%edx
  801607:	8b 48 04             	mov    0x4(%eax),%ecx
  80160a:	8d 40 08             	lea    0x8(%eax),%eax
  80160d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801610:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801615:	eb 3f                	jmp    801656 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801617:	8b 45 14             	mov    0x14(%ebp),%eax
  80161a:	8b 10                	mov    (%eax),%edx
  80161c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801621:	8d 40 04             	lea    0x4(%eax),%eax
  801624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801627:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80162c:	eb 28                	jmp    801656 <vprintfmt+0x38c>
			putch('0', putdat);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	53                   	push   %ebx
  801632:	6a 30                	push   $0x30
  801634:	ff d6                	call   *%esi
			putch('x', putdat);
  801636:	83 c4 08             	add    $0x8,%esp
  801639:	53                   	push   %ebx
  80163a:	6a 78                	push   $0x78
  80163c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80163e:	8b 45 14             	mov    0x14(%ebp),%eax
  801641:	8b 10                	mov    (%eax),%edx
  801643:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801648:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80164b:	8d 40 04             	lea    0x4(%eax),%eax
  80164e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801651:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80165d:	57                   	push   %edi
  80165e:	ff 75 e0             	pushl  -0x20(%ebp)
  801661:	50                   	push   %eax
  801662:	51                   	push   %ecx
  801663:	52                   	push   %edx
  801664:	89 da                	mov    %ebx,%edx
  801666:	89 f0                	mov    %esi,%eax
  801668:	e8 72 fb ff ff       	call   8011df <printnum>
			break;
  80166d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801670:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801673:	83 c7 01             	add    $0x1,%edi
  801676:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80167a:	83 f8 25             	cmp    $0x25,%eax
  80167d:	0f 84 62 fc ff ff    	je     8012e5 <vprintfmt+0x1b>
			if (ch == '\0')
  801683:	85 c0                	test   %eax,%eax
  801685:	0f 84 8b 00 00 00    	je     801716 <vprintfmt+0x44c>
			putch(ch, putdat);
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	53                   	push   %ebx
  80168f:	50                   	push   %eax
  801690:	ff d6                	call   *%esi
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	eb dc                	jmp    801673 <vprintfmt+0x3a9>
	if (lflag >= 2)
  801697:	83 f9 01             	cmp    $0x1,%ecx
  80169a:	7f 1b                	jg     8016b7 <vprintfmt+0x3ed>
	else if (lflag)
  80169c:	85 c9                	test   %ecx,%ecx
  80169e:	74 2c                	je     8016cc <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8016a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a3:	8b 10                	mov    (%eax),%edx
  8016a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016aa:	8d 40 04             	lea    0x4(%eax),%eax
  8016ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016b0:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8016b5:	eb 9f                	jmp    801656 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 10                	mov    (%eax),%edx
  8016bc:	8b 48 04             	mov    0x4(%eax),%ecx
  8016bf:	8d 40 08             	lea    0x8(%eax),%eax
  8016c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016c5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016ca:	eb 8a                	jmp    801656 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cf:	8b 10                	mov    (%eax),%edx
  8016d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d6:	8d 40 04             	lea    0x4(%eax),%eax
  8016d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016dc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8016e1:	e9 70 ff ff ff       	jmp    801656 <vprintfmt+0x38c>
			putch(ch, putdat);
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	53                   	push   %ebx
  8016ea:	6a 25                	push   $0x25
  8016ec:	ff d6                	call   *%esi
			break;
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	e9 7a ff ff ff       	jmp    801670 <vprintfmt+0x3a6>
			putch('%', putdat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	53                   	push   %ebx
  8016fa:	6a 25                	push   $0x25
  8016fc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	89 f8                	mov    %edi,%eax
  801703:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801707:	74 05                	je     80170e <vprintfmt+0x444>
  801709:	83 e8 01             	sub    $0x1,%eax
  80170c:	eb f5                	jmp    801703 <vprintfmt+0x439>
  80170e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801711:	e9 5a ff ff ff       	jmp    801670 <vprintfmt+0x3a6>
}
  801716:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801719:	5b                   	pop    %ebx
  80171a:	5e                   	pop    %esi
  80171b:	5f                   	pop    %edi
  80171c:	5d                   	pop    %ebp
  80171d:	c3                   	ret    

0080171e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80171e:	f3 0f 1e fb          	endbr32 
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 18             	sub    $0x18,%esp
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80172e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801731:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801735:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801738:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80173f:	85 c0                	test   %eax,%eax
  801741:	74 26                	je     801769 <vsnprintf+0x4b>
  801743:	85 d2                	test   %edx,%edx
  801745:	7e 22                	jle    801769 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801747:	ff 75 14             	pushl  0x14(%ebp)
  80174a:	ff 75 10             	pushl  0x10(%ebp)
  80174d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801750:	50                   	push   %eax
  801751:	68 88 12 80 00       	push   $0x801288
  801756:	e8 6f fb ff ff       	call   8012ca <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80175b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801764:	83 c4 10             	add    $0x10,%esp
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    
		return -E_INVAL;
  801769:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176e:	eb f7                	jmp    801767 <vsnprintf+0x49>

00801770 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801770:	f3 0f 1e fb          	endbr32 
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80177a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80177d:	50                   	push   %eax
  80177e:	ff 75 10             	pushl  0x10(%ebp)
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	ff 75 08             	pushl  0x8(%ebp)
  801787:	e8 92 ff ff ff       	call   80171e <vsnprintf>
	va_end(ap);

	return rc;
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80178e:	f3 0f 1e fb          	endbr32 
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801798:	b8 00 00 00 00       	mov    $0x0,%eax
  80179d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8017a1:	74 05                	je     8017a8 <strlen+0x1a>
		n++;
  8017a3:	83 c0 01             	add    $0x1,%eax
  8017a6:	eb f5                	jmp    80179d <strlen+0xf>
	return n;
}
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    

008017aa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017aa:	f3 0f 1e fb          	endbr32 
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bc:	39 d0                	cmp    %edx,%eax
  8017be:	74 0d                	je     8017cd <strnlen+0x23>
  8017c0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017c4:	74 05                	je     8017cb <strnlen+0x21>
		n++;
  8017c6:	83 c0 01             	add    $0x1,%eax
  8017c9:	eb f1                	jmp    8017bc <strnlen+0x12>
  8017cb:	89 c2                	mov    %eax,%edx
	return n;
}
  8017cd:	89 d0                	mov    %edx,%eax
  8017cf:	5d                   	pop    %ebp
  8017d0:	c3                   	ret    

008017d1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017d1:	f3 0f 1e fb          	endbr32 
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8017e8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8017eb:	83 c0 01             	add    $0x1,%eax
  8017ee:	84 d2                	test   %dl,%dl
  8017f0:	75 f2                	jne    8017e4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8017f2:	89 c8                	mov    %ecx,%eax
  8017f4:	5b                   	pop    %ebx
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    

008017f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8017f7:	f3 0f 1e fb          	endbr32 
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	53                   	push   %ebx
  8017ff:	83 ec 10             	sub    $0x10,%esp
  801802:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801805:	53                   	push   %ebx
  801806:	e8 83 ff ff ff       	call   80178e <strlen>
  80180b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	01 d8                	add    %ebx,%eax
  801813:	50                   	push   %eax
  801814:	e8 b8 ff ff ff       	call   8017d1 <strcpy>
	return dst;
}
  801819:	89 d8                	mov    %ebx,%eax
  80181b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801820:	f3 0f 1e fb          	endbr32 
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	56                   	push   %esi
  801828:	53                   	push   %ebx
  801829:	8b 75 08             	mov    0x8(%ebp),%esi
  80182c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182f:	89 f3                	mov    %esi,%ebx
  801831:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801834:	89 f0                	mov    %esi,%eax
  801836:	39 d8                	cmp    %ebx,%eax
  801838:	74 11                	je     80184b <strncpy+0x2b>
		*dst++ = *src;
  80183a:	83 c0 01             	add    $0x1,%eax
  80183d:	0f b6 0a             	movzbl (%edx),%ecx
  801840:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801843:	80 f9 01             	cmp    $0x1,%cl
  801846:	83 da ff             	sbb    $0xffffffff,%edx
  801849:	eb eb                	jmp    801836 <strncpy+0x16>
	}
	return ret;
}
  80184b:	89 f0                	mov    %esi,%eax
  80184d:	5b                   	pop    %ebx
  80184e:	5e                   	pop    %esi
  80184f:	5d                   	pop    %ebp
  801850:	c3                   	ret    

00801851 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801851:	f3 0f 1e fb          	endbr32 
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	8b 75 08             	mov    0x8(%ebp),%esi
  80185d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801860:	8b 55 10             	mov    0x10(%ebp),%edx
  801863:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801865:	85 d2                	test   %edx,%edx
  801867:	74 21                	je     80188a <strlcpy+0x39>
  801869:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80186d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80186f:	39 c2                	cmp    %eax,%edx
  801871:	74 14                	je     801887 <strlcpy+0x36>
  801873:	0f b6 19             	movzbl (%ecx),%ebx
  801876:	84 db                	test   %bl,%bl
  801878:	74 0b                	je     801885 <strlcpy+0x34>
			*dst++ = *src++;
  80187a:	83 c1 01             	add    $0x1,%ecx
  80187d:	83 c2 01             	add    $0x1,%edx
  801880:	88 5a ff             	mov    %bl,-0x1(%edx)
  801883:	eb ea                	jmp    80186f <strlcpy+0x1e>
  801885:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801887:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80188a:	29 f0                	sub    %esi,%eax
}
  80188c:	5b                   	pop    %ebx
  80188d:	5e                   	pop    %esi
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    

00801890 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801890:	f3 0f 1e fb          	endbr32 
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80189d:	0f b6 01             	movzbl (%ecx),%eax
  8018a0:	84 c0                	test   %al,%al
  8018a2:	74 0c                	je     8018b0 <strcmp+0x20>
  8018a4:	3a 02                	cmp    (%edx),%al
  8018a6:	75 08                	jne    8018b0 <strcmp+0x20>
		p++, q++;
  8018a8:	83 c1 01             	add    $0x1,%ecx
  8018ab:	83 c2 01             	add    $0x1,%edx
  8018ae:	eb ed                	jmp    80189d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018b0:	0f b6 c0             	movzbl %al,%eax
  8018b3:	0f b6 12             	movzbl (%edx),%edx
  8018b6:	29 d0                	sub    %edx,%eax
}
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    

008018ba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018ba:	f3 0f 1e fb          	endbr32 
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c8:	89 c3                	mov    %eax,%ebx
  8018ca:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018cd:	eb 06                	jmp    8018d5 <strncmp+0x1b>
		n--, p++, q++;
  8018cf:	83 c0 01             	add    $0x1,%eax
  8018d2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8018d5:	39 d8                	cmp    %ebx,%eax
  8018d7:	74 16                	je     8018ef <strncmp+0x35>
  8018d9:	0f b6 08             	movzbl (%eax),%ecx
  8018dc:	84 c9                	test   %cl,%cl
  8018de:	74 04                	je     8018e4 <strncmp+0x2a>
  8018e0:	3a 0a                	cmp    (%edx),%cl
  8018e2:	74 eb                	je     8018cf <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018e4:	0f b6 00             	movzbl (%eax),%eax
  8018e7:	0f b6 12             	movzbl (%edx),%edx
  8018ea:	29 d0                	sub    %edx,%eax
}
  8018ec:	5b                   	pop    %ebx
  8018ed:	5d                   	pop    %ebp
  8018ee:	c3                   	ret    
		return 0;
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f4:	eb f6                	jmp    8018ec <strncmp+0x32>

008018f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018f6:	f3 0f 1e fb          	endbr32 
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801904:	0f b6 10             	movzbl (%eax),%edx
  801907:	84 d2                	test   %dl,%dl
  801909:	74 09                	je     801914 <strchr+0x1e>
		if (*s == c)
  80190b:	38 ca                	cmp    %cl,%dl
  80190d:	74 0a                	je     801919 <strchr+0x23>
	for (; *s; s++)
  80190f:	83 c0 01             	add    $0x1,%eax
  801912:	eb f0                	jmp    801904 <strchr+0xe>
			return (char *) s;
	return 0;
  801914:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    

0080191b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80191b:	f3 0f 1e fb          	endbr32 
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801929:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80192c:	38 ca                	cmp    %cl,%dl
  80192e:	74 09                	je     801939 <strfind+0x1e>
  801930:	84 d2                	test   %dl,%dl
  801932:	74 05                	je     801939 <strfind+0x1e>
	for (; *s; s++)
  801934:	83 c0 01             	add    $0x1,%eax
  801937:	eb f0                	jmp    801929 <strfind+0xe>
			break;
	return (char *) s;
}
  801939:	5d                   	pop    %ebp
  80193a:	c3                   	ret    

0080193b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80193b:	f3 0f 1e fb          	endbr32 
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	57                   	push   %edi
  801943:	56                   	push   %esi
  801944:	53                   	push   %ebx
  801945:	8b 7d 08             	mov    0x8(%ebp),%edi
  801948:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80194b:	85 c9                	test   %ecx,%ecx
  80194d:	74 31                	je     801980 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80194f:	89 f8                	mov    %edi,%eax
  801951:	09 c8                	or     %ecx,%eax
  801953:	a8 03                	test   $0x3,%al
  801955:	75 23                	jne    80197a <memset+0x3f>
		c &= 0xFF;
  801957:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80195b:	89 d3                	mov    %edx,%ebx
  80195d:	c1 e3 08             	shl    $0x8,%ebx
  801960:	89 d0                	mov    %edx,%eax
  801962:	c1 e0 18             	shl    $0x18,%eax
  801965:	89 d6                	mov    %edx,%esi
  801967:	c1 e6 10             	shl    $0x10,%esi
  80196a:	09 f0                	or     %esi,%eax
  80196c:	09 c2                	or     %eax,%edx
  80196e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801970:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801973:	89 d0                	mov    %edx,%eax
  801975:	fc                   	cld    
  801976:	f3 ab                	rep stos %eax,%es:(%edi)
  801978:	eb 06                	jmp    801980 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80197a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197d:	fc                   	cld    
  80197e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801980:	89 f8                	mov    %edi,%eax
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5f                   	pop    %edi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801987:	f3 0f 1e fb          	endbr32 
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	57                   	push   %edi
  80198f:	56                   	push   %esi
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8b 75 0c             	mov    0xc(%ebp),%esi
  801996:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801999:	39 c6                	cmp    %eax,%esi
  80199b:	73 32                	jae    8019cf <memmove+0x48>
  80199d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019a0:	39 c2                	cmp    %eax,%edx
  8019a2:	76 2b                	jbe    8019cf <memmove+0x48>
		s += n;
		d += n;
  8019a4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019a7:	89 fe                	mov    %edi,%esi
  8019a9:	09 ce                	or     %ecx,%esi
  8019ab:	09 d6                	or     %edx,%esi
  8019ad:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019b3:	75 0e                	jne    8019c3 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019b5:	83 ef 04             	sub    $0x4,%edi
  8019b8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019bb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019be:	fd                   	std    
  8019bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019c1:	eb 09                	jmp    8019cc <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019c3:	83 ef 01             	sub    $0x1,%edi
  8019c6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019c9:	fd                   	std    
  8019ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019cc:	fc                   	cld    
  8019cd:	eb 1a                	jmp    8019e9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019cf:	89 c2                	mov    %eax,%edx
  8019d1:	09 ca                	or     %ecx,%edx
  8019d3:	09 f2                	or     %esi,%edx
  8019d5:	f6 c2 03             	test   $0x3,%dl
  8019d8:	75 0a                	jne    8019e4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019da:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019dd:	89 c7                	mov    %eax,%edi
  8019df:	fc                   	cld    
  8019e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019e2:	eb 05                	jmp    8019e9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8019e4:	89 c7                	mov    %eax,%edi
  8019e6:	fc                   	cld    
  8019e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019e9:	5e                   	pop    %esi
  8019ea:	5f                   	pop    %edi
  8019eb:	5d                   	pop    %ebp
  8019ec:	c3                   	ret    

008019ed <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019ed:	f3 0f 1e fb          	endbr32 
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8019f7:	ff 75 10             	pushl  0x10(%ebp)
  8019fa:	ff 75 0c             	pushl  0xc(%ebp)
  8019fd:	ff 75 08             	pushl  0x8(%ebp)
  801a00:	e8 82 ff ff ff       	call   801987 <memmove>
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a07:	f3 0f 1e fb          	endbr32 
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	56                   	push   %esi
  801a0f:	53                   	push   %ebx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a16:	89 c6                	mov    %eax,%esi
  801a18:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a1b:	39 f0                	cmp    %esi,%eax
  801a1d:	74 1c                	je     801a3b <memcmp+0x34>
		if (*s1 != *s2)
  801a1f:	0f b6 08             	movzbl (%eax),%ecx
  801a22:	0f b6 1a             	movzbl (%edx),%ebx
  801a25:	38 d9                	cmp    %bl,%cl
  801a27:	75 08                	jne    801a31 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a29:	83 c0 01             	add    $0x1,%eax
  801a2c:	83 c2 01             	add    $0x1,%edx
  801a2f:	eb ea                	jmp    801a1b <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a31:	0f b6 c1             	movzbl %cl,%eax
  801a34:	0f b6 db             	movzbl %bl,%ebx
  801a37:	29 d8                	sub    %ebx,%eax
  801a39:	eb 05                	jmp    801a40 <memcmp+0x39>
	}

	return 0;
  801a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a40:	5b                   	pop    %ebx
  801a41:	5e                   	pop    %esi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    

00801a44 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a44:	f3 0f 1e fb          	endbr32 
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a51:	89 c2                	mov    %eax,%edx
  801a53:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a56:	39 d0                	cmp    %edx,%eax
  801a58:	73 09                	jae    801a63 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a5a:	38 08                	cmp    %cl,(%eax)
  801a5c:	74 05                	je     801a63 <memfind+0x1f>
	for (; s < ends; s++)
  801a5e:	83 c0 01             	add    $0x1,%eax
  801a61:	eb f3                	jmp    801a56 <memfind+0x12>
			break;
	return (void *) s;
}
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    

00801a65 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a65:	f3 0f 1e fb          	endbr32 
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	57                   	push   %edi
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a75:	eb 03                	jmp    801a7a <strtol+0x15>
		s++;
  801a77:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801a7a:	0f b6 01             	movzbl (%ecx),%eax
  801a7d:	3c 20                	cmp    $0x20,%al
  801a7f:	74 f6                	je     801a77 <strtol+0x12>
  801a81:	3c 09                	cmp    $0x9,%al
  801a83:	74 f2                	je     801a77 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801a85:	3c 2b                	cmp    $0x2b,%al
  801a87:	74 2a                	je     801ab3 <strtol+0x4e>
	int neg = 0;
  801a89:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801a8e:	3c 2d                	cmp    $0x2d,%al
  801a90:	74 2b                	je     801abd <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a92:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801a98:	75 0f                	jne    801aa9 <strtol+0x44>
  801a9a:	80 39 30             	cmpb   $0x30,(%ecx)
  801a9d:	74 28                	je     801ac7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a9f:	85 db                	test   %ebx,%ebx
  801aa1:	b8 0a 00 00 00       	mov    $0xa,%eax
  801aa6:	0f 44 d8             	cmove  %eax,%ebx
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ab1:	eb 46                	jmp    801af9 <strtol+0x94>
		s++;
  801ab3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801ab6:	bf 00 00 00 00       	mov    $0x0,%edi
  801abb:	eb d5                	jmp    801a92 <strtol+0x2d>
		s++, neg = 1;
  801abd:	83 c1 01             	add    $0x1,%ecx
  801ac0:	bf 01 00 00 00       	mov    $0x1,%edi
  801ac5:	eb cb                	jmp    801a92 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ac7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801acb:	74 0e                	je     801adb <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801acd:	85 db                	test   %ebx,%ebx
  801acf:	75 d8                	jne    801aa9 <strtol+0x44>
		s++, base = 8;
  801ad1:	83 c1 01             	add    $0x1,%ecx
  801ad4:	bb 08 00 00 00       	mov    $0x8,%ebx
  801ad9:	eb ce                	jmp    801aa9 <strtol+0x44>
		s += 2, base = 16;
  801adb:	83 c1 02             	add    $0x2,%ecx
  801ade:	bb 10 00 00 00       	mov    $0x10,%ebx
  801ae3:	eb c4                	jmp    801aa9 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801ae5:	0f be d2             	movsbl %dl,%edx
  801ae8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801aeb:	3b 55 10             	cmp    0x10(%ebp),%edx
  801aee:	7d 3a                	jge    801b2a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801af0:	83 c1 01             	add    $0x1,%ecx
  801af3:	0f af 45 10          	imul   0x10(%ebp),%eax
  801af7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801af9:	0f b6 11             	movzbl (%ecx),%edx
  801afc:	8d 72 d0             	lea    -0x30(%edx),%esi
  801aff:	89 f3                	mov    %esi,%ebx
  801b01:	80 fb 09             	cmp    $0x9,%bl
  801b04:	76 df                	jbe    801ae5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801b06:	8d 72 9f             	lea    -0x61(%edx),%esi
  801b09:	89 f3                	mov    %esi,%ebx
  801b0b:	80 fb 19             	cmp    $0x19,%bl
  801b0e:	77 08                	ja     801b18 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801b10:	0f be d2             	movsbl %dl,%edx
  801b13:	83 ea 57             	sub    $0x57,%edx
  801b16:	eb d3                	jmp    801aeb <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801b18:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b1b:	89 f3                	mov    %esi,%ebx
  801b1d:	80 fb 19             	cmp    $0x19,%bl
  801b20:	77 08                	ja     801b2a <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b22:	0f be d2             	movsbl %dl,%edx
  801b25:	83 ea 37             	sub    $0x37,%edx
  801b28:	eb c1                	jmp    801aeb <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b2e:	74 05                	je     801b35 <strtol+0xd0>
		*endptr = (char *) s;
  801b30:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b33:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b35:	89 c2                	mov    %eax,%edx
  801b37:	f7 da                	neg    %edx
  801b39:	85 ff                	test   %edi,%edi
  801b3b:	0f 45 c2             	cmovne %edx,%eax
}
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5f                   	pop    %edi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    

00801b43 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b43:	f3 0f 1e fb          	endbr32 
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	56                   	push   %esi
  801b4b:	53                   	push   %ebx
  801b4c:	8b 75 08             	mov    0x8(%ebp),%esi
  801b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b55:	85 c0                	test   %eax,%eax
  801b57:	74 3d                	je     801b96 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	50                   	push   %eax
  801b5d:	e8 f4 e7 ff ff       	call   800356 <sys_ipc_recv>
  801b62:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b65:	85 f6                	test   %esi,%esi
  801b67:	74 0b                	je     801b74 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b69:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b6f:	8b 52 74             	mov    0x74(%edx),%edx
  801b72:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b74:	85 db                	test   %ebx,%ebx
  801b76:	74 0b                	je     801b83 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b78:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b7e:	8b 52 78             	mov    0x78(%edx),%edx
  801b81:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 21                	js     801ba8 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b87:	a1 04 40 80 00       	mov    0x804004,%eax
  801b8c:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b92:	5b                   	pop    %ebx
  801b93:	5e                   	pop    %esi
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801b96:	83 ec 0c             	sub    $0xc,%esp
  801b99:	68 00 00 c0 ee       	push   $0xeec00000
  801b9e:	e8 b3 e7 ff ff       	call   800356 <sys_ipc_recv>
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	eb bd                	jmp    801b65 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801ba8:	85 f6                	test   %esi,%esi
  801baa:	74 10                	je     801bbc <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801bac:	85 db                	test   %ebx,%ebx
  801bae:	75 df                	jne    801b8f <ipc_recv+0x4c>
  801bb0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bb7:	00 00 00 
  801bba:	eb d3                	jmp    801b8f <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801bbc:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bc3:	00 00 00 
  801bc6:	eb e4                	jmp    801bac <ipc_recv+0x69>

00801bc8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bc8:	f3 0f 1e fb          	endbr32 
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	57                   	push   %edi
  801bd0:	56                   	push   %esi
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 0c             	sub    $0xc,%esp
  801bd5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bde:	85 db                	test   %ebx,%ebx
  801be0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801be5:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801be8:	ff 75 14             	pushl  0x14(%ebp)
  801beb:	53                   	push   %ebx
  801bec:	56                   	push   %esi
  801bed:	57                   	push   %edi
  801bee:	e8 3c e7 ff ff       	call   80032f <sys_ipc_try_send>
  801bf3:	83 c4 10             	add    $0x10,%esp
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	79 1e                	jns    801c18 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801bfa:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801bfd:	75 07                	jne    801c06 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801bff:	e8 63 e5 ff ff       	call   800167 <sys_yield>
  801c04:	eb e2                	jmp    801be8 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c06:	50                   	push   %eax
  801c07:	68 5f 23 80 00       	push   $0x80235f
  801c0c:	6a 59                	push   $0x59
  801c0e:	68 7a 23 80 00       	push   $0x80237a
  801c13:	e8 c8 f4 ff ff       	call   8010e0 <_panic>
	}
}
  801c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    

00801c20 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c20:	f3 0f 1e fb          	endbr32 
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c2a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c2f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c32:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c38:	8b 52 50             	mov    0x50(%edx),%edx
  801c3b:	39 ca                	cmp    %ecx,%edx
  801c3d:	74 11                	je     801c50 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c3f:	83 c0 01             	add    $0x1,%eax
  801c42:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c47:	75 e6                	jne    801c2f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4e:	eb 0b                	jmp    801c5b <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c50:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c53:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c58:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    

00801c5d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c5d:	f3 0f 1e fb          	endbr32 
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c67:	89 c2                	mov    %eax,%edx
  801c69:	c1 ea 16             	shr    $0x16,%edx
  801c6c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c73:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c78:	f6 c1 01             	test   $0x1,%cl
  801c7b:	74 1c                	je     801c99 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c7d:	c1 e8 0c             	shr    $0xc,%eax
  801c80:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c87:	a8 01                	test   $0x1,%al
  801c89:	74 0e                	je     801c99 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c8b:	c1 e8 0c             	shr    $0xc,%eax
  801c8e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c95:	ef 
  801c96:	0f b7 d2             	movzwl %dx,%edx
}
  801c99:	89 d0                	mov    %edx,%eax
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    
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
