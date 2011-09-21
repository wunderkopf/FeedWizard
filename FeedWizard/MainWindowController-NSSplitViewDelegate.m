//
//  MainWindowController-NSSplitViewDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/13/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"

@implementation MainWindowController (NSSplitViewDelegate)

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview 
{
    return NO;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex
{    
    return NO;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    return proposedMinimumPosition + 100;
}

@end