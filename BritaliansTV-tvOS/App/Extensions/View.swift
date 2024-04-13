//
//  View.swift
//  BritaliansTV-tvOS
//
//  Created by miqo on 28.03.24.
//

import SwiftUI

extension View {
    @inlinable public func onChange<V: Equatable>(of value: V, performAction action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some View {
        if #available(tvOS 17.0, *) {
            return self.onChange(of: value, { oldValue, newValue in
                action(oldValue, newValue)
            })
        } else {
            return self.onChange(of: value, perform: { newValue in
                action(newValue, newValue)
            })
        }
    }
}
