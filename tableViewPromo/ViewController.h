//
//  ViewController.h
//  tableViewPromo
//
//  Created by GIDEON ROSENTHAL on 12/10/13.
//  Copyright (c) 2013 GIDEON ROSENTHAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCell.h"

@interface ViewController : UIViewController <UITableViewDataSource, TableCellDelegate>

@property (nonatomic, strong) NSData *allPosts;
@property (nonatomic, strong) NSMutableArray *placeImages;
@property (nonatomic, strong) NSString *currentLink;
@property (nonatomic, strong) NSArray *jsonResults;
@property (nonatomic, strong) NSString *modHash;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) UIImage *topImage;
@property (nonatomic, strong) NSString *topText;

@property (nonatomic, readwrite) CGFloat cellHeight;

@property (nonatomic, strong) NSMutableArray *postsCollection;

@property (nonatomic, strong) UIRefreshControl *refreshControl;


@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)twitterButtonTapped:(id)sender;

- (IBAction)redditButtonPressed:(id)sender;

- (IBAction)handleRefresh:(id)sender;



@end
