//
//  FeedSourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/7/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "FeedSourceListItem.h"
#import "Entry.h"

@implementation FeedSourceListItem

@synthesize feed = _feed;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _icon = [NSImage imageNamed:@"feed-default"];
    }
    
    return self;
}

+ (id)itemWithFeed:(PSFeed *)feed
{
    FeedSourceListItem *item = [[FeedSourceListItem alloc] init];
    
    item.feed = feed;
    
    return item;
}

- (NSString *)title
{
    return _feed.title;
}

- (NSInteger)badge
{
    return _feed.unreadCount;
}

- (BOOL)hasBadge
{
    return _feed.unreadCount > 0;
}

- (NSArray *)items
{
    //return _feed.entries;
    __block NSMutableArray *entries = [NSMutableArray array];
    
    [_feed.entries enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        Entry *entry = [Entry itemWithEntry:item];
        [entries addObject:entry];
     }];
    
    return entries;
}

@end
