//
//  FeedSourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/7/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "FeedSourceListItem.h"
#import "Entry.h"
#import "Storage.h"

@implementation FeedSourceListItem

@synthesize feed = _feed;

- (id)init
{
    self = [super init];
    if (self) 
    {
        //_icon = [NSImage imageNamed:@"feed-default"];
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
    BOOL displayState = [[NSUserDefaults standardUserDefaults] boolForKey:OptDisplayArticlesState];
    __block NSMutableArray *entries = [NSMutableArray array];
    
    [_feed.entries enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        Entry *entry = [Entry itemWithEntry:item];
        if (displayState)
            [entries addObject:entry];
        else
        {
            if ([entry isUnread])
                [entries addObject:entry];
        }
    }];
    
    return entries;
}

- (BOOL)hasIcon
{
	return YES;
}

- (NSImage *)icon
{
    return [[Storage sharedStorage] logoWithFeedIdentifier:_feed.identifier];
}

@end
