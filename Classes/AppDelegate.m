//
//  BirthdayCheckerAppDelegate.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "FlickrHelperTabBar.h"
#import "FlickrCommentsViewController.h"
#import "InterestingViewController.h"
#import "PhotoPageViewController.h"
#import "ProfileViewController.h"
#import "UserPhotosViewController.h"
#import "StyleSheet.h"
#import "FlickrFaver.h"
#import "MailboxViewController.h"
#import "LogoutViewController.h"
#import "CommentsViewController.h"
#import "AddCommentViewController.h"
#import "FavoritePhotosViewController.h"
#import "ContactsViewController.h"
#import "UserPhotosThumbsViewController.h"
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate
NSString* const kFacebookAppId = @"159124404149011";
NSString* const kFBToken = @"fbtoken";


@synthesize flickrFaver=_flickrFaver, flickrUploader=_flickrUploader, favProgress=_favProgress, favsUpdater=_favsUpdater;
@synthesize window;
@synthesize facebook=_facebook;




///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *token = [defaults objectForKey:TOKEN];
	NSLog(@"Found token %@", token);
	//NSLog(@"launch options is %@", launchOptions);
	_flickrFaver = [[FlickrFaver alloc] initWithFlickrDelegate:self];
	
	_facebook = [[Facebook alloc] initWithAppId:kFacebookAppId];
	
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.window = window;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	[TTStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];
	TTURLMap* map = navigator.URLMap;
	
	[map from:@"ff://login" toModalViewController:[LoginViewController class] transition:UIViewAnimationTransitionFlipFromLeft];
	[map from:@"ff://commentsView" toViewController:[FlickrCommentsViewController class]];
	[map from:@"ff://usersPhotosThumbs" toViewController:[UserPhotosViewController class]];
	[map from:@"ff://usersPhotosThumbs/(initWithUserId:)/(andUserName:)" toViewController:[UserPhotosViewController class]];
	[map from:@"ff://profileView/(initWithUserId:)" toViewController:[ProfileViewController class]];
	[map from:@"ff://interestingView" toViewController:[InterestingViewController class]];
	[map from:@"ff://tabBar" toViewController:[FlickrHelperTabBar class]];
	[map from:@"ff://photopage/(initWithImageId:)/(andSecret:)/(andFarm:)/(andServer:)/(andOwner:)/(andImageName:)" toViewController:[PhotoPageViewController class]];
	[map from:@"ff://mailbox" toViewController:[MailboxViewController class]];
	[map from:@"ff://logout" toViewController:[LogoutViewController class]];
	[map from:@"ff://commentsView/(initWithPhotoId:)" toViewController:[CommentsViewController class]];
	[map from:@"ff://addCommentView/(initWithPhotoId:)" toViewController:[AddCommentViewController class]];
	[map from:@"ff://contactsView" toViewController:[ContactsViewController class]];
	
	
	
	[navigator openURLAction:[TTURLAction actionWithURLPath:@"ff://tabBar"]];
	// keep this alive at all times	
	[[map objectForURL:@"ff://tabBar"] retain]; 
	
	application.applicationIconBadgeNumber = 0;
	if(!token){
		NSLog(@"Need to show login view");
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"ff://login"]];
		// download users's favorites so you have them in memory
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerAppForPushNotifications) name:@"UserHasLoggedIn" object:nil];
        
	}else{
	
        _favsUpdater = [[UserFavoritesUpdater alloc] init];
        [_favsUpdater downloadUserFaves];
    }
	return YES;
}

-(FlickrUploader *) flickrUploaderInstance{
	
		
	if(!self.flickrUploader){
			
		self.flickrUploader = [[FlickrUploader alloc] init];
		self.flickrUploader.uploadDelegate = self;
	}
	
	return self.flickrUploader;
}


-(void) registerAppForPushNotifications{
	
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	// download users's favorites so you have them in memory
	_favsUpdater = [[UserFavoritesUpdater alloc] init];
	[_favsUpdater downloadUserFaves];
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];
	
}

-(void) dealloc{
	
	[window release];
	[FlickrHelperTabBar release];
	//[_flickrUploader release];
	[_flickrFaver release];
	[_favProgress release];
	[super dealloc];
	
	
	
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSLog(@"Device registered with token %@", [devToken description]);
#if !TARGET_IPHONE_SIMULATOR
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    // Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
    NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    // Set the defaults to disabled unless we find otherwise...
    NSString *pushBadge = @"disabled";
    NSString *pushAlert = @"disabled";
    NSString *pushSound = @"disabled";
    // Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
    // one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
    // single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
    // true if those two notifications are on.  This is why the code is written this way
    if(rntypes == UIRemoteNotificationTypeBadge){
        pushBadge = @"enabled";
    }
    else if(rntypes == UIRemoteNotificationTypeAlert){
        pushAlert = @"enabled";
    }
    else if(rntypes == UIRemoteNotificationTypeSound){
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)){
        pushBadge = @"enabled";
        pushAlert = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)){
        pushBadge = @"enabled";
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
        pushBadge = @"enabled";
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
	NSString *deviceUuid = dev.uniqueIdentifier;
    NSString *deviceName = dev.name;
	NSString *deviceModel = dev.model;
	NSString *deviceSystemVersion = dev.systemVersion;
	
	// Prepare the Device Token for Registration (remove spaces and < >)
	NSString *deviceToken = [[[[devToken description] 
							   stringByReplacingOccurrencesOfString:@"<"withString:@""] 
							  stringByReplacingOccurrencesOfString:@">" withString:@""] 
							 stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	// Build URL String for Registration
	// !!! CHANGE "www.mywebsite.com" TO YOUR WEBSITE. Leave out the http://
	// !!! SAMPLE: "secure.awesomeapp.com"
	NSString *host = @"www.photomiky.com/flickrjuice";
	
	// !!! CHANGE "/apns.php?" TO THE PATH TO WHERE apns.php IS INSTALLED 
	// !!! ( MUST START WITH / AND END WITH ? ). 
	// !!! SAMPLE: "/path/to/apns.php?"
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *urlString = [NSString stringWithFormat:@"/apns.php?task=%@&appname=%@&appversion=%@&deviceuid=%@&devicetoken=%@&devicename=%@&devicemodel=%@&deviceversion=%@&pushbadge=%@&pushalert=%@&pushsound=%@&ftoken=%@", @"register", appName,appVersion, deviceUuid, deviceToken, deviceName, deviceModel, deviceSystemVersion, pushBadge, pushAlert, pushSound, 
						   [prefs objectForKey:@"token"]];
	
	// Register the Device Data
	// !!! CHANGE "http" TO "https" IF YOU ARE USING HTTPS PROTOCOL
	NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSLog(@"Register URL: %@", url);
	NSLog(@"Return Data: %@", returnData);
	
#endif
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
#if !TARGET_IPHONE_SIMULATOR
	
	NSLog(@"Error in registration. Error: %@", err);
	
#endif
}

/**
 * Remote Notification Received while application was open.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
#if !TARGET_IPHONE_SIMULATOR
    
	NSLog(@"remote notification: %@",[userInfo description]);
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
	
	NSString *alert = [apsInfo objectForKey:@"alert"];
	NSLog(@"Received Push Alert: %@", alert);
	
	NSString *sound = [apsInfo objectForKey:@"sound"];
	NSLog(@"Received Push Sound: %@", sound);
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	
	NSString *badge = [apsInfo objectForKey:@"badge"];
	NSLog(@"Received Push Badge: %@", badge);
	
//	NSString *contentsInfo = [apsInfo objectForKey:@"contTag"];
//	
//	UIApplicationState state = [application applicationState];
//	if (state == UIApplicationStateActive){
//		NSLog(@" It is in active state");
//		application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
//		NSLog(@"Alert message: %@",[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
//		UITabBarController *tabbar = (UITabBarController *)[[TTNavigator navigator] viewControllerForURL:@"ff://tabbar"];
//		UITabBarItem *item = (UITabBarItem *)[[tabbar viewControllers] objectAtIndex:0];
//		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//		NSNumber *oldNumber = [formatter numberFromString:item.badgeValue];
//		oldNumber++;
//		item.badgeValue = [NSString stringWithFormat:@"%d", [oldNumber intValue]];
//		[formatter release];
//	}
//	else {
//		
//		if ([contentsInfo length] > 0 ) {
//			// Do whatever u want for push notification handle
//			NSLog(@"Alert message: %@",[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
//		}
//
//	}
		
	
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
	return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	
	NSLog(@"URL is %@", [URL description]);
	NSString *urlStr = [URL absoluteString];
	if([urlStr hasPrefix:@"fb"]){
	
		return [_facebook handleOpenURL:URL];
	}else {
		[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
		return YES;
	}

}

- (void)onProgress:(int)completed outOfTotal:(int)total {
	NSLog(@"download complete %d/%d", completed, total);
	if ( completed < total ) {
		float progress = (float) completed / total;
		NSLog(@"setting progress: %g", progress);
		self.favProgress.progress = progress;
	} else {
		[self.favProgress removeFromSuperview];
		[self.favProgress release];
		self.favProgress = nil;
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
}

- (BOOL)onDownloadFailWithError:(NSError *)error {
	NSLog(@"download failed: %@", error);
	
	[self.favProgress removeFromSuperview];
	[self.favProgress release];
	self.favProgress = nil;
	
	return NO;
}

- (void)onDownloadStart:(int)total {
	if (! self.favProgress ) {
		NSLog(@"start download of %d items", total);
		self.favProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		self.favProgress.frame = CGRectMake( 0, TTScreenBounds().size.height - 75, TTScreenBounds().size.width, 10);
		self.favProgress.progress = 0.0;
		[self.favProgress setHidden:NO];
		TTNavigator* navigator = [TTNavigator navigator];	
		NSLog(@"%@", [navigator.visibleViewController class]);
		[navigator.visibleViewController.view addSubview:self.favProgress];		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
}



/////////////////////////////////////////////////////////////////////////////////
///////// fb connect

-(void) fbConnect{
	
	[_facebook authorize:nil delegate:self];
	
}

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin{

	NSLog(@"FB DID LOGIN");
	
	
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled{
	
		
	NSLog(@"FB DID NOT LOGIN");
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout{

	NSLog(@"FB DID LOGOUT");
	
}

-(void) fbLogout{

	[_facebook logout:self];
		
}

-(BOOL) isFBLoggedIn{
	
	return [_facebook isSessionValid];
	
}


@end


@implementation UINavigationBar (UINavigationBarCategory) 
- (void)drawRect:(CGRect)rect { 
	
	//float red1 = 16.0;
//	float green1 = 26.0;
//	float blue1 = 81.0;
//	
//	float red2 = 117.0;
//	float green2 = 134.0;
//	float blue2 = 187.0;
	
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
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect paperRect = self.bounds;
	
	drawLinearGradient(context, paperRect, lightBlue, darkBlue);
	
    UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"]; 
    [image drawInRect:CGRectMake((320 - image.size.width)/2,0,image.size.width, image.size.height)];
//    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease]; 
 //   self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];

    return;
}
@end


