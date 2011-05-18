//
//  FlickrUploader.m
//  FlickrJuice2
//
//  Created by Michael Rabin on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlickrUploader.h"
#import "LoginViewController.h"

@implementation FlickrUploader

@synthesize ofRequest, uploadDelegate, uploadImageData, dict;
@synthesize pool=_pool, uploadQueue=_uploadQueue;
extern const NSString* FlickrAPIKey;
extern const NSString* FlickrSecret;

-(id) init{
	self = [super init];
	if(self){
		
		OFFlickrAPIContext *context = [[OFFlickrAPIContext alloc] initWithAPIKey:@"749d579517e11bafb606299f70a6fe18" sharedSecret:@"72221c4e323bf274"];		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSLog(@"Setting flickr uploader with token %@", [prefs objectForKey:@"token"]);
		[context setAuthToken:[prefs objectForKey:@"token"]];
		
		self.ofRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:context];
		[self.ofRequest setDelegate:self];	
		self.uploadQueue = [[NSMutableSet alloc] init];
	}
	
	return self;
}


-(void) dealloc{

	[self.ofRequest release];
	[self.uploadQueue release];
	[super dealloc];
	
}

-(void) uploadImage:(NSData *) imageData andDictionary:(NSDictionary *) dictionary{
	
	totalNumberOfRequests++;
	UploadImage *upload = [[UploadImage alloc] init];
	upload.imageData = imageData;
	upload.dict = dictionary;
	[self.uploadQueue addObject:upload];
	NSLog(@"Upload %@ added to Queue %@", upload, self.uploadQueue);
	[upload release];
	if([self.uploadQueue count] == 1){
		[self startNextRequest];
	}
	[uploadDelegate onDownloadStart:[self.uploadQueue count]];
	
}
	 
-(void) startNextRequest{
		
	UploadImage *upload = [self.uploadQueue anyObject];
	if(upload){
		NSInputStream *imageStream = [NSInputStream inputStreamWithData:upload.imageData];
		[self.ofRequest uploadImageStream:imageStream suggestedFilename:@"FlickrJuice_upload.png" MIMEType:@"image/png" arguments:upload.dict];
		[self.uploadQueue removeObject:upload];
	}
	
}
	 
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(unsigned int)inSentBytes totalBytes:(unsigned int)inTotalBytes{
	
	NSLog(@"uploaded %u out of %u bytes", inSentBytes, inTotalBytes);
	//[self.uploadDelegate onProgress:inSentBytes outOfTotal:inTotalBytes];
}


#pragma mark OFFlickrAPIRequest delegate methods
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
	NSLog(@"Did complete with response %@", inResponseDictionary);
	int finished = totalNumberOfRequests - [self.uploadQueue count];
	[self.uploadDelegate onProgress:finished outOfTotal:totalNumberOfRequests];
	if ([self.uploadQueue count] > 0 ) {
		[self startNextRequest];
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	NSLog(@"uploading failed with errors %@", [inError description]);

}
@end
