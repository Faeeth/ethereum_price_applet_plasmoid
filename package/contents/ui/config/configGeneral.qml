import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

import ".."
import "../../code/eth.js" as Eth

Item {
	id: configGeneral
	Layout.fillWidth: true
	property string cfg_onClickAction: plasmoid.configuration.onClickAction
	property alias cfg_refreshRate: refreshRate.value
	property alias cfg_showIcon: showIcon.checked
	property alias cfg_showText: showText.checked
	property alias cfg_showDecimals: showDecimals.checked

	GridLayout {
		columns: 2
		
		Label {
			text: i18n("Actualisation :")
		}
		
		SpinBox {
			id: refreshRate
			suffix: i18n(" minutes")
			minimumValue: 1
		}
		
		Label {
			text: ""
		}
		
		CheckBox {
			id: showIcon
			text: i18n("Afficher l'icône")
			onClicked: {
				if(!this.checked) {
					showText.checked = true
					showText.enabled = false
				} else {
					showText.enabled = true
				}
			}
		}
		
		Label {
			text: ""
		}
		
		CheckBox {
			id: showText
			text: i18n("Afficher le texte (Si désactivé, la valeur est toujours visible au survol)")
			onClicked: {
				if(!this.checked) {
					showIcon.checked = true
					showIcon.enabled = false
				} else {
					showIcon.enabled = true
				}
			}
		}
		
		Label {
			text: ""
		}
		
		CheckBox {
			id: showDecimals
			text: i18n("Afficher les décimales")
		}
		
		Label {
			text: ""
		}
	}
}
