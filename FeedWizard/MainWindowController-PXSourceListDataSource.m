//
//  MainWindowController-PXSourceListDataSource.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"
#import "SourceListItem.h"
#import "FeedSourceListItem.h"

@implementation MainWindowController (PXSourceListDataSource)

- (NSUInteger)sourceList:(PXSourceList *)sourceList numberOfChildrenOfItem:(id)item
{
	if (item == nil)
		return [_navigationItems count];
	else
		return [[item children] count];
}

- (id)sourceList:(PXSourceList *)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	if (item == nil)
		return [_navigationItems objectAtIndex:index];
	else
		return [[item children] objectAtIndex:index];
}

- (id)sourceList:(PXSourceList *)aSourceList objectValueForItem:(id)item
{
	return [item title];
}

- (void)sourceList:(PXSourceList *)aSourceList setObjectValue:(id)object forItem:(id)item
{
	[item setTitle:object];
}

- (BOOL)sourceList:(PXSourceList *)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}

- (BOOL)sourceList:(PXSourceList *)aSourceList itemHasBadge:(id)item
{
	return [item hasBadge];
}

- (NSInteger)sourceList:(PXSourceList *)aSourceList badgeValueForItem:(id)item
{
	return [item badge];
}

- (BOOL)sourceList:(PXSourceList *)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
}

- (NSImage*)sourceList:(PXSourceList *)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(PXSourceList *)aSourceList menuForEvent:(NSEvent *)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || 
        ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) 
    {
        if ([item isKindOfClass:[FeedSourceListItem class]])
            return _feedMenu;
	}
    
	return nil;
}

@end