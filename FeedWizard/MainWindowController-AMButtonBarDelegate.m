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

- (void)buttonBarSelectionDidChange:(NSNotification *)notification
{
    //AMButtonBarItem *selectedItem = [notification object];
    
    if ([[_displayModeButtonBar selectedItemIdentifier] compare:@"all-items"] == NSOrderedSame)
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OptDisplayArticlesState];
    else if ([[_displayModeButtonBar selectedItemIdentifier] compare:@"unread-items"] == NSOrderedSame)
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:OptDisplayArticlesState];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:nil];
    
    //[_entriesTableView reloadData];
}

@end