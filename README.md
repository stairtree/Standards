# Standards

<a href="LICENSE">
<img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
</a>
<a href="https://swift.org">
<img src="https://img.shields.io/badge/swift-5.2-brightgreen.svg" alt="Swift 5.2">
</a>
<a href="https://github.com/stairtree/Standards/actions">
<img src="https://github.com/stairtree/Standards/workflows/test/badge.svg" alt="CI">
</a>

Useful standards for business applications

## Table of Contents
* [Supported Platforms](#supported-platforms)
* [Installation](#installation)
* [Usage](#usage)
   * [Continents](#continents)
   * [Countries (ISO 3166-1)](#countries-iso-3166-1)
   * [Currencies (ISO 4217)](#currencies-iso-4217)
   * [Languages (ISO 639)](#languages-iso-639)
   * [Human Sexes (ISO 5218)](#human-sexes-iso-5218)
* [Updating data](#updating-data)
* [Copyright](#copyright)

---

## Supported Platforms

Standards is tested on macOS, iOS, tvOS, Linux, and Windows, and is known to support the following operating system versions:

* Ubuntu 16.04+
* macOS 10.12+
* iOS 12+
* tvOS 12+
* watchOS (untested since watchOS doesn't support `XCTest`)
* Windows 10 (using the latest Swift development snapshot)

**Note: Tests are currently disabled on iOS, tvOS, and watchOS as `xcodebuild` doesn't handle executable targets in packages for testing.`**

## Installation

To integrate the package:

```swift
dependencies: [
    .package(url: "https://github.com/stairtree/Standards.git", from: "1.0.1")
]
```

## Usage

### Continents

While there is no standard for referring to continents, codes and names are widely used.

```swift
let africa = ISOContinents.find(byCode: "AF")!
// dump(africa)
// ▿ Standards.ContinentInfo
//   - code: "AF"
//   - name: "Africa"
africa.countries
// {{name "Burundi", numeric "108", alpha2 "BI", alpha3 "BDI", {…}},…
```

### Countries (ISO 3166-1)

All countries currently recognized in ISO 3166-1. The data is sourced from [Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1) for now.

```swift
let austria = ISOCountries.find(byAlpha2: "AT")!
// dump(austria)
// ▿ Standards.ISOCountryInfo
//   - name: "Austria"
//   - numeric: "040"
//   - alpha2: "AT"
//   - alpha3: "AUT"
//   ▿ continents: 1 member
//   - "EU"
let localized = austria.localizedName(for: .init(localeIdentifier: "de_at"))
// "Österreich"
```

### Currencies (ISO 4217)

All currencies currently recognized in ISO 4217 and currently in use. Funds are excluded. The data is sourced from [ISO](https://www.currency-iso.org/dam/downloads/lists/list_one.xml) directly.

```swift
let canadianDollar = ISOCurrencies.find(byCode: "CAD")!
// dump(canadianDollar)
// ▿ Standards.ISOCurrencyInfo
//   - name: "Canadian Dollar"
//   - numeric: "124"
//   - code: "CAD"
//   - minorUnit: 2
canadianDollar.localizedName(for: .init(localeIdentifier: "de_at"))
// "Kanadischer Dollar"
canadianDollar.symbol
// "CA$"
```

### Languages (ISO 639)

All languages contained in ISO 639-1. The data is sourced from [Wikipedia](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) for now.

```swift
let bengali = ISOLanguages.find(byCode1: "bn")!
dump(bengali)
// ▿ Standards.ISOLanguageInfo
//   - name: "Bengali"
//   - endonym: "বাংলা"
//   - family: "Indo-European"
//   - code1: "bn"
//   - code2T: "ben"
//   - code2B: "ben"
//   - code3: "ben"
bengali.localizedName(for: .init(localeIdentifier: "de_at"))
// "Bengalisch"
```

### Human Sexes (ISO 5218)

Human sexes as defined by ISO 5218. **Note: This is not a valid representation of human gender** (See [awesome falsehood](https://github.com/kdeldycke/awesome-falsehood))! 
Should only be used to handle legacy IT systems or where this standard is required explicitly. Ideally this information is irrelevant and should not be required.

---

## Updating data

Run `swift run update` at the root of the package to parse all sources and regenerate the various files.

_**Note**: No releases have yet been tagged._

## Copyright

All data is owned by their respective sources. Only publicly available data is used.
