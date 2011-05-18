//
//  FlickrJuiceAppDelegate.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/21/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlickrFaver.h"
#import "FlickrUploader.h"
#import "LoginViewController.h"
#import "ImageManipulation.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FBConnect.h"
#import "UserFavoritesUpdater.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, FlickrPhotoFaverDelegate, FBSessionDelegate> {
	
	UserFavoritesUpdater *_favsUpdater;
	FlickrFaver *_flickrFaver; 
	FlickrUploader *_flickrUploader;
	UIProgressView *_favProgress;
	UIWindow *window;
	Facebook *_facebook;
}

@property (nonatomic, retain) UserFavoritesUpdater *favsUpdater;
@property (nonatomic, retain) FlickrFaver *flickrFaver;
@property (nonatomic, retain) FlickrUploader *flickrUploader;
@property (nonatomic, retain) UIProgressView *favProgress;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) Facebook *facebook;


-(void) fbConnect;
-(void) fbLogout;
-(BOOL) isFBLoggedIn;
-(void) registerAppForPushNotifications;
-(FlickrUploader *) flickrUploaderInstance;
@end


