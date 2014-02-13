//
//  ViewController.m
//  tableViewPromo
//
//  Created by GIDEON ROSENTHAL on 12/10/13.
//  Copyright (c) 2013 GIDEON ROSENTHAL. All rights reserved.
//

#import "Reachability.h"
#import "ViewController.h"
#import "WebViewController.h"
#import "PostCell.h"
#import "PostObject.h"
#import <Social/Social.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface ViewController ()

@end

@implementation ViewController
@synthesize allPosts, placeImages, currentLink, jsonResults, modHash, myTableView, userName, postsCollection;

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  [[UIView appearance] setTintColor: nil];
  

  
    [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.myTableView setContentInset:UIEdgeInsetsMake(8,0,0,0)];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:self.refreshControl];
  
 
  
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];

  if (networkStatus != NotReachable) {
  //if(true == false){
      NSError* error;
      NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://reddit.com/r/nba/.json"]];

      NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      jsonResults = [[json objectForKey: @"data"] objectForKey: @"children"];
      postsCollection = [[NSMutableArray alloc] initWithCapacity:26];
      [self populatePostsDictionary];
    }else {
      NSLog(@"No Connection");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (postsCollection[0] == NULL){
      NSLog(@"No Height");
      return MAX([UIImage upArrowImage].size.height * 2 + 8, 0);
  }
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
  if (postsCollection[0] != NULL){
    return [jsonResults count];
  }
  else {
    return 1;
  }
}

- (void) populatePostsDictionary {
  NSLog(@"Here:");

  for (int i = 0; i <jsonResults.count; i++){
    PostObject *thisPost = [[PostObject alloc] init];
    
    NSDictionary *post = [jsonResults[i] objectForKey:@"data"];
    thisPost.postId = [post  objectForKey:@"name"];
    thisPost.postTitle = [post  objectForKey:@"title"];
    
    thisPost.position = i;
    thisPost.status = 0;
    
    [postsCollection addObject:thisPost];
    NSLog(@"Here: %@", thisPost.description);
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (postsCollection[0] == NULL){
    UITableViewCell *blankCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    return blankCell;
  }
    PostCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PostObject *currentObject = postsCollection[indexPath.row];
  
    if(nil == myCell){
        myCell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
  
    myCell.delegate = self;

    NSString *currentPostID = currentObject.postId;
    NSString *currentPostTitle = currentObject.postTitle;
  
    myCell.postId = currentPostID;
    myCell.modHash = modHash;
  
  switch (currentObject.status) {
    case -1:
      [myCell.upArrow setSelected:NO];
      [myCell.downArrow setSelected:YES];
      break;
    case 1:
      [myCell.upArrow setSelected:YES];
      [myCell.downArrow setSelected:NO];
      break;
    default:
      [myCell.upArrow setSelected:NO];
      [myCell.downArrow setSelected:NO];
      break;
  }
  
  
    [[myCell textLabel] setText:currentPostTitle];
    myCell.textLabel.font = [UIFont fontWithName:@"Verdana" size:19];

    NSDictionary *postTest = jsonResults[25];
    if (postTest && indexPath.row == 0){
        //imagePath = placeImages[4];
    } else {
        //imagePath = placeImages[indexPath.row];
    }
  
    return myCell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
  if (postsCollection[0] != NULL){

    NSDictionary *post = [jsonResults[indexPath.row] objectForKey:@"data"];
    currentLink = [post  objectForKey:@"url"];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier: @"pushToWebView" sender: self];

  }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"pushToWebView"]) {
        WebViewController *transferViewController = segue.destinationViewController;
        transferViewController.urlName = currentLink;
    }
  
}


- (IBAction)handleRefresh:(id)sender {
  Reachability *reachability = [Reachability reachabilityForInternetConnection];
  NetworkStatus networkStatus = [reachability currentReachabilityStatus];
  
  if(postsCollection[0] == NULL && networkStatus != NotReachable){
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://reddit.com/r/nba/.json"]];
    
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    jsonResults = [[json objectForKey: @"data"] objectForKey: @"children"];
    postsCollection = [[NSMutableArray alloc] initWithCapacity:26];
    [self populatePostsDictionary];
  }
  
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

-(void) statusChanged:(NSInteger)status forPostWithId:(NSString *)postId{
  for (int i = 0; i < postsCollection.count; i++){
    PostObject *check = postsCollection[i];
    if (check.postId == postId){
      check.status = status;
      postsCollection[i] = check;
      break;
    }
  }
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
        //int test = [self getVoteStatus];
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
