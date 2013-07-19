//
//  Math.h
//  Test
//
//  Created by Daniel Perez on 7/18/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PI 3.14159265359
#define E 2.718281828459


@interface Math : NSObject
+ (long)factorial:(int)value;
+ (double)pow:(double)x :(double)n;
+ (long)intPow:(long)x :(int)n;
+ (double)doubleIntPow:(double)x :(int)n;
+ (double)log:(double) x;
+ (double)log10:(double) x;
+ (double)exp:(double) x;
+ (double)sin:(double) x;
+ (double)cos:(double) x;
+ (double)tan:(double) x;
@end
