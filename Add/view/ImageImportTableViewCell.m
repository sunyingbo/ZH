#import "ImageImportTableViewCell.h"

@interface ImageImportTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic,strong)ImageImportCellModel *dataModel;
@end

@implementation ImageImportTableViewCell

- (void)refreshUI:(ImageImportCellModel *)dataModel{
    _dataModel=dataModel;
    if (dataModel.imagePath>0) {
        self.iconImageView.image=[UIImage imageNamed:dataModel.imagePath];
    }else{
        self.iconImageView.image=nil;
    }
}

- (void)awakeFromNib {
    [self.iconImageView cornerRadiusWithFloat:10 borderColor:[UIColor blackColor] borderWidth:1];
    [self addUITapGestureRecognizerWithTarget:self withAction:@selector(setImage)];
}

- (void)setImage{
    NSString *macDesktopPath=[ZHFileManager getMacDesktop];
    macDesktopPath = [macDesktopPath stringByAppendingPathComponent:@"代码助手.m"];
    [ZHFileManager createFileAtPath:macDesktopPath];
    NSString *Msg=@"文件已经生成在桌面,名字为\"代码助手.m\",请填写图片路径";
    
    [ZHAlertAction alertWithTitle:@"导入图片" withMsg:Msg addToViewController:[self getViewController] withCancleBlock:nil withOkBlock:^{
        
        NSString *path=[NSString stringWithContentsOfFile:macDesktopPath encoding:NSUTF8StringEncoding error:nil];
        
        if ([ZHFileManager fileExistsAtPath:path]==NO) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZHAlertAction alertWithMsg:@"图片路径不存在!请重新填写!" addToViewController:[self getViewController] ActionSheet:NO];
            });
            return ;
        }else{
            self.iconImageView.image=[UIImage imageNamed:path];
            if (self.iconImageView.image!=nil) {
                _dataModel.imagePath=path;
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZHAlertAction alertWithMsg:@"不是图片文件" addToViewController:[self getViewController] ActionSheet:NO];
                });
            }
        }
    } cancelButtonTitle:@"取消" OkButtonTitle:@"已填写好,导入图片" ActionSheet:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end