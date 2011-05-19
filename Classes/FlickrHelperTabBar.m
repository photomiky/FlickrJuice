//
//  FlickrHelperTabBar.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrHelperTabBar.h"
#import <Three20/Three20.h>
#import <Three20UI/UITabBarControllerAdditions.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserPhotosViewController.h"


@implementation FlickrHelperTabBar

- (void)viewDidLoad {
		
	[super viewDidLoad];
	[self setUpTabs];
	
		
}

/*- (void) viewDidAppear:(BOOL)animated{

	AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	if([ad isLoggedIn]){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSString *userName = [defaults objectForKey:@"username"];
		NSString *userId = [defaults objectForKey:@"user"];
		NSString *userNameEscaped = [userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSLog(@"username is %@ and id is %@", userNameEscaped, userId);
		NSArray *tabs = [self viewControllers];
		UserPhotosViewController *userPhotosVC = (UserPhotosViewController *)[tabs objectAtIndex:2];
		[userPhotosVC retain];
		[userPhotosVC reloadWithUserId:userId andUserName:userName];
		
	}
	
	
	
}
*/
-(void) setUpTabs{
	NSLog(@"creating tabs");
	
	// get username and userId from user defaults
	[self setTabURLs:[NSArray arrayWithObjects:
					  @"ff://commentsView",
					  @"ff://contactsView",
					  //  @"ff://mailbox",
					  @"ff://interestingView",
					  @"ff://usersPhotosThumbs", 
					  @"ff://logout",
					  nil]];	
	
	[self updateTabsInfo];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTabsInfo) name:@"UserHasLoggedIn" object:nil];	
}

-(void) updateTabsInfo{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *userName = [defaults objectForKey:@"username"];

	NSArray *tabs =  [self viewControllers];
	UIViewController *feed = [tabs objectAtIndex:0];
	feed.tabBarItem.image = [UIImage imageNamed:@"house.png"];
	feed.tabBarItem.title = @"Feed";
	//feed.tabBarItem.title = @"Feed";
	
	//	UIViewController *mailbox = [tabs objectAtIndex:1];
	
	//	mailbox.tabBarItem.image = [UIImage imageNamed:@"envelope.png"];
	//	mailbox.tabBarItem.title = @"Messages";

	UIViewController *contacts = [tabs objectAtIndex:1];
	
	contacts.tabBarItem.image = [UIImage imageNamed:@"group.png"];
	contacts.tabBarItem.title = @"Contacts";
	
	
	UIViewController *interesting = [tabs objectAtIndex:2];
	
	interesting.tabBarItem.image = [UIImage imageNamed:@"heart.png"];
	interesting.tabBarItem.title = @"Interesting";
	
	
	UIViewController *user = [tabs objectAtIndex:3];
	
	user.tabBarItem.image = [UIImage imageNamed:@"user.png"];
	user.tabBarItem.title = userName;
	
	
	UIViewController *logout = [tabs objectAtIndex:4];
	
	logout.tabBarItem.image = [UIImage imageNamed:@"pencil.png"];
	logout.tabBarItem.title = @"Settings";
	
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation) interfaceOrientation
{
    return  [self.selectedViewController
			 shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end

