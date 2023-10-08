import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
	id: pane

	property string headerText
	property string text
	property bool showError: false

	signal back()
	padding: 0

	Rectangle {
		id: header

		height: 50
		color: pane.showError? "red": app.settings.headerColor
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
				iconSource: "../images/back.svg"
				color: header.color
				onTapped: pane.back()
			}
			Text {
				Layout.fillWidth: true
				color: app.settings.headerTextColor
				text: pane.showError? qsTr("Error"): pane.headerText
				font.bold: true
			}
			Button {
				text: qsTr("Copy")
				onClicked: {
					textEdit.selectAll()
					textEdit.copy()
					textEdit.deselect()
				}
			}
		}
	}

	TextEdit {
		id: textEdit
		text: pane.text
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: header.bottom
		anchors.bottom: parent.bottom
		font.pixelSize: app.settings.fontSize
		wrapMode: Text.WordWrap
		readOnly: true
		textFormat: Text.PlainText
	}
}
