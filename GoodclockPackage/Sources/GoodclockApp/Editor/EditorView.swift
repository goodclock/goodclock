//
//  File.swift
//  
//
//  Created by 송영모 on 3/28/24.
//

import Foundation
import SwiftUI

@Observable
class Editor: AutoHashable {
    var clock: ClockModel
    weak var delegate: (any EditorDelegate)?

    init(clock: ClockModel) {
        self.clock = clock
    }
}


struct EditorView: View {
    let editor: Editor

    var body: some View {
        VStack {
            row
            Spacer()
        }
    }

    @ViewBuilder
    var row: some View {
        @Bindable var editor = editor
        VStack {
            TextField("", text: $editor.clock.title)
        }
    }
}
