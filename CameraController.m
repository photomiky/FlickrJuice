//
//  CameraController.m
//  CoffeeCard
//
//  Created by Michael Rabin on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraController.h"
#import "AppDelegate.h"

#define SOURCETYPE UIImagePickerControllerSourceTypeCamera 
#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation CameraController

@synthesize uploadDelegate;

NSString *kNumCoffees = @"kNumCoffees";

- (id)init {
	if (!(self = [super init])) return self;
	
	/*if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE]) 
		self.sourceType = SOURCETYPE;*/
		
	self.delegate = self; 
	return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	
	NSLog(@"Image captured with info %@", info);
	[self.uploadDelegate handleUpload:[info objectForKey:UIImagePickerControllerOriginalImage] withSource:picker.sourceType];
	[self dismissModalViewControllerAnimated:YES];
	
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
	
	NSLog(@"Image captured %@", image);

	[self.uploadDelegate handleUpload:image withSource:picker.sourceType];
	[self dismissModalViewControllerAnimated:YES];
	
}




- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
		// Show error message...
		
    }
    else  // No errors
    {
		// Show message image successfully saved
		NSLog(@"Image saved to camera roll successfully");
	
		
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	[picker release];
}

@end
