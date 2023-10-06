import QtQuick

Rectangle {
	id: brokerRectangle
	height: 50
	width: 300

	signal connectToBrokerRequest(connection_id: int)
	signal editBrokerRequest(connection_id: int)

	required property int index
	required property var model
	required property string name
	required property string connectionId
	required property string connectionString

	Rectangle {
		id: playButton
		width: height
		color: mouseArea.isDown? border.color: "#c0f2bc"
		radius:5

		border.color: "#5d8f5c"
		border.width: 1
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom

		Text {
			x: 0
			y: 0
			color: "white"
			text: "⏻ "
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			font.pixelSize: 30
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			anchors.leftMargin: 8
			anchors.topMargin: 8
		}

		MouseArea {
			id: mouseArea
			property bool isDown: false
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			onPressed: isDown = true;
			onReleased: {
				isDown = false;
				brokerRectangle.connectToBrokerRequest(brokerRectangle.connectionId)
			}
		}
	}

	Text {
		id: name
		height: 27
		text: brokerRectangle.name? brokerRectangle.name: "Connection name"
		anchors.left: playButton.right
		anchors.right: parent.right
		anchors.top: parent.top
		//verticalAlignment: Text.AlignVCenter
		font.pointSize: 15
		font.bold: true
		anchors.leftMargin: 11
	}

	Rectangle {
		id: editButton
		width: height
		border.width: 0

		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		color: mouseArea2.isDown? "#c0f2bc": "#00000000"
		Text {
			color: "#5d5b5b"
			text: "🖉"
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			font.pixelSize: 30
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}

		MouseArea {
			id: mouseArea2
			property bool isDown: false
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			onPressed: isDown = true;
			onReleased: {
				isDown = false;
				//console.log("edit", brokerRectangle.connectionId)
				brokerRectangle.editBrokerRequest(brokerRectangle.connectionId)
			}
		}
	}

	Text {
		id: connectionString
		text: brokerRectangle.connectionString? brokerRectangle.connectionString: "Connection string"
		anchors.left: playButton.right
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.top: name.bottom
		verticalAlignment: Text.AlignVCenter
		anchors.leftMargin: name.anchors.leftMargin
	}

}
