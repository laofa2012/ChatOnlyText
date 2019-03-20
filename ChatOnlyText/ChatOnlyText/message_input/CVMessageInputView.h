//
//  CVMessageInputView.h
//  ChatOnlyText
//
//  Created by Yuanhai on 20/3/19.
//  Copyright © 2019年 Yuanhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CVMessageInputViewDelegate <NSObject>
@optional
// 发送文本
- (void)chatMessageWithSendText:(NSString *)text;
// 工具栏高度改变
- (void)toolbarHeightChange;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CVMessageInputView : UIView

// 代理
@property (nonatomic, weak) id <CVMessageInputViewDelegate>delegate;

// 文本输入框
@property (nonatomic, strong) UITextView *textView;

// 刷新视图
- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
