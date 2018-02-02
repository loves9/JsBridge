//
//  WebViewJsBridge.h
//  VoxStudent
//
//  Created by zhaoxy on 14-3-8.
//  Copyright (c) 2014年 17zuoye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#define kCustomProtocolScheme @"jscall"
#define kBridgeName           @"FSJsBridge"

@interface WebViewJsBridge : NSObject<UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) UIViewController* viewController;
@property (nonatomic, copy) NSString * baseStr;

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>*)webViewDelegate UIViewController:(UIViewController*)viewController;

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>*)webViewDelegate resourceBundle:(NSBundle*)bundle UIViewController:(UIViewController*)viewController;

- (void)excuteJSWithObj:(NSString *)obj function:(NSString *)function;
@end
