//
//  CVChatLabelView.m
//  ChatOnlyText
//
//  Created by Yuanhai on 20/3/19.
//  Copyright © 2019年 Yuanhai. All rights reserved.
//

#import "CVChatLabelView.h"
#import <Masonry.h>

#define viewPadding 10.0f

@implementation CVChatLabelView

- (instancetype)initWithLeftOrRightChat:(ChatSendOrReveive)chats
{
    self = [super init];
    if (self)
    {
        [self createLabel:chats];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0f;
    }
    return self;
}

- (void)createLabel:(ChatSendOrReveive)chats
{
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.numberOfLines = 0;
    [self addSubview:self.label];
    
    if (chats == ChatSend)
    {
        self.backgroundColor = [UIColor colorWithRed:170 / 255.0f green:232 / 255.0f blue:122 / 255.0f alpha:1.0f];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(viewPadding);
            make.right.mas_equalTo(-viewPadding);
            make.top.mas_equalTo(viewPadding);
            make.bottom.mas_equalTo(-viewPadding);
        }];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithRed:255 / 255.0f green:254 / 255.0f blue:255 / 255.0f alpha:1.0f];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(viewPadding);
            make.right.mas_equalTo(-viewPadding);
            make.top.mas_equalTo(viewPadding);
            make.bottom.mas_equalTo(-viewPadding);
        }];
    }
}

- (CGFloat)sizeWithText:(NSString*)text andFont:(UIFont*)font
{
    return [self sizeWithText:text andFont:font constrainedToSize:CGSizeZero].width;
}

- (CGSize)sizeWithText:(NSString*)text andFont:(UIFont*)font constrainedToSize:(CGSize)size
{
    CGSize rect = CGSizeZero;
    rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return rect;
}

@end
