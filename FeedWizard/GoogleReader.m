//
//  GoogleReader.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "GoogleReader.h"

enum
{
    GReaderOfflineState = 0,
	GReaderErrorState,
	
    GReaderAuthStartState,
	GReaderAuthFinishState,
	
	GReaderListStartState,
	GReaderListFinishState
};

@implementation GoogleReader

@synthesize email = _email;
@synthesize password = _password;

- (id)init
{
	self = [super init];
	if (self != nil) 
    {
		//_responseData = [NSMutableData data];
		//_currentState = GReaderOfflineState;
        //_networkQueue = [[NSOperationQueue alloc] init];
        //[_networkQueue setMaxConcurrentOperationCount:5];
	}
	return self;
}

- (void)dealloc 
{
	//_responseData = nil;
    //_networkQueue = nil;
	//_currentState = GReaderOfflineState;
	[super dealloc];
}

- (BOOL)login
{
    /*if ([_email length] == 0 || [_password length] == 0) 
    {
        //_currentState = GReaderErrorState;
        return FALSE;
    }
	//_currentState = GReaderAuthStartState;
	
	NSString *postData = [NSString stringWithFormat:@"service=reader&source=scroll&continue=http://www.google.com/&Email=%@&Passwd=%@", _email, _password];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://www.google.com/accounts/ClientLogin"]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPShouldHandleCookies:NO];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request addValue:kUserAgentValue forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
	
	//[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *loginResponse = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSArray *loginResponseVariables = [loginResponse componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *clientSID = [NSString string];
    NSString *errorMessage = [NSString string];
    NSString *clientAuth = [NSString string];
    
    for (NSString *entry in loginResponseVariables) {
        if ([entry length] > 0) {
            NSArray *entryComponents = [entry componentsSeparatedByString:@"="];
            if (entryComponents.count == 2) {
                NSString *key = [entryComponents objectAtIndex:0];
                if ([@"SID" caseInsensitiveCompare:key] == NSOrderedSame)
                    clientSID = [entryComponents objectAtIndex:1];
                else if ([@"Auth" caseInsensitiveCompare:key] == NSOrderedSame)
                    clientAuth = [entryComponents objectAtIndex:1];
                else if ([@"Error" caseInsensitiveCompare:key] == NSOrderedSame)
                    errorMessage = [entryComponents objectAtIndex:1];
            }
        }
    }
    
    if ([clientSID length] == 0 || [clientAuth length] == 0) {
        NSMutableDictionary* errorInfo = [NSMutableDictionary dictionaryWithCapacity:3];
        NSLog(@"Error logging in. Response body:\n-----\n%@\n-----\n", loginResponse);
        [errorInfo setObject:NSLocalizedString(@"Could not log you in to Google.", @"Google Reader service") forKey:NSLocalizedDescriptionKey];
        
        if ([errorMessage length] != 0)
            [errorInfo setObject:[NSString localizedStringWithFormat:@"Google returned error: \"%@\".", errorMessage] forKey:NSLocalizedFailureReasonErrorKey];
        
        [errorInfo setObject:NSLocalizedString(@"Please re-check your Google ID and password.", @"Google Reader service") forKey:NSLocalizedRecoverySuggestionErrorKey];
        //_currentState = GReaderErrorState;
        return FALSE;
    }
    else {
        _clientSID = clientSID;
        _clientAuth = clientAuth;
        //_currentState = GReaderAuthFinishState;
        //[self list];
        return TRUE;
    }*/
    
    return TRUE;
}

- (void)listWithCompletionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler
{
	//_currentState = GReaderListStartState;
/*	NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 7];
    
    NSDictionary *clientSidCookieProps = [NSDictionary dictionaryWithObjectsAndKeys:
										  @"0", NSHTTPCookieVersion,
										  @"/", NSHTTPCookiePath,
										  @".google.com", NSHTTPCookieDomain,
										  expiryDate, NSHTTPCookieExpires,
										  @"SID", NSHTTPCookieName,
										  _clientSID, NSHTTPCookieValue,
										  nil];
    
    NSHTTPCookie *sidCookie = [NSHTTPCookie cookieWithProperties:clientSidCookieProps];
    
    u_int64_t now = abs(round([[NSDate date] timeIntervalSince1970] * 1000));
		
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSURL *listURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/reader/api/0/subscription/list?output=json&client=scroll&ck=%qu", now]];
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:sidCookie];
	NSString* authString = [NSString stringWithFormat:@"GoogleLogin auth=%@", _clientAuth];
	[request setURL:listURL];
	[request setHTTPMethod:@"GET"];
	[request setHTTPShouldHandleCookies:NO];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request addValue:kUserAgentValue forHTTPHeaderField:@"User-Agent"];
	[request addValue:authString forHTTPHeaderField:@"Authorization"];*/
	
	//[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	
}

/*- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	_currentState = GReaderErrorState;
	[[NSAlert alertWithError:error] runModal];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (_currentState == GReaderAuthStartState) {
		NSString *loginResponse = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
		NSArray *loginResponseVariables = [loginResponse componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSString *clientSID = [NSString string];
		NSString *errorMessage = [NSString string];
		NSString *clientAuth = [NSString string];
		
		for (NSString *entry in loginResponseVariables) {
			NSArray *entryComponents = [entry componentsSeparatedByString:@"="];
			if (entryComponents.count == 2) {
				NSString *key = [entryComponents objectAtIndex:0];
				if ([@"SID" caseInsensitiveCompare:key] == NSOrderedSame)
					clientSID = [entryComponents objectAtIndex:1];
				else if ([@"Auth" caseInsensitiveCompare:key] == NSOrderedSame)
					clientAuth = [entryComponents objectAtIndex:1];
				else if ([@"Error" caseInsensitiveCompare:key] == NSOrderedSame)
					errorMessage = [entryComponents objectAtIndex:1];
			}
		}
		
		
		if ([clientSID length] == 0 || [clientAuth length] == 0) {
			NSMutableDictionary* errorInfo = [NSMutableDictionary dictionaryWithCapacity:3];
			NSLog(@"Error logging in. Response body:\n-----\n%@\n-----\n", loginResponse);
			[errorInfo setObject:NSLocalizedString(@"Could not log you in to Google.", @"Google Reader service") forKey:NSLocalizedDescriptionKey];
			
			if ([errorMessage length] != 0)
				[errorInfo setObject:[NSString localizedStringWithFormat:@"Google returned error: \"%@\".", errorMessage] forKey:NSLocalizedFailureReasonErrorKey];
			
			[errorInfo setObject:NSLocalizedString(@"Please re-check your Google ID and password.", @"Google Reader service") forKey:NSLocalizedRecoverySuggestionErrorKey];
			
			//self.operationError = [NSError errorWithDomain:BSCommonsErrorDomain code:BSInvalidCredentialsError userInfo:errorInfo];
			_currentState = GReaderErrorState;
		}
		else {
			_clientSID = clientSID;
			_clientAuth = clientAuth;
			_currentState = GReaderAuthFinishState;
			//[self list];
		}
	}
	else if (_currentState == GReaderListStartState) {
		
		//NSString *listResponse = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
		_currentState = GReaderListFinishState;
	}
}*/

@end
