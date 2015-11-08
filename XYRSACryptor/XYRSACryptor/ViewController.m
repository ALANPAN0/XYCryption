//
//  ViewController.m
//  XYRSACryptor
//
//  Created by Panda on 15/11/8.
//  Copyright © 2015年 Panda. All rights reserved.
//

#import "ViewController.h"
#import "XYSHASign.h"
#import "GTMBase64.h"
#import "XYRSACryptor.h"

@interface ViewController ()

@property (nonatomic, strong) XYRSACryptor *rsaCryptor;
@property (nonatomic, strong) XYSHASign *sign;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self XYRSACryptor];
}


- (void)XYRSACryptor {
    NSString *derPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    [self.rsaCryptor loadPublicKeyFromFile:derPath];
    
    NSString *p12Path = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
    [self.rsaCryptor loadPrivateKeyFromFile:p12Path password:@"123456"];

    NSString *enStr = @"Panda_iOS 喜欢的请关注我 Panda_iOS 喜欢的请关注我Panda_iOS 喜欢的请关注我Panda_iOS 喜欢的请关注我 Panda_iOS 喜欢的请关注我Panda_iOS 喜欢的请关注我Panda_iOS 喜欢的请关注我Panda_iOS ";

    //加解密
    NSData *enData = [self.rsaCryptor rsaEncryptData:
                      [enStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *deData = [self.rsaCryptor rsaDecryptData:enData];
    
    
    NSString *deStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
    NSLog(@"加密前： %@ \n 解密后： %@",enStr,deStr);
    
    //签名
    NSData *signedData = [self.sign sha256WithRSA:enData privateKey:[self.sign getPrivateKeyRefWithP12Path:p12Path]];
    NSLog(@"签名后的base64:%@",[GTMBase64 stringByEncodingData:signedData]);
    
    BOOL signSuccess = [self.rsaCryptor rsaSHA256VerifyData:enData withSignature:signedData];
    NSLog(@"是否签名成功：%@",signSuccess ? @"是":@"否");
}

- (XYRSACryptor *)rsaCryptor {
    if (!_rsaCryptor) {
        self.rsaCryptor = [[XYRSACryptor alloc] init];
    }
    return _rsaCryptor;
}

- (XYSHASign *)sign {
    if (!_sign) {
        self.sign = [[XYSHASign alloc] init];
        self.sign.passwordBlock = ^(){
            return @"123456";
        };
    }
    return _sign;
}

@end
