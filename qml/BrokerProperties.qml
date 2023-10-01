import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
	id: rectangle
	property StackView stackView
	Rectangle {
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: 25
		color: "#cbe6b3"
		id: header
		Label {
			text: qsTr("Broker properties")
			anchors.fill: parent
			anchors.leftMargin: 8
		}
	}
	Column {
		id: column
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: header.bottom
		anchors.bottom: parent.bottom
		anchors.topMargin: anchors.rightMargin
		anchors.rightMargin: 10
		anchors.leftMargin: anchors.rightMargin
		spacing: 10
		Label {
			id: label
			text: qsTr("Name")
		}

		TextField {
			id: textField
			anchors.left: parent.left
			anchors.right: parent.right
			placeholderText: qsTr("Broker name")
		}


		Label {
			id: label1
			text: qsTr("Scheme")
		}

		ComboBox {
			id: comboBox
			model: ["tcp", "ssl", "ws", "wss", "SerialPort"]
		}
		Button {
			text: "Save"
			onClicked: stackView.pop()
		}

	}
}
