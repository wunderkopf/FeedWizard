//
//  Entry.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/8/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

@interface Entry : NSObject
{
@private
    PSEntry *_entry;
}

@property (nonatomic, assign) PSEntry *entry;
@property (readonly, assign) NSString *titleForDisplay;
@property (readonly, assign) NSDate *dateForDisplay;
@property (readonly, assign) NSString *content;
@property (readonly, assign) NSURL *baseURL;
@property (readonly, assign) NSURL *alternateURL;
@property (getter = isRead, setter = setRead:) BOOL read;
@property (readonly, assign) NSString *feedTitle;
@property (readonly, assign) NSImage *feedLogo;
@property (assign) BOOL flagged;
@property (readonly, assign) NSString *summary;

+ (id)itemWithEntry:(PSEntry *)entry;
- (BOOL)isUnread;

@end
