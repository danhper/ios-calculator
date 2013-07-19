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


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)updateText:(id)sender
{
    NSString *newText = [[[self textField] text] stringByAppendingString:[sender currentTitle]];
    self.textField.text = newText;
}

-(IBAction)clearText:(id)sender
{
    [self textField].text = @"";
}

-(IBAction)removeLastCharacter:(id)sender
{
    NSString* str = [[self textField] text];
    if([str length] == 0) {
        return;
    }
    [self textField].text = [str substringToIndex:[str length] - 1];
}

-(IBAction)evaluateResult:(id)sender
{
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}


@end
