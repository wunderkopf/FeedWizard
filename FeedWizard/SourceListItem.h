//
//  SourceListItem.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

@interface SourceListItem : NSObject 
{
@protected
	NSString *_title;
	NSString *_identifier;
	NSImage *_icon;
	NSInteger _badge;
	NSMutableArray *_children;
    NSMutableArray *_items;
}

@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *identifier;
@property (nonatomic, assign) NSImage *icon;
@property (nonatomic) NSInteger badge;
@property (nonatomic, assign) NSArray *children;
@property (nonatomic, assign) NSArray *items;

+ (id)itemWithTitle:(NSString *)title identifier:(NSString *)identifier;
+ (id)itemWithTitle:(NSString *)title identifier:(NSString *)identifier icon:(NSImage *)icon;

- (BOOL)hasBadge;
- (BOOL)hasChildren;
- (BOOL)hasIcon;

@end
