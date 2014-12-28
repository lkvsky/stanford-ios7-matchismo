//
//  CardMatchingGame.h
//  playing_cards
//
//  Created by Kyle Lucovsky on 11/18/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                        usingMode:(NSUInteger)mode;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void) setGameMode:(NSUInteger)mode;
- (void) startNextMatch;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSMutableArray *chosenCards;
@property (nonatomic, readonly) BOOL isMatching;
@property (nonatomic, readonly) BOOL playComplete;

@end
