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

#import "SubscribeWindowController.h"
#import "FeedSettingsWindowController.h"
#import "EntrySettingsWindowController.h"

#import "AMButtonBar.h"
#import "AMButtonBarItem.h"
#import "NSGradient_AMButtonBar.h"
#import "OPMLParser.h"
#import "NSAlert+Extensions.h"

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
@synthesize emptyEntryView = _emptyEntryView;
@synthesize webEntryView = _webEntryView;

- (void)updateSubviewsTransition 
{
    /*CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionFade];
    [transition setSubtype:kCATransitionFromLeft];
    [transition setDuration:1.0];
    [[self rightPane] setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];*/
    NSAnimation *animation = [[NSAnimation alloc] initWithDuration:1.0 animationCurve:NSAnimationEaseInOut];
    [animation setAnimationBlockingMode:NSAnimationNonblockingThreaded];
    [[self rightPane] setAnimations:[NSDictionary dictionaryWithObject:animation forKey:@"subviews"]];
}

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    
    if (self != nil) 
    {
        _runSubscribe = NO;
        _subscriptionURL = [NSString string];
        
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter addObserver:self selector:@selector(reloadData:) name:ReloadDataNotification object:nil];
        
        PSClient *client = [PSClient applicationClient];
        client.delegate = self;
        
        NSAppleEventManager *eventManager = [NSAppleEventManager sharedAppleEventManager];
        [eventManager setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:) 
                        forEventClass:kInternetEventClass andEventID:kAEGetURL];
        
        [eventManager setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:) forEventClass:'WWW!' 
                           andEventID:'OURL'];
        
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

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [[self rightPane] setWantsLayer:YES];
    [self updateSubviewsTransition];
    	
	[_emptyEntryView setFrame:[[self rightPane] bounds]];
	[[self rightPane] addSubview:_emptyEntryView];
    
    BOOL displayState = [[NSUserDefaults standardUserDefaults] boolForKey:OptDisplayArticlesState];
    AMButtonBarItem *item = [[AMButtonBarItem alloc] initWithIdentifier:@"all-items"];
    [item setTitle:NSLocalizedString(@"All", nil)];
    if (displayState)
        [item setState:NSOnState];
    [_displayModeButtonBar insertItem:item atIndex:0];
    
    item = [[AMButtonBarItem alloc] initWithIdentifier:@"unread-items"];
    [item setTitle:NSLocalizedString(@"Unread", nil)];
    if (!displayState)
        [item setState:NSOnState];
    [_displayModeButtonBar insertItem:item atIndex:1];
    [_displayModeButtonBar setDelegate:self];
    [_displayModeButtonBar setNeedsDisplay:YES];
    
    [_navigationSourceList reloadData];
}

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{    
    if ([self.window isVisible])
    {
        NSString *subscriptionURL = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
        [self doSubscribe:nil];
        _subscribeWindowController.urlTextField.stringValue = subscriptionURL;
        [_subscribeWindowController.subscribeButton setEnabled:YES];
    }
    
    _subscriptionURL = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    _runSubscribe = YES;
}

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    CFStringRef schemeHandler = LSCopyDefaultHandlerForURLScheme((CFStringRef)@"feed");
    BOOL doNotAskAboutDefaultReader = [[NSUserDefaults standardUserDefaults] boolForKey:OptDoNotAskAboutDefaultReader];
    
    if ([bundleID compare:(NSString *)schemeHandler options:NSCaseInsensitiveSearch] != NSOrderedSame &&
        !doNotAskAboutDefaultReader)
    {
        NSAlertCheckbox *alert = [NSAlertCheckbox alertWithMessageText:
                                  NSLocalizedString(@"Default RSS & ATOM reader", nil)
                                                         defaultButton:
                                  NSLocalizedString(@"Make default", nil)
                                                       alternateButton:
                                  NSLocalizedString(@"Cancel", nil)
                                                           otherButton:nil
                                                       informativeText:
                                  NSLocalizedString(@"FeedWizard is not currently set as your default RSS & ATOM reader.", nil)];
        
        [alert setShowsCheckbox:YES];
        [alert setCheckboxText:NSLocalizedString(@"Don't ask me again.", nil)];
        [alert setCheckboxState:NSOffState];
        
        if ([alert runModal] == NSAlertDefaultReturn) 
            LSSetDefaultHandlerForURLScheme((CFStringRef)@"feed", (CFStringRef)bundleID);
        
        if ([alert checkboxState] == NSOnState) 
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OptDoNotAskAboutDefaultReader];
    }
    
    if (_runSubscribe)
    {
        [self doSubscribe:nil];
        _subscribeWindowController.urlTextField.stringValue = _subscriptionURL;
        [_subscribeWindowController.subscribeButton setEnabled:YES];
        _runSubscribe = NO;
    }
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
    
    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Are you really want to unsubscribe?", nil)
                                     defaultButton:NSLocalizedString(@"Cancel", nil) 
								   alternateButton:NSLocalizedString(@"Unsubscribe", nil) 
                                       otherButton:nil 
						 informativeTextWithFormat:NSLocalizedString(@"Subscribtion can not be restored.", nil)];
	[[alert window] setTitle:[NSString stringWithFormat:NSLocalizedString(@"Unsubscribe %@", nil), feed.title]];
	NSInteger button = [alert runModal];
	
	if (button == NSAlertAlternateReturn) 
    {
        PSClient *client = [PSClient applicationClient];
        if (![client removeFeed:feed.feed])
            // TODO: better error checking
            Error(@"Can not unsubscribe feed");
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
    NSArray *selectedObjects = [_entryArrayController selectedObjects];
    Entry *entry = [selectedObjects firstObject];
    [[NSWorkspace sharedWorkspace] openURL:entry.alternateURL];
}

- (IBAction)doImportOPML:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"opml", @"xml", nil];
    
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowedFileTypes:allowedFileTypes];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setResolvesAliases:YES];
    [openPanel setCanChooseFiles:YES];
    
    if ([openPanel runModal] == NSOKButton) 
    {
        OPMLParser *parser = [[OPMLParser alloc] init];
        if (![parser parseFileAtURL:[openPanel URL]])
            // TODO: better error checking
            Error(@"Can not parse ompl file");
        
        PSClient *client = [PSClient applicationClient];
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [[parser feeds] enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            PSFeed *feed = item;
            [client addFeed:feed];
        }];
        [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:nil];
    }
}

- (IBAction)doMarkAllAsRead:(id)sender
{
    NSAssert([_currentItem isKindOfClass:[FeedSourceListItem class]], 
             @"Current item should always be FeedSourceListItem type.");
    
    FeedSourceListItem *feed = _currentItem;
    
    [[feed items] enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        Entry *entry = item;
        if ([entry isUnread])
            entry.read = YES;
    }];
}

- (IBAction)doMarkAllAsUnread:(id)sender
{
    NSAssert([_currentItem isKindOfClass:[FeedSourceListItem class]], 
             @"Current item should always be FeedSourceListItem type.");
    
    FeedSourceListItem *feed = _currentItem;
    
    [[feed items] enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        Entry *entry = item;
        if ([entry isRead])
            entry.read = NO;
    }];
}

- (NSView *)leftPane
{
    return [[_mainSplitView subviews] objectAtIndex:0];
}

- (NSView *)centerPane
{
    return [[_mainSplitView subviews] objectAtIndex:1];
}

- (NSView *)rightPane
{
    return [[_mainSplitView subviews] objectAtIndex:2];
}

@end
