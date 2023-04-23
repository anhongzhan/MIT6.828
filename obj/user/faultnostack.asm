
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 27 00 00 00       	call   800058 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80003d:	68 50 04 80 00       	push   $0x800450
  800042:	6a 00                	push   $0x0
  800044:	e8 a6 02 00 00       	call   8002ef <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800049:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800050:	00 00 00 
}
  800053:	83 c4 10             	add    $0x10,%esp
  800056:	c9                   	leave  
  800057:	c3                   	ret    

00800058 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800058:	f3 0f 1e fb          	endbr32 
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	56                   	push   %esi
  800060:	53                   	push   %ebx
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800067:	e8 de 00 00 00       	call   80014a <sys_getenvid>
  80006c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800071:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800074:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800079:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007e:	85 db                	test   %ebx,%ebx
  800080:	7e 07                	jle    800089 <libmain+0x31>
		binaryname = argv[0];
  800082:	8b 06                	mov    (%esi),%eax
  800084:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	56                   	push   %esi
  80008d:	53                   	push   %ebx
  80008e:	e8 a0 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800093:	e8 0a 00 00 00       	call   8000a2 <exit>
}
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009e:	5b                   	pop    %ebx
  80009f:	5e                   	pop    %esi
  8000a0:	5d                   	pop    %ebp
  8000a1:	c3                   	ret    

008000a2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a2:	f3 0f 1e fb          	endbr32 
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ac:	e8 b9 05 00 00       	call   80066a <close_all>
	sys_env_destroy(0);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	6a 00                	push   $0x0
  8000b6:	e8 4a 00 00 00       	call   800105 <sys_env_destroy>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c0:	f3 0f 1e fb          	endbr32 
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d5:	89 c3                	mov    %eax,%ebx
  8000d7:	89 c7                	mov    %eax,%edi
  8000d9:	89 c6                	mov    %eax,%esi
  8000db:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    

008000e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e2:	f3 0f 1e fb          	endbr32 
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	57                   	push   %edi
  8000ea:	56                   	push   %esi
  8000eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f6:	89 d1                	mov    %edx,%ecx
  8000f8:	89 d3                	mov    %edx,%ebx
  8000fa:	89 d7                	mov    %edx,%edi
  8000fc:	89 d6                	mov    %edx,%esi
  8000fe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5f                   	pop    %edi
  800103:	5d                   	pop    %ebp
  800104:	c3                   	ret    

00800105 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800105:	f3 0f 1e fb          	endbr32 
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	57                   	push   %edi
  80010d:	56                   	push   %esi
  80010e:	53                   	push   %ebx
  80010f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800112:	b9 00 00 00 00       	mov    $0x0,%ecx
  800117:	8b 55 08             	mov    0x8(%ebp),%edx
  80011a:	b8 03 00 00 00       	mov    $0x3,%eax
  80011f:	89 cb                	mov    %ecx,%ebx
  800121:	89 cf                	mov    %ecx,%edi
  800123:	89 ce                	mov    %ecx,%esi
  800125:	cd 30                	int    $0x30
	if(check && ret > 0)
  800127:	85 c0                	test   %eax,%eax
  800129:	7f 08                	jg     800133 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80012b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5f                   	pop    %edi
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	6a 03                	push   $0x3
  800139:	68 2a 25 80 00       	push   $0x80252a
  80013e:	6a 23                	push   $0x23
  800140:	68 47 25 80 00       	push   $0x802547
  800145:	e8 2e 15 00 00       	call   801678 <_panic>

0080014a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80014a:	f3 0f 1e fb          	endbr32 
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	57                   	push   %edi
  800152:	56                   	push   %esi
  800153:	53                   	push   %ebx
	asm volatile("int %1\n"
  800154:	ba 00 00 00 00       	mov    $0x0,%edx
  800159:	b8 02 00 00 00       	mov    $0x2,%eax
  80015e:	89 d1                	mov    %edx,%ecx
  800160:	89 d3                	mov    %edx,%ebx
  800162:	89 d7                	mov    %edx,%edi
  800164:	89 d6                	mov    %edx,%esi
  800166:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800168:	5b                   	pop    %ebx
  800169:	5e                   	pop    %esi
  80016a:	5f                   	pop    %edi
  80016b:	5d                   	pop    %ebp
  80016c:	c3                   	ret    

0080016d <sys_yield>:

void
sys_yield(void)
{
  80016d:	f3 0f 1e fb          	endbr32 
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	57                   	push   %edi
  800175:	56                   	push   %esi
  800176:	53                   	push   %ebx
	asm volatile("int %1\n"
  800177:	ba 00 00 00 00       	mov    $0x0,%edx
  80017c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800181:	89 d1                	mov    %edx,%ecx
  800183:	89 d3                	mov    %edx,%ebx
  800185:	89 d7                	mov    %edx,%edi
  800187:	89 d6                	mov    %edx,%esi
  800189:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80018b:	5b                   	pop    %ebx
  80018c:	5e                   	pop    %esi
  80018d:	5f                   	pop    %edi
  80018e:	5d                   	pop    %ebp
  80018f:	c3                   	ret    

00800190 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800190:	f3 0f 1e fb          	endbr32 
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019d:	be 00 00 00 00       	mov    $0x0,%esi
  8001a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a8:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b0:	89 f7                	mov    %esi,%edi
  8001b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	7f 08                	jg     8001c0 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	6a 04                	push   $0x4
  8001c6:	68 2a 25 80 00       	push   $0x80252a
  8001cb:	6a 23                	push   $0x23
  8001cd:	68 47 25 80 00       	push   $0x802547
  8001d2:	e8 a1 14 00 00       	call   801678 <_panic>

008001d7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d7:	f3 0f 1e fb          	endbr32 
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001f5:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7f 08                	jg     800206 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	50                   	push   %eax
  80020a:	6a 05                	push   $0x5
  80020c:	68 2a 25 80 00       	push   $0x80252a
  800211:	6a 23                	push   $0x23
  800213:	68 47 25 80 00       	push   $0x802547
  800218:	e8 5b 14 00 00       	call   801678 <_panic>

0080021d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80021d:	f3 0f 1e fb          	endbr32 
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022f:	8b 55 08             	mov    0x8(%ebp),%edx
  800232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800235:	b8 06 00 00 00       	mov    $0x6,%eax
  80023a:	89 df                	mov    %ebx,%edi
  80023c:	89 de                	mov    %ebx,%esi
  80023e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800240:	85 c0                	test   %eax,%eax
  800242:	7f 08                	jg     80024c <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	6a 06                	push   $0x6
  800252:	68 2a 25 80 00       	push   $0x80252a
  800257:	6a 23                	push   $0x23
  800259:	68 47 25 80 00       	push   $0x802547
  80025e:	e8 15 14 00 00       	call   801678 <_panic>

00800263 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800263:	f3 0f 1e fb          	endbr32 
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 08 00 00 00       	mov    $0x8,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
	if(check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 08                	push   $0x8
  800298:	68 2a 25 80 00       	push   $0x80252a
  80029d:	6a 23                	push   $0x23
  80029f:	68 47 25 80 00       	push   $0x802547
  8002a4:	e8 cf 13 00 00       	call   801678 <_panic>

008002a9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a9:	f3 0f 1e fb          	endbr32 
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	57                   	push   %edi
  8002b1:	56                   	push   %esi
  8002b2:	53                   	push   %ebx
  8002b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c1:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c6:	89 df                	mov    %ebx,%edi
  8002c8:	89 de                	mov    %ebx,%esi
  8002ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	7f 08                	jg     8002d8 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d3:	5b                   	pop    %ebx
  8002d4:	5e                   	pop    %esi
  8002d5:	5f                   	pop    %edi
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	6a 09                	push   $0x9
  8002de:	68 2a 25 80 00       	push   $0x80252a
  8002e3:	6a 23                	push   $0x23
  8002e5:	68 47 25 80 00       	push   $0x802547
  8002ea:	e8 89 13 00 00       	call   801678 <_panic>

008002ef <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ef:	f3 0f 1e fb          	endbr32 
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
  8002f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800301:	8b 55 08             	mov    0x8(%ebp),%edx
  800304:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800307:	b8 0a 00 00 00       	mov    $0xa,%eax
  80030c:	89 df                	mov    %ebx,%edi
  80030e:	89 de                	mov    %ebx,%esi
  800310:	cd 30                	int    $0x30
	if(check && ret > 0)
  800312:	85 c0                	test   %eax,%eax
  800314:	7f 08                	jg     80031e <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800316:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800319:	5b                   	pop    %ebx
  80031a:	5e                   	pop    %esi
  80031b:	5f                   	pop    %edi
  80031c:	5d                   	pop    %ebp
  80031d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	50                   	push   %eax
  800322:	6a 0a                	push   $0xa
  800324:	68 2a 25 80 00       	push   $0x80252a
  800329:	6a 23                	push   $0x23
  80032b:	68 47 25 80 00       	push   $0x802547
  800330:	e8 43 13 00 00       	call   801678 <_panic>

00800335 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800335:	f3 0f 1e fb          	endbr32 
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	57                   	push   %edi
  80033d:	56                   	push   %esi
  80033e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80033f:	8b 55 08             	mov    0x8(%ebp),%edx
  800342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800345:	b8 0c 00 00 00       	mov    $0xc,%eax
  80034a:	be 00 00 00 00       	mov    $0x0,%esi
  80034f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800352:	8b 7d 14             	mov    0x14(%ebp),%edi
  800355:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800357:	5b                   	pop    %ebx
  800358:	5e                   	pop    %esi
  800359:	5f                   	pop    %edi
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80035c:	f3 0f 1e fb          	endbr32 
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	57                   	push   %edi
  800364:	56                   	push   %esi
  800365:	53                   	push   %ebx
  800366:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800369:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036e:	8b 55 08             	mov    0x8(%ebp),%edx
  800371:	b8 0d 00 00 00       	mov    $0xd,%eax
  800376:	89 cb                	mov    %ecx,%ebx
  800378:	89 cf                	mov    %ecx,%edi
  80037a:	89 ce                	mov    %ecx,%esi
  80037c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80037e:	85 c0                	test   %eax,%eax
  800380:	7f 08                	jg     80038a <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800385:	5b                   	pop    %ebx
  800386:	5e                   	pop    %esi
  800387:	5f                   	pop    %edi
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80038a:	83 ec 0c             	sub    $0xc,%esp
  80038d:	50                   	push   %eax
  80038e:	6a 0d                	push   $0xd
  800390:	68 2a 25 80 00       	push   $0x80252a
  800395:	6a 23                	push   $0x23
  800397:	68 47 25 80 00       	push   $0x802547
  80039c:	e8 d7 12 00 00       	call   801678 <_panic>

008003a1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003a1:	f3 0f 1e fb          	endbr32 
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	57                   	push   %edi
  8003a9:	56                   	push   %esi
  8003aa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b0:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003b5:	89 d1                	mov    %edx,%ecx
  8003b7:	89 d3                	mov    %edx,%ebx
  8003b9:	89 d7                	mov    %edx,%edi
  8003bb:	89 d6                	mov    %edx,%esi
  8003bd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003bf:	5b                   	pop    %ebx
  8003c0:	5e                   	pop    %esi
  8003c1:	5f                   	pop    %edi
  8003c2:	5d                   	pop    %ebp
  8003c3:	c3                   	ret    

008003c4 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8003c4:	f3 0f 1e fb          	endbr32 
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	57                   	push   %edi
  8003cc:	56                   	push   %esi
  8003cd:	53                   	push   %ebx
  8003ce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dc:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003e1:	89 df                	mov    %ebx,%edi
  8003e3:	89 de                	mov    %ebx,%esi
  8003e5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	7f 08                	jg     8003f3 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8003eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ee:	5b                   	pop    %ebx
  8003ef:	5e                   	pop    %esi
  8003f0:	5f                   	pop    %edi
  8003f1:	5d                   	pop    %ebp
  8003f2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003f3:	83 ec 0c             	sub    $0xc,%esp
  8003f6:	50                   	push   %eax
  8003f7:	6a 0f                	push   $0xf
  8003f9:	68 2a 25 80 00       	push   $0x80252a
  8003fe:	6a 23                	push   $0x23
  800400:	68 47 25 80 00       	push   $0x802547
  800405:	e8 6e 12 00 00       	call   801678 <_panic>

0080040a <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  80040a:	f3 0f 1e fb          	endbr32 
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	57                   	push   %edi
  800412:	56                   	push   %esi
  800413:	53                   	push   %ebx
  800414:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800417:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041c:	8b 55 08             	mov    0x8(%ebp),%edx
  80041f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800422:	b8 10 00 00 00       	mov    $0x10,%eax
  800427:	89 df                	mov    %ebx,%edi
  800429:	89 de                	mov    %ebx,%esi
  80042b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80042d:	85 c0                	test   %eax,%eax
  80042f:	7f 08                	jg     800439 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800431:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800434:	5b                   	pop    %ebx
  800435:	5e                   	pop    %esi
  800436:	5f                   	pop    %edi
  800437:	5d                   	pop    %ebp
  800438:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800439:	83 ec 0c             	sub    $0xc,%esp
  80043c:	50                   	push   %eax
  80043d:	6a 10                	push   $0x10
  80043f:	68 2a 25 80 00       	push   $0x80252a
  800444:	6a 23                	push   $0x23
  800446:	68 47 25 80 00       	push   $0x802547
  80044b:	e8 28 12 00 00       	call   801678 <_panic>

00800450 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800450:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800451:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  800456:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800458:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  80045b:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80045f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800463:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800466:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800468:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80046c:	83 c4 08             	add    $0x8,%esp
	popal
  80046f:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800470:	83 c4 04             	add    $0x4,%esp
	popfl
  800473:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800474:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800475:	c3                   	ret    

00800476 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800476:	f3 0f 1e fb          	endbr32 
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	05 00 00 00 30       	add    $0x30000000,%eax
  800485:	c1 e8 0c             	shr    $0xc,%eax
}
  800488:	5d                   	pop    %ebp
  800489:	c3                   	ret    

0080048a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80048a:	f3 0f 1e fb          	endbr32 
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800499:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8004a3:	5d                   	pop    %ebp
  8004a4:	c3                   	ret    

008004a5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004a5:	f3 0f 1e fb          	endbr32 
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004b1:	89 c2                	mov    %eax,%edx
  8004b3:	c1 ea 16             	shr    $0x16,%edx
  8004b6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004bd:	f6 c2 01             	test   $0x1,%dl
  8004c0:	74 2d                	je     8004ef <fd_alloc+0x4a>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	c1 ea 0c             	shr    $0xc,%edx
  8004c7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004ce:	f6 c2 01             	test   $0x1,%dl
  8004d1:	74 1c                	je     8004ef <fd_alloc+0x4a>
  8004d3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8004d8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8004dd:	75 d2                	jne    8004b1 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004e8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8004ed:	eb 0a                	jmp    8004f9 <fd_alloc+0x54>
			*fd_store = fd;
  8004ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004f2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004f9:	5d                   	pop    %ebp
  8004fa:	c3                   	ret    

008004fb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004fb:	f3 0f 1e fb          	endbr32 
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800505:	83 f8 1f             	cmp    $0x1f,%eax
  800508:	77 30                	ja     80053a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80050a:	c1 e0 0c             	shl    $0xc,%eax
  80050d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800512:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800518:	f6 c2 01             	test   $0x1,%dl
  80051b:	74 24                	je     800541 <fd_lookup+0x46>
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	c1 ea 0c             	shr    $0xc,%edx
  800522:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800529:	f6 c2 01             	test   $0x1,%dl
  80052c:	74 1a                	je     800548 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80052e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800531:	89 02                	mov    %eax,(%edx)
	return 0;
  800533:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800538:	5d                   	pop    %ebp
  800539:	c3                   	ret    
		return -E_INVAL;
  80053a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80053f:	eb f7                	jmp    800538 <fd_lookup+0x3d>
		return -E_INVAL;
  800541:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800546:	eb f0                	jmp    800538 <fd_lookup+0x3d>
  800548:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80054d:	eb e9                	jmp    800538 <fd_lookup+0x3d>

0080054f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80054f:	f3 0f 1e fb          	endbr32 
  800553:	55                   	push   %ebp
  800554:	89 e5                	mov    %esp,%ebp
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80055c:	ba 00 00 00 00       	mov    $0x0,%edx
  800561:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800566:	39 08                	cmp    %ecx,(%eax)
  800568:	74 38                	je     8005a2 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80056a:	83 c2 01             	add    $0x1,%edx
  80056d:	8b 04 95 d4 25 80 00 	mov    0x8025d4(,%edx,4),%eax
  800574:	85 c0                	test   %eax,%eax
  800576:	75 ee                	jne    800566 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800578:	a1 08 40 80 00       	mov    0x804008,%eax
  80057d:	8b 40 48             	mov    0x48(%eax),%eax
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	51                   	push   %ecx
  800584:	50                   	push   %eax
  800585:	68 58 25 80 00       	push   $0x802558
  80058a:	e8 d0 11 00 00       	call   80175f <cprintf>
	*dev = 0;
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800598:	83 c4 10             	add    $0x10,%esp
  80059b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    
			*dev = devtab[i];
  8005a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005a5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ac:	eb f2                	jmp    8005a0 <dev_lookup+0x51>

008005ae <fd_close>:
{
  8005ae:	f3 0f 1e fb          	endbr32 
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	57                   	push   %edi
  8005b6:	56                   	push   %esi
  8005b7:	53                   	push   %ebx
  8005b8:	83 ec 24             	sub    $0x24,%esp
  8005bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005be:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005c4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005c5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8005cb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005ce:	50                   	push   %eax
  8005cf:	e8 27 ff ff ff       	call   8004fb <fd_lookup>
  8005d4:	89 c3                	mov    %eax,%ebx
  8005d6:	83 c4 10             	add    $0x10,%esp
  8005d9:	85 c0                	test   %eax,%eax
  8005db:	78 05                	js     8005e2 <fd_close+0x34>
	    || fd != fd2)
  8005dd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8005e0:	74 16                	je     8005f8 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8005e2:	89 f8                	mov    %edi,%eax
  8005e4:	84 c0                	test   %al,%al
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	0f 44 d8             	cmove  %eax,%ebx
}
  8005ee:	89 d8                	mov    %ebx,%eax
  8005f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005f3:	5b                   	pop    %ebx
  8005f4:	5e                   	pop    %esi
  8005f5:	5f                   	pop    %edi
  8005f6:	5d                   	pop    %ebp
  8005f7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005fe:	50                   	push   %eax
  8005ff:	ff 36                	pushl  (%esi)
  800601:	e8 49 ff ff ff       	call   80054f <dev_lookup>
  800606:	89 c3                	mov    %eax,%ebx
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	85 c0                	test   %eax,%eax
  80060d:	78 1a                	js     800629 <fd_close+0x7b>
		if (dev->dev_close)
  80060f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800612:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800615:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80061a:	85 c0                	test   %eax,%eax
  80061c:	74 0b                	je     800629 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80061e:	83 ec 0c             	sub    $0xc,%esp
  800621:	56                   	push   %esi
  800622:	ff d0                	call   *%eax
  800624:	89 c3                	mov    %eax,%ebx
  800626:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	56                   	push   %esi
  80062d:	6a 00                	push   $0x0
  80062f:	e8 e9 fb ff ff       	call   80021d <sys_page_unmap>
	return r;
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	eb b5                	jmp    8005ee <fd_close+0x40>

00800639 <close>:

int
close(int fdnum)
{
  800639:	f3 0f 1e fb          	endbr32 
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800643:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800646:	50                   	push   %eax
  800647:	ff 75 08             	pushl  0x8(%ebp)
  80064a:	e8 ac fe ff ff       	call   8004fb <fd_lookup>
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	85 c0                	test   %eax,%eax
  800654:	79 02                	jns    800658 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800656:	c9                   	leave  
  800657:	c3                   	ret    
		return fd_close(fd, 1);
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	6a 01                	push   $0x1
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	e8 49 ff ff ff       	call   8005ae <fd_close>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	eb ec                	jmp    800656 <close+0x1d>

0080066a <close_all>:

void
close_all(void)
{
  80066a:	f3 0f 1e fb          	endbr32 
  80066e:	55                   	push   %ebp
  80066f:	89 e5                	mov    %esp,%ebp
  800671:	53                   	push   %ebx
  800672:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800675:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80067a:	83 ec 0c             	sub    $0xc,%esp
  80067d:	53                   	push   %ebx
  80067e:	e8 b6 ff ff ff       	call   800639 <close>
	for (i = 0; i < MAXFD; i++)
  800683:	83 c3 01             	add    $0x1,%ebx
  800686:	83 c4 10             	add    $0x10,%esp
  800689:	83 fb 20             	cmp    $0x20,%ebx
  80068c:	75 ec                	jne    80067a <close_all+0x10>
}
  80068e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800691:	c9                   	leave  
  800692:	c3                   	ret    

00800693 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800693:	f3 0f 1e fb          	endbr32 
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
  80069a:	57                   	push   %edi
  80069b:	56                   	push   %esi
  80069c:	53                   	push   %ebx
  80069d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006a3:	50                   	push   %eax
  8006a4:	ff 75 08             	pushl  0x8(%ebp)
  8006a7:	e8 4f fe ff ff       	call   8004fb <fd_lookup>
  8006ac:	89 c3                	mov    %eax,%ebx
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	85 c0                	test   %eax,%eax
  8006b3:	0f 88 81 00 00 00    	js     80073a <dup+0xa7>
		return r;
	close(newfdnum);
  8006b9:	83 ec 0c             	sub    $0xc,%esp
  8006bc:	ff 75 0c             	pushl  0xc(%ebp)
  8006bf:	e8 75 ff ff ff       	call   800639 <close>

	newfd = INDEX2FD(newfdnum);
  8006c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006c7:	c1 e6 0c             	shl    $0xc,%esi
  8006ca:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8006d0:	83 c4 04             	add    $0x4,%esp
  8006d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006d6:	e8 af fd ff ff       	call   80048a <fd2data>
  8006db:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8006dd:	89 34 24             	mov    %esi,(%esp)
  8006e0:	e8 a5 fd ff ff       	call   80048a <fd2data>
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006ea:	89 d8                	mov    %ebx,%eax
  8006ec:	c1 e8 16             	shr    $0x16,%eax
  8006ef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006f6:	a8 01                	test   $0x1,%al
  8006f8:	74 11                	je     80070b <dup+0x78>
  8006fa:	89 d8                	mov    %ebx,%eax
  8006fc:	c1 e8 0c             	shr    $0xc,%eax
  8006ff:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800706:	f6 c2 01             	test   $0x1,%dl
  800709:	75 39                	jne    800744 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80070b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80070e:	89 d0                	mov    %edx,%eax
  800710:	c1 e8 0c             	shr    $0xc,%eax
  800713:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80071a:	83 ec 0c             	sub    $0xc,%esp
  80071d:	25 07 0e 00 00       	and    $0xe07,%eax
  800722:	50                   	push   %eax
  800723:	56                   	push   %esi
  800724:	6a 00                	push   $0x0
  800726:	52                   	push   %edx
  800727:	6a 00                	push   $0x0
  800729:	e8 a9 fa ff ff       	call   8001d7 <sys_page_map>
  80072e:	89 c3                	mov    %eax,%ebx
  800730:	83 c4 20             	add    $0x20,%esp
  800733:	85 c0                	test   %eax,%eax
  800735:	78 31                	js     800768 <dup+0xd5>
		goto err;

	return newfdnum;
  800737:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80073a:	89 d8                	mov    %ebx,%eax
  80073c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80073f:	5b                   	pop    %ebx
  800740:	5e                   	pop    %esi
  800741:	5f                   	pop    %edi
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800744:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	25 07 0e 00 00       	and    $0xe07,%eax
  800753:	50                   	push   %eax
  800754:	57                   	push   %edi
  800755:	6a 00                	push   $0x0
  800757:	53                   	push   %ebx
  800758:	6a 00                	push   $0x0
  80075a:	e8 78 fa ff ff       	call   8001d7 <sys_page_map>
  80075f:	89 c3                	mov    %eax,%ebx
  800761:	83 c4 20             	add    $0x20,%esp
  800764:	85 c0                	test   %eax,%eax
  800766:	79 a3                	jns    80070b <dup+0x78>
	sys_page_unmap(0, newfd);
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	56                   	push   %esi
  80076c:	6a 00                	push   $0x0
  80076e:	e8 aa fa ff ff       	call   80021d <sys_page_unmap>
	sys_page_unmap(0, nva);
  800773:	83 c4 08             	add    $0x8,%esp
  800776:	57                   	push   %edi
  800777:	6a 00                	push   $0x0
  800779:	e8 9f fa ff ff       	call   80021d <sys_page_unmap>
	return r;
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	eb b7                	jmp    80073a <dup+0xa7>

00800783 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800783:	f3 0f 1e fb          	endbr32 
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	53                   	push   %ebx
  80078b:	83 ec 1c             	sub    $0x1c,%esp
  80078e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800791:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800794:	50                   	push   %eax
  800795:	53                   	push   %ebx
  800796:	e8 60 fd ff ff       	call   8004fb <fd_lookup>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	78 3f                	js     8007e1 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007a8:	50                   	push   %eax
  8007a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ac:	ff 30                	pushl  (%eax)
  8007ae:	e8 9c fd ff ff       	call   80054f <dev_lookup>
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	85 c0                	test   %eax,%eax
  8007b8:	78 27                	js     8007e1 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8007ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8007bd:	8b 42 08             	mov    0x8(%edx),%eax
  8007c0:	83 e0 03             	and    $0x3,%eax
  8007c3:	83 f8 01             	cmp    $0x1,%eax
  8007c6:	74 1e                	je     8007e6 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007cb:	8b 40 08             	mov    0x8(%eax),%eax
  8007ce:	85 c0                	test   %eax,%eax
  8007d0:	74 35                	je     800807 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8007d2:	83 ec 04             	sub    $0x4,%esp
  8007d5:	ff 75 10             	pushl  0x10(%ebp)
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	52                   	push   %edx
  8007dc:	ff d0                	call   *%eax
  8007de:	83 c4 10             	add    $0x10,%esp
}
  8007e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007e6:	a1 08 40 80 00       	mov    0x804008,%eax
  8007eb:	8b 40 48             	mov    0x48(%eax),%eax
  8007ee:	83 ec 04             	sub    $0x4,%esp
  8007f1:	53                   	push   %ebx
  8007f2:	50                   	push   %eax
  8007f3:	68 99 25 80 00       	push   $0x802599
  8007f8:	e8 62 0f 00 00       	call   80175f <cprintf>
		return -E_INVAL;
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800805:	eb da                	jmp    8007e1 <read+0x5e>
		return -E_NOT_SUPP;
  800807:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80080c:	eb d3                	jmp    8007e1 <read+0x5e>

0080080e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80080e:	f3 0f 1e fb          	endbr32 
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	57                   	push   %edi
  800816:	56                   	push   %esi
  800817:	53                   	push   %ebx
  800818:	83 ec 0c             	sub    $0xc,%esp
  80081b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80081e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800821:	bb 00 00 00 00       	mov    $0x0,%ebx
  800826:	eb 02                	jmp    80082a <readn+0x1c>
  800828:	01 c3                	add    %eax,%ebx
  80082a:	39 f3                	cmp    %esi,%ebx
  80082c:	73 21                	jae    80084f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80082e:	83 ec 04             	sub    $0x4,%esp
  800831:	89 f0                	mov    %esi,%eax
  800833:	29 d8                	sub    %ebx,%eax
  800835:	50                   	push   %eax
  800836:	89 d8                	mov    %ebx,%eax
  800838:	03 45 0c             	add    0xc(%ebp),%eax
  80083b:	50                   	push   %eax
  80083c:	57                   	push   %edi
  80083d:	e8 41 ff ff ff       	call   800783 <read>
		if (m < 0)
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	85 c0                	test   %eax,%eax
  800847:	78 04                	js     80084d <readn+0x3f>
			return m;
		if (m == 0)
  800849:	75 dd                	jne    800828 <readn+0x1a>
  80084b:	eb 02                	jmp    80084f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80084d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80084f:	89 d8                	mov    %ebx,%eax
  800851:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800854:	5b                   	pop    %ebx
  800855:	5e                   	pop    %esi
  800856:	5f                   	pop    %edi
  800857:	5d                   	pop    %ebp
  800858:	c3                   	ret    

00800859 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800859:	f3 0f 1e fb          	endbr32 
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	53                   	push   %ebx
  800861:	83 ec 1c             	sub    $0x1c,%esp
  800864:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800867:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80086a:	50                   	push   %eax
  80086b:	53                   	push   %ebx
  80086c:	e8 8a fc ff ff       	call   8004fb <fd_lookup>
  800871:	83 c4 10             	add    $0x10,%esp
  800874:	85 c0                	test   %eax,%eax
  800876:	78 3a                	js     8008b2 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80087e:	50                   	push   %eax
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800882:	ff 30                	pushl  (%eax)
  800884:	e8 c6 fc ff ff       	call   80054f <dev_lookup>
  800889:	83 c4 10             	add    $0x10,%esp
  80088c:	85 c0                	test   %eax,%eax
  80088e:	78 22                	js     8008b2 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800893:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800897:	74 1e                	je     8008b7 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800899:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089c:	8b 52 0c             	mov    0xc(%edx),%edx
  80089f:	85 d2                	test   %edx,%edx
  8008a1:	74 35                	je     8008d8 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8008a3:	83 ec 04             	sub    $0x4,%esp
  8008a6:	ff 75 10             	pushl  0x10(%ebp)
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	50                   	push   %eax
  8008ad:	ff d2                	call   *%edx
  8008af:	83 c4 10             	add    $0x10,%esp
}
  8008b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b5:	c9                   	leave  
  8008b6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8008b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8008bc:	8b 40 48             	mov    0x48(%eax),%eax
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	53                   	push   %ebx
  8008c3:	50                   	push   %eax
  8008c4:	68 b5 25 80 00       	push   $0x8025b5
  8008c9:	e8 91 0e 00 00       	call   80175f <cprintf>
		return -E_INVAL;
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d6:	eb da                	jmp    8008b2 <write+0x59>
		return -E_NOT_SUPP;
  8008d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008dd:	eb d3                	jmp    8008b2 <write+0x59>

008008df <seek>:

int
seek(int fdnum, off_t offset)
{
  8008df:	f3 0f 1e fb          	endbr32 
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ec:	50                   	push   %eax
  8008ed:	ff 75 08             	pushl  0x8(%ebp)
  8008f0:	e8 06 fc ff ff       	call   8004fb <fd_lookup>
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	85 c0                	test   %eax,%eax
  8008fa:	78 0e                	js     80090a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8008fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800902:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80090c:	f3 0f 1e fb          	endbr32 
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	53                   	push   %ebx
  800914:	83 ec 1c             	sub    $0x1c,%esp
  800917:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80091a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80091d:	50                   	push   %eax
  80091e:	53                   	push   %ebx
  80091f:	e8 d7 fb ff ff       	call   8004fb <fd_lookup>
  800924:	83 c4 10             	add    $0x10,%esp
  800927:	85 c0                	test   %eax,%eax
  800929:	78 37                	js     800962 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800931:	50                   	push   %eax
  800932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800935:	ff 30                	pushl  (%eax)
  800937:	e8 13 fc ff ff       	call   80054f <dev_lookup>
  80093c:	83 c4 10             	add    $0x10,%esp
  80093f:	85 c0                	test   %eax,%eax
  800941:	78 1f                	js     800962 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800946:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80094a:	74 1b                	je     800967 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80094c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094f:	8b 52 18             	mov    0x18(%edx),%edx
  800952:	85 d2                	test   %edx,%edx
  800954:	74 32                	je     800988 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	ff d2                	call   *%edx
  80095f:	83 c4 10             	add    $0x10,%esp
}
  800962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800965:	c9                   	leave  
  800966:	c3                   	ret    
			thisenv->env_id, fdnum);
  800967:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80096c:	8b 40 48             	mov    0x48(%eax),%eax
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	53                   	push   %ebx
  800973:	50                   	push   %eax
  800974:	68 78 25 80 00       	push   $0x802578
  800979:	e8 e1 0d 00 00       	call   80175f <cprintf>
		return -E_INVAL;
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800986:	eb da                	jmp    800962 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800988:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80098d:	eb d3                	jmp    800962 <ftruncate+0x56>

0080098f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80098f:	f3 0f 1e fb          	endbr32 
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	53                   	push   %ebx
  800997:	83 ec 1c             	sub    $0x1c,%esp
  80099a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80099d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009a0:	50                   	push   %eax
  8009a1:	ff 75 08             	pushl  0x8(%ebp)
  8009a4:	e8 52 fb ff ff       	call   8004fb <fd_lookup>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	85 c0                	test   %eax,%eax
  8009ae:	78 4b                	js     8009fb <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b6:	50                   	push   %eax
  8009b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ba:	ff 30                	pushl  (%eax)
  8009bc:	e8 8e fb ff ff       	call   80054f <dev_lookup>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	85 c0                	test   %eax,%eax
  8009c6:	78 33                	js     8009fb <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8009c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8009cf:	74 2f                	je     800a00 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8009d1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8009d4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8009db:	00 00 00 
	stat->st_isdir = 0;
  8009de:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009e5:	00 00 00 
	stat->st_dev = dev;
  8009e8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	53                   	push   %ebx
  8009f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8009f5:	ff 50 14             	call   *0x14(%eax)
  8009f8:	83 c4 10             	add    $0x10,%esp
}
  8009fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    
		return -E_NOT_SUPP;
  800a00:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800a05:	eb f4                	jmp    8009fb <fstat+0x6c>

00800a07 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a07:	f3 0f 1e fb          	endbr32 
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	56                   	push   %esi
  800a0f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	6a 00                	push   $0x0
  800a15:	ff 75 08             	pushl  0x8(%ebp)
  800a18:	e8 fb 01 00 00       	call   800c18 <open>
  800a1d:	89 c3                	mov    %eax,%ebx
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	85 c0                	test   %eax,%eax
  800a24:	78 1b                	js     800a41 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	50                   	push   %eax
  800a2d:	e8 5d ff ff ff       	call   80098f <fstat>
  800a32:	89 c6                	mov    %eax,%esi
	close(fd);
  800a34:	89 1c 24             	mov    %ebx,(%esp)
  800a37:	e8 fd fb ff ff       	call   800639 <close>
	return r;
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	89 f3                	mov    %esi,%ebx
}
  800a41:	89 d8                	mov    %ebx,%eax
  800a43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a46:	5b                   	pop    %ebx
  800a47:	5e                   	pop    %esi
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	56                   	push   %esi
  800a4e:	53                   	push   %ebx
  800a4f:	89 c6                	mov    %eax,%esi
  800a51:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a53:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a5a:	74 27                	je     800a83 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a5c:	6a 07                	push   $0x7
  800a5e:	68 00 50 80 00       	push   $0x805000
  800a63:	56                   	push   %esi
  800a64:	ff 35 00 40 80 00    	pushl  0x804000
  800a6a:	e8 64 17 00 00       	call   8021d3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a6f:	83 c4 0c             	add    $0xc,%esp
  800a72:	6a 00                	push   $0x0
  800a74:	53                   	push   %ebx
  800a75:	6a 00                	push   $0x0
  800a77:	e8 d2 16 00 00       	call   80214e <ipc_recv>
}
  800a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	6a 01                	push   $0x1
  800a88:	e8 9e 17 00 00       	call   80222b <ipc_find_env>
  800a8d:	a3 00 40 80 00       	mov    %eax,0x804000
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	eb c5                	jmp    800a5c <fsipc+0x12>

00800a97 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a97:	f3 0f 1e fb          	endbr32 
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8b 40 0c             	mov    0xc(%eax),%eax
  800aa7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaf:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab9:	b8 02 00 00 00       	mov    $0x2,%eax
  800abe:	e8 87 ff ff ff       	call   800a4a <fsipc>
}
  800ac3:	c9                   	leave  
  800ac4:	c3                   	ret    

00800ac5 <devfile_flush>:
{
  800ac5:	f3 0f 1e fb          	endbr32 
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  800ad5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800ada:	ba 00 00 00 00       	mov    $0x0,%edx
  800adf:	b8 06 00 00 00       	mov    $0x6,%eax
  800ae4:	e8 61 ff ff ff       	call   800a4a <fsipc>
}
  800ae9:	c9                   	leave  
  800aea:	c3                   	ret    

00800aeb <devfile_stat>:
{
  800aeb:	f3 0f 1e fb          	endbr32 
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	53                   	push   %ebx
  800af3:	83 ec 04             	sub    $0x4,%esp
  800af6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 40 0c             	mov    0xc(%eax),%eax
  800aff:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b04:	ba 00 00 00 00       	mov    $0x0,%edx
  800b09:	b8 05 00 00 00       	mov    $0x5,%eax
  800b0e:	e8 37 ff ff ff       	call   800a4a <fsipc>
  800b13:	85 c0                	test   %eax,%eax
  800b15:	78 2c                	js     800b43 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	68 00 50 80 00       	push   $0x805000
  800b1f:	53                   	push   %ebx
  800b20:	e8 44 12 00 00       	call   801d69 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b25:	a1 80 50 80 00       	mov    0x805080,%eax
  800b2a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b30:	a1 84 50 80 00       	mov    0x805084,%eax
  800b35:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b3b:	83 c4 10             	add    $0x10,%esp
  800b3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <devfile_write>:
{
  800b48:	f3 0f 1e fb          	endbr32 
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 0c             	sub    $0xc,%esp
  800b52:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800b55:	8b 55 08             	mov    0x8(%ebp),%edx
  800b58:	8b 52 0c             	mov    0xc(%edx),%edx
  800b5b:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800b61:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800b66:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800b6b:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800b6e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800b73:	50                   	push   %eax
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	68 08 50 80 00       	push   $0x805008
  800b7c:	e8 9e 13 00 00       	call   801f1f <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
  800b86:	b8 04 00 00 00       	mov    $0x4,%eax
  800b8b:	e8 ba fe ff ff       	call   800a4a <fsipc>
}
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    

00800b92 <devfile_read>:
{
  800b92:	f3 0f 1e fb          	endbr32 
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
  800b9b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  800ba4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ba9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800baf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb4:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb9:	e8 8c fe ff ff       	call   800a4a <fsipc>
  800bbe:	89 c3                	mov    %eax,%ebx
  800bc0:	85 c0                	test   %eax,%eax
  800bc2:	78 1f                	js     800be3 <devfile_read+0x51>
	assert(r <= n);
  800bc4:	39 f0                	cmp    %esi,%eax
  800bc6:	77 24                	ja     800bec <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800bc8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800bcd:	7f 33                	jg     800c02 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800bcf:	83 ec 04             	sub    $0x4,%esp
  800bd2:	50                   	push   %eax
  800bd3:	68 00 50 80 00       	push   $0x805000
  800bd8:	ff 75 0c             	pushl  0xc(%ebp)
  800bdb:	e8 3f 13 00 00       	call   801f1f <memmove>
	return r;
  800be0:	83 c4 10             	add    $0x10,%esp
}
  800be3:	89 d8                	mov    %ebx,%eax
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    
	assert(r <= n);
  800bec:	68 e8 25 80 00       	push   $0x8025e8
  800bf1:	68 ef 25 80 00       	push   $0x8025ef
  800bf6:	6a 7c                	push   $0x7c
  800bf8:	68 04 26 80 00       	push   $0x802604
  800bfd:	e8 76 0a 00 00       	call   801678 <_panic>
	assert(r <= PGSIZE);
  800c02:	68 0f 26 80 00       	push   $0x80260f
  800c07:	68 ef 25 80 00       	push   $0x8025ef
  800c0c:	6a 7d                	push   $0x7d
  800c0e:	68 04 26 80 00       	push   $0x802604
  800c13:	e8 60 0a 00 00       	call   801678 <_panic>

00800c18 <open>:
{
  800c18:	f3 0f 1e fb          	endbr32 
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
  800c21:	83 ec 1c             	sub    $0x1c,%esp
  800c24:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800c27:	56                   	push   %esi
  800c28:	e8 f9 10 00 00       	call   801d26 <strlen>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c35:	7f 6c                	jg     800ca3 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800c37:	83 ec 0c             	sub    $0xc,%esp
  800c3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c3d:	50                   	push   %eax
  800c3e:	e8 62 f8 ff ff       	call   8004a5 <fd_alloc>
  800c43:	89 c3                	mov    %eax,%ebx
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	85 c0                	test   %eax,%eax
  800c4a:	78 3c                	js     800c88 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	56                   	push   %esi
  800c50:	68 00 50 80 00       	push   $0x805000
  800c55:	e8 0f 11 00 00       	call   801d69 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c65:	b8 01 00 00 00       	mov    $0x1,%eax
  800c6a:	e8 db fd ff ff       	call   800a4a <fsipc>
  800c6f:	89 c3                	mov    %eax,%ebx
  800c71:	83 c4 10             	add    $0x10,%esp
  800c74:	85 c0                	test   %eax,%eax
  800c76:	78 19                	js     800c91 <open+0x79>
	return fd2num(fd);
  800c78:	83 ec 0c             	sub    $0xc,%esp
  800c7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7e:	e8 f3 f7 ff ff       	call   800476 <fd2num>
  800c83:	89 c3                	mov    %eax,%ebx
  800c85:	83 c4 10             	add    $0x10,%esp
}
  800c88:	89 d8                	mov    %ebx,%eax
  800c8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c8d:	5b                   	pop    %ebx
  800c8e:	5e                   	pop    %esi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    
		fd_close(fd, 0);
  800c91:	83 ec 08             	sub    $0x8,%esp
  800c94:	6a 00                	push   $0x0
  800c96:	ff 75 f4             	pushl  -0xc(%ebp)
  800c99:	e8 10 f9 ff ff       	call   8005ae <fd_close>
		return r;
  800c9e:	83 c4 10             	add    $0x10,%esp
  800ca1:	eb e5                	jmp    800c88 <open+0x70>
		return -E_BAD_PATH;
  800ca3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800ca8:	eb de                	jmp    800c88 <open+0x70>

00800caa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800caa:	f3 0f 1e fb          	endbr32 
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800cb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb9:	b8 08 00 00 00       	mov    $0x8,%eax
  800cbe:	e8 87 fd ff ff       	call   800a4a <fsipc>
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800cc5:	f3 0f 1e fb          	endbr32 
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800ccf:	68 1b 26 80 00       	push   $0x80261b
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	e8 8d 10 00 00       	call   801d69 <strcpy>
	return 0;
}
  800cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <devsock_close>:
{
  800ce3:	f3 0f 1e fb          	endbr32 
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	53                   	push   %ebx
  800ceb:	83 ec 10             	sub    $0x10,%esp
  800cee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800cf1:	53                   	push   %ebx
  800cf2:	e8 71 15 00 00       	call   802268 <pageref>
  800cf7:	89 c2                	mov    %eax,%edx
  800cf9:	83 c4 10             	add    $0x10,%esp
		return 0;
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800d01:	83 fa 01             	cmp    $0x1,%edx
  800d04:	74 05                	je     800d0b <devsock_close+0x28>
}
  800d06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d09:	c9                   	leave  
  800d0a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800d0b:	83 ec 0c             	sub    $0xc,%esp
  800d0e:	ff 73 0c             	pushl  0xc(%ebx)
  800d11:	e8 e3 02 00 00       	call   800ff9 <nsipc_close>
  800d16:	83 c4 10             	add    $0x10,%esp
  800d19:	eb eb                	jmp    800d06 <devsock_close+0x23>

00800d1b <devsock_write>:
{
  800d1b:	f3 0f 1e fb          	endbr32 
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800d25:	6a 00                	push   $0x0
  800d27:	ff 75 10             	pushl  0x10(%ebp)
  800d2a:	ff 75 0c             	pushl  0xc(%ebp)
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	ff 70 0c             	pushl  0xc(%eax)
  800d33:	e8 b5 03 00 00       	call   8010ed <nsipc_send>
}
  800d38:	c9                   	leave  
  800d39:	c3                   	ret    

00800d3a <devsock_read>:
{
  800d3a:	f3 0f 1e fb          	endbr32 
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800d44:	6a 00                	push   $0x0
  800d46:	ff 75 10             	pushl  0x10(%ebp)
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	ff 70 0c             	pushl  0xc(%eax)
  800d52:	e8 1f 03 00 00       	call   801076 <nsipc_recv>
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <fd2sockid>:
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800d5f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d62:	52                   	push   %edx
  800d63:	50                   	push   %eax
  800d64:	e8 92 f7 ff ff       	call   8004fb <fd_lookup>
  800d69:	83 c4 10             	add    $0x10,%esp
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	78 10                	js     800d80 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d73:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800d79:	39 08                	cmp    %ecx,(%eax)
  800d7b:	75 05                	jne    800d82 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800d7d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    
		return -E_NOT_SUPP;
  800d82:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d87:	eb f7                	jmp    800d80 <fd2sockid+0x27>

00800d89 <alloc_sockfd>:
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 1c             	sub    $0x1c,%esp
  800d91:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d96:	50                   	push   %eax
  800d97:	e8 09 f7 ff ff       	call   8004a5 <fd_alloc>
  800d9c:	89 c3                	mov    %eax,%ebx
  800d9e:	83 c4 10             	add    $0x10,%esp
  800da1:	85 c0                	test   %eax,%eax
  800da3:	78 43                	js     800de8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800da5:	83 ec 04             	sub    $0x4,%esp
  800da8:	68 07 04 00 00       	push   $0x407
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	6a 00                	push   $0x0
  800db2:	e8 d9 f3 ff ff       	call   800190 <sys_page_alloc>
  800db7:	89 c3                	mov    %eax,%ebx
  800db9:	83 c4 10             	add    $0x10,%esp
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	78 28                	js     800de8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800dc9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dce:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800dd5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	50                   	push   %eax
  800ddc:	e8 95 f6 ff ff       	call   800476 <fd2num>
  800de1:	89 c3                	mov    %eax,%ebx
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	eb 0c                	jmp    800df4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800de8:	83 ec 0c             	sub    $0xc,%esp
  800deb:	56                   	push   %esi
  800dec:	e8 08 02 00 00       	call   800ff9 <nsipc_close>
		return r;
  800df1:	83 c4 10             	add    $0x10,%esp
}
  800df4:	89 d8                	mov    %ebx,%eax
  800df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800df9:	5b                   	pop    %ebx
  800dfa:	5e                   	pop    %esi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <accept>:
{
  800dfd:	f3 0f 1e fb          	endbr32 
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	e8 4a ff ff ff       	call   800d59 <fd2sockid>
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	78 1b                	js     800e2e <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800e13:	83 ec 04             	sub    $0x4,%esp
  800e16:	ff 75 10             	pushl  0x10(%ebp)
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	50                   	push   %eax
  800e1d:	e8 22 01 00 00       	call   800f44 <nsipc_accept>
  800e22:	83 c4 10             	add    $0x10,%esp
  800e25:	85 c0                	test   %eax,%eax
  800e27:	78 05                	js     800e2e <accept+0x31>
	return alloc_sockfd(r);
  800e29:	e8 5b ff ff ff       	call   800d89 <alloc_sockfd>
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <bind>:
{
  800e30:	f3 0f 1e fb          	endbr32 
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	e8 17 ff ff ff       	call   800d59 <fd2sockid>
  800e42:	85 c0                	test   %eax,%eax
  800e44:	78 12                	js     800e58 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800e46:	83 ec 04             	sub    $0x4,%esp
  800e49:	ff 75 10             	pushl  0x10(%ebp)
  800e4c:	ff 75 0c             	pushl  0xc(%ebp)
  800e4f:	50                   	push   %eax
  800e50:	e8 45 01 00 00       	call   800f9a <nsipc_bind>
  800e55:	83 c4 10             	add    $0x10,%esp
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <shutdown>:
{
  800e5a:	f3 0f 1e fb          	endbr32 
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	e8 ed fe ff ff       	call   800d59 <fd2sockid>
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	78 0f                	js     800e7f <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	ff 75 0c             	pushl  0xc(%ebp)
  800e76:	50                   	push   %eax
  800e77:	e8 57 01 00 00       	call   800fd3 <nsipc_shutdown>
  800e7c:	83 c4 10             	add    $0x10,%esp
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <connect>:
{
  800e81:	f3 0f 1e fb          	endbr32 
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	e8 c6 fe ff ff       	call   800d59 <fd2sockid>
  800e93:	85 c0                	test   %eax,%eax
  800e95:	78 12                	js     800ea9 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e97:	83 ec 04             	sub    $0x4,%esp
  800e9a:	ff 75 10             	pushl  0x10(%ebp)
  800e9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ea0:	50                   	push   %eax
  800ea1:	e8 71 01 00 00       	call   801017 <nsipc_connect>
  800ea6:	83 c4 10             	add    $0x10,%esp
}
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <listen>:
{
  800eab:	f3 0f 1e fb          	endbr32 
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	e8 9c fe ff ff       	call   800d59 <fd2sockid>
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	78 0f                	js     800ed0 <listen+0x25>
	return nsipc_listen(r, backlog);
  800ec1:	83 ec 08             	sub    $0x8,%esp
  800ec4:	ff 75 0c             	pushl  0xc(%ebp)
  800ec7:	50                   	push   %eax
  800ec8:	e8 83 01 00 00       	call   801050 <nsipc_listen>
  800ecd:	83 c4 10             	add    $0x10,%esp
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <socket>:

int
socket(int domain, int type, int protocol)
{
  800ed2:	f3 0f 1e fb          	endbr32 
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800edc:	ff 75 10             	pushl  0x10(%ebp)
  800edf:	ff 75 0c             	pushl  0xc(%ebp)
  800ee2:	ff 75 08             	pushl  0x8(%ebp)
  800ee5:	e8 65 02 00 00       	call   80114f <nsipc_socket>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	85 c0                	test   %eax,%eax
  800eef:	78 05                	js     800ef6 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800ef1:	e8 93 fe ff ff       	call   800d89 <alloc_sockfd>
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	53                   	push   %ebx
  800efc:	83 ec 04             	sub    $0x4,%esp
  800eff:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800f01:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800f08:	74 26                	je     800f30 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800f0a:	6a 07                	push   $0x7
  800f0c:	68 00 60 80 00       	push   $0x806000
  800f11:	53                   	push   %ebx
  800f12:	ff 35 04 40 80 00    	pushl  0x804004
  800f18:	e8 b6 12 00 00       	call   8021d3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800f1d:	83 c4 0c             	add    $0xc,%esp
  800f20:	6a 00                	push   $0x0
  800f22:	6a 00                	push   $0x0
  800f24:	6a 00                	push   $0x0
  800f26:	e8 23 12 00 00       	call   80214e <ipc_recv>
}
  800f2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800f30:	83 ec 0c             	sub    $0xc,%esp
  800f33:	6a 02                	push   $0x2
  800f35:	e8 f1 12 00 00       	call   80222b <ipc_find_env>
  800f3a:	a3 04 40 80 00       	mov    %eax,0x804004
  800f3f:	83 c4 10             	add    $0x10,%esp
  800f42:	eb c6                	jmp    800f0a <nsipc+0x12>

00800f44 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f44:	f3 0f 1e fb          	endbr32 
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	56                   	push   %esi
  800f4c:	53                   	push   %ebx
  800f4d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800f58:	8b 06                	mov    (%esi),%eax
  800f5a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800f5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800f64:	e8 8f ff ff ff       	call   800ef8 <nsipc>
  800f69:	89 c3                	mov    %eax,%ebx
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	79 09                	jns    800f78 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800f6f:	89 d8                	mov    %ebx,%eax
  800f71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	ff 35 10 60 80 00    	pushl  0x806010
  800f81:	68 00 60 80 00       	push   $0x806000
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	e8 91 0f 00 00       	call   801f1f <memmove>
		*addrlen = ret->ret_addrlen;
  800f8e:	a1 10 60 80 00       	mov    0x806010,%eax
  800f93:	89 06                	mov    %eax,(%esi)
  800f95:	83 c4 10             	add    $0x10,%esp
	return r;
  800f98:	eb d5                	jmp    800f6f <nsipc_accept+0x2b>

00800f9a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f9a:	f3 0f 1e fb          	endbr32 
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	53                   	push   %ebx
  800fa2:	83 ec 08             	sub    $0x8,%esp
  800fa5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800fb0:	53                   	push   %ebx
  800fb1:	ff 75 0c             	pushl  0xc(%ebp)
  800fb4:	68 04 60 80 00       	push   $0x806004
  800fb9:	e8 61 0f 00 00       	call   801f1f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800fbe:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800fc4:	b8 02 00 00 00       	mov    $0x2,%eax
  800fc9:	e8 2a ff ff ff       	call   800ef8 <nsipc>
}
  800fce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800fd3:	f3 0f 1e fb          	endbr32 
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800fed:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff2:	e8 01 ff ff ff       	call   800ef8 <nsipc>
}
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <nsipc_close>:

int
nsipc_close(int s)
{
  800ff9:	f3 0f 1e fb          	endbr32 
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80100b:	b8 04 00 00 00       	mov    $0x4,%eax
  801010:	e8 e3 fe ff ff       	call   800ef8 <nsipc>
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801017:	f3 0f 1e fb          	endbr32 
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	53                   	push   %ebx
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80102d:	53                   	push   %ebx
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	68 04 60 80 00       	push   $0x806004
  801036:	e8 e4 0e 00 00       	call   801f1f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80103b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801041:	b8 05 00 00 00       	mov    $0x5,%eax
  801046:	e8 ad fe ff ff       	call   800ef8 <nsipc>
}
  80104b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104e:	c9                   	leave  
  80104f:	c3                   	ret    

00801050 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801050:	f3 0f 1e fb          	endbr32 
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80106a:	b8 06 00 00 00       	mov    $0x6,%eax
  80106f:	e8 84 fe ff ff       	call   800ef8 <nsipc>
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801076:	f3 0f 1e fb          	endbr32 
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	56                   	push   %esi
  80107e:	53                   	push   %ebx
  80107f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80108a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801090:	8b 45 14             	mov    0x14(%ebp),%eax
  801093:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801098:	b8 07 00 00 00       	mov    $0x7,%eax
  80109d:	e8 56 fe ff ff       	call   800ef8 <nsipc>
  8010a2:	89 c3                	mov    %eax,%ebx
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	78 26                	js     8010ce <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  8010a8:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  8010ae:	b8 3f 06 00 00       	mov    $0x63f,%eax
  8010b3:	0f 4e c6             	cmovle %esi,%eax
  8010b6:	39 c3                	cmp    %eax,%ebx
  8010b8:	7f 1d                	jg     8010d7 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8010ba:	83 ec 04             	sub    $0x4,%esp
  8010bd:	53                   	push   %ebx
  8010be:	68 00 60 80 00       	push   $0x806000
  8010c3:	ff 75 0c             	pushl  0xc(%ebp)
  8010c6:	e8 54 0e 00 00       	call   801f1f <memmove>
  8010cb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010d3:	5b                   	pop    %ebx
  8010d4:	5e                   	pop    %esi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8010d7:	68 27 26 80 00       	push   $0x802627
  8010dc:	68 ef 25 80 00       	push   $0x8025ef
  8010e1:	6a 62                	push   $0x62
  8010e3:	68 3c 26 80 00       	push   $0x80263c
  8010e8:	e8 8b 05 00 00       	call   801678 <_panic>

008010ed <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8010ed:	f3 0f 1e fb          	endbr32 
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	53                   	push   %ebx
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801103:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801109:	7f 2e                	jg     801139 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80110b:	83 ec 04             	sub    $0x4,%esp
  80110e:	53                   	push   %ebx
  80110f:	ff 75 0c             	pushl  0xc(%ebp)
  801112:	68 0c 60 80 00       	push   $0x80600c
  801117:	e8 03 0e 00 00       	call   801f1f <memmove>
	nsipcbuf.send.req_size = size;
  80111c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801122:	8b 45 14             	mov    0x14(%ebp),%eax
  801125:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80112a:	b8 08 00 00 00       	mov    $0x8,%eax
  80112f:	e8 c4 fd ff ff       	call   800ef8 <nsipc>
}
  801134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801137:	c9                   	leave  
  801138:	c3                   	ret    
	assert(size < 1600);
  801139:	68 48 26 80 00       	push   $0x802648
  80113e:	68 ef 25 80 00       	push   $0x8025ef
  801143:	6a 6d                	push   $0x6d
  801145:	68 3c 26 80 00       	push   $0x80263c
  80114a:	e8 29 05 00 00       	call   801678 <_panic>

0080114f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80114f:	f3 0f 1e fb          	endbr32 
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801171:	b8 09 00 00 00       	mov    $0x9,%eax
  801176:	e8 7d fd ff ff       	call   800ef8 <nsipc>
}
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80117d:	f3 0f 1e fb          	endbr32 
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	56                   	push   %esi
  801185:	53                   	push   %ebx
  801186:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801189:	83 ec 0c             	sub    $0xc,%esp
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 f6 f2 ff ff       	call   80048a <fd2data>
  801194:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801196:	83 c4 08             	add    $0x8,%esp
  801199:	68 54 26 80 00       	push   $0x802654
  80119e:	53                   	push   %ebx
  80119f:	e8 c5 0b 00 00       	call   801d69 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8011a4:	8b 46 04             	mov    0x4(%esi),%eax
  8011a7:	2b 06                	sub    (%esi),%eax
  8011a9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8011af:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8011b6:	00 00 00 
	stat->st_dev = &devpipe;
  8011b9:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8011c0:	30 80 00 
	return 0;
}
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8011cf:	f3 0f 1e fb          	endbr32 
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8011dd:	53                   	push   %ebx
  8011de:	6a 00                	push   $0x0
  8011e0:	e8 38 f0 ff ff       	call   80021d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011e5:	89 1c 24             	mov    %ebx,(%esp)
  8011e8:	e8 9d f2 ff ff       	call   80048a <fd2data>
  8011ed:	83 c4 08             	add    $0x8,%esp
  8011f0:	50                   	push   %eax
  8011f1:	6a 00                	push   $0x0
  8011f3:	e8 25 f0 ff ff       	call   80021d <sys_page_unmap>
}
  8011f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <_pipeisclosed>:
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	57                   	push   %edi
  801201:	56                   	push   %esi
  801202:	53                   	push   %ebx
  801203:	83 ec 1c             	sub    $0x1c,%esp
  801206:	89 c7                	mov    %eax,%edi
  801208:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80120a:	a1 08 40 80 00       	mov    0x804008,%eax
  80120f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	57                   	push   %edi
  801216:	e8 4d 10 00 00       	call   802268 <pageref>
  80121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80121e:	89 34 24             	mov    %esi,(%esp)
  801221:	e8 42 10 00 00       	call   802268 <pageref>
		nn = thisenv->env_runs;
  801226:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80122c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80122f:	83 c4 10             	add    $0x10,%esp
  801232:	39 cb                	cmp    %ecx,%ebx
  801234:	74 1b                	je     801251 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801236:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801239:	75 cf                	jne    80120a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80123b:	8b 42 58             	mov    0x58(%edx),%eax
  80123e:	6a 01                	push   $0x1
  801240:	50                   	push   %eax
  801241:	53                   	push   %ebx
  801242:	68 5b 26 80 00       	push   $0x80265b
  801247:	e8 13 05 00 00       	call   80175f <cprintf>
  80124c:	83 c4 10             	add    $0x10,%esp
  80124f:	eb b9                	jmp    80120a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801251:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801254:	0f 94 c0             	sete   %al
  801257:	0f b6 c0             	movzbl %al,%eax
}
  80125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125d:	5b                   	pop    %ebx
  80125e:	5e                   	pop    %esi
  80125f:	5f                   	pop    %edi
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    

00801262 <devpipe_write>:
{
  801262:	f3 0f 1e fb          	endbr32 
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	57                   	push   %edi
  80126a:	56                   	push   %esi
  80126b:	53                   	push   %ebx
  80126c:	83 ec 28             	sub    $0x28,%esp
  80126f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801272:	56                   	push   %esi
  801273:	e8 12 f2 ff ff       	call   80048a <fd2data>
  801278:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80127a:	83 c4 10             	add    $0x10,%esp
  80127d:	bf 00 00 00 00       	mov    $0x0,%edi
  801282:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801285:	74 4f                	je     8012d6 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801287:	8b 43 04             	mov    0x4(%ebx),%eax
  80128a:	8b 0b                	mov    (%ebx),%ecx
  80128c:	8d 51 20             	lea    0x20(%ecx),%edx
  80128f:	39 d0                	cmp    %edx,%eax
  801291:	72 14                	jb     8012a7 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801293:	89 da                	mov    %ebx,%edx
  801295:	89 f0                	mov    %esi,%eax
  801297:	e8 61 ff ff ff       	call   8011fd <_pipeisclosed>
  80129c:	85 c0                	test   %eax,%eax
  80129e:	75 3b                	jne    8012db <devpipe_write+0x79>
			sys_yield();
  8012a0:	e8 c8 ee ff ff       	call   80016d <sys_yield>
  8012a5:	eb e0                	jmp    801287 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8012a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8012ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8012b1:	89 c2                	mov    %eax,%edx
  8012b3:	c1 fa 1f             	sar    $0x1f,%edx
  8012b6:	89 d1                	mov    %edx,%ecx
  8012b8:	c1 e9 1b             	shr    $0x1b,%ecx
  8012bb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8012be:	83 e2 1f             	and    $0x1f,%edx
  8012c1:	29 ca                	sub    %ecx,%edx
  8012c3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8012c7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8012cb:	83 c0 01             	add    $0x1,%eax
  8012ce:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8012d1:	83 c7 01             	add    $0x1,%edi
  8012d4:	eb ac                	jmp    801282 <devpipe_write+0x20>
	return i;
  8012d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d9:	eb 05                	jmp    8012e0 <devpipe_write+0x7e>
				return 0;
  8012db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e3:	5b                   	pop    %ebx
  8012e4:	5e                   	pop    %esi
  8012e5:	5f                   	pop    %edi
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    

008012e8 <devpipe_read>:
{
  8012e8:	f3 0f 1e fb          	endbr32 
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 18             	sub    $0x18,%esp
  8012f5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8012f8:	57                   	push   %edi
  8012f9:	e8 8c f1 ff ff       	call   80048a <fd2data>
  8012fe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	be 00 00 00 00       	mov    $0x0,%esi
  801308:	3b 75 10             	cmp    0x10(%ebp),%esi
  80130b:	75 14                	jne    801321 <devpipe_read+0x39>
	return i;
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	eb 02                	jmp    801314 <devpipe_read+0x2c>
				return i;
  801312:	89 f0                	mov    %esi,%eax
}
  801314:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801317:	5b                   	pop    %ebx
  801318:	5e                   	pop    %esi
  801319:	5f                   	pop    %edi
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    
			sys_yield();
  80131c:	e8 4c ee ff ff       	call   80016d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801321:	8b 03                	mov    (%ebx),%eax
  801323:	3b 43 04             	cmp    0x4(%ebx),%eax
  801326:	75 18                	jne    801340 <devpipe_read+0x58>
			if (i > 0)
  801328:	85 f6                	test   %esi,%esi
  80132a:	75 e6                	jne    801312 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80132c:	89 da                	mov    %ebx,%edx
  80132e:	89 f8                	mov    %edi,%eax
  801330:	e8 c8 fe ff ff       	call   8011fd <_pipeisclosed>
  801335:	85 c0                	test   %eax,%eax
  801337:	74 e3                	je     80131c <devpipe_read+0x34>
				return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb d4                	jmp    801314 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801340:	99                   	cltd   
  801341:	c1 ea 1b             	shr    $0x1b,%edx
  801344:	01 d0                	add    %edx,%eax
  801346:	83 e0 1f             	and    $0x1f,%eax
  801349:	29 d0                	sub    %edx,%eax
  80134b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801350:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801353:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801356:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801359:	83 c6 01             	add    $0x1,%esi
  80135c:	eb aa                	jmp    801308 <devpipe_read+0x20>

0080135e <pipe>:
{
  80135e:	f3 0f 1e fb          	endbr32 
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	56                   	push   %esi
  801366:	53                   	push   %ebx
  801367:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80136a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136d:	50                   	push   %eax
  80136e:	e8 32 f1 ff ff       	call   8004a5 <fd_alloc>
  801373:	89 c3                	mov    %eax,%ebx
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	0f 88 23 01 00 00    	js     8014a3 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801380:	83 ec 04             	sub    $0x4,%esp
  801383:	68 07 04 00 00       	push   $0x407
  801388:	ff 75 f4             	pushl  -0xc(%ebp)
  80138b:	6a 00                	push   $0x0
  80138d:	e8 fe ed ff ff       	call   800190 <sys_page_alloc>
  801392:	89 c3                	mov    %eax,%ebx
  801394:	83 c4 10             	add    $0x10,%esp
  801397:	85 c0                	test   %eax,%eax
  801399:	0f 88 04 01 00 00    	js     8014a3 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80139f:	83 ec 0c             	sub    $0xc,%esp
  8013a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a5:	50                   	push   %eax
  8013a6:	e8 fa f0 ff ff       	call   8004a5 <fd_alloc>
  8013ab:	89 c3                	mov    %eax,%ebx
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	0f 88 db 00 00 00    	js     801493 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	68 07 04 00 00       	push   $0x407
  8013c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8013c3:	6a 00                	push   $0x0
  8013c5:	e8 c6 ed ff ff       	call   800190 <sys_page_alloc>
  8013ca:	89 c3                	mov    %eax,%ebx
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	0f 88 bc 00 00 00    	js     801493 <pipe+0x135>
	va = fd2data(fd0);
  8013d7:	83 ec 0c             	sub    $0xc,%esp
  8013da:	ff 75 f4             	pushl  -0xc(%ebp)
  8013dd:	e8 a8 f0 ff ff       	call   80048a <fd2data>
  8013e2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013e4:	83 c4 0c             	add    $0xc,%esp
  8013e7:	68 07 04 00 00       	push   $0x407
  8013ec:	50                   	push   %eax
  8013ed:	6a 00                	push   $0x0
  8013ef:	e8 9c ed ff ff       	call   800190 <sys_page_alloc>
  8013f4:	89 c3                	mov    %eax,%ebx
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	0f 88 82 00 00 00    	js     801483 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	ff 75 f0             	pushl  -0x10(%ebp)
  801407:	e8 7e f0 ff ff       	call   80048a <fd2data>
  80140c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801413:	50                   	push   %eax
  801414:	6a 00                	push   $0x0
  801416:	56                   	push   %esi
  801417:	6a 00                	push   $0x0
  801419:	e8 b9 ed ff ff       	call   8001d7 <sys_page_map>
  80141e:	89 c3                	mov    %eax,%ebx
  801420:	83 c4 20             	add    $0x20,%esp
  801423:	85 c0                	test   %eax,%eax
  801425:	78 4e                	js     801475 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801427:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80142c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801431:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801434:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80143b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80143e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801443:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80144a:	83 ec 0c             	sub    $0xc,%esp
  80144d:	ff 75 f4             	pushl  -0xc(%ebp)
  801450:	e8 21 f0 ff ff       	call   800476 <fd2num>
  801455:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801458:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80145a:	83 c4 04             	add    $0x4,%esp
  80145d:	ff 75 f0             	pushl  -0x10(%ebp)
  801460:	e8 11 f0 ff ff       	call   800476 <fd2num>
  801465:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801468:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801473:	eb 2e                	jmp    8014a3 <pipe+0x145>
	sys_page_unmap(0, va);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	56                   	push   %esi
  801479:	6a 00                	push   $0x0
  80147b:	e8 9d ed ff ff       	call   80021d <sys_page_unmap>
  801480:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801483:	83 ec 08             	sub    $0x8,%esp
  801486:	ff 75 f0             	pushl  -0x10(%ebp)
  801489:	6a 00                	push   $0x0
  80148b:	e8 8d ed ff ff       	call   80021d <sys_page_unmap>
  801490:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801493:	83 ec 08             	sub    $0x8,%esp
  801496:	ff 75 f4             	pushl  -0xc(%ebp)
  801499:	6a 00                	push   $0x0
  80149b:	e8 7d ed ff ff       	call   80021d <sys_page_unmap>
  8014a0:	83 c4 10             	add    $0x10,%esp
}
  8014a3:	89 d8                	mov    %ebx,%eax
  8014a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a8:	5b                   	pop    %ebx
  8014a9:	5e                   	pop    %esi
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    

008014ac <pipeisclosed>:
{
  8014ac:	f3 0f 1e fb          	endbr32 
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b9:	50                   	push   %eax
  8014ba:	ff 75 08             	pushl  0x8(%ebp)
  8014bd:	e8 39 f0 ff ff       	call   8004fb <fd_lookup>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 18                	js     8014e1 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8014cf:	e8 b6 ef ff ff       	call   80048a <fd2data>
  8014d4:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8014d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d9:	e8 1f fd ff ff       	call   8011fd <_pipeisclosed>
  8014de:	83 c4 10             	add    $0x10,%esp
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8014e3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ec:	c3                   	ret    

008014ed <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8014ed:	f3 0f 1e fb          	endbr32 
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8014f7:	68 73 26 80 00       	push   $0x802673
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	e8 65 08 00 00       	call   801d69 <strcpy>
	return 0;
}
  801504:	b8 00 00 00 00       	mov    $0x0,%eax
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <devcons_write>:
{
  80150b:	f3 0f 1e fb          	endbr32 
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	57                   	push   %edi
  801513:	56                   	push   %esi
  801514:	53                   	push   %ebx
  801515:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80151b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801520:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801526:	3b 75 10             	cmp    0x10(%ebp),%esi
  801529:	73 31                	jae    80155c <devcons_write+0x51>
		m = n - tot;
  80152b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80152e:	29 f3                	sub    %esi,%ebx
  801530:	83 fb 7f             	cmp    $0x7f,%ebx
  801533:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801538:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80153b:	83 ec 04             	sub    $0x4,%esp
  80153e:	53                   	push   %ebx
  80153f:	89 f0                	mov    %esi,%eax
  801541:	03 45 0c             	add    0xc(%ebp),%eax
  801544:	50                   	push   %eax
  801545:	57                   	push   %edi
  801546:	e8 d4 09 00 00       	call   801f1f <memmove>
		sys_cputs(buf, m);
  80154b:	83 c4 08             	add    $0x8,%esp
  80154e:	53                   	push   %ebx
  80154f:	57                   	push   %edi
  801550:	e8 6b eb ff ff       	call   8000c0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801555:	01 de                	add    %ebx,%esi
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	eb ca                	jmp    801526 <devcons_write+0x1b>
}
  80155c:	89 f0                	mov    %esi,%eax
  80155e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801561:	5b                   	pop    %ebx
  801562:	5e                   	pop    %esi
  801563:	5f                   	pop    %edi
  801564:	5d                   	pop    %ebp
  801565:	c3                   	ret    

00801566 <devcons_read>:
{
  801566:	f3 0f 1e fb          	endbr32 
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 08             	sub    $0x8,%esp
  801570:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801575:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801579:	74 21                	je     80159c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80157b:	e8 62 eb ff ff       	call   8000e2 <sys_cgetc>
  801580:	85 c0                	test   %eax,%eax
  801582:	75 07                	jne    80158b <devcons_read+0x25>
		sys_yield();
  801584:	e8 e4 eb ff ff       	call   80016d <sys_yield>
  801589:	eb f0                	jmp    80157b <devcons_read+0x15>
	if (c < 0)
  80158b:	78 0f                	js     80159c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80158d:	83 f8 04             	cmp    $0x4,%eax
  801590:	74 0c                	je     80159e <devcons_read+0x38>
	*(char*)vbuf = c;
  801592:	8b 55 0c             	mov    0xc(%ebp),%edx
  801595:	88 02                	mov    %al,(%edx)
	return 1;
  801597:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    
		return 0;
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a3:	eb f7                	jmp    80159c <devcons_read+0x36>

008015a5 <cputchar>:
{
  8015a5:	f3 0f 1e fb          	endbr32 
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8015b5:	6a 01                	push   $0x1
  8015b7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	e8 00 eb ff ff       	call   8000c0 <sys_cputs>
}
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <getchar>:
{
  8015c5:	f3 0f 1e fb          	endbr32 
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8015cf:	6a 01                	push   $0x1
  8015d1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8015d4:	50                   	push   %eax
  8015d5:	6a 00                	push   $0x0
  8015d7:	e8 a7 f1 ff ff       	call   800783 <read>
	if (r < 0)
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 06                	js     8015e9 <getchar+0x24>
	if (r < 1)
  8015e3:	74 06                	je     8015eb <getchar+0x26>
	return c;
  8015e5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    
		return -E_EOF;
  8015eb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8015f0:	eb f7                	jmp    8015e9 <getchar+0x24>

008015f2 <iscons>:
{
  8015f2:	f3 0f 1e fb          	endbr32 
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	ff 75 08             	pushl  0x8(%ebp)
  801603:	e8 f3 ee ff ff       	call   8004fb <fd_lookup>
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	85 c0                	test   %eax,%eax
  80160d:	78 11                	js     801620 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801612:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801618:	39 10                	cmp    %edx,(%eax)
  80161a:	0f 94 c0             	sete   %al
  80161d:	0f b6 c0             	movzbl %al,%eax
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <opencons>:
{
  801622:	f3 0f 1e fb          	endbr32 
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80162c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162f:	50                   	push   %eax
  801630:	e8 70 ee ff ff       	call   8004a5 <fd_alloc>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 3a                	js     801676 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 07 04 00 00       	push   $0x407
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	6a 00                	push   $0x0
  801649:	e8 42 eb ff ff       	call   800190 <sys_page_alloc>
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 21                	js     801676 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801658:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80165e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801663:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80166a:	83 ec 0c             	sub    $0xc,%esp
  80166d:	50                   	push   %eax
  80166e:	e8 03 ee ff ff       	call   800476 <fd2num>
  801673:	83 c4 10             	add    $0x10,%esp
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801678:	f3 0f 1e fb          	endbr32 
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	56                   	push   %esi
  801680:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801681:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801684:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80168a:	e8 bb ea ff ff       	call   80014a <sys_getenvid>
  80168f:	83 ec 0c             	sub    $0xc,%esp
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	56                   	push   %esi
  801699:	50                   	push   %eax
  80169a:	68 80 26 80 00       	push   $0x802680
  80169f:	e8 bb 00 00 00       	call   80175f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8016a4:	83 c4 18             	add    $0x18,%esp
  8016a7:	53                   	push   %ebx
  8016a8:	ff 75 10             	pushl  0x10(%ebp)
  8016ab:	e8 5a 00 00 00       	call   80170a <vcprintf>
	cprintf("\n");
  8016b0:	c7 04 24 2b 2a 80 00 	movl   $0x802a2b,(%esp)
  8016b7:	e8 a3 00 00 00       	call   80175f <cprintf>
  8016bc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8016bf:	cc                   	int3   
  8016c0:	eb fd                	jmp    8016bf <_panic+0x47>

008016c2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8016c2:	f3 0f 1e fb          	endbr32 
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	53                   	push   %ebx
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8016d0:	8b 13                	mov    (%ebx),%edx
  8016d2:	8d 42 01             	lea    0x1(%edx),%eax
  8016d5:	89 03                	mov    %eax,(%ebx)
  8016d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016da:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8016de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8016e3:	74 09                	je     8016ee <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8016e5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8016e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8016ee:	83 ec 08             	sub    $0x8,%esp
  8016f1:	68 ff 00 00 00       	push   $0xff
  8016f6:	8d 43 08             	lea    0x8(%ebx),%eax
  8016f9:	50                   	push   %eax
  8016fa:	e8 c1 e9 ff ff       	call   8000c0 <sys_cputs>
		b->idx = 0;
  8016ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	eb db                	jmp    8016e5 <putch+0x23>

0080170a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80170a:	f3 0f 1e fb          	endbr32 
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801717:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80171e:	00 00 00 
	b.cnt = 0;
  801721:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801728:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80172b:	ff 75 0c             	pushl  0xc(%ebp)
  80172e:	ff 75 08             	pushl  0x8(%ebp)
  801731:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801737:	50                   	push   %eax
  801738:	68 c2 16 80 00       	push   $0x8016c2
  80173d:	e8 20 01 00 00       	call   801862 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801742:	83 c4 08             	add    $0x8,%esp
  801745:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80174b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801751:	50                   	push   %eax
  801752:	e8 69 e9 ff ff       	call   8000c0 <sys_cputs>

	return b.cnt;
}
  801757:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80175f:	f3 0f 1e fb          	endbr32 
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801769:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80176c:	50                   	push   %eax
  80176d:	ff 75 08             	pushl  0x8(%ebp)
  801770:	e8 95 ff ff ff       	call   80170a <vcprintf>
	va_end(ap);

	return cnt;
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	57                   	push   %edi
  80177b:	56                   	push   %esi
  80177c:	53                   	push   %ebx
  80177d:	83 ec 1c             	sub    $0x1c,%esp
  801780:	89 c7                	mov    %eax,%edi
  801782:	89 d6                	mov    %edx,%esi
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	89 d1                	mov    %edx,%ecx
  80178c:	89 c2                	mov    %eax,%edx
  80178e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801791:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801794:	8b 45 10             	mov    0x10(%ebp),%eax
  801797:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80179a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80179d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8017a4:	39 c2                	cmp    %eax,%edx
  8017a6:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8017a9:	72 3e                	jb     8017e9 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	ff 75 18             	pushl  0x18(%ebp)
  8017b1:	83 eb 01             	sub    $0x1,%ebx
  8017b4:	53                   	push   %ebx
  8017b5:	50                   	push   %eax
  8017b6:	83 ec 08             	sub    $0x8,%esp
  8017b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8017bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8017c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8017c5:	e8 e6 0a 00 00       	call   8022b0 <__udivdi3>
  8017ca:	83 c4 18             	add    $0x18,%esp
  8017cd:	52                   	push   %edx
  8017ce:	50                   	push   %eax
  8017cf:	89 f2                	mov    %esi,%edx
  8017d1:	89 f8                	mov    %edi,%eax
  8017d3:	e8 9f ff ff ff       	call   801777 <printnum>
  8017d8:	83 c4 20             	add    $0x20,%esp
  8017db:	eb 13                	jmp    8017f0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	56                   	push   %esi
  8017e1:	ff 75 18             	pushl  0x18(%ebp)
  8017e4:	ff d7                	call   *%edi
  8017e6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8017e9:	83 eb 01             	sub    $0x1,%ebx
  8017ec:	85 db                	test   %ebx,%ebx
  8017ee:	7f ed                	jg     8017dd <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	56                   	push   %esi
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8017fd:	ff 75 dc             	pushl  -0x24(%ebp)
  801800:	ff 75 d8             	pushl  -0x28(%ebp)
  801803:	e8 b8 0b 00 00       	call   8023c0 <__umoddi3>
  801808:	83 c4 14             	add    $0x14,%esp
  80180b:	0f be 80 a3 26 80 00 	movsbl 0x8026a3(%eax),%eax
  801812:	50                   	push   %eax
  801813:	ff d7                	call   *%edi
}
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181b:	5b                   	pop    %ebx
  80181c:	5e                   	pop    %esi
  80181d:	5f                   	pop    %edi
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801820:	f3 0f 1e fb          	endbr32 
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80182a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80182e:	8b 10                	mov    (%eax),%edx
  801830:	3b 50 04             	cmp    0x4(%eax),%edx
  801833:	73 0a                	jae    80183f <sprintputch+0x1f>
		*b->buf++ = ch;
  801835:	8d 4a 01             	lea    0x1(%edx),%ecx
  801838:	89 08                	mov    %ecx,(%eax)
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	88 02                	mov    %al,(%edx)
}
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    

00801841 <printfmt>:
{
  801841:	f3 0f 1e fb          	endbr32 
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80184b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80184e:	50                   	push   %eax
  80184f:	ff 75 10             	pushl  0x10(%ebp)
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	e8 05 00 00 00       	call   801862 <vprintfmt>
}
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <vprintfmt>:
{
  801862:	f3 0f 1e fb          	endbr32 
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	57                   	push   %edi
  80186a:	56                   	push   %esi
  80186b:	53                   	push   %ebx
  80186c:	83 ec 3c             	sub    $0x3c,%esp
  80186f:	8b 75 08             	mov    0x8(%ebp),%esi
  801872:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801875:	8b 7d 10             	mov    0x10(%ebp),%edi
  801878:	e9 8e 03 00 00       	jmp    801c0b <vprintfmt+0x3a9>
		padc = ' ';
  80187d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801881:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801888:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80188f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801896:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80189b:	8d 47 01             	lea    0x1(%edi),%eax
  80189e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018a1:	0f b6 17             	movzbl (%edi),%edx
  8018a4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8018a7:	3c 55                	cmp    $0x55,%al
  8018a9:	0f 87 df 03 00 00    	ja     801c8e <vprintfmt+0x42c>
  8018af:	0f b6 c0             	movzbl %al,%eax
  8018b2:	3e ff 24 85 e0 27 80 	notrack jmp *0x8027e0(,%eax,4)
  8018b9:	00 
  8018ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8018bd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8018c1:	eb d8                	jmp    80189b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8018c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8018c6:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8018ca:	eb cf                	jmp    80189b <vprintfmt+0x39>
  8018cc:	0f b6 d2             	movzbl %dl,%edx
  8018cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8018d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8018da:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8018dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8018e1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8018e4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8018e7:	83 f9 09             	cmp    $0x9,%ecx
  8018ea:	77 55                	ja     801941 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8018ec:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8018ef:	eb e9                	jmp    8018da <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8018f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f4:	8b 00                	mov    (%eax),%eax
  8018f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fc:	8d 40 04             	lea    0x4(%eax),%eax
  8018ff:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801902:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801905:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801909:	79 90                	jns    80189b <vprintfmt+0x39>
				width = precision, precision = -1;
  80190b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80190e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801911:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801918:	eb 81                	jmp    80189b <vprintfmt+0x39>
  80191a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191d:	85 c0                	test   %eax,%eax
  80191f:	ba 00 00 00 00       	mov    $0x0,%edx
  801924:	0f 49 d0             	cmovns %eax,%edx
  801927:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80192a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80192d:	e9 69 ff ff ff       	jmp    80189b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801932:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801935:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80193c:	e9 5a ff ff ff       	jmp    80189b <vprintfmt+0x39>
  801941:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801944:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801947:	eb bc                	jmp    801905 <vprintfmt+0xa3>
			lflag++;
  801949:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80194c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80194f:	e9 47 ff ff ff       	jmp    80189b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801954:	8b 45 14             	mov    0x14(%ebp),%eax
  801957:	8d 78 04             	lea    0x4(%eax),%edi
  80195a:	83 ec 08             	sub    $0x8,%esp
  80195d:	53                   	push   %ebx
  80195e:	ff 30                	pushl  (%eax)
  801960:	ff d6                	call   *%esi
			break;
  801962:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801965:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801968:	e9 9b 02 00 00       	jmp    801c08 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8d 78 04             	lea    0x4(%eax),%edi
  801973:	8b 00                	mov    (%eax),%eax
  801975:	99                   	cltd   
  801976:	31 d0                	xor    %edx,%eax
  801978:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80197a:	83 f8 0f             	cmp    $0xf,%eax
  80197d:	7f 23                	jg     8019a2 <vprintfmt+0x140>
  80197f:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  801986:	85 d2                	test   %edx,%edx
  801988:	74 18                	je     8019a2 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80198a:	52                   	push   %edx
  80198b:	68 01 26 80 00       	push   $0x802601
  801990:	53                   	push   %ebx
  801991:	56                   	push   %esi
  801992:	e8 aa fe ff ff       	call   801841 <printfmt>
  801997:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80199a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80199d:	e9 66 02 00 00       	jmp    801c08 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8019a2:	50                   	push   %eax
  8019a3:	68 bb 26 80 00       	push   $0x8026bb
  8019a8:	53                   	push   %ebx
  8019a9:	56                   	push   %esi
  8019aa:	e8 92 fe ff ff       	call   801841 <printfmt>
  8019af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8019b2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8019b5:	e9 4e 02 00 00       	jmp    801c08 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8019ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bd:	83 c0 04             	add    $0x4,%eax
  8019c0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8019c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c6:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8019c8:	85 d2                	test   %edx,%edx
  8019ca:	b8 b4 26 80 00       	mov    $0x8026b4,%eax
  8019cf:	0f 45 c2             	cmovne %edx,%eax
  8019d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8019d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019d9:	7e 06                	jle    8019e1 <vprintfmt+0x17f>
  8019db:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8019df:	75 0d                	jne    8019ee <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019e4:	89 c7                	mov    %eax,%edi
  8019e6:	03 45 e0             	add    -0x20(%ebp),%eax
  8019e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019ec:	eb 55                	jmp    801a43 <vprintfmt+0x1e1>
  8019ee:	83 ec 08             	sub    $0x8,%esp
  8019f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8019f4:	ff 75 cc             	pushl  -0x34(%ebp)
  8019f7:	e8 46 03 00 00       	call   801d42 <strnlen>
  8019fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ff:	29 c2                	sub    %eax,%edx
  801a01:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801a09:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801a0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801a10:	85 ff                	test   %edi,%edi
  801a12:	7e 11                	jle    801a25 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801a14:	83 ec 08             	sub    $0x8,%esp
  801a17:	53                   	push   %ebx
  801a18:	ff 75 e0             	pushl  -0x20(%ebp)
  801a1b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801a1d:	83 ef 01             	sub    $0x1,%edi
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	eb eb                	jmp    801a10 <vprintfmt+0x1ae>
  801a25:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801a28:	85 d2                	test   %edx,%edx
  801a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2f:	0f 49 c2             	cmovns %edx,%eax
  801a32:	29 c2                	sub    %eax,%edx
  801a34:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801a37:	eb a8                	jmp    8019e1 <vprintfmt+0x17f>
					putch(ch, putdat);
  801a39:	83 ec 08             	sub    $0x8,%esp
  801a3c:	53                   	push   %ebx
  801a3d:	52                   	push   %edx
  801a3e:	ff d6                	call   *%esi
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801a46:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a48:	83 c7 01             	add    $0x1,%edi
  801a4b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a4f:	0f be d0             	movsbl %al,%edx
  801a52:	85 d2                	test   %edx,%edx
  801a54:	74 4b                	je     801aa1 <vprintfmt+0x23f>
  801a56:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a5a:	78 06                	js     801a62 <vprintfmt+0x200>
  801a5c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801a60:	78 1e                	js     801a80 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801a62:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a66:	74 d1                	je     801a39 <vprintfmt+0x1d7>
  801a68:	0f be c0             	movsbl %al,%eax
  801a6b:	83 e8 20             	sub    $0x20,%eax
  801a6e:	83 f8 5e             	cmp    $0x5e,%eax
  801a71:	76 c6                	jbe    801a39 <vprintfmt+0x1d7>
					putch('?', putdat);
  801a73:	83 ec 08             	sub    $0x8,%esp
  801a76:	53                   	push   %ebx
  801a77:	6a 3f                	push   $0x3f
  801a79:	ff d6                	call   *%esi
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	eb c3                	jmp    801a43 <vprintfmt+0x1e1>
  801a80:	89 cf                	mov    %ecx,%edi
  801a82:	eb 0e                	jmp    801a92 <vprintfmt+0x230>
				putch(' ', putdat);
  801a84:	83 ec 08             	sub    $0x8,%esp
  801a87:	53                   	push   %ebx
  801a88:	6a 20                	push   $0x20
  801a8a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801a8c:	83 ef 01             	sub    $0x1,%edi
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	85 ff                	test   %edi,%edi
  801a94:	7f ee                	jg     801a84 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a99:	89 45 14             	mov    %eax,0x14(%ebp)
  801a9c:	e9 67 01 00 00       	jmp    801c08 <vprintfmt+0x3a6>
  801aa1:	89 cf                	mov    %ecx,%edi
  801aa3:	eb ed                	jmp    801a92 <vprintfmt+0x230>
	if (lflag >= 2)
  801aa5:	83 f9 01             	cmp    $0x1,%ecx
  801aa8:	7f 1b                	jg     801ac5 <vprintfmt+0x263>
	else if (lflag)
  801aaa:	85 c9                	test   %ecx,%ecx
  801aac:	74 63                	je     801b11 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801aae:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab1:	8b 00                	mov    (%eax),%eax
  801ab3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ab6:	99                   	cltd   
  801ab7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801aba:	8b 45 14             	mov    0x14(%ebp),%eax
  801abd:	8d 40 04             	lea    0x4(%eax),%eax
  801ac0:	89 45 14             	mov    %eax,0x14(%ebp)
  801ac3:	eb 17                	jmp    801adc <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac8:	8b 50 04             	mov    0x4(%eax),%edx
  801acb:	8b 00                	mov    (%eax),%eax
  801acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ad0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad6:	8d 40 08             	lea    0x8(%eax),%eax
  801ad9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801adc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801adf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801ae2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801ae7:	85 c9                	test   %ecx,%ecx
  801ae9:	0f 89 ff 00 00 00    	jns    801bee <vprintfmt+0x38c>
				putch('-', putdat);
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	53                   	push   %ebx
  801af3:	6a 2d                	push   $0x2d
  801af5:	ff d6                	call   *%esi
				num = -(long long) num;
  801af7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801afa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801afd:	f7 da                	neg    %edx
  801aff:	83 d1 00             	adc    $0x0,%ecx
  801b02:	f7 d9                	neg    %ecx
  801b04:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801b07:	b8 0a 00 00 00       	mov    $0xa,%eax
  801b0c:	e9 dd 00 00 00       	jmp    801bee <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801b11:	8b 45 14             	mov    0x14(%ebp),%eax
  801b14:	8b 00                	mov    (%eax),%eax
  801b16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b19:	99                   	cltd   
  801b1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b20:	8d 40 04             	lea    0x4(%eax),%eax
  801b23:	89 45 14             	mov    %eax,0x14(%ebp)
  801b26:	eb b4                	jmp    801adc <vprintfmt+0x27a>
	if (lflag >= 2)
  801b28:	83 f9 01             	cmp    $0x1,%ecx
  801b2b:	7f 1e                	jg     801b4b <vprintfmt+0x2e9>
	else if (lflag)
  801b2d:	85 c9                	test   %ecx,%ecx
  801b2f:	74 32                	je     801b63 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801b31:	8b 45 14             	mov    0x14(%ebp),%eax
  801b34:	8b 10                	mov    (%eax),%edx
  801b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3b:	8d 40 04             	lea    0x4(%eax),%eax
  801b3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b41:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801b46:	e9 a3 00 00 00       	jmp    801bee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4e:	8b 10                	mov    (%eax),%edx
  801b50:	8b 48 04             	mov    0x4(%eax),%ecx
  801b53:	8d 40 08             	lea    0x8(%eax),%eax
  801b56:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b59:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801b5e:	e9 8b 00 00 00       	jmp    801bee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b63:	8b 45 14             	mov    0x14(%ebp),%eax
  801b66:	8b 10                	mov    (%eax),%edx
  801b68:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b6d:	8d 40 04             	lea    0x4(%eax),%eax
  801b70:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b73:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801b78:	eb 74                	jmp    801bee <vprintfmt+0x38c>
	if (lflag >= 2)
  801b7a:	83 f9 01             	cmp    $0x1,%ecx
  801b7d:	7f 1b                	jg     801b9a <vprintfmt+0x338>
	else if (lflag)
  801b7f:	85 c9                	test   %ecx,%ecx
  801b81:	74 2c                	je     801baf <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801b83:	8b 45 14             	mov    0x14(%ebp),%eax
  801b86:	8b 10                	mov    (%eax),%edx
  801b88:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b8d:	8d 40 04             	lea    0x4(%eax),%eax
  801b90:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b93:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b98:	eb 54                	jmp    801bee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9d:	8b 10                	mov    (%eax),%edx
  801b9f:	8b 48 04             	mov    0x4(%eax),%ecx
  801ba2:	8d 40 08             	lea    0x8(%eax),%eax
  801ba5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ba8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801bad:	eb 3f                	jmp    801bee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801baf:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb2:	8b 10                	mov    (%eax),%edx
  801bb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb9:	8d 40 04             	lea    0x4(%eax),%eax
  801bbc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801bbf:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801bc4:	eb 28                	jmp    801bee <vprintfmt+0x38c>
			putch('0', putdat);
  801bc6:	83 ec 08             	sub    $0x8,%esp
  801bc9:	53                   	push   %ebx
  801bca:	6a 30                	push   $0x30
  801bcc:	ff d6                	call   *%esi
			putch('x', putdat);
  801bce:	83 c4 08             	add    $0x8,%esp
  801bd1:	53                   	push   %ebx
  801bd2:	6a 78                	push   $0x78
  801bd4:	ff d6                	call   *%esi
			num = (unsigned long long)
  801bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd9:	8b 10                	mov    (%eax),%edx
  801bdb:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801be0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801be3:	8d 40 04             	lea    0x4(%eax),%eax
  801be6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801be9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801bee:	83 ec 0c             	sub    $0xc,%esp
  801bf1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801bf5:	57                   	push   %edi
  801bf6:	ff 75 e0             	pushl  -0x20(%ebp)
  801bf9:	50                   	push   %eax
  801bfa:	51                   	push   %ecx
  801bfb:	52                   	push   %edx
  801bfc:	89 da                	mov    %ebx,%edx
  801bfe:	89 f0                	mov    %esi,%eax
  801c00:	e8 72 fb ff ff       	call   801777 <printnum>
			break;
  801c05:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801c08:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c0b:	83 c7 01             	add    $0x1,%edi
  801c0e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801c12:	83 f8 25             	cmp    $0x25,%eax
  801c15:	0f 84 62 fc ff ff    	je     80187d <vprintfmt+0x1b>
			if (ch == '\0')
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	0f 84 8b 00 00 00    	je     801cae <vprintfmt+0x44c>
			putch(ch, putdat);
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	53                   	push   %ebx
  801c27:	50                   	push   %eax
  801c28:	ff d6                	call   *%esi
  801c2a:	83 c4 10             	add    $0x10,%esp
  801c2d:	eb dc                	jmp    801c0b <vprintfmt+0x3a9>
	if (lflag >= 2)
  801c2f:	83 f9 01             	cmp    $0x1,%ecx
  801c32:	7f 1b                	jg     801c4f <vprintfmt+0x3ed>
	else if (lflag)
  801c34:	85 c9                	test   %ecx,%ecx
  801c36:	74 2c                	je     801c64 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801c38:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3b:	8b 10                	mov    (%eax),%edx
  801c3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c42:	8d 40 04             	lea    0x4(%eax),%eax
  801c45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c48:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801c4d:	eb 9f                	jmp    801bee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c52:	8b 10                	mov    (%eax),%edx
  801c54:	8b 48 04             	mov    0x4(%eax),%ecx
  801c57:	8d 40 08             	lea    0x8(%eax),%eax
  801c5a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c5d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801c62:	eb 8a                	jmp    801bee <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8b 10                	mov    (%eax),%edx
  801c69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6e:	8d 40 04             	lea    0x4(%eax),%eax
  801c71:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c74:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801c79:	e9 70 ff ff ff       	jmp    801bee <vprintfmt+0x38c>
			putch(ch, putdat);
  801c7e:	83 ec 08             	sub    $0x8,%esp
  801c81:	53                   	push   %ebx
  801c82:	6a 25                	push   $0x25
  801c84:	ff d6                	call   *%esi
			break;
  801c86:	83 c4 10             	add    $0x10,%esp
  801c89:	e9 7a ff ff ff       	jmp    801c08 <vprintfmt+0x3a6>
			putch('%', putdat);
  801c8e:	83 ec 08             	sub    $0x8,%esp
  801c91:	53                   	push   %ebx
  801c92:	6a 25                	push   $0x25
  801c94:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	89 f8                	mov    %edi,%eax
  801c9b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c9f:	74 05                	je     801ca6 <vprintfmt+0x444>
  801ca1:	83 e8 01             	sub    $0x1,%eax
  801ca4:	eb f5                	jmp    801c9b <vprintfmt+0x439>
  801ca6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ca9:	e9 5a ff ff ff       	jmp    801c08 <vprintfmt+0x3a6>
}
  801cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb1:	5b                   	pop    %ebx
  801cb2:	5e                   	pop    %esi
  801cb3:	5f                   	pop    %edi
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    

00801cb6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cb6:	f3 0f 1e fb          	endbr32 
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 18             	sub    $0x18,%esp
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801cc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cc9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801ccd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801cd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	74 26                	je     801d01 <vsnprintf+0x4b>
  801cdb:	85 d2                	test   %edx,%edx
  801cdd:	7e 22                	jle    801d01 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801cdf:	ff 75 14             	pushl  0x14(%ebp)
  801ce2:	ff 75 10             	pushl  0x10(%ebp)
  801ce5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ce8:	50                   	push   %eax
  801ce9:	68 20 18 80 00       	push   $0x801820
  801cee:	e8 6f fb ff ff       	call   801862 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfc:	83 c4 10             	add    $0x10,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    
		return -E_INVAL;
  801d01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d06:	eb f7                	jmp    801cff <vsnprintf+0x49>

00801d08 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d08:	f3 0f 1e fb          	endbr32 
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d12:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801d15:	50                   	push   %eax
  801d16:	ff 75 10             	pushl  0x10(%ebp)
  801d19:	ff 75 0c             	pushl  0xc(%ebp)
  801d1c:	ff 75 08             	pushl  0x8(%ebp)
  801d1f:	e8 92 ff ff ff       	call   801cb6 <vsnprintf>
	va_end(ap);

	return rc;
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801d26:	f3 0f 1e fb          	endbr32 
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
  801d35:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801d39:	74 05                	je     801d40 <strlen+0x1a>
		n++;
  801d3b:	83 c0 01             	add    $0x1,%eax
  801d3e:	eb f5                	jmp    801d35 <strlen+0xf>
	return n;
}
  801d40:	5d                   	pop    %ebp
  801d41:	c3                   	ret    

00801d42 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801d42:	f3 0f 1e fb          	endbr32 
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d54:	39 d0                	cmp    %edx,%eax
  801d56:	74 0d                	je     801d65 <strnlen+0x23>
  801d58:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801d5c:	74 05                	je     801d63 <strnlen+0x21>
		n++;
  801d5e:	83 c0 01             	add    $0x1,%eax
  801d61:	eb f1                	jmp    801d54 <strnlen+0x12>
  801d63:	89 c2                	mov    %eax,%edx
	return n;
}
  801d65:	89 d0                	mov    %edx,%eax
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    

00801d69 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d69:	f3 0f 1e fb          	endbr32 
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	53                   	push   %ebx
  801d71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d74:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801d77:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801d80:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801d83:	83 c0 01             	add    $0x1,%eax
  801d86:	84 d2                	test   %dl,%dl
  801d88:	75 f2                	jne    801d7c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801d8a:	89 c8                	mov    %ecx,%eax
  801d8c:	5b                   	pop    %ebx
  801d8d:	5d                   	pop    %ebp
  801d8e:	c3                   	ret    

00801d8f <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d8f:	f3 0f 1e fb          	endbr32 
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	53                   	push   %ebx
  801d97:	83 ec 10             	sub    $0x10,%esp
  801d9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d9d:	53                   	push   %ebx
  801d9e:	e8 83 ff ff ff       	call   801d26 <strlen>
  801da3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801da6:	ff 75 0c             	pushl  0xc(%ebp)
  801da9:	01 d8                	add    %ebx,%eax
  801dab:	50                   	push   %eax
  801dac:	e8 b8 ff ff ff       	call   801d69 <strcpy>
	return dst;
}
  801db1:	89 d8                	mov    %ebx,%eax
  801db3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801db8:	f3 0f 1e fb          	endbr32 
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	56                   	push   %esi
  801dc0:	53                   	push   %ebx
  801dc1:	8b 75 08             	mov    0x8(%ebp),%esi
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	89 f3                	mov    %esi,%ebx
  801dc9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801dcc:	89 f0                	mov    %esi,%eax
  801dce:	39 d8                	cmp    %ebx,%eax
  801dd0:	74 11                	je     801de3 <strncpy+0x2b>
		*dst++ = *src;
  801dd2:	83 c0 01             	add    $0x1,%eax
  801dd5:	0f b6 0a             	movzbl (%edx),%ecx
  801dd8:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801ddb:	80 f9 01             	cmp    $0x1,%cl
  801dde:	83 da ff             	sbb    $0xffffffff,%edx
  801de1:	eb eb                	jmp    801dce <strncpy+0x16>
	}
	return ret;
}
  801de3:	89 f0                	mov    %esi,%eax
  801de5:	5b                   	pop    %ebx
  801de6:	5e                   	pop    %esi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801de9:	f3 0f 1e fb          	endbr32 
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	56                   	push   %esi
  801df1:	53                   	push   %ebx
  801df2:	8b 75 08             	mov    0x8(%ebp),%esi
  801df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801df8:	8b 55 10             	mov    0x10(%ebp),%edx
  801dfb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801dfd:	85 d2                	test   %edx,%edx
  801dff:	74 21                	je     801e22 <strlcpy+0x39>
  801e01:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801e05:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801e07:	39 c2                	cmp    %eax,%edx
  801e09:	74 14                	je     801e1f <strlcpy+0x36>
  801e0b:	0f b6 19             	movzbl (%ecx),%ebx
  801e0e:	84 db                	test   %bl,%bl
  801e10:	74 0b                	je     801e1d <strlcpy+0x34>
			*dst++ = *src++;
  801e12:	83 c1 01             	add    $0x1,%ecx
  801e15:	83 c2 01             	add    $0x1,%edx
  801e18:	88 5a ff             	mov    %bl,-0x1(%edx)
  801e1b:	eb ea                	jmp    801e07 <strlcpy+0x1e>
  801e1d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801e1f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e22:	29 f0                	sub    %esi,%eax
}
  801e24:	5b                   	pop    %ebx
  801e25:	5e                   	pop    %esi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    

00801e28 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e28:	f3 0f 1e fb          	endbr32 
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e32:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801e35:	0f b6 01             	movzbl (%ecx),%eax
  801e38:	84 c0                	test   %al,%al
  801e3a:	74 0c                	je     801e48 <strcmp+0x20>
  801e3c:	3a 02                	cmp    (%edx),%al
  801e3e:	75 08                	jne    801e48 <strcmp+0x20>
		p++, q++;
  801e40:	83 c1 01             	add    $0x1,%ecx
  801e43:	83 c2 01             	add    $0x1,%edx
  801e46:	eb ed                	jmp    801e35 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e48:	0f b6 c0             	movzbl %al,%eax
  801e4b:	0f b6 12             	movzbl (%edx),%edx
  801e4e:	29 d0                	sub    %edx,%eax
}
  801e50:	5d                   	pop    %ebp
  801e51:	c3                   	ret    

00801e52 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801e52:	f3 0f 1e fb          	endbr32 
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	53                   	push   %ebx
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e60:	89 c3                	mov    %eax,%ebx
  801e62:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801e65:	eb 06                	jmp    801e6d <strncmp+0x1b>
		n--, p++, q++;
  801e67:	83 c0 01             	add    $0x1,%eax
  801e6a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801e6d:	39 d8                	cmp    %ebx,%eax
  801e6f:	74 16                	je     801e87 <strncmp+0x35>
  801e71:	0f b6 08             	movzbl (%eax),%ecx
  801e74:	84 c9                	test   %cl,%cl
  801e76:	74 04                	je     801e7c <strncmp+0x2a>
  801e78:	3a 0a                	cmp    (%edx),%cl
  801e7a:	74 eb                	je     801e67 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e7c:	0f b6 00             	movzbl (%eax),%eax
  801e7f:	0f b6 12             	movzbl (%edx),%edx
  801e82:	29 d0                	sub    %edx,%eax
}
  801e84:	5b                   	pop    %ebx
  801e85:	5d                   	pop    %ebp
  801e86:	c3                   	ret    
		return 0;
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8c:	eb f6                	jmp    801e84 <strncmp+0x32>

00801e8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e8e:	f3 0f 1e fb          	endbr32 
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e9c:	0f b6 10             	movzbl (%eax),%edx
  801e9f:	84 d2                	test   %dl,%dl
  801ea1:	74 09                	je     801eac <strchr+0x1e>
		if (*s == c)
  801ea3:	38 ca                	cmp    %cl,%dl
  801ea5:	74 0a                	je     801eb1 <strchr+0x23>
	for (; *s; s++)
  801ea7:	83 c0 01             	add    $0x1,%eax
  801eaa:	eb f0                	jmp    801e9c <strchr+0xe>
			return (char *) s;
	return 0;
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    

00801eb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801eb3:	f3 0f 1e fb          	endbr32 
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801ec1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801ec4:	38 ca                	cmp    %cl,%dl
  801ec6:	74 09                	je     801ed1 <strfind+0x1e>
  801ec8:	84 d2                	test   %dl,%dl
  801eca:	74 05                	je     801ed1 <strfind+0x1e>
	for (; *s; s++)
  801ecc:	83 c0 01             	add    $0x1,%eax
  801ecf:	eb f0                	jmp    801ec1 <strfind+0xe>
			break;
	return (char *) s;
}
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    

00801ed3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ed3:	f3 0f 1e fb          	endbr32 
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	57                   	push   %edi
  801edb:	56                   	push   %esi
  801edc:	53                   	push   %ebx
  801edd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ee0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ee3:	85 c9                	test   %ecx,%ecx
  801ee5:	74 31                	je     801f18 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ee7:	89 f8                	mov    %edi,%eax
  801ee9:	09 c8                	or     %ecx,%eax
  801eeb:	a8 03                	test   $0x3,%al
  801eed:	75 23                	jne    801f12 <memset+0x3f>
		c &= 0xFF;
  801eef:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ef3:	89 d3                	mov    %edx,%ebx
  801ef5:	c1 e3 08             	shl    $0x8,%ebx
  801ef8:	89 d0                	mov    %edx,%eax
  801efa:	c1 e0 18             	shl    $0x18,%eax
  801efd:	89 d6                	mov    %edx,%esi
  801eff:	c1 e6 10             	shl    $0x10,%esi
  801f02:	09 f0                	or     %esi,%eax
  801f04:	09 c2                	or     %eax,%edx
  801f06:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801f08:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801f0b:	89 d0                	mov    %edx,%eax
  801f0d:	fc                   	cld    
  801f0e:	f3 ab                	rep stos %eax,%es:(%edi)
  801f10:	eb 06                	jmp    801f18 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f15:	fc                   	cld    
  801f16:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801f18:	89 f8                	mov    %edi,%eax
  801f1a:	5b                   	pop    %ebx
  801f1b:	5e                   	pop    %esi
  801f1c:	5f                   	pop    %edi
  801f1d:	5d                   	pop    %ebp
  801f1e:	c3                   	ret    

00801f1f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801f1f:	f3 0f 1e fb          	endbr32 
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	57                   	push   %edi
  801f27:	56                   	push   %esi
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801f31:	39 c6                	cmp    %eax,%esi
  801f33:	73 32                	jae    801f67 <memmove+0x48>
  801f35:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801f38:	39 c2                	cmp    %eax,%edx
  801f3a:	76 2b                	jbe    801f67 <memmove+0x48>
		s += n;
		d += n;
  801f3c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f3f:	89 fe                	mov    %edi,%esi
  801f41:	09 ce                	or     %ecx,%esi
  801f43:	09 d6                	or     %edx,%esi
  801f45:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801f4b:	75 0e                	jne    801f5b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801f4d:	83 ef 04             	sub    $0x4,%edi
  801f50:	8d 72 fc             	lea    -0x4(%edx),%esi
  801f53:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801f56:	fd                   	std    
  801f57:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f59:	eb 09                	jmp    801f64 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f5b:	83 ef 01             	sub    $0x1,%edi
  801f5e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801f61:	fd                   	std    
  801f62:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f64:	fc                   	cld    
  801f65:	eb 1a                	jmp    801f81 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f67:	89 c2                	mov    %eax,%edx
  801f69:	09 ca                	or     %ecx,%edx
  801f6b:	09 f2                	or     %esi,%edx
  801f6d:	f6 c2 03             	test   $0x3,%dl
  801f70:	75 0a                	jne    801f7c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f72:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801f75:	89 c7                	mov    %eax,%edi
  801f77:	fc                   	cld    
  801f78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f7a:	eb 05                	jmp    801f81 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801f7c:	89 c7                	mov    %eax,%edi
  801f7e:	fc                   	cld    
  801f7f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801f81:	5e                   	pop    %esi
  801f82:	5f                   	pop    %edi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    

00801f85 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f85:	f3 0f 1e fb          	endbr32 
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f8f:	ff 75 10             	pushl  0x10(%ebp)
  801f92:	ff 75 0c             	pushl  0xc(%ebp)
  801f95:	ff 75 08             	pushl  0x8(%ebp)
  801f98:	e8 82 ff ff ff       	call   801f1f <memmove>
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f9f:	f3 0f 1e fb          	endbr32 
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	56                   	push   %esi
  801fa7:	53                   	push   %ebx
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fae:	89 c6                	mov    %eax,%esi
  801fb0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801fb3:	39 f0                	cmp    %esi,%eax
  801fb5:	74 1c                	je     801fd3 <memcmp+0x34>
		if (*s1 != *s2)
  801fb7:	0f b6 08             	movzbl (%eax),%ecx
  801fba:	0f b6 1a             	movzbl (%edx),%ebx
  801fbd:	38 d9                	cmp    %bl,%cl
  801fbf:	75 08                	jne    801fc9 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801fc1:	83 c0 01             	add    $0x1,%eax
  801fc4:	83 c2 01             	add    $0x1,%edx
  801fc7:	eb ea                	jmp    801fb3 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801fc9:	0f b6 c1             	movzbl %cl,%eax
  801fcc:	0f b6 db             	movzbl %bl,%ebx
  801fcf:	29 d8                	sub    %ebx,%eax
  801fd1:	eb 05                	jmp    801fd8 <memcmp+0x39>
	}

	return 0;
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd8:	5b                   	pop    %ebx
  801fd9:	5e                   	pop    %esi
  801fda:	5d                   	pop    %ebp
  801fdb:	c3                   	ret    

00801fdc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801fdc:	f3 0f 1e fb          	endbr32 
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801fe9:	89 c2                	mov    %eax,%edx
  801feb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801fee:	39 d0                	cmp    %edx,%eax
  801ff0:	73 09                	jae    801ffb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ff2:	38 08                	cmp    %cl,(%eax)
  801ff4:	74 05                	je     801ffb <memfind+0x1f>
	for (; s < ends; s++)
  801ff6:	83 c0 01             	add    $0x1,%eax
  801ff9:	eb f3                	jmp    801fee <memfind+0x12>
			break;
	return (void *) s;
}
  801ffb:	5d                   	pop    %ebp
  801ffc:	c3                   	ret    

00801ffd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ffd:	f3 0f 1e fb          	endbr32 
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	57                   	push   %edi
  802005:	56                   	push   %esi
  802006:	53                   	push   %ebx
  802007:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80200a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80200d:	eb 03                	jmp    802012 <strtol+0x15>
		s++;
  80200f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  802012:	0f b6 01             	movzbl (%ecx),%eax
  802015:	3c 20                	cmp    $0x20,%al
  802017:	74 f6                	je     80200f <strtol+0x12>
  802019:	3c 09                	cmp    $0x9,%al
  80201b:	74 f2                	je     80200f <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80201d:	3c 2b                	cmp    $0x2b,%al
  80201f:	74 2a                	je     80204b <strtol+0x4e>
	int neg = 0;
  802021:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  802026:	3c 2d                	cmp    $0x2d,%al
  802028:	74 2b                	je     802055 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80202a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  802030:	75 0f                	jne    802041 <strtol+0x44>
  802032:	80 39 30             	cmpb   $0x30,(%ecx)
  802035:	74 28                	je     80205f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802037:	85 db                	test   %ebx,%ebx
  802039:	b8 0a 00 00 00       	mov    $0xa,%eax
  80203e:	0f 44 d8             	cmove  %eax,%ebx
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802049:	eb 46                	jmp    802091 <strtol+0x94>
		s++;
  80204b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80204e:	bf 00 00 00 00       	mov    $0x0,%edi
  802053:	eb d5                	jmp    80202a <strtol+0x2d>
		s++, neg = 1;
  802055:	83 c1 01             	add    $0x1,%ecx
  802058:	bf 01 00 00 00       	mov    $0x1,%edi
  80205d:	eb cb                	jmp    80202a <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80205f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802063:	74 0e                	je     802073 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802065:	85 db                	test   %ebx,%ebx
  802067:	75 d8                	jne    802041 <strtol+0x44>
		s++, base = 8;
  802069:	83 c1 01             	add    $0x1,%ecx
  80206c:	bb 08 00 00 00       	mov    $0x8,%ebx
  802071:	eb ce                	jmp    802041 <strtol+0x44>
		s += 2, base = 16;
  802073:	83 c1 02             	add    $0x2,%ecx
  802076:	bb 10 00 00 00       	mov    $0x10,%ebx
  80207b:	eb c4                	jmp    802041 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80207d:	0f be d2             	movsbl %dl,%edx
  802080:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802083:	3b 55 10             	cmp    0x10(%ebp),%edx
  802086:	7d 3a                	jge    8020c2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802088:	83 c1 01             	add    $0x1,%ecx
  80208b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80208f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802091:	0f b6 11             	movzbl (%ecx),%edx
  802094:	8d 72 d0             	lea    -0x30(%edx),%esi
  802097:	89 f3                	mov    %esi,%ebx
  802099:	80 fb 09             	cmp    $0x9,%bl
  80209c:	76 df                	jbe    80207d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  80209e:	8d 72 9f             	lea    -0x61(%edx),%esi
  8020a1:	89 f3                	mov    %esi,%ebx
  8020a3:	80 fb 19             	cmp    $0x19,%bl
  8020a6:	77 08                	ja     8020b0 <strtol+0xb3>
			dig = *s - 'a' + 10;
  8020a8:	0f be d2             	movsbl %dl,%edx
  8020ab:	83 ea 57             	sub    $0x57,%edx
  8020ae:	eb d3                	jmp    802083 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  8020b0:	8d 72 bf             	lea    -0x41(%edx),%esi
  8020b3:	89 f3                	mov    %esi,%ebx
  8020b5:	80 fb 19             	cmp    $0x19,%bl
  8020b8:	77 08                	ja     8020c2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  8020ba:	0f be d2             	movsbl %dl,%edx
  8020bd:	83 ea 37             	sub    $0x37,%edx
  8020c0:	eb c1                	jmp    802083 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  8020c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020c6:	74 05                	je     8020cd <strtol+0xd0>
		*endptr = (char *) s;
  8020c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020cb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8020cd:	89 c2                	mov    %eax,%edx
  8020cf:	f7 da                	neg    %edx
  8020d1:	85 ff                	test   %edi,%edi
  8020d3:	0f 45 c2             	cmovne %edx,%eax
}
  8020d6:	5b                   	pop    %ebx
  8020d7:	5e                   	pop    %esi
  8020d8:	5f                   	pop    %edi
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    

008020db <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020db:	f3 0f 1e fb          	endbr32 
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020e5:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8020ec:	74 0a                	je     8020f8 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	6a 07                	push   $0x7
  8020fd:	68 00 f0 bf ee       	push   $0xeebff000
  802102:	6a 00                	push   $0x0
  802104:	e8 87 e0 ff ff       	call   800190 <sys_page_alloc>
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	85 c0                	test   %eax,%eax
  80210e:	78 2a                	js     80213a <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802110:	83 ec 08             	sub    $0x8,%esp
  802113:	68 50 04 80 00       	push   $0x800450
  802118:	6a 00                	push   $0x0
  80211a:	e8 d0 e1 ff ff       	call   8002ef <sys_env_set_pgfault_upcall>
  80211f:	83 c4 10             	add    $0x10,%esp
  802122:	85 c0                	test   %eax,%eax
  802124:	79 c8                	jns    8020ee <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802126:	83 ec 04             	sub    $0x4,%esp
  802129:	68 cc 29 80 00       	push   $0x8029cc
  80212e:	6a 25                	push   $0x25
  802130:	68 04 2a 80 00       	push   $0x802a04
  802135:	e8 3e f5 ff ff       	call   801678 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	68 a0 29 80 00       	push   $0x8029a0
  802142:	6a 22                	push   $0x22
  802144:	68 04 2a 80 00       	push   $0x802a04
  802149:	e8 2a f5 ff ff       	call   801678 <_panic>

0080214e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80214e:	f3 0f 1e fb          	endbr32 
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	56                   	push   %esi
  802156:	53                   	push   %ebx
  802157:	8b 75 08             	mov    0x8(%ebp),%esi
  80215a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802160:	85 c0                	test   %eax,%eax
  802162:	74 3d                	je     8021a1 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802164:	83 ec 0c             	sub    $0xc,%esp
  802167:	50                   	push   %eax
  802168:	e8 ef e1 ff ff       	call   80035c <sys_ipc_recv>
  80216d:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802170:	85 f6                	test   %esi,%esi
  802172:	74 0b                	je     80217f <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802174:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80217a:	8b 52 74             	mov    0x74(%edx),%edx
  80217d:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80217f:	85 db                	test   %ebx,%ebx
  802181:	74 0b                	je     80218e <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802183:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802189:	8b 52 78             	mov    0x78(%edx),%edx
  80218c:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80218e:	85 c0                	test   %eax,%eax
  802190:	78 21                	js     8021b3 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802192:	a1 08 40 80 00       	mov    0x804008,%eax
  802197:	8b 40 70             	mov    0x70(%eax),%eax
}
  80219a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5d                   	pop    %ebp
  8021a0:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8021a1:	83 ec 0c             	sub    $0xc,%esp
  8021a4:	68 00 00 c0 ee       	push   $0xeec00000
  8021a9:	e8 ae e1 ff ff       	call   80035c <sys_ipc_recv>
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	eb bd                	jmp    802170 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8021b3:	85 f6                	test   %esi,%esi
  8021b5:	74 10                	je     8021c7 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8021b7:	85 db                	test   %ebx,%ebx
  8021b9:	75 df                	jne    80219a <ipc_recv+0x4c>
  8021bb:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021c2:	00 00 00 
  8021c5:	eb d3                	jmp    80219a <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8021c7:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021ce:	00 00 00 
  8021d1:	eb e4                	jmp    8021b7 <ipc_recv+0x69>

008021d3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021d3:	f3 0f 1e fb          	endbr32 
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	57                   	push   %edi
  8021db:	56                   	push   %esi
  8021dc:	53                   	push   %ebx
  8021dd:	83 ec 0c             	sub    $0xc,%esp
  8021e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8021e9:	85 db                	test   %ebx,%ebx
  8021eb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021f0:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8021f3:	ff 75 14             	pushl  0x14(%ebp)
  8021f6:	53                   	push   %ebx
  8021f7:	56                   	push   %esi
  8021f8:	57                   	push   %edi
  8021f9:	e8 37 e1 ff ff       	call   800335 <sys_ipc_try_send>
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	85 c0                	test   %eax,%eax
  802203:	79 1e                	jns    802223 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802205:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802208:	75 07                	jne    802211 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80220a:	e8 5e df ff ff       	call   80016d <sys_yield>
  80220f:	eb e2                	jmp    8021f3 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802211:	50                   	push   %eax
  802212:	68 12 2a 80 00       	push   $0x802a12
  802217:	6a 59                	push   $0x59
  802219:	68 2d 2a 80 00       	push   $0x802a2d
  80221e:	e8 55 f4 ff ff       	call   801678 <_panic>
	}
}
  802223:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802226:	5b                   	pop    %ebx
  802227:	5e                   	pop    %esi
  802228:	5f                   	pop    %edi
  802229:	5d                   	pop    %ebp
  80222a:	c3                   	ret    

0080222b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80222b:	f3 0f 1e fb          	endbr32 
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
  802232:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80223a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80223d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802243:	8b 52 50             	mov    0x50(%edx),%edx
  802246:	39 ca                	cmp    %ecx,%edx
  802248:	74 11                	je     80225b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80224a:	83 c0 01             	add    $0x1,%eax
  80224d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802252:	75 e6                	jne    80223a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802254:	b8 00 00 00 00       	mov    $0x0,%eax
  802259:	eb 0b                	jmp    802266 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80225b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80225e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802263:	8b 40 48             	mov    0x48(%eax),%eax
}
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    

00802268 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802268:	f3 0f 1e fb          	endbr32 
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802272:	89 c2                	mov    %eax,%edx
  802274:	c1 ea 16             	shr    $0x16,%edx
  802277:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80227e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802283:	f6 c1 01             	test   $0x1,%cl
  802286:	74 1c                	je     8022a4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802288:	c1 e8 0c             	shr    $0xc,%eax
  80228b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802292:	a8 01                	test   $0x1,%al
  802294:	74 0e                	je     8022a4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802296:	c1 e8 0c             	shr    $0xc,%eax
  802299:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022a0:	ef 
  8022a1:	0f b7 d2             	movzwl %dx,%edx
}
  8022a4:	89 d0                	mov    %edx,%eax
  8022a6:	5d                   	pop    %ebp
  8022a7:	c3                   	ret    
  8022a8:	66 90                	xchg   %ax,%ax
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <__udivdi3>:
  8022b0:	f3 0f 1e fb          	endbr32 
  8022b4:	55                   	push   %ebp
  8022b5:	57                   	push   %edi
  8022b6:	56                   	push   %esi
  8022b7:	53                   	push   %ebx
  8022b8:	83 ec 1c             	sub    $0x1c,%esp
  8022bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022cb:	85 d2                	test   %edx,%edx
  8022cd:	75 19                	jne    8022e8 <__udivdi3+0x38>
  8022cf:	39 f3                	cmp    %esi,%ebx
  8022d1:	76 4d                	jbe    802320 <__udivdi3+0x70>
  8022d3:	31 ff                	xor    %edi,%edi
  8022d5:	89 e8                	mov    %ebp,%eax
  8022d7:	89 f2                	mov    %esi,%edx
  8022d9:	f7 f3                	div    %ebx
  8022db:	89 fa                	mov    %edi,%edx
  8022dd:	83 c4 1c             	add    $0x1c,%esp
  8022e0:	5b                   	pop    %ebx
  8022e1:	5e                   	pop    %esi
  8022e2:	5f                   	pop    %edi
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    
  8022e5:	8d 76 00             	lea    0x0(%esi),%esi
  8022e8:	39 f2                	cmp    %esi,%edx
  8022ea:	76 14                	jbe    802300 <__udivdi3+0x50>
  8022ec:	31 ff                	xor    %edi,%edi
  8022ee:	31 c0                	xor    %eax,%eax
  8022f0:	89 fa                	mov    %edi,%edx
  8022f2:	83 c4 1c             	add    $0x1c,%esp
  8022f5:	5b                   	pop    %ebx
  8022f6:	5e                   	pop    %esi
  8022f7:	5f                   	pop    %edi
  8022f8:	5d                   	pop    %ebp
  8022f9:	c3                   	ret    
  8022fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802300:	0f bd fa             	bsr    %edx,%edi
  802303:	83 f7 1f             	xor    $0x1f,%edi
  802306:	75 48                	jne    802350 <__udivdi3+0xa0>
  802308:	39 f2                	cmp    %esi,%edx
  80230a:	72 06                	jb     802312 <__udivdi3+0x62>
  80230c:	31 c0                	xor    %eax,%eax
  80230e:	39 eb                	cmp    %ebp,%ebx
  802310:	77 de                	ja     8022f0 <__udivdi3+0x40>
  802312:	b8 01 00 00 00       	mov    $0x1,%eax
  802317:	eb d7                	jmp    8022f0 <__udivdi3+0x40>
  802319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802320:	89 d9                	mov    %ebx,%ecx
  802322:	85 db                	test   %ebx,%ebx
  802324:	75 0b                	jne    802331 <__udivdi3+0x81>
  802326:	b8 01 00 00 00       	mov    $0x1,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	f7 f3                	div    %ebx
  80232f:	89 c1                	mov    %eax,%ecx
  802331:	31 d2                	xor    %edx,%edx
  802333:	89 f0                	mov    %esi,%eax
  802335:	f7 f1                	div    %ecx
  802337:	89 c6                	mov    %eax,%esi
  802339:	89 e8                	mov    %ebp,%eax
  80233b:	89 f7                	mov    %esi,%edi
  80233d:	f7 f1                	div    %ecx
  80233f:	89 fa                	mov    %edi,%edx
  802341:	83 c4 1c             	add    $0x1c,%esp
  802344:	5b                   	pop    %ebx
  802345:	5e                   	pop    %esi
  802346:	5f                   	pop    %edi
  802347:	5d                   	pop    %ebp
  802348:	c3                   	ret    
  802349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802350:	89 f9                	mov    %edi,%ecx
  802352:	b8 20 00 00 00       	mov    $0x20,%eax
  802357:	29 f8                	sub    %edi,%eax
  802359:	d3 e2                	shl    %cl,%edx
  80235b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80235f:	89 c1                	mov    %eax,%ecx
  802361:	89 da                	mov    %ebx,%edx
  802363:	d3 ea                	shr    %cl,%edx
  802365:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802369:	09 d1                	or     %edx,%ecx
  80236b:	89 f2                	mov    %esi,%edx
  80236d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802371:	89 f9                	mov    %edi,%ecx
  802373:	d3 e3                	shl    %cl,%ebx
  802375:	89 c1                	mov    %eax,%ecx
  802377:	d3 ea                	shr    %cl,%edx
  802379:	89 f9                	mov    %edi,%ecx
  80237b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80237f:	89 eb                	mov    %ebp,%ebx
  802381:	d3 e6                	shl    %cl,%esi
  802383:	89 c1                	mov    %eax,%ecx
  802385:	d3 eb                	shr    %cl,%ebx
  802387:	09 de                	or     %ebx,%esi
  802389:	89 f0                	mov    %esi,%eax
  80238b:	f7 74 24 08          	divl   0x8(%esp)
  80238f:	89 d6                	mov    %edx,%esi
  802391:	89 c3                	mov    %eax,%ebx
  802393:	f7 64 24 0c          	mull   0xc(%esp)
  802397:	39 d6                	cmp    %edx,%esi
  802399:	72 15                	jb     8023b0 <__udivdi3+0x100>
  80239b:	89 f9                	mov    %edi,%ecx
  80239d:	d3 e5                	shl    %cl,%ebp
  80239f:	39 c5                	cmp    %eax,%ebp
  8023a1:	73 04                	jae    8023a7 <__udivdi3+0xf7>
  8023a3:	39 d6                	cmp    %edx,%esi
  8023a5:	74 09                	je     8023b0 <__udivdi3+0x100>
  8023a7:	89 d8                	mov    %ebx,%eax
  8023a9:	31 ff                	xor    %edi,%edi
  8023ab:	e9 40 ff ff ff       	jmp    8022f0 <__udivdi3+0x40>
  8023b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023b3:	31 ff                	xor    %edi,%edi
  8023b5:	e9 36 ff ff ff       	jmp    8022f0 <__udivdi3+0x40>
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__umoddi3>:
  8023c0:	f3 0f 1e fb          	endbr32 
  8023c4:	55                   	push   %ebp
  8023c5:	57                   	push   %edi
  8023c6:	56                   	push   %esi
  8023c7:	53                   	push   %ebx
  8023c8:	83 ec 1c             	sub    $0x1c,%esp
  8023cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	75 19                	jne    8023f8 <__umoddi3+0x38>
  8023df:	39 df                	cmp    %ebx,%edi
  8023e1:	76 5d                	jbe    802440 <__umoddi3+0x80>
  8023e3:	89 f0                	mov    %esi,%eax
  8023e5:	89 da                	mov    %ebx,%edx
  8023e7:	f7 f7                	div    %edi
  8023e9:	89 d0                	mov    %edx,%eax
  8023eb:	31 d2                	xor    %edx,%edx
  8023ed:	83 c4 1c             	add    $0x1c,%esp
  8023f0:	5b                   	pop    %ebx
  8023f1:	5e                   	pop    %esi
  8023f2:	5f                   	pop    %edi
  8023f3:	5d                   	pop    %ebp
  8023f4:	c3                   	ret    
  8023f5:	8d 76 00             	lea    0x0(%esi),%esi
  8023f8:	89 f2                	mov    %esi,%edx
  8023fa:	39 d8                	cmp    %ebx,%eax
  8023fc:	76 12                	jbe    802410 <__umoddi3+0x50>
  8023fe:	89 f0                	mov    %esi,%eax
  802400:	89 da                	mov    %ebx,%edx
  802402:	83 c4 1c             	add    $0x1c,%esp
  802405:	5b                   	pop    %ebx
  802406:	5e                   	pop    %esi
  802407:	5f                   	pop    %edi
  802408:	5d                   	pop    %ebp
  802409:	c3                   	ret    
  80240a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802410:	0f bd e8             	bsr    %eax,%ebp
  802413:	83 f5 1f             	xor    $0x1f,%ebp
  802416:	75 50                	jne    802468 <__umoddi3+0xa8>
  802418:	39 d8                	cmp    %ebx,%eax
  80241a:	0f 82 e0 00 00 00    	jb     802500 <__umoddi3+0x140>
  802420:	89 d9                	mov    %ebx,%ecx
  802422:	39 f7                	cmp    %esi,%edi
  802424:	0f 86 d6 00 00 00    	jbe    802500 <__umoddi3+0x140>
  80242a:	89 d0                	mov    %edx,%eax
  80242c:	89 ca                	mov    %ecx,%edx
  80242e:	83 c4 1c             	add    $0x1c,%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    
  802436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	89 fd                	mov    %edi,%ebp
  802442:	85 ff                	test   %edi,%edi
  802444:	75 0b                	jne    802451 <__umoddi3+0x91>
  802446:	b8 01 00 00 00       	mov    $0x1,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f7                	div    %edi
  80244f:	89 c5                	mov    %eax,%ebp
  802451:	89 d8                	mov    %ebx,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f5                	div    %ebp
  802457:	89 f0                	mov    %esi,%eax
  802459:	f7 f5                	div    %ebp
  80245b:	89 d0                	mov    %edx,%eax
  80245d:	31 d2                	xor    %edx,%edx
  80245f:	eb 8c                	jmp    8023ed <__umoddi3+0x2d>
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	ba 20 00 00 00       	mov    $0x20,%edx
  80246f:	29 ea                	sub    %ebp,%edx
  802471:	d3 e0                	shl    %cl,%eax
  802473:	89 44 24 08          	mov    %eax,0x8(%esp)
  802477:	89 d1                	mov    %edx,%ecx
  802479:	89 f8                	mov    %edi,%eax
  80247b:	d3 e8                	shr    %cl,%eax
  80247d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802481:	89 54 24 04          	mov    %edx,0x4(%esp)
  802485:	8b 54 24 04          	mov    0x4(%esp),%edx
  802489:	09 c1                	or     %eax,%ecx
  80248b:	89 d8                	mov    %ebx,%eax
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e7                	shl    %cl,%edi
  802495:	89 d1                	mov    %edx,%ecx
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80249f:	d3 e3                	shl    %cl,%ebx
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	89 d1                	mov    %edx,%ecx
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 fa                	mov    %edi,%edx
  8024ad:	d3 e6                	shl    %cl,%esi
  8024af:	09 d8                	or     %ebx,%eax
  8024b1:	f7 74 24 08          	divl   0x8(%esp)
  8024b5:	89 d1                	mov    %edx,%ecx
  8024b7:	89 f3                	mov    %esi,%ebx
  8024b9:	f7 64 24 0c          	mull   0xc(%esp)
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	89 d7                	mov    %edx,%edi
  8024c1:	39 d1                	cmp    %edx,%ecx
  8024c3:	72 06                	jb     8024cb <__umoddi3+0x10b>
  8024c5:	75 10                	jne    8024d7 <__umoddi3+0x117>
  8024c7:	39 c3                	cmp    %eax,%ebx
  8024c9:	73 0c                	jae    8024d7 <__umoddi3+0x117>
  8024cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024d3:	89 d7                	mov    %edx,%edi
  8024d5:	89 c6                	mov    %eax,%esi
  8024d7:	89 ca                	mov    %ecx,%edx
  8024d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024de:	29 f3                	sub    %esi,%ebx
  8024e0:	19 fa                	sbb    %edi,%edx
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	d3 e0                	shl    %cl,%eax
  8024e6:	89 e9                	mov    %ebp,%ecx
  8024e8:	d3 eb                	shr    %cl,%ebx
  8024ea:	d3 ea                	shr    %cl,%edx
  8024ec:	09 d8                	or     %ebx,%eax
  8024ee:	83 c4 1c             	add    $0x1c,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	29 fe                	sub    %edi,%esi
  802502:	19 c3                	sbb    %eax,%ebx
  802504:	89 f2                	mov    %esi,%edx
  802506:	89 d9                	mov    %ebx,%ecx
  802508:	e9 1d ff ff ff       	jmp    80242a <__umoddi3+0x6a>
