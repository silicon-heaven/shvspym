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

			Label {
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

			Label {
				text: qsTr("User")
			}
			TextField {
				id: userFld
				anchors.left: parent.left
				anchors.right: parent.right
				placeholderText: qsTr("User")
			}

			Label {
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
				/*
				Text {
					id: ocko
					property bool checked: false
					text: "👁"
					font.pointSize: 20
					height: passwordFld.height
					MouseArea {
						anchors.fill: parent

					}
				}
				*/
				Button {
					id: button
					//height: passwordFld.height
					text: "👁"
					font.pointSize: 15
					flat: true
					checkable: true
				}
			}

		}
	}

}
