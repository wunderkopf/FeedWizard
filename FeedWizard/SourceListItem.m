//
//  SourceListItem.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "SourceListItem.h"

@implementation SourceListItem

@synthesize title = _title;
@synthesize identifier = _identifier;
@synthesize icon = _icon;
@synthesize badge = _badge;
@synthesize children = _children;
@synthesize items = _items;

- (id)init
{
    self = [super init];
    
    if (self != nil) 
    {
		_badge = -1;
        _children = [NSMutableArray array];
        _items = [NSMutableArray array];
	}
	
	return self;
}

+ (id)itemWithTitle:(NSString *)title identifier:(NSString *)identifier
{	
	SourceListItem *item = [SourceListItem itemWithTitle:title identifier:identifier icon:nil];
	return item;
}

+ (id)itemWithTitle:(NSString *)title identifier:(NSString *)identifier icon:(NSImage *)icon
{
	SourceListItem *item = [[SourceListItem alloc] init];
	
	item.title = title;
	item.identifier = identifier;
	item.icon = icon;
	
	return item;
}

- (BOOL)hasBadge
{
	return _badge != -1;
}

- (BOOL)hasChildren
{
	return [_children count] > 0;
}

- (BOOL)hasIcon
{
	return _icon != nil;
}

/*- (NSArray *)items
{
    return [NSArray array];
}*/

@end
