//
//  PhotoPageView.m
//  FlickrJuice
//
//  Created by Michael Rabin on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoPageView.h"
#import "Photo.h"

@implementation PhotoPageView

static NSString *PHOTO_URL_PREFIX = @"http://farm%@.static.flickr.com/%@/%@_%@_%@.jpg";

@synthesize imgId=_imgId, secret=_secret, farm=_farm, server=_server, imgName=_imgName;


//- (BOOL)loadPreview:(BOOL)fromNetwork {
//	if (![self loadVersion:TTPhotoVersionLarge fromNetwork:fromNetwork]) {
//		if (![self loadVersion:TTPhotoVersionLarge fromNetwork:YES]) {
//			return NO;
//		}
//	}
//	
//	return YES;
//}

-(id) initWithImageId:(NSString *) imgId andSecret:(NSString *)secret andFarm:(NSString *)farm andServer:(NSString *)server andImageName:(NSString *)imgName{
	
	if(self = [super init]){
			
		self.imgId = imgId;
		self.secret = secret;
		self.farm = farm;
		self.server = server;
		self.imgName = imgName;

	}
	
	return self;
}


-(void) loadImage {
	
		
	[super loadImage];
	
	
}

- (void)setPhoto:(id<TTPhoto>)photo {
	NSString *imgUrl_t = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_%@.jpg", self.farm, self.server, self.imgId, self.secret, @"t"];
	//NSString *imgUrl_s = [NSString stringWithFormat:PHOTO_URL_PREFIX, self.farm, self.server, self.imgId, self.secret, @"s"];
	NSString *imgUrl_m = [NSString stringWithFormat:PHOTO_URL_PREFIX, self.farm, self.server, self.imgId, self.secret, @"m"];
	//NSString *imgUrl_l = [NSString stringWithFormat:PHOTO_URL_PREFIX, self.farm, self.server, self.imgId, self.secret, @"l"];
	Photo *photoNew = [[Photo alloc] initWithURL:imgUrl_m smallURL:imgUrl_t size:CGSizeMake(320.0, 250.0)];
	//self.photoSource = [[[PhotoSource alloc] initWithType:PhotoSourceNormal title:self.imgName photos:[NSArray arrayWithObjects:photo, nil] photos2:nil] autorelease];
	[super setPhoto:photoNew];
}






@end
