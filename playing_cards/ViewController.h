//
//  ViewController.h
//  playing_cards
//
//  Created by Kyle Lucovsky on 11/18/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *history;
- (UIImage *)backgroundImageForCard:(Card *)card;
@end

