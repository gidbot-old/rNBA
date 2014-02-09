//
//  WebViewController.m
//  tableViewPromo
//
//  Created by GIDEON ROSENTHAL on 1/8/14.
//  Copyright (c) 2014 GIDEON ROSENTHAL. All rights reserved.
//

#import "WebViewController.h"
#import "ViewController.h"
#import <Social/Social.h>

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize urlName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc] initWithString:urlName];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];

    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
}

- (IBAction)twitterButtonTapped:(id)sender {

    NSString *urlRequest = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", urlName];
    
    NSURLRequest *myR = [NSURLRequest requestWithURL:[NSURL URLWithString:urlRequest]];
    NSError *error;
    NSURLResponse *myResponse;
    NSData *urlData = [NSURLConnection sendSynchronousRequest: myR returningResponse:&myResponse error:&error];
    
    NSString *tinyString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *toPost = [NSString stringWithFormat:@"%@ #rNBA #SlashNBA", tinyString];
    [tweetSheet setInitialText:toPost];
    [self presentViewController:tweetSheet animated:YES completion:nil];

}
@end
