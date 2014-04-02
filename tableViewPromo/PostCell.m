//
//  PostCell.m
//  tableViewPromo
//
//  Created by Adam Cue on 2/9/14.
//  Copyright (c) 2014 GIDEON ROSENTHAL. All rights reserved.
//

#import "PostCell.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>



@implementation PostCell

@synthesize postId, modHash, cellImage, delegate, upArrow, downArrow, status,  upImg, upImgLight, downImg, downImgLight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.textLabel.numberOfLines = 0;

    upImg = [UIImage upArrowImage];
    upImgLight = [UIImage upArrowImageLight];
    downImg = [UIImage downArrowImage];
    downImgLight = [UIImage downArrowImageLight];

  
    self.upArrow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.upArrow.adjustsImageWhenHighlighted = false;
    self.upArrow.frame = CGRectMake(8, 0, upImgLight.size.width, upImgLight.size.height);
  
    [self.upArrow setBackgroundImage:upImgLight forState:UIControlStateNormal];
    [self.upArrow setBackgroundImage:upImg forState:UIControlStateSelected];
    [self.upArrow addTarget:self action:@selector(UpArrowTapped:) forControlEvents: UIControlEventTouchUpInside];
    [self.contentView addSubview:upArrow];

  
  
    self.downArrow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.downArrow.adjustsImageWhenHighlighted = false;
    [self.downArrow setBackgroundImage:downImgLight forState:UIControlStateNormal];
    [self.downArrow setBackgroundImage:downImg forState:UIControlStateSelected];
    self.downArrow.frame = CGRectMake(8, 0, downImgLight.size.width, downImgLight.size.height);
  
    [self.downArrow addTarget:self action:@selector(DownArrowTapped:) forControlEvents: UIControlEventTouchUpInside];

  [self.contentView addSubview:downArrow];


  
    return self;
}

- (void) layoutSubviews {
  [super layoutSubviews];
  self.upArrow.center = CGPointMake(self.upArrow.center.x, floorf(self.frame.size.height / 2 - upArrow.frame.size.height / 2));
  self.downArrow.center = CGPointMake(self.downArrow.center.x, floorf(self.frame.size.height / 2) + downArrow.frame.size.height /2);

  float x = self.upArrow.frame.origin.x + self.upArrow.frame.size.width +8;
  self.textLabel.frame = CGRectMake(x, self.textLabel.frame.origin.y, self.frame.size.width - x - 8, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)UpArrowTapped:(id)sender {
  NSLog(@"UP!");
  if (modHash == NULL){
    
     UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login into reddit to vote." delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
     [alert show];
     
    
  } else {
      if (status != 1){
        // Happens if the previous state was neutral or negative
        [self.upArrow setSelected: YES];
        if (status == -1){
          [self.downArrow setSelected: NO];
        }
        [self vote:@"1"];
        status =1;
      } else {
      
        [self.upArrow setSelected:NO];
        [self vote:@"0"];
        status = 0;
      }
    }
  if ([delegate respondsToSelector:@selector(statusChanged:forPostWithId:)]){
    [delegate statusChanged:status forPostWithId: self.postId];
  }
}

- (IBAction)DownArrowTapped:(id)sender {
  NSLog(@"Down!");
  if (modHash == NULL){
    
       UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login into reddit to vote." delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
       [alert show];
    

  } else {
      if (status != -1){
        // Happens if the previous state was neutral or positive
        [self.downArrow setSelected: YES];
        if (status == 1){
          [self.upArrow setSelected: NO];
        }
        [self vote:@"-1"];
        status = -1;
      } else {
        
        [self.downArrow setSelected: NO];
        [self vote:@"0"];
        status = 0;
      }
  }
  if ([delegate respondsToSelector:@selector(statusChanged:forPostWithId:)]){
    [delegate statusChanged:status forPostWithId: self.postId];
  }
  
}

-(void) vote: (NSString *)direction{
  
  NSString *postToVote = postId;
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  if (modHash != NULL){
    NSDictionary *parameters = @{@"dir": direction, @"id":postToVote, @"uh":modHash};
    [manager POST:@"https://ssl.reddit.com/api/vote" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"JSON: %@", responseObject);
      NSArray *errors = responseObject[@"json"][@"errors"];
      if (errors){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please use a valid Reddit Login." delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
      
    }];
    
  }
}

@end
