//
//  Storage.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "Storage.h"
#import "GoogleReader.h"

@implementation FWStorage

@synthesize managedObjectContext;
@synthesize firstRun = _firstRun;
@synthesize sortDescriptors;

static FWStorage *_sharedStorage = nil;

+ (FWStorage *)sharedStorage 
{	
	@synchronized ([FWStorage class]) {
		
		if (!_sharedStorage) {
			[[self alloc] init];
		}
		
		return _sharedStorage;
	}
	
	return nil;
}

+ (id)alloc {
	
	@synchronized([FWStorage class]) {
		
		NSAssert(_sharedStorage == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedStorage = [super alloc];
		return _sharedStorage;
	}
	
	return nil;
}

- (id) init {
	
	self = [super init];
	if (self != nil) {
		// Needs to create data file
		[_sharedStorage managedObjectContext];
        _greader = [[GoogleReader alloc] init];
	}
	return self;
}

- (void) dealloc 
{	
	_managedObjectContext = nil;
	_persistentStoreCoordinator = nil;
	_managedObjectModel = nil;
	
    [super dealloc];
}

- (NSURL *)applicationFilesDirectory 
{    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *libraryURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [libraryURL URLByAppendingPathComponent:@"FeedWizard"];
}

- (NSManagedObjectModel *)managedObjectModel 
{    
    if (_managedObjectModel)
        return _managedObjectModel;
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FeedWizard" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{    
    if (_persistentStoreCoordinator)
        return _persistentStoreCoordinator;
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    _firstRun = NO;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] 
                                                                          error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:YES], NSFileExtensionHidden, nil];
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES 
                                         attributes:attributes error:&error];
            _firstRun = YES;
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else {
        if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] != YES) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]]; 
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"com.wunderkopf" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"fw.db"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url 
                                                         options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        _persistentStoreCoordinator = nil;
        return nil;
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext 
{    
    if (_managedObjectContext)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"com.wunderkopf" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

- (BOOL)close
{
    if (![_managedObjectContext commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing", [self class], NSStringFromSelector(_cmd));
        return FALSE;
    }
    
    if (![_managedObjectContext hasChanges]) {
        NSLog(@"Database has not changes");
        return TRUE;
    }
    
    // TODO: better error checking
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", 
                                               @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn)
            return FALSE;
    }
    
    return TRUE;
}

- (NSArray *)sortDescriptors 
{	
	return [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]];
}

- (NSArray *)fetchForEntity:(NSString *)name withPredicate:(NSPredicate *)predicate 
{	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:name 
                                                         inManagedObjectContext:_managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	[request setSortDescriptors:self.sortDescriptors];
	
	[request setPredicate:predicate];
	
	// TODO: error checking
	NSError *error = nil;
	NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
	request = nil;
    
	return array;
}

- (BOOL)loginForEmail:(NSString *)email withPassword:(NSString *)password;
{
    _greader.email = email;
    _greader.password = password;
    return [_greader login];
}

- (BOOL)sync
{
    return YES;
}

@end
