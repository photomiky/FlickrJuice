//
//  LoginViewController.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ASIAsyncImageView.h"
#import "LoginViewController.h"
#import "UIImageAnimationView.h"


extern NSString * const TOKEN;

@protocol LoginViewControllerDelegate;

@interface LoginViewController : UIViewController <UIWebViewDelegate, NSXMLParserDelegate, IconDownloaderDelegate, UIActionSheetDelegate>{
	
    UIImageView *_animationView2;
    UIImageView *_animationView1;
    UIActivityIndicatorView *_activityInd;
	IBOutlet UIWebView *_webView;
    UIButton *_loginButton;
	NSString *_frob;
	NSMutableString *_token;
	NSMutableString *_userName;
	NSMutableString *_userId;
	NSMutableData *_data;
	BOOL itemElementInProgress;
	NSString *currToken;
	id<LoginViewControllerDelegate> delegate;
    NSMutableDictionary *_allImageDownloads;
    NSMutableSet *_slideShowImages;
    int globalAnimationCounter;
    BOOL isAnimating;
    BOOL isFirstFrame;
}

@property (nonatomic, retain) UIImageView *animationView1;
@property (nonatomic, retain) UIImageView *animationView2;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIActivityIndicatorView *activityInd;
@property (nonatomic, retain) NSString *frob;
@property (nonatomic, retain) NSMutableString *token;
@property (nonatomic, retain) NSMutableString *userName;
@property (nonatomic, retain) NSMutableString *userId;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSString *currToken;
@property (nonatomic, assign) id<LoginViewControllerDelegate> delegate;

+ (NSString *) md5:(NSString *)str;
-(BOOL) isLoggedIn;
-(void) getTokenFromFrob;
-(void) setItemElementInProgress:(BOOL) value;
-(void) storeToken;
- (void)loginClick:(id)sender;

- (void)logoutClick:(id)sender;
- (void)logout;

- (void)invalidateViewControllerAtUrl:(NSString *)url fromMap:(TTURLMap *)map;

-(void) fadeIn;
-(void) startImagesDownload;
-(void) fadeOut:(NSString *) animationId finished:(NSNumber *) finished context:(void *) context;
-(void) display:(NSString *) animationId finished:(NSNumber *) finished context:(void *) context;
-(CGRect) calculateFrameFromImage:(UIImage *) image;
@end

@protocol LoginViewControllerDelegate

-(void) loginViewControllerDidFinish:(LoginViewController *)loginViewController;

@end

