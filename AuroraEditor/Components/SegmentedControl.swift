//
//  SegmentedControl.swift
//  Aurora Editor
//
//  Created by Lukas Pistrol on 31.03.22.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import SwiftUI

/// A view that creates a segmented control from an array of text labels.
public struct SegmentedControl: View {
    /// A view that creates a segmented control from an array of text labels.
    /// - Parameters:
    ///   - selection: The index of the current selected item.
    ///   - options: the options to display as an array of strings.
    ///   - prominent: A Bool indicating whether to use a prominent appearance instead
    ///   of the muted selection color. Defaults to `false`.
    public init(
        _ selection: Binding<Int>,
        options: [String],
        prominent: Bool = false
    ) {
        self._preselectedIndex = selection
        self.options = options
        self.prominent = prominent
    }

    /// The index of the current selected item.
    @Binding
    private var preselectedIndex: Int

    /// The options to display as an array of strings.
    private var options: [String]

    /// A Bool indicating whether to use a prominent appearance instead
    private var prominent: Bool

    /// The view body.
    public var body: some View {
        HStack(spacing: 8) {
            ForEach(options.indices, id: \.self) { index in
                SegmentedControlItem(
                    label: options[index],
                    active: preselectedIndex == index,
                    action: {
                        preselectedIndex = index
                    },
                    prominent: prominent
                )

            }
        }
        .frame(height: 20, alignment: .leading)
    }
}

/// A view that represents a single item in a segmented control.
struct SegmentedControlItem: View {
    /// The color scheme.
    @Environment(\.colorScheme)
    private var colorScheme

    /// The active state.
    @Environment(\.controlActiveState)
    private var activeState

    /// A binding to the hovering state.
    @State
    var isHovering: Bool = false

    /// A binding to the pressing state.
    @State
    var isPressing: Bool = false

    /// Item label.
    let label: String

    /// Is the item active.
    let active: Bool

    /// The action to perform when the item is tapped.
    let action: () -> Void

    /// A Bool indicating whether to use a prominent appearance instead
    let prominent: Bool

    /// The color of the control.
    private let color: Color = Color(nsColor: .selectedControlColor)

    /// The view body.
    public var body: some View {
        Text(label)
            .font(.subheadline)
            .foregroundColor(textColor)
            .opacity(textOpacity)
            .frame(height: 20)
            .padding(.horizontal, 7.5)
            .background(
                background
            )
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .onTapGesture {
                action()
            }
            .accessibilityAddTraits(.isButton)
            .onHover { hover in
                isHovering = hover
            }
            .pressAction {
                isPressing = true
            } onRelease: {
                isPressing = false
            }

    }

    /// The text color.
    private var textColor: Color {
        if prominent {
            return active
            ? .white
            : .primary
        } else {
            return active
            ? colorScheme == .dark ? .white : .accentColor
            : .primary
        }
    }

    /// The text opacity.
    private var textOpacity: Double {
        if prominent {
            return activeState != .inactive ? 1 : active ? 1 : 0.3
        } else {
            return activeState != .inactive ? 1 : active ? 0.5 : 0.3
        }
    }

    /// The background color.
    @ViewBuilder
    private var background: some View {
        if prominent {
            if active {
                Color.accentColor.opacity(activeState != .inactive ? 1 : 0.5)
            } else {
                Color(nsColor: colorScheme == .dark ? .white : .black)
                .opacity(isPressing ? 0.10 : isHovering ? 0.05 : 0)
            }
        } else {
            if active {
                color.opacity(isPressing ? 1 : activeState != .inactive ? 0.75 : 0.5)
            } else {
                Color(nsColor: colorScheme == .dark ? .white : .black)
                .opacity(isPressing ? 0.10 : isHovering ? 0.05 : 0)
            }
        }
    }
}

struct SegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControl(.constant(0), options: ["Tab 1", "Tab 2"], prominent: true)
            .padding()

        SegmentedControl(.constant(0), options: ["Tab 1", "Tab 2"])
            .padding()
    }
}
