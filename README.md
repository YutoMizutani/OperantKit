# OperantKit

[![Build Status](https://app.bitrise.io/app/e1b066c3a796bb39/status.svg?token=3DteqY4In4ByLDs_2-iucg&branch=master)](https://app.bitrise.io/app/e1b066c3a796bb39)
![platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-333333.svg)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/YutoMizutani/OperantKit/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/OperantKit.svg)](https://github.com/YutoMizutani/OperantKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/YutoMizutani/OperantKit)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

**OperantKit** is a tool kit for *operant conditioning* (*instrumental conditioning*) experiments written in Swift.

日本語:jp:: [README_JP.md](https://github.com/YutoMizutani/OperantKit/blob/master/README_JP.md)

## Usage

```swift
import OperantKit
import RxSwift

func main() {
	let schedule = FR(5) // Fixed ratio 5 schedule
	let events: Observable<Void> = ... // Observable events
	schedule.decision(events)
		.filter({ $0.isReinforcement }) // Filtering responses of reinforcement
		.subscribe(onNext: {
			print("Reinforcement")
		})
		.disposed(by: DisposeBag())
}
```

## Demo

![](https://github.com/YutoMizutani/OperantKit/blob/master/assets/demo_ratchamber.gif?raw=true)

## Supporting schedules

### Simple schedules

#### Fixed schedules

|Name of schedule|Code|
|:-:|:-:|
|Fixed ratio schedule|`FR(5)`|
|Variable ratio schedule|`VR(5)` ※|
|Random ratio schedule|`RR(5)`|

※ The number of iterations of the variable schedule is "12" by default,

```swift
VR(10, iterations: 12)
```

It is also possible to change the number of iterations and so on.

#### Interval schedules

|Name of schedule|Code|
|:-:|:-:|
|Fixed interval schedule|`FI(5)`|
|Variable interval schedule|`VI(5)`|
|Random interval schedule|`RI(5)`|

The time interval defaults in `.seconds`,

```swift
FI(5, unit: .minutes)
```

It is also possible to change the unit in such a way.

#### Time schedules

|Name of schedule|Code|
|:-:|:-:|
|Fixed time schedule|`FT(5)`|
|Variable time schedule|`VT(5)`|
|Random time schedule|`RT(5)`|

The time interval defaults in `.seconds`,

```swift
FI(5, unit: .minutes)
```

It is also possible to change the unit in such a way.

#### Other schedules

|Name of schedule|Code|
|:-:|:-:|
|Continuous reinforcement|`CRF()`|
|Extinction schedule|`EXT()`|

### Compound schedules

|Name of schedule|Code|
|:-:|:-:|
|Concurrent schedule|`Conc(FR(5), VI(10))` ※|

※ When a common schedule applies to two or more types of operandam like the internal link in concurrent chained schedule, it can be handled by using `Shared()` keyword. e.g. `Conc(Shared(VI(10)))`

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Add this to your `Podfile`:

```ruby
pod 'OperantKit'
```

and

```bash
$ pod install
```

### [Carthage](https://github.com/Carthage/Carthage)

Add this to your `Cartfile`:

```
github "YutoMizutani/OperantKit"
```

and

```bash
$ carthage update
```

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/YutoMizutani/OperantKit.git", "0.0.1" ..< "1.0.0"),
]
```

and

```bash
$ swift build
```

## Dependencies

* [RxSwift](https://www.github.com/ReactiveX/RxSwift)
* [RxCocoa](https://www.github.com/ReactiveX/RxSwift)

## Documents

See [docs/index.html](https://github.com/YutoMizutani/OperantKit/blob/master/docs/index.html)

## Operant conditioning (Instrumental conditioning)

## Clean architecture

![](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)

## Reactive programming

## Development installation

Clone this repository,

```bash
$ git clone https://github.com/YutoMizutani/OperantKit.git
```

And use `make` command,

```bash
$ make deps-all
$ make open
```

## References

## Author

Yuto Mizutani, yuto.mizutani.dev@gmail.com

## Donate

My "motivation" is fully controlled by continuous reinforcement (FR1) schedule :)

## License

OperantKit is available under the [MIT license](https://github.com/YutoMizutani/OperantKit/blob/master/LICENSE).