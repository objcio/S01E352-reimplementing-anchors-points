//

import SwiftUI

public struct MyAnchor<Value> {
    var value: Value
    var convertToLocal: (Value, GeometryProxy) -> Value

    public struct Source {
        var measure: (CGRect) -> Value
        var convertToLocal: (Value, GeometryProxy) -> Value
    }
}

extension MyAnchor<CGRect>.Source {
    public static var bounds: Self {
        Self(measure: { $0 }) { sourceRect, proxy in
            let s = proxy.frame(in: .global)
            let o = sourceRect
            return o.offsetBy(dx: -s.origin.x, dy: -s.origin.y)
        }
    }
}

extension CGRect {
    subscript(_ p: UnitPoint) -> CGPoint {
        CGPoint(x: origin.x + width*p.x, y: origin.y + height*p.y)
    }
}

extension MyAnchor<CGPoint>.Source {
    public static func unitPoint(_ p: UnitPoint) -> Self {
        Self(measure: { $0[p] }) { sourcePoint, proxy in
            let s = proxy.frame(in: .global).origin
            let o = sourcePoint
            return o.applying(.init(translationX: -s.x, y: -s.y))
        }
    }
    public static var center: Self {
        unitPoint(.center)
    }

    public static var trailing: Self {
        unitPoint(.trailing)
    }
}

extension View {
    func myAnchorPreference<Value, Key: PreferenceKey>(key: Key.Type, value: MyAnchor<Value>.Source, transform: @escaping (MyAnchor<Value>) -> Key.Value) -> some View {
        overlay(GeometryReader { proxy in
            let frame = proxy.frame(in: .global)
            let anchorValue = value.measure(frame)
            let anchor = MyAnchor(value: anchorValue, convertToLocal: value.convertToLocal)
            Color.clear.preference(key: key, value: transform(anchor))
        })
    }
}

extension GeometryProxy {
    subscript<Value>(_ anchor: MyAnchor<Value>) -> Value {
        anchor.convertToLocal(anchor.value, self)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: {
                    Sample0()
                }, label: {
                    Text("Sample 0")
                })
                NavigationLink(destination: {
                    Sample1()
                }, label: {
                    Text("Sample 1")
                })
            }.listStyle(.sidebar)
            Text("Select a sample")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
