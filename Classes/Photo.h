//
//  FlickrPhoto.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Photo : NSObject <TTPhoto> {  
	id<TTPhotoSource> _photoSource;  
	NSString* _thumbURL;  
	NSString* _smallURL;  
	NSString* _URL;  
	CGSize _size;  
	NSInteger _index;  
	NSString* _caption;  
}  

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size;  

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size  
		  caption:(NSString*)caption;  

@end 