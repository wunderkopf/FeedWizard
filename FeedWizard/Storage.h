//
//  Storage.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

@class GoogleReader;

@interface FWStorage : NSObject {
@private
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
	BOOL _firstRun;
    GoogleReader *_greader;
}

@property (assign) NSManagedObjectContext *managedObjectContext;
@property (assign) NSArray *sortDescriptors;
@property (readonly, assign) BOOL firstRun;

+ (FWStorage *)sharedStorage;
- (BOOL)loginForEmail:(NSString *)email withPassword:(NSString *)password;
- (BOOL)sync;
- (BOOL)close;
- (NSArray *)fetchForEntity:(NSString *)name withPredicate:(NSPredicate *)predicate;

@end
