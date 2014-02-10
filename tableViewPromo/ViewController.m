//
//  ViewController.m
//  tableViewPromo
//
//  Created by GIDEON ROSENTHAL on 12/10/13.
//  Copyright (c) 2013 GIDEON ROSENTHAL. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "PostCell.h"
#import <Social/Social.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface ViewController ()

@end

@implementation ViewController
@synthesize allPosts, placeImages, currentLink, jsonResults, modHash, myTableView, userName;

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.myTableView setContentInset:UIEdgeInsetsMake(8,0,0,0)];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:self.refreshControl];
  
  
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://reddit.com/r/nba/.json"]];
    
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    jsonResults = [[json objectForKey: @"data"] objectForKey: @"children"];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *post = [jsonResults[indexPath.row] objectForKey:@"data"];
    NSString *currentPostName = [post  objectForKey:@"title"];


    CGRect expectedFrame = [currentPostName boundingRectWithSize:CGSizeMake(tableView.frame.size.width -72, 9999)
                                                    options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                 attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIFont fontWithName:@"Futura" size:19], NSFontAttributeName,
                                                             nil]
                                                    context:nil];
  
    return MAX([UIImage upArrowImage].size.height * 2 + 8, expectedFrame.size.height - 8);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [jsonResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(nil == myCell){
        myCell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
  
    myCell.delegate = self;
    NSDictionary *post = [jsonResults[indexPath.row] objectForKey:@"data"];
    NSString *currentPostID = [post  objectForKey:@"name"];
    NSLog(@"Post Name: %@", currentPostID);
  
    myCell.postName = currentPostID;
    myCell.modHash = modHash;
  
    NSString *currentPostName = [post  objectForKey:@"title"];
  
  
    [[myCell textLabel] setText:currentPostName];
    NSDictionary *postTest = jsonResults[25];
    if (postTest && indexPath.row == 0){
        //imagePath = placeImages[4];
    } else {
        //imagePath = placeImages[indexPath.row];
    }
  
    return myCell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    NSDictionary *post = [jsonResults[indexPath.row] objectForKey:@"data"];
    currentLink = [post  objectForKey:@"url"];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier: @"pushToWebView" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"pushToWebView"]) {
        WebViewController *transferViewController = segue.destinationViewController;
        transferViewController.urlName = currentLink;
    }
  
}


- (IBAction)handleRefresh:(id)sender {
  [self.myTableView reloadData];
  [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)twitterButtonTapped:(id)sender {
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"#rNBA #SlashNBA"];
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}

- (IBAction)redditButtonPressed:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Reddit Login" message:@"Enter Username & Password:" delegate:self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Login", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Username";
    UITextField * alertTextField2 = [alert textFieldAtIndex:1];
    alertTextField2.keyboardType = UIKeyboardTypeDefault;
    alertTextField2.placeholder = @"Password";
    [alert show];
      //[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1)
  {
    UITextField *username = [alertView textFieldAtIndex:0];
    NSLog(@"username: %@", username.text);
    
    UITextField *password = [alertView textFieldAtIndex:1];
    NSLog(@"password: %@", password.text);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"user": username.text, @"passwd":password.text, @"api_type":@"json"};
    [manager POST:@"https://ssl.reddit.com/api/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      NSDictionary *errors = responseObject[@"json"][@"errors"];
      NSDictionary *data = responseObject[@"json"][@"data"];
      modHash = responseObject[@"json"][@"data"][@"modhash"];
      
      //NSLog(@"Response: %@", responseObject);
      //NSLog(@"Data: %@", data);
      NSLog(@"Mod: %@", modHash);
      
      if ([errors count]!=0){
          UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid Login. Please Try Again." delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
        
        NSLog(@"Error: %@", errors);

      } else {
        userName = username.text;
        int test = [self getVoteStatus];
        [self.myTableView reloadData];
      }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
      
    }];
  
  }
}

- (int) getVoteStatus {
  NSString *thisUrl = [NSString stringWithFormat: @"http://reddit.com/user/%@/liked.json", userName];
  NSLog(@"Url Test, %@", thisUrl);
  NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString: thisUrl]];
  

  NSError* error;
  
  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
  jsonResults = [[json objectForKey: @"data"] objectForKey: @"children"];
  //NSArray *jsonResults2 = [[json objectForKey: @"data"] objectForKey: @"children"];
  
  NSLog(@"Likes: %@", jsonResults);
  
  return NULL;

}


@end
