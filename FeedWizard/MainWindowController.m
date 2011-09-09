//
//  MainWindowController.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 8/31/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"
#import "SourceListItem.h"
#import "StuffSourceListItem.h"
#import "FeedsSourceListItem.h"
#import "FeedSourceListItem.h"
//#import "LoginWindowController.h"
#import "SubscribeWindowController.h"
#import "INAppStoreWindow.h"

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

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    
    if (self != nil) 
    {
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter addObserver:self selector:@selector(reloadData:) name:ReloadDataNotification object:nil];

        PSClient *client = [PSClient applicationClient];
        client.delegate = self;
        
        _navigationItems = [[NSMutableArray alloc] init];
        //_loginWindowController = [[LoginWindowController alloc] init];
        _subscribeWindowController = [[SubscribeWindowController alloc] init];
        _subscribeWindowController.mainWindowControllerDelegate = self;
        
        _feedQueue = [[NSOperationQueue alloc] init];
		[_feedQueue setName:[[NSBundle mainBundle] bundleIdentifier]];
        _refreshNotification = nil;
        _currentItem = nil;
        
        StuffSourceListItem *stuffItem = [[StuffSourceListItem alloc] init];
        FeedsSourceListItem *feedsItem = [[FeedsSourceListItem alloc] init];
        [_navigationItems addObject:stuffItem];
        [_navigationItems addObject:feedsItem];
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
    //[_loginWindowController doShowSheet:sender];
    /*PSClient *client = [PSClient applicationClient];
    //PSFeed *feed = [client addFeedWithURL:[NSURL URLWithString:@"http://"]];
    PSFeed *feed = [[PSFeed alloc] initWithURL:[NSURL URLWithString:@"http://cocos2dbook.com/?feed=rss2"]];
    feed.settings.refreshInterval = 300.0;
    [client addFeed:feed];
    FeedsSourceListItem *feedsItem = [_navigationItems objectAtIndex:1];
    
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
	_refreshNotification = [notifyCenter addObserverForName:PSFeedRefreshingNotification object:feed 
                                                      queue:_feedQueue usingBlock:^(NSNotification *arg1) 
                            {
                                if ([feed isRefreshing])
                                    return;
                                
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    
                                    //if (nil != feedError) {
                                    //    [NSApp presentError:feedError];
                                    //    return;
                                    //}
                                    
                                    [feedsItem reloadFeeds];
                                    [_navigationSourceList reloadData];
                                    [notifyCenter removeObserver:_refreshNotification];
                                }];
                            }];*/
}

- (void)reloadData:(NSNotification *)notification
{
    FeedsSourceListItem *feedsItem = [_navigationItems objectAtIndex:1];
    [feedsItem reloadFeeds];
    [_navigationSourceList reloadData];
}

- (IBAction)doSubscribe:(id)sender
{
    [_subscribeWindowController doShowSheet:sender];
}

- (IBAction)doUnsubscribe:(id)sender
{
    NSAssert([_currentItem isKindOfClass:[FeedSourceListItem class]], 
             @"Current item should always be FeedSourceListItem type.");

    PSClient *client = [PSClient applicationClient];
    FeedSourceListItem *feed = _currentItem;
    
    if (![client removeFeed:feed.feed])
        NSLog(@"Can not unsubscribe feed");
}

- (IBAction)doFeedSettings:(id)sender
{
    
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

@end
