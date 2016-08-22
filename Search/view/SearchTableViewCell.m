#import "SearchTableViewCell.h"
#import "LagerImageViewController.h"

@interface SearchTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *promoteLabel;
@property (nonatomic,weak)SearchCellModel *dataModel;
@end


@implementation SearchTableViewCell

- (UIImageView *)getMyIconImageView{
    return self.iconImageView;
}
- (void)refreshUI:(SearchCellModel *)dataModel{
    
    _dataModel=dataModel;
    if (dataModel.iconImage.length>0) {
        self.iconImageView.image=[UIImage imageNamed:dataModel.iconImage];
    }else{
        self.iconImageView.image=nil;
    }
    
    if (_dataModel.select) {
        self.selectImageView.image=[UIImage imageNamed:@"xuanzhong"];
    }else{
        self.selectImageView.image=[UIImage imageNamed:@"meixuanzhong"];
    }
    
    self.promoteLabel.hidden=dataModel.havCondition;
}


- (void)awakeFromNib {
    [self.iconImageView cornerRadiusWithFloat:10];
    [self.selectImageView addUITapGestureRecognizerWithTarget:self withAction:@selector(selectClick)];
    [self.selectImageView cornerRadiusWithBorderColor:[UIColor redColor] borderWidth:1];
}
- (void)selectClick{
    self.dataModel.select=!self.dataModel.select;
    if (_dataModel.select) {
        self.selectImageView.image=[UIImage imageNamed:@"xuanzhong"];
    }else{
        self.selectImageView.image=[UIImage imageNamed:@"meixuanzhong"];
    }
    [ZHBlockSingleCategroy runBlockNULLIdentity:@"selectCell"];
}

@end