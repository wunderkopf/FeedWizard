//
//  EntrySettingsWindowController.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/13/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "EntrySettingsWindowController.h"
#import "Entry.h"

@implementation EntrySettingsWindowController

@synthesize entryFeedImageView = _entryFeedImageView;
@synthesize entryTitleTextField = _entryTitleTextField;
@synthesize entryURLtextField = _entryURLtextField;
@synthesize entry = _entry;

- (id)init
{
    self = [super initWithWindowNibName:@"EntrySettingsWindow"];
    
    if (self != nil) 
    {
    }
	
    return self;
}

- (IBAction)doShowSheet:(id)sender
{
    [super doShowSheet:sender];
    _entryFeedImageView.image = _entry.feedLogo;
    _entryTitleTextField.stringValue = _entry.titleForDisplay;
    _entryURLtextField.stringValue = _entry.alternateURL.description;
}

@end
