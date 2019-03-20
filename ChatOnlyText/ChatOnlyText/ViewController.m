//
//  ViewController.m
//  ChatOnlyText
//
//  Created by Yuanhai on 20/3/19.
//  Copyright © 2019年 Yuanhai. All rights reserved.
//

#import "ViewController.h"
#import "CVMessageInputView.h"
#import "CCChatLeftCell.h"
#import "CCChatRightCell.h"
#import "MDChatModel.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, CVMessageInputViewDelegate>

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) CVMessageInputView *chatInputView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"纯文本聊天";
    
    // 聊天北京
    self.view.backgroundColor = [UIColor colorWithRed:237 / 255.0f green:236 / 255.0f blue:237 / 255.0f alpha:1.0f];
    
    // 初始化
    [self initData];
}

// 初始化
- (void)initData
{
    // 数据源
    NSArray *arr = @[@"妈妈，我睡不着，你能和我说说话吗？", @"可以，你说吧！", @"你对我的成绩满意吗？", @"你对你自己的成绩满意吗？", @"还行吧，感觉挺有自信的。", @"有时候自信比成绩更重要！", @"难道你真不在乎我的成绩吗？妈妈！", @"啊？", @"不在乎！你想一想，我什么时候在乎过你的成绩呢？", @"收到了你的来信，从中能看出你在思考，我很开心。有很多话一直想对你说，有些话可能在平时说过，有些可能还没有说，在这我都说说，谈一些我的人生感悟，供咱们共同探讨。 ", @"亲爱的儿子，见信好。"];
    self.contentArray = [NSMutableArray array];
    // 随机排列
    for (NSString *str in arr)
    {
        MDChatModel *model = [[MDChatModel alloc] init];
        model.chatMode = random() % 2;
        model.content = str;
        [self.contentArray addObject:model];
    }
    
    // 添加下方输入框
    [self.view addSubview:self.chatInputView];
    
    // 添加聊天
    [self.view addSubview:self.chatTableView];
    
    // 添加键盘监听
    [self addKeyboardNote];
}

#pragma mark - 滚动Table

// 滚动最下方
- (void)tableViewScrollToBottom
{
    // 界面滚动到指定位置
    [self tableViewScrollToIndex:self.contentArray.count - 1];
}

// 滚动到指定位置
- (void)tableViewScrollToIndex:(NSInteger)index
{
    @synchronized (self.contentArray)
    {
        if (self.contentArray.count > index)
        {
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark - SHMessageInputViewDelegate

// 发送文本
- (void)chatMessageWithSendText:(NSString *)text
{
    MDChatModel *model = [[MDChatModel alloc] init];
    model.chatMode = ChatSend;
    model.content = text;
    [self.contentArray addObject:model];
    // 模拟相同回复
    model = [[MDChatModel alloc] init];
    model.chatMode = ChatReceive;
    model.content = text;
    [self.contentArray addObject:model];
    
    [self.chatTableView reloadData];
    [self.chatInputView.textView resignFirstResponder];
}

// 工具栏高度改变
- (void)toolbarHeightChange
{
    // 改变聊天界面高度
    CGRect frame = self.chatTableView.frame;
    frame.size.height = self.chatInputView.y;
    self.chatTableView.frame = frame;
    [self.view layoutIfNeeded];
    // 滚动到底部
    [self tableViewScrollToBottom];
}

#pragma mark - 聊天界面

- (UITableView *)chatTableView
{
    if (!_chatTableView)
    {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSHWidth, self.chatInputView.y) style:UITableViewStylePlain];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.backgroundColor = [UIColor clearColor];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _chatTableView;
}

#pragma mark - 下方输入框

- (CVMessageInputView *)chatInputView
{
    if (!_chatInputView)
    {
        _chatInputView = [[CVMessageInputView alloc]init];
        _chatInputView.frame = CGRectMake(0, self.view.height - kSHInPutHeight - kSHBottomSafe, kSHWidth, kSHInPutHeight);
        _chatInputView.delegate = self;
        [_chatInputView reloadView];
        
        // 安全区域
        if (kSHBottomSafe)
        {
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(0, _chatInputView.maxY, kSHWidth, kSHBottomSafe);
            view.backgroundColor = kInPutViewColor;
            [self.view addSubview:view];
        }
    }
    return _chatInputView;
}

#pragma mark - 键盘通知

// 添加键盘通知
- (void)addKeyboardNote
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

// 键盘通知执行
- (void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.chatInputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    
    if ([notification.name isEqualToString:@"UIKeyboardWillHideNotification"]) {
        newFrame.origin.y -= kSHBottomSafe;
    }
    self.chatInputView.frame = newFrame;
    
    [UIView commitAnimations];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDChatModel *model = self.contentArray[indexPath.row];
    if (model.chatMode == ChatReceive)
    {
        CCChatLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        if (!cell)
        {
            cell = [[CCChatLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshCellWithText:model.content];
        return cell;
    }
    else
    {
        CCChatRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
        if (!cell)
        {
            cell = [[CCChatRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshCellWithText:model.content];
        return cell;
    }
}

#pragma mark - ScrollVIewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.chatInputView.textView resignFirstResponder];
}

@end
