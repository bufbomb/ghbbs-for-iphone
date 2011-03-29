//
//  BBSParserDelegate.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/20/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ErrorType.h"

@protocol BBSParserDelegate <NSObject>
-(void) onParseSuccessful:(NSDictionary *)data;
-(void) onParseFailed:(ErrorType)error;

@end
