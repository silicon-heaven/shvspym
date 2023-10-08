import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
	id: root
	height: nodeName.height + fldResult.height + 5;

	color: backgroundColor()

	required property string index
	required property string name
	required property string shvPath
	required property int flags
	property bool isGetter: flags & 2

	property int requestId: 0

	function backgroundColor() {
		return root.index % 2? app.settings.delegateAltColor: app.settings.delegateColor

	}

	RowLayout {
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin: 6
		Layout.fillWidth: true
		Column {
			id: column
			Layout.fillWidth: true
			RowLayout {
				anchors.left: parent.left
				anchors.right: parent.right
				Text {
					id: nodeName
					Layout.fillWidth: true
					text: root.name? root.name: "method name"
					font.pointSize: app.settings.fontSize
					font.bold: true
				}
				Text {
					id: fldFlags
					font.pointSize: app.settings.fontSize
					text: root.isGetter? "G": ""
				}
			}
			Text {
				id: fldResult
				font.pixelSize: nodeName.font.pixelSize
				font.pointSize: app.settings.fontSize
			}
		}
		Button {
			id: buttonCall
			text: qsTr("Call")
			onClicked: {
				//let shv_path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
				root.requestId = app.callMethod(root.shvPath, root.name)
			}
		}
	}

	Component.onCompleted: {
		console.log("method", root.shvPath, root.name, root.flags, "G:", root.isGetter)
		if(root.isGetter) {
			// auto call getter
			root.requestId = app.callMethod(root.shvPath, root.name)
		}
	}

	Connections {
		target: app
		function onMethodCallResult(rq_id, result, is_error) {
			if(rq_id === root.requestId) {
				console.log(rq_id, JSON.stringify(result), is_error);
				fldResult.text = result;
				root.color = is_error? "darksalmon": root.backgroundColor()
			}
		}
	}

}
