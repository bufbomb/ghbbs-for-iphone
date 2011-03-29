//
//  ErrorType.h
//  ghbbs
//
//  Created by Chenqun Hang on 10/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum 
{
    ErrorTypeNetwork,
    ErrorTypeParse,
    ErrorTypeEncoding,
    ErrorTypeFileNotFound,
    ErrorTypeNotLogin,
    ErrorTypeNoPermission,
    ErrorTypeUnknown
}ErrorType;