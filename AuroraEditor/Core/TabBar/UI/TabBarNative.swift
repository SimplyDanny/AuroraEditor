//
//  TabBarNative.swift
//  Aurora Editor
//
//  Created by Lingxi Li on 4/25/22.
//  Copyright © 2023 Aurora Company. All rights reserved.
//
//  This file contains some support views to make native tab bar style come true.

import SwiftUI

/// Native style background view (including color and shadow divider) for tab bar.
struct TabBarNativeInactiveBackground: View {
    /// The view body.
    var body: some View {
        ZStack(alignment: .top) {
            TabBarNativeInactiveBackgroundColor()
            // When tab bar style is `native`, we put the top divider beneath tabs.
            TabBarTopDivider()
        }
    }
}

/// Native style background color for tab bar.
struct TabBarNativeInactiveBackgroundColor: View {

    /// Color scheme
    @Environment(\.colorScheme)
    private var colorScheme

    /// The view body.
    var body: some View {
        Color(nsColor: .black)
            .opacity(colorScheme == .dark ? 0.45 : 0.05)
    }
}

/// Native style background material for active tab bar in fullscreen.
/// This view is only used in fullscreen (to match the material of toolbar).
struct TabBarNativeActiveMaterial: View {

    /// Color scheme
    @Environment(\.colorScheme)
    private var colorScheme

    /// The view body.
    var body: some View {
        EffectView(
            NSVisualEffectView.Material.headerView,
            blendingMode: NSVisualEffectView.BlendingMode.withinWindow
        )
        .background(
            // This layer of background is for matching the native toolbar background
            // in dark mode and in fullscreen.
            // There is no exactly matched material available.
            // If you have a better solution, feel free to replace!!
            Color(nsColor: colorScheme == .dark ? .selectedContentBackgroundColor : .clear)
                .opacity(0.003)
        )
        .background(
            Color(nsColor: .windowBackgroundColor)
        )
    }
}

/// Native style background material for tab bar.
struct TabBarNativeMaterial: View {

    /// The view body.
    var body: some View {
        EffectView(
            NSVisualEffectView.Material.titlebar,
            blendingMode: NSVisualEffectView.BlendingMode.withinWindow
        )
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
