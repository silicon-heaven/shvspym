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
	StackView {
		id: stackView

		//property var rootItem: null

		anchors.fill: parent
		//anchors.leftMargin: !window.portraitMode ? drawer.width : undefined

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
			id: nodesPane
			NodesPane {
				onBack: stackView.pop()
				onGotoRoot: {
					while(stackView.depth > 2) {
						stackView.pop()
					}
				}
			}
		}
		Component {
			id: methodsPane
			MethodsPane {
				onBack: stackView.pop()
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
				//let pane = stackView.push(brokerProperties)
				//pane.loadParams(app.brokerListModel.brokerProperties(connection_id))
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
			function onNodesLoaded(shv_path, nodelist) {
				let pane = stackView.push(nodesPane, {shvPath: shv_path, nodes: nodelist})
			}
			function onMethodsLoaded(shv_path, methods) {
				let pane = stackView.push(methodsPane, {shvPath: shv_path, methods: methods})
			}
		}
	}
}
