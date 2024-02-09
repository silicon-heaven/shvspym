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

	Settings {
		id: settings
		property string style
	}

	header: ToolBar {
		id: header
		height: 50
		Rectangle {
			color: Style.headerColor
			anchors.fill: parent
			RowLayout {
				anchors.fill: parent
				spacing: 20

				BusyIndicator {
					id: busyIndicator
					running: false
					height: header.height
					width: height
				}

				Label {
					Layout.fillWidth: true

					text: qsTr("ShvSpy")
					horizontalAlignment: Qt.AlignHCenter
					verticalAlignment: Qt.AlignVCenter
					//font.pixelSize: Style.fontPixelSize
					font.bold: true
				}

				ToolButton {
					id: settingsButton
					icon.source: "images/menu.svg"
					onClicked: {
						aboutDialog.open()
					}
					//palette.button: Constants.isDarkModeActive ? "#30D158" : "#34C759"
					//palette.highlight: Constants.isDarkModeActive ? "#30DB5B" : "#248A3D"
				}
			}
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
			id: sessionPage
			SessionPage {
				onBack: {
					stackView.pop()
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
					stackView.push(sessionPage)
				}
			}
			function onConnetToBrokerError(errmsg) {
				stackView.push(errorPane, {text: errmsg})
			}
		}
	}
	/*
	Rectangle {
		id: busyRect
		visible: false
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: 100
		BusyIndicator {
			id: busyIndicator2
			anchors.centerIn: parent
			running: busyRect.visible
			height: busyRect.height
			width: height
		}
	}
	*/
	AboutDialog {
		id: aboutDialog
	}
	Component.onCompleted: {
		app.methodCallInProcess.connect((is_running) => {
											busyIndicator.running = is_running
											//busyRect.visible = is_running
		})
		//console.log("Style:", Style)
		//console.log("Style.lineHeight:", Style.lineHeight)
	}
}
