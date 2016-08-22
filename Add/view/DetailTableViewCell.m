#import "DetailTableViewCell.h"

@interface DetailTableViewCell ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,weak)DetailCellModel *dataModel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger selectedIndex;
@end

@implementation DetailTableViewCell

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
        
        [_dataArr addObject:@"UITableViewCell"];
        [_dataArr addObject:@"UICollectionViewCell"];
    }
    return _dataArr;
}
- (void)refreshUI:(DetailCellModel *)dataModel{
    _dataModel=dataModel;
    //设置分类
    for (NSString *str in self.dataArr) {
        if ([dataModel.category isEqualToString:str]) {
            NSInteger index=[self.dataArr indexOfObject:str];
            [self.pickView selectRow:index inComponent:0 animated:NO];
        }
    }
    //默认为UITableViewCell
    if (dataModel.category.length<=0) {
        dataModel.category=@"UITableViewCell";
    }
}

- (void)awakeFromNib{
    _pickView.delegate=self;
    _pickView.dataSource=self;
    [self.pickView cornerRadiusWithFloat:10 borderColor:[[UIColor redColor] colorWithAlphaComponent:0.4] borderWidth:1];
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
    [ZHBlockSingleCategroy runBlockNULLIdentity:@"cleanDo"];
    _dataModel.category=self.dataArr[self.selectedIndex];
    [ZHBlockSingleCategroy runBlockNSStringIdentity:@"AlertMsg" Str1:[NSString stringWithFormat:@"你选择的分类为%@",_dataModel.category]];
}

/**每一列的标题*/
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArr[row];
}

/**每一列的高度*/
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end