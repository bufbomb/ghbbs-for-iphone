//
//  SectionParser.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "Top10Parser.h"
#import "DataConvertor.h"
#import "Top10Item.h"
#import "ConnectionManager.h"

NSString * kTop10 = @"Top10";

@implementation Top10Parser
@synthesize delegate;
- (id) initWithURL:(NSURL *)_url
{
    if (self = [super init])
    {
        url = [_url copy];
        assert(url);
        top10List = [[NSMutableArray alloc] init];
        buffer = [[NSMutableString alloc] init];
    }
    return self;
}

#pragma mark NSOperation override method.
- (void) main
{
    NSData * data = [ConnectionManager dataOfURL:url];
    if (!data) 
    {
        [delegate onParseFailed:ErrorTypeNetwork];
        return;
    }
    assert(data);
    NSData * utf8data = [DataConvertor convertXMLData:data withEncoding:kCFStringEncodingGB_18030_2000];
    if (!utf8data) 
    {
        [delegate onParseFailed:ErrorTypeEncoding];
        return;
    }
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:utf8data];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
}

#pragma mark NSXMLParser delegate method
- (void) parserDidStartDocument:(NSXMLParser *)parser
{
    assert([top10List count] == 0);
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"top"])
    {
        NSString * name = [attributeDict objectForKey:@"board"];
        NSString * owner = [attributeDict objectForKey:@"owner"];
        int count = [[attributeDict objectForKey:@"count"] intValue];
        NSString * pid = [attributeDict objectForKey:@"gid"];
        [buffer setString:@""];
        currentItem = [[Top10Item alloc] initWithBoardName:name Owner:owner Pid:pid Count:count];

    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"top"])
    {
        currentItem.postTitle = buffer;
        [top10List addObject:currentItem];
        [currentItem release];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [buffer appendString:string];
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error %i,Description: %@, Line: %i, Column: %i", [parseError code],
          [[parser parserError] localizedDescription], [parser lineNumber],
          [parser columnNumber]);
    assert(NO);
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    [delegate onParseSuccessful:[NSDictionary dictionaryWithObject:top10List forKey:kTop10]];
}

- (void) dealloc
{
    [buffer release];
    [delegate release];
    [url release];
    [top10List release];
    [super dealloc];
}

@end
