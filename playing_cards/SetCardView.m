//
//  SetCardView.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 1/22/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setSymbolType:(NSInteger *)symbolType
{
    _symbolType = symbolType;
    [self setNeedsDisplay];
}

- (void)setSymbolColor:(NSInteger *)symbolColor
{
    _symbolColor = symbolColor;
    [self setNeedsDisplay];
}

- (void)setSymbolFillType:(NSInteger *)symbolFillType
{
    _symbolFillType = symbolFillType;
    [self setNeedsDisplay];
}

- (void)setSymbolCount:(NSInteger *)symbolCount
{
    _symbolCount = symbolCount;
    [self setNeedsDisplay];
};

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.faceUp) {
        [[self getDesign] drawAtPoint:CGPointMake(5, self.bounds.size.height/2)];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

+ (NSMutableAttributedString *)getDesignForSymbol:(NSInteger *)symbolType withCount:(NSInteger *)symbolCount inColor:(NSInteger *)symbolColor withFill:(NSInteger *)symbolFillType
{
    NSMutableAttributedString *cardDesign = [[NSMutableAttributedString alloc] initWithString:[SetCardView getSymbol:symbolType withCount:symbolCount]];
    [cardDesign addAttributes:[SetCardView getSymbolAttributes:symbolColor withFill:symbolFillType] range:(NSRange){0, (int)[cardDesign.string length]}];
    
    return cardDesign;
}

- (NSMutableAttributedString *)getDesign
{
    NSMutableAttributedString *cardDesign = [[NSMutableAttributedString alloc] initWithString:[SetCardView getSymbol:self.symbolType withCount:self.symbolCount]];
    [cardDesign addAttributes:[SetCardView getSymbolAttributes:self.symbolColor withFill:self.symbolFillType] range:(NSRange){0, (int)[cardDesign.string length]}];
    
    return cardDesign;
}

+ (NSMutableDictionary *)getSymbolAttributes:(NSInteger *)symbolColor withFill:(NSInteger *)symbolFillType
{
    NSMutableDictionary *fontStyles = [[NSMutableDictionary alloc] initWithDictionary:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                                                                        }];
    UIColor *symbolColorForUi;
    
    if ((int)symbolColor == 1) {
        symbolColorForUi = [UIColor blueColor];
    } else if ((int)symbolColor == 2) {
        symbolColorForUi = [UIColor redColor];
    } else {
        symbolColorForUi = [UIColor greenColor];
    }
    
    if ((int)symbolFillType == 1) {
        [fontStyles setObject:symbolColorForUi forKey:NSStrokeColorAttributeName];
        [fontStyles setObject:@-5 forKey:NSStrokeWidthAttributeName];
        [fontStyles setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    } else if ((int)symbolFillType == 2) {
        [fontStyles setObject:symbolColorForUi forKey:NSStrokeColorAttributeName];
        [fontStyles setObject:@-5 forKey:NSStrokeWidthAttributeName];
        [fontStyles setObject:[symbolColorForUi colorWithAlphaComponent:0.5] forKey:NSForegroundColorAttributeName];
    } else {
        [fontStyles setObject:symbolColorForUi forKey:NSForegroundColorAttributeName];
    }
    
    return fontStyles;
}

+ (NSMutableString *)getSymbol:(NSInteger *)symbolType withCount:(NSInteger *)symbolCount
{
    NSMutableString *baseString = [[NSMutableString alloc] initWithString:@""];
    
    for (int i = 0; i < (int)symbolCount; i++) {
        if ((int)symbolType == 1) {
            [baseString appendString:@"▲"];
        } else if ((int)symbolType == 2) {
            [baseString appendString:@"●"];
        } else if ((int)symbolType == 3) {
            [baseString appendString:@"■"];
        }
    }
    
    return baseString;
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib { [self setup]; }

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    [self setup];
    return self;
}

@end
