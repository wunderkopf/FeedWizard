//
//  NotifyController.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/14/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import <Growl/Growl.h>

@interface NotifyController : NSObject <GrowlApplicationBridgeDelegate>

+ (NotifyController *)sharedNotifyController;
- (void)infoWithTitle:(NSString* )title andDescription:(NSString *)description;

@end
