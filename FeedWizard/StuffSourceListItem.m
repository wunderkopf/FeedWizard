//
//  StuffSourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/7/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "StuffSourceListItem.h"
#import "AllSourceListItem.h"
#import "StarredSourceListItem.h"

@implementation StuffSourceListItem

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.title = @"STUFF";
        self.identifier = @"stuff";
        self.icon = nil;
        
        AllSourceListItem *stuffAllItem = [[AllSourceListItem alloc] init];
        StarredSourceListItem *stuffStarredItem = [[StarredSourceListItem alloc] init];

        self.children = [NSArray arrayWithObjects:stuffAllItem, stuffStarredItem, nil];
    }
    
    return self;
}

@end
