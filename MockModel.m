//
//  MockModel.m
//  FlickrJuice2
//
//  Created by Michael Rabin on 17/05/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import "MockModel.h"


@implementation MockModel


- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more{
    
    NSLog(@"load model called");
    [self didFinishLoad];
}



@end
