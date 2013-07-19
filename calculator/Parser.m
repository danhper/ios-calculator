//
//  Parser.m
//  Test
//
//  Created by Daniel Perez on 7/19/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import "Parser.h"

@implementation Parser

- (id)initWithLexer:(Lexer*) lex
{
    lexer = lex;
    return self;
}

- (NSObject<AbstractSyntaxTree>*)run
{
    return [self parseExpression];
}

- (NSObject<AbstractSyntaxTree>*)parseExpression
{
    NSObject<AbstractSyntaxTree>* term = [self parseTerm];
    NSObject<Token>* token = [lexer currentToken];
    while([token getType] == SymbTok && (
                                         [(SymbToken*)token value] == '+' || [(SymbToken*)token value] == '-')) {
        NSObject<AbstractSyntaxTree>* nextTerm = [self parseTerm];
        if([(SymbToken*)token value] == '+') {
            term = [[BinaryApp alloc] initWithValues:ADD :term :nextTerm];
        } else if([(SymbToken*)token value] == '-') {
            term = [[BinaryApp alloc] initWithValues:SUB :term :nextTerm];
        }
        token = [lexer currentToken];
    }
    return term;
}

- (NSObject<AbstractSyntaxTree>*)parseTerm
{
    NSObject<AbstractSyntaxTree>* factor = [self parseFactor];
    NSObject<Token>* token = [lexer currentToken];
    while([token getType] == SymbTok && [(SymbToken*)token value] == '^') {        NSObject<AbstractSyntaxTree>* nextFactor = [self parseFactor];
        factor = [[BinaryApp alloc] initWithValues:POW :factor :nextFactor];
        token = [lexer currentToken];
    }
    return factor;    
}

- (NSObject<AbstractSyntaxTree>*)parseFactor
{
    NSObject<AbstractSyntaxTree>* atom = [self parseAtom];
    NSObject<Token>* token = [lexer currentToken];
    while([token getType] == SymbTok && (
                                         [(SymbToken*)token value] == '*' || [(SymbToken*)token value] == '/')) {
        NSObject<AbstractSyntaxTree>* nextAtom = [self parseTerm];
        if([(SymbToken*)token value] == '*') {
            atom = [[BinaryApp alloc] initWithValues:MUL :atom :nextAtom];
        } else {
            atom = [[BinaryApp alloc] initWithValues:DIV :atom :nextAtom];
        }
        token = [lexer currentToken];
    }
    return atom;
}

- (NSObject<AbstractSyntaxTree>*)parseAtom
{
    NSObject<Token>* token = [lexer nextToken];
    NSObject<AbstractSyntaxTree>* tree;
    switch ([token getType]) {
        case IntTok:
            tree = [[IntValue alloc] initWithValue:[(IntToken*)token value]];
            break;
        case RealTok:
            tree = [[DoubleValue alloc] initWithValue:[(RealToken*)token value]];
            break;
        case SymbTok: {
            char c = [(SymbToken*)token value];
            if(c == '(') {
                tree = [self parseExpression];
            } else if(c == 'r') {
                tree = [[UnaryApp alloc] initWithValues:SQRT :[self parseExpression]];
            }
            break;
        }
        default:
            break;
    }
    token = [lexer nextToken];
    
    return tree;
}

@end
