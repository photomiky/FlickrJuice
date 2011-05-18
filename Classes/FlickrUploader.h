//
//  FlickrUploader.h
//  FlickrJuice2
//
//  Created by Michael Rabin on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveFlickr.h"
#import "FlickrFaver.h"
#import "LoginViewController.h"
#import "UploadImage.h"

@interface FlickrUploader : NSObject <OFFlickrAPIRequestDelegate>{

	NSMutableSet *_uploadQueue;
	int totalNumberOfRequests;
	OFFlickrAPIRequest *ofRequest;
	id<FlickrPhotoFaverDelegate> uploadDelegate;
	NSAutoreleasePool *_pool;
}

@property (nonatomic, retain) NSMutableSet *uploadQueue;
@property (nonatomic, retain) OFFlickrAPIRequest *ofRequest;
@property (nonatomic, assign) id<FlickrPhotoFaverDelegate> uploadDelegate;
@property (retain) NSData *uploadImageData;
@property (retain) NSDictionary *dict;
@property (nonatomic, retain) NSAutoreleasePool *pool;


-(void) uploadImage:(NSData *) imageData andDictionary:(NSDictionary *) dictionary;
-(void) startNextRequest;

@end

