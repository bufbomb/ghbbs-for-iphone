//
//  AuthenticationUtility.m
//  ghbbs
//
//  Created by Chenqun Hang on 11/1/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "AuthenticationUtility.h"
#import "CategoryDataSource.h"
#import "StorageManager.h"

static AuthenticationUtility * sharedInstance = nil;
NSString * kUserStatusUpdate = @"UserStatusUpdate";

@interface AuthenticationUtility()
- (BOOL) checkName:(NSString *)name Password:(NSString *)password;
@end


@implementation AuthenticationUtility
@synthesize status = _status;
+ (AuthenticationUtility *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[AuthenticationUtility alloc] init];
        }
        return sharedInstance;
    }
}

+ (id)allocWithZone:(NSZone *)zone {
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
        self.status = NotSignedIn;
        idleTimer = [[NSTimer alloc] initWithFireDate:nil interval:300 target:self selector:@selector(idle) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)signin
{
    if (self.status == SignedIn)
    {
        return;
    }
    NSArray * nameAndPassword = [[StorageManager sharedInstance] getUserNameAndPassword];
    NSString * name = [nameAndPassword objectAtIndex:0];
    NSString * password = [nameAndPassword objectAtIndex:1];
    
    if (![self checkName:name Password:password])
    {
        self.status = NotSignedIn;
        return;
    }
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: @"http://bbs.fudan.sh.cn/bbs/login"]];
    [theRequest setHTTPMethod:@"POST"];
    NSData * dataToPost = [[NSString stringWithFormat:@"id=%@&pw=%@", name, password] dataUsingEncoding: NSUTF8StringEncoding];
    [theRequest setHTTPBody: dataToPost];
    self.status = SigningIn;
    signinConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
}

- (void)idle
{
    if (self.status == SignedIn)
    {
        NSDate * now = [NSDate date];
        int ticks = (int)([now timeIntervalSince1970] * 1000);
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: 
                                           [NSURL URLWithString:
                                            [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/idle?date=%d", ticks]]];
        [theRequest setHTTPMethod:@"GET"];
        [theRequest setTimeoutInterval:30];
        [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    }
    else
    {
        [idleTimer invalidate];
    }

}

- (void)signoutUntilDone:(BOOL)untilDone
{
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: @"http://bbs.fudan.sh.cn/bbs/logout"]];
    [theRequest setHTTPMethod:@"GET"];
    [theRequest setTimeoutInterval:10];
    if (untilDone) 
    {
        self.status = NotSignedIn;
        [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
        [AuthenticationUtility sharedInstance].status = NotSignedIn;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserStatusUpdate object:nil];
    }
    else
    {
        signoutConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    }
}

- (BOOL) checkName:(NSString *)name Password:(NSString *)password
{
    if (name == nil || password == nil) 
    {
        return NO;
    }
    else if ([name isEqualToString:@""] || [password isEqualToString:@""])
    {
        return NO;
    }
    else if (name.length > 12)
    {
        return NO;
    }
    return YES;
}

#pragma mark NSURLConnection delegate method
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    if (theConnection == signinConnection) 
    {
        NSHTTPURLResponse * httpResponse;
        httpResponse = (NSHTTPURLResponse *) response;
        assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
        
        if ((httpResponse.statusCode / 100) == 3) {
            [AuthenticationUtility sharedInstance].status = SignedIn;
            [idleTimer fire];
        } else {
            [AuthenticationUtility sharedInstance].status = SignInFailed;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserStatusUpdate object:nil];
    }
    else if (theConnection == signoutConnection)
    {
        NSHTTPURLResponse * httpResponse;
        httpResponse = (NSHTTPURLResponse *) response;
        assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
        if ((httpResponse.statusCode / 100) == 3) {
            [AuthenticationUtility sharedInstance].status = NotSignedIn;
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserStatusUpdate object:nil];
        }
    }
    else {
        NSAssert(NO, @"Never happen");
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)theConnection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    if (redirectResponse == nil) 
    {
        return request;        
    }
    else 
    {
        return nil;
    }
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
#pragma unused(theConnection)
#pragma unused(error)
    [theConnection cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
#pragma unused(theConnection)
    [theConnection cancel];
}


@end
