# dw
web-api for dw.com News, off-beat stories and analysis of German and international affairs. Dive deeper with our features from Europe and beyond. Watch our 24/7 TV stream.
# main
```swift
import Foundation
import dw
let client = Dw()

do {
    let news = try await client.get_breaking_news()
    print(news)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
