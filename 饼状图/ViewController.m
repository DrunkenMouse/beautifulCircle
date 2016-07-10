//
//  ViewController.m
//  饼状图
//
//  Created by 王奥东 on 16/7/10.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "bridger.swift"
#import "饼状图-Bridging-Header.h"
#import "Masonry.h"

@interface ViewController ()

@property(nonatomic,strong)PieChartView *pieChartView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    //创建并添加饼状图
    PieChartView *pieChart = [[PieChartView alloc]init];
    pieChart.backgroundColor = [UIColor greenColor];
    [self.view addSubview:pieChart];
    
    [pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.center.mas_equalTo(self.view);
    }];
    
    
    //外观样式的设置
    
    //基本样式
    //饼状图距离边缘的间隙
    [pieChart setExtraOffsetsWithLeft:30 top:0 right:30 bottom:0];
    //是否根据所提供的数据，将显示数据转换为百分比格式
    pieChart.usePercentValuesEnabled = YES;
    //拖曳饼状图后是否有惯性效果
    pieChart.dragDecelerationEnabled = YES;
    //是否显示区块文本
    pieChart.drawSliceTextEnabled = YES;
    
    
    //设置饼状图中间的空心样式
    //空心有两个圆组成，一个是hole，一个是transparentCircle
    //transparCircle里面是hole，所以中间的空心也就是一个同心圆
    //饼状图是否是空心
    pieChart.drawHoleEnabled = YES;
    //空心半径占比
    pieChart.holeRadiusPercent = 0.5;
    //空心颜色
    pieChart.holeColor = [UIColor clearColor];
    //半透明空心半径占比
    pieChart.transparentCircleRadiusPercent = 0.5;
    pieChart.transparentCircleColor = [UIColor colorWithRed:210/255.0 green:145/255.0 blue:133/255.0 alpha:1];

    //设置饼状图中心的文本
    if (pieChart.isDrawHoleEnabled == YES) {
        //是否显示中间文字
        pieChart.drawCenterTextEnabled = YES;
        //普通文本,字体颜色大小等不可设置
//        pieChart.centerText = @"饼状图";
        //富文本,可以设置字体颜色大小等
        NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc]initWithString:@"饼状图"];
        [centerText setAttributes:@{
                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                    NSForegroundColorAttributeName:[UIColor orangeColor]
                                    } range:NSMakeRange(0,centerText.length)];
        pieChart.centerAttributedText = centerText;
        
    }
    
    //设置饼状图描述
    pieChart.descriptionText = @"饼状图示例";
    pieChart.descriptionFont = [UIFont systemFontOfSize:10];
    pieChart.descriptionTextColor = [UIColor grayColor];
    
    //设置饼状图图例的样式
    //图例在饼状图中的大小占比，这回影响图例的宽高
    pieChart.legend.maxSizePercent = 1;
    //文本间隔
    pieChart.legend.formToTextSpace = 5;
    //字体大小
    pieChart.legend.font = [UIFont systemFontOfSize:10];
    //字体颜色
    pieChart.legend.textColor = [UIColor grayColor];
    //图例在饼状图中的样式
    pieChart.legend.position = ChartLegendPositionBelowChartCenter;
    //图示样式：方形、线条、圆形
    pieChart.legend.form = ChartLegendFormCircle;
    //图示大小
    pieChart.legend.formSize = 12;
//
    pieChart.data = [self setData];
  
    
}

- (PieChartData *)setData{
    
    double mult = 100;
    int count = 5;//饼状图总共有几块组成
    
    //每个区块的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        double randomVal = arc4random_uniform(mult + 1);
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithValue:randomVal xIndex:i];
        [yVals addObject:entry];
    }
    
    //每个区块的名称或描述
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        NSString *title = [NSString stringWithFormat:@"part%d", i+1];
        [xVals addObject:title];
    }
    
    //dataSet
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals label:@""];
    dataSet.drawValuesEnabled = YES;//是否绘制显示数据
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    dataSet.colors = colors;//区块颜色
    dataSet.sliceSpace = 0;//相邻区块之间的间距
    dataSet.selectionShift = 8;//选中区块时, 放大的半径
    dataSet.xValuePosition = PieChartValuePositionInsideSlice;//名称位置
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;//数据位置
    //数据与区块之间的用于指示的折线样式
    dataSet.valueLinePart1OffsetPercentage = 0.85;//折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
    dataSet.valueLinePart1Length = 0.5;//折线中第一段长度占比
    dataSet.valueLinePart2Length = 0.4;//折线中第二段长度最大占比
    dataSet.valueLineWidth = 1;//折线的粗细
    dataSet.valueLineColor = [UIColor brownColor];//折线颜色
    
    //data
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    formatter.maximumFractionDigits = 0;//小数位数
    formatter.multiplier = @1.f;
    [data setValueFormatter:formatter];//设置显示数据格式
    [data setValueTextColor:[UIColor brownColor]];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    
    return data;
}


//   //饼状图的数据设置
//-(PieChartData *)setData{
//    
//    double mult = 100;
//    //饼状图总共有几块组成
//    int count = 5;
//    
//    //每个区块的数据
//    NSMutableArray *yVals = [[NSMutableArray alloc]init];
//    for (int i = 0; i < count; i++) {
//        
//        double randomVal = arc4random_uniform(mult+1);
//        BarChartDataEntry *entry = [[BarChartDataEntry alloc]initWithValue:randomVal xIndex:i];
//        [yVals addObject:entry];
//        
//    }
//    
//    //每个区块的名称或描述
//    NSMutableArray *xVals = [[NSMutableArray alloc]init];
//    for (int i = 0; i < count; i++) {
//        NSString *titile = [NSString stringWithFormat:@"part%d",i+1];
//        [xVals addObject:titile];
//    }
//    
//    
//    //创建pieChartDataSet对象，通过dataSet放进去yVals
//    //创建pieChartData对象，通过data将xVals与dataSet放进去
//    //最后直接将data赋值给饼状图的data属性
//    
//    //dataset
//    PieChartDataSet *dataSet = [[PieChartDataSet alloc]initWithYVals:yVals label:@""];
//    //是否绘制显示数据
//    dataSet.drawValuesEnabled = YES;
//    NSMutableArray *colors = [[NSMutableArray alloc]init];
//        [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
//        [colors addObjectsFromArray:ChartColorTemplates.joyful];
//        [colors addObjectsFromArray:ChartColorTemplates.colorful];
//        [colors addObjectsFromArray:ChartColorTemplates.liberty];
//        [colors addObjectsFromArray:ChartColorTemplates.pastel];
//    
//    //区块颜色
//    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1]];
//    dataSet.colors = colors;
//    //相邻区块之间的间距
//    dataSet.sliceSpace = 0;
//    //选中区块时，放大的半径
//    dataSet.selectionShift = 8;
//    //名称位置
//    dataSet.xValuePosition = PieChartValuePositionInsideSlice;
//    //数据位置
//    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
//    //数据与区块之间的用于指示的折现样式
//    //折线中第一段起始位置相对于区块的偏移量，数值越大，折线距离区块越远
//    dataSet.valueLinePart1OffsetPercentage = 0.85;
//    //折线中第一段长度占比
//    dataSet.valueLinePart1Length = 0.5;
//    //折线中第二段长度最大占比
//    dataSet.valueLinePart2Length = 0.4;
//    //折线的粗细
//    dataSet.valueLineWidth = 1;
//    //折线颜色
//    dataSet.valueLineColor = [UIColor brownColor];
//    
//    
//    //data
//    PieChartData *data = [[PieChartData alloc]initWithXVals:xVals dataSets:dataSet];
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
//    formatter.numberStyle = NSNumberFormatterPercentStyle;
//    //小数位数
//    formatter.maximumFractionDigits = 0;
//    formatter.multiplier = @1.f;
//    //设置显示数据格式
//    [data setValueFormatter:formatter];
//    [data setValueTextColor:[UIColor brownColor]];
//    [data setValueFont:[UIFont systemFontOfSize:10]];
//    
//    return data;
//    
//    
//}
//
//
//
//
//





















@end
