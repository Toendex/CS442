//
//  ETableViewCell.m
//  CS442-assignment4
//
//  Created by T on 5/9/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "ETableViewCell.h"

@implementation ETableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)doInitWithGame:(Game *)game
{
    PFUser *usr;
    if([[[game player:1] objectId] isEqualToString:[[PFUser currentUser] objectId]])
        usr=[game player:2];
    else
        usr=[game player:1];
    NSString *str=[NSString stringWithFormat:@"Game with   %@",[usr username]];
    self.gameLabel.text=str;
    NSString *s;
    if([game winner]!=1 && [game winner]!=2)
        s=@"draw";
    else {
        usr=[game player:[game winner]];
        if([[usr objectId] isEqualToString:[[PFUser currentUser] objectId]])
            s=@"You won";
        else
            s=[NSString stringWithFormat:@"You lost"];
    }
    self.wonLabel.text=s;
    
}

@end
