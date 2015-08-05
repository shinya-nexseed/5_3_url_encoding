//
//  ViewController.m
//  4_3_keyboard_animation
//
//  Created by Shinya Hirai on 2015/07/29.
//  Copyright (c) 2015年 Shinya Hirai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    CGSize _screenSize;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 画面のサイズを取得 (width,heigth 両方)
    _screenSize = [[UIScreen mainScreen] bounds].size;
    NSLog(@"w%f : h%f",_screenSize.width,_screenSize.height);
    
    self.searchBar.delegate = self;
    
    // キーボードのイベントを取得する
    // キーボードが表示された時の通知を登録する
    // 書き方には2種類あります
    
    // 準備
    NSNotificationCenter *center; // 通知取得用のオブジェクト定義
    center = [NSNotificationCenter defaultCenter]; // 初期化
    
    // パターン１ - 表示されたとき
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // パターン２ - 閉じるとき
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"keyboardWiilShow");
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         // キーボードのフレーム
                         CGSize keyboardFrameSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
                         NSLog(@"kw%f : kh%f",keyboardFrameSize.width,keyboardFrameSize.height);
                         
                         _searchBar.translatesAutoresizingMaskIntoConstraints = YES;
                         _searchBar.frame = CGRectMake(0, (_screenSize.height - (keyboardFrameSize.height + 44)), _screenSize.width, 44);
                         self.searchBar.showsCancelButton = YES;
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished animation");
                     }];
    

}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"keyboardWiilHide");
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         
                         _searchBar.translatesAutoresizingMaskIntoConstraints = YES;
                         _searchBar.frame = CGRectMake(0, _screenSize.height - 44, _screenSize.width, 44);
                         self.searchBar.showsCancelButton = NO;
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished animation");
                     }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search button clicked");
    NSLog(@"search text = %@",_searchBar.text);
    
    // URLエンコード処理
    NSString *encodeStr = [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Encode str = %@", encodeStr);
    
    // wiki api叩く
    NSString *urlString = [NSString stringWithFormat:@"http://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&titles=%@&rvprop=content",encodeStr];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error = nil;
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"%@",jsonObject);
    
    // 辞書データのキーを取得する
    NSLog(@"キー = %@",[jsonObject[@"query"][@"pages"] allKeys]);
    NSString *idStr = [jsonObject[@"query"][@"pages"] allKeys][0];

    
    // jsonObjectから必要なデータを取得する
    NSString *title = jsonObject[@"query"][@"pages"][idStr][@"title"];
    
    // 取得したデータをmyLabelに表示する
    self.myLabel.text = title;
    
    NSString *body = jsonObject[@"query"][@"pages"][idStr][@"revisions"][0][@"*"];
    NSLog(@"body = %@",body);
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel button clicked");
    [_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
