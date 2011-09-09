//
//  SheetWindowController.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

@interface SheetWindowController : NSWindowController {
	id _mainWindowControllerDelegate;
}

@property (assign) id mainWindowControllerDelegate;

- (IBAction)doShowSheet:(id)sender;
- (IBAction)doCloseSheet:(id)sender;
- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

@end
