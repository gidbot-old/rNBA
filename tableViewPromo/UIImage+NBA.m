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
    upArrowImage = [UIImage imageNamed:@"number3.png"];
  }
  return upArrowImage;
}

+ (UIImage *)downArrowImage {
  static UIImage * downArrowImage = nil;
  if(downArrowImage == nil) {
    downArrowImage = [UIImage imageNamed:@"number3.png"];
  }
  return downArrowImage;
}

@end
