//
//  DetailViewController.m
//  CS442-assignment2
//
//  Created by T on 3/14/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@end

@implementation DetailViewController {
    id currentFirstResponder;
}

#pragma mark - Managing the detail item

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    currentFirstResponder=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_model numOfUnits:_index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DCell" forIndexPath:indexPath];
    ((UILabel*)[cell viewWithTag:11]).text=[_model getUnitName:indexPath.row ofCategory:_index];
    ((UITextField*)[cell viewWithTag:10]).text=
        [NSString stringWithFormat:@"%.4f",[_model getUnitValue:indexPath.row ofCategory:_index]];
    ((UITextField*)[cell viewWithTag:10]).delegate=self;
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
 //   [textField resignFirstResponder];
    [self.tableView reloadData];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    id cell=[[[textField superview] superview] superview];
    NSIndexPath *ip=[[self tableView] indexPathForCell:(UITableViewCell*)cell];
    [self reloadAllBut:ip];
    textField.text=@"";
    currentFirstResponder=textField;
}

- (void)reloadAllBut:(NSIndexPath *)ip {
    NSMutableArray *ips=[[NSMutableArray alloc] init];
    for (int j=0; j<[self.tableView numberOfSections]; j++) {
        for (int i=0; i<[self.tableView numberOfRowsInSection:j]; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:j];
            if (indexPath.row!=ip.row || indexPath.section!=ip.section)
                [ips addObject:indexPath];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:ips withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)textFieldChanged:(id)sender {
    double value=[((UITextField*)sender).text doubleValue];
    id cell=[[[sender superview] superview] superview];
    NSIndexPath *ip=[[self tableView] indexPathForCell:(UITableViewCell*)cell];
    [[self model] changeValue:value ofIndex:ip.row OfCategory:_index];
    [self reloadAllBut:ip];
}

- (IBAction)doneTapped:(id)sender {
    [self.tableView reloadData];
}

@end
