//
//  UIImage+NBA.m
//  tableViewPromo
//
//  Created by Adam Cue on 2/9/14.
//  Copyright (c) 2014 GIDEON ROSENTHAL. All rights reserved.
//

#import "UIImage+NBA.h"

@implementation UIImage (NBA)

+ (UIImage *)upArrowImage {
  static UIImage * upArrowImage = nil;
  if(upArrowImage == nil) {
    upArrowImage = [UIImage imageNamed:@"UpArrow.png"];
  }

  return upArrowImage;
}

+ (UIImage *)downArrowImage {
  static UIImage * downArrowImage = nil;
  if(downArrowImage == nil) {
    downArrowImage = [UIImage imageNamed:@"DownArrow.png"];
  }
  return downArrowImage;
}

+ (UIImage *)upArrowImageLight {
  static UIImage * upArrowImageLight = nil;
  if(upArrowImageLight == nil) {
    upArrowImageLight = [UIImage imageNamed:@"UpArrowLight.png"];
  }
  
  return upArrowImageLight;
}

+ (UIImage *)downArrowImageLight {
  static UIImage * downArrowImageLight = nil;
  if(downArrowImageLight == nil) {
    downArrowImageLight = [UIImage imageNamed:@"DownArrowLight.png"];
  }
  return downArrowImageLight;
}

@end
