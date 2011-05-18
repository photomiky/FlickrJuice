//
//  CommentsTableModel.m
//  FlickrJuice
//
//  Created by Michael Rabin on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentsTableModel.h"
#import <extThree20JSON/extThree20JSON.h>
#import "LoginViewController.h"
#import "FFComment.h"

@implementation CommentsTableModel


extern const NSString* FlickrAPIKey;
extern const NSString* FlickrSecret;
extern const NSString* FLICKR_API;

@synthesize comments=_comments, objectId=_objectId;


-(id) initWithPhotoId:(NSString *) photoId{
		
	if(self = [super init]){
		
		self.objectId = photoId;
		
	}
	
	return self;
	
	
}

- (void) dealloc {
	TT_RELEASE_SAFELY(_comments);
	TT_RELEASE_SAFELY(_objectId);
	[super dealloc];
}


- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {		
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *token = [defaults objectForKey:@"token"];
	NSString *method = @"flickr.photos.comments.getList";
	
	NSString *api_sig_str = [NSString stringWithFormat:@"%@api_key%@auth_token%@formatjsonmethod%@nojsoncallback1photo_id%@", FlickrSecret, FlickrAPIKey, token, method, _objectId]; 
	NSLog(@"api_Sig %@", api_sig_str);
	
	NSString *api_sig = [LoginViewController md5:api_sig_str];
	
	NSString *params = [NSString stringWithFormat:@"method=%@&photo_id=%@&format=json&nojsoncallback=1&api_key=%@&auth_token=%@&api_sig=%@", method, _objectId, FlickrAPIKey, token, api_sig];
	
	NSString *url = [FLICKR_API stringByAppendingString:params];
	NSLog(@"url sent to flickr is %@", url);
	
	//NSString *url2 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	TTURLRequest *req = [TTURLRequest
						 requestWithURL: url
						 delegate: self];
	
	req.cachePolicy = TTURLRequestCachePolicyNoCache;
	//		self.ttReq.cacheExpirationAge = 0;
	
	TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
	
	//response.isRssFeed = YES;
	//response.isRssFeed = YES;
	req.response = response;
	
	TT_RELEASE_SAFELY(response);
	
	[req send];
	
	
}


- (void)requestDidFinishLoad:(TTURLRequest*)request {

	TTURLJSONResponse* response = request.response;
	//TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
	//	// 
	//	 
	
	NSDictionary* feed = response.rootObject;
	
	NSLog(@"response %@", feed);	 
	
	NSDictionary* itemsWrap = [feed objectForKey:@"comments"];
	NSArray* items = [itemsWrap objectForKey:@"comment"];
	NSMutableArray *userComments = [[NSMutableArray alloc] init];
	for(NSDictionary *comment in items){
	
		FFComment *aComment = [[FFComment alloc] init];
		aComment.author = [comment objectForKey:@"author"];
		aComment.authorName = [comment objectForKey:@"authorname"]; 
		aComment.permaLink = [comment objectForKey:@"permalink"];
		aComment.uid = [comment objectForKey:@"id"];
		aComment.comment = [comment objectForKey:@"_content"];
		aComment.iconFarm = [comment objectForKey:@"iconfarm"];
		aComment.iconServer = [comment objectForKey:@"iconserver"];
		[userComments addObject:aComment];
		
	}
	
	self.comments = userComments;
	TT_RELEASE_SAFELY(userComments);
	[super requestDidFinishLoad:request];
	
}


@end
