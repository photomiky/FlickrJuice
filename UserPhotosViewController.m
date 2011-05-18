//
//  UserPhotosViewController.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserPhotosViewController.h"
#import "UserPhotosModel.h"
#import "AppDelegate.h"
#import "SPPhotoSource.h"
#import "PhotoPageViewController.h"

#import <Three20UI/UIViewAdditions.h>
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UserPhotosViewController

const int OVERLAY_TAG=99;

@synthesize userId=_userId, userName=_userName, selection=_selection, overlays=_overlays; 
@synthesize timer=_timer;

- (id) initWithUserId:(NSString *) uid andUserName:(NSString *) userName{
	self = [super init];
	if(self){
	
		self.userId = uid;
		self.userName = userName;
		isDifferentUser = YES;
		

	}
	
	return self;
	
	
}


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self){
	
		self.hidesBottomBarWhenPushed = NO; 
	}
	return self;
}



-(void) loadView{
	[super loadView];
//	UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"]; 
//	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease]; 
	self.wantsFullScreenLayout = NO; 
	
	UIButton *fav = [UIButton buttonWithType:UIButtonTypeCustom];
	fav.bounds = CGRectMake(0, 0, 35, 35);
	UIImage *dlimg = [UIImage imageNamed:@"fav_btn.png"]; 
	[fav addTarget:self action:@selector(showDownloadOptions) forControlEvents:UIControlEventTouchUpInside];
	[fav setImage:dlimg forState:UIControlStateNormal];
	
	if(isDifferentUser){
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:fav];
		
	}else {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture)];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	}

	
	// register for notification 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createModel) name:@"UserHasLoggedIn" object:nil];
	
	
	
	
	
	
	
	//self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 
//												target:self 
//											  selector:@selector(invalidateModel) 
//											  userInfo:nil 
//											   repeats:YES];
//	
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if(![defaults objectForKey:TOKEN]){
		return;
	}else {
		if (isDifferentUser) {
			
			// do nothing. 
		}else {
			self.userId = [defaults objectForKey:@"user"];
			self.userName = [defaults objectForKey:@"username"];
			
		}
		
		NSLog(@"UserPhotoViewController: creating photoSource with %@ and %@", self.userId, self.userName);
		self.photoSource = [[[UserPhotosModel alloc] initWithUserId:self.userId andUserName:self.userName] autorelease];
	}
	
	
	
}

- (void)updateTableLayout { 
	self.tableView.contentInset = UIEdgeInsetsMake(47, 0, 0, 0); 
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero; 
}


-(void) takePicture{
	
	ImageUploadFormViewController *imageUploaderView = [[ImageUploadFormViewController alloc] init];
	[self presentModalViewController:imageUploaderView animated:YES];
	
}

/* actions sheet functions */


- (void)showDownloadOptions {
	UIActionSheet *actions = [[UIActionSheet alloc] 
							  initWithTitle:@"Fave Options" 
							  delegate:self 
							  cancelButtonTitle:@"Cancel" 
							  destructiveButtonTitle:nil 
							  otherButtonTitles:@"Fave ", nil];
	[actions showInView:self.tabBarController.view];
	[actions release];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ( buttonIndex == 0 ) {
		[self selectPhotos];
	} else if ( buttonIndex == 1 ) {
		[self.navigationController popToRootViewControllerAnimated:YES];
	}	
}

-(void) refresh{
	UserPhotosModel *ps = (UserPhotosModel *) self.photoSource;
	NSLog(@"1 photo source cache key = %@", ps.cacheKey);
	[self.photoSource invalidate:YES];
	ps.loadedTime = nil;
	[self.photoSource load:TTURLRequestCachePolicyDefault more:NO];
	NSLog(@"1 photo source cache key = %@", ps.cacheKey);
}

- (void)selectPhotos {
	NSLog(@"select photos");
	self.selection = [[NSMutableSet alloc] initWithCapacity:self.photoSource.numberOfPhotos];
	self.overlays = [[NSMutableSet alloc] initWithCapacity:self.photoSource.numberOfPhotos];
	
	self.delegate = self;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSelect)];	
}

- (void) doneSelect {
	self.delegate = nil;
	self.navigationItem.rightBarButtonItem = nil;
	AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	if ( self.selection.count > 0 ) {
		
		[ad.flickrFaver favePhotos:self.selection];	
	}
	
	self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
	UIButton *dl = [UIButton buttonWithType:UIButtonTypeCustom];
	dl.bounds = CGRectMake(0, 0, 35, 35);
	UIImage *dlimg = [UIImage imageNamed:@"fav_btn.png"]; 
	[dl addTarget:self action:@selector(showDownloadOptions) forControlEvents:UIControlEventTouchUpInside];
	[dl setImage:dlimg forState:UIControlStateNormal];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dl];
	
	for (FlickrPhoto *fp in self.selection ) {
		// add here code for adding to favs hash in memory
		[ad.favsUpdater addFavedImageWithKey:[fp.owner stringByAppendingString:fp.itemId]];
		fp.selected = NO;
	}
	[self.tableView reloadData];
	self.selection = nil;
}


/*************************************/



-(void) dealloc{
	
	[_selection release];
	[_overlays release];
	[super dealloc];
	
}


- (TTPhotoViewController*)createPhotoViewController {
	PhotoPageViewController *photoViewController = [[[PhotoPageViewController alloc] initWithPhotoSource:self.photoSource] autorelease]; 
	return photoViewController;
}


-(void) createModel{

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if(![defaults objectForKey:TOKEN]){
        self.userName = @"LogIn";
		return;
	}else {
		if (isDifferentUser) {
			
			// do nothing. 
		}else {
			self.userId = [defaults objectForKey:@"user"];
			self.userName = [defaults objectForKey:@"username"];
			
		}
		
		NSLog(@"UserPhotoViewController: creating photoSource with %@ and %@", self.userId, self.userName);
		self.photoSource = [[[UserPhotosModel alloc] initWithUserId:self.userId andUserName:self.userName] autorelease];
	}
	
								 
	
}

- (void)thumbsViewController: (TTThumbsViewController*)controller
              didSelectPhoto: (id<TTPhoto>)photo {
	
	FlickrPhoto *fp = (FlickrPhoto *)photo;
	if ( [self.selection containsObject:photo] ) {
		[self.selection removeObject:photo];
		fp.selected = NO;
	} else {
		[self.selection addObject:photo];
		fp.selected = YES;
	}
	
}

- (BOOL)thumbsViewController: (TTThumbsViewController*)controller
       shouldNavigateToPhoto: (id<TTPhoto>)photo {
	return NO;
}

- (void)thumbsTableViewCell:(TTThumbsTableViewCell*)cell didSelectPhoto:(id<TTPhoto>)photo {
	[super thumbsTableViewCell:cell didSelectPhoto:photo];
	
	[cell updateOverlayForPhoto:photo];
	[cell setNeedsDisplay];
}


@end

@implementation TTThumbsTableViewCell (selectable)

- (UIView *)thumbViewAtIndex:(int)index {
	return [_thumbViews objectAtIndex:index];
}

- (void)assignPhotoAtIndex:(int)photoIndex toView:(TTThumbView*)thumbView {
	id<TTPhoto> photo = [_photo.photoSource photoAtIndex:photoIndex];
	if (photo) {
		thumbView.thumbURL = [photo URLForVersion:TTPhotoVersionThumbnail];
		thumbView.hidden = NO;
	} else {
		thumbView.thumbURL = nil;
		thumbView.hidden = YES;
	}
	
	[self updateOverlayForPhoto:(FlickrPhoto *)photo];
	
}

- (void)updateOverlayForPhoto:(FlickrPhoto *)photo {
	if ( self.columnCount )  {
		
		UIImage *img = [UIImage imageNamed:@"overlay.png"];
		UIImageView *overlay = [[UIImageView alloc] initWithImage:img];
		overlay.bounds = CGRectMake(-30,-30, 75, 75);
		overlay.tag = OVERLAY_TAG;
		
		int thumbIdx = photo.index % self.columnCount;
		
		UIView *selectedView = [self thumbViewAtIndex:thumbIdx];
		if ( photo.selected ) {
			[selectedView addSubview:overlay];
		} else {
			[selectedView removeAllSubviews];
		}		
	}
}


@end

