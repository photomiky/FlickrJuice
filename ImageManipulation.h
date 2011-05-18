//
//  ImageManipulation.h
//  Anonymous
//
//  Created by Michael Rabin on 8/22/10.
//  Copyright 2010 AppHouse. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageManipulator : NSObject {
}

+(UIImage *)makeRoundCornerImage:(UIImage*)img :(int) cornerWidth :(int) cornerHeight;
+(UIImage *)makeRoundCornerImage:(UIImage*)img :(int) cornerWidth :(int) cornerHeight :(int)corner;
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
						CGColorRef  endColor);
@end
