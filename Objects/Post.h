//
//  Post.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Post : NSObject {
    NSString * _title;
    NSString * _owner;
    NSString * _content;
    NSString * _time;
    NSString * _mark;
    BOOL _isStick;
    NSString * _pid;
}
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * owner;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * mark;
@property BOOL isStick;
@property (nonatomic, copy) NSString * pid;
- (id) init;

@end
