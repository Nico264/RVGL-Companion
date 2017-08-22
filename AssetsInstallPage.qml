import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import AssetsManager 1.0

Page {
    id: page
    title: "Package installer"

    property string option: window.option

    AssetsManager {
        id: assetsManager
    }

    ColumnLayout {
        width: parent.width
        id: column
        Label {
            Layout.fillWidth: true
            text: "Select a download in the combobox below or enter a url to an archive to be extracted "
                + "in your RVGL folder."
            wrapMode: Label.Wrap
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Preselection"
            }

            ComboBox {
                Layout.fillWidth: true
                editable: true
                model: ListModel {
                    id: availableAssets
                    ListElement {
                        modelData: "IO track pack"
                        source: "http://files.re-volt.io/packs/tracks.7z"
                    }
                    ListElement {
                        modelData: "IO tracks' loading screens"
                        source: "http://files.re-volt.io/packs/loadlevel.7z"
                    }
                    ListElement {
                        modelData: "IO car pack"
                        source: "http://files.re-volt.io/packs/cars.7z"
                    }
                    ListElement {
                        modelData: "IO LMS & Tag pack"
                        source: "http://files.re-volt.io/packs/lmstag.7z"
                    }
                    ListElement {
                        modelData: "IO drift pack"
                        source: "http://files.re-volt.io/packs/drift.7z"
                    }
                    ListElement {
                        modelData: "IO clockwork pack"
                        source: "http://files.re-volt.io/packs/clockworks.7z"
                    }
                    ListElement {
                        modelData: "RVR month track pack"
                        source: "http://files.re-volt.io/packs/month_pack.7z"
                    }
                }
                currentIndex: -1
                onCurrentIndexChanged: {
                    assetURL.text = availableAssets.get(currentIndex).source
                }
                Component.onCompleted: {
                    if (Qt.platform.os === "windows") {
                        availableAssets.insert(0, {modelData: "RVGL without music", source: "http://files.re-volt.io/rvgl_full/rvgl_17.0327a_win32_nomusic.7z"})
                        availableAssets.insert(0, {modelData: "RVGL with music", source: "http://files.re-volt.io/rvgl_full/rvgl_17.0327a_win32_music.7z"})
                    } else {
                        availableAssets.insert(0, {modelData: "RVGL without music", source: "http://files.re-volt.io/rvgl_full/rvgl_17.0327a_linux_nomusic.7z"})
                        availableAssets.insert(0, {modelData: "RVGL with music", source: "http://files.re-volt.io/rvgl_full/rvgl_17.0327a_linux_music.7z"})
                    }
                }
            }
        }

        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            Label {
                text: "Asset URL:"
                color: assetURL.text === "" ? "#e41e25" : "black"
            }

            TextField {
                id: assetURL
                Layout.fillWidth: true
                text: option
            }

            Button {
                id: confirm
                text: "Install"
                onClicked: {
                    assetsManager.installAsset(assetURL.text)
                }
                enabled: assetURL.text !== ""
            }
        }
        Repeater {
            id: progressBars
            model: assetsManager.progresses
            ProgressBar {
                from: 0
                to: 100
                value: modelData
                Layout.fillWidth: true
            }
        }
        Button {
            text: "Fix filename cases (done automatically after installs)"
            onClicked: {
                assetsManager.fixCases()
            }
            visible: Qt.platform.os !== "windows"
            Layout.fillWidth: true
        }
    }
}