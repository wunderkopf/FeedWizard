//
//  Storage.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

@interface Storage : NSObject {
@private
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
	BOOL _firstRun;
    NSOperationQueue *_loadQueue;
}

@property (assign) NSManagedObjectContext *managedObjectContext;
@property (assign) NSArray *sortDescriptors;
@property (readonly, assign) BOOL firstRun;

+ (Storage *)sharedStorage;
- (BOOL)close;
- (NSArray *)fetchForEntity:(NSString *)name withPredicate:(NSPredicate *)predicate;
- (NSImage *)logoWithFeedIdentifier:(NSString *)identifier;
- (void)addLogoWithIdentifier:(NSString *)identifier;

@end
