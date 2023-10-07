import QtQuick
import QtQuick.Controls

Pane {
	id: pane

	required property string shvPath
	required property var nodes

	signal back()
	signal gotoRoot()

	Rectangle {
		id: header

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: cancelBt.height
		color: "#b3e4e6"

		Button {
			id: cancelBt
			text: qsTr("<")
			anchors.left: parent.left
			icon.source: "../images/back.svg"
			display: AbstractButton.IconOnly
			width: height
			onClicked: pane.back()
		}
		Button {
			id: rootBt
			text: qsTr("/")
			anchors.left: cancelBt.right
			icon.source: "../images/goto-root.svg"
			display: AbstractButton.IconOnly
			width: height
			onClicked: pane.gotoRoot()
		}
		Label {
			text: shvPath
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: rootBt.right
			horizontalAlignment: Text.AlignHCenter
			font.bold: true
			anchors.right: parent.right
		}
	}

	ListView {
		id: nodeListView
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: header.bottom
		anchors.bottom: parent.bottom

		model: ListModel {
			id: listModel
		}

		focus: true

		delegate: NodeListDelegate {
			width: nodeListView.width;
			//name: nodeName
			//onEditBrokerRequest: (connection_id) => pane.editBroker(connection_id)
			//onConnectToBrokerRequest: (connection_id) => pane.connectToBroker(connection_id)
		}
		ScrollIndicator.vertical: ScrollIndicator { }
	}
	Component.onCompleted: {
		for(let nd of pane.nodes) {
			//console.log(nd);
			listModel.append({nodeName: nd, shvPath: pane.shvPath});
		}
	}
	Connections {
		target: app
	}
}
