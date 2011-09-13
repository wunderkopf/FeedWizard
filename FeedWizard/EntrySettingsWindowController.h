//
//  EntrySettingsWindowController.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/13/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "SheetWindowController.h"

@class Entry;

@interface EntrySettingsWindowController : SheetWindowController
{
@private
    NSImageView *_entryFeedImageView;
    NSTextField *_entryTitleTextField;
    NSTextField *_entryURLtextField;
    Entry *_entry;
}

@property (assign) IBOutlet NSImageView *entryFeedImageView;
@property (assign) IBOutlet NSTextField *entryTitleTextField;
@property (assign) IBOutlet NSTextField *entryURLtextField;
@property (assign) Entry *entry;

@end
