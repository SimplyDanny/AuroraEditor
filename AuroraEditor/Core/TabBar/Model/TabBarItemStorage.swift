//
//  TabBarItemStorage.swift
//  Aurora Editor
//
//  Created by TAY KAI QUAN on 14/9/22.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import SwiftUI

/// Storage for a tab item
class TabBarItemStorage: NSObject, Codable, Identifiable {
    /// Unique identifier
    var id = UUID()

    /// Tab bar item ID
    var tabBarID: TabBarItemID

    /// Children of the tab item
    var children: [TabBarItemStorage] = []

    /// Category of the tab item
    var category: TabHierarchyCategory

    /// Parent item
    var parentItem: TabBarItemStorage?

    // Notably, children is missing from this. This is because it will result in
    // circular calling of encode(to encoder), which will hang the app.
    // unfortunately that means that groups of saved tabs cannot be moved.
    private enum Keys: CodingKey {
        case tabBarID, category, parentItem, id
    }

    /// Initialize a new tab item storage
    /// 
    /// - Parameter tabBarID: Tab bar item ID
    /// - Parameter category: Category of the tab item
    /// - Parameter children: Children of the tab item
    /// 
    /// - Returns: A new tab item storage
    init(tabBarID: TabBarItemID, category: TabHierarchyCategory, children: [TabBarItemStorage] = []) {
        self.category = category
        self.tabBarID = tabBarID
        self.children = children
    }

    /// Initialize a new tab item storage
    /// 
    /// - Parameter decoder: Decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.tabBarID = try container.decode(TabBarItemID.self, forKey: Keys.tabBarID)
        self.category = try container.decode(TabHierarchyCategory.self, forKey: Keys.category)
        self.parentItem = try container.decode(TabBarItemStorage?.self, forKey: Keys.parentItem)
        self.id = try container.decode(UUID.self, forKey: Keys.id)
    }

    /// Encode the tab item storage
    /// 
    /// - Parameter encoder: Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.tabBarID, forKey: Keys.tabBarID)
        try container.encode(self.category, forKey: Keys.category)
        try container.encode(self.parentItem, forKey: Keys.parentItem)
        try container.encode(self.id, forKey: Keys.id)
    }

    /// Item count
    var itemCount: Int {
        var soFar = 1 // 1 for the item itself

        // for each child, add its item count (recursive)
        for child in children {
            soFar += child.itemCount
        }
        return soFar
    }

    /// Flattened children
    var flattenedChildren: [TabBarItemStorage] {
        var flat = [TabBarItemStorage]()
        for child in children {
            flat.append(child)
            flat.append(contentsOf: child.flattenedChildren)
        }
        return flat
    }
}

extension Array where Iterator.Element: TabBarItemStorage {
    /// Total number of tabs in the array
    var allTabs: Int {
        return reduce(0, { soFar, tab in
            return soFar + (tab.itemCount)
        })
    }
}

/// Tab hierarchy category
enum TabHierarchyCategory: Codable {
    /// Saved tabs
    case savedTabs

    /// Open tabs
    case openTabs

    /// Unknown
    case unknown
}
