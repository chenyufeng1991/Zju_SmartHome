//
//  JYElectricalController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/21.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYElectricalController.h"
#import "AFNetworking.h"

@interface JYElectricalController ()<NSURLConnectionDataDelegate>
@property(nonatomic,strong)NSURLConnection *connection;
@property(nonatomic,strong)NSMutableData *receiveData;
@end

@implementation JYElectricalController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor=[UIColor whiteColor];
  [self test];
}

//这里要传哪些参数可以再修改；
- (void)test{
  
  //增加这几行代码；
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSString *str = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
  "<root>"
  "<command_id>10001</command_id>"
  "<command_type>execute</command_type>"
  "<id>123</id>"
  "<action>warmcold</action>"
  "<value>80</value>"
  "</root>";
  
  NSDictionary *parameters = @{@"test" : str};
  
  [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/yw_light.php"
     parameters:parameters
        success:^(AFHTTPRequestOperation *operation,id responseObject){
          NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
          NSLog(@"成功: %@", string);
        }
        failure:^(AFHTTPRequestOperation *operation,NSError *error){
          NSLog(@"失败: %@", error);
        }];
}



@end
