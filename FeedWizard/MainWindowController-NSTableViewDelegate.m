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
    
    /*NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:entry.alternateURL];
	[request setHTTPMethod:@"GET"];
	[request setHTTPShouldHandleCookies:NO];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request addValue:kUserAgentValue forHTTPHeaderField:@"User-Agent"];
	//[request setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    [[_webView mainFrame] loadRequest:request];*/
    
    //[[_webView mainFrame] loadHTMLString:entry.content baseURL:entry.baseURL];
    
    /*GGReadability *read = [[GGReadability alloc] initWithURL:entry.alternateURL completionHandler:^(NSString *string) {
        //[[_webView mainFrame] loadHTMLString:string baseURL:entry.baseURL];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"article" ofType:@"html"];
        NSData *articleData = [NSData dataWithContentsOfFile:filePath];
        NSString *atricleText = [[NSString alloc] initWithData:articleData encoding:NSStringEncodingConversionAllowLossy];
        atricleText = [atricleText stringByReplacingOccurrencesOfString:@"[CONTENT]" withString:string];
        [[_webView mainFrame] loadHTMLString:atricleText baseURL:entry.baseURL];
    } errorHandler:^(NSError * error) {
        NSLog(@"Something wrong");
    }];
    [read render];*/

    NSString *articleText = [NSString string];
    if ([entry.titleForDisplay length] > 0)
        articleText = [_articleText stringByReplacingOccurrencesOfString:@"[TITLE]" withString:entry.titleForDisplay];
    else
        articleText = [_articleText stringByReplacingOccurrencesOfString:@"[TITLE]" withString:@"No Title"];
    
    articleText = [articleText stringByReplacingOccurrencesOfString:@"[DATE]" withString:entry.dateForDisplay.description];
    
    if ([entry.content length] > 0)
        articleText = [articleText stringByReplacingOccurrencesOfString:@"[CONTENT]" withString:entry.content];
    else
        articleText = [articleText stringByReplacingOccurrencesOfString:@"[CONTENT]" withString:@""];
    
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