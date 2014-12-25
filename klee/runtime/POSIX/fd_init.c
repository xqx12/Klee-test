//===-- fd_init.c ---------------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#define _LARGEFILE64_SOURCE
#define _FILE_OFFSET_BITS 64
#include "fd.h"
#include <klee/klee.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>


exe_file_system_t __exe_fs;

/* NOTE: It is important that these are statically initialized
   correctly, since things that run before main may hit them given the
   current way things are linked. */

/* XXX Technically these flags are initialized w.o.r. to the
   environment we are actually running in. We could patch them in
   klee_init_fds, but we still have the problem that uclibc calls
   prior to main will get the wrong data. Not such a big deal since we
   mostly care about sym case anyway. */


exe_sym_env_t __exe_env = { 
  {{ 0, eOpen | eReadable, 0, 0}, 
   { 1, eOpen | eWriteable, 0, 0}, 
   { 2, eOpen | eWriteable, 0, 0}},
  022,
  0,
  0
};

/* add a global struct for make specify parts of a file symbolic
 * addbyxqx201411 for test . it should be spcified by user  
 */
xqx_make_sym_t __sym_parts = {
	NULL,
	0,
	fill_sym,
	{{0x103,0x12},{0,0},{0,0},{0,0},{0,0}},
	/*{0x20, 0x4, fill_sym},*/
};

#define XQX_DEBUG_PNG
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  __xqx_create_new_file
 *  Description:  create new file for symbolic partial
 *  Copyright: addbyxqx 2014年11月19日 09时35分03秒
 * =====================================================================================
 */
static void __xqx_create_new_dfile(exe_disk_file_t *dfile, unsigned size, char* contents, 
                               const char *name,
                               const xqx_make_sym_t* sym_infos, unsigned n_sym_info,
                               struct stat64 *defaults, int is_foreign) {
  struct stat64 *s = malloc(sizeof(*s));
  const char *sp;
  char sname[256], src_name[256];
  for (sp=name; *sp; ++sp)
    sname[sp-name] = *sp;
  memcpy(&sname[sp-name], "-stat", 6);

  assert(contents || size);

#ifdef XQX_DEBUG_PNG
  fprintf(stderr, "xqx_create_new_dfile: %s \n", name);
#endif

  dfile->size = size;
  char* original_file = NULL;
  if (contents) {
    original_file = malloc(size);
    memcpy(original_file, contents, size);
    dfile->contents = contents;
  } else {
    dfile->contents = malloc(dfile->size);
  }

  if( n_sym_info && original_file ) {
	__xqx_make_file_symbolic(dfile, original_file,  sym_infos, n_sym_info);
  }

#ifdef XQX_DEBUG_PNG
  fprintf(stderr, "xqx_create_new_dfile make file symbolic: \n" );
#endif

#if 0
  // need to do the same for fill_blocks data
  if (contents) {
    unsigned i;
    for (i = 0; i < dfile->size; ++i) {
      klee_prefer_cex(dfile->contents, dfile->contents[i] == original_file[i]);
    }
    free(original_file);
  }
#endif
  s->st_size = size;
  klee_make_symbolic(s, sizeof(*s), sname);

  /* For broken tests */
  if (!klee_is_symbolic(s->st_ino) && 
      (s->st_ino & 0x7FFFFFFF) == 0)
    s->st_ino = defaults->st_ino;
  
  /* Important since we copy this out through getdents, and readdir
     will otherwise skip this entry. For same reason need to make sure
     it fits in low bits. */
  klee_assume((s->st_ino & 0x7FFFFFFF) != 0);

  /* uclibc opendir uses this as its buffer size, try to keep
     reasonable. */
  klee_assume((s->st_blksize & ~0xFFFF) == 0);

  klee_prefer_cex(s, !(s->st_mode & ~(S_IFMT | 0777)));
  klee_prefer_cex(s, s->st_dev == defaults->st_dev);
  klee_prefer_cex(s, s->st_rdev == defaults->st_rdev);
  klee_prefer_cex(s, (s->st_mode&0700) == 0600);
  klee_prefer_cex(s, (s->st_mode&0070) == 0020);
  klee_prefer_cex(s, (s->st_mode&0007) == 0002);
  klee_prefer_cex(s, (s->st_mode&S_IFMT) == S_IFREG);
  klee_prefer_cex(s, s->st_nlink == 1);
  klee_prefer_cex(s, s->st_uid == defaults->st_uid);
  klee_prefer_cex(s, s->st_gid == defaults->st_gid);
  klee_prefer_cex(s, s->st_blksize == 4096);
  klee_prefer_cex(s, s->st_atime == defaults->st_atime);
  klee_prefer_cex(s, s->st_mtime == defaults->st_mtime);
  klee_prefer_cex(s, s->st_ctime == defaults->st_ctime);

  // allow variable file size (contents should be set only in zest mode)
  if (contents) {
    klee_assume(0 <= s->st_size && s->st_size <= size);
  } else {
    s->st_size = dfile->size;
  }
  s->st_blocks = 8;
  dfile->stat = s;

}

static void __create_new_dfile(exe_disk_file_t *dfile, unsigned size, 
                               const char *name, struct stat64 *defaults) {
  struct stat64 *s = malloc(sizeof(*s));
  const char *sp;
  char sname[64];
  for (sp=name; *sp; ++sp)
    sname[sp-name] = *sp;
  memcpy(&sname[sp-name], "-stat", 6);

  assert(size);

  dfile->size = size;
  dfile->contents = malloc(dfile->size);
  klee_make_symbolic(dfile->contents, dfile->size, name);
  
  klee_make_symbolic(s, sizeof(*s), sname);

  /* For broken tests */
  if (!klee_is_symbolic(s->st_ino) && 
      (s->st_ino & 0x7FFFFFFF) == 0)
    s->st_ino = defaults->st_ino;
  
  /* Important since we copy this out through getdents, and readdir
     will otherwise skip this entry. For same reason need to make sure
     it fits in low bits. */
  klee_assume((s->st_ino & 0x7FFFFFFF) != 0);

  /* uclibc opendir uses this as its buffer size, try to keep
     reasonable. */
  klee_assume((s->st_blksize & ~0xFFFF) == 0);

  klee_prefer_cex(s, !(s->st_mode & ~(S_IFMT | 0777)));
  klee_prefer_cex(s, s->st_dev == defaults->st_dev);
  klee_prefer_cex(s, s->st_rdev == defaults->st_rdev);
  klee_prefer_cex(s, (s->st_mode&0700) == 0600);
  klee_prefer_cex(s, (s->st_mode&0070) == 0020);
  klee_prefer_cex(s, (s->st_mode&0007) == 0002);
  klee_prefer_cex(s, (s->st_mode&S_IFMT) == S_IFREG);
  klee_prefer_cex(s, s->st_nlink == 1);
  klee_prefer_cex(s, s->st_uid == defaults->st_uid);
  klee_prefer_cex(s, s->st_gid == defaults->st_gid);
  klee_prefer_cex(s, s->st_blksize == 4096);
  klee_prefer_cex(s, s->st_atime == defaults->st_atime);
  klee_prefer_cex(s, s->st_mtime == defaults->st_mtime);
  klee_prefer_cex(s, s->st_ctime == defaults->st_ctime);

  s->st_size = dfile->size;
  s->st_blocks = 8;
  dfile->stat = s;
}

static unsigned __sym_uint32(const char *name) {
  unsigned x;
  klee_make_symbolic(&x, sizeof x, name);
  return x;
}

/* n_files: number of symbolic input files, excluding stdin
   file_length: size in bytes of each symbolic file, including stdin
   sym_stdout_flag: 1 if stdout should be symbolic, 0 otherwise
   save_all_writes_flag: 1 if all writes are executed as expected, 0 if 
                         writes past the initial file size are discarded 
			 (file offset is always incremented)
   max_failures: maximum number of system call failures */
void klee_init_fds(unsigned n_files, unsigned file_length, 
		   int sym_stdout_flag, int save_all_writes_flag,
		   unsigned max_failures) {
  unsigned k;
  char name[7] = "?-data";
  struct stat64 s;

  stat64(".", &s);

  __exe_fs.n_sym_files = n_files;
  __exe_fs.sym_files = malloc(sizeof(*__exe_fs.sym_files) * n_files);
  for (k=0; k < n_files; k++) {
    name[0] = 'A' + k;
    __create_new_dfile(&__exe_fs.sym_files[k], file_length, name, &s);
  }
  
  /* setting symbolic stdin */
  if (file_length) {
    __exe_fs.sym_stdin = malloc(sizeof(*__exe_fs.sym_stdin));
    __create_new_dfile(__exe_fs.sym_stdin, file_length, "stdin", &s);
    __exe_env.fds[0].dfile = __exe_fs.sym_stdin;
  }
  else __exe_fs.sym_stdin = NULL;

  __exe_fs.max_failures = max_failures;
  if (__exe_fs.max_failures) {
    __exe_fs.read_fail = malloc(sizeof(*__exe_fs.read_fail));
    __exe_fs.write_fail = malloc(sizeof(*__exe_fs.write_fail));
    __exe_fs.close_fail = malloc(sizeof(*__exe_fs.close_fail));
    __exe_fs.ftruncate_fail = malloc(sizeof(*__exe_fs.ftruncate_fail));
    __exe_fs.getcwd_fail = malloc(sizeof(*__exe_fs.getcwd_fail));

    klee_make_symbolic(__exe_fs.read_fail, sizeof(*__exe_fs.read_fail), "read_fail");
    klee_make_symbolic(__exe_fs.write_fail, sizeof(*__exe_fs.write_fail), "write_fail");
    klee_make_symbolic(__exe_fs.close_fail, sizeof(*__exe_fs.close_fail), "close_fail");
    klee_make_symbolic(__exe_fs.ftruncate_fail, sizeof(*__exe_fs.ftruncate_fail), "ftruncate_fail");
    klee_make_symbolic(__exe_fs.getcwd_fail, sizeof(*__exe_fs.getcwd_fail), "getcwd_fail");
  }

  /* setting symbolic stdout */
  if (sym_stdout_flag) {
    __exe_fs.sym_stdout = malloc(sizeof(*__exe_fs.sym_stdout));
    __create_new_dfile(__exe_fs.sym_stdout, 1024, "stdout", &s);
    __exe_env.fds[1].dfile = __exe_fs.sym_stdout;
    __exe_fs.stdout_writes = 0;
  }
  else __exe_fs.sym_stdout = NULL;

  //addbyxqx201411 setting concrete path file for symboic
#define XQX_CP_FILES 10
  __exe_fs.n_cp_files = XQX_CP_FILES;
  __exe_fs.cp_files = malloc(sizeof(*__exe_fs.cp_files) * XQX_CP_FILES);
  memset( __exe_fs.cp_files, 0 , sizeof(*__exe_fs.cp_files) * XQX_CP_FILES );
  
  __exe_env.save_all_writes = save_all_writes_flag;
  __exe_env.version = __sym_uint32("model_version");
  klee_assume(__exe_env.version == 1);
}



/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  native_read_file
 *  Description:  read file from native , copy from zesti
 *  Copyright: addbyxqx 2014年11月19日 09时08分10秒
 * =====================================================================================
 */
int native_read_file(const char* path, int flags, char** _buf) {
  struct stat64 s;
  char *buf;
  int fd;
  if (-1 == stat64(path, &s))
    return -1;
  buf = *_buf = malloc(s.st_size);
  if( !buf ) 
	  return -1;
  fd = syscall(__NR_open, path, flags, 0);
  if (-1 == fd)
    return -1;
  int rd, cnt = 0;
  while(cnt < s.st_size) {
    rd = syscall(__NR_read, fd, buf+cnt, s.st_size);
    if (rd <= 0)
      break;
    cnt += rd;
  }
  syscall(__NR_close, fd);
  return s.st_size;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  klee_create_cp_file
 *  Description:  create concrete path file for symbolic its content
 *  Copyright: addbyxqx 2014年11月19日 09时09分39秒
 * =====================================================================================
 */
exe_disk_file_t* klee_create_cp_file(const char* path, int flags) {
  unsigned k;
  int fsize;
  struct stat64 def;
  char *buf;
#ifdef XQX_DEBUG_PNG
  fprintf(stderr, "klee_create_cp_file file: %s \n", path);
#endif

  fsize = native_read_file(path, flags, &buf);
  if (fsize < 0)
    return NULL;

#ifdef XQX_DEBUG_PNG
  if(fsize > 4)
  fprintf(stderr, "klee_read_file size=%x, head: %x-%x-%x-%x \n", fsize, buf[0],buf[1],buf[2],buf[3]);
#endif

  stat64(".", &def);
  for (k=0; k < __exe_fs.n_cp_files; k++) {
    if (!__exe_fs.cp_files[k].stat) {
      __exe_fs.cp_files[k].path = (char*)malloc(strlen(path)+1);
      strcpy(__exe_fs.cp_files[k].path, path);
      __xqx_create_new_dfile(&__exe_fs.cp_files[k], fsize, buf, path, &__sym_parts, __sym_parts.num, &def, 0);
      
      return &__exe_fs.cp_files[k];
    }
  }

#ifdef XQX_DEBUG_PNG
  fprintf(stderr, "klee_create_cp_file file end \n");
#endif
  return NULL;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  __xqx_make_file_symbolic
 *  Description:  make the specify parts symbolic of a file content
 *  Copyright: addbyxqx 2014年11月19日 10时40分27秒
 * =====================================================================================
 */
void __xqx_make_file_symbolic(exe_disk_file_t* dfile, char* orig_content, const xqx_make_sym_t* sym_info, unsigned n_syms)
{

#ifdef XQX_DEBUG_PNG
  fprintf(stderr, "xqx_make_file_symbolic entry, n_syms = %d \n", n_syms);
#endif
	unsigned i = 0;
	unsigned j = 0;
	for( ;i < n_syms; i++ ) {
		const xqx_make_sym_t *p = &sym_info[i];
		switch(p->fill_method) {
			case fill_concrete:
				klee_make_symbolic(dfile->contents, dfile->size, dfile->path);
				if( p->sym_buf[i].offset + p->sym_buf[i].length > dfile->size ){
					klee_warning("xqx_make_file_symbolic error: out file bound");
					return;
				}
				memcpy( dfile->contents, orig_content, p->sym_buf[i].offset-1);
				memcpy( dfile->contents + p->sym_buf[i].offset + p->sym_buf[i].length, 
						orig_content + p->sym_buf[i].offset + p->sym_buf[i].length, 
						dfile->size - p->sym_buf[i].offset - p->sym_buf[i].length);
				break;
			case fill_assume:
				klee_make_symbolic(dfile->contents, dfile->size, dfile->path);
				if( p->sym_buf[i].offset + p->sym_buf[i].length > dfile->size ){
					klee_warning("xqx_make_file_symbolic fill_assume error: out file bound");
					return;
				}
				for(j=0;j<p->sym_buf[i].offset;j++) {
					klee_assume(dfile->contents[j]==orig_content[j]);
				}
				j= p->sym_buf[i].offset + p->sym_buf[i].length;
				for(;j<dfile->size;j++) {
					klee_assume(dfile->contents[j]==orig_content[j]);
				}
				break;
			case fill_sym:
#ifdef XQX_DEBUG_PNG
  fprintf(stderr, " fill_sym offset=%d, len=%d, dfilesize=%d \n", p->sym_buf[i].offset, p->sym_buf[i].length,dfile->size);
#endif
				if( p->sym_buf[i].offset + p->sym_buf[i].length > dfile->size ){
					klee_warning("xqx_make_file_symbolic fill_sym error: out file bound");
					return;
				}
				memcpy( dfile->contents, orig_content, dfile->size);
				char *symbuf = malloc(p->sym_buf[i].length);
				memcpy(symbuf, orig_content+p->sym_buf[i].offset, p->sym_buf[i].length); 
				klee_make_symbolic(symbuf, p->sym_buf[i].length, dfile->path);
				memcpy(dfile->contents+p->sym_buf[i].offset, symbuf, p->sym_buf[i].length);
#ifdef XQX_DEBUG_PNG
  fprintf(stderr, "xqx_make_file_symbolic fill_sym \n");
#endif
				break;
		}
	}
}


