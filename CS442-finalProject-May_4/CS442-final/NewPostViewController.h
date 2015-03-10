//
//  NewPostViewController.h
//  CS442-final
//
//  Created by T on 4/2/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ImageCollectionCell.h"
#import "MBProgressHUD.h"

@interface NewPostViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MBProgressHUDDelegate, PostDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *lowestLvView;


@property (strong, atomic) Post *post;

- (IBAction)openCamera:(id)sender;
- (IBAction)openPhotoLib:(id)sender;
- (IBAction)postToServer:(id)sender;

@end
