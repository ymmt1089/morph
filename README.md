# README

Morph-もおふ。-
====

Morphは文章作品の投稿及び閲覧を行うアプリです。
さらに投稿された文章を形態素解析し可視化を行えるサイトでもあります。

Morph is an application that allows you to post and view written works.
It is also a site where you can visualize and analyze the posted text.

## Description
文章作品の投稿サイトは数多く存在していますが、本アプリでは投稿した作品を形態素解析し、
ワードクラウド化したものを作品一覧に表示します。
表紙や題名、著者名などの情報に囚われない新しい手法で作品を選ぶことができるアプリです。

There are many posting sites for writing works, but this app analyzes the submitted work with morphological analysis,The word cloud is displayed in the work list.
It is an application that allows you to select works by a new method that is not trapped by information such as cover, title, author name.

## Demo(sample)
http://ec2-18-176-124-216.ap-northeast-1.compute.amazonaws.com/about  

About画面
<img width="1278" alt="スクリーンショット 2019-11-15 15 34 17" src="https://user-images.githubusercontent.com/52972668/68921977-c72c3d00-07bd-11ea-9640-65bb16f43bce.png">


解析結果画面
<img width="1278" alt="スクリーンショット 2019-11-15 15 35 52" src="https://user-images.githubusercontent.com/52972668/68921998-d57a5900-07bd-11ea-904c-5210e36dfe9b.png">
<img width="1278" alt="スクリーンショット 2019-11-15 15 36 02" src="https://user-images.githubusercontent.com/52972668/68922008-da3f0d00-07bd-11ea-84d2-5c00ca01ed30.png">


作品一覧画面
<img width="1278" alt="スクリーンショット 2019-11-15 15 34 56" src="https://user-images.githubusercontent.com/52972668/68921985-cb585a80-07bd-11ea-9567-801ca73b9884.png">


## Usage

git cloneして動作を見る場合、形態素解析を行う為、
形態素解析ツール(macab)及びMeCab標準のIPA辞書(mecab-ipadic)をインストールする必要があります。
※詳しくはInstall項目に記載

When performing the git clone and seeing the operation, in order to perform morphological analysis,
It is necessary to install the morphological analysis tool (macab) and MeCab standard IPA dictionary (mecab-ipadic).
* For details, see the Install item.

## Install
    git clone以降の環境設定などの方法をいかに記述しております。
    It describes how to set the environment after git clone.  

        $ git clone https://github.com/ymmt1089/morph.git
        $ cd morph


    http://taku910.github.io/mecab/
    上記のサイトよりmecab本体(mecab-0.996.tar.gz)をダウンロードの後、以下コマンド実行
    After downloading mecab (mecab-0.996.tar.gz) from the above site, execute the following command  

        $ tar zxvf mecab-0.996.tar.gz
        $ cd mecab-0.996
        $ ./configure --with-charset=utf8 --enable-utf8-only
        $ make
        $ sudo make install


    同じく上記のサイトよりMeCab標準のIPA辞書(mecab-ipadic-2.7.0-20070801.tar.gz)をダインロードの後、以下コマンド実行
    Also, after downloading the MeCab standard IPA dictionary (mecab-ipadic-2.7.0-20070801.tar.gz) from the above site, execute the following command  

        $ tar zxvf mecab-ipadic-2.7.0-20070801.tar.gz
        $ cd mecab-ipadic-2.7.0-20070801
        $ ./configure --with-charset=utf8
        $ make
        $ sudo make install


## Author
山本 尚幸 (Naoyuki Yamamoto)  
Git: https://github.com/ymmt1089  
mail to: ymmt1089@mail.com
 
## License

 Copyright (c) <year> <copyright holders>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.