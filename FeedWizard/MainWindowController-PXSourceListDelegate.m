//
//  MainWindowController-PXSourceListDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"
#import "SourceListItem.h"
#import "StarredSourceListItem.h"
#import "AMButtonBar.h"

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
    
    if ([[self rightPane] superview] != _emptyEntryView)
    {
        [_emptyEntryView setFrame:[[self rightPane] bounds]];
        [[[self rightPane] animator] replaceSubview:_webView with:_emptyEntryView];
        Debug(@"After changing to web view we have %lu subviews.", [[[self rightPane] subviews] count]);
    }
}

- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
    [self doUnsubscribe:nil];
}

@end