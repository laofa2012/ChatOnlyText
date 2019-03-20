//
//  CVChatLabelView.h
//  ChatOnlyText
//
//  Created by Yuanhai on 20/3/19.
//  Copyright © 2019年 Yuanhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CVChatLabelView : UIView

@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithLeftOrRightChat:(ChatSendOrReveive)chats;

- (CGFloat)sizeWithText:(NSString*)text andFont:(UIFont*)font;

@end

NS_ASSUME_NONNULL_END
