//
//  Clone.swift
//  Aurora Editor
//
//  Created by Nanashi Li on 2022/08/12.
//  Copyright © 2023 Aurora Company. All rights reserved.
//
//  This source code is restricted for Aurora Editor usage only.
//

import Foundation

/// GIT clone
public struct Clone {

    /// Clones a repository from a given url into to the specified path.
    ///
    /// - Parameter url: The remote repository URL to clone from
    /// - Parameter path: The destination path for the cloned repository. If the
    ///            path does not exist it will be created. Cloning into an
    ///            existing directory is only allowed if the directory is
    ///            empty.
    /// - Parameter options: Options specific to the clone operation, see the
    ///               documentation for CloneOptions for more details.
    /// - Parameter progressCallback: An optional function which will be invoked
    ///                     with information about the current progress
    ///                     of the clone operation. When provided this enables
    ///                     the '--progress' command line flag for
    ///                     'git clone'.
    func clone() {}

}
