#import "MemberTableViewCell.h"
#import "LosStyles.h"

@implementation MemberTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 33)];
        self.nameLabel.text = @"name";
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        self.cardsLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 33)];
        self.cardsLabel.text = @"cards";
        self.cardsLabel.textAlignment = NSTextAlignmentRight;
        self.cardsLabel.textColor = GRAY4;
        self.cardsLabel.font = [UIFont systemFontOfSize:14];
        
        self.consumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 33, 300, 33)];
        self.consumeLabel.text = @"consume";
        self.consumeLabel.textAlignment = NSTextAlignmentLeft;
        self.consumeLabel.textColor = GRAY4;
        self.consumeLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.cardsLabel];
        [self addSubview:self.consumeLabel];
    }
    return self;
}

@end
