//
//  SectionParser.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "SectionParser.h"
#import "DataConvertor.h"
#import "ConnectionManager.h"

NSString * kSection = @"Section";

@implementation SectionParser
@synthesize delegate;
- (id) initWithURL:(NSURL *)_url
{
    if (self = [super init])
    {
        url = [_url copy];//[[NSURL URLWithString:feedURLString] retain];
        assert(url);
        boardList = [[NSMutableArray alloc] init];
        errorOccured = NO;
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
    assert(utf8data);
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:utf8data];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
}

#pragma mark NSXMLParser delegate method
- (void) parserDidStartDocument:(NSXMLParser *)parser
{
    [boardList removeAllObjects];
    if(isCategory)
    {
        [category removeAllBoards];
    }
    else
    {
        [board removeAllSubBoards];
    }
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"brd"])
    {
        NSString * name = [attributeDict objectForKey:@"title"];
        NSString * desc = [attributeDict objectForKey:@"desc"];
        int dir = [[attributeDict objectForKey:@"dir"] intValue];
        Board * subBoard = [[Board alloc] initWithName:name Desc:desc Dir:dir];
        subBoard.total = [[attributeDict objectForKey:@"count"] intValue];
        NSString * bmNames = [attributeDict objectForKey:@"bm"];
        if (![bmNames isEqualToString:@""])
        {
            NSArray * bmArray = [bmNames componentsSeparatedByString:@" "];
            [subBoard addBMs:bmArray];
        }
        [boardList addObject:subBoard];
        [subBoard release];
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //NSLog(@"Found string %@.", string);
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (!errorOccured) 
    {
        errorOccured = YES;
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    if (!errorOccured) 
    {
        [delegate onParseSuccessful:[NSDictionary dictionaryWithObject:boardList forKey:kSection]];
    }
    else 
    {
        [delegate onParseFailed:ErrorTypeParse];
    }
}

- (void) dealloc
{
    [delegate release];
    [board release];
    [category release];
    [url release];
    [boardList release];
    [super dealloc];
}

@end
