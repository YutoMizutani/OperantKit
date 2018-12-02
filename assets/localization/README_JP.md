# OperantKit

[![Build Status](https://app.bitrise.io/app/e1b066c3a796bb39/status.svg?token=3DteqY4In4ByLDs_2-iucg&branch=master)](https://app.bitrise.io/app/e1b066c3a796bb39)
![platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-333333.svg)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/YutoMizutani/OperantKit/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/OperantKit.svg)](https://github.com/YutoMizutani/OperantKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/YutoMizutani/OperantKit)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

**OperantKit** は *オペラント条件づけ* (*道具的条件づけ*) 実験を実施するためのSwiftで書かれたツールキットです。

## 使用方法

```swift
import OperantKit
import RxSwift

func main() {
	let schedule = FR(5) // 固定比率 5 スケジュール
	let events: Observable<Void> = ... // Observable イベント
	schedule.decision(events)
		.filter({ $0.isReinforcement }) // 強化される反応のみをフィルタリング
		.subscribe(onNext: {
			print("Reinforcement")
		})
		.disposed(by: DisposeBag())
}
```

## サンプル

* [CLI サンプル (Linux, macOS)](https://github.com/YutoMizutani/OperantKit/tree/master/Examples/CLI)
* [iOS サンプル (iOS)](https://github.com/YutoMizutani/OperantKit/tree/master/Examples/iOS)
	* [RatChamber](https://github.com/YutoMizutani/OperantKit/tree/master/Examples/iOS/RatChamber)
	![](https://github.com/YutoMizutani/OperantKit/blob/master/assets/img/demo_ratchamber.gif?raw=true)

## サポートされているスケジュール

### 単一スケジュール

#### 比率スケジュール

反応の回数に随伴するスケジュールを指します。

|スケジュール名|記法例|
|:-:|:-:|
|固定比率スケジュール|`FR(5)`|
|変動比率スケジュール|`VR(5)` ※|
|ランダム比率スケジュール|`RR(5)`|

※ 変動スケジュールの要素数はデフォルトで「12」で，

```swift
VR(10, iterations: 12)
```

というように要素数を変更することも可能です。

#### 時隔スケジュール

一定時間経過後の最初の反応に随伴するスケジュールを指します。

|スケジュール名|記法例|
|:-:|:-:|
|固定時隔スケジュール|`FI(5)`|
|変動時隔スケジュール|`VI(5)`|
|ランダム時隔スケジュール|`RI(5)`|

時間間隔はデフォルトで「秒」単位で，

```swift
FI(5, unit: .minutes)
```

というように単位を変更することも可能です。

#### 時間スケジュール

反応に関係なく時間経過に随伴するスケジュールを指します。

|スケジュール名|記法例|
|:-:|:-:|
|固定時間スケジュール|`FT(5)`|
|変動時間スケジュール|`VT(5)`|
|ランダム時間スケジュール|`RT(5)`|

時間間隔はデフォルトで「秒」単位で，

```swift
FI(5, unit: .minutes)
```

というように単位を変更することも可能です。

#### その他のスケジュール

|スケジュール名|記法例|
|:-:|:-:|
|連続強化スケジュール|`CRF()`|
|消去スケジュール|`EXT()`|

### 複合スケジュール

|スケジュール名|記法例|
|:-:|:-:|
|並立スケジュール|`Conc(FR(5), VI(10))` ※|

※ 並立連鎖スケジュールにおける初環のように，2種類以上のオペランダムに対して共通のスケジュールが適用される場合は， `Shared()` を利用することで対応可能です。 e.g. `Conc(Shared(VI(10)))`

## インストール

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

`Podfile`に追記後，

```ruby
pod 'OperantKit'
```

以下を入力

```bash
$ pod install
```

### [Carthage](https://github.com/Carthage/Carthage)

`Cartfile`に追記後，

```
github "YutoMizutani/OperantKit"
```

以下を入力

```bash
$ carthage update
```

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

`Package.swift`に追記後，

```swift
dependencies: [
    .package(url: "https://github.com/YutoMizutani/OperantKit.git", "0.0.1" ..< "1.0.0"),
]
```

以下を入力

```bash
$ swift build
```


## 依存ライブラリ

* [RxSwift](https://www.github.com/ReactiveX/RxSwift)
* [RxCocoa](https://www.github.com/ReactiveX/RxSwift)

## ドキュメント

[https://yutomizutani.github.io/OperantKit/](https://yutomizutani.github.io/OperantKit/) を参照して下さい。

## オペラント条件づけ (道具的条件づけ) について

![](https://github.com/YutoMizutani/OperantKit/blob/master/assets/img/abc_analysis.png?raw=true)

オペラント条件づけとは，行動の前後に起こる環境を操作することで，行動が変容する現象およびその手続きを指します。
環境を制御することにより，随伴して生じる行動の予測と制御を行なおうとするのが行動分析学です。

ある行動のあとにその個体に対して環境に変化が生じた。その変化を知覚し，ヒト含む動物は行動を変容するようになります。

イヌがボールを取って来た場合に褒めてやると，そのイヌは再びボールを取りに行くようになるでしょう。
逆に，いたずらをするという行動に随伴して先生に怒られるという結果が生じた場合，いたずらをする行動は減るでしょう。
対象は第三者が存在する必要はありません。大当たりを経験したパチンコの台には再び訪れるでしょうし，窓を開けて寝たあとに風邪をひいたとすれば，窓が開いている状態で寝なくなるでしょう。または，羽織を着込んで寝るようになるかもしれません。夜更しをしている子供がゲームを没収されたらどうなるでしょうか。

行動の頻度が増加することを「強化 (Reinforcement)」，逆に頻度が減少することを「罰 (Punishment)」と言います。
行動の結果，何かが与えられることを「正 (Positive)」，何かが取り去られることを「負 (Negative)」と言います。
この場合ですと，イヌの例は「正の強化」となり，夜更しの例は「負の罰」となります。

一方で，パチンコに再び訪れるのはどうしてでしょうか?もしかしたらその人は，同じ台ではなく別の台に移動するかもしれません。どうしてでしょうか。

窓を開けて寝てから風邪をひくまでには，数時間の遅延があります。その結び付きはいったいいつまで持続するのでしょうか。窓を閉めるのか，羽織を着るのか，どうすれば予測できるのでしょうか。そもそも風邪をひいた原因は窓を開けたことではないかもしれません，なぜ行動が変容したのでしょうか。

子供の夜更しの原因はゲームにあり，そのゲームが没収されたことで夜更しがなくなっただけかもしれません。この子供にゲームを再び与えた場合，どうなるでしょうか。

これらの問題を実験的に解明するのが行動科学者の目的であり，手段です。

## ソフトウェアエンジニアに向けて

本リポジトリは，行動科学者が行動の因果関係に迫るため，適切に刺激を制御し，反応を検知したいと願っています。
そのために，いかなる反応をも記録し，反応と時間を厳密に (可能であれば1ミリ秒単位まで) 記録したい，
最終的には，どんな時間イベントが何度重複して発生しようとも処理できるようにと考えております。

## クリーンアーキテクチャについて

![](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)

本リポジトリは [*クリーンアーキテクチャ*](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) ([邦訳](https://blog.tai2.net/the_clean_architecture.html)) を採用しています。これは基盤に共通のビジネスロジックを採用し，UIとそれを紐付けるコードを記述するだけで簡単に様々なUIに適用させることが可能になります。さらに，拡張性にも優れ，必要な強化スケジュールを独自に作り出すこともできます。

![](https://github.com/YutoMizutani/OperantKit/blob/master/assets/img/operantkit_architecture.png?raw=true)

クリーンアーキテクチャに従った場合，本ライブラリはデータ層及びドメイン層を担当している形となります。
強化スケジュールの演算に必要な実装は既に本ライブラリに組み込まれているため，プレゼンター層を追加するだけであらゆる実験を作成することができます。

## リアクティブプログラミングについて

本リポジトリは主に疎結合なレイヤー間での値渡し，計測時間の継続的な提供，反応イベントの効率的な変換，メインスレッド内競合解決のために非同期ライブラリを利用しています。

## 開発用インストール

`make` コマンドを使用します。詳しいコマンドについては [Makefile](https://github.com/YutoMizutani/OperantKit/blob/master/Makefile) を参照して下さい。

```
$ make deps-all
$ make open
```

## 参照

## 連絡先

Yuto Mizutani, yuto.mizutani.dev@gmail.com

## Donate

私の「モチベーション」は連続強化 (FR1) スケジュールで完全に制御されます。

## ライセンス

OperantKit は [MIT ライセンス](https://github.com/YutoMizutani/OperantKit/blob/master/LICENSE) の下に配布されています。