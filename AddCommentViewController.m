//
//  AddCommentViewController.m
//  SPFeed
//
//  Created by Michael Rabin on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddCommentViewController.h"
#import "LoginViewController.h"

extern const NSString* FlickrAPIKey;
extern const NSString* FlickrSecret;
extern const NSString* FLICKR_API;
NSString* const kSignatureKey=@"useCommentSignature";

@implementation AddCommentViewController

@synthesize object_id=_object_id,commentText=_commentText;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		_target = nil;
		_selector = nil;
		self.hidesBottomBarWhenPushed = NO; 
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	posted = NO;
	_commentText = nil;
	
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)viewWillAppear:(BOOL)flag {
	NSLog(@"view will appear - comments");
    [super viewWillAppear:flag];
    [_textview becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.commentText = nil;
}


- (void)dealloc {
	[_textview release];
	[self.commentText release];	
	[self.object_id release];
    [super dealloc];
}

- (IBAction)post {
	NSLog(@"POSTING comment");
	if ( ( !posted ) && (_textview.text.length > 0 ) ) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		BOOL useSignature = YES;
		NSNumber *pUseSignature = [NSNumber numberWithInt:1];
		if ( YES ) {
			useSignature = [pUseSignature boolValue];
		}
		
		NSLog(@"signature=%d", useSignature);
		
		//NSString *commentTxt = _textview.text;
		NSString *commentTxt = useSignature ? [_textview.text stringByAppendingFormat:@"\n\nSent using FlickrJuice iPhone App http://itunes.apple.com/us/app/flickrjuice/id424477518?mt=8"] : _textview.text;
		NSLog(@"commentTxt = %@", commentTxt);
		NSString *token = [defaults objectForKey:@"token"];
		
		
		
		NSString *method = @"flickr.photos.comments.addComment";
		
		NSString *api_sig_str = [NSString stringWithFormat:@"%@api_key%@auth_token%@comment_text%@formatjsonmethod%@nojsoncallback1photo_id%@", FlickrSecret, FlickrAPIKey, token, commentTxt, method, _object_id]; 
		NSLog(@"api_Sig %@", api_sig_str);
		
		NSString *api_sig = [LoginViewController md5:api_sig_str];
		
		NSString *params = [NSString stringWithFormat:@"method=%@&photo_id=%@&comment_text=%@&format=json&nojsoncallback=1&api_key=%@&auth_token=%@&api_sig=%@", method, _object_id, commentTxt
							, FlickrAPIKey, token, api_sig];
		
		NSString *url = [[FLICKR_API stringByAppendingString:params] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSLog(@"url sent to flickr is %@", url);
		
		
		NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
		
		TTActivityLabel *activity = [[[TTActivityLabel alloc] 
									 initWithFrame:CGRectMake(50, 128, 200, 60) 
									 style:TTActivityLabelStyleBlackBezel 
									 text:@"Sending Comment"] autorelease];
		
		[self.view addSubview:activity];
		 
		posted = YES;
		self.commentText = commentTxt;
		
	}
}

- (IBAction)cancel {
	if (_textview.text.length > 0) {
		UIActionSheet *action = [[UIActionSheet alloc] 
								 initWithTitle:@"Discard Comment ?" 
								 delegate:self 
								 cancelButtonTitle:@"Keep Editing" 
								 destructiveButtonTitle:@"Discard Changes" 
								 otherButtonTitles:nil];
		[action showInView:self.view];
		[action release];		
	} else {
		[self dismiss];
	}
}

- (void)dismiss {
	NSLog(@"closing comments dialog");
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	[textView resignFirstResponder];
	return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		// cancel selected
		[self dismiss];
	} 	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"failed sending comment: %@", error);
	UIAlertView *err = [[[UIAlertView alloc] 
						initWithTitle:@"Connection Error" 
						message:[error localizedDescription] 
						delegate:nil 
						cancelButtonTitle:@"Dismiss" 
						otherButtonTitles:nil] autorelease];
					
	[err show];
	[self dismiss];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"connection finished loading");
	if ( _target && _selector ) {
		[_target performSelector:_selector withObject:self];
	}
	
	[self dismiss];
}

- (void)setCallback:(id)target withSelector:(SEL)selector {
	_target = target;
	_selector = selector;
}

@end
