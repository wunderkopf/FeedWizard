//
//  StuffSourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/7/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "StuffSourceListItem.h"
#import "AllSourceListItem.h"

@implementation StuffSourceListItem

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.title = @"STUFF";
        self.identifier = @"stuff";
        self.icon = nil;
        
        /*SourceListItem *stuffAllItem = [SourceListItem itemWithTitle:@"All" identifier:@"stuff-all" 
                                                                icon:[NSImage imageNamed:@"rss"]];
        
        
        PSClient *client = [PSClient applicationClient];
        NSArray *feeds = [client feeds];
        __block NSInteger unreadCount = 0;
        
        [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) 
         {
             //FeedItemSourceListItem *feedItem = [FeedItemSourceListItem itemWithFeed:item];
             //[_children addObject:feedItem];
             PSFeed *feed = item;
             unreadCount += feed.unreadCount;
         }];
        stuffAllItem.badge = unreadCount;*/
        
        AllSourceListItem *stuffAllItem = [[AllSourceListItem alloc] init];
        
        SourceListItem *stuffStarredItem = [SourceListItem itemWithTitle:@"Starred" identifier:@"stuff-starred" 
                                                                    icon:[NSImage imageNamed:@"star"]];
        SourceListItem *stuffNotesItem = [SourceListItem itemWithTitle:@"Notes" identifier:@"stuff-notes"
                                                                  icon:[NSImage imageNamed:@"note"]];
        
        self.children = [NSArray arrayWithObjects:stuffAllItem, stuffStarredItem, stuffNotesItem, nil];
    }
    
    return self;
}

@end
