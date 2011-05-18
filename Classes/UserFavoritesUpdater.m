//
//  UserFavoritesUpdater.m
//  FlickrJuice2
//
//  Created by Michael Rabin on 10/04/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import "UserFavoritesUpdater.h"


@implementation UserFavoritesUpdater
@synthesize favedImageIds=_favedImageIds, flickr=_flickr;


-(id) init{
	
	
	if(self = [super init]){
		OFFlickrAPIContext *context = [[OFFlickrAPIContext alloc] initWithAPIKey:@"749d579517e11bafb606299f70a6fe18" sharedSecret:@"72221c4e323bf274"];		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSLog(@"Setting flickr uploader with token %@", [prefs objectForKey:@"token"]);
		[context setAuthToken:[prefs objectForKey:@"token"]];
		
		self.flickr = [[OFFlickrAPIRequest alloc] initWithAPIContext:context];		
		[self.flickr setDelegate:self];
		self.favedImageIds = [[NSMutableDictionary alloc] init];
	}
	
	return self;
	
}

-(void) dealloc{

	[self.flickr release];
	[super dealloc];
	
}

-(void) downloadUserFaves{

	
	[self.flickr callAPIMethodWithGET:@"flickr.favorites.getList" arguments:nil];
	
	
}

-(void) addFavedImageWithKey:(NSString *) key{

	if(![self.favedImageIds objectForKey:key]){
			
		[self.favedImageIds setObject:@"1" forKey:key];
	}
	
	
}

-(BOOL) isFavedImage:(NSString *) key{
		
	if(![self.favedImageIds objectForKey:key]){
		return NO;
	}
	
	return YES;
	
	
}


- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(unsigned int)inSentBytes totalBytes:(unsigned int)inTotalBytes{
	
	NSLog(@"uploaded %u out of %u bytes", inSentBytes, inTotalBytes);
}


#pragma mark OFFlickrAPIRequest delegate methods
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
	//NSLog(@"Did complete with response %@", inResponseDictionary);
	NSDictionary *photos = [inResponseDictionary objectForKey:@"photos"];
	NSArray *allphotos = [photos objectForKey:@"photo"];
	for(NSDictionary *photo in allphotos){
	
		NSString *key = [[photo objectForKey:@"owner"] stringByAppendingString:[photo objectForKey:@"id"]];
		if(![self.favedImageIds objectForKey:key]){
			[self.favedImageIds setValue:@"1" forKey:key];
		}
	}
	//NSLog(@"Faved images stored in memory : %@", self.favedImageIds);					  
}



- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	NSLog(@"uploading failed with errors ", [inError description]);
	
}


@end
