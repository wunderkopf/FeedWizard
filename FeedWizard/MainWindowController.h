//
//  MainWindowController.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 8/31/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "PXSourceList.h"
#import <WebKit/WebKit.h>

@class SubscribeWindowController;
@class AMButtonBar;
@class FeedSettingsWindowController;
@class EntrySettingsWindowController;
@class EntryTableView;

@interface MainWindowController : NSWindowController <PXSourceListDelegate, PXSourceListDataSource, NSTableViewDelegate/*, PSClientDelegate*/>
{
@private
    NSSplitView *_mainSplitView;
    PXSourceList *_navigationSourceList;
    NSMutableArray *_navigationItems;
    NSOperationQueue *_feedQueue;
    id _refreshNotification;
    id _currentItem;
    NSArrayController *_entryArrayController;
    WebView *_webView;
    EntryTableView *_entriesTableView;
    NSScrollView *_entriesScrollView;
    NSScrollView *_navigationScrollView;
    SubscribeWindowController *_subscribeWindowController;
    NSMenu *_feedMenu;
    NSString *_articleText;
    NSString *_emptyArticleText;
    AMButtonBar *_displayModeButtonBar;
    FeedSettingsWindowController *_feedSettingsWindowController;
    EntrySettingsWindowController *_entrySettingsWindowController;
    NSMenu *_entryMenu;
    BOOL _runSubscribe;
    NSString *_subscriptionURL;
    NSView *_emptyEntryView;
    NSView *_webEntryView;
}

@property (assign) IBOutlet NSSplitView *mainSplitView;
@property (assign) IBOutlet PXSourceList *navigationSourceList;
@property (assign) id currentItem;
@property (assign) IBOutlet NSArrayController *entryArrayController;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet EntryTableView *entriesTableView;
@property (assign) IBOutlet NSScrollView *entriesScrollView;
@property (assign) IBOutlet NSScrollView *navigationScrollView;
@property (assign) IBOutlet NSMenu *feedMenu;
@property (assign) IBOutlet AMButtonBar *displayModeButtonBar;
@property (assign) IBOutlet NSMenu *entryMenu;
@property (assign) IBOutlet NSView *emptyEntryView;
@property (assign) IBOutlet NSView *webEntryView;

- (IBAction)doSubscribe:(id)sender;
- (IBAction)doUnsubscribe:(id)sender;
- (IBAction)doFeedSettings:(id)sender;
- (IBAction)doOpenFeedHome:(id)sender;
- (IBAction)doOpenFeedHomeInBrowser:(id)sender;
- (IBAction)doChangeFlag:(id)sender;
- (IBAction)doEntrySettings:(id)sender;
- (IBAction)doOpenEntryInBrowser:(id)sender;
- (IBAction)doImportOPML:(id)sender;
- (IBAction)doMarkAllAsRead:(id)sender;
- (IBAction)doMarkAllAsUnread:(id)sender;

- (NSView *)leftPane;
- (NSView *)centerPane;
- (NSView *)rightPane;

@end
