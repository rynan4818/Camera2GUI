# Camera2GUI
[Camera2](https://github.com/kinsi55/CS_BeatSaber_Camera2)のGUI設定ツールです。

This is a GUI configuration tool for [Camera2](https://github.com/kinsi55/CS_BeatSaber_Camera2).

![preview](https://rynan4818.github.io/camera2gui1.png)![preview](https://rynan4818.github.io/camera2gui2.png)
![preview](https://rynan4818.github.io/camera2gui3.png)![preview](https://rynan4818.github.io/camera2gui4.png)
![preview](https://rynan4818.github.io/camera2gui5.png)![preview](https://rynan4818.github.io/camera2gui6.png)
![preview](https://rynan4818.github.io/camera2gui7.png)![preview](https://rynan4818.github.io/camera2gui8.png)

# インストール方法 How to install

## 注意事項 Caution

このツールは非公式であるため、予想外の動作でCamera2の設定ファイルが壊れる可能性があります。

必ず本ツールの使用前に \UserData\Camera2フォルダの設定ファイルをバックアップしてからツールを使用して下さい。

設定ファイルが壊れた場合はバックアップした設定ファイルを戻すか、Camera2フォルダごと削除してBeatSaberを起動すればもとに戻ります。

特に動作確認をしていないCamera2のバージョンでの仕様は注意して下さい。

本ツールを使用した事により被った被害の苦情は受け付けていません。

また、本ツールに関することをCamera2公式サイトで問い合わせをすることは止めて下さい。

以上を承知の上で使用して下さい。

Since this tool is unofficial, there is a possibility that Camera2 configuration files may be corrupted due to unexpected behavior.

Be sure to back up the configuration files in the \UserData\Camera2 folder before using this tool.

If the configuration file is corrupted, you can restore the backed up configuration file or delete the entire Camera2 folder and launch BeatSaber to get it back.

Please pay attention to the specifications, especially for versions of Camera2 that have not been tested.

We do not accept complaints about damage caused by the use of this tool.

Also, please do not contact the official Camera2 website to inquire about this tool.

Please be aware of the above before using this product.
## (1)
 [リリースページ](https://github.com/rynan4818/Camera2GUI/releases)から最新のリリースをダウンロードします。

Download the latest release from the [Release Page](https://github.com/rynan4818/Camera2GUI/releases).

## (2)

ダウンロードしたzipファイルを適当なフォルダに解凍して、Camera2GUI.exeを実行して下さい。

Unzip the downloaded zip file to an appropriate folder and run Camera2GUI.exe.

## (3)

起動時に設定画面が開くので、BeatSaberのインストールフォルダを選択して下さい。

When the settings window opens at startup, select the installation folder of BeatSaber.

## (4)

設定画面の構成や説明は公式のものを踏襲しています。

詳細な説明は、入力箇所にマウスカーソルを置くとツールチップが表示されるのため、確認して下さい。

その他、設定方法の詳細は公式サイトの[Wiki](https://github.com/kinsi55/CS_BeatSaber_Camera2/wiki)を参照して下さい。

The configuration and description of the settings screen follows the official one.

For detailed instructions, please check the tooltip that appears when you place the mouse cursor over the input area.

For other details on how to set it up, please refer to the [Wiki](https://github.com/kinsi55/CS_BeatSaber_Camera2/wiki) on the official website.

# ライセンスと著作権について

Camera2GUI はプログラム本体と各種ライブラリから構成されています。

Camera2GUI のソースコード及び各種ドキュメントについての著作権は作者であるリュナン(Twitter [@rynan4818](https://twitter.com/rynan4818))が有します。
ライセンスは MIT ライセンスを適用します。

それ以外の Camera2GUI.exe に内包や添付しているrubyスクリプトやバイナリライブラリは、それぞれの作者に著作権があります。配布ライセンスは、それぞれ異なるため詳細は下記の入手元を確認して下さい。

# 開発環境、各種ライブラリ入手先

各ツールの入手先、開発者・製作者（敬称略）、ライセンスは以下の通りです。

Camera2GUI.exe に内包している具体的なライブラリファイルの詳細は [Exerbレシピファイル](source/core_cui.exy) を参照して下さい。

## Ruby本体入手先
- ActiveScriptRuby(1.8.7-p330)
- https://www.artonx.org/data/asr/
- 製作者:arton
- ライセンス：Ruby Licence

## GUIフォームビルダー入手先
- FormDesigner for project VisualuRuby (exe化版)
- https://github.com/rynan4818/formdesigner
- 開発者:雪見酒
- ライセンス：Ruby Licence

## 使用拡張ライブラリ、ソースコード

### Ruby本体 1.8.7-p330              #開発はActiveScriptRuby(1.8.7-p330)を使用
- https://www.ruby-lang.org/ja/
- 開発者:まつもとゆきひろ
- ライセンス：Ruby Licence

### Exerb                            #開発はActiveScriptRuby(1.8.7-p330)同封版を使用
- http://exerb.osdn.jp/man/README.ja.html
- 開発者:加藤勇也
- ライセンス：LGPL

### gem                              #開発はActiveScriptRuby(1.8.7-p330)同封版を使用
- https://rubygems.org/
- ライセンス：Ruby Licence

### VisualuRuby                      #開発はActiveScriptRuby(1.8.7-p330)同封版を使用 ※swin.soを改造
- http://www.osk.3web.ne.jp/~nyasu/software/vrproject.html
- 開発者:にゃす
- ライセンス：Ruby Licence

### json-1.4.6-x86-mswin32
- https://rubygems.org/gems/json/versions/1.4.6
- https://rubygems.org/gems/json/versions/1.4.6-x86-mswin32
- 開発者:Florian Frank
- ライセンス：Ruby Licence

### DLL

#### libiconv 1.11  (iconv.dll)       #Exerbでbs_movie_cut.exeに内包
- https://www.gnu.org/software/libiconv/
- Copyright (C) 1998, 2019 Free Software Foundation, Inc.
- ライセンス：LGPL

#### AutoIT v3.3.15.3 (Beta)  (AutoItX3.dll)
- https://www.autoitscript.com/
- Jonathan Bennett and the AutoIt Team
- ライセンス：https://www.autoitscript.com/autoit3/docs/license.htm
