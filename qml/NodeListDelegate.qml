import QtQuick
import QtQuick.Controls

Rectangle {
	id: root
	height: button.height
	color: "#d5f3c0"
	radius: 5
	border.color: "#69ac77"
	width: 300

	required property string nodeName
	required property string shvPath

	Text {
		id: nodeName
		text: root.nodeName? root.nodeName: "node name"
		elide: Text.ElideLeft
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.right: parent.right
		font.pointSize: 15
		font.bold: true
		anchors.leftMargin: 5
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		onClicked: {
			let shv_path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
			app.callLs(shv_path)
		}
	}
	Button {
		id: button
		text: qsTr("Methods")
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		onClicked: {
			let shv_path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
			app.callDir(shv_path)
		}
	}
}
