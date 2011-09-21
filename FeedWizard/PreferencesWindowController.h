//
//  PreferencesWindowController.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/16/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

@interface PreferencesWindowController : NSWindowController <NSToolbarDelegate>
{
@private
    NSInteger _currentViewTag;
	NSToolbar *_toolBar;
	NSView *_generalView;
    NSView *_rssView;
    NSPopUpButton *_updatePopUpButton;
    NSPopUpButton *_removePopUpButton;
}

@property (assign) IBOutlet NSToolbar *toolBar;
@property (assign) IBOutlet NSView *generalView;
@property (assign) IBOutlet NSView *rssView;
@property (assign) IBOutlet NSPopUpButton *updatePopUpButton;
@property (assign) IBOutlet NSPopUpButton *removePopUpButton;

- (IBAction)doSwitchView:(id)sender;
- (IBAction)doChangeUpdateInterval:(id)sender;
- (IBAction)doChangeExpirationInterval:(id)sender;

- (NSView *)viewWithTag:(NSInteger)tag;
- (NSString *)viewTitleWithTag:(NSInteger)tag;
- (NSRect)newFrameForNewContentView:(NSView *)view;
//- (void)showWindow:(id)sender withTag:(NSInteger)tag;

@end
