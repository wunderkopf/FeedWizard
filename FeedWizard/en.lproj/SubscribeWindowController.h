//
//  SubscribeWindowController.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/9/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "SheetWindowController.h"

@interface SubscribeWindowController : SheetWindowController
{
@private
    NSTextField *_urlTextField;
    NSButton *_subscribeButton;
    id _refreshNotification;
    NSOperationQueue *_feedQueue;
    NSTextField *_subscriptionTextField;
    NSButton *_cancelButton;
    NSProgressIndicator *_waitProgressIndicator;
}

@property (assign) IBOutlet NSTextField *urlTextField;
@property (assign) IBOutlet NSButton *subscribeButton;
@property (assign) IBOutlet NSTextField *subscriptionTextField;
@property (assign) IBOutlet NSButton *cancelButton;
@property (assign) IBOutlet NSProgressIndicator *waitProgressIndicator;

- (IBAction)doSubscribe:(id)sender;

@end
