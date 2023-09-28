import QtQuick

Rectangle {
	id: brokerRectangle
	height: 50
	width: 200

	signal connectToBrokerRequest(index: int)

	required property int index
	required property var model
	required property string name
	required property string connectionId

	Text {
		id: text1
		text: brokerRectangle.name? brokerRectangle.name: "Connection name"
		anchors.left: parent.left;
		anchors.right: playButton.left;
		anchors.top: parent.top;
		anchors.bottom: parent.bottom;
		verticalAlignment: Text.AlignVCenter
		font.pointSize: 17
		anchors.leftMargin: 5
	}
	Connections {
		target: brokerRectangle
		function onConnectToBrokerRequest(index) {
			//text1.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
			console.log("index:", index)
		}
	}

	Rectangle {
		id: playButton
		x: 395
		y: 0
		width: height
		height: 200
		color: mouseArea.isDown? border.color: "#c0f2bc"
		radius:5

		border.color: "#5d8f5c"
		border.width: 1
		anchors.right: parent.right
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
			//onClicked: {
			//	console.log("parent.index is ", parent.index);
			//}
			onPressed: isDown = true;
			onReleased: {
				isDown = false;
				brokerRectangle.connectToBrokerRequest(brokerRectangle.index)
				console.log(brokerRectangle.ListView.view.currentIndex, brokerRectangle.index, brokerRectangle.connectionId)
			}
		}
	}

}
