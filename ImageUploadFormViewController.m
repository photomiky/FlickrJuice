    //
//  ImageUploadFormViewController.m
//  FlickrJuice
//
//  Created by Michael Rabin on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageUploadFormViewController.h"
#import "AppDelegate.h"
#import "ImageHelpers.h"
#import "CameraController.h"


@implementation ImageUploadFormViewController

@synthesize titleTxt=_titleTxt, descTxt=_descTxt, tagsTxt=_tagsTxt;
@synthesize cameraController=_cameraController;
@synthesize selectPicBtn=_selectPicBtn, takePicBtn=_takePicBtn;
@synthesize theImage=_theImage;

-(id) init{

	if(self = [super init]){
		self.cameraController = [[CameraController alloc] init];
		[self.cameraController setUploadDelegate:self];
	}
	
	return self;
	
}

-(void) dealloc{

	[self.titleTxt release];
	[self.descTxt release];
	[self.tagsTxt release];
	[self.cameraController release];
	[super dealloc];
	
	
}

-(void) viewDidUnload{

	self.titleTxt = nil;
	self.descTxt = nil;
	self.tagsTxt = nil;
	[super viewDidUnload];
	
}

-(void) viewDidLoad{

	[super viewDidLoad];
	//[self.takePicBtn setBackgroundImage:[UIImage imageNamed:@"upload_camera_icon.png"] forState:UIControlStateNormal];
	// draw as if nav bar here
	UIGraphicsBeginImageContext(CGSizeMake(320,480));
	CGContextRef context = UIGraphicsGetCurrentContext();
	float red1 = 135.0;
	float green1 = 135.0;
	float blue1 = 135.0;
	
	float red2 = 63.0;
	float green2 = 63.0;
	float blue2 = 63.0;
	
    CGColorRef darkBlue = [UIColor colorWithRed:red1/255.0 green:green1/255.0 
										   blue:blue1/255.0 alpha:1.0].CGColor;
    CGColorRef lightBlue = [UIColor colorWithRed:red2/255.0 green:green2/255.0 
							
							
											blue:blue2/255.0 alpha:1.0].CGColor;
	drawLinearGradient(context, CGRectMake(0, 0, 320, 60), darkBlue, lightBlue);
	UIGraphicsEndImageContext();
}

- (void)viewWillAppear:(BOOL)flag {
	NSLog(@"view will appear - image uplaod screen");
    [super viewWillAppear:flag];
    
}

-(void) touchesBegan:(NSSet * )touches withEvent:(UIEvent * )event
{
	
	if(_titleTxt){
		if([_titleTxt canResignFirstResponder]) [_titleTxt resignFirstResponder];
	}
	if(_tagsTxt){
		if([_tagsTxt canResignFirstResponder]) [_tagsTxt resignFirstResponder];
	}
	if(_descTxt){
		if([_descTxt canResignFirstResponder]) [_descTxt resignFirstResponder];
	}
	[super touchesBegan:touches withEvent:event];
	
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField{
		
	[textField resignFirstResponder];
	return YES;
	
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
	
		
	if(textField == _titleTxt){
			
		[_descTxt becomeFirstResponder];
		
	}
	if(textField == _descTxt){
			
		[_tagsTxt becomeFirstResponder];
		
	}
	
	if(textField == _tagsTxt){
		
	
		[textField resignFirstResponder];
		
	}
	return YES;
	
}




-(IBAction) uploadImage{
	
	if(!self.theImage){
		
		return;
	}
	
	AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSData *imgData = UIImageJPEGRepresentation(self.theImage, 0.5f);
	//UIImageJPEGRepresentation(self.image, 1.0f);
	BOOL useSignature = YES;
	NSNumber *pUseSignature = [NSNumber numberWithInt:1];
	if ( YES ) {
		useSignature = [pUseSignature boolValue];
	}
	
	NSLog(@"signature=%d", useSignature);
	NSString *descText = useSignature ? [_descTxt.text stringByAppendingFormat:@"\n\nSent using FlickrJuice iPhone App http://itunes.apple.com/us/app/flickrjuice/id424477518?mt=8"] : _descTxt.text;
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"is_public", self.titleTxt.text, @"title",
						  descText, @"description", self.tagsTxt.text, @"tags", nil];
	
	[[ad flickrUploaderInstance] uploadImage:imgData andDictionary:dict];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) cancel{
	
	[self dismissModalViewControllerAnimated:YES];
	
}


-(IBAction) showCamera{
	NSLog(@"show camera");

	
	
	if ( ! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || 
		![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		[self displayNotCapableError];
		return;
	}

	self.cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:self.cameraController animated:YES];

}

-(IBAction) choosePicture{
		
	self.cameraController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:self.cameraController animated:YES];
	
	
}

- (void)displayNotCapableError {
	UIAlertView *err = [[UIAlertView alloc] 
						initWithTitle:@"error" 
						message:@"Sorry, Camera not supported on your device" 
						delegate:nil
						cancelButtonTitle:@"Dismiss" 
						otherButtonTitles:nil];
	[err show];
	[err release];
}


// handle upload to flickr code here. use Appdelegate. 
-(void) handleUpload:(UIImage *) image withSource:(int) sourceType{
	
	
	if(sourceType == UIImagePickerControllerSourceTypeCamera){
		
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil );
			
	}
	
	// set image to small thumb
	self.theImage = image;
	NSLog(@"Image is now %@", self.theImage);
	image = [image scaleToSize:CGSizeMake(65, 65)];
	UIImage *newImg = [[UIImage alloc] initWithData:UIImagePNGRepresentation(image)];
	if(self.takePicBtn.selected){
		[self.takePicBtn setBackgroundImage:newImg forState:UIControlStateSelected];
	}else {
		[self.takePicBtn setBackgroundImage:newImg forState:UIControlStateNormal];
		
	}
}




@end





