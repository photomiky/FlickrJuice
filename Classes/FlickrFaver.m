//
//  FlickrFaver.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrFaver.h"
#import "FlickrPhoto.h"
#import "LoginViewController.h"

@implementation FlickrFaver
@synthesize dlqueue=_dlqueue, buffer=_buffer;

extern const NSString* FLICKR_API;
extern const NSString* FlickrAPIKey;
extern const NSString* FlickrSecret;

- (id)initWithFlickrDelegate:(id<FlickrPhotoFaverDelegate>) delegate {
	if ( self = [super init] ) {
		_delegate = delegate;
		self.dlqueue = [[NSMutableSet alloc] init];
	}
	
	return self;
}

- (void)favePhotos:(NSSet *)urls {
	NSLog(@"faving photos: %@", urls);
	
	totalNumberOfRequests +=  urls.count;
	
	for (FlickrPhoto *sp in urls ) {
		[self.dlqueue addObject:sp];
	}
	
	[self startNextRequest];
	
	[_delegate onDownloadStart:urls.count];
}

- (void)dealloc {
	self.dlqueue = nil;
	self.buffer = nil;
	[super dealloc];
}

- (void)startNextRequest {
	FlickrPhoto *next = [self.dlqueue anyObject];
	
	if ( next ) {
		
		NSString *method = @"flickr.favorites.add";
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];		
		NSString *token = [defaults objectForKey:@"token"];
		
		NSString *api_sig_str = [NSString stringWithFormat:@"%@api_key%@auth_token%@method%@photo_id%@", FlickrSecret, FlickrAPIKey, token, method, next.itemId]; 
		NSLog(@"api_Sig %@", api_sig_str);
		
		NSString *api_sig = [LoginViewController md5:api_sig_str];
		
		NSString *params = [NSString stringWithFormat:@"method=%@&photo_id=%@&api_key=%@&auth_token=%@&api_sig=%@", method, next.itemId, FlickrAPIKey, token, api_sig];
		
		NSString *urlString = [FLICKR_API stringByAppendingString:params];
		
		self.buffer = [[NSMutableData alloc] init];
		
		NSURL *url = [NSURL URLWithString:urlString];
		NSURLRequest *req = [NSURLRequest requestWithURL:url];
		
		[NSURLConnection connectionWithRequest:req delegate:self];
		
		NSLog(@"start download from url: %@", urlString);
		[self.dlqueue removeObject:next];			
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {	
	[self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"finished request");
	
	UIImage *img = [UIImage imageWithData:self.buffer];
	UIImageWriteToSavedPhotosAlbum( img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil );
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	NSLog(@"saved to phone with error: %@", error);
	int finished = totalNumberOfRequests - self.dlqueue.count;
	[_delegate onProgress:finished outOfTotal:totalNumberOfRequests];
	
	if ( self.dlqueue.count > 0 ) {
		[self startNextRequest];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"failed with error : %@", error);
	
	BOOL keepGoing = [_delegate onDownloadFailWithError:error];
	
	if ( keepGoing && (self.dlqueue.count > 0 ) ){
		[self startNextRequest];
	}
	
}


@end
