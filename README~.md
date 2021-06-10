# Moji

Easy RSS parsing to Swift Codables

### Usage

#### Decode

Decode from data

```swift
let rssFeed = Moji.decode(from: data)
```

Decode from URL Request 

*(requires iOS 15+)*

```swift
let rss = try await Moji.decode(from: urlRequest)
```

#### Encode

```swift
```

