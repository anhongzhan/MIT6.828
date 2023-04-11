
obj/user/buggyhello:     file format elf32-i386


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
  80002c:	e8 1a 00 00 00       	call   80004b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  80003d:	6a 01                	push   $0x1
  80003f:	6a 01                	push   $0x1
  800041:	e8 65 00 00 00       	call   8000ab <sys_cputs>
}
  800046:	83 c4 10             	add    $0x10,%esp
  800049:	c9                   	leave  
  80004a:	c3                   	ret    

0080004b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004b:	f3 0f 1e fb          	endbr32 
  80004f:	55                   	push   %ebp
  800050:	89 e5                	mov    %esp,%ebp
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800057:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005a:	e8 d6 00 00 00       	call   800135 <sys_getenvid>
  80005f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800064:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800067:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006c:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800071:	85 db                	test   %ebx,%ebx
  800073:	7e 07                	jle    80007c <libmain+0x31>
		binaryname = argv[0];
  800075:	8b 06                	mov    (%esi),%eax
  800077:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	e8 ad ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800086:	e8 0a 00 00 00       	call   800095 <exit>
}
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800091:	5b                   	pop    %ebx
  800092:	5e                   	pop    %esi
  800093:	5d                   	pop    %ebp
  800094:	c3                   	ret    

00800095 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800095:	f3 0f 1e fb          	endbr32 
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80009f:	6a 00                	push   $0x0
  8000a1:	e8 4a 00 00 00       	call   8000f0 <sys_env_destroy>
}
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	c9                   	leave  
  8000aa:	c3                   	ret    

008000ab <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ab:	f3 0f 1e fb          	endbr32 
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	57                   	push   %edi
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c0:	89 c3                	mov    %eax,%ebx
  8000c2:	89 c7                	mov    %eax,%edi
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5f                   	pop    %edi
  8000cb:	5d                   	pop    %ebp
  8000cc:	c3                   	ret    

008000cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cd:	f3 0f 1e fb          	endbr32 
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	57                   	push   %edi
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8000dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	89 d3                	mov    %edx,%ebx
  8000e5:	89 d7                	mov    %edx,%edi
  8000e7:	89 d6                	mov    %edx,%esi
  8000e9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000eb:	5b                   	pop    %ebx
  8000ec:	5e                   	pop    %esi
  8000ed:	5f                   	pop    %edi
  8000ee:	5d                   	pop    %ebp
  8000ef:	c3                   	ret    

008000f0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f0:	f3 0f 1e fb          	endbr32 
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800102:	8b 55 08             	mov    0x8(%ebp),%edx
  800105:	b8 03 00 00 00       	mov    $0x3,%eax
  80010a:	89 cb                	mov    %ecx,%ebx
  80010c:	89 cf                	mov    %ecx,%edi
  80010e:	89 ce                	mov    %ecx,%esi
  800110:	cd 30                	int    $0x30
	if(check && ret > 0)
  800112:	85 c0                	test   %eax,%eax
  800114:	7f 08                	jg     80011e <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800116:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800119:	5b                   	pop    %ebx
  80011a:	5e                   	pop    %esi
  80011b:	5f                   	pop    %edi
  80011c:	5d                   	pop    %ebp
  80011d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	6a 03                	push   $0x3
  800124:	68 2a 10 80 00       	push   $0x80102a
  800129:	6a 23                	push   $0x23
  80012b:	68 47 10 80 00       	push   $0x801047
  800130:	e8 11 02 00 00       	call   800346 <_panic>

00800135 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800135:	f3 0f 1e fb          	endbr32 
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	57                   	push   %edi
  80013d:	56                   	push   %esi
  80013e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013f:	ba 00 00 00 00       	mov    $0x0,%edx
  800144:	b8 02 00 00 00       	mov    $0x2,%eax
  800149:	89 d1                	mov    %edx,%ecx
  80014b:	89 d3                	mov    %edx,%ebx
  80014d:	89 d7                	mov    %edx,%edi
  80014f:	89 d6                	mov    %edx,%esi
  800151:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5f                   	pop    %edi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <sys_yield>:

void
sys_yield(void)
{
  800158:	f3 0f 1e fb          	endbr32 
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	57                   	push   %edi
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
	asm volatile("int %1\n"
  800162:	ba 00 00 00 00       	mov    $0x0,%edx
  800167:	b8 0a 00 00 00       	mov    $0xa,%eax
  80016c:	89 d1                	mov    %edx,%ecx
  80016e:	89 d3                	mov    %edx,%ebx
  800170:	89 d7                	mov    %edx,%edi
  800172:	89 d6                	mov    %edx,%esi
  800174:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5f                   	pop    %edi
  800179:	5d                   	pop    %ebp
  80017a:	c3                   	ret    

0080017b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80017b:	f3 0f 1e fb          	endbr32 
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	57                   	push   %edi
  800183:	56                   	push   %esi
  800184:	53                   	push   %ebx
  800185:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800188:	be 00 00 00 00       	mov    $0x0,%esi
  80018d:	8b 55 08             	mov    0x8(%ebp),%edx
  800190:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800193:	b8 04 00 00 00       	mov    $0x4,%eax
  800198:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019b:	89 f7                	mov    %esi,%edi
  80019d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019f:	85 c0                	test   %eax,%eax
  8001a1:	7f 08                	jg     8001ab <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a6:	5b                   	pop    %ebx
  8001a7:	5e                   	pop    %esi
  8001a8:	5f                   	pop    %edi
  8001a9:	5d                   	pop    %ebp
  8001aa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	6a 04                	push   $0x4
  8001b1:	68 2a 10 80 00       	push   $0x80102a
  8001b6:	6a 23                	push   $0x23
  8001b8:	68 47 10 80 00       	push   $0x801047
  8001bd:	e8 84 01 00 00       	call   800346 <_panic>

008001c2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c2:	f3 0f 1e fb          	endbr32 
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	57                   	push   %edi
  8001ca:	56                   	push   %esi
  8001cb:	53                   	push   %ebx
  8001cc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d5:	b8 05 00 00 00       	mov    $0x5,%eax
  8001da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001dd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001e0:	8b 75 18             	mov    0x18(%ebp),%esi
  8001e3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e5:	85 c0                	test   %eax,%eax
  8001e7:	7f 08                	jg     8001f1 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ec:	5b                   	pop    %ebx
  8001ed:	5e                   	pop    %esi
  8001ee:	5f                   	pop    %edi
  8001ef:	5d                   	pop    %ebp
  8001f0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f1:	83 ec 0c             	sub    $0xc,%esp
  8001f4:	50                   	push   %eax
  8001f5:	6a 05                	push   $0x5
  8001f7:	68 2a 10 80 00       	push   $0x80102a
  8001fc:	6a 23                	push   $0x23
  8001fe:	68 47 10 80 00       	push   $0x801047
  800203:	e8 3e 01 00 00       	call   800346 <_panic>

00800208 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800208:	f3 0f 1e fb          	endbr32 
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800215:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021a:	8b 55 08             	mov    0x8(%ebp),%edx
  80021d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800220:	b8 06 00 00 00       	mov    $0x6,%eax
  800225:	89 df                	mov    %ebx,%edi
  800227:	89 de                	mov    %ebx,%esi
  800229:	cd 30                	int    $0x30
	if(check && ret > 0)
  80022b:	85 c0                	test   %eax,%eax
  80022d:	7f 08                	jg     800237 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80022f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800232:	5b                   	pop    %ebx
  800233:	5e                   	pop    %esi
  800234:	5f                   	pop    %edi
  800235:	5d                   	pop    %ebp
  800236:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	50                   	push   %eax
  80023b:	6a 06                	push   $0x6
  80023d:	68 2a 10 80 00       	push   $0x80102a
  800242:	6a 23                	push   $0x23
  800244:	68 47 10 80 00       	push   $0x801047
  800249:	e8 f8 00 00 00       	call   800346 <_panic>

0080024e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80024e:	f3 0f 1e fb          	endbr32 
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	57                   	push   %edi
  800256:	56                   	push   %esi
  800257:	53                   	push   %ebx
  800258:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800260:	8b 55 08             	mov    0x8(%ebp),%edx
  800263:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800266:	b8 08 00 00 00       	mov    $0x8,%eax
  80026b:	89 df                	mov    %ebx,%edi
  80026d:	89 de                	mov    %ebx,%esi
  80026f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800271:	85 c0                	test   %eax,%eax
  800273:	7f 08                	jg     80027d <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800275:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	50                   	push   %eax
  800281:	6a 08                	push   $0x8
  800283:	68 2a 10 80 00       	push   $0x80102a
  800288:	6a 23                	push   $0x23
  80028a:	68 47 10 80 00       	push   $0x801047
  80028f:	e8 b2 00 00 00       	call   800346 <_panic>

00800294 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800294:	f3 0f 1e fb          	endbr32 
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	57                   	push   %edi
  80029c:	56                   	push   %esi
  80029d:	53                   	push   %ebx
  80029e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ac:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b1:	89 df                	mov    %ebx,%edi
  8002b3:	89 de                	mov    %ebx,%esi
  8002b5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b7:	85 c0                	test   %eax,%eax
  8002b9:	7f 08                	jg     8002c3 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002be:	5b                   	pop    %ebx
  8002bf:	5e                   	pop    %esi
  8002c0:	5f                   	pop    %edi
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	50                   	push   %eax
  8002c7:	6a 09                	push   $0x9
  8002c9:	68 2a 10 80 00       	push   $0x80102a
  8002ce:	6a 23                	push   $0x23
  8002d0:	68 47 10 80 00       	push   $0x801047
  8002d5:	e8 6c 00 00 00       	call   800346 <_panic>

008002da <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002da:	f3 0f 1e fb          	endbr32 
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ea:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002ef:	be 00 00 00 00       	mov    $0x0,%esi
  8002f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fa:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002fc:	5b                   	pop    %ebx
  8002fd:	5e                   	pop    %esi
  8002fe:	5f                   	pop    %edi
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    

00800301 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800301:	f3 0f 1e fb          	endbr32 
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	57                   	push   %edi
  800309:	56                   	push   %esi
  80030a:	53                   	push   %ebx
  80030b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800313:	8b 55 08             	mov    0x8(%ebp),%edx
  800316:	b8 0c 00 00 00       	mov    $0xc,%eax
  80031b:	89 cb                	mov    %ecx,%ebx
  80031d:	89 cf                	mov    %ecx,%edi
  80031f:	89 ce                	mov    %ecx,%esi
  800321:	cd 30                	int    $0x30
	if(check && ret > 0)
  800323:	85 c0                	test   %eax,%eax
  800325:	7f 08                	jg     80032f <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032a:	5b                   	pop    %ebx
  80032b:	5e                   	pop    %esi
  80032c:	5f                   	pop    %edi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	50                   	push   %eax
  800333:	6a 0c                	push   $0xc
  800335:	68 2a 10 80 00       	push   $0x80102a
  80033a:	6a 23                	push   $0x23
  80033c:	68 47 10 80 00       	push   $0x801047
  800341:	e8 00 00 00 00       	call   800346 <_panic>

00800346 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800346:	f3 0f 1e fb          	endbr32 
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	56                   	push   %esi
  80034e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80034f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800352:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800358:	e8 d8 fd ff ff       	call   800135 <sys_getenvid>
  80035d:	83 ec 0c             	sub    $0xc,%esp
  800360:	ff 75 0c             	pushl  0xc(%ebp)
  800363:	ff 75 08             	pushl  0x8(%ebp)
  800366:	56                   	push   %esi
  800367:	50                   	push   %eax
  800368:	68 58 10 80 00       	push   $0x801058
  80036d:	e8 bb 00 00 00       	call   80042d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800372:	83 c4 18             	add    $0x18,%esp
  800375:	53                   	push   %ebx
  800376:	ff 75 10             	pushl  0x10(%ebp)
  800379:	e8 5a 00 00 00       	call   8003d8 <vcprintf>
	cprintf("\n");
  80037e:	c7 04 24 7b 10 80 00 	movl   $0x80107b,(%esp)
  800385:	e8 a3 00 00 00       	call   80042d <cprintf>
  80038a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80038d:	cc                   	int3   
  80038e:	eb fd                	jmp    80038d <_panic+0x47>

00800390 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800390:	f3 0f 1e fb          	endbr32 
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	53                   	push   %ebx
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039e:	8b 13                	mov    (%ebx),%edx
  8003a0:	8d 42 01             	lea    0x1(%edx),%eax
  8003a3:	89 03                	mov    %eax,(%ebx)
  8003a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b1:	74 09                	je     8003bc <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003b3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ba:	c9                   	leave  
  8003bb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	68 ff 00 00 00       	push   $0xff
  8003c4:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 de fc ff ff       	call   8000ab <sys_cputs>
		b->idx = 0;
  8003cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	eb db                	jmp    8003b3 <putch+0x23>

008003d8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d8:	f3 0f 1e fb          	endbr32 
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ec:	00 00 00 
	b.cnt = 0;
  8003ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	68 90 03 80 00       	push   $0x800390
  80040b:	e8 20 01 00 00       	call   800530 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800410:	83 c4 08             	add    $0x8,%esp
  800413:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800419:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80041f:	50                   	push   %eax
  800420:	e8 86 fc ff ff       	call   8000ab <sys_cputs>

	return b.cnt;
}
  800425:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80042b:	c9                   	leave  
  80042c:	c3                   	ret    

0080042d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80042d:	f3 0f 1e fb          	endbr32 
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800437:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80043a:	50                   	push   %eax
  80043b:	ff 75 08             	pushl  0x8(%ebp)
  80043e:	e8 95 ff ff ff       	call   8003d8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	57                   	push   %edi
  800449:	56                   	push   %esi
  80044a:	53                   	push   %ebx
  80044b:	83 ec 1c             	sub    $0x1c,%esp
  80044e:	89 c7                	mov    %eax,%edi
  800450:	89 d6                	mov    %edx,%esi
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	8b 55 0c             	mov    0xc(%ebp),%edx
  800458:	89 d1                	mov    %edx,%ecx
  80045a:	89 c2                	mov    %eax,%edx
  80045c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800462:	8b 45 10             	mov    0x10(%ebp),%eax
  800465:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800468:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800472:	39 c2                	cmp    %eax,%edx
  800474:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800477:	72 3e                	jb     8004b7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	ff 75 18             	pushl  0x18(%ebp)
  80047f:	83 eb 01             	sub    $0x1,%ebx
  800482:	53                   	push   %ebx
  800483:	50                   	push   %eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	ff 75 e4             	pushl  -0x1c(%ebp)
  80048a:	ff 75 e0             	pushl  -0x20(%ebp)
  80048d:	ff 75 dc             	pushl  -0x24(%ebp)
  800490:	ff 75 d8             	pushl  -0x28(%ebp)
  800493:	e8 18 09 00 00       	call   800db0 <__udivdi3>
  800498:	83 c4 18             	add    $0x18,%esp
  80049b:	52                   	push   %edx
  80049c:	50                   	push   %eax
  80049d:	89 f2                	mov    %esi,%edx
  80049f:	89 f8                	mov    %edi,%eax
  8004a1:	e8 9f ff ff ff       	call   800445 <printnum>
  8004a6:	83 c4 20             	add    $0x20,%esp
  8004a9:	eb 13                	jmp    8004be <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	56                   	push   %esi
  8004af:	ff 75 18             	pushl  0x18(%ebp)
  8004b2:	ff d7                	call   *%edi
  8004b4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004b7:	83 eb 01             	sub    $0x1,%ebx
  8004ba:	85 db                	test   %ebx,%ebx
  8004bc:	7f ed                	jg     8004ab <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	56                   	push   %esi
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8004ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d1:	e8 ea 09 00 00       	call   800ec0 <__umoddi3>
  8004d6:	83 c4 14             	add    $0x14,%esp
  8004d9:	0f be 80 7d 10 80 00 	movsbl 0x80107d(%eax),%eax
  8004e0:	50                   	push   %eax
  8004e1:	ff d7                	call   *%edi
}
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e9:	5b                   	pop    %ebx
  8004ea:	5e                   	pop    %esi
  8004eb:	5f                   	pop    %edi
  8004ec:	5d                   	pop    %ebp
  8004ed:	c3                   	ret    

008004ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ee:	f3 0f 1e fb          	endbr32 
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004fc:	8b 10                	mov    (%eax),%edx
  8004fe:	3b 50 04             	cmp    0x4(%eax),%edx
  800501:	73 0a                	jae    80050d <sprintputch+0x1f>
		*b->buf++ = ch;
  800503:	8d 4a 01             	lea    0x1(%edx),%ecx
  800506:	89 08                	mov    %ecx,(%eax)
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	88 02                	mov    %al,(%edx)
}
  80050d:	5d                   	pop    %ebp
  80050e:	c3                   	ret    

0080050f <printfmt>:
{
  80050f:	f3 0f 1e fb          	endbr32 
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800519:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80051c:	50                   	push   %eax
  80051d:	ff 75 10             	pushl  0x10(%ebp)
  800520:	ff 75 0c             	pushl  0xc(%ebp)
  800523:	ff 75 08             	pushl  0x8(%ebp)
  800526:	e8 05 00 00 00       	call   800530 <vprintfmt>
}
  80052b:	83 c4 10             	add    $0x10,%esp
  80052e:	c9                   	leave  
  80052f:	c3                   	ret    

00800530 <vprintfmt>:
{
  800530:	f3 0f 1e fb          	endbr32 
  800534:	55                   	push   %ebp
  800535:	89 e5                	mov    %esp,%ebp
  800537:	57                   	push   %edi
  800538:	56                   	push   %esi
  800539:	53                   	push   %ebx
  80053a:	83 ec 3c             	sub    $0x3c,%esp
  80053d:	8b 75 08             	mov    0x8(%ebp),%esi
  800540:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800543:	8b 7d 10             	mov    0x10(%ebp),%edi
  800546:	e9 8e 03 00 00       	jmp    8008d9 <vprintfmt+0x3a9>
		padc = ' ';
  80054b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80054f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800556:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80055d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800564:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800569:	8d 47 01             	lea    0x1(%edi),%eax
  80056c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80056f:	0f b6 17             	movzbl (%edi),%edx
  800572:	8d 42 dd             	lea    -0x23(%edx),%eax
  800575:	3c 55                	cmp    $0x55,%al
  800577:	0f 87 df 03 00 00    	ja     80095c <vprintfmt+0x42c>
  80057d:	0f b6 c0             	movzbl %al,%eax
  800580:	3e ff 24 85 40 11 80 	notrack jmp *0x801140(,%eax,4)
  800587:	00 
  800588:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80058b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80058f:	eb d8                	jmp    800569 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800591:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800594:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800598:	eb cf                	jmp    800569 <vprintfmt+0x39>
  80059a:	0f b6 d2             	movzbl %dl,%edx
  80059d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005a8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005ab:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005af:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005b2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005b5:	83 f9 09             	cmp    $0x9,%ecx
  8005b8:	77 55                	ja     80060f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005ba:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005bd:	eb e9                	jmp    8005a8 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d7:	79 90                	jns    800569 <vprintfmt+0x39>
				width = precision, precision = -1;
  8005d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005e6:	eb 81                	jmp    800569 <vprintfmt+0x39>
  8005e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005eb:	85 c0                	test   %eax,%eax
  8005ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f2:	0f 49 d0             	cmovns %eax,%edx
  8005f5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005fb:	e9 69 ff ff ff       	jmp    800569 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800600:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800603:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80060a:	e9 5a ff ff ff       	jmp    800569 <vprintfmt+0x39>
  80060f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800612:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800615:	eb bc                	jmp    8005d3 <vprintfmt+0xa3>
			lflag++;
  800617:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80061a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80061d:	e9 47 ff ff ff       	jmp    800569 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8d 78 04             	lea    0x4(%eax),%edi
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	53                   	push   %ebx
  80062c:	ff 30                	pushl  (%eax)
  80062e:	ff d6                	call   *%esi
			break;
  800630:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800633:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800636:	e9 9b 02 00 00       	jmp    8008d6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8d 78 04             	lea    0x4(%eax),%edi
  800641:	8b 00                	mov    (%eax),%eax
  800643:	99                   	cltd   
  800644:	31 d0                	xor    %edx,%eax
  800646:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800648:	83 f8 08             	cmp    $0x8,%eax
  80064b:	7f 23                	jg     800670 <vprintfmt+0x140>
  80064d:	8b 14 85 a0 12 80 00 	mov    0x8012a0(,%eax,4),%edx
  800654:	85 d2                	test   %edx,%edx
  800656:	74 18                	je     800670 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800658:	52                   	push   %edx
  800659:	68 9e 10 80 00       	push   $0x80109e
  80065e:	53                   	push   %ebx
  80065f:	56                   	push   %esi
  800660:	e8 aa fe ff ff       	call   80050f <printfmt>
  800665:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800668:	89 7d 14             	mov    %edi,0x14(%ebp)
  80066b:	e9 66 02 00 00       	jmp    8008d6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800670:	50                   	push   %eax
  800671:	68 95 10 80 00       	push   $0x801095
  800676:	53                   	push   %ebx
  800677:	56                   	push   %esi
  800678:	e8 92 fe ff ff       	call   80050f <printfmt>
  80067d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800680:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800683:	e9 4e 02 00 00       	jmp    8008d6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800696:	85 d2                	test   %edx,%edx
  800698:	b8 8e 10 80 00       	mov    $0x80108e,%eax
  80069d:	0f 45 c2             	cmovne %edx,%eax
  8006a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a7:	7e 06                	jle    8006af <vprintfmt+0x17f>
  8006a9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006ad:	75 0d                	jne    8006bc <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006b2:	89 c7                	mov    %eax,%edi
  8006b4:	03 45 e0             	add    -0x20(%ebp),%eax
  8006b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ba:	eb 55                	jmp    800711 <vprintfmt+0x1e1>
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8006c2:	ff 75 cc             	pushl  -0x34(%ebp)
  8006c5:	e8 46 03 00 00       	call   800a10 <strnlen>
  8006ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006cd:	29 c2                	sub    %eax,%edx
  8006cf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006d7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006de:	85 ff                	test   %edi,%edi
  8006e0:	7e 11                	jle    8006f3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	53                   	push   %ebx
  8006e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006eb:	83 ef 01             	sub    $0x1,%edi
  8006ee:	83 c4 10             	add    $0x10,%esp
  8006f1:	eb eb                	jmp    8006de <vprintfmt+0x1ae>
  8006f3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006f6:	85 d2                	test   %edx,%edx
  8006f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fd:	0f 49 c2             	cmovns %edx,%eax
  800700:	29 c2                	sub    %eax,%edx
  800702:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800705:	eb a8                	jmp    8006af <vprintfmt+0x17f>
					putch(ch, putdat);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	53                   	push   %ebx
  80070b:	52                   	push   %edx
  80070c:	ff d6                	call   *%esi
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800714:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800716:	83 c7 01             	add    $0x1,%edi
  800719:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80071d:	0f be d0             	movsbl %al,%edx
  800720:	85 d2                	test   %edx,%edx
  800722:	74 4b                	je     80076f <vprintfmt+0x23f>
  800724:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800728:	78 06                	js     800730 <vprintfmt+0x200>
  80072a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80072e:	78 1e                	js     80074e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800730:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800734:	74 d1                	je     800707 <vprintfmt+0x1d7>
  800736:	0f be c0             	movsbl %al,%eax
  800739:	83 e8 20             	sub    $0x20,%eax
  80073c:	83 f8 5e             	cmp    $0x5e,%eax
  80073f:	76 c6                	jbe    800707 <vprintfmt+0x1d7>
					putch('?', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	53                   	push   %ebx
  800745:	6a 3f                	push   $0x3f
  800747:	ff d6                	call   *%esi
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	eb c3                	jmp    800711 <vprintfmt+0x1e1>
  80074e:	89 cf                	mov    %ecx,%edi
  800750:	eb 0e                	jmp    800760 <vprintfmt+0x230>
				putch(' ', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 20                	push   $0x20
  800758:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80075a:	83 ef 01             	sub    $0x1,%edi
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	85 ff                	test   %edi,%edi
  800762:	7f ee                	jg     800752 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800764:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
  80076a:	e9 67 01 00 00       	jmp    8008d6 <vprintfmt+0x3a6>
  80076f:	89 cf                	mov    %ecx,%edi
  800771:	eb ed                	jmp    800760 <vprintfmt+0x230>
	if (lflag >= 2)
  800773:	83 f9 01             	cmp    $0x1,%ecx
  800776:	7f 1b                	jg     800793 <vprintfmt+0x263>
	else if (lflag)
  800778:	85 c9                	test   %ecx,%ecx
  80077a:	74 63                	je     8007df <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800784:	99                   	cltd   
  800785:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 40 04             	lea    0x4(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
  800791:	eb 17                	jmp    8007aa <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 50 04             	mov    0x4(%eax),%edx
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8d 40 08             	lea    0x8(%eax),%eax
  8007a7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007b0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007b5:	85 c9                	test   %ecx,%ecx
  8007b7:	0f 89 ff 00 00 00    	jns    8008bc <vprintfmt+0x38c>
				putch('-', putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	53                   	push   %ebx
  8007c1:	6a 2d                	push   $0x2d
  8007c3:	ff d6                	call   *%esi
				num = -(long long) num;
  8007c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007c8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007cb:	f7 da                	neg    %edx
  8007cd:	83 d1 00             	adc    $0x0,%ecx
  8007d0:	f7 d9                	neg    %ecx
  8007d2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007da:	e9 dd 00 00 00       	jmp    8008bc <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e7:	99                   	cltd   
  8007e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8d 40 04             	lea    0x4(%eax),%eax
  8007f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f4:	eb b4                	jmp    8007aa <vprintfmt+0x27a>
	if (lflag >= 2)
  8007f6:	83 f9 01             	cmp    $0x1,%ecx
  8007f9:	7f 1e                	jg     800819 <vprintfmt+0x2e9>
	else if (lflag)
  8007fb:	85 c9                	test   %ecx,%ecx
  8007fd:	74 32                	je     800831 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 10                	mov    (%eax),%edx
  800804:	b9 00 00 00 00       	mov    $0x0,%ecx
  800809:	8d 40 04             	lea    0x4(%eax),%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800814:	e9 a3 00 00 00       	jmp    8008bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8b 10                	mov    (%eax),%edx
  80081e:	8b 48 04             	mov    0x4(%eax),%ecx
  800821:	8d 40 08             	lea    0x8(%eax),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800827:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80082c:	e9 8b 00 00 00       	jmp    8008bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 10                	mov    (%eax),%edx
  800836:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083b:	8d 40 04             	lea    0x4(%eax),%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800841:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800846:	eb 74                	jmp    8008bc <vprintfmt+0x38c>
	if (lflag >= 2)
  800848:	83 f9 01             	cmp    $0x1,%ecx
  80084b:	7f 1b                	jg     800868 <vprintfmt+0x338>
	else if (lflag)
  80084d:	85 c9                	test   %ecx,%ecx
  80084f:	74 2c                	je     80087d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 10                	mov    (%eax),%edx
  800856:	b9 00 00 00 00       	mov    $0x0,%ecx
  80085b:	8d 40 04             	lea    0x4(%eax),%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800861:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800866:	eb 54                	jmp    8008bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 10                	mov    (%eax),%edx
  80086d:	8b 48 04             	mov    0x4(%eax),%ecx
  800870:	8d 40 08             	lea    0x8(%eax),%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800876:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80087b:	eb 3f                	jmp    8008bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	8b 10                	mov    (%eax),%edx
  800882:	b9 00 00 00 00       	mov    $0x0,%ecx
  800887:	8d 40 04             	lea    0x4(%eax),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80088d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800892:	eb 28                	jmp    8008bc <vprintfmt+0x38c>
			putch('0', putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	53                   	push   %ebx
  800898:	6a 30                	push   $0x30
  80089a:	ff d6                	call   *%esi
			putch('x', putdat);
  80089c:	83 c4 08             	add    $0x8,%esp
  80089f:	53                   	push   %ebx
  8008a0:	6a 78                	push   $0x78
  8008a2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	8b 10                	mov    (%eax),%edx
  8008a9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008ae:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b1:	8d 40 04             	lea    0x4(%eax),%eax
  8008b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008bc:	83 ec 0c             	sub    $0xc,%esp
  8008bf:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008c3:	57                   	push   %edi
  8008c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	51                   	push   %ecx
  8008c9:	52                   	push   %edx
  8008ca:	89 da                	mov    %ebx,%edx
  8008cc:	89 f0                	mov    %esi,%eax
  8008ce:	e8 72 fb ff ff       	call   800445 <printnum>
			break;
  8008d3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d9:	83 c7 01             	add    $0x1,%edi
  8008dc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e0:	83 f8 25             	cmp    $0x25,%eax
  8008e3:	0f 84 62 fc ff ff    	je     80054b <vprintfmt+0x1b>
			if (ch == '\0')
  8008e9:	85 c0                	test   %eax,%eax
  8008eb:	0f 84 8b 00 00 00    	je     80097c <vprintfmt+0x44c>
			putch(ch, putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	53                   	push   %ebx
  8008f5:	50                   	push   %eax
  8008f6:	ff d6                	call   *%esi
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	eb dc                	jmp    8008d9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008fd:	83 f9 01             	cmp    $0x1,%ecx
  800900:	7f 1b                	jg     80091d <vprintfmt+0x3ed>
	else if (lflag)
  800902:	85 c9                	test   %ecx,%ecx
  800904:	74 2c                	je     800932 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	8b 10                	mov    (%eax),%edx
  80090b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800910:	8d 40 04             	lea    0x4(%eax),%eax
  800913:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800916:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80091b:	eb 9f                	jmp    8008bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8b 10                	mov    (%eax),%edx
  800922:	8b 48 04             	mov    0x4(%eax),%ecx
  800925:	8d 40 08             	lea    0x8(%eax),%eax
  800928:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800930:	eb 8a                	jmp    8008bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	8b 10                	mov    (%eax),%edx
  800937:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093c:	8d 40 04             	lea    0x4(%eax),%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800942:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800947:	e9 70 ff ff ff       	jmp    8008bc <vprintfmt+0x38c>
			putch(ch, putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	53                   	push   %ebx
  800950:	6a 25                	push   $0x25
  800952:	ff d6                	call   *%esi
			break;
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	e9 7a ff ff ff       	jmp    8008d6 <vprintfmt+0x3a6>
			putch('%', putdat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	53                   	push   %ebx
  800960:	6a 25                	push   $0x25
  800962:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	89 f8                	mov    %edi,%eax
  800969:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80096d:	74 05                	je     800974 <vprintfmt+0x444>
  80096f:	83 e8 01             	sub    $0x1,%eax
  800972:	eb f5                	jmp    800969 <vprintfmt+0x439>
  800974:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800977:	e9 5a ff ff ff       	jmp    8008d6 <vprintfmt+0x3a6>
}
  80097c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80097f:	5b                   	pop    %ebx
  800980:	5e                   	pop    %esi
  800981:	5f                   	pop    %edi
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800984:	f3 0f 1e fb          	endbr32 
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	83 ec 18             	sub    $0x18,%esp
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800994:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800997:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80099b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a5:	85 c0                	test   %eax,%eax
  8009a7:	74 26                	je     8009cf <vsnprintf+0x4b>
  8009a9:	85 d2                	test   %edx,%edx
  8009ab:	7e 22                	jle    8009cf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ad:	ff 75 14             	pushl  0x14(%ebp)
  8009b0:	ff 75 10             	pushl  0x10(%ebp)
  8009b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b6:	50                   	push   %eax
  8009b7:	68 ee 04 80 00       	push   $0x8004ee
  8009bc:	e8 6f fb ff ff       	call   800530 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ca:	83 c4 10             	add    $0x10,%esp
}
  8009cd:	c9                   	leave  
  8009ce:	c3                   	ret    
		return -E_INVAL;
  8009cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d4:	eb f7                	jmp    8009cd <vsnprintf+0x49>

008009d6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d6:	f3 0f 1e fb          	endbr32 
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e3:	50                   	push   %eax
  8009e4:	ff 75 10             	pushl  0x10(%ebp)
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 92 ff ff ff       	call   800984 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f2:	c9                   	leave  
  8009f3:	c3                   	ret    

008009f4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f4:	f3 0f 1e fb          	endbr32 
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800a03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a07:	74 05                	je     800a0e <strlen+0x1a>
		n++;
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	eb f5                	jmp    800a03 <strlen+0xf>
	return n;
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a10:	f3 0f 1e fb          	endbr32 
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a22:	39 d0                	cmp    %edx,%eax
  800a24:	74 0d                	je     800a33 <strnlen+0x23>
  800a26:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a2a:	74 05                	je     800a31 <strnlen+0x21>
		n++;
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	eb f1                	jmp    800a22 <strnlen+0x12>
  800a31:	89 c2                	mov    %eax,%edx
	return n;
}
  800a33:	89 d0                	mov    %edx,%eax
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a37:	f3 0f 1e fb          	endbr32 
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	53                   	push   %ebx
  800a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a4e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a51:	83 c0 01             	add    $0x1,%eax
  800a54:	84 d2                	test   %dl,%dl
  800a56:	75 f2                	jne    800a4a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a58:	89 c8                	mov    %ecx,%eax
  800a5a:	5b                   	pop    %ebx
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a5d:	f3 0f 1e fb          	endbr32 
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	53                   	push   %ebx
  800a65:	83 ec 10             	sub    $0x10,%esp
  800a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a6b:	53                   	push   %ebx
  800a6c:	e8 83 ff ff ff       	call   8009f4 <strlen>
  800a71:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	01 d8                	add    %ebx,%eax
  800a79:	50                   	push   %eax
  800a7a:	e8 b8 ff ff ff       	call   800a37 <strcpy>
	return dst;
}
  800a7f:	89 d8                	mov    %ebx,%eax
  800a81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a84:	c9                   	leave  
  800a85:	c3                   	ret    

00800a86 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a86:	f3 0f 1e fb          	endbr32 
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	56                   	push   %esi
  800a8e:	53                   	push   %ebx
  800a8f:	8b 75 08             	mov    0x8(%ebp),%esi
  800a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a95:	89 f3                	mov    %esi,%ebx
  800a97:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a9a:	89 f0                	mov    %esi,%eax
  800a9c:	39 d8                	cmp    %ebx,%eax
  800a9e:	74 11                	je     800ab1 <strncpy+0x2b>
		*dst++ = *src;
  800aa0:	83 c0 01             	add    $0x1,%eax
  800aa3:	0f b6 0a             	movzbl (%edx),%ecx
  800aa6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa9:	80 f9 01             	cmp    $0x1,%cl
  800aac:	83 da ff             	sbb    $0xffffffff,%edx
  800aaf:	eb eb                	jmp    800a9c <strncpy+0x16>
	}
	return ret;
}
  800ab1:	89 f0                	mov    %esi,%eax
  800ab3:	5b                   	pop    %ebx
  800ab4:	5e                   	pop    %esi
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab7:	f3 0f 1e fb          	endbr32 
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	56                   	push   %esi
  800abf:	53                   	push   %ebx
  800ac0:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac6:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800acb:	85 d2                	test   %edx,%edx
  800acd:	74 21                	je     800af0 <strlcpy+0x39>
  800acf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ad3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 14                	je     800aed <strlcpy+0x36>
  800ad9:	0f b6 19             	movzbl (%ecx),%ebx
  800adc:	84 db                	test   %bl,%bl
  800ade:	74 0b                	je     800aeb <strlcpy+0x34>
			*dst++ = *src++;
  800ae0:	83 c1 01             	add    $0x1,%ecx
  800ae3:	83 c2 01             	add    $0x1,%edx
  800ae6:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae9:	eb ea                	jmp    800ad5 <strlcpy+0x1e>
  800aeb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800aed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800af0:	29 f0                	sub    %esi,%eax
}
  800af2:	5b                   	pop    %ebx
  800af3:	5e                   	pop    %esi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af6:	f3 0f 1e fb          	endbr32 
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b00:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b03:	0f b6 01             	movzbl (%ecx),%eax
  800b06:	84 c0                	test   %al,%al
  800b08:	74 0c                	je     800b16 <strcmp+0x20>
  800b0a:	3a 02                	cmp    (%edx),%al
  800b0c:	75 08                	jne    800b16 <strcmp+0x20>
		p++, q++;
  800b0e:	83 c1 01             	add    $0x1,%ecx
  800b11:	83 c2 01             	add    $0x1,%edx
  800b14:	eb ed                	jmp    800b03 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b16:	0f b6 c0             	movzbl %al,%eax
  800b19:	0f b6 12             	movzbl (%edx),%edx
  800b1c:	29 d0                	sub    %edx,%eax
}
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b20:	f3 0f 1e fb          	endbr32 
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	53                   	push   %ebx
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2e:	89 c3                	mov    %eax,%ebx
  800b30:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b33:	eb 06                	jmp    800b3b <strncmp+0x1b>
		n--, p++, q++;
  800b35:	83 c0 01             	add    $0x1,%eax
  800b38:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b3b:	39 d8                	cmp    %ebx,%eax
  800b3d:	74 16                	je     800b55 <strncmp+0x35>
  800b3f:	0f b6 08             	movzbl (%eax),%ecx
  800b42:	84 c9                	test   %cl,%cl
  800b44:	74 04                	je     800b4a <strncmp+0x2a>
  800b46:	3a 0a                	cmp    (%edx),%cl
  800b48:	74 eb                	je     800b35 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4a:	0f b6 00             	movzbl (%eax),%eax
  800b4d:	0f b6 12             	movzbl (%edx),%edx
  800b50:	29 d0                	sub    %edx,%eax
}
  800b52:	5b                   	pop    %ebx
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    
		return 0;
  800b55:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5a:	eb f6                	jmp    800b52 <strncmp+0x32>

00800b5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5c:	f3 0f 1e fb          	endbr32 
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6a:	0f b6 10             	movzbl (%eax),%edx
  800b6d:	84 d2                	test   %dl,%dl
  800b6f:	74 09                	je     800b7a <strchr+0x1e>
		if (*s == c)
  800b71:	38 ca                	cmp    %cl,%dl
  800b73:	74 0a                	je     800b7f <strchr+0x23>
	for (; *s; s++)
  800b75:	83 c0 01             	add    $0x1,%eax
  800b78:	eb f0                	jmp    800b6a <strchr+0xe>
			return (char *) s;
	return 0;
  800b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7f:	5d                   	pop    %ebp
  800b80:	c3                   	ret    

00800b81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b81:	f3 0f 1e fb          	endbr32 
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b8f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b92:	38 ca                	cmp    %cl,%dl
  800b94:	74 09                	je     800b9f <strfind+0x1e>
  800b96:	84 d2                	test   %dl,%dl
  800b98:	74 05                	je     800b9f <strfind+0x1e>
	for (; *s; s++)
  800b9a:	83 c0 01             	add    $0x1,%eax
  800b9d:	eb f0                	jmp    800b8f <strfind+0xe>
			break;
	return (char *) s;
}
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ba1:	f3 0f 1e fb          	endbr32 
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
  800bab:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb1:	85 c9                	test   %ecx,%ecx
  800bb3:	74 31                	je     800be6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb5:	89 f8                	mov    %edi,%eax
  800bb7:	09 c8                	or     %ecx,%eax
  800bb9:	a8 03                	test   $0x3,%al
  800bbb:	75 23                	jne    800be0 <memset+0x3f>
		c &= 0xFF;
  800bbd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc1:	89 d3                	mov    %edx,%ebx
  800bc3:	c1 e3 08             	shl    $0x8,%ebx
  800bc6:	89 d0                	mov    %edx,%eax
  800bc8:	c1 e0 18             	shl    $0x18,%eax
  800bcb:	89 d6                	mov    %edx,%esi
  800bcd:	c1 e6 10             	shl    $0x10,%esi
  800bd0:	09 f0                	or     %esi,%eax
  800bd2:	09 c2                	or     %eax,%edx
  800bd4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bd6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd9:	89 d0                	mov    %edx,%eax
  800bdb:	fc                   	cld    
  800bdc:	f3 ab                	rep stos %eax,%es:(%edi)
  800bde:	eb 06                	jmp    800be6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	fc                   	cld    
  800be4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800be6:	89 f8                	mov    %edi,%eax
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5f                   	pop    %edi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bed:	f3 0f 1e fb          	endbr32 
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bff:	39 c6                	cmp    %eax,%esi
  800c01:	73 32                	jae    800c35 <memmove+0x48>
  800c03:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c06:	39 c2                	cmp    %eax,%edx
  800c08:	76 2b                	jbe    800c35 <memmove+0x48>
		s += n;
		d += n;
  800c0a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0d:	89 fe                	mov    %edi,%esi
  800c0f:	09 ce                	or     %ecx,%esi
  800c11:	09 d6                	or     %edx,%esi
  800c13:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c19:	75 0e                	jne    800c29 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c1b:	83 ef 04             	sub    $0x4,%edi
  800c1e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c21:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c24:	fd                   	std    
  800c25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c27:	eb 09                	jmp    800c32 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c29:	83 ef 01             	sub    $0x1,%edi
  800c2c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c2f:	fd                   	std    
  800c30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c32:	fc                   	cld    
  800c33:	eb 1a                	jmp    800c4f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c35:	89 c2                	mov    %eax,%edx
  800c37:	09 ca                	or     %ecx,%edx
  800c39:	09 f2                	or     %esi,%edx
  800c3b:	f6 c2 03             	test   $0x3,%dl
  800c3e:	75 0a                	jne    800c4a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c40:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c43:	89 c7                	mov    %eax,%edi
  800c45:	fc                   	cld    
  800c46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c48:	eb 05                	jmp    800c4f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c4a:	89 c7                	mov    %eax,%edi
  800c4c:	fc                   	cld    
  800c4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c53:	f3 0f 1e fb          	endbr32 
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c5d:	ff 75 10             	pushl  0x10(%ebp)
  800c60:	ff 75 0c             	pushl  0xc(%ebp)
  800c63:	ff 75 08             	pushl  0x8(%ebp)
  800c66:	e8 82 ff ff ff       	call   800bed <memmove>
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6d:	f3 0f 1e fb          	endbr32 
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	56                   	push   %esi
  800c75:	53                   	push   %ebx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7c:	89 c6                	mov    %eax,%esi
  800c7e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c81:	39 f0                	cmp    %esi,%eax
  800c83:	74 1c                	je     800ca1 <memcmp+0x34>
		if (*s1 != *s2)
  800c85:	0f b6 08             	movzbl (%eax),%ecx
  800c88:	0f b6 1a             	movzbl (%edx),%ebx
  800c8b:	38 d9                	cmp    %bl,%cl
  800c8d:	75 08                	jne    800c97 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c8f:	83 c0 01             	add    $0x1,%eax
  800c92:	83 c2 01             	add    $0x1,%edx
  800c95:	eb ea                	jmp    800c81 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c97:	0f b6 c1             	movzbl %cl,%eax
  800c9a:	0f b6 db             	movzbl %bl,%ebx
  800c9d:	29 d8                	sub    %ebx,%eax
  800c9f:	eb 05                	jmp    800ca6 <memcmp+0x39>
	}

	return 0;
  800ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800caa:	f3 0f 1e fb          	endbr32 
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cb7:	89 c2                	mov    %eax,%edx
  800cb9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cbc:	39 d0                	cmp    %edx,%eax
  800cbe:	73 09                	jae    800cc9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cc0:	38 08                	cmp    %cl,(%eax)
  800cc2:	74 05                	je     800cc9 <memfind+0x1f>
	for (; s < ends; s++)
  800cc4:	83 c0 01             	add    $0x1,%eax
  800cc7:	eb f3                	jmp    800cbc <memfind+0x12>
			break;
	return (void *) s;
}
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ccb:	f3 0f 1e fb          	endbr32 
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
  800cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cdb:	eb 03                	jmp    800ce0 <strtol+0x15>
		s++;
  800cdd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ce0:	0f b6 01             	movzbl (%ecx),%eax
  800ce3:	3c 20                	cmp    $0x20,%al
  800ce5:	74 f6                	je     800cdd <strtol+0x12>
  800ce7:	3c 09                	cmp    $0x9,%al
  800ce9:	74 f2                	je     800cdd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ceb:	3c 2b                	cmp    $0x2b,%al
  800ced:	74 2a                	je     800d19 <strtol+0x4e>
	int neg = 0;
  800cef:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cf4:	3c 2d                	cmp    $0x2d,%al
  800cf6:	74 2b                	je     800d23 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cfe:	75 0f                	jne    800d0f <strtol+0x44>
  800d00:	80 39 30             	cmpb   $0x30,(%ecx)
  800d03:	74 28                	je     800d2d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d05:	85 db                	test   %ebx,%ebx
  800d07:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d0c:	0f 44 d8             	cmove  %eax,%ebx
  800d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d14:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d17:	eb 46                	jmp    800d5f <strtol+0x94>
		s++;
  800d19:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d1c:	bf 00 00 00 00       	mov    $0x0,%edi
  800d21:	eb d5                	jmp    800cf8 <strtol+0x2d>
		s++, neg = 1;
  800d23:	83 c1 01             	add    $0x1,%ecx
  800d26:	bf 01 00 00 00       	mov    $0x1,%edi
  800d2b:	eb cb                	jmp    800cf8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d31:	74 0e                	je     800d41 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d33:	85 db                	test   %ebx,%ebx
  800d35:	75 d8                	jne    800d0f <strtol+0x44>
		s++, base = 8;
  800d37:	83 c1 01             	add    $0x1,%ecx
  800d3a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d3f:	eb ce                	jmp    800d0f <strtol+0x44>
		s += 2, base = 16;
  800d41:	83 c1 02             	add    $0x2,%ecx
  800d44:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d49:	eb c4                	jmp    800d0f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d4b:	0f be d2             	movsbl %dl,%edx
  800d4e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d51:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d54:	7d 3a                	jge    800d90 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d56:	83 c1 01             	add    $0x1,%ecx
  800d59:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d5d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d5f:	0f b6 11             	movzbl (%ecx),%edx
  800d62:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d65:	89 f3                	mov    %esi,%ebx
  800d67:	80 fb 09             	cmp    $0x9,%bl
  800d6a:	76 df                	jbe    800d4b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d6c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d6f:	89 f3                	mov    %esi,%ebx
  800d71:	80 fb 19             	cmp    $0x19,%bl
  800d74:	77 08                	ja     800d7e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d76:	0f be d2             	movsbl %dl,%edx
  800d79:	83 ea 57             	sub    $0x57,%edx
  800d7c:	eb d3                	jmp    800d51 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d7e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d81:	89 f3                	mov    %esi,%ebx
  800d83:	80 fb 19             	cmp    $0x19,%bl
  800d86:	77 08                	ja     800d90 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d88:	0f be d2             	movsbl %dl,%edx
  800d8b:	83 ea 37             	sub    $0x37,%edx
  800d8e:	eb c1                	jmp    800d51 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d94:	74 05                	je     800d9b <strtol+0xd0>
		*endptr = (char *) s;
  800d96:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d99:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d9b:	89 c2                	mov    %eax,%edx
  800d9d:	f7 da                	neg    %edx
  800d9f:	85 ff                	test   %edi,%edi
  800da1:	0f 45 c2             	cmovne %edx,%eax
}
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    
  800da9:	66 90                	xchg   %ax,%ax
  800dab:	66 90                	xchg   %ax,%ax
  800dad:	66 90                	xchg   %ax,%ax
  800daf:	90                   	nop

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
