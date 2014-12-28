//
//  Deck.h
//  playing_cards
//
//  Created by Kyle Lucovsky on 11/18/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
