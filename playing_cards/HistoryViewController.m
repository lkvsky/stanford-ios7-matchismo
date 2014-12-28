//
//  HistoryViewController.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 12/23/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textView setAttributedText:[self formatHistory]];
}

- (NSMutableAttributedString *)formatHistory
{
    NSMutableAttributedString *baseString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *delimiter = [[NSAttributedString alloc] initWithString:@"\n"];
    
    for (NSAttributedString *historyItem in self.history) {
        [baseString appendAttributedString:historyItem];
        [baseString appendAttributedString:delimiter];
    }
    
    return baseString;
}

@end
