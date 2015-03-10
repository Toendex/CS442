//
//  ViewController.m
//  CS442-assignment3
//
//  Created by T on 5/6/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    GameModel *_gameModel;
    ConnectFourView *_gameView;
    NSString *_boardImagePath;
    NSString *_firstImagePath;
    NSString *_secondImagePath;
    NSTimeInterval _timeInterval;
    NSTimer *_timer;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.
    _timeInterval=3.0;
    _timer=[NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(stepRandomly) userInfo:nil repeats:NO];
    _boardImagePath=@"wooden_background.jpg";
    _firstImagePath=@"first.jpg";
    _secondImagePath=@"second.jpg";
    _gameModel=[[GameModel alloc]initWithRows:6 cols:7];
    _gameView=[[ConnectFourView alloc]initWithFrame:self.view.bounds rows:6 cols:7 slotDiameter:39 boardImagePath:_boardImagePath];
    _gameView.delegate=self;
    [self.view addSubview:_gameView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - timer

-(void)stepRandomly
{
    NSArray *avaliableColumns=[_gameModel avaliableColumns];
    if ([avaliableColumns count]==0) {
        NSLog(@"In function \"stepRandomly\": This shouldn't happened!");
        return;
    }
    NSInteger random=(arc4random()%[avaliableColumns count]);
    assert(random>=0);
    [self columnTapped:[[avaliableColumns objectAtIndex:random] unsignedIntegerValue]]; //
}

#pragma mark - ConnectFourDelegate

-(void)columnTapped:(NSUInteger)column
{
    int nowTurn=[_gameModel nowTurn];
    int newRowIndex=[_gameModel addPieceToColumn:column];
    if(newRowIndex==-1) {
        return;
    }
    [_timer invalidate];
    NSUInteger row=newRowIndex;
    NSString *imagePath=(nowTurn==1)?(_firstImagePath):(_secondImagePath);
    [_gameView addToColumn:column row:row withImagePath:imagePath];
}

-(void)didEndMove
{
    if([_gameModel ifEnd]) {
        UIAlertView *alert;
        if([_gameModel winner]==1 || [_gameModel winner]==2) {
            alert=[[UIAlertView alloc]initWithTitle:@"Game End" message:[NSString stringWithFormat:@"Player %d wins!", [_gameModel winner]] delegate:self cancelButtonTitle:@"Reset" otherButtonTitles:nil, nil];
        }
        else {
            alert=[[UIAlertView alloc]initWithTitle:@"Game End" message:@"Nobody wins!" delegate:self cancelButtonTitle:@"Reset" otherButtonTitles:nil, nil];
        }
        alert.delegate=self;
        [alert show];
    }
    else {
        _timer=[NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(stepRandomly) userInfo:nil repeats:NO];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_gameModel reset];
    [_gameView reset];
    _timer=[NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(stepRandomly) userInfo:nil repeats:NO];
}

@end
