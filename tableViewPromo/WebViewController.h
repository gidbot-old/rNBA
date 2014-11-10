//
//  WebViewController.h
//  tableViewPromo
//
//  Created by GIDEON ROSENTHAL on 1/8/14.
//  Copyright (c) 2014 GIDEON ROSENTHAL. All rights reserved.
//


@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *urlName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) IBOutlet UITableView *tableView;


- (IBAction)twitterButtonTapped:(id)sender;

@end
