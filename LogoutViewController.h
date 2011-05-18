//
//  LogoutViewController.h
//  FlickrJuice
//
//  Created by Michael Rabin on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "FBConnect.h"

@interface LogoutViewController : UIViewController <UIActionSheetDelegate>{
	IBOutlet UIButton *_logoutBtn;
}

@property (nonatomic, retain) UIButton *logoutBtn;


- (void)logoutClick:(id)sender;
- (void)logout;
@end
