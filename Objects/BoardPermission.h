//
//  BoardPermission.h
//  ghbbs
//
//  Created by Chenqun Hang on 12/2/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BoardPermission : NSObject {
    BOOL _edit;
    BOOL _att;
    BOOL _anony;
}

@property BOOL edit;
@property BOOL att;
@property BOOL anony;

@end
