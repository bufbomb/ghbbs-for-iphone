//
//  PictureManager.m
//  ghbbs
//
//  Created by hangchenqun on 3/14/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import "PictureManager.h"
NSString * kPictureUpdate = @"PictureUpdate";
@interface PictureManager()
- (void) start;
- (void) stop;
- (void) download;
- (void) prepare;
- (void) addPicture:(NSData *)data withURL:(NSString *)key;
@end


@implementation PictureManager
static PictureManager * sharedInstance = nil;
+ (PictureManager *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[PictureManager alloc] init];
        }
        return sharedInstance;
    }
}

+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id) init
{
    if(self = [super init])
    {
		downloadingQueue = [[NSMutableArray alloc] init];
		failedQueue = [[NSMutableArray alloc] init];
		downloadedPictures = [[NSMutableDictionary alloc] init];
		bufferredData = [[NSMutableData alloc] init];
		status = 0;
		started = NO;
    }
    return self;
}

- (void) addPictureToQueue:(NSString *)picurl
{
	NSAssert(picurl != nil, @"no nil");
	NSAssert(downloadingQueue != nil, @"downloading queue shouldn't be nil.");
	@synchronized(downloadingQueue)
	{
		if (![downloadingQueue containsObject:picurl]) 
		{
			[downloadingQueue addObject:picurl];
		}
	}
	if (!started) 
	{
		[self start];
	}
}

- (void) addPicture:(NSData *)data withURL:(NSString *)key
{
	assert(data);
	assert(key);
	assert([downloadedPictures objectForKey:key] == nil);
	UIImage * image = [[UIImage alloc] initWithData:data];
	if (image == nil) 
	{
		return;
	}
	@synchronized(downloadedPictures)
	{
		[downloadedPictures setObject:image forKey:key];
		[[NSNotificationCenter defaultCenter] postNotificationName:kPictureUpdate object:nil];
	}
	[image release];
	return;
}

- (UIImage *) getPicture:(NSString *)picurl
{
	NSAssert(picurl != nil, @"no nil");
	NSAssert(downloadedPictures != nil, @"downloading queue shouldn't be nil.");
	@synchronized(downloadedPictures)
	{
		UIImage * picture = [downloadedPictures objectForKey:picurl];
		if (picture == nil) 
		{
			if (![failedQueue containsObject:picurl]) 
			{
				[self addPictureToQueue:picurl];
			}
		}
		return picture;
	}
}

- (void) start
{
	assert(!started);
	NSAssert(downloadingQueue != nil && [downloadingQueue count] > 0, @"should have a queue.");
	if (downloadingQueue == nil || [downloadingQueue count] == 0) 
	{
		return;
	}
	started = YES;
	[self prepare];
	[self download];
}

- (void) stop
{
	assert(started);
	connection = nil;
	[bufferredData setData:nil];
	started = NO;
}

- (void) download
{
	@synchronized(downloadingQueue)
	{
		if ([downloadingQueue count] > 0) 
		{
			NSString * picUrlStr = [downloadingQueue objectAtIndex:0];
			currentDownloading = [picUrlStr retain];
			NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: picUrlStr]];
			[theRequest setHTTPMethod:@"GET"];
			connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
		}
		else 
		{
			[self stop];
		}
	}
}

- (void) prepare
{
	[bufferredData setData:nil];
	[currentDownloading release];
	currentDownloading = nil;	
}

#pragma mark NSURLConnection delegate method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse * httpResponse;
	httpResponse = (NSHTTPURLResponse *) response;
	assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
	status = httpResponse.statusCode;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	assert(bufferredData);
	assert(data);
	[bufferredData appendData:data];
}


- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	#pragma unused(theConnection)
	#pragma unused(error)
	assert(NO);
	assert([currentDownloading isEqualToString:[downloadingQueue objectAtIndex:0]]);
    [theConnection cancel];
	[failedQueue addObject:currentDownloading];
	[self prepare];
	[downloadingQueue removeObjectAtIndex:0];
	[self download];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
	#pragma unused(theConnection)
	assert([currentDownloading isEqualToString:[downloadingQueue objectAtIndex:0]]);
	if (status / 100 == 2) 
	{
		NSData * imageData = [bufferredData copy];
		[self addPicture:imageData withURL:currentDownloading];
		[imageData release];
	}
	else 
	{
		[failedQueue addObject:currentDownloading];
	}

	[self prepare];
	[downloadingQueue removeObjectAtIndex:0];
	[self download];
}

- (void) dealloc
{
	[failedQueue release];
	[downloadingQueue release];
	[downloadedPictures release];
	[super dealloc];
}


@end
