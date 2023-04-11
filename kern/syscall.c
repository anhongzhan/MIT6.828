// /* See COPYRIGHT for copyright information. */

// #include <inc/x86.h>
// #include <inc/error.h>
// #include <inc/string.h>
// #include <inc/assert.h>

// #include <kern/env.h>
// #include <kern/pmap.h>
// #include <kern/trap.h>
// #include <kern/syscall.h>
// #include <kern/console.h>
// #include <kern/sched.h>

// // Print a string to the system console.
// // The string is exactly 'len' characters long.
// // Destroys the environment on memory errors.
// static void
// sys_cputs(const char *s, size_t len)
// {
// 	// Check that the user has permission to read memory [s, s+len).
// 	// Destroy the environment if not.

// 	// LAB 3: Your code here.
// 	user_mem_assert(curenv, s, len, PTE_U);

// 	// Print the string supplied by the user.
// 	cprintf("%.*s", len, s);
// }

// // Read a character from the system console without blocking.
// // Returns the character, or 0 if there is no input waiting.
// static int
// sys_cgetc(void)
// {
// 	return cons_getc();
// }

// // Returns the current environment's envid.
// static envid_t
// sys_getenvid(void)
// {
// 	return curenv->env_id;
// }

// // Destroy a given environment (possibly the currently running environment).
// //
// // Returns 0 on success, < 0 on error.  Errors are:
// //	-E_BAD_ENV if environment envid doesn't currently exist,
// //		or the caller doesn't have permission to change envid.
// static int
// sys_env_destroy(envid_t envid)
// {
// 	int r;
// 	struct Env *e;

// 	if ((r = envid2env(envid, &e, 1)) < 0)
// 		return r;
// 	if (e == curenv)
// 		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
// 	else
// 		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
// 	env_destroy(e);
// 	return 0;
// }

// // Deschedule current environment and pick a different one to run.
// static void
// sys_yield(void)
// {
// 	sched_yield();
// }

// // Allocate a new environment.
// // Returns envid of new environment, or < 0 on error.  Errors are:
// //	-E_NO_FREE_ENV if no free environment is available.
// //	-E_NO_MEM on memory exhaustion.
// static envid_t
// sys_exofork(void)
// {
// 	// Create the new environment with env_alloc(), from kern/env.c.
// 	// It should be left as env_alloc created it, except that
// 	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
// 	// from the current environment -- but tweaked so sys_exofork
// 	// will appear to return 0.

// 	// LAB 4: Your code here.
// 	// panic("sys_exofork not implemented");
// 	int e;
// 	struct Env *parent, *child;
// 	parent = curenv;

// 	// Create the new environment with env_alloc()
// 	if((e = env_alloc(&child, parent->env_id)) < 0){
// 		//失败的情况和env_alloc失败的情况相同
// 		return e;
// 	}

// 	//子进程和父进程由相同的寄存器状态，实验描述中写着的
// 	child->env_tf = parent->env_tf;
// 	//子进程状态设置，函数注释中写着的
// 	child->env_status = ENV_NOT_RUNNABLE;
// 	//子进程返回值为0，但是为什么eax是返回值
// 	//而且看网上的实现大家都默认这件事了
// 	//我只记得Lab3中提到过系统调用eax是第一个参数以及返回值
// 	//不知道是否和这个有关
// 	child->env_tf.tf_regs.reg_eax = 0;
// 	return child->env_id;
// }

// // Set envid's env_status to status, which must be ENV_RUNNABLE
// // or ENV_NOT_RUNNABLE.
// //
// // Returns 0 on success, < 0 on error.  Errors are:
// //	-E_BAD_ENV if environment envid doesn't currently exist,
// //		or the caller doesn't have permission to change envid.
// //	-E_INVAL if status is not a valid status for an environment.
// static int
// sys_env_set_status(envid_t envid, int status)
// {
// 	// Hint: Use the 'envid2env' function from kern/env.c to translate an
// 	// envid to a struct Env.
// 	// You should set envid2env's third argument to 1, which will
// 	// check whether the current environment has permission to set
// 	// envid's status.

// 	// LAB 4: Your code here.
// 	// panic("sys_env_set_status not implemented");
// 	struct Env* e;
// 	//	-E_INVAL if status is not a valid status for an environment.
// 	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE){
// 		return -E_INVAL;
// 	}
// 	//	-E_BAD_ENV if environment envid doesn't currently exist,
// 	if(envid2env(envid, &e, 1) != 0){
// 		return -E_BAD_ENV;
// 	}
// 	e->env_status = status;
// 	return 0;
// }

// // Set the page fault upcall for 'envid' by modifying the corresponding struct
// // Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// // kernel will push a fault record onto the exception stack, then branch to
// // 'func'.
// //
// // Returns 0 on success, < 0 on error.  Errors are:
// //	-E_BAD_ENV if environment envid doesn't currently exist,
// //		or the caller doesn't have permission to change envid.
// static int
// sys_env_set_pgfault_upcall(envid_t envid, void *func)
// {
// 	// LAB 4: Your code here.
// 	// panic("sys_env_set_pgfault_upcall not implemented");
// 	struct Env* e;
// 	if(envid2env(envid, &e, 1) < 0)
// 		return -E_BAD_ENV;
// 	e->env_pgfault_upcall = func;
// 	return 0;
// }

// // Allocate a page of memory and map it at 'va' with permission
// // 'perm' in the address space of 'envid'.
// // The page's contents are set to 0.
// // If a page is already mapped at 'va', that page is unmapped as a
// // side effect.
// //
// // perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
// //         but no other bits may be set.  See PTE_SYSCALL in inc/mmu.h.
// //
// // Return 0 on success, < 0 on error.  Errors are:
// //	-E_BAD_ENV if environment envid doesn't currently exist,
// //		or the caller doesn't have permission to change envid.
// //	-E_INVAL if va >= UTOP, or va is not page-aligned.
// //	-E_INVAL if perm is inappropriate (see above).
// //	-E_NO_MEM if there's no memory to allocate the new page,
// //		or to allocate any necessary page tables.
// static int
// sys_page_alloc(envid_t envid, void *va, int perm)
// {
// 	// Hint: This function is a wrapper around page_alloc() and
// 	//   page_insert() from kern/pmap.c.
// 	//   Most of the new code you write should be to check the
// 	//   parameters for correctness.
// 	//   If page_insert() fails, remember to free the page you
// 	//   allocated!

// 	// LAB 4: Your code here.
// 	// panic("sys_page_alloc not implemented");
// 	struct PageInfo* pp = NULL;
// 	struct Env* e = NULL;
// 	int r;
// 	int flag = PTE_U | PTE_P;

// 	//	-E_BAD_ENV if environment envid doesn't currently exist,
// //		or the caller doesn't have permission to change envid.
// 	if(envid2env(envid, &e, 1) < 0)
// 		return -E_BAD_ENV;
	
// 	//	-E_INVAL if va >= UTOP, or va is not page-aligned.
// 	if((uintptr_t)va >= UTOP || PGOFF(va))
// 		return -E_INVAL;

// 	//	-E_INVAL if perm is inappropriate (see above).
// 	if(((perm & flag) != flag) || (perm & ~PTE_SYSCALL) != 0)
// 		return -E_INVAL;

// 	//	-E_NO_MEM if there's no memory to allocate the new page,
// 	if((pp = page_alloc(ALLOC_ZERO)) == NULL)
// 		return -E_NO_MEM;

// 	if((r = page_insert(e->env_pgdir, pp, (void*)va, perm)) < 0){
// 		page_free(pp);
// 		return r;
// 	}

// 	return 0;
		 
// }

// // Map the page of memory at 'srcva' in srcenvid's address space
// // at 'dstva' in dstenvid's address space with permission 'perm'.
// // Perm has the same restrictions as in sys_page_alloc, except
// // that it also must not grant write access to a read-only
// // page.
// //
// // Return 0 on success, < 0 on error.  Errors are:
// //	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
// //		or the caller doesn't have permission to change one of them.
// //	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
// //		or dstva >= UTOP or dstva is not page-aligned.
// //	-E_INVAL is srcva is not mapped in srcenvid's address space.
// //	-E_INVAL if perm is inappropriate (see sys_page_alloc).
// //	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
// //		address space.
// //	-E_NO_MEM if there's no memory to allocate any necessary page tables.
// static int
// sys_page_map(envid_t srcenvid, void *srcva,
// 	     envid_t dstenvid, void *dstva, int perm)
// {
// 	// Hint: This function is a wrapper around page_lookup() and
// 	//   page_insert() from kern/pmap.c.
// 	//   Again, most of the new code you write should be to check the
// 	//   parameters for correctness.
// 	//   Use the third argument to page_lookup() to
// 	//   check the current permissions on the page.

// 	// LAB 4: Your code here.
// 	// panic("sys_page_map not implemented");
// 	struct Env* src = NULL;
// 	struct Env* dst = NULL;

// 	//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
// 	if(envid2env(srcenvid, &src, 1) < 0 || envid2env(dstenvid, &dst, 1))
// 		return -E_BAD_ENV;

// 	//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned
// 	if((uintptr_t)srcva >= UTOP || PGOFF(srcva))
// 		return -E_INVAL;

// 	//		or dstva >= UTOP or dstva is not page-aligned.
// 	if((uintptr_t)dstva >= UTOP || PGOFF(dstva))
// 		return -E_INVAL;

// 	//	-E_INVAL is srcva is not mapped in srcenvid's address space.
// 	pte_t* pte_addr = NULL;
// 	struct PageInfo* page = NULL;
// 	if((page = page_lookup(src->env_pgdir, srcva, &pte_addr)) == NULL)
// 		return -E_INVAL;

// 	//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
// 	if(((perm & PTE_U) == 0) || ((perm & PTE_P) == 0) || ((perm & ~PTE_SYSCALL) != 0))
// 		return -E_INVAL;

// 	//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
// 	//		address space.
// 	if(((perm & PTE_U) == 0) || ((perm & PTE_P) == 0) || ((perm & ~PTE_SYSCALL) != 0))
// 		return -E_INVAL;

// 	//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
// 	if(page_insert(dst->env_pgdir, page, dstva, perm) < 0)
// 		return -E_NO_MEM;

// 	return 0;
// }

// // Unmap the page of memory at 'va' in the address space of 'envid'.
// // If no page is mapped, the function silently succeeds.
// //
// // Return 0 on success, < 0 on error.  Errors are:
// //	-E_BAD_ENV if environment envid doesn't currently exist,
// //		or the caller doesn't have permission to change envid.
// //	-E_INVAL if va >= UTOP, or va is not page-aligned.
// static int
// sys_page_unmap(envid_t envid, void *va)
// {
// 	// Hint: This function is a wrapper around page_remove().

// 	// LAB 4: Your code here.
// 	// panic("sys_page_unmap not implemented");
// 	struct Env* e;

// 	//	-E_BAD_ENV if environment envid doesn't currently exist,
// 	if(envid2env(envid, &e, 1) < 0)
// 		return -E_BAD_ENV;

// 	//	-E_INVAL if va >= UTOP, or va is not page-aligned.
// 	if((uintptr_t)va >= UTOP || PGOFF(va))
// 		return -E_INVAL;

// 	page_remove(e->env_pgdir, va);
// 	return 0;
// }

// // Try to send 'value' to the target env 'envid'.
// // If srcva < UTOP, then also send page currently mapped at 'srcva',
// // so that receiver gets a duplicate mapping of the same page.
// //
// // The send fails with a return value of -E_IPC_NOT_RECV if the
// // target is not blocked, waiting for an IPC.
// //
// // The send also can fail for the other reasons listed below.
// //
// // Otherwise, the send succeeds, and the target's ipc fields are
// // updated as follows:
// //    env_ipc_recving is set to 0 to block future sends;
// //    env_ipc_from is set to the sending envid;
// //    env_ipc_value is set to the 'value' parameter;
// //    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// // The target environment is marked runnable again, returning 0
// // from the paused sys_ipc_recv system call.  (Hint: does the
// // sys_ipc_recv function ever actually return?)
// //
// // If the sender wants to send a page but the receiver isn't asking for one,
// // then no page mapping is transferred, but no error occurs.
// // The ipc only happens when no errors occur.
// //
// // Returns 0 on success, < 0 on error.
// // Errors are:
// //	-E_BAD_ENV if environment envid doesn't currently exist.
// //		(No need to check permissions.)
// //	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
// //		or another environment managed to send first.
// //	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
// //	-E_INVAL if srcva < UTOP and perm is inappropriate
// //		(see sys_page_alloc).
// //	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
// //		address space.
// //	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
// //		current environment's address space.
// //	-E_NO_MEM if there's not enough memory to map srcva in envid's
// //		address space.
// static int
// sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
// {
// 	// LAB 4: Your code here.
// 	//panic("sys_ipc_try_send not implemented");
// 	struct Env *rec_env, *cur_env;
// 	int r;
// 	int flag = PTE_U | PTE_P;
// 	struct PageInfo* pg;
// 	pte_t* pte;

// 	//get current env
// 	envid2env(0, &cur_env, 0);

// 	//	-E_BAD_ENV if environment envid doesn't currently exist.
// 	//  envid2env return -E_BAD_ENV
// 	//  所以我们直接返回r即可
// 	if((r = envid2env(envid, &rec_env, 0)) < 0){
// 		return r;
// 	}

// 	//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
// 	//	or another environment managed to send first.
// 	// env_ipc_recving 表示 Env is blocked receiving
// 	if(!rec_env->env_ipc_recving){
// 		return -E_IPC_NOT_RECV;
// 	}

// 	// After any IPC the kernel sets the new field env_ipc_perm 
// 	// in the receiver's Env structure to the permissions of the page received, 
// 	// or zero if no page was received.
// 	if(rec_env->env_ipc_from){
// 		return -E_IPC_NOT_RECV;
// 	}

// 	if((uintptr_t)srcva >= UTOP){
// 		perm = 0;
// 	}

// 	//	-E_INVAL if srcva < UTOP
// 	if(perm){
// 		//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
// 		if((uintptr_t)srcva & (PGSIZE - 1)){
// 			return -E_INVAL;
// 		}

// 		//	-E_INVAL if srcva < UTOP and perm is inappropriate
// 		//		(see sys_page_alloc).
// 		if(((perm & flag) != flag) || (perm & ~PTE_SYSCALL) != 0){
// 			return -E_INVAL;
// 		}

// 		//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
// 		//		address space.
// 		if(!(pg = page_lookup(cur_env->env_pgdir, srcva, &pte))){
// 			return -E_INVAL;
// 		}	

// 		//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
// 		//		current environment's address space.
// 		if((perm & PTE_W) && !((*pte) & PTE_W)){
// 			return -E_INVAL;
// 		}

// 		//	-E_NO_MEM if there's not enough memory to map srcva in envid's
// 		//		address space.
// 		//  page_insert失败后返回-E_NO_MEM
// 		if((uintptr_t)rec_env->env_ipc_dstva < UTOP){
// 			if((r = page_insert(rec_env->env_pgdir, pg, rec_env->env_ipc_dstva, perm)) < 0){
// 				return r;
// 			}
// 		}
// 	}

// 	// Otherwise, the send succeeds, and the target's ipc fields are
// 	// updated as follows:
// 	//    env_ipc_recving is set to 0 to block future sends;
// 	//    env_ipc_from is set to the sending envid;
// 	//    env_ipc_value is set to the 'value' parameter;
// 	//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// 	rec_env->env_ipc_recving = 0;
// 	rec_env->env_ipc_from = cur_env->env_id;
// 	rec_env->env_ipc_value = value;
// 	rec_env->env_ipc_perm = perm;

// 	// The target environment is marked runnable again
// 	rec_env->env_status = ENV_RUNNABLE;

// 	// returning 0 from the paused sys_ipc_recv system call. 
// 	rec_env->env_tf.tf_regs.reg_eax = 0;

// 	return 0;
// }

// // Block until a value is ready.  Record that you want to receive
// // using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// // mark yourself not runnable, and then give up the CPU.
// //
// // If 'dstva' is < UTOP, then you are willing to receive a page of data.
// // 'dstva' is the virtual address at which the sent page should be mapped.
// //
// // This function only returns on error, but the system call will eventually
// // return 0 on success.
// // Return < 0 on error.  Errors are:
// //	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
// static int
// sys_ipc_recv(void *dstva)
// {
// 	// LAB 4: Your code here.
// 	//panic("sys_ipc_recv not implemented");

// 	//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
// 	if((uintptr_t)dstva < UTOP || (uintptr_t)dstva & (PGSIZE - 1)){
// 		return -E_INVAL;
// 	}

// 	struct Env* cur_env;
// 	envid2env(0, &cur_env, 0);
// 	assert(cur_env);

// 	// Block until a value is ready.  Record that you want to receive
// 	// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// 	// mark yourself not runnable, and then give up the CPU.
// 	cur_env->env_ipc_recving = 1;
// 	cur_env->env_ipc_dstva = dstva;
// 	cur_env->env_status = ENV_NOT_RUNNABLE;

// 	sched_yield();

// 	// This function only returns on error, but the system call will eventually
// 	// return 0 on success.
// 	//return 0;
// }

// // Dispatches to the correct kernel function, passing the arguments.
// int32_t
// syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
// {
// 	// Call the function corresponding to the 'syscallno' parameter.
// 	// Return any appropriate return value.
// 	// LAB 3: Your code here.

// 	//panic("syscall not implemented");

// 	switch (syscallno) {
// 	case SYS_cputs:
// 		sys_cputs((const char*)a1, (size_t)a2);
// 		return 0;
// 	case SYS_cgetc:
// 		return sys_cgetc();
// 	case SYS_getenvid:
// 		return (envid_t)sys_getenvid();
// 	case SYS_env_destroy:
// 		return sys_env_destroy((envid_t)a1);
// 	case SYS_yield:
// 		sys_yield();
// 		return 0;
// 	case SYS_exofork:
// 		return sys_exofork();
// 	case SYS_env_set_status:
// 		return (envid_t)sys_env_set_status((envid_t)a1, (int)a2);
// 	case SYS_page_alloc:
// 		return (envid_t)sys_page_alloc((envid_t)a1, (void*)a2, (int)a3);
// 	case SYS_page_map:
// 		return (envid_t)sys_page_map((envid_t)a1, (void*)a2, (envid_t)a3, (void*)a4, (int)a5);
// 	case SYS_page_unmap:
// 		return (envid_t)sys_page_unmap((envid_t)a1, (void*)a2);
// 	case SYS_env_set_pgfault_upcall:
// 		return (envid_t)sys_env_set_pgfault_upcall((envid_t)a1, (void*)a2);
// 	case SYS_ipc_try_send:
// 		return sys_ipc_try_send(a1, a2, (void *) a3, a4);
// 		break;
// 	case SYS_ipc_recv:
// 		return sys_ipc_recv((void *) a1);
// 		break;
// 	default:
// 		return -E_INVAL;
// 	}
// }


/* See COPYRIGHT for copyright information. */

#include <inc/x86.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/syscall.h>
#include <kern/console.h>
#include <kern/sched.h>

// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.
	user_mem_assert(curenv, s, len, 0);
	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
}

// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
}

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
		return r;
	if (e == curenv)
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
	env_destroy(e);
	return 0;
}

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	// LAB 4: Your code here.
	struct Env *child;
	int status = env_alloc(&child, curenv->env_id);
	if (status < 0) return status;
	child->env_tf = curenv->env_tf;
	child->env_status = ENV_NOT_RUNNABLE;
	child->env_tf.tf_regs.reg_eax = 0;		//新的用户环境从sys_exofork()的返回值应该为0
	return child->env_id;
}

// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	struct Env *env;
	int state = envid2env(envid, &env, 1);
	if (state < 0) return state;
	if (status != ENV_NOT_RUNNABLE && status != ENV_RUNNABLE) {
		return -E_INVAL;
	}

	env->env_status = status;
	return 0;
}

// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	struct Env *env;
	int state = envid2env(envid, &env, 1);
	if (state < 0) return state;
	env->env_pgfault_upcall = func;
	return 0;
}

// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.  See PTE_SYSCALL in inc/mmu.h.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	// Hint: This function is a wrapper around page_alloc() and
	//   page_insert() from kern/pmap.c.
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
	struct Env *env;
	int state = envid2env(envid, &env, 1);
	if (state < 0) return state;

	if ((size_t) va >= UTOP || ((size_t) va % PGSIZE) != 0) return -E_INVAL;
	if ((perm & PTE_U) != PTE_U || (perm & PTE_P) != PTE_P) return -E_INVAL;
	
	struct PageInfo *pp = page_alloc(1);
	if (pp == NULL) return -E_NO_MEM;
	if (page_insert(env->env_pgdir, pp, va, perm) < 0) {
		page_free(pp);
		return -E_NO_MEM;
	}

	return 0;
}

// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.
	if ((size_t) srcva >= UTOP || ((size_t) srcva % PGSIZE) != 0 || (size_t) dstva >= UTOP || ((size_t) dstva % PGSIZE) != 0) {
		return -E_INVAL;
	}

	struct Env *senv, *denv;
	int state1, state2;
	state1 = envid2env(srcenvid, &senv, 1);
	state2 = envid2env(dstenvid, &denv, 1);
	if (state1 < 0) return state1;
	if (state2 < 0) return state2;

	pte_t *pte;
	struct PageInfo *pp = page_lookup(senv->env_pgdir, srcva, &pte);
	if (pp == NULL) return -E_INVAL;

	if (((*pte & PTE_W) == 0) && (perm & PTE_W)) return -E_INVAL;

	return page_insert(denv->env_pgdir, pp, dstva, perm);
}

// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	struct Env *env;
	if (envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
	if ((size_t) va >= UTOP || ((size_t) va % PGSIZE) != 0) {
		return -E_INVAL;
	}

	page_remove(env->env_pgdir, va);
	return 0;
}

// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target is not blocked, waiting for an IPC.
//
// The send also can fail for the other reasons listed below.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused sys_ipc_recv system call.  (Hint: does the
// sys_ipc_recv function ever actually return?)
//
// If the sender wants to send a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success, < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	// LAB 4: Your code here.
	struct Env *env;
	if (envid2env(envid, &env, 0) < 0) return -E_BAD_ENV;
	if (!env->env_ipc_recving) return -E_IPC_NOT_RECV;

	if ((size_t) srcva < UTOP) {
		if (((size_t) srcva % PGSIZE) != 0) {
			return -E_INVAL;
		}

		if ((perm & PTE_U) != PTE_U || (perm & PTE_P) != PTE_P) return -E_INVAL;

		pte_t *pte;
		struct PageInfo *pp = page_lookup(curenv->env_pgdir, srcva, &pte);
		if (!pp) return -E_INVAL;

		if ((perm & PTE_W) && ((size_t) *pte & PTE_W) != PTE_W) return -E_INVAL;
		if ((size_t) env->env_ipc_dstva < UTOP) {
			if (page_insert(env->env_pgdir, pp, env->env_ipc_dstva, perm) < 0) return -E_NO_MEM;
			env->env_ipc_perm = perm;
		}
	} else {
		env->env_ipc_perm = 0;
	}

	env->env_ipc_from = curenv->env_id;
	env->env_ipc_recving = 0;
	env->env_ipc_value = value;
	env->env_status = ENV_RUNNABLE;
	env->env_tf.tf_regs.reg_eax = 0;
	return 0;
}

// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
	if ((size_t) dstva < UTOP && ((size_t) dstva % PGSIZE) != 0) return -E_INVAL;
	curenv->env_ipc_recving = 1;
	curenv->env_ipc_dstva = dstva;
	curenv->env_status = ENV_NOT_RUNNABLE;
	sys_yield();
	return 0;
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	switch (syscallno) {
		case SYS_cputs:
			sys_cputs((char *) a1, a2);
			return 0;
		case SYS_cgetc:
			return sys_cgetc();
		case SYS_getenvid:
			return sys_getenvid();
		case SYS_env_destroy:
			return sys_env_destroy(a1);
		case SYS_yield:
			sys_yield();
			return 0;
		case SYS_exofork:
			return sys_exofork();
		case SYS_env_set_status:
			return sys_env_set_status(a1, a2);
		case SYS_page_alloc:
			return sys_page_alloc(a1, (void *) a2, a3);
		case SYS_page_map:
			return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
		case SYS_page_unmap:
			return sys_page_unmap(a1, (void *) a2);
		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall(a1, (void *) a2);
		case SYS_ipc_try_send:
			return sys_ipc_try_send(a1, a2, (void *) a3, a4);
			break;
		case SYS_ipc_recv:
			return sys_ipc_recv((void *) a1);
			break;
		default:
			return -E_INVAL;
	}

	return -E_INVAL;
}

