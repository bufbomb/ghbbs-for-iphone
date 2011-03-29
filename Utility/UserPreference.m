//
//  UserPreference.m
//  ghbbs
//
//  Created by Chenqun Hang on 12/16/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "UserPreference.h"
NSString * kEnglishNameKey = @"EnglishName";
NSString * kSignature = @"Signature";
NSString * kShowPictureKey = @"ShowPicture";
NSString * kAnsiColor = @"AnsiColor";

@implementation UserPreference

+ (BOOL) isEnglishName
{
    NSNumber * englishNameNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kEnglishNameKey];
    
    if (englishNameNumber == nil) 
    {
        return YES;
    }
    else 
    {
        return [englishNameNumber boolValue];    
    }
}

+ (void) setEnglishName:(BOOL) englishName
{
    NSNumber * englishNameNumber = [NSNumber numberWithBool:englishName];
    [[NSUserDefaults standardUserDefaults] setObject:englishNameNumber forKey:kEnglishNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) isShownPicture
{
	NSNumber * isShownNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kShowPictureKey];
	
	if (isShownNumber == nil)
	{
		return YES;
	}
	else 
	{
		return [isShownNumber boolValue];
	}

}

+ (void) setShowPicture:(BOOL) isShown
{
	NSNumber * isShownNumber = [NSNumber numberWithBool:isShown];
	[[NSUserDefaults standardUserDefaults] setObject:isShownNumber forKey:kShowPictureKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) needAnsiColor
{
	NSNumber * isAnsiColor = [[NSUserDefaults standardUserDefaults] objectForKey:kAnsiColor];
	
	if (isAnsiColor == nil)
	{
		return YES;
	}
	else
	{
		return [isAnsiColor boolValue];
	}
}

+ (void) setAnsiColor:(BOOL) isAnsiColor
{
	NSNumber * isAnsiColorNumber = [NSNumber numberWithBool:isAnsiColor];
	[[NSUserDefaults standardUserDefaults] setObject:isAnsiColorNumber forKey:kAnsiColor];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
/*+ (NSString *) getSignature
{
    NSString * result = [[NSUserDefaults standardUserDefaults] objectForKey:kSignature];
    if (result == nil) 
    {
        return @"Post from my iPhone";
    }
    else
    {
        return result;
    }

}

+ (void) setSignature:(NSString *)signature
{
    assert(signature);
    if (signature != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:signature forKey:kSignature];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}*/

@end
