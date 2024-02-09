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
			port: portFld.value,
			user: userFld.text,
			password: passwordFld.text,
		};
		return props;
	}
	function loadParams(props) {
		form.connectionId = props.connectionId;
		nameFld.text = props.name;
		schemeFld.currentIndex = schemeFld.find(props.scheme);
		hostFld.text = props.host;
		portFld.value = props.port;
		userFld.text = props.user;
		passwordFld.text = props.password;
	}

	Rectangle {
		id: header

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: okBt.height
		color: Style.headerColor

		RowLayout {
			anchors.left: parent.left
			anchors.right: parent.right
			MyButton {
				id: cancelBt
				width: height
				iconSource: "images/back.svg"
				iconMargin: 10
				onTapped: form.cancelled()
			}
			Text {
				Layout.fillWidth: true
				text: qsTr("Broker properties")
				horizontalAlignment: Text.AlignHCenter
				font.bold: true
				//font.pixelSize: Style.fontPixelSize
				color: Style.backgroundColor
			}
			MyButton {
				id: okBt
				width: height
				iconSource: "images/ok.svg"
				iconMargin: 10
				onTapped: {
					schemeFld.focus = true
					let props = form.createParams();
					form.updateBroker(form.connectionId, props)
				}
			}
		}

	}
	ScrollView {
		id: scrollView
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: header.bottom
		anchors.bottom: parent.bottom
		anchors.rightMargin: 10
		anchors.topMargin: anchors.rightMargin
		anchors.leftMargin: anchors.rightMargin
		contentWidth: scrollView.width
		contentHeight: column.height
		Column {
			id: column
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.rightMargin: 0
			spacing: 10

			component FldLabel : Text {
				color: Style.headerColor
			}

			FldLabel {
				id: label
				text: qsTr("Name")
			}
			TextField {
				id: nameFld
				anchors.left: parent.left
				anchors.right: parent.right
				placeholderText: qsTr("Broker name")
			}

			FldLabel {
				text: qsTr("Scheme")
			}
			ComboBox {
				id: schemeFld
				model: ["tcp", "ssl", "ws", "wss", "SerialPort"]
			}

			FldLabel {
				text: qsTr("Host")
			}
			TextField {
				id: hostFld
				anchors.left: parent.left
				anchors.right: parent.right
				placeholderText: qsTr("Host")
			}

			FldLabel {
				text: qsTr("Port")
			}
			SpinBox {
				id: portFld
				wheelEnabled: true
				value: 3755
				to: 65535
				from: 1024
				editable: true
			}

			FldLabel {
				text: qsTr("User")
			}
			TextField {
				id: userFld
				anchors.left: parent.left
				anchors.right: parent.right
				placeholderText: qsTr("User")
			}

			FldLabel {
				text: qsTr("Password")
			}
			RowLayout {
				id: row
				anchors.left: parent.left
				anchors.right: parent.right
				TextField {
					id: passwordFld
					Layout.fillWidth: true
					echoMode: button.checked? TextInput.Normal: TextInput.Password
					placeholderText: qsTr("Password")
				}
				MyButton {
					id: button
					property bool checked: false
					iconSource: "images/eye.svg"
					color: Style.backgroundColor
					border.width: 0
					onTapped: {
						checked = !checked
					}
				}
			}
		}
	}
}
