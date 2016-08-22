#import "ConditionTableViewNewCell.h"

@interface ConditionTableViewNewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoteLabel;
@end

@implementation ConditionTableViewNewCell

- (void)refreshUI:(NSString *)title{
    if ([title isEqualToString:@"添加新的条件"]) {
        self.titleLabel.textColor=[UIColor redColor];
        self.titleLabel.font=[UIFont systemFontOfSize:18];
        self.promoteLabel.hidden=YES;
    }else if ([title isEqualToString:@"清空"]) {
        self.titleLabel.textColor=[UIColor redColor];
        self.titleLabel.font=[UIFont systemFontOfSize:18];
        self.promoteLabel.hidden=YES;
    }else{
        self.titleLabel.textColor=[UIColor blueColor];
        self.titleLabel.font=[UIFont systemFontOfSize:16];
        self.promoteLabel.hidden=NO;
    }
    self.titleLabel.text=title;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end