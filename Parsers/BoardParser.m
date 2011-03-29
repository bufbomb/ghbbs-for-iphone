//
//  BoardParser.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "BoardParser.h"
#import "DataConvertor.h"
#import "ConnectionManager.h"

NSString * kPost = @"Post";
NSString * kMode = @"Mode";
NSString * kStickPost = @"StickPost";
NSString * kStart= @"Start";
NSString * kBid = @"bid";

@implementation BoardParser
@synthesize delegate;

- (id) initWithURL:(NSURL *)_url Mode:(ViewMode)_mode;
{
    if (self = [super init]) 
    {
        url = [_url retain];
        postList = [[NSMutableArray alloc] init];
        stickPostList = [[NSMutableArray alloc] init];
        buffer = [[NSMutableString alloc] init];
        viewMode = _mode;
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
    assert(currentPost == nil);
    assert([postList count] == 0);
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"po"])
    {
        currentPost = [[Post alloc] init];
        NSString * owner = [attributeDict objectForKey:@"owner"];
        NSString * time = [attributeDict objectForKey:@"time"];
        NSString * pid = [attributeDict objectForKey:@"id"];
        NSString * mark = [attributeDict objectForKey:@"m"];
        [buffer setString:@""];
        if([attributeDict objectForKey:@"sticky"] != nil)
        {
            currentPost.isStick = YES;
        }
        currentPost.owner = owner;
        currentPost.time = time;
        currentPost.pid = pid;
        currentPost.mark = mark;
        
        assert(currentPost.pid != nil);
        assert(currentPost.owner != nil);
        assert(currentPost.time != nil);
        assert(currentPost.mark != nil);
        assert([currentPost.mark length] == 1);
    }
    else if ([elementName isEqualToString:@"brd"])
    {
        id _bid = [attributeDict objectForKey:@"bid"];
        id _start = [attributeDict objectForKey:@"start"];
        assert(_bid != nil);
        assert(_start != nil);
        bid = [_bid retain];
        start = [_start intValue];
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"po"])
    {
        currentPost.title = buffer;
        if(currentPost.isStick)
        {
            [stickPostList insertObject:currentPost atIndex:0];
        }
        else
        {
            [postList insertObject:currentPost atIndex:0];
        }
        [currentPost release];
        currentPost = nil;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [buffer appendString:string];
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
        NSNumber * viewModeNumber = [NSNumber numberWithInt:viewMode];
        NSNumber * startNumber = [NSNumber numberWithInt:start];
        NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:postList, kPost,
                               stickPostList, kStickPost,
                               viewModeNumber, kMode, 
                               startNumber, kStart,
                               bid, kBid,
                               nil];
        [delegate onParseSuccessful:data];        
    }
    else
    {
        [delegate onParseFailed:ErrorTypeParse];    
    }
}

- (void) dealloc
{
    [buffer release];
    [postList release];
    [stickPostList release];
    [url release];
    [super dealloc];
}

@end
