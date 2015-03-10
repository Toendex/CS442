//
//  MyTableViewController.m
//  CS442-assignment4
//
//  Created by T on 5/8/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "MyTableViewController.h"
#import "GameViewController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController {
    NSArray *_sectionTitles;
    GameModel *_gameModel;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate=self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self theInitialize];
    if (![PFUser currentUser]) {
        [self showLogin];
    } else {
        [self doRefreshData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self doRefreshTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)theInitialize
{
    _sectionTitles=[NSMutableArray arrayWithArray:@[@"YOUR TURN", @"THEIR TURN", @"AVAILABLE GAMES", @"ENDED GAMES", @"", @"", @""]];
    _gameModel=[[GameModel alloc] init];
}

-(void)doRefreshData
{
    [_gameModel doQueryInBackground:^{
        [self doRefreshTableView];
    }];
}

-(void)doRefreshTableView
{
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Login && Signup

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user
{
    [_gameModel removeAll];
    [self doRefreshTableView];
    [self doRefreshData];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [_gameModel removeAll];
    [self doRefreshTableView];
    [self doRefreshData];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showLogin
{
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    logInController.fields = PFLogInFieldsUsernameAndPassword
    //                                | PFLogInFieldsPasswordForgotten
    | PFLogInFieldsLogInButton
    | PFLogInFieldsSignUpButton;
    logInController.signUpController=[[PFSignUpViewController alloc] init];
    logInController.signUpController.delegate = self;
    logInController.signUpController.fields = PFSignUpFieldsUsernameAndPassword
    | PFSignUpFieldsSignUpButton
    //                                                | PFSignUpFieldsEmail
    | PFSignUpFieldsDismissButton;
    [self presentViewController:logInController animated:YES completion:nil];
}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    [self showLogin];
}

- (IBAction)addNewGame:(id)sender {
    Game *game=[_gameModel getAvailableGame];
    if(game!=nil) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:2];
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self performSegueWithIdentifier:@"ASegue" sender:cell];
    }
    else {
        Game *newGame=[[Game alloc]initWithRows:6 cols:7 isFirstPlayer:YES];
    //    [_gameModel addNewGame:newGame ifFirstPlayer:YES];
    //    [self doRefreshTableView];
        [newGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self doRefreshData];
        }];
    }
}

- (IBAction)pullToRefresh:(id)sender {
    [_gameModel doQueryInBackground:^{
        [self doRefreshTableView];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section>=[_gameModel numOfArrays])
        return 0;
    return [_gameModel countOfArray:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [tableView rowHeight];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 15, 320, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:21];
    label.text = sectionTitle;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [view addSubview:label];
    
    return view;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    // Configure the cell...
    Game *game=[_gameModel objectAtIndexPath:indexPath];
    NSInteger section=[indexPath section];
    if(section==0 || section==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCell" forIndexPath:indexPath];
        TTableViewCell *zcell=(TTableViewCell *)cell;
        [zcell doInitWithGame:game];
    }
    else if(section==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ACell" forIndexPath:indexPath];
        ATableViewCell *zcell=(ATableViewCell *)cell;
        [zcell doInitWithGame:game];
    }
    else if(section==3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ECell" forIndexPath:indexPath];
        ETableViewCell *zcell=(ETableViewCell *)cell;
        [zcell doInitWithGame:game];
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GameViewController *gameViewController=(GameViewController *)[segue destinationViewController];
    NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
    gameViewController.game=[_gameModel objectAtIndexPath:indexPath];
}

#pragma mark - UINavigationControllerDelegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    if(toVC==self) {
        if([fromVC isKindOfClass:[GameViewController class]]) {
            GameViewController *gameViewController=(GameViewController *)fromVC;
            if(gameViewController.didStep) {
                if(indexPath.section==2) {
                   assert( [gameViewController.game joinToGame:[PFUser currentUser]]==YES );
                }
                [gameViewController.game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [self doRefreshData];
                }];
            }
            
        }
    }
    return nil;
}

@end
