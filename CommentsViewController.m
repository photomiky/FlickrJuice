//
//  CommentsViewController.m
//  FlickrJuice
//
//  Created by Michael Rabin on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "CommentsViewController.h"
#import "CommentsDataSource.h"
#import "AddCommentViewController.h"
#import "FFComment.h"

@implementation CommentsViewController

@synthesize photoId=_photoId;

-(id) initWithPhotoId:(NSString *) photoId{
	

	if(self = [super init]){
		
		self.photoId = photoId;
		
	}
	
	return self;
	
}


-(void) loadView{
	

	[super loadView];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)] autorelease]; 
	
	
	
}

-(void) viewWillAppear:(BOOL)animated{

	
	[super viewWillAppear:animated];
	
	if(newComment){
		NSLog(@"reloading comments...");
		[self.tableView reloadData];
	
	}
	
}



-(void) dealloc{

	[_photoId release];
	[super dealloc];
	
}

// callback function I defined
- (void)postedFromController:(AddCommentViewController *)controller {
	NSLog(@"new comment posted");
	
	
	FFComment *comment = [[FFComment alloc] init];
	comment.comment = controller.commentText;
	comment.uid = controller.object_id;
	CommentsDataSource *ds = (CommentsDataSource *)self.dataSource;
	[ds addComment:comment];
//	
	[self invalidateModel]; 
	newComment = YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////


- (void)createModel {
	self.dataSource = [[[CommentsDataSource alloc] initWithPhotoId:self.photoId] autorelease];
}


-(void) compose {
	
	NSLog(@"1 Compose a new comment");
	AddCommentViewController *addCommentsDialog = [[AddCommentViewController alloc] 
												   initWithNibName:@"AddCommentViewController" 
												   bundle:nil];
	addCommentsDialog.object_id = self.photoId;
	[addCommentsDialog setCallback:self withSelector:@selector(postedFromController:)];
	[self presentModalViewController:addCommentsDialog animated:YES];
	[addCommentsDialog release];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end
