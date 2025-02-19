//
//  UpdatePreferencesView.swift
//  Aurora Editor
//
//  Created by Nanashi Li on 2022/09/23.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import SwiftUI

/// A view that represents the update preferences view.
struct UpdatePreferencesView: View {
    /// Preferences model
    @ObservedObject
    private var prefs: AppPreferencesModel = .shared

    /// Update editor repository
    private var repository: UpdateEditorRepository = UpdateEditorRepository()

    /// Update model
    @ObservedObject
    private var updateModel: UpdateObservedModel = .shared

    /// Whether the update settings is open
    @State
    private var openUpdateSettings: Bool = false

    /// The app version
    private var appVersion: String {
        Bundle.versionString ?? "No Version"
    }

    /// The app build number
    private var commitHash: String {
        Bundle.commitHash ?? "No Hash"
    }

    /// Whether the update button is disabled
    private var isUpdateButtonDisabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    /// The short commit hash
    private var shortCommitHash: String {
        if commitHash.count > 7 {
            return String(commitHash[...commitHash.index(commitHash.startIndex, offsetBy: 7)])
        }

        return commitHash
    }

    /// The view body
    var body: some View {
        PreferencesContent {
            VStack {
                GroupBox {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Automatic Updates")
                                .font(.system(size: 12, weight: .medium))
                            Spacer()
                            Text(automaticUpdates())
                                .foregroundColor(.secondary)
                                .font(.system(size: 12, weight: .medium))
                            Button {
                                openUpdateSettings.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 12, weight: .medium))
                                    .accessibilityLabel(Text("Open Update Settings"))
                            }
                            .buttonStyle(.plain)
                            .sheet(isPresented: $openUpdateSettings) {
                                AutomaticallyUpdateSheet()
                            }
                        }
                        Text("This IDE is currently enrolled in the \(updateChannelDescription()) Build Programme")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                            .padding(.vertical, -4)

                        Link("settings.update.learn.more",
                             destination: URL("https://auroraeditor.com"))
                        .font(.system(size: 11))
                        .foregroundColor(.accentColor)
                    }
                    .padding(5)
                }
                .padding(5)

                switch updateModel.updateState {
                case .loading:
                    UpdateLoadingState()
                case .updateFound:
                    UpdateAvailableState(model: updateModel, prefs: prefs)
                case .error:
                    UpdateErrorState(prefs: prefs,
                                     updateModel: updateModel)
                case .cancelled:
                    UpdateErrorState(prefs: prefs,
                                     updateModel: updateModel)
                case .timedOut:
                    UpdateErrorState(prefs: prefs,
                                     updateModel: updateModel)
                case .networkConnectionLost:
                    UpdateErrorState(prefs: prefs,
                                     updateModel: updateModel)
                case .cannotFindHost:
                    UpdateErrorState(prefs: prefs,
                                     updateModel: updateModel)
                case .cannotConnectToHost:
                    UpdateErrorState(prefs: prefs,
                                     updateModel: updateModel)
                case .notEnoughStorage:
                    UpdateErrorState(prefs: prefs,
                                     updateModel: updateModel)
                case .invalidChecksum:
                    UpdateErrorState(prefs: prefs,
                                     updateModel: updateModel)
                case .unzipError:
                    UpdateErrorState(prefs: prefs,
                                     updateModel: updateModel)
                case .updateReady:
                    UpdateReadyState(repository: repository,
                                     model: updateModel,
                                     prefs: prefs)
                case .inProgress:
                    UpdateInProgressState(repository: repository,
                                          model: updateModel)
                case .checksumInvalid:
                    UpdateInvalidChecksumState(repository: repository,
                                               prefs: prefs,
                                               model: updateModel)
                case .upToDate:
                    UpdateUpToDateState(prefs: prefs,
                                        model: updateModel)
                }

                // swiftlint:disable:next line_length
                Text("Use of this software is subject to the [original license agreement](https://auroraeditor.com) that accompanied the software being updated.")
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(5)
            }
        }
        .onAppear {
            updateModel.checkForUpdates()
        }
    }

    /// Update the channel description
    ///
    /// - Returns: The channel description
    func updateChannelDescription() -> String {
        switch prefs.preferences.updates.updateChannel {
        case .release:
            return "settings.update.channel.release".localize()
        case .beta:
            return "settings.update.channel.beta".localize()
        case .nightly:
            return "settings.update.channel.nightly".localize()
        }
    }

    /// Get the automatic updates
    func automaticUpdates() -> String {
        if prefs.preferences.updates.checkForUpdates {
            return "On"
        } else {
            return "Off"
        }
    }
}

struct UpdatePreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePreferencesView()
    }
}
