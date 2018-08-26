//
//  UpdateDeviceViewController.m
//  AlexaSDKHost
//
//  Created by snake on 10/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

#import "F3UpdateDeviceViewController.h"
#import "CustomLinkLabel.h"
#import "RVBluetoothDeviceF3.h"
#import "RVBluetoothManager.h"
#import <ZXMoblie/ZXMoblie.h>
#import <ZXMoblie/UIView+AutoLayout.h>
#import "SettingsFeedBackViewController.h"
#import "OTAUpdateManagerF3.h"
#import "SSZipArchive.h"
#import "UpdateProgressView.h"
#import "MBProgressHUD.h"
#import "ROVSettingManager.h"
#import "ROVSettingDefine.h"
#import "ROVSimpleH5ViewController.h"
#import "StorageKeyValueDefine.h"
#import "RVKVStorageManager.h"
#import <OWAccount/OWAccount.h>



@interface F3UpdateDeviceViewController ()<CustomLinkLabelDelegate,OTAUpdateManagerF3Delegate,SSZipArchiveDelegate>
@property (nonatomic, assign) BOOL isUpdateSuccess;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *noUpdateView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *curVersionLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) CustomLinkLabel *bottomLabel;
@property (nonatomic, strong) UIView *updateView;
@property (nonatomic, strong) UILabel *updateLabel;
@property (nonatomic, strong) UILabel *currentVerLabel;
@property (nonatomic, strong) UILabel *latestVerLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *updateBtn;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UpdateProgressView *updateProgressView;

@property (nonatomic, strong) OTAUpdateManagerF3 *otaUpdateManager;

@end

@implementation F3UpdateDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RV_MAIN_BACKGROUNDCOLOR;
    self.title = RVLocalize(@"Update Device");
    _otaUpdateManager = [OTAUpdateManagerF3 sharedManager];
    _otaUpdateManager.delegate = self;
    _isUpdateSuccess = NO;
    [self setupSubViews];
    if (_isUpdateAvailable) {
        _noUpdateView.hidden = YES;
        _updateView.hidden = NO;
        [self showUpdateAvailable];
    } else {
        _noUpdateView.hidden = YES;
        _updateView.hidden = YES;
//        [self checkOtaUpgrade];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkOtaUpgrade];
        });
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readDeviceValue:) name:kNFBLEF3DidReadValue object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super  viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showUpdateAvailable];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubViews {
    UIImage *image = [UIImage imageNamed:@"F1"];
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCALEHeight*45, SCALEWidth*139, SCALEWidth*220)];
    _iconView.image = image;
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_iconView];
    _iconView.x = self.view.x;

    //init noupdateView
    _noUpdateView = [[UIView alloc] initWithFrame:CGRectMake(0, _iconView.bottom+20, SCWidth, SCHeight-64-_iconView.bottom)];
    _noUpdateView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_noUpdateView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCWidth, 28*SCALEHeight)];
    _titleLabel.textColor = mUIColorWithValue(0x323232);
    _titleLabel.font = RVFont_20;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = RVLocalize(@"Your device is up to date");
    [_noUpdateView addSubview:_titleLabel];
    
    _curVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom+4, SCWidth, 21*SCALEHeight)];
    _curVersionLabel.textColor = RV_TABLEHEADER_GRAY;
    _curVersionLabel.font = RVFont_14;
    _curVersionLabel.textAlignment = NSTextAlignmentCenter;
    [_noUpdateView addSubview:_curVersionLabel];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _curVersionLabel.bottom+114*SCALEHeight, SCWidth, 42*SCALEHeight)];
    _currentVerLabel.numberOfLines = 0;
    _tipLabel.textColor = mUIColorWithValue(0x666666);
    _tipLabel.font = RVFont_14;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.text = RVLocalize(@"Device will restart immediately.\nGo to connect device.");
    [_noUpdateView addSubview:_tipLabel];
    _tipLabel.hidden = YES;
    
    
    _bottomLabel = [[CustomLinkLabel alloc] initWithFrame:CGRectMake(0, _noUpdateView.height - 60*SCALEHeight, SCWidth, 21*SCALEHeight)];
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    _bottomLabel.font = RVFont_14;
    _bottomLabel.textColor = RV_TABLEHEADER_GRAY;
    _bottomLabel.text = RVLocalize(@"Chat with Roav if you need any help.");
    _bottomLabel.linkColor = RV_ORANGE;
    _bottomLabel.delegate = self;
    NSArray *linkAry = [NSArray arrayWithObjects:RVLocalize(@"Chat with Roav"), nil];
    [_bottomLabel setLinkContents:linkAry];
    [_noUpdateView addSubview:_bottomLabel];
    
    if([RVCommonUtil isIphoneX]) {
        _bottomLabel.top -= 40;
    }
    
    //init updateView
    _updateView = [[UIView alloc] initWithFrame:_noUpdateView.frame];
    _updateView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_updateView];
    
    _updateLabel = [[UILabel alloc] initWithFrame:_titleLabel.frame];
    _updateLabel.textColor = mUIColorWithValue(0x323232);
    _updateLabel.font = RVFont_20;
    _updateLabel.textAlignment = NSTextAlignmentCenter;
    _updateLabel.text = RVLocalize(@"New Version Available");
    [_updateView addSubview:_updateLabel];
    
    _currentVerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _updateLabel.bottom+4, SCWidth, 21*SCALEHeight)];
    _currentVerLabel.textColor = RV_TABLEHEADER_GRAY;
    _currentVerLabel.font = RVFont_14;
    _currentVerLabel.textAlignment = NSTextAlignmentCenter;
//    _currentVerLabel.text = RVLocalize(@"Current Version 1.2.4");
    [_updateView addSubview:_currentVerLabel];
    
    _latestVerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _currentVerLabel.bottom, SCWidth, 21*SCALEHeight)];
    _latestVerLabel.textColor = RV_TABLEHEADER_GRAY;
    _latestVerLabel.font = RVFont_14;
    _latestVerLabel.textAlignment = NSTextAlignmentCenter;
//    _latestVerLabel.text = RVLocalize(@"Latest Version 1.3.0");
    [_updateView addSubview:_latestVerLabel];
    
    _updateBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCWidth-315*SCALEWidth)/2,_updateView.height - 103*SCALEHeight,315*SCALEWidth,65*SCALEHeight)];
    _updateBtn.layer.cornerRadius = 7.0;
    _updateBtn.layer.masksToBounds = YES;
    [_updateBtn setTitle:RVLocalize(@"Update Device") forState:UIControlStateNormal];
    [_updateBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_p"] forState:UIControlStateNormal];
    [_updateBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_n"] forState:UIControlStateDisabled];
    [_updateBtn addTarget:self action:@selector(updateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_updateView addSubview:_updateBtn];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCWidth, 42*SCALEHeight)];
    _tipsLabel.numberOfLines = 0;
    _tipsLabel.bottom = _updateBtn.top - 18*SCALEHeight;
    _tipsLabel.textColor = mUIColorWithValue(0x666666);
    _tipsLabel.font = RVFont_14;
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.text = RVLocalize(@"Keep your device connected.\nIt will take few minutes.");
    [_updateView addSubview:_tipsLabel];
    
    _updateProgressView = [[UpdateProgressView alloc] initWithFrame:CGRectMake(0, 0, SCWidth, SCHeight)];

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, NAV_BACK_BUTTON_WIDTH, NAV_BACK_BUTTON_WIDTH);
    [btn setImage:[UIImage imageNamed:@"back_n"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onLeftButtonItemTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //shadow under navigation bar
    UIImage* sShadow = [UIImage imageNamed:@"down_shadow"];
    UIImage* rShadow = [sShadow resizableImageWithCapInsets:(UIEdgeInsets){.top=8,.bottom=8,.left=20,.right=20}];
    UIImageView* shadowIv = [[UIImageView alloc] initWithImage:rShadow];
    shadowIv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:shadowIv];
    [shadowIv al_alignLeft:0 toView:self.view];
    [shadowIv al_alignRight:0 toView:self.view];
    [shadowIv al_alignTop:0 toView:self.view];
}

- (void)onLeftButtonItemTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateBtnClick {
    if ([RVBluetoothManager shareManager].connectStatus != RVDeviceConnectStatusConnected) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:RVLocalize(@"Device not connected")
                                              message:RVLocalize(@"Please connect to the device and try again.")
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:RVLocalize(@"OK")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }

    _updateProgressView.titleStr = RVLocalize(@"Updating");
    _updateProgressView.detailStr = RVLocalize(@"Keep close to your device, and it’ll take few minutes to update.");
    [_updateProgressView setProgress:0.001];
    [_updateProgressView show];
    [_otaUpdateManager doStartOTAUpdate];
}

#pragma mark -CustomLinkLabelDelegate
- (void)didTapWithString:(NSString *)str inRange:(NSRange)range {
    if (![str isEqualToString:RVLocalize(@"Chat with Roav")]) return ;

    NSString * uid = [OWAAccountManager sharedManager].uid;
    NSString * urlStr = [NSString stringWithFormat:@"https://goroav.com/pages/live_chat_support?email=%@",uid];
    ROVSimpleH5ViewController* h5vc = [[ROVSimpleH5ViewController alloc] init];
    h5vc.urlStr = urlStr;
    [self.navigationController pushViewController:h5vc animated:YES];
}

#pragma mark - ota operator
- (void)checkOtaUpgrade {
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    _progressHUD.opaque = 0.3;
    _progressHUD.bezelView.backgroundColor = [UIColor whiteColor];
    _progressHUD.activityIndicatorColor = mUIColorWithValue(0x323232);
//    _progressHUD.minSize = CGSizeMake(160, 120);
    _progressHUD.dimBackground = YES;
    [_otaUpdateManager fetchOTAFilesInfo];
}

- (void)showTextAndDismiss:(NSString *)str {
//    [self showTextOnHud:RVLocalize(str)];
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressHUD.label.text = RVLocalize(str);
        [_progressHUD hideAnimated:YES afterDelay:2];
    });
}

- (void) showNoUpdateAvailable:(NSError *)error {
    BOOL hideVersion = NO;
    if (_progressHUD != nil) {
        [_progressHUD hideAnimated:YES];
        _progressHUD = nil;
    }
    _noUpdateView.hidden = NO;
    _updateView.hidden = YES;
    
    if(![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        _titleLabel.text = RVLocalize(@"Network unavailable.");
    } else if (error!=nil && error.code == OTA_ERROR_DEVICE_NOT_CONNECTED) {
        hideVersion = YES;
        _titleLabel.text = RVLocalize(@"Device not connected.");
    } else if (error!=nil && error.code == OTA_ERROR_NO_NEED_UPGRADE) {
        _titleLabel.text = RVLocalize(@"Your device is up to date");
    } else {
        _titleLabel.text = RVLocalize(@"Your device is up to date");
    }
    _tipLabel.hidden = YES;

    NSString *currVersion = [RVBluetoothManager shareManager].currentDevice.otaSoftVersion;
    if (is_string_void(currVersion)) {
        _curVersionLabel.hidden = YES;
    } else {
        _curVersionLabel.hidden = NO | hideVersion;
        _curVersionLabel.text = [RVLocalize(@"Current Version ") stringByAppendingString:currVersion];
    }
}

- (void) showUpdateAvailable {
    if (_progressHUD != nil) {
        [_progressHUD hideAnimated:YES];
        _progressHUD = nil;
    }
    _noUpdateView.hidden = YES;
    _updateView.hidden = NO;
    // 当前版本
    NSString *currVersion = [RVBluetoothManager shareManager].currentDevice.otaSoftVersion;
    if (is_string_void(currVersion)) {
        _currentVerLabel.hidden = YES;
    } else {
        _currentVerLabel.hidden = NO;
        _currentVerLabel.text = [RVLocalize(@"Current Version ") stringByAppendingString:currVersion];
    }
    // 最新版本
    NSString * otaVersion = [RVKVStorageManager getStringForKey:STORAGE_OTA_FIREMWARE_VERSION];
    if (is_string_void(currVersion)) {
        _latestVerLabel.hidden = YES;
    } else {
        _latestVerLabel.hidden = NO;
        _latestVerLabel.text = [RVLocalize(@"Latest Version ") stringByAppendingString:otaVersion];
    }
}

- (void) showLatestVersion {
//    NSLog(@"##%@=%@", RVLocalize(@"Update show lates version, isUpdateSuccess"),(_isUpdateSuccess ? RVLocalize(@"YES") : RVLocalize(@"NO")));
    if (!_isUpdateSuccess) return;
    _isUpdateSuccess = NO;
    
    _noUpdateView.hidden = NO;
    _updateView.hidden = YES;
    _titleLabel.text = RVLocalize(@"Your device is up to date");
    _tipLabel.hidden = YES;
    
    NSString *currVersion = [RVBluetoothManager shareManager].currentDevice.otaSoftVersion;
    if (is_string_void(currVersion)) {
        _curVersionLabel.hidden = YES;
    } else {
        _curVersionLabel.hidden = NO;
        _curVersionLabel.text = [RVLocalize(@"Current Version ") stringByAppendingString:currVersion];
    }
}

- (void) showUpdateSuccess {
    _isUpdateSuccess = YES;
    [_updateProgressView hide];
    _noUpdateView.hidden = NO;
    _updateView.hidden = YES;
    _titleLabel.text = RVLocalize(@"Update Successfully");
    _tipLabel.hidden = NO;
    _curVersionLabel.hidden = YES;
//    NSLog(@"##%@=%@", RVLocalize(@"Update upload success device isUpdateSuccess"),(_isUpdateSuccess ? RVLocalize(@"YES") : RVLocalize(@"NO")));
}

- (void) showUpdateFail {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:RVLocalize(@"Update Failed")
                                          message:RVLocalize(@"Update failed, would you try again?")
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:RVLocalize(@"Later")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                        }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:RVLocalize(@"Yes")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self updateBtnClick];
                                                     }];
    [alertController addAction:laterAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -OTAUpdateManagerF3Delegate
- (void)fetchOTAFilesInfoSuccess:(NSDictionary *)result {
    NSLog(@"##1## F3Ota fetch ota file info success");
}

- (void)fetchOTAFilesInfoFail:(NSError *)error {
    NSLog(@"##1## F3Ota fetch ota file info failed!");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showNoUpdateAvailable:error];
    });
}

- (void)downloadOTAFilesSuccess:(NSString *)filePath {
    NSLog(@"##2## F3Ota download ota file success!");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showUpdateAvailable];
    });
}

- (void)downloadOTAFilesFail:(NSError *)error {
    NSLog(@"##2## F3Ota download failed!");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showNoUpdateAvailable:error];
    });
}

- (void)downloadOTAFilesProgress:(CGFloat)progress {
    NSLog(@"##2## F3Ota download progress:%f", progress);
}

- (void)uploadOTAFilesProgress:(CGFloat)progress {
    NSLog(@"##3## F3Ota upload progress:%f", progress);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_updateProgressView setProgress:progress];
    });
}

- (void)uploadOTAFilesSuccess {
    NSLog(@"##3## F3Ota upload success.");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showUpdateSuccess];
    });
}

- (void)uploadOTAFilesFail {
    NSLog(@"##3## F3Ota upload Fail.");
    [_updateProgressView hide];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self showUpdateFail];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notifications
-(void) readDeviceValue : (NSNotification *) notif {
    NSDictionary* userInfo = notif.userInfo;
    NSString *firmwareVersion = userInfo[@(DeviceCmdF3FirmwareVersion)];
    if ( is_string_void(firmwareVersion) ) return ;
    NSLog(@"##Update read device firmware:%@ isUpdateSuccess=%@",
          firmwareVersion, (_isUpdateSuccess ? @"YES" : @"NO"));
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLatestVersion];
    });
}

@end
