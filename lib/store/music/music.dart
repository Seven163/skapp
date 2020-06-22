/*
 * Created: 2020-04-07 15:55:59
 * Author : Mockingbird
 * Email : 1768385508@qq.com
 * -----
 * Description:
              1. 执行命令: flutter packages pub run build_runner build
              2. 删除之内再生成: flutter packages pub run build_runner build --delete-conflicting-outputs
              3. 实时更新.g文件: flutter packages pub run build_runner watch
 */

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './../../http/API.dart';
import './../../http/http_request.dart';

/// 必须, 用于生成.g文件
part 'music.g.dart';

class MusicStore = MusicStoreMobx with _$MusicStore;

abstract class MusicStoreMobx with Store {
  String musicUrl = API.MUSIC_URL;

  @observable
  bool isLoading = true;

  @observable
  var songInfo = {};

  @observable
  String mp3Url = "";

  @action
  Future<dynamic> fetchData(String song, String type) async {
    this.isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cIp = prefs.getString('ip') ?? API.BASE_SK_URL;
    var req = HttpRequest(cIp);
    final res = await req.get(musicUrl + song + '&type=' + type);
    if (res['code'] == 200) {
      this.songInfo = res;
      mp3Url = res['data']['typeUrl'][type]['url'];
      this.isLoading = false;
    } else {
      Fluttertoast.showToast(
        msg: res['msg'],
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @action
  void resetSongInfo() {
    songInfo = {};
    mp3Url = "";
  }
}
