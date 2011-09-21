//
//  MainWindowController-PSClientDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/8/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"
#import "NotifyController.h"

@implementation MainWindowController (PSClientDelegate)

- (void)feedDidBeginRefresh:(PSFeed *)feed
{
    //NSLog(@"Refresh of '%@' did begin", feed.title);
}

- (void)feedDidEndRefresh:(PSFeed *)feed
{
    //NSLog(@"Refresh of '%@' did end", feed.title);
}

- (void)feed:(PSFeed *)feed didAddEntries:(NSArray *)entries
{
    NSString *description = [NSString stringWithFormat:NSLocalizedString(@"Added %lu entries to '%@' feed", nil), [entries count], feed.title];
    [[NotifyController sharedNotifyController] infoWithTitle:NSLocalizedString(@"New feed entries", nil) andDescription:description];
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed];
}

- (void)feed:(PSFeed *)feed didRemoveEntriesWithIdentifiers:(NSArray *)identifiers
{
    Info(@"Removed %lu entries from '%@' feed", [identifiers count], feed.title);
    NSString *description = [NSString stringWithFormat:NSLocalizedString(@"Removed %lu entries from '%@' feed", nil), [identifiers count], feed.title];
    [[NotifyController sharedNotifyController] infoWithTitle:NSLocalizedString(@"Removed feed entries", nil) andDescription:description];
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed];
}

- (void)feed:(PSFeed *)feed didUpdateEntries:(NSArray *)entries
{
    Info(@"Updated %lu entries in '%@' feed", [entries count], feed.title);
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed];
}

- (void)feed:(PSFeed *)feed didChangeFlagsInEntries:(NSArray *)entries
{
    Info(@"Changed flags for %lu entries in '%@' feed", [entries count], feed.title);
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed];
}

- (void)enclosure:(PSEnclosure *)enclosure downloadStateDidChange:(PSEnclosureDownloadState)state
{
    Info(@"Enclosure '%@' download state changed to %d", enclosure.MIMEType, state);
}

@end