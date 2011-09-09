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
#import <OAuthConsumer/OAuthConsumer.h>

@implementation MainWindowController (NSTableViewDelegate)

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    //[_webView close];
    NSArray *selectedObjects = [_entryArrayController selectedObjects];
    
    Entry *entry = [selectedObjects firstObject];
    
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	//[request setURL:entry.alternateURL];
	//[request setHTTPMethod:@"GET"];
	//[request setHTTPShouldHandleCookies:NO];
	//[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	//[request addValue:kUserAgentValue forHTTPHeaderField:@"User-Agent"];
	//[request setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    //[[_webView mainFrame] loadRequest:request];
    
    /*OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"kurylenko" secret:@"fb7sfvwDDyH6w5GZPNfwruA9PdC24XDx"];
    //OAToken *token = [[OAToken alloc] initWithKey:@"kurylenko" secret:@"fb7sfvwDDyH6w5GZPNfwruA9PdC24XDx"];
    NSURL *url = [NSURL URLWithString:@"https://www.readability.com/api/rest/v1/oauth/access_token/"];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:consumer token:nil realm:nil
                                                          signatureProvider:[[OAPlaintextSignatureProvider alloc] init]];
    [request setHTTPMethod:@"POST"];
    //[request setOAuthParameterName:@"x_auth_mode" withValue:@"client_auth"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request delegate:self
                didFinishSelector:@selector(requestTokenTicket:finishedWithData:)
                  didFailSelector:@selector(requestTokenTicket:failedWithError:)];*/
    
    [[_webView mainFrame] loadHTMLString:entry.content baseURL:entry.baseURL];
    
    if (![entry isRead])
    {
        [entry setRead:YES];
        [_entriesTableView reloadData];
        [_entriesTableView selectRowIndexes:[_entryArrayController selectionIndexes] byExtendingSelection:NO];
    }
}

/*- (void)requestTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data 
{
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    //[token storeInDefaultKeychainWithAppName:@"FeedWizard" serviceProviderName:@"readability.com"];
    
    NSArray *selectedObjects = [_entryArrayController selectedObjects];
    Entry *entry = [selectedObjects firstObject];
    
    NSString *postData = [NSString stringWithFormat:@"url=%@&favorite=1", entry.alternateURL];
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"kurylenko" secret:@"fb7sfvwDDyH6w5GZPNfwruA9PdC24XDx"];
    NSURL *url = [NSURL URLWithString:@"https://www.readability.com/api/rest/v1/bookmarks"];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:consumer token:token realm:nil
                                                          signatureProvider:[[OAPlaintextSignatureProvider alloc] init]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request delegate:self
                didFinishSelector:@selector(requestTokenTicket:finishedWithData:)
                  didFailSelector:@selector(requestTokenTicket:failedWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error 
{
    //STAssertFalse(ticket.didSucceed, NULL);
    int gg = 5;
}*/

@end