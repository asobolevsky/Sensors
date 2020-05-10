//
//  PDMUtils.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#define WEAKIFY_SELF    \
    __weak __typeof__((self)) self##__weak = (self)

#define STRONGIFY_SELF    \
    __strong __typeof__((self##__weak)) self = (self##__weak)

#define var __auto_type

struct PDMVector3 {
   double x;
   double y;
   double z;
};
typedef struct PDMVector3 PDMVector3;
