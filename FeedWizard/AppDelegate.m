//
//  AppDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 8/31/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "Storage.h"

NSString * const FeedDidEndRefreshNotification = @"FeedDidEndRefreshNotification";
NSString * const ReloadDataNotification = @"ReloadDataNotification";

NSString * const OptDisplayArticlesState = @"DisplayArticlesState";
NSString * const OptDoNotAskAboutDefaultReader = @"DoNotAskAboutDefaultReader";

@implementation AppDelegate

@synthesize mainWindowController = _mainWindowController;

- (id)init
{
    self = [super init];
    
    if (self != nil) 
    {
        PSClient *client = [PSClient applicationClient];
        if (![client isPrivate])
            [client setPrivate:YES];
        
        _mainWindowController = [[MainWindowController alloc] init];
    }
	
    return self;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender 
{
    if ([[Storage sharedStorage] close])
        return NSTerminateNow;
    else
        return NSTerminateCancel;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_mainWindowController showWindow:self];
}

- (void)dealloc
{
    _mainWindowController = nil;
    
    [super dealloc];
}

- (IBAction)doExportOPML:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"opml", @"xml", nil];
    
    [savePanel setAllowedFileTypes:allowedFileTypes];
    [savePanel setCanSelectHiddenExtension:NO];
    [savePanel setTreatsFilePackagesAsDirectories:NO];
    
    if ([savePanel runModal] == NSOKButton) 
    {
        NSXMLElement *root = [[NSXMLElement alloc] initWithName:@"opml"];
        [root addAttribute:[NSXMLNode attributeWithName:@"version" stringValue:@"1.0"]];
        
        NSXMLElement *head = [[NSXMLElement alloc] initWithName:@"head"];
        NSXMLElement *title = [[NSXMLElement alloc] initWithName:@"title" stringValue:
                               NSLocalizedString(@"Subscriptions in FeedWizard", nil)];
        [head addChild:title];
        [root addChild:head];
        
        NSXMLElement *body = [[NSXMLElement alloc] initWithName:@"body"];
        // Enumerate feeds
        PSClient *client = [PSClient applicationClient];
        NSArray *feeds = [client feeds];
        
        [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            PSFeed *feed = item;
            NSXMLElement *outline = [[NSXMLElement alloc] initWithName:@"outline"];
            [outline addAttribute:[NSXMLNode attributeWithName:@"text" stringValue:feed.title]];
            [outline addAttribute:[NSXMLNode attributeWithName:@"title" stringValue:feed.title]];
            if (feed.feedFormat == PSAtomFormat)
                [outline addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"atom"]];
            else
                [outline addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"rss"]];
            [outline addAttribute:[NSXMLNode attributeWithName:@"xmlUrl" stringValue:feed.URL.description]];
            [outline addAttribute:[NSXMLNode attributeWithName:@"htmlUrl" stringValue:feed.alternateURL.description]];
            [body addChild:outline];
        }];
        //
        [root addChild:body];
        
        NSXMLDocument *doc = [[NSXMLDocument alloc] initWithRootElement:root];
        [doc setCharacterEncoding:@"UTF-8"];
        [doc setVersion:@"1.0"];
        
        NSData *xmlData = [doc XMLDataWithOptions:NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement];
        
        [xmlData writeToURL:[savePanel URL] atomically:YES];
    }
}

- (IBAction)doImportOPML:(id)sender
{
    // Implementation in Main Window Controller
    [_mainWindowController doImportOPML:sender];
}

- (IBAction)doUnsubsribeAll:(id)sender
{
    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Are you really want to unsubscribe all feeds?", nil) 
                                     defaultButton:NSLocalizedString(@"Cancel", nil) 
								   alternateButton:NSLocalizedString(@"Unsubscribe", nil) 
                                       otherButton:nil 
						 informativeTextWithFormat:NSLocalizedString(@"Subscribtiones can not be restored.", nil)];
	[[alert window] setTitle:[NSString stringWithString:NSLocalizedString(@"Unsubscribe All", nil)]];
	NSInteger button = [alert runModal];
	
	if (button == NSAlertAlternateReturn) 
    {
        PSClient *client = [PSClient applicationClient];
        NSArray *feeds = [client feeds];
        
        [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            PSFeed *feed = item;
            [client removeFeed:feed];
        }];
        
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter postNotificationName:FeedDidEndRefreshNotification object:nil];
        [notifyCenter postNotificationName:ReloadDataNotification object:nil];
    }
}

- (IBAction)doSubscribe:(id)sender
{
    [_mainWindowController doSubscribe:sender];
}

- (IBAction)doUnsubscribe:(id)sender
{
    [_mainWindowController doUnsubscribe:sender];
}

@end
