import QtQuick
import QtQuick.Controls

Rectangle {
	id: root
	height: nodeName.contentHeight + fldResult.contentHeight + 5;

	color: defaultBackground
	radius: 5
	border.color: "#69ac77"
	width: 300

	required property string name
	required property string shvPath
	required property int flags
	property bool isGetter: flags & 2

	property string defaultBackground: "#d5f3c0"
	property int requestId: 0

	Text {
		id: nodeName
		x: 8
		text: root.name? root.name: "method name"
		anchors.top: parent.top
		anchors.topMargin: 4
		font.pointSize: 15
		font.bold: true
	}
	Text {
		id: fldResult
		//height: contentHeight
		anchors.left: parent.left
		anchors.right: buttonCall.left
		anchors.top: nodeName.bottom
		font.pixelSize: nodeName.font.pixelSize
		wrapMode: Text.WrapAnywhere
		//fontSizeMode: Text.VerticalFit
		anchors.leftMargin: 8
	}

	Button {
		id: buttonCall
		text: qsTr("Call")
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		onClicked: {
			//let shv_path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
			root.requestId = app.callMethod(root.shvPath, root.name)
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
				root.color = is_error? "darksalmon": root.defaultBackground
			}
		}
	}

	Text {
		id: fldFlags
		text: root.isGetter? "G": ""
		anchors.right: buttonCall.left
		anchors.top: parent.top
		font.pixelSize: 12
		anchors.rightMargin: 6
		anchors.topMargin: 5
	}

}
