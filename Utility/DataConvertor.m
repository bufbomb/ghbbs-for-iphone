//
//  DataConvertor.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/7/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "DataConvertor.h"
typedef enum {
    GB18030Normal,
    GB18030FirstByteRead,
    GB18030SecondByteRead,
    GB18030ThirdByteRead
}  GB18030EncodingStatus;

@implementation DataConvertor
+ (NSData *) convertXMLData:(NSData *)data withEncoding:(CFStringEncoding) cfEncode
{
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(cfEncode);
    NSData * processedData = [DataConvertor preprocessData:data];
    
    
    NSString * str = [[NSString alloc] initWithData:processedData encoding:encode];
    if (str == nil) 
    {
        return nil;
    }
    NSString * new_str = [str stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
    if (![str hasPrefix:@"<?xml"]) 
    {
        new_str = [NSString stringWithFormat:@"%@%@", @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>", str];
    }
    NSData * utf8data = [new_str dataUsingEncoding:NSUTF8StringEncoding];
    [str release];
    return utf8data;
}

+ (NSData *) preprocessData:(NSData *)data
{
    NSAssert(data != nil, @"data shouldn't be nil.");
    NSMutableData * processedData = [[NSMutableData alloc] initWithData:data];
    Byte * bytes = (Byte *)[processedData bytes];
    int dataLength = [processedData length];
    GB18030EncodingStatus status = GB18030Normal;
    for (int i = 0; i < dataLength; i++)
    {
        Byte currentByte = bytes[i];
        switch (status)
        {
            case GB18030Normal:
                if (currentByte >= 0x81 && currentByte <= 0xFE) 
                {
                    status = GB18030FirstByteRead;
                }
                else 
                {
					if (currentByte == 0x80) 
					{
						bytes[i] = 0x3F;
					}
                }
                break;
            case GB18030FirstByteRead:
                if (currentByte >= 0x30 && currentByte <= 0x39) 
                {
                    status = GB18030SecondByteRead;
                }
                else if ((currentByte >= 0x40 && currentByte <= 0x7E) || (currentByte >= 0x80 && currentByte <= 0xFE))
                {
                    status = GB18030Normal;
                }
                else 
                {
                    i--;
                    bytes[i] = 0x3F; //0x3f = '?'
                    status = GB18030Normal;
                }
                break;
            case GB18030SecondByteRead:
                if (currentByte >= 0x81 && currentByte <= 0xFE) 
                {
                    status = GB18030ThirdByteRead;
                }
                else 
                {
                    i -= 2;
                    bytes[i] = 0x3F;
                    status = GB18030Normal;
                }
                break;
            case GB18030ThirdByteRead:
                if (currentByte >= 0x30 && currentByte <= 0x39)
                {
                    status = GB18030Normal;
                }
                else 
                {
                    i -= 3;
                    bytes[i] = 0x3F;
                    status = GB18030Normal;
                }
                break;
            default:
                assert(NO);
                break;
        }
    }
    switch (status) {
        case GB18030Normal:
            break;
        case GB18030FirstByteRead:
            bytes[dataLength - 1] = 0x3F;
            break;
        case GB18030SecondByteRead:
            bytes[dataLength - 1] = 0x3F;
            bytes[dataLength - 2] = 0x3F;
            break;
        case GB18030ThirdByteRead:
            bytes[dataLength - 1] = 0x3F;
            bytes[dataLength - 2] = 0x3F;
            bytes[dataLength - 3] = 0x3F;
            break;
        default:
            assert(NO);
            break;
    }
    NSData * result = [[NSData alloc] initWithData:processedData];
    [processedData release];
    return [result autorelease];
}

+ (NSString *) URLEncodeGB18030String:(NSString *)string
{
    NSData * stringData = [string dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSMutableString * bufferString = [[NSMutableString alloc] init];
    const Byte * bytes = [stringData bytes];
    for (int i = 0; i < [stringData length]; i ++) 
    {
        [bufferString appendFormat:@"%%%02X", bytes[i]];
    }
    
    NSString * resultString = [NSString stringWithString:bufferString];
    [bufferString release];
    return resultString;
}



@end
