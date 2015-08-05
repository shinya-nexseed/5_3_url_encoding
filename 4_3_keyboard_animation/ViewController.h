//
//  ViewController.h
//  4_3_keyboard_animation
//
//  Created by Shinya Hirai on 2015/07/29.
//  Copyright (c) 2015年 Shinya Hirai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

