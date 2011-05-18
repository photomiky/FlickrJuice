//
//  FavoritePhotosViewController.m
//  FlickrJuice
//
//  Created by Michael Rabin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoritePhotosViewController.h"


@implementation FavoritePhotosViewController


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
		
		self.title = @"Interesting";
		self.hidesBottomBarWhenPushed = NO; 
		isInteresting = YES;
		
	}
	return self;
}


-(void) viewDidLoad{

	[super viewDidLoad];
//	UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"]; 
//	[image drawInRect:CGRectMake(0,0, 320, image.size.height)];
	
	
}
@end
