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
@synthesize title;

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
    
    NSLog(@"Button Tapped");
    
    NSString *urlRequest = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", urlName];
    
    NSURLRequest *myR = [NSURLRequest requestWithURL:[NSURL URLWithString:urlRequest]];
    NSError *error;
    NSURLResponse *myResponse;
    NSData *urlData = [NSURLConnection sendSynchronousRequest: myR returningResponse:&myResponse error:&error];
    
    NSString *tinyString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSString *toPost = [NSString stringWithFormat:@"%@ #rNBA @NBA_Reddit", tinyString];
    
    NSUInteger linkLength = [toPost length];
    NSUInteger goal = 140 - linkLength - 3;
    NSUInteger titleLength = [title length];
    
    if (titleLength > goal) {
        title = [title substringToIndex:goal-3];
        title = [NSString stringWithFormat:@"%@%@", title, @"..."];
    }
    toPost = [NSString stringWithFormat:@"%@%@%@ %@", @"\"", title, @"\"", toPost];
    
    [tweetSheet setInitialText:toPost];
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}


//flag method
-(void)needIos6Landscape {
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
