import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.1

Window {
    id: root
    visible: true
    width: 600
    height: 600

    Rectangle {
        Text {
            x: 220; y: 10
            font.family: "Helvetica"
            font.pointSize: 24
            color: "red"
            text: "Moves: "
        }

        Text {
            id: numberOfMoves
            x: 350; y: 10
            font.family: "Helvetica"
            font.pointSize: 24
            color: "red"
            text: "0"
        }
    }

    Component {
        id: rectangleDelegate
        Rectangle {
            width: grid.cellWidth
            height: grid.cellHeight
            radius: width
            border.color: "black"
            border.width: 1
            Text {
                font.pointSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: name
            }
            visible: (name == "0") ? false : true
        }
    }

    GridView {
        id: grid
        x: 60; y: 60
        width: 480; height: 480
        cellWidth: 120; cellHeight: 120
        model: rectangleModel
        delegate: rectangleDelegate
        move: Transition {
            NumberAnimation { easing.type: Easing.InOutCirc; properties: "x,y"; duration: 300 }
        }

        property int playerWin: 0
        property int zeroItem: 15
        property int leftItem
        property int rightItem
        property int upItem
        property int downItem

        function swapItems1(from) {
            grid.zeroItem = grid.currentIndex
            var tmp = from - 1
            rectangleModel.move(grid.currentIndex, from, 1)
            rectangleModel.move(tmp, grid.zeroItem, 1)
            numberOfMoves.text = parseInt(numberOfMoves.text) + 1
        }

        function swapItems2(from) {
            grid.zeroItem = grid.currentIndex
            var tmp = from + 1
            rectangleModel.move(grid.currentIndex, from, 1)
            rectangleModel.move(tmp, grid.zeroItem, 1)
            numberOfMoves.text = parseInt(numberOfMoves.text) + 1
        }

        function shuffle(array) {
            var currentIndex = array.length, temporaryValue, randomIndex;

            while (0 !== currentIndex) {
              // Pick a remaining element
              randomIndex = Math.floor(Math.random() * currentIndex);
              currentIndex -= 1;

              // And swap it with the current element.
              temporaryValue = array[currentIndex];
              array[currentIndex] = array[randomIndex];
              array[randomIndex] = temporaryValue;
            }
        }

        function restartModel() {
            rectangleModel.clear()
            var array = ["0", "1", "2", "3", "4", "5", "6", "7", "8",
                         "9", "10", "11", "12", "13", "14", "15"]
            grid.shuffle(array)
            for (var i = 0; i < 16; i++) {
                if (array[i] === "0") {
                    grid.zeroItem = i
                }

                rectangleModel.append({name: array[i]})
            }
        }

        function checkWon() {
            grid.playerWin = 1
            for (var i = 0; i<15; i++) {
                if (rectangleModel.get(i).name !== (i + 1).toString()) {
                    grid.playerWin = 0
                    break
                }
            }
            return grid.playerWin
        }

        MessageDialog {
            id: messageWon
            title: "You win!"
            text: "Congradulations, you won the game"
            onAccepted: {
                console.log("You win!")
                messageWon.close()
            }
            visible: false
        }

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            onPressed: {
                grid.currentIndex = grid.indexAt(mouseX, mouseY)
                grid.leftItem = grid.indexAt(mouseX - grid.cellWidth, mouseY)
                grid.rightItem = grid.indexAt(mouseX + grid.cellWidth, mouseY)
                grid.upItem = grid.indexAt(mouseX, mouseY - grid.cellHeight)
                grid.downItem = grid.indexAt(mouseX, mouseY + grid.cellHeight)
                if (grid.leftItem == grid.zeroItem){
                    grid.swapItems2(grid.leftItem)
                } else if (grid.rightItem == grid.zeroItem) {
                    grid.swapItems1(grid.rightItem)
                } else if (grid.upItem == grid.zeroItem) {
                    grid.swapItems2(grid.upItem)
                } else if (grid.downItem == grid.zeroItem) {
                    grid.swapItems1(grid.downItem)
                }

                if (grid.checkWon() === 1) {
                    messageWon.visible = true
                }
            }
        }
    }

    Rectangle {
        Button {
            id: newGameButton
            x: 120; y: 550
            width: 100; height: 40
            text: "New Game"
            onClicked: {
                grid.restartModel()
                numberOfMoves.text = "0"
                grid.playerWin = 0
            }
        }

        Button {
            id: exitGameButton
            x: 320; y: 550
            width: 100; height: 40
            text: "Exit"
            onClicked: root.close()
        }
    }

    ListModel {
        id: rectangleModel
        ListElement {
            name: "1"
        }
        ListElement {
            name: "2"
        }
        ListElement {
            name: "3"
        }
        ListElement {
            name: "4"
        }
        ListElement {
            name: "5"
        }
        ListElement {
            name: "6"
        }
        ListElement {
            name: "7"
        }
        ListElement {
            name: "8"
        }
        ListElement {
            name: "9"
        }
        ListElement {
            name: "10"
        }
        ListElement {
            name: "11"
        }
        ListElement {
            name: "12"
        }
        ListElement {
            name: "13"
        }
        ListElement {
            name: "14"
        }
        ListElement {
            name: "15"
        }
        ListElement {
            name: "0"
        }
    }
}

