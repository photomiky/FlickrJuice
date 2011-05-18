//
//  GradientDrawClass.h
//
//  Created by Lawrence Coopet on 11/16/09.
//  Copyright 2009 Apple, Inc. All rights reserved.
//
// Simple Class that wraps CFGradient functionality

#import <Foundation/Foundation.h>

@interface GradientDrawClass : NSObject {
@private
	CFMutableArrayRef	colors;			// an array of CGColors for the gradient colors - we must have at least 2 colors
	NSMutableArray		*locations;		// an array of NSNumber floats for the gradient color changes - can be empty -- all points between 0-1
	CGGradientRef		cgGradient;
	BOOL				fillBeforeStart;
	BOOL				fillAfterEnd;
}

@property(nonatomic,assign) BOOL	fillBeforeStart;		// defaults to YES
@property(nonatomic,assign) BOOL	fillAfterEnd;			// defaults to YES

-(void) reset;		// clears the gradient and all the colors, etc

-(void) addColor:(CGColorRef)color;
-(void) addColor:(CGColorRef)color atPercentage:(CGFloat)loc;


// Drawing
-(void) drawLinearInContext:(CGContextRef)cgx from:(CGPoint)start to:(CGPoint)end;

-(void) drawRadialInContext:(CGContextRef)cgx startCenter:(CGPoint)startCtr startRadius:(CGFloat)startRad endCenter:(CGPoint)endCtr endRadius:(CGFloat)endRad;

-(void) drawRadialInContext:(CGContextRef)cgx atPoint:(CGPoint)atPt startRadius:(CGFloat)startRad endRadius:(CGFloat)endRad;

@end
