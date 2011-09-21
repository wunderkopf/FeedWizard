//
//  PreferencesWindowController.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/16/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "PreferencesWindowController.h"

@implementation PreferencesWindowController

@synthesize toolBar = _toolBar;
@synthesize generalView = _generalView;
@synthesize rssView = _rssView;
@synthesize updatePopUpButton = _updatePopUpButton;
@synthesize removePopUpButton = _removePopUpButton;

- (id)init
{
    self = [super initWithWindowNibName:@"PreferencesWindow"];
    
    if (self != nil) 
    {
    }
	
    return self;
}

- (void)switchToViewWithTag:(NSInteger)tag 
{	
	NSView *view = [self viewWithTag:tag];
	NSView *previousView = [self viewWithTag:_currentViewTag];
	_currentViewTag = tag;
	NSRect newFrame = [self newFrameForNewContentView:view];
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.1];
	
	if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
	    [[NSAnimationContext currentContext] setDuration:1.0];
	
	[[[self.window contentView] animator] replaceSubview:previousView with:view];
    
    [self.window setTitle:[self viewTitleWithTag:tag]];
    
	[[self.window animator] setFrame:newFrame display:YES];
	
	[NSAnimationContext endGrouping];
}

- (void)awakeFromNib 
{	
	[self.window setContentSize:[_rssView frame].size];
	[[self.window contentView] addSubview:_rssView];
	[_toolBar setSelectedItemIdentifier:@"RSS"];
    [self.window setTitle:[self viewTitleWithTag:1]];
	[self.window center];
    
    PSClient *client = [PSClient applicationClient];
    NSTimeInterval interval = [[client settings] refreshInterval];
    [_updatePopUpButton selectItemWithTag:(NSInteger)interval];
    
    interval = [[client settings] expirationInterval];
    [_removePopUpButton selectItemWithTag:(NSInteger)interval];
}

- (IBAction)doSwitchView:(id)sender
{
    NSInteger tag = [sender tag];
	[self switchToViewWithTag:tag];
}

- (NSString *)viewTitleWithTag:(NSInteger)tag
{
    NSString *title = [NSString string];
    
    switch (tag) 
    {
		case 0: 
        default: 
            title = [NSString stringWithString:NSLocalizedString(@"General", nil)]; 
            break;
		case 1: 
            title = [NSString stringWithString:NSLocalizedString(@"RSS", nil)]; 
            break;
	}
    return title;
}

- (NSView *)viewWithTag:(NSInteger)tag
{
    NSView *view = nil;
	switch (tag) 
    {
		case 0: 
        default: 
            view = _generalView; 
            break;
		case 1: 
            view = _rssView; 
            break;
	}
    return view;
}

- (NSRect)newFrameForNewContentView:(NSView *)view
{
    NSRect newFrameRect = [self.window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [self.window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;    
    NSRect frame = [self.window frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}

/*- (void)showWindow:(id)sender withTag:(NSInteger)tag
{
    [super showWindow:sender];
    
	[self switchToViewWithTag:tag];
	[_toolBar setSelectedItemIdentifier:@"RSS"];
}*/

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar 
{
	return [[_toolBar items] valueForKey:@"itemIdentifier"];
}

- (IBAction)doChangeUpdateInterval:(id)sender
{
    PSClient *client = [PSClient applicationClient];
    PSFeedSettings *settings = client.settings;
    NSMenuItem *selectedItem = [sender selectedItem];
    NSTimeInterval interval = (NSTimeInterval)selectedItem.tag;
    settings.refreshInterval = interval;
    client.settings = settings;
}

- (IBAction)doChangeExpirationInterval:(id)sender
{
    PSClient *client = [PSClient applicationClient];
    PSFeedSettings *settings = client.settings;
    NSMenuItem *selectedItem = [sender selectedItem];
    NSTimeInterval interval = (NSTimeInterval)selectedItem.tag;
    settings.expirationInterval = interval;
    client.settings = settings;
}

@end
