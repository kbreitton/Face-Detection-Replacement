/*
 * spread_types.h
 *
 * Code generation for function 'spread'
 *
 * C source code generated on: Sat Dec 20 16:11:42 2014
 *
 */

#ifndef __SPREAD_TYPES_H__
#define __SPREAD_TYPES_H__

/* Include files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_ResolvedFunctionInfo
#define typedef_ResolvedFunctionInfo
typedef struct
{
    const char * context;
    const char * name;
    const char * dominantType;
    const char * resolved;
    uint32_T fileTimeLo;
    uint32_T fileTimeHi;
    uint32_T mFileTimeLo;
    uint32_T mFileTimeHi;
} ResolvedFunctionInfo;
#endif /*typedef_ResolvedFunctionInfo*/
#ifndef struct_emxArray_int32_T_1x9
#define struct_emxArray_int32_T_1x9
struct emxArray_int32_T_1x9
{
    int32_T data[9];
    int32_T size[2];
};
#endif /*struct_emxArray_int32_T_1x9*/
#ifndef typedef_emxArray_int32_T_1x9
#define typedef_emxArray_int32_T_1x9
typedef struct emxArray_int32_T_1x9 emxArray_int32_T_1x9;
#endif /*typedef_emxArray_int32_T_1x9*/

#endif
/* End of code generation (spread_types.h) */
