//
//  XYCryptionTests.m
//  XYCryptionTests
//
//  Created by 潘显跃 on 16/1/24.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XYRSACryption.h"

@interface XYCryptionTests : XCTestCase

@property (nonatomic, strong) XYRSACryption *rsa;

@end

@implementation XYCryptionTests

- (void)setUp {
    [super setUp];
    
    _rsa = [XYRSACryption new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // 加载公钥
    NSString *derPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"public_key" ofType:@"der"];
    [_rsa loadPublicKeyFromFile:derPath];
    
    // 加载私钥
    NSString *p12Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"private_key" ofType:@"p12"];
    [_rsa loadPrivateKeyFromFile:p12Path password:@"123456"];
    
    NSString *enStr = @"请替换为你要加密的文本内容！";
    
    // 加密后的数据
    NSData *enData = [_rsa rsaEncryptData:
                      [enStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 解密后的数据
    NSData *deData = [_rsa rsaDecryptData:enData];
    NSString *deStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(enStr, deStr, @"解密失败!");
    
    // 签名
    NSData *signedData = [_rsa sha256WithRSA:enData];
    
    // 对前面进行验证
    BOOL result = [_rsa rsaSHA256VertifyingData:enData withSignature:signedData];
    XCTAssertTrue(result, @"验签失败");

}

@end
