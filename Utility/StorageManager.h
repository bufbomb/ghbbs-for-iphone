//
//  StorageManager.h
//  ghbbs
//
//  Created by Chenqun Hang on 12/6/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StorageManager : NSObject {
    NSFileManager * fileManager;
    NSString * wholeAccountFilePath;
}
+ (StorageManager *)sharedInstance;

- (void) saveUserName:(NSString *)username Password:(NSString *)password;
- (NSArray *)getUserNameAndPassword;
@end
