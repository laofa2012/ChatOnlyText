//
//  CVMessageInputView.m
//  ChatOnlyText
//
//  Created by Yuanhai on 20/3/19.
//  Copyright © 2019年 Yuanhai. All rights reserved.
//

#import "CVMessageInputView.h"

@interface CVMessageInputView () <UITextViewDelegate>

// 发送按钮
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation CVMessageInputView

static CGFloat start_maxy;

#pragma mark - 刷新界面

- (void)reloadView
{
    //设置背景颜色
    self.backgroundColor = kInPutViewColor;
    
    //分割线
    self.layer.cornerRadius = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
    self.layer.borderWidth = 0.4;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    start_maxy = self.maxY;
    
    // 添加文本输入框
    [self addSubview:self.textView];
    // 添加发送按钮
    [self addSubview:self.sendBtn];
    
    // 添加监听
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - 子控件

// 文本输入框
- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(kSHInPutSpace, self.height - kSHInPutIcon_WH - kSHInPutSpace, self.width - 3 * kSHInPutSpace - kSHInPutButton_W, kSHInPutIcon_WH);
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        // UITextView内部判断send按钮是否可以用
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _textView.layer.borderWidth = 1;
    }
    return _textView;
}

// 发送按钮
- (UIButton *)sendBtn
{
    if (!_sendBtn)
    {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(self.width - kSHInPutSpace - kSHInPutButton_W, self.height - kSHInPutIcon_WH - kSHInPutSpace, kSHInPutButton_W, kSHInPutIcon_WH);
        _sendBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _sendBtn.layer.cornerRadius = 4;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _sendBtn.layer.borderWidth = 1;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //文字颜色
        [_sendBtn setTitleColor:kRGB(76, 76, 76, 1) forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kRGB(150, 150, 150, 1) forState:UIControlStateHighlighted];
        //文字内容
        [_sendBtn setTitle:@"SEND" forState:UIControlStateNormal];
        //点击方式
        [_sendBtn addTarget:self action:@selector(sendPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

#pragma mark - 监听实现

// 监听输入框的位置
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"])
    {
        if ([self.delegate respondsToSelector:@selector(toolbarHeightChange)]) {
            [self.delegate toolbarHeightChange];
        }
    }
}

#pragma mark - 发送

- (void)sendPress:(UIButton *)button
{
    [self sendMessageWithText:self.textView.text];
}

- (void)sendMessageWithText:(NSString *)text
{
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendText:)])
    {
        [_delegate chatMessageWithSendText:text];
    }
    self.textView.text = @"";
    [self textViewDidChange:self.textView];
}

#pragma mark - UITextViewDelegate

// 键盘上功能点击
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //点击了发送
    if ([text isEqualToString:@"\n"])
    {
        //发送文字
        [self sendMessageWithText:textView.text];
        return NO;
    }
    return YES;
}

// 开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self textViewDidChange:textView];
}

// 文字改变
- (void)textViewDidChange:(UITextView *)textView{
    
    CGFloat padding = textView.textContainer.lineFragmentPadding;
    
    CGFloat maxH = ceil(textView.font.lineHeight*3 + 2*padding);
    
    CGFloat textH = [textView.text boundingRectWithSize:CGSizeMake(textView.width - 2*padding, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil].size.height;
    textH = ceil(MIN(maxH, textH));
    textH = ceil(MAX(textH, kSHInPutIcon_WH));
    
    if (self.textView.height != textH)
    {
        self.y += (self.textView.height - textH);
        self.height = textH + 2*kSHInPutSpace;
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
    }
}

@end
