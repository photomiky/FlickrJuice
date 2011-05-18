//
//  UIImageAnimationView.m
//  FlickrJuice2
//
//  Created by Michael Rabin on 16/05/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import "UIImageAnimationView.h"


@implementation UIImageAnimationView





-(void) fadeIn{
    
    NSLog(@"fading in");
    
    [self setAlpha:0.0f];    
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:4.0];
    [UIView setAnimationDidStopSelector:@selector(fadeOut:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [self setAlpha:1.0f];
    [UIView commitAnimations];
    
    
}

-(void) fadeOut:(NSString *) animationId finished:(NSNumber *) finished context:(void *) context{
    NSLog(@"now fading out");
    
}

@end
