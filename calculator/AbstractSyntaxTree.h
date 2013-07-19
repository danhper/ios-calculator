//
//  AbstractSyntaxTree.h
//  Test
//
//  Created by Daniel Perez on 7/18/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    INT_VALUE, DOUBLE_VALUE
} ValueType;

typedef enum {
    FACT, COS, SIN, TAN, SQRT, LN, LOG
} UnaryAppType;

typedef enum {
    ADD, SUB, MUL, DIV, POW
} BinaryAppType;

@protocol Value;

@protocol AbstractSyntaxTree <NSObject>
- (NSObject<Value>*) evaluate;
@end

@protocol Value <AbstractSyntaxTree>
- (ValueType) getType;
- (double) getDoubleValue;
- (NSObject<Value>*) add:(NSObject<Value>*) other;
- (NSObject<Value>*) sub:(NSObject<Value>*) other;
- (NSObject<Value>*) mul:(NSObject<Value>*) other;
- (NSObject<Value>*) div:(NSObject<Value>*) other;
- (NSObject<Value>*) pow:(NSObject<Value>*) other;
@end

@interface IntValue : NSObject<Value>
@property (readonly) long value;
- (id)initWithValue:(long)v;
@end

@interface DoubleValue : NSObject<Value>
@property (readonly) double value;
- (id)initWithValue:(double)v;
@end

@interface Variable : NSObject<AbstractSyntaxTree> {
    @protected NSString* name;
}
+ (void)initVariables;
- (id)initWithName:(NSString*)n;
@end

@interface UnaryApp : NSObject<AbstractSyntaxTree> {
    @protected UnaryAppType type;
    @protected NSObject<AbstractSyntaxTree>* elem;
}
- (id)initWithValues:(UnaryAppType)type :(NSObject<AbstractSyntaxTree>*)e;
@end

@interface BinaryApp : NSObject<AbstractSyntaxTree> {
    @protected BinaryAppType type;
    @protected NSObject<AbstractSyntaxTree>* left;
    @protected NSObject<AbstractSyntaxTree>* right;
}
- (id)initWithValues:(BinaryAppType)t :(NSObject<AbstractSyntaxTree>*)l :(NSObject<AbstractSyntaxTree>*)r;
@end
