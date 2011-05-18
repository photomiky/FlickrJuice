//
//  UIImageAnimationView.h
//  FlickrJuice2
//
//  Created by Michael Rabin on 16/05/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageAnimationView : UIImageView {
    
}
-(void) fadeIn;
-(void) fadeOut:(NSString *) animationId finished:(NSNumber *) finished context:(void *) context;
@end
