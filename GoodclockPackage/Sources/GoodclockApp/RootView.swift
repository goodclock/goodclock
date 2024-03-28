//
//  File.swift
//  
//
//  Created by 송영모 on 3/28/24.
//

import Foundation
import SwiftUI

enum Navigation: Hashable {
    case editor(Editor)
}

@Observable
class Model {
    var path: [Navigation] = .init()
    var clocks: [ClockModel] = [
        .init(title: "시계 1"),
        .init(title: "시계 2"),
        .init(title: "시계 3"),
    ]

    func clockTapped(clock: ClockModel) {
        let editor = Editor(clock: clock)
        editor.delegate = self
        path.append(.editor(editor))
    }
}

extension Model: EditorDelegate {
    func request() {
        print("hello")
    }
}

protocol EditorDelegate: AnyObject {
    func request()
}

protocol AutoHashable: Hashable, AnyObject {}

extension AutoHashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

@Observable
class Editor: AutoHashable {
    var clock: ClockModel
    weak var delegate: (any EditorDelegate)?

    init(clock: ClockModel) {
        self.clock = clock
    }
}

class ClockModel: Identifiable {
    var title: String

    init(title: String) {
        self.title = title
    }
}

struct RootView: View {
    @State var model: Model

    init(model: Model) {
        self._model = .init(initialValue: model)
    }

    var body: some View {
        NavigationStack(path: $model.path) {
            main
                .navigationDestination(for: Navigation.self) {
                    switch $0 {
                    case .editor(let editor):
                        EditorView(editor: editor)
                    }
                }
        }
    }

    var main: some View {
        VStack {
            ForEach(model.clocks) { clock in
                Button("edit \(clock.title)") {
                    model.clockTapped(clock: clock)
                }
            }
        }
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

#Preview {
    RootView(model: .init())
}
