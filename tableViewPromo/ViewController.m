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
@synthesize allPosts, placeImages, currentLink, currentTitle, jsonResults, modHash, myTableView, userName, postsCollection, topImage, topText, cellHeight;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    cellHeight = 70;
    [[UIView appearance] setTintColor: nil];
    [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.myTableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:self.refreshControl];
    
    
    //Allow for swipe left to WebView
    /*
     UISwipeGestureRecognizer * swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
     [swipeRecognizer setDelegate:self];
     [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
     [self.myTableView addGestureRecognizer:swipeRecognizer];
     */
    
    [self.myTableView registerClass:[PostCell class] forCellReuseIdentifier:@"cell"];
    
    [self populateTable];
}

- (void) populateTable{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus != NotReachable) {
        NSError* error;
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://reddit.com/r/nba/.json"]];
        
        //stylesheet info
        NSData* imageAPI = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://54.183.35.108/rnba/index.php?r=site/getCurrent"]];
        NSDictionary* imageDict = [NSJSONSerialization JSONObjectWithData:imageAPI options:kNilOptions error:&error];
        
        NSString *imageUrl = [imageDict objectForKey:@"linkAddress"];
        topImage = [self getImageFromURL:imageUrl];
        //    NSLog(@" ImageUrl %@",imageUrl);
        //Get and set the Text for the Top Image
        
        NSString *imageText = [imageDict objectForKey:@"text"];
        topText = imageText;
        //    NSLog(@" ImageText %@",imageText);
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        jsonResults = [[json objectForKey: @"data"] objectForKey: @"children"];
        
        NSUInteger lastIndex = jsonResults.count -1;
        NSDictionary *post = [jsonResults[lastIndex] objectForKey:@"data"];
        NSString *id = [post  objectForKey:@"name"];
        NSString *secondUrl = [NSString stringWithFormat:@"%@%@", @"http://www.reddit.com/r/nba/.json?count=25&after=", id];
        
        NSData* secondData = [NSData dataWithContentsOfURL:[NSURL URLWithString:secondUrl]];
        NSDictionary* secondJson = [NSJSONSerialization JSONObjectWithData:secondData options:kNilOptions error:&error];
        NSArray *secondJsonResults = [[secondJson objectForKey: @"data"] objectForKey: @"children"];
        jsonResults = [jsonResults arrayByAddingObjectsFromArray:secondJsonResults];
        
        
        
        
        postsCollection = [[NSMutableArray alloc] initWithCapacity:27];
        [self populatePostsDictionary];
    }else {
        NSLog(@"No Connection");
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return (topImage != nil) ? topImage.size.height : cellHeight+8;
    }
    //NSDictionary *post = [jsonResults[indexPath.row] objectForKey:@"data"];
    //NSString *currentPostName = [post  objectForKey:@"title"];
    
    PostObject *thisPost = postsCollection[indexPath.row];
    NSString *currentPostName = thisPost.postTitle;
    
    CGRect expectedFrame = [currentPostName boundingRectWithSize:CGSizeMake(tableView.frame.size.width -72, 9999)
                                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIFont fontWithName:@"Futura" size:16], NSFontAttributeName,
                                                                  nil]
                                                         context:nil];
    
    if (expectedFrame.size.height > cellHeight+8)
        return expectedFrame.size.height + 8;
    else
        return cellHeight +8;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (postsCollection[0] != NULL){
        return ([postsCollection count]);
    }
    else {
        return 1;
    }
}

- (void) populatePostsDictionary {
    PostObject *thisPostOne = [[PostObject alloc] init];
    [postsCollection addObject:thisPostOne];
    
    NSUInteger count2 = 0;
    NSString *holdLast;
    for (int i = 0; i <jsonResults.count; i++){
        
        NSDictionary *post = [jsonResults[i] objectForKey:@"data"];
        
        if (![[post objectForKey:@"url"] containsString:@"reddit.com"]) {
            
            count2++;
            PostObject *thisPost = [[PostObject alloc] init];
            thisPost.postId = [post  objectForKey:@"name"];
            thisPost.postTitle = [post  objectForKey:@"title"];
            holdLast = thisPost.postTitle;
            
            if ([thisPost.postTitle rangeOfString:@"&amp;"].length > 0){
                NSString *hold = thisPost.postTitle;
                NSUInteger location = [hold rangeOfString:@"amp;"].location;
                NSString *front = [hold substringToIndex:location];
                NSString *back = [hold substringFromIndex:(location + 4)];
                NSString *complete = [NSString stringWithFormat:@"%@%@", front, back];
                thisPost.postTitle = complete;
            }
            
            thisPost.url = [post objectForKey:@"url"];
            
            thisPost.position = i;
            thisPost.status = 0;
            
            [postsCollection addObject:thisPost];
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (postsCollection[0] == NULL){
        UITableViewCell *blankCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        [blankCell.textLabel setText:@"Unable to Connect. Please Refresh"];
        return blankCell;
        
    } else if (indexPath.row == 0) {
        
        
        UITableViewCell *topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        UIImageView *topView = [[UIImageView alloc] initWithImage:topImage];
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenBound.size.width;
        //        CGFloat ratio = topImage.size.height / screenWidth;
        //        topView.frame = CGRectMake(0, 0, screenWidth, topImage.size.height * ratio);
        
        CGFloat distance = screenWidth - topImage.size.width;
        topView.frame = CGRectMake(distance/2, 0, topImage.size.width, topImage.size.height);
        
        
        [topCell addSubview:topView];
        
        UILabel  *xlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,320, 320, 9999)];
        xlabel.numberOfLines = 0;
        xlabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
        xlabel.text = topText;
        xlabel.font = [UIFont fontWithName:@"Futura" size:14];
        xlabel.textColor = [UIColor whiteColor];
        [topView addSubview: xlabel];
        
        [xlabel sizeToFit];
        xlabel.frame = CGRectMake(0, topView.frame.size.height - xlabel.frame.size.height, 300 , xlabel.frame.size.height);
        
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return topCell;
        
    }
    PostCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PostObject *currentObject = postsCollection[indexPath.row];
    
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
    
    //currentPostTitle = [currentPostTitle lowercaseString];
    [[myCell textLabel] setText:currentPostTitle];
    
    NSInteger holdSize = 16;
    
    myCell.textLabel.font = [UIFont fontWithName:@"Futura" size:holdSize];
    
    return myCell;
}

/*
 - (void) onSwipeLeft:(UISwipeGestureRecognizer *)recognizer
 {
 if (recognizer.state == UIGestureRecognizerStateEnded)
 {
 CGPoint swipeLocation = [recognizer locationInView:self.myTableView];
 NSIndexPath *swipedIndexPath = [self.myTableView indexPathForRowAtPoint:swipeLocation];
 // do what you want here
 
 if (postsCollection[0] != NULL && swipedIndexPath.row != 0){
 PostObject *thisPost = postsCollection[swipedIndexPath.row];
 currentLink = thisPost.url;
 [self.myTableView deselectRowAtIndexPath:swipedIndexPath animated:YES];
 [self performSegueWithIdentifier: @"pushToWebView" sender: self];
 }
 }
 }
 */
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    if (postsCollection[0] != NULL && indexPath.row != 0){
        PostObject *thisPost = postsCollection[indexPath.row];
        currentLink = thisPost.url;
        currentTitle = thisPost.postTitle;
        [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier: @"pushToWebView" sender: self];
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"pushToWebView"]) {
        WebViewController *transferViewController = segue.destinationViewController;
        transferViewController.urlName = currentLink;
        transferViewController.title = currentTitle;
    }
    
}


- (IBAction)handleRefresh:(id)sender {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus != NotReachable) {
        [self populateTable];
        [self.myTableView reloadData];
    }
    [self.refreshControl endRefreshing];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)twitterButtonTapped:(id)sender {
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"#rNBA @NBA_Reddit"];
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}

//- (IBAction)redditButtonPressed:(id)sender {
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Reddit Login" message:@"Enter Username & Password:" delegate:self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Login", nil];
//    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//    UITextField * alertTextField = [alert textFieldAtIndex:0];
//    alertTextField.keyboardType = UIKeyboardTypeDefault;
//    alertTextField.placeholder = @"Username";
//    UITextField * alertTextField2 = [alert textFieldAtIndex:1];
//    alertTextField2.keyboardType = UIKeyboardTypeDefault;
//    alertTextField2.placeholder = @"Password";
//    [alert show];
//      //[alert release];
//}

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
        //    NSLog(@"username: %@", username.text);
        
        UITextField *password = [alertView textFieldAtIndex:1];
        //    NSLog(@"password: %@", password.text);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"user": username.text, @"passwd":password.text, @"api_type":@"json"};
        [manager POST:@"https://ssl.reddit.com/api/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *errors = responseObject[@"json"][@"errors"];
            NSDictionary *data = responseObject[@"json"][@"data"];
            modHash = responseObject[@"json"][@"data"][@"modhash"];
            
            //NSLog(@"Response: %@", responseObject);
            //NSLog(@"Data: %@", data);
            //      NSLog(@"Mod: %@", modHash);
            
            if ([errors count]!=0){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid Login. Please Try Again." delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                [alert show];
                
                //        NSLog(@"Error: %@", errors);
                
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
    //  NSLog(@"Url Test, %@", thisUrl);
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString: thisUrl]];
    
    
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    jsonResults = [[json objectForKey: @"data"] objectForKey: @"children"];
    //NSArray *jsonResults2 = [[json objectForKey: @"data"] objectForKey: @"children"];
    
    //  NSLog(@"Likes: %@", jsonResults);
    
    return NULL;
    
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 80;
    if(y > h + reload_distance) {
        //    NSLog(@"load more rows");
    }
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
