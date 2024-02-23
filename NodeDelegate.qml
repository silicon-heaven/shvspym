import QtQuick
import QtQuick.Controls

Rectangle {
	id: root
	height: nodeName.height * 1.5
	color: index % 2? Style.delegateColor: Style.delegateAltColor
	//radius: 5
	//border.color: "#69ac77"
	border.width: 0
	width: 300

	required property string nodeName
	required property string shvPath
	required property int index
	Keys.onReleased: {
		if(event.key === Qt.Key_Back || kevent.key === Qt.Key_Escape) {
			console.log("BACK4")
			nodesStack.pop()
		}
	}

	Text {
		id: nodeName
		text: root.nodeName? root.nodeName: "node name"
		elide: Text.ElideLeft
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.right: lightning.left
		//font.pointSize: 15
		anchors.leftMargin: 5
		TapHandler {
			onTapped: {
				let shv_path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
				app.callLs(shv_path)
			}
		}
	}
	Rectangle {
		id: lightning
		height: root.height
		width: height * 1.5
		anchors.right: parent.right
		//anchors.rightMargin: 10

		property bool isActive: false

		Image {
			id: image
			anchors.fill: parent
			source: lightning.isActive? "images/subscription-active.svg": "images/subscription.svg"
			anchors.bottomMargin: 3
			anchors.topMargin: 3
			anchors.leftMargin: 3
			anchors.rightMargin: 3
			fillMode: Image.PreserveAspectFit
			Connections {
				target: app.subscriptionModel
				function onSignalSubscribedChanged(shv_path, method, is_subscribed) {
					let path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
					if(shv_path === path) {
						lightning.isActive = is_subscribed
					}
				}
			}
		}
		TapHandler {
			onTapped: {
				let path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
				app.subscriptionModel.subscribeSignal(path, "chng", !lightning.isActive)
			}
		}
	}
}
