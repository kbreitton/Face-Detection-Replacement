/*
 * spread.c
 *
 * Code generation for function 'spread'
 *
 * C source code generated on: Sat Dec 20 16:11:42 2014
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "spread.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 10, "spread",
  "/media/klyde/OS/Documents/PENN STUFF/Fall 2014/CIS 581/CIS 581 Final Project/spread.m"
};

static emlrtRSInfo b_emlrtRSI = { 11, "spread",
  "/media/klyde/OS/Documents/PENN STUFF/Fall 2014/CIS 581/CIS 581 Final Project/spread.m"
};

static emlrtRSInfo c_emlrtRSI = { 12, "spread",
  "/media/klyde/OS/Documents/PENN STUFF/Fall 2014/CIS 581/CIS 581 Final Project/spread.m"
};

static emlrtRSInfo d_emlrtRSI = { 14, "eml_li_find",
  "/usr/local/MATLAB/R2013a/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtMCInfo emlrtMCI = { 14, 5, "eml_li_find",
  "/usr/local/MATLAB/R2013a/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtECInfo emlrtECI = { -1, 12, 5, "spread",
  "/media/klyde/OS/Documents/PENN STUFF/Fall 2014/CIS 581/CIS 581 Final Project/spread.m"
};

/* Function Declarations */
static void eml_li_find(const boolean_T x[9], int32_T y_data[9], int32_T y_size
  [2]);
static void error(const mxArray *b, emlrtMCInfo *location);

/* Function Definitions */
static void eml_li_find(const boolean_T x[9], int32_T y_data[9], int32_T y_size
  [2])
{
  int32_T k;
  int32_T i;
  const mxArray *y;
  const mxArray *m0;
  k = 0;
  for (i = 0; i < 9; i++) {
    if (x[i]) {
      k++;
    }
  }

  if (k <= 9) {
  } else {
    emlrtPushRtStackR2012b(&d_emlrtRSI, emlrtRootTLSGlobal);
    y = NULL;
    m0 = mxCreateString("Assertion failed.");
    emlrtAssign(&y, m0);
    error(y, &emlrtMCI);
    emlrtPopRtStackR2012b(&d_emlrtRSI, emlrtRootTLSGlobal);
  }

  y_size[0] = 1;
  y_size[1] = k;
  k = 0;
  for (i = 0; i < 9; i++) {
    if (x[i]) {
      y_data[k] = i + 1;
      k++;
    }
  }
}

static void error(const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(emlrtRootTLSGlobal, 0, NULL, 1, &pArray, "error", TRUE,
                        location);
}

void spread(real_T dir, real_T mag, real_T hist[9])
{
  int32_T i0;
  boolean_T b_hist[9];
  int32_T tmp_size[2];
  int32_T tmp_data[9];
  int32_T loop_ub;
  int32_T b_tmp_size[2];
  int32_T b_tmp_data[9];
  real_T c_tmp_data[9];

  /* given a pixel's gradient direction and magnitude, return its individual histogram of */
  /* gradients */
  /* split a pixel's magnitude between the two closest orientation bins to it, */
  /* unless it hits exactly on a bin  */
  for (i0 = 0; i0 < 9; i0++) {
    hist[i0] = muDoubleScalarAbs(dir - (20.0 + 40.0 * (real_T)i0));
  }

  emlrtPushRtStackR2012b(&emlrtRSI, emlrtRootTLSGlobal);
  for (i0 = 0; i0 < 9; i0++) {
    b_hist[i0] = (hist[i0] == 0.0);
  }

  eml_li_find(b_hist, tmp_data, tmp_size);
  emlrtPopRtStackR2012b(&emlrtRSI, emlrtRootTLSGlobal);
  loop_ub = tmp_size[0] * tmp_size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    hist[tmp_data[i0] - 1] = 2.2250738585072014E-308;
  }

  emlrtPushRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
  for (i0 = 0; i0 < 9; i0++) {
    b_hist[i0] = (hist[i0] > 40.0);
  }

  eml_li_find(b_hist, tmp_data, tmp_size);
  emlrtPopRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
  loop_ub = tmp_size[0] * tmp_size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    hist[tmp_data[i0] - 1] = 0.0;
  }

  emlrtPushRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
  for (i0 = 0; i0 < 9; i0++) {
    b_hist[i0] = (hist[i0] > 0.0);
  }

  eml_li_find(b_hist, tmp_data, tmp_size);
  emlrtPopRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
  emlrtPushRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
  for (i0 = 0; i0 < 9; i0++) {
    b_hist[i0] = (hist[i0] > 0.0);
  }

  eml_li_find(b_hist, b_tmp_data, b_tmp_size);
  loop_ub = b_tmp_size[0] * b_tmp_size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    c_tmp_data[i0] = hist[b_tmp_data[i0] - 1];
  }

  emlrtPopRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
  emlrtSizeEqCheck1DFastR2012b(tmp_size[1], b_tmp_size[1], &emlrtECI,
    emlrtRootTLSGlobal);
  loop_ub = b_tmp_size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    hist[tmp_data[i0] - 1] = 40.0 - c_tmp_data[i0];
  }

  for (i0 = 0; i0 < 9; i0++) {
    hist[i0] = hist[i0] / 40.0 * mag;
  }

  /*          values = (1 - sorted(1:2) / sum(sorted(1:2))) * mag; */
  /*          hist(response == sorted(1)) = values(1); */
  /*          hist(response == sorted(2)) = values(2); */
}

/* End of code generation (spread.c) */
