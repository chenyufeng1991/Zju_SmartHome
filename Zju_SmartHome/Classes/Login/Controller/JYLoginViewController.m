//
//  JYLoginViewController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/10/31.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYLoginViewController.h"
#import "JYLoginXib.h"
#import "JYRegisterViewController.h"
#import "JYNavigationController.h"
#import "AFNetworking.h"
#import "JYLoginStatus.h"
#import "JYUserData.h"
#import "MBProgressHUD+MJ.h"
#import "CYFMainViewController.h"
#import "DLLeftSlideView.h"
#import "JYNavigationController.h"
@interface JYLoginViewController ()<LoginXibDelegate,UITextFieldDelegate>

@property(nonatomic,strong)JYLoginXib *loginXib;
@end

@implementation JYLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JYLoginXib *loginXib=[JYLoginXib loginXib];
    //设置代理
    loginXib.delegate=self;
    self.loginXib=loginXib;
    //设置文本输入框的代理
    loginXib.password.delegate=self;
    loginXib.username.delegate=self;
    self.view=loginXib;
    
    
}


//UITextField监听事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@"请输入用户名"])
    {
        [textField setText:@""];
    }
    else if([textField.text isEqualToString:@"请输入密码"])
    {
        self.loginXib.eyePicture.hidden=NO;
        [textField setText:@""];
        textField.font=[UIFont systemFontOfSize:10];
        textField.secureTextEntry=YES;
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//代理登录方法
-(void)loginGoGoGo:(NSString *)username and:(NSString *)password
{
    
    //显示一个蒙板
    [MBProgressHUD showMessage:@"正在登录中..."];
  
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    params[@"account"]=username;
    params[@"password"]=password;
    
    //4.发送请求
    [mgr POST:@"http://60.12.220.16:8888/paladin/Passport/dologin" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //请求成功
        JYLoginStatus *status=[JYLoginStatus statusWithDict:responseObject];
        
        JYUserData *data=status.data;
        
        //5.存储模型数据
        //归档
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *file=[doc stringByAppendingPathComponent:@"account.data"];
        [NSKeyedArchiver archiveRootObject:data toFile:file];
        
        if([status.code isEqualToString:@"0"])
        {
            //移除遮盖
            [MBProgressHUD hideHUD];
            
            CYFMainViewController *cyfVc=[[CYFMainViewController alloc]init];
            JYNavigationController *navVc=[[JYNavigationController alloc]initWithRootViewController:cyfVc];
            self.view.window.rootViewController=navVc;

        }
        else if([status.code isEqualToString:@"330"])
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"用户名或者密码错误"];
        }
        else if([status.code isEqualToString:@"308"])
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"用户名活着邮箱重复"];
          
        }
        else if([status.code isEqualToString:@"300"])
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"没有登录"];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [MBProgressHUD showError:@"登录请求失败"];

    }];
}
//代理注册方法
-(void)registerGoGoGo
{
    JYRegisterViewController *registerVc=[[JYRegisterViewController alloc]init];
    self.view.window.rootViewController=registerVc;
}
@end
