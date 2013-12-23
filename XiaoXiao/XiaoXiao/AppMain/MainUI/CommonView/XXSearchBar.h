//
//  XXSearchBar.h
//  SearchBar
//
//  Created by ZYVincent on 13-12-23.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^XXSearchBarDidBeginSearchBlock) (void);
typedef void (^XXSearchBarValueChangeBlock) (BOOL canEnableNextStep,NSString *msg);

@interface XXSearchBar : UIView<UITextFieldDelegate>
{
    UIImageView *backgroundImageView;
    UITextField *contentTextField;
    UIImageView *rightIconImageView;
    
    XXSearchBarDidBeginSearchBlock _beginBlock;
    XXSearchBarValueChangeBlock _valueChangeBlock;
}
@property (nonatomic,strong)NSString *searchText;
@property (nonatomic,strong)NSString *placeHoldString;

+ (BOOL)formValidateIsAllSpace:(NSString*)sourceString;

- (void)setBeginSearchBlock:(XXSearchBarDidBeginSearchBlock)beginBlock;
- (void)setValueChangedBlock:(XXSearchBarValueChangeBlock)valueChangeBlock;
- (void)finishChooseWithNameText:(NSString*)name;

@end
