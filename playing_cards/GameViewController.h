//
//  GameViewController.h
//  playing_cards
//
//  Created by Kyle Lucovsky on 1/23/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardMatchingGame.h"
#import "Grid.h"

@interface GameViewController : UIViewController
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *history;
@property (nonatomic) NSUInteger numberOfStartingCards;
@property (nonatomic) CGSize maxCardSize;
@property (nonatomic) Grid *grid;
@property (nonatomic) int mode;

- (void)updateCardView:(UIView *)cardView;
- (void)tapCard:(UISwipeGestureRecognizer *)sender;
@end
