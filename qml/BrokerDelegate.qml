import QtQuick
import QtQuick.Layouts

Rectangle {
	id: root
	height: 50
	color: app.settings.delegateColor

	signal connectToBrokerRequest(connection_id: int)
	signal editBrokerRequest(connection_id: int)

	required property int index
	required property var model
	required property string name
	required property string connectionId
	required property string connectionString

	RowLayout {
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.right: parent.right
		MyButton {
			id: playButton
			width: height
			radius:5
			iconSource: "../images/connect.svg"
			iconMargin: 5
			onTapped: {
				root.connectToBrokerRequest(root.connectionId)
			}
		}
		Column {
			Layout.fillWidth: true
			Text {
				id: name
				height: 27
				text: root.name? root.name: "Connection name"
				//verticalAlignment: Text.AlignVCenter
				font.pointSize: app.settings.fontSize
				font.bold: true
			}
			Text {
				id: connectionString
				text: root.connectionString? root.connectionString: "Connection string"
				font.pointSize: app.settings.fontSize
			}
		}
		MyButton {
			id: editButton
			width: height
			border.width: 0
			color: app.settings.delegateColor
			iconSource: "../images/pencil.svg"
			onTapped: {
				root.editBrokerRequest(root.connectionId)
			}
		}
	}

}
