//
//  ConnectionManager.m
//  ghbbs
//
//  Created by Chenqun Hang on 10/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "ConnectionManager.h"

static int taskCount = 0;
@implementation ConnectionManager
+ (NSData *) dataOfURL:(NSURL *)url
{
    taskCount ++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData * data = [NSData dataWithContentsOfURL:url];
    taskCount --;
    if (taskCount <= 0) 
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;        
    }
    return data;
}
@end
