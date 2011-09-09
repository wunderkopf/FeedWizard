//
//  FeedSourceListItem.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/7/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "SourceListItem.h"

@interface FeedSourceListItem : SourceListItem
{
@private
    PSFeed *_feed;
}

@property (nonatomic, assign) PSFeed *feed;

+ (id)itemWithFeed:(PSFeed *)feed;

@end
