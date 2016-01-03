//
//  STLeftSliderController.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STLeftSliderController.h"
#import "STLeftSliderView.h"
#import "STSliderCell.h"
#import "AppDelegate.h"
#import "UIImage+ST.h"

@interface STLeftSliderController ()<UITableViewDataSource,UITableViewDelegate,STLeftSliderViewDelegate>
@property(nonatomic,strong)NSArray *imageNames;
@property(nonatomic,strong)NSArray *descArray;
@end

@implementation STLeftSliderController

-(NSArray *)imageNames
{
    if (_imageNames==nil) {
        NSArray *imgNames=[NSArray arrayWithObjects:@"slide_icon_gitway",@"slide_icon_location",@"slide_icon_setting",@"slide_icon_aboutus",@"slide_icon_company", nil];
        _imageNames=imgNames;
    }
    return _imageNames;
}
-(NSArray *)descArray
{
    if (_descArray==nil) {
        NSArray *descArray=[NSArray arrayWithObjects:@"我的网关", @"一键场景",@"一键设备",@"关于我们",@"公司简介",nil];
        _descArray=descArray;
    }
    return _descArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    STLeftSliderView *leftSliderView=[STLeftSliderView initWithSliderView];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    leftSliderView.uesername.text=appDelegate.username;
    leftSliderView.userEmail.text=appDelegate.email;
    
    leftSliderView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:leftSliderView];
    leftSliderView.delegate=self;
    
    [leftSliderView.portraitBtn setBackgroundImage:[UIImage imageNamed:@"UserPhoto"] forState:UIControlStateNormal];
  
    
    leftSliderView.sliderTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    leftSliderView.sliderTableView.bounces=NO;
    leftSliderView.sliderTableView.dataSource=self;
    leftSliderView.sliderTableView.delegate=self;
}
#pragma mark - STLeftSliderViewDelegate
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"sliderCell";
    STSliderCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (sliderCell==nil)
    {
        sliderCell=[STSliderCell initWithSTSliderCell];
        sliderCell.iconImage.image=[UIImage imageNamed:self.imageNames[indexPath.row]];
        
        [sliderCell.descBtn setTitle:self.descArray[indexPath.row] forState:UIControlStateNormal];
        [sliderCell.descBtn setTitleColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] forState:UIControlStateNormal];
        
        UIColor *color=[[UIColor alloc]initWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0];
        sliderCell.selectedBackgroundView=[[UIView alloc]initWithFrame:sliderCell.frame];
        sliderCell.selectedBackgroundView.backgroundColor=color;
    }
    
    // Configure the cell...
    
    return sliderCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat originH=50;
    CGFloat originW=320;
    CGFloat newH=(self.view.frame.size.width*originH)/originW;
    return newH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}
@end
