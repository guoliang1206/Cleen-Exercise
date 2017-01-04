//
//  CustomCell.m
//  Cleen-Exercise
//
//  Created by os x on 17/1/4.
//  Copyright © 2017年 Guo. All rights reserved.
//

#import "CustomCell.h"
#import "UIImageView+WebCache.h"

@interface CustomCell ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;


@end

@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setCellWithModel:(NSDictionary *)model{
    
    NSString *title = [model objectForKey:@"title"];
    NSString *description = [model objectForKey:@"description"];
    NSString *imageHref = [model objectForKey:@"imageHref"];
    
    if (![title isEqual:[NSNull null]]) {
      self.titleLabel.text = title;
    }
    if (![description isEqual:[NSNull null]]) {
        self.contentLabel.text = description;
    }
    if (![imageHref isEqual:[NSNull null]]) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageHref] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }
    
}



@end
