//
//  DataConvertor.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/7/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataConvertor : NSObject {

}
+ (NSData *) convertXMLData:(NSData *)data withEncoding:(CFStringEncoding) cfEncode;
+ (NSData *) preprocessData:(NSData *)data;
+ (NSString *) URLEncodeGB18030String:(NSString *)string;
@end
