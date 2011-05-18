//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "StyleSheet.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StyleSheet


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)myHeadingFont {
	return [UIFont fontWithName:@"Arial" size:13];
}

- (UIColor *)myHeadingColor {

	return [UIColor blueColor];
}
- (UIColor *)mySubtextColor {
	
	return [UIColor grayColor];
}

-(UIFont *) mySubtextFont{
	
	return [UIFont fontWithName:@"Arial" size:13];	
	
}

- (UIFont*)font {
  return [UIFont fontWithName:@"Arial" size:13];
}
-(UIFont*) tableSmallFont{
return [UIFont fontWithName:@"Arial" size:13];	
	
}
-(UIFont*) messageFont{
	
	return [UIFont fontWithName:@"Arial" size:13];
	
}
-(UIColor*)  linkTextColor{
	
	return [UIColor colorWithRed:242.0/255.0 green:5.0/255.0 blue:135.0/255.0 alpha:1.0];	
}

- (UIColor*)tablePlainBackgroundColor{
		
	return [UIColor colorWithRed:242.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableFont {
  return [UIFont fontWithName:@"Arial" size:16];
}

-(UIColor*)  textColor{
	
	return [UIColor colorWithRed:4.0/255.0 green:118.0/255.0 blue:217.0/255.0 alpha:1];
}


-(UIColor*)  highlightedTextColor{
	return [UIColor colorWithRed:242.0/255.0 green:5.0/255.0 blue:135.0/255.0 alpha:1];
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableHeaderPlainFont {
  return [UIFont fontWithName:@"Arial" size:14];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(UIFont*)titleFont {
  return [UIFont fontWithName:@"Arial" size:14];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableGroupedBackgroundColor {
  return RGBCOLOR(224, 221, 203);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableHeaderTextColor {
  return [UIColor colorWithRed:41.0 green:4.0 blue:24.0 alpha:1.0];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableHeaderTintColor {
  return RGBCOLOR(255, 0, 131);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)navigationBarTintColor {
  return RGBCOLOR(133, 191, 242);
}


@end
