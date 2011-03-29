//
//  NetworkTest.h
//  ghbbs
//
//  Created by Chenqun Hang on 10/29/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkTest : NSObject {

}
+ (BOOL) connectedToNetwork;
+ (BOOL) hostAvailable:(NSString *) theHost;
@end
