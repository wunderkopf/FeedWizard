//
//  MainWindowController-PSClientDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/8/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"

@implementation MainWindowController (PSClientDelegate)

- (void)feedDidBeginRefresh:(PSFeed *)feed
{
    //NSLog(@"Refresh of '%@' did begin", feed.title);
}

- (void)feedDidEndRefresh:(PSFeed *)feed
{
    //NSLog(@"Refresh of '%@' did end", feed.title);
    //NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    //[notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed];
}

- (void)feed:(PSFeed *)feed didAddEntries:(NSArray *)entries
{
    NSLog(@"Added %lu entries to '%@' feed", [entries count], feed.title);
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed];
}

- (void)feed:(PSFeed *)feed didRemoveEntriesWithIdentifiers:(NSArray *)identifiers
{
    NSLog(@"Removed %lu entries from '%@' feed", [identifiers count], feed.title);
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed];
}

- (void)feed:(PSFeed *)feed didUpdateEntries:(NSArray *)entries
{
    NSLog(@"Updated %lu entries in '%@' feed", [entries count], feed.title);
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed];
}

- (void)feed:(PSFeed *)feed didChangeFlagsInEntries:(NSArray *)entries
{
    NSLog(@"Changed flags for %lu entries in '%@' feed", [entries count], feed.title);
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed];
}

- (void)enclosure:(PSEnclosure *)enclosure downloadStateDidChange:(PSEnclosureDownloadState)state
{
    NSLog(@"Enclosure '%@' download state changed to %d", enclosure.MIMEType, state);
}

@end