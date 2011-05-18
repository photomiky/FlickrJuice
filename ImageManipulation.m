//
//  ImageManipulation.m
//  Anonymous
//
//  Created by Ynon Perek on 8/22/10.
//  Copyright 2010 AppHouse. All rights reserved.
//

#import "ImageManipulation.h"

@implementation ImageManipulator

static void addRoundedRectToTopRight(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
		
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddLineToPoint(context, 0, fh);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, fw, 0);
	
    CGContextClosePath(context);
    CGContextRestoreGState(context);	
}

static void addRoundedRectToBottomRight(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
	
	CGContextAddLineToPoint(context, fw, fh);
    CGContextAddLineToPoint(context, 0, fh);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	
    CGContextClosePath(context);
    CGContextRestoreGState(context);	
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);

	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddLineToPoint(context, 0, fh);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, fw, 0);
	
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight {
	return [ImageManipulator makeRoundCornerImage:img :cornerWidth :cornerHeight :0];
}

+(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight :(int)corner
{
	UIImage * newImage = nil;
	
	if( nil != img)
	{
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		int w = img.size.width;
		int h = img.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		
		if ( corner == 1 ) {
			addRoundedRectToTopRight(context, rect, cornerWidth, cornerHeight);
		} else if ( corner == 2 ) {
			addRoundedRectToBottomRight(context, rect, cornerWidth, cornerHeight);
		} else {
			addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
		}
		
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		[img release];
		
		newImage = [[UIImage imageWithCGImage:imageMasked] retain];
		CGImageRelease(imageMasked);
		
		[pool release];
	}
	
    return newImage;
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
						CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
	
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
	
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
														(CFArrayRef) colors, locations);
	
	CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
	
	CGContextSaveGState(context);
	CGContextAddRect(context, rect);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	CGContextRestoreGState(context);
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

@end