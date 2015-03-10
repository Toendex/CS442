//
//  ViewController.h
//  CS4420-assignment1
//
//  Created by T on 2/28/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *topField;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UITextField *botField;
@property (weak, nonatomic) IBOutlet UILabel *botLabel;
@property (weak, nonatomic) IBOutlet UIButton *UBbutton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transType;

- (IBAction)convertButtonTapped:(id)sender;
- (void)doTrans;
- (IBAction)changeTransType:(UISegmentedControl *)sender;
- (IBAction)TBButtonTapped:(id)sender;
- (IBAction)topFieldTextChanged:(id)sender;
- (IBAction)botFieldChanged:(id)sender;

@end
