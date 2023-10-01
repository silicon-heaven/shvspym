import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
	id: form
	//property StackView stackView
	signal addBroker(broker_properties: var)
	signal cancelled()
	Rectangle {
		id: header
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: okBt.height
		color: "#cbe6b3"
		Button {
			id: cancelBt
			text: qsTr("<")
			anchors.left: parent.left
			display: AbstractButton.TextOnly
			width: height
			onClicked: form.cancelled()
		}
		Label {
			text: qsTr("Broker properties")
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: okBt.left
			horizontalAlignment: Text.AlignHCenter
			font.bold: true
			anchors.left: cancelBt.right
		}
		Button {
			id: okBt
			width: height * 2
			text: qsTr("Ok")
			anchors.right: parent.right
			onClicked: {
				let props = {
					name: nameFld.text,
					connectionString: schemeFld.text + "://" + hostFld.text
				};
				form.addBroker(props)
			}
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
			id: nameFld
			anchors.left: parent.left
			anchors.right: parent.right
			placeholderText: qsTr("Broker name")
		}

		Label {
			id: schemeFld
			text: qsTr("Scheme")
		}
		ComboBox {
			id: comboBox
			model: ["tcp", "ssl", "ws", "wss", "SerialPort"]
		}

		Label {
			text: qsTr("Host")
		}
		TextField {
			id: hostFld
			anchors.left: parent.left
			anchors.right: parent.right
			placeholderText: qsTr("Host")
		}
	}
}
