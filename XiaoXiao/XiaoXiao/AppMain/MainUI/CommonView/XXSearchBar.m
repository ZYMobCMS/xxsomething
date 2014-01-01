//
//  XXSearchBar.m
//  SearchBar
//
//  Created by ZYVincent on 13-12-23.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSearchBar.h"

@implementation XXSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat rightIconWidth = 25;
        self.placeHoldString = @"请输入学校关键字";
        
        backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width,frame.size.height)];
        backgroundImageView.image = [UIImage imageNamed:@"search_bar_back.png"];
        [self addSubview:backgroundImageView];
        
        self.contentTextField = [[UITextField alloc]initWithFrame:CGRectMake(8,5,frame.size.width-8,frame.size.height-10)];
        [self addSubview:self.contentTextField];
        self.contentTextField.placeholder = self.placeHoldString;
        self.contentTextField.delegate = self;
        self.contentTextField.returnKeyType = UIReturnKeySearch;
        self.contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        rightIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-25-8,9,rightIconWidth,rightIconWidth)];
        rightIconImageView.image = [UIImage imageNamed:@"search_icon.png"];
        [self addSubview:rightIconImageView];
        rightIconImageView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchInputValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchInputBeginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setBeginSearchBlock:(XXSearchBarDidBeginSearchBlock)beginBlock
{
    _beginBlock = [beginBlock copy];
}
- (void)setValueChangedBlock:(XXSearchBarValueChangeBlock)valueChangeBlock
{
    _valueChangeBlock = [valueChangeBlock copy];
}

//不允许全部为空
+ (BOOL)formValidateIsAllSpace:(NSString*)sourceString
{
    BOOL status = YES;
    int postion = 0;
    while (postion<=sourceString.length-1) {
        
        NSString *subChar = [sourceString substringWithRange:NSMakeRange(postion,1)];
        if (![subChar isEqualToString:@" "]) {
            status = NO;
            break;
        }
        postion++;
    }
    return status;
}

- (void)searchInputBeginEdit:(NSNotification*)noti
{
    rightIconImageView.hidden=YES;
}

- (void)searchInputValueChanged:(NSNotification*)noti
{
    if (_valueChangeBlock ) {
        if (self.contentTextField.text.length>0) {
            self.searchText = self.contentTextField.text;
            _valueChangeBlock(YES,self.contentTextField.text);
        }
    }
}
#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        [textField resignFirstResponder];
        return YES;
    }else{
        return NO;
    }
}
- (void)finishChooseWithNameText:(NSString *)name
{
    [self.contentTextField resignFirstResponder];
    self.contentTextField.text = name;
    self.searchText = name;
    rightIconImageView.hidden = NO;
    rightIconImageView.image = [UIImage imageNamed:@"blue_right_selected.png"];
}

@end
