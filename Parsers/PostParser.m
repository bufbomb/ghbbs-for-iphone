//
//  PostParser.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/13/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "PostParser.h"
#import "DataConvertor.h"
#import "ConnectionManager.h"

@implementation PostParser
@synthesize delegate;

- (id) initWithURL:(NSURL *)_url
{
    if (self = [super init])
    {
        url = [_url retain];
        buffer = [[NSMutableString alloc] init];
        isAppending = NO;
        posts = [[NSMutableArray alloc] init];
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
    assert(utf8data);
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:utf8data];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
}

#pragma mark NSXMLParser delegate method
- (void) parserDidStartDocument:(NSXMLParser *)parser
{
    assert(currentPost == nil);
    assert(isAppending == NO);
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"po"])
    {
        currentPost = [[Post alloc] init];
        id owner = [attributeDict objectForKey:@"owner"];
        id pid = [attributeDict objectForKey:@"fid"];
        if (owner != nil) 
        {
            currentPost.owner = owner;
        }
        if (pid != nil) 
        {
            currentPost.pid = pid;
        }
        
        [buffer setString:@""];
        isAppending = YES;
    }
    else if ([elementName isEqualToString:@"bbstcon"]) 
    {
        NSString * _bid = [attributeDict objectForKey:@"bid"];
        assert(bid == nil);
        assert(_bid != nil);
        bid = [[NSString alloc] initWithString:_bid];
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"po"])
    {
        currentPost.content = buffer;
        [posts addObject:currentPost];
        [currentPost release];
        currentPost = nil;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (currentPost != nil) 
    {
        [buffer appendString:string];        
    }
    else if ([string isEqualToString:@"找不到指定的文件"])
    {
        errorOccured = YES;
        errorType = ErrorTypeFileNotFound;
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
    if (!errorOccured) 
    {
        NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:posts, kPost, bid, kBid, nil];
        [delegate onParseSuccessful:data];            
    }
    else 
    {
        [delegate onParseFailed:errorType];
    }

}

- (void) dealloc
{
    [bid release];
    [buffer release];
    [posts release];
    [super dealloc];
}

@end
