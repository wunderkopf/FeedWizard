//
//  Entry.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/8/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "Entry.h"
#import "AppDelegate.h"

@implementation Entry

@synthesize entry = _entry;
@synthesize flagged;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}

+ (id)itemWithEntry:(PSEntry *)entry
{
    Entry *newEntry = [[Entry alloc] init];
    newEntry.entry = entry;
    return newEntry;
}

- (NSString *)titleForDisplay
{
    return _entry.titleForDisplay;
}

- (NSDate *)dateForDisplay
{
    return _entry.dateForDisplay;
}

- (NSString *)content
{
    return _entry.content.HTMLString;
}

- (NSURL *)baseURL
{
    return _entry.baseURL;
}

- (BOOL)isRead
{
    return [_entry isRead];
}

- (void)setRead:(BOOL)state
{
    [_entry setRead:state];
}

- (BOOL)isUnread
{
    return ![self isRead];
}

- (NSString *)feedTitle
{
    return _entry.feed.title;
}

- (NSURL *)alternateURL
{
    return _entry.alternateURL;
}

- (BOOL)flagged
{
    return _entry.flagged;
}

- (void)setFlagged:(BOOL)state
{
    _entry.flagged = state;
}

- (NSImage *)feedLogo
{
    return [AppDelegate logoWithFeedIdentifier:_entry.feed.identifier];
}

- (NSString *)summary
{
    return _entry.summary.HTMLString;
}

@end
