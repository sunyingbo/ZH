#import "ReplaceCleanTableViewCell.h"
#import "ZHBlockSingleCategroy.h"
#import "CreatFatherFile.h"

@interface ReplaceCleanTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *buttonClean;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@property (nonatomic,strong)CreatFatherFile *cf;
@end

@implementation ReplaceCleanTableViewCell
- (void)refreshUI:(NSString *)buttons{
    NSArray *arr=[buttons componentsSeparatedByString:@"和"];
    if (arr.count==2) {
        [self.buttonAdd setTitle:arr[1] forState:(UIControlStateNormal)];
        [self.buttonClean setTitle:arr[0] forState:(UIControlStateNormal)];
    }
}
- (IBAction)addAction:(id)sender{
    if([self.buttonAdd.titleLabel.text isEqualToString:@"添加"]){
        [ZHBlockSingleCategroy runBlockNULLIdentity:@"addAction"];
    }else if([self.buttonAdd.titleLabel.text isEqualToString:@"修改"]){
        [ZHBlockSingleCategroy runBlockNULLIdentity:@"updataOldAction"];
    }
}
- (IBAction)cleanAction:(id)sender{
    if([self.buttonClean.titleLabel.text isEqualToString:@"重置"]){
        [ZHBlockSingleCategroy runBlockNULLIdentity:@"cleanAction"];
        [ZHBlockSingleCategroy runBlockNSStringIdentity:@"AlertMsg" Str1:@"重置成功"];
    }else{
        [ZHBlockSingleCategroy runBlockNULLIdentity:@"returnIndex"];
    }
}
- (void)awakeFromNib {
    [self.buttonAdd cornerRadiusWithFloat:10];
    [self.buttonClean cornerRadiusWithFloat:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end