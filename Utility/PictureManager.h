//
//  PictureManager.h
//  ghbbs
//
//  Created by hangchenqun on 3/14/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * kPictureUpdate;

@interface PictureManager : NSObject {
	NSMutableArray * downloadingQueue;
	NSMutableArray * failedQueue;
	NSMutableDictionary * downloadedPictures;
	BOOL started;
	NSURLConnection * connection;
	int status;
	NSMutableData * bufferredData;
	NSString * currentDownloading;
}
+ (PictureManager *)sharedInstance;
- (void) addPictureToQueue:(NSString *)picurl;
- (UIImage *) getPicture:(NSString *)picurl;
@end
