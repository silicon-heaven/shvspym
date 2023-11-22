import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
	id: root

	signal back()

	Component {
		id: shvPane
		ShvPane {
			onBack: {
				nodesStack.pop()
				if(nodesStack.depth === 0) {
					root.back()
				}
			}
			onGoBack: (levels) => {
				for (let i = 0; i < levels; i++) {
					nodesStack.pop()
				}
			}
		}
	}
	StackLayout {
		id: tabStack
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: tabBar.top
		currentIndex: tabBar.currentIndex
		StackView {
			id: nodesStack
		}
		Item {
			id: item1
			TabBar {
				id: subscriptionsTabBar
				width: parent.width
				height: tabButtonNodes.height
				currentIndex: 0
				TabButton {
					text: qsTr("Subscribed")
				}

				TabButton {
					text: qsTr("Delivered")
				}
			}
			StackLayout {
				id: tabSubscriptionsStack
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.top: subscriptionsTabBar.bottom
				anchors.bottom: parent.bottom
				currentIndex: subscriptionsTabBar.currentIndex
				ListView {
					id: subscribedList
					model: app.subscriptionModel
					delegate: SubscriptionDelegate {
						width: subscribedList.width
					}
				}
				ListView {
					id: deliveredSignalsList
					model: ListModel {
						id: deliveredListModel
					}
					delegate: DeliveredSignalDelegate {
						width: deliveredSignalsList.width
					}
					Component.onCompleted: {
						app.signalArrived.connect(
							(shv_path, method, timestamp, value) => {
								console.log("signal arrived:", shv_path + ':' + method, "timestamp:", timestamp, "value:", value)
								deliveredListModel.insert(0, {"shvPath": shv_path, "method": method, "timestamp": timestamp, "value": value})
								//deliveredSignalsList.positionViewAtEnd()
							}
						)
					}
				}
			}
		}
	}
	Rectangle {
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: tabBar.top
		height: 1
		color: "gray"
	}
	TabBar {
		id: tabBar
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		height: tabButtonNodes.height

		currentIndex: 0
		TabButton {
			id: tabButtonNodes
			text: qsTr("Nodes")
			display: AbstractButton.IconOnly
			icon.source: "../images/nodes.svg"
		}

		TabButton {
			id: tabButtonSubscriptions
			text: qsTr("Subscriptions")
			icon.source: "../images/subscription.svg"
			display: AbstractButton.IconOnly
		}
	}

	Connections {
		target: app
		function onNodesLoaded(shv_path, nodelist) {
			nodesStack.push(shvPane, {shvPath: shv_path, nodes: nodelist})
		}
	}
	Component.onCompleted: {
		app.callLs("");
	}
}
