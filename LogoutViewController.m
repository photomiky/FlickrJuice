//
//  LogoutViewController.m
//  FlickrJuice
//
//  Created by Michael Rabin on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogoutViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@implementation LogoutViewController

@synthesize logoutBtn=_logoutBtn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		//self.title=@"Settings";
//		UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"]; 
//		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease]; 
		
    }
    return self;
}

- (void)logoutClick:(id)sender{
	
	NSLog(@"request logout");
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to logout ?" 
														delegate:self 
											   cancelButtonTitle:@"Cancel" 
										  destructiveButtonTitle:@"Yes. Log me out"
											   otherButtonTitles:nil];
	
	[action showInView:self.tabBarController.view];
	[action release];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
} 


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self logout];
	} 
}

- (void) logout {
	
	NSLog(@"Log out user");
	// invalidate stuff
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// remove from defaults
	
	
	
	[defaults removeObjectForKey:TOKEN];
	[defaults removeObjectForKey:@"username"];
	[defaults removeObjectForKey:@"user"];
	[defaults synchronize];
	
	
	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in [[cookieStorage.cookies copy] autorelease]) {
        [cookieStorage deleteCookie:each];
    }
	
	TTNavigator* navigator = [TTNavigator navigator];
	[navigator openURLAction:[TTURLAction actionWithURLPath:@"ff://login"]];
	
}





@end
