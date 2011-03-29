//
//  NewPostParser.m
//  ghbbs
//
//  Created by Chenqun Hang on 12/2/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "NewPostParser.h"
#import "ConnectionManager.h"
#import "DataConvertor.h"


NSString * kBoardPermission = @"BoardPermission";
NSString * kTitle = @"Title";
NSString * kPostContent = @"PostContent";

@implementation NewPostParser
@synthesize delegate;
- (id) initWithURL:(NSURL *)_url
{
    if (self = [super init])
    {
        url = [_url copy];
        assert(url);
        boardPermission = nil;
        title = nil;
        postContent = nil;
        buffer = [[NSMutableString alloc] init];
        isAppending = NO;
        errorOccured = NO;
        errorType = ErrorTypeUnknown;        
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
    NSAssert(boardPermission == nil, @"boardPermission shouldn't be nil");
    NSAssert(title == nil, @"title shouldn't be nil");
    NSAssert(postContent == nil, @"postContent shouldn't be nil");
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"bbspst"])
    {
        NSAssert(boardPermission == nil, @"boardPermission should only be alloc once.");
        boardPermission = [[BoardPermission alloc] init];
        boardPermission.edit = [[attributeDict objectForKey:@"edit"] boolValue];
        boardPermission.att = [[attributeDict objectForKey:@"att"] boolValue];
        boardPermission.anony = [[attributeDict objectForKey:@"anony"] boolValue];
    }
    else if([elementName isEqualToString:@"t"])
    {
        [buffer setString:@""];
        isAppending = YES;
    }
    else if([elementName isEqualToString:@"po"])
    {
        [buffer setString:@""];
        isAppending = YES;
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"t"]) 
    {
        title = [NSString stringWithString:buffer];
    }
    else if ([elementName isEqualToString:@"po"])
    {
        postContent = [NSString stringWithString:buffer];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSAssert(buffer != nil, @"buffer shouldn't be nil");
    if (boardPermission != nil) 
    {
        [buffer appendString:string];
    }
    else if ([string isEqualToString:@"请先"])
    {
        errorOccured = YES;
        errorType = ErrorTypeNotLogin;
    }
    else if ([string hasPrefix:@"此文不可回复"])
    {
        errorOccured = YES;
        errorType = ErrorTypeNoPermission;
    }

    
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (!errorOccured) 
    {
        errorOccured = YES;
        errorType = ErrorTypeParse;
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    NSAssert(boardPermission != nil, @"boardPermission should only be alloc once.");

    if (!errorOccured) 
    {
        [delegate onParseSuccessful:[NSDictionary dictionaryWithObjectsAndKeys:
                                     boardPermission, kBoardPermission,
                                     title, kTitle,
                                     postContent, kPostContent, nil]];
    }
    else 
    {
        [delegate onParseFailed:errorType];
    }
}

- (void) dealloc
{
    [delegate release];
    [url release];
    [boardPermission release];
    [super dealloc];
}

@end
