//
//  OPMLParser.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/14/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

@interface OPMLParser : NSObject <NSXMLParserDelegate>
{
@private
    NSMutableArray *_feeds;
    NSMutableString *_textInProgress;
    PSFeed *_feedInProgress;
    NSString *_title;
}

@property (readonly, assign) NSArray *feeds;
@property (readonly, assign) NSString *title;

- (BOOL)parseFileAtURL:(NSURL *)url;

@end
