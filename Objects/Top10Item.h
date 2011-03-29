//
//  Top10Item.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Top10Item : NSObject {
    NSString * _boardName;
    NSString * _postTitle;
    NSString * _owner;
    NSString * _pid;
    int _count;
}
- (id) initWithBoardName:(NSString *)name Owner:(NSString *)owner Pid:(NSString *)pid Count:(int)count;

@property (nonatomic, copy) NSString * boardName;
@property (nonatomic, copy) NSString * owner;
@property (nonatomic, copy) NSString * pid;
@property (nonatomic, copy) NSString * postTitle;
@property int count;

@end
