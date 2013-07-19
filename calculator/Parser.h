//
//  Parser.h
//  Test
//
//  Created by Daniel Perez on 7/19/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AbstractSyntaxTree.h"
#import "Lexer.h"

@interface Parser : NSObject {
    @private Lexer* lexer;
}
- (id)initWithLexer:(Lexer*) lex;
- (NSObject<AbstractSyntaxTree>*) run;
@end
