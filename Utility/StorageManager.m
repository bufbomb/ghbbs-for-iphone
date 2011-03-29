//
//  StorageManager.m
//  ghbbs
//
//  Created by Chenqun Hang on 12/6/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "StorageManager.h"
static StorageManager * sharedInstance = nil;
static NSString * AccountFilePath = @"account.txt";
@implementation StorageManager
+ (StorageManager *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[StorageManager alloc] init];
        }
        return sharedInstance;
    }
}

+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id) init
{
    if(self = [super init])
    {
        fileManager = [NSFileManager defaultManager];
        wholeAccountFilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", AccountFilePath] copy];
        if (![fileManager fileExistsAtPath:wholeAccountFilePath]) 
        {
            [fileManager createFileAtPath:wholeAccountFilePath contents:nil attributes:nil];
        }
    }
    return self;
}


- (void) saveUserName:(NSString *)username Password:(NSString *)password
{
    NSAssert(username != nil && password != nil, @"username or password can't be nil.");
    
    NSString * dataStr = [NSString stringWithFormat:@"%@\n%@", username, password];
    NSData * data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSAssert(data != nil, @"data shouldn't be nil.");
    
    [data writeToFile:wholeAccountFilePath options:NSDataWritingAtomic error:nil];
}

- (NSArray *)getUserNameAndPassword
{
    NSString * dataStr = [NSString stringWithContentsOfFile:wholeAccountFilePath encoding:NSUTF8StringEncoding error:nil];
    if (dataStr == nil || [dataStr isEqualToString:@""]) 
    {
        return [NSArray arrayWithObjects:@"", @"", nil];
    }
    NSArray * results = [dataStr componentsSeparatedByString:@"\n"];
    NSAssert([results count] == 2, @"results length should be exactly 2");
    return results;
}

- (void) dealloc
{
    [wholeAccountFilePath release];
    [super dealloc];
}

@end
