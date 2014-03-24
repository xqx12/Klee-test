/*
 * =====================================================================================
 *
 *       Filename:  xPath.h
 *
 *    Description:   path analysis before Symbolic Execution
 *
 *        Version:  1.0
 *        Created:  2014年03月03日 14时49分03秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Xiao Qixue (XQX), xiaoqixue_1@163.com
 *   Organization:  Tsinghua University
 *
 * =====================================================================================
 */

#ifndef KLEE_XPATH_H
#define KLEE_XPATH_H

#include "klee/Config/Version.h"
#include "llvm/Support/DataTypes.h"
#include <string>

#ifdef __cplusplus
extern "C" {
#endif

//namespace klee {

	void xPathAnalysisPrint();
//}

#ifdef __cplusplus
}
#endif

#endif

