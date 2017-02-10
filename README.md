# TinyHSP

![miyuzu_header](https://cloud.githubusercontent.com/assets/13228693/22240053/9dba8334-e25c-11e6-8543-7a537abf6664.png)

TinyHSPは**最軽量のHSPを作成する**ことを目標にしたプロジェクトです。

## 仕様

TinyHSPは`tinyhsp.cpp`のみで構成されており、ソースコードは5000行ほどです。[neteruhsp](https://github.com/exrd/neteruhsp)をベースにしており、文法や変数の規則などは基本的に同じです。

TinyHSPで新しく追加された命令とシステム変数は以下の通りです。

### 命令

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

|-|説明|
|---|---|
|mousex|マウスのx座標|
|mousey|マウスのy座標|
|mousel|マウスの左ボタンが押されていれば1、押されていなけば0|
|mouser|マウスの右ボタンが押されていれば1、押されていなけば0|

### その他の仕様

TinyHSPはスクリプトファイルの末尾まで実行したら、自動的に終了するようになっています。すぐにウィンドウを閉じないようにするためには、HSP2.xのようにソースの末尾にstopを書く必要があります。

## 開発環境の入手

TinyHSPではGLFW3というライブラリを使っています。導入する手順は以下の通りです。

### macOSの場合

macOS用のパッケージマネージャーであるHomebrewを使用します。[Homebrew](http://brew.sh/index_ja.html)のウェブサイトにあるスクリプトをターミナルに貼り付け実行します。

次いでターミナルで次のコマンドを実行してください。

`$ brew install glfw3`

### Linuxの場合

未確認です。

### MinGWの場合

MinGWはWindows用の開発環境です。次の手順で導入します。

1. **GLFWをダウンロードする**: **GLFWライブラリは[GLFWのダウンロードページ](http://www.glfw.org/download.html)から入手**します。GLFWには32bit版と64bit版があります。仮に64bit版をダウンロードしたとして話を進めます。
2. **include内のGLFWフォルダをMinGW内のincludeフォルダにコピーする**: ダウンロードしたフォルダの中に、`include` というフォルダが入っています。この中に `GLFW` というフォルダがあるので、その**GLFWフォルダをMinGWのincludeフォルダにコピー**します。
3. **2つの.aファイルをMinGW内のlibフォルダにコピーする**: ダウンロードしたフォルダの中に、`lib-mingw-w64` というフォルダが入っているので、この中にある、`libglfw3.a`、`libglfw3dll.a`という**2つの.aファイルをMinGWのlibフォルダにコピー**します。
4. **glfw3.dllをプロジェクトのフォルダにコピーする**: 上と同じ `lib-mingw-w64` フォルダ内に`glfw3.dll`というファイルがあるので、作成したいプロジェクト用のフォルダ内にコピーします。例えば、**glfw3.dllをtinyhsp.cがあるフォルダと同じ場所にコピー**します。

## コンパイル

環境によりそれぞれ以下のようにコンパイルします。

macOS: `$ clang++ tinyhsp.cpp -o tinyhsp -std=c++11 -lglfw -framework OpenGL`

Linux: `$ g++ tinyhsp.cpp -o tinyhsp -std=gnu++11 -lm -ldl -lglfw3 -lGL -lX11 -lXxf86vm -lXrandr -lXinerama -lXcursor -lpthread -lXi`

MinGW: `$ g++ tinyhsp.cpp -o tinyhsp -std=gnu++11 -lglfw3dll -lopengl32`

注記：`tinyhsp.cpp`の文字コードはUTF-8である必要があります。

## 実行

`$ ./tinyhsp` のようにコマンドラインのオプションに何も指定がない場合は、実行ファイルと同じディレクトリにある`start.hsp`を読み込みます。

明示的に、`$ ./tinyhsp -f start.hsp` のように`-f`オプションを使って指定することもできます。

## サンプル

同封したサンプル`start.hsp`は簡易的なお絵かきスクリプトです。

### サンプルスクリプト

```
title "TinyPaint"

old_x = -1
old_y = -1
now_x = 0
now_y = 0

repeat
    stick key
    if key & 256 {
        now_x = mousex
        now_y = mousey
        line now_x, now_y, old_x, old_y
        old_x = now_x
        old_y = now_y
    } else {
        old_x = mousex
        old_y = mousey
    }
    wait 5
loop

stop
```

### サンプルのスクリーンショット
![tinypaint](https://cloud.githubusercontent.com/assets/13228693/22679200/833b9b1e-ed43-11e6-80c2-94f5711863de.png)

## おまけ：文字と画像を表示する

TinyHSPを拡張して[文字と画像を表示できるようにしたバージョンも入手できます](https://github.com/dolphilia/tinyhsp/tree/master/prototype/11_neteruhsp_gui3)。

コンパイル方法は通常版と同じです。

[stbライブラリ](https://github.com/nothings/stb)と[M+フォント](http://mplus-fonts.osdn.jp)を使用しています。

### サンプルのスクリーンショット

![011](https://cloud.githubusercontent.com/assets/13228693/22812773/138d0278-ef8a-11e6-9a83-944f5e9cf31d.png)

### 拡張された命令

|-|書式|説明|
|---|---|---|
|mes|mes p1|カレントポジションに文字列p1を画面に描画します。描画後にカレントポジションを文字サイズ分Y方向にずらします|
|font|font p1,p2,p3|フォントの設定をします。p1には使用するTTFファイルのパスを拡張子.ttfも含めて記述します。p2にはフォントサイズを指定します。フォントサイズは上限が100です。p3にはフォントのスムージングを行うか行わないかを指定します。0でスムージングを行わず、16でスムージングを行うように設定します|
|picload|picload p1|カレントポジションにp1で指定した画像を描画します。p1には使用する画像ファイルのパスの拡張子も含めて記述します|

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