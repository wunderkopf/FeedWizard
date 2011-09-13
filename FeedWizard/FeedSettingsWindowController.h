//
//  FeedSettingsWindowController.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/13/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "SheetWindowController.h"

@interface FeedSettingsWindowController : SheetWindowController
{
@private
    NSButton *_saveButton;
    NSImageView *_feedImageView;
    NSTextField *_feedTitleTextField;
    NSTextField *_feedURLTextField;
    PSFeed *_feed;
    NSImageView *_feedTypeImageView;
}

@property (assign) IBOutlet NSButton *saveButton;
@property (assign) IBOutlet NSImageView *feedImageView;
@property (assign) IBOutlet NSTextField *feedTitleTextField;
@property (assign) IBOutlet NSTextField *feedURLTextField;
@property (assign) PSFeed *feed;
@property (assign) IBOutlet NSImageView *feedTypeImageView;

@end
