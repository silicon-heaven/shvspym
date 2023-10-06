import QtQuick
import QtQuick.Controls

Pane {
	id: pane

	required property string shvPath
	required property var methods

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
		id: listView
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: header.bottom
		anchors.bottom: parent.bottom

		model: ListModel {
			id: listModel
		}

		focus: true

		delegate: MethodDelegate {
			width: listView.width;
			//onEditBrokerRequest: (connection_id) => pane.editBroker(connection_id)
			//onConnectToBrokerRequest: (connection_id) => pane.connectToBroker(connection_id)
		}
		ScrollIndicator.vertical: ScrollIndicator { }
	}
	Component.onCompleted: {
		for(let method of pane.methods) {
			method.shvPath = pane.shvPath;
			console.log("method description:", JSON.stringify(method));
			listModel.append(method);
		}

	}
}
