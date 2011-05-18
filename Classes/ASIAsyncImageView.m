//
//  ASIAsyncImageView.m
//  JukeBook
//
//  Created by Michael Rabin on 11/05/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import "ASIAsyncImageView.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


@implementation ASIAsyncImageView

@synthesize delegate=_delegate, urlStr=_urlStr, index;

-(id) init{
    self = [super init];
    if(self){
       //
    }
    return self;
}

- (void)loadImageFromURL:(NSString *)urlStr; {
    
    self.urlStr = urlStr;
    if(urlStr && ![urlStr isEqualToString:@""]){
        NSURL *url = [NSURL URLWithString:urlStr];

        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCachePolicy:ASIUseDefaultCachePolicy];
        [request setDelegate:self];
        [request startAsynchronous];
        
    }
}

-(void) dealloc{
    
    [_theImage release];
    [_urlStr release];
    [super dealloc];
    
    
}

- (UIImage *) image{
    return _theImage;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    //NSLog(@"Image download request finished. Did use cache? %d", [request didUseCachedResponse]);
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    _theImage = [UIImage imageWithData:responseData];
    [self.delegate appImageDidLoad:index];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Loading of image failed with error %@", [error description]);
}


@end
