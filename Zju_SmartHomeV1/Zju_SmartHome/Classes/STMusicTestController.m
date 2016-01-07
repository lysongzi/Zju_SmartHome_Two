//
//  STMusicTestController.m
//  Zju_SmartHome
//
//  Created by gujinyue on 16/1/7.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "STMusicTestController.h"
#import "HttpRequest.h"

@interface STMusicTestController ()

@end

@implementation STMusicTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)palypause:(id)sender
{
    [HttpRequest getMusicActionfromProtol:self.protolName.text andValue:self.value.text success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
         NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"请求成功：%@",result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败：%@",error);
    }];
}

- (IBAction)previous:(id)sender
{
    [HttpRequest getMusicActionfromProtol:self.protolName.text andValue:self.value.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"请求成功：%@",result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败：%@",error);
    }];
}

- (IBAction)next:(id)sender
{
    [HttpRequest getMusicActionfromProtol:self.protolName.text andValue:self.value.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"请求成功：%@",result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败：%@",error);
    }];
}
@end
