import QtQuick
import QtQuick.Controls

Pane {
	id: pane

	signal addBroker()
	signal editBroker(connection_id: int);
	signal connectToBroker(connection_id: int);

	ListView {
		id: brokerListView

		focus: true
		anchors.fill: parent

		model: app.brokerListModel
		delegate: BrokerDelegate {
			width: brokerListView.width;
			onEditBrokerRequest: (connection_id) => pane.editBroker(connection_id)
			onConnectToBrokerRequest: (connection_id) => pane.connectToBroker(connection_id)
		}
		ScrollIndicator.vertical: ScrollIndicator { }
	}
	MyButton {
		id: addBrokerButton
		width: height
		height: 50
		color: "#cf9d15"
		radius: height/2
		border.width: 0

		anchors.right: parent.right
		anchors.bottom: parent.bottom
		iconMargin: 7
		iconSource: "../images/plus.svg"

		onTapped: {
			pane.addBroker()
		}
	}
}
