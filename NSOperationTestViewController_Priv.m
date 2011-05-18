/*
 File: NSOperationTestViewController_Priv.m
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 */

#import "NSOperationTestViewController_Priv.h"
#import "ImageStateObject.h"
#import "MyGradientView.h"

@implementation NSOperationTestViewController (HouseKeeping)

-(ImageStateObject*) imageObjectForIndex:(NSUInteger)index {
	return (ImageStateObject*) [mModelArray objectAtIndex:index];
}

-(NSString*) textForIndex:(NSUInteger)index {
	ImageStateObject	*iso	= [self imageObjectForIndex:index];
	return iso.path.lastPathComponent;
}
-(CGSize) preferredImageSize {
	CGSize		maxSz	= mTableView.bounds.size;
	CGFloat		sz		= maxSz.width * mSizeFactor;
	if( sz > (maxSz.width - 20))	sz = (maxSz.width - 20);
	sz	= trunc(sz);	// UITableView doesnt seem to like fractional sizes
	return CGSizeMake(sz, sz);
}

- (void) loadImageLocations			// Get the paths to the files - could be more efficient, we dont need to store the whole string
{
	if( mModelArray != nil )
	{
		[mModelArray removeAllObjects];

		// Load up our image paths...
		NSString	*path		= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Images"];
		NSArray		*subItems	= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
		
		for(NSString* itemPath in subItems)
		{
			ImageStateObject	*ir	= [[ImageStateObject alloc] init];
			ir.path	= [path stringByAppendingPathComponent:itemPath];
			[mModelArray addObject:ir];
			[ir release];
		}
	}
}

- (void) setUp		// build our internals
{
	if( mModelArray == nil )
	{	
		mQueue		= [[NSOperationQueue alloc] init];					// empty queue
		[mQueue setMaxConcurrentOperationCount:[[NSProcessInfo processInfo] activeProcessorCount] + 1];	// a good heuristic = processors + 1
		
		mModelArray			= [[NSMutableArray arrayWithCapacity:1] retain];	// empty array
		mPlaceHolderImage	= [[UIImage imageNamed:@"placeholder.png"] retain];		// just return a scaled placeholder
		mTableViewBackColor	= [mTableView.backgroundColor retain];
		
		mUseOperations		= [[NSUserDefaults standardUserDefaults] integerForKey:kKey_Ops];
		if( mUseOperations )
		{	
			UIButton *butt	= (UIButton*) [self.view viewWithTag:kID_ButtonOps];
			if( butt )	[butt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		}
		
		mUseGradient		= [[NSUserDefaults standardUserDefaults] integerForKey:kKey_Gradient];
		if( mUseGradient )
		{	
			UIButton *butt	= (UIButton*) [self.view viewWithTag:kID_ButtonGrad];
			if( butt )	[butt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		}
		
		mUseTransparency		= [[NSUserDefaults standardUserDefaults] integerForKey:kKey_Transparency];
		if( mUseTransparency )
		{	
			UIButton *butt	= (UIButton*) [self.view viewWithTag:kID_ButtonTrans];
			if( butt )	[butt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

			mTableView.backgroundColor	= [UIColor clearColor];
			mTableView.opaque			= NO;
		}
		
		mSizeFactor		= [[NSUserDefaults standardUserDefaults] doubleForKey:kKey_Scale];
		if(mSizeFactor < .1)	mSizeFactor	= .25;

		UISlider *slider	= (UISlider*) [self.view viewWithTag:kID_SliderScale];
		if( slider )	slider.value	= mSizeFactor;
		
		[self loadImageLocations];	// load the paths - NOT the actual images
		
		[self reloadAll];
	}
}

- (void) cleanUp		// tear down the object 
{
	[mQueue cancelAllOperations];		// stop any pending operations

	[mQueue release];	mQueue	= nil;
	
	[mModelArray release];	mModelArray = nil;
	
	[mPlaceHolderImage release];	mPlaceHolderImage	= nil;
	
	[mTableViewBackColor release]; mTableViewBackColor = nil;
	self.mTableView	= nil;
}

-(void) updateOnScreenCells
{
	NSArray	*array = [mTableView visibleCells];
	for (UITableViewCell *foo in array )
		[self setupCell:foo];
}

-(void) refreshAll
{
	[mTableView setNeedsDisplay];
	[self.view setNeedsDisplay];
}

-(void) reloadAll
{
	[mQueue cancelAllOperations];						// cancel any operations
	for( ImageStateObject *iso in mModelArray )	{		// update model states
		iso.hasImage	= NO;
		iso.queuedOp	= NO;
	}

	[self updateOnScreenCells];
	[mTableView reloadData];
}

-(void) setupCell:(UITableViewCell*)cell
{	
	if( mUseGradient )
	{
		MyGradientView	*gradView	= [[MyGradientView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		gradView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		if( mUseTransparency )
		{	
			gradView.alpha	= .65;
			gradView.opaque	= NO;
		}
		cell.backgroundView			= gradView;
		[gradView release];
	}
	else
	{
		cell.backgroundView			= nil;
	}
}

@end
