//
//  AppDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 8/31/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "Storage.h"

NSString * const FeedDidEndRefreshNotification = @"FeedDidEndRefreshNotification";
NSString * const ReloadDataNotification = @"ReloadDataNotification";

NSString * const OptDisplayArticlesState = @"DisplayArticlesState";

@implementation AppDelegate

@synthesize mainWindowController = _mainWindowController;

- (id)init
{
    self = [super init];
    
    if (self != nil) 
    {
        PSClient *client = [PSClient applicationClient];
        if (![client isPrivate])
            [client setPrivate:YES];
        
        _mainWindowController = [[MainWindowController alloc] init];
    }
	
    return self;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender 
{
    if ([[Storage sharedStorage] close])
        return NSTerminateNow;
    else
        return NSTerminateCancel;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_mainWindowController showWindow:self];
}

- (void)dealloc
{
     _mainWindowController = nil;
    
    [super dealloc];
}

@end
