//
//  FlickrCommentsViewController.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrCommentsViewController.h"
#import "FlickrCommentsDataSource.h"
#import "FlickrCommentsViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FlickrCommentsViewController

extern NSString* const  TOKEN;

///////////////////////////////////////////////////////////////////////////////////////////////////


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self){
		
		//self.title = @"Feed";
		self.hidesBottomBarWhenPushed = NO; 
	}
	return self;
}




-(void) viewDidLoad{
	
	[super viewDidLoad];
	
//	UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"]; 
//	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease]; 
	
	// sign up for login notification
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createModel) name:@"UserHasLoggedIn" object:nil];


    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds  
                                                   style:UITableViewStyleGrouped] autorelease];  
    //UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"]; 
//		self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image]; 
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
    self.variableHeightRows = YES;  
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];  
	
}


- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
	
	
	self.dataSource = [[[FlickrCommentsDataSource alloc]
						init] autorelease];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ( buttonIndex == 0 ) {
		//[self takePicture];
	} else if ( buttonIndex == 1 ) {
		[self selectPicture];
	} 
}

- (void)upload {

	UIActionSheet *sheet = [[UIActionSheet alloc] 
				 initWithTitle:@"Photo upload"
				 delegate:self 
				 cancelButtonTitle:@"Cancel" 
				 destructiveButtonTitle:nil 
				 otherButtonTitles:@"Take Photo", @"Upload from Library", nil];
	
	
	[sheet showInView:self.view];
}


-(void) selectPicture{

	//self.cameraController.sourceType = 2;
	//[self presentModalViewController:self.cameraController animated:YES];

	
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
} 



@end

