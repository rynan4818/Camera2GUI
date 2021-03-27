#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
#
$KCODE='s'
#==============================================================================
#Project Name    : BeatSaber Camera2GUI
#Creation Date   : 2021/03/20
#Copyright       : (c) 2021 rynan4818 (Twitter @rynan4818)
#License         : MIT License
#                  https://github.com/rynan4818/Camera2GUI/blob/main/LICENSE
#Tool            : ActiveScriptRuby(1.8.7-p330)
#                  https://www.artonx.org/data/asr/
#                  FormDesigner Release v2020/06/18
#                  https://github.com/rynan4818/formdesigner
#RubyGems Package: rubygems-update (1.8.21)      https://rubygems.org/
#                  json (1.4.6 x86-mswin32)
#==============================================================================

MAIN_MENU_VERSION_TITLE              = "BeatSaber Camera2 GUI バージョン情報"
MAIN_SELF_CREATED_BSDIR_CHK_MES      = "BeatSaber フォルダの設定がありません。設定画面を開くので設定して下さい。"
MAIN_SELF_CREATED_BSDIR_CHK_TITLE    = "BeatSaber フォルダ未設定"
MODALDLG_SETTING_OK_BTN_NO_DIR_MES   = "BeatSaber Folderがありません。戻って再設定しますか？"
MODALDLG_SETTING_OK_BTN_NO_DIR_TITLE = "BeatSaber Folder 設定ミス"
SETTING_LOAD_ERROR_NO_SCENE          = "'Scenes.json' ファイルが見つかりません。"
SETTING_LOAD_ERROR_MES               = "設定ファイルが読み込めません。"
SETTING_LOAD_ERROR_NO_CAMERA         = "'Cameras'のフォルダがありません。"
SETTING_LOAD_ERROR_NO_DEFAULT        = "デフォルト設定ファイルがありません。"
UNKNOWN_CAMERA_TYPE_MES              = "非対応のカメラタイプです。使用できません。"
UNKNOWN_CAMERA_TYPE_TITLE            = "未知のカメラタイプ"
LAYER_CONFLICT_MES                   = "レイヤーが競合しています。レイヤーを振り直しますので、順序を確認して下さい。"
LAYER_CONFLICT_TITLE                 = "レイヤー競合"
CHARACTER_CHECK_MES                  = "は使用できない文字です"
CHARACTER_CHECK_TITLE                = "使用不可文字"
MODALDLG_CUSTOM_SCENES_ERR_MES       = "が競合しています。名前を変更して下さい。"
MODALDLG_CUSTOM_SCENES_ERR_TITLE     = "名前競合"
MAIN_DELETE_MES                      = "選択されているカメラを削除して良いですか？"
MAIN_DELETE_TITLE                    = "削除確認"
FILE_TIME_CHECK_MES                  = "Camera2の設定ファイルが更新されました。再読み込みしますか？(保存してない設定は消えます)"
FILE_TIME_CHECK_TITLE                = "ファイル更新確認"
MAIN_WSH_ERR                         = "WScript Shellでエラーが発生しました"
MAIN_WSH_ERR_TITLE                   = "WSHエラー発生"
TOOLTIP_CAMERA_NAME                  = "カメラ名：半角英数記号空白(ASCII文字)のみ。\r\nただし、ファイル名に使用出来ない文字 \\/:*?\"<>| は使用不可。"
TOOLTIP_CAMERA_TYPE                  = "FirstPerson(一人称[HMD]視点）または Positionable(三人称視点)"
TOOLTIP_FIELD_OF_VIEW                = "カメラの視野角度（画角）"
TOOLTIP_FPS_LIMIT                    = "1秒間にレンダリングする最大フレーム数(通常は0を推奨)\r\nCamera2のサイトのwikiページの説明をよく読んでから設定して下さい"
TOOLTIP_RENDER_SCALE                 = "画面の粗さの設定"
TOOLTIP_ANTI_ALIASING                = "文字や画像の曲線や斜めの線に生じるジャギー(キザギザ)を抑えます"
TOOLTIP_WORLDCAM_VISIBILITY          = "ゲーム内カメラの可視性の設定\r\n(Visible:表示・HiddenWhilePlaying:プレイ中は非表示・Hidden:非表示)"
TOOLTIP_PREVIEW_SIZE                 = "ゲーム内カメラのプレビュー画面の大きさ(BeatSaber再起動後に有効)"
TOOLTIP_Z_OFFSET                     = "一人称視点時の前後方向オフセット"
TOOLTIP_RELOAD                       = "設定ファイルを再読み込みします。保存していない設定は消えます。"
TOOLTIP_ADD                          = "カメラを追加します。(追加されるカメラのデフォルト値はPositionableDefault.jsonになります)"
TOOLTIP_COPY                         = "選択中のカメラをコピーして追加します。"
TOOLTIP_DEL                          = "選択中のカメラを削除します。"
TOOLTIP_SAVE                         = "現在の設定を保存します。"
TOOLTIP_SAVE_APPLY                   = "設定を保存し、Camera2へ反映します(BeatSaberが起動している必要があります)"
TOOLTIP_CAMERA_LIST                  = "カメラの設定一覧です。左からレイヤー番号・カメラタイプ・カメラ名になります。"
TOOLTIP_UP                           = "選択中のカメラのレイヤーを１つ上げます"
TOOLTIP_DOWN                         = "選択中のカメラのレイヤーを１つ下げます"
TOOLTIP_BS_FOLDER                    = "BeatSaberのインストールフォルダを設定します"
TOOLTIP_TOOLTIP                      = "ツールチップ（この説明表示）の表示をします"
TOOLTIP_JAPANESE                     = "メッセージとツールチップを日本語化します。（再起動後に有効です）\r\n※システムロケールがSHIFT-JIS以外のOSでは文字化けします。"
TOOLTIP_UPDATE_CHECK                 = "Camera2側の設定ファイル更新チェックのファイルタイムスタンプの無視時間です。\r\nタイムスタンプで更新チェックをした後にJSONの中身も比較するため通常は0で問題ありません。"
TOOLTIP_SEND_TIME                    = "Camera2の更新キー操作の、キー送信時間です。\r\nApplyでCamera2が更新されない場合は値を上げて下さい。"
TOOLTIP_WAIT_TIME                    = "AutoIT(Windows自動操作ツール)で、コマンド毎の待ち時間です。\r\nApply動作が不安定な場合は上げて下さい。通常は0で問題ありません。"
TOOLTIP_WALLS                        = "壁の可視性(Visible:表示・Transparent:透明・Hidden:非表示)"
TOOLTIP_NOTES                        = "ノーツの可視性(Visible:表示・Hidden:非表示・ForceCustomNotes:カスタムノーツをVRのみで表示するようにした場合でも表示する)"
TOOLTIP_DEBRIS                       = "カット後のノーツの破片の可視性"
TOOLTIP_CUT_PARTICLES                = "カット時の粒子エフェクトの可視性"
TOOLTIP_AVATAR                       = "アバターの可視性"
TOOLTIP_UI                           = "スコア(HUD)などのユーザーインターフェースの可視性"
TOOLTIP_FLOOR                        = "床の可視性"
TOOLTIP_FORCE_UPRIGHT                = "頭の横方向の傾きを無視して常に直立させます。一人称画面の酔い防止に効果があります。"
TOOLTIP_PIVOTING_OFFSET              = "Zオフセットを、絶対値（Camera Plus標準設定）ではなく、旋回軸基準（Cmera2標準設定）で適用します。"
TOOLTIP_FOLLOW_REPLAY_POSITION       = "有効にすると、リプレイを見ている間、一人称カメラがHMDやFPFCのカメラではなくリプレイ位置に配置されます。"
TOOLTIP_POSITION_SMOOTHING           = "カメラ移動のスムージングの量を定義します。数値が小さいほど、スムージングが多くなります。"
TOOLTIP_360ENABLED                   = "360度譜面で、カメラを譜面の回転に追従します"
TOOLTIP_ROTATION_SMOOTHING           = "カメラの回転のスムージングの量を定義します。数値が小さいほど、スムージングが多くなります。"
TOOLTIP_MOVE_WITH_MAP                = "Noodle拡張譜面が移動/回転すると、このカメラはその動きに従います"
TOOLTIP_AUTO_VISIBLE_WALLS           = "NoodleまたはMappingExtensions譜面をプレイしている場合に、壁が非表示設定でも表示に変更します"
TOOLTIP_AUTO_HIDE_HUD                = "NoodleまたはMappingExtensions譜面をプレイしている場合に、スコア(HUD)などを非表示に変更します"
TOOLTIP_SCENE_MENU                   = "優先度3-2:メニュー画面でこのカメラを表示します"
TOOLTIP_SCENE_MULTIPLAYER_MENU       = "優先度3-1:マルチプレイヤーのメニュー画面でこのカメラを表示します"
TOOLTIP_SCENE_PLAYING                = "優先度2-3:通常マップのゲームシーンでこのカメラを表示します"
TOOLTIP_SCENE_PLAYING_360            = "優先度2-2:360度譜面のプレイ画面でこのカメラを表示します"
TOOLTIP_SCENE_PLAYING_MODMAP         = "優先度2-2:Mod譜面(NoodleまたはMappingExtensions譜面)のプレイ画面でこのカメラを表示します"
TOOLTIP_SCENE_PLAYING_MULTI          = "優先度2-1:マルチプレイヤーのプレイ画面でこのカメラを表示します"
TOOLTIP_SCENE_REPLAY                 = "優先度2-1:リプレイ画面でこのカメラを表示します"
TOOLTIP_SCENE_FPFC                   = "優先度1:飛行(fpfc)モードでこのカメラを表示します。\r\n(BeatSaberの起動オプションで'fpfc'を設定して起動します)"
TOOLTIP_ENABLE_AUTO_SWITCH           = "上記設定のシーン切り替えを自動で行います"
TOOLTIP_AUTOSWITCH_FROM_CUSTOM       = "カスタムシーンを使用中でも、ゲームのシーンが切り替わった時に上記設定の自動切り替えを行います"
TOOLTIP_CUSTOM_SCENES                = "カスタムシーンの設定(ゲーム内のメニュー設定、またはショートカットキーでシーン切り替え可能)"
TOOLTIP_AUTO_APPLY                   = "数値が変更されると、即保存してCamera2へ反映します"
TOOLTIP_MOVEMENT_FROM_ORIGIN         = "移動スクリプトの実行前に原点(0,0,0)に移動します"
TOOLTIP_MOVEMENT_ENABLE_IN_MENU      = "ゲームプレイ以外のメニューシーンでも移動スクリプトを適用します"
TOOLTIP_MOVEMENT_SCRIPT_LIST         = "このカメラに適用する移動スクリプトを選択します。\r\n複数選択すると毎回ランダムに適用されます。"
TOOLTIP_CUSTOM_SCENES_LIST           = "設定済みのカスタムシーンのリスト\r\n(左からキーバインド[設定がある場合]・カスタムシーンの名前)"
TOOLTIP_CUSTOM_SCENES_SCENE          = "カスタムシーンの名前(半角英数記号空白のみ)"
TOOLTIP_CUSTOM_SCENES_KEY            = "ショートカットキー(未設定でも可、その場合は譜面画面のメニューのMod設定から選択)"
TOOLTIP_CUSTOM_SCENES_CAMERA         = "表示するカメラ"
TOOLTIP_CUSTOM_SCENES_ADD            = "カスタムシーンを新規で追加します"
TOOLTIP_CUSTOM_SCENES_DEL            = "選択中のカスタムシーンを削除します"
TOOLTIP_CUSTOM_SCENES_CANCEL         = "現在の設定を適用せずに破棄します"
TOOLTIP_CUSTOM_SCENES_OK             = "現在の設定を適用します。保存はメインメニューに戻って保存する必要があります。"
TOOLTIP_STEAM                        = "Steam版BeatSaberのfpfc起動コマンド"
TOOLTIP_OCULUS                       = "Oculus版BeatSaberのfpfc起動コマンド"
TOOLTIP_FPFC                         = "メニューのBeatSaberのfpfc start-upで実行するコマンド。\r\n(BeatSaberが未起動か事前チェック付き)"
MENU_FPFC_NOCOMMAND_MES              = "fpfc起動コマンドの設定がありません。OptionのSettingで設定して下さい。"
MENU_FPFC_NOCOMMAND_TITLE            = "fpfc起動コマンドがありません"
MENU_FPFC_EXIST_MES                  = "BeatSaberが起動中のため実行しません。\r\n'#{BEATSABER_WINDOW_NAME}'のウインドウタイトルで判断しているため、誤認識の可能性もあります"
MENU_FPFC_EXIST_TITLE                = "BeatSaberが起動中"
