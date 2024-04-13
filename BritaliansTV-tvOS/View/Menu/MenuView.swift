//
//  MenuView.swift
//  DemoApp
//
//  Created by miqo on 11.09.23.
//

import SwiftUI
import Kingfisher

struct MenuView: View {
    @EnvironmentObject private var appVM: ApplicationVM
    @EnvironmentObject private var menuVM: MenuVM
    
    @FocusState var focus: MenuItem?
    private let items: [MenuItem] = MenuItem.allCases
    
    var body: some View {
        menuContainer()
            .focusSection()
            .padding(.leading, 50)
            .frame(
                width: menuVM.opened ? 350 : 120,
                alignment: .topLeading
            )
            .onChange(of: focus, performAction: { oldValue, newValue in
                switch oldValue {
                case nil:
                    focus = menuVM.selection
                default:
                    break
                }
            
                //print("menu OpenClose selection is valid: \(newValue != nil) | isFocusable: \(menuVM.isFocusable)")
                if menuVM.isFocusable {
                    menuVM.opened = (newValue != nil)
                }
            })
    }
    
    @ViewBuilder
    func menuContainer() -> some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Spacer()
            ForEach(items, id: \.id) { item in
                MenuButton(
                    name: item.name,
                    image: item.image,
                    isSelected: menuVM.selection == item,
                    action: {
                        if item == .exit {
                            print("On exit pressed: ", appVM.exitPresented)
                            appVM.exitPresented = true
                            
                        } else {
                            menuVM.selection = item
                        }
                    }
                )
                //.padding(.horizontal, menuVM.opened ? 70 : 40)
                .padding(.bottom, 35)
                .focused($focus, equals: item)
            }
            Spacer()
        })
        .frame(maxHeight: .infinity)
        .fixedSize(horizontal: true, vertical: false)
        .background(.black)
    }
}
