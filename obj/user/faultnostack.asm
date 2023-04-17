
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
  80003d:	68 a1 03 80 00       	push   $0x8003a1
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
  800079:	a3 04 40 80 00       	mov    %eax,0x804004

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
  8000ac:	e8 05 05 00 00       	call   8005b6 <close_all>
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
  800139:	68 aa 1f 80 00       	push   $0x801faa
  80013e:	6a 23                	push   $0x23
  800140:	68 c7 1f 80 00       	push   $0x801fc7
  800145:	e8 c2 0f 00 00       	call   80110c <_panic>

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
  8001c6:	68 aa 1f 80 00       	push   $0x801faa
  8001cb:	6a 23                	push   $0x23
  8001cd:	68 c7 1f 80 00       	push   $0x801fc7
  8001d2:	e8 35 0f 00 00       	call   80110c <_panic>

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
  80020c:	68 aa 1f 80 00       	push   $0x801faa
  800211:	6a 23                	push   $0x23
  800213:	68 c7 1f 80 00       	push   $0x801fc7
  800218:	e8 ef 0e 00 00       	call   80110c <_panic>

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
  800252:	68 aa 1f 80 00       	push   $0x801faa
  800257:	6a 23                	push   $0x23
  800259:	68 c7 1f 80 00       	push   $0x801fc7
  80025e:	e8 a9 0e 00 00       	call   80110c <_panic>

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
  800298:	68 aa 1f 80 00       	push   $0x801faa
  80029d:	6a 23                	push   $0x23
  80029f:	68 c7 1f 80 00       	push   $0x801fc7
  8002a4:	e8 63 0e 00 00       	call   80110c <_panic>

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
  8002de:	68 aa 1f 80 00       	push   $0x801faa
  8002e3:	6a 23                	push   $0x23
  8002e5:	68 c7 1f 80 00       	push   $0x801fc7
  8002ea:	e8 1d 0e 00 00       	call   80110c <_panic>

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
  800324:	68 aa 1f 80 00       	push   $0x801faa
  800329:	6a 23                	push   $0x23
  80032b:	68 c7 1f 80 00       	push   $0x801fc7
  800330:	e8 d7 0d 00 00       	call   80110c <_panic>

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
  800390:	68 aa 1f 80 00       	push   $0x801faa
  800395:	6a 23                	push   $0x23
  800397:	68 c7 1f 80 00       	push   $0x801fc7
  80039c:	e8 6b 0d 00 00       	call   80110c <_panic>

008003a1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8003a1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8003a2:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8003a7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8003a9:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8003ac:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8003b0:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8003b4:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8003b7:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8003b9:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8003bd:	83 c4 08             	add    $0x8,%esp
	popal
  8003c0:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8003c1:	83 c4 04             	add    $0x4,%esp
	popfl
  8003c4:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8003c5:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8003c6:	c3                   	ret    

008003c7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003c7:	f3 0f 1e fb          	endbr32 
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	05 00 00 00 30       	add    $0x30000000,%eax
  8003d6:	c1 e8 0c             	shr    $0xc,%eax
}
  8003d9:	5d                   	pop    %ebp
  8003da:	c3                   	ret    

008003db <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003db:	f3 0f 1e fb          	endbr32 
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ef:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003f4:	5d                   	pop    %ebp
  8003f5:	c3                   	ret    

008003f6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003f6:	f3 0f 1e fb          	endbr32 
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800402:	89 c2                	mov    %eax,%edx
  800404:	c1 ea 16             	shr    $0x16,%edx
  800407:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80040e:	f6 c2 01             	test   $0x1,%dl
  800411:	74 2d                	je     800440 <fd_alloc+0x4a>
  800413:	89 c2                	mov    %eax,%edx
  800415:	c1 ea 0c             	shr    $0xc,%edx
  800418:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80041f:	f6 c2 01             	test   $0x1,%dl
  800422:	74 1c                	je     800440 <fd_alloc+0x4a>
  800424:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800429:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80042e:	75 d2                	jne    800402 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800439:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80043e:	eb 0a                	jmp    80044a <fd_alloc+0x54>
			*fd_store = fd;
  800440:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800443:	89 01                	mov    %eax,(%ecx)
			return 0;
  800445:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80044a:	5d                   	pop    %ebp
  80044b:	c3                   	ret    

0080044c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80044c:	f3 0f 1e fb          	endbr32 
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800456:	83 f8 1f             	cmp    $0x1f,%eax
  800459:	77 30                	ja     80048b <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80045b:	c1 e0 0c             	shl    $0xc,%eax
  80045e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800463:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800469:	f6 c2 01             	test   $0x1,%dl
  80046c:	74 24                	je     800492 <fd_lookup+0x46>
  80046e:	89 c2                	mov    %eax,%edx
  800470:	c1 ea 0c             	shr    $0xc,%edx
  800473:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80047a:	f6 c2 01             	test   $0x1,%dl
  80047d:	74 1a                	je     800499 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80047f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800482:	89 02                	mov    %eax,(%edx)
	return 0;
  800484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800489:	5d                   	pop    %ebp
  80048a:	c3                   	ret    
		return -E_INVAL;
  80048b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800490:	eb f7                	jmp    800489 <fd_lookup+0x3d>
		return -E_INVAL;
  800492:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800497:	eb f0                	jmp    800489 <fd_lookup+0x3d>
  800499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80049e:	eb e9                	jmp    800489 <fd_lookup+0x3d>

008004a0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004a0:	f3 0f 1e fb          	endbr32 
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004ad:	ba 54 20 80 00       	mov    $0x802054,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004b2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004b7:	39 08                	cmp    %ecx,(%eax)
  8004b9:	74 33                	je     8004ee <dev_lookup+0x4e>
  8004bb:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004be:	8b 02                	mov    (%edx),%eax
  8004c0:	85 c0                	test   %eax,%eax
  8004c2:	75 f3                	jne    8004b7 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004c4:	a1 04 40 80 00       	mov    0x804004,%eax
  8004c9:	8b 40 48             	mov    0x48(%eax),%eax
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	51                   	push   %ecx
  8004d0:	50                   	push   %eax
  8004d1:	68 d8 1f 80 00       	push   $0x801fd8
  8004d6:	e8 18 0d 00 00       	call   8011f3 <cprintf>
	*dev = 0;
  8004db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004ec:	c9                   	leave  
  8004ed:	c3                   	ret    
			*dev = devtab[i];
  8004ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f8:	eb f2                	jmp    8004ec <dev_lookup+0x4c>

008004fa <fd_close>:
{
  8004fa:	f3 0f 1e fb          	endbr32 
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	57                   	push   %edi
  800502:	56                   	push   %esi
  800503:	53                   	push   %ebx
  800504:	83 ec 24             	sub    $0x24,%esp
  800507:	8b 75 08             	mov    0x8(%ebp),%esi
  80050a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80050d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800510:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800511:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800517:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80051a:	50                   	push   %eax
  80051b:	e8 2c ff ff ff       	call   80044c <fd_lookup>
  800520:	89 c3                	mov    %eax,%ebx
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	85 c0                	test   %eax,%eax
  800527:	78 05                	js     80052e <fd_close+0x34>
	    || fd != fd2)
  800529:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80052c:	74 16                	je     800544 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80052e:	89 f8                	mov    %edi,%eax
  800530:	84 c0                	test   %al,%al
  800532:	b8 00 00 00 00       	mov    $0x0,%eax
  800537:	0f 44 d8             	cmove  %eax,%ebx
}
  80053a:	89 d8                	mov    %ebx,%eax
  80053c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80053f:	5b                   	pop    %ebx
  800540:	5e                   	pop    %esi
  800541:	5f                   	pop    %edi
  800542:	5d                   	pop    %ebp
  800543:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80054a:	50                   	push   %eax
  80054b:	ff 36                	pushl  (%esi)
  80054d:	e8 4e ff ff ff       	call   8004a0 <dev_lookup>
  800552:	89 c3                	mov    %eax,%ebx
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	85 c0                	test   %eax,%eax
  800559:	78 1a                	js     800575 <fd_close+0x7b>
		if (dev->dev_close)
  80055b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800561:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800566:	85 c0                	test   %eax,%eax
  800568:	74 0b                	je     800575 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80056a:	83 ec 0c             	sub    $0xc,%esp
  80056d:	56                   	push   %esi
  80056e:	ff d0                	call   *%eax
  800570:	89 c3                	mov    %eax,%ebx
  800572:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	56                   	push   %esi
  800579:	6a 00                	push   $0x0
  80057b:	e8 9d fc ff ff       	call   80021d <sys_page_unmap>
	return r;
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	eb b5                	jmp    80053a <fd_close+0x40>

00800585 <close>:

int
close(int fdnum)
{
  800585:	f3 0f 1e fb          	endbr32 
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80058f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800592:	50                   	push   %eax
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 b1 fe ff ff       	call   80044c <fd_lookup>
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	85 c0                	test   %eax,%eax
  8005a0:	79 02                	jns    8005a4 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    
		return fd_close(fd, 1);
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	6a 01                	push   $0x1
  8005a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ac:	e8 49 ff ff ff       	call   8004fa <fd_close>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	eb ec                	jmp    8005a2 <close+0x1d>

008005b6 <close_all>:

void
close_all(void)
{
  8005b6:	f3 0f 1e fb          	endbr32 
  8005ba:	55                   	push   %ebp
  8005bb:	89 e5                	mov    %esp,%ebp
  8005bd:	53                   	push   %ebx
  8005be:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005c6:	83 ec 0c             	sub    $0xc,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	e8 b6 ff ff ff       	call   800585 <close>
	for (i = 0; i < MAXFD; i++)
  8005cf:	83 c3 01             	add    $0x1,%ebx
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	83 fb 20             	cmp    $0x20,%ebx
  8005d8:	75 ec                	jne    8005c6 <close_all+0x10>
}
  8005da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005df:	f3 0f 1e fb          	endbr32 
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	57                   	push   %edi
  8005e7:	56                   	push   %esi
  8005e8:	53                   	push   %ebx
  8005e9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005ec:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005ef:	50                   	push   %eax
  8005f0:	ff 75 08             	pushl  0x8(%ebp)
  8005f3:	e8 54 fe ff ff       	call   80044c <fd_lookup>
  8005f8:	89 c3                	mov    %eax,%ebx
  8005fa:	83 c4 10             	add    $0x10,%esp
  8005fd:	85 c0                	test   %eax,%eax
  8005ff:	0f 88 81 00 00 00    	js     800686 <dup+0xa7>
		return r;
	close(newfdnum);
  800605:	83 ec 0c             	sub    $0xc,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	e8 75 ff ff ff       	call   800585 <close>

	newfd = INDEX2FD(newfdnum);
  800610:	8b 75 0c             	mov    0xc(%ebp),%esi
  800613:	c1 e6 0c             	shl    $0xc,%esi
  800616:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80061c:	83 c4 04             	add    $0x4,%esp
  80061f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800622:	e8 b4 fd ff ff       	call   8003db <fd2data>
  800627:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800629:	89 34 24             	mov    %esi,(%esp)
  80062c:	e8 aa fd ff ff       	call   8003db <fd2data>
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800636:	89 d8                	mov    %ebx,%eax
  800638:	c1 e8 16             	shr    $0x16,%eax
  80063b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800642:	a8 01                	test   $0x1,%al
  800644:	74 11                	je     800657 <dup+0x78>
  800646:	89 d8                	mov    %ebx,%eax
  800648:	c1 e8 0c             	shr    $0xc,%eax
  80064b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800652:	f6 c2 01             	test   $0x1,%dl
  800655:	75 39                	jne    800690 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800657:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80065a:	89 d0                	mov    %edx,%eax
  80065c:	c1 e8 0c             	shr    $0xc,%eax
  80065f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	25 07 0e 00 00       	and    $0xe07,%eax
  80066e:	50                   	push   %eax
  80066f:	56                   	push   %esi
  800670:	6a 00                	push   $0x0
  800672:	52                   	push   %edx
  800673:	6a 00                	push   $0x0
  800675:	e8 5d fb ff ff       	call   8001d7 <sys_page_map>
  80067a:	89 c3                	mov    %eax,%ebx
  80067c:	83 c4 20             	add    $0x20,%esp
  80067f:	85 c0                	test   %eax,%eax
  800681:	78 31                	js     8006b4 <dup+0xd5>
		goto err;

	return newfdnum;
  800683:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800686:	89 d8                	mov    %ebx,%eax
  800688:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80068b:	5b                   	pop    %ebx
  80068c:	5e                   	pop    %esi
  80068d:	5f                   	pop    %edi
  80068e:	5d                   	pop    %ebp
  80068f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800690:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800697:	83 ec 0c             	sub    $0xc,%esp
  80069a:	25 07 0e 00 00       	and    $0xe07,%eax
  80069f:	50                   	push   %eax
  8006a0:	57                   	push   %edi
  8006a1:	6a 00                	push   $0x0
  8006a3:	53                   	push   %ebx
  8006a4:	6a 00                	push   $0x0
  8006a6:	e8 2c fb ff ff       	call   8001d7 <sys_page_map>
  8006ab:	89 c3                	mov    %eax,%ebx
  8006ad:	83 c4 20             	add    $0x20,%esp
  8006b0:	85 c0                	test   %eax,%eax
  8006b2:	79 a3                	jns    800657 <dup+0x78>
	sys_page_unmap(0, newfd);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	56                   	push   %esi
  8006b8:	6a 00                	push   $0x0
  8006ba:	e8 5e fb ff ff       	call   80021d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006bf:	83 c4 08             	add    $0x8,%esp
  8006c2:	57                   	push   %edi
  8006c3:	6a 00                	push   $0x0
  8006c5:	e8 53 fb ff ff       	call   80021d <sys_page_unmap>
	return r;
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	eb b7                	jmp    800686 <dup+0xa7>

008006cf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006cf:	f3 0f 1e fb          	endbr32 
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	53                   	push   %ebx
  8006d7:	83 ec 1c             	sub    $0x1c,%esp
  8006da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006e0:	50                   	push   %eax
  8006e1:	53                   	push   %ebx
  8006e2:	e8 65 fd ff ff       	call   80044c <fd_lookup>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	78 3f                	js     80072d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006f4:	50                   	push   %eax
  8006f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f8:	ff 30                	pushl  (%eax)
  8006fa:	e8 a1 fd ff ff       	call   8004a0 <dev_lookup>
  8006ff:	83 c4 10             	add    $0x10,%esp
  800702:	85 c0                	test   %eax,%eax
  800704:	78 27                	js     80072d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800706:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800709:	8b 42 08             	mov    0x8(%edx),%eax
  80070c:	83 e0 03             	and    $0x3,%eax
  80070f:	83 f8 01             	cmp    $0x1,%eax
  800712:	74 1e                	je     800732 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800717:	8b 40 08             	mov    0x8(%eax),%eax
  80071a:	85 c0                	test   %eax,%eax
  80071c:	74 35                	je     800753 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80071e:	83 ec 04             	sub    $0x4,%esp
  800721:	ff 75 10             	pushl  0x10(%ebp)
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	52                   	push   %edx
  800728:	ff d0                	call   *%eax
  80072a:	83 c4 10             	add    $0x10,%esp
}
  80072d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800730:	c9                   	leave  
  800731:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800732:	a1 04 40 80 00       	mov    0x804004,%eax
  800737:	8b 40 48             	mov    0x48(%eax),%eax
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	53                   	push   %ebx
  80073e:	50                   	push   %eax
  80073f:	68 19 20 80 00       	push   $0x802019
  800744:	e8 aa 0a 00 00       	call   8011f3 <cprintf>
		return -E_INVAL;
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800751:	eb da                	jmp    80072d <read+0x5e>
		return -E_NOT_SUPP;
  800753:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800758:	eb d3                	jmp    80072d <read+0x5e>

0080075a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80075a:	f3 0f 1e fb          	endbr32 
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
  800761:	57                   	push   %edi
  800762:	56                   	push   %esi
  800763:	53                   	push   %ebx
  800764:	83 ec 0c             	sub    $0xc,%esp
  800767:	8b 7d 08             	mov    0x8(%ebp),%edi
  80076a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80076d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800772:	eb 02                	jmp    800776 <readn+0x1c>
  800774:	01 c3                	add    %eax,%ebx
  800776:	39 f3                	cmp    %esi,%ebx
  800778:	73 21                	jae    80079b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80077a:	83 ec 04             	sub    $0x4,%esp
  80077d:	89 f0                	mov    %esi,%eax
  80077f:	29 d8                	sub    %ebx,%eax
  800781:	50                   	push   %eax
  800782:	89 d8                	mov    %ebx,%eax
  800784:	03 45 0c             	add    0xc(%ebp),%eax
  800787:	50                   	push   %eax
  800788:	57                   	push   %edi
  800789:	e8 41 ff ff ff       	call   8006cf <read>
		if (m < 0)
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	85 c0                	test   %eax,%eax
  800793:	78 04                	js     800799 <readn+0x3f>
			return m;
		if (m == 0)
  800795:	75 dd                	jne    800774 <readn+0x1a>
  800797:	eb 02                	jmp    80079b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800799:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80079b:	89 d8                	mov    %ebx,%eax
  80079d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a0:	5b                   	pop    %ebx
  8007a1:	5e                   	pop    %esi
  8007a2:	5f                   	pop    %edi
  8007a3:	5d                   	pop    %ebp
  8007a4:	c3                   	ret    

008007a5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007a5:	f3 0f 1e fb          	endbr32 
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	53                   	push   %ebx
  8007ad:	83 ec 1c             	sub    $0x1c,%esp
  8007b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b6:	50                   	push   %eax
  8007b7:	53                   	push   %ebx
  8007b8:	e8 8f fc ff ff       	call   80044c <fd_lookup>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	85 c0                	test   %eax,%eax
  8007c2:	78 3a                	js     8007fe <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ca:	50                   	push   %eax
  8007cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ce:	ff 30                	pushl  (%eax)
  8007d0:	e8 cb fc ff ff       	call   8004a0 <dev_lookup>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	85 c0                	test   %eax,%eax
  8007da:	78 22                	js     8007fe <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007df:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007e3:	74 1e                	je     800803 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e8:	8b 52 0c             	mov    0xc(%edx),%edx
  8007eb:	85 d2                	test   %edx,%edx
  8007ed:	74 35                	je     800824 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007ef:	83 ec 04             	sub    $0x4,%esp
  8007f2:	ff 75 10             	pushl  0x10(%ebp)
  8007f5:	ff 75 0c             	pushl  0xc(%ebp)
  8007f8:	50                   	push   %eax
  8007f9:	ff d2                	call   *%edx
  8007fb:	83 c4 10             	add    $0x10,%esp
}
  8007fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800801:	c9                   	leave  
  800802:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800803:	a1 04 40 80 00       	mov    0x804004,%eax
  800808:	8b 40 48             	mov    0x48(%eax),%eax
  80080b:	83 ec 04             	sub    $0x4,%esp
  80080e:	53                   	push   %ebx
  80080f:	50                   	push   %eax
  800810:	68 35 20 80 00       	push   $0x802035
  800815:	e8 d9 09 00 00       	call   8011f3 <cprintf>
		return -E_INVAL;
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800822:	eb da                	jmp    8007fe <write+0x59>
		return -E_NOT_SUPP;
  800824:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800829:	eb d3                	jmp    8007fe <write+0x59>

0080082b <seek>:

int
seek(int fdnum, off_t offset)
{
  80082b:	f3 0f 1e fb          	endbr32 
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800835:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800838:	50                   	push   %eax
  800839:	ff 75 08             	pushl  0x8(%ebp)
  80083c:	e8 0b fc ff ff       	call   80044c <fd_lookup>
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	85 c0                	test   %eax,%eax
  800846:	78 0e                	js     800856 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800851:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800856:	c9                   	leave  
  800857:	c3                   	ret    

00800858 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800858:	f3 0f 1e fb          	endbr32 
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	53                   	push   %ebx
  800860:	83 ec 1c             	sub    $0x1c,%esp
  800863:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800866:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800869:	50                   	push   %eax
  80086a:	53                   	push   %ebx
  80086b:	e8 dc fb ff ff       	call   80044c <fd_lookup>
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	85 c0                	test   %eax,%eax
  800875:	78 37                	js     8008ae <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80087d:	50                   	push   %eax
  80087e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800881:	ff 30                	pushl  (%eax)
  800883:	e8 18 fc ff ff       	call   8004a0 <dev_lookup>
  800888:	83 c4 10             	add    $0x10,%esp
  80088b:	85 c0                	test   %eax,%eax
  80088d:	78 1f                	js     8008ae <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80088f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800892:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800896:	74 1b                	je     8008b3 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089b:	8b 52 18             	mov    0x18(%edx),%edx
  80089e:	85 d2                	test   %edx,%edx
  8008a0:	74 32                	je     8008d4 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	50                   	push   %eax
  8008a9:	ff d2                	call   *%edx
  8008ab:	83 c4 10             	add    $0x10,%esp
}
  8008ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008b3:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008b8:	8b 40 48             	mov    0x48(%eax),%eax
  8008bb:	83 ec 04             	sub    $0x4,%esp
  8008be:	53                   	push   %ebx
  8008bf:	50                   	push   %eax
  8008c0:	68 f8 1f 80 00       	push   $0x801ff8
  8008c5:	e8 29 09 00 00       	call   8011f3 <cprintf>
		return -E_INVAL;
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d2:	eb da                	jmp    8008ae <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008d9:	eb d3                	jmp    8008ae <ftruncate+0x56>

008008db <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008db:	f3 0f 1e fb          	endbr32 
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	53                   	push   %ebx
  8008e3:	83 ec 1c             	sub    $0x1c,%esp
  8008e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008ec:	50                   	push   %eax
  8008ed:	ff 75 08             	pushl  0x8(%ebp)
  8008f0:	e8 57 fb ff ff       	call   80044c <fd_lookup>
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	85 c0                	test   %eax,%eax
  8008fa:	78 4b                	js     800947 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800902:	50                   	push   %eax
  800903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800906:	ff 30                	pushl  (%eax)
  800908:	e8 93 fb ff ff       	call   8004a0 <dev_lookup>
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	85 c0                	test   %eax,%eax
  800912:	78 33                	js     800947 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800917:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80091b:	74 2f                	je     80094c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80091d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800920:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800927:	00 00 00 
	stat->st_isdir = 0;
  80092a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800931:	00 00 00 
	stat->st_dev = dev;
  800934:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	53                   	push   %ebx
  80093e:	ff 75 f0             	pushl  -0x10(%ebp)
  800941:	ff 50 14             	call   *0x14(%eax)
  800944:	83 c4 10             	add    $0x10,%esp
}
  800947:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094a:	c9                   	leave  
  80094b:	c3                   	ret    
		return -E_NOT_SUPP;
  80094c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800951:	eb f4                	jmp    800947 <fstat+0x6c>

00800953 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800953:	f3 0f 1e fb          	endbr32 
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	6a 00                	push   $0x0
  800961:	ff 75 08             	pushl  0x8(%ebp)
  800964:	e8 fb 01 00 00       	call   800b64 <open>
  800969:	89 c3                	mov    %eax,%ebx
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	85 c0                	test   %eax,%eax
  800970:	78 1b                	js     80098d <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	50                   	push   %eax
  800979:	e8 5d ff ff ff       	call   8008db <fstat>
  80097e:	89 c6                	mov    %eax,%esi
	close(fd);
  800980:	89 1c 24             	mov    %ebx,(%esp)
  800983:	e8 fd fb ff ff       	call   800585 <close>
	return r;
  800988:	83 c4 10             	add    $0x10,%esp
  80098b:	89 f3                	mov    %esi,%ebx
}
  80098d:	89 d8                	mov    %ebx,%eax
  80098f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800992:	5b                   	pop    %ebx
  800993:	5e                   	pop    %esi
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	89 c6                	mov    %eax,%esi
  80099d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80099f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009a6:	74 27                	je     8009cf <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009a8:	6a 07                	push   $0x7
  8009aa:	68 00 50 80 00       	push   $0x805000
  8009af:	56                   	push   %esi
  8009b0:	ff 35 00 40 80 00    	pushl  0x804000
  8009b6:	e8 ac 12 00 00       	call   801c67 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009bb:	83 c4 0c             	add    $0xc,%esp
  8009be:	6a 00                	push   $0x0
  8009c0:	53                   	push   %ebx
  8009c1:	6a 00                	push   $0x0
  8009c3:	e8 1a 12 00 00       	call   801be2 <ipc_recv>
}
  8009c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009cb:	5b                   	pop    %ebx
  8009cc:	5e                   	pop    %esi
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009cf:	83 ec 0c             	sub    $0xc,%esp
  8009d2:	6a 01                	push   $0x1
  8009d4:	e8 e6 12 00 00       	call   801cbf <ipc_find_env>
  8009d9:	a3 00 40 80 00       	mov    %eax,0x804000
  8009de:	83 c4 10             	add    $0x10,%esp
  8009e1:	eb c5                	jmp    8009a8 <fsipc+0x12>

008009e3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009e3:	f3 0f 1e fb          	endbr32 
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8009f3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a00:	ba 00 00 00 00       	mov    $0x0,%edx
  800a05:	b8 02 00 00 00       	mov    $0x2,%eax
  800a0a:	e8 87 ff ff ff       	call   800996 <fsipc>
}
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    

00800a11 <devfile_flush>:
{
  800a11:	f3 0f 1e fb          	endbr32 
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	8b 40 0c             	mov    0xc(%eax),%eax
  800a21:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a26:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2b:	b8 06 00 00 00       	mov    $0x6,%eax
  800a30:	e8 61 ff ff ff       	call   800996 <fsipc>
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <devfile_stat>:
{
  800a37:	f3 0f 1e fb          	endbr32 
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	53                   	push   %ebx
  800a3f:	83 ec 04             	sub    $0x4,%esp
  800a42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	8b 40 0c             	mov    0xc(%eax),%eax
  800a4b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a50:	ba 00 00 00 00       	mov    $0x0,%edx
  800a55:	b8 05 00 00 00       	mov    $0x5,%eax
  800a5a:	e8 37 ff ff ff       	call   800996 <fsipc>
  800a5f:	85 c0                	test   %eax,%eax
  800a61:	78 2c                	js     800a8f <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	68 00 50 80 00       	push   $0x805000
  800a6b:	53                   	push   %ebx
  800a6c:	e8 8c 0d 00 00       	call   8017fd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a71:	a1 80 50 80 00       	mov    0x805080,%eax
  800a76:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a7c:	a1 84 50 80 00       	mov    0x805084,%eax
  800a81:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a92:	c9                   	leave  
  800a93:	c3                   	ret    

00800a94 <devfile_write>:
{
  800a94:	f3 0f 1e fb          	endbr32 
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	83 ec 0c             	sub    $0xc,%esp
  800a9e:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa4:	8b 52 0c             	mov    0xc(%edx),%edx
  800aa7:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800aad:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800ab2:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800ab7:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800aba:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800abf:	50                   	push   %eax
  800ac0:	ff 75 0c             	pushl  0xc(%ebp)
  800ac3:	68 08 50 80 00       	push   $0x805008
  800ac8:	e8 e6 0e 00 00       	call   8019b3 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800acd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ad7:	e8 ba fe ff ff       	call   800996 <fsipc>
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    

00800ade <devfile_read>:
{
  800ade:	f3 0f 1e fb          	endbr32 
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	56                   	push   %esi
  800ae6:	53                   	push   %ebx
  800ae7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8b 40 0c             	mov    0xc(%eax),%eax
  800af0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800af5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800afb:	ba 00 00 00 00       	mov    $0x0,%edx
  800b00:	b8 03 00 00 00       	mov    $0x3,%eax
  800b05:	e8 8c fe ff ff       	call   800996 <fsipc>
  800b0a:	89 c3                	mov    %eax,%ebx
  800b0c:	85 c0                	test   %eax,%eax
  800b0e:	78 1f                	js     800b2f <devfile_read+0x51>
	assert(r <= n);
  800b10:	39 f0                	cmp    %esi,%eax
  800b12:	77 24                	ja     800b38 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b14:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b19:	7f 33                	jg     800b4e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b1b:	83 ec 04             	sub    $0x4,%esp
  800b1e:	50                   	push   %eax
  800b1f:	68 00 50 80 00       	push   $0x805000
  800b24:	ff 75 0c             	pushl  0xc(%ebp)
  800b27:	e8 87 0e 00 00       	call   8019b3 <memmove>
	return r;
  800b2c:	83 c4 10             	add    $0x10,%esp
}
  800b2f:	89 d8                	mov    %ebx,%eax
  800b31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    
	assert(r <= n);
  800b38:	68 64 20 80 00       	push   $0x802064
  800b3d:	68 6b 20 80 00       	push   $0x80206b
  800b42:	6a 7c                	push   $0x7c
  800b44:	68 80 20 80 00       	push   $0x802080
  800b49:	e8 be 05 00 00       	call   80110c <_panic>
	assert(r <= PGSIZE);
  800b4e:	68 8b 20 80 00       	push   $0x80208b
  800b53:	68 6b 20 80 00       	push   $0x80206b
  800b58:	6a 7d                	push   $0x7d
  800b5a:	68 80 20 80 00       	push   $0x802080
  800b5f:	e8 a8 05 00 00       	call   80110c <_panic>

00800b64 <open>:
{
  800b64:	f3 0f 1e fb          	endbr32 
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	83 ec 1c             	sub    $0x1c,%esp
  800b70:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b73:	56                   	push   %esi
  800b74:	e8 41 0c 00 00       	call   8017ba <strlen>
  800b79:	83 c4 10             	add    $0x10,%esp
  800b7c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b81:	7f 6c                	jg     800bef <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b83:	83 ec 0c             	sub    $0xc,%esp
  800b86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b89:	50                   	push   %eax
  800b8a:	e8 67 f8 ff ff       	call   8003f6 <fd_alloc>
  800b8f:	89 c3                	mov    %eax,%ebx
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	85 c0                	test   %eax,%eax
  800b96:	78 3c                	js     800bd4 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	56                   	push   %esi
  800b9c:	68 00 50 80 00       	push   $0x805000
  800ba1:	e8 57 0c 00 00       	call   8017fd <strcpy>
	fsipcbuf.open.req_omode = mode;
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb6:	e8 db fd ff ff       	call   800996 <fsipc>
  800bbb:	89 c3                	mov    %eax,%ebx
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	85 c0                	test   %eax,%eax
  800bc2:	78 19                	js     800bdd <open+0x79>
	return fd2num(fd);
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bca:	e8 f8 f7 ff ff       	call   8003c7 <fd2num>
  800bcf:	89 c3                	mov    %eax,%ebx
  800bd1:	83 c4 10             	add    $0x10,%esp
}
  800bd4:	89 d8                	mov    %ebx,%eax
  800bd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd9:	5b                   	pop    %ebx
  800bda:	5e                   	pop    %esi
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    
		fd_close(fd, 0);
  800bdd:	83 ec 08             	sub    $0x8,%esp
  800be0:	6a 00                	push   $0x0
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	e8 10 f9 ff ff       	call   8004fa <fd_close>
		return r;
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	eb e5                	jmp    800bd4 <open+0x70>
		return -E_BAD_PATH;
  800bef:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bf4:	eb de                	jmp    800bd4 <open+0x70>

00800bf6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bf6:	f3 0f 1e fb          	endbr32 
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c00:	ba 00 00 00 00       	mov    $0x0,%edx
  800c05:	b8 08 00 00 00       	mov    $0x8,%eax
  800c0a:	e8 87 fd ff ff       	call   800996 <fsipc>
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c11:	f3 0f 1e fb          	endbr32 
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
  800c1a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c1d:	83 ec 0c             	sub    $0xc,%esp
  800c20:	ff 75 08             	pushl  0x8(%ebp)
  800c23:	e8 b3 f7 ff ff       	call   8003db <fd2data>
  800c28:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c2a:	83 c4 08             	add    $0x8,%esp
  800c2d:	68 97 20 80 00       	push   $0x802097
  800c32:	53                   	push   %ebx
  800c33:	e8 c5 0b 00 00       	call   8017fd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c38:	8b 46 04             	mov    0x4(%esi),%eax
  800c3b:	2b 06                	sub    (%esi),%eax
  800c3d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c43:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c4a:	00 00 00 
	stat->st_dev = &devpipe;
  800c4d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c54:	30 80 00 
	return 0;
}
  800c57:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c63:	f3 0f 1e fb          	endbr32 
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	53                   	push   %ebx
  800c6b:	83 ec 0c             	sub    $0xc,%esp
  800c6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c71:	53                   	push   %ebx
  800c72:	6a 00                	push   $0x0
  800c74:	e8 a4 f5 ff ff       	call   80021d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c79:	89 1c 24             	mov    %ebx,(%esp)
  800c7c:	e8 5a f7 ff ff       	call   8003db <fd2data>
  800c81:	83 c4 08             	add    $0x8,%esp
  800c84:	50                   	push   %eax
  800c85:	6a 00                	push   $0x0
  800c87:	e8 91 f5 ff ff       	call   80021d <sys_page_unmap>
}
  800c8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <_pipeisclosed>:
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
  800c97:	83 ec 1c             	sub    $0x1c,%esp
  800c9a:	89 c7                	mov    %eax,%edi
  800c9c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c9e:	a1 04 40 80 00       	mov    0x804004,%eax
  800ca3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	57                   	push   %edi
  800caa:	e8 4d 10 00 00       	call   801cfc <pageref>
  800caf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cb2:	89 34 24             	mov    %esi,(%esp)
  800cb5:	e8 42 10 00 00       	call   801cfc <pageref>
		nn = thisenv->env_runs;
  800cba:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800cc0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800cc3:	83 c4 10             	add    $0x10,%esp
  800cc6:	39 cb                	cmp    %ecx,%ebx
  800cc8:	74 1b                	je     800ce5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800cca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ccd:	75 cf                	jne    800c9e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800ccf:	8b 42 58             	mov    0x58(%edx),%eax
  800cd2:	6a 01                	push   $0x1
  800cd4:	50                   	push   %eax
  800cd5:	53                   	push   %ebx
  800cd6:	68 9e 20 80 00       	push   $0x80209e
  800cdb:	e8 13 05 00 00       	call   8011f3 <cprintf>
  800ce0:	83 c4 10             	add    $0x10,%esp
  800ce3:	eb b9                	jmp    800c9e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800ce5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ce8:	0f 94 c0             	sete   %al
  800ceb:	0f b6 c0             	movzbl %al,%eax
}
  800cee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <devpipe_write>:
{
  800cf6:	f3 0f 1e fb          	endbr32 
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
  800d00:	83 ec 28             	sub    $0x28,%esp
  800d03:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d06:	56                   	push   %esi
  800d07:	e8 cf f6 ff ff       	call   8003db <fd2data>
  800d0c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d0e:	83 c4 10             	add    $0x10,%esp
  800d11:	bf 00 00 00 00       	mov    $0x0,%edi
  800d16:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d19:	74 4f                	je     800d6a <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d1b:	8b 43 04             	mov    0x4(%ebx),%eax
  800d1e:	8b 0b                	mov    (%ebx),%ecx
  800d20:	8d 51 20             	lea    0x20(%ecx),%edx
  800d23:	39 d0                	cmp    %edx,%eax
  800d25:	72 14                	jb     800d3b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800d27:	89 da                	mov    %ebx,%edx
  800d29:	89 f0                	mov    %esi,%eax
  800d2b:	e8 61 ff ff ff       	call   800c91 <_pipeisclosed>
  800d30:	85 c0                	test   %eax,%eax
  800d32:	75 3b                	jne    800d6f <devpipe_write+0x79>
			sys_yield();
  800d34:	e8 34 f4 ff ff       	call   80016d <sys_yield>
  800d39:	eb e0                	jmp    800d1b <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d42:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d45:	89 c2                	mov    %eax,%edx
  800d47:	c1 fa 1f             	sar    $0x1f,%edx
  800d4a:	89 d1                	mov    %edx,%ecx
  800d4c:	c1 e9 1b             	shr    $0x1b,%ecx
  800d4f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d52:	83 e2 1f             	and    $0x1f,%edx
  800d55:	29 ca                	sub    %ecx,%edx
  800d57:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d5b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d5f:	83 c0 01             	add    $0x1,%eax
  800d62:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d65:	83 c7 01             	add    $0x1,%edi
  800d68:	eb ac                	jmp    800d16 <devpipe_write+0x20>
	return i;
  800d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6d:	eb 05                	jmp    800d74 <devpipe_write+0x7e>
				return 0;
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <devpipe_read>:
{
  800d7c:	f3 0f 1e fb          	endbr32 
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 18             	sub    $0x18,%esp
  800d89:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d8c:	57                   	push   %edi
  800d8d:	e8 49 f6 ff ff       	call   8003db <fd2data>
  800d92:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d94:	83 c4 10             	add    $0x10,%esp
  800d97:	be 00 00 00 00       	mov    $0x0,%esi
  800d9c:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d9f:	75 14                	jne    800db5 <devpipe_read+0x39>
	return i;
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	eb 02                	jmp    800da8 <devpipe_read+0x2c>
				return i;
  800da6:	89 f0                	mov    %esi,%eax
}
  800da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    
			sys_yield();
  800db0:	e8 b8 f3 ff ff       	call   80016d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800db5:	8b 03                	mov    (%ebx),%eax
  800db7:	3b 43 04             	cmp    0x4(%ebx),%eax
  800dba:	75 18                	jne    800dd4 <devpipe_read+0x58>
			if (i > 0)
  800dbc:	85 f6                	test   %esi,%esi
  800dbe:	75 e6                	jne    800da6 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800dc0:	89 da                	mov    %ebx,%edx
  800dc2:	89 f8                	mov    %edi,%eax
  800dc4:	e8 c8 fe ff ff       	call   800c91 <_pipeisclosed>
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	74 e3                	je     800db0 <devpipe_read+0x34>
				return 0;
  800dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd2:	eb d4                	jmp    800da8 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dd4:	99                   	cltd   
  800dd5:	c1 ea 1b             	shr    $0x1b,%edx
  800dd8:	01 d0                	add    %edx,%eax
  800dda:	83 e0 1f             	and    $0x1f,%eax
  800ddd:	29 d0                	sub    %edx,%eax
  800ddf:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800dea:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800ded:	83 c6 01             	add    $0x1,%esi
  800df0:	eb aa                	jmp    800d9c <devpipe_read+0x20>

00800df2 <pipe>:
{
  800df2:	f3 0f 1e fb          	endbr32 
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e01:	50                   	push   %eax
  800e02:	e8 ef f5 ff ff       	call   8003f6 <fd_alloc>
  800e07:	89 c3                	mov    %eax,%ebx
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	0f 88 23 01 00 00    	js     800f37 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e14:	83 ec 04             	sub    $0x4,%esp
  800e17:	68 07 04 00 00       	push   $0x407
  800e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1f:	6a 00                	push   $0x0
  800e21:	e8 6a f3 ff ff       	call   800190 <sys_page_alloc>
  800e26:	89 c3                	mov    %eax,%ebx
  800e28:	83 c4 10             	add    $0x10,%esp
  800e2b:	85 c0                	test   %eax,%eax
  800e2d:	0f 88 04 01 00 00    	js     800f37 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e39:	50                   	push   %eax
  800e3a:	e8 b7 f5 ff ff       	call   8003f6 <fd_alloc>
  800e3f:	89 c3                	mov    %eax,%ebx
  800e41:	83 c4 10             	add    $0x10,%esp
  800e44:	85 c0                	test   %eax,%eax
  800e46:	0f 88 db 00 00 00    	js     800f27 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e4c:	83 ec 04             	sub    $0x4,%esp
  800e4f:	68 07 04 00 00       	push   $0x407
  800e54:	ff 75 f0             	pushl  -0x10(%ebp)
  800e57:	6a 00                	push   $0x0
  800e59:	e8 32 f3 ff ff       	call   800190 <sys_page_alloc>
  800e5e:	89 c3                	mov    %eax,%ebx
  800e60:	83 c4 10             	add    $0x10,%esp
  800e63:	85 c0                	test   %eax,%eax
  800e65:	0f 88 bc 00 00 00    	js     800f27 <pipe+0x135>
	va = fd2data(fd0);
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e71:	e8 65 f5 ff ff       	call   8003db <fd2data>
  800e76:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e78:	83 c4 0c             	add    $0xc,%esp
  800e7b:	68 07 04 00 00       	push   $0x407
  800e80:	50                   	push   %eax
  800e81:	6a 00                	push   $0x0
  800e83:	e8 08 f3 ff ff       	call   800190 <sys_page_alloc>
  800e88:	89 c3                	mov    %eax,%ebx
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	85 c0                	test   %eax,%eax
  800e8f:	0f 88 82 00 00 00    	js     800f17 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e95:	83 ec 0c             	sub    $0xc,%esp
  800e98:	ff 75 f0             	pushl  -0x10(%ebp)
  800e9b:	e8 3b f5 ff ff       	call   8003db <fd2data>
  800ea0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800ea7:	50                   	push   %eax
  800ea8:	6a 00                	push   $0x0
  800eaa:	56                   	push   %esi
  800eab:	6a 00                	push   $0x0
  800ead:	e8 25 f3 ff ff       	call   8001d7 <sys_page_map>
  800eb2:	89 c3                	mov    %eax,%ebx
  800eb4:	83 c4 20             	add    $0x20,%esp
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	78 4e                	js     800f09 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800ebb:	a1 20 30 80 00       	mov    0x803020,%eax
  800ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800ecf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ed2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800ede:	83 ec 0c             	sub    $0xc,%esp
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	e8 de f4 ff ff       	call   8003c7 <fd2num>
  800ee9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800eee:	83 c4 04             	add    $0x4,%esp
  800ef1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ef4:	e8 ce f4 ff ff       	call   8003c7 <fd2num>
  800ef9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f07:	eb 2e                	jmp    800f37 <pipe+0x145>
	sys_page_unmap(0, va);
  800f09:	83 ec 08             	sub    $0x8,%esp
  800f0c:	56                   	push   %esi
  800f0d:	6a 00                	push   $0x0
  800f0f:	e8 09 f3 ff ff       	call   80021d <sys_page_unmap>
  800f14:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f17:	83 ec 08             	sub    $0x8,%esp
  800f1a:	ff 75 f0             	pushl  -0x10(%ebp)
  800f1d:	6a 00                	push   $0x0
  800f1f:	e8 f9 f2 ff ff       	call   80021d <sys_page_unmap>
  800f24:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f27:	83 ec 08             	sub    $0x8,%esp
  800f2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2d:	6a 00                	push   $0x0
  800f2f:	e8 e9 f2 ff ff       	call   80021d <sys_page_unmap>
  800f34:	83 c4 10             	add    $0x10,%esp
}
  800f37:	89 d8                	mov    %ebx,%eax
  800f39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <pipeisclosed>:
{
  800f40:	f3 0f 1e fb          	endbr32 
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 08             	pushl  0x8(%ebp)
  800f51:	e8 f6 f4 ff ff       	call   80044c <fd_lookup>
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	78 18                	js     800f75 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f5d:	83 ec 0c             	sub    $0xc,%esp
  800f60:	ff 75 f4             	pushl  -0xc(%ebp)
  800f63:	e8 73 f4 ff ff       	call   8003db <fd2data>
  800f68:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6d:	e8 1f fd ff ff       	call   800c91 <_pipeisclosed>
  800f72:	83 c4 10             	add    $0x10,%esp
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f77:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f80:	c3                   	ret    

00800f81 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f81:	f3 0f 1e fb          	endbr32 
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f8b:	68 b6 20 80 00       	push   $0x8020b6
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	e8 65 08 00 00       	call   8017fd <strcpy>
	return 0;
}
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <devcons_write>:
{
  800f9f:	f3 0f 1e fb          	endbr32 
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
  800fa9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800faf:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fb4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fba:	3b 75 10             	cmp    0x10(%ebp),%esi
  800fbd:	73 31                	jae    800ff0 <devcons_write+0x51>
		m = n - tot;
  800fbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc2:	29 f3                	sub    %esi,%ebx
  800fc4:	83 fb 7f             	cmp    $0x7f,%ebx
  800fc7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800fcc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	53                   	push   %ebx
  800fd3:	89 f0                	mov    %esi,%eax
  800fd5:	03 45 0c             	add    0xc(%ebp),%eax
  800fd8:	50                   	push   %eax
  800fd9:	57                   	push   %edi
  800fda:	e8 d4 09 00 00       	call   8019b3 <memmove>
		sys_cputs(buf, m);
  800fdf:	83 c4 08             	add    $0x8,%esp
  800fe2:	53                   	push   %ebx
  800fe3:	57                   	push   %edi
  800fe4:	e8 d7 f0 ff ff       	call   8000c0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fe9:	01 de                	add    %ebx,%esi
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	eb ca                	jmp    800fba <devcons_write+0x1b>
}
  800ff0:	89 f0                	mov    %esi,%eax
  800ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <devcons_read>:
{
  800ffa:	f3 0f 1e fb          	endbr32 
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	83 ec 08             	sub    $0x8,%esp
  801004:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801009:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100d:	74 21                	je     801030 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80100f:	e8 ce f0 ff ff       	call   8000e2 <sys_cgetc>
  801014:	85 c0                	test   %eax,%eax
  801016:	75 07                	jne    80101f <devcons_read+0x25>
		sys_yield();
  801018:	e8 50 f1 ff ff       	call   80016d <sys_yield>
  80101d:	eb f0                	jmp    80100f <devcons_read+0x15>
	if (c < 0)
  80101f:	78 0f                	js     801030 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801021:	83 f8 04             	cmp    $0x4,%eax
  801024:	74 0c                	je     801032 <devcons_read+0x38>
	*(char*)vbuf = c;
  801026:	8b 55 0c             	mov    0xc(%ebp),%edx
  801029:	88 02                	mov    %al,(%edx)
	return 1;
  80102b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    
		return 0;
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
  801037:	eb f7                	jmp    801030 <devcons_read+0x36>

00801039 <cputchar>:
{
  801039:	f3 0f 1e fb          	endbr32 
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801049:	6a 01                	push   $0x1
  80104b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80104e:	50                   	push   %eax
  80104f:	e8 6c f0 ff ff       	call   8000c0 <sys_cputs>
}
  801054:	83 c4 10             	add    $0x10,%esp
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <getchar>:
{
  801059:	f3 0f 1e fb          	endbr32 
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801063:	6a 01                	push   $0x1
  801065:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801068:	50                   	push   %eax
  801069:	6a 00                	push   $0x0
  80106b:	e8 5f f6 ff ff       	call   8006cf <read>
	if (r < 0)
  801070:	83 c4 10             	add    $0x10,%esp
  801073:	85 c0                	test   %eax,%eax
  801075:	78 06                	js     80107d <getchar+0x24>
	if (r < 1)
  801077:	74 06                	je     80107f <getchar+0x26>
	return c;
  801079:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    
		return -E_EOF;
  80107f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801084:	eb f7                	jmp    80107d <getchar+0x24>

00801086 <iscons>:
{
  801086:	f3 0f 1e fb          	endbr32 
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801090:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801093:	50                   	push   %eax
  801094:	ff 75 08             	pushl  0x8(%ebp)
  801097:	e8 b0 f3 ff ff       	call   80044c <fd_lookup>
  80109c:	83 c4 10             	add    $0x10,%esp
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	78 11                	js     8010b4 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8010a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010ac:	39 10                	cmp    %edx,(%eax)
  8010ae:	0f 94 c0             	sete   %al
  8010b1:	0f b6 c0             	movzbl %al,%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <opencons>:
{
  8010b6:	f3 0f 1e fb          	endbr32 
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c3:	50                   	push   %eax
  8010c4:	e8 2d f3 ff ff       	call   8003f6 <fd_alloc>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	78 3a                	js     80110a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010d0:	83 ec 04             	sub    $0x4,%esp
  8010d3:	68 07 04 00 00       	push   $0x407
  8010d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010db:	6a 00                	push   $0x0
  8010dd:	e8 ae f0 ff ff       	call   800190 <sys_page_alloc>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	78 21                	js     80110a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ec:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010f2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010fe:	83 ec 0c             	sub    $0xc,%esp
  801101:	50                   	push   %eax
  801102:	e8 c0 f2 ff ff       	call   8003c7 <fd2num>
  801107:	83 c4 10             	add    $0x10,%esp
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80110c:	f3 0f 1e fb          	endbr32 
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	56                   	push   %esi
  801114:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801115:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801118:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80111e:	e8 27 f0 ff ff       	call   80014a <sys_getenvid>
  801123:	83 ec 0c             	sub    $0xc,%esp
  801126:	ff 75 0c             	pushl  0xc(%ebp)
  801129:	ff 75 08             	pushl  0x8(%ebp)
  80112c:	56                   	push   %esi
  80112d:	50                   	push   %eax
  80112e:	68 c4 20 80 00       	push   $0x8020c4
  801133:	e8 bb 00 00 00       	call   8011f3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801138:	83 c4 18             	add    $0x18,%esp
  80113b:	53                   	push   %ebx
  80113c:	ff 75 10             	pushl  0x10(%ebp)
  80113f:	e8 5a 00 00 00       	call   80119e <vcprintf>
	cprintf("\n");
  801144:	c7 04 24 6b 24 80 00 	movl   $0x80246b,(%esp)
  80114b:	e8 a3 00 00 00       	call   8011f3 <cprintf>
  801150:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801153:	cc                   	int3   
  801154:	eb fd                	jmp    801153 <_panic+0x47>

00801156 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801156:	f3 0f 1e fb          	endbr32 
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	53                   	push   %ebx
  80115e:	83 ec 04             	sub    $0x4,%esp
  801161:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801164:	8b 13                	mov    (%ebx),%edx
  801166:	8d 42 01             	lea    0x1(%edx),%eax
  801169:	89 03                	mov    %eax,(%ebx)
  80116b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801172:	3d ff 00 00 00       	cmp    $0xff,%eax
  801177:	74 09                	je     801182 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801179:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80117d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801180:	c9                   	leave  
  801181:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801182:	83 ec 08             	sub    $0x8,%esp
  801185:	68 ff 00 00 00       	push   $0xff
  80118a:	8d 43 08             	lea    0x8(%ebx),%eax
  80118d:	50                   	push   %eax
  80118e:	e8 2d ef ff ff       	call   8000c0 <sys_cputs>
		b->idx = 0;
  801193:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	eb db                	jmp    801179 <putch+0x23>

0080119e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80119e:	f3 0f 1e fb          	endbr32 
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011b2:	00 00 00 
	b.cnt = 0;
  8011b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011bc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011bf:	ff 75 0c             	pushl  0xc(%ebp)
  8011c2:	ff 75 08             	pushl  0x8(%ebp)
  8011c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011cb:	50                   	push   %eax
  8011cc:	68 56 11 80 00       	push   $0x801156
  8011d1:	e8 20 01 00 00       	call   8012f6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011d6:	83 c4 08             	add    $0x8,%esp
  8011d9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8011df:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011e5:	50                   	push   %eax
  8011e6:	e8 d5 ee ff ff       	call   8000c0 <sys_cputs>

	return b.cnt;
}
  8011eb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011f3:	f3 0f 1e fb          	endbr32 
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011fd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801200:	50                   	push   %eax
  801201:	ff 75 08             	pushl  0x8(%ebp)
  801204:	e8 95 ff ff ff       	call   80119e <vcprintf>
	va_end(ap);

	return cnt;
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	53                   	push   %ebx
  801211:	83 ec 1c             	sub    $0x1c,%esp
  801214:	89 c7                	mov    %eax,%edi
  801216:	89 d6                	mov    %edx,%esi
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121e:	89 d1                	mov    %edx,%ecx
  801220:	89 c2                	mov    %eax,%edx
  801222:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801225:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801228:	8b 45 10             	mov    0x10(%ebp),%eax
  80122b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80122e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801231:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801238:	39 c2                	cmp    %eax,%edx
  80123a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80123d:	72 3e                	jb     80127d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	ff 75 18             	pushl  0x18(%ebp)
  801245:	83 eb 01             	sub    $0x1,%ebx
  801248:	53                   	push   %ebx
  801249:	50                   	push   %eax
  80124a:	83 ec 08             	sub    $0x8,%esp
  80124d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801250:	ff 75 e0             	pushl  -0x20(%ebp)
  801253:	ff 75 dc             	pushl  -0x24(%ebp)
  801256:	ff 75 d8             	pushl  -0x28(%ebp)
  801259:	e8 e2 0a 00 00       	call   801d40 <__udivdi3>
  80125e:	83 c4 18             	add    $0x18,%esp
  801261:	52                   	push   %edx
  801262:	50                   	push   %eax
  801263:	89 f2                	mov    %esi,%edx
  801265:	89 f8                	mov    %edi,%eax
  801267:	e8 9f ff ff ff       	call   80120b <printnum>
  80126c:	83 c4 20             	add    $0x20,%esp
  80126f:	eb 13                	jmp    801284 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801271:	83 ec 08             	sub    $0x8,%esp
  801274:	56                   	push   %esi
  801275:	ff 75 18             	pushl  0x18(%ebp)
  801278:	ff d7                	call   *%edi
  80127a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80127d:	83 eb 01             	sub    $0x1,%ebx
  801280:	85 db                	test   %ebx,%ebx
  801282:	7f ed                	jg     801271 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801284:	83 ec 08             	sub    $0x8,%esp
  801287:	56                   	push   %esi
  801288:	83 ec 04             	sub    $0x4,%esp
  80128b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80128e:	ff 75 e0             	pushl  -0x20(%ebp)
  801291:	ff 75 dc             	pushl  -0x24(%ebp)
  801294:	ff 75 d8             	pushl  -0x28(%ebp)
  801297:	e8 b4 0b 00 00       	call   801e50 <__umoddi3>
  80129c:	83 c4 14             	add    $0x14,%esp
  80129f:	0f be 80 e7 20 80 00 	movsbl 0x8020e7(%eax),%eax
  8012a6:	50                   	push   %eax
  8012a7:	ff d7                	call   *%edi
}
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012af:	5b                   	pop    %ebx
  8012b0:	5e                   	pop    %esi
  8012b1:	5f                   	pop    %edi
  8012b2:	5d                   	pop    %ebp
  8012b3:	c3                   	ret    

008012b4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012b4:	f3 0f 1e fb          	endbr32 
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012be:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8012c2:	8b 10                	mov    (%eax),%edx
  8012c4:	3b 50 04             	cmp    0x4(%eax),%edx
  8012c7:	73 0a                	jae    8012d3 <sprintputch+0x1f>
		*b->buf++ = ch;
  8012c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cc:	89 08                	mov    %ecx,(%eax)
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	88 02                	mov    %al,(%edx)
}
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <printfmt>:
{
  8012d5:	f3 0f 1e fb          	endbr32 
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012df:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012e2:	50                   	push   %eax
  8012e3:	ff 75 10             	pushl  0x10(%ebp)
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	ff 75 08             	pushl  0x8(%ebp)
  8012ec:	e8 05 00 00 00       	call   8012f6 <vprintfmt>
}
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    

008012f6 <vprintfmt>:
{
  8012f6:	f3 0f 1e fb          	endbr32 
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	57                   	push   %edi
  8012fe:	56                   	push   %esi
  8012ff:	53                   	push   %ebx
  801300:	83 ec 3c             	sub    $0x3c,%esp
  801303:	8b 75 08             	mov    0x8(%ebp),%esi
  801306:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801309:	8b 7d 10             	mov    0x10(%ebp),%edi
  80130c:	e9 8e 03 00 00       	jmp    80169f <vprintfmt+0x3a9>
		padc = ' ';
  801311:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801315:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80131c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801323:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80132a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80132f:	8d 47 01             	lea    0x1(%edi),%eax
  801332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801335:	0f b6 17             	movzbl (%edi),%edx
  801338:	8d 42 dd             	lea    -0x23(%edx),%eax
  80133b:	3c 55                	cmp    $0x55,%al
  80133d:	0f 87 df 03 00 00    	ja     801722 <vprintfmt+0x42c>
  801343:	0f b6 c0             	movzbl %al,%eax
  801346:	3e ff 24 85 20 22 80 	notrack jmp *0x802220(,%eax,4)
  80134d:	00 
  80134e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801351:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801355:	eb d8                	jmp    80132f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80135a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80135e:	eb cf                	jmp    80132f <vprintfmt+0x39>
  801360:	0f b6 d2             	movzbl %dl,%edx
  801363:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
  80136b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80136e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801371:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801375:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801378:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80137b:	83 f9 09             	cmp    $0x9,%ecx
  80137e:	77 55                	ja     8013d5 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801380:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801383:	eb e9                	jmp    80136e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801385:	8b 45 14             	mov    0x14(%ebp),%eax
  801388:	8b 00                	mov    (%eax),%eax
  80138a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80138d:	8b 45 14             	mov    0x14(%ebp),%eax
  801390:	8d 40 04             	lea    0x4(%eax),%eax
  801393:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801399:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80139d:	79 90                	jns    80132f <vprintfmt+0x39>
				width = precision, precision = -1;
  80139f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013a5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8013ac:	eb 81                	jmp    80132f <vprintfmt+0x39>
  8013ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b8:	0f 49 d0             	cmovns %eax,%edx
  8013bb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013c1:	e9 69 ff ff ff       	jmp    80132f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8013c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013c9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013d0:	e9 5a ff ff ff       	jmp    80132f <vprintfmt+0x39>
  8013d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013db:	eb bc                	jmp    801399 <vprintfmt+0xa3>
			lflag++;
  8013dd:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013e3:	e9 47 ff ff ff       	jmp    80132f <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013eb:	8d 78 04             	lea    0x4(%eax),%edi
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	53                   	push   %ebx
  8013f2:	ff 30                	pushl  (%eax)
  8013f4:	ff d6                	call   *%esi
			break;
  8013f6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013f9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013fc:	e9 9b 02 00 00       	jmp    80169c <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801401:	8b 45 14             	mov    0x14(%ebp),%eax
  801404:	8d 78 04             	lea    0x4(%eax),%edi
  801407:	8b 00                	mov    (%eax),%eax
  801409:	99                   	cltd   
  80140a:	31 d0                	xor    %edx,%eax
  80140c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80140e:	83 f8 0f             	cmp    $0xf,%eax
  801411:	7f 23                	jg     801436 <vprintfmt+0x140>
  801413:	8b 14 85 80 23 80 00 	mov    0x802380(,%eax,4),%edx
  80141a:	85 d2                	test   %edx,%edx
  80141c:	74 18                	je     801436 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80141e:	52                   	push   %edx
  80141f:	68 7d 20 80 00       	push   $0x80207d
  801424:	53                   	push   %ebx
  801425:	56                   	push   %esi
  801426:	e8 aa fe ff ff       	call   8012d5 <printfmt>
  80142b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80142e:	89 7d 14             	mov    %edi,0x14(%ebp)
  801431:	e9 66 02 00 00       	jmp    80169c <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801436:	50                   	push   %eax
  801437:	68 ff 20 80 00       	push   $0x8020ff
  80143c:	53                   	push   %ebx
  80143d:	56                   	push   %esi
  80143e:	e8 92 fe ff ff       	call   8012d5 <printfmt>
  801443:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801446:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801449:	e9 4e 02 00 00       	jmp    80169c <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	83 c0 04             	add    $0x4,%eax
  801454:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801457:	8b 45 14             	mov    0x14(%ebp),%eax
  80145a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80145c:	85 d2                	test   %edx,%edx
  80145e:	b8 f8 20 80 00       	mov    $0x8020f8,%eax
  801463:	0f 45 c2             	cmovne %edx,%eax
  801466:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801469:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80146d:	7e 06                	jle    801475 <vprintfmt+0x17f>
  80146f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801473:	75 0d                	jne    801482 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801475:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801478:	89 c7                	mov    %eax,%edi
  80147a:	03 45 e0             	add    -0x20(%ebp),%eax
  80147d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801480:	eb 55                	jmp    8014d7 <vprintfmt+0x1e1>
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	ff 75 d8             	pushl  -0x28(%ebp)
  801488:	ff 75 cc             	pushl  -0x34(%ebp)
  80148b:	e8 46 03 00 00       	call   8017d6 <strnlen>
  801490:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801493:	29 c2                	sub    %eax,%edx
  801495:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80149d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8014a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8014a4:	85 ff                	test   %edi,%edi
  8014a6:	7e 11                	jle    8014b9 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	53                   	push   %ebx
  8014ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8014af:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014b1:	83 ef 01             	sub    $0x1,%edi
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	eb eb                	jmp    8014a4 <vprintfmt+0x1ae>
  8014b9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8014bc:	85 d2                	test   %edx,%edx
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c3:	0f 49 c2             	cmovns %edx,%eax
  8014c6:	29 c2                	sub    %eax,%edx
  8014c8:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8014cb:	eb a8                	jmp    801475 <vprintfmt+0x17f>
					putch(ch, putdat);
  8014cd:	83 ec 08             	sub    $0x8,%esp
  8014d0:	53                   	push   %ebx
  8014d1:	52                   	push   %edx
  8014d2:	ff d6                	call   *%esi
  8014d4:	83 c4 10             	add    $0x10,%esp
  8014d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014da:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014dc:	83 c7 01             	add    $0x1,%edi
  8014df:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014e3:	0f be d0             	movsbl %al,%edx
  8014e6:	85 d2                	test   %edx,%edx
  8014e8:	74 4b                	je     801535 <vprintfmt+0x23f>
  8014ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014ee:	78 06                	js     8014f6 <vprintfmt+0x200>
  8014f0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014f4:	78 1e                	js     801514 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014f6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014fa:	74 d1                	je     8014cd <vprintfmt+0x1d7>
  8014fc:	0f be c0             	movsbl %al,%eax
  8014ff:	83 e8 20             	sub    $0x20,%eax
  801502:	83 f8 5e             	cmp    $0x5e,%eax
  801505:	76 c6                	jbe    8014cd <vprintfmt+0x1d7>
					putch('?', putdat);
  801507:	83 ec 08             	sub    $0x8,%esp
  80150a:	53                   	push   %ebx
  80150b:	6a 3f                	push   $0x3f
  80150d:	ff d6                	call   *%esi
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	eb c3                	jmp    8014d7 <vprintfmt+0x1e1>
  801514:	89 cf                	mov    %ecx,%edi
  801516:	eb 0e                	jmp    801526 <vprintfmt+0x230>
				putch(' ', putdat);
  801518:	83 ec 08             	sub    $0x8,%esp
  80151b:	53                   	push   %ebx
  80151c:	6a 20                	push   $0x20
  80151e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801520:	83 ef 01             	sub    $0x1,%edi
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	85 ff                	test   %edi,%edi
  801528:	7f ee                	jg     801518 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80152a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80152d:	89 45 14             	mov    %eax,0x14(%ebp)
  801530:	e9 67 01 00 00       	jmp    80169c <vprintfmt+0x3a6>
  801535:	89 cf                	mov    %ecx,%edi
  801537:	eb ed                	jmp    801526 <vprintfmt+0x230>
	if (lflag >= 2)
  801539:	83 f9 01             	cmp    $0x1,%ecx
  80153c:	7f 1b                	jg     801559 <vprintfmt+0x263>
	else if (lflag)
  80153e:	85 c9                	test   %ecx,%ecx
  801540:	74 63                	je     8015a5 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801542:	8b 45 14             	mov    0x14(%ebp),%eax
  801545:	8b 00                	mov    (%eax),%eax
  801547:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80154a:	99                   	cltd   
  80154b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80154e:	8b 45 14             	mov    0x14(%ebp),%eax
  801551:	8d 40 04             	lea    0x4(%eax),%eax
  801554:	89 45 14             	mov    %eax,0x14(%ebp)
  801557:	eb 17                	jmp    801570 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801559:	8b 45 14             	mov    0x14(%ebp),%eax
  80155c:	8b 50 04             	mov    0x4(%eax),%edx
  80155f:	8b 00                	mov    (%eax),%eax
  801561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801567:	8b 45 14             	mov    0x14(%ebp),%eax
  80156a:	8d 40 08             	lea    0x8(%eax),%eax
  80156d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801570:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801573:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801576:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80157b:	85 c9                	test   %ecx,%ecx
  80157d:	0f 89 ff 00 00 00    	jns    801682 <vprintfmt+0x38c>
				putch('-', putdat);
  801583:	83 ec 08             	sub    $0x8,%esp
  801586:	53                   	push   %ebx
  801587:	6a 2d                	push   $0x2d
  801589:	ff d6                	call   *%esi
				num = -(long long) num;
  80158b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80158e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801591:	f7 da                	neg    %edx
  801593:	83 d1 00             	adc    $0x0,%ecx
  801596:	f7 d9                	neg    %ecx
  801598:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80159b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015a0:	e9 dd 00 00 00       	jmp    801682 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8015a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a8:	8b 00                	mov    (%eax),%eax
  8015aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015ad:	99                   	cltd   
  8015ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8015b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b4:	8d 40 04             	lea    0x4(%eax),%eax
  8015b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015ba:	eb b4                	jmp    801570 <vprintfmt+0x27a>
	if (lflag >= 2)
  8015bc:	83 f9 01             	cmp    $0x1,%ecx
  8015bf:	7f 1e                	jg     8015df <vprintfmt+0x2e9>
	else if (lflag)
  8015c1:	85 c9                	test   %ecx,%ecx
  8015c3:	74 32                	je     8015f7 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8015c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c8:	8b 10                	mov    (%eax),%edx
  8015ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015cf:	8d 40 04             	lea    0x4(%eax),%eax
  8015d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015d5:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8015da:	e9 a3 00 00 00       	jmp    801682 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015df:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e2:	8b 10                	mov    (%eax),%edx
  8015e4:	8b 48 04             	mov    0x4(%eax),%ecx
  8015e7:	8d 40 08             	lea    0x8(%eax),%eax
  8015ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015ed:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015f2:	e9 8b 00 00 00       	jmp    801682 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fa:	8b 10                	mov    (%eax),%edx
  8015fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801601:	8d 40 04             	lea    0x4(%eax),%eax
  801604:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801607:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80160c:	eb 74                	jmp    801682 <vprintfmt+0x38c>
	if (lflag >= 2)
  80160e:	83 f9 01             	cmp    $0x1,%ecx
  801611:	7f 1b                	jg     80162e <vprintfmt+0x338>
	else if (lflag)
  801613:	85 c9                	test   %ecx,%ecx
  801615:	74 2c                	je     801643 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801617:	8b 45 14             	mov    0x14(%ebp),%eax
  80161a:	8b 10                	mov    (%eax),%edx
  80161c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801621:	8d 40 04             	lea    0x4(%eax),%eax
  801624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801627:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80162c:	eb 54                	jmp    801682 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80162e:	8b 45 14             	mov    0x14(%ebp),%eax
  801631:	8b 10                	mov    (%eax),%edx
  801633:	8b 48 04             	mov    0x4(%eax),%ecx
  801636:	8d 40 08             	lea    0x8(%eax),%eax
  801639:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80163c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801641:	eb 3f                	jmp    801682 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801643:	8b 45 14             	mov    0x14(%ebp),%eax
  801646:	8b 10                	mov    (%eax),%edx
  801648:	b9 00 00 00 00       	mov    $0x0,%ecx
  80164d:	8d 40 04             	lea    0x4(%eax),%eax
  801650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801653:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801658:	eb 28                	jmp    801682 <vprintfmt+0x38c>
			putch('0', putdat);
  80165a:	83 ec 08             	sub    $0x8,%esp
  80165d:	53                   	push   %ebx
  80165e:	6a 30                	push   $0x30
  801660:	ff d6                	call   *%esi
			putch('x', putdat);
  801662:	83 c4 08             	add    $0x8,%esp
  801665:	53                   	push   %ebx
  801666:	6a 78                	push   $0x78
  801668:	ff d6                	call   *%esi
			num = (unsigned long long)
  80166a:	8b 45 14             	mov    0x14(%ebp),%eax
  80166d:	8b 10                	mov    (%eax),%edx
  80166f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801674:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801677:	8d 40 04             	lea    0x4(%eax),%eax
  80167a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80167d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801682:	83 ec 0c             	sub    $0xc,%esp
  801685:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801689:	57                   	push   %edi
  80168a:	ff 75 e0             	pushl  -0x20(%ebp)
  80168d:	50                   	push   %eax
  80168e:	51                   	push   %ecx
  80168f:	52                   	push   %edx
  801690:	89 da                	mov    %ebx,%edx
  801692:	89 f0                	mov    %esi,%eax
  801694:	e8 72 fb ff ff       	call   80120b <printnum>
			break;
  801699:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80169c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80169f:	83 c7 01             	add    $0x1,%edi
  8016a2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016a6:	83 f8 25             	cmp    $0x25,%eax
  8016a9:	0f 84 62 fc ff ff    	je     801311 <vprintfmt+0x1b>
			if (ch == '\0')
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	0f 84 8b 00 00 00    	je     801742 <vprintfmt+0x44c>
			putch(ch, putdat);
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	53                   	push   %ebx
  8016bb:	50                   	push   %eax
  8016bc:	ff d6                	call   *%esi
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	eb dc                	jmp    80169f <vprintfmt+0x3a9>
	if (lflag >= 2)
  8016c3:	83 f9 01             	cmp    $0x1,%ecx
  8016c6:	7f 1b                	jg     8016e3 <vprintfmt+0x3ed>
	else if (lflag)
  8016c8:	85 c9                	test   %ecx,%ecx
  8016ca:	74 2c                	je     8016f8 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8016cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cf:	8b 10                	mov    (%eax),%edx
  8016d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d6:	8d 40 04             	lea    0x4(%eax),%eax
  8016d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016dc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8016e1:	eb 9f                	jmp    801682 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 10                	mov    (%eax),%edx
  8016e8:	8b 48 04             	mov    0x4(%eax),%ecx
  8016eb:	8d 40 08             	lea    0x8(%eax),%eax
  8016ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016f1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016f6:	eb 8a                	jmp    801682 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fb:	8b 10                	mov    (%eax),%edx
  8016fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801702:	8d 40 04             	lea    0x4(%eax),%eax
  801705:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801708:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80170d:	e9 70 ff ff ff       	jmp    801682 <vprintfmt+0x38c>
			putch(ch, putdat);
  801712:	83 ec 08             	sub    $0x8,%esp
  801715:	53                   	push   %ebx
  801716:	6a 25                	push   $0x25
  801718:	ff d6                	call   *%esi
			break;
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	e9 7a ff ff ff       	jmp    80169c <vprintfmt+0x3a6>
			putch('%', putdat);
  801722:	83 ec 08             	sub    $0x8,%esp
  801725:	53                   	push   %ebx
  801726:	6a 25                	push   $0x25
  801728:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 f8                	mov    %edi,%eax
  80172f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801733:	74 05                	je     80173a <vprintfmt+0x444>
  801735:	83 e8 01             	sub    $0x1,%eax
  801738:	eb f5                	jmp    80172f <vprintfmt+0x439>
  80173a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80173d:	e9 5a ff ff ff       	jmp    80169c <vprintfmt+0x3a6>
}
  801742:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5f                   	pop    %edi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    

0080174a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80174a:	f3 0f 1e fb          	endbr32 
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 18             	sub    $0x18,%esp
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80175a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80175d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801761:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80176b:	85 c0                	test   %eax,%eax
  80176d:	74 26                	je     801795 <vsnprintf+0x4b>
  80176f:	85 d2                	test   %edx,%edx
  801771:	7e 22                	jle    801795 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801773:	ff 75 14             	pushl  0x14(%ebp)
  801776:	ff 75 10             	pushl  0x10(%ebp)
  801779:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80177c:	50                   	push   %eax
  80177d:	68 b4 12 80 00       	push   $0x8012b4
  801782:	e8 6f fb ff ff       	call   8012f6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801787:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80178d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801790:	83 c4 10             	add    $0x10,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    
		return -E_INVAL;
  801795:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179a:	eb f7                	jmp    801793 <vsnprintf+0x49>

0080179c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80179c:	f3 0f 1e fb          	endbr32 
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017a6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017a9:	50                   	push   %eax
  8017aa:	ff 75 10             	pushl  0x10(%ebp)
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	e8 92 ff ff ff       	call   80174a <vsnprintf>
	va_end(ap);

	return rc;
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017ba:	f3 0f 1e fb          	endbr32 
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8017cd:	74 05                	je     8017d4 <strlen+0x1a>
		n++;
  8017cf:	83 c0 01             	add    $0x1,%eax
  8017d2:	eb f5                	jmp    8017c9 <strlen+0xf>
	return n;
}
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    

008017d6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017d6:	f3 0f 1e fb          	endbr32 
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e8:	39 d0                	cmp    %edx,%eax
  8017ea:	74 0d                	je     8017f9 <strnlen+0x23>
  8017ec:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017f0:	74 05                	je     8017f7 <strnlen+0x21>
		n++;
  8017f2:	83 c0 01             	add    $0x1,%eax
  8017f5:	eb f1                	jmp    8017e8 <strnlen+0x12>
  8017f7:	89 c2                	mov    %eax,%edx
	return n;
}
  8017f9:	89 d0                	mov    %edx,%eax
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017fd:	f3 0f 1e fb          	endbr32 
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	53                   	push   %ebx
  801805:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801808:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
  801810:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801814:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801817:	83 c0 01             	add    $0x1,%eax
  80181a:	84 d2                	test   %dl,%dl
  80181c:	75 f2                	jne    801810 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80181e:	89 c8                	mov    %ecx,%eax
  801820:	5b                   	pop    %ebx
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    

00801823 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801823:	f3 0f 1e fb          	endbr32 
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	53                   	push   %ebx
  80182b:	83 ec 10             	sub    $0x10,%esp
  80182e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801831:	53                   	push   %ebx
  801832:	e8 83 ff ff ff       	call   8017ba <strlen>
  801837:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80183a:	ff 75 0c             	pushl  0xc(%ebp)
  80183d:	01 d8                	add    %ebx,%eax
  80183f:	50                   	push   %eax
  801840:	e8 b8 ff ff ff       	call   8017fd <strcpy>
	return dst;
}
  801845:	89 d8                	mov    %ebx,%eax
  801847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80184c:	f3 0f 1e fb          	endbr32 
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	56                   	push   %esi
  801854:	53                   	push   %ebx
  801855:	8b 75 08             	mov    0x8(%ebp),%esi
  801858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185b:	89 f3                	mov    %esi,%ebx
  80185d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801860:	89 f0                	mov    %esi,%eax
  801862:	39 d8                	cmp    %ebx,%eax
  801864:	74 11                	je     801877 <strncpy+0x2b>
		*dst++ = *src;
  801866:	83 c0 01             	add    $0x1,%eax
  801869:	0f b6 0a             	movzbl (%edx),%ecx
  80186c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80186f:	80 f9 01             	cmp    $0x1,%cl
  801872:	83 da ff             	sbb    $0xffffffff,%edx
  801875:	eb eb                	jmp    801862 <strncpy+0x16>
	}
	return ret;
}
  801877:	89 f0                	mov    %esi,%eax
  801879:	5b                   	pop    %ebx
  80187a:	5e                   	pop    %esi
  80187b:	5d                   	pop    %ebp
  80187c:	c3                   	ret    

0080187d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80187d:	f3 0f 1e fb          	endbr32 
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	56                   	push   %esi
  801885:	53                   	push   %ebx
  801886:	8b 75 08             	mov    0x8(%ebp),%esi
  801889:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188c:	8b 55 10             	mov    0x10(%ebp),%edx
  80188f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801891:	85 d2                	test   %edx,%edx
  801893:	74 21                	je     8018b6 <strlcpy+0x39>
  801895:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801899:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80189b:	39 c2                	cmp    %eax,%edx
  80189d:	74 14                	je     8018b3 <strlcpy+0x36>
  80189f:	0f b6 19             	movzbl (%ecx),%ebx
  8018a2:	84 db                	test   %bl,%bl
  8018a4:	74 0b                	je     8018b1 <strlcpy+0x34>
			*dst++ = *src++;
  8018a6:	83 c1 01             	add    $0x1,%ecx
  8018a9:	83 c2 01             	add    $0x1,%edx
  8018ac:	88 5a ff             	mov    %bl,-0x1(%edx)
  8018af:	eb ea                	jmp    80189b <strlcpy+0x1e>
  8018b1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8018b3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018b6:	29 f0                	sub    %esi,%eax
}
  8018b8:	5b                   	pop    %ebx
  8018b9:	5e                   	pop    %esi
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    

008018bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018bc:	f3 0f 1e fb          	endbr32 
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018c9:	0f b6 01             	movzbl (%ecx),%eax
  8018cc:	84 c0                	test   %al,%al
  8018ce:	74 0c                	je     8018dc <strcmp+0x20>
  8018d0:	3a 02                	cmp    (%edx),%al
  8018d2:	75 08                	jne    8018dc <strcmp+0x20>
		p++, q++;
  8018d4:	83 c1 01             	add    $0x1,%ecx
  8018d7:	83 c2 01             	add    $0x1,%edx
  8018da:	eb ed                	jmp    8018c9 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018dc:	0f b6 c0             	movzbl %al,%eax
  8018df:	0f b6 12             	movzbl (%edx),%edx
  8018e2:	29 d0                	sub    %edx,%eax
}
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018e6:	f3 0f 1e fb          	endbr32 
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	53                   	push   %ebx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f4:	89 c3                	mov    %eax,%ebx
  8018f6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018f9:	eb 06                	jmp    801901 <strncmp+0x1b>
		n--, p++, q++;
  8018fb:	83 c0 01             	add    $0x1,%eax
  8018fe:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801901:	39 d8                	cmp    %ebx,%eax
  801903:	74 16                	je     80191b <strncmp+0x35>
  801905:	0f b6 08             	movzbl (%eax),%ecx
  801908:	84 c9                	test   %cl,%cl
  80190a:	74 04                	je     801910 <strncmp+0x2a>
  80190c:	3a 0a                	cmp    (%edx),%cl
  80190e:	74 eb                	je     8018fb <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801910:	0f b6 00             	movzbl (%eax),%eax
  801913:	0f b6 12             	movzbl (%edx),%edx
  801916:	29 d0                	sub    %edx,%eax
}
  801918:	5b                   	pop    %ebx
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    
		return 0;
  80191b:	b8 00 00 00 00       	mov    $0x0,%eax
  801920:	eb f6                	jmp    801918 <strncmp+0x32>

00801922 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801922:	f3 0f 1e fb          	endbr32 
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801930:	0f b6 10             	movzbl (%eax),%edx
  801933:	84 d2                	test   %dl,%dl
  801935:	74 09                	je     801940 <strchr+0x1e>
		if (*s == c)
  801937:	38 ca                	cmp    %cl,%dl
  801939:	74 0a                	je     801945 <strchr+0x23>
	for (; *s; s++)
  80193b:	83 c0 01             	add    $0x1,%eax
  80193e:	eb f0                	jmp    801930 <strchr+0xe>
			return (char *) s;
	return 0;
  801940:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801947:	f3 0f 1e fb          	endbr32 
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801955:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801958:	38 ca                	cmp    %cl,%dl
  80195a:	74 09                	je     801965 <strfind+0x1e>
  80195c:	84 d2                	test   %dl,%dl
  80195e:	74 05                	je     801965 <strfind+0x1e>
	for (; *s; s++)
  801960:	83 c0 01             	add    $0x1,%eax
  801963:	eb f0                	jmp    801955 <strfind+0xe>
			break;
	return (char *) s;
}
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    

00801967 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801967:	f3 0f 1e fb          	endbr32 
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	57                   	push   %edi
  80196f:	56                   	push   %esi
  801970:	53                   	push   %ebx
  801971:	8b 7d 08             	mov    0x8(%ebp),%edi
  801974:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801977:	85 c9                	test   %ecx,%ecx
  801979:	74 31                	je     8019ac <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80197b:	89 f8                	mov    %edi,%eax
  80197d:	09 c8                	or     %ecx,%eax
  80197f:	a8 03                	test   $0x3,%al
  801981:	75 23                	jne    8019a6 <memset+0x3f>
		c &= 0xFF;
  801983:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801987:	89 d3                	mov    %edx,%ebx
  801989:	c1 e3 08             	shl    $0x8,%ebx
  80198c:	89 d0                	mov    %edx,%eax
  80198e:	c1 e0 18             	shl    $0x18,%eax
  801991:	89 d6                	mov    %edx,%esi
  801993:	c1 e6 10             	shl    $0x10,%esi
  801996:	09 f0                	or     %esi,%eax
  801998:	09 c2                	or     %eax,%edx
  80199a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80199c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80199f:	89 d0                	mov    %edx,%eax
  8019a1:	fc                   	cld    
  8019a2:	f3 ab                	rep stos %eax,%es:(%edi)
  8019a4:	eb 06                	jmp    8019ac <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	fc                   	cld    
  8019aa:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8019ac:	89 f8                	mov    %edi,%eax
  8019ae:	5b                   	pop    %ebx
  8019af:	5e                   	pop    %esi
  8019b0:	5f                   	pop    %edi
  8019b1:	5d                   	pop    %ebp
  8019b2:	c3                   	ret    

008019b3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019b3:	f3 0f 1e fb          	endbr32 
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	57                   	push   %edi
  8019bb:	56                   	push   %esi
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019c5:	39 c6                	cmp    %eax,%esi
  8019c7:	73 32                	jae    8019fb <memmove+0x48>
  8019c9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019cc:	39 c2                	cmp    %eax,%edx
  8019ce:	76 2b                	jbe    8019fb <memmove+0x48>
		s += n;
		d += n;
  8019d0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019d3:	89 fe                	mov    %edi,%esi
  8019d5:	09 ce                	or     %ecx,%esi
  8019d7:	09 d6                	or     %edx,%esi
  8019d9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019df:	75 0e                	jne    8019ef <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019e1:	83 ef 04             	sub    $0x4,%edi
  8019e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019e7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019ea:	fd                   	std    
  8019eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019ed:	eb 09                	jmp    8019f8 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019ef:	83 ef 01             	sub    $0x1,%edi
  8019f2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019f5:	fd                   	std    
  8019f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019f8:	fc                   	cld    
  8019f9:	eb 1a                	jmp    801a15 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019fb:	89 c2                	mov    %eax,%edx
  8019fd:	09 ca                	or     %ecx,%edx
  8019ff:	09 f2                	or     %esi,%edx
  801a01:	f6 c2 03             	test   $0x3,%dl
  801a04:	75 0a                	jne    801a10 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801a06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801a09:	89 c7                	mov    %eax,%edi
  801a0b:	fc                   	cld    
  801a0c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801a0e:	eb 05                	jmp    801a15 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801a10:	89 c7                	mov    %eax,%edi
  801a12:	fc                   	cld    
  801a13:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801a15:	5e                   	pop    %esi
  801a16:	5f                   	pop    %edi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    

00801a19 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801a19:	f3 0f 1e fb          	endbr32 
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801a23:	ff 75 10             	pushl  0x10(%ebp)
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	ff 75 08             	pushl  0x8(%ebp)
  801a2c:	e8 82 ff ff ff       	call   8019b3 <memmove>
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a33:	f3 0f 1e fb          	endbr32 
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	56                   	push   %esi
  801a3b:	53                   	push   %ebx
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a42:	89 c6                	mov    %eax,%esi
  801a44:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a47:	39 f0                	cmp    %esi,%eax
  801a49:	74 1c                	je     801a67 <memcmp+0x34>
		if (*s1 != *s2)
  801a4b:	0f b6 08             	movzbl (%eax),%ecx
  801a4e:	0f b6 1a             	movzbl (%edx),%ebx
  801a51:	38 d9                	cmp    %bl,%cl
  801a53:	75 08                	jne    801a5d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a55:	83 c0 01             	add    $0x1,%eax
  801a58:	83 c2 01             	add    $0x1,%edx
  801a5b:	eb ea                	jmp    801a47 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a5d:	0f b6 c1             	movzbl %cl,%eax
  801a60:	0f b6 db             	movzbl %bl,%ebx
  801a63:	29 d8                	sub    %ebx,%eax
  801a65:	eb 05                	jmp    801a6c <memcmp+0x39>
	}

	return 0;
  801a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6c:	5b                   	pop    %ebx
  801a6d:	5e                   	pop    %esi
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    

00801a70 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a70:	f3 0f 1e fb          	endbr32 
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a7d:	89 c2                	mov    %eax,%edx
  801a7f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a82:	39 d0                	cmp    %edx,%eax
  801a84:	73 09                	jae    801a8f <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a86:	38 08                	cmp    %cl,(%eax)
  801a88:	74 05                	je     801a8f <memfind+0x1f>
	for (; s < ends; s++)
  801a8a:	83 c0 01             	add    $0x1,%eax
  801a8d:	eb f3                	jmp    801a82 <memfind+0x12>
			break;
	return (void *) s;
}
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    

00801a91 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a91:	f3 0f 1e fb          	endbr32 
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	57                   	push   %edi
  801a99:	56                   	push   %esi
  801a9a:	53                   	push   %ebx
  801a9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801aa1:	eb 03                	jmp    801aa6 <strtol+0x15>
		s++;
  801aa3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801aa6:	0f b6 01             	movzbl (%ecx),%eax
  801aa9:	3c 20                	cmp    $0x20,%al
  801aab:	74 f6                	je     801aa3 <strtol+0x12>
  801aad:	3c 09                	cmp    $0x9,%al
  801aaf:	74 f2                	je     801aa3 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801ab1:	3c 2b                	cmp    $0x2b,%al
  801ab3:	74 2a                	je     801adf <strtol+0x4e>
	int neg = 0;
  801ab5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801aba:	3c 2d                	cmp    $0x2d,%al
  801abc:	74 2b                	je     801ae9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801abe:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ac4:	75 0f                	jne    801ad5 <strtol+0x44>
  801ac6:	80 39 30             	cmpb   $0x30,(%ecx)
  801ac9:	74 28                	je     801af3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801acb:	85 db                	test   %ebx,%ebx
  801acd:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ad2:	0f 44 d8             	cmove  %eax,%ebx
  801ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ada:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801add:	eb 46                	jmp    801b25 <strtol+0x94>
		s++;
  801adf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801ae2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ae7:	eb d5                	jmp    801abe <strtol+0x2d>
		s++, neg = 1;
  801ae9:	83 c1 01             	add    $0x1,%ecx
  801aec:	bf 01 00 00 00       	mov    $0x1,%edi
  801af1:	eb cb                	jmp    801abe <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801af3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801af7:	74 0e                	je     801b07 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801af9:	85 db                	test   %ebx,%ebx
  801afb:	75 d8                	jne    801ad5 <strtol+0x44>
		s++, base = 8;
  801afd:	83 c1 01             	add    $0x1,%ecx
  801b00:	bb 08 00 00 00       	mov    $0x8,%ebx
  801b05:	eb ce                	jmp    801ad5 <strtol+0x44>
		s += 2, base = 16;
  801b07:	83 c1 02             	add    $0x2,%ecx
  801b0a:	bb 10 00 00 00       	mov    $0x10,%ebx
  801b0f:	eb c4                	jmp    801ad5 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801b11:	0f be d2             	movsbl %dl,%edx
  801b14:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801b17:	3b 55 10             	cmp    0x10(%ebp),%edx
  801b1a:	7d 3a                	jge    801b56 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801b1c:	83 c1 01             	add    $0x1,%ecx
  801b1f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b23:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801b25:	0f b6 11             	movzbl (%ecx),%edx
  801b28:	8d 72 d0             	lea    -0x30(%edx),%esi
  801b2b:	89 f3                	mov    %esi,%ebx
  801b2d:	80 fb 09             	cmp    $0x9,%bl
  801b30:	76 df                	jbe    801b11 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801b32:	8d 72 9f             	lea    -0x61(%edx),%esi
  801b35:	89 f3                	mov    %esi,%ebx
  801b37:	80 fb 19             	cmp    $0x19,%bl
  801b3a:	77 08                	ja     801b44 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801b3c:	0f be d2             	movsbl %dl,%edx
  801b3f:	83 ea 57             	sub    $0x57,%edx
  801b42:	eb d3                	jmp    801b17 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801b44:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b47:	89 f3                	mov    %esi,%ebx
  801b49:	80 fb 19             	cmp    $0x19,%bl
  801b4c:	77 08                	ja     801b56 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b4e:	0f be d2             	movsbl %dl,%edx
  801b51:	83 ea 37             	sub    $0x37,%edx
  801b54:	eb c1                	jmp    801b17 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b5a:	74 05                	je     801b61 <strtol+0xd0>
		*endptr = (char *) s;
  801b5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b5f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b61:	89 c2                	mov    %eax,%edx
  801b63:	f7 da                	neg    %edx
  801b65:	85 ff                	test   %edi,%edi
  801b67:	0f 45 c2             	cmovne %edx,%eax
}
  801b6a:	5b                   	pop    %ebx
  801b6b:	5e                   	pop    %esi
  801b6c:	5f                   	pop    %edi
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    

00801b6f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b6f:	f3 0f 1e fb          	endbr32 
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801b79:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801b80:	74 0a                	je     801b8c <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	6a 07                	push   $0x7
  801b91:	68 00 f0 bf ee       	push   $0xeebff000
  801b96:	6a 00                	push   $0x0
  801b98:	e8 f3 e5 ff ff       	call   800190 <sys_page_alloc>
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	78 2a                	js     801bce <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801ba4:	83 ec 08             	sub    $0x8,%esp
  801ba7:	68 a1 03 80 00       	push   $0x8003a1
  801bac:	6a 00                	push   $0x0
  801bae:	e8 3c e7 ff ff       	call   8002ef <sys_env_set_pgfault_upcall>
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	79 c8                	jns    801b82 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	68 0c 24 80 00       	push   $0x80240c
  801bc2:	6a 25                	push   $0x25
  801bc4:	68 44 24 80 00       	push   $0x802444
  801bc9:	e8 3e f5 ff ff       	call   80110c <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  801bce:	83 ec 04             	sub    $0x4,%esp
  801bd1:	68 e0 23 80 00       	push   $0x8023e0
  801bd6:	6a 22                	push   $0x22
  801bd8:	68 44 24 80 00       	push   $0x802444
  801bdd:	e8 2a f5 ff ff       	call   80110c <_panic>

00801be2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801be2:	f3 0f 1e fb          	endbr32 
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	56                   	push   %esi
  801bea:	53                   	push   %ebx
  801beb:	8b 75 08             	mov    0x8(%ebp),%esi
  801bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	74 3d                	je     801c35 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	50                   	push   %eax
  801bfc:	e8 5b e7 ff ff       	call   80035c <sys_ipc_recv>
  801c01:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801c04:	85 f6                	test   %esi,%esi
  801c06:	74 0b                	je     801c13 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801c08:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c0e:	8b 52 74             	mov    0x74(%edx),%edx
  801c11:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801c13:	85 db                	test   %ebx,%ebx
  801c15:	74 0b                	je     801c22 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801c17:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c1d:	8b 52 78             	mov    0x78(%edx),%edx
  801c20:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 21                	js     801c47 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801c26:	a1 04 40 80 00       	mov    0x804004,%eax
  801c2b:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c31:	5b                   	pop    %ebx
  801c32:	5e                   	pop    %esi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801c35:	83 ec 0c             	sub    $0xc,%esp
  801c38:	68 00 00 c0 ee       	push   $0xeec00000
  801c3d:	e8 1a e7 ff ff       	call   80035c <sys_ipc_recv>
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	eb bd                	jmp    801c04 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801c47:	85 f6                	test   %esi,%esi
  801c49:	74 10                	je     801c5b <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801c4b:	85 db                	test   %ebx,%ebx
  801c4d:	75 df                	jne    801c2e <ipc_recv+0x4c>
  801c4f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c56:	00 00 00 
  801c59:	eb d3                	jmp    801c2e <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801c5b:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c62:	00 00 00 
  801c65:	eb e4                	jmp    801c4b <ipc_recv+0x69>

00801c67 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c67:	f3 0f 1e fb          	endbr32 
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	57                   	push   %edi
  801c6f:	56                   	push   %esi
  801c70:	53                   	push   %ebx
  801c71:	83 ec 0c             	sub    $0xc,%esp
  801c74:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c77:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801c7d:	85 db                	test   %ebx,%ebx
  801c7f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c84:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801c87:	ff 75 14             	pushl  0x14(%ebp)
  801c8a:	53                   	push   %ebx
  801c8b:	56                   	push   %esi
  801c8c:	57                   	push   %edi
  801c8d:	e8 a3 e6 ff ff       	call   800335 <sys_ipc_try_send>
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	85 c0                	test   %eax,%eax
  801c97:	79 1e                	jns    801cb7 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801c99:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c9c:	75 07                	jne    801ca5 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801c9e:	e8 ca e4 ff ff       	call   80016d <sys_yield>
  801ca3:	eb e2                	jmp    801c87 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801ca5:	50                   	push   %eax
  801ca6:	68 52 24 80 00       	push   $0x802452
  801cab:	6a 59                	push   $0x59
  801cad:	68 6d 24 80 00       	push   $0x80246d
  801cb2:	e8 55 f4 ff ff       	call   80110c <_panic>
	}
}
  801cb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cba:	5b                   	pop    %ebx
  801cbb:	5e                   	pop    %esi
  801cbc:	5f                   	pop    %edi
  801cbd:	5d                   	pop    %ebp
  801cbe:	c3                   	ret    

00801cbf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cbf:	f3 0f 1e fb          	endbr32 
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cce:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801cd1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801cd7:	8b 52 50             	mov    0x50(%edx),%edx
  801cda:	39 ca                	cmp    %ecx,%edx
  801cdc:	74 11                	je     801cef <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801cde:	83 c0 01             	add    $0x1,%eax
  801ce1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ce6:	75 e6                	jne    801cce <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ced:	eb 0b                	jmp    801cfa <ipc_find_env+0x3b>
			return envs[i].env_id;
  801cef:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801cf2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801cf7:	8b 40 48             	mov    0x48(%eax),%eax
}
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    

00801cfc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cfc:	f3 0f 1e fb          	endbr32 
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d06:	89 c2                	mov    %eax,%edx
  801d08:	c1 ea 16             	shr    $0x16,%edx
  801d0b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801d12:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801d17:	f6 c1 01             	test   $0x1,%cl
  801d1a:	74 1c                	je     801d38 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801d1c:	c1 e8 0c             	shr    $0xc,%eax
  801d1f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d26:	a8 01                	test   $0x1,%al
  801d28:	74 0e                	je     801d38 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d2a:	c1 e8 0c             	shr    $0xc,%eax
  801d2d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801d34:	ef 
  801d35:	0f b7 d2             	movzwl %dx,%edx
}
  801d38:	89 d0                	mov    %edx,%eax
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    
  801d3c:	66 90                	xchg   %ax,%ax
  801d3e:	66 90                	xchg   %ax,%ax

00801d40 <__udivdi3>:
  801d40:	f3 0f 1e fb          	endbr32 
  801d44:	55                   	push   %ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 1c             	sub    $0x1c,%esp
  801d4b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d4f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d53:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d57:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d5b:	85 d2                	test   %edx,%edx
  801d5d:	75 19                	jne    801d78 <__udivdi3+0x38>
  801d5f:	39 f3                	cmp    %esi,%ebx
  801d61:	76 4d                	jbe    801db0 <__udivdi3+0x70>
  801d63:	31 ff                	xor    %edi,%edi
  801d65:	89 e8                	mov    %ebp,%eax
  801d67:	89 f2                	mov    %esi,%edx
  801d69:	f7 f3                	div    %ebx
  801d6b:	89 fa                	mov    %edi,%edx
  801d6d:	83 c4 1c             	add    $0x1c,%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5f                   	pop    %edi
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    
  801d75:	8d 76 00             	lea    0x0(%esi),%esi
  801d78:	39 f2                	cmp    %esi,%edx
  801d7a:	76 14                	jbe    801d90 <__udivdi3+0x50>
  801d7c:	31 ff                	xor    %edi,%edi
  801d7e:	31 c0                	xor    %eax,%eax
  801d80:	89 fa                	mov    %edi,%edx
  801d82:	83 c4 1c             	add    $0x1c,%esp
  801d85:	5b                   	pop    %ebx
  801d86:	5e                   	pop    %esi
  801d87:	5f                   	pop    %edi
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    
  801d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d90:	0f bd fa             	bsr    %edx,%edi
  801d93:	83 f7 1f             	xor    $0x1f,%edi
  801d96:	75 48                	jne    801de0 <__udivdi3+0xa0>
  801d98:	39 f2                	cmp    %esi,%edx
  801d9a:	72 06                	jb     801da2 <__udivdi3+0x62>
  801d9c:	31 c0                	xor    %eax,%eax
  801d9e:	39 eb                	cmp    %ebp,%ebx
  801da0:	77 de                	ja     801d80 <__udivdi3+0x40>
  801da2:	b8 01 00 00 00       	mov    $0x1,%eax
  801da7:	eb d7                	jmp    801d80 <__udivdi3+0x40>
  801da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801db0:	89 d9                	mov    %ebx,%ecx
  801db2:	85 db                	test   %ebx,%ebx
  801db4:	75 0b                	jne    801dc1 <__udivdi3+0x81>
  801db6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbb:	31 d2                	xor    %edx,%edx
  801dbd:	f7 f3                	div    %ebx
  801dbf:	89 c1                	mov    %eax,%ecx
  801dc1:	31 d2                	xor    %edx,%edx
  801dc3:	89 f0                	mov    %esi,%eax
  801dc5:	f7 f1                	div    %ecx
  801dc7:	89 c6                	mov    %eax,%esi
  801dc9:	89 e8                	mov    %ebp,%eax
  801dcb:	89 f7                	mov    %esi,%edi
  801dcd:	f7 f1                	div    %ecx
  801dcf:	89 fa                	mov    %edi,%edx
  801dd1:	83 c4 1c             	add    $0x1c,%esp
  801dd4:	5b                   	pop    %ebx
  801dd5:	5e                   	pop    %esi
  801dd6:	5f                   	pop    %edi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    
  801dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801de0:	89 f9                	mov    %edi,%ecx
  801de2:	b8 20 00 00 00       	mov    $0x20,%eax
  801de7:	29 f8                	sub    %edi,%eax
  801de9:	d3 e2                	shl    %cl,%edx
  801deb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801def:	89 c1                	mov    %eax,%ecx
  801df1:	89 da                	mov    %ebx,%edx
  801df3:	d3 ea                	shr    %cl,%edx
  801df5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801df9:	09 d1                	or     %edx,%ecx
  801dfb:	89 f2                	mov    %esi,%edx
  801dfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e01:	89 f9                	mov    %edi,%ecx
  801e03:	d3 e3                	shl    %cl,%ebx
  801e05:	89 c1                	mov    %eax,%ecx
  801e07:	d3 ea                	shr    %cl,%edx
  801e09:	89 f9                	mov    %edi,%ecx
  801e0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e0f:	89 eb                	mov    %ebp,%ebx
  801e11:	d3 e6                	shl    %cl,%esi
  801e13:	89 c1                	mov    %eax,%ecx
  801e15:	d3 eb                	shr    %cl,%ebx
  801e17:	09 de                	or     %ebx,%esi
  801e19:	89 f0                	mov    %esi,%eax
  801e1b:	f7 74 24 08          	divl   0x8(%esp)
  801e1f:	89 d6                	mov    %edx,%esi
  801e21:	89 c3                	mov    %eax,%ebx
  801e23:	f7 64 24 0c          	mull   0xc(%esp)
  801e27:	39 d6                	cmp    %edx,%esi
  801e29:	72 15                	jb     801e40 <__udivdi3+0x100>
  801e2b:	89 f9                	mov    %edi,%ecx
  801e2d:	d3 e5                	shl    %cl,%ebp
  801e2f:	39 c5                	cmp    %eax,%ebp
  801e31:	73 04                	jae    801e37 <__udivdi3+0xf7>
  801e33:	39 d6                	cmp    %edx,%esi
  801e35:	74 09                	je     801e40 <__udivdi3+0x100>
  801e37:	89 d8                	mov    %ebx,%eax
  801e39:	31 ff                	xor    %edi,%edi
  801e3b:	e9 40 ff ff ff       	jmp    801d80 <__udivdi3+0x40>
  801e40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e43:	31 ff                	xor    %edi,%edi
  801e45:	e9 36 ff ff ff       	jmp    801d80 <__udivdi3+0x40>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	66 90                	xchg   %ax,%ax
  801e4e:	66 90                	xchg   %ax,%ax

00801e50 <__umoddi3>:
  801e50:	f3 0f 1e fb          	endbr32 
  801e54:	55                   	push   %ebp
  801e55:	57                   	push   %edi
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	83 ec 1c             	sub    $0x1c,%esp
  801e5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e5f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e63:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	75 19                	jne    801e88 <__umoddi3+0x38>
  801e6f:	39 df                	cmp    %ebx,%edi
  801e71:	76 5d                	jbe    801ed0 <__umoddi3+0x80>
  801e73:	89 f0                	mov    %esi,%eax
  801e75:	89 da                	mov    %ebx,%edx
  801e77:	f7 f7                	div    %edi
  801e79:	89 d0                	mov    %edx,%eax
  801e7b:	31 d2                	xor    %edx,%edx
  801e7d:	83 c4 1c             	add    $0x1c,%esp
  801e80:	5b                   	pop    %ebx
  801e81:	5e                   	pop    %esi
  801e82:	5f                   	pop    %edi
  801e83:	5d                   	pop    %ebp
  801e84:	c3                   	ret    
  801e85:	8d 76 00             	lea    0x0(%esi),%esi
  801e88:	89 f2                	mov    %esi,%edx
  801e8a:	39 d8                	cmp    %ebx,%eax
  801e8c:	76 12                	jbe    801ea0 <__umoddi3+0x50>
  801e8e:	89 f0                	mov    %esi,%eax
  801e90:	89 da                	mov    %ebx,%edx
  801e92:	83 c4 1c             	add    $0x1c,%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5f                   	pop    %edi
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    
  801e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ea0:	0f bd e8             	bsr    %eax,%ebp
  801ea3:	83 f5 1f             	xor    $0x1f,%ebp
  801ea6:	75 50                	jne    801ef8 <__umoddi3+0xa8>
  801ea8:	39 d8                	cmp    %ebx,%eax
  801eaa:	0f 82 e0 00 00 00    	jb     801f90 <__umoddi3+0x140>
  801eb0:	89 d9                	mov    %ebx,%ecx
  801eb2:	39 f7                	cmp    %esi,%edi
  801eb4:	0f 86 d6 00 00 00    	jbe    801f90 <__umoddi3+0x140>
  801eba:	89 d0                	mov    %edx,%eax
  801ebc:	89 ca                	mov    %ecx,%edx
  801ebe:	83 c4 1c             	add    $0x1c,%esp
  801ec1:	5b                   	pop    %ebx
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    
  801ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ecd:	8d 76 00             	lea    0x0(%esi),%esi
  801ed0:	89 fd                	mov    %edi,%ebp
  801ed2:	85 ff                	test   %edi,%edi
  801ed4:	75 0b                	jne    801ee1 <__umoddi3+0x91>
  801ed6:	b8 01 00 00 00       	mov    $0x1,%eax
  801edb:	31 d2                	xor    %edx,%edx
  801edd:	f7 f7                	div    %edi
  801edf:	89 c5                	mov    %eax,%ebp
  801ee1:	89 d8                	mov    %ebx,%eax
  801ee3:	31 d2                	xor    %edx,%edx
  801ee5:	f7 f5                	div    %ebp
  801ee7:	89 f0                	mov    %esi,%eax
  801ee9:	f7 f5                	div    %ebp
  801eeb:	89 d0                	mov    %edx,%eax
  801eed:	31 d2                	xor    %edx,%edx
  801eef:	eb 8c                	jmp    801e7d <__umoddi3+0x2d>
  801ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ef8:	89 e9                	mov    %ebp,%ecx
  801efa:	ba 20 00 00 00       	mov    $0x20,%edx
  801eff:	29 ea                	sub    %ebp,%edx
  801f01:	d3 e0                	shl    %cl,%eax
  801f03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f07:	89 d1                	mov    %edx,%ecx
  801f09:	89 f8                	mov    %edi,%eax
  801f0b:	d3 e8                	shr    %cl,%eax
  801f0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f11:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f15:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f19:	09 c1                	or     %eax,%ecx
  801f1b:	89 d8                	mov    %ebx,%eax
  801f1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f21:	89 e9                	mov    %ebp,%ecx
  801f23:	d3 e7                	shl    %cl,%edi
  801f25:	89 d1                	mov    %edx,%ecx
  801f27:	d3 e8                	shr    %cl,%eax
  801f29:	89 e9                	mov    %ebp,%ecx
  801f2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f2f:	d3 e3                	shl    %cl,%ebx
  801f31:	89 c7                	mov    %eax,%edi
  801f33:	89 d1                	mov    %edx,%ecx
  801f35:	89 f0                	mov    %esi,%eax
  801f37:	d3 e8                	shr    %cl,%eax
  801f39:	89 e9                	mov    %ebp,%ecx
  801f3b:	89 fa                	mov    %edi,%edx
  801f3d:	d3 e6                	shl    %cl,%esi
  801f3f:	09 d8                	or     %ebx,%eax
  801f41:	f7 74 24 08          	divl   0x8(%esp)
  801f45:	89 d1                	mov    %edx,%ecx
  801f47:	89 f3                	mov    %esi,%ebx
  801f49:	f7 64 24 0c          	mull   0xc(%esp)
  801f4d:	89 c6                	mov    %eax,%esi
  801f4f:	89 d7                	mov    %edx,%edi
  801f51:	39 d1                	cmp    %edx,%ecx
  801f53:	72 06                	jb     801f5b <__umoddi3+0x10b>
  801f55:	75 10                	jne    801f67 <__umoddi3+0x117>
  801f57:	39 c3                	cmp    %eax,%ebx
  801f59:	73 0c                	jae    801f67 <__umoddi3+0x117>
  801f5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f63:	89 d7                	mov    %edx,%edi
  801f65:	89 c6                	mov    %eax,%esi
  801f67:	89 ca                	mov    %ecx,%edx
  801f69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f6e:	29 f3                	sub    %esi,%ebx
  801f70:	19 fa                	sbb    %edi,%edx
  801f72:	89 d0                	mov    %edx,%eax
  801f74:	d3 e0                	shl    %cl,%eax
  801f76:	89 e9                	mov    %ebp,%ecx
  801f78:	d3 eb                	shr    %cl,%ebx
  801f7a:	d3 ea                	shr    %cl,%edx
  801f7c:	09 d8                	or     %ebx,%eax
  801f7e:	83 c4 1c             	add    $0x1c,%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5f                   	pop    %edi
  801f84:	5d                   	pop    %ebp
  801f85:	c3                   	ret    
  801f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f8d:	8d 76 00             	lea    0x0(%esi),%esi
  801f90:	29 fe                	sub    %edi,%esi
  801f92:	19 c3                	sbb    %eax,%ebx
  801f94:	89 f2                	mov    %esi,%edx
  801f96:	89 d9                	mov    %ebx,%ecx
  801f98:	e9 1d ff ff ff       	jmp    801eba <__umoddi3+0x6a>
