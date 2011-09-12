//
//  MainWindowController-PXSourceListDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"
#import "SourceListItem.h"

@implementation MainWindowController (PXSourceListDelegate)

- (BOOL)sourceList:(PXSourceList *)aSourceList isGroupAlwaysExpanded:(id)group
{
	if([[group identifier] isEqualToString:@"stuff"])
		return YES;
    return NO;
}

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupExpanded:(id)group
{
    return YES;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{    
    NSIndexSet *selectedIndexes = [_navigationSourceList selectedRowIndexes];
    
    _currentItem = [_navigationSourceList itemAtRow:[selectedIndexes firstIndex]];
    [_entryArrayController setContent:((SourceListItem *)_currentItem).items];
    [_entryArrayController setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"dateForDisplay" ascending:NO]]];
    //[_entryArrayController setSelectionIndex:[selectedIndexes firstIndex]];
}

- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}

@end