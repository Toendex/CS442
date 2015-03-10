//
//  SingleTableViewController.m
//  CS442-assignment2
//
//  Created by T on 3/25/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "SingleTableViewController.h"

@interface SingleTableViewController ()

@end

@implementation SingleTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tabBarController.delegate=self;
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _model=[ConModel sharedSingleton:@"data"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_model numOfCategories];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_model numOfUnits:section];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_model getCategoryName:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCell" forIndexPath:indexPath];
    ((UILabel*)[cell viewWithTag:11]).text=[_model getUnitName:indexPath.row ofCategory:indexPath.section];
    ((UITextField*)[cell viewWithTag:10]).text=
        [NSString stringWithFormat:@"%.4f", [_model getUnitValue:indexPath.row ofCategory:indexPath.section]];
    ((UITextField*)[cell viewWithTag:10]).delegate=self;
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
    [self.tableView reloadData];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    id cell=[[[textField superview] superview] superview];
    NSIndexPath *ip=[[self tableView] indexPathForCell:(UITableViewCell*)cell];
    [self reloadAllBut:ip];
    textField.text=@"";
}

- (void)reloadAllBut:(NSIndexPath *)ip {
    NSMutableArray *ips=[[NSMutableArray alloc] init];
    for (int j=0; j<[self.tableView numberOfSections]; j++) {
        for (int i=0; i<[self.tableView numberOfRowsInSection:j]; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:j];
            if (indexPath.row!=ip.row)
                [ips addObject:indexPath];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:ips withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadAllBut:(NSIndexPath *)ip inSection:(NSInteger)section {
    NSMutableArray *ips=[[NSMutableArray alloc] init];
    for (int i=0; i<[self.tableView numberOfRowsInSection:section]; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:section];
        if (indexPath.row!=ip.row)
            [ips addObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:ips withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)textFieldChanged:(id)sender {
    double value=[((UITextField*)sender).text doubleValue];
    id cell=[[[sender superview] superview] superview];
    NSIndexPath *ip=[[self tableView] indexPathForCell:(UITableViewCell*)cell];
    [[self model] changeValue:value ofIndex:ip.row OfCategory:ip.section];
    [self reloadAllBut:ip inSection:ip.section];
}

- (IBAction)doneTapped:(id)sender {
    [self.tableView reloadData];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController respondsToSelector:@selector(tableView)])
        [[viewController performSelector:@selector(tableView)] reloadData];
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        NSArray * viewStack=((UINavigationController *)viewController).viewControllers;
        id view=[viewStack objectAtIndex:viewStack.count-1];
        if ([view respondsToSelector:@selector(tableView)])
            [[view performSelector:@selector(tableView)] reloadData];
    }
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

@end
