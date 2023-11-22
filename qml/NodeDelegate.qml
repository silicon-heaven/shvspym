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
			source: lightning.isActive? "../images/subscription-active.svg": "../images/subscription.svg"
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
