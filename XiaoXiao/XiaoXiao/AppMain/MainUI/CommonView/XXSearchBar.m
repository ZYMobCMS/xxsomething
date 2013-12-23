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
        
        backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width,frame.size.height)];
        backgroundImageView.backgroundColor = [UIColor blueColor];
        [self addSubview:backgroundImageView];
        
        contentTextField = [[UITextField alloc]initWithFrame:CGRectMake(8,5,frame.size.width-8,frame.size.height-10)];
        [self addSubview:contentTextField];
        contentTextField.placeholder = self.placeHoldString;
        contentTextField.delegate = self;
        contentTextField.returnKeyType = UIReturnKeySearch;
        contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        rightIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-25-8,9,rightIconWidth,rightIconWidth)];
        rightIconImageView.backgroundColor = [UIColor redColor];
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
        if (contentTextField.text.length>0) {
            BOOL enableState = [XXSearchBar formValidateIsAllSpace:contentTextField.text];
            NSString *msg = @"字符串合法";
            if (enableState) {
                msg = @"不能全部为空字符或者全部为空格";
            }
            _valueChangeBlock(enableState,msg);
        }
    }
}
#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (contentTextField.text.length>0) {
        return ![XXSearchBar formValidateIsAllSpace:contentTextField.text];
    }else{
        return NO;
    }
}
- (void)finishChooseWithNameText:(NSString *)name
{
    rightIconImageView.hidden = NO;
}

@end
