//
//  PhotoPageViewController.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface PhotoPageViewController : TTPhotoViewController <FBDialogDelegate> {
	
	
	BOOL isSinglePhoto;
	NSString *_imgId;	
	NSString *_secret;	
	NSString *_farm;
	NSString *_server;
	NSString *_imgName;
	NSString *_owner;
}


@property (nonatomic, retain) NSString *imgId;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *farm;
@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *imgName;
@property (nonatomic, retain) NSString *owner;



-(id) initWithImageId:(NSString *) imgId andSecret:(NSString *)secret andFarm:(NSString *)farm andServer:(NSString *)server andOwner:(NSString *) owner andImageName:(NSString *)imgName;
-(void) showCommentsView;
- (void)configureCommentsButton;
- (void) favImage;
-(void) fbPostImage;
-(void) setFaveImage:(UIImage *) favImage;
@end
