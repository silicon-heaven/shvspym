import QtQuick
import QtQuick.Controls

Pane {
	id: pane

	signal addBroker()

	ListView {
		id: brokerListView

		focus: true
		anchors.fill: parent

		model: brokerListModel
		delegate: BrokerListDelegate {
			width: brokerListView.width;
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
		anchors.bottomMargin: 0
		anchors.rightMargin: 0

		Text {
			x: 0
			y: 0
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
				console.log("add broker 1")
				pane.addBroker()
			}
		}
	}
}
