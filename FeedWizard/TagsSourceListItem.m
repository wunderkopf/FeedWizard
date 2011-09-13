//
//  TagsSourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/13/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "TagsSourceListItem.h"

@implementation TagsSourceListItem

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.title = @"TAGS";
        self.identifier = @"tags";
        self.icon = nil;        
    }
    
    return self;
}


@end
