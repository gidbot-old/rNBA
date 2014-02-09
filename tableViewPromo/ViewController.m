//
//  ViewController.m
//  tableViewPromo
//
//  Created by GIDEON ROSENTHAL on 12/10/13.
//  Copyright (c) 2013 GIDEON ROSENTHAL. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import <Social/Social.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface ViewController ()

@end

@implementation ViewController
@synthesize allPosts, placeImages, currentLink, jsonResults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *imagePath1 = [[NSBundle mainBundle] pathForResource:@"number1.1" ofType:@"png"];
    NSString *imagePath2 = [[NSBundle mainBundle] pathForResource:@"number2" ofType:@"png"];
    NSString *imagePath3 = [[NSBundle mainBundle] pathForResource:@"number3" ofType:@"png"];
    NSString *imagePath4 = [[NSBundle mainBundle] pathForResource:@"number4" ofType:@"png"];
    NSString *imagePath5 = [[NSBundle mainBundle] pathForResource:@"number5" ofType:@"png"];
    NSString *imagePath6 = [[NSBundle mainBundle] pathForResource:@"number6" ofType:@"png"];
    NSString *imagePath7 = [[NSBundle mainBundle] pathForResource:@"number7" ofType:@"png"];
    NSString *imagePath8 = [[NSBundle mainBundle] pathForResource:@"number8" ofType:@"png"];
    NSString *imagePath9 = [[NSBundle mainBundle] pathForResource:@"number9" ofType:@"png"];
    placeImages = [[NSMutableArray alloc] initWithObjects:imagePath1, imagePath2,imagePath3, imagePath4,imagePath5, imagePath6,imagePath7, imagePath8,
                   imagePath9, imagePath1, imagePath2,imagePath3, imagePath4,imagePath5, imagePath6,imagePath7, imagePath8,
                   imagePath9, imagePath1,imagePath2, imagePath3,imagePath4, imagePath5,imagePath6, imagePath7, imagePath8, nil];
    
        
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
    return MAX(45, expectedFrame.size.height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [jsonResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(nil == myCell){
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *post = [jsonResults[indexPath.row] objectForKey:@"data"];

    NSString *currentPostName = [post  objectForKey:@"title"];

    [[myCell textLabel] setText:currentPostName];
    NSDictionary *postTest = jsonResults[25];
    NSString *imagePath = NULL;
    if (postTest && indexPath.row == 0){
        imagePath = placeImages[4];
    } else {
        imagePath = placeImages[indexPath.row];
    }

    UIImage *numberImage = [UIImage imageWithContentsOfFile:imagePath];
    myCell.imageView.image = numberImage;
    
    [myCell textLabel].font = [UIFont fontWithName:@"Futura" size:17];

    [myCell textLabel].numberOfLines =0;
    [[myCell textLabel] sizeToFit];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
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
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Reddit Login" message:@"Please enter your username and password:" delegate:self cancelButtonTitle: nil otherButtonTitles:@"Login", @"Cancel", nil];
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

@end
