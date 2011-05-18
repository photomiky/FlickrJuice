//
//  MyTableViewCell.m
//  NSOperationTest
//
//  Created by Lawrence Coopet on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyGradientView.h"

// Implement start and end colors and start and end point

@implementation MyGradientView

-(id) initWithCoder:(NSCoder *)aDecoder
{
	self	= [super initWithCoder:aDecoder];
	if( self )
	{
		gdObject	= [[GradientDrawClass alloc] init];
		[gdObject addColor:[UIColor redColor].CGColor];
		[gdObject addColor:[UIColor blueColor].CGColor];
	}
	return self;
}

-(id) initWithFrame:(CGRect)frame
{
	self	= [super initWithFrame:frame];
	if( self )
	{
		gdObject	= [[GradientDrawClass alloc] init];
		
		UIColor	*foo	= [UIColor redColor];
		[gdObject addColor:foo.CGColor atPercentage:0];
		
		foo	= [UIColor greenColor];
		[gdObject addColor:foo.CGColor atPercentage:.5];
		
		foo	= [UIColor blueColor];
		[gdObject addColor:foo.CGColor atPercentage:1];
	}
	return self;
}

-(void) dealloc
{
	//NSLog(@"dealloc of Gradient View");
	[gdObject release];
	[super dealloc];
}

-(void) drawRect:(CGRect)rect
{
	CGRect			rct	= [self bounds];
	CGContextRef	cgx	= UIGraphicsGetCurrentContext();
	
#if 0
	CGPoint	mid		= CGPointMake( rct.size.width * .5, rct.size.height * .5 );
	[gdObject drawRadialInContext:cgx atPoint:mid startRadius:rct.size.height / 2 endRadius:rct.size.width];
#else
	CGPoint	start	= CGPointMake( 0, 0 );
	CGPoint	end		= CGPointMake( rct.size.width, 0 );
	[gdObject drawLinearInContext:cgx from:start to:end];
#endif
}


@end
