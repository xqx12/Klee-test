//===-- Common.h ------------------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef __KLEE_COMMON_H__
#define __KLEE_COMMON_H__

#ifdef __CYGWIN__
#ifndef WINDOWS
#define WINDOWS
#endif
#endif

#define XQX_DEBUG
//#define XQX_DEBUG_1
//#define xDEBUG   //for executeMemory Debug
#define XQX_INFO
//#define XQX_DEBUG_ENV
//#define XQX_DEBUG_STATE
#define XQX_DEBUG_SHOW_EACH_FORK
//#define XQX_DEBUG_FORK_DUMP_STACK
//#define XQX_DEBUG_PRINT_RANGE
//#define XQX_DEBUG_EXECUTE_MEM  
#define XQX_CMA_CHECK
#define XQX_CONCRETE_EXEC
#define XQX_RESOLVE_ADDR
#define XQX_DEBUG_CONCOLIC
#define XQX_DEBUG_SEED
#define XQX_SAGE
#define XQX_SAGE_DEBUG

#include <stdio.h>

// XXX ugh
namespace klee {
  class Solver;

  extern FILE* klee_warning_file;
  extern FILE* klee_message_file;
  extern FILE* klee_functions_file;

  /// Print "KLEE: ERROR" followed by the msg in printf format and a
  /// newline on stderr and to warnings.txt, then exit with an error.
  void klee_error(const char *msg, ...)
    __attribute__ ((format (printf, 1, 2), noreturn));

  /// Print "KLEE: " followed by the msg in printf format and a
  /// newline on stderr and to messages.txt.
  void klee_message(const char *msg, ...)
    __attribute__ ((format (printf, 1, 2)));

  void klee_record_func(const char *msg, ...)
    __attribute__ ((format (printf, 1, 2)));

  void klee_xqx_debug(const char *msg, ...)
    __attribute__ ((format (printf, 1, 2)));

  void klee_xqx_info(const char *msg, ...)
    __attribute__ ((format (printf, 1, 2)));

  /// Print "KLEE: " followed by the msg in printf format and a
  /// newline to messages.txt.
  void klee_message_to_file(const char *msg, ...)
    __attribute__ ((format (printf, 1, 2)));

  /// Print "KLEE: WARNING" followed by the msg in printf format and a
  /// newline on stderr and to warnings.txt.
  void klee_warning(const char *msg, ...)
    __attribute__ ((format (printf, 1, 2)));

  /// Print "KLEE: WARNING" followed by the msg in printf format and a
  /// newline on stderr and to warnings.txt. However, the warning is only 
  /// printed once for each unique (id, msg) pair (as pointers).
  void klee_warning_once(const void *id,
                         const char *msg, ...)
    __attribute__ ((format (printf, 2, 3)));
}

#endif /* __KLEE_COMMON_H__ */
