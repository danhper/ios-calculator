//
//  ViewController.h
//  calculator
//
//  Created by Daniel Perez on 7/15/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;

-(IBAction)updateText:(id)sender;

-(IBAction)evaluateResult:(id)sender;

@end
