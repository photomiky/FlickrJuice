//
//  FlickrFaver.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FlickrPhotoFaverDelegate;

@interface FlickrFaver : NSObject {
	NSMutableSet *_dlqueue;	
	id<FlickrPhotoFaverDelegate> _delegate;
	NSMutableData *_buffer;
	int totalNumberOfRequests;
}

@property (nonatomic, retain) NSMutableSet *dlqueue;
@property (nonatomic, retain) NSMutableData *buffer;

- (id)initWithFlickrDelegate:(id<FlickrPhotoFaverDelegate>) delegate;

- (void)dealloc;
- (void)startNextRequest;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

- (void)favePhotos:(NSSet *)urls;

@end

@protocol FlickrPhotoFaverDelegate 

- (void)onProgress:(int)completed outOfTotal:(int)total;
- (BOOL)onDownloadFailWithError:(NSError *)error;
- (void)onDownloadStart:(int)total;

@end
