//
//  ConditionView.m
//  StoryBoard助手
//
//  Created by mac on 16/4/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ConditionView.h"
#import "ZHBlockSingleCategroy.h"

@interface ConditionView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger selectedIndex;
@end
@implementation ConditionView
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
        [_dataArr addObject:@"UIImageView"];
        [_dataArr addObject:@"UILabel"];
        [_dataArr addObject:@"UIButton"];
        [_dataArr addObject:@"UITextView"];
        [_dataArr addObject:@"UITextField"];
        [_dataArr addObject:@"UITableView"];
        [_dataArr addObject:@"UIView"];
        [_dataArr addObject:@"UISwitch"];
        [_dataArr addObject:@"UIWebView"];
        [_dataArr addObject:@"UICollectionView"];
        [_dataArr addObject:@"UISegmentedControl"];
        [_dataArr addObject:@"UISlider"];
        [_dataArr addObject:@"UIActivityIndicatorView"];
        [_dataArr addObject:@"UIProgressView"];
        [_dataArr addObject:@"UIPageControl"];
        [_dataArr addObject:@"UIStepper"];
        [_dataArr addObject:@"UIScrollView"];
        [_dataArr addObject:@"UIDatePicker"];
        [_dataArr addObject:@"UIPickerView"];
        [_dataArr addObject:@"UISearchBar"];
    }
    return _dataArr;
}

- (BOOL)validateNumber:(NSString*)number{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (IBAction)cancleAction:(id)sender {
    if (self.type==1) {
        [ZHBlockSingleCategroy runBlockNULLIdentity:@"removeConditionNew"];
    }else{
        [ZHBlockSingleCategroy runBlockNULLIdentity:@"removeConditionView"];
    }
}

- (IBAction)okAction:(id)sender {
    if (self.count.text.length>0) {
        if ([self validateNumber:self.count.text]==NO) {
            [ZHHelp AlertMsg:@"不是数字"];
            return;
        }
        NSString *conditionString=[NSString stringWithFormat:@"%@个%@",self.count.text,self.dataArr[self.selectedIndex]];
        if (self.type==1) {
            [ZHBlockSingleCategroy runBlockNSStringIdentity:@"addConditionNew" Str1:conditionString];
        }else{
            [ZHBlockSingleCategroy runBlockNSStringIdentity:@"addCondition" Str1:conditionString];
        }
    }
    if (self.type==1) {
        [ZHBlockSingleCategroy runBlockNULLIdentity:@"removeConditionNew"];
    }else{
        [ZHBlockSingleCategroy runBlockNULLIdentity:@"removeConditionView"];
    }
}

- (void)awakeFromNib{
    _pickView.delegate=self;
    _pickView.dataSource=self;
    [self.count cornerRadiusWithFloat:5 borderColor:[UIColor blackColor] borderWidth:1];
    [self.pickView cornerRadiusWithFloat:5 borderColor:[UIColor blackColor] borderWidth:1];
    self.count.placeholder=@"必填";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

/**一组当中有多少列*/
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArr.count;
}

/**选择某一列*/
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedIndex=row;
}

/**每一列的标题*/
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArr[row];
}

/**每一列的高度*/
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0f;
}
@end
