//
//  ViewController.m
//  Test1
//
//  Created by bigyelow on 02/06/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

#import "ViewController.h"
#import "SubTestExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  SubTestExtension *se = [[SubTestExtension alloc] init];
  [se setIdentifier:@"hh"];

  NSLog(@"id = %@", se.identifier);
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
