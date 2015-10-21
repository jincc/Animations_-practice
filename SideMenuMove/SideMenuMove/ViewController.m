//
//  ViewController.m
//  SideMenuMove
//
//  Created by Jincc on 15/10/20.
//  Copyright © 2015年 Jincc. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"
@interface ViewController ()


@property (nonatomic  ,strong) MenuView *menuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushMenu:(id)sender {
    
    [[self menuView] pop];
}
-(MenuView *)menuView{
    if (!_menuView) {
        _menuView = [[MenuView alloc]init];
    }
    return _menuView;
}
@end
