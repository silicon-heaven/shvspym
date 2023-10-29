import QtQuick
import QtQuick.Controls

Rectangle {
	id: root
	height: app.settings.fontSize * 3
	color: index % 2? app.settings.delegateColor: app.settings.delegateAltColor
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
		anchors.leftMargin: 5
		TapHandler {
			onTapped: {
				let shv_path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
				app.callLs(shv_path)
			}
			onLongPressed: {
				contextMenu.popup()
			}
		}
	}
	/*
	Menu {
		id: contextMenu
		MenuItem {
			text: "Subscribe"
			onTriggered: {
				let path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
				app.subscribeSignal(path)
			}
		}
	}
	*/
	MyButton {
		id: button
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		//iconMargin: 10
		border.width: 0
		iconSource: "../images/subscription.svg"
		color: "transparent"
		onTapped: {
			let path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
			app.subscribeSignal(path, "chng", true)
		}
	}
}
