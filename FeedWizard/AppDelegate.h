//
//  AppDelegate.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 8/31/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

@class MainWindowController;
@class PreferencesWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate> 
{
@private
    MainWindowController *_mainWindowController;
    PreferencesWindowController *_preferencesWindowController;
}

@property (assign) MainWindowController *mainWindowController;

- (IBAction)doExportOPML:(id)sender;
- (IBAction)doImportOPML:(id)sender;
- (IBAction)doUnsubsribeAll:(id)sender;
- (IBAction)doSubscribe:(id)sender;
- (IBAction)doUnsubscribe:(id)sender;
- (IBAction)doPreferences:(id)sender;
- (IBAction)doMarkAllAsRead:(id)sender;

+ (NSString *)appVersionNumber;

@end
