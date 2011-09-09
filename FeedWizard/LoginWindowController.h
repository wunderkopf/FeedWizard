//
//  LoginWindowController.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "SheetWindowController.h"

@interface LoginWindowController : SheetWindowController {
@private
    NSProgressIndicator *_progressIndicator;
}

@property (assign) IBOutlet NSProgressIndicator *progressIndicator;

@end
