//
//  CCChatRightCell.m
//  ChatOnlyText
//
//  Created by Yuanhai on 20/3/19.
//  Copyright © 2019年 Yuanhai. All rights reserved.
//

#import "CCChatRightCell.h"
#import <Masonry.h>
#import "CVChatLabelView.h"

#define k_width [UIScreen mainScreen].bounds.size.width
#define cellPadding 8.0f

@interface CCChatRightCell ()

@property (nonatomic, strong) CVChatLabelView *chatLabelView;

@end

@implementation CCChatRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    if (self)
    {
        [self createCusCellView];
    }
    return self;
}

- (void)createCusCellView
{
    self.chatLabelView = [[CVChatLabelView alloc] initWithLeftOrRightChat:ChatSend];
    [self addSubview:self.chatLabelView];
}

- (void)refreshCellWithText:(NSString *)text
{
    self.chatLabelView.label.text = text;
    [self.chatLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-cellPadding);
        make.top.mas_equalTo(cellPadding);
        make.bottom.mas_equalTo(-cellPadding);
        if ([self.chatLabelView sizeWithText:self.chatLabelView.label.text andFont:self.chatLabelView.label.font] > (k_width / 5 * 4)) {
            make.left.mas_equalTo(k_width / 5);
        }
    }];
}

@end
