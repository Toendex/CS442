//
//  GameModel.m
//  CS442-assignment4
//
//  Created by T on 5/8/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel {
    NSMutableArray *_yourTurnGamesArray;
    NSMutableArray *_theirTurnGamesArray;
    NSMutableArray *_availableGamesArray;
    NSMutableArray *_endedGamesArray;
    NSDate *_lastUpdateDate;
}

-(id)init
{
    if(self==[super init]) {
        _yourTurnGamesArray=[NSMutableArray array];
        _theirTurnGamesArray=[NSMutableArray array];
        _availableGamesArray=[NSMutableArray array];
        _endedGamesArray=[NSMutableArray array];
        _lastUpdateDate=[NSDate dateWithTimeIntervalSince1970:0];
    }
    return self;
}

-(void)doQueryInBackground:(void(^)())block
{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query includeKey:@"nowTurnPlayer"];
    [query includeKey:@"firstPlayer"];
    [query includeKey:@"secondPlayer"];
    [query includeKey:@"creator"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        BOOL ifNewer=NO;
//        for (PFObject *obj in objects) {
//            NSDate *updateDate=[obj updatedAt];
//            if ([updateDate compare:_lastUpdateDate]==NSOrderedDescending) {
//                ifNewer=YES;
//                _lastUpdateDate=updateDate;
//            }
//        }
//        if(!ifNewer)
//            return;
        [_yourTurnGamesArray removeAllObjects];
        [_theirTurnGamesArray removeAllObjects];
        [_availableGamesArray removeAllObjects];
        [_endedGamesArray removeAllObjects];
        for(PFObject *obj in objects) {
//            NSLog(@"%@,%@,%@",obj[@"nowTurnPlayer"] ,obj[@"secondPlayer"], obj[@"firstPlayer"] );
            
            if((obj[@"firstPlayer"]!=[NSNull null] && [[obj[@"firstPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) || (obj[@"secondPlayer"]!=[NSNull null] && [[obj[@"secondPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]])) {
                if([obj[@"ifEnd"] boolValue]==YES) {
                    [_endedGamesArray addObject:[[Game alloc] initWithPFObject:obj]];
                }
                else if(obj[@"nowTurnPlayer"]!=[NSNull null] && [[obj[@"nowTurnPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                    [_yourTurnGamesArray addObject:[[Game alloc] initWithPFObject:obj]];
                }
                else {
                    [_theirTurnGamesArray addObject:[[Game alloc] initWithPFObject:obj]];
                }
            }
            else if((obj[@"firstPlayer"]==[NSNull null] || obj[@"secondPlayer"]==[NSNull null]) && obj[@"nowTurnPlayer"]==[NSNull null]){
                [_availableGamesArray addObject:[[Game alloc] initWithPFObject:obj]];
            }
            
//            if([obj[@"ifEnd"] boolValue]==YES ) {
//                if( [[obj[@"firstPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]] ||
//                   [[obj[@"secondPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
//                    [_endedGamesArray addObject:[[Game alloc] initWithPFObject:obj]];
//                }
//            }
//            else if(obj[@"nowTurnPlayer"]!=[NSNull null] && [[obj[@"nowTurnPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
//                [_yourTurnGamesArray addObject:[[Game alloc] initWithPFObject:obj]];
//            }
//            else if((obj[@"nowTurnPlayer"]==[NSNull null] && obj[@"firstPlayer"]==[NSNull null] && ![[obj[@"secondPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) ||
//                    (obj[@"nowTurnPlayer"]==[NSNull null] && obj[@"secondPlayer"]==[NSNull null] && ![[obj[@"firstPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]])) {
//                [_availableGamesArray addObject:[[Game alloc] initWithPFObject:obj]];
//            }
//            else if(((obj[@"firstPlayer"]!=[NSNull null] && [[obj[@"firstPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) || (obj[@"secondPlayer"]!=[NSNull null] && [[obj[@"secondPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]])) && (!(obj[@"nowTurnPlayer"]!=[NSNull null] && [[obj[@"nowTurnPlayer"] objectId] isEqualToString:[[PFUser currentUser] objectId]]))) {
//                [_theirTurnGamesArray addObject:[[Game alloc] initWithPFObject:obj]];
//            }
        }
        block();
    }];
}

-(NSInteger)numOfArrays
{
    return 4;
}

-(NSUInteger)countOfArray:(NSInteger)indexOfArray
{
    NSUInteger num=0;
    switch (indexOfArray) {
        case 0:
            num=[_yourTurnGamesArray count];
            break;
        case 1:
            num=[_theirTurnGamesArray count];
            break;
        case 2:
            num=[_availableGamesArray count];
            break;
        case 3:
            num=[_endedGamesArray count];
            break;
        default:
            break;
    }
    return num;
}

-(Game *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexOfArray=[indexPath section];
    NSInteger item=[indexPath item];
    assert(indexOfArray >= 0 && indexOfArray < 4);
    Game *game=nil;;
    switch (indexOfArray) {
        case 0:
            game=[_yourTurnGamesArray objectAtIndex:item];
            break;
        case 1:
            game=[_theirTurnGamesArray objectAtIndex:item];
            break;
        case 2:
            game=[_availableGamesArray objectAtIndex:item];
            break;
        case 3:
            game=[_endedGamesArray objectAtIndex:item];
            break;
        default:
            return nil;
            break;
    }
    return game;
}

-(void)addNewGame:(Game *)game ifFirstPlayer:(BOOL)ifFirstPlayer
{
    if(ifFirstPlayer) {
        [_yourTurnGamesArray insertObject:game atIndex:0];
    }
    else {
        [_theirTurnGamesArray insertObject:game atIndex:0];
    }
}

-(void)removeAll
{
    [_yourTurnGamesArray removeAllObjects];
    [_theirTurnGamesArray removeAllObjects];
    [_availableGamesArray removeAllObjects];
    [_endedGamesArray removeAllObjects];
}

-(Game *)getAvailableGame
{
    Game *game=nil;
    if(([_availableGamesArray count]!=0))
        game=[_availableGamesArray objectAtIndex:0];
    return game;
}

//-(void)didStepOnGame:(Game *)game
//{
//    if ([_yourTurnGamesArray containsObject:game]) {
//        [_yourTurnGamesArray removeObject:game];
//        [_theirTurnGamesArray insertObject:game atIndex:0];
//        [game setToInit];
//    }
//    else {
//        NSLog(@"In function \"didStepOnGame\" in GameModel: this should not happened");
//    }
//}

@end
