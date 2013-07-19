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
                                         [(SymbToken*)token eqChar:'+'] || [(SymbToken*)token eqChar:'-'])) {
        [lexer nextToken];
        NSObject<AbstractSyntaxTree>* nextTerm = [self parseTerm];
        if([(SymbToken*)token eqChar: '+']) {
            term = [[BinaryApp alloc] initWithValues:ADD :term :nextTerm];
        } else if([(SymbToken*)token eqChar:'-']) {
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
    while([token getType] == SymbTok && [(SymbToken*)token eqChar:'^']) {
        [lexer nextToken];
        NSObject<AbstractSyntaxTree>* nextFactor = [self parseFactor];
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
                                         [(SymbToken*)token eqChar:'*'] || [(SymbToken*)token eqChar:'/'])) {
        [lexer nextToken];
        NSObject<AbstractSyntaxTree>* nextAtom = [self parseTerm];
        if([(SymbToken*)token eqChar: '*']) {
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
    NSObject<Token>* token = [lexer eatToken];
    NSObject<AbstractSyntaxTree>* tree = nil;
    switch ([token getType]) {
        case IntTok:
            tree = [[IntValue alloc] initWithValue:[(IntToken*)token value]];
            break;
        case RealTok:
            tree = [[DoubleValue alloc] initWithValue:[(RealToken*)token value]];
            break;
        case SymbTok:
            tree = [self parseSymbAtom:(SymbToken*)token];
            break;
        case IdentTok:
            tree = [self parseIdentAtom:token];
            break;
        default:
            break;
    }
    
    NSObject<Token>* nextToken = [lexer currentToken];
    
    if([nextToken getType] == SymbTok && [(SymbToken*)nextToken eqChar:'!']) {
        [lexer eatToken];
        tree = [[UnaryApp alloc] initWithValues:FACT :tree];
    }
        
    return tree;
}

- (NSObject<AbstractSyntaxTree>*) parseSymbAtom:(SymbToken*)tok
{
    NSObject<AbstractSyntaxTree>* tree = nil;
    if([tok eqChar: '(']) {
        tree = [self parseExpression];
        NSObject<Token>* token = [lexer eatToken];
        if([token getType] != SymbTok || ![(SymbToken*)token eqChar:')']) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:[NSString stringWithFormat :@"closing bracket not found"]
                                         userInfo:nil];
        }
    } else if([tok eqString:@"√"]) {
        tree = [[UnaryApp alloc] initWithValues:SQRT :[self parseExpression]];
    } else if([tok eqString:@"π"]) {
        tree = [[Variable alloc] initWithName:[tok value]];
    }
    return tree;
}

- (NSObject<AbstractSyntaxTree>*)parseIdentAtom:(NSObject<Token>*)token {
    NSObject<AbstractSyntaxTree>* tree = nil;
    NSObject<Token>* nextToken = [lexer currentToken];
    if([nextToken getType] == SymbTok && [(SymbToken*)nextToken eqChar:'(']) {
        [lexer nextToken];
        tree = [[UnaryApp alloc] initWithValues:[self getAppType:[(IdentToken*)token value]] :[self parseExpression]];
        nextToken = [lexer eatToken];
        if([nextToken getType] != SymbTok || ![(SymbToken*)nextToken eqChar:')']) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:[NSString stringWithFormat :@"closing bracket not found"]
                                         userInfo:nil];
        }
    } else {
        tree = [[Variable alloc] initWithName:[(IdentToken*)token value]];
    }
    return tree;
}

- (UnaryAppType) getAppType:(NSString*)str
{
    if([str isEqualToString:@"tan"]) {
        return TAN;
    } else if([str isEqualToString:@"cos"]) {
        return COS;
    } else if([str isEqualToString:@"sin"]) {
        return SIN;
    } else if([str isEqualToString:@"ln"]) {
        return LN;
    } else if([str isEqualToString:@"log"]) {
        return LOG;
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat :@"unknown function %@", str]
                                     userInfo:nil];
    }
}

@end
