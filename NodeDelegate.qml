import QtQuick
import QtQuick.Controls

Rectangle {
	id: root
	height: Style.lineHeight * 2
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
		font.pointSize: 15
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
		width: root.height
		height: root.height
		anchors.right: parent.right

		property bool isActive: false

		Image {
			id: image
			anchors.fill: parent
			source: lightning.isActive? "images/subscription-active.svg": "images/subscription.svg"
			anchors.bottomMargin: 5
			anchors.topMargin: 5
			anchors.leftMargin: 5
			anchors.rightMargin: 5
			fillMode: Image.PreserveAspectFit
			Component.onCompleted: {
				app.subscriptionModel.signalSubscribedChanged.connect((shv_path, method, is_subscribed) => {
							  let path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
							  if(shv_path === path) {
								  lightning.isActive = is_subscribed
							  }
						  })
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
