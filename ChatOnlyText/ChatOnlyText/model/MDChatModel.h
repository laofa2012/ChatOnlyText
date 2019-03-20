//
//  MDChatModel.h
//  ChatOnlyText
//
//  Created by Yuanhai on 20/3/19.
//  Copyright © 2019年 Yuanhai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ChatSendOrReveive) {
    ChatSend,
    ChatReceive
};

NS_ASSUME_NONNULL_BEGIN

@interface MDChatModel : NSObject

@property (nonatomic, assign) ChatSendOrReveive chatMode;
@property (nonatomic, strong) NSString *content;

@end

NS_ASSUME_NONNULL_END
