//
//  ViewController.m
//  CS442-assignment3
//
//  Created by T on 5/6/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController {
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    _didStep=NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.
    _gameView=[[ConnectFourView alloc]initWithFrame:self.view.bounds rows:6 cols:7 slotDiameter:30];
    _gameView.delegate=self;
    [self.view addSubview:_gameView];
    [self doSteps];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doSteps
{
    NSArray *gameMatrix=[self.game gameMatrix];
    for(int r=0;r<6;r++) for(int c=0;c<7;c++) {
        int turn=[[[gameMatrix objectAtIndex:r] objectAtIndex:c] intValue];
        if(turn!=1 && turn!=2)
            continue;
        CGColorRef color=(turn==1)?([UIColor redColor].CGColor):([UIColor yellowColor].CGColor);
        [_gameView addToColumn:c row:r withColor:color withAnimate:NO];
    }
}


#pragma mark - ConnectFourDelegate

-(void)columnTapped:(NSUInteger)column
{
    int nowTurn=[_game nowTurn];
    int newRowIndex=[_game addPieceToColumn:column usr:[PFUser currentUser]];
    if(newRowIndex==-1) {
        return;
    }
    _didStep=YES;
    NSUInteger row=newRowIndex;
    CGColorRef color=(nowTurn==1)?([UIColor redColor].CGColor):([UIColor yellowColor].CGColor);
    [_gameView addToColumn:column row:row withColor:color withAnimate:YES];
}

-(void)didEndMove
{
    if([_game ifEnd]) {
        UIAlertView *alert;
        if([_game winner]==1 || [_game winner]==2) {
//            NSLog(@"%d",[_game winner]);
//            NSLog(@"%@, %@",[[_game player:[_game winner]] objectId],[[PFUser currentUser] objectId]);
//            assert([[[_game player:[_game winner]] objectId] isEqualToString:[[PFUser currentUser] objectId]]);
            alert=[[UIAlertView alloc]initWithTitle:@"Game End" message:[NSString stringWithFormat:@"Congratulations! You won!"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        }
        else {
            alert=[[UIAlertView alloc]initWithTitle:@"Game End" message:@"Nobody won!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        }
        alert.delegate=self;
        [alert show];
    }
}

//#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [_gameView reset];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
