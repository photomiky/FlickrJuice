//
//  CameraController.h
//  CoffeeCard
//
//  Created by Michael Rabin on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CameraController.h"
#import "FlickrUploader.h"

@protocol UploadDelegate;

@interface CameraController : UIImagePickerController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {

	id<UploadDelegate> uploadDelegate;

}

@property(nonatomic, assign) id<UploadDelegate> uploadDelegate;

void UIImageWriteToSavedPhotosAlbum(UIImage *image, 
									id completionTarget, SEL completionSelector, void *contextInfo);


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo;

@end

@protocol UploadDelegate

-(void) handleUpload:(UIImage *) image withSource:(int) sourceType;

@end