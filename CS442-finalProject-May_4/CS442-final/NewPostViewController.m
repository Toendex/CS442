//
//  NewPostViewController.m
//  CS442-final
//
//  Created by T on 4/2/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "NewPostViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

@interface NewPostViewController ()

@end

@implementation NewPostViewController {
    UICollectionViewFlowLayout *layout;
    MBProgressHUD *HUD;
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
//    self.tabBarController.tabBar.hidden=YES;
    _post=[[Post alloc] init];
    _post.delegate=self;
    layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    [_imageCollection setCollectionViewLayout:layout];
//    CGSize size=CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
//    _scrollView=[[UIScrollView alloc] init];
//    _scrollView.contentSize=size;
//    _scrollView.minimumZoomScale=1;
//    _scrollView.maximumZoomScale=1;
//    _scrollView.frame=self.view.frame;
//    [_scrollView addSubview:self.view];
//    self.view=_scrollView;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapBegin)];
    [self.lowestLvView addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Pick Images

- (IBAction)openCamera:(id)sender {
    BOOL ifHavCamera=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if(!ifHavCamera) {
        NSLog(@"No camera avaliable");
        return;
    }
    UIImagePickerController *camera=[[UIImagePickerController alloc] init];
    camera.sourceType=UIImagePickerControllerSourceTypeCamera;
    camera.delegate=self;
    [self presentViewController:camera animated:YES completion:nil];
}

- (IBAction)openPhotoLib:(id)sender {
    BOOL ifHavPhotoLib=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    UIImagePickerController *photoLib=[[UIImagePickerController alloc] init];
    photoLib.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    photoLib.delegate=self;
    [self presentViewController:photoLib animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType=info[UIImagePickerControllerMediaType];
    UIImage *originalImage;
    UIImage *editedImage;
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)== kCFCompareEqualTo) {//if it's an image
        editedImage = (UIImage *) info[UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
        if (editedImage) {
            [_post addImage:editedImage];
        } else {
            [_post addImage:originalImage];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_imageCollection reloadData];
    [_imageCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[_post imageCount]-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

#pragma mark - Post To Server

- (IBAction)postToServer:(id)sender {
    if([_post imageCount]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Reject" message:@"Please add some image." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    PFUser *user = [PFUser currentUser];
    _post.user=user;
    _post.date=[NSDate date];
    _post.title=self.titleField.text;
    _post.contentText=self.contentTextField.text;

    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Posting";
    [HUD show:YES];
    
    [_post doPost];
}

#pragma mark - UICollectionView Datasource


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_post imageCount];
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ICell" forIndexPath:indexPath];
    cell.imageView.image=[_post imageAtIndexPath:indexPath];
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

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size=CGSizeMake(70, 70);
    return size;
}

#pragma mark - UITextFieldDelegate/UITextViewDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void)singleTapBegin
{
    [self.titleField resignFirstResponder];
    [self.contentTextField resignFirstResponder];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.titleField resignFirstResponder];
//    [self.contentTextField resignFirstResponder];
//}


#pragma mark - PostDelegate

-(void)didEndPost
{
    [HUD hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setProgress:(float)percentDone
{
    HUD.progress = percentDone;
}

@end
