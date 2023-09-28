import QtQuick
import QtQuick.Controls

Rectangle {
	id: rectangle
	height: 50
	width: 200

	required property int index
	required property var model
	required property string name

	Text {
		id: text1
		text: parent.name? parent.name: "Connection name"
		anchors.left: parent.left;
		anchors.right: button.left;
		anchors.top: parent.top;
		anchors.bottom: parent.bottom;
		verticalAlignment: Text.AlignVCenter
		font.pointSize: 17
		anchors.leftMargin: 5
	}
	Connections {
		target: playButton
		function onClicked() {
			text1.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
		}
	}
	/*
	Button {
		id: button
		width:height
		text: "⏵"
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		flat: false
		highlighted: true
		display: AbstractButton.TextOnly
	}
	*/
	Rectangle {
		id: playButton
		signal clicked()
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
				playButton.clicked()
			}
		}
	}

}
