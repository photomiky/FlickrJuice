//
//  FlickrPhoto.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhoto.h"


@implementation FlickrPhoto

static  NSString* FLICKR_PHOTO_PREFIX = @"http://farm%@.static.flickr.com/%@/%@_%@_%@.jpg";
@synthesize photoSource = _photoSource, size = _size, index = _index, caption = _caption;
@synthesize urlThumb=_urlThumb, urlMedium=_urlMedium, selected;


- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size {
	return [self initWithURL:URL smallURL:smallURL size:size caption:nil];
}

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size
		  caption:(NSString*)caption {
	if (self = [super init]) {
		_photoSource = nil;
		_URL = [URL copy];
		_smallURL = [smallURL copy];
		_thumbURL = [smallURL copy];
		_size = size;
		_caption = [caption copy];
		_index = NSIntegerMax;
		
		_tags = nil;
		self.selected = NO;
	}
	return self;
}



- (NSString*)URLForVersion:(TTPhotoVersion)version {
	if (version == TTPhotoVersionLarge) {
		//NSLog(@"URL For photo is %@", _URL);
		return _URL; // [self getURLForSize:@"l"];
	} else if (version == TTPhotoVersionMedium) {
		return _urlMedium;
	} else if (version == TTPhotoVersionSmall) {
		return _smallURL;
	} else if (version == TTPhotoVersionThumbnail) {
		return _thumbURL;
	} else {
		NSLog(@"returning nil");
		return nil;
	}
}

-(NSString *) getURLForSize:(NSString *) strSize{
	
	return [NSString stringWithFormat:FLICKR_PHOTO_PREFIX, _farm, _server, _itemId, _secret, strSize];
	
}

@end
