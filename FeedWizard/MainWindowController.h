//
//  MainWindowController.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 8/31/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "PXSourceList.h"
#import <WebKit/WebKit.h>

//@class LoginWindowController;
@class SubscribeWindowController;

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
    //LoginWindowController *_loginWindowController;
    WebView *_webView;
    NSTableView *_entriesTableView;
    NSScrollView *_entriesScrollView;
    NSScrollView *_navigationScrollView;
    SubscribeWindowController *_subscribeWindowController;
    NSMenu *_feedMenu;
}

@property (assign) IBOutlet NSSplitView *mainSplitView;
@property (assign) IBOutlet PXSourceList *navigationSourceList;
@property (assign) id currentItem;
@property (assign) IBOutlet NSArrayController *entryArrayController;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSTableView *entriesTableView;
@property (assign) IBOutlet NSScrollView *entriesScrollView;
@property (assign) IBOutlet NSScrollView *navigationScrollView;
@property (assign) IBOutlet NSMenu *feedMenu;

- (IBAction)doSomething:(id)sender;
- (IBAction)doSubscribe:(id)sender;
- (IBAction)doUnsubscribe:(id)sender;
- (IBAction)doFeedSettings:(id)sender;
- (IBAction)doOpenFeedHome:(id)sender;
- (IBAction)doOpenFeedHomeInBrowser:(id)sender;

@end
