//
//  ViewController.m
//  calculator
//
//  Created by Daniel Perez on 7/15/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import "ViewController.h"
#import "Parser.h"
#import "AbstractSyntaxTree.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)updateText:(id)sender {
    NSString *newText = [[[self textField] text] stringByAppendingString:[sender currentTitle]];
    self.textField.text = newText;
}

-(IBAction)clearText:(id)sender {
    [self textField].text = @"";
}

-(IBAction)evaluateResult:(id)sender {
    NSString* text = [[self textField] text];
    if([[[self textField] text] length] == 0) {
        return;
    }
    @autoreleasepool {
        @try {
            Lexer* lexer = [[Lexer alloc] initWithString: text];
            Parser* parser = [[Parser alloc] initWithLexer:lexer];
            NSObject<AbstractSyntaxTree>* tree = [parser run];
            NSObject<Value>* result = [tree evaluate];
            if([result getType] == INT_VALUE) {
                [self textField].text = [NSString stringWithFormat:@"%ld", [(IntValue*)result value]];
            } else {
                [self textField].text = [NSString stringWithFormat:@"%g", [result getDoubleValue]];
            }
        }
        @catch (NSException *exception) {
            [self textField].text = @"error";
        }
    }
}

@end
