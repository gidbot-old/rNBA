//
//  PostCell.h
//  tableViewPromo
//
//  Created by Adam Cue on 2/9/14.
//  Copyright (c) 2014 GIDEON ROSENTHAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableCellDelegate
@optional
- (void)voteButtonTappedOnCell:(id)sender;
@end

@interface PostCell : UITableViewCell

@property (nonatomic, strong) NSString *postName;
@property (nonatomic, strong) NSString *modHash;
@property (nonatomic, strong) UIButton *upArrow;
@property (nonatomic, strong) UIButton *downArrow;

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (nonatomic, strong) id  delegate;


@end
