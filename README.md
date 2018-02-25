# JsBridge
H5调原生拍照后回调H5
支持Web与Native数据传输

# Usage
#### 一、WKWebView
```object-c
_bridge = [LKLHtmlBridge shareInstance];
_webview = [_bridge bridgeForWkWebView:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) UIViewController:self];
_bridge.LakalaWKBridgeBlock = ^(id tag){
       // 这里做其它操作（比如退出 与h5约定好tag，然后处理tag）
       // tag 可以是字符串、数字、字典、数组；(建议使用字典)
        
};
```

#### 二、UIWebView
```object-c
LKLHtmlBridge* bridge = [LKLHtmlBridge bridgeForWebView:_webview webViewDelegate:self UIViewController:self];
```
# 详情参见Demo
