//
//  GoogleReader.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/1/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

// TODO: not implemented yet
typedef NSUInteger GReaderState;

@interface GoogleReader : NSObject {
@private
	NSString *_email;
	NSString *_password;
/*	GReaderState _currentState;
	NSMutableData *_responseData;
	NSString *_clientSID;
    NSString *_clientAuth;
    NSOperationQueue* _networkQueue;*/
}

@property (assign) NSString *email;
@property (assign) NSString *password;

- (BOOL)login;
- (void)listWithCompletionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler;

@end
