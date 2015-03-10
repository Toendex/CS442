//
//  ViewController.h
//  CS442-assignment3
//
//  Created by T on 5/6/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "ConnectFourView.h"
#import <Parse/Parse.h>

@interface GameViewController : UIViewController <ConnectFourDelegate,UIAlertViewDelegate>

@property (strong) Game *game;
@property (strong) ConnectFourView *gameView;
@property BOOL didStep;

@end
