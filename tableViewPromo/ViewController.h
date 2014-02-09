//
//  ViewController.h
//  tableViewPromo
//
//  Created by GIDEON ROSENTHAL on 12/10/13.
//  Copyright (c) 2013 GIDEON ROSENTHAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSData *allPosts;
@property (nonatomic, strong) NSMutableArray *placeImages;
@property (nonatomic, strong) NSString *currentLink;
@property (nonatomic, strong) NSArray *jsonResults;

- (IBAction)twitterButtonTapped:(id)sender;

- (IBAction)redditButtonPressed:(id)sender;



@end
