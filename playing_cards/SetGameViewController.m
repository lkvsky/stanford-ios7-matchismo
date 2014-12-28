//
//  SetGameViewController.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 12/10/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "HistoryViewController.h"


@interface SetGameViewController ()
@property (nonatomic) int mode;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation SetGameViewController

- (int)mode
{
    if (!_mode) _mode = 3;
    return _mode;
}

- (SetCardDeck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateUI
{
    
    for (UIButton *cardButton in self.cardButtons) {
        NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        SetCard *card = (SetCard *)[self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
    }
    
    if (self.game.playComplete) {
        NSAttributedString *currentStatus = [self buildStatus:self.game.chosenCards thatMatched:self.game.isMatching];
        [self.statusLabel setAttributedText:currentStatus];
        [self.history addObject:currentStatus];
    } else {
        self.statusLabel.text = @"";
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
//        HistoryViewController *historyVC = (HistoryViewController *)segue.destinationViewController;
//        historyVC.history = self.history;
//    }
//}

- (NSMutableAttributedString *)buildStatus:(NSArray *)cards
              thatMatched:(BOOL)isMatch
{
    NSMutableAttributedString *baseString;
    
    if (isMatch) {
       baseString = [[NSMutableAttributedString alloc] initWithString:@"Yay! you matched "];
    } else {
        baseString = [[NSMutableAttributedString alloc] initWithString:@"Sorry! "];
    }

    NSMutableAttributedString *cardString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *delimiter = [[NSAttributedString alloc] initWithString:@", "];
    
    for (SetCard *card in cards) {
        [cardString appendAttributedString:[self getSetCardTitle:card]];
    
        if (card != [cards lastObject]) {
            [cardString appendAttributedString:delimiter];
        }
    }

    if (isMatch) {
        [baseString appendAttributedString:cardString];
    } else {
        [baseString appendAttributedString:cardString];
        [baseString appendAttributedString:[[NSAttributedString alloc] initWithString:@" do not match!"]];
    }
    
    return baseString;
}

- (NSAttributedString *)titleForCard:(SetCard *)card
{
    return card.isChosen ? [self getSetCardTitle:card] : [[NSAttributedString alloc] initWithString:@""];
}

- (NSMutableAttributedString *)getSetCardTitle:(SetCard *)card
{
    NSMutableAttributedString *cardTitle = [[NSMutableAttributedString alloc] initWithString:[self getSymbolForCard:card]];
    [cardTitle addAttributes:[self getSymbolColorAttributes:card] range:(NSRange){0, (int)[cardTitle.string length]}];
    
    return cardTitle;
}

- (NSMutableDictionary *)getSymbolColorAttributes:(SetCard *)card
{
    NSMutableDictionary *fontStyles = [[NSMutableDictionary alloc] initWithDictionary:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
}];
    UIColor *symbolColor;
    
    if ((int)card.symbolColor == 1) {
        symbolColor = [UIColor blueColor];
    } else if ((int)card.symbolColor == 2) {
        symbolColor = [UIColor redColor];
    } else {
        symbolColor = [UIColor greenColor];
    }
    
    if ((int)card.symbolFillType == 1) {
        [fontStyles setObject:symbolColor forKey:NSStrokeColorAttributeName];
        [fontStyles setObject:@-5 forKey:NSStrokeWidthAttributeName];
        [fontStyles setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    } else if ((int)card.symbolFillType == 2) {
        [fontStyles setObject:symbolColor forKey:NSStrokeColorAttributeName];
        [fontStyles setObject:@-5 forKey:NSStrokeWidthAttributeName];
        [fontStyles setObject:[symbolColor colorWithAlphaComponent:0.5] forKey:NSForegroundColorAttributeName];
    } else {
        [fontStyles setObject:symbolColor forKey:NSForegroundColorAttributeName];
    }
    
    return fontStyles;
}

- (NSMutableString *)getSymbolForCard:(SetCard *)card
{
    NSMutableString *baseString = [[NSMutableString alloc] initWithString:@""];
    
    for (int i = 0; i < (int)card.symbolCount; i++) {
        if ((int)card.symbolType == 1) {
            [baseString appendString:@"▲"];
        } else if ((int)card.symbolType == 2) {
            [baseString appendString:@"●"];
        } else if ((int)card.symbolType == 3) {
            [baseString appendString:@"■"];
        }
    }
    
    return baseString;
}


@end
