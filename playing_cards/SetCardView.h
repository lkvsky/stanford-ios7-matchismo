//
//  SetCardView.h
//  playing_cards
//
//  Created by Kyle Lucovsky on 1/22/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView
@property (nonatomic) bool faceUp;
@property (nonatomic) NSInteger *symbolType;
@property (nonatomic) NSInteger *symbolCount;
@property (nonatomic) NSInteger *symbolFillType;
@property (nonatomic) NSInteger *symbolColor;

+ (NSMutableAttributedString *)getDesignForSymbol:(NSInteger *)symbolType withCount:(NSInteger *)symbolCount inColor:(NSInteger *)symbolColor withFill:(NSInteger *)symbolFillType;
@end
