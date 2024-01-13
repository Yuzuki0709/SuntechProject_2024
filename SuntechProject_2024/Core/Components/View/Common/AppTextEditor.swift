//
//  AppTextEditor.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/11.
//

import SwiftUI
import UIKit

public enum TextLineLimit {
    case fixed(Int)
    case flexible(ClosedRange<Int>)
}

private struct InternalTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    var textLimit: Int?
    let textContentInset: EdgeInsets

    final class Coordinator: NSObject, UITextViewDelegate {
        let parent: InternalTextView

        init(_ parent: InternalTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            if let textLimit = parent.textLimit, textView.markedTextRange == nil {
                // 変換中ではない場合文字制限をかける
                textView.text = String(textView.text.prefix(textLimit))
            }

            DispatchQueue.main.async {
                self.parent.text = textView.text!
            }
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isFocused = true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isFocused = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor(Color(R.color.timetable.backgroundColor))
        textView.delegate = context.coordinator
        textView.textContainerInset = .init(textContentInset)
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = .app.corner.radiusS
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text

        if isFocused != uiView.isFirstResponder {
            DispatchQueue.main.async {
                if isFocused {
                    uiView.becomeFirstResponder()
                } else {
                    uiView.resignFirstResponder()
                }
            }
        }
    }
}

public struct AppTextEditor: View {
    @Binding private var text: String
    @Binding private var isFocused: Bool

    private let placeholder: String?
    private let textLimit: Int?
    private let textContentInset: EdgeInsets

    private let minFakeText: String
    private let maxLineLimit: Int?

    public init(
        text: Binding<String>,
        isFocused: Binding<Bool>,
        placeholder: String? = nil,
        textLimit: Int? = nil,
        lineLimit: TextLineLimit,
        textContentInset: EdgeInsets = EdgeInsets(
            top: .app.space.spacingXS,
            leading: 0,
            bottom: .app.space.spacingXS,
            trailing: 0
        )
    ) {
        _text = text
        _isFocused = isFocused
        self.placeholder = placeholder
        self.textLimit = textLimit
        self.textContentInset = textContentInset

        switch lineLimit {
        case var .fixed(num):
            if num <= 0 {
                assertionFailure("Line limit should be greater than 0.")
                num = 1
            }
            self.minFakeText = " " + String(repeating: "\n", count: num - 1)
            self.maxLineLimit = nil

        case var .flexible(range):
            if range.lowerBound <= 0 {
                assertionFailure("Line limit should be greater than 0.")
                range = 0...max(0, range.upperBound)
            }
            self.minFakeText = " " + String(repeating: "\n", count: range.lowerBound - 1)
            self.maxLineLimit = range.upperBound
        }
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder
            if let placeholder, text.isEmpty {
                placeholderText(placeholder)
                    .foregroundColor(.gray)
            }

            // For min height
            placeholderText(minFakeText)
                .hidden()

            // For max height
            if let maxLineLimit {
                placeholderText(text)
                    .lineLimit(maxLineLimit)
                    .hidden()
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .overlay(alignment: .topLeading) {
            InternalTextView(
                text: $text,
                isFocused: $isFocused,
                textLimit: textLimit,
                textContentInset: textContentInset
            )
        }
    }

    private func placeholderText(_ text: String) -> some View {
        Text(text)
            .padding(textContentInset)
    }
}

public extension UIEdgeInsets {
    init(_ edgeInsets: EdgeInsets) {
        self = .init(
            top: edgeInsets.top,
            left: edgeInsets.leading,
            bottom: edgeInsets.bottom,
            right: edgeInsets.trailing
        )
    }
}
