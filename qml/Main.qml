// Copyright (C) 2022 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "." as App

ApplicationWindow {
	id: window
	width: 360
	height: 520
	visible: true
	title: qsTr("SHV Spy")

	//! [orientation]
	readonly property bool portraitMode: window.width < window.height
	//! [orientation]

	function help() {
		let displayingControl = listView.currentIndex !== -1
		let currentControlName = displayingControl
			? listView.model.get(listView.currentIndex).title.toLowerCase() : ""
		let url = "https://doc.qt.io/qt-6/"
			+ (displayingControl
			   ? "qml-qtquick-controls2-" + currentControlName + ".html"
			   : "qtquick-controls2-qmlmodule.html");
		Qt.openUrlExternally(url)
	}

	required property var builtInStyles

	Settings {
		id: settings
		property string style
	}

	header: ToolBar {
		Rectangle {
			color: app.settings.headerColor
			anchors.fill: parent
			RowLayout {
				anchors.fill: parent
				spacing: 20

				BusyIndicator {
					id: busyIndicator
					running: false
					height: settingsButton.height
					width: height
				}

				Label {
					Layout.fillWidth: true

					text: qsTr("ShvSpy")
					horizontalAlignment: Qt.AlignHCenter
					verticalAlignment: Qt.AlignVCenter
					font.pixelSize: app.settings.fontSize + 4
					font.bold: true
				}

				ToolButton {
					id: settingsButton
					icon.source: "../images/menu.svg"
					onClicked: {
						aboutDialog.open()
					}

					//palette.button: Constants.isDarkModeActive ? "#30D158" : "#34C759"
					//palette.highlight: Constants.isDarkModeActive ? "#30DB5B" : "#248A3D"
				}
			}
		}
		Rectangle {
			anchors.right: parent.right
			anchors.left: parent.left
			anchors.bottom: parent.bottom
			height: 1
			color: app.settings.delegateColor
		}
	}
	StackView {
		id: stackView

		anchors.fill: parent

		initialItem: BrokersPane {
			id: brokersPane
		}
		Component {
			id: brokerProperties
			BrokerProperties {
				onCancelled: stackView.pop()
				onUpdateBroker: (connection_id, broker_propeties) => {
					stackView.pop()
					app.brokerListModel.updateBroker(connection_id, broker_propeties)
				}
			}
		}
		Component {
			id: shvPane
			ShvPane {
				onBack: stackView.pop()
				onGotoRoot: {
					while(stackView.depth > 2) {
						stackView.pop()
					}
				}
			}
		}
		Connections {
			target: brokersPane
			function onAddBroker() {
				//console.log("add broker 2")
				stackView.push(brokerProperties)
			}
			function onEditBroker(connection_id) {
				console.log("edit broker connection_id", connection_id)
				let pane = stackView.push(brokerProperties)
				pane.loadParams(app.brokerListModel.brokerProperties(connection_id))
			}
			function onConnectToBroker(connection_id) {
				console.log("connect to broker connection_id", connection_id)
				app.connectToBroker(connection_id)
			}
		}
		Component {
			id: errorPane
			TextViewPane {
				showError: true
				onBack: stackView.pop()
			}
		}
		Connections {
			target: app
			function onBrokerConnectedChanged(is_connected) {
				console.log("broker connected changed:", is_connected)
				if(is_connected) {
					app.callLs("");
				}
			}
			function onConnetToBrokerError(errmsg) {
				stackView.push(errorPane, {text: errmsg})
			}
			function onNodesLoaded(shv_path, nodelist) {
				let pane = stackView.push(shvPane, {shvPath: shv_path, nodes: nodelist})
			}
		}
	}
	AboutDialog {
		id: aboutDialog
	}
	Component.onCompleted: {
		app.methodCallInProcess.connect((rq_id, is_running) => busyIndicator.running = is_running)
	}
}
