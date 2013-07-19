//
//  Lexer.m
//  calculator
//
//  Created by Daniel Perez on 7/18/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import "Lexer.h"

@implementation IntToken

- (id)initWithValue:(int)value
{
    _value = value;
    return self;
}

- (TokenType) getType
{
    return IntTok;
}
@end

@implementation RealToken

- (id)initWithValue:(double)value
{
    _value = value;
    return self;
}

- (TokenType) getType
{
    return RealTok;
}

@end

@implementation SymbToken

- (id)initWithValue:(NSString*)value
{
    _value = value;
    return self;
}

- (TokenType) getType
{
    return SymbTok;
}

- (BOOL)eqChar: (char)val
{
    return [[self value] isEqualToString:[NSString stringWithFormat:@"%c", val]];
}

- (BOOL)eqString: (NSString*) val
{
    return [[self value] isEqualToString:val];
}

@end

@implementation IdentToken

- (id)initWithValue:(NSString*)value
{
    _value = value;
    return self;
}

- (TokenType) getType
{
    return IdentTok;
}

@end

@implementation Lexer

- (id) initWithString:(NSString *)str
{
    buffer = malloc([str lengthOfBytesUsingEncoding:NSUTF8StringEncoding] * sizeof(char));
    strncpy(buffer, [str UTF8String], [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    maxPosition = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    position = 0;
    [self nextToken];
    return self;
}

- (char) peek
{
    return position < maxPosition ? buffer[position] : EOF;
}

- (char) next
{
    [self advance];
    return [self peek];
}

- (void) advance
{
    position++;
}

- (id<Token>) nextToken
{
    while([self peek] == ' ' || [self peek] == '\t') {
        [self advance];
    }
    if([self isNumber:[self peek]]) {
        _currentToken = [self getNumToken];
    } else if([self isChar:[self peek]]) {
        _currentToken = [self getIdentToken];
    } else {
        _currentToken = [self getSymbToken];
    }
    return [self currentToken];
}

- (id<Token>) currentToken
{
    return _currentToken;
}

- (id<Token>) eatToken
{
    id<Token> tok = [self currentToken];
    [self nextToken];
    return tok;
}

- (BOOL) isNumber:(int)c
{
    return c >= '0' && c <= '9';
}

- (BOOL) isChar:(int)c
{
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
}

- (id<Token>) getIdentToken
{
    NSMutableString* str = [[NSMutableString alloc] init];
    char c;
    for(c = [self peek]; [self isChar:c]; c = [self next]) {
        [str appendFormat:@"%c", c];
    }
    return [[IdentToken alloc] initWithValue:str];
}

- (id<Token>) getNumToken
{
    int n = 0;
    for(char c = [self peek]; [self isNumber:c]; c = [self next]) {
        n = n * 10 + (c - '0');
    }
    if([self peek] != '.') {
        return [[IntToken alloc] initWithValue: n];
    } else {
        [self advance];
        return [self getRealToken:n];
    }
}

- (id<Token>) getSymbToken
{
    if([self peek] == -49) {
        char c = [self next];
        if(c == -128) {
            [self advance];
            return [[SymbToken alloc] initWithValue:@"π"];
        }
    }
    NSString* value = [NSString stringWithFormat:@"%c", [self peek]];
    id<Token> token = [[SymbToken alloc] initWithValue:value];
    [self advance];
    return token;
}

- (id<Token>) getRealToken:(int)value
{
    int multiplier = 10;
    double floatingVal = 0;
    for(char c = [self peek]; [self isNumber:c]; c = [self next]) {
        floatingVal += (c - '0') / (double)multiplier;
        multiplier *= 10;
    }
    return [[RealToken alloc] initWithValue:(value + floatingVal)];
}


@end
