//
//  UserPreference.h
//  ghbbs
//
//  Created by Chenqun Hang on 12/16/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserPreference : NSObject {

}
+ (BOOL) isEnglishName;
+ (BOOL) isShownPicture;
+ (BOOL) needAnsiColor;
+ (void) setEnglishName:(BOOL) englishName;
+ (void) setShowPicture:(BOOL)isShown;
+ (void) setAnsiColor:(BOOL)showColor;
@end
