import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
	id: root
	height: nodeName.height + fldResult.height + 5;

	color: backgroundColor()

	required property StackView stackView
	required property string index
	required property string name
	required property string shvPath
	property var params: null
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
		spacing: 0
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
					font.pixelSize: app.settings.fontSize
					font.bold: true
				}
				Text {
					id: fldFlags
					font.pixelSize: app.settings.fontSize
					text: root.isGetter? "G": ""
				}
			}
			Text {
				id: fldResult
				property bool isError: false
				font.pixelSize: app.settings.fontSize
			}
			Component {
				id: resultPane
				TextViewPane {
					onBack: stackView.pop()
				}
			}
			TapHandler {
				onTapped: {
					console.log("result:" , fldResult.text)
					stackView.push(resultPane, {text: fldResult.text, headerText: qsTr("RPC Result"), showError: fldResult.isError});
				}
			}
		}
		MyButton {
			id: buttonParams
			width: buttonCall.height
			height: width
			color: root.color
			border.width: 0
			//iconMargin: 15
			iconSource: root.params? "../images/params-some.svg": "../images/params.svg"
			onTapped: {
				let cpon = app.variantToCpon(root.params);
				let pane = stackView.push(resultPane, {text: cpon, headerText: qsTr("Method parameters"), checkCpon: true, readOnly: false});
				pane.textCommited.connect((text) => { root.params = app.cponToVariant(text) })
			}
		}
		MyButton {
			id: buttonCall
			color: app.settings.buttonColor
			width: root.height - 6
			height: width
			iconMargin: 10
			iconSource: "../images/play.svg"
			onTapped: {
				//let shv_path = root.shvPath? root.shvPath + '/' + root.nodeName: root.nodeName
				root.requestId = app.callMethod(root.shvPath, root.name, root.params)
			}
		}
		Rectangle {
			width: 5
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
				fldResult.isError = is_error
				fldResult.text = result;
				root.color = is_error? "darksalmon": root.backgroundColor()
			}
		}
	}

}
