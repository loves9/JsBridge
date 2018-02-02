//
//  FSWebViewJsBridge.m
//  FSWebViewJsBridge
//
//  Created by Fenng on 15/12/3.
//  Copyright © 2015年 Fenng. All rights reserved.
//

#import "FSWebViewJsBridge.h"
#import "LKLGTMBase64.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height


@interface FSWebViewJsBridge() <UIPickerViewAccessibilityDelegate>

@end


@implementation FSWebViewJsBridge
{
    id _tag;
    UIImagePickerController * _picker;
    NSString * _baseStr;

    WKWebView * _mWkWebView;
    BOOL isWKWebView;
}

+ (instancetype)shareInstance
{
    static FSWebViewJsBridge * mBridge;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mBridge = [[FSWebViewJsBridge alloc] init];
    });
    
    return mBridge;
}

/**
 * wkwebview 交互方法
 *
 * @param frame
 * return wkwebview
 */
- (WKWebView *)bridgeForWkWebView:(CGRect)frame UIViewController:(UIViewController*)viewController
{
    isWKWebView = YES;
    self.viewController = viewController;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:kBridgeName];
    
    _mWkWebView = [[WKWebView alloc]initWithFrame:frame configuration:config];
    
    return _mWkWebView;
}

#pragma mark - wkview js调 native代理方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:kBridgeName]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSLog(@"%@", message.body);
        
        if (!self.LakalaWKBridgeBlock) {
            return;
        }
        
        if([message.body isKindOfClass:[NSDictionary class]]){
            NSDictionary * dict = message.body;
            
            if ([[dict valueForKey:@"tag"] isEqualToString:@"take_photo"]) {
                [self take_photo:@[[dict valueForKey:@"index"]]];
            }else{
                self.LakalaWKBridgeBlock(message.body);
            }
            
        }else{
            self.LakalaWKBridgeBlock(message.body);
        }
    }
}

- (void)take_photo:(NSArray *)msg
{
    if(msg.count == 0){
        return;
    }
    _tag = msg[0];
//    NSLog(@"take_photo:%@;tag:%@", msg, _tag);

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate        = (id)self;
        _picker.allowsEditing   = NO; //设置拍照后的图片可被编辑
        _picker.sourceType      = sourceType;
        //_picker.sourceType      = UIImagePickerControllerSourceTypePhotoLibrary;
        _picker.navigationBar.translucent = NO;
        
        [self.viewController presentViewController:_picker animated:YES completion:^{}];
    }
}

//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width, newSize.height));
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

#pragma mark- 相机代理协议
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(!_baseStr){
        _baseStr = [[NSString alloc]init];
    }
    UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];

    // 生成缩略图 for 上传用
    CGSize size = image.size;
    float w = 300;
    float h = 300*size.height/size.width;
    // 压缩图片尺寸
    image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
    NSData * imageData1 = UIImageJPEGRepresentation(image,1);
    _baseStr = [LKLGTMBase64 stringByEncodingData:imageData1];
//    NSLog(@"image size = %@===%@=",NSStringFromCGSize(image.size), _baseStr);

    
    NSString * str1 = @"lakala";
    NSString * str2 = @"get_photo";
    NSString * error = @"";
    //lakala.get_photo(base64, tag, error);
    
    id tag = _tag;
    if (_baseStr) {
        if (isWKWebView) {
            NSString *js = [NSString stringWithFormat:@"%@(%@,%@,'%@');",
                            str2,
                            [NSString stringWithFormat:@"'%@'", _baseStr],
                            tag,
                            error];
            js = [NSString stringWithFormat:@"%@.%@", str1, js];

            [_mWkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                
            }];
            
        }else{
            [self excuteJSWithObj:str1
                         function:[NSString stringWithFormat:@"%@(%@,%@,'%@');",
                                   str2,
                                   [NSString stringWithFormat:@"'%@'", _baseStr],
                                   tag,
                                   error]];
        }
    }
    
    [_picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_picker dismissViewControllerAnimated:YES completion:nil];
}
@end
