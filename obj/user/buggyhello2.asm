
obj/user/buggyhello2:     file format elf32-i386


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
  800042:	ff 35 00 20 80 00    	pushl  0x802000
  800048:	e8 65 00 00 00       	call   8000b2 <sys_cputs>
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
  800061:	e8 d6 00 00 00       	call   80013c <sys_getenvid>
  800066:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800073:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800078:	85 db                	test   %ebx,%ebx
  80007a:	7e 07                	jle    800083 <libmain+0x31>
		binaryname = argv[0];
  80007c:	8b 06                	mov    (%esi),%eax
  80007e:	a3 04 20 80 00       	mov    %eax,0x802004

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
  8000a3:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000a6:	6a 00                	push   $0x0
  8000a8:	e8 4a 00 00 00       	call   8000f7 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	c9                   	leave  
  8000b1:	c3                   	ret    

008000b2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b2:	f3 0f 1e fb          	endbr32 
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	57                   	push   %edi
  8000ba:	56                   	push   %esi
  8000bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c7:	89 c3                	mov    %eax,%ebx
  8000c9:	89 c7                	mov    %eax,%edi
  8000cb:	89 c6                	mov    %eax,%esi
  8000cd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5f                   	pop    %edi
  8000d2:	5d                   	pop    %ebp
  8000d3:	c3                   	ret    

008000d4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d4:	f3 0f 1e fb          	endbr32 
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	57                   	push   %edi
  8000dc:	56                   	push   %esi
  8000dd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000de:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e8:	89 d1                	mov    %edx,%ecx
  8000ea:	89 d3                	mov    %edx,%ebx
  8000ec:	89 d7                	mov    %edx,%edi
  8000ee:	89 d6                	mov    %edx,%esi
  8000f0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f2:	5b                   	pop    %ebx
  8000f3:	5e                   	pop    %esi
  8000f4:	5f                   	pop    %edi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f7:	f3 0f 1e fb          	endbr32 
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	57                   	push   %edi
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
  800101:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800104:	b9 00 00 00 00       	mov    $0x0,%ecx
  800109:	8b 55 08             	mov    0x8(%ebp),%edx
  80010c:	b8 03 00 00 00       	mov    $0x3,%eax
  800111:	89 cb                	mov    %ecx,%ebx
  800113:	89 cf                	mov    %ecx,%edi
  800115:	89 ce                	mov    %ecx,%esi
  800117:	cd 30                	int    $0x30
	if(check && ret > 0)
  800119:	85 c0                	test   %eax,%eax
  80011b:	7f 08                	jg     800125 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80011d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800120:	5b                   	pop    %ebx
  800121:	5e                   	pop    %esi
  800122:	5f                   	pop    %edi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800125:	83 ec 0c             	sub    $0xc,%esp
  800128:	50                   	push   %eax
  800129:	6a 03                	push   $0x3
  80012b:	68 38 10 80 00       	push   $0x801038
  800130:	6a 23                	push   $0x23
  800132:	68 55 10 80 00       	push   $0x801055
  800137:	e8 11 02 00 00       	call   80034d <_panic>

0080013c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80013c:	f3 0f 1e fb          	endbr32 
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	57                   	push   %edi
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
	asm volatile("int %1\n"
  800146:	ba 00 00 00 00       	mov    $0x0,%edx
  80014b:	b8 02 00 00 00       	mov    $0x2,%eax
  800150:	89 d1                	mov    %edx,%ecx
  800152:	89 d3                	mov    %edx,%ebx
  800154:	89 d7                	mov    %edx,%edi
  800156:	89 d6                	mov    %edx,%esi
  800158:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015a:	5b                   	pop    %ebx
  80015b:	5e                   	pop    %esi
  80015c:	5f                   	pop    %edi
  80015d:	5d                   	pop    %ebp
  80015e:	c3                   	ret    

0080015f <sys_yield>:

void
sys_yield(void)
{
  80015f:	f3 0f 1e fb          	endbr32 
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	57                   	push   %edi
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
	asm volatile("int %1\n"
  800169:	ba 00 00 00 00       	mov    $0x0,%edx
  80016e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800173:	89 d1                	mov    %edx,%ecx
  800175:	89 d3                	mov    %edx,%ebx
  800177:	89 d7                	mov    %edx,%edi
  800179:	89 d6                	mov    %edx,%esi
  80017b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    

00800182 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800182:	f3 0f 1e fb          	endbr32 
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	57                   	push   %edi
  80018a:	56                   	push   %esi
  80018b:	53                   	push   %ebx
  80018c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80018f:	be 00 00 00 00       	mov    $0x0,%esi
  800194:	8b 55 08             	mov    0x8(%ebp),%edx
  800197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019a:	b8 04 00 00 00       	mov    $0x4,%eax
  80019f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a2:	89 f7                	mov    %esi,%edi
  8001a4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001a6:	85 c0                	test   %eax,%eax
  8001a8:	7f 08                	jg     8001b2 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	50                   	push   %eax
  8001b6:	6a 04                	push   $0x4
  8001b8:	68 38 10 80 00       	push   $0x801038
  8001bd:	6a 23                	push   $0x23
  8001bf:	68 55 10 80 00       	push   $0x801055
  8001c4:	e8 84 01 00 00       	call   80034d <_panic>

008001c9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c9:	f3 0f 1e fb          	endbr32 
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	57                   	push   %edi
  8001d1:	56                   	push   %esi
  8001d2:	53                   	push   %ebx
  8001d3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001dc:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001e7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ea:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ec:	85 c0                	test   %eax,%eax
  8001ee:	7f 08                	jg     8001f8 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f3:	5b                   	pop    %ebx
  8001f4:	5e                   	pop    %esi
  8001f5:	5f                   	pop    %edi
  8001f6:	5d                   	pop    %ebp
  8001f7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	50                   	push   %eax
  8001fc:	6a 05                	push   $0x5
  8001fe:	68 38 10 80 00       	push   $0x801038
  800203:	6a 23                	push   $0x23
  800205:	68 55 10 80 00       	push   $0x801055
  80020a:	e8 3e 01 00 00       	call   80034d <_panic>

0080020f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80020f:	f3 0f 1e fb          	endbr32 
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	57                   	push   %edi
  800217:	56                   	push   %esi
  800218:	53                   	push   %ebx
  800219:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80021c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800221:	8b 55 08             	mov    0x8(%ebp),%edx
  800224:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800227:	b8 06 00 00 00       	mov    $0x6,%eax
  80022c:	89 df                	mov    %ebx,%edi
  80022e:	89 de                	mov    %ebx,%esi
  800230:	cd 30                	int    $0x30
	if(check && ret > 0)
  800232:	85 c0                	test   %eax,%eax
  800234:	7f 08                	jg     80023e <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800236:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800239:	5b                   	pop    %ebx
  80023a:	5e                   	pop    %esi
  80023b:	5f                   	pop    %edi
  80023c:	5d                   	pop    %ebp
  80023d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	50                   	push   %eax
  800242:	6a 06                	push   $0x6
  800244:	68 38 10 80 00       	push   $0x801038
  800249:	6a 23                	push   $0x23
  80024b:	68 55 10 80 00       	push   $0x801055
  800250:	e8 f8 00 00 00       	call   80034d <_panic>

00800255 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800255:	f3 0f 1e fb          	endbr32 
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	57                   	push   %edi
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800262:	bb 00 00 00 00       	mov    $0x0,%ebx
  800267:	8b 55 08             	mov    0x8(%ebp),%edx
  80026a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026d:	b8 08 00 00 00       	mov    $0x8,%eax
  800272:	89 df                	mov    %ebx,%edi
  800274:	89 de                	mov    %ebx,%esi
  800276:	cd 30                	int    $0x30
	if(check && ret > 0)
  800278:	85 c0                	test   %eax,%eax
  80027a:	7f 08                	jg     800284 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80027c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027f:	5b                   	pop    %ebx
  800280:	5e                   	pop    %esi
  800281:	5f                   	pop    %edi
  800282:	5d                   	pop    %ebp
  800283:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	50                   	push   %eax
  800288:	6a 08                	push   $0x8
  80028a:	68 38 10 80 00       	push   $0x801038
  80028f:	6a 23                	push   $0x23
  800291:	68 55 10 80 00       	push   $0x801055
  800296:	e8 b2 00 00 00       	call   80034d <_panic>

0080029b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80029b:	f3 0f 1e fb          	endbr32 
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	57                   	push   %edi
  8002a3:	56                   	push   %esi
  8002a4:	53                   	push   %ebx
  8002a5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b3:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b8:	89 df                	mov    %ebx,%edi
  8002ba:	89 de                	mov    %ebx,%esi
  8002bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002be:	85 c0                	test   %eax,%eax
  8002c0:	7f 08                	jg     8002ca <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c5:	5b                   	pop    %ebx
  8002c6:	5e                   	pop    %esi
  8002c7:	5f                   	pop    %edi
  8002c8:	5d                   	pop    %ebp
  8002c9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	50                   	push   %eax
  8002ce:	6a 09                	push   $0x9
  8002d0:	68 38 10 80 00       	push   $0x801038
  8002d5:	6a 23                	push   $0x23
  8002d7:	68 55 10 80 00       	push   $0x801055
  8002dc:	e8 6c 00 00 00       	call   80034d <_panic>

008002e1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e1:	f3 0f 1e fb          	endbr32 
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	57                   	push   %edi
  8002e9:	56                   	push   %esi
  8002ea:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f1:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002f6:	be 00 00 00 00       	mov    $0x0,%esi
  8002fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800301:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800303:	5b                   	pop    %ebx
  800304:	5e                   	pop    %esi
  800305:	5f                   	pop    %edi
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    

00800308 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800308:	f3 0f 1e fb          	endbr32 
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	57                   	push   %edi
  800310:	56                   	push   %esi
  800311:	53                   	push   %ebx
  800312:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800315:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031a:	8b 55 08             	mov    0x8(%ebp),%edx
  80031d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800322:	89 cb                	mov    %ecx,%ebx
  800324:	89 cf                	mov    %ecx,%edi
  800326:	89 ce                	mov    %ecx,%esi
  800328:	cd 30                	int    $0x30
	if(check && ret > 0)
  80032a:	85 c0                	test   %eax,%eax
  80032c:	7f 08                	jg     800336 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80032e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800331:	5b                   	pop    %ebx
  800332:	5e                   	pop    %esi
  800333:	5f                   	pop    %edi
  800334:	5d                   	pop    %ebp
  800335:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	50                   	push   %eax
  80033a:	6a 0c                	push   $0xc
  80033c:	68 38 10 80 00       	push   $0x801038
  800341:	6a 23                	push   $0x23
  800343:	68 55 10 80 00       	push   $0x801055
  800348:	e8 00 00 00 00       	call   80034d <_panic>

0080034d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034d:	f3 0f 1e fb          	endbr32 
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	56                   	push   %esi
  800355:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800356:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800359:	8b 35 04 20 80 00    	mov    0x802004,%esi
  80035f:	e8 d8 fd ff ff       	call   80013c <sys_getenvid>
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	ff 75 0c             	pushl  0xc(%ebp)
  80036a:	ff 75 08             	pushl  0x8(%ebp)
  80036d:	56                   	push   %esi
  80036e:	50                   	push   %eax
  80036f:	68 64 10 80 00       	push   $0x801064
  800374:	e8 bb 00 00 00       	call   800434 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800379:	83 c4 18             	add    $0x18,%esp
  80037c:	53                   	push   %ebx
  80037d:	ff 75 10             	pushl  0x10(%ebp)
  800380:	e8 5a 00 00 00       	call   8003df <vcprintf>
	cprintf("\n");
  800385:	c7 04 24 2c 10 80 00 	movl   $0x80102c,(%esp)
  80038c:	e8 a3 00 00 00       	call   800434 <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800394:	cc                   	int3   
  800395:	eb fd                	jmp    800394 <_panic+0x47>

00800397 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800397:	f3 0f 1e fb          	endbr32 
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	53                   	push   %ebx
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003a5:	8b 13                	mov    (%ebx),%edx
  8003a7:	8d 42 01             	lea    0x1(%edx),%eax
  8003aa:	89 03                	mov    %eax,(%ebx)
  8003ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003af:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b8:	74 09                	je     8003c3 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003ba:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003c1:	c9                   	leave  
  8003c2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	68 ff 00 00 00       	push   $0xff
  8003cb:	8d 43 08             	lea    0x8(%ebx),%eax
  8003ce:	50                   	push   %eax
  8003cf:	e8 de fc ff ff       	call   8000b2 <sys_cputs>
		b->idx = 0;
  8003d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003da:	83 c4 10             	add    $0x10,%esp
  8003dd:	eb db                	jmp    8003ba <putch+0x23>

008003df <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003df:	f3 0f 1e fb          	endbr32 
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f3:	00 00 00 
	b.cnt = 0;
  8003f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003fd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800400:	ff 75 0c             	pushl  0xc(%ebp)
  800403:	ff 75 08             	pushl  0x8(%ebp)
  800406:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	68 97 03 80 00       	push   $0x800397
  800412:	e8 20 01 00 00       	call   800537 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800417:	83 c4 08             	add    $0x8,%esp
  80041a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800420:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800426:	50                   	push   %eax
  800427:	e8 86 fc ff ff       	call   8000b2 <sys_cputs>

	return b.cnt;
}
  80042c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800434:	f3 0f 1e fb          	endbr32 
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80043e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800441:	50                   	push   %eax
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 95 ff ff ff       	call   8003df <vcprintf>
	va_end(ap);

	return cnt;
}
  80044a:	c9                   	leave  
  80044b:	c3                   	ret    

0080044c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	57                   	push   %edi
  800450:	56                   	push   %esi
  800451:	53                   	push   %ebx
  800452:	83 ec 1c             	sub    $0x1c,%esp
  800455:	89 c7                	mov    %eax,%edi
  800457:	89 d6                	mov    %edx,%esi
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045f:	89 d1                	mov    %edx,%ecx
  800461:	89 c2                	mov    %eax,%edx
  800463:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800466:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800469:	8b 45 10             	mov    0x10(%ebp),%eax
  80046c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80046f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800472:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800479:	39 c2                	cmp    %eax,%edx
  80047b:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80047e:	72 3e                	jb     8004be <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff 75 18             	pushl  0x18(%ebp)
  800486:	83 eb 01             	sub    $0x1,%ebx
  800489:	53                   	push   %ebx
  80048a:	50                   	push   %eax
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800491:	ff 75 e0             	pushl  -0x20(%ebp)
  800494:	ff 75 dc             	pushl  -0x24(%ebp)
  800497:	ff 75 d8             	pushl  -0x28(%ebp)
  80049a:	e8 11 09 00 00       	call   800db0 <__udivdi3>
  80049f:	83 c4 18             	add    $0x18,%esp
  8004a2:	52                   	push   %edx
  8004a3:	50                   	push   %eax
  8004a4:	89 f2                	mov    %esi,%edx
  8004a6:	89 f8                	mov    %edi,%eax
  8004a8:	e8 9f ff ff ff       	call   80044c <printnum>
  8004ad:	83 c4 20             	add    $0x20,%esp
  8004b0:	eb 13                	jmp    8004c5 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	56                   	push   %esi
  8004b6:	ff 75 18             	pushl  0x18(%ebp)
  8004b9:	ff d7                	call   *%edi
  8004bb:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004be:	83 eb 01             	sub    $0x1,%ebx
  8004c1:	85 db                	test   %ebx,%ebx
  8004c3:	7f ed                	jg     8004b2 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	56                   	push   %esi
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d8:	e8 e3 09 00 00       	call   800ec0 <__umoddi3>
  8004dd:	83 c4 14             	add    $0x14,%esp
  8004e0:	0f be 80 87 10 80 00 	movsbl 0x801087(%eax),%eax
  8004e7:	50                   	push   %eax
  8004e8:	ff d7                	call   *%edi
}
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f0:	5b                   	pop    %ebx
  8004f1:	5e                   	pop    %esi
  8004f2:	5f                   	pop    %edi
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004f5:	f3 0f 1e fb          	endbr32 
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800503:	8b 10                	mov    (%eax),%edx
  800505:	3b 50 04             	cmp    0x4(%eax),%edx
  800508:	73 0a                	jae    800514 <sprintputch+0x1f>
		*b->buf++ = ch;
  80050a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80050d:	89 08                	mov    %ecx,(%eax)
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	88 02                	mov    %al,(%edx)
}
  800514:	5d                   	pop    %ebp
  800515:	c3                   	ret    

00800516 <printfmt>:
{
  800516:	f3 0f 1e fb          	endbr32 
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800520:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800523:	50                   	push   %eax
  800524:	ff 75 10             	pushl  0x10(%ebp)
  800527:	ff 75 0c             	pushl  0xc(%ebp)
  80052a:	ff 75 08             	pushl  0x8(%ebp)
  80052d:	e8 05 00 00 00       	call   800537 <vprintfmt>
}
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	c9                   	leave  
  800536:	c3                   	ret    

00800537 <vprintfmt>:
{
  800537:	f3 0f 1e fb          	endbr32 
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
  80053e:	57                   	push   %edi
  80053f:	56                   	push   %esi
  800540:	53                   	push   %ebx
  800541:	83 ec 3c             	sub    $0x3c,%esp
  800544:	8b 75 08             	mov    0x8(%ebp),%esi
  800547:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80054a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80054d:	e9 8e 03 00 00       	jmp    8008e0 <vprintfmt+0x3a9>
		padc = ' ';
  800552:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800556:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80055d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800564:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80056b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800570:	8d 47 01             	lea    0x1(%edi),%eax
  800573:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800576:	0f b6 17             	movzbl (%edi),%edx
  800579:	8d 42 dd             	lea    -0x23(%edx),%eax
  80057c:	3c 55                	cmp    $0x55,%al
  80057e:	0f 87 df 03 00 00    	ja     800963 <vprintfmt+0x42c>
  800584:	0f b6 c0             	movzbl %al,%eax
  800587:	3e ff 24 85 40 11 80 	notrack jmp *0x801140(,%eax,4)
  80058e:	00 
  80058f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800592:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800596:	eb d8                	jmp    800570 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800598:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80059b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80059f:	eb cf                	jmp    800570 <vprintfmt+0x39>
  8005a1:	0f b6 d2             	movzbl %dl,%edx
  8005a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005af:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005b2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005b6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005b9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005bc:	83 f9 09             	cmp    $0x9,%ecx
  8005bf:	77 55                	ja     800616 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005c1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005c4:	eb e9                	jmp    8005af <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8d 40 04             	lea    0x4(%eax),%eax
  8005d4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005de:	79 90                	jns    800570 <vprintfmt+0x39>
				width = precision, precision = -1;
  8005e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005ed:	eb 81                	jmp    800570 <vprintfmt+0x39>
  8005ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f2:	85 c0                	test   %eax,%eax
  8005f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f9:	0f 49 d0             	cmovns %eax,%edx
  8005fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800602:	e9 69 ff ff ff       	jmp    800570 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800607:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80060a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800611:	e9 5a ff ff ff       	jmp    800570 <vprintfmt+0x39>
  800616:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800619:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061c:	eb bc                	jmp    8005da <vprintfmt+0xa3>
			lflag++;
  80061e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800621:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800624:	e9 47 ff ff ff       	jmp    800570 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8d 78 04             	lea    0x4(%eax),%edi
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	53                   	push   %ebx
  800633:	ff 30                	pushl  (%eax)
  800635:	ff d6                	call   *%esi
			break;
  800637:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80063a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80063d:	e9 9b 02 00 00       	jmp    8008dd <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 78 04             	lea    0x4(%eax),%edi
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	99                   	cltd   
  80064b:	31 d0                	xor    %edx,%eax
  80064d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80064f:	83 f8 08             	cmp    $0x8,%eax
  800652:	7f 23                	jg     800677 <vprintfmt+0x140>
  800654:	8b 14 85 a0 12 80 00 	mov    0x8012a0(,%eax,4),%edx
  80065b:	85 d2                	test   %edx,%edx
  80065d:	74 18                	je     800677 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80065f:	52                   	push   %edx
  800660:	68 a8 10 80 00       	push   $0x8010a8
  800665:	53                   	push   %ebx
  800666:	56                   	push   %esi
  800667:	e8 aa fe ff ff       	call   800516 <printfmt>
  80066c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80066f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800672:	e9 66 02 00 00       	jmp    8008dd <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800677:	50                   	push   %eax
  800678:	68 9f 10 80 00       	push   $0x80109f
  80067d:	53                   	push   %ebx
  80067e:	56                   	push   %esi
  80067f:	e8 92 fe ff ff       	call   800516 <printfmt>
  800684:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800687:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80068a:	e9 4e 02 00 00       	jmp    8008dd <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	83 c0 04             	add    $0x4,%eax
  800695:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80069d:	85 d2                	test   %edx,%edx
  80069f:	b8 98 10 80 00       	mov    $0x801098,%eax
  8006a4:	0f 45 c2             	cmovne %edx,%eax
  8006a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ae:	7e 06                	jle    8006b6 <vprintfmt+0x17f>
  8006b0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006b4:	75 0d                	jne    8006c3 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006b9:	89 c7                	mov    %eax,%edi
  8006bb:	03 45 e0             	add    -0x20(%ebp),%eax
  8006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c1:	eb 55                	jmp    800718 <vprintfmt+0x1e1>
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8006c9:	ff 75 cc             	pushl  -0x34(%ebp)
  8006cc:	e8 46 03 00 00       	call   800a17 <strnlen>
  8006d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d4:	29 c2                	sub    %eax,%edx
  8006d6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006de:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e5:	85 ff                	test   %edi,%edi
  8006e7:	7e 11                	jle    8006fa <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	53                   	push   %ebx
  8006ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f2:	83 ef 01             	sub    $0x1,%edi
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	eb eb                	jmp    8006e5 <vprintfmt+0x1ae>
  8006fa:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006fd:	85 d2                	test   %edx,%edx
  8006ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800704:	0f 49 c2             	cmovns %edx,%eax
  800707:	29 c2                	sub    %eax,%edx
  800709:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80070c:	eb a8                	jmp    8006b6 <vprintfmt+0x17f>
					putch(ch, putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	53                   	push   %ebx
  800712:	52                   	push   %edx
  800713:	ff d6                	call   *%esi
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80071b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071d:	83 c7 01             	add    $0x1,%edi
  800720:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800724:	0f be d0             	movsbl %al,%edx
  800727:	85 d2                	test   %edx,%edx
  800729:	74 4b                	je     800776 <vprintfmt+0x23f>
  80072b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80072f:	78 06                	js     800737 <vprintfmt+0x200>
  800731:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800735:	78 1e                	js     800755 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800737:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80073b:	74 d1                	je     80070e <vprintfmt+0x1d7>
  80073d:	0f be c0             	movsbl %al,%eax
  800740:	83 e8 20             	sub    $0x20,%eax
  800743:	83 f8 5e             	cmp    $0x5e,%eax
  800746:	76 c6                	jbe    80070e <vprintfmt+0x1d7>
					putch('?', putdat);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	53                   	push   %ebx
  80074c:	6a 3f                	push   $0x3f
  80074e:	ff d6                	call   *%esi
  800750:	83 c4 10             	add    $0x10,%esp
  800753:	eb c3                	jmp    800718 <vprintfmt+0x1e1>
  800755:	89 cf                	mov    %ecx,%edi
  800757:	eb 0e                	jmp    800767 <vprintfmt+0x230>
				putch(' ', putdat);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	53                   	push   %ebx
  80075d:	6a 20                	push   $0x20
  80075f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800761:	83 ef 01             	sub    $0x1,%edi
  800764:	83 c4 10             	add    $0x10,%esp
  800767:	85 ff                	test   %edi,%edi
  800769:	7f ee                	jg     800759 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80076b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
  800771:	e9 67 01 00 00       	jmp    8008dd <vprintfmt+0x3a6>
  800776:	89 cf                	mov    %ecx,%edi
  800778:	eb ed                	jmp    800767 <vprintfmt+0x230>
	if (lflag >= 2)
  80077a:	83 f9 01             	cmp    $0x1,%ecx
  80077d:	7f 1b                	jg     80079a <vprintfmt+0x263>
	else if (lflag)
  80077f:	85 c9                	test   %ecx,%ecx
  800781:	74 63                	je     8007e6 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078b:	99                   	cltd   
  80078c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
  800798:	eb 17                	jmp    8007b1 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 50 04             	mov    0x4(%eax),%edx
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8d 40 08             	lea    0x8(%eax),%eax
  8007ae:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007b7:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007bc:	85 c9                	test   %ecx,%ecx
  8007be:	0f 89 ff 00 00 00    	jns    8008c3 <vprintfmt+0x38c>
				putch('-', putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	53                   	push   %ebx
  8007c8:	6a 2d                	push   $0x2d
  8007ca:	ff d6                	call   *%esi
				num = -(long long) num;
  8007cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007cf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007d2:	f7 da                	neg    %edx
  8007d4:	83 d1 00             	adc    $0x0,%ecx
  8007d7:	f7 d9                	neg    %ecx
  8007d9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e1:	e9 dd 00 00 00       	jmp    8008c3 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ee:	99                   	cltd   
  8007ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8d 40 04             	lea    0x4(%eax),%eax
  8007f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fb:	eb b4                	jmp    8007b1 <vprintfmt+0x27a>
	if (lflag >= 2)
  8007fd:	83 f9 01             	cmp    $0x1,%ecx
  800800:	7f 1e                	jg     800820 <vprintfmt+0x2e9>
	else if (lflag)
  800802:	85 c9                	test   %ecx,%ecx
  800804:	74 32                	je     800838 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 10                	mov    (%eax),%edx
  80080b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800816:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80081b:	e9 a3 00 00 00       	jmp    8008c3 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8b 10                	mov    (%eax),%edx
  800825:	8b 48 04             	mov    0x4(%eax),%ecx
  800828:	8d 40 08             	lea    0x8(%eax),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082e:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800833:	e9 8b 00 00 00       	jmp    8008c3 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 10                	mov    (%eax),%edx
  80083d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800842:	8d 40 04             	lea    0x4(%eax),%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800848:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80084d:	eb 74                	jmp    8008c3 <vprintfmt+0x38c>
	if (lflag >= 2)
  80084f:	83 f9 01             	cmp    $0x1,%ecx
  800852:	7f 1b                	jg     80086f <vprintfmt+0x338>
	else if (lflag)
  800854:	85 c9                	test   %ecx,%ecx
  800856:	74 2c                	je     800884 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8b 10                	mov    (%eax),%edx
  80085d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800862:	8d 40 04             	lea    0x4(%eax),%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800868:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80086d:	eb 54                	jmp    8008c3 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8b 10                	mov    (%eax),%edx
  800874:	8b 48 04             	mov    0x4(%eax),%ecx
  800877:	8d 40 08             	lea    0x8(%eax),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800882:	eb 3f                	jmp    8008c3 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8b 10                	mov    (%eax),%edx
  800889:	b9 00 00 00 00       	mov    $0x0,%ecx
  80088e:	8d 40 04             	lea    0x4(%eax),%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800894:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800899:	eb 28                	jmp    8008c3 <vprintfmt+0x38c>
			putch('0', putdat);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	53                   	push   %ebx
  80089f:	6a 30                	push   $0x30
  8008a1:	ff d6                	call   *%esi
			putch('x', putdat);
  8008a3:	83 c4 08             	add    $0x8,%esp
  8008a6:	53                   	push   %ebx
  8008a7:	6a 78                	push   $0x78
  8008a9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8b 10                	mov    (%eax),%edx
  8008b0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008b5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b8:	8d 40 04             	lea    0x4(%eax),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008be:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008c3:	83 ec 0c             	sub    $0xc,%esp
  8008c6:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008ca:	57                   	push   %edi
  8008cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ce:	50                   	push   %eax
  8008cf:	51                   	push   %ecx
  8008d0:	52                   	push   %edx
  8008d1:	89 da                	mov    %ebx,%edx
  8008d3:	89 f0                	mov    %esi,%eax
  8008d5:	e8 72 fb ff ff       	call   80044c <printnum>
			break;
  8008da:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e0:	83 c7 01             	add    $0x1,%edi
  8008e3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e7:	83 f8 25             	cmp    $0x25,%eax
  8008ea:	0f 84 62 fc ff ff    	je     800552 <vprintfmt+0x1b>
			if (ch == '\0')
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	0f 84 8b 00 00 00    	je     800983 <vprintfmt+0x44c>
			putch(ch, putdat);
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	53                   	push   %ebx
  8008fc:	50                   	push   %eax
  8008fd:	ff d6                	call   *%esi
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	eb dc                	jmp    8008e0 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800904:	83 f9 01             	cmp    $0x1,%ecx
  800907:	7f 1b                	jg     800924 <vprintfmt+0x3ed>
	else if (lflag)
  800909:	85 c9                	test   %ecx,%ecx
  80090b:	74 2c                	je     800939 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	8b 10                	mov    (%eax),%edx
  800912:	b9 00 00 00 00       	mov    $0x0,%ecx
  800917:	8d 40 04             	lea    0x4(%eax),%eax
  80091a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800922:	eb 9f                	jmp    8008c3 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	8b 48 04             	mov    0x4(%eax),%ecx
  80092c:	8d 40 08             	lea    0x8(%eax),%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800932:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800937:	eb 8a                	jmp    8008c3 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8b 10                	mov    (%eax),%edx
  80093e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800943:	8d 40 04             	lea    0x4(%eax),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800949:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80094e:	e9 70 ff ff ff       	jmp    8008c3 <vprintfmt+0x38c>
			putch(ch, putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	53                   	push   %ebx
  800957:	6a 25                	push   $0x25
  800959:	ff d6                	call   *%esi
			break;
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	e9 7a ff ff ff       	jmp    8008dd <vprintfmt+0x3a6>
			putch('%', putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	53                   	push   %ebx
  800967:	6a 25                	push   $0x25
  800969:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	89 f8                	mov    %edi,%eax
  800970:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800974:	74 05                	je     80097b <vprintfmt+0x444>
  800976:	83 e8 01             	sub    $0x1,%eax
  800979:	eb f5                	jmp    800970 <vprintfmt+0x439>
  80097b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097e:	e9 5a ff ff ff       	jmp    8008dd <vprintfmt+0x3a6>
}
  800983:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800986:	5b                   	pop    %ebx
  800987:	5e                   	pop    %esi
  800988:	5f                   	pop    %edi
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80098b:	f3 0f 1e fb          	endbr32 
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	83 ec 18             	sub    $0x18,%esp
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80099b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80099e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009a2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ac:	85 c0                	test   %eax,%eax
  8009ae:	74 26                	je     8009d6 <vsnprintf+0x4b>
  8009b0:	85 d2                	test   %edx,%edx
  8009b2:	7e 22                	jle    8009d6 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b4:	ff 75 14             	pushl  0x14(%ebp)
  8009b7:	ff 75 10             	pushl  0x10(%ebp)
  8009ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	68 f5 04 80 00       	push   $0x8004f5
  8009c3:	e8 6f fb ff ff       	call   800537 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
}
  8009d4:	c9                   	leave  
  8009d5:	c3                   	ret    
		return -E_INVAL;
  8009d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009db:	eb f7                	jmp    8009d4 <vsnprintf+0x49>

008009dd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009dd:	f3 0f 1e fb          	endbr32 
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009ea:	50                   	push   %eax
  8009eb:	ff 75 10             	pushl  0x10(%ebp)
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	ff 75 08             	pushl  0x8(%ebp)
  8009f4:	e8 92 ff ff ff       	call   80098b <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009fb:	f3 0f 1e fb          	endbr32 
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a05:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a0e:	74 05                	je     800a15 <strlen+0x1a>
		n++;
  800a10:	83 c0 01             	add    $0x1,%eax
  800a13:	eb f5                	jmp    800a0a <strlen+0xf>
	return n;
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a17:	f3 0f 1e fb          	endbr32 
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a24:	b8 00 00 00 00       	mov    $0x0,%eax
  800a29:	39 d0                	cmp    %edx,%eax
  800a2b:	74 0d                	je     800a3a <strnlen+0x23>
  800a2d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a31:	74 05                	je     800a38 <strnlen+0x21>
		n++;
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	eb f1                	jmp    800a29 <strnlen+0x12>
  800a38:	89 c2                	mov    %eax,%edx
	return n;
}
  800a3a:	89 d0                	mov    %edx,%eax
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a3e:	f3 0f 1e fb          	endbr32 
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	53                   	push   %ebx
  800a46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a51:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a55:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a58:	83 c0 01             	add    $0x1,%eax
  800a5b:	84 d2                	test   %dl,%dl
  800a5d:	75 f2                	jne    800a51 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a5f:	89 c8                	mov    %ecx,%eax
  800a61:	5b                   	pop    %ebx
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a64:	f3 0f 1e fb          	endbr32 
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	53                   	push   %ebx
  800a6c:	83 ec 10             	sub    $0x10,%esp
  800a6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a72:	53                   	push   %ebx
  800a73:	e8 83 ff ff ff       	call   8009fb <strlen>
  800a78:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	01 d8                	add    %ebx,%eax
  800a80:	50                   	push   %eax
  800a81:	e8 b8 ff ff ff       	call   800a3e <strcpy>
	return dst;
}
  800a86:	89 d8                	mov    %ebx,%eax
  800a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a8d:	f3 0f 1e fb          	endbr32 
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	56                   	push   %esi
  800a95:	53                   	push   %ebx
  800a96:	8b 75 08             	mov    0x8(%ebp),%esi
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	89 f3                	mov    %esi,%ebx
  800a9e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa1:	89 f0                	mov    %esi,%eax
  800aa3:	39 d8                	cmp    %ebx,%eax
  800aa5:	74 11                	je     800ab8 <strncpy+0x2b>
		*dst++ = *src;
  800aa7:	83 c0 01             	add    $0x1,%eax
  800aaa:	0f b6 0a             	movzbl (%edx),%ecx
  800aad:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ab0:	80 f9 01             	cmp    $0x1,%cl
  800ab3:	83 da ff             	sbb    $0xffffffff,%edx
  800ab6:	eb eb                	jmp    800aa3 <strncpy+0x16>
	}
	return ret;
}
  800ab8:	89 f0                	mov    %esi,%eax
  800aba:	5b                   	pop    %ebx
  800abb:	5e                   	pop    %esi
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800abe:	f3 0f 1e fb          	endbr32 
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	56                   	push   %esi
  800ac6:	53                   	push   %ebx
  800ac7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800acd:	8b 55 10             	mov    0x10(%ebp),%edx
  800ad0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad2:	85 d2                	test   %edx,%edx
  800ad4:	74 21                	je     800af7 <strlcpy+0x39>
  800ad6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ada:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800adc:	39 c2                	cmp    %eax,%edx
  800ade:	74 14                	je     800af4 <strlcpy+0x36>
  800ae0:	0f b6 19             	movzbl (%ecx),%ebx
  800ae3:	84 db                	test   %bl,%bl
  800ae5:	74 0b                	je     800af2 <strlcpy+0x34>
			*dst++ = *src++;
  800ae7:	83 c1 01             	add    $0x1,%ecx
  800aea:	83 c2 01             	add    $0x1,%edx
  800aed:	88 5a ff             	mov    %bl,-0x1(%edx)
  800af0:	eb ea                	jmp    800adc <strlcpy+0x1e>
  800af2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800af4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800af7:	29 f0                	sub    %esi,%eax
}
  800af9:	5b                   	pop    %ebx
  800afa:	5e                   	pop    %esi
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800afd:	f3 0f 1e fb          	endbr32 
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b07:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b0a:	0f b6 01             	movzbl (%ecx),%eax
  800b0d:	84 c0                	test   %al,%al
  800b0f:	74 0c                	je     800b1d <strcmp+0x20>
  800b11:	3a 02                	cmp    (%edx),%al
  800b13:	75 08                	jne    800b1d <strcmp+0x20>
		p++, q++;
  800b15:	83 c1 01             	add    $0x1,%ecx
  800b18:	83 c2 01             	add    $0x1,%edx
  800b1b:	eb ed                	jmp    800b0a <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b1d:	0f b6 c0             	movzbl %al,%eax
  800b20:	0f b6 12             	movzbl (%edx),%edx
  800b23:	29 d0                	sub    %edx,%eax
}
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b27:	f3 0f 1e fb          	endbr32 
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	53                   	push   %ebx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b35:	89 c3                	mov    %eax,%ebx
  800b37:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b3a:	eb 06                	jmp    800b42 <strncmp+0x1b>
		n--, p++, q++;
  800b3c:	83 c0 01             	add    $0x1,%eax
  800b3f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b42:	39 d8                	cmp    %ebx,%eax
  800b44:	74 16                	je     800b5c <strncmp+0x35>
  800b46:	0f b6 08             	movzbl (%eax),%ecx
  800b49:	84 c9                	test   %cl,%cl
  800b4b:	74 04                	je     800b51 <strncmp+0x2a>
  800b4d:	3a 0a                	cmp    (%edx),%cl
  800b4f:	74 eb                	je     800b3c <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b51:	0f b6 00             	movzbl (%eax),%eax
  800b54:	0f b6 12             	movzbl (%edx),%edx
  800b57:	29 d0                	sub    %edx,%eax
}
  800b59:	5b                   	pop    %ebx
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    
		return 0;
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b61:	eb f6                	jmp    800b59 <strncmp+0x32>

00800b63 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b63:	f3 0f 1e fb          	endbr32 
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b71:	0f b6 10             	movzbl (%eax),%edx
  800b74:	84 d2                	test   %dl,%dl
  800b76:	74 09                	je     800b81 <strchr+0x1e>
		if (*s == c)
  800b78:	38 ca                	cmp    %cl,%dl
  800b7a:	74 0a                	je     800b86 <strchr+0x23>
	for (; *s; s++)
  800b7c:	83 c0 01             	add    $0x1,%eax
  800b7f:	eb f0                	jmp    800b71 <strchr+0xe>
			return (char *) s;
	return 0;
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b88:	f3 0f 1e fb          	endbr32 
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b96:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b99:	38 ca                	cmp    %cl,%dl
  800b9b:	74 09                	je     800ba6 <strfind+0x1e>
  800b9d:	84 d2                	test   %dl,%dl
  800b9f:	74 05                	je     800ba6 <strfind+0x1e>
	for (; *s; s++)
  800ba1:	83 c0 01             	add    $0x1,%eax
  800ba4:	eb f0                	jmp    800b96 <strfind+0xe>
			break;
	return (char *) s;
}
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    

00800ba8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ba8:	f3 0f 1e fb          	endbr32 
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	57                   	push   %edi
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
  800bb2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb8:	85 c9                	test   %ecx,%ecx
  800bba:	74 31                	je     800bed <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bbc:	89 f8                	mov    %edi,%eax
  800bbe:	09 c8                	or     %ecx,%eax
  800bc0:	a8 03                	test   $0x3,%al
  800bc2:	75 23                	jne    800be7 <memset+0x3f>
		c &= 0xFF;
  800bc4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc8:	89 d3                	mov    %edx,%ebx
  800bca:	c1 e3 08             	shl    $0x8,%ebx
  800bcd:	89 d0                	mov    %edx,%eax
  800bcf:	c1 e0 18             	shl    $0x18,%eax
  800bd2:	89 d6                	mov    %edx,%esi
  800bd4:	c1 e6 10             	shl    $0x10,%esi
  800bd7:	09 f0                	or     %esi,%eax
  800bd9:	09 c2                	or     %eax,%edx
  800bdb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bdd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800be0:	89 d0                	mov    %edx,%eax
  800be2:	fc                   	cld    
  800be3:	f3 ab                	rep stos %eax,%es:(%edi)
  800be5:	eb 06                	jmp    800bed <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bea:	fc                   	cld    
  800beb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bed:	89 f8                	mov    %edi,%eax
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bf4:	f3 0f 1e fb          	endbr32 
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c03:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c06:	39 c6                	cmp    %eax,%esi
  800c08:	73 32                	jae    800c3c <memmove+0x48>
  800c0a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c0d:	39 c2                	cmp    %eax,%edx
  800c0f:	76 2b                	jbe    800c3c <memmove+0x48>
		s += n;
		d += n;
  800c11:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c14:	89 fe                	mov    %edi,%esi
  800c16:	09 ce                	or     %ecx,%esi
  800c18:	09 d6                	or     %edx,%esi
  800c1a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c20:	75 0e                	jne    800c30 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c22:	83 ef 04             	sub    $0x4,%edi
  800c25:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c2b:	fd                   	std    
  800c2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2e:	eb 09                	jmp    800c39 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c30:	83 ef 01             	sub    $0x1,%edi
  800c33:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c36:	fd                   	std    
  800c37:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c39:	fc                   	cld    
  800c3a:	eb 1a                	jmp    800c56 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c3c:	89 c2                	mov    %eax,%edx
  800c3e:	09 ca                	or     %ecx,%edx
  800c40:	09 f2                	or     %esi,%edx
  800c42:	f6 c2 03             	test   $0x3,%dl
  800c45:	75 0a                	jne    800c51 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c47:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c4a:	89 c7                	mov    %eax,%edi
  800c4c:	fc                   	cld    
  800c4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c4f:	eb 05                	jmp    800c56 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c51:	89 c7                	mov    %eax,%edi
  800c53:	fc                   	cld    
  800c54:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c5a:	f3 0f 1e fb          	endbr32 
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c64:	ff 75 10             	pushl  0x10(%ebp)
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	ff 75 08             	pushl  0x8(%ebp)
  800c6d:	e8 82 ff ff ff       	call   800bf4 <memmove>
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c74:	f3 0f 1e fb          	endbr32 
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c83:	89 c6                	mov    %eax,%esi
  800c85:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c88:	39 f0                	cmp    %esi,%eax
  800c8a:	74 1c                	je     800ca8 <memcmp+0x34>
		if (*s1 != *s2)
  800c8c:	0f b6 08             	movzbl (%eax),%ecx
  800c8f:	0f b6 1a             	movzbl (%edx),%ebx
  800c92:	38 d9                	cmp    %bl,%cl
  800c94:	75 08                	jne    800c9e <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c96:	83 c0 01             	add    $0x1,%eax
  800c99:	83 c2 01             	add    $0x1,%edx
  800c9c:	eb ea                	jmp    800c88 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c9e:	0f b6 c1             	movzbl %cl,%eax
  800ca1:	0f b6 db             	movzbl %bl,%ebx
  800ca4:	29 d8                	sub    %ebx,%eax
  800ca6:	eb 05                	jmp    800cad <memcmp+0x39>
	}

	return 0;
  800ca8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cb1:	f3 0f 1e fb          	endbr32 
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cbe:	89 c2                	mov    %eax,%edx
  800cc0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cc3:	39 d0                	cmp    %edx,%eax
  800cc5:	73 09                	jae    800cd0 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cc7:	38 08                	cmp    %cl,(%eax)
  800cc9:	74 05                	je     800cd0 <memfind+0x1f>
	for (; s < ends; s++)
  800ccb:	83 c0 01             	add    $0x1,%eax
  800cce:	eb f3                	jmp    800cc3 <memfind+0x12>
			break;
	return (void *) s;
}
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd2:	f3 0f 1e fb          	endbr32 
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce2:	eb 03                	jmp    800ce7 <strtol+0x15>
		s++;
  800ce4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ce7:	0f b6 01             	movzbl (%ecx),%eax
  800cea:	3c 20                	cmp    $0x20,%al
  800cec:	74 f6                	je     800ce4 <strtol+0x12>
  800cee:	3c 09                	cmp    $0x9,%al
  800cf0:	74 f2                	je     800ce4 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800cf2:	3c 2b                	cmp    $0x2b,%al
  800cf4:	74 2a                	je     800d20 <strtol+0x4e>
	int neg = 0;
  800cf6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cfb:	3c 2d                	cmp    $0x2d,%al
  800cfd:	74 2b                	je     800d2a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cff:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d05:	75 0f                	jne    800d16 <strtol+0x44>
  800d07:	80 39 30             	cmpb   $0x30,(%ecx)
  800d0a:	74 28                	je     800d34 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d0c:	85 db                	test   %ebx,%ebx
  800d0e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d13:	0f 44 d8             	cmove  %eax,%ebx
  800d16:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d1e:	eb 46                	jmp    800d66 <strtol+0x94>
		s++;
  800d20:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d23:	bf 00 00 00 00       	mov    $0x0,%edi
  800d28:	eb d5                	jmp    800cff <strtol+0x2d>
		s++, neg = 1;
  800d2a:	83 c1 01             	add    $0x1,%ecx
  800d2d:	bf 01 00 00 00       	mov    $0x1,%edi
  800d32:	eb cb                	jmp    800cff <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d34:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d38:	74 0e                	je     800d48 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d3a:	85 db                	test   %ebx,%ebx
  800d3c:	75 d8                	jne    800d16 <strtol+0x44>
		s++, base = 8;
  800d3e:	83 c1 01             	add    $0x1,%ecx
  800d41:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d46:	eb ce                	jmp    800d16 <strtol+0x44>
		s += 2, base = 16;
  800d48:	83 c1 02             	add    $0x2,%ecx
  800d4b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d50:	eb c4                	jmp    800d16 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d52:	0f be d2             	movsbl %dl,%edx
  800d55:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d58:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d5b:	7d 3a                	jge    800d97 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d5d:	83 c1 01             	add    $0x1,%ecx
  800d60:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d64:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d66:	0f b6 11             	movzbl (%ecx),%edx
  800d69:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d6c:	89 f3                	mov    %esi,%ebx
  800d6e:	80 fb 09             	cmp    $0x9,%bl
  800d71:	76 df                	jbe    800d52 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d73:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d76:	89 f3                	mov    %esi,%ebx
  800d78:	80 fb 19             	cmp    $0x19,%bl
  800d7b:	77 08                	ja     800d85 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d7d:	0f be d2             	movsbl %dl,%edx
  800d80:	83 ea 57             	sub    $0x57,%edx
  800d83:	eb d3                	jmp    800d58 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d85:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d88:	89 f3                	mov    %esi,%ebx
  800d8a:	80 fb 19             	cmp    $0x19,%bl
  800d8d:	77 08                	ja     800d97 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d8f:	0f be d2             	movsbl %dl,%edx
  800d92:	83 ea 37             	sub    $0x37,%edx
  800d95:	eb c1                	jmp    800d58 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9b:	74 05                	je     800da2 <strtol+0xd0>
		*endptr = (char *) s;
  800d9d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800da0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800da2:	89 c2                	mov    %eax,%edx
  800da4:	f7 da                	neg    %edx
  800da6:	85 ff                	test   %edi,%edi
  800da8:	0f 45 c2             	cmovne %edx,%eax
}
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <__udivdi3>:
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 1c             	sub    $0x1c,%esp
  800dbb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800dbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800dc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800dc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800dcb:	85 d2                	test   %edx,%edx
  800dcd:	75 19                	jne    800de8 <__udivdi3+0x38>
  800dcf:	39 f3                	cmp    %esi,%ebx
  800dd1:	76 4d                	jbe    800e20 <__udivdi3+0x70>
  800dd3:	31 ff                	xor    %edi,%edi
  800dd5:	89 e8                	mov    %ebp,%eax
  800dd7:	89 f2                	mov    %esi,%edx
  800dd9:	f7 f3                	div    %ebx
  800ddb:	89 fa                	mov    %edi,%edx
  800ddd:	83 c4 1c             	add    $0x1c,%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
  800de5:	8d 76 00             	lea    0x0(%esi),%esi
  800de8:	39 f2                	cmp    %esi,%edx
  800dea:	76 14                	jbe    800e00 <__udivdi3+0x50>
  800dec:	31 ff                	xor    %edi,%edi
  800dee:	31 c0                	xor    %eax,%eax
  800df0:	89 fa                	mov    %edi,%edx
  800df2:	83 c4 1c             	add    $0x1c,%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    
  800dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e00:	0f bd fa             	bsr    %edx,%edi
  800e03:	83 f7 1f             	xor    $0x1f,%edi
  800e06:	75 48                	jne    800e50 <__udivdi3+0xa0>
  800e08:	39 f2                	cmp    %esi,%edx
  800e0a:	72 06                	jb     800e12 <__udivdi3+0x62>
  800e0c:	31 c0                	xor    %eax,%eax
  800e0e:	39 eb                	cmp    %ebp,%ebx
  800e10:	77 de                	ja     800df0 <__udivdi3+0x40>
  800e12:	b8 01 00 00 00       	mov    $0x1,%eax
  800e17:	eb d7                	jmp    800df0 <__udivdi3+0x40>
  800e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e20:	89 d9                	mov    %ebx,%ecx
  800e22:	85 db                	test   %ebx,%ebx
  800e24:	75 0b                	jne    800e31 <__udivdi3+0x81>
  800e26:	b8 01 00 00 00       	mov    $0x1,%eax
  800e2b:	31 d2                	xor    %edx,%edx
  800e2d:	f7 f3                	div    %ebx
  800e2f:	89 c1                	mov    %eax,%ecx
  800e31:	31 d2                	xor    %edx,%edx
  800e33:	89 f0                	mov    %esi,%eax
  800e35:	f7 f1                	div    %ecx
  800e37:	89 c6                	mov    %eax,%esi
  800e39:	89 e8                	mov    %ebp,%eax
  800e3b:	89 f7                	mov    %esi,%edi
  800e3d:	f7 f1                	div    %ecx
  800e3f:	89 fa                	mov    %edi,%edx
  800e41:	83 c4 1c             	add    $0x1c,%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
  800e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e50:	89 f9                	mov    %edi,%ecx
  800e52:	b8 20 00 00 00       	mov    $0x20,%eax
  800e57:	29 f8                	sub    %edi,%eax
  800e59:	d3 e2                	shl    %cl,%edx
  800e5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e5f:	89 c1                	mov    %eax,%ecx
  800e61:	89 da                	mov    %ebx,%edx
  800e63:	d3 ea                	shr    %cl,%edx
  800e65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e69:	09 d1                	or     %edx,%ecx
  800e6b:	89 f2                	mov    %esi,%edx
  800e6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e71:	89 f9                	mov    %edi,%ecx
  800e73:	d3 e3                	shl    %cl,%ebx
  800e75:	89 c1                	mov    %eax,%ecx
  800e77:	d3 ea                	shr    %cl,%edx
  800e79:	89 f9                	mov    %edi,%ecx
  800e7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e7f:	89 eb                	mov    %ebp,%ebx
  800e81:	d3 e6                	shl    %cl,%esi
  800e83:	89 c1                	mov    %eax,%ecx
  800e85:	d3 eb                	shr    %cl,%ebx
  800e87:	09 de                	or     %ebx,%esi
  800e89:	89 f0                	mov    %esi,%eax
  800e8b:	f7 74 24 08          	divl   0x8(%esp)
  800e8f:	89 d6                	mov    %edx,%esi
  800e91:	89 c3                	mov    %eax,%ebx
  800e93:	f7 64 24 0c          	mull   0xc(%esp)
  800e97:	39 d6                	cmp    %edx,%esi
  800e99:	72 15                	jb     800eb0 <__udivdi3+0x100>
  800e9b:	89 f9                	mov    %edi,%ecx
  800e9d:	d3 e5                	shl    %cl,%ebp
  800e9f:	39 c5                	cmp    %eax,%ebp
  800ea1:	73 04                	jae    800ea7 <__udivdi3+0xf7>
  800ea3:	39 d6                	cmp    %edx,%esi
  800ea5:	74 09                	je     800eb0 <__udivdi3+0x100>
  800ea7:	89 d8                	mov    %ebx,%eax
  800ea9:	31 ff                	xor    %edi,%edi
  800eab:	e9 40 ff ff ff       	jmp    800df0 <__udivdi3+0x40>
  800eb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800eb3:	31 ff                	xor    %edi,%edi
  800eb5:	e9 36 ff ff ff       	jmp    800df0 <__udivdi3+0x40>
  800eba:	66 90                	xchg   %ax,%ax
  800ebc:	66 90                	xchg   %ax,%ax
  800ebe:	66 90                	xchg   %ax,%ax

00800ec0 <__umoddi3>:
  800ec0:	f3 0f 1e fb          	endbr32 
  800ec4:	55                   	push   %ebp
  800ec5:	57                   	push   %edi
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 1c             	sub    $0x1c,%esp
  800ecb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800ecf:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ed3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ed7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800edb:	85 c0                	test   %eax,%eax
  800edd:	75 19                	jne    800ef8 <__umoddi3+0x38>
  800edf:	39 df                	cmp    %ebx,%edi
  800ee1:	76 5d                	jbe    800f40 <__umoddi3+0x80>
  800ee3:	89 f0                	mov    %esi,%eax
  800ee5:	89 da                	mov    %ebx,%edx
  800ee7:	f7 f7                	div    %edi
  800ee9:	89 d0                	mov    %edx,%eax
  800eeb:	31 d2                	xor    %edx,%edx
  800eed:	83 c4 1c             	add    $0x1c,%esp
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    
  800ef5:	8d 76 00             	lea    0x0(%esi),%esi
  800ef8:	89 f2                	mov    %esi,%edx
  800efa:	39 d8                	cmp    %ebx,%eax
  800efc:	76 12                	jbe    800f10 <__umoddi3+0x50>
  800efe:	89 f0                	mov    %esi,%eax
  800f00:	89 da                	mov    %ebx,%edx
  800f02:	83 c4 1c             	add    $0x1c,%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    
  800f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f10:	0f bd e8             	bsr    %eax,%ebp
  800f13:	83 f5 1f             	xor    $0x1f,%ebp
  800f16:	75 50                	jne    800f68 <__umoddi3+0xa8>
  800f18:	39 d8                	cmp    %ebx,%eax
  800f1a:	0f 82 e0 00 00 00    	jb     801000 <__umoddi3+0x140>
  800f20:	89 d9                	mov    %ebx,%ecx
  800f22:	39 f7                	cmp    %esi,%edi
  800f24:	0f 86 d6 00 00 00    	jbe    801000 <__umoddi3+0x140>
  800f2a:	89 d0                	mov    %edx,%eax
  800f2c:	89 ca                	mov    %ecx,%edx
  800f2e:	83 c4 1c             	add    $0x1c,%esp
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    
  800f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f3d:	8d 76 00             	lea    0x0(%esi),%esi
  800f40:	89 fd                	mov    %edi,%ebp
  800f42:	85 ff                	test   %edi,%edi
  800f44:	75 0b                	jne    800f51 <__umoddi3+0x91>
  800f46:	b8 01 00 00 00       	mov    $0x1,%eax
  800f4b:	31 d2                	xor    %edx,%edx
  800f4d:	f7 f7                	div    %edi
  800f4f:	89 c5                	mov    %eax,%ebp
  800f51:	89 d8                	mov    %ebx,%eax
  800f53:	31 d2                	xor    %edx,%edx
  800f55:	f7 f5                	div    %ebp
  800f57:	89 f0                	mov    %esi,%eax
  800f59:	f7 f5                	div    %ebp
  800f5b:	89 d0                	mov    %edx,%eax
  800f5d:	31 d2                	xor    %edx,%edx
  800f5f:	eb 8c                	jmp    800eed <__umoddi3+0x2d>
  800f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f68:	89 e9                	mov    %ebp,%ecx
  800f6a:	ba 20 00 00 00       	mov    $0x20,%edx
  800f6f:	29 ea                	sub    %ebp,%edx
  800f71:	d3 e0                	shl    %cl,%eax
  800f73:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f77:	89 d1                	mov    %edx,%ecx
  800f79:	89 f8                	mov    %edi,%eax
  800f7b:	d3 e8                	shr    %cl,%eax
  800f7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f81:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f85:	8b 54 24 04          	mov    0x4(%esp),%edx
  800f89:	09 c1                	or     %eax,%ecx
  800f8b:	89 d8                	mov    %ebx,%eax
  800f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f91:	89 e9                	mov    %ebp,%ecx
  800f93:	d3 e7                	shl    %cl,%edi
  800f95:	89 d1                	mov    %edx,%ecx
  800f97:	d3 e8                	shr    %cl,%eax
  800f99:	89 e9                	mov    %ebp,%ecx
  800f9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800f9f:	d3 e3                	shl    %cl,%ebx
  800fa1:	89 c7                	mov    %eax,%edi
  800fa3:	89 d1                	mov    %edx,%ecx
  800fa5:	89 f0                	mov    %esi,%eax
  800fa7:	d3 e8                	shr    %cl,%eax
  800fa9:	89 e9                	mov    %ebp,%ecx
  800fab:	89 fa                	mov    %edi,%edx
  800fad:	d3 e6                	shl    %cl,%esi
  800faf:	09 d8                	or     %ebx,%eax
  800fb1:	f7 74 24 08          	divl   0x8(%esp)
  800fb5:	89 d1                	mov    %edx,%ecx
  800fb7:	89 f3                	mov    %esi,%ebx
  800fb9:	f7 64 24 0c          	mull   0xc(%esp)
  800fbd:	89 c6                	mov    %eax,%esi
  800fbf:	89 d7                	mov    %edx,%edi
  800fc1:	39 d1                	cmp    %edx,%ecx
  800fc3:	72 06                	jb     800fcb <__umoddi3+0x10b>
  800fc5:	75 10                	jne    800fd7 <__umoddi3+0x117>
  800fc7:	39 c3                	cmp    %eax,%ebx
  800fc9:	73 0c                	jae    800fd7 <__umoddi3+0x117>
  800fcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800fcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800fd3:	89 d7                	mov    %edx,%edi
  800fd5:	89 c6                	mov    %eax,%esi
  800fd7:	89 ca                	mov    %ecx,%edx
  800fd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fde:	29 f3                	sub    %esi,%ebx
  800fe0:	19 fa                	sbb    %edi,%edx
  800fe2:	89 d0                	mov    %edx,%eax
  800fe4:	d3 e0                	shl    %cl,%eax
  800fe6:	89 e9                	mov    %ebp,%ecx
  800fe8:	d3 eb                	shr    %cl,%ebx
  800fea:	d3 ea                	shr    %cl,%edx
  800fec:	09 d8                	or     %ebx,%eax
  800fee:	83 c4 1c             	add    $0x1c,%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    
  800ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ffd:	8d 76 00             	lea    0x0(%esi),%esi
  801000:	29 fe                	sub    %edi,%esi
  801002:	19 c3                	sbb    %eax,%ebx
  801004:	89 f2                	mov    %esi,%edx
  801006:	89 d9                	mov    %ebx,%ecx
  801008:	e9 1d ff ff ff       	jmp    800f2a <__umoddi3+0x6a>
