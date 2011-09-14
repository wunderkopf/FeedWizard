//
//  OPMLParser.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/14/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "OPMLParser.h"

@implementation OPMLParser

@synthesize feeds = _feeds;
@synthesize title = _title;

- (void)dealloc
{
    _feeds = nil;
    
    [super dealloc];
}

- (BOOL)parseFileAtURL:(NSURL *)url
{
    _feeds = nil;
    _feeds = [NSMutableArray array];
    
    NSData *opmlData = [NSData dataWithContentsOfURL:url];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:opmlData];
    [parser setDelegate:self];
    [parser parse];
    parser = nil;
    
    return TRUE;
}

@end

@implementation OPMLParser (NSXMLParserDelegate)

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"title"]) 
    {
        _textInProgress = [NSMutableString string];
    }
    
    if ([elementName isEqual:@"outline"])
    {
        NSString *xmlURLString = [attributeDict objectForKey:@"xmlUrl"];
        if ([xmlURLString length] != 0)
        {
            NSURL *xmlURL = [NSURL URLWithString:xmlURLString];
            _feedInProgress = [[PSFeed alloc] initWithURL:xmlURL];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"title"]) 
    {
        _title = _textInProgress;
        _textInProgress = nil;
    }
    
    if ([elementName isEqual:@"outline"])
    {
        if (_feedInProgress != nil)
        {
            [_feeds addObject:_feedInProgress];
            _feedInProgress = nil;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_textInProgress appendString:string];
}

@end
