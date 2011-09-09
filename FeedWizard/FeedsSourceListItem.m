//
//  FeedsSourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/7/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "FeedsSourceListItem.h"
#import "FeedSourceListItem.h"

@implementation FeedsSourceListItem

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.title = @"FEEDS";
        self.identifier = @"feeds";
        self.icon = nil;
        
        PSClient *client = [PSClient applicationClient];
        NSArray *feeds = [client feeds];
        //NSLog(@"%@", feeds);
        //_children = nil;
        //_children = [NSMutableArray array];
        
        [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) 
         {
             PSFeed *feed = item;
             FeedSourceListItem *feedItem = [FeedSourceListItem itemWithFeed:feed];
             //feed.settings.refreshInterval = 300;
             //NSLog(@"%@ has interval %f", feed.title, feed.settings.refreshInterval);
             //[[[[PSClient applicationClient] feedWithIdentifier:feed.identifier] settings] setRefreshInterval:300];
             [_children addObject:feedItem];
         }];
    }
    
    return self;
}

- (void)reloadFeeds
{
    PSClient *client = [PSClient applicationClient];
    NSArray *feeds = [client feeds];
    //NSLog(@"%@", feeds);
    _children = nil;
    _children = [NSMutableArray array];
    
    [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) 
     {
         FeedSourceListItem *feedItem = [FeedSourceListItem itemWithFeed:item];
         [_children addObject:feedItem];
     }];
}

@end
