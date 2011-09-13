//
//  MainWindowController.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 8/31/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"

#import "Entry.h"
#import "SourceListItem.h"
#import "StuffSourceListItem.h"
#import "FeedsSourceListItem.h"
#import "FeedSourceListItem.h"
#import "TagsSourceListItem.h"

//#import "LoginWindowController.h"
#import "SubscribeWindowController.h"
#import "FeedSettingsWindowController.h"
#import "EntrySettingsWindowController.h"

#import "INAppStoreWindow.h"

#import "AMButtonBar.h"
#import "AMButtonBarItem.h"
#import "NSGradient_AMButtonBar.h"

NSString * const kUserAgentValue = @"FeedWizard/1.0.0";

@implementation MainWindowController

@synthesize mainSplitView = _mainSplitView;
@synthesize navigationSourceList = _navigationSourceList;
@synthesize currentItem = _currentItem;
@synthesize entryArrayController = _entryArrayController;
@synthesize webView = _webView;
@synthesize entriesTableView = _entriesTableView;
@synthesize entriesScrollView = _entriesScrollView;
@synthesize navigationScrollView = _navigationScrollView;
@synthesize feedMenu = _feedMenu;
@synthesize displayModeButtonBar = _displayModeButtonBar;
@synthesize entryMenu = _entryMenu;

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    
    if (self != nil) 
    {
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter addObserver:self selector:@selector(reloadData:) name:ReloadDataNotification object:nil];
        
        PSClient *client = [PSClient applicationClient];
        client.delegate = self;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"article" ofType:@"html"];
        NSData *articleData = [NSData dataWithContentsOfFile:filePath];
        _articleText = [[NSString alloc] initWithData:articleData encoding:NSStringEncodingConversionAllowLossy];
        
        _navigationItems = [[NSMutableArray alloc] init];

        _subscribeWindowController = [[SubscribeWindowController alloc] init];
        _subscribeWindowController.mainWindowControllerDelegate = self;
        
        _feedSettingsWindowController = [[FeedSettingsWindowController alloc] init];
        _feedSettingsWindowController.mainWindowControllerDelegate = self;
        
        _entrySettingsWindowController = [[EntrySettingsWindowController alloc] init];
        _entrySettingsWindowController.mainWindowControllerDelegate = self;
        
        _feedQueue = [[NSOperationQueue alloc] init];
		[_feedQueue setName:[[NSBundle mainBundle] bundleIdentifier]];
        _refreshNotification = nil;
        _currentItem = nil;
        
        StuffSourceListItem *stuffItem = [[StuffSourceListItem alloc] init];
        FeedsSourceListItem *feedsItem = [[FeedsSourceListItem alloc] init];
        //TagsSourceListItem *tagsItem = [[TagsSourceListItem alloc] init];
        [_navigationItems addObject:stuffItem];
        [_navigationItems addObject:feedsItem];
        //[_navigationItems addObject:tagsItem];
    }
	
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_entriesScrollView setScrollerStyle:NSScrollerStyleOverlay];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    BOOL displayState = [[NSUserDefaults standardUserDefaults] boolForKey:OptDisplayArticlesState];
    AMButtonBarItem *item = [[AMButtonBarItem alloc] initWithIdentifier:@"all-items"];
    [item setTitle:@"All"];
    if (displayState)
        [item setState:NSOnState];
    [_displayModeButtonBar insertItem:item atIndex:0];
    
    item = [[AMButtonBarItem alloc] initWithIdentifier:@"unread-items"];
    [item setTitle:@"Unread"];
    if (!displayState)
        [item setState:NSOnState];
    [_displayModeButtonBar insertItem:item atIndex:1];
    [_displayModeButtonBar setDelegate:self];
    [_displayModeButtonBar setNeedsDisplay:YES];
    
    [_navigationSourceList reloadData];
}

- (void)showWindow:(id)sender
{
    INAppStoreWindow *window = (INAppStoreWindow *)self.window;
    window.titleBarHeight = 40.0;
    
    [super showWindow:sender];
    
    //[_loginWindowController doShowSheet:sender];
}

- (IBAction)doSomething:(id)sender
{
}

- (void)reloadData:(NSNotification *)notification
{    
    [_navigationSourceList reloadData];
    [_entriesTableView reloadData];
    [_entriesTableView selectRowIndexes:[_entryArrayController selectionIndexes] byExtendingSelection:NO];
}

- (IBAction)doSubscribe:(id)sender
{
    [_subscribeWindowController doShowSheet:sender];
}

- (IBAction)doUnsubscribe:(id)sender
{
    FeedSourceListItem *feed = nil;
    if ([_currentItem isKindOfClass:[FeedSourceListItem class]])
        feed = _currentItem;
    else
        return;
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Are you really want to unsubscribe?" 
                                     defaultButton:NSLocalizedString(@"Cancel", @"") 
								   alternateButton:NSLocalizedString(@"Unsubscribe", @"") otherButton:nil 
						 informativeTextWithFormat:NSLocalizedString(@"Subscribtion can not be restored.", @"")];
	[[alert window] setTitle:[NSString stringWithFormat:@"Unsubscribe %@", feed.title]];
	NSInteger button = [alert runModal];
	
	if (button == NSAlertAlternateReturn) 
    {
        PSClient *client = [PSClient applicationClient];
        if (![client removeFeed:feed.feed])
            NSLog(@"Can not unsubscribe feed");
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:feed.feed];
    }
}

- (IBAction)doFeedSettings:(id)sender
{
    _feedSettingsWindowController.feed = ((FeedSourceListItem *)_currentItem).feed;
    [_feedSettingsWindowController doShowSheet:sender];
}

- (IBAction)doOpenFeedHome:(id)sender
{
    NSAssert([_currentItem isKindOfClass:[FeedSourceListItem class]], 
             @"Current item should always be FeedSourceListItem type.");
    
    FeedSourceListItem *feed = _currentItem;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:feed.feed.alternateURL];
	[request setHTTPMethod:@"GET"];
	[request setHTTPShouldHandleCookies:NO];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request addValue:kUserAgentValue forHTTPHeaderField:@"User-Agent"];
    
    [[_webView mainFrame] loadRequest:request];
}

- (IBAction)doOpenFeedHomeInBrowser:(id)sender
{
    NSAssert([_currentItem isKindOfClass:[FeedSourceListItem class]], 
             @"Current item should always be FeedSourceListItem type.");
    
    FeedSourceListItem *feed = _currentItem;
    
    [[NSWorkspace sharedWorkspace] openURL:feed.feed.alternateURL];
}

- (IBAction)doChangeFlag:(id)sender
{
    NSButton *starButton = sender;
    NSArray *selectedObjects = [_entryArrayController selectedObjects];
    Entry *entry = [selectedObjects firstObject];
    entry.flagged = (BOOL)[starButton state];
}

- (IBAction)doEntrySettings:(id)sender
{
    NSArray *selectedObjects = [_entryArrayController selectedObjects];
    Entry *entry = [selectedObjects firstObject];
    _entrySettingsWindowController.entry = entry;
    [_entrySettingsWindowController doShowSheet:sender];
}

- (IBAction)doOpenEntryInBrowser:(id)sender
{
    
}

@end
