//
//  FSWebViewJsBridge.h
//  FSWebViewJsBridge
//
//  Created by Fenng on 15/12/3.
//  Copyright © 2015年 Fenng. All rights reserved.
//

#import "WebViewJsBridge.h"

@interface FSWebViewJsBridge : WebViewJsBridge <WKScriptMessageHandler>

@property(nonatomic, copy) void (^LakalaWKBridgeBlock)(id);

+ (instancetype)shareInstance;

/**
 * WkWebView 桥接初始化方法
 *
 */
- (WKWebView *)bridgeForWkWebView:(CGRect)frame UIViewController:(UIViewController*)viewController;
@end
