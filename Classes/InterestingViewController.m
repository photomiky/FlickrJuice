//
//  InterestingViewController.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InterestingViewController.h"
#import "SPPhotoSource.h"
#import "FlickrPhoto.h"
#import "PhotoPageViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation InterestingViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
		
		//self.title = @"Interesting";
		isInteresting = YES;
		UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"]; 
		[image drawInRect:CGRectMake(0,0, image.size.width, image.size.height)];

	}
	return self;
}


-(void) loadView{

	
	[super loadView];
	UIButton *fav = [UIButton buttonWithType:UIButtonTypeCustom];
	fav.bounds = CGRectMake(0, 0, 35, 35);
	UIImage *dlimg = [UIImage imageNamed:@"fav_btn.png"]; 
	[fav addTarget:self action:@selector(showDownloadOptions) forControlEvents:UIControlEventTouchUpInside];
	[fav setImage:dlimg forState:UIControlStateNormal];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:fav];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	SPPhotoSource *alPhotoSource = [[[SPPhotoSource alloc] init] autorelease];
	self.photoSource = alPhotoSource;
}

//-(void) createModel{
//	
//	SPPhotoSource *alPhotoSource = [[[SPPhotoSource alloc] init] autorelease];
//	self.photoSource = alPhotoSource;
//		
//	
//}

@end

