//
//  MainWindowController-NSTableViewDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/7/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "MainWindowController.h"
#import "SourceListItem.h"
#import "FeedsSourceListItem.h"
#import "Entry.h"
//#import <OAuthConsumer/OAuthConsumer.h>
//#import "GGReadability.h"
#import "Storage.h"

@implementation MainWindowController (NSTableViewDelegate)

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSArray *selectedObjects = [_entryArrayController selectedObjects];
    
    Entry *entry = [selectedObjects firstObject];

    NSString *articleText = [NSString string];
    if ([entry.titleForDisplay length] > 0)
        articleText = [_articleText stringByReplacingOccurrencesOfString:@"[TITLE]" withString:entry.titleForDisplay];
    else
        articleText = [_articleText stringByReplacingOccurrencesOfString:@"[TITLE]" withString:
                       NSLocalizedString(@"No Title", nil)];
    
    articleText = [articleText stringByReplacingOccurrencesOfString:@"[DATE]" withString:entry.dateForDisplay.description];
    
    if ([entry.content length] > 0)
        articleText = [articleText stringByReplacingOccurrencesOfString:@"[CONTENT]" withString:entry.content];
    else
    {
        //summary
        if ([entry.summary length] > 0)
            articleText = [articleText stringByReplacingOccurrencesOfString:@"[CONTENT]" withString:entry.summary];
        else
            articleText = [articleText stringByReplacingOccurrencesOfString:@"[CONTENT]" withString:
                           NSLocalizedString(@"No content", nil)];
    }
    
    [[_webView mainFrame] loadHTMLString:articleText baseURL:entry.baseURL];

    [[Storage sharedStorage] addLogoWithIdentifier:entry.entry.feed.identifier];
    
    if (![entry isRead])
        [entry setRead:YES];
}

- (NSMenu *)tableView:(NSTableView *)tableView menuForEvent:(NSEvent *)event
{
    return _entryMenu;
}

@end