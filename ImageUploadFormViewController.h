//
//  ImageUploadFormViewController.h
//  FlickrJuice
//
//  Created by Michael Rabin on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrUploader.h"
#import "CameraController.h"
#import "FlickrUploader.h"

@interface ImageUploadFormViewController : UIViewController <UITextFieldDelegate, UploadDelegate> {

	UIImage *_theImage;
	UITextField *_titleTxt;
	UITextField *_descTxt;
	UITextField *_tagsTxt;
	UIButton *_takePicBtn;
	UIButton *_selectPicBtn;
	BOOL isNewPIc;
	CameraController *_cameraController;
}

@property (nonatomic, retain) UIImage *theImage;
@property (nonatomic, retain) IBOutlet UITextField  *titleTxt;
@property (nonatomic, retain) IBOutlet UITextField  *descTxt;
@property (nonatomic, retain) IBOutlet UITextField  *tagsTxt;
@property (nonatomic, retain) CameraController *cameraController;
@property (nonatomic, retain) IBOutlet UIButton *takePicBtn;
@property (nonatomic, retain) IBOutlet UIButton *selectPicBtn;
-(IBAction) uploadImage;
-(IBAction) cancel;
-(IBAction) choosePicture;
-(IBAction) showCamera;
- (void)displayNotCapableError;
@end
