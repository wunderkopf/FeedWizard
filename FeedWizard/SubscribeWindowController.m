//
//  SubscribeWindowController.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/9/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "SubscribeWindowController.h"

@implementation SubscribeWindowController

@synthesize urlTextField = _urlTextField;
@synthesize subscribeButton = _subscribeButton;
@synthesize subscriptionTextField = _subscriptionTextField;
@synthesize cancelButton = _cancelButton;
@synthesize waitProgressIndicator = _waitProgressIndicator;

- (id)init
{
    self = [super initWithWindowNibName:@"SubscribeWindow"];
    
    if (self != nil) 
    {
        _refreshNotification = nil;
        _feedQueue = [[NSOperationQueue alloc] init];
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter addObserver:self selector:@selector(urlChanged:) name:NSControlTextDidChangeNotification object:_urlTextField];
    }
	
    return self;
}

- (void)urlChanged:(NSNotification *)notification
{
    [_subscribeButton setEnabled:([[_urlTextField stringValue] length] != 0)];
}

- (IBAction)doSubscribe:(id)sender
{
    [_urlTextField setHidden:YES];
    [_subscribeButton setHidden:YES];
    [_subscriptionTextField setHidden:YES];
    [_cancelButton setHidden:YES];
    [_waitProgressIndicator setHidden:NO];
    [_waitProgressIndicator startAnimation:sender];
    PSClient *client = [PSClient applicationClient];
    NSMutableString *urlString = [NSMutableString stringWithString:[_urlTextField stringValue]];
    if ([[urlString substringWithRange:NSMakeRange(0, 6)] compare:@"http://"] != NSOrderedSame &&
        [[urlString substringWithRange:NSMakeRange(0, 7)] compare:@"https://"] != NSOrderedSame &&
        [[urlString substringWithRange:NSMakeRange(0, 6)] compare:@"feed://"] != NSOrderedSame)
    {
        [urlString insertString:@"feed://" atIndex:0];
    }
    PSFeed *feed = [client addFeedWithURL:[NSURL URLWithString:urlString]];
    
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    _refreshNotification = [notifyCenter addObserverForName:PSFeedRefreshingNotification object:feed queue:_feedQueue usingBlock:^(NSNotification *arg1) {
        
        if ([feed isRefreshing])
            return;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            // TODO: error checking
            //if (nil != feedError) {
            //    [NSApp presentError:feedError];
            //    return;
            //}
            
            [_waitProgressIndicator stopAnimation:sender];
            [_waitProgressIndicator setHidden:YES];
            _urlTextField.stringValue = @"";
            [_urlTextField setHidden:NO];
            [_subscribeButton setEnabled:NO];
            [_subscribeButton setHidden:NO];
            [_subscriptionTextField setHidden:NO];
            [_cancelButton setHidden:NO];

            [notifyCenter removeObserver:_refreshNotification];
            [self doCloseSheet:nil];
        }];
    }];
}

@end
