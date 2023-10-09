import QtQuick
import QtQuick.Controls

Rectangle {
	id: root
	height: button.height
	color: index % 2? app.settings.delegateAltColor: app.settings.delegateColor
	//radius: 5
	//border.color: "#69ac77"
	border.width: 0
	width: 300

	required property string nodeName
	required property string shvPath
	required property int index

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
	MyButton {
		id: button
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: 4
		//iconMargin: 10
		iconSource: "../images/methods.svg"
		//color: "transparent"
		onTapped: {
			let shv_path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
			app.callDir(shv_path)
		}
	}
}
