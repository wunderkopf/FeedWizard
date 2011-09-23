//
//  FeedSettingsWindowController.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/13/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "FeedSettingsWindowController.h"
#import "AppDelegate.h"

@implementation FeedSettingsWindowController

@synthesize saveButton = _saveButton;
@synthesize feedImageView = _feedImageView;
@synthesize feedTitleTextField = _feedTitleTextField;
@synthesize feedURLTextField = _feedURLTextField;
@synthesize feed = _feed;
@synthesize feedTypeImageView = _feedTypeImageView;

- (id)init
{
    self = [super initWithWindowNibName:@"FeedSettingsWindow"];
    
    if (self != nil) 
    {
    }
	
    return self;
}

- (IBAction)doShowSheet:(id)sender
{
    [super doShowSheet:sender];
    _feedImageView.image = [AppDelegate logoWithFeedIdentifier:_feed.identifier];
    if (_feed.feedFormat == PSAtomFormat)
        _feedTypeImageView.image = [NSImage imageNamed:@"atom-feed"];
    else
        _feedTypeImageView.image = [NSImage imageNamed:@"rss-feed"];
    _feedTitleTextField.stringValue = _feed.title;
    _feedURLTextField.stringValue = _feed.alternateURL.description;
}

@end
