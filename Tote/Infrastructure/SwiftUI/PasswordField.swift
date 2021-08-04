//
//  PasswordField.swift
//  Tote
//
//  Created by Brian Michel on 4/5/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct PasswordField: View {
    @State var secure: Bool = true
    @State private var icon = "eye"

    var placeholder: String = ""

    private var password: Binding<String>

    init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        password = text
    }

    var body: some View {
        HStack {
            if self.secure {
                SecureField(self.placeholder, text: self.password)
            } else {
                TextField(self.placeholder, text: self.password)
            }
            Spacer()
            Button(action: {
                self.secure.toggle()
                self.icon = self.secure ? "eye" : "eye.slash"
            }, label: {
                Image(systemName: self.icon)
            })
        }
    }
}

#if DEBUG
    struct PasswordField_Previews: PreviewProvider {
        static var previews: some View {
            PasswordField(placeholder: "Something", text: .constant("password")).padding()
        }
    }
#endif
