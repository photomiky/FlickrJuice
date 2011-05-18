//
//  FlickrPhoto.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserComment.h"

@interface FlickrPhoto : UserComment <TTPhoto> {
	
	
	id<TTPhotoSource> _photoSource;
	NSString* _thumbURL;
	NSString* _smallURL;
	NSString* _URL;
	CGSize _size;
	NSInteger _index;
	NSString* _caption;
	NSString *_object_id;
	NSArray *_tags;
	BOOL selected;
	NSString *_urlThumb;
	NSString *_urlMedium;
}

@property (nonatomic, retain) NSString *urlThumb;
@property (nonatomic, retain) NSString *urlMedium;
//@property (nonatomic, retain) NSString *URL;
//@property (nonatomic, retain) NSString *object_id;
//@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger index;

-(NSString *) getURLForSize:(NSString *) size;
- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size;

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size
		  caption:(NSString*)caption;
@end
