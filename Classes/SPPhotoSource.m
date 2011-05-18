//
//  SPPhotoSource.m
//  SPFeed
//
//  Created by Ynon Perek on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPPhotoSource.h"
#import <extThree20JSON/extThree20JSON.h>



@implementation SPPhotoSource

extern const NSString* FlickrAPIKey;
extern const NSString* FlickrSecret;

extern const NSString* FLICKR_API;

@synthesize interestingPics=_interestingPics, responseProcessor=_responseProcessor, title;

-(id) initWithTitle:(NSString *) aTitle{
	

	if(self = [super init]){
	
		//self.interestingPics = [[NSArray alloc] init];
		self.responseProcessor = [[SPAlbumJSONResponse alloc] init];		
		page = 1;
		title = aTitle;
	}
	
	return self;
}

- (id)init {
	
	if (self = [super init]) {
		//self.interestingPics = [[NSArray alloc] init];
		self.responseProcessor = [[SPAlbumJSONResponse alloc] init];		
		page = 1;
	}
	
	return self;
}

-(void) dealloc{
		
	//[self.interestingPics dealloc];
	//[self.responseProcessor dealloc];
	[super dealloc];
	
}

- (NSArray *)interestingPics
{
    return [[[_responseProcessor objects] copy] autorelease];
}


 
///////////////////////////////////////////////////////////////////////////////////////////////////
// TTPhotoSource

- (NSInteger)numberOfPhotos {
	int numPhotos = [_responseProcessor totalObjectsAvailableOnServer];
	//NSLog(@"Number of photos %d", numPhotos);
	return numPhotos;
}

- (NSInteger)maxPhotoIndex {
	return [self interestingPics].count - 1;
	NSLog(@"maxPhotoIndex returned %d", [self interestingPics].count - 1);
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index {
	if (index < [self interestingPics].count) {
		id<TTPhoto> photo = [[self interestingPics] objectAtIndex:index];
		photo.index = index;
		photo.photoSource = self;
		return photo;
	} else {
		return nil;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModel

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	
	if(more){
		page++;
	}
    if (!self.isLoading) {
		
		NSString *method = @"flickr.interestingness.getList";
		
		NSString *pagenumber = [[NSNumber numberWithInt:page] stringValue];
		NSString *params = [NSString stringWithFormat:@"method=%@&page=%@&extras=url_t,url_m,url_l&format=json&nojsoncallback=1&api_key=%@", method, pagenumber, FlickrAPIKey];
		
		NSString *url = [FLICKR_API stringByAppendingString:params];
		NSLog(@"url sent to flickr is %@", url);
		
		
		TTURLRequest *req = [TTURLRequest
							 requestWithURL: url
							 delegate: self];
		
		req.cachePolicy = TTURLRequestCachePolicyNoCache;		

		
		req.cachePolicy = cachePolicy;
		req.cacheExpirationAge = TT_DEFAULT_CACHE_EXPIRATION_AGE;
		// sets the response
		req.response = self.responseProcessor;
		req.httpMethod = @"GET";

		
		[req send];
		
	}
	
  
}



- (void)invalidate:(BOOL)erase {
	NSLog(@"invalidating SPPhotoSource. erase=%d", erase);
	[self.responseProcessor.objects removeAllObjects];
	[super invalidate:erase];
}

@end
