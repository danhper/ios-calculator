//
//  Math.h
//  Test
//
//  Created by Daniel Perez on 7/18/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Math : NSObject
+ (long)factorial:(int)value;
+ (double)pow:(double)x :(double)n;
+ (long)intPow:(long)x :(int)n;
+ (double)doubleIntPow:(double)x :(int)n;
+ (double)log:(double) x;
+ (double)exp:(double) x;
@end
