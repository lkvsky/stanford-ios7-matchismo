//
//  PlayingCardView.h
//  playing_cards
//
//  Created by Kyle Lucovsky on 1/9/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView
@property (nonatomic) BOOL faceUp;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;

- (void)tap:(UITapGestureRecognizer *)gesture;

@end
