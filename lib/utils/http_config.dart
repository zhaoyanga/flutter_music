// 请求服务器地址
// const String baseUrl = 'http://10.0.2.2:3000/';
const String baseUrl = 'http://localhost:3000/';
// 请求连接
const Map urlPath = {
  'banner': 'banner', // 轮播图
  'homepageDragonBall': '/homepage/dragon/ball', // 圆形图标
  'getMusicList': '/song/url', // 获取音乐
  'getQrCodeKeyGenerate': '/login/qr/key', // 二维码 key 生成接口
  'getQrCodeGenerate': '/login/qr/create', // 二维码生成接口
  'getQrCodeDetection': '/login/qr/check', // 二维码检测扫描接口
  'getResource': '/recommend/resource', // 二维码检测扫描接口
  'getAccountInfo': '/user/account', // 获取账号信息
  'getUserDetail': '/user/detail', // 获取用户详情
  'getPlaylist': '/user/playlist', // 获取用户歌单
  'getPlaylistDynamic': '/playlist/detail/dynamic', // 获取歌单详情动态(分享次数等)
  'getPlaylistTrack': '/playlist/track/all', // 获取歌单内歌曲
};

// content-type
const Map contentType = {
  'json': "application/json;charset=UTF-8",
  'form': "application/x-www-form-urlencoded"
};
