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
		delegate: BrokerListDelegate {
			width: brokerListView.width;
			onEditBrokerRequest: (connection_id) => pane.editBroker(connection_id)
			onConnectToBrokerRequest: (connection_id) => pane.connectToBroker(connection_id)
		}
		/*
				delegate: ItemDelegate {
					//id: delegateItem
					width: ListView.view.width
					text: name
					highlighted: ListView.isCurrentItem

					required property int index
					required property var model
					required property string name

					onClicked: {
						brokerListView.currentIndex = index
						//stackView.push(source)
						//if (window.portraitMode)
						//	drawer.close()
					}
				}
				*/
		ScrollIndicator.vertical: ScrollIndicator { }
	}
	Rectangle {
		id: addBrokerButton
		width: height
		height: 50
		color: "#cf9d15"
		radius: height/2
		border.width: 0

		anchors.right: parent.right
		anchors.bottom: parent.bottom

		Text {
			color: "white"
			text: "+"
			anchors.fill: parent
			font.pixelSize: 50
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}

		MouseArea {
			id: mouseArea
			anchors.fill: parent
			onClicked: {
				//console.log("add broker 1")
				pane.addBroker()
			}
		}
	}
}
