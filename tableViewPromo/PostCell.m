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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textLabel.numberOfLines = 0;
        
        self.upArrow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.upArrow.adjustsImageWhenHighlighted = false;
        
        [self.upArrow addTarget:self action:@selector(UpArrowTapped:) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview:self.upArrow];
    }
  
    return self;
}

- (void) layoutSubviews {
  [super layoutSubviews];
    /*
  self.upArrow.center = CGPointMake(self.upArrow.center.x, floorf(self.frame.size.height / 2 - upArrow.frame.size.height / 2));
  self.downArrow.center = CGPointMake(self.downArrow.center.x, floorf(self.frame.size.height / 2) + downArrow.frame.size.height /2);

  float x = self.upArrow.frame.origin.x + self.upArrow.frame.size.width +8;
  self.textLabel.frame = CGRectMake(x, self.textLabel.frame.origin.y, self.frame.size.width - x - 8, self.frame.size.height);
     */
    float x = self.upArrow.frame.origin.x + self.upArrow.frame.size.width +8;
    
    self.textLabel.frame = CGRectMake(8, self.textLabel.frame.origin.y, self.frame.size.width - self.upArrow.frame.size.width - 24, self.frame.size.height);

}

- (void)setNumberImage:(UIImage *)numberImage
{
    if (numberImage == _numberImage) return;
    _numberImage = numberImage;
    
    self.upArrow.frame = CGRectMake(self.frame.size.width - _numberImage.size.width, 0, _numberImage.size.width, _numberImage.size.height);
    
    [self.upArrow setBackgroundImage:_numberImage forState:UIControlStateNormal];
    [self.upArrow setBackgroundImage:_numberImage forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)UpArrowTapped:(id)sender {
  NSLog(@"UP!");
  if (_modHash == NULL){
    
     UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login into reddit to vote." delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
     [alert show];
     
    
  } else {
      if (_status != 1){
        // Happens if the previous state was neutral or negative
        [self.upArrow setSelected: YES];
        if (_status == -1){
          [self.downArrow setSelected: NO];
        }
        [self vote:@"1"];
        _status =1;
      } else {
      
        [self.upArrow setSelected:NO];
        [self vote:@"0"];
        _status = 0;
      }
    }
    /*
  if ([_delegate respondsToSelector:@selector(statusChanged:forPostWithId:)]){
    [self.delegate statusChanged:_status forPostWithId: self.postId];
  }
     */
}

- (IBAction)DownArrowTapped:(id)sender {
  NSLog(@"Down!");
  if (_modHash == NULL){
    
       UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login into reddit to vote." delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
       [alert show];
    

  } else {
      if (_status != -1){
        // Happens if the previous state was neutral or positive
        [self.downArrow setSelected: YES];
        if (_status == 1){
          [self.upArrow setSelected: NO];
        }
        [self vote:@"-1"];
        _status = -1;
      } else {
        
        [self.downArrow setSelected: NO];
        [self vote:@"0"];
        _status = 0;
      }
  }
    /*
  if ([_delegate respondsToSelector:@selector(statusChanged:forPostWithId:)]){
    [_delegate statusChanged:_status forPostWithId: self.postId];
  }
     */
  
}

-(void) vote: (NSString *)direction{
  
  NSString *postToVote = _postId;
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  if (_modHash != NULL){
    NSDictionary *parameters = @{@"dir": direction, @"id":postToVote, @"uh":_modHash};
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
