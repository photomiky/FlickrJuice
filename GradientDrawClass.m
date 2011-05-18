//
//  GradientDrawClass.m
//  NSOperationTest
//
//  Created by Lawrence Coopet on 11/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GradientDrawClass.h"


@implementation GradientDrawClass
@synthesize	fillBeforeStart, fillAfterEnd;

-(id) init
{
	self = [super init];
	if( self )
	{
		locations	= [[NSMutableArray alloc] init];
		colors		= CFArrayCreateMutable(NULL, 0, &kCFTypeArrayCallBacks);
		self.fillBeforeStart	= YES;
		self.fillAfterEnd		= YES;
	}
	return self;
}

-(void) killGradient
{
	if( cgGradient )
		CGGradientRelease(cgGradient);
	cgGradient	= NULL;
}

-(void) reset
{
	[self killGradient];
	[locations removeAllObjects];
	CFArrayRemoveAllValues( colors );
}

-(void) dealloc
{
	//NSLog(@"dealloc of Gradient Draw Class");
	[self reset];
	[locations release];
	CFRelease(colors);
	[super dealloc];
}

-(void) build
{
	[self killGradient];
	
	if( CFArrayGetCount(colors) > 0 )
	{
		CGFloat	*locs	= nil;
		
		if( locations.count > 0 )
		{
			locs	= (CGFloat*) malloc(sizeof(CGFloat) * locations.count);
			for(unsigned int ix = 0; ix < locations.count; ix++) 
			{
				NSNumber	*foo	= [locations objectAtIndex:ix];
				locs[ix]	= [foo floatValue];
			}
		}
		
		cgGradient	= CGGradientCreateWithColors(NULL, colors, (CGFloat*)locs);
	}
}

-(void) addColor:(CGColorRef)color atOptionalPercentage:(CGFloat*)loc
{
	CGColorRef	tmp	= CGColorCreateCopy(color);
	CFArrayAppendValue( colors, tmp );
	CGColorRelease(tmp);
	
	if( loc )
	{
		NSValue	*val	= [NSNumber numberWithFloat:*loc];
		[locations addObject:val];
	}
	if( CFArrayGetCount(colors) > 1 )
		[self build];
}

-(void) addColor:(CGColorRef)color atPercentage:(CGFloat)loc
{
	[self addColor:color atOptionalPercentage:&loc];
}

-(void) addColor:(CGColorRef)color
{
	[self addColor:color atOptionalPercentage:NULL];
}

-(void) drawLinearInContext:(CGContextRef)cgx from:(CGPoint)start to:(CGPoint)end
{
	if( cgGradient )
	{
		CGGradientDrawingOptions	opts	= 0;
		if( self.fillBeforeStart )	opts |= kCGGradientDrawsBeforeStartLocation;
		if( self.fillAfterEnd )		opts |= kCGGradientDrawsAfterEndLocation;
		
		CGContextDrawLinearGradient( cgx, cgGradient, start, end, opts );
	}
}

-(void) drawRadialInContext:(CGContextRef)cgx startCenter:(CGPoint)startCtr startRadius:(CGFloat)startRad endCenter:(CGPoint)endCtr endRadius:(CGFloat)endRad
{
	if( cgGradient )
	{
		CGGradientDrawingOptions	opts	= 0;
		if( self.fillBeforeStart )	opts |= kCGGradientDrawsBeforeStartLocation;
		if( self.fillAfterEnd )		opts |= kCGGradientDrawsAfterEndLocation;
		
		CGContextDrawRadialGradient( cgx, cgGradient, startCtr, startRad, endCtr, endRad, opts );
	}
}

-(void) drawRadialInContext:(CGContextRef)cgx atPoint:(CGPoint)atPt startRadius:(CGFloat)startRad endRadius:(CGFloat)endRad
{
	if( cgGradient )
	{
		CGGradientDrawingOptions	opts	= 0;
		if( self.fillBeforeStart )	opts |= kCGGradientDrawsBeforeStartLocation;
		if( self.fillAfterEnd )		opts |= kCGGradientDrawsAfterEndLocation;
		
		CGContextDrawRadialGradient( cgx, cgGradient, atPt, startRad, atPt, endRad, opts );
	}
}

@end
