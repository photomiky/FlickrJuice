//
//  PhotoPageView.h
//  FlickrJuice
//
//  Created by Michael Rabin on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhotoPageView : TTPhotoView {
	
	NSString *_imgId;	
	NSString *_secret;	
	NSString *_farm;
	NSString *_server;
	NSString *_imgName;
	
}

@property (nonatomic, retain) NSString *imgId;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *farm;
@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *imgName;



-(id) initWithImageId:(NSString *) imgId andSecret:(NSString *)secret andFarm:(NSString *)farm andServer:(NSString *)server andImageName:(NSString *)imgName;

@end
