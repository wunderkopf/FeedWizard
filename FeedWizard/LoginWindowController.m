//
//  LoginWindowController.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "LoginWindowController.h"
#import "Storage.h"

@implementation LoginWindowController

@synthesize progressIndicator = _progressIndicator;

- (id)init
{
    self = [super initWithWindowNibName:@"LoginWindow"];
    
    if (self != nil) {
    }
	
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)doShowSheet:(id)sender 
{
    [super doShowSheet:sender];
    
    [_progressIndicator startAnimation:sender];
    
    /*if ([[FWStorage sharedStorage] loginForEmail:@"wunderkopf@gmail.com" withPassword:@"wunderkopf123"]) {
        NSLog(@"Log in successfully");
        [self doCloseSheet:sender];
    }
    else
        NSLog(@"Log in failed");
    
    [_progressIndicator stopAnimation:sender];*/
}

@end
