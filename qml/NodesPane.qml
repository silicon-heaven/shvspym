import QtQuick
import QtQuick.Controls

Pane {
	id: pane

	required property string shvPath
	required property var nodes

	signal back()

	Rectangle {
		id: header

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: cancelBt.height
		color: "#cbe6b3"

		Button {
			id: cancelBt
			text: qsTr("<")
			anchors.left: parent.left
			display: AbstractButton.TextOnly
			width: height
			onClicked: pane.back()
		}
		Label {
			text: shvPath
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			horizontalAlignment: Text.AlignHCenter
			font.bold: true
			anchors.left: cancelBt.right
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
		for(let nd of nodes) {
			//console.log(nd);
			listModel.append({nodeName: nd, shvPath: pane.shvPath});
		}
	}
	Connections {
		target: app
	}
}
