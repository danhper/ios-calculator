//
//  Math.m
//  Test
//
//  Created by Daniel Perez on 7/18/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import "Math.h"

@implementation Math

+ (long)factorial:(int)value
{
    long result = 1;
    for(int i = 2; i <= value; i++)
        result *= i;
    return result;
}

+ (double)pow:(double)x :(double)n
{
    return [Math exp:n * [Math log:x]];
}

+ (long)intPow:(long)x :(int)n
{
    return (long)[Math doubleIntPow:x :n];
}

+ (double)doubleIntPow:(double)x :(int)n
{
    if(n == 0) {
        return 1;
    } else if(n == 1) {
        return x;
    } else if(n % 2 == 0) {
        return [Math doubleIntPow:(x * x) :(n / 2)];
    } else {
        return x * [Math doubleIntPow:(x * x) :(n - 1) / 2];
    }    
}

+ (double)log:(double) x
{
    double result = 0;
    for(int n = 0; n < 200; n++) {
        double a = [Math doubleIntPow:(x - 1) / (x + 1.0) :2 * n + 1];
        double b = 1.0 / (2 * n + 1);
        result += (a * b);
    }
    return result * 2;
}

+ (double)log10:(double) x
{
    return [Math log:x] / [Math log: 10.0];
}

+ (double)exp:(double) x
{
    double result = 0;
    for(int n = 0; n < 20; n++) {
        result += [Math doubleIntPow:x :n] / [Math factorial:n];
    }
    return result;
}

@end
