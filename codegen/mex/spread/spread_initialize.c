/*
 * spread_initialize.c
 *
 * Code generation for function 'spread_initialize'
 *
 * C source code generated on: Sat Dec 20 16:11:42 2014
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "spread.h"
#include "spread_initialize.h"

/* Variable Definitions */
static const volatile char_T *emlrtBreakCheckR2012bFlagVar;

/* Function Definitions */
void spread_initialize(emlrtContext *aContext)
{
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, aContext, NULL, 1);
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, FALSE, 0U, 0);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (spread_initialize.c) */
