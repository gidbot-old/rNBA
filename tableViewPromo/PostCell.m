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

@synthesize postName, modHash, cellImage, delegate, upArrow, downArrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  // Set UpArrow
    UIImage * upImg = [UIImage upArrowImage];
    self.upArrow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.upArrow.frame = CGRectMake(8, 0, upImg.size.width, upImg.size.height);
    [self.upArrow setBackgroundImage:upImg forState:UIControlStateNormal];
    [self.upArrow addTarget:self action:@selector(UpArrowTapped:) forControlEvents: UIControlEventTouchUpInside];
    [self.contentView addSubview:upArrow];
  
    // Set DownArrow
  UIImage * downImg = [UIImage downArrowImage];
    self.downArrow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.downArrow.frame = CGRectMake(8, 0, downImg.size.width, downImg.size.height);
    [self.downArrow setBackgroundImage:downImg forState:UIControlStateNormal];
    [self.downArrow addTarget:self action:@selector(DownArrowTapped:) forControlEvents: UIControlEventTouchUpInside];
    [self.contentView addSubview:downArrow];
  
  self.textLabel.numberOfLines = 0;
    
  //  self.window.tintColor //
  
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
  [self vote:@"1"];
}

- (IBAction)DownArrowTapped:(id)sender {
  NSLog(@"Down!");
  [self vote:@"-1"];
}

-(void) vote: (NSString *)direction{
  
  NSString *postToUpVote = postName;
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  if (modHash != NULL){
    NSDictionary *parameters = @{@"dir": direction, @"id":postToUpVote, @"uh":modHash};
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
    
  } else {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login into reddit to vote." delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alert show];
    
  }

}

@end
