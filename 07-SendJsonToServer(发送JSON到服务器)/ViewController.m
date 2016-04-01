//
//  ViewController.m
//  07-SendJsonToServer(发送JSON到服务器)
//
//  Created by  a on 16/4/1.
//  Copyright © 2016年 eva. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+MJ.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);

}

// 点击屏幕的时候就发送一个 JSON数据类型的 请求到服务器
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. URL
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/order"];
    
    // 2. 创建一个请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    // 3. 设置请求方法为POST
    request.HTTPMethod = @"POST";
    
    // 4. 设置请求参数 (请求体)
    // 4-1 简单的传输数据
    /**  (有大量的参数的时候  不适合使用拼接字符串直接添加进请求)
     NSString *param = [NSString stringWithFormat:@"shop_id=123&shop_price=88&shop_name=2222...."];
     request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
     */
    
    // 4-2 创建一个描述订单信息的JSON数据
    // 创建一个字典 保存订单信息
    NSDictionary *orderInfo = @{
                                @"shop_id" : @"88y42",
                              @"shop_name" : @"pen",
                             @"shop_price" : @44.2,
                             @"shop_count" : @1,
                                @"user_id" : @"4226921",
                                };
    // 将字典转化为JSON
    NSData *json = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json; // 请求体
    
    // 设置请求头 (发送JSON给服务器，光有请求体不够，还需要独立的请求头)
    // * 默认情况下 Content-Type 只可以接收普通参数，如果需要修改发送的数据类型，需要修改请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /**
     不同格式的独立的请求头  (替换上面的 /json )
     MIMEType 
     image/jpeg
     image/png
     */
    
    // 5. 发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        // NSLog(@"%@", data);
        
        // 解析服务器返回的data
        if (data == nil || connectionError) {
            return;
        }
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        // NSLog(@"%@", result);
        NSString *error = result[@"error"];
        if (error) {
            [MBProgressHUD showError:error];
        }
        else {
            // NSLog(@"%@", result);
            NSString *success = result[@"success"];
            [MBProgressHUD showSuccess:success];
        }
        
    }];
    
    
}

@end
