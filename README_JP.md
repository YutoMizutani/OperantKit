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

## デモ

![](https://github.com/YutoMizutani/OperantKit/blob/master/assets/demo_ratchamber.gif?raw=true)

## サポートされているスケジュール

### 単一スケジュール

#### 比率スケジュール

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

[docs/index.html](https://github.com/YutoMizutani/OperantKit/blob/master/docs/index.html) を参照して下さい。

## オペラント条件づけ (道具的条件づけ) について

## クリーンアーキテクチャについて

![](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)

本リポジトリは [*クリーンアーキテクチャ*](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) ([邦訳](https://blog.tai2.net/the_clean_architecture.html)) を採用しています。これは基盤に共通のビジネスロジックを採用し，UIとそれを紐付けるコードを記述するだけで簡単に様々なUIに適用させることが可能になります。さらに，拡張性にも優れ，必要な強化スケジュールを独自に作り出すこともできます。

クリーンアーキテクチャに従った場合，本ライブラリはData層及びDomain層を担当している形となります。

## リアクティブプログラミングについて

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