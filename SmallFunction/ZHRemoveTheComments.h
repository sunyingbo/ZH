#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ZHRemoveTheCommentsTypeAllComments,//删除全部注释
    ZHRemoveTheCommentsTypeFileInstructionsComments,//删除文件说明注释
    ZHRemoveTheCommentsTypeEnglishComments,//删除英文注释
    ZHRemoveTheCommentsTypeDoubleSlashComments,//删除//注释
    ZHRemoveTheCommentsTypeFuncInstructionsComments//删除/ **\/或\/ ***\/注释
} ZHRemoveTheCommentsType;

@interface ZHRemoveTheComments : NSObject

+ (NSString *)BeginWithFilePath:(NSString *)filePath type:(ZHRemoveTheCommentsType)type;

@end