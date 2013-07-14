//
//  ViewController.m
//  calculator
//
//  Created by Daniel Perez on 7/15/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import "ViewController.h"

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
    NSLog(@"received event with text: %@", [sender currentTitle]);
    NSString *newText = [self.textField.text stringByAppendingString:[sender currentTitle]];
    self.textField.text = newText;
}

-(IBAction)evaluateResult:(id)sender {
    
}

@end
