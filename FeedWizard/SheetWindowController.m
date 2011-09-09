//
//  SheetWindowController.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "SheetWindowController.h"

@implementation SheetWindowController

@synthesize mainWindowControllerDelegate = _mainWindowControllerDelegate;

- (IBAction)doShowSheet:(id)sender 
{
	[NSApp beginSheet:[self window] modalForWindow:[[self mainWindowControllerDelegate] window] modalDelegate:self 
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)doCloseSheet:(id)sender 
{
	[NSApp endSheet:[self window]];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo 
{
	[[self window] orderOut:self];
}

@end
