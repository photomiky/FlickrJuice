//
//  LoginViewController.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "ASIHTTPRequest.h"
#import "Consts.h"
#import "SBJSON.h"
#import "FlickrPhoto.h"
#import "ASIAsyncImageView.h"

const NSString* FlickrAPIKey = @"749d579517e11bafb606299f70a6fe18";
const NSString* FlickrSecret = @"72221c4e323bf274";
NSString* const  TOKEN = @"token";
NSString* const  USER = @"user";

const int kSlideShowImageCount = 20;
const int kNavigationBarHeight = 44;

extern const NSString* FLICKR_API;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LoginViewController
	

@synthesize webView = _webView, frob=_frob, data=_data, token=_token, loginButton=_loginButton;
@synthesize activityInd=_activityInd, currToken=_currToken, userName=_userName, userId=_userId;
@synthesize delegate;
@synthesize animationView1=_animationView1, animationView2=_animationView2;



-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        self.activityInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _allImageDownloads = [[NSMutableDictionary alloc] init];
        _slideShowImages = [[NSMutableSet alloc] initWithCapacity:kSlideShowImageCount];
        isAnimating = NO;
     
    }
    
    return self;
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseBody = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSDictionary *json = [responseBody JSONValue];
   // NSLog(@"Response dict is %@", json);
    NSDictionary *main = [json objectForKey:@"photos"];	

	NSDictionary *arrOfServerPhotos = [main objectForKey:@"photo"];
    NSNumber *idx = [NSNumber numberWithInt:0];
	for(NSDictionary *photo in arrOfServerPhotos){
        
		CGSize bigSize = CGSizeMake(500, 333);			
		FlickrPhoto *fphoto = [[FlickrPhoto alloc] initWithURL:[photo objectForKey:@"url_m"] smallURL:[photo objectForKey:@"url_t"] size:bigSize caption:[photo objectForKey:@"title"]];
		fphoto.farm = [photo objectForKey:@"farm"];
		fphoto.owner = [photo objectForKey:@"owner"];
		fphoto.server = [photo objectForKey:@"server"];
		fphoto.secret = [photo objectForKey:@"secret"];
		fphoto.itemId = [photo objectForKey:@"id"];
		fphoto.urlMedium = [photo objectForKey:@"url_m"];
        
       
        NSString *imgUrl_M = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_z.jpg", fphoto.farm, fphoto.server, fphoto.itemId, fphoto.secret];
        //NSLog(@"URL for image is %@", imgUrl_M);
        ASIAsyncImageView *asyncImageView = [_allImageDownloads objectForKey:idx];
        if(asyncImageView == nil)
        {
            asyncImageView = [[ASIAsyncImageView alloc] init];
            asyncImageView.delegate = self;
            asyncImageView.index = idx;
            [_allImageDownloads setObject:asyncImageView forKey:idx];
            [asyncImageView loadImageFromURL:imgUrl_M];
            [asyncImageView release];
        }
        
        idx = [NSNumber numberWithInt:([idx intValue] + 1)];
        
	}
   
}


- (void)appImageDidLoad:(NSNumber *) idx{
    
    
    ASIAsyncImageView *asyncImageView = [_allImageDownloads objectForKey:idx];
	
    if (asyncImageView != nil)
    {
        UIImage *image = [asyncImageView image];
        if(image)
            [_slideShowImages addObject:image];
        //NSLog(@"Downloaded image for animation number %d", [idx intValue]);
        if(!isAnimating){
            isAnimating = YES;
            [self fadeIn];
            NSLog(@"starting animation");
            // add button 
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"loginButton.png"] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 339, 300, 44);//CGRectMake(0, 0, 320, 380);
            [button addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Downloading of interesting images failed");
}


-(void) viewDidLoad {
	
	[super viewDidLoad];
//	UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"]; 
//	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease]; 
//    self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
	
    self.navigationController.navigationBarHidden = YES;
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.activityInd] autorelease];
    [self.activityInd setHidesWhenStopped:YES];
    
    NSLog(@"View did load");
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//NSString *token = [defaults objectForKey:TOKEN];
	
	//if(!token){
        
        UIImage *splashImage = [UIImage imageNamed:@"Default.png"];
        
        self.animationView1 = [[UIImageView alloc] initWithImage:splashImage];
        self.animationView1.frame = CGRectMake(0,-20, 320, 480);
        self.animationView2 = [[UIImageView alloc] init];
        [self.view addSubview:self.animationView2];
        [self.view addSubview:self.animationView1];
        
               
        [self startImagesDownload];
//	}	
	
}

-(void) startImagesDownload{
    
    isFirstFrame = YES;
    NSString *method = @"flickr.interestingness.getList";
    NSString *params = [NSString stringWithFormat:@"method=%@&page=1&per_page=%d&format=json&nojsoncallback=1&api_key=%@", method, kSlideShowImageCount, FlickrAPIKey];
    NSString *urlStr = [FLICKR_API stringByAppendingString:params];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setDelegate:self];
    [request startAsynchronous];

}

-(void) fadeIn{
    
    //NSLog(@"fading in");
    
    UIImage *currImage = [_slideShowImages anyObject];
    self.animationView2.image = currImage;
    [_slideShowImages removeObject:currImage];
    [self.animationView2 setFrame:[self calculateFrameFromImage:currImage]];
    [self.animationView2 setAlpha:0.0f];    
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    if(isFirstFrame){
        isFirstFrame = NO;
        [UIView setAnimationDuration:4.0f];
    }else{
        [UIView setAnimationDuration:8.0f];
    }
    [UIView setAnimationDidStopSelector:@selector(display:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.animationView1 setAlpha:0.0f];
    //[self.animationView2 setFrame:[self calculateFrameFromImage:self.animationView2.image isBig:YES]];
    [self.animationView2 setAlpha:1.0f];
    [UIView commitAnimations];
    
    
}

-(CGRect) calculateFrameFromImage:(UIImage *) image{
    
    int screenWidth = 320;
    int screenHeight = 480;
    
    if(image.size.width < screenWidth || image.size.height < screenHeight){
        return CGRectMake(0, 0, 320, 480); // fill screen
    }
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    int x = (screenWidth - imageWidth) / 2;
    int y = (screenHeight - imageHeight) / 2;
    
    return CGRectMake(x, y, imageWidth, imageHeight);    
}

-(void) display:(NSString *) animationId finished:(NSNumber *) finished context:(void *) context{
    
    //NSLog(@"now displaying");
    
    
    UIImage *image = [_slideShowImages anyObject];
    self.animationView1.image = image;
    [_slideShowImages removeObject:image];
   // [self.animationView1 setAlpha:0.0f];
    [self.animationView1 setFrame:[self calculateFrameFromImage:image]];
    


    [UIView beginAnimations:@"display" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:8.0f];

    [UIView setAnimationDidStopSelector:@selector(fadeIn)];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.animationView2 setAlpha:0.0f];
    //[self.animationView2 setFrame:[self calculateFrameFromImage:self.animationView1.image isBig:NO]];
    [self.animationView1 setAlpha:1.0f];
   // [self.animationView1 setFrame:[self calculateFrameFromImage:self.animationView2.image isBig:YES]];
    [UIView commitAnimations];
    
    
}

-(void) fadeOut:(NSString *) animationId finished:(NSNumber *) finished context:(void *) context{
    NSLog(@"now fade out");

    
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:6.0f];
    [UIView setAnimationDidStopSelector:@selector(fadeIn)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.animationView1 setAlpha:0.2f];
    [UIView commitAnimations];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
} 


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.webView = nil;
	self.loginButton = nil;
	self.activityInd = nil;
    //self.animationView1 = nil;
    //self.animationView2 = nil;
    //_slideShowImages = nil;
    //_allImageDownloads = nil;
}


- (void)dealloc {
	[self.webView release];
	[self.loginButton release];
	[self.activityInd release];
    [self.animationView1 release];
    [self.animationView2 release];
    [_slideShowImages release];
    [_allImageDownloads release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////
/// logout methods

-(BOOL) isLoggedIn{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"IS LOGGED IN RETURNED %d", ([defaults objectForKey:TOKEN] == nil));
    return ([defaults objectForKey:TOKEN] != nil);
    
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


- (void)loginClick:(id)sender {
	
    if([self isLoggedIn]){
        [self logoutClick:sender];
        return;
    }
    // stop downloading of images in background
    _allImageDownloads = nil;
    
	// start indicator

	self.activityInd.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin; 
	self.activityInd.center = CGPointMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds));
	[self.activityInd startAnimating];
    [self.view addSubview:self.activityInd];
	
	CGRect webFrame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	self.webView = [[UIWebView alloc] initWithFrame:webFrame];

	
	self.webView.delegate = self;
	NSString *api_sig_str = [NSString stringWithFormat:@"%@api_key%@permswrite", FlickrSecret, FlickrAPIKey];
	NSString *api_sig = [LoginViewController md5:api_sig_str];
	NSString *urlString = [NSString stringWithFormat:@"http://flickr.com/services/auth/?api_key=%@&perms=%@&api_sig=%@", FlickrAPIKey, 
						   @"write",  api_sig];
	NSLog(@"api_sig = %@", api_sig);
	NSLog(@"url = %@", urlString);
	NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:60.0];
	[self.webView loadRequest:req];
	
	
}

-(void) getTokenFromFrob{
	
	// http://flickr.com/services/rest/?method=flickr.auth.getToken&api_key=1234567890&frob=abcxyz&api_sig=3f3870be274f6c49b3e31a0c6728957f
	NSString *urlString = @"http://flickr.com/services/rest/?method=flickr.auth.getToken&api_key=%@&frob=%@&api_sig=%@";
	NSString *api_sig_str = [NSString stringWithFormat:@"%@api_key%@frob%@method%@", FlickrSecret, FlickrAPIKey, self.frob, @"flickr.auth.getToken"];
	NSString *api_sig = [LoginViewController md5:api_sig_str];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:urlString, FlickrAPIKey, self.frob, api_sig]];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser parse];
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}



// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser{
	currToken = @"";
}
// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser{
	NSLog(@"parser ended doc");
	[self storeToken];
}
// sent when the parser has completed parsing. If this is encountered, the parse was successful.

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	
	
	if([elementName isEqualToString:TOKEN]
	   ){
		currToken = TOKEN;
		[self setItemElementInProgress:YES];
	}else if([elementName isEqualToString:USER]){
		currToken = USER;
		self.userId = [attributeDict objectForKey:@"nsid"];
		self.userName = [attributeDict objectForKey:@"username"];
	}else {
		currToken = @"";
	}

	
}




// This method gets called for every character NSXMLParser finds.
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // If currentValue doesn't exist, initialize and allocate
    if (!self.token) {
		self.token = [[NSMutableString alloc] init];
    }
    
    // Append the current character value to the running string
    // that is being parsed
	if([currToken isEqualToString:TOKEN] && itemElementInProgress){
		[self.token appendString:string];
	}
}

// This method is called whenever NSXMLParser reaches the end of an element
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName{
	
	
	if ([elementName isEqualToString:TOKEN]) {
		[self setItemElementInProgress:NO];  // If we are currently on the "item" element, then do not save value
		NSLog(@"Token is %@", self.token);
	}
	
	//[self storeToken];
}	

-(void) storeToken{

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[defaults setObject:self.token forKey:TOKEN];
	[defaults setObject:self.userId forKey:USER];
	[defaults setObject:self.userName forKey:@"username"];
	[defaults synchronize];
	NSLog(@"Logged In as %@", self.userName);
	//[self.delegate loginViewControllerDidFinish:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"UserHasLoggedIn" object:self userInfo:nil];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)invalidateViewControllerAtUrl:(NSString *)url fromMap:(TTURLMap *)map{
	TTNavigator* navigator = [TTNavigator navigator];
	UIViewController *vc = [navigator viewControllerForURL:url];
	
	NSLog(@"invalidating model for: %@", vc);
	if ( [vc isKindOfClass:[TTModelViewController class]] ) {
		TTModelViewController * mvc = (TTModelViewController *)vc;
		[mvc invalidateView];
	}	
}

-(void) setItemElementInProgress:(BOOL) value{

	itemElementInProgress = value;
	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"should start load url=%@", [request.URL query]);
    [self.activityInd startAnimating];
	NSRange range = [[request.URL query] rangeOfString:@"frob"];
	if(range.location != NSNotFound){
		NSArray *arr = [[request.URL query] componentsSeparatedByString:@"?frob"];
		
		if([arr count] > 0){
			NSLog(@"Arr %@", arr);
			NSString *frob = [[arr objectAtIndex:0] substringFromIndex:5];
			if(frob != (NSString *)[NSNull null] && ![frob isEqualToString:@""]){
				self.frob = frob;	
				NSLog(@"Frob - %@", frob);
				[self getTokenFromFrob];
				return NO;
			}
		}
    }
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	NSLog(@"did start load");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSLog(@"did finish load");
	NSLog(@"%@", webView.request);
	[self.activityInd stopAnimating];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.activityInd] autorelease];
	[self.view addSubview:self.webView];
    self.navigationController.navigationBarHidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"did fail load with error: %@", error);
}


+ (NSString *) md5:(NSString *)str {
   const char *cStr = [str UTF8String];
   unsigned char result[16];
   CC_MD5( cStr, strlen(cStr), result );
   return [NSString stringWithFormat:
		   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
		   result[0], result[1], result[2], result[3], 
		   result[4], result[5], result[6], result[7],
		   result[8], result[9], result[10], result[11],
		   result[12], result[13], result[14], result[15]
		   ]; 
}

@end

