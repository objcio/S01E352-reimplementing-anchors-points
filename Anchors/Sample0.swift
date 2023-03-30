//

import Foundation
import SwiftUI


struct HighlightKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>?

    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

struct MyHighlightKey: PreferenceKey {
    static var defaultValue: MyAnchor<CGRect>?

    static func reduce(value: inout MyAnchor<CGRect>?, nextValue: () -> MyAnchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

struct Sample0: View {
    @State var myVisibility = true
    var body: some View {
        VStack {
            Toggle("Show MyAnchor implementation", isOn: $myVisibility)
                .padding(.bottom, 30)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .anchorPreference(key: HighlightKey.self, value: .bounds, transform: {
                    $0
                })
                .myAnchorPreference(key: MyHighlightKey.self, value: .bounds, transform: {
                    $0
                })
        }
        .padding()
        .overlayPreferenceValue(HighlightKey.self) { value in
            if let value {
                GeometryReader { proxy in
                    let frame = proxy[value]
                    Ellipse()
                        .stroke(Color.red, lineWidth: 2)
                        .padding(-10)
                        .frame(width: frame.width, height: frame.height)
                        .offset(x: frame.origin.x, y: frame.origin.y)
                        .opacity(myVisibility ? 0 : 1)
                }
            }
        }
        .overlayPreferenceValue(MyHighlightKey.self) { value in
            if let value {
                GeometryReader { proxy in
                    let frame = proxy[value]
                    Ellipse()
                        .stroke(Color.red, lineWidth: 2)
                        .padding(-10)
                        .frame(width: frame.width, height: frame.height)
                        .offset(x: frame.origin.x, y: frame.origin.y)
                        .opacity(myVisibility ? 1 : 0)
                }
            }
        }
//        .overlay {
//            Ellipse()
//                .stroke(Color.red, lineWidth: 1)
//                .padding(-10)
//        }
    }
}
