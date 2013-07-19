//
//  AbstractSyntaxTree.m
//  Test
//
//  Created by Daniel Perez on 7/18/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import "AbstractSyntaxTree.h"

#import "Math.h"

#define PI 3.14159265359
#define E 2.718281828459


@implementation IntValue

- (id)initWithValue:(long)v
{
    _value = v;
    return self;
}

- (ValueType) getType
{
    return INT_VALUE;
}

- (double) getDoubleValue
{
    return (double)[self value];
}

- (NSObject<Value>*) evaluate
{
    return self;
}

- (NSObject<Value>*) add:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        return [[IntValue alloc] initWithValue: [self value] + [(IntValue*)other value]];
    } else {
        return [[DoubleValue alloc] initWithValue:[self value] + [other getDoubleValue]];
    }
}

- (NSObject<Value>*) sub:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        return [[IntValue alloc] initWithValue: [self value] - [(IntValue*)other value]];
    } else {
        return [[DoubleValue alloc] initWithValue:[self value] - [other getDoubleValue]];
    }
}

- (NSObject<Value>*) mul:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        return [[IntValue alloc] initWithValue: [self value] * [(IntValue*)other value]];
    } else {
        return [[DoubleValue alloc] initWithValue:[self value] * [other getDoubleValue]];
    }
}

- (NSObject<Value>*) div:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        if([(IntValue*)other value] == 0) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                               reason:[NSString stringWithFormat:@"div by 0"]
                                             userInfo:nil];
        }
        return [[IntValue alloc] initWithValue: [self value] / [(IntValue*)other value]];
    } else {
        return [[DoubleValue alloc] initWithValue:[self value] / [other getDoubleValue]];
    }
}

- (NSObject<Value>*) pow:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        long newValue = [Math intPow:[self value] :(int)[(IntValue*)other value]];
        return [[IntValue alloc] initWithValue: newValue];
    } else {
        double newValue = [Math pow:[self value] :[other getDoubleValue]];
        return [[DoubleValue alloc] initWithValue: newValue];
    }
}

@end

@implementation DoubleValue

- (id)initWithValue:(double)v
{
    _value = v;
    return self;
}

- (ValueType) getType
{
    return DOUBLE_VALUE;
}

- (double) getDoubleValue
{
    return [self value];
}

- (NSObject<Value>*) evaluate
{
    return self;
}

- (NSObject<Value>*) add:(NSObject<Value> *)other
{
    return [[DoubleValue alloc] initWithValue:[self getDoubleValue] + [other getDoubleValue]];
}

- (NSObject<Value>*) sub:(NSObject<Value> *)other
{
    return [[DoubleValue alloc] initWithValue:[self getDoubleValue] - [other getDoubleValue]];
}

- (NSObject<Value>*) mul:(NSObject<Value> *)other
{
    return [[DoubleValue alloc] initWithValue:[self getDoubleValue] * [other getDoubleValue]];
}

- (NSObject<Value>*) div:(NSObject<Value> *)other
{
    return [[DoubleValue alloc] initWithValue:[self getDoubleValue] / [other getDoubleValue]];
}

- (NSObject<Value>*) pow:(NSObject<Value> *)other
{
    double newValue;
    if([other getType] == INT_VALUE) {
        newValue = [Math doubleIntPow:[self value] :(int)[(IntValue*)other value]];
    } else {
        newValue = [Math pow:[self value] :[other getDoubleValue]];
    }
    return [[DoubleValue alloc] initWithValue:newValue];
}


@end

@implementation Variable
static NSMutableDictionary *dictionary = nil;

+ (void)initVariables
{
    if(dictionary != nil) {
        return;
    }
    dictionary = [[NSMutableDictionary alloc] init];
    DoubleValue* pi = [[DoubleValue alloc] initWithValue:PI];
    DoubleValue* e = [[DoubleValue alloc] initWithValue:E];
    [dictionary setObject:pi forKey:@"π"];
    [dictionary setObject:e forKey:@"e"];
}

- (id)initWithName:(NSString*)n
{
    name = n;
    return self;
}

- (NSObject<Value> *)evaluate
{
    NSObject<Value>* value = [dictionary objectForKey:name];
    if(value == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"variable %@ not found", name]
                                     userInfo:nil];
    }
    return value;
}

@end

@implementation UnaryApp

- (id)initWithValues:(UnaryAppType)t :(NSObject<AbstractSyntaxTree>*)e
{
    elem = e;
    type = t;
    return self;
}

- (NSObject<Value>*)evaluate
{
    switch (type) {
        case FACT: {
            NSObject<Value>* v = [elem evaluate];
            if([v getType] != INT_VALUE) {
                @throw [NSException exceptionWithName:NSInvalidArgumentException
                                               reason:[NSString stringWithFormat:@"need int for factorial"]
                                             userInfo:nil];
            }
            return [[IntValue alloc] initWithValue: [Math factorial:[(IntValue*)v value]]];
            break;
        }
        case LN: {
            NSObject<Value>* v = [elem evaluate];
            return [[DoubleValue alloc] initWithValue:[Math log:[v getDoubleValue]]];
        }
        case LOG: {
            NSObject<Value>* v = [elem evaluate];
            return [[DoubleValue alloc] initWithValue:[Math log10:[v getDoubleValue]]];
        }
        case SQRT:
            return [[DoubleValue alloc] initWithValue:[Math pow:[[elem evaluate] getDoubleValue] :0.5]];
        case COS:
            return [[DoubleValue alloc] initWithValue:[Math cos:[[elem evaluate] getDoubleValue]]];
        case SIN:
            return [[DoubleValue alloc] initWithValue:[Math sin:[[elem evaluate] getDoubleValue]]];
        case TAN:
            return [[DoubleValue alloc] initWithValue:[Math tan:[[elem evaluate] getDoubleValue]]];
            
        default:
            break;
    }
}
@end

@implementation BinaryApp

- (id)initWithValues:(BinaryAppType)t :(NSObject<AbstractSyntaxTree>*)l :(NSObject<AbstractSyntaxTree>*)r
{
    type = t;
    left = l;
    right = r;
    return self;
}

- (NSObject<Value>*)evaluate
{
    switch(type) {
        case ADD: return [[left evaluate] add: [right evaluate]];
        case SUB: return [[left evaluate] sub: [right evaluate]];
        case MUL: return [[left evaluate] mul: [right evaluate]];
        case DIV: return [[left evaluate] div: [right evaluate]];
        case POW: return [[left evaluate] pow: [right evaluate]];
    }
}

@end

