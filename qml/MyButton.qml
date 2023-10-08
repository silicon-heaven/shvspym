// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick

Rectangle {
	id: root

	property int iconMargin: 2

	color: app.settings.buttonColor
	width: 44
	height: 44

	border.color: app.settings.buttonBorderColor
	border.width: 1
	radius: Math.max(height / 10, 1)

	property alias iconSource: icon.source

	signal tapped()

	Image {
		id: icon
		anchors.fill: parent
		source: "../3rdparty/libshv/libshvvisu/images/close.svg"
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.leftMargin: root.iconMargin
		anchors.rightMargin: root.iconMargin
		anchors.topMargin: root.iconMargin
		anchors.bottomMargin: root.iconMargin

	}

	TapHandler {
		id: tapHandler

		gesturePolicy: TapHandler.WithinBounds
		onTapped: root.tapped()
	}
}
