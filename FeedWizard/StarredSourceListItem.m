//
//  StarredSourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/12/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "StarredSourceListItem.h"
#import "Entry.h"

@implementation StarredSourceListItem

- (void)reloadData
{
    BOOL displayState = [[NSUserDefaults standardUserDefaults] boolForKey:OptDisplayArticlesState];
    PSClient *client = [PSClient applicationClient];
    NSArray *feeds = [client feeds];
    __block NSInteger starredCount = 0;
    _items = nil;
    _items = [NSMutableArray array];
    
    [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        PSFeed *feed = item;
        __block NSMutableArray *entries = [NSMutableArray array];
        
        [feed.entries enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            Entry *entry = [Entry itemWithEntry:item];
            if (entry.flagged)
            {
                if (displayState)
                    [entries addObject:entry];
                else
                {
                    if ([entry isUnread])
                        [entries addObject:entry];
                }
                starredCount += 1;
            }
        }];
        
        [_items addObjectsFromArray:entries];
    }];
    
    if (starredCount > 0)
        self.badge = starredCount;
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.title = NSLocalizedString(@"Starred", nil);
        self.identifier = @"stuff-starred";
        self.icon = [NSImage imageNamed:@"star"];
        
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
