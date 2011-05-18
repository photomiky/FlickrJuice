//
//  AddCommentViewController.h
//  SPFeed
//
//  Created by Michael Rabin on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddCommentViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate> {
	IBOutlet UITextView *_textview;
	NSString *_object_id;
	BOOL posted;
	
	id _target;
	SEL _selector;
	NSString *_commentText;
}

@property (nonatomic,retain) NSString *object_id;
@property (nonatomic, retain) NSString *commentText;
- (IBAction)post;
- (IBAction)cancel;

- (void)dismiss;
- (void)setCallback:(id)target withSelector:(SEL)selector;

@end
