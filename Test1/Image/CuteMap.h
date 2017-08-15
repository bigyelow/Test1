//
//  CuteMap.h
//  Test1
//
//  Created by bigyelow on 09/08/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

#ifndef CuteMap_h
#define CuteMap_h

#include <stdio.h>

typedef struct CubeMap CubeMap;

struct CubeMap {
  int length;
  float dimension;
  float *data;
};

struct CubeMap createCubeMap(float minHueAngle, float maxHueAngle);

#endif /* CuteMap_h */
