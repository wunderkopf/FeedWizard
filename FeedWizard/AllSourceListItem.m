//
//  AllSourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/8/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "AllSourceListItem.h"
#import "FeedSourceListItem.h"
#import "Entry.h"

@implementation AllSourceListItem

- (void)reloadData
{
    BOOL displayState = [[NSUserDefaults standardUserDefaults] boolForKey:OptDisplayArticlesState];
    PSClient *client = [PSClient applicationClient];
    NSArray *feeds = [client feeds];
    __block NSInteger unreadCount = 0;
    _items = nil;
    _items = [NSMutableArray array];
    
    [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        PSFeed *feed = item;
        unreadCount += feed.unreadCount;
        
        __block NSMutableArray *entries = [NSMutableArray array];
        
        [feed.entries enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            Entry *entry = [Entry itemWithEntry:item];
            if (displayState)
                [entries addObject:entry];
            else
            {
                if ([entry isUnread])
                    [entries addObject:entry];
            }
        }];
        
        [_items addObjectsFromArray:entries];
    }];
    
    if (unreadCount > 0)
    {
        self.badge = unreadCount;
        NSDockTile *tile = [[NSApplication sharedApplication] dockTile];
        [tile setBadgeLabel:[NSString stringWithFormat:@"%d", unreadCount]];
    }
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.title = NSLocalizedString(@"All", nil);
        self.identifier = @"stuff-all";
        self.icon = [NSImage imageNamed:@"rss"];
        
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter addObserver:self selector:@selector(dataChanged:) name:FeedDidEndRefreshNotification object:nil];
        
        [self reloadData];
    }
    
    return self;
}

- (void)dataChanged:(NSNotification *)notification
{
    [self reloadData];
    //NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    //[notifyCenter postNotificationName:ReloadDataNotification object:self.identifier];
}

@end
