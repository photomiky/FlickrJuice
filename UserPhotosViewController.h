//
//  UserPhotosViewController.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhoto.h"
#import "ImageUploadFormViewController.h"


@interface UserPhotosViewController : TTThumbsViewController <UIActionSheetDelegate, TTThumbsViewControllerDelegate>{

	NSMutableSet *_selection;
	NSMutableSet *_overlays;
	BOOL isInteresting;
	BOOL isDifferentUser;
	NSString* _userName;
	NSString* _userId;
	NSTimer *_timer;
}

@property (nonatomic, retain) NSMutableSet *selection;
@property (nonatomic, retain) NSMutableSet *overlays;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, assign) NSTimer *timer;

- (id) initWithUserId:(NSString *) uid andUserName:(NSString *) userName;
- (void)selectPhotos;
- (void)doneSelect;
-(void) takePicture;
-(void) refresh;
@end

@interface TTThumbsTableViewCell (selectable)

- (UIView *)thumbViewAtIndex:(int)index;
- (void)updateOverlayForPhoto:(FlickrPhoto *)photo;
- (void)assignPhotoAtIndex:(int)photoIndex toView:(TTThumbView*)thumbView;
@end