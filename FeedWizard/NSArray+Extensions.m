//
//  NSArray+Extensions.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/7/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

- (id)firstObject 
{	
	if ([self count] == 0)
		return nil;
	
	return [self objectAtIndex:0];
}

- (id)secondObject 
{	
	if ([self count] < 2)
		return nil;
	
	return [self objectAtIndex:1];
}

- (BOOL)containsObjectOfClass:(Class)objectClass 
{
	__block BOOL result = NO;
	[self enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) 
    {
		if ([item isKindOfClass:objectClass]) 
        {
			result = YES;
			*stop = YES;
		}
	}];	
	
	return result;
}

@end
