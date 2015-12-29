//
//  STHomeView.m
//  STHome
//
//  Created by gujinyue on 15/12/29.
//  Copyright © 2015年 gujinyue. All rights reserved.
//

#import "STHomeView.h"

@implementation STHomeView

- (IBAction)officeClick:(id)sender
{
    NSLog(@"officeClick");
}

- (IBAction)homeClick:(id)sender
{
    NSLog(@"homeClick");
}

- (IBAction)universalClick:(id)sender
{
    NSLog(@"universalClick");
}

- (IBAction)singleClick:(id)sender
{
    NSLog(@"singleClick");
}

+(instancetype)initWithSThomeView
{
    STHomeView *homeView=[[[NSBundle mainBundle]loadNibNamed:@"STHomeView" owner:nil options:nil]lastObject];
    
    return homeView;
}
@end
