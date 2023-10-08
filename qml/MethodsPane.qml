import QtQuick
import QtQuick.Controls

Pane {
	id: pane

	required property StackView stackView
	required property string shvPath
	required property var methods

	signal back()
	padding: 0

	Rectangle {
		id: header

		height: 54
		color: "#278f00"
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		Row {
			anchors.left: parent.left
			anchors.right: parent.right
			spacing: 5
			MyButton {
				id: cancelBt
				width: header.height
				height: width
				iconMargin: 15
				iconSource: "../images/back.svg"
				onTapped: pane.back()
			}
			Text {
				color: app.settings.headerTextColor
				text: pane.shvPath? pane.shvPath: "shv path"
				anchors.verticalCenter: parent.verticalCenter
				font.bold: true
			}
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
			stackView: pane.stackView
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
