//
//  MainWindowController-AMButtonBarDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/12/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"
#import "AMButtonBar.h"

@implementation MainWindowController (AMButtonBarDelegate)

- (void)buttonBarSelectionDidChange:(NSNotification *)aNotification
{
    NSLog(@"AMButtonBar selection did change");
}

@end