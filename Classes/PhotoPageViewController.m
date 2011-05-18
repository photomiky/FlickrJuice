//
//  PhotoPageViewController.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PhotoPageViewController.h"
#import "PhotoSource.h"
#import "FlickrPhoto.h"
#import "PhotoPageView.h"
#import "CommentsViewController.h"
#import "Photo.h"
#import "AppDelegate.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation PhotoPageViewController


@synthesize imgId=_imgId, secret=_secret, farm=_farm, server=_server, imgName=_imgName, owner=_owner;


static NSString *PHOTO_URL_PREFIX = @"http://farm%@.static.flickr.com/%@/%@_%@_%@.jpg";

-(id) initWithImageId:(NSString *) imgId andSecret:(NSString *)secret andFarm:(NSString *)farm andServer:(NSString *)server andOwner:(NSString *) owner andImageName:(NSString *)imgName{
	
	
	if(self = [super init]){
			
		self.imgId = imgId;
		self.secret = secret;
		self.farm = farm;
		self.server = server;
		self.imgName = imgName;
		self.owner = owner;
		isSinglePhoto = NO;
	}
	return self;
	
}

//- (TTPhotoView*)createPhotoView {
//	return [[[PhotoPageView alloc] initWithImageId:self.imgId andSecret:self.secret andFarm:self.farm andServer:self.server andImageName:self.imgName] autorelease];
//}


-(void) viewDidUnload{

	self.imgId = nil;
	self.secret = nil;
	self.farm = nil;
	self.server = nil;
	self.imgName = nil;
	self.owner = nil;
	[super viewDidUnload];
	
}

-(void) dealloc{

		
	[super dealloc];
}

- (void)loadView {
/*	[super loadView];
	
	
	[self configureCommentsButton];
 */
	[super loadView];

    

	UIButton *comment = [UIButton buttonWithType:UIButtonTypeCustom];
	comment.bounds = CGRectMake(0, 0, 24, 22);
	UIImage *dlimg = [UIImage imageNamed:@"chat.png"]; 
	[comment addTarget:self action:@selector(showCommentsView) forControlEvents:UIControlEventTouchUpInside];
	[comment setImage:dlimg forState:UIControlStateNormal];
	UIBarButtonItem* commentButton = [[[UIBarButtonItem alloc] initWithCustomView:comment] autorelease];	
	
	
	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	UIButton *fav = [UIButton buttonWithType:UIButtonTypeCustom];
	fav.bounds = CGRectMake(0,0,24,22);
	
	UIImage *favImg = [UIImage imageNamed:@"heart.png"];
	[fav addTarget:self action:@selector(favImage) forControlEvents:UIControlEventTouchUpInside];
	
	[fav setImage:favImg forState:UIControlStateNormal];
	
	UIBarButtonItem* favButton = [[[UIBarButtonItem alloc] initWithCustomView:fav] autorelease];
					
	UIButton *fb = [UIButton buttonWithType:UIButtonTypeCustom];
	fb.bounds = CGRectMake(0,0, 24,22);
	UIImage *fbImg = [UIImage imageNamed:@"facebook-icon-Gray.jpg"];
	[fb addTarget:self action:@selector(fbPostImage) forControlEvents:UIControlEventTouchUpInside];
	[fb setImage:fbImg forState:UIControlStateNormal];
	UIBarButtonItem *fbButton = [[[UIBarButtonItem alloc] initWithCustomView:fb] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showCommentsView)];
	_toolbar.autoresizingMask =
	UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	_toolbar.barStyle = UIBarStyleDefault;
	_toolbar.tintColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.5];
	_toolbar.translucent = YES;
	_toolbar.items = [NSArray arrayWithObjects:
					  commentButton, space, favButton, space, fbButton, nil];
	[self.view addSubview:_toolbar];
	[self configureCommentsButton];	
	isSinglePhoto = NO;
	
	if(self.photoSource == nil){
		
		NSLog(@"this is a photosource less");	
		isSinglePhoto = YES;
		 NSString *imgUrl_t = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_%@.jpg", self.farm, self.server, self.imgId, self.secret, @"t"];
		 //NSString *imgUrl_s = [NSString stringWithFormat:PHOTO_URL_PREFIX, self.farm, self.server, self.imgId, self.secret, @"s"];
		 NSString *imgUrl_m = [NSString stringWithFormat:PHOTO_URL_PREFIX, self.farm, self.server, self.imgId, self.secret, @"m"];
		 //NSString *imgUrl_l = [NSString stringWithFormat:PHOTO_URL_PREFIX, self.farm, self.server, self.imgId, self.secret, @"l"];
		 FlickrPhoto *photo = [[FlickrPhoto alloc] initWithURL:imgUrl_m smallURL:imgUrl_t size:CGSizeMake(320.0, 250.0)];
		//Photo *photo = [[Photo alloc] initWithURL:imgUrl_m smallURL:imgUrl_t size:CGSizeMake(320.0, 250.0)];
		self.photoSource = [[[PhotoSource alloc] initWithType:PhotoSourceNormal title:self.imgName photos:[NSArray arrayWithObjects:photo, nil] photos2:nil] autorelease];
		 
	}
	
}

- (void)didMoveToPhoto:(id<TTPhoto>)photo fromPhoto:(id<TTPhoto>)fromPhoto{
		
	
	AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	FlickrPhoto *flickrPhoto = (FlickrPhoto *)photo;
	BOOL isFaved = NO;
	if(!flickrPhoto.itemId){
		
		isFaved = [ad.favsUpdater isFavedImage:[self.owner stringByAppendingString:self.imgId]];
		
	}else {
		isFaved = [ad.favsUpdater isFavedImage:[flickrPhoto.owner stringByAppendingString:flickrPhoto.itemId]];
	}
	NSLog(@"is FAVED? %i", isFaved);
	if(isFaved){
	
		[self setFaveImage:[UIImage imageNamed:@"heart-icon.png"]];
		
	}else {
		[self setFaveImage:[UIImage imageNamed:@"heart.png"]];
	}
	
}



-(void) setFaveImage:(UIImage *) favImage{
	
	UIBarButtonItem *item = [_toolbar.items objectAtIndex:2];
	UIButton *btn = (UIButton *)item.customView;
	[btn setImage:favImage forState:UIControlStateNormal];
}

- (void)updateView{
    [super updateView];
    self.title = @"";
    
}

- (void)viewWillAppear:(BOOL)animated{
	
    
	AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	FlickrPhoto *flickrPhoto = (FlickrPhoto *)self.centerPhoto;
	BOOL isFaved = NO;
	if(!flickrPhoto.itemId){
		
		isFaved = [ad.favsUpdater isFavedImage:[self.owner stringByAppendingString:self.imgId]];
		
	}else {
		isFaved = [ad.favsUpdater isFavedImage:[flickrPhoto.owner stringByAppendingString:flickrPhoto.itemId]];
	}
	//NSLog(@"is FAVED? %i", isFaved);
	if(isFaved){
		
		[self setFaveImage:[UIImage imageNamed:@"heart-icon.png"]];
		
	}else {
		[self setFaveImage:[UIImage imageNamed:@"heart.png"]];
	}
	[super viewWillAppear:animated];
	
}

-(void) fbPostImage{
	
	AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	FlickrPhoto *centerPhoto = (FlickrPhoto *)self.centerPhoto;
	NSLog(@"Center Photo is of id and owner %@ %@", centerPhoto.itemId, centerPhoto.owner);
	NSString *link = nil;
	if(!centerPhoto.itemId){
				
		link = [NSString stringWithFormat:@"http://www.flickr.com/photos/%@/%@", self.owner, self.imgId];
		
	}else{
		link = [NSString stringWithFormat:@"http://www.flickr.com/photos/%@/%@", centerPhoto.owner , centerPhoto.itemId];
	}
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:link, nil] forKeys:[NSArray arrayWithObjects:@"link", nil]];
	[ad.facebook dialog:@"feed" andParams:params andDelegate:self];
	
	
}


- (void)configureCommentsButton {
	//if ( hasComments ) {
		NSString *imageName = @"comments-icon3.png";
		
		UIBarButtonItem *comments = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] 
																	  style:UIBarButtonItemStylePlain 
																	 target:self
																	 action:@selector(showCommentsPage)] autorelease];
		
		self.navigationItem.rightBarButtonItem = comments;
		
	/*} else {
		NSString *imageName = @"comments-icon4.png";
		UIBarButtonItem *comments = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] 
																	  style:UIBarButtonItemStylePlain 
																	 target:self
																	 action:@selector(addComment)] autorelease];
		
		self.navigationItem.rightBarButtonItem = comments;
		
	}*/
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
} 


- (void) favImage{
	
	FlickrPhoto *centerPhoto = (FlickrPhoto *)self.centerPhoto;
	FlickrPhoto *photo = [[FlickrPhoto alloc] init];
	
	if(!centerPhoto.itemId){
		
		photo.itemId = self.imgId;
		photo.owner = self.owner;
		
	}else{
		photo.itemId = centerPhoto.itemId;
		photo.owner = centerPhoto.owner;
	}
	
	[self setFaveImage:[UIImage imageNamed:@"heart-icon.png"]];
	
	AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableSet *photosToFave = [[NSMutableSet alloc] initWithCapacity:1];
	[photosToFave addObject:photo]; 
	[ad.flickrFaver favePhotos:photosToFave];
	NSLog(@"Attempting to fave image with owner %@ and id %@", photo.owner, photo.itemId);
	[ad.favsUpdater addFavedImageWithKey:[photo.owner stringByAppendingString:photo.itemId]];
	[photosToFave release];
	[photo release];
}

-(void) showCommentsView{
	
	NSLog(@"Show comments View");
	TTNavigator *navigator = [TTNavigator navigator];
	NSString *iid = nil;
	if(isSinglePhoto){
		iid = self.imgId;
	}else {
		FlickrPhoto *centerPhoto = (FlickrPhoto*)_centerPhoto;
		iid = centerPhoto.itemId;
	}

	
	[navigator openURLAction:[TTURLAction actionWithURLPath:[NSString stringWithFormat:@"ff://commentsView/%@", iid]]];													
}


////////////////////////////////////////////////////////////////////////////////
//// fb dialog delegate methods 
/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog{
		
	NSLog(@"Dialog did complete");
	
}





@end

