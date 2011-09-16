//
//  FeedsSourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/7/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "FeedsSourceListItem.h"
#import "FeedSourceListItem.h"
#import "PXSourceList.h"

@implementation FeedsSourceListItem

- (void)reloadData
{
    PSClient *client = [PSClient applicationClient];
    NSArray *feeds = [client feeds];
    _children = nil;
    _children = [NSMutableArray array];
    
    [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        FeedSourceListItem *feedItem = [FeedSourceListItem itemWithFeed:item];
        [_children addObject:feedItem];
    }];
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.title = NSLocalizedString(@"FEEDS", nil);
        self.identifier = @"feeds";
        self.icon = nil;
        
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
