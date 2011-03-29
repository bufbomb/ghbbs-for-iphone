//
//  AuthenticationUtility.h
//  ghbbs
//
//  Created by Chenqun Hang on 11/1/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * kUserStatusUpdate;
typedef enum
{
    SignedIn,
    SigningIn,
    NotSignedIn,
    SignInFailed
}
AuthStatus;

@interface AuthenticationUtility : NSObject {
    AuthStatus _status;
    NSURLConnection * signinConnection;
    NSURLConnection * signoutConnection;
    
    NSTimer * idleTimer;
}
@property AuthStatus status;

+ (AuthenticationUtility *)sharedInstance;
- (void)signin;
- (void)signoutUntilDone:(BOOL)untilDone;

- (void)idle;
@end
