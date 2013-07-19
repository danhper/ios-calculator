//
//  Lexer.h
//  calculator
//
//  Created by Daniel Perez on 7/18/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IntTok,
    RealTok,
    SymbTok,
    IdentTok
} TokenType;

@protocol Token <NSObject>
- (TokenType) getType;
@end

@interface IntToken : NSObject <Token>
@property (readonly) int value;
- (id)initWithValue: (int)value;
@end

@interface RealToken : NSObject <Token>
@property (readonly) double value;
- (id)initWithValue: (double)value;
@end

@interface SymbToken : NSObject <Token>
@property (readonly) NSString* value;
- (id)initWithValue: (NSString*)value;
- (BOOL)eqChar: (char)value;
- (BOOL)eqString: (NSString*) value;
@end

@interface IdentToken : NSObject <Token>
@property (readonly) NSString* value;
- (id)initWithValue: (NSString*)value;
@end

@interface Lexer : NSObject {
    @private char* buffer;
    @private unsigned long position;
    @private unsigned long maxPosition;
    @private id<Token> _currentToken;
}

- (id) initWithString:(NSString*)string;
- (id<Token>) nextToken;
- (id<Token>) currentToken;
- (id<Token>) eatToken;

@end


