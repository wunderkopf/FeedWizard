//
//  AppDelegate.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 8/31/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "PreferencesWindowController.h"
#import "NSImage+Extensions.h"

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
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
        NSString *logPath = [libraryPath stringByAppendingPathComponent:@"FeedWizard/Logs"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSFileExtensionHidden, nil];
        [fileManager createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:attributes error:&error];
        logPath = [logPath stringByAppendingPathComponent:@"FeedWizard.log"];
        
        freopen([logPath fileSystemRepresentation], "a", stderr);
        
        PSClient *client = [PSClient applicationClient];
        if (![client isPrivate])
            [client setPrivate:YES];
        
        _mainWindowController = [[MainWindowController alloc] init];
        _preferencesWindowController = [[PreferencesWindowController alloc] init];
        Info(@"FeedWizard %@ lunched successfully.", [AppDelegate appVersionNumber]);
    }
	
    return self;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender 
{
    return NSTerminateNow;
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

- (IBAction)doPreferences:(id)sender
{
    [_preferencesWindowController showWindow:sender];
}

- (IBAction)doMarkAllAsRead:(id)sender
{
    PSClient *client = [PSClient applicationClient];
    NSArray *feeds = [client feeds];
    
    [feeds enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        PSFeed *feed = item;
        [[feed entries] enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            PSEntry *entry = item;
            if (![entry isRead])
                entry.read = YES;
        }];
    }];
}

+ (NSString *)appVersionNumber
{
    return [NSString stringWithFormat:@"%@b%@", 
            [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"], 
            [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]];
}

+ (NSURL *)applicationFilesDirectory 
{    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *libraryURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [libraryURL URLByAppendingPathComponent:@"FeedWizard"];
}

+ (NSURL *)imagesFilesDirectory 
{    
    return [[self applicationFilesDirectory] URLByAppendingPathComponent:@"Images"];
}

+ (NSImage *)logoWithFeedIdentifier:(NSString *)identifier
{
    NSMutableString *name = [NSMutableString stringWithString:identifier];
    [name appendString:@".png"];
    NSURL *path = [[self imagesFilesDirectory] URLByAppendingPathComponent:name];
    // TODO: error checking
    NSError *error = nil;
    if ([path checkResourceIsReachableAndReturnError:&error])
        return [[NSImage alloc] initWithContentsOfURL:path];
    
    return [NSImage imageNamed:@"feed-default"];
}

+ (void)addLogoWithIdentifier:(NSString *)identifier
{
    if ([identifier length] > 0)
    {
        NSMutableString *name = [NSMutableString stringWithString:identifier];
        [name appendString:@".png"];
        
        NSURL *path = [[self imagesFilesDirectory] URLByAppendingPathComponent:name];
        // TODO: error checking
        NSError *error = nil;
        if (![path checkResourceIsReachableAndReturnError:&error])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:YES], NSFileExtensionHidden, nil];
            NSURL *imagesFilesDirectory = [self imagesFilesDirectory];
            [fileManager createDirectoryAtPath:[imagesFilesDirectory path] 
                   withIntermediateDirectories:YES attributes:attributes error:&error];
            
            PSFeed *feed = [[PSClient applicationClient] feedWithIdentifier:identifier];
            NSURL *faviconURL = [NSURL URLWithString: @"/favicon.ico" relativeToURL:feed.alternateURL];
            NSImage *logo = [[NSImage alloc] initWithContentsOfURL:faviconURL];
            if (logo == nil)
                logo = [NSImage imageNamed:@"feed-default"];
            [logo saveAsPNGWithName:name atURL:[self imagesFilesDirectory]];
        }
    }
}

@end
