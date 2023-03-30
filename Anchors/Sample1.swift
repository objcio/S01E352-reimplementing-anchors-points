//

import Foundation
import SwiftUI

struct PointKey: PreferenceKey {
    static var defaultValue: Anchor<CGPoint>?

    static func reduce(value: inout Anchor<CGPoint>?, nextValue: () -> Anchor<CGPoint>?) {
        value = value ?? nextValue()
    }
}

struct MyPointKey: PreferenceKey {
    static var defaultValue: MyAnchor<CGPoint>?

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value ?? nextValue()
    }
}

struct Sample1: View {
    @State var myVisibility = true
    var body: some View {
        VStack {
            Toggle("Show MyAnchor implementation", isOn: $myVisibility)
                .padding(.bottom, 30)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .anchorPreference(key: PointKey.self, value: .center, transform: {
                    $0
                })
                .myAnchorPreference(key: MyPointKey.self, value: .center, transform: {
                    $0
                })
        }
        .padding()
        .overlayPreferenceValue(PointKey.self) { value in
            if let value {
                let _ = dump(value)
                GeometryReader { proxy in
                    let position = proxy[value]
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundColor(.green)
                        .offset(x: -2.5, y: -2.5)
                        .offset(x: position.x, y: position.y)
                        .opacity(myVisibility ? 0 : 1)
                }
            }
        }
        .overlayPreferenceValue(MyPointKey.self) { value in
            if let value {
                let _ = dump(value)
                GeometryReader { proxy in
                    let position = proxy[value]
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundColor(.green)
                        .offset(x: -2.5, y: -2.5)
                        .offset(x: position.x, y: position.y)
                        .opacity(myVisibility ? 1 : 0)
                }
            }
        }
    }
}
