#import "Element.h"

@interface GroupingBox : Element
{
    NSMutableArray *__strong insideTheBox;
    int marginTop;
    int marginRight;
    //int highestYcoordiante;
    NSString *idPreviouslyKnownAs;
    NSMutableArray *nestedGroupingBoxes; // These are the other grouping boxes nested inside it
    int xcoordinate;
    int ycoordinate;
    int width;
    int height;
    float highestElementYco;
    float lowestElementBottomYco;
    
}
@property (nonatomic, strong) NSMutableArray *insideTheBox;
@property int marginTop;
@property int marginRight;
//@property int highestYcoordiante;
@property (strong, nonatomic) NSString *idPreviouslyKnownAs;
@property (strong, nonatomic) NSMutableArray *nestedGroupingBoxes;
@property int xcoordinate;
@property int ycoordinate;
@property int width;
@property int height;
@property float highestElementYco;
@property float lowestElementBottomYco;

@end
