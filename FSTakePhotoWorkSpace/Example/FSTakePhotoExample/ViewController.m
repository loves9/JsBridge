//
//  ViewController.m
//  testSDK
//
//  Created by Fenng on 15/12/11.
//  Copyright © 2015年 Fenng. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

#import <WebKit/WebKit.h>

#import <FSJsBrigde/FSJsBrigde.h>


#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () 
@property (nonatomic) FSWebViewJsBridge* bridge;
@property (strong, nonatomic) WKWebView *webview;

@end

@implementation ViewController
{
    UITextField * _textField;
    WebViewController * _wb;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    _wb = [[WebViewController alloc]init];
}

- (void)createUI
{
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 80, SCREENWIDTH - 20, 40)];
    _textField.layer.borderColor=[[UIColor blueColor]CGColor];
    _textField.layer.borderWidth= 1.0f;
    
    [self.view addSubview:_textField];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 -30, 150, 60, 40)];
    btn.layer.borderColor = [[UIColor blueColor]CGColor];
    btn.layer.borderWidth = 1.0f;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)onClickBtn
{
    [self loadWebViewWithURL:_textField.text];
    [self.navigationController pushViewController:_wb animated:YES];
}

- (void)loadWebViewWithURL:(NSString *)path
{
    if (_webview != nil) {
        [_webview removeFromSuperview];
        _webview = nil;
    }

    _bridge = [FSWebViewJsBridge shareInstance];
    _webview = [_bridge bridgeForWkWebView:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) UIViewController:self];
    _bridge.LakalaWKBridgeBlock = ^(id tag){
        // 这里做其它操作（与h5约定好tag，然后处理tag）

    };
    
    [_wb.view addSubview:_webview];
    
    //test only
    if ([path isEqualToString:@""]) {
        NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
        NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [_webview loadHTMLString:appHtml baseURL:nil];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:path];
    NSLog(@"%@",path);
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField endEditing:YES];
}

@end
