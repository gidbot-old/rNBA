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
- (void)statusChanged:(NSInteger) status forPostWithId: (NSString *)postId;
@end

@interface PostCell : UITableViewCell

@property (nonatomic, strong) NSString *postId;

@property (nonatomic, strong) NSString *modHash;
@property (nonatomic, strong) UIButton *upArrow;
@property (nonatomic, strong) UIButton *downArrow;

@property (nonatomic, readwrite) NSInteger status;

@property (nonatomic, strong) IBOutlet UIImageView *cellImage;
@property (nonatomic, strong) id<TableCellDelegate> delegate;

@property (nonatomic, strong) UIImage *numberImage;

/*
 @property (nonatomic, strong) UIImage *upImg;
 @property (nonatomic, strong) UIImage *downImg;
 @property (nonatomic, strong) UIImage *upImgLight;
 @property (nonatomic, strong) UIImage *downImgLight;
 */


@end
