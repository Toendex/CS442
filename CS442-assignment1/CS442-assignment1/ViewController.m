//
//  ViewController.m
//  CS4420-assignment1
//
//  Created by T on 2/28/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "ViewController.h"
#import "ConvertLogic.h"

@interface ViewController ()

@end

@implementation ViewController  {
    int t2bORb2t;    //0=t2b;1=b2t
    NSMutableArray *TBText;
    NSMutableArray *TTFText;
    NSMutableArray *BTFText;
    NSString *tempString;
    NSMutableArray *convert;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self->t2bORb2t=0;
    NSArray *zna=@[@"⇟",@"⇞"];
    self->TBText=[zna mutableCopy];
    zna=@[@"℉",@"Miles",@"Gallons"];
    self->TTFText=[zna mutableCopy];
    zna=@[@"℃",@"Kilometers",@"Liters"];
    BTFText=[zna mutableCopy];
    [self setTexts];
    
    self->convert=[[NSMutableArray alloc] init];
    [convert addObject:^double(double value)
     {
         return (value-32)*5/9;
     }];
    [convert addObject:^double(double value)
     {
         return value*9/5+32;
     }];
    [convert addObject:^double(double value)
     {
         return value/0.62137;
     }];
    [convert addObject:^double(double value)
     {
         return value*0.62137;
     }];
    [convert addObject:^double(double value)
     {
         return value/0.264172051242;
     }];
    [convert addObject:^double(double value)
     {
         return value*0.264172051242;
     }];
}

- (void)setTexts {
//    [self->TTFText replaceObjectAtIndex:1 withObject:NSLocalizedString(@"Miles", nil)];
//    [self->TTFText replaceObjectAtIndex:2 withObject:NSLocalizedString(@"Gallons", nil)];
//    [self->BTFText replaceObjectAtIndex:1 withObject:NSLocalizedString(@"Kilometers", nil)];
//    [self->BTFText replaceObjectAtIndex:2 withObject:NSLocalizedString(@"Liters", nil)];
    self->TTFText[1]=NSLocalizedString(@"Miles", nil);
    self->TTFText[2]=NSLocalizedString(@"Gallons", nil);
    self->BTFText[1]=NSLocalizedString(@"Kilometers", nil);
    self->BTFText[2]=NSLocalizedString(@"Liters", nil);
    if (-1<t2bORb2t && t2bORb2t<2)
        [self.UBbutton setTitle:TBText[t2bORb2t] forState:(UIControlStateNormal)];
    NSInteger n=[self transType].selectedSegmentIndex;
    self.topLabel.text=TTFText[n];
    self.botLabel.text=BTFText[n];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) doTrans {
    double t=[self.topField.text doubleValue];
    double b=[self.botField.text doubleValue];
    double z;
    NSInteger n=[self transType].selectedSegmentIndex;
    double (^actConver) (double)=self->convert[n*2+self->t2bORb2t];
    if(self->t2bORb2t==0) {
        z=actConver(t);
        self.botField.text=[NSString stringWithFormat:@"%.2lf",z];
    }
    else {
        z=actConver(b);
        self.topField.text=[NSString stringWithFormat:@"%.2lf",z];
    }
//    if(n==0) {
//        if(self->t2bORb2t==0) {
//            z=(t-32)*5/9;
//            self.botField.text=[NSString stringWithFormat:@"%.2lf",z];
//        }
//        else if(self->t2bORb2t==1) {
//            z=b*9/5+32;
//            self.topField.text=[NSString stringWithFormat:@"%.2lf",z];
//        }
//    }
//    else if(n==1) {
//        if(self->t2bORb2t==0) {
//            z=t/0.62137;
//            self.botField.text=[NSString stringWithFormat:@"%.2lf",z];
//        }
//        else if(self->t2bORb2t==1) {
//            z=b*0.62137;
//            self.topField.text=[NSString stringWithFormat:@"%.2lf",z];
//        }
//    }
//    else if(n==2) {
//        if(self->t2bORb2t==0) {
//            z=t/0.264172051242;
//            self.botField.text=[NSString stringWithFormat:@"%.2lf",z];
//        }
//        else if(self->t2bORb2t==1) {
//            z=b*0.264172051242;
//            self.topField.text=[NSString stringWithFormat:@"%.2lf",z];
//        }
//    }
}

- (IBAction)convertButtonTapped:(id)sender {
    [self doTrans];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)changeTransType:(UISegmentedControl *)sender {
    [self setTexts];
    [self doTrans];
}

- (IBAction)TBButtonTapped:(id)sender {
    self->t2bORb2t=((self->t2bORb2t)+1)%2;
    [self setTexts];
}

- (IBAction)topFieldTextChanged:(id)sender {
    [self doTrans];
}

- (IBAction)botFieldChanged:(id)sender {
    [self doTrans];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
  //  self->tempString=textField.text;
    textField.text=@"";
    if (textField==self.topField) {
        self->t2bORb2t=0;
    }
    else if (textField==self.botField) {
        self->t2bORb2t=1;
    }
    [self setTexts];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.topField resignFirstResponder];
    [self.botField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
//    if ([textField.text isEqualToString:@""]) {
//        textField.text=self->tempString;
//    }
}

@end
