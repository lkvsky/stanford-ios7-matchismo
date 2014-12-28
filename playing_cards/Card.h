//
//  Card.h
//  playing_cards
//
//  Created by Kyle Lucovsky on 11/18/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
