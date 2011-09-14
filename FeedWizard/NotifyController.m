//
//  NotifyController.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/14/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "NotifyController.h"

@implementation NotifyController

- (id)init 
{
    self = [super init];
    if (self != nil) 
    {
        [GrowlApplicationBridge setGrowlDelegate:self];
	}
	return self;    
}

static NotifyController *_sharedNotifyController = nil;

+ (NotifyController *)sharedNotifyController 
{	
	@synchronized ([NotifyController class]) 
    {
		if (!_sharedNotifyController)
			[[self alloc] init];
		
		return _sharedNotifyController;
	}
	
	return nil;
}

+ (id)alloc 
{	
	@synchronized([NotifyController class]) 
    {
		NSAssert(_sharedNotifyController == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedNotifyController = [super alloc];
		return _sharedNotifyController;
	}
	
	return nil;
}

- (void)dealloc 
{	
    [super dealloc];
}

- (NSDictionary *)registrationDictionaryForGrowl 
{
    NSArray *array = [NSArray arrayWithObjects:@"info", @"error", nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],
                          @"TicketVersion",
                          array,
                          @"AllNotifications",
                          array,
                          @"DefaultNotifications",
                          nil];
    return dict;
}

- (void)infoWithTitle:(NSString* )title andDescription:(NSString *)description
{
    [GrowlApplicationBridge notifyWithTitle:title description:description notificationName:@"info" iconData:nil priority:0 isSticky:NO clickContext:nil];
}

@end
