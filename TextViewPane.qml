import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
	id: root

	property string headerText
	property bool showError: false
	property bool checkCpon: false
	property alias text: textEdit.text
	property alias readOnly: textEdit.readOnly

	signal back()
	signal textCommited(text: string)
	padding: 0

	Rectangle {
		id: header

		height: 50
		color: root.showError? "red": Style.headerColor
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		RowLayout {
			anchors.left: parent.left
			anchors.right: parent.right
			spacing: 5
			MyButton {
				id: cancelBt
				width: header.height
				height: width
				iconMargin: 15
				iconSource: "images/back.svg"
				color: "transparent"
				onTapped: root.back()
			}
			Text {
				Layout.fillWidth: true
				color: Style.headerTextColor
				text: root.showError? qsTr("Error"): root.headerText
				font.bold: true
			}
			MyButton {
				width: header.height
				height: width
				iconSource: "images/copy.svg"
				color: "transparent"
				onTapped: {
					textEdit.selectAll()
					textEdit.copy()
					textEdit.deselect()
				}
			}
			MyButton {
				visible: !root.readOnly
				width: header.height
				height: width
				iconSource: "images/ok.svg"
				iconMargin: 10
				color: "transparent"
				onTapped: {
					textEdit.focus = false
					let text = textEdit.text
					if(root.checkCpon) {
						let errmsg = app.checkCpon(text)
						errRect.errorMsg = errmsg
						if(errmsg) {
							return;
						}
					}
					root.textCommited(text)
					root.back()
				}
			}
		}
	}
	Rectangle {
		id: errRect
		property string errorMsg
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: header.bottom
		anchors.bottom: parent.bottom
		visible: errorMsg && !textEdit.focus
		color: "salmon"
		Text {
			text: parent.errorMsg
			anchors.fill: parent
			verticalAlignment: Text.AlignVCenter
		}
	}

	TextEdit {
		id: textEdit
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: header.bottom
		anchors.bottom: parent.bottom
		font.pixelSize: Style.fontPixelSize
		wrapMode: Text.WordWrap
		readOnly: true
		textFormat: Text.PlainText
		/*
		onTextChanged: {
			// text changed does not contain current line
			console.log("text changed:", textEdit.text)
			if(root.checkCpon) {
				let errmsg = app.checkCpon(text)
				errRect.errorMsg = errmsg
			}
		}
		*/
	}
}
