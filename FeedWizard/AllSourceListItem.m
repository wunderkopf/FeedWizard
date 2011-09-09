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
    PSClient *client = [PSClient applicationClient];
    NSArray *feeds = [client feeds];
    __block NSInteger unreadCount = 0;
    
    [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        PSFeed *feed = item;
        //FeedSourceListItem *feedItem = [FeedSourceListItem itemWithFeed:feed];
        //[_items addObject:feedItem];
        unreadCount += feed.unreadCount;
        
        __block NSMutableArray *entries = [NSMutableArray array];
        
        [feed.entries enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            Entry *entry = [Entry itemWithEntry:item];
            [entries addObject:entry];
        }];
        
        [_items addObjectsFromArray:entries];
    }];
    
    self.badge = unreadCount;
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.title = @"All";
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
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:ReloadDataNotification object:self.identifier];
}

@end