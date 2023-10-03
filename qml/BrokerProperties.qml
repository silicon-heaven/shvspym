import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
	id: form
	property int connectionId
	//property StackView stackView
	signal updateBroker(connection_id: int, broker_properties: var)
	signal cancelled()

	function createParams() {
		let props = {
			connectionId = form.connectionId,
			name: nameFld.text,
			scheme: schemeFld.currentText,
			host: hostFld.text,
		};
		return props;
	}
	function loadParams(props) {
		form.connectionId = props.connectionId;
		nameFld.text = props.name;
		schemeFld.currentIndex = schemeFld.find(props.scheme);
		hostFld.text = props.host;
	}

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
				let props = form.createParams();
				form.updateBroker(form.connectionId, props)
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
			text: qsTr("Scheme")
		}
		ComboBox {
			id: schemeFld
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
