/*
 * spread_terminate.c
 *
 * Code generation for function 'spread_terminate'
 *
 * C source code generated on: Sat Dec 20 16:11:42 2014
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "spread.h"
#include "spread_terminate.h"

/* Function Definitions */
void spread_atexit(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void spread_terminate(void)
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (spread_terminate.c) */
