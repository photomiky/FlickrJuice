//
//  UserPhotosModel.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserPhotosModel.h"
#import "LoginViewController.h"
extern const NSString* FlickrAPIKey;
extern const NSString* FlickrSecret;
extern const NSString* FLICKR_API;
@implementation UserPhotosModel
@synthesize title, usersPhotos=_usersPhotos, responseProcessor=_responseProcessor, userId=_userId, userName=_userName;


-(id) initWithUserId:(NSString *)userId andUserName:(NSString *)userName
{
	
    self = [super init];
	if(self){
	
		self.userId = userId;
		self.userName = userName;
		//self.title = userName;
		self.usersPhotos = [[[NSArray alloc] init] autorelease];
		self.responseProcessor = [[SPAlbumJSONResponse alloc] init];
		page = 1;
		
	}
	return self;
	
}

- (id)init {
	self = [super init];
	if (self) {
		self.usersPhotos = [[[NSArray alloc] init] autorelease];
		self.responseProcessor = [[SPAlbumJSONResponse alloc] init];		
		page = 1;
	}
	
	return self;
}

-(void) dealloc{
	TT_RELEASE_SAFELY(title);
	TT_RELEASE_SAFELY(_usersPhotos);
	TT_RELEASE_SAFELY(_responseProcessor);
	TT_RELEASE_SAFELY(_userId);
	TT_RELEASE_SAFELY(_userName);
	[super dealloc];
	
}


- (NSInteger)numberOfPhotos {
	int numPhotos = [_responseProcessor totalObjectsAvailableOnServer];
	return numPhotos;
}

- (NSInteger)maxPhotoIndex {
	NSInteger count =  [self usersPhotos].count - 1;
	NSLog(@"maxPhotoIndex returned %d", count);
	return count;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index {
	if (index < [self usersPhotos].count) {
		id<TTPhoto> photo = [[self usersPhotos] objectAtIndex:index];
		photo.index = index;
		photo.photoSource = self;
		return photo;
	} else {
		return nil;
	}
}

- (NSArray *)usersPhotos
{
    return [[[_responseProcessor objects] copy] autorelease];
}


- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	
	
	
	if(more){
		page++;
	}
    if (!self.isLoading) {
		
		NSString *method = @"flickr.people.getPhotos";
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];		
		NSString *token = [defaults objectForKey:@"token"];
		NSString *pagenumber = [[NSNumber numberWithInt:page] stringValue];
		NSString *api_sig_str = [NSString stringWithFormat:@"%@api_key%@auth_token%@extrasurl_t,url_mformatjsonmethod%@nojsoncallback1page%@user_id%@", FlickrSecret, FlickrAPIKey, token, method, pagenumber, self.userId]; 
		NSLog(@"api_Sig %@", api_sig_str);
		
		NSString *api_sig = [LoginViewController md5:api_sig_str];
		
		NSString *params = [NSString stringWithFormat:@"method=%@&user_id=%@&page=%@&&extras=url_t,url_m&format=json&nojsoncallback=1&api_key=%@&auth_token=%@&api_sig=%@", method, self.userId, pagenumber, FlickrAPIKey, token, api_sig];
		
		NSString *url = [FLICKR_API stringByAppendingString:params];
		NSLog(@"url is %@", url);
		TTURLRequest *req = [TTURLRequest
							 requestWithURL: url
							 delegate: self];
		
		req.cachePolicy = cachePolicy;
		req.cacheExpirationAge = TT_DEFAULT_CACHE_EXPIRATION_AGE;
		// sets the response
		req.response = self.responseProcessor;
		req.httpMethod = @"GET";
		//req.response = response;
		
		[req send];
		
		
		
	}
	
	
	
}


- (void)invalidate:(BOOL)erase {
	NSLog(@"invalidating SPPhotoSource. erase=%d", erase);
	[self.responseProcessor.objects removeAllObjects];
	[super invalidate:erase];
}


@end
