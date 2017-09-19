//
//  ViewController.m
//  iOS_XML
//
//  Created by Herbert Hu on 2017/9/18.
//  Copyright © 2017年 Herbert Hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSXMLParserDelegate> {
    
    NSString *currentElement;
    NSString *currentValue;
    NSMutableDictionary *rootDic;
    NSMutableArray *finalArray;
}
@property (strong, nonatomic) NSArray *keyElements;
@property (strong, nonatomic) NSArray *rootElements;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)start_Parse_With_NSXMLParser:(id)sender {
    
    // 遇到节点 message 和 user 时作为一个字典存放
    self.keyElements = [[NSArray alloc] initWithObjects:@"message", @"user", nil];
    // 需要解析的字段
    self.rootElements = [[NSArray alloc] initWithObjects:@"message", @"name", @"age", @"school", nil];
    // 获取 XML 文件路径
    NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"users.xml" ofType:nil];
    // 转化为 NSData
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:xmlFilePath];
    
    // 初始化
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    
    xmlParser.delegate = self;
    
    BOOL flag = [xmlParser parse];
    
    if (flag) {
        NSLog(@"parse successful.");
    }
    else {
        NSLog(@"parse failed.");
    }
}

#pragma mark - 开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
    finalArray = [[NSMutableArray alloc] init];
}

#pragma mark - 发现节点时
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    for (NSString *key in self.keyElements) {
        if ([elementName isEqualToString:key]) {
            
            rootDic = nil;
            rootDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        else {
            
            for (NSString *element in self.rootElements) {
                if ([elementName isEqualToString:element]) {
                    currentElement = elementName;
                    currentValue = [NSString string];
                }
            }
        }
    }
}

#pragma mark - 发现节点值时
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (currentElement) {
        
        currentValue = string;
        [rootDic setObject:string forKey:currentElement];
    }
}

#pragma mark - 结束节点时
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if (currentElement) {
        
        [rootDic setObject:currentValue forKey:currentElement];
        currentElement = nil;
        currentValue = nil;
    }
    
    for (NSString *key in self.keyElements) {
        
        if ([elementName isEqualToString:key]) {
            // 关键节点结束时，将字典存入数组中
            if (rootDic) {
                
                [finalArray addObject:rootDic];
            }
        }
    }
}

#pragma mark - 解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    NSLog(@"%@", finalArray);
}



@end
