//
//  CollectionViewController.m
//  CS442-final
//
//  Created by T on 3/31/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "PostModel.h"
#import "CollectionViewFlowLayout.h"
#import "ImageViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController {
    CGRect screenBounds;
    PostModel *postModel;
    CollectionViewFlowLayout *cvfl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"pCell"];
    if (![PFUser currentUser]) {
        [self showLogin];
    } else {
        [self theInitialize];
    }
}

-(void)theInitialize
{
    self.tabBarController.tabBar.hidden=NO;
    postModel=[PostModel sharedSingleton];
    cvfl=[[CollectionViewFlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout:cvfl];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note){
                                                      [self.collectionView reloadData];
//                                                      [cvfl invalidateLayout];
                                                  }];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(doRefresh)
      forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refresh];
    [self setRefreshControl:refresh];
    self.collectionView.alwaysBounceVertical = YES;
}

-(void)doReload
{
    [postModel readPosts];
    [cvfl refresh];
    if (![PFUser currentUser]) {
        [self showLogin];
    } else {
        ;
    }
}

-(void)doRefresh
{
    [postModel readPosts];
    [cvfl refresh];
    [self.refreshControl endRefreshing];
    [self.collectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    screenBounds=self.collectionView.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowPost"]) {
        ImageViewController *ivc=((ImageViewController*)[segue destinationViewController]);
        [ivc setPost:[postModel postAtIndex:[self.collectionView indexPathForCell:(UICollectionViewCell *)sender].row]];
    }
}


#pragma mark - UICollectionView Datasource


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [postModel count];
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];

    UIImage *image=[[postModel postAtIndex:indexPath.row].imgs objectAtIndex:0];
    CGSize size=[cvfl sizeOfCellAtIndexPath:indexPath];
    UIImageView *imageView;
    imageView = [[UIImageView alloc] initWithImage:image];
    screenBounds=self.collectionView.bounds;
    double width=size.width;
    double height=size.height;
    imageView.frame=CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, width, height);
    for (UIView *subview in [cell subviews])
        if ([subview isKindOfClass:[UIImageView class]])
            [subview removeFromSuperview];
    [cell addSubview:imageView];

//    NSLog(@"%d, %d", indexPath.section, indexPath.row);
//    NSLog(@"subviews: %d", [cell.subviews count]);
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [[UICollectionReusableView alloc] init];
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
//    [imgs removeObjectAtIndex:indexPath.row];
//    NSArray *deletions = @[indexPath];
//    [self.collectionView deleteItemsAtIndexPaths:deletions];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    screenBounds=self.collectionView.bounds;
//    UIImage *image=[imgs imageAtIndex:indexPath.row];
//    double width=screenBounds.size.width/2-1;
//    double height=image.size.height*width/image.size.width;
//    CGSize size=CGSizeMake(width, height);
//    return size;
    CGSize size=[cvfl sizeOfCellAtIndexPath:indexPath];
    return size;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}


#pragma mark - Login & Signup

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user
{
    [self theInitialize];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self theInitialize];
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
    MyLogInViewController *logInController = [[MyLogInViewController alloc] init];
    logInController.delegate = self;
    logInController.fields = PFLogInFieldsUsernameAndPassword
    //                                | PFLogInFieldsPasswordForgotten
    | PFLogInFieldsLogInButton
    | PFLogInFieldsSignUpButton;
    logInController.signUpController=[[MySignUpViewController alloc] init];
    logInController.signUpController.delegate = self;
    logInController.signUpController.fields = PFSignUpFieldsUsernameAndPassword
    | PFSignUpFieldsSignUpButton
    //                                                | PFSignUpFieldsEmail
    | PFSignUpFieldsDismissButton;
    [self presentViewController:logInController animated:NO completion:nil];
}

@end
