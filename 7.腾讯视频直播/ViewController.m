//
//  ViewController.m
//  7.腾讯视频直播
//
//  Created by apple on 2020/7/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ViewController.h"

@import TXLiteAVSDK_Professional;

@interface ViewController ()

@property (nonatomic, strong) TXLivePush * pusher;
@property (nonatomic, strong) TXLivePlayer * player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    _pusher = [self createPusher];
    _player = [self createPlayer];
}
// 开始推流
- (IBAction)startPush:(id)sender {
    [self startPush];
}
// 停止推流
- (IBAction)stopPush:(id)sender {
    [self stopPush];
}
// 开始拉流
- (IBAction)startPlay:(id)sender {
    [self startPlay];
}
// 停止拉流
- (IBAction)stopPlay:(id)sender {
    [self stopPlay];
}

- (TXLivePush *)createPusher {
    TXLivePushConfig *_config = [[TXLivePushConfig alloc] init];  // 一般情况下不需要修改默认 config
    TXLivePush *_pusher = [[TXLivePush alloc] initWithConfig: _config];
    return _pusher;
}
- (TXLivePlayer *)createPlayer{
    TXLivePlayConfig* config = _player.config;
    config.enableMessage = YES;
    _player = [[TXLivePlayer alloc] init];
    [_player setConfig:config];
    return _player;
}

- (void)startPush{
    //创建一个 view 对象，并将其嵌入到当前界面中
    UIView *_localView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_localView atIndex:0];
    _localView.center = self.view.center;
    //启动本地摄像头预览
    [_pusher startPreview:_localView];
    NSString* rtmpUrl = @"rtmp://94642.livepush.myqcloud.com/live/liangsenPlayStreamm?txSecret=e6c909070b49dcc7f8bfbfc184206a3c&txTime=5F22772C";
    int result = [_pusher startPush:rtmpUrl];
    NSLog(@"result:%d", result);
}
- (void)stopPush {
    if (_pusher) {
        [_pusher setDelegate:nil];
        [_pusher stopPreview];
        [_pusher stopPush];
    }
}

- (void)startPlay{
    UIView *_localView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    [self.view insertSubview:_localView atIndex:0];
    _localView.center = self.view.center;
    [_player setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:_localView insertIndex:0];
    NSString* flvUrl = @"http://liveplay.easysharing.online/live/liangsenPlayStreamm.flv";
    int result = [_player startPlay:flvUrl type:PLAY_TYPE_LIVE_FLV];
    if (result == 0) {
        NSLog(@"拉流成功");
    }else{
        NSLog(@"拉流失败");
    }
}
- (void)stopPlay {
    if (_player) {
        [_player setDelegate:nil];
        [_player removeVideoWidget];
        [_player stopPlay];
    }
}

@end
