//
//  NetworkTest.m
//  ghbbs
//
//  Created by Chenqun Hang on 10/29/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "NetworkTest.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation NetworkTest
//TODO:
//The two methods are used to test if bbs.fudan.sh.cn is available.
+ (BOOL) connectedToNetwork
{
    /*struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && ! needsConnection);*/
    return YES;
}

+ (BOOL) hostAvailable:(NSString *) theHost
{
    //struct hostent * host = gethostbyname([theHost UTF8String]);
    //return host != NULL;
    return YES;
}
@end
