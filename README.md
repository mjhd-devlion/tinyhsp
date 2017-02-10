# TinyHSP

![miyuzu_header](https://cloud.githubusercontent.com/assets/13228693/22240053/9dba8334-e25c-11e6-8543-7a537abf6664.png)

TinyHSPは**最軽量のHSPを作成する**ことを目標にしたプロジェクトです。

## 仕様

### 命令

neteruhspをベースに、
次の命令を追加しました。

|-|書式|説明|
|---|---|---|
|wait|wait p1| p1ミリ秒待つ|
|stop|stop|クローズされるまで待つ|
|title|title p1|タイトルバーに文字列p1を表示する|
|pset|pset p1,p2|位置p1,p2にドットを描画する。p1,p2が省略された場合はカレントポジションに描画する|
|line|line p1,p2,p3,p4|位置p1,p2から位置p3,p4まで線を描画する|
|boxf|line p1,p2,p3,p4|位置p1,p2から位置p3,p4まで矩形を塗りつぶす|
|redraw|redraw p1|p1が0なら再描画スイッチをオフに、1ならオンにする。p1が省略されたらオンにする|
|pos|pos p1,p2|位置p1,p2をカレントポジションに設定する|
|color|color p1,p2,p3|RGBカラーp1,p2,p3をカレントカラーに設定する|
|stick|stick p1|数値変数p1にキー情報を格納する。本家HSPの stick p1,1+2+4+8+16+32+64+128+256+512+1024 相当の動作をする|

### システム変数

次のシステム変数を追加しました。

|-|説明|
|---|---|
|mousex|マウスのx座標|
|mousey|マウスのy座標|
|mousel|マウスの左ボタンが押されていれば1、押されていなけば0|
|mouser|マウスの右ボタンが押されていれば1、押されていなけば0|

### その他の仕様

スクリプトファイルの末尾まで実行したら、
自動的に終了するようになっています。

すぐにウィンドウを閉じないようにするためには、
HSP2.xのようにソースの末尾にstopを書く必要があります。

## 開発環境の入手

TinyHSPではGLFW3というライブラリを使っています。
導入する手順は以下の通りです。

### macOSの場合

macOS用のパッケージマネージャーであるHomebrewを使用します。[Homebrew](http://brew.sh/index_ja.html)のウェブサイトにあるスクリプトをターミナルに貼り付け実行します。

次いでターミナルで次のコマンドを実行してください。

`$ brew install glfw3`

### Linuxの場合

未確認です。

### MinGWの場合

MinGWはWindows用の開発環境です。次の手順で導入します。

1. GLFW3をダウンロードする
2. include内のGLFWフォルダをMinGW内のincludeフォルダにコピーする
3. 2つの.aファイルをMinGW内のlibフォルダにコピーする
4. glfw3.dllをプロジェクトのフォルダにコピーする

#### 1. GLFWをダウンロードする

**GLFWライブラリは[GLFWのダウンロードページ](http://www.glfw.org/download.html)から入手**します。

GLFWには32bit版と64bit版があります。
仮に64bit版をダウンロードしたとして話を進めます。

#### 2. include内のGLFWフォルダをMinGW内のincludeフォルダにコピーする

ダウンロードしたフォルダの中に、
`include` というフォルダが入っています。
この中に `GLFW` というフォルダがあるので、
その**GLFWフォルダをMinGWのincludeフォルダにコピー**します。

#### 3. 2つの.aファイルをMinGW内のlibフォルダにコピーする

ダウンロードしたフォルダの中に、
`lib-mingw-w64` というフォルダが入っているので、
この中にある、

- libglfw3.a
- libglfw3dll.a

という**2つの.aファイルをMinGWのlibフォルダにコピー**します。

#### 4. glfw3.dllをプロジェクトのフォルダにコピーする

上と同じ `lib-mingw-w64` フォルダ内に、

- glfw3.dll

というファイルがあるので、
作成したいプロジェクト用のフォルダ内にコピーします。

例えば、**glfw3.dllをtinyhsp.cがあるフォルダと同じ場所にコピー**します。

## コンパイル

環境によりそれぞれ以下のようにコンパイルします。

macOS:
`$ clang++ tinyhsp.cpp -o tinyhsp -std=c++11 -lglfw -framework OpenGL`

Linux:
`$ g++ tinyhsp.cpp -o tinyhsp -std=gnu++11 -lm -ldl -lglfw3 -lGL -lX11 -lXxf86vm -lXrandr -lXinerama -lXcursor -lpthread -lXi`

MinGW:
`$ g++ tinyhsp.cpp -o tinyhsp -std=gnu++11 -lglfw3dll -lopengl32`

注記：`tinyhsp.cpp`の文字コードはUTF-8である必要があります。

## 実行

`$ ./tinyhsp`
のようにコマンドラインのオプションに何も指定がない場合は、
実行ファイルと同じディレクトリにある`start.hsp`を読み込みます。

明示的に、
`$ ./tinyhsp -f start.hsp`
のように`-f`オプションを使って指定することもできます。

## 更新履歴

- 2017/02/10 
- 2017/02/09 neteruhspにGUIを実装する3
- 2017/02/08 neteruhspにGUIを実装する2
- 2017/02/07 neteruhspにGUIを実装する
- 2017/02/05 stb\_image.hを使って画像を描画する
- 2017/01/31 空白文字を考慮して文字列を描画する
- 2017/01/30 Unicode文字列を描画するプロトタイプ
- 2017/01/28 stb\_truetype.hを使って文字を描画するテスト／README.mdにイラストを追加
- 2017/01/27 wait命令が使えるプロトタイプ
- 2017/01/26 改行方式でpset命令も使えるプロトタイプ
- 2017/01/25 改行方式でprint命令のみ使えるプロトタイプ
- 2017/01/24 作り直しを始める／ヘッダー画像を追加／start.hspを読み込むだけのプロトタイプ
- 2017/01/23 作り直しを検討／これ以前のプログラムを1つのディレクトリにまとめた
- 2017/01/22 ディレクトリ構成を変更
- 2017/01/21 README.mdにイラストを追加
- 2017/01/18 パーサを修正
- 2017/01/17 テスト用のMakefileを作成
- 2017/01/16 パーサにテスト用コードを追加
- 2017/01/15 命令トークンを識別するように変更
- 2017/01/14 ピクセル操作のためのファイルを追加
- 2017/01/13 字句解析器を修正（長い関数を分割）
- 2017/01/12 ファイル読み込み用のユーティリティを追加
- 2017/01/11 ディレクトリ構成およびMakefileの変更
- 2017/01/10 字句解析器を修正／仕様を変更（wait命令を追加）
- 2017/01/09 電卓を実装（未対応：丸括弧・負の数）
- 2016/12/29 リポジトリを開設

## リンク

- きっかけ
    - [TinyHSPの提案](http://hsp.tv/play/pforum.php?mode=all&num=77515)
- 使用したライブラリ・フォント
    - [GFLW3](http://www.glfw.org)
    - [exrd / neteruhsp](https://github.com/exrd/neteruhsp)
    - [nothings / stb](https://github.com/nothings/stb)
    - [M+ FONTS](http://mplus-fonts.osdn.jp)
    - [Mgen+](http://jikasei.me/font/mgenplus/)

## ライセンス

TinyHSPはMITライセンスです。