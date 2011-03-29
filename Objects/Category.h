//
//  Category.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/8/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"

@interface Category : NSObject {
    NSString * _name;
    NSString * _cid;
    NSMutableArray * boardList;
}

- (id) initWithName:(NSString *)name Cid:(NSString *) cid;
- (void) addBoard:(Board *)board;
- (void) addBoards:(NSArray *)boards;
- (void) removeAllBoards;
- (int) numberOfBoards;
- (Board *) boardAtIndex:(int)index;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * cid;
@end
