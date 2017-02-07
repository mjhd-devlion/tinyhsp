# TinyHSP

![miyuzu_header](https://cloud.githubusercontent.com/assets/13228693/22240053/9dba8334-e25c-11e6-8543-7a537abf6664.png)

TinyHSPは**最軽量のHSPを作成する**ことを目標にしたプロジェクトです。

## 言語仕様

TinyHSPの言語仕様は、プロトタイプごとに異なります。

- v0.0.9 [neteruhspにGUIを実装する](https://github.com/dolphilia/tinyhsp/tree/master/09_neteruhsp_gui)
- v0.0.8 [stb_image.hを使って画像を描画する](https://github.com/dolphilia/tinyhsp/tree/master/08_loadimage)
- v0.0.7 [空白文字を考慮する](https://github.com/dolphilia/tinyhsp/tree/master/07_whitespace)
- v0.0.6 [はろーわーるど](https://github.com/dolphilia/tinyhsp/tree/master/06_helloworld)
- v0.0.5 [stb_truetype.hを使って文字を描画する](https://github.com/dolphilia/tinyhsp/tree/master/05_truetype)
- v0.0.4 [wait命令が使えるプロトタイプ](https://github.com/dolphilia/tinyhsp/tree/master/04_wait)
- v0.0.3 [改行方式でpset命令も使える](https://github.com/dolphilia/tinyhsp/tree/master/03_pset)
- v0.0.2 [改行方式でprint命令のみ使える](https://github.com/dolphilia/tinyhsp/tree/master/02_print)
- v0.0.1 [start.hspを読み込むだけ](https://github.com/dolphilia/tinyhsp/tree/master/01_file_to_array)
- v0.0.0 [最初に見た夢](https://github.com/dolphilia/tinyhsp/tree/master/00_start)

## 運営方針

プロトタイプをたくさん作っていく方式で進めています。

## 更新履歴

![miyuzu_change_log](https://cloud.githubusercontent.com/assets/13228693/22394825/6cfac8fc-e56e-11e6-9a29-26bcff971422.png)

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

## どんなことでもissuesにどうぞ

Githubでは掲示板のスレッドのような機能「イシュー」を使うことができます。質問や提案・不具合の報告などがありましたら、ご自由に[Issuesのページ](https://github.com/dolphilia/tinyhsp/issues)からイシューを立てていただければと思います。

![miyuzu](https://cloud.githubusercontent.com/assets/13228693/22172736/56d7206a-dff2-11e6-8ca8-ea155caf7acf.jpg)

## リンク

- [TinyHSPの提案](http://hsp.tv/play/pforum.php?mode=all&num=77515)

## ライセンス

TinyHSPはMITライセンスです。