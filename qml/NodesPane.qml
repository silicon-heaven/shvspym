import QtQuick
import QtQuick.Controls

Pane {
	id: pane

	required property string shvPath
	required property var nodes

	signal back()
	signal gotoRoot()
	padding: 0

	Rectangle {
		id: header

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: cancelBt.height
		color: app.settings.headerColor

		Row {
			anchors.left: parent.left
			anchors.right: parent.right
			spacing: 5
			MyButton {
				id: cancelBt
				color: "transparent"
				iconMargin: 10
				iconSource: "../images/back.svg"
				width: header.height
				onTapped: pane.back()
			}
			MyButton {
				id: rootBt
				color: cancelBt.color
				border.color: cancelBt.border.color
				iconMargin: 10
				iconSource: "../images/goto-root.svg"
				width: header.height
				onTapped: pane.gotoRoot()
			}
			Text {
				color: app.settings.headerTextColor
				text: pane.shvPath? pane.shvPath: "shv path"
				anchors.verticalCenter: parent.verticalCenter
				horizontalAlignment: Text.AlignHCenter
				style: Text.Normal
				font.bold: true
			}
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

		delegate: NodeDelegate {
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
