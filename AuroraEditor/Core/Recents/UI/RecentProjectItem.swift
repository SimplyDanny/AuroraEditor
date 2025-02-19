//
//  RecentProjectView.swift
//  Aurora Editor
//
//  Created by Ziyuan Zhao on 2022/3/18.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import SwiftUI

// This view creates a recent item cell for the WelcomeView
// when a project has been recently opened.
public struct RecentProjectItem: View {
    // The path of the project
    let projectPath: String

    // Initialize a new RecentProjectItem
    //
    // - Parameter projectPath: the path of the project
    //
    // - Returns: a new RecentProjectItem
    public init(projectPath: String) {
        self.projectPath = projectPath
    }

    /// The view body.
    public var body: some View {
        HStack(spacing: 8) {
            Image(nsImage: NSWorkspace.shared.icon(forFile: projectPath))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .accessibilityLabel(Text("Project Icon"))
            VStack(alignment: .leading) {
                Text(projectPath.components(separatedBy: "/").last ?? "").font(.system(size: 13))
                    .lineLimit(1)
                Text(projectPath.abbreviatingWithTildeInPath())
                    .font(.system(size: 11))
                    .lineLimit(1)
                    .truncationMode(.head)
            }.padding(.trailing, 15)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct RecentProjectItem_Previews: PreviewProvider {
    static var previews: some View {
        RecentProjectItem(projectPath: "/repos/AuroraEditor")
            .frame(width: 300)
    }
}
