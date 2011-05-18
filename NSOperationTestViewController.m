/*
 File: NSOperationTestViewController.m
 
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

#import "NSOperationTestViewController.h"
#import "NSOperationTestViewController_Priv.h"
#import "ImageStateObject.h"
#import "ImageHelpers.h"

#define kMyCellID	@"MyCellID"

@implementation NSOperationTestViewController
@synthesize	mTableView;

-(void) dealloc	{
	[self cleanUp];
    [super dealloc];
}
-(void) didReceiveMemoryWarning	{
    [super didReceiveMemoryWarning];	// Releases the view if it doesn't have a superview.
}
-(void) viewDidLoad	{
	[super viewDidLoad];
	[self setUp];
}
-(void) viewDidUnload	{
	[self cleanUp];
	[super viewDidUnload];
}


#pragma mark -
#pragma mark Action Methods

-(IBAction) toggleOperations:(UIButton*)sender
{
	mUseOperations	= !mUseOperations;
	UIColor	*clr	= mUseOperations ? [UIColor redColor] : [UIColor blackColor];
	[sender setTitleColor:clr forState:UIControlStateNormal];
	
	// store state for next launch
	[[NSUserDefaults standardUserDefaults] setInteger:(mUseOperations ? 1 : 0) forKey:kKey_Ops];
}

-(IBAction) changeScale:(UISlider*)sender
{
	int			index	= -1;
	
	if( sender.value == mSizeFactor ) return;

	mSizeFactor	= sender.value;

	// get the middle item onscreen
	NSArray*	array	= [mTableView indexPathsForVisibleRows];
	if( array.count > 0 )
	{
		NSIndexPath	*path	= [array objectAtIndex:(array.count / 2)];
		index	= path ? path.row : -1;
	}
	
	[self reloadAll];

	if( index >= 0 )
		[mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

	[[NSUserDefaults standardUserDefaults] setDouble:mSizeFactor forKey:kKey_Scale];
}

-(IBAction) toggleTransparent:(UIButton*)sender
{
	mUseTransparency	= !mUseTransparency;
	
	UIColor	*clr	= mUseTransparency ? [UIColor redColor] : [UIColor blackColor];
	[sender setTitleColor:clr forState:UIControlStateNormal];
	
	mTableView.backgroundColor	= mUseTransparency ? [UIColor clearColor] : mTableViewBackColor;
	mTableView.opaque			= mUseTransparency ? NO : YES;
	
	[self updateOnScreenCells];
	
	[[NSUserDefaults standardUserDefaults] setInteger:(mUseTransparency ? 1 : 0) forKey:kKey_Transparency];
}

-(IBAction) toggleGradient:(UIButton*)sender
{	
	mUseGradient	= !mUseGradient;
	
	UIColor	*clr	= mUseGradient ? [UIColor redColor] : [UIColor blackColor];
	[sender setTitleColor:clr forState:UIControlStateNormal];
	
	[self updateOnScreenCells];
	
	[[NSUserDefaults standardUserDefaults] setInteger:(mUseGradient ? 1 : 0) forKey:kKey_Gradient];
}


#pragma mark -
#pragma mark Deferred image loading request method

-(UIImage*) requestImageForIndex:(NSUInteger)index
{
	ImageStateObject	*iso	= [self imageObjectForIndex:index];
	CGSize				theSz	= [self preferredImageSize];
	
	if( mUseOperations )
	{
		if( iso.hasImage == NO && iso.queuedOp == NO )	// if we dont have an image and there is no operation pending
		{	
			// Queue up an operation to do the work!
			MyLoadScaleOperation	*op = [[MyLoadScaleOperation alloc] initWithPath:iso.path index:index targetSize:theSz];
			op.resultsDelegate	= self;		// set the delegate
			[mQueue addOperation:op];
			[op release];
			
			iso.queuedOp	= YES;
		}
		
		return mPlaceHolderImage;		// just return our placeholder
	}
	
	return UImageFromPathScaledToSize( iso.path, theSz );
}

#pragma mark -
#pragma mark Deferred image loading cancellation method

-(void) cancelOperationsForOffscreenRows
{	
	NSArray	*opArray	= [mQueue operations];
	int		active		= 0;
	for( MyLoadScaleOperation *op in opArray )
	{
		if( ! op.isCancelled )	// we only care about non-cancelled operations
		{
			NSUInteger		row		= op.index;
			UITableViewCell *cell	= [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
			
			if( cell == nil )	// then the row is NO longer visible so cancel the operation associated with that cell
			{
				[op cancel];
				[self imageObjectForIndex:row].queuedOp	= NO;		// update model state
			}
		}
		active	+= op.isCancelled ? 0 : 1;
	}
	//NSLog(@"operation count: %d", active);
}

#pragma mark -
#pragma mark Delegate method for MyLoadScaleOperationResultsDelegate protocol

-(void) operationFinishedScale:(MyLoadScaleOperation*)op
{
	if( op.isCancelled ) return;
	
	if( [NSThread isMainThread] )	// ok do our stuff
	{
		// Ask the table view for a given cell; nil if requested row is offscreen
		UITableViewCell *cell	= [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:op.index inSection:0]];
		if( cell && op.scaledImage )
		{	
			cell.imageView.image	= op.scaledImage;
			[cell setNeedsLayout];
		}

		// Update our model data
		ImageStateObject	*iso	= [self imageObjectForIndex:op.index];
		iso.queuedOp	= NO;
		iso.hasImage	= (op.scaledImage != nil);
	}
	else 
	{
		// this is NOT a recursive call - its an invocation pushed to the main thread
		[self performSelectorOnMainThread:@selector(operationFinishedScale:) withObject:op waitUntilDone:NO];
	}
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {	// any offset changes
	[self cancelOperationsForOffscreenRows];	// cancel any operations for offscreen rows
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if( !decelerate )	[self cancelOperationsForOffscreenRows];	// cancel any operations for offscreen rows - if we are decelerating we will do it in scrollViewDidScroll
}


#pragma mark -
#pragma mark TableView Delegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
	return [self preferredImageSize].height;
}


#pragma mark -
#pragma mark TableView DataSource

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section  {
	return mModelArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	// You Must do this HERE if you want to make the default items transparent
	cell.textLabel.backgroundColor	= [UIColor clearColor];
	cell.textLabel.opaque	= NO;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSUInteger		row		= indexPath.row;
	
	// try to recycle!
	UITableViewCell	*cell	= (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:kMyCellID];
	
	if( cell == nil )
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyCellID] autorelease];
		cell.imageView.contentMode	= UIViewContentModeScaleAspectFit;
		cell.textLabel.adjustsFontSizeToFitWidth	= YES;

		[self setupCell:cell];
	}
	else	// the cell is being recycled - so keep our model data in sync
	{
		ImageStateObject	*iso	= [self imageObjectForIndex:row];
		if( iso )
		{	
			iso.hasImage	= NO;
			iso.queuedOp	= NO;
		}
	}
	
	cell.imageView.image	= [self requestImageForIndex:row];
	cell.textLabel.text		= [self textForIndex:row];
	return cell;
}

@end
